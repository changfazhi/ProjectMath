import { Router } from 'express';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { submitAttempt, getAttemptsBySession } from '../services/attemptService.js';
import { sendServerError } from '../lib/httpErrors.js';

const router = Router();

const submitSchema = z.object({
  question_id: z.string().uuid(),
  part_label: z.string().min(1).optional(),
  answer_given: z.string().min(1),
  field_answers: z.array(z.object({ key: z.string(), value: z.string() })).optional(),
  time_taken_s: z.number().int().positive().optional(),
});

// POST /api/attempts
router.post('/', ...gate('practice'), async (req, res) => {
  try {
    const body = submitSchema.parse(req.body);
    const result = await submitAttempt(req.user!.uid, body);
    res.status(201).json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    // The service throws "Question <uuid> not found" / "Part ... not found" — genericise so the
    // raw record id never reaches the client, but keep the 404 so the UI can react to it.
    if ((err as Error).message.includes('not found')) {
      res.status(404).json({ error: 'That question could not be found.' });
      return;
    }
    sendServerError(res, 'POST /api/attempts', err);
  }
});

// GET /api/attempts?question_id=yyy (question_id optional)
router.get('/', ...gate('practice'), async (req, res) => {
  try {
    const questionId = req.query.question_id
      ? z.string().uuid().parse(req.query.question_id)
      : undefined;
    const attempts = await getAttemptsBySession(req.user!.uid, questionId);
    res.json(attempts);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'question_id must be a valid UUID' });
      return;
    }
    sendServerError(res, 'GET /api/attempts', err);
  }
});

export default router;
