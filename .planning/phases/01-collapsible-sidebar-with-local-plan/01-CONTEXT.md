# Phase 1: Collapsible Sidebar with Local Plan - Context

**Gathered:** 2026-06-27
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 1 delivers a `StudyPlanSidebar` component permanently mounted in `RootLayout` (between `<Header />` and `<Outlet />`). It shows today's study plan from `localStorage` with correct/attempted/pending quest status icons. No Firestore, no live sync — that is Phase 2. The existing `/study-plan` page stays; the sidebar is additive.

</domain>

<decisions>
## Implementation Decisions

### Layout Integration
- **D-01:** `StudyPlanSidebar` mounts directly inside `RootLayout` in `frontend/src/App.tsx`, as a sibling of `<main>`. It is `position: fixed` so it does not affect the flex flow. The `RootLayout` div gains a `relative` wrapper around `<main>` + `<StudyPlanSidebar>` per the UI-SPEC layout contract.
- **D-02:** The sidebar's open/closed state lives in a `useState` inside `StudyPlanSidebar` (or a local hook). It is NOT persisted — it resets on browser refresh. SPA navigations (React Router) do not unmount `RootLayout`, so the sidebar naturally stays open when the user navigates to a practice question and back.

### Quest Status Refresh Strategy
- **D-03:** `useStudyPlan` re-fetches attempt statuses each time the sidebar panel opens (not on mount, not on an interval). This gives users up-to-date icons after returning from a practice question without hammering the API while the panel is closed. Implementation: pass `isOpen` into `useStudyPlan` and trigger a `useEffect` keyed on `isOpen` becoming `true`.

### Stale Plan Handling
- **D-04:** `useStudyPlan` reads the raw `study_plan_v1` localStorage value **regardless of date** and exposes an `isStale: boolean` flag (`storedPlan.date !== todayStr()`). The existing `loadStoredPlan()` in `StudyPlanPage.tsx` returns `null` for stale plans — `useStudyPlan` must differ: return `{ plan, isStale }` where a stale plan is returned (not null). The UI-SPEC's State 3 (greyed out list + "New day" banner) requires the stale plan data.

### localStorage Shared Utilities
- **D-05:** Extract localStorage read/write helpers (`loadStoredPlan`, `savePlan`, `PLAN_KEY`, `todayStr`, `StoredPlan` interface) from `StudyPlanPage.tsx` into `frontend/src/lib/studyPlan.ts`. Both `StudyPlanPage` and `useStudyPlan` import from there. Do NOT duplicate the logic.

### Component Placement
- **D-06:** New components go here:
  - `frontend/src/components/layout/StudyPlanSidebar.tsx` — root sidebar component (trigger tab + panel + backdrop)
  - `frontend/src/components/sidebar/QuestItem.tsx` — individual quest row
  - `frontend/src/hooks/useStudyPlan.ts` — plan data + status logic
  - `frontend/src/lib/studyPlan.ts` — shared localStorage helpers

### Phase 2 forward-compatibility
- **D-07:** `useStudyPlan` is localStorage-only in Phase 1. It should NOT import Firebase or Firestore. Phase 2 will augment the hook (or create a separate hook) for Firestore sync.

### Claude's Discretion
- Exact TypeScript types for `useStudyPlan` return shape (e.g., `{ plan: StoredPlan | null, isStale: boolean, statuses: Record<string, QuestStatus>, loading: boolean, error: string | null }`) — planner decides the right shape
- Whether to combine the trigger tab and panel into one component or split them — follow what feels cleanest given the z-index layering
- Whether to put `isOpen` state in `StudyPlanSidebar` or hoist it to `RootLayout` — keep it local unless a future need to control it from outside arises

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### UI Design Contract (primary spec)
- `.planning/phases/01-collapsible-sidebar-with-local-plan/01-UI-SPEC.md` — Full visual/interaction contract: layout, colors, typography, spacing, states, accessibility, copywriting. All visual decisions are locked here.

