import { Router } from 'express';
import { z } from 'zod';
import {
  getCorrectionsItems,
  getWeakTopicsItems,
  getSpeedDrillItems,
  getSpacedItems,
  getRandomItems,
} from '../services/reviewService.js';

const router = Router();

const sessionSchema = z.string().uuid();

function sessionId(raw: unknown): string {
  return sessionSchema.parse(raw);
}

router.get('/corrections', async (req, res) => {
  try {
    const items = await getCorrectionsItems(sessionId(req.query.session_id));
    res.json({ items });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/weak-topics', async (req, res) => {
  try {
    const items = await getWeakTopicsItems(sessionId(req.query.session_id));
    res.json({ items });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/speed-drills', async (req, res) => {
  try {
    const items = await getSpeedDrillItems(sessionId(req.query.session_id));
    res.json({ items });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

router.get('/spaced', async (req, res) => {
  try {
    const items = await getSpacedItems(sessionId(req.query.session_id));
    res.json({ items });
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'session_id must be a valid UUID' });
      return;
    }
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

export default router;
