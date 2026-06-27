import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { Spinner } from '../components/ui/Spinner'
import { cn } from '../lib/utils'
import type { DiagnosisResult, TopicDiagnosis } from '../types/api'

// ── Queue helpers ─────────────────────────────────────────────────────────────

interface StoredQueue {
  items: ReviewItem[]
  fetchedAt: number
}

const QUEUE_TTL_MS = 30 * 60 * 1000

function loadQueue(key: string): ReviewItem[] | null {
  try {
    const raw = localStorage.getItem(key)
    if (!raw) return null
    const stored = JSON.parse(raw) as StoredQueue
    if (Date.now() - stored.fetchedAt > QUEUE_TTL_MS) return null
    return stored.items.length > 0 ? stored.items : null
  } catch {
    return null
  }
}

function saveQueue(key: string, items: ReviewItem[]) {
  localStorage.setItem(key, JSON.stringify({ items, fetchedAt: Date.now() }))
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr]
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[a[i], a[j]] = [a[j]!, a[i]!]
  }
  return a
}

// ── Shared card arrow icon ─────────────────────────────────────────────────────

function ChevronRight() {
  return (
    <svg
      className="w-5 h-5 text-slate-400 dark:text-slate-500 shrink-0"
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      viewBox="0 0 24 24"
    >
      <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
    </svg>
  )
}

// ── Accuracy bar ──────────────────────────────────────────────────────────────

function AccuracyBar({ accuracy }: { accuracy: number }) {
  const pct = Math.round(accuracy * 100)
  const color =
    pct < 50
      ? 'bg-red-500'
      : pct < 75
        ? 'bg-amber-500'
        : 'bg-emerald-500'
  return (
    <div className="flex items-center gap-2 mt-1">
      <div className="flex-1 h-1.5 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
        <div className={cn('h-full rounded-full', color)} style={{ width: `${pct}%` }} />
      </div>
      <span className="text-xs tabular-nums text-slate-500 dark:text-slate-400 w-8 text-right">
        {pct}%
      </span>
    </div>
  )
}

// ── Topic list within diagnostic result ───────────────────────────────────────

function TopicList({
  title,
  topics,
  accent,
}: {
  title: string
  topics: TopicDiagnosis[]
  accent: string
}) {
  if (topics.length === 0) return null
  return (
    <div>
      <h3 className={cn('text-xs font-semibold uppercase tracking-wider mb-2', accent)}>{title}</h3>
      <ul className="flex flex-col gap-2">
        {topics.map((t) => (
          <li key={t.topic_id} className="text-sm">
            <div className="flex items-center justify-between">
              <span className="font-medium text-slate-800 dark:text-slate-200">{t.topic_name}</span>
              <span className="text-xs text-slate-500 dark:text-slate-400">
                {t.questions_attempted} attempted
              </span>
            </div>
            <AccuracyBar accuracy={t.accuracy} />
            {t.ai_insight && (
              <p className="text-xs text-slate-500 dark:text-slate-400 mt-1 leading-relaxed">
                {t.ai_insight}
              </p>
            )}
          </li>
        ))}
      </ul>
    </div>
  )
}

// ── Component ─────────────────────────────────────────────────────────────────

type DiagState = 'idle' | 'loading' | 'shown' | 'error'

