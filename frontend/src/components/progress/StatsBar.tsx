interface Props {
  correct: number
  total: number
  streak: number
}

export function StatsBar({ correct, total, streak }: Props) {
  const pct = total > 0 ? Math.round((correct / total) * 100) : 0
  return (
    <div className="flex items-center gap-4 text-sm text-slate-600 dark:text-slate-400 flex-wrap">
      <span>
        Correct:{' '}
        <strong className="text-slate-900 dark:text-slate-100">
          {correct}/{total}
        </strong>{' '}
        {total > 0 && <span className="text-xs">({pct}%)</span>}
      </span>
      {streak > 1 && (
        <span className="text-amber-600 dark:text-amber-400 font-medium">
          🔥 Streak: {streak}
        </span>
      )}
    </div>
  )
}
