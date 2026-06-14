import { Router } from 'express';
import { z } from 'zod';
import { getAllTopics, getTopicById, getTopicsProgress } from '../services/topicService.js';

const router = Router();

const levelSchema = z.enum(['H1', 'H2']).optional();

// GET /api/topics?level=H2
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

// GET /api/topics/progress?session_id=UUID
router.get('/progress', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const progress = await getTopicsProgress(sessionId);
    res.json(progress);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/:id
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
