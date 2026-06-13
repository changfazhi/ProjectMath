import type { Topic } from '../../types/api'
import { cn } from '../../lib/utils'

// ---------- layout config ----------

const NODE_W = 176
const NODE_H = 72
const CANVAS_W = 1020
const CANVAS_H = 700

// cx/cy is the centre of each node
const POSITIONS: Record<string, { cx: number; cy: number; color: string }> = {
  // Column A — Pure Math part 1 (violet)
  'Graphing Techniques':            { cx: 100, cy:  60, color: 'violet' },
  'Functions':                      { cx: 100, cy: 170, color: 'violet' },
  'Transformation':                 { cx: 100, cy: 280, color: 'violet' },
  'Conics':                         { cx: 100, cy: 390, color: 'violet' },
  'Inequalities':                   { cx: 100, cy: 500, color: 'violet' },
  'Systems of Linear Equations':    { cx: 100, cy: 610, color: 'violet' },
  // Column B — Pure Math part 2 (indigo)
  'Sequences & Series':             { cx: 340, cy:  60, color: 'indigo' },
  'Vector (Basic)':                 { cx: 340, cy: 170, color: 'indigo' },
  'Vector (Lines)':                 { cx: 340, cy: 280, color: 'indigo' },
  'Vector (Plane)':                 { cx: 340, cy: 390, color: 'indigo' },
  'Complex Number':                 { cx: 340, cy: 500, color: 'indigo' },
  'Differentiation Technique':      { cx: 340, cy: 610, color: 'indigo' },
  // Column C — Pure Math part 3 (sky)
  'Application of Differentiation': { cx: 580, cy:  60, color: 'sky' },
  'Maclaurin Series':               { cx: 580, cy: 170, color: 'sky' },
  'Integration Technique':          { cx: 580, cy: 280, color: 'sky' },
  'Definite Integral':              { cx: 580, cy: 390, color: 'sky' },
  'Parametric Equations':           { cx: 580, cy: 500, color: 'sky' },
  'Differential Equations':         { cx: 580, cy: 610, color: 'sky' },
  // Column D — Statistics (emerald, isolated)
  'Permutation and Combination':    { cx: 870, cy:  60, color: 'emerald' },
  'Probability':                    { cx: 870, cy: 170, color: 'emerald' },
  'Discrete Random Variable':       { cx: 870, cy: 280, color: 'emerald' },
  'Sampling and Estimation Theory': { cx: 870, cy: 390, color: 'emerald' },
  'Hypothesis Testing':             { cx: 870, cy: 500, color: 'emerald' },
  'Correlation and Linear Regression': { cx: 870, cy: 610, color: 'emerald' },
}

// Directed prerequisite edges: [source, target]
const EDGES: [string, string][] = [
  // Column A — vertical chain
  ['Graphing Techniques',         'Functions'],
  ['Functions',                   'Transformation'],
  ['Transformation',              'Conics'],
  ['Conics',                      'Inequalities'],
  ['Inequalities',                'Systems of Linear Equations'],
  // Snake: Col A bottom → Col B top (long S-curve)
  ['Systems of Linear Equations', 'Sequences & Series'],
  // Column B — vertical chain
  ['Sequences & Series',          'Vector (Basic)'],
  ['Vector (Basic)',              'Vector (Lines)'],
  ['Vector (Lines)',              'Vector (Plane)'],
  ['Vector (Plane)',              'Complex Number'],
  ['Complex Number',              'Differentiation Technique'],
  // Snake: Col B bottom → Col C top (long S-curve)
  ['Differentiation Technique',   'Application of Differentiation'],
  // Column C — vertical chain
  ['Application of Differentiation', 'Maclaurin Series'],
  ['Maclaurin Series',            'Integration Technique'],
  ['Integration Technique',       'Definite Integral'],
  ['Definite Integral',           'Parametric Equations'],
  ['Parametric Equations',        'Differential Equations'],
  // Column D — statistics vertical chain (independent tree)
  ['Permutation and Combination', 'Probability'],
  ['Probability',                 'Discrete Random Variable'],
  ['Discrete Random Variable',    'Sampling and Estimation Theory'],
  ['Sampling and Estimation Theory', 'Hypothesis Testing'],
  ['Hypothesis Testing',          'Correlation and Linear Regression'],
]

// ---------- color maps ----------

type Color = 'violet' | 'blue' | 'sky' | 'indigo' | 'emerald'

