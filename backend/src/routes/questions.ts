import { Router } from 'express';
import { z } from 'zod';
import { requireAuth } from '../middleware/auth.js';
import { compileGraph } from '../services/graphService.js';
import { getNextQuestion, getQuestionById, getQuestionsByTopicWithStatus, getQuestionWithSolution } from '../services/questionService.js';
import type { SolutionGraphRender } from '../types/index.js';

const router = Router();

const difficultySchema = z.coerce.number().int().min(1).max(3).optional();

// GET /api/topics/:topicId/questions — requires auth (status needs userId)
router.get('/:topicId/questions', requireAuth, async (req, res) => {
  try {
    const questions = await getQuestionsByTopicWithStatus(req.params.topicId, req.user!.uid);
    res.json(questions);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/topics/:topicId/next?difficulty=2 — requires auth (skips already-answered questions)
router.get('/:topicId/next', requireAuth, async (req, res) => {
  try {
    const difficulty = difficultySchema.parse(req.query.difficulty) as 1 | 2 | 3 | undefined;
    const question = await getNextQuestion(req.params.topicId, req.user!.uid, difficulty);
    if (!question) {
      res.status(404).json({ error: 'No questions found for this topic' });
      return;
    }
    res.json(question);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid query parameters', details: err.issues });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/questions/:id/solution
router.get('/:id/solution', async (req, res) => {
  try {
    const question = await getQuestionWithSolution(req.params.id);
    if (!question) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }
    // Compile model sketches for parts that have one; a broken spec skips that
    // part rather than failing the whole solution.
    const graphs: SolutionGraphRender[] = [];
    for (const part of question.parts ?? []) {
      if (!part.solution_graph) continue;
      try {
        graphs.push(compileGraph(part.label, part.solution_graph));
      } catch {
        // skip malformed spec
      }
    }
    res.json({ solution_latex: question.solution_latex ?? null, graphs });
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

// GET /api/questions/:id
router.get('/:id', async (req, res) => {
  try {
    const question = await getQuestionById(req.params.id);
    if (!question) {
      res.status(404).json({ error: 'Question not found' });
      return;
    }
    res.json(question);
  } catch (err) {
    res.status(500).json({ error: (err as Error).message });
  }
});

export default router;
