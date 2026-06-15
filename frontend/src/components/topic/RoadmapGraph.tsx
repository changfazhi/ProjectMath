import { useRef, useState, useEffect } from 'react'
import type { Topic } from '../../types/api'
import { cn } from '../../lib/utils'
import { ProgressBar } from '../ui/ProgressBar'

const NODE_W = 190
const NODE_H = 72
const CANVAS_W = 2200
const CANVAS_H = 1700

// cx/cy = centre of each node
const POSITIONS: Record<string, { cx: number; cy: number; color: string }> = {
  // ── Trunk ─────────────────────────────────────────────────────────────────
  'Graphing Techniques':            { cx:  660, cy:   90, color: 'violet' },
  'Functions':                      { cx:  660, cy:  210, color: 'violet' },
  'Transformation':                 { cx:  660, cy:  330, color: 'violet' },
  'Conics':                         { cx:  660, cy:  450, color: 'violet' },
  'Inequalities':                   { cx:  660, cy:  570, color: 'violet' },
  'Systems of Linear Equations':    { cx:  660, cy:  690, color: 'indigo' },
  // ── Left branch — Sequences & Series ──────────────────────────────────────
  'Sequences & Series':             { cx:  200, cy:  840, color: 'indigo' },
  // ── Centre branch — Vectors ────────────────────────────────────────────────
  'Vector (Basic)':                 { cx:  580, cy:  840, color: 'blue'   },
  'Vector (Lines)':                 { cx:  580, cy:  960, color: 'blue'   },
  'Vector (Plane)':                 { cx:  580, cy: 1080, color: 'blue'   },
  // ── Right branch — Calculus ────────────────────────────────────────────────
  'Differentiation Technique':      { cx: 1160, cy:  840, color: 'sky'    },
  'Application of Differentiation': { cx:  940, cy:  960, color: 'sky'    },
  'Maclaurin Series':               { cx: 1160, cy:  960, color: 'sky'    },
  'Integration Technique':          { cx: 1380, cy:  960, color: 'sky'    },
  'Definite Integral':              { cx: 1060, cy: 1080, color: 'sky'    },
  'Parametric Equations':           { cx: 1280, cy: 1080, color: 'sky'    },
  'Differential Equations':         { cx: 1500, cy: 1080, color: 'sky'    },
  // ── Convergence node ──────────────────────────────────────────────────────
  'Complex Number':                 { cx:  660, cy: 1440, color: 'indigo' },
  // ── Statistics — independent tree ─────────────────────────────────────────
  'Permutation and Combination':       { cx: 2000, cy:   90, color: 'emerald' },
  'Probability':                       { cx: 2000, cy:  210, color: 'emerald' },
  'Discrete Random Variable':          { cx: 2000, cy:  330, color: 'emerald' },
  'Binomial Distribution':             { cx: 2000, cy:  450, color: 'emerald' },
  'Normal Distribution':               { cx: 2000, cy:  570, color: 'emerald' },
  'Sampling and Estimation Theory':    { cx: 2000, cy:  690, color: 'emerald' },
  'Hypothesis Testing':                { cx: 2000, cy:  810, color: 'emerald' },
  'Correlation and Linear Regression': { cx: 2000, cy:  930, color: 'emerald' },
}

