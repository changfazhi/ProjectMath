import { useRef, useState } from 'react'
import type { QuestionPart, QuestionPublic } from '../../types/api'
import type { PartState } from '../../hooks/usePracticeSession'
import { renderLatex } from '../../lib/renderLatex'
import { MathField, type MathFieldHandle } from '../math/MathField'
import { MathKeyboard } from '../math/MathKeyboard'
import { Button } from '../ui/Button'
import { cn } from '../../lib/utils'

interface PartInputProps {
  part: QuestionPart
  partState: PartState
  onSubmit: (answer: string, fieldAnswers?: { key: string; value: string }[]) => void
}

// Renders one labelled box per field for a multi-value part (e.g. "find a, b and c").
// All boxes share a single Submit; the part is graded correct only if every field matches.
function MultiFieldInput({ part, partState, onSubmit }: PartInputProps) {
  const fields = part.answers ?? []
  const mathRefs = useRef<Record<string, MathFieldHandle | null>>({})
  const inputRefs = useRef<Record<string, HTMLInputElement | null>>({})
  const [activeKey, setActiveKey] = useState<string | null>(null)
  const [showKeyboard, setShowKeyboard] = useState(false)

  const disabled = partState.phase === 'submitting'
  const loading = partState.phase === 'submitting'

  function submit() {
    const fieldAnswers: { key: string; value: string }[] = []
    for (const f of fields) {
      const value =
        f.answer_type === 'range'
          ? inputRefs.current[f.key]?.value.trim() ?? ''
          : mathRefs.current[f.key]?.getValue().trim() ?? ''
      fieldAnswers.push({ key: f.key, value })
    }
    if (fieldAnswers.some((fa) => fa.value === '')) return
    const display = fieldAnswers.map((fa) => `${fa.key} = ${fa.value}`).join(', ')
    onSubmit(display, fieldAnswers)
  }

  return (
    <div className="flex flex-col gap-3">
      {fields.map((f) => (
        <div key={f.key} className="flex items-center gap-3">
          <span className="font-mono text-sm text-slate-600 dark:text-slate-300 shrink-0 min-w-[2.5rem] text-right">
            {renderLatex(f.label)} =
          </span>
          {f.answer_type === 'range' ? (
            <input
              ref={(el) => { inputRefs.current[f.key] = el }}
              type="number"
              step="any"
              disabled={disabled}
              onFocus={() => setActiveKey(f.key)}
              onKeyDown={(e) => { if (e.key === 'Enter') submit() }}
              placeholder="Enter a number"
              className="flex-1 px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 font-mono text-base focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
            />
          ) : (
            <div className="flex-1" onFocus={() => setActiveKey(f.key)}>
              <MathField
                ref={(el) => { mathRefs.current[f.key] = el }}
                onChange={() => {}}
                disabled={disabled}
                className={cn(
                  'border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100',
                  'focus-within:ring-2 focus-within:ring-blue-500',
                )}
              />
            </div>
          )}
        </div>
      ))}
      <div className="flex gap-2 flex-wrap">
        <button
          type="button"
          onClick={() => {
            setShowKeyboard((v) => !v)
            if (!showKeyboard && activeKey) setTimeout(() => mathRefs.current[activeKey]?.focus(), 50)
          }}
          disabled={disabled}
          className={cn(
            'inline-flex items-center gap-1.5 px-4 py-2 rounded-xl border text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed',
            showKeyboard
              ? 'border-blue-500 bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300'
              : 'border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:border-blue-400',
          )}
        >
          <span>⌨</span> Math Input
        </button>
        <Button onClick={submit} disabled={disabled} loading={loading} size="lg" className="flex-1">
          Submit ({part.label})
        </Button>
      </div>
      {showKeyboard && !disabled && (
        <MathKeyboard onInsert={(latex) => { if (activeKey) mathRefs.current[activeKey]?.insert(latex) }} />
      )}
    </div>
  )
}

