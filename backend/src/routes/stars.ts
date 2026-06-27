import { Router } from 'express';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { toggleStar, getStarredIds, getStarredQuestions } from '../services/starService.js';
import { getQuestionsByTopicWithStatus } from '../services/questionService.js';

const router = Router();

const toggleSchema = z.object({
  question_id: z.string().uuid(),
});

// POST /api/stars — toggle star for a question
router.post('/', ...gate('practice'), async (req, res) => {
  try {
    const { question_id } = toggleSchema.parse(req.body);
    const result = await toggleStar(req.user!.uid, question_id);
    res.json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/stars/all — all starred questions across all topics
router.get('/all', ...gate('practice'), async (req, res) => {
  try {
    const rows = await getStarredQuestions(req.user!.uid);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/stars?topic_id=UUID
router.get('/', ...gate('practice'), async (req, res) => {
  try {
    const topicId = z.string().uuid().parse(req.query.topic_id);
    const questions = await getQuestionsByTopicWithStatus(topicId, req.user!.uid);
    const questionIds = questions.map((q) => q.id);
    const starredIds = await getStarredIds(req.user!.uid, questionIds);
    res.json(starredIds);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'topic_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
