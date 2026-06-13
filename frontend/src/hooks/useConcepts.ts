import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import type { TopicConcept } from '../types/api'

export function useConcepts(topicId: string | null) {
  const [concepts, setConcepts] = useState<TopicConcept[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!topicId) {
      setConcepts([])
      return
    }
    let cancelled = false
    setLoading(true)
    setError(null)
    api.topics
      .concepts(topicId)
      .then((data) => {
        if (!cancelled) {
          setConcepts(data)
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
  }, [topicId])

  return { concepts, loading, error }
}
