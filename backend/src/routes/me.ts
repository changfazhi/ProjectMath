import { Router, type RequestHandler } from 'express';
import { requireAuth } from '../middleware/auth.js';

const router = Router();

// GET /api/me — the signed-in user's server-resolved tier.
//
// The frontend must not read tier from the Firebase custom claim: the claim is baked into an ID
// token that lives up to an hour, so a cancelled user would keep seeing Premium chrome long after
// the server stopped honouring it (issue #54). `requireAuth` has already derived the tier from the
// `users` row, so this route is free. `/api/billing/status` is deliberately not used for this —
// it hits Stripe live for card subscribers, and this runs on every page load.
router.get('/', requireAuth as RequestHandler, (req, res) => {
  res.json({ tier: req.user!.tier, accessExpiresAt: req.user!.accessExpiresAt });
});

export default router;
