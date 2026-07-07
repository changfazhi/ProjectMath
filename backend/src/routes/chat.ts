import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { ChatLimitError, newChatThread, sendHintMessage } from '../services/chatService.js';
import { QuotaExceededError, sendQuotaError } from '../services/usageService.js';
import { AiUnavailableError, sendAiError } from '../services/aiErrors.js';

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
  question_id: z.string().uuid(),
  thread_id: z.string().uuid(),
  message: z.string().min(1).max(2000),
});

// GET /api/chat?question_id=UUID — start a fresh conversation scope. Never returns
// stored history: the chat is meant to reset every time it's opened (refresh, reopen,
// new tab, new device). Past messages stay in the DB only for quota/cap enforcement.
router.get('/', ...gate('aiHints'), async (req, res) => {
  try {
    z.string().uuid().parse(req.query.question_id);
    res.json({ thread_id: newChatThread() });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'question_id must be a valid UUID' });
      return;
    }
    console.error('[chat] thread error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

// POST /api/chat — send a message, get a hint
router.post('/', ...gate('aiHints'), chatLimiter, async (req, res) => {
  try {
    const { question_id, thread_id, message } = sendSchema.parse(req.body);
    const result = await sendHintMessage(req.user!.uid, question_id, thread_id, message, req.user!.tier);
    res.json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if (err instanceof QuotaExceededError) {
      sendQuotaError(res, err, req.user!.tier);
      return;
    }
    if (err instanceof ChatLimitError) {
      res.status(429).json({ error: err.message });
      return;
    }
    if (err instanceof AiUnavailableError) {
      sendAiError(res, err);
      return;
    }
    // Never forward raw error messages (Gemini blobs, DB errors) to the client.
    console.error('[chat] unexpected error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

export default router;
