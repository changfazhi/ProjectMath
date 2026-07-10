import { Router } from 'express';
import multer from 'multer';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { accountRateLimit } from '../middleware/rateLimit.js';
import { addImage, closePair, createPair, getValidPair, PairError } from '../services/pairService.js';
import { gradeSolution, GradingError } from '../services/gradingService.js';
import { assertScanQuota, QuotaExceededError, sendQuotaError } from '../services/usageService.js';
import { AiUnavailableError } from '../services/aiErrors.js';
import { getQuestionById } from '../services/questionService.js';
import { emitToPair } from '../realtime.js';
import type { CreatePairResponse, PairContext } from '../types/index.js';

const router = Router();

const MAX_IMAGE_MB = Number(process.env.GRADE_MAX_IMAGE_MB ?? 8);
const ALLOWED_MIME = new Set(['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/heic', 'image/heif']);

const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: MAX_IMAGE_MB * 1024 * 1024, files: 1 },
  fileFilter: (_req, file, cb) => {
    if (ALLOWED_MIME.has(file.mimetype)) cb(null, true);
    else cb(new Error(`Unsupported file type: ${file.mimetype}`));
  },
});

// Account-keyed. On POST /api/pair that's req.user; on the three token-authed phone routes the
// token resolves to the account that created the pairing, so the phone counts against its owner
// rather than against whatever cellular IP it happens to be on.
const pairLimiter = accountRateLimit({
  limit: Number(process.env.PAIR_RATE_LIMIT_PER_MIN ?? 30),
  message: 'Too many requests — slow down a moment.',
});

const createSchema = z.object({
  question_id: z.string().uuid(),
});

// POST /api/pair — desktop starts a pairing (requires auth; userId stored in pair for grading).
router.post('/', ...gate('pairUpload'), pairLimiter, async (req, res) => {
  try {
    const { question_id } = createSchema.parse(req.body);
    // Fail fast before showing a QR the user can't use; runGrading re-checks at /done.
    await assertScanQuota(req.user!.uid, req.user!.tier);
    const pair = createPair(req.user!.uid, question_id, req.user!.tier);
    const body: CreatePairResponse = {
      token: pair.token,
      mobile_path: `/m/${pair.token}`,
      expires_at: pair.expires_at,
    };
    res.status(201).json(body);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if (err instanceof QuotaExceededError) {
      sendQuotaError(res, err, req.user!.tier);
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/pair/:token — mobile page loads its context; no auth (phone uses token as auth).
router.get('/:token', pairLimiter, async (req, res) => {
  const pair = getValidPair(req.params.token);
  if (!pair) {
    res.status(404).json({ valid: false, error: 'This link has expired.' });
    return;
  }
  try {
    const question = await getQuestionById(pair.question_id);
    const body: PairContext = {
      valid: true,
      question_id: pair.question_id,
      question_name: question?.name ?? null,
    };
    emitToPair(pair.token, 'pair:phone-connected');
    res.json(body);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// POST /api/pair/:token/photo — mobile sends one photo; no auth (token is the auth).
router.post('/:token/photo', pairLimiter, upload.single('image'), async (req, res) => {
  try {
    const pair = getValidPair(req.params.token);
    if (!pair) throw new PairError('This link has expired. Please scan a fresh QR code.', 404);
    const file = req.file;
    if (!file) {
      res.status(400).json({ error: 'No photo received.' });
      return;
    }
    const count = addImage(pair.token, { mimeType: file.mimetype, buffer: file.buffer });
    const dataUrl = `data:${file.mimetype};base64,${file.buffer.toString('base64')}`;
    emitToPair(pair.token, 'pair:image', { index: count - 1, dataUrl });
    res.status(201).json({ count });
  } catch (err) {
    if (err instanceof PairError) {
      res.status(err.status).json({ error: err.message });
      return;
    }
    if (err instanceof Error && /file too large|unsupported file type/i.test(err.message)) {
      res.status(400).json({ error: err.message });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// POST /api/pair/:token/done — mobile finishes; grade all collected photos, push result to desktop.
router.post('/:token/done', pairLimiter, async (req, res) => {
  const pair = getValidPair(req.params.token);
  if (!pair) {
    res.status(404).json({ error: 'This link has expired. Please scan a fresh QR code.' });
    return;
  }
  if (pair.images.length === 0) {
    res.status(400).json({ error: 'Take at least one photo before finishing.' });
    return;
  }

  // Respond to the phone immediately; grading streams to the desktop over the socket.
  res.status(202).json({ ok: true });

  emitToPair(pair.token, 'pair:grading');
  try {
    const grading = await gradeSolution({
      userId: pair.userId,
      tier: pair.tier,
      question_id: pair.question_id,
      images: pair.images,
    });
    emitToPair(pair.token, 'pair:graded', { grading });
  } catch (err) {
    // AiUnavailableError messages are public-safe (cooldown/busy/daily limit); anything
    // unexpected gets a generic message — never the raw error.
    const message =
      err instanceof GradingError ||
      err instanceof QuotaExceededError ||
      err instanceof AiUnavailableError
        ? err.message
        : 'Grading failed — please try again on your computer.';
    if (!(err instanceof GradingError || err instanceof QuotaExceededError || err instanceof AiUnavailableError)) {
      console.error('[pair/done] unexpected error:', err);
    }
    const code = err instanceof AiUnavailableError ? err.code : undefined;
    const resetAt = err instanceof AiUnavailableError ? err.resetAt : undefined;
    emitToPair(pair.token, 'pair:error', {
      message,
      ...(code ? { code } : {}),
      ...(resetAt ? { reset_at: resetAt } : {}),
    });
  } finally {
    closePair(pair.token);
  }
});

export default router;
