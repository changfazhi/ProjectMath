import type { QuestionPublic } from '../../types/api'
import { Card } from '../ui/Card'
import { QuestionHeader } from './QuestionHeader'
import { renderLatex } from '../../lib/renderLatex'

interface Props {
  question: QuestionPublic
}

export function QuestionCard({ question }: Props) {
  return (
    <Card className="mb-4">
      <QuestionHeader question={question} />
      {question.prompt_latex && (
        <div className="text-lg leading-relaxed text-slate-800 dark:text-slate-100 whitespace-pre-line">
          {renderLatex(question.prompt_latex)}
        </div>
      )}
    </Card>
  )
}
