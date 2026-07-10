import rateLimit, { ipKeyGenerator } from 'express-rate-limit';
import type { Request, RequestHandler } from 'express';
import { peekPairOwner } from '../services/pairService.js';

/**
 * Which bucket a request counts against.
 *
 * Keying on the IP — express-rate-limit's default — lets one user throttle another: two students
 * behind a school NAT share a bucket, and on Cloud Run (where `req.ip` is the front end's address
 * unless `trust proxy` is set) the *entire* user base shares one. See issue #55.
 *
 * The account is the right unit. Every AI route runs this after `gate(...)`, so `req.user` is
 * populated; the phone's token-authed pair routes have no `req.user` but their token resolves to
 * the account that created the pairing.
 */
export function accountKey(req: Request): string {
  if (req.user) return `user:${req.user.uid}`;

  const token = req.params['token'];
  const owner = token ? peekPairOwner(token) : null;
  if (owner) return `user:${owner}`;

  // Anonymous, or an unknown/expired pair token — the caller's IP is the only handle we have.
  // `ipKeyGenerator` has to be called *inline here*: express-rate-limit reads this function's
  // source text and rejects a `req.ip` that isn't accompanied by it, because a raw IPv6 address
  // lets one client rotate through a /64 to get a fresh bucket per request.
  return `ip:${ipKeyGenerator(req.ip ?? '')}`;
}

/**
 * A per-minute limiter bucketed by account rather than by IP.
 *
 * These numbers are a burst guard, not the spend ceiling. Sustained cost is bounded by the
 * per-user cooldowns (`cooldownService`), the per-tier daily quotas (`usageService`), and the
 * shared outbound pacer in front of Gemini (`config/aiLimits.ts`) — which is the layer actually
 * sized against the API key's real RPM/RPD.
 */
export function accountRateLimit(opts: { limit: number; message: string }): RequestHandler {
  return rateLimit({
    windowMs: 60_000,
    limit: opts.limit,
    standardHeaders: true,
    legacyHeaders: false,
    message: { error: opts.message },
    keyGenerator: accountKey,
  });
}
