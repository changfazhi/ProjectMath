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
      .select('id, access_expires_at, welcome_email_sent_at')
      .single();

    if (error || !data) {
      res.status(500).json({ error: 'Failed to resolve user' });
      return;
    }

    const row = data as { id: string; access_expires_at: string | null; welcome_email_sent_at: string | null };

    // Induction email, once per account — fire-and-forget so it never delays the request.
    // The conditional update atomically "claims" the send: under concurrent first-login
    // requests (the frontend fires several API calls at once), only the request whose
    // update actually matches a NULL flag proceeds, so we never double-send. If the send
    // itself fails, the claim is rolled back so the next login retries instead of the
    // account being permanently marked "welcomed" with nothing ever delivered.
    if (!row.welcome_email_sent_at && decoded.email) {
      const email = decoded.email;
      const userId = row.id;
      supabase
        .from('users')
        .update({ welcome_email_sent_at: new Date().toISOString() })
        .eq('id', userId)
        .is('welcome_email_sent_at', null)
        .select('id')
        .then(async ({ data: claimed }) => {
          if (!claimed || claimed.length === 0) return;
          const sent = await sendWelcomeEmail(email);
          if (!sent) {
            supabase.from('users').update({ welcome_email_sent_at: null }).eq('id', userId).then(() => {}, () => {});
          }
        }, () => {});
    }

    // Enforce PayNow expiry server-side: downgrade if access_expires_at has passed.
    if (tier === 'paid' && row.access_expires_at && new Date(row.access_expires_at) <= new Date()) {
      tier = 'free';
      getAuth(getFirebaseAdmin())
        .setCustomUserClaims(decoded.uid, { tier: 'free' })
        .catch(() => {});
      supabase
        .from('users')
        .update({ subscription_status: 'expired', access_expires_at: null })
        .eq('id', row.id)
        .then(() => {}, () => {});
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