export function ReviewPage() {
  const navigate = useNavigate()

  // ── Page meta ──────────────────────────────────────────────────────────────
  const [metaLoaded, setMetaLoaded] = useState(false)
  const [spacedDueCount, setSpacedDueCount] = useState(0)
  const [totalAttempts, setTotalAttempts] = useState(0)

  useEffect(() => {
    Promise.all([
      api.review.spaced(),
      api.streaks.get(),
    ])
      .then(([spaced, streaks]) => {
        setSpacedDueCount(spaced.items.length)
        setTotalAttempts(streaks.totalAttempts)
      })
      .catch(() => {
        /* non-critical — defaults to 0 */
      })
      .finally(() => setMetaLoaded(true))
  }, [])

  // ── Corrections card ───────────────────────────────────────────────────────
  const [correctionsLoading, setCorrectionsLoading] = useState(false)
  const [correctionsError, setCorrectionsError] = useState<string | null>(null)

  async function handleCorrections() {
    if (correctionsLoading) return
    setCorrectionsLoading(true)
    setCorrectionsError(null)

    try {
      let queue = loadQueue('review_queue_corrections')
      if (!queue) {
        const { items } = await api.review.corrections()
        if (items.length === 0) {
          setCorrectionsError('No incorrect questions yet — nothing to correct!')
          setCorrectionsLoading(false)
          return
        }
        queue = shuffle(items)
        saveQueue('review_queue_corrections', queue)
      }
      const item = queue[0]!
      saveQueue('review_queue_corrections', queue.slice(1))
      navigate(`/practice/${item.topic_id}?question_id=${item.question_id}&from=corrections`)
    } catch (err) {
      setCorrectionsError((err as Error).message)
      setCorrectionsLoading(false)
    }
  }

  // ── Review (SM-2 spaced) card ──────────────────────────────────────────────
  const [spacedLoading, setSpacedLoading] = useState(false)
  const [spacedError, setSpacedError] = useState<string | null>(null)

  async function handleSpaced() {
    if (spacedLoading) return
    setSpacedLoading(true)
    setSpacedError(null)

    try {
      let queue = loadQueue('review_queue_spaced')
      if (!queue) {
        const { items } = await api.review.spaced()
        if (items.length === 0) {
          setSpacedError('No questions due for review today — check back later!')
          setSpacedLoading(false)
          return
        }
        queue = shuffle(items)
        saveQueue('review_queue_spaced', queue)
      }
      const item = queue[0]!
      saveQueue('review_queue_spaced', queue.slice(1))
      navigate(`/practice/${item.topic_id}?question_id=${item.question_id}&from=spaced-review`)
    } catch (err) {
      setSpacedError((err as Error).message)
      setSpacedLoading(false)
    }
  }

  // ── Weakness Diagnostic card ───────────────────────────────────────────────
  const UNLOCK_THRESHOLD = 5
  const eligible = metaLoaded && totalAttempts >= UNLOCK_THRESHOLD

  const [diagState, setDiagState] = useState<DiagState>('idle')
  const [diagnosis, setDiagnosis] = useState<DiagnosisResult | null>(null)
  const [diagError, setDiagError] = useState<string | null>(null)

  async function handleDiagnosis() {
    if (diagState === 'loading') return
    setDiagState('loading')
    setDiagError(null)

    try {
      const result = await api.review.diagnosis()
      setDiagnosis(result)
      setDiagState('shown')
    } catch (err) {
      setDiagError((err as Error).message)
      setDiagState('error')
    }
  }

  const [studyPlanLoading, setStudyPlanLoading] = useState(false)
  const [studyPlanError, setStudyPlanError] = useState<string | null>(null)

  async function handleStudyPlan() {
    if (studyPlanLoading) return
    setStudyPlanLoading(true)
    setStudyPlanError(null)
    try {
      // Clear stale plan so StudyPlanPage fetches fresh if date changed
      const stored = localStorage.getItem('study_plan_v1')
      if (stored) {
        const parsed = JSON.parse(stored) as { date: string }
        const today = new Date().toISOString().slice(0, 10)
        if (parsed.date !== today) localStorage.removeItem('study_plan_v1')
      }
      navigate('/study-plan')
    } catch {
      setStudyPlanError('Could not open study plan.')
      setStudyPlanLoading(false)
    }
  }

  // ── Render ─────────────────────────────────────────────────────────────────

  return (
    <div className="max-w-4xl mx-auto px-4 py-12 flex flex-col gap-6">
      <div>
        <h1 className="text-3xl font-bold text-slate-900 dark:text-slate-100">Corrections</h1>
        <p className="mt-2 text-slate-500 dark:text-slate-400">
          Re-attempt questions you got wrong, with your past mistakes shown for reference
        </p>
      </div>

      {/* ── Start Corrections ─────────────────────────────────────────────── */}
      <button
        onClick={handleCorrections}
        disabled={correctionsLoading}
        className={cn(
          'flex items-center gap-5 rounded-2xl border px-6 py-4 text-left transition-all duration-200',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500',
          'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800',
          !correctionsLoading
            ? 'hover:border-red-400 dark:hover:border-red-600 hover:shadow-md cursor-pointer'
            : 'border-red-400 dark:border-red-600 shadow-md',
        )}
      >
        <div className="flex items-center justify-center w-12 h-12 rounded-xl text-2xl shrink-0 bg-red-50 dark:bg-red-900/30">
          {correctionsLoading ? <Spinner size="sm" /> : '🚧'}
        </div>
        <div className="flex-1 min-w-0">
          <p className="font-bold text-slate-900 dark:text-slate-100 text-base leading-tight">
            Start Corrections
          </p>
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">
            Practice questions you answered incorrectly
          </p>
          {correctionsError && (
            <p className="text-xs text-amber-600 dark:text-amber-400 mt-1">{correctionsError}</p>
          )}
        </div>
        <ChevronRight />
      </button>

      {/* ── Review (SM-2 Spaced Repetition) ──────────────────────────────── */}
      <button
        onClick={handleSpaced}
        disabled={spacedLoading}
        className={cn(
          'flex items-center gap-5 rounded-2xl border px-6 py-4 text-left transition-all duration-200',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-violet-500',
          'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800',
          !spacedLoading
            ? 'hover:border-violet-400 dark:hover:border-violet-600 hover:shadow-md cursor-pointer'
            : 'border-violet-400 dark:border-violet-600 shadow-md',
        )}
      >
        <div className="flex items-center justify-center w-12 h-12 rounded-xl text-2xl shrink-0 bg-violet-50 dark:bg-violet-900/30">
          {spacedLoading ? <Spinner size="sm" /> : '🔁'}
        </div>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2">
            <p className="font-bold text-slate-900 dark:text-slate-100 text-base leading-tight">
              Review
            </p>
            {metaLoaded && spacedDueCount > 0 && (
              <span className="inline-flex items-center rounded-full bg-violet-100 dark:bg-violet-900/40 px-2 py-0.5 text-xs font-semibold text-violet-700 dark:text-violet-300">
                {spacedDueCount} due
              </span>
            )}
          </div>
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">
            Spaced repetition (Wozniak SM-2) — revisit wrong answers at optimal intervals
          </p>
          {spacedError && (
            <p className="text-xs text-amber-600 dark:text-amber-400 mt-1">{spacedError}</p>
          )}
        </div>
        <ChevronRight />
      </button>

      {/* ── Weakness Diagnostic ───────────────────────────────────────────── */}
      {!metaLoaded || !eligible ? (
        // Locked or loading state
        <div
          className={cn(
            'flex items-center gap-5 rounded-2xl border px-6 py-4',
            'bg-slate-50 dark:bg-slate-900/50 border-slate-200 dark:border-slate-800',
            !metaLoaded && 'animate-pulse',
          )}
        >
          <div className="flex items-center justify-center w-12 h-12 rounded-xl text-2xl shrink-0 bg-slate-100 dark:bg-slate-800">
            🔒
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-bold text-slate-400 dark:text-slate-500 text-base leading-tight">
              Weakness Diagnostic
            </p>
            <p className="text-sm text-slate-400 dark:text-slate-500 mt-0.5">
              {metaLoaded
                ? `Attempt ${UNLOCK_THRESHOLD} questions to unlock — ${UNLOCK_THRESHOLD - totalAttempts} to go`
                : 'Checking eligibility…'}
            </p>
          </div>
        </div>
      ) : (
        // Active state
        <div
          className={cn(
            'rounded-2xl border',
            'bg-white dark:bg-slate-900 border-slate-200 dark:border-slate-800',
            diagState === 'shown' && 'border-indigo-300 dark:border-indigo-700',
          )}
        >
          {/* Card header / trigger button */}
          <button
            onClick={diagState === 'shown' ? undefined : handleDiagnosis}
            disabled={diagState === 'loading'}
            className={cn(
              'w-full flex items-center gap-5 px-6 py-4 text-left transition-all duration-200',
              'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500 rounded-2xl',
              diagState !== 'shown' &&
                diagState !== 'loading' &&
                'hover:bg-indigo-50/50 dark:hover:bg-indigo-900/10 cursor-pointer',
              diagState === 'loading' && 'cursor-default',
              diagState === 'shown' && 'cursor-default',
            )}
          >
            <div className="flex items-center justify-center w-12 h-12 rounded-xl text-2xl shrink-0 bg-indigo-50 dark:bg-indigo-900/30">
              {diagState === 'loading' ? <Spinner size="sm" /> : '🧠'}
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-bold text-slate-900 dark:text-slate-100 text-base leading-tight">
                Weakness Diagnostic
              </p>
              <p className="text-sm text-slate-500 dark:text-slate-400 mt-0.5">
                {diagState === 'idle' || diagState === 'error'
                  ? 'AI analysis of your performance — find your weak and strong topics'
                  : diagState === 'loading'
                    ? 'Analysing your performance with Gemini…'
                    : 'Your personalised performance report'}
              </p>
              {diagState === 'error' && diagError && (
                <p className="text-xs text-red-600 dark:text-red-400 mt-1">{diagError}</p>
              )}
            </div>
            {diagState === 'idle' && <ChevronRight />}
            {diagState === 'error' && (
              <span className="text-xs text-indigo-600 dark:text-indigo-400 shrink-0">Retry</span>
            )}
          </button>

          {/* Diagnosis results */}
          {diagState === 'shown' && diagnosis && (
            <div className="px-6 pb-6 flex flex-col gap-5">
              <div className="h-px bg-slate-100 dark:bg-slate-800" />

              {/* Overall summary */}
              <p className="text-sm text-slate-700 dark:text-slate-300 leading-relaxed">
                {diagnosis.overall_summary}
              </p>

              {/* Topic breakdowns */}
              <div className="flex flex-col gap-5">
                <TopicList
                  title="Needs Work"
                  topics={diagnosis.weak_topics}
                  accent="text-red-600 dark:text-red-400"
                />
                <TopicList
                  title="Getting There"
                  topics={diagnosis.moderate_topics}
                  accent="text-amber-600 dark:text-amber-400"
                />
                <TopicList
                  title="Strengths"
                  topics={diagnosis.strong_topics}
                  accent="text-emerald-600 dark:text-emerald-400"
                />
              </div>

              {/* Study plan CTA */}
              <div className="flex flex-col gap-2 pt-1">
                <button
                  onClick={handleStudyPlan}
                  disabled={studyPlanLoading}
                  className={cn(
                    'w-full flex items-center justify-center gap-2 rounded-xl px-4 py-3',
                    'bg-indigo-600 hover:bg-indigo-700 active:bg-indigo-800',
                    'text-white font-semibold text-sm transition-colors duration-150',
                    'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500 focus-visible:ring-offset-2',
                    'disabled:opacity-60 disabled:cursor-not-allowed',
                  )}
                >
                  {studyPlanLoading ? (
                    <Spinner size="sm" />
                  ) : (
                    <>
                      <span>📅</span>
                      <span>Today&apos;s Personalised Study Plan</span>
                    </>
                  )}
                </button>
                {studyPlanError && (
                  <p className="text-xs text-amber-600 dark:text-amber-400 text-center">
                    {studyPlanError}
                  </p>
                )}
                <p className="text-xs text-slate-400 dark:text-slate-500 text-center">
                  AI selects up to 10 questions from your weakest topics
                </p>
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  )
}