### Existing Code to Modify / Extend
- `frontend/src/App.tsx` — `RootLayout` function; this is where `StudyPlanSidebar` is mounted
- `frontend/src/pages/StudyPlanPage.tsx` — contains existing `loadStoredPlan()`, `savePlan()`, `StoredPlan` interface, `PLAN_KEY` constant, `todayStr()` — extract these to `lib/studyPlan.ts`
- `frontend/src/types/api.ts` — `StudyPlanItem` type already defined here; `QuestStatus` type to be added

### Architecture Constraints
- `CLAUDE.md` §Key Conventions — Tailwind via `cn()`, no inline styles, no CSS Modules, no per-component `.css` files
- `CLAUDE.md` §Frontend Architecture — all HTTP via `lib/api.ts`, state machines use `useReducer` for complex state, hooks own data logic
- `.planning/codebase/CONVENTIONS.md` — naming patterns, TypeScript rules, import order

### Phase Requirements
- `.planning/REQUIREMENTS.md` — SIDE-01 through SIDE-06, QUEST-01 through QUEST-04 are in scope for Phase 1; PERS-01 through SYNC-02 are Phase 2

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `frontend/src/components/ui/Button.tsx` — use for "Generate plan" CTA and close button; has `variant="primary"` and `variant="secondary"` and `size="sm"/"md"` props
- `frontend/src/components/ui/Spinner.tsx` — use for loading state in sidebar body (`<Spinner size="sm" />`)
- `frontend/src/lib/utils.ts` → `cn()` — use for all conditional class merging
- `frontend/src/pages/StudyPlanPage.tsx` — `StudyPlanItem`, `StoredPlan`, `PLAN_KEY`, `loadStoredPlan()`, `savePlan()`, `todayStr()` — extract to shared lib
- `frontend/src/lib/api.ts` → `api.attempts.list()` — call with no questionId arg to get all attempts for session; map `question_id → is_correct` to derive statuses

### Established Patterns
- Fixed overlay pattern: see `TopicDrawer` in `frontend/src/components/topic/TopicDrawer.tsx` — uses `fixed inset-0 z-30` backdrop + `fixed` panel with translate animation; same pattern applies here
- State machines: complex UI state uses `useReducer` (see `usePracticeSession.ts`); sidebar open/close is simple enough for `useState`
- Dark mode: always apply both light and dark Tailwind classes; `dark:` variants required on every element per UI-SPEC

### Integration Points
- `frontend/src/App.tsx` `RootLayout` — add `StudyPlanSidebar` as sibling of `<main>`; wrap both in `div.relative.flex-1.overflow-hidden` per UI-SPEC layout contract
- `frontend/src/lib/api.ts` → `api.attempts.list()` — no new endpoint needed; use existing call
- `frontend/src/lib/session.ts` → `getSessionId()` — pass to `api.attempts.list()` for session-scoped attempt lookup

</code_context>

<specifics>
## Specific Ideas

- The sidebar trigger tab is `fixed left-0 top-1/2 -translate-y-1/2 z-50 w-10 h-20 rounded-r-2xl bg-blue-600` — this is very specific and locked in the UI-SPEC; implement exactly as specified
- When panel opens, focus moves to the close button (`×`); when panel closes, focus returns to the trigger tab — this is WCAG-required focus management, not optional
- Escape key listener should be on `window`, removed on unmount (not on the panel element)

</specifics>

<deferred>
## Deferred Ideas

- Firestore sync (PERS-01, PERS-02, PERS-03) — Phase 2
- Live status refresh without panel-open trigger (SYNC-01, SYNC-02) — Phase 2
- StudyPlanPage eventual replacement by sidebar — not in roadmap; coexistence is the intended model
- Sidebar badge showing incomplete quest count — v2 requirement (ADV-01/NOTF-02)

</deferred>

---

*Phase: 1-collapsible-sidebar-with-local-plan*
*Context gathered: 2026-06-27*
