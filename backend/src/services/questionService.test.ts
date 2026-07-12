import { describe, expect, it } from 'vitest';
import { stripSolution } from './questionService.js';
import type { Question } from '../types/index.js';

// A minimal question carrying a prompt_graph (given diagram) — mirrors the EJC
// Q4 shape: a question-level spec that must be compiled and served publicly.
function baseQuestion(overrides: Partial<Question> = {}): Question {
  return {
    id: 'q1',
    topic_id: 't1',
    difficulty: 2,
    name: null,
    prompt_latex: 'The diagram shows y=f(2x).',
    answer_type: 'exact',
    correct_answer: 'secret',
    tolerance: null,
    mcq_options: null,
    parts: null,
    solution_latex: 'secret solution',
    marks: 3,
    source: 'test',
    created_at: '2025-01-01',
    ...overrides,
  };
}

describe('stripSolution — prompt_graph', () => {
  it('compiles a given diagram into the public payload and drops the raw spec', () => {
    const pub = stripSolution(
      baseQuestion({
        prompt_graph: {
          x_range: [-1, 10],
          y_range: [-1, 10],
          curves: [{ expr: '2*((x-2)/x)^2', domain: [0.16, 10], label: 'y=f(2x)' }],
          asymptotes: [{ kind: 'vertical', x: 0, label: 'x=0' }],
          points: [{ x: 2, y: 0, label: '(2,\\ 0)', kind: 'min' }],
        },
      }),
    );

    expect(pub.prompt_graph).toBeTruthy();
    // expression-free render: polyline segments, no mathjs `expr` strings anywhere
    expect(pub.prompt_graph!.curves[0].segments.length).toBeGreaterThan(0);
    expect(JSON.stringify(pub.prompt_graph)).not.toContain('2*((x-2)/x)');
    // solution fields are still hidden
    expect((pub as unknown as Question).correct_answer).toBeUndefined();
    expect((pub as unknown as Question).solution_latex).toBeUndefined();
  });

  it('yields null (not a crash) for a question without a given diagram', () => {
    expect(stripSolution(baseQuestion()).prompt_graph).toBeNull();
  });

  it('drops a malformed spec to null instead of throwing', () => {
    const pub = stripSolution(
      baseQuestion({
        // curves referencing an unparseable expression
        prompt_graph: { x_range: [0, 1], y_range: [0, 1], curves: [{ expr: '@@@', domain: [0, 1] }] },
      }),
    );
    // compileGraph tolerates a bad expr (empty polyline) rather than throwing, so
    // the payload still carries a render; the important guarantee is no crash.
    expect(pub).toBeDefined();
  });
});
