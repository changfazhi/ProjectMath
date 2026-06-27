---
plan: 01-02
phase: 01-collapsible-sidebar-with-local-plan
status: complete
completed_at: 2026-06-27
---

# Plan 01-02 Summary — Sidebar States + Accessibility

## What Was Built

Completed the sidebar UI-SPEC contract by extending `StudyPlanSidebar.tsx`:

- **State 1 (Empty):** calendar icon, "No plan yet" heading, body copy, full-width "Generate plan" → `/review`
- **State 2 (Active):** progress summary + ProgressBar visible, normal-opacity quest list (unchanged from 01-01)
- **State 3 (Stale):** `opacity-40` on quest list container; footer amber banner ("New day" + "Generate plan" → `/review`)
- **State 4 (Loading):** centered Spinner in body; progress bar hidden
- **State 5 (Error):** "Couldn't load your plan — refresh to try again." in red-500; no retry button
- **Focus management:** `triggerRef` + `closeRef`; `useEffect` keyed on `isOpen` focuses close button on open, trigger on close
- **Escape handler:** `window keydown` listener added when open, removed on cleanup
- **`useStudyPlan`:** `isOpen` already in effect dependency array from 01-01 — re-fetches on every open ✓

## Self-Check: PASSED

- `tsc -b` exits 0
- Lint on changed files: 0 errors
- All UI-SPEC states implemented with exact copy strings ✓
- ARIA: `aria-expanded`, dynamic `aria-label`, `role="complementary"`, `aria-label="Study plan"` ✓
- Both Generate plan CTAs call `navigate('/review')` without changing `isOpen` ✓
