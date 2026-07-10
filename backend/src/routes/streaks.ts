import { Router } from 'express';
import { gate } from '../middleware/auth.js';
import { getStreakStats } from '../services/streakService.js';
import { sendServerError } from '../lib/httpErrors.js';

const router = Router();

router.get('/', ...gate('practice'), async (req, res) => {
  try {
    const stats = await getStreakStats(req.user!.uid);
    res.json(stats);
  } catch (err) {
    sendServerError(res, 'GET /api/streaks', err);
  }
});

export default router;
