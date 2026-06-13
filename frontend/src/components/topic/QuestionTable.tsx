import type { AttemptStatus, QuestionWithStatus } from '../../types/api'
import { Badge } from '../ui/Badge'
import { cn } from '../../lib/utils'

const difficultyLabel: Record<number, string> = { 1: 'Easy', 2: 'Medium', 3: 'Hard' }
const difficultyVariant = { 1: 'success', 2: 'warning', 3: 'danger' } as const

function StatusIcon({ status }: { status: AttemptStatus }) {
  if (status === 'correct') {
    return (
      <span className="inline-flex items-center justify-center w-5 h-5 rounded-full bg-green-100 dark:bg-green-900/40">
        <svg className="w-3 h-3 text-green-600 dark:text-green-400" viewBox="0 0 12 12" fill="none">
          <path d="M2 6l3 3 5-5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" />
        </svg>
      </span>
    )
  }
  if (status === 'attempted') {
    return (
      <span className="inline-flex items-center justify-center w-5 h-5 rounded-full bg-red-100 dark:bg-red-900/40">
        <svg className="w-3 h-3 text-red-500 dark:text-red-400" viewBox="0 0 12 12" fill="none">
          <path d="M3 3l6 6M9 3l-6 6" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
        </svg>
      </span>
    )
  }
  return (
    <span className="inline-flex items-center justify-center w-5 h-5">
      <span className="w-3.5 h-3.5 rounded-full border-2 border-slate-300 dark:border-slate-600" />
    </span>
  )
}

function StarButton({ starred, onClick }: { starred: boolean; onClick: () => void }) {
  return (
    <button
      onClick={(e) => {
        e.stopPropagation()
        onClick()
      }}
      className="p-1 rounded hover:bg-slate-100 dark:hover:bg-slate-700 transition-colors"
      aria-label={starred ? 'Unstar question' : 'Star question'}
    >
      {starred ? (
        <svg className="w-4 h-4 text-amber-400" viewBox="0 0 20 20" fill="currentColor">
          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.957a1 1 0 00.95.69h4.162c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.286 3.957c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.784.57-1.838-.197-1.539-1.118l1.285-3.957a1 1 0 00-.364-1.118L2.063 9.384c-.783-.57-.38-1.81.588-1.81h4.162a1 1 0 00.95-.69L9.049 2.927z" />
        </svg>
      ) : (
        <svg className="w-4 h-4 text-slate-400 dark:text-slate-500" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.286 3.957a1 1 0 00.95.69h4.162c.969 0 1.371 1.24.588 1.81l-3.37 2.448a1 1 0 00-.364 1.118l1.286 3.957c.3.921-.755 1.688-1.54 1.118l-3.37-2.448a1 1 0 00-1.175 0l-3.37 2.448c-.784.57-1.838-.197-1.539-1.118l1.285-3.957a1 1 0 00-.364-1.118L2.063 9.384c-.783-.57-.38-1.81.588-1.81h4.162a1 1 0 00.95-.69L9.049 2.927z" />
        </svg>
      )}
    </button>
  )
}

interface Props {
  questions: QuestionWithStatus[]
  starredIds: Set<string>
  onToggleStar: (questionId: string) => void
  onSelectQuestion: (questionId: string) => void
}

export function QuestionTable({ questions, starredIds, onToggleStar, onSelectQuestion }: Props) {
  if (questions.length === 0) {
    return (
      <p className="text-sm text-slate-400 dark:text-slate-500 italic py-4">
        No questions available for this topic yet.
      </p>
    )
  }

  return (
    <div className="overflow-hidden rounded-xl border border-slate-200 dark:border-slate-700">
      <table className="w-full text-left text-sm">
        <thead className="bg-slate-50 dark:bg-slate-800/60 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">
          <tr>
            <th className="py-2.5 px-3 w-8">Status</th>
            <th className="py-2.5 px-2 w-8">Star</th>
            <th className="py-2.5 px-3">Problem</th>
            <th className="py-2.5 px-3 text-right">Difficulty</th>
          </tr>
        </thead>
        <tbody>
          {questions.map((q, i) => (
            <tr
              key={q.id}
              onClick={() => onSelectQuestion(q.id)}
              className={cn(
                'border-t border-slate-100 dark:border-slate-800 cursor-pointer transition-colors',
                'hover:bg-slate-50 dark:hover:bg-slate-800/50',
              )}
            >
              <td className="py-3 px-3">
                <StatusIcon status={q.status} />
              </td>
              <td className="py-3 px-2">
                <StarButton starred={starredIds.has(q.id)} onClick={() => onToggleStar(q.id)} />
              </td>
              <td className="py-3 px-3 text-slate-800 dark:text-slate-200 font-medium">
                {q.name ?? `Question ${i + 1}`}
              </td>
              <td className="py-3 px-3 text-right">
                <Badge variant={difficultyVariant[q.difficulty]}>
                  {difficultyLabel[q.difficulty]}
                </Badge>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