const EDGES: [string, string][] = [
  // Trunk
  ['Graphing Techniques',         'Functions'],
  ['Functions',                   'Transformation'],
  ['Transformation',              'Conics'],
  ['Conics',                      'Inequalities'],
  ['Inequalities',                'Systems of Linear Equations'],
  // Split into 3 branches
  ['Systems of Linear Equations', 'Sequences & Series'],
  ['Systems of Linear Equations', 'Vector (Basic)'],
  ['Systems of Linear Equations', 'Differentiation Technique'],
  // Left branch → merge
  ['Sequences & Series',          'Complex Number'],
  // Centre branch
  ['Vector (Basic)',              'Vector (Lines)'],
  ['Vector (Lines)',              'Vector (Plane)'],
  ['Vector (Plane)',              'Complex Number'],
  // Right branch — internal
  ['Differentiation Technique',   'Application of Differentiation'],
  ['Differentiation Technique',   'Maclaurin Series'],
  ['Differentiation Technique',   'Integration Technique'],
  ['Integration Technique',       'Definite Integral'],
  ['Integration Technique',       'Parametric Equations'],
  ['Integration Technique',       'Differential Equations'],
  // Right branch — all leaves → merge
  ['Application of Differentiation', 'Complex Number'],
  ['Maclaurin Series',               'Complex Number'],
  ['Definite Integral',              'Complex Number'],
  ['Parametric Equations',           'Complex Number'],
  ['Differential Equations',         'Complex Number'],
  // Statistics chain
  ['Permutation and Combination',    'Probability'],
  ['Probability',                    'Discrete Random Variable'],
  ['Discrete Random Variable',       'Binomial Distribution'],
  ['Binomial Distribution',          'Normal Distribution'],
  ['Normal Distribution',            'Sampling and Estimation Theory'],
  ['Sampling and Estimation Theory', 'Hypothesis Testing'],
  ['Hypothesis Testing',             'Correlation and Linear Regression'],
]

type Color = 'violet' | 'blue' | 'sky' | 'indigo' | 'emerald'

