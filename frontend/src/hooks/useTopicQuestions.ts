import { useCallback, useEffect, useState } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../contexts/AuthContext'
import type { QuestionWithStatus } from '../types/api'

export function useTopicQuestions(topicId: string | null) {
  const { user } = useAuth()
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
      api.topics.questions(topicId),
      api.stars.list(topicId),
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
  }, [topicId, user])

  const toggleStar = useCallback(
    async (questionId: string) => {
      setStarredIds((prev) => {
        const next = new Set(prev)
        if (next.has(questionId)) next.delete(questionId)
        else next.add(questionId)
        return next
      })
      try {
        const { starred } = await api.stars.toggle(questionId)
        setStarredIds((prev) => {
          const next = new Set(prev)
          if (starred) next.add(questionId)
          else next.delete(questionId)
          return next
        })
      } catch {
        setStarredIds((prev) => {
          const next = new Set(prev)
          if (next.has(questionId)) next.delete(questionId)
          else next.add(questionId)
          return next
        })
      }
    },
    [],
  )

  return { questions, starredIds, toggleStar, loading, error }
}
