import { useEffect, useState } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import type { Attempt, Difficulty } from '../types/api'
import { usePracticeSession } from '../hooks/usePracticeSession'
import { QuestionCard } from '../components/question/QuestionCard'
import { AnswerInput } from '../components/question/AnswerInput'
import { MultiPartQuestion } from '../components/question/MultiPartQuestion'
import { SolutionReveal } from '../components/question/SolutionReveal'
import { StatsBar } from '../components/progress/StatsBar'
import { Badge } from '../components/ui/Badge'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'
import { Button } from '../components/ui/Button'
import { StreakNotification } from '../components/ui/StreakNotification'
import { ChatPanel } from '../components/chat/ChatPanel'
import { useChatSession } from '../hooks/useChatSession'
import { api } from '../lib/api'
import { cn, formatTime } from '../lib/utils'

function getActivityDate(): string {
  return new Date(Date.now() - 16 * 60 * 60 * 1000).toISOString().slice(0, 10)
}

type Tab = 'question' | 'attempts' | 'hints'

const TABS: { id: Tab; label: string }[] = [
  { id: 'question', label: 'Question' },
  { id: 'attempts', label: 'Attempts' },
  { id: 'hints', label: 'Hints' },
]

const DIFFICULTIES: { label: string; value: Difficulty | undefined }[] = [
  { label: 'Any', value: undefined },
  { label: 'Easy', value: 1 },
  { label: 'Medium', value: 2 },
  { label: 'Hard', value: 3 },
]

