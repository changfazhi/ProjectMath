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
  getWeaknessDiagnosis,
  getPersonalisedStudyPlan,
} from '../services/diagnosticService.js';

const router = Router();

router.get('/corrections', ...gate('review'), async (req, res) => {
  try {
    const items = await getCorrectionsItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/weak-topics', ...gate('review'), async (req, res) => {
  try {
    const items = await getWeakTopicsItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/speed-drills', ...gate('review'), async (req, res) => {
  try {
    const items = await getSpeedDrillItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/spaced', ...gate('review'), async (req, res) => {
  try {
    const items = await getSpacedItems(req.user!.uid);
    res.json({ items });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/random', async (_req, res) => {
  try {
    const items = await getRandomItems();
    res.json({ items });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/diagnosis', ...gate('review'), async (req, res) => {
  try {
    const result = await getWeaknessDiagnosis(req.user!.uid);
    res.json(result);
  } catch (err) {
    const msg = (err as Error).message;
    if (msg.includes('Attempt at least')) {
      res.status(403).json({ error: msg });
      return;
    }
    res.status(500).json({ error: msg });
  }
});

router.get('/study-plan', ...gate('review'), async (req, res) => {
  try {
    const result = await getPersonalisedStudyPlan(req.user!.uid);
    res.json(result);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
