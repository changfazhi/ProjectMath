import { Router } from 'express';
import { gate } from '../middleware/auth.js';
import { getStreakStats } from '../services/streakService.js';

const router = Router();

router.get('/', ...gate('practice'), async (req, res) => {
  try {
    const stats = await getStreakStats(req.user!.uid);
    res.json(stats);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
