import type { GraphPoint, GraphSegment, RenderedAsymptote, SolutionGraphRender } from '../../types/api'
import { renderLatex } from '../../lib/renderLatex'

// Fixed drawing surface — the svg scales responsively but keeps this aspect,
// so HTML labels positioned by percentage line up with svg coordinates.
const W = 600
const H = 420
const PAD = 34

// Round a raw step to 1/2/5 × 10^k so axis ticks land on friendly values.
function niceStep(raw: number): number {
  const mag = 10 ** Math.floor(Math.log10(raw))
  const norm = raw / mag
  if (norm <= 1) return mag
  if (norm <= 2) return 2 * mag
  if (norm <= 5) return 5 * mag
  return 10 * mag
}

function ticks(min: number, max: number): number[] {
  const step = niceStep((max - min) / 8)
  const out: number[] = []
  for (let t = Math.ceil(min / step) * step; t <= max + 1e-9; t += step) {
    // Skip 0 — the axes already mark it and a "0" label would sit on them.
    if (Math.abs(t) > 1e-9) out.push(Number(t.toFixed(10)))
  }
  return out
}

export function SolutionGraph({ graph }: { graph: SolutionGraphRender }) {
  const [x0, x1] = graph.x_range
  const [y0, y1] = graph.y_range

  const sx = (x: number) => PAD + ((x - x0) / (x1 - x0)) * (W - 2 * PAD)
  const sy = (y: number) => H - PAD - ((y - y0) / (y1 - y0)) * (H - 2 * PAD)

  const xAxisY = y0 <= 0 && y1 >= 0 ? sy(0) : sy(y0)
  const yAxisX = x0 <= 0 && x1 >= 0 ? sx(0) : sx(x0)

  const path = (seg: [number, number][]) =>
    seg.map(([x, y], i) => `${i === 0 ? 'M' : 'L'}${sx(x).toFixed(2)} ${sy(y).toFixed(2)}`).join(' ')

  const labelPos = (x: number, y: number) => ({
    left: `${(sx(x) / W) * 100}%`,
    top: `${(sy(y) / H) * 100}%`,
  })

  const asymptoteEnd = (a: RenderedAsymptote): { x: number; y: number } | null => {
    if (a.kind === 'vertical' && a.x !== undefined) return { x: a.x, y: y1 }
    const end = a.points?.[1]
    return end ? { x: end[0], y: end[1] } : null
  }

  const pointLabelShift = (p: GraphPoint) =>
    p.kind === 'min' ? 'translate(-50%, 30%)' : 'translate(-50%, -130%)'

  // Arrowhead triangle at the `to` end of a segment, aligned to its direction.
  const segmentArrow = (s: GraphSegment) => {
    const dx = sx(s.to[0]) - sx(s.from[0])
    const dy = sy(s.to[1]) - sy(s.from[1])
    const len = Math.hypot(dx, dy) || 1
    const [ux, uy] = [dx / len, dy / len]
    const [tipX, tipY] = [sx(s.to[0]), sy(s.to[1])]
    const [baseX, baseY] = [tipX - 10 * ux, tipY - 10 * uy]
    return `M${tipX} ${tipY} L${baseX - 4 * uy} ${baseY + 4 * ux} L${baseX + 4 * uy} ${baseY - 4 * ux} z`
  }

  const shadeCentroid = (polygon: [number, number][]) => {
    const cx = polygon.reduce((acc, [x]) => acc + x, 0) / polygon.length
    const cy = polygon.reduce((acc, [, y]) => acc + y, 0) / polygon.length
    return { x: cx, y: cy }
  }

  return (
    <div className="relative w-full max-w-2xl">
      <svg viewBox={`0 0 ${W} ${H}`} className="w-full h-auto select-none" role="img">
        {/* axes */}
        <line
          x1={PAD / 2} y1={xAxisY} x2={W - PAD / 2} y2={xAxisY}
          className="stroke-slate-400 dark:stroke-slate-500" strokeWidth={1.2}
        />
        <line
          x1={yAxisX} y1={H - PAD / 2} x2={yAxisX} y2={PAD / 2}
          className="stroke-slate-400 dark:stroke-slate-500" strokeWidth={1.2}
        />
        {/* arrowheads */}
        <path d={`M${W - PAD / 2} ${xAxisY} l-8 -4 v8 z`} className="fill-slate-400 dark:fill-slate-500" />
        <path d={`M${yAxisX} ${PAD / 2} l-4 8 h8 z`} className="fill-slate-400 dark:fill-slate-500" />

        {/* ticks */}
        {ticks(x0, x1).map((t) => (
          <g key={`xt${t}`}>
            <line x1={sx(t)} y1={xAxisY - 3} x2={sx(t)} y2={xAxisY + 3} className="stroke-slate-400 dark:stroke-slate-500" strokeWidth={1} />
            <text x={sx(t)} y={xAxisY + 14} textAnchor="middle" className="fill-slate-500 dark:fill-slate-400 text-[10px]">
              {t}
            </text>
          </g>
        ))}
        {ticks(y0, y1).map((t) => (
          <g key={`yt${t}`}>
            <line x1={yAxisX - 3} y1={sy(t)} x2={yAxisX + 3} y2={sy(t)} className="stroke-slate-400 dark:stroke-slate-500" strokeWidth={1} />
            <text x={yAxisX - 6} y={sy(t) + 3} textAnchor="end" className="fill-slate-500 dark:fill-slate-400 text-[10px]">
              {t}
            </text>
          </g>
        ))}

        {/* shaded regions — beneath everything else */}
        {graph.shade.map((s, i) => (
          <path
            key={`sh${i}`}
            d={`${path(s.polygon)} Z`}
            className="fill-blue-500/15 dark:fill-blue-400/15"
            stroke="none"
          />
        ))}

        {/* asymptotes */}
        {graph.asymptotes.map((a, i) =>
          a.kind === 'vertical' && a.x !== undefined ? (
            <line
              key={i}
              x1={sx(a.x)} y1={PAD / 2} x2={sx(a.x)} y2={H - PAD / 2}
              className="stroke-rose-400 dark:stroke-rose-500" strokeWidth={1.2} strokeDasharray="6 4"
            />
          ) : a.points ? (
            <line
              key={i}
              x1={sx(a.points[0][0])} y1={sy(a.points[0][1])}
              x2={sx(a.points[1][0])} y2={sy(a.points[1][1])}
              className="stroke-rose-400 dark:stroke-rose-500" strokeWidth={1.2} strokeDasharray="6 4"
            />
          ) : null,
        )}

        {/* curves */}
        {graph.curves.flatMap((c, i) =>
          c.segments.map((seg, j) => (
            <path
              key={`c${i}s${j}`}
              d={path(seg)}
              fill="none"
              className="stroke-blue-600 dark:stroke-blue-400"
              strokeWidth={2}
              strokeLinejoin="round"
            />
          )),
        )}

        {/* straight segments (Argand/vector diagrams, overlay lines) */}
        {graph.segments.map((s, i) => (
          <g key={`sg${i}`}>
            <line
              x1={sx(s.from[0])} y1={sy(s.from[1])} x2={sx(s.to[0])} y2={sy(s.to[1])}
              className="stroke-blue-600 dark:stroke-blue-400"
              strokeWidth={2}
              strokeDasharray={s.style === 'dashed' ? '6 4' : undefined}
            />
            {s.arrow && <path d={segmentArrow(s)} className="fill-blue-600 dark:fill-blue-400" />}
          </g>
        ))}

        {/* labelled points */}
        {graph.points.map((p, i) =>
          p.open ? (
            <circle
              key={i} cx={sx(p.x)} cy={sy(p.y)} r={4}
              className="fill-white dark:fill-slate-900 stroke-slate-900 dark:stroke-white"
              strokeWidth={2}
            />
          ) : (
            <circle key={i} cx={sx(p.x)} cy={sy(p.y)} r={4} className="fill-slate-900 dark:fill-white" />
          ),
        )}
      </svg>

      {/* KaTeX labels overlaid in HTML so they typeset like the rest of the app */}
      {graph.x_label && (
        <div
          className="absolute text-xs text-slate-500 dark:text-slate-400 whitespace-nowrap pointer-events-none"
          style={{ left: `${((W - PAD / 2) / W) * 100}%`, top: `${(xAxisY / H) * 100}%`, transform: 'translate(-100%, 40%)' }}
        >
          {renderLatex(`\\(${graph.x_label}\\)`)}
        </div>
      )}
      {graph.y_label && (
        <div
          className="absolute text-xs text-slate-500 dark:text-slate-400 whitespace-nowrap pointer-events-none"
          style={{ left: `${(yAxisX / W) * 100}%`, top: `${(PAD / 2 / H) * 100}%`, transform: 'translate(40%, -30%)' }}
        >
          {renderLatex(`\\(${graph.y_label}\\)`)}
        </div>
      )}
      {graph.segments.map(
        (s, i) =>
          s.label && (
            <div
              key={`sgl${i}`}
              className="absolute text-xs text-blue-600 dark:text-blue-400 whitespace-nowrap pointer-events-none"
              style={{
                ...labelPos((s.from[0] + s.to[0]) / 2, (s.from[1] + s.to[1]) / 2),
                transform: 'translate(-50%, -130%)',
              }}
            >
              {renderLatex(`\\(${s.label}\\)`)}
            </div>
          ),
      )}
      {graph.shade.map((s, i) => {
        if (!s.label) return null
        const c = shadeCentroid(s.polygon)
        return (
          <div
            key={`shl${i}`}
            className="absolute text-xs text-slate-700 dark:text-slate-200 whitespace-nowrap pointer-events-none"
            style={{ ...labelPos(c.x, c.y), transform: 'translate(-50%, -50%)' }}
          >
            {renderLatex(`\\(${s.label}\\)`)}
          </div>
        )
      })}
      {graph.points.map(
        (p, i) =>
          p.label && (
            <div
              key={`pl${i}`}
              className="absolute text-xs text-slate-700 dark:text-slate-200 whitespace-nowrap pointer-events-none"
              style={{ ...labelPos(p.x, p.y), transform: pointLabelShift(p) }}
            >
              {renderLatex(`\\(${p.label}\\)`)}
            </div>
          ),
      )}
      {graph.asymptotes.map((a, i) => {
        const end = asymptoteEnd(a)
        return (
          a.label &&
          end && (
            <div
              key={`al${i}`}
              className="absolute text-xs text-rose-500 dark:text-rose-400 whitespace-nowrap pointer-events-none"
              style={{ ...labelPos(end.x, end.y), transform: 'translate(-110%, -10%)' }}
            >
              {renderLatex(`\\(${a.label}\\)`)}
            </div>
          )
        )
      })}
      {graph.curves.map((c, i) => {
        const seg = c.segments[c.segments.length - 1]
        const end = seg?.[seg.length - 1]
        return (
          c.label &&
          end && (
            <div
              key={`cl${i}`}
              className="absolute text-xs text-blue-600 dark:text-blue-400 whitespace-nowrap pointer-events-none"
              style={{ ...labelPos(end[0], end[1]), transform: 'translate(-100%, -140%)' }}
            >
              {renderLatex(`\\(${c.label}\\)`)}
            </div>
          )
        )
      })}
    </div>
  )
}