const colorMap: Record<Color, { border: string; bg: string; text: string; badge: string; visited: string; fill: string }> = {
  violet:  { border: 'border-violet-400 dark:border-violet-600',   bg: 'bg-violet-50 dark:bg-violet-950/60',   text: 'text-violet-900 dark:text-violet-100',   badge: 'bg-violet-100 text-violet-700 dark:bg-violet-900/60 dark:text-violet-300',   visited: 'ring-violet-400',  fill: 'bg-violet-500'  },
  blue:    { border: 'border-blue-400 dark:border-blue-600',       bg: 'bg-blue-50 dark:bg-blue-950/60',       text: 'text-blue-900 dark:text-blue-100',       badge: 'bg-blue-100 text-blue-700 dark:bg-blue-900/60 dark:text-blue-300',       visited: 'ring-blue-400',    fill: 'bg-blue-500'    },
  sky:     { border: 'border-sky-400 dark:border-sky-600',         bg: 'bg-sky-50 dark:bg-sky-950/60',         text: 'text-sky-900 dark:text-sky-100',         badge: 'bg-sky-100 text-sky-700 dark:bg-sky-900/60 dark:text-sky-300',         visited: 'ring-sky-400',     fill: 'bg-sky-500'     },
  indigo:  { border: 'border-indigo-400 dark:border-indigo-600',   bg: 'bg-indigo-50 dark:bg-indigo-950/60',   text: 'text-indigo-900 dark:text-indigo-100',   badge: 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/60 dark:text-indigo-300',   visited: 'ring-indigo-400',  fill: 'bg-indigo-500'  },
  emerald: { border: 'border-emerald-400 dark:border-emerald-600', bg: 'bg-emerald-50 dark:bg-emerald-950/60', text: 'text-emerald-900 dark:text-emerald-100', badge: 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/60 dark:text-emerald-300', visited: 'ring-emerald-400', fill: 'bg-emerald-500' },
}

// Cubic Bezier that exits the source node straight down and enters the target straight down.
// Handles both straight drops and wide horizontal sweeps gracefully.
function edgePath(sx: number, sy: number, tx: number, ty: number): string {
  const dy = ty - sy
  const cp1y = sy + dy * 0.5
  const cp2y = ty - dy * 0.5
  return `M ${sx} ${sy} C ${sx} ${cp1y} ${tx} ${cp2y} ${tx} ${ty}`
}

interface Transform { x: number; y: number; scale: number }

interface Props {
  topics: Topic[]
  visited: Set<string>
  progress: Map<string, { correct: number; total: number }>
  onTopicClick: (topic: Topic) => void
}

export function RoadmapGraph({ topics, visited, progress, onTopicClick }: Props) {
  const containerRef = useRef<HTMLDivElement>(null)

  // Single source of truth — mirrored in a ref so event handlers never read stale values
  const [t, setT] = useState<Transform>({ x: 0, y: 40, scale: 1 })
  const tRef = useRef<Transform>(t)
  const applyT = (next: Transform) => { tRef.current = next; setT(next) }

  const [isPanning, setIsPanning] = useState(false)
  const panStart = useRef<{ mx: number; my: number; ox: number; oy: number } | null>(null)
  const didPan = useRef(false)

  // Centre the canvas on first render
  useEffect(() => {
    const el = containerRef.current
    if (!el) return
    applyT({ x: Math.max(0, (el.clientWidth - CANVAS_W) / 2), y: 40, scale: 1 })
  }, [])

  // Wheel → zoom toward cursor (must be non-passive to call e.preventDefault())
  useEffect(() => {
    const el = containerRef.current
    if (!el) return
    const onWheel = (e: WheelEvent) => {
      e.preventDefault()
      const { x, y, scale } = tRef.current
      const factor = e.deltaY < 0 ? 1.1 : 1 / 1.1
      const newScale = Math.min(2, Math.max(0.2, scale * factor))
      const rect = el.getBoundingClientRect()
      const mx = e.clientX - rect.left
      const my = e.clientY - rect.top
      applyT({
        scale: newScale,
        x: mx - (mx - x) * (newScale / scale),
        y: my - (my - y) * (newScale / scale),
      })
    }
    el.addEventListener('wheel', onWheel, { passive: false })
    return () => el.removeEventListener('wheel', onWheel)
  }, [])

  // Non-passive touchmove → prevent page scroll while panning on mobile
  useEffect(() => {
    const el = containerRef.current
    if (!el) return
    const prevent = (e: TouchEvent) => { if (panStart.current) e.preventDefault() }
    el.addEventListener('touchmove', prevent, { passive: false })
    return () => el.removeEventListener('touchmove', prevent)
  }, [])

  // ── Derived data ───────────────────────────────────────────────────────────
  const topicMap = new Map(topics.map((tp) => [tp.name, tp]))

  const nodes = Object.entries(POSITIONS).map(([name, pos]) => ({
    name,
    pos,
    topic: topicMap.get(name) ?? null,
  }))

  const resolvedEdges = EDGES.map(([src, tgt]) => {
    const s = POSITIONS[src]
    const d = POSITIONS[tgt]
    if (!s || !d) return null
    return { id: `${src}→${tgt}`, sx: s.cx, sy: s.cy + NODE_H / 2, tx: d.cx, ty: d.cy - NODE_H / 2 }
  }).filter(Boolean) as { id: string; sx: number; sy: number; tx: number; ty: number }[]

  // ── Render ─────────────────────────────────────────────────────────────────
  return (
    <div
      ref={containerRef}
      style={{ touchAction: 'none' }}
      className={cn('w-full h-full overflow-hidden', isPanning ? 'cursor-grabbing' : 'cursor-grab')}
      onMouseDown={(e) => {
        const { x, y } = tRef.current
        panStart.current = { mx: e.clientX, my: e.clientY, ox: x, oy: y }
        didPan.current = false
        setIsPanning(true)
      }}
      onMouseMove={(e) => {
        if (!panStart.current) return
        const dx = e.clientX - panStart.current.mx
        const dy = e.clientY - panStart.current.my
        if (Math.abs(dx) > 3 || Math.abs(dy) > 3) didPan.current = true
        applyT({ ...tRef.current, x: panStart.current.ox + dx, y: panStart.current.oy + dy })
      }}
      onMouseUp={() => { panStart.current = null; setIsPanning(false) }}
      onMouseLeave={() => { panStart.current = null; setIsPanning(false) }}
      onTouchStart={(e) => {
        const touch = e.touches[0]
        const { x, y } = tRef.current
        panStart.current = { mx: touch.clientX, my: touch.clientY, ox: x, oy: y }
        didPan.current = false
      }}
      onTouchMove={(e) => {
        if (!panStart.current) return
        const touch = e.touches[0]
        const dx = touch.clientX - panStart.current.mx
        const dy = touch.clientY - panStart.current.my
        if (Math.abs(dx) > 3 || Math.abs(dy) > 3) didPan.current = true
        applyT({ ...tRef.current, x: panStart.current.ox + dx, y: panStart.current.oy + dy })
      }}
      onTouchEnd={() => { panStart.current = null }}
    >
      {/* Canvas — translate then scale from its own top-left origin */}
      <div
        style={{
          width: CANVAS_W,
          height: CANVAS_H,
          transform: `translate(${t.x}px, ${t.y}px) scale(${t.scale})`,
          transformOrigin: '0 0',
          position: 'relative',
          willChange: 'transform',
        }}
      >
        {/* Section labels */}
        <div
          className="absolute pointer-events-none text-[10px] font-semibold uppercase tracking-widest text-violet-500 dark:text-violet-400"
          style={{ left: 50, top: 22, width: 1600, textAlign: 'center' }}
        >
          Pure Mathematics
        </div>
        <div
          className="absolute pointer-events-none text-[10px] font-semibold uppercase tracking-widest text-emerald-600 dark:text-emerald-400"
          style={{ left: 1905, top: 22, width: NODE_W, textAlign: 'center' }}
        >
          Statistics
        </div>

        {/* SVG edge layer */}
        <svg
          className="absolute inset-0 pointer-events-none"
          width={CANVAS_W}
          height={CANVAS_H}
          viewBox={`0 0 ${CANVAS_W} ${CANVAS_H}`}
        >
          <defs>
            <marker id="arrowhead" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto">
              <path d="M1,1 L7,4 L1,7 Z" className="fill-slate-300 dark:fill-slate-600" />
            </marker>
          </defs>
          {resolvedEdges.map((e) => (
            <path
              key={e.id}
              d={edgePath(e.sx, e.sy, e.tx, e.ty)}
              fill="none"
              stroke="currentColor"
              strokeWidth="2"
              className="text-slate-300 dark:text-slate-600"
              markerEnd="url(#arrowhead)"
            />
          ))}
        </svg>

        {/* Node cards */}
        {nodes.map(({ name, pos, topic }) => {
          const color = pos.color as Color
          const c = colorMap[color]
          const isVisited = topic ? visited.has(topic.id) : false
          const p = topic ? (progress.get(topic.id) ?? { correct: 0, total: 0 }) : { correct: 0, total: 0 }

          return (
            <button
              key={name}
              disabled={!topic}
              onClick={() => { if (!didPan.current && topic) onTopicClick(topic) }}
              style={{
                left: pos.cx - NODE_W / 2,
                top: pos.cy - NODE_H / 2,
                width: NODE_W,
                height: NODE_H,
              }}
              className={cn(
                'absolute flex flex-col justify-center px-5 rounded-2xl border-2 shadow-sm transition-all duration-150 text-center',
                c.bg, c.border,
                topic
                  ? 'cursor-pointer hover:shadow-lg hover:scale-105 focus-visible:outline-none focus-visible:ring-2'
                  : 'opacity-40 cursor-not-allowed',
                isVisited && `ring-2 ring-offset-2 dark:ring-offset-slate-950 ${c.visited}`,
              )}
            >
              <span className={cn('text-sm font-semibold leading-tight', c.text)}>
                {name}
              </span>
              <div className="flex items-center gap-1.5 mt-1.5">
                {topic && (
                  <span className={cn('text-[10px] font-medium px-1.5 py-0.5 rounded-md shrink-0', c.badge)}>
                    {topic.level}
                  </span>
                )}
                {topic && (
                  <>
                    <div className="flex-1 min-w-0">
                      <ProgressBar correct={p.correct} total={p.total} fillClass={c.fill} size="sm" />
                    </div>
                    <span className="text-[10px] text-slate-500 dark:text-slate-400 shrink-0 tabular-nums">
                      {p.correct}/{p.total}
                    </span>
                  </>
                )}
              </div>
            </button>
          )
        })}
      </div>
    </div>
  )
}
