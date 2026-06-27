import type { StudyPlanItem } from '../types/api'

export interface StoredPlan {
  date: string
  items: StudyPlanItem[]
  reasoning: string
}

export const PLAN_KEY = 'study_plan_v1'

export function todayStr() {
  return new Date().toISOString().slice(0, 10)
}

export function savePlan(plan: StoredPlan) {
  localStorage.setItem(PLAN_KEY, JSON.stringify(plan))
}

export function loadStoredPlan(): { plan: StoredPlan | null; isStale: boolean } {
  try {
    const raw = localStorage.getItem(PLAN_KEY)
    if (!raw) return { plan: null, isStale: false }
    const p = JSON.parse(raw) as StoredPlan
    if (!Array.isArray(p.items)) return { plan: null, isStale: false }
    return { plan: p, isStale: p.date !== todayStr() }
  } catch {
    return { plan: null, isStale: false }
  }
}
