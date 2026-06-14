import type { SubmitAttemptResponse } from '../../types/api'
import { Button } from '../ui/Button'
import { Latex } from '../math/Latex'
import { renderLatex } from '../../lib/renderLatex'

interface Props {
  result: SubmitAttemptResponse
  onNext: () => void
}

export function SolutionReveal({ result, onNext }: Props) {
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
        {!result.is_correct && (
          <p className="text-sm mt-1 text-slate-700 dark:text-slate-300">
            Correct answer:{' '}
            <Latex className="text-sm">{result.correct_answer}</Latex>
          </p>
        )}
      </div>

      <div className="rounded-xl p-5 bg-slate-50 dark:bg-slate-800/60 border border-slate-200 dark:border-slate-700">
        <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">
          Solution
        </p>
        <div className="text-base leading-relaxed text-slate-800 dark:text-slate-100">
          {renderLatex(result.solution_latex)}
        </div>
      </div>

      <Button onClick={onNext} size="lg" className="self-start">
        Next Question →
      </Button>
    </div>
  )
}
