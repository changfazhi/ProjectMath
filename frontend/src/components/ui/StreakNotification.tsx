import { useEffect, useState } from 'react'

interface Props {
  streakCount: number
  onClose: () => void
}

export function StreakNotification({ streakCount, onClose }: Props) {
  // Animated count-up 0 → streakCount over ~800ms (skipped for 1-day streaks / reduced motion).
  const [display, setDisplay] = useState(streakCount <= 1 ? streakCount : 0)

  useEffect(() => {
    if (streakCount <= 1) return
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
      setDisplay(streakCount)
      return
    }
    let raf = 0
    const start = performance.now()
    const DUR = 800
    const step = (t: number) => {
      const p = Math.min(1, (t - start) / DUR)
      const eased = 1 - Math.pow(1 - p, 3)
      setDisplay(Math.max(1, Math.round(eased * streakCount)))
      if (p < 1) raf = requestAnimationFrame(step)
    }
    raf = requestAnimationFrame(step)
    return () => cancelAnimationFrame(raf)
  }, [streakCount])

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm animate-fade-in">
      <div className="relative bg-white dark:bg-slate-900 rounded-2xl p-8 flex flex-col items-center gap-3 shadow-2xl max-w-xs w-full mx-4 text-center animate-scale-in motion-reduce:animate-none">
        <button
          onClick={onClose}
          className="absolute top-3 right-3 p-1 rounded-full text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
          aria-label="Close"
        >
          <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" d="M18 6L6 18M6 6l12 12" />
          </svg>
        </button>
        <div className="text-5xl animate-flame-pulse motion-reduce:animate-none">🔥</div>
        <h2 className="text-lg font-bold text-slate-900 dark:text-slate-100">Daily Streak</h2>
        <p className="text-4xl font-bold text-orange-500 tabular-nums">
          {display} {streakCount === 1 ? 'day' : 'days'}
        </p>
        <p className="text-sm text-slate-500 dark:text-slate-400">Keep up the good work!</p>
      </div>
    </div>
  )
}
