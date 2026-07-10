import { Router } from 'express';
import { getConceptsByTopic } from '../services/conceptService.js';
import { sendServerError } from '../lib/httpErrors.js';

const router = Router();

// GET /api/topics/:topicId/concepts
router.get('/:topicId/concepts', async (req, res) => {
  try {
    const concepts = await getConceptsByTopic(req.params.topicId);
    res.json(concepts);
  } catch (err) {
    sendServerError(res, 'GET /api/topics/:topicId/concepts', err);
  }
});

export default router;
