import type { Request, Response, NextFunction, RequestHandler } from 'express';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../db/firebase.js';
import { supabase } from '../db/supabase.js';
import { FEATURE_TIERS } from '../config/featureTiers.js';
import { sendWelcomeEmail } from '../services/emailService.js';

declare global {
  namespace Express {
    interface Request {
      user?: {
        uid: string;
        firebaseUid: string;
        email: string | null;
        tier: 'free' | 'paid';
        accessExpiresAt: string | null;
      };
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
 * The `users` row — never the Firebase claim — decides a request's tier.
 *
 * A claim rides inside an ID token that lives up to an hour, and `setCustomUserClaims` cannot
 * invalidate the tokens already issued. A cancellation written to Firebase alone therefore would
 * not bind until the token happened to refresh, handing the user another hour of paid quotas
 * (issue #54). The row is written synchronously by the Stripe webhook, so reading it here makes
 * every grant and every revocation take effect on the user's very next request. It costs nothing:
 * `requireAuth` already fetches this row to resolve the internal user id.
 *
 * `subscription_status` is exhaustive: 'active' from both grants, 'canceled'/'past_due'/'unpaid'
 * from `revokePaidTier`, 'expired' from `reconcileExpiredUser`, and null on a fresh row or after
 * `createPortalSession` clears a dead Stripe customer.
 */
function deriveTier(row: UserRow): 'free' | 'paid' {
  if (row.subscription_status !== 'active') return 'free';
  // A lapsed PayNow row can still say 'active' when the reconcile below kept failing to run —
  // the stored expiry is self-describing, so it stays authoritative on its own. See issue #53.
  if (row.access_expires_at && new Date(row.access_expires_at) <= new Date()) return 'free';
  return 'paid';
}

/**
 * Flip a lapsed user's Firebase claim to free and mark the row expired.
 *
 * Pure cleanup — never enforcement. `deriveTier` resolves `free` from the stored expiry on every
 * request, so a failure here costs nothing: the row keeps its past `access_expires_at` and its
 * non-'expired' status, and the next request tries again. The claim is written first so the row
 * is only marked done once the claim it describes actually landed — until then `deriveTier` is
 * still deriving `free` from the expiry, so nothing is riding on the ordering either way.
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

    const tier = deriveTier(row);

    // `access_expires_at` is deliberately *not* cleared when it lapses: a past timestamp is
    // self-describing, so `deriveTier` re-derives `free` from it on every request. Clearing it
    // here — as this code used to — erased the one piece of state saying a downgrade was owed,
    // so a claim write that failed (silently, since supabase-js resolves rather than rejects)
    // left the user holding `tier: 'paid'` forever. See issue #53.
    const lapsed = row.access_expires_at && new Date(row.access_expires_at) <= new Date();
    const claimsPaid = decoded['tier'] === 'paid';
    if (claimsPaid && lapsed && row.subscription_status !== 'expired') {
      void reconcileExpiredUser(decoded.uid, row.id);
    }

    // A paid claim over a row that has never been billed can only come from a hand-edited claim
    // (the Stripe webhook always writes the row). Surface it: this is the one shape where making
    // the row authoritative silently takes access away from someone who had it.
    if (claimsPaid && tier === 'free' && row.subscription_status === null) {
      console.warn(`User ${row.id} holds a paid Firebase claim with no subscription row — resolving free.`);
    }

    req.user = {
      uid: row.id,
      firebaseUid: decoded.uid,
      email: decoded.email ?? null,
      tier,
      accessExpiresAt: row.access_expires_at,
    };
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
