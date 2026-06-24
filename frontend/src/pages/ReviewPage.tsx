import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { getSessionId } from '../lib/session'
import { Spinner } from '../components/ui/Spinner'
import { cn } from '../lib/utils'
import type { ReviewItem, ReviewMode } from '../types/api'

// ── Queue persistence ─────────────────────────────────────────────────────────

interface StoredQueue {
  items: ReviewItem[]
  fetchedAt: number
}

const QUEUE_TTL_MS = 30 * 60 * 1000

function loadQueue(mode: ReviewMode): ReviewItem[] | null {
  try {
    const raw = localStorage.getItem(`review_queue_${mode}`)
    if (!raw) return null
    const stored = JSON.parse(raw) as StoredQueue
    if (Date.now() - stored.fetchedAt > QUEUE_TTL_MS) return null
    return stored.items.length > 0 ? stored.items : null
  } catch {
    return null
  }
}

function saveQueue(mode: ReviewMode, items: ReviewItem[]) {
  const stored: StoredQueue = { items, fetchedAt: Date.now() }
  localStorage.setItem(`review_queue_${mode}`, JSON.stringify(stored))
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j]!, a[i]!]
  }
  return a
}

// ── Mode definitions ──────────────────────────────────────────────────────────

interface ModeConfig {
  id: ReviewMode
  title: string
  caption: string
  icon: string
  iconBg: string
  emptyMessage: string
}

const MODES: ModeConfig[] = [
  {
    id: 'corrections',
    title: 'Corrections',
    caption: 'Re-attempt incorrect questions',
    icon: '🚧',
    iconBg: 'bg-red-50 dark:bg-red-900/30',
    emptyMessage: 'No incorrect questions yet — nothing to correct!',
  },
  {
    id: 'weak-topics',
    title: 'Practice Makes Perfect',
    caption: 'Work on your weakest topics',
    icon: '🎯',
    iconBg: 'bg-amber-50 dark:bg-amber-900/30',
    emptyMessage: 'Attempt more questions to unlock weak topic analysis.',
  },
  {
    id: 'speed-drills',
    title: 'Speed Drills',
    caption: 'Work on your speed',
    icon: '⏱️',
    iconBg: 'bg-blue-50 dark:bg-blue-900/30',
    emptyMessage: 'Solve more questions first to unlock speed drills.',
  },
  {
    id: 'spaced',
    title: 'Review',
    caption: 'Train your pattern recognition',
    icon: '🧠',
    iconBg: 'bg-purple-50 dark:bg-purple-900/30',
    emptyMessage: 'No questions due for review yet — check back later.',
  },
  {
    id: 'random',
    title: 'Random',
    caption: 'Test your exam preparation',
    icon: '📚',
    iconBg: 'bg-slate-100 dark:bg-slate-800',
    emptyMessage: 'No questions available.',
  },
]

// ── Component ─────────────────────────────────────────────────────────────────

export function ReviewPage() {
  const navigate = useNavigate()
  const [loadingMode, setLoadingMode] = useState<ReviewMode | null>(null)
  const [errors, setErrors] = useState<Partial<Record<ReviewMode, string>>>({})

  async function fetchItems(mode: ReviewMode): Promise<ReviewItem[]> {
    const sessionId = getSessionId()
    switch (mode) {
      case 'corrections':
        return (await api.review.corrections(sessionId)).items
      case 'weak-topics':
        return (await api.review.weakTopics(sessionId)).items
      case 'speed-drills':
        return (await api.review.speedDrills(sessionId)).items
      case 'spaced':
        return (await api.review.spaced(sessionId)).items
      case 'random':
        return (await api.review.random()).items
    }
  }

  async function handleClick(mode: ReviewMode) {
    if (loadingMode !== null) return
    setLoadingMode(mode)
    setErrors((e) => ({ ...e, [mode]: undefined }))

    try {
      let queue = loadQueue(mode)

      if (!queue) {
        const items = await fetchItems(mode)
        if (items.length === 0) {
          const emptyMsg = MODES.find((m) => m.id === mode)?.emptyMessage ?? 'Nothing available.'
          setErrors((e) => ({ ...e, [mode]: emptyMsg }))
          setLoadingMode(null)
          return
        }
        queue = shuffle(items)
        saveQueue(mode, queue)
      }

      const item = queue[0]!
      const remaining = queue.slice(1)
      // Save remaining (even if empty — next click will refetch)
      saveQueue(mode, remaining)

      navigate(`/practice/${item.topic_id}?question_id=${item.question_id}`)
    } catch (err) {
      setErrors((e) => ({ ...e, [mode]: (err as Error).message }))
      setLoadingMode(null)
    }
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-12 flex flex-col gap-8">
      <div>
        <h1 className="text-3xl font-bold text-slate-900 dark:text-slate-100">
          From problem to solution
        </h1>
        <p className="mt-2 text-slate-500 dark:text-slate-400">Choose your learning style</p>
      </div>

      <div className="flex flex-col gap-3">
        {MODES.map((mode) => {
          const isLoading = loadingMode === mode.id
          const modeError = errors[mode.id]

          return (
            <button
              key={mode.id}
              onClick={() => handleClick(mode.id)}
              disabled={loadingMode !== null}
              className={cn(
                'flex items-center gap-5 rounded-2xl border px-6 py-4 text-left transition-all duration-200',
                'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500',
                'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800',
                loadingMode === null
                  ? 'hover:border-blue-400 dark:hover:border-blue-600 hover:shadow-md cursor-pointer'
                  : isLoading
                    ? 'border-blue-400 dark:border-blue-600 shadow-md'
                    : 'opacity-50 cursor-not-allowed',
              )}
            >
              <div
                className={cn(
                  'flex items-center justify-center w-12 h-12 rounded-xl text-2xl shrink-0',
                  mode.iconBg,
                )}
              >
                {isLoading ? <Spinner size="sm" /> : mode.icon}
              </div>

              <div className="flex-1 min-w-0">
                <p className="font-bold text-slate-900 dark:text-slate-100 text-base leading-tight">
                  {mode.title}
                </p>
                <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">{mode.caption}</p>
                {modeError && (
                  <p className="text-xs text-amber-600 dark:text-amber-400 mt-1">{modeError}</p>
                )}
              </div>

              <svg
                className="w-5 h-5 text-slate-400 dark:text-slate-500 shrink-0"
                fill="none"
                stroke="currentColor"
                strokeWidth={2}
                viewBox="0 0 24 24"
              >
                <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
              </svg>
            </button>
          )
        })}
      </div>
    </div>
  )
}
