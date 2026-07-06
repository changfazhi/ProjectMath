import { evaluate } from 'mathjs';
import type {
  GraphAsymptote,
  RenderedAsymptote,
  SolutionGraphRender,
  SolutionGraphSpec,
} from '../types/index.js';

const SAMPLES = 200;
// Parametric curves can wind (rosettes, ellipses) — sample them more densely.
const PARAM_SAMPLES = 600;

// Inset sampling this close to a declared vertical asymptote so the polyline
// approaches it without shooting to ±∞ on the exact boundary sample.
const EPS_FRACTION = 1e-3;

// A labelled point snaps onto a curve only if the authored y is within this
// fraction of the y-range span of the curve's true value — loose enough for
// rounded authored coordinates, tight enough not to grab a different branch.
const SNAP_FRACTION = 0.05;

function evalAt(expr: string, x: number): number | null {
  try {
    // Both names bound so y = f(x) curves use x and parametric ones can use t.
    const y = evaluate(expr, { x, t: x }) as unknown;
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

  const pointXs = (spec.points ?? []).map((p) => p.x);
  const specCurves = spec.curves ?? [];
  const [xMin, xMax] = spec.x_range;

  const curves = specCurves.map((curve) => {
    // Parametric curve: sample t, plot (x(t), y(t)), clip to both ranges.
    if (curve.x_expr && curve.y_expr) {
      const [t0, t1] = curve.domain;
      const segments: [number, number][][] = [];
      let current: [number, number][] = [];
      const flush = () => {
        if (current.length > 1) segments.push(current);
        current = [];
      };
      for (let i = 0; i <= PARAM_SAMPLES; i++) {
        const t = t0 + ((t1 - t0) * i) / PARAM_SAMPLES;
        const x = evalAt(curve.x_expr, t);
        const y = evalAt(curve.y_expr, t);
        if (x === null || y === null || x < xMin || x > xMax || y < yMin || y > yMax) {
          flush();
          continue;
        }
        current.push([x, y]);
      }
      flush();
      return { segments, label: curve.label ?? null };
    }

    let [d0, d1] = curve.domain;
    // Pull sampling just inside the domain where it touches a vertical asymptote.
    for (const vx of verticals) {
      if (Math.abs(d0 - vx) < eps) d0 = vx + eps;
      if (Math.abs(d1 - vx) < eps) d1 = vx - eps;
    }

    // Uniform grid plus every labelled point's x, so the polyline passes
    // through the exact extremum instead of a chord just missing it.
    const xs: number[] = [];
    for (let i = 0; i <= SAMPLES; i++) xs.push(d0 + ((d1 - d0) * i) / SAMPLES);
    for (const px of pointXs) {
      if (px > d0 && px < d1 && xs.every((x) => Math.abs(x - px) > eps * 1e-3)) xs.push(px);
    }
    xs.sort((a, b) => a - b);

    const segments: [number, number][][] = [];
    let current: [number, number][] = [];
    const flush = () => {
      if (current.length > 1) segments.push(current);
      current = [];
    };

    for (const x of xs) {
      // Break the segment when stepping across a declared vertical asymptote.
      const prev = current[current.length - 1];
      if (prev && verticals.some((vx) => (prev[0] - vx) * (x - vx) < 0)) flush();

      const y = curve.expr ? evalAt(curve.expr, x) : null;
      if (y === null || y < yMin || y > yMax) {
        flush();
        continue;
      }
      current.push([x, y]);
    }
    flush();

    return { segments, label: curve.label ?? null };
  });

  // Snap authored (often rounded) point coordinates onto the drawn curve so
  // dots sit exactly on the polyline; labels keep the human-readable values.
  const snapTolerance = (yMax - yMin) * SNAP_FRACTION;
  const xSnapTolerance = (xMax - xMin) * SNAP_FRACTION;
  const parametricVertices = curves
    .filter((_, i) => specCurves[i].x_expr && specCurves[i].y_expr)
    .flatMap((c) => c.segments.flat());
  const points = (spec.points ?? []).map((p) => {
    let best: number | null = null;
    for (const curve of specCurves) {
      if (!curve.expr || curve.x_expr) continue;
      if (p.x < curve.domain[0] || p.x > curve.domain[1]) continue;
      const y = evalAt(curve.expr, p.x);
      if (y === null) continue;
      if (best === null || Math.abs(y - p.y) < Math.abs(best - p.y)) best = y;
    }
    if (best !== null && Math.abs(best - p.y) <= snapTolerance) return { ...p, y: best };
    // No y = f(x) match — snap to the nearest sampled parametric vertex.
    let vertex: [number, number] | null = null;
    for (const [vx, vy] of parametricVertices) {
      if (Math.abs(vx - p.x) > xSnapTolerance || Math.abs(vy - p.y) > snapTolerance) continue;
      if (!vertex || Math.hypot(vx - p.x, vy - p.y) < Math.hypot(vertex[0] - p.x, vertex[1] - p.y)) {
        vertex = [vx, vy];
      }
    }
    return vertex ? { ...p, x: vertex[0], y: vertex[1] } : p;
  });

  // A shade compiles to a closed polygon: the curve sampled over its domain,
  // then back along the x-axis (clamped into y_range) to close the region.
  const shade = (spec.shade ?? []).flatMap((s) => {
    const [d0, d1] = s.domain;
    const baseline = Math.min(Math.max(0, yMin), yMax);
    const polygon: [number, number][] = [];
    for (let i = 0; i <= SAMPLES; i++) {
      const x = d0 + ((d1 - d0) * i) / SAMPLES;
      const y = evalAt(s.expr, x);
      if (y === null) continue;
      polygon.push([x, Math.min(Math.max(y, yMin), yMax)]);
    }
    if (polygon.length < 2) return [];
    polygon.push([d1, baseline], [d0, baseline]);
    return [{ polygon, label: s.label ?? null }];
  });

  return {
    part_label: partLabel,
    x_range: spec.x_range,
    y_range: spec.y_range,
    curves,
    asymptotes: (spec.asymptotes ?? [])
      .map((a) => compileAsymptote(a, spec.x_range))
      .filter((a): a is RenderedAsymptote => a !== null),
    points,
    segments: spec.segments ?? [],
    shade,
    x_label: spec.x_label ?? null,
    y_label: spec.y_label ?? null,
  };
}
