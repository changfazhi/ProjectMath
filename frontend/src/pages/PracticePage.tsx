import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import type { Difficulty } from '../types/api'
import { usePracticeSession } from '../hooks/usePracticeSession'
import { QuestionCard } from '../components/question/QuestionCard'
import { AnswerInput } from '../components/question/AnswerInput'
import { SolutionReveal } from '../components/question/SolutionReveal'
import { StatsBar } from '../components/progress/StatsBar'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'
import { Button } from '../components/ui/Button'
import { cn } from '../lib/utils'

const DIFFICULTIES: { label: string; value: Difficulty | undefined }[] = [
  { label: 'Any', value: undefined },
  { label: 'Easy', value: 1 },
  { label: 'Medium', value: 2 },
  { label: 'Hard', value: 3 },
]

export function PracticePage() {
  const { topicId } = useParams<{ topicId: string }>()
  const [difficulty, setDifficulty] = useState<Difficulty | undefined>(undefined)

  const session = usePracticeSession(topicId ?? '', difficulty)

  useEffect(() => {
    session.loadNext()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [topicId])

  function handleDifficultyChange(d: Difficulty | undefined) {
    setDifficulty(d)
    session.reset(d) // pass new difficulty directly — avoids stale ref on first load
  }

  return (
    <div className="max-w-2xl mx-auto px-4 py-8 flex flex-col gap-6">
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

      {(session.phase === 'answering' || session.phase === 'submitted' || session.phase === 'revealed') &&
        session.question && (
          <div className="flex flex-col gap-4">
            <QuestionCard question={session.question} />

            {session.phase !== 'revealed' && (
              <AnswerInput
                question={session.question}
                onSubmit={session.submitAnswer}
                disabled={session.phase === 'submitted'}
                loading={session.phase === 'submitted'}
              />
            )}

            {session.phase === 'revealed' && session.result && (
              <SolutionReveal result={session.result} onNext={session.nextQuestion} />
            )}
          </div>
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
            <Button onClick={session.reset}>Practice Again</Button>
            <Button variant="secondary" onClick={() => (window.location.href = '/')}>
              Back to Topics
            </Button>
          </div>
        </div>
      )}

      {session.phase === 'error' && session.error && (
        <ErrorMessage message={session.error} onRetry={session.reset} />
      )}
    </div>
  )
}
