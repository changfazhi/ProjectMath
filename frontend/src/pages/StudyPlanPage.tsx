import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { Spinner } from '../components/ui/Spinner'
import { cn } from '../lib/utils'
import type { StudyPlanItem, QuestStatus } from '../types/api'
import { persistPlan, resolvePlan } from '../lib/studyPlan'
import { useAuth } from '../contexts/AuthContext'

// ── Types ─────────────────────────────────────────────────────────────────────

interface Quest extends StudyPlanItem {
  status: QuestStatus
  index: number
}

// ── Quest row ─────────────────────────────────────────────────────────────────

function QuestRow({
  quest,
  isNext,
  onStart,
}: {
  quest: Quest
  isNext: boolean
  onStart: () => void
}) {
  const done = quest.status === 'correct'
  const tried = quest.status === 'attempted'

  return (
    <div
      className={cn(
        'flex items-center gap-4 rounded-xl border px-4 py-3.5 transition-all duration-300',
        done && 'border-emerald-200 dark:border-emerald-800 bg-emerald-50 dark:bg-emerald-900/20',
        tried && 'border-amber-200 dark:border-amber-800 bg-amber-50/60 dark:bg-amber-900/15',
        !done && !tried && isNext && 'border-indigo-300 dark:border-indigo-600 bg-indigo-50 dark:bg-indigo-900/25 shadow-sm',
        !done && !tried && !isNext && 'border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 opacity-60',
      )}
    >
      {/* Quest number / status icon */}
      <div
        className={cn(
          'flex items-center justify-center w-9 h-9 rounded-lg shrink-0 text-sm font-bold',
          done && 'bg-emerald-100 dark:bg-emerald-800/50 text-emerald-700 dark:text-emerald-300',
          tried && 'bg-amber-100 dark:bg-amber-800/50 text-amber-700 dark:text-amber-300',
          !done && !tried && isNext && 'bg-indigo-100 dark:bg-indigo-800/50 text-indigo-700 dark:text-indigo-300',
          !done && !tried && !isNext && 'bg-slate-100 dark:bg-slate-800 text-slate-400 dark:text-slate-500',
        )}
      >
        {done ? '✓' : tried ? '↩' : quest.index + 1}
      </div>

      {/* Quest info */}
      <div className="flex-1 min-w-0">
        <p
          className={cn(
            'text-sm font-semibold leading-tight truncate',
            done && 'text-emerald-800 dark:text-emerald-200',
            tried && 'text-amber-800 dark:text-amber-200',
            !done && !tried && 'text-slate-800 dark:text-slate-100',
          )}
        >
          {quest.question_name ?? `Question ${quest.index + 1}`}
        </p>
        <p
          className={cn(
            'text-xs mt-0.5',
            done && 'text-emerald-600 dark:text-emerald-400',
            tried && 'text-amber-600 dark:text-amber-400',
            !done && !tried && 'text-slate-500 dark:text-slate-400',
          )}
        >
          {quest.topic_name}
          {done && ' · Complete!'}
          {tried && ' · Keep trying'}
        </p>
      </div>

      {/* Action button */}
      {!done && (
        <button
          onClick={onStart}
          className={cn(
            'shrink-0 rounded-lg px-3 py-1.5 text-xs font-semibold transition-all duration-150',
            'focus-visible:outline-none focus-visible:ring-2',
            isNext
              ? 'bg-indigo-600 hover:bg-indigo-700 text-white focus-visible:ring-indigo-500'
              : tried
                ? 'bg-amber-100 dark:bg-amber-800/40 hover:bg-amber-200 dark:hover:bg-amber-700/50 text-amber-700 dark:text-amber-300 focus-visible:ring-amber-500'
                : 'bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-600 dark:text-slate-300 focus-visible:ring-slate-400',
          )}
        >
          {isNext ? '▶ Start' : tried ? 'Retry' : 'Practice'}
        </button>
      )}
    </div>
  )
}

// ── Component ─────────────────────────────────────────────────────────────────

