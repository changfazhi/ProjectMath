import { useRef, useState } from 'react'
import type { QuestionPart, QuestionPublic } from '../../types/api'
import type { PartState } from '../../hooks/usePracticeSession'
import { renderLatex } from '../../lib/renderLatex'
import { MathField, type MathFieldHandle } from '../math/MathField'
import { MathKeyboard } from '../math/MathKeyboard'
import { Button } from '../ui/Button'
import { Latex } from '../math/Latex'
import { cn } from '../../lib/utils'

interface PartInputProps {
  part: QuestionPart
  partState: PartState
  onSubmit: (answer: string) => void
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
        {!partState.isCorrect && partState.correctAnswer && (
          <span className="ml-2 text-slate-700 dark:text-slate-300">
            Answer: <Latex className="text-sm">{partState.correctAnswer}</Latex>
          </span>
        )}
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
  onSubmitPart: (label: string, answer: string) => void
  revealed: boolean
}

export function MultiPartQuestion({ question, partStates, onSubmitPart, revealed }: Props) {
  const parts = question.parts ?? []

  return (
    <div className="flex flex-col gap-4">
      {parts.map((part) => {
        const partState = partStates[part.label] ?? { phase: 'idle' as const }
        const isShowThat = part.answer_type === null

        return (
          <div
            key={part.label}
            className="rounded-xl border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-900 p-4 flex flex-col gap-3"
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
                  onSubmit={(answer) => onSubmitPart(part.label, answer)}
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
                {!partState.isCorrect && partState.correctAnswer && (
                  <span className="ml-2 text-slate-700 dark:text-slate-300">
                    Answer: <Latex className="text-sm">{partState.correctAnswer}</Latex>
                  </span>
                )}
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}
