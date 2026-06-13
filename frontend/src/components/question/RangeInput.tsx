import { useRef, type KeyboardEvent } from 'react'
import { Button } from '../ui/Button'

interface Props {
  tolerance: number | null
  onSubmit: (answer: string) => void
  disabled: boolean
  loading: boolean
}

export function RangeInput({ tolerance, onSubmit, disabled, loading }: Props) {
  const inputRef = useRef<HTMLInputElement>(null)

  function handleKeyDown(e: KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Enter') submit()
  }

  function submit() {
    const value = inputRef.current?.value.trim() ?? ''
    if (value !== '') onSubmit(value)
  }

  const tol = tolerance ?? 0.01

  return (
    <div className="flex flex-col gap-3">
      <input
        ref={inputRef}
        type="number"
        step="any"
        disabled={disabled}
        onKeyDown={handleKeyDown}
        placeholder="Enter a number"
        className="w-full px-4 py-3 rounded-xl border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100 font-mono text-base focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:opacity-50"
      />
      <p className="text-xs text-slate-500 dark:text-slate-400">
        Answer accepted within ±{tol}
      </p>
      <Button onClick={submit} disabled={disabled} loading={loading} size="lg">
        Submit Answer
      </Button>
    </div>
  )
}