export function StudyPlanPage() {
  const navigate = useNavigate()
  const { user, tier } = useAuth()
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [quests, setQuests] = useState<Quest[]>([])
  const [reasoning, setReasoning] = useState('')
  const [validUntil, setValidUntil] = useState<string | null>(null)

  // Re-run when auth settles so signed-in users hydrate from Firestore on new devices
  useEffect(() => {
    loadPlan()
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.uid])

  async function loadPlan() {
    setLoading(true)
    setError(null)
    try {
      let items: StudyPlanItem[]
      let planReasoning: string

      const { plan: stored, isStale } = await resolvePlan(user?.uid ?? null)
      if (stored && !isStale) {
        items = stored.items
        planReasoning = stored.reasoning
        setValidUntil(stored.valid_until ?? null)
      } else {
        const fresh = await api.review.studyPlan()
        if (fresh.items.length === 0) {
          setError("You've already mastered all the recommended questions — great work!")
          setLoading(false)
          return
        }
        items = fresh.items
        planReasoning = fresh.reasoning
        setValidUntil(fresh.valid_until)
        await persistPlan(user?.uid ?? null, {
          date: fresh.date,
          valid_until: fresh.valid_until,
          items,
          reasoning: planReasoning,
        })
      }

      // Check attempt status for each question
      const attempts = await api.attempts.list()
      const correctSet = new Set(attempts.filter(a => a.is_correct).map(a => a.question_id))
      const triedSet = new Set(attempts.map(a => a.question_id))

      const q: Quest[] = items.map((item, i) => ({
        ...item,
        index: i,
        status: correctSet.has(item.question_id)
          ? 'correct'
          : triedSet.has(item.question_id)
            ? 'attempted'
            : 'pending',
      }))

      setQuests(q)
      setReasoning(planReasoning)
    } catch (err) {
      setError((err as Error).message)
    } finally {
      setLoading(false)
    }
  }

  function startQuest(quest: Quest) {
    navigate(`/practice/${quest.topic_id}?question_id=${quest.question_id}&from=study-plan`)
  }

  const correctCount = quests.filter(q => q.status === 'correct').length
  const total = quests.length
  const allDone = total > 0 && correctCount === total
  const pct = total > 0 ? Math.round((correctCount / total) * 100) : 0

  // First pending or first attempted (re-try) quest
  const nextQuest =
    quests.find(q => q.status === 'pending') ??
    quests.find(q => q.status === 'attempted') ??
    null

  // ── Render ──────────────────────────────────────────────────────────────────

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[60vh]">
        <div className="flex flex-col items-center gap-3">
          <Spinner size="lg" />
          <p className="text-sm text-slate-500 dark:text-slate-400">Building your quest log…</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="max-w-2xl mx-auto px-4 py-16 text-center flex flex-col gap-4">
        <p className="text-4xl">🎯</p>
        <p className="text-lg font-semibold text-slate-800 dark:text-slate-200">{error}</p>
        <button
          onClick={() => navigate('/review')}
          className="mx-auto text-sm text-indigo-600 dark:text-indigo-400 underline underline-offset-2"
        >
          Back to Review
        </button>
      </div>
    )
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-10 flex flex-col gap-6">

      {/* ── Header ─────────────────────────────────────────────────────────── */}
      <div className="flex items-start justify-between gap-4">
        <div>
          <p className="text-xs font-semibold uppercase tracking-widest text-indigo-500 dark:text-indigo-400 mb-1">
            {tier === 'paid' ? 'Daily' : 'Weekly'} Quest Log · {new Date().toLocaleDateString('en-SG', { day: 'numeric', month: 'short' })}
          </p>
          <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100">
            {tier === 'paid' ? "Today's Study Plan" : "This Week's Study Plan"}
          </h1>
          {tier !== 'paid' && validUntil && (
            <p className="mt-0.5 text-xs text-slate-400 dark:text-slate-500">
              Refreshes {new Date(`${validUntil}T00:00:00+08:00`).toLocaleDateString('en-SG', { day: 'numeric', month: 'short' })}
            </p>
          )}
          {reasoning && (
            <p className="mt-1 text-sm text-slate-500 dark:text-slate-400 leading-relaxed">
              {reasoning}
            </p>
          )}
        </div>
        <button
          onClick={() => navigate('/review')}
          className="shrink-0 text-sm text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 transition-colors"
        >
          ← Back
        </button>
      </div>

      {/* ── Progress bar ───────────────────────────────────────────────────── */}
      <div className="flex flex-col gap-2">
        <div className="flex items-center justify-between text-sm">
          <span className="font-semibold text-slate-700 dark:text-slate-300">
            {correctCount} / {total} complete
          </span>
          <span
            className={cn(
              'font-bold tabular-nums',
              pct === 100
                ? 'text-emerald-600 dark:text-emerald-400'
                : 'text-indigo-600 dark:text-indigo-400',
            )}
          >
            {pct}%
          </span>
        </div>
        <div className="h-3 rounded-full bg-slate-200 dark:bg-slate-700 overflow-hidden">
          <div
            className={cn(
              'h-full rounded-full transition-all duration-700 ease-out',
              pct === 100
                ? 'bg-emerald-500'
                : 'bg-gradient-to-r from-indigo-500 to-violet-500',
            )}
            style={{ width: `${pct}%` }}
          />
        </div>
      </div>

      {/* ── All-done celebration ───────────────────────────────────────────── */}
      {allDone && (
        <div className="rounded-2xl border border-emerald-200 dark:border-emerald-700 bg-emerald-50 dark:bg-emerald-900/25 px-6 py-5 flex flex-col items-center gap-2 text-center">
          <p className="text-4xl">🏆</p>
          <p className="text-lg font-bold text-emerald-800 dark:text-emerald-200">
            All Quests Complete!
          </p>
          <p className="text-sm text-emerald-700 dark:text-emerald-300">
            Outstanding work — you&apos;ve finished every question in today&apos;s plan.
            Come back tomorrow for a new quest log.
          </p>
          <button
            onClick={() => navigate('/review')}
            className="mt-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-sm font-semibold px-4 py-2 transition-colors"
          >
            Return to Review
          </button>
        </div>
      )}

      {/* ── Quest list ─────────────────────────────────────────────────────── */}
      <div className="flex flex-col gap-2">
        {quests.map((quest) => (
          <QuestRow
            key={quest.question_id}
            quest={quest}
            isNext={nextQuest?.question_id === quest.question_id}
            onStart={() => startQuest(quest)}
          />
        ))}
      </div>

      {/* ── Footer tip ─────────────────────────────────────────────────────── */}
      {!allDone && (
        <p className="text-xs text-center text-slate-400 dark:text-slate-500">
          Questions check off automatically when you get them correct.
          Your progress is saved for today.
        </p>
      )}
    </div>
  )
}
