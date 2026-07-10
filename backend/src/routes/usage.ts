import { Router, type RequestHandler } from 'express';
import { requireAuth } from '../middleware/auth.js';
import { getUsageSummary } from '../services/usageService.js';
import { sendServerError } from '../lib/httpErrors.js';

const router = Router();

// GET /api/usage — today's quota usage for the signed-in user (any tier).
router.get('/', requireAuth as RequestHandler, async (req, res) => {
  try {
    res.json(await getUsageSummary(req.user!.uid, req.user!.tier));
  } catch (err) {
    sendServerError(res, 'GET /api/usage', err);
  }
});

export default router;
