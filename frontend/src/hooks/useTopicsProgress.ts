import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../contexts/AuthContext'

export function useTopicsProgress() {
  const { user } = useAuth()
  const [progress, setProgress] = useState<
    Map<string, { correct: number; attempted: number; total: number }>
  >(new Map())

  useEffect(() => {
    if (!user) {
      setProgress(new Map())
      return
    }
    api.topics
      .progress()
      .then((data) => {
        setProgress(
          new Map(
            data.map((p) => [
              p.topic_id,
              { correct: p.correct, attempted: p.attempted, total: p.total },
            ]),
          ),
        )
      })
      .catch(() => {})
  }, [user])

  return progress
}
