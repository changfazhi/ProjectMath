---
plan: 01-01
phase: 01-collapsible-sidebar-with-local-plan
status: complete
completed_at: 2026-06-27
---

# Plan 01-01 Summary — Walking Skeleton Sidebar

## What Was Built

Delivered the full end-to-end walking skeleton for the Phase 1 sidebar milestone:

- **`frontend/src/lib/studyPlan.ts`** — Shared localStorage helpers: `StoredPlan` interface, `PLAN_KEY`, `todayStr()`, `savePlan()`, `loadStoredPlan()` (returns `{ plan, isStale }` — always returns the stored plan regardless of date so the stale UI can render it).
- **`frontend/src/types/api.ts`** — Added `QuestStatus = 'correct' | 'attempted' | 'pending'` union type.
- **`frontend/src/pages/StudyPlanPage.tsx`** — Refactored to import from `lib/studyPlan`; no local duplicates. `loadPlan()` now destructures `{ plan: stored, isStale }` and only uses a stored plan when `!isStale`.
- **`frontend/src/hooks/useStudyPlan.ts`** — `Quest` interface (extends `StudyPlanItem` with `status` + `index`); `useStudyPlan(isOpen)` hook that fetches `api.attempts.list()` only when `isOpen` is true, deriving correct/attempted/pending status. Re-fetches on every open (refresh-on-open). No Firebase import.
- **`frontend/src/components/sidebar/QuestItem.tsx`** — Semantic `<button>` row with distinct SVG icons for correct (emerald check), attempted (amber return arrow), and pending (slate numbered badge). Full dark mode support.
- **`frontend/src/components/layout/StudyPlanSidebar.tsx`** — Fixed blue trigger tab (left-0, top-1/2, w-10 h-20, rounded-r-2xl, z-50) + backdrop + 280px sliding panel. Header with "Today's Plan" title + close button, progress summary + ProgressBar, scrollable quest list with Spinner during load. Default collapsed.
- **`frontend/src/App.tsx`** — `StudyPlanSidebar` mounted in `RootLayout` as a sibling of `<main>` inside `div.relative.flex-1.overflow-hidden`. MobileUploadPage route unchanged.
- **`frontend/src/pages/ReviewPage.tsx`** — Fixed pre-existing missing `ReviewItem` import (blocked build).

## Self-Check: PASSED

- `tsc -b` exits 0 (clean — no type errors in new or changed files)
- Lint errors: 17 pre-existing errors (same count as before; no new errors introduced)
- All acceptance criteria met:
  - `loadStoredPlan` returns `{ plan, isStale }` ✓
  - `QuestStatus` exported from `types/api.ts` ✓
  - `StudyPlanPage.tsx` imports from `lib/studyPlan`, no local duplicates ✓
  - `useStudyPlan` has no Firebase/Firestore import ✓
  - `useStudyPlan` effect depends on `isOpen` ✓
  - `QuestItem` renders as `<button>` with distinct status rendering ✓
  - `StudyPlanSidebar` initializes `isOpen` with `useState(false)` ✓
  - Locked trigger tab classes applied ✓
  - Quest click navigates without changing `isOpen` ✓
  - `StudyPlanSidebar` mounted in `RootLayout`, `/m/:token` unchanged ✓

## Key Files Created

- `frontend/src/lib/studyPlan.ts`
- `frontend/src/hooks/useStudyPlan.ts`
- `frontend/src/components/sidebar/QuestItem.tsx`
- `frontend/src/components/layout/StudyPlanSidebar.tsx`

## Deviations

None. Skeleton intentionally omits empty/stale/error states and full accessibility — deferred to Plan 01-02.
