import type { QuestionPublic } from '../../types/api'
import { Badge } from '../ui/Badge'

const difficultyLabel: Record<number, string> = { 1: 'Easy', 2: 'Medium', 3: 'Hard' }
const difficultyVariant = { 1: 'success', 2: 'warning', 3: 'danger' } as const

interface Props {
  question: QuestionPublic
}

export function QuestionHeader({ question }: Props) {
  return (
    <div className="mb-3">
      <div className="flex items-center gap-2 flex-wrap">
        <Badge variant={difficultyVariant[question.difficulty]}>
          {difficultyLabel[question.difficulty]}
        </Badge>
        <Badge variant="neutral">
          {question.marks} {question.marks === 1 ? 'mark' : 'marks'}
        </Badge>
        {question.source && (
          <span className="text-xs text-slate-500 dark:text-slate-400 ml-auto">{question.source}</span>
        )}
      </div>
      {question.name && (
        <p className="text-xs font-medium text-slate-400 dark:text-slate-500 uppercase tracking-wide mt-2">
          {question.name}
        </p>
      )}
    </div>
  )
}
