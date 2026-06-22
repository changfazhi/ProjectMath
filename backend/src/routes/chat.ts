import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import { z } from 'zod';
import { ChatLimitError, getChatHistory, sendHintMessage } from '../services/chatService.js';

const router = Router();

// IP-keyed limiter — primary defence against runaway Gemini bills.
const chatLimiter = rateLimit({
  windowMs: 60_000,
  limit: Number(process.env.CHAT_RATE_LIMIT_PER_MIN ?? 15),
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many requests, slow down and give the hints a moment.' },
});

const sendSchema = z.object({
  session_id: z.string().uuid(),
  question_id: z.string().uuid(),
  message: z.string().min(1).max(2000),
});

// GET /api/chat?session_id=UUID&question_id=UUID — rehydrate history
router.get('/', async (req, res) => {
  try {
    const sessionId = z.string().uuid().parse(req.query.session_id);
    const questionId = z.string().uuid().parse(req.query.question_id);
    const history = await getChatHistory(sessionId, questionId);
    res.json(history);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id and question_id must be valid UUIDs' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// POST /api/chat — send a message, get a hint
router.post('/', chatLimiter, async (req, res) => {
  try {
    const { session_id, question_id, message } = sendSchema.parse(req.body);
    const result = await sendHintMessage(session_id, question_id, message);
    res.json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if (err instanceof ChatLimitError) {
      res.status(429).json({ error: err.message });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