export function PracticePage() {
  const { topicId } = useParams<{ topicId: string }>()
  const [searchParams] = useSearchParams()
  const initialQuestionId = searchParams.get('question_id') ?? undefined

  const [difficulty, setDifficulty] = useState<Difficulty | undefined>(undefined)
  const [activeTab, setActiveTab] = useState<Tab>('question')
  const [notification, setNotification] = useState<{ show: boolean; streakCount: number }>({
    show: false,
    streakCount: 0,
  })

  // Attempts tab state
  const [attemptsList, setAttemptsList] = useState<Attempt[]>([])
  const [attemptsLoading, setAttemptsLoading] = useState(false)
  const [attemptsError, setAttemptsError] = useState<string | null>(null)

  const session = usePracticeSession(topicId ?? '', difficulty)

  // One shared chat instance drives both the desktop side panel and the mobile Hints tab.
  const chat = useChatSession(session.question?.id)

  // Reset to Question tab whenever the active question changes
  useEffect(() => {
    setActiveTab('question')
  }, [session.question?.id])

  // Lazily fetch attempts when Attempts tab is activated
  useEffect(() => {
    if (activeTab !== 'attempts' || !session.question?.id) return
    setAttemptsLoading(true)
    setAttemptsError(null)
    api.attempts
      .list(session.sessionId, session.question.id)
      .then(setAttemptsList)
      .catch((e: Error) => setAttemptsError(e.message))
      .finally(() => setAttemptsLoading(false))
  }, [activeTab, session.question?.id, session.sessionId])

  // Show streak notification once per day on first correct answer
  useEffect(() => {
    if (session.phase !== 'revealed' || !session.result?.is_correct) return
    const today = getActivityDate()
    if (localStorage.getItem('streak_notified_date') === today) return
    api.streaks.get(session.sessionId).then((stats) => {
      if (stats.currentStreak > 0) {
        setNotification({ show: true, streakCount: stats.currentStreak })
        localStorage.setItem('streak_notified_date', today)
      }
    }).catch(() => {})
  }, [session.phase, session.result, session.sessionId])

  useEffect(() => {
    if (initialQuestionId) {
      session.loadSpecific(initialQuestionId)
    } else {
      session.loadNext()
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [topicId])

  function handleDifficultyChange(d: Difficulty | undefined) {
    setDifficulty(d)
    session.reset(d)
  }

  const hasActiveQuestion =
    (session.phase === 'answering' ||
      session.phase === 'submitted' ||
      session.phase === 'revealed') &&
    session.question != null

  return (
    <div className="max-w-2xl lg:max-w-6xl mx-auto px-4 py-8 lg:flex lg:gap-6 lg:items-start">
      <div className="flex flex-col gap-6 lg:flex-1 lg:min-w-0">
      <div className="flex items-center gap-3">
        <Link to="/" className="text-blue-600 hover:text-blue-700 text-sm">
          ← Topics
        </Link>
      </div>

      {/* Difficulty filter */}
      <div className="flex items-center gap-2 flex-wrap">
        <span className="text-sm text-slate-500 dark:text-slate-400 mr-1">Difficulty:</span>
        {DIFFICULTIES.map((d) => (
          <button
            key={d.label}
            onClick={() => handleDifficultyChange(d.value)}
            className={cn(
              'px-3 py-1 text-sm rounded-lg border transition-colors',
              difficulty === d.value
                ? 'border-blue-600 bg-blue-600 text-white'
                : 'border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-300 hover:border-blue-400',
            )}
          >
            {d.label}
          </button>
        ))}
      </div>

      <StatsBar
        correct={session.sessionCorrect}
        total={session.sessionTotal}
        streak={session.streak}
      />

      {session.phase === 'loading' && (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      )}

      {/* Tab bar — only shown when a question is active */}
      {hasActiveQuestion && (
        <div className="flex border-b border-slate-200 dark:border-slate-800 -mb-2">
          {TABS.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={cn(
                'px-4 py-2 text-sm font-medium transition-colors border-b-2 -mb-px',
                activeTab === tab.id
                  ? 'border-blue-600 text-blue-600 dark:border-blue-400 dark:text-blue-400'
                  : 'border-transparent text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-slate-200',
              )}
            >
              {tab.label}
            </button>
          ))}
        </div>
      )}

      {/* Question tab */}
      {hasActiveQuestion && activeTab === 'question' && (
        <div className="flex flex-col gap-4">
          <QuestionCard question={session.question!} />

          {session.question!.parts ? (
            <>
              {(session.phase === 'answering' || session.phase === 'revealed') && (
                <MultiPartQuestion
                  question={session.question!}
                  partStates={session.partStates}
                  onSubmitPart={session.submitPart}
                  revealed={session.phase === 'revealed'}
                />
              )}
              {session.phase === 'revealed' && session.result && (
                <SolutionReveal result={session.result} onNext={session.nextQuestion} />
              )}
            </>
          ) : (
            <>
              {session.phase !== 'revealed' && (
                <AnswerInput
                  question={session.question!}
                  onSubmit={session.submitAnswer}
                  disabled={session.phase === 'submitted'}
                  loading={session.phase === 'submitted'}
                />
              )}
              {session.phase === 'revealed' && session.result && (
                <SolutionReveal result={session.result} onNext={session.nextQuestion} />
              )}
            </>
          )}
        </div>
      )}

      {/* Attempts tab */}
      {hasActiveQuestion && activeTab === 'attempts' && (
        <div>
          {attemptsLoading && (
            <div className="flex justify-center py-10">
              <Spinner size="lg" />
            </div>
          )}
          {attemptsError && (
            <p className="text-sm text-red-500">{attemptsError}</p>
          )}
          {!attemptsLoading && !attemptsError && attemptsList.length === 0 && (
            <p className="text-sm text-slate-500 dark:text-slate-400 py-6 text-center">
              No attempts yet
            </p>
          )}
          {!attemptsLoading && !attemptsError && attemptsList.length > 0 && (
            <div className="rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 overflow-hidden">
              <table className="w-full text-left">
                <thead className="bg-slate-50 dark:bg-slate-800/60 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">
                  <tr>
                    <th className="py-3 px-4">Date</th>
                    <th className="py-3 px-4">Your Answer</th>
                    <th className="py-3 px-4">Result</th>
                    <th className="py-3 px-4">Time</th>
                  </tr>
                </thead>
                <tbody>
                  {attemptsList.map((a) => {
                    const date = new Date(a.attempted_at)
                    return (
                      <tr
                        key={a.id}
                        className="border-b border-slate-100 dark:border-slate-800 last:border-0"
                      >
                        <td className="py-3 px-4 text-sm text-slate-600 dark:text-slate-400 whitespace-nowrap">
                          {date.toLocaleDateString()}{' '}
                          {date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                        </td>
                        <td className="py-3 px-4 text-sm font-mono text-slate-700 dark:text-slate-300">
                          {a.answer_given}
                        </td>
                        <td className="py-3 px-4">
                          <Badge variant={a.is_correct ? 'success' : 'danger'}>
                            {a.is_correct ? 'Correct' : 'Incorrect'}
                          </Badge>
                        </td>
                        <td className="py-3 px-4 text-sm text-slate-500 dark:text-slate-400">
                          {a.time_taken_s != null ? formatTime(a.time_taken_s) : '—'}
                        </td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {/* Hints tab — chat panel on mobile (desktop uses the side rail) */}
      {hasActiveQuestion && activeTab === 'hints' && (
        <ChatPanel chat={chat} className="lg:hidden h-[28rem]" />
      )}

      {session.phase === 'complete' && (
        <div className="rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-8 flex flex-col items-center gap-4 text-center">
          <div className="text-4xl">🎉</div>
          <h2 className="text-xl font-semibold text-slate-900 dark:text-slate-100">
            Topic complete!
          </h2>
          <p className="text-slate-500 dark:text-slate-400 text-sm">
            You answered {session.sessionCorrect} out of {session.sessionTotal} correctly.
          </p>
          <div className="flex gap-3 flex-wrap justify-center">
            <Button onClick={() => session.reset()}>Practice Again</Button>
            <Button variant="secondary" onClick={() => (window.location.href = '/')}>
              Back to Topics
            </Button>
          </div>
        </div>
      )}

      {session.phase === 'error' && session.error && (
        <ErrorMessage message={session.error} onRetry={session.reset} />
      )}

      {notification.show && (
        <StreakNotification
          streakCount={notification.streakCount}
          onClose={() => setNotification(n => ({ ...n, show: false }))}
        />
      )}
      </div>

      {/* Desktop side rail — chat beside the question (mobile uses the Hints tab) */}
      {hasActiveQuestion && (
        <ChatPanel
          chat={chat}
          className="hidden lg:flex w-96 shrink-0 sticky top-8 self-start max-h-[calc(100vh-4rem)]"
        />
      )}
    </div>
  )
}
