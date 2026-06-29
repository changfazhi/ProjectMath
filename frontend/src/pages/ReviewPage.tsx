import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { Spinner } from '../components/ui/Spinner'
import { cn } from '../lib/utils'
import { useAuth } from '../contexts/AuthContext'
import { savePlan, savePlanRemote, todayStr, PLAN_KEY, type StoredPlan } from '../lib/studyPlan'
import type { DiagnosisResult, ReviewItem, TopicDiagnosis } from '../types/api'

const BRICOLAGE = "'Bricolage Grotesque', sans-serif"

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
      className="w-5 h-5 shrink-0"
      style={{ color: '#7e84ad' }}
      fill="none"
      stroke="currentColor"
      strokeWidth={2}
      viewBox="0 0 24 24"
    >
      <path strokeLinecap="round" strokeLinejoin="round" d="M9 5l7 7-7 7" />
    </svg>
  )
}

// ── Card icons (no emojis) ──────────────────────────────────────────────────────

const iconProps = {
  className: 'w-6 h-6',
  fill: 'none',
  stroke: 'currentColor',
  strokeWidth: 1.8,
  viewBox: '0 0 24 24',
  strokeLinecap: 'round' as const,
  strokeLinejoin: 'round' as const,
}

function IconCorrections() {
  return (
    <svg {...iconProps}>
      <path d="M12 20h9" />
      <path d="M16.5 3.5a2.12 2.12 0 0 1 3 3L7 19l-4 1 1-4Z" />
    </svg>
  )
}

function IconReview() {
  return (
    <svg {...iconProps}>
      <path d="M17 2.5 21 6l-4 3.5" />
      <path d="M21 6H7a4 4 0 0 0-4 4v1" />
      <path d="M7 21.5 3 18l4-3.5" />
      <path d="M3 18h14a4 4 0 0 0 4-4v-1" />
    </svg>
  )
}

function IconDiagnostic() {
  return (
    <svg {...iconProps}>
      <circle cx="12" cy="12" r="9" />
      <circle cx="12" cy="12" r="4.5" />
      <circle cx="12" cy="12" r="1" />
    </svg>
  )
}

function IconLock() {
  return (
    <svg {...iconProps}>
      <rect x="5" y="11" width="14" height="10" rx="2" />
      <path d="M8 11V7a4 4 0 0 1 8 0v4" />
    </svg>
  )
}

