import { Router } from 'express';
import { z } from 'zod';
import { toggleStar, getStarredIds } from '../services/starService.js';
import { getQuestionsByTopicWithStatus } from '../services/questionService.js';

const router = Router();

const toggleSchema = z.object({
  session_id: z.string().uuid(),
  question_id: z.string().uuid(),
});

// POST /api/stars — toggle star for a question
router.post('/', async (req, res) => {
  try {
    const { session_id, question_id } = toggleSchema.parse(req.body);
    const result = await toggleStar(session_id, question_id);
    res.json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/stars?session_id=UUID&topic_id=UUID
router.get('/', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const topicId = z.string().uuid().parse(req.query.topic_id);

    // Resolve question IDs for this topic so we can filter stars correctly
    const questions = await getQuestionsByTopicWithStatus(topicId, sessionId);
    const questionIds = questions.map((q) => q.id);
    const starredIds = await getStarredIds(sessionId, questionIds);
    res.json(starredIds);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id and topic_id must be valid UUIDs' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
