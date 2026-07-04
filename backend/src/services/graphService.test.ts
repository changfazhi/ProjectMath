import { describe, expect, it } from 'vitest';
import { compileGraph } from './graphService.js';
import type { SolutionGraphSpec } from '../types/index.js';

// The DHS P2 Q1(b) model sketch: y = x + 9/(x+1), VA x=-1, oblique y=x.
const dhsSpec: SolutionGraphSpec = {
  x_range: [-10, 8],
  y_range: [-20, 18],
  curves: [
    { expr: 'x + 9/(x+1)', domain: [-10, -1] },
    { expr: 'x + 9/(x+1)', domain: [-1, 8], label: 'y=x+\\dfrac{9}{x+1}' },
  ],
  asymptotes: [
    { kind: 'vertical', x: -1, label: 'x=-1' },
    { kind: 'oblique', expr: 'x', label: 'y=x' },
  ],
  points: [
    { x: 2, y: 8, label: '(2,\\ 8)', kind: 'min' },
    { x: -4, y: -10, label: '(-4,\\ -10)', kind: 'max' },
    { x: 0, y: 9, label: '(0,\\ 9)', kind: 'intercept' },
  ],
};

describe('compileGraph', () => {
  const render = compileGraph('b', dhsSpec);

  it('carries ranges, label, and points through', () => {
    expect(render.part_label).toBe('b');
    expect(render.x_range).toEqual([-10, 8]);
    expect(render.points).toHaveLength(3);
    expect(render.curves[1].label).toBe('y=x+\\dfrac{9}{x+1}');
  });

  it('samples no point at or across the vertical asymptote', () => {
    for (const curve of render.curves) {
      for (const seg of curve.segments) {
        for (const [x] of seg) {
          expect(Math.abs(x - -1)).toBeGreaterThan(1e-6);
        }
        // a single segment never straddles x = -1
        const signs = new Set(seg.map(([x]) => Math.sign(x + 1)));
        expect(signs.size).toBe(1);
      }
    }
  });

  it('keeps every sampled y within y_range', () => {
    for (const curve of render.curves) {
      for (const seg of curve.segments) {
        for (const [, y] of seg) {
          expect(y).toBeGreaterThanOrEqual(-20);
          expect(y).toBeLessThanOrEqual(18);
        }
      }
    }
  });

  it('produces sane curve values (y-intercept region ≈ 9)', () => {
    const right = render.curves[1];
    const nearZero = right.segments.flat().find(([x]) => Math.abs(x) < 0.05);
    expect(nearZero).toBeDefined();
    expect(nearZero![1]).toBeCloseTo(9, 0);
  });

  it('compiles the oblique asymptote to a 2-point line y=x', () => {
    const oblique = render.asymptotes.find((a) => a.kind === 'oblique');
    expect(oblique?.points).toEqual([
      [-10, -10],
      [8, 8],
    ]);
    const vertical = render.asymptotes.find((a) => a.kind === 'vertical');
    expect(vertical?.x).toBe(-1);
  });

  it('drops asymptotes with broken expressions instead of throwing', () => {
    const render2 = compileGraph('a', {
      ...dhsSpec,
      asymptotes: [{ kind: 'oblique', expr: 'nonsense(', label: 'bad' }],
    });
    expect(render2.asymptotes).toEqual([]);
  });
});