function IconCalendar() {
  return (
    <svg className="w-5 h-5" fill="none" stroke="currentColor" strokeWidth={1.8} viewBox="0 0 24 24" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="5" width="18" height="16" rx="2" />
      <path d="M3 9h18M8 3v4m8-4v4" />
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
  const { user } = useAuth()

  // ── Page meta ──────────────────────────────────────────────────────────────
  const [metaLoaded, setMetaLoaded] = useState(false)
  const [spacedDueCount, setSpacedDueCount] = useState(0)
  const [uniqueQuestionsAttempted, setUniqueQuestionsAttempted] = useState(0)

  useEffect(() => {
    Promise.all([
      api.review.spaced(),
      api.streaks.get(),
    ])
      .then(([spaced, streaks]) => {
        setSpacedDueCount(spaced.items.length)
        setUniqueQuestionsAttempted(streaks.uniqueQuestionsAttempted)
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
  const eligible = metaLoaded && uniqueQuestionsAttempted >= UNLOCK_THRESHOLD

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
      const today = todayStr()

      // Check whether today's plan is already cached in localStorage
      let hasTodayPlan = false
      const localRaw = localStorage.getItem(PLAN_KEY)
      if (localRaw) {
        try {
          hasTodayPlan = (JSON.parse(localRaw) as { date: string }).date === today
        } catch {
          localStorage.removeItem(PLAN_KEY)
        }
      }

      if (!hasTodayPlan) {
        // Fetch the plan here (spinner is already showing) so StudyPlanPage renders instantly.
        const fresh = await api.review.studyPlan()
        const planData: StoredPlan = { date: today, items: fresh.items, reasoning: fresh.reasoning }
        savePlan(planData)                                        // sync — localStorage is immediate
        if (user?.uid) savePlanRemote(user.uid, planData).catch(() => {}) // background Firestore write
      }

      navigate('/study-plan')
    } catch (err) {
      setStudyPlanError((err as Error).message)
      setStudyPlanLoading(false)
    }
  }

  // ── Render ─────────────────────────────────────────────────────────────────

  return (
    <div className="max-w-4xl mx-auto px-4 py-12 flex flex-col gap-6">
      <style>{`.rv-card{transition:transform .15s,border-color .15s,box-shadow .15s}.rv-card:hover{transform:translateY(-2px);border-color:#4f46e5;box-shadow:0 18px 40px -24px rgba(79,70,229,.65)}`}</style>
      <div>
        <div className="text-[13px] font-bold uppercase tracking-[0.1em]" style={{ color: '#a5abe0' }}>
          Review &amp; correct
        </div>
        <h1 className="mt-2 text-3xl font-extrabold tracking-tight text-white" style={{ fontFamily: BRICOLAGE }}>
          Corrections
        </h1>
        <p className="mt-2" style={{ color: '#aab0d6' }}>
          Re-attempt questions you got wrong, with your past mistakes shown for reference
        </p>
      </div>

      {/* ── Start Corrections ─────────────────────────────────────────────── */}
      <button
        onClick={handleCorrections}
        disabled={correctionsLoading}
        className="rv-card flex items-center gap-5 rounded-2xl px-6 py-4 text-left cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500 disabled:cursor-default"
        style={{ background: '#12152b', border: '1px solid #2a3160' }}
      >
        <div
          className="flex items-center justify-center w-12 h-12 rounded-xl shrink-0"
          style={{ background: 'rgba(239,68,68,.14)', color: '#f87171' }}
        >
          {correctionsLoading ? <Spinner size="sm" /> : <IconCorrections />}
        </div>
        <div className="flex-1 min-w-0">
          <p className="font-bold text-base leading-tight text-white">Start Corrections</p>
          <p className="text-sm mt-0.5" style={{ color: '#aab0d6' }}>
            Practice questions you answered incorrectly
          </p>
          {correctionsError && (
            <p className="text-xs mt-1" style={{ color: '#fbbf24' }}>{correctionsError}</p>
          )}
        </div>
        <ChevronRight />
      </button>

      {/* ── Review (SM-2 Spaced Repetition) ──────────────────────────────── */}
      <button
        onClick={handleSpaced}
        disabled={spacedLoading}
        className="rv-card flex items-center gap-5 rounded-2xl px-6 py-4 text-left cursor-pointer focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500 disabled:cursor-default"
        style={{ background: '#12152b', border: '1px solid #2a3160' }}
      >
        <div
          className="flex items-center justify-center w-12 h-12 rounded-xl shrink-0"
          style={{ background: 'rgba(124,58,237,.16)', color: '#a78bfa' }}
        >
          {spacedLoading ? <Spinner size="sm" /> : <IconReview />}
        </div>
        <div className="flex-1 min-w-0">
          <div className="flex items-center gap-2">
            <p className="font-bold text-base leading-tight text-white">Review</p>
            {metaLoaded && spacedDueCount > 0 && (
              <span
                className="inline-flex items-center rounded-full px-2 py-0.5 text-xs font-semibold"
                style={{ background: 'rgba(124,58,237,.22)', color: '#c4b5fd' }}
              >
                {spacedDueCount} due
              </span>
            )}
          </div>
          <p className="text-sm mt-0.5" style={{ color: '#aab0d6' }}>
            Spaced repetition (Wozniak SM-2) — revisit wrong answers at optimal intervals
          </p>
          {spacedError && (
            <p className="text-xs mt-1" style={{ color: '#fbbf24' }}>{spacedError}</p>
          )}
        </div>
        <ChevronRight />
      </button>

      {/* ── Weakness Diagnostic ───────────────────────────────────────────── */}
      {!metaLoaded || !eligible ? (
        // Locked or loading state
        <div
          className={cn('flex items-center gap-5 rounded-2xl px-6 py-4', !metaLoaded && 'animate-pulse')}
          style={{ background: '#10132a', border: '1px solid #232850' }}
        >
          <div
            className="flex items-center justify-center w-12 h-12 rounded-xl shrink-0"
            style={{ background: '#161a33', border: '1px solid #262b4d', color: '#5b6090' }}
          >
            <IconLock />
          </div>
          <div className="flex-1 min-w-0">
            <p className="font-bold text-base leading-tight" style={{ color: '#bcc1e0' }}>
              Weakness Diagnostic
            </p>
            <p className="text-sm mt-0.5" style={{ color: '#6a6f99' }}>
              {metaLoaded
                ? `Attempt ${UNLOCK_THRESHOLD} unique questions to unlock — ${UNLOCK_THRESHOLD - uniqueQuestionsAttempted} to go`
                : 'Checking eligibility…'}
            </p>
          </div>
        </div>
      ) : (
        // Active state
        <div
          className={cn('rounded-2xl', diagState !== 'shown' && 'rv-card')}
          style={{
            background: '#12152b',
            border: diagState === 'shown' ? '1px solid #4f46e5' : '1px solid #2a3160',
          }}
        >
          {/* Card header / trigger button */}
          <button
            onClick={diagState === 'shown' ? undefined : handleDiagnosis}
            disabled={diagState === 'loading'}
            className={cn(
              'w-full flex items-center gap-5 px-6 py-4 text-left rounded-2xl',
              'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500',
              diagState !== 'shown' && diagState !== 'loading' && 'cursor-pointer',
              (diagState === 'loading' || diagState === 'shown') && 'cursor-default',
            )}
          >
            <div
              className="flex items-center justify-center w-12 h-12 rounded-xl shrink-0"
              style={{ background: 'rgba(79,70,229,.16)', color: '#7c83ff' }}
            >
              {diagState === 'loading' ? <Spinner size="sm" /> : <IconDiagnostic />}
            </div>
            <div className="flex-1 min-w-0">
              <p className="font-bold text-base leading-tight text-white">Weakness Diagnostic</p>
              <p className="text-sm mt-0.5" style={{ color: '#aab0d6' }}>
                {diagState === 'idle' || diagState === 'error'
                  ? 'AI analysis of your performance — find your weak and strong topics'
                  : diagState === 'loading'
                    ? 'Analysing your performance with Gemini…'
                    : 'Your personalised performance report'}
              </p>
              {diagState === 'error' && diagError && (
                <p className="text-xs mt-1" style={{ color: '#f87171' }}>{diagError}</p>
              )}
            </div>
            {diagState === 'idle' && <ChevronRight />}
            {diagState === 'error' && (
              <span className="text-xs shrink-0" style={{ color: '#7c83ff' }}>Retry</span>
            )}
          </button>

          {/* Diagnosis results */}
          {diagState === 'shown' && diagnosis && (
            <div className="px-6 pb-6 flex flex-col gap-5">
              <div className="h-px" style={{ background: '#2a3160' }} />

              {/* Overall summary */}
              <p className="text-sm leading-relaxed" style={{ color: '#cdd2ea' }}>
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
                  className="w-full flex items-center justify-center gap-2 rounded-xl px-4 py-3 text-white font-semibold text-sm transition-transform hover:-translate-y-0.5 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-400 focus-visible:ring-offset-2 focus-visible:ring-offset-[#12152b] disabled:opacity-60 disabled:cursor-not-allowed"
                  style={{ background: 'linear-gradient(135deg,#4f46e5,#7c3aed)', boxShadow: '0 12px 26px -10px rgba(79,70,229,.7)' }}
                >
                  {studyPlanLoading ? (
                    <Spinner size="sm" />
                  ) : (
                    <>
                      <IconCalendar />
                      <span>Today&apos;s Personalised Study Plan</span>
                    </>
                  )}
                </button>
                {studyPlanError && (
                  <p className="text-xs text-center" style={{ color: '#fbbf24' }}>
                    {studyPlanError}
                  </p>
                )}
                <p className="text-xs text-center" style={{ color: '#6a6f99' }}>
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
