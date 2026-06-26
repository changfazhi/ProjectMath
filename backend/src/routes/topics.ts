import { Router } from 'express';
import { z } from 'zod';
import { requireAuth } from '../middleware/auth.js';
import { getAllTopics, getTopicById, getTopicsAccuracy, getTopicsProgress } from '../services/topicService.js';

const router = Router();

const levelSchema = z.enum(['H1', 'H2']).optional();

// GET /api/topics?level=H2 — public
router.get('/', async (req, res) => {
  try {
    const level = levelSchema.parse(req.query.level);
    const topics = await getAllTopics(level);
    res.json(topics);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'level must be H1 or H2' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/progress — requires auth
router.get('/progress', requireAuth, async (req, res) => {
  try {
    const progress = await getTopicsProgress(req.user!.uid);
    res.json(progress);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/accuracy — requires auth
router.get('/accuracy', requireAuth, async (req, res) => {
  try {
    const accuracy = await getTopicsAccuracy(req.user!.uid);
    res.json(accuracy);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/:id — public
router.get('/:id', async (req, res) => {
  try {
    const topic = await getTopicById(req.params.id);
    if (!topic) {
      res.status(404).json({ error: 'Topic not found' });
      return;
    }
    res.json(topic);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
