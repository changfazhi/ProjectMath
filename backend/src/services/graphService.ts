import { evaluate } from 'mathjs';
import type {
  GraphAsymptote,
  RenderedAsymptote,
  SolutionGraphRender,
  SolutionGraphSpec,
} from '../types/index.js';

const SAMPLES = 200;

// Inset sampling this close to a declared vertical asymptote so the polyline
// approaches it without shooting to ±∞ on the exact boundary sample.
const EPS_FRACTION = 1e-3;

function evalAt(expr: string, x: number): number | null {
  try {
    const y = evaluate(expr, { x }) as unknown;
    return typeof y === 'number' && isFinite(y) ? y : null;
  } catch {
    return null;
  }
}

function compileAsymptote(
  a: GraphAsymptote,
  xRange: [number, number],
): RenderedAsymptote | null {
  if (a.kind === 'vertical') {
    return typeof a.x === 'number' ? { kind: 'vertical', x: a.x, label: a.label ?? null } : null;
  }
  if (!a.expr) return null;
  const y1 = evalAt(a.expr, xRange[0]);
  const y2 = evalAt(a.expr, xRange[1]);
  if (y1 === null || y2 === null) return null;
  return {
    kind: a.kind,
    points: [
      [xRange[0], y1],
      [xRange[1], y2],
    ],
    label: a.label ?? null,
  };
}

/**
 * Compile an authored graph spec into expression-free polylines the client can
 * draw directly. Curves are sampled over their domain, split into segments at
 * non-finite values and wherever y leaves y_range (so branches on either side
 * of an asymptote render as separate paths).
 */
export function compileGraph(partLabel: string, spec: SolutionGraphSpec): SolutionGraphRender {
  const [yMin, yMax] = spec.y_range;
  const eps = (spec.x_range[1] - spec.x_range[0]) * EPS_FRACTION;
  const verticals = (spec.asymptotes ?? [])
    .filter((a) => a.kind === 'vertical' && typeof a.x === 'number')
    .map((a) => a.x as number);

  const curves = spec.curves.map((curve) => {
    let [d0, d1] = curve.domain;
    // Pull sampling just inside the domain where it touches a vertical asymptote.
    for (const vx of verticals) {
      if (Math.abs(d0 - vx) < eps) d0 = vx + eps;
      if (Math.abs(d1 - vx) < eps) d1 = vx - eps;
    }

    const segments: [number, number][][] = [];
    let current: [number, number][] = [];
    const flush = () => {
      if (current.length > 1) segments.push(current);
      current = [];
    };

    for (let i = 0; i <= SAMPLES; i++) {
      const x = d0 + ((d1 - d0) * i) / SAMPLES;
      // Break the segment when stepping across a declared vertical asymptote.
      const prev = current[current.length - 1];
      if (prev && verticals.some((vx) => (prev[0] - vx) * (x - vx) < 0)) flush();

      const y = evalAt(curve.expr, x);
      if (y === null || y < yMin || y > yMax) {
        flush();
        continue;
      }
      current.push([x, y]);
    }
    flush();

    return { segments, label: curve.label ?? null };
  });

  return {
    part_label: partLabel,
    x_range: spec.x_range,
    y_range: spec.y_range,
    curves,
    asymptotes: (spec.asymptotes ?? [])
      .map((a) => compileAsymptote(a, spec.x_range))
      .filter((a): a is RenderedAsymptote => a !== null),
    points: spec.points ?? [],
  };
}
