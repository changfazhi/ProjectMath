import { useRef, useState } from 'react'
import { Button } from '../ui/Button'
import { MathField, type MathFieldHandle } from '../math/MathField'
import { MathKeyboard } from '../math/MathKeyboard'
import { cn } from '../../lib/utils'

interface Props {
  onSubmit: (answer: string) => void
  disabled: boolean
  loading: boolean
}

export function ExactInput({ onSubmit, disabled, loading }: Props) {
  const mathRef = useRef<MathFieldHandle>(null)
  const [showKeyboard, setShowKeyboard] = useState(false)

  function submit() {
    const value = mathRef.current?.getValue().trim() ?? ''
    if (value) onSubmit(value)
  }

  function insertSymbol(latex: string) {
    mathRef.current?.insert(latex)
  }

  return (
    <div className="flex flex-col gap-3">
      <MathField
        ref={mathRef}
        onChange={() => {}}
        disabled={disabled}
        className={cn(
          'border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100',
          'focus-within:ring-2 focus-within:ring-blue-500',
        )}
      />

      {/* Math keyboard toggle + submit row */}
      <div className="flex gap-2 flex-wrap">
        <button
          type="button"
          onClick={() => {
            setShowKeyboard((v) => !v)
            if (!showKeyboard) {
              // Delay focus so the keyboard has rendered
              setTimeout(() => mathRef.current?.focus(), 50)
            }
          }}
          disabled={disabled}
          className={cn(
            'inline-flex items-center gap-1.5 px-4 py-2 rounded-xl border text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed',
            showKeyboard
              ? 'border-blue-500 bg-blue-50 dark:bg-blue-950 text-blue-700 dark:text-blue-300'
              : 'border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-slate-700 dark:text-slate-300 hover:border-blue-400',
          )}
        >
          <span>⌨</span>
          Math Input
        </button>

        <Button onClick={submit} disabled={disabled} loading={loading} size="lg" className="flex-1">
          Submit Answer
        </Button>
      </div>

      {showKeyboard && !disabled && (
        <MathKeyboard onInsert={insertSymbol} />
      )}
    </div>
  )
}
