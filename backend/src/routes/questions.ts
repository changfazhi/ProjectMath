import { Router } from 'express';
import { z } from 'zod';
import { getNextQuestion, getQuestionById, getQuestionsByTopicWithStatus } from '../services/questionService.js';

const router = Router();

const difficultySchema = z.coerce.number().int().min(1).max(3).optional();

// GET /api/topics/:topicId/questions?session_id=UUID
router.get('/:topicId/questions', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const questions = await getQuestionsByTopicWithStatus(req.params.topicId, sessionId);
    res.json(questions);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/:topicId/next?session_id=xxx&difficulty=2
router.get('/:topicId/next', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const difficulty = difficultySchema.parse(req.query.difficulty) as 1 | 2 | 3 | undefined;

    const question = await getNextQuestion(req.params.topicId, sessionId, difficulty);
    if (!question) {
      res.status(404).json({ error: 'No questions found for this topic' });
      return;
    }
    res.json(question);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID', details: err.issues });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/questions/:id
router.get('/:id', async (req, res) => {
  try {
    const question = await getQuestionById(req.params.id);
    if (!question) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }
    res.json(question);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
