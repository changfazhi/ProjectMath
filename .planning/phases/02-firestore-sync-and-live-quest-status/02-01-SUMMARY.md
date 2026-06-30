---
plan: 02-01
phase: 02-firestore-sync-and-live-quest-status
status: complete
completed_at: 2026-06-29
commit: e7771bc
---

# Plan 02-01 Summary — Live Quest Status Refresh

## What Was Done

Added `useLocation().key` as a dependency to the `useStudyPlan` effect in `frontend/src/hooks/useStudyPlan.ts`. Three-line change: import `useLocation`, call it inside the hook, add `location.key` to the `[isOpen]` dependency array.

## One-liner

Quest statuses in the sidebar now refresh automatically on every navigation event while the sidebar is open — no page reload needed after answering a practice question.

## Must-Haves Verified

- ✓ Quest statuses update when user navigates back from practice — `location.key` changes trigger a re-run of the status derivation
- ✓ Plan is NOT re-fetched from network on navigation — `loadStoredPlan()` short-circuits the plan fetch via localStorage (synchronous)
- ✓ Status is derived from `api.attempts.list()` on every navigation event while open
- ✓ Sidebar does nothing while closed — `if (!isOpen) return` guard is unchanged

## Files Changed

- `frontend/src/hooks/useStudyPlan.ts` — +3 lines (import, call, dependency)

## TypeScript

`npx tsc --noEmit` — clean, no errors.
