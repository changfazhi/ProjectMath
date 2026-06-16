import { Router } from 'express';
import { z } from 'zod';
import { getStreakStats } from '../services/streakService.js';

const router = Router();

router.get('/', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const stats = await getStreakStats(sessionId);
    res.json(stats);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
