import { useCallback, useEffect, useState } from 'react'
import { api } from '../lib/api'
import type { Attempt } from '../types/api'

export function useAttemptHistory(sessionId: string) {
  const [attempts, setAttempts] = useState<Attempt[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetch = useCallback(() => {
    setLoading(true)
    setError(null)
    api.attempts
      .list(sessionId)
      .then((data) => {
        setAttempts(data)
        setLoading(false)
      })
      .catch((err: Error) => {
        setError(err.message)
        setLoading(false)
      })
  }, [sessionId])

  useEffect(() => {
    fetch()
  }, [fetch])

  return { attempts, loading, error, refetch: fetch }
}
