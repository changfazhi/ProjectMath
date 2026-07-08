import { useEffect } from 'react'

// Non-blocking full-screen tick celebration; parent unmounts it via onDone (~1.3s).
export function CorrectCelebration({ onDone }: { onDone: () => void }) {
  // setTimeout (not onAnimationEnd): animation-end events never fire under
  // motion-reduce:animate-none, which would leak the overlay.
  useEffect(() => {
    const t = setTimeout(onDone, 1300)
    return () => clearTimeout(t)
  }, [onDone])

  return (
    <div
      className="fixed inset-0 z-[60] pointer-events-none flex items-center justify-center"
      aria-hidden="true"
    >
      <div className="relative animate-celebrate-out motion-reduce:animate-none">
        {/* expanding ring */}
        <div className="absolute inset-0 rounded-full border-4 border-green-400 animate-ring-burst motion-reduce:hidden" />
        {/* tick disc */}
        <div className="w-24 h-24 rounded-full bg-green-500 shadow-xl shadow-green-500/40 flex items-center justify-center animate-tick-pop motion-reduce:animate-none">
          <svg
            className="w-12 h-12 text-white"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            strokeWidth={3}
          >
            <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
          </svg>
        </div>
      </div>
    </div>
  )
}
