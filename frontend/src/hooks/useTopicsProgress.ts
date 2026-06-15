import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import { getSessionId } from '../lib/session'

export function useTopicsProgress() {
  const sessionId = getSessionId()
  const [progress, setProgress] = useState<Map<string, { correct: number; total: number }>>(
    new Map(),
  )

  useEffect(() => {
    api.topics
      .progress(sessionId)
      .then((data) => {
        setProgress(new Map(data.map((p) => [p.topic_id, { correct: p.correct, total: p.total }])))
      })
      .catch(() => {})
  }, [sessionId])

  return progress
}
