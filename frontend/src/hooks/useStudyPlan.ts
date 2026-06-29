import { useEffect, useState } from 'react'
import { useLocation } from 'react-router-dom'
import { api } from '../lib/api'
import { loadStoredPlan, savePlan, todayStr } from '../lib/studyPlan'
import type { StudyPlanItem, QuestStatus } from '../types/api'

export interface Quest extends StudyPlanItem {
  status: QuestStatus
  index: number
}

function computeStatuses(items: StudyPlanItem[], attempts: { question_id: string; is_correct: boolean }[]): Quest[] {
  const planIds = new Set(items.map(i => i.question_id))
  const scoped = attempts.filter(a => planIds.has(a.question_id))
  const correctIds = new Set<string>()
  const incorrectIds = new Set<string>()
  for (const a of scoped) {
    if (a.is_correct) correctIds.add(a.question_id)
    else incorrectIds.add(a.question_id)
  }
  // A question is 'correct' only when it has a correct attempt and no subsequent wrong one
  const correctSet = new Set([...correctIds].filter(id => !incorrectIds.has(id)))
  const triedSet = new Set(scoped.map(a => a.question_id))
  return items.map((item, i) => ({
    ...item,
    index: i,
    status: correctSet.has(item.question_id)
      ? 'correct'
      : triedSet.has(item.question_id)
        ? 'attempted'
        : 'pending',
  }))
}

export function useStudyPlan(isOpen: boolean) {
  const location = useLocation()
  const [quests, setQuests] = useState<Quest[]>([])
  const [isStale, setIsStale] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  // Bumped on window focus / tab visibility to trigger a status re-derive (SYNC-01)
  const [refreshKey, setRefreshKey] = useState(0)

  // Cache plan items so focus-triggered refreshes only re-query attempts, not Firestore
  const planItemsRef = useRef<StudyPlanItem[] | null>(null)

  // Full load: Firestore + attempts. Runs when sidebar opens or auth settles.
  useEffect(() => {
    if (!isOpen) {
      planItemsRef.current = null  // clear cache so next open re-reads from Firestore
      return
    }
    if (authLoading) return

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
        planItemsRef.current = plan.items
        const allAttempts = await api.attempts.list()
        if (cancelled) return
        if (!cancelled) {
          setQuests(computeStatuses(plan.items, allAttempts))
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
  }, [isOpen, location.key])

  const correctCount = quests.filter(q => q.status === 'correct').length
  const total = quests.length

  return { quests, isStale, loading, error, correctCount, total }
}
