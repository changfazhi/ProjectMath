---
phase: 02-firestore-sync-and-live-quest-status
plan: "01"
subsystem: frontend/persistence
tags: [firestore, firebase, study-plan, persistence, auth]
dependency_graph:
  requires: [01-02]
  provides: [PERS-01, PERS-02, PERS-03]
  affects: [frontend/src/lib/firebase.ts, frontend/src/lib/studyPlan.ts, frontend/src/hooks/useStudyPlan.ts, frontend/src/pages/StudyPlanPage.tsx]
tech_stack:
  added: [firebase/firestore (getFirestore, doc, getDoc, setDoc) — Firestore client-side writes]
  patterns: [Firestore-first read with localStorage write-through cache, auth-gated async loading, cancelled-ref cleanup guard]
key_files:
  created: []
  modified:
    - frontend/src/lib/firebase.ts
    - frontend/src/lib/studyPlan.ts
    - frontend/src/hooks/useStudyPlan.ts
    - frontend/src/pages/StudyPlanPage.tsx
decisions:
  - "Firestore doc path users/{uid}/study_plans/{YYYY-MM-DD}: one doc per user per day — simple key, idempotent overwrite on regeneration"
  - "resolvePlan wraps remote read in try/catch and falls back to localStorage so Firestore unavailability (T-02-01-D) never breaks the sidebar"
  - "persistPlan writes localStorage first (synchronous) then awaits Firestore — anonymous users (uid null) hit only the localStorage branch (PERS-02)"
  - "useStudyPlan gates on authLoading before calling resolvePlan to avoid reading Firestore with a stale (null) uid that resolves to a real uid moments later"
metrics:
  duration_minutes: 15
  completed: "2026-06-27"
  tasks_completed: 3
  tasks_total: 3
  files_changed: 4
status: complete
---

# Phase 02 Plan 01: Firestore Sync + Persistence Helpers Summary

Layered Firestore-first persistence for signed-in users using Firestore as the source of truth and localStorage as a fast-load write-through cache; anonymous users keep the existing localStorage-only path.

## Tasks Completed

| # | Name | Commit | Files |
|---|------|--------|-------|
| 1 | Add Firestore client + Firestore-aware persistence helpers | bef9440 | firebase.ts, studyPlan.ts |
| 2 | Write generated plans through persistPlan in StudyPlanPage | 0815423 | StudyPlanPage.tsx |
| 3 | Resolve the sidebar plan Firestore-first in useStudyPlan | ac8d25a | useStudyPlan.ts |

## What Was Built

**`frontend/src/lib/firebase.ts`** — Added `getFirestore(app)` import and exported `db` alongside the existing `auth` export. No new npm dependency (firebase ^12.15 already installed).

**`frontend/src/lib/studyPlan.ts`** — Added four async Firestore-aware helpers while keeping all existing localStorage exports (`savePlan`, `loadStoredPlan`, `todayStr`, `PLAN_KEY`, `StoredPlan`) unchanged in signature:
- `savePlanRemote(uid, plan)` — writes `StoredPlan` to `users/{uid}/study_plans/{date}` via `setDoc`
- `loadRemotePlan(uid)` — reads today's doc via `getDoc`; returns typed `StoredPlan | null`
- `persistPlan(uid | null, plan)` — always writes localStorage; writes Firestore only when uid is non-null (PERS-02 anonymous gate)
- `resolvePlan(uid | null)` — Firestore-first when uid present, write-through to localStorage on hit, try/catch fallback to localStorage on any Firestore error (T-02-01-D)

**`frontend/src/pages/StudyPlanPage.tsx`** — Replaced `loadStoredPlan` + `savePlan` with `resolvePlan` + `persistPlan`; added `useAuth()` to get the uid; added `user?.uid` to the `useEffect` dependency array so the plan re-resolves when auth settles.

**`frontend/src/hooks/useStudyPlan.ts`** — Replaced synchronous `loadStoredPlan()` with `await resolvePlan(user?.uid ?? null)`; added `authLoading` guard (returns early while auth is still resolving); extended dependency array to `[isOpen, user?.uid, authLoading]`; preserved `cancelled` cleanup guard and all status-derivation logic via `api.attempts.list()` unchanged.

## Deviations from Plan

None — plan executed exactly as written.

## Threat Surface Scan

No new network endpoints introduced. Firestore access path (`users/{uid}/study_plans/{date}`) is exactly the path described in the plan's threat model and security-rules user_setup. The `T-02-01-I / T-02-01-T` mitigations depend on Firestore security rules being published by the operator (documented in `user_setup` in the PLAN.md) — client-side code correctly scopes every read/write to `useAuth().user.uid`.

## Known Stubs

None — the Firestore path is live code. Cross-device verification requires the operator to enable Firestore and publish the ownership security rules (see PLAN.md `user_setup`).

## Self-Check: PASSED

- `frontend/src/lib/firebase.ts` — present, exports `db`
- `frontend/src/lib/studyPlan.ts` — present, exports 4 new helpers + all original exports
- `frontend/src/hooks/useStudyPlan.ts` — present, uses `resolvePlan` + `useAuth`
- `frontend/src/pages/StudyPlanPage.tsx` — present, uses `persistPlan` + `resolvePlan` + `useAuth`
- Commits bef9440, 0815423, ac8d25a confirmed in git log
- `npx tsc -b` exits 0
