import { useRef, useState, useEffect } from 'react'
import type { CSSProperties } from 'react'
import type { Topic } from '../../types/api'
import { cn } from '../../lib/utils'

const NODE_W = 210
const NODE_H = 100
const CANVAS_W = 2200
const CANVAS_H = 1700

// Section accents — nodes are coloured by which tree they belong to (Pure Math
// vs Statistics), not by status. Status stays legible via icon + label + glow.
interface Accent { main: string; second: string; glow: string; label: string }
const PURE_MATH_ACCENT: Accent = {
  main: '#38bdf8', second: '#0ea5e9',
  glow: '0 0 0 4px rgba(56,189,248,.12),0 18px 40px -20px rgba(14,165,233,.7)',
  label: '#bae6fd',
}
const STATS_ACCENT: Accent = {
  main: '#34d399', second: '#10b981',
  glow: '0 0 0 4px rgba(52,211,153,.12),0 18px 40px -20px rgba(16,185,129,.6)',
  label: '#a7f3d0',
}

// Centre the initial view on the Pure Math tree (trunk ~660, branches 200→1500).
const PURE_MATH_CENTER_X = 800

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

// Each node echoes the landing-page roadmap cards: a dark card with an icon
// tile, a thin progress bar and a status label. Status is derived from real
// per-topic progress — no topic is ever hidden or removed.
type Status = 'completed' | 'progress' | 'upnext' | 'locked'

interface StatusStyle {
  card: CSSProperties
  tile: CSSProperties
  icon: string
  iconColor: string
  title: string
  sub: string
  track: string
  fill: CSSProperties | null
  label: string
  labelColor: string
  pctColor: string
}

function statusOf(topic: Topic | null, p: { correct: number; total: number }): Status {
  if (!topic) return 'locked'
  if (p.total > 0 && p.correct >= p.total) return 'completed'
  if (p.correct > 0) return 'progress'
  return 'upnext'
}

function styleFor(status: Status, accent: Accent): StatusStyle {
  switch (status) {
    case 'completed':
      return {
        card: { background: '#12152b', border: `1px solid ${accent.main}66`, boxShadow: accent.glow },
        tile: { background: `linear-gradient(135deg,${accent.main},${accent.second})` },
        icon: '✓', iconColor: '#ffffff',
        title: '#ffffff', sub: '#7e84ad',
        track: '#222742', fill: { background: accent.second },
        label: 'Completed', labelColor: accent.label, pctColor: '#7e84ad',
      }
    case 'progress':
      return {
        card: { background: '#161a33', border: `1.5px solid ${accent.main}`, boxShadow: accent.glow },
        tile: { background: `linear-gradient(135deg,${accent.main},${accent.second})` },
        icon: '▸', iconColor: '#ffffff',
        title: '#ffffff', sub: '#aab0e6',
        track: '#222742', fill: { background: `linear-gradient(90deg,${accent.main},${accent.second})` },
        label: 'In progress', labelColor: accent.label, pctColor: '#aab0e6',
      }
    case 'upnext':
      return {
        card: { background: '#12152b', border: '1px solid #2a3160' },
        tile: { background: '#1b2042', border: '1px solid #2f3666' },
        icon: '▸', iconColor: '#aab0e6',
        title: '#e7e9f7', sub: '#7e84ad',
        track: '#222742', fill: { background: '#3a4170' },
        label: 'Up next', labelColor: '#aab0d6', pctColor: '#7e84ad',
      }
    case 'locked':
      return {
        card: { background: '#10132a', border: '1px solid #232850', opacity: 0.62 },
        tile: { background: '#161a33', border: '1px solid #262b4d' },
        icon: '⌧', iconColor: '#5b6090',
        title: '#bcc1e0', sub: '#6a6f99',
        track: '#1c2138', fill: null,
        label: 'Locked', labelColor: '#6a6f99', pctColor: '#54597e',
      }
  }
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
  progress: Map<string, { correct: number; total: number }>
  onTopicClick: (topic: Topic) => void
}

