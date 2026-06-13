import { useCallback, useState } from 'react'

const KEY = 'math_trainer_visited_topics'

function loadVisited(): Set<string> {
  try {
    const raw = localStorage.getItem(KEY)
    if (!raw) return new Set()
    return new Set(JSON.parse(raw) as string[])
  } catch {
    return new Set()
  }
}

export function useVisitedTopics() {
  const [visited, setVisited] = useState<Set<string>>(loadVisited)

  const markVisited = useCallback((topicId: string) => {
    setVisited((prev) => {
      if (prev.has(topicId)) return prev
      const next = new Set(prev)
      next.add(topicId)
      localStorage.setItem(KEY, JSON.stringify([...next]))
      return next
    })
  }, [])

  return { visited, markVisited }
}
