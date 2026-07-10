import { Router } from 'express';
import { z } from 'zod';
import { requireAuth } from '../middleware/auth.js';
import { getAllTopics, getTopicById, getTopicsAccuracy, getTopicsProgress } from '../services/topicService.js';
import { sendServerError } from '../lib/httpErrors.js';

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
    sendServerError(res, 'GET /api/topics', err);
  }
});

// GET /api/topics/progress — requires auth
router.get('/progress', requireAuth, async (req, res) => {
  try {
    const progress = await getTopicsProgress(req.user!.uid);
    res.json(progress);
  } catch (err) {
    sendServerError(res, 'GET /api/topics/progress', err);
  }
});

// GET /api/topics/accuracy — requires auth
router.get('/accuracy', requireAuth, async (req, res) => {
  try {
    const accuracy = await getTopicsAccuracy(req.user!.uid);
    res.json(accuracy);
  } catch (err) {
    sendServerError(res, 'GET /api/topics/accuracy', err);
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
    sendServerError(res, 'GET /api/topics/:id', err);
  }
});

export default router;
