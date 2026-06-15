import type { QuestionPublic } from '../../types/api'
import { Badge } from '../ui/Badge'
import { Card } from '../ui/Card'
import { renderLatex } from '../../lib/renderLatex'

const difficultyLabel: Record<number, string> = { 1: 'Easy', 2: 'Medium', 3: 'Hard' }
const difficultyVariant = {
  1: 'success',
  2: 'warning',
  3: 'danger',
} as const

interface Props {
  question: QuestionPublic
}

export function QuestionCard({ question }: Props) {
  return (
    <Card className="mb-4">
      <div className="flex items-center gap-2 mb-4 flex-wrap">
        <Badge variant={difficultyVariant[question.difficulty]}>
          {difficultyLabel[question.difficulty]}
        </Badge>
        <Badge variant="neutral">{question.marks} {question.marks === 1 ? 'mark' : 'marks'}</Badge>
        {question.source && (
          <span className="text-xs text-slate-500 dark:text-slate-400 ml-auto">{question.source}</span>
        )}
      </div>
      <div className="text-lg leading-relaxed text-slate-800 dark:text-slate-100 whitespace-pre-line">
        {renderLatex(question.prompt_latex)}
      </div>
    </Card>
  )
}
