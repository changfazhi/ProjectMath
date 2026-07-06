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
    { x: 2, y: 5, label: '(2,\\ 5)', kind: 'min' },
    { x: -4, y: -7, label: '(-4,\\ -7)', kind: 'max' },
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

  it('injects labelled-point x values so the polyline passes through the exact extrema', () => {
    const vertices = render.curves.flatMap((c) => c.segments.flat());
    expect(vertices).toContainEqual([2, 5]);
    expect(vertices).toContainEqual([-4, -7]);
  });

  it('keeps exact authored points unchanged', () => {
    const min = render.points.find((p) => p.kind === 'min');
    expect(min).toMatchObject({ x: 2, y: 5, label: '(2,\\ 5)' });
  });
});

describe('compileGraph point snapping', () => {
  // DHS P2 Q5(e) cooling curve: authored point (28.7, 60) is rounded — the
  // curve's true value at x=28.7 is ≈59.958.
  const coolingSpec: SolutionGraphSpec = {
    x_range: [0, 60],
    y_range: [0, 220],
    curves: [{ expr: '30 + 177 * e^(-0.0619 x)', domain: [0, 60] }],
    points: [
      { x: 0, y: 207, label: '(0,\\ 207)', kind: 'intercept' },
      { x: 28.7, y: 60, label: '(28.7,\\ 60)', kind: 'point' },
    ],
  };

  const render = compileGraph('e', coolingSpec);
  const trueY = 30 + 177 * Math.exp(-0.0619 * 28.7);

  it('snaps a rounded point y onto the curve, keeping the label', () => {
    const snapped = render.points.find((p) => p.x === 28.7);
    expect(snapped?.y).toBeCloseTo(trueY, 10);
    expect(snapped?.y).not.toBe(60);
    expect(snapped?.label).toBe('(28.7,\\ 60)');
  });

  it('places the snapped point exactly on a polyline vertex', () => {
    const vertex = render.curves[0].segments.flat().find(([x]) => x === 28.7);
    expect(vertex).toBeDefined();
    expect(vertex![1]).toBe(render.points.find((p) => p.x === 28.7)!.y);
  });

  it('leaves points far from any curve untouched', () => {
    const render2 = compileGraph('e', {
      ...coolingSpec,
      points: [{ x: 10, y: 200, label: 'annotation', kind: 'point' }],
    });
    expect(render2.points[0]).toEqual({ x: 10, y: 200, label: 'annotation', kind: 'point' });
  });
});

describe('compileGraph extended features', () => {
  it('compiles a points-only spec (scatter diagram) with axis labels', () => {
    const render = compileGraph('a', {
      x_range: [0, 10],
      y_range: [0, 100],
      points: [
        { x: 1, y: 90, kind: 'point' },
        { x: 5, y: 40, kind: 'point' },
      ],
      x_label: 't',
      y_label: 'S',
    });
    expect(render.curves).toEqual([]);
    expect(render.points).toHaveLength(2);
    expect(render.x_label).toBe('t');
    expect(render.y_label).toBe('S');
  });

  it('passes segments and open points through unchanged', () => {
    const render = compileGraph('b', {
      x_range: [-3, 3],
      y_range: [-3, 3],
      curves: [],
      segments: [{ from: [0, 0], to: [2, 2], label: 'P', arrow: true }],
      points: [{ x: 2, y: 2, open: true, kind: 'point' }],
    });
    expect(render.segments).toEqual([{ from: [0, 0], to: [2, 2], label: 'P', arrow: true }]);
    expect(render.points[0].open).toBe(true);
  });

  it('compiles a shade into a closed polygon down to the x-axis', () => {
    const render = compileGraph('c', {
      x_range: [0, 4],
      y_range: [0, 5],
      curves: [{ expr: '4 - x', domain: [0, 4] }],
      shade: [{ expr: '4 - x', domain: [1, 3], label: 'R' }],
    });
    expect(render.shade).toHaveLength(1);
    const { polygon, label } = render.shade[0];
    expect(label).toBe('R');
    // Sampled curve run plus the two baseline corners closing the region.
    expect(polygon[0]).toEqual([1, 3]);
    expect(polygon[polygon.length - 2]).toEqual([3, 0]);
    expect(polygon[polygon.length - 1]).toEqual([1, 0]);
  });

  it('compiles parametric curves and snaps points to their vertices', () => {
    const render = compileGraph('a', {
      x_range: [-3, 3],
      y_range: [-4, 4],
      curves: [{ x_expr: '2 cos(t)', y_expr: '3 sin(t)', domain: [0, 2 * Math.PI], label: 'E' }],
      points: [{ x: 2, y: 0, kind: 'intercept' }],
    });
    const vertices = render.curves[0].segments.flat();
    expect(vertices.length).toBeGreaterThan(500);
    // every vertex satisfies the ellipse equation
    for (const [x, y] of vertices) {
      expect((x * x) / 4 + (y * y) / 9).toBeCloseTo(1, 6);
    }
    // the intercept point snapped onto a sampled vertex
    const p = render.points[0];
    expect(vertices.some(([vx, vy]) => vx === p.x && vy === p.y)).toBe(true);
  });

  it('clamps shade samples into y_range and skips unevaluable shades', () => {
    const render = compileGraph('d', {
      x_range: [0, 4],
      y_range: [0, 2],
      curves: [],
      shade: [
        { expr: '10', domain: [0, 1] },
        { expr: 'nonsense(', domain: [0, 1] },
      ],
    });
    expect(render.shade).toHaveLength(1);
    for (const [, y] of render.shade[0].polygon) expect(y).toBeLessThanOrEqual(2);
  });
});
