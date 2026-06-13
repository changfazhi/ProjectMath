import type { QuestionPublic } from '../../types/api'
import { ExactInput } from './ExactInput'
import { RangeInput } from './RangeInput'

interface Props {
  question: QuestionPublic
  onSubmit: (answer: string) => void
  disabled: boolean
  loading: boolean
}

export function AnswerInput({ question, onSubmit, disabled, loading }: Props) {
  if (question.answer_type === 'range') {
    return (
      <RangeInput
        tolerance={question.tolerance}
        onSubmit={onSubmit}
        disabled={disabled}
        loading={loading}
      />
    )
  }
  return <ExactInput onSubmit={onSubmit} disabled={disabled} loading={loading} />
}
