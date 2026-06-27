import { doc, getDoc, setDoc } from 'firebase/firestore'
import { db } from './firebase'
import type { StudyPlanItem } from '../types/api'

export interface StoredPlan {
  date: string
  items: StudyPlanItem[]
  reasoning: string
}

export const PLAN_KEY = 'study_plan_v1'

export function todayStr() {
  return new Date().toLocaleDateString('en-CA')
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

// ── Firestore helpers ─────────────────────────────────────────────────────────

/** Write a study plan to Firestore at users/{uid}/study_plans/{date}. */
export async function savePlanRemote(uid: string, plan: StoredPlan): Promise<void> {
  const ref = doc(db, 'users', uid, 'study_plans', plan.date)
  await setDoc(ref, plan)
}

/**
 * Read today's study plan from Firestore for the given user.
 * Returns null when no doc exists or the stored items array is invalid.
 */
export async function loadRemotePlan(uid: string): Promise<StoredPlan | null> {
  const ref = doc(db, 'users', uid, 'study_plans', todayStr())
  const snap = await getDoc(ref)
  if (!snap.exists()) return null
  const data = snap.data() as StoredPlan
  if (!Array.isArray(data.items)) return null
  return data
}

/**
 * Unified write: always writes to localStorage (fast-load cache).
 * When uid is non-null, also writes to Firestore (PERS-01/PERS-03).
 * Anonymous users (uid null) write only to localStorage (PERS-02).
 */
export async function persistPlan(uid: string | null, plan: StoredPlan): Promise<void> {
  savePlan(plan)
  if (uid !== null) {
    await savePlanRemote(uid, plan)
  }
}

/**
 * Unified read: Firestore-first when signed in, localStorage fallback.
 * On a Firestore hit, write-through to localStorage (refresh fast-load cache).
 * Falls back to localStorage on any Firestore failure (PERS-03 / T-02-01-D).
 * When uid is null, returns localStorage result directly (PERS-02 anonymous path).
 */
export async function resolvePlan(
  uid: string | null,
): Promise<{ plan: StoredPlan | null; isStale: boolean }> {
  if (uid !== null) {
    try {
      const remote = await loadRemotePlan(uid)
      if (remote !== null) {
        // Write-through: keep the localStorage cache fresh for fast subsequent loads
        savePlan(remote)
        // Remote docs are keyed by today's date, so they are never stale
        return { plan: remote, isStale: false }
      }
    } catch {
      // Firestore unavailable (offline / rules / transient) — degrade to cache (T-02-01-D)
    }
  }
  return loadStoredPlan()
}
