import { Router, type RequestHandler } from 'express';
import rateLimit from 'express-rate-limit';
import { z } from 'zod';
import { requireAuth } from '../middleware/auth.js';
import { sendFeedbackEmail } from '../services/feedbackService.js';

const router = Router();

// The one limiter still keyed by IP, because it deliberately runs *before* requireAuth so that
// hammering never reaches Firebase token verification — which means there is no account to key
// on. Every other limiter buckets per account (see middleware/rateLimit.ts, issue #55). This one
// only works because `trust proxy` is set in index.ts; otherwise all callers collapse to the
// Cloud Run front end's address and share a single 3/min bucket.
const feedbackLimiter = rateLimit({
  windowMs: 60_000,
  limit: Number(process.env.FEEDBACK_RATE_LIMIT_PER_MIN ?? 3),
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many feedback submissions — please wait a minute.' },
});

const bodySchema = z.object({
  message: z.string().trim().min(1, 'Message is required').max(2000),
  category: z.enum(['bug', 'idea', 'question', 'other']).optional(),
  page: z.string().max(200).optional(),
});

// POST /api/feedback — email feedback to the team (any signed-in tier)
router.post('/', feedbackLimiter, requireAuth as RequestHandler, async (req, res) => {
  try {
    const body = bodySchema.parse(req.body);
    await sendFeedbackEmail(
      { uid: req.user!.uid, email: req.user!.email, tier: req.user!.tier },
      body,
    );
    res.json({ ok: true });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    // Generic message only — mailer errors describe credential config, not user problems.
    console.error('[feedback] send failed:', err);
    res.status(500).json({ error: 'Could not send feedback right now — please try again later.' });
  }
});

export default router;
