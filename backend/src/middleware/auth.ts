import type { Request, Response, NextFunction, RequestHandler } from 'express';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../db/firebase.js';
import { supabase } from '../db/supabase.js';
import { FEATURE_TIERS } from '../config/featureTiers.js';
import { sendWelcomeEmail } from '../services/emailService.js';

declare global {
  namespace Express {
    interface Request {
      user?: { uid: string; firebaseUid: string; email: string | null; tier: 'free' | 'paid' };
    }
  }
}

interface UserRow {
  id: string;
  subscription_status: string | null;
  access_expires_at: string | null;
  welcome_email_sent_at: string | null;
}

/**
 * Flip a lapsed user's Firebase claim to free and mark the row expired.
 *
 * Pure cleanup — never enforcement. `requireAuth` derives `free` from the stored expiry on
 * every request, so a failure here costs nothing: the row keeps its past `access_expires_at`
 * and its non-'expired' status, and the next request tries again. The claim is written first
 * so the row is only marked done once the claim it describes actually landed.
 */
async function reconcileExpiredUser(firebaseUid: string, userId: string): Promise<void> {
  try {
    await getAuth(getFirebaseAdmin()).setCustomUserClaims(firebaseUid, { tier: 'free' });
    const { error } = await supabase
      .from('users')
      .update({ subscription_status: 'expired' })
      .eq('id', userId);
    if (error) throw new Error(error.message);
  } catch (err) {
    console.error(`Failed to reconcile expired user ${userId}:`, err);
  }
}

/**
 * Induction email, once per account. The conditional update atomically "claims" the send:
 * under concurrent first-login requests (the frontend fires several API calls at once) only
 * the request whose update matches a NULL flag proceeds, so we never double-send. If the send
 * fails, the claim is rolled back so the next login retries instead of the account being
 * permanently marked "welcomed" with nothing ever delivered.
 */
async function sendWelcomeEmailIfNeeded(userId: string, email: string): Promise<void> {
  try {
    const { data: claimed, error } = await supabase
      .from('users')
      .update({ welcome_email_sent_at: new Date().toISOString() })
      .eq('id', userId)
      .is('welcome_email_sent_at', null)
      .select('id');
    // Without this check a database error looks exactly like "0 rows claimed", i.e. "already
    // welcomed" — the email would be dropped for good rather than retried on the next login.
    if (error) throw new Error(error.message);
    if (!claimed || claimed.length === 0) return;

    if (!(await sendWelcomeEmail(email))) {
      const { error: rollbackError } = await supabase
        .from('users')
        .update({ welcome_email_sent_at: null })
        .eq('id', userId);
      if (rollbackError) throw new Error(rollbackError.message);
    }
  } catch (err) {
    console.error(`Failed to send welcome email to user ${userId}:`, err);
  }
}

export async function requireAuth(req: Request, res: Response, next: NextFunction): Promise<void> {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Authentication required' });
    return;
  }
  const token = header.slice(7);
  try {
    const decoded = await getAuth(getFirebaseAdmin()).verifyIdToken(token);
    let tier: 'free' | 'paid' = decoded['tier'] === 'paid' ? 'paid' : 'free';

    // Atomic upsert — safe under concurrent first-logins.
    const { data, error } = await supabase
      .from('users')
      .upsert(
        { firebase_uid: decoded.uid, email: decoded.email ?? null },
        { onConflict: 'firebase_uid' },
      )
      .select('id, subscription_status, access_expires_at, welcome_email_sent_at')
      .single();

    if (error || !data) {
      res.status(500).json({ error: 'Failed to resolve user' });
      return;
    }

    const row = data as UserRow;

    // Fire-and-forget so it never delays the request.
    if (!row.welcome_email_sent_at && decoded.email) {
      void sendWelcomeEmailIfNeeded(row.id, decoded.email);
    }

    // Enforce PayNow expiry server-side. `access_expires_at` is deliberately *not* cleared
    // when it lapses: a past timestamp is self-describing, so this check re-derives `free`
    // on every request and the Firebase claim is only ever an optimisation. Clearing it here
    // — as this code used to — erased the one piece of state saying a downgrade was owed, so
    // a claim write that failed (silently, since supabase-js resolves rather than rejects)
    // left the user holding `tier: 'paid'` forever. See issue #53.
    if (tier === 'paid' && row.access_expires_at && new Date(row.access_expires_at) <= new Date()) {
      tier = 'free';
      if (row.subscription_status !== 'expired') void reconcileExpiredUser(decoded.uid, row.id);
    }

    req.user = { uid: row.id, firebaseUid: decoded.uid, email: decoded.email ?? null, tier };
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

export function gate(feature: string): RequestHandler[] {
  return [
    requireAuth as RequestHandler,
    (req: Request, res: Response, next: NextFunction) => {
      const required = FEATURE_TIERS[feature] ?? 'paid';
      if (required === 'paid' && req.user!.tier !== 'paid') {
        res.status(402).json({ error: 'Subscription required', feature });
        return;
      }
      next();
    },
  ];
}
