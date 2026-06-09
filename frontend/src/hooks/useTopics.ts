import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import type { MathLevel, Topic } from '../types/api'

export function useTopics(level?: MathLevel) {
  const [topics, setTopics] = useState<Topic[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    let cancelled = false
    setLoading(true)
    setError(null)
    api.topics
      .list(level)
      .then((data) => {
        if (!cancelled) {
          setTopics(data)
          setLoading(false)
        }
      })
      .catch((err: Error) => {
        if (!cancelled) {
          setError(err.message)
          setLoading(false)
        }
      })
    return () => {
      cancelled = true
    }
  }, [level])

  return { topics, loading, error }
}
