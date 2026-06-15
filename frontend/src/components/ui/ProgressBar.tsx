interface Props {
  correct: number
  total: number
  fillClass: string
  size?: 'sm' | 'md'
}

export function ProgressBar({ correct, total, fillClass, size = 'md' }: Props) {
  const pct = total > 0 ? (correct / total) * 100 : 0
  const h = size === 'sm' ? 'h-1' : 'h-2'
  return (
    <div className={`w-full ${h} bg-slate-200 dark:bg-slate-700 rounded-full overflow-hidden`}>
      <div
        className={`h-full ${fillClass} rounded-full transition-all duration-300`}
        style={{ width: `${pct}%` }}
      />
    </div>
  )
}
