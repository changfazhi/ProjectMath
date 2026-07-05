import { doc, getDoc, setDoc } from 'firebase/firestore'
import { db } from './firebase'
import type { StudyPlanItem } from '../types/api'

export interface StoredPlan {
  date: string
  valid_until?: string // first SGT date the plan is stale (server-computed; free = weekly)
  items: StudyPlanItem[]
  reasoning: string
}

export const PLAN_KEY = 'study_plan_v1'

// "Today" in Asia/Singapore (UTC+8, no DST) — matches the backend's day boundary.
export function todayStr() {
  return new Date(Date.now() + 8 * 3_600_000).toISOString().slice(0, 10)
}

// Plans persisted before valid_until existed are treated as stale — the server
// returns the same plan back for free users, so nothing regenerates early.
function isPlanStale(p: StoredPlan): boolean {
  return !p.valid_until || todayStr() >= p.valid_until
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
    return { plan: p, isStale: isPlanStale(p) }
  } catch {
    return { plan: null, isStale: false }
  }
}

// ── Firestore helpers ─────────────────────────────────────────────────────────

/**
 * Write the study plan to Firestore at users/{uid}/study_plans/current.
 * A single fixed doc (not date-keyed) so a still-valid week-old free plan can be
 * found from another device; the plan carries its own valid_until.
 */
export async function savePlanRemote(uid: string, plan: StoredPlan): Promise<void> {
  const ref = doc(db, 'users', uid, 'study_plans', 'current')
  await setDoc(ref, plan)
}

/**
 * Read the current study plan from Firestore for the given user.
 * Returns null when no doc exists, the stored items array is invalid, or the plan is stale.
 */
export async function loadRemotePlan(uid: string): Promise<StoredPlan | null> {
  const ref = doc(db, 'users', uid, 'study_plans', 'current')
  const snap = await getDoc(ref)
  if (!snap.exists()) return null
  const data = snap.data() as StoredPlan
  if (!Array.isArray(data.items)) return null
  if (isPlanStale(data)) return null
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

const FIRESTORE_TIMEOUT_MS = 5000

/**
 * Unified read: localStorage-first for today's plan (same-device fast path).
 * Falls through to Firestore when localStorage has no plan or it is stale
 * (cross-device sync — e.g. user opens on a second device).
 * Falls back to whatever localStorage held on any Firestore failure or timeout.
 */
export async function resolvePlan(
  uid: string | null,
): Promise<{ plan: StoredPlan | null; isStale: boolean }> {
  const local = loadStoredPlan()

  // Fast path: today's plan is already in localStorage — skip Firestore entirely.
  if (local.plan && !local.isStale) {
    return local
  }

  // localStorage miss or stale → try Firestore for cross-device sync (PERS-01/PERS-03).
  if (uid !== null) {
    try {
      const remote = await Promise.race([
        loadRemotePlan(uid),
        new Promise<never>((_, reject) =>
          setTimeout(() => reject(new Error('firestore-timeout')), FIRESTORE_TIMEOUT_MS),
        ),
      ])
      if (remote !== null) {
        savePlan(remote)
        return { plan: remote, isStale: false }
      }
    } catch {
      // Firestore unavailable / timeout / rules error — degrade to local cache (T-02-01-D)
    }
  }
  return local
}
