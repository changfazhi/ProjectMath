import { useRef, useState } from 'react'
import { Button } from '../ui/Button'
import { MathField, type FieldInputMode, type MathFieldHandle } from '../math/MathField'
import { MathKeyboard } from '../math/MathKeyboard'
import { cn, isTouchDevice } from '../../lib/utils'

interface Props {
  onSubmit: (answer: string) => void
  disabled: boolean
  loading: boolean
}

export function ExactInput({ onSubmit, disabled, loading }: Props) {
  const mathRef = useRef<MathFieldHandle>(null)
  // On touch, the two keyboards are mutually exclusive: the answer box raises the OS keyboard,
  // the palette button raises the LaTeX palette. Both write into the same field.
  const [keyboardMode, setKeyboardMode] = useState<FieldInputMode>('native')
  const showKeyboard = keyboardMode === 'math'

  function submit() {
    const value = mathRef.current?.getValue().trim() ?? ''
    if (value) onSubmit(value)
  }

  function insertSymbol(latex: string) {
    mathRef.current?.insert(latex)
  }

  // Selecting the answer box hands the field back to the OS keyboard. Touch only — on desktop
  // there is no OS keyboard to swap and clicking the field must not close the palette.
  function selectAnswerBox() {
    if (!isTouchDevice() || keyboardMode === 'native') return
    setKeyboardMode('native')
    mathRef.current?.setInputMode('native')
  }

  function toggleMathKeyboard() {
    const next: FieldInputMode = keyboardMode === 'math' ? 'native' : 'math'
    setKeyboardMode(next)
    // Order matters — focusing after the mode is set means the browser reads the right
    // inputmode: 'math' keeps the OS keyboard down, 'native' brings it back up. Pressing the
    // button blurred the field, so the focus() is also what returns the caret to it. Desktop
    // keeps today's behaviour of only focusing when the palette opens.
    mathRef.current?.setInputMode(next)
    if (next === 'math' || isTouchDevice()) mathRef.current?.focus()
  }

  return (
    <div className="flex flex-col gap-3">
      <div onPointerDown={selectAnswerBox}>
        <MathField
          ref={mathRef}
          onChange={() => {}}
          disabled={disabled}
          className={cn(
            'border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100',
            'focus-within:ring-2 focus-within:ring-blue-500',
          )}
        />
      </div>

      {/* Math keyboard toggle + submit row */}
      <div className="flex gap-2 flex-wrap">
        <button
          type="button"
          onClick={toggleMathKeyboard}
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
