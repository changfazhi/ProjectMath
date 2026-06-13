import { useCallback, useEffect, useState } from 'react'
import { api } from '../lib/api'
import type { QuestionWithStatus } from '../types/api'

export function useTopicQuestions(topicId: string | null, sessionId: string) {
  const [questions, setQuestions] = useState<QuestionWithStatus[]>([])
  const [starredIds, setStarredIds] = useState<Set<string>>(new Set())
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!topicId) {
      setQuestions([])
      setStarredIds(new Set())
      return
    }
    let cancelled = false
    setLoading(true)
    setError(null)

    Promise.all([
      api.topics.questions(topicId, sessionId),
      api.stars.list(sessionId, topicId),
    ])
      .then(([qs, starred]) => {
        if (!cancelled) {
          setQuestions(qs)
          setStarredIds(new Set(starred))
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
  }, [topicId, sessionId])

  const toggleStar = useCallback(
    async (questionId: string) => {
      // Optimistic update
      setStarredIds((prev) => {
        const next = new Set(prev)
        if (next.has(questionId)) next.delete(questionId)
        else next.add(questionId)
        return next
      })
      try {
        const { starred } = await api.stars.toggle(sessionId, questionId)
        // Sync with server response in case optimistic update was wrong
        setStarredIds((prev) => {
          const next = new Set(prev)
          if (starred) next.add(questionId)
          else next.delete(questionId)
          return next
        })
      } catch {
        // Revert optimistic update on failure
        setStarredIds((prev) => {
          const next = new Set(prev)
          if (next.has(questionId)) next.delete(questionId)
          else next.add(questionId)
          return next
        })
      }
    },
    [sessionId],
  )

  return { questions, starredIds, toggleStar, loading, error }
}
