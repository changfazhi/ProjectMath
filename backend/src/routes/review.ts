import { Router } from 'express';
import { gate } from '../middleware/auth.js';
import {
  getCorrectionsItems,
  getWeakTopicsItems,
  getSpeedDrillItems,
  getSpacedItems,
  getRandomItems,
} from '../services/reviewService.js';
import {
  getDiagnosisStatus,
  generateWeaknessDiagnosis,
  getPersonalisedStudyPlan,
} from '../services/diagnosticService.js';
import { QuotaExceededError, sendQuotaError } from '../services/usageService.js';
import { AiUnavailableError, sendAiError } from '../services/aiErrors.js';
import { sendServerError } from '../lib/httpErrors.js';

const router = Router();

router.get('/corrections', ...gate('review'), async (req, res) => {
  try {
    const items = await getCorrectionsItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    sendServerError(res, 'GET /api/review/corrections', err);
  }
});

router.get('/weak-topics', ...gate('review'), async (req, res) => {
  try {
    const items = await getWeakTopicsItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    sendServerError(res, 'GET /api/review/weak-topics', err);
  }
});

router.get('/speed-drills', ...gate('review'), async (req, res) => {
  try {
    const items = await getSpeedDrillItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    sendServerError(res, 'GET /api/review/speed-drills', err);
  }
});

router.get('/spaced', ...gate('review'), async (req, res) => {
  try {
    const items = await getSpacedItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    sendServerError(res, 'GET /api/review/spaced', err);
  }
});

router.get('/random', async (_req, res) => {
  try {
    const items = await getRandomItems();
    res.json({ items });
  } catch (err) {
    sendServerError(res, 'GET /api/review/random', err);
  }
});

// GET — the stored diagnosis + cooldown state; never runs the AI analysis.
router.get('/diagnosis', ...gate('review'), async (req, res) => {
  try {
    const status = await getDiagnosisStatus(req.user!.uid, req.user!.tier);
    res.json(status);
  } catch (err) {
    sendServerError(res, 'GET /api/review/diagnosis', err);
  }
});

// POST — run a new analysis (cooldown-enforced: daily for paid, weekly for free).
router.post('/diagnosis', ...gate('review'), async (req, res) => {
  try {
    const status = await generateWeaknessDiagnosis(req.user!.uid, req.user!.tier);
    res.json(status);
  } catch (err) {
    if (err instanceof QuotaExceededError) {
      sendQuotaError(res, err, req.user!.tier);
      return;
    }
    if (err instanceof AiUnavailableError) {
      sendAiError(res, err);
      return;
    }
    const msg = (err as Error).message;
    if (msg.includes('Attempt at least')) {
      res.status(403).json({ error: msg });
      return;
    }
    console.error('[review/diagnosis] unexpected error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

router.get('/study-plan', ...gate('review'), async (req, res) => {
  try {
    const result = await getPersonalisedStudyPlan(req.user!.uid, req.user!.tier);
    res.json(result);
  } catch (err) {
    if (err instanceof AiUnavailableError) {
      sendAiError(res, err);
      return;
    }
    console.error('[review/study-plan] unexpected error:', err);
    res.status(500).json({ error: 'Something went wrong — please try again.' });
  }
});

export default router;
