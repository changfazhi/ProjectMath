import { Router } from 'express';
import multer from 'multer';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { accountRateLimit } from '../middleware/rateLimit.js';
import {
  gradeSolution,
  gradeTranscription,
  getGradingsForQuestion,
  GradingError,
} from '../services/gradingService.js';
import { QuotaExceededError, sendQuotaError } from '../services/usageService.js';
import { AiUnavailableError, sendAiError } from '../services/aiErrors.js';

const router = Router();

const MAX_IMAGES = Number(process.env.GRADE_MAX_IMAGES ?? 5);
const MAX_IMAGE_MB = Number(process.env.GRADE_MAX_IMAGE_MB ?? 8);
const ALLOWED_MIME = new Set(['image/jpeg', 'image/jpg', 'image/png', 'image/webp', 'image/heic', 'image/heif']);

// Images are held in memory: forwarded to Gemini as base64 and uploaded to Supabase Storage.
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: MAX_IMAGE_MB * 1024 * 1024, files: MAX_IMAGES },
  fileFilter: (_req, file, cb) => {
    if (ALLOWED_MIME.has(file.mimetype)) cb(null, true);
    else cb(new Error(`Unsupported file type: ${file.mimetype}`));
  },
});

// Account-keyed burst guard — runs after gate() so req.user is populated. The real pacing on
// costly vision calls is the 60s per-user grade cooldown, which is stricter than this.
const gradeLimiter = accountRateLimit({
  limit: Number(process.env.GRADE_RATE_LIMIT_PER_MIN ?? 5),
  message: 'Too many grading requests — give it a moment before submitting again.',
});

const bodySchema = z.object({
  question_id: z.string().uuid(),
  time_taken_s: z.coerce.number().int().positive().optional(),
});

const textBodySchema = z.object({
  question_id: z.string().uuid(),
  transcription_latex: z.string().min(1),
  time_taken_s: z.coerce.number().int().positive().optional(),
});

// GET /api/grade?question_id=UUID — rehydrate past gradings
router.get('/', ...gate('photoGrading'), async (req, res) => {
  try {
    const questionId = z.string().uuid().parse(req.query.question_id);
    const gradings = await getGradingsForQuestion(req.user!.uid, questionId);
    res.json(gradings);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'question_id must be a valid UUID' });
      return;
    }
    console.error('[grade] history error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

// POST /api/grade — multipart upload of solution photo(s) → AI grade
router.post('/', ...gate('photoGrading'), gradeLimiter, upload.array('images', MAX_IMAGES), async (req, res) => {
  try {
    const { question_id, time_taken_s } = bodySchema.parse(req.body);
    const files = (req.files as Express.Multer.File[]) ?? [];
    if (files.length === 0) {
      res.status(400).json({ error: 'Attach at least one photo of your solution.' });
      return;
    }
    const result = await gradeSolution({
      userId: req.user!.uid,
      tier: req.user!.tier,
      question_id,
      time_taken_s,
      images: files.map((f) => ({ mimeType: f.mimetype, buffer: f.buffer })),
    });
    res.status(201).json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if (err instanceof QuotaExceededError) {
      sendQuotaError(res, err, req.user!.tier);
      return;
    }
    if (err instanceof GradingError) {
      res.status(400).json({ error: err.message });
      return;
    }
    if (err instanceof AiUnavailableError) {
      sendAiError(res, err);
      return;
    }
    // multer errors (file too large / too many / bad type) surface as plain Errors
    if (err instanceof Error && /file too large|too many files|unsupported file type/i.test(err.message)) {
      res.status(400).json({ error: err.message });
      return;
    }
    // Never forward raw error messages (Gemini blobs, DB errors) to the client.
    console.error('[grade] unexpected error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

// POST /api/grade/text — re-grade from the student's (edited) typed LaTeX, after they correct a
// mis-scanned photo. No images; grades the corrected text only. Same rate limit as photo grading.
router.post('/text', ...gate('photoGrading'), gradeLimiter, async (req, res) => {
  try {
    const { question_id, transcription_latex, time_taken_s } = textBodySchema.parse(req.body);
    const result = await gradeTranscription({
      userId: req.user!.uid,
      tier: req.user!.tier,
      question_id,
      transcription_latex,
      time_taken_s,
    });
    res.status(201).json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if (err instanceof QuotaExceededError) {
      sendQuotaError(res, err, req.user!.tier);
      return;
    }
    if (err instanceof GradingError) {
      res.status(400).json({ error: err.message });
      return;
    }
    if (err instanceof AiUnavailableError) {
      sendAiError(res, err);
      return;
    }
    console.error('[grade/text] unexpected error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

export default router;
