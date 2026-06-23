import type { GradeResponse, GradingPartResult, GradingVerdict } from '../../types/api'
import { Badge } from '../ui/Badge'
import { renderLatex } from '../../lib/renderLatex'

const VERDICT: Record<GradingVerdict, { label: string; variant: 'success' | 'warning' | 'danger' }> = {
  correct: { label: '✓ Correct', variant: 'success' },
  partial: { label: '~ Partial', variant: 'warning' },
  incorrect: { label: '✗ Incorrect', variant: 'danger' },
}

function PartCard({ part }: { part: GradingPartResult }) {
  const v = VERDICT[part.verdict] ?? VERDICT.incorrect
  return (
    <div className="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-4 flex flex-col gap-3">
      <div className="flex items-center justify-between gap-2">
        <span className="font-semibold text-slate-800 dark:text-slate-100">
          {part.label === 'whole' ? 'Your solution' : `Part (${part.label})`}
        </span>
        <div className="flex items-center gap-2">
          <Badge variant={v.variant}>{v.label}</Badge>
          <span className="text-sm font-medium text-slate-600 dark:text-slate-300">
            {part.marks_awarded} / {part.marks_total} marks
          </span>
        </div>
      </div>

      {part.summary && (
        <div className="text-sm text-slate-700 dark:text-slate-300 leading-relaxed">
          {renderLatex(part.summary)}
        </div>
      )}

      {part.errors.length > 0 && (
        <div>
          <p className="text-xs font-semibold uppercase tracking-wider text-red-600 dark:text-red-400 mb-1">
            Key errors
          </p>
          <ul className="flex flex-col gap-1.5">
            {part.errors.map((e, i) => (
              <li key={i} className="text-sm text-slate-700 dark:text-slate-300">
                <span className="font-medium text-slate-900 dark:text-slate-100">{e.step}: </span>
                {renderLatex(e.description)}
              </li>
            ))}
          </ul>
        </div>
      )}

      {part.hints.length > 0 && (
        <div>
          <p className="text-xs font-semibold uppercase tracking-wider text-blue-600 dark:text-blue-400 mb-1">
            Hints
          </p>
          <ul className="list-disc list-inside flex flex-col gap-1">
            {part.hints.map((h, i) => (
              <li key={i} className="text-sm text-slate-700 dark:text-slate-300">
                {renderLatex(h)}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  )
}

export function GradingResult({ grading }: { grading: GradeResponse }) {
  const pct = grading.marks_total > 0 ? Math.round((grading.marks_awarded / grading.marks_total) * 100) : 0
  return (
    <div className="flex flex-col gap-4 animate-fade-in">
      <div
        className={
          grading.is_correct
            ? 'rounded-xl p-4 bg-green-50 dark:bg-green-900/25 border border-green-200 dark:border-green-800'
            : 'rounded-xl p-4 bg-amber-50 dark:bg-amber-900/25 border border-amber-200 dark:border-amber-800'
        }
      >
        <div className="flex items-center justify-between gap-3">
          <p className="font-semibold text-base text-slate-800 dark:text-slate-100">
            {grading.is_correct ? '✓ Full marks!' : 'AI feedback'}
          </p>
          <span className="text-lg font-bold text-slate-900 dark:text-slate-100">
            {grading.marks_awarded} / {grading.marks_total}
            <span className="ml-2 text-sm font-normal text-slate-500 dark:text-slate-400">({pct}%)</span>
          </span>
        </div>
        {grading.overall_feedback && (
          <div className="mt-2 text-sm text-slate-700 dark:text-slate-300 leading-relaxed">
            {renderLatex(grading.overall_feedback)}
          </div>
        )}
      </div>

      {grading.ignored_images.length > 0 && (
        <p className="text-xs text-slate-500 dark:text-slate-400">
          Ignored {grading.ignored_images.map((g) => `Photo ${g.index} (${g.reason})`).join(', ')}.
        </p>
      )}

      <div className="flex flex-col gap-3">
        {grading.parts.map((p) => (
          <PartCard key={p.label} part={p} />
        ))}
      </div>
    </div>
  )
}
