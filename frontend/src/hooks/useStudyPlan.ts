import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import { loadStoredPlan, savePlan, todayStr } from '../lib/studyPlan'
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
        let { plan, isStale: stale } = loadStoredPlan()
        if (!plan) {
          // No local cache — fetch from server (which returns the DB-saved plan or generates one).
          const fresh = await api.review.studyPlan()
          if (cancelled) return
          if (!fresh.items.length) {
            if (!cancelled) { setQuests([]); setIsStale(false) }
            return
          }
          savePlan({ date: todayStr(), items: fresh.items, reasoning: fresh.reasoning })
          plan = { date: todayStr(), items: fresh.items, reasoning: fresh.reasoning }
          stale = false
        }
        const planQuestionIds = new Set(plan.items.map(item => item.question_id))
        const allAttempts = await api.attempts.list()
        if (cancelled) return
        // Scope to only the plan's questions so unrelated history doesn't inflate status
        const attempts = allAttempts.filter(a => planQuestionIds.has(a.question_id))
        const correctIds = new Set<string>()
        const incorrectIds = new Set<string>()
        for (const a of attempts) {
          if (a.is_correct) correctIds.add(a.question_id)
          else incorrectIds.add(a.question_id)
        }
        // A question is 'correct' only when all its attempts are correct (multi-part safety)
        const correctSet = new Set([...correctIds].filter(id => !incorrectIds.has(id)))
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
