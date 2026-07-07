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
        // Outer span: mount-only slide-in (stable across increments).
        <span className="inline-flex animate-slide-in-right motion-reduce:animate-none">
          {/* key={streak} remounts on each increment to replay bounce/wiggle/pop */}
          <span
            key={streak}
            className="inline-flex items-center gap-1.5 rounded-full bg-gradient-to-r from-amber-400 to-orange-500 px-3 py-1 text-xs font-semibold text-white shadow-lg shadow-amber-500/30 dark:shadow-amber-500/20 animate-pill-bounce motion-reduce:animate-none"
          >
            <span className="animate-flame-wiggle motion-reduce:animate-none">🔥</span>
            <span>Streak</span>
            <span className="tabular-nums text-sm animate-num-pop motion-reduce:animate-none">{streak}</span>
          </span>
        </span>
      )}
    </div>
  )
}