const colorMap: Record<Color, { border: string; bg: string; text: string; badge: string; visited: string }> = {
  violet:  { border: 'border-violet-400 dark:border-violet-600',  bg: 'bg-violet-50 dark:bg-violet-950/60',  text: 'text-violet-900 dark:text-violet-100',  badge: 'bg-violet-100 text-violet-700 dark:bg-violet-900/60 dark:text-violet-300',  visited: 'ring-violet-400' },
  blue:    { border: 'border-blue-400 dark:border-blue-600',      bg: 'bg-blue-50 dark:bg-blue-950/60',      text: 'text-blue-900 dark:text-blue-100',      badge: 'bg-blue-100 text-blue-700 dark:bg-blue-900/60 dark:text-blue-300',      visited: 'ring-blue-400' },
  sky:     { border: 'border-sky-400 dark:border-sky-600',        bg: 'bg-sky-50 dark:bg-sky-950/60',        text: 'text-sky-900 dark:text-sky-100',        badge: 'bg-sky-100 text-sky-700 dark:bg-sky-900/60 dark:text-sky-300',        visited: 'ring-sky-400' },
  indigo:  { border: 'border-indigo-400 dark:border-indigo-600',  bg: 'bg-indigo-50 dark:bg-indigo-950/60',  text: 'text-indigo-900 dark:text-indigo-100',  badge: 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/60 dark:text-indigo-300',  visited: 'ring-indigo-400' },
  emerald: { border: 'border-emerald-400 dark:border-emerald-600', bg: 'bg-emerald-50 dark:bg-emerald-950/60', text: 'text-emerald-900 dark:text-emerald-100', badge: 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/60 dark:text-emerald-300', visited: 'ring-emerald-400' },
}

// ---------- edge path helper ----------

// Cubic Bezier: exits source vertically and arrives at target vertically.
// Works for both straight vertical edges and the long cross-column S-curves.
function edgePath(sx: number, sy: number, tx: number, ty: number): string {
  const dy = ty - sy
  const cp1y = sy + dy * 0.5
  const cp2y = ty - dy * 0.5
  return `M ${sx} ${sy} C ${sx} ${cp1y} ${tx} ${cp2y} ${tx} ${ty}`
}

// ---------- component ----------

interface Props {
  topics: Topic[]
  visited: Set<string>
  onTopicClick: (topic: Topic) => void
}

export function RoadmapGraph({ topics, visited, onTopicClick }: Props) {
  const topicMap = new Map(topics.map((t) => [t.name, t]))

  const nodes = Object.entries(POSITIONS).map(([name, pos]) => ({
    name,
    pos,
    topic: topicMap.get(name) ?? null,
  }))

  const resolvedEdges = EDGES.map(([srcName, tgtName]) => {
    const src = POSITIONS[srcName]
    const tgt = POSITIONS[tgtName]
    if (!src || !tgt) return null
    return {
      id: `${srcName}→${tgtName}`,
      sx: src.cx,
      sy: src.cy + NODE_H / 2,
      tx: tgt.cx,
      ty: tgt.cy - NODE_H / 2,
    }
  }).filter(Boolean) as { id: string; sx: number; sy: number; tx: number; ty: number }[]

  return (
    <div className="overflow-x-auto pb-4">
      {/* Section labels */}
      <div className="flex mb-3" style={{ width: CANVAS_W }}>
        <div className="flex-1 text-center text-xs font-semibold uppercase tracking-widest text-violet-500 dark:text-violet-400" style={{ maxWidth: 680 }}>
          Pure Mathematics
        </div>
        <div className="text-center text-xs font-semibold uppercase tracking-widest text-emerald-600 dark:text-emerald-400" style={{ width: 340 }}>
          Statistics
        </div>
      </div>

      <div
        className="relative mx-auto"
        style={{ width: CANVAS_W, height: CANVAS_H, minWidth: CANVAS_W }}
      >
        {/* SVG edge layer */}
        <svg
          className="absolute inset-0 pointer-events-none"
          width={CANVAS_W}
          height={CANVAS_H}
          viewBox={`0 0 ${CANVAS_W} ${CANVAS_H}`}
        >
          <defs>
            <marker
              id="arrowhead"
              markerWidth="8"
              markerHeight="8"
              refX="4"
              refY="4"
              orient="auto"
            >
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

          return (
            <button
              key={name}
              disabled={!topic}
              onClick={() => topic && onTopicClick(topic)}
              style={{
                left: pos.cx - NODE_W / 2,
                top: pos.cy - NODE_H / 2,
                width: NODE_W,
                height: NODE_H,
              }}
              className={cn(
                'absolute flex flex-col justify-center px-4 rounded-2xl border-2 shadow-sm transition-all duration-150 text-left group',
                c.bg,
                c.border,
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
                  <span className={cn('text-[10px] font-medium px-1.5 py-0.5 rounded-md', c.badge)}>
                    {topic.level}
                  </span>
                )}
                {isVisited && (
                  <span className="text-[10px] text-slate-500 dark:text-slate-400">
                    visited ✓
                  </span>
                )}
                {!isVisited && topic && (
                  <span className={cn('text-[10px] opacity-0 group-hover:opacity-100 transition-opacity', c.text)}>
                    View →
                  </span>
                )}
              </div>
            </button>
          )
        })}
      </div>
    </div>
  )
}
