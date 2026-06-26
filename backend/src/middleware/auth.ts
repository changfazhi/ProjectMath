import type { Request, Response, NextFunction, RequestHandler } from 'express';
import { getAuth } from 'firebase-admin/auth';
import { getFirebaseAdmin } from '../db/firebase.js';
import { supabase } from '../db/supabase.js';
import { FEATURE_TIERS } from '../config/featureTiers.js';

declare global {
  namespace Express {
    interface Request {
      user?: { uid: string; tier: 'free' | 'paid' };
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
    const tier = decoded['tier'] === 'paid' ? 'paid' : 'free';

    // Atomic upsert — safe under concurrent first-logins.
    const { data, error } = await supabase
      .from('users')
      .upsert(
        { firebase_uid: decoded.uid, email: decoded.email ?? null },
        { onConflict: 'firebase_uid' },
      )
      .select('id')
      .single();

    if (error || !data) {
      res.status(500).json({ error: 'Failed to resolve user' });
      return;
    }

    req.user = { uid: data.id as string, tier };
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
