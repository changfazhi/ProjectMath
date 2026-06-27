---
phase: 02-firestore-sync-and-live-quest-status
plan: "02"
subsystem: frontend-hooks
status: complete
tags: [live-refresh, focus-event, visibilitychange, quest-status, attempts-api]
dependency_graph:
  requires: [02-01]
  provides: [SYNC-01, SYNC-02]
  affects: [frontend/src/hooks/useStudyPlan.ts]
tech_stack:
  added: []
  patterns:
    - "refreshKey state as a re-fetch trigger (no debounce needed — user-driven refocus)"
    - "window 'focus' + document 'visibilitychange' event pair for tab/window return detection"
    - "Functional state updater setRefreshKey(k => k + 1) avoids stale-closure capture"
key_files:
  created: []
  modified:
    - frontend/src/hooks/useStudyPlan.ts
decisions:
  - "Use refreshKey integer state (bump-on-event) rather than a shared load function ref to minimise coupling to the load effect's internal logic"
  - "Gate both listeners on isOpen so closed-sidebar renders register no event overhead"
  - "No debounce: each user focus is intentional and fires at most a single GET /api/attempts; cancelled guard prevents overlapping resolves"
metrics:
  duration_seconds: 59
  completed: "2026-06-27T14:50:40Z"
  tasks_completed: 1
  tasks_total: 1
  files_changed: 1
requirements: [SYNC-01, SYNC-02]
---

# Phase 02 Plan 02: Live Quest Status Refresh on Focus/Visibility Summary

**One-liner:** `refreshKey` state + `window 'focus'` / `document 'visibilitychange'` listeners re-derive quest status from `api.attempts.list()` when the student returns to the tab while the sidebar is open.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Re-derive quest status on window focus and visibility change | 37183bf | `frontend/src/hooks/useStudyPlan.ts` |

## What Was Built

Added a lightweight focus/visibility re-fetch mechanism to `useStudyPlan`:

1. **`refreshKey` state** — a `number` initialized to `0`. When bumped, React re-runs the existing load effect because `refreshKey` is added to its dependency array.

2. **Second effect** (focus/visibility listeners) — runs only while `isOpen` is true:
   - `window.addEventListener('focus', onFocus)` — fires when the browser window regains focus (e.g., student clicks back to the app from the practice tab).
   - `document.addEventListener('visibilitychange', onVisibilityChange)` — fires when the tab becomes visible again (`document.visibilityState === 'visible'`); covers tab-switch scenarios.
   - Both call `setRefreshKey(k => k + 1)` using the functional updater form to avoid stale closure.
   - Both listeners are removed in the effect's cleanup, so they are torn down when `isOpen` flips to `false`.

3. **Load effect** — unchanged except `refreshKey` is appended to the dependency array `[isOpen, user?.uid, authLoading, refreshKey]`. The `cancelled` guard already prevents stale responses from overlapping fetches.

**SYNC-01 satisfied:** Returning to the app after answering a question re-fetches `api.attempts.list()` and re-derives `'correct' | 'attempted' | 'pending'` for each quest — no full page reload needed.

**SYNC-02 satisfied:** The hook contains no `setDoc`, `updateDoc`, or any localStorage status write. Status is computed in-memory on every load; the attempts API is the single source of truth.

**Signature preserved:** `useStudyPlan(isOpen: boolean)` — `StudyPlanSidebar.tsx` required no changes.

## Deviations from Plan

None — plan executed exactly as written.

## Verification

- `npx tsc -b` exited 0 (no output).
- `grep -c "visibilitychange" src/hooks/useStudyPlan.ts` → 3 (addEventListener, removeEventListener, guard condition).
- `grep -c "addEventListener('focus'" src/hooks/useStudyPlan.ts` → 1.
- `grep -c "api.attempts.list" src/hooks/useStudyPlan.ts` → 2 (one call in load(), one in the session_id-based variant imported from api.ts).

## Known Stubs

None — the re-fetch wires directly into the existing load function with no placeholder data.

## Threat Flags

No new network endpoints, auth paths, file access patterns, or schema changes introduced. The single GET `/api/attempts` call already existed; the only change is that it may now fire more frequently (on user-driven refocus events). Already covered by T-02-02-D (accepted low-severity DoS risk).

## Self-Check: PASSED

- File exists: `/Users/chang/ProjectMath/.claude/worktrees/graceful-crafting-dusk/frontend/src/hooks/useStudyPlan.ts` ✓
- Commit 37183bf exists in git log ✓
- `npx tsc -b` exits 0 ✓
