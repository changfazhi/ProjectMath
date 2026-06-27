import { Router } from 'express';
import multer from 'multer';
import rateLimit from 'express-rate-limit';
import { z } from 'zod';
import { gate } from '../middleware/auth.js';
import { gradeSolution, getGradingsForQuestion, GradingError } from '../services/gradingService.js';

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

// IP-keyed limiter — primary defence against runaway Gemini vision bills (grading is costly).
const gradeLimiter = rateLimit({
  windowMs: 60_000,
  limit: Number(process.env.GRADE_RATE_LIMIT_PER_MIN ?? 5),
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many grading requests — give it a moment before submitting again.' },
});

const bodySchema = z.object({
  question_id: z.string().uuid(),
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
    res.status(500).json({ error: (err as Error).message });
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
    if (err instanceof GradingError) {
      res.status(400).json({ error: err.message });
      return;
    }
    // multer errors (file too large / too many / bad type) surface as plain Errors
    if (err instanceof Error && /file too large|too many files|unsupported file type/i.test(err.message)) {
      res.status(400).json({ error: err.message });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