function PartInput({ part, partState, onSubmit }: PartInputProps) {
  const mathRef = useRef<MathFieldHandle>(null)
  const [showKeyboard, setShowKeyboard] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  const disabled = partState.phase === 'submitting'
  const loading = partState.phase === 'submitting'

  function submit() {
    if (part.answer_type === 'range') {
      const value = inputRef.current?.value.trim() ?? ''
      if (value !== '') onSubmit(value)
    } else {
      const value = mathRef.current?.getValue().trim() ?? ''
      if (value) onSubmit(value)
    }
  }

  if (part.answers && part.answers.length > 0) {
    if (partState.phase === 'done') {
      return (
        <div
          className={cn(
            'rounded-lg px-4 py-3 text-sm',
            partState.isCorrect
              ? 'bg-green-50 dark:bg-green-900/25 border border-green-200 dark:border-green-800'
              : 'bg-red-50 dark:bg-red-900/25 border border-red-200 dark:border-red-800',
          )}
        >
          <span className={cn('font-semibold', partState.isCorrect ? 'text-green-800 dark:text-green-300' : 'text-red-800 dark:text-red-300')}>
            {partState.isCorrect ? '✓ Correct' : '✗ Incorrect'}
          </span>
        </div>
      )
    }
    return <MultiFieldInput part={part} partState={partState} onSubmit={onSubmit} />
  }

  if (partState.phase === 'done') {
    return (
      <div
        className={cn(
          'rounded-lg px-4 py-3 text-sm',
          partState.isCorrect
            ? 'bg-green-50 dark:bg-green-900/25 border border-green-200 dark:border-green-800'
            : 'bg-red-50 dark:bg-red-900/25 border border-red-200 dark:border-red-800',
        )}
      >
        <span className={cn('font-semibold', partState.isCorrect ? 'text-green-800 dark:text-green-300' : 'text-red-800 dark:text-red-300')}>
          {partState.isCorrect ? '✓ Correct' : '✗ Incorrect'}
        </span>
      </div>
    )
  }

  if (part.answer_type === 'range') {
    return (
      <div className="flex flex-col gap-2">
        <input
          ref={inputRef}
          type="number"
          step="any"
          disabled={disabled}
          onKeyDown={(e) => { if (e.key === 'Enter') submit() }}
          placeholder="Enter a number"
          className="w-full px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 font-mono text-base focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
        />
        {part.tolerance !== null && (
          <p className="text-xs text-slate-500 dark:text-slate-400">Answer accepted within ±{part.tolerance}</p>
        )}
        <Button onClick={submit} disabled={disabled} loading={loading} size="lg">
          Submit ({part.label})
        </Button>
      </div>
    )
  }

  // exact input
  return (
    <div className="flex flex-col gap-2">
      <MathField
        ref={mathRef}
        onChange={() => {}}
        disabled={disabled}
        className={cn(
          'border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100',
          'focus-within:ring-2 focus-within:ring-blue-500',
        )}
      />
      <div className="flex gap-2 flex-wrap">
        <button
          type="button"
          onClick={() => {
            setShowKeyboard((v) => !v)
            if (!showKeyboard) setTimeout(() => mathRef.current?.focus(), 50)
          }}
          disabled={disabled}
          className={cn(
            'inline-flex items-center gap-1.5 px-4 py-2 rounded-xl border text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed',
            showKeyboard
              ? 'border-blue-500 bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300'
              : 'border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:border-blue-400',
          )}
        >
          <span>⌨</span> Math Input
        </button>
        <Button onClick={submit} disabled={disabled} loading={loading} size="lg" className="flex-1">
          Submit ({part.label})
        </Button>
      </div>
      {showKeyboard && !disabled && (
        <MathKeyboard onInsert={(latex) => mathRef.current?.insert(latex)} />
      )}
    </div>
  )
}

interface Props {
  question: QuestionPublic
  partStates: Record<string, PartState>
  onSubmitPart: (label: string, answer: string, fieldAnswers?: { key: string; value: string }[]) => void
  revealed: boolean
}

export function MultiPartQuestion({ question, partStates, onSubmitPart, revealed }: Props) {
  const parts = question.parts ?? []

  return (
    <div className="flex flex-col">
      {parts.map((part) => {
        const partState = partStates[part.label] ?? { phase: 'idle' as const }
        const isShowThat = part.answer_type === null && !(part.answers && part.answers.length > 0)

        return (
          <div
            key={part.label}
            className="py-4 border-t border-slate-100 dark:border-slate-800 flex flex-col gap-3"
          >
            <div className="flex items-start gap-3">
              <span className="font-bold text-slate-700 dark:text-slate-300 text-base shrink-0">
                ({part.label})
              </span>
              <div className="text-base leading-relaxed text-slate-800 dark:text-slate-100 whitespace-pre-line">
                {renderLatex(part.prompt_latex)}
              </div>
            </div>

            {isShowThat ? (
              <span className="text-xs text-slate-500 dark:text-slate-400 border border-slate-200 dark:border-slate-700 rounded-md px-2 py-1 w-fit">
                Show that — no submission required
              </span>
            ) : (
              !revealed && (
                <PartInput
                  part={part}
                  partState={partState}
                  onSubmit={(answer, fieldAnswers) => onSubmitPart(part.label, answer, fieldAnswers)}
                />
              )
            )}

            {partState.phase === 'done' && revealed && (
              <div
                className={cn(
                  'rounded-lg px-4 py-3 text-sm',
                  partState.isCorrect
                    ? 'bg-green-50 dark:bg-green-900/25 border border-green-200 dark:border-green-800'
                    : 'bg-red-50 dark:bg-red-900/25 border border-red-200 dark:border-red-800',
                )}
              >
                <span className={cn('font-semibold', partState.isCorrect ? 'text-green-800 dark:text-green-300' : 'text-red-800 dark:text-red-300')}>
                  {partState.isCorrect ? '✓ Correct' : '✗ Incorrect'}
                </span>
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}
