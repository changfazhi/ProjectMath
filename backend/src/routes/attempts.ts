import { Router } from 'express';
import { z } from 'zod';
import { submitAttempt, getAttemptsBySession } from '../services/attemptService.js';

const router = Router();

const submitSchema = z.object({
  session_id: z.string().uuid(),
  question_id: z.string().uuid(),
  part_label: z.string().min(1).optional(),
  answer_given: z.string().min(1),
  time_taken_s: z.number().int().positive().optional(),
});

// POST /api/attempts
// Body: { session_id, question_id, answer_given, time_taken_s? }
// Returns: { attempt_id, is_correct, correct_answer, solution_latex }
router.post('/', async (req, res) => {
  try {
    const body = submitSchema.parse(req.body);
    const result = await submitAttempt(body);
    res.status(201).json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if ((err as Error).message.includes('not found')) {
      res.status(404).json({ error: (err as Error).message });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/attempts?session_id=xxx&question_id=yyy (question_id optional)
router.get('/', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const questionId = req.query.question_id
      ? z.string().uuid().parse(req.query.question_id)
      : undefined;

    const attempts = await getAttemptsBySession(sessionId, questionId);
    res.json(attempts);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
