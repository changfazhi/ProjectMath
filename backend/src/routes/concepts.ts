import { Router } from 'express';
import { getConceptsByTopic } from '../services/conceptService.js';

const router = Router();

// GET /api/topics/:topicId/concepts
router.get('/:topicId/concepts', async (req, res) => {
  try {
    const concepts = await getConceptsByTopic(req.params.topicId);
    res.json(concepts);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