export function RoadmapGraph({ topics, progress, onTopicClick }: Props) {
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
    applyT({ x: el.clientWidth / 2 - PURE_MATH_CENTER_X, y: 40, scale: 1 })
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
      style={{
        touchAction: 'none',
        backgroundColor: '#0b0e20',
        backgroundImage:
          'radial-gradient(700px 420px at 50% -5%, rgba(99,102,241,.18), transparent 70%),' +
          'linear-gradient(rgba(255,255,255,.035) 1px, transparent 1px),' +
          'linear-gradient(90deg, rgba(255,255,255,.035) 1px, transparent 1px)',
        backgroundSize: '100% 100%, 46px 46px, 46px 46px',
      }}
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
      <style>{`.rm-node{transition:transform .15s, box-shadow .15s}.rm-node:hover{transform:translateY(-3px)}`}</style>
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
          className="absolute pointer-events-none text-[11px] font-bold uppercase tracking-widest"
          style={{ left: 50, top: 22, width: 1600, textAlign: 'center', color: '#a5abe0' }}
        >
          Pure Mathematics
        </div>
        <div
          className="absolute pointer-events-none text-[11px] font-bold uppercase tracking-widest"
          style={{ left: 1905, top: 22, width: NODE_W, textAlign: 'center', color: '#34d399' }}
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
              <path d="M1,1 L7,4 L1,7 Z" fill="#3a4170" />
            </marker>
          </defs>
          {resolvedEdges.map((e) => (
            <path
              key={e.id}
              d={edgePath(e.sx, e.sy, e.tx, e.ty)}
              fill="none"
              stroke="#2a3160"
              strokeWidth="2"
              markerEnd="url(#arrowhead)"
            />
          ))}
        </svg>

        {/* Node cards — styled like the landing-page roadmap cards */}
        {nodes.map(({ name, pos, topic }) => {
          const p = topic ? (progress.get(topic.id) ?? { correct: 0, total: 0 }) : { correct: 0, total: 0 }
          const status = statusOf(topic, p)
          const accent = pos.color === 'emerald' ? STATS_ACCENT : PURE_MATH_ACCENT
          const s = styleFor(status, accent)
          const pct = p.total > 0 ? Math.round((p.correct / p.total) * 100) : 0
          const barWidth = status === 'completed' ? 100 : pct

          return (
            <button
              key={name}
              disabled={!topic}
              onClick={() => { if (!didPan.current && topic) onTopicClick(topic) }}
              className={cn('rm-node absolute flex flex-col justify-center rounded-2xl text-left', topic ? 'cursor-pointer' : 'cursor-not-allowed')}
              style={{
                left: pos.cx - NODE_W / 2,
                top: pos.cy - NODE_H / 2,
                width: NODE_W,
                height: NODE_H,
                padding: '12px 14px',
                ...s.card,
              }}
            >
              {/* header row: icon tile + title + question count */}
              <div className="flex items-center gap-3">
                <div
                  className="flex-none flex items-center justify-center rounded-[10px]"
                  style={{ width: 32, height: 32, color: s.iconColor, fontSize: 15, ...s.tile }}
                >
                  {s.icon}
                </div>
                <div className="flex-1 min-w-0">
                  <div
                    className="font-bold leading-tight"
                    style={{
                      color: s.title,
                      fontSize: 12.5,
                      display: '-webkit-box',
                      WebkitLineClamp: 2,
                      WebkitBoxOrient: 'vertical',
                      overflow: 'hidden',
                    }}
                  >
                    {name}
                  </div>
                  <div className="mt-0.5" style={{ color: s.sub, fontSize: 10 }}>
                    {topic ? `${p.total} question${p.total === 1 ? '' : 's'}` : 'Coming soon'}
                  </div>
                </div>
              </div>

              {/* progress bar + status row */}
              {status !== 'locked' && (
                <>
                  <div
                    className="mt-2 overflow-hidden"
                    style={{ height: 6, borderRadius: 99, background: s.track }}
                  >
                    {s.fill && (
                      <div style={{ height: '100%', width: `${barWidth}%`, borderRadius: 99, ...s.fill }} />
                    )}
                  </div>
                  <div className="flex items-center justify-between mt-1.5" style={{ fontSize: 10 }}>
                    <span className="font-bold" style={{ color: s.labelColor }}>{s.label}</span>
                    <span className="tabular-nums" style={{ color: s.pctColor }}>{barWidth}%</span>
                  </div>
                </>
              )}
            </button>
          )
        })}
      </div>
    </div>
  )
}
