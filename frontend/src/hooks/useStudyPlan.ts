import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import { loadStoredPlan } from '../lib/studyPlan'
import type { StudyPlanItem, QuestStatus } from '../types/api'

export interface Quest extends StudyPlanItem {
  status: QuestStatus
  index: number
}

export function useStudyPlan(isOpen: boolean) {
  const [quests, setQuests] = useState<Quest[]>([])
  const [isStale, setIsStale] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!isOpen) return

    let cancelled = false

    async function load() {
      setLoading(true)
      setError(null)
      try {
        const { plan, isStale: stale } = loadStoredPlan()
        if (!plan) {
          if (!cancelled) {
            setQuests([])
            setIsStale(false)
          }
          return
        }
        const attempts = await api.attempts.list()
        if (cancelled) return
        const correctSet = new Set(attempts.filter(a => a.is_correct).map(a => a.question_id))
        const triedSet = new Set(attempts.map(a => a.question_id))
        const q: Quest[] = plan.items.map((item, i) => ({
          ...item,
          index: i,
          status: correctSet.has(item.question_id)
            ? 'correct'
            : triedSet.has(item.question_id)
              ? 'attempted'
              : 'pending',
        }))
        if (!cancelled) {
          setQuests(q)
          setIsStale(stale)
        }
      } catch (err) {
        if (!cancelled) setError((err as Error).message)
      } finally {
        if (!cancelled) setLoading(false)
      }
    }

    load()
    return () => {
      cancelled = true
    }
  }, [isOpen])

  const correctCount = quests.filter(q => q.status === 'correct').length
  const total = quests.length

  return { quests, isStale, loading, error, correctCount, total }
}
