import type { SubmitAttemptResponse } from '../../types/api'
import { Button } from '../ui/Button'

interface Props {
  result: SubmitAttemptResponse
  onNext: () => void
  onRetry?: () => void
}

export function SolutionReveal({ result, onNext, onRetry }: Props) {
  return (
    <div className="flex flex-col gap-4 animate-fade-in">
      <div
        className={
          result.is_correct
            ? 'rounded-xl p-4 bg-green-50 dark:bg-green-900/25 border border-green-200 dark:border-green-800'
            : 'rounded-xl p-4 bg-red-50 dark:bg-red-900/25 border border-red-200 dark:border-red-800'
        }
      >
        <p className={`font-semibold text-base ${result.is_correct ? 'text-green-800 dark:text-green-300' : 'text-red-800 dark:text-red-300'}`}>
          {result.is_correct ? '✓ Correct!' : '✗ Incorrect'}
        </p>
      </div>

      <div className="flex gap-3 flex-wrap">
        {!result.is_correct && onRetry && (
          <Button onClick={onRetry} size="lg" variant="secondary">
            Try Again
          </Button>
        )}
        <Button onClick={onNext} size="lg">
          Next Question →
        </Button>
      </div>
    </div>
  )
}
