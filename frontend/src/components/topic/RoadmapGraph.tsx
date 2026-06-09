import { useNavigate } from 'react-router-dom'
import type { Topic } from '../../types/api'
import { cn } from '../../lib/utils'
import { useVisitedTopics } from '../../hooks/useVisitedTopics'

// ---------- layout config ----------

const NODE_W = 176
const NODE_H = 72
const CANVAS_W = 740
const CANVAS_H = 530

// Center-x, center-y for each topic (keyed by canonical name)
const POSITIONS: Record<string, { cx: number; cy: number; color: string }> = {
  'Functions & Graphs': { cx: 240, cy: 72,  color: 'violet' },
  'Differentiation':    { cx: 130, cy: 252, color: 'blue'   },
  'Integration':        { cx: 130, cy: 432, color: 'sky'    },
  'Sequences & Series': { cx: 390, cy: 252, color: 'indigo' },
  'Statistics':         { cx: 590, cy: 72,  color: 'emerald' },
}

// Directed edges: [sourceName, targetName]
const EDGES: [string, string][] = [
  ['Functions & Graphs', 'Differentiation'],
  ['Functions & Graphs', 'Sequences & Series'],
  ['Differentiation', 'Integration'],
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

function edgePath(
  sx: number, sy: number,  // source bottom-center
  tx: number, ty: number,  // target top-center
): string {
  const dy = ty - sy
  const cp1y = sy + dy * 0.5
  const cp2y = ty - dy * 0.5
  return `M ${sx} ${sy} C ${sx} ${cp1y} ${tx} ${cp2y} ${tx} ${ty}`
}

// ---------- component ----------

interface Props {
  topics: Topic[]
}

export function RoadmapGraph({ topics }: Props) {
  const navigate = useNavigate()
  const { visited, markVisited } = useVisitedTopics()

  // Build name → topic map
  const topicMap = new Map(topics.map((t) => [t.name, t]))

  // Resolve positioned nodes from fetched topics
  const nodes = Object.entries(POSITIONS).map(([name, pos]) => ({
    name,
    pos,
    topic: topicMap.get(name) ?? null,
  }))

  // Resolve edge coordinates
  const resolvedEdges = EDGES.map(([srcName, tgtName]) => {
    const src = POSITIONS[srcName]
    const tgt = POSITIONS[tgtName]
    if (!src || !tgt) return null
    const sx = src.cx
    const sy = src.cy + NODE_H / 2
    const tx = tgt.cx
    const ty = tgt.cy - NODE_H / 2
    return { id: `${srcName}→${tgtName}`, sx, sy, tx, ty }
  }).filter(Boolean) as { id: string; sx: number; sy: number; tx: number; ty: number }[]

  function handleNodeClick(topicId: string) {
    markVisited(topicId)
    navigate(`/practice/${topicId}`)
  }

  return (
    <div className="overflow-x-auto pb-4">
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
              <path
                d="M1,1 L7,4 L1,7 Z"
                className="fill-slate-300 dark:fill-slate-600"
              />
            </marker>
            <marker
              id="arrowhead-dark"
              markerWidth="8"
              markerHeight="8"
              refX="4"
              refY="4"
              orient="auto"
            >
              <path d="M1,1 L7,4 L1,7 Z" fill="#475569" />
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
              strokeDasharray="none"
            />
          ))}
        </svg>

        {/* Node cards */}
        {nodes.map(({ name, pos, topic }) => {
          const color = (pos.color as Color)
          const c = colorMap[color]
          const isVisited = topic ? visited.has(topic.id) : false

          return (
            <button
              key={name}
              disabled={!topic}
              onClick={() => topic && handleNodeClick(topic.id)}
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
                    Practice →
                  </span>
                )}
              </div>
            </button>
          )
        })}

        {/* Unmatched topics — render as fallback nodes below the graph */}
      </div>

      {/* Fallback: topics not in the roadmap config */}
      {(() => {
        const knownNames = new Set(Object.keys(POSITIONS))
        const extra = topics.filter((t) => !knownNames.has(t.name))
        if (extra.length === 0) return null
        return (
          <div className="mt-6 flex flex-wrap gap-3 justify-center">
            {extra.map((t) => {
              const isVisited = visited.has(t.id)
              return (
                <button
                  key={t.id}
                  onClick={() => handleNodeClick(t.id)}
                  className={cn(
                    'flex flex-col justify-center px-4 py-3 rounded-2xl border-2 shadow-sm text-left transition-all hover:shadow-md hover:scale-105',
                    'bg-slate-50 dark:bg-slate-900 border-slate-300 dark:border-slate-700',
                    isVisited && 'ring-2 ring-offset-2 ring-slate-400 dark:ring-offset-slate-950',
                  )}
                  style={{ width: NODE_W, height: NODE_H }}
                >
                  <span className="text-sm font-semibold text-slate-800 dark:text-slate-100">
                    {t.name}
                  </span>
                  <span className="text-[10px] mt-1 text-slate-400">{t.level}</span>
                </button>
              )
            })}
          </div>
        )
      })()}
    </div>
  )
}
