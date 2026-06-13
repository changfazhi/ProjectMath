import { useState } from 'react'
import { cn, parseOption } from '../../lib/utils'
import { renderLatex } from '../../lib/renderLatex'

interface Props {
  options: string[]
  onSubmit: (answer: string) => void
  disabled: boolean
}

export function McqInput({ options, onSubmit, disabled }: Props) {
  const [selected, setSelected] = useState<string | null>(null)

  function handleClick(letter: string) {
    if (disabled) return
    setSelected(letter)
    onSubmit(letter)
  }

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
      {options.map((opt) => {
        const { letter, latex } = parseOption(opt)
        const isSelected = selected === letter
        return (
          <button
            key={letter}
            disabled={disabled}
            onClick={() => handleClick(letter)}
            className={cn(
              'flex items-start gap-3 px-4 py-3 rounded-xl border-2 text-left transition-all duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:cursor-not-allowed',
              isSelected
                ? 'border-blue-600 bg-blue-50 dark:bg-blue-900/30 dark:border-blue-500'
                : 'border-slate-200 dark:border-slate-700 hover:border-blue-400 hover:bg-blue-50 dark:hover:bg-blue-900/20 bg-white dark:bg-slate-900',
              disabled && !isSelected && 'opacity-50',
            )}
          >
            <span className="shrink-0 w-6 h-6 rounded-full border-2 border-current flex items-center justify-center text-xs font-bold text-blue-600 dark:text-blue-400">
              {letter}
            </span>
            <span className="text-sm text-slate-800 dark:text-slate-100 leading-relaxed">
              {renderLatex(latex)}
            </span>
          </button>
        )
      })}
    </div>
  )
}
