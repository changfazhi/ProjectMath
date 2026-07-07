import { useEffect, useState } from 'react'

// Live seconds remaining until an ISO timestamp — drives cooldown countdowns.
export function useCountdown(resetAt?: string): number {
  const [remaining, setRemaining] = useState(0)
  useEffect(() => {
    if (!resetAt) {
      setRemaining(0)
      return
    }
    const target = new Date(resetAt).getTime()
    const tick = () => setRemaining(Math.max(0, Math.ceil((target - Date.now()) / 1000)))
    tick()
    const id = setInterval(tick, 500)
    return () => clearInterval(id)
  }, [resetAt])
  return remaining
}

// True once `active` has stayed true for `delayMs` — swaps in a reassurance message
// when an AI request is taking a while (queued or held behind other requests).
export function useSlowLoad(active: boolean, delayMs = 4000): boolean {
  const [slow, setSlow] = useState(false)
  useEffect(() => {
    if (!active) {
      setSlow(false)
      return
    }
    const id = setTimeout(() => setSlow(true), delayMs)
    return () => clearTimeout(id)
  }, [active, delayMs])
  return slow
}
