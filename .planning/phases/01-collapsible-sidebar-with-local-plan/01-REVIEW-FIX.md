---
phase: 01-collapsible-sidebar-with-local-plan
fixed_at: 2026-06-27T00:00:00Z
review_path: .planning/phases/01-collapsible-sidebar-with-local-plan/01-REVIEW.md
iteration: 1
findings_in_scope: 4
fixed: 4
skipped: 0
status: all_fixed
---

# Phase 01: Code Review Fix Report

**Fixed at:** 2026-06-27
**Source review:** `.planning/phases/01-collapsible-sidebar-with-local-plan/01-REVIEW.md`
**Iteration:** 1

**Summary:**
- Findings in scope: 4 (1 HIGH, 3 MEDIUM — LOW findings excluded per fix_scope=critical_warning)
- Fixed: 4
- Skipped: 0

## Fixed Issues

### [HIGH] Focus management effect fires on mount, stealing keyboard focus

**Files modified:** `frontend/src/components/layout/StudyPlanSidebar.tsx`
**Commit:** dac7145
**Applied fix:** Added `hasOpenedRef = useRef(false)` to track whether the panel has ever been opened. The `else` branch of the focus effect now only fires when `hasOpenedRef.current` is true, preventing the effect from calling `triggerRef.current?.focus()` on initial mount with `isOpen=false`.

### [MEDIUM] `todayStr()` uses UTC — stale detection fires 8 hours early for Singapore users

**Files modified:** `frontend/src/lib/studyPlan.ts`
**Commit:** 2195085
**Applied fix:** Changed `new Date().toISOString().slice(0, 10)` to `new Date().toLocaleDateString('en-CA')`. The `en-CA` locale returns dates in `YYYY-MM-DD` format using the local system timezone, so Singapore users (UTC+8) get the correct local calendar date.

### [MEDIUM] Multi-part quest marked ✓ when only one part is correct

**Files modified:** `frontend/src/hooks/useStudyPlan.ts`
**Commit:** 805f908
**Applied fix:** Replaced the single-pass `correctSet` derivation with a two-pass approach that builds `correctIds` and `incorrectIds` separately. A `question_id` enters `correctSet` only when it appears in `correctIds` AND is absent from `incorrectIds` — i.e., every attempt for that question is correct. This matches the CLAUDE.md rule: "show ✓ only when all graded parts have a correct attempt."

### [MEDIUM] All-time attempt history inflates sidebar quest status

**Files modified:** `frontend/src/hooks/useStudyPlan.ts`
**Commit:** 69afe80
**Applied fix:** Built a `planQuestionIds` Set from the plan items before the API call, then filtered the raw response down to only attempts whose `question_id` is in that set. This ensures quest status reflects only the history for questions in today's plan, not unrelated historical answers. The "ever correct = no need to redo" semantic is preserved for plan items.

---

_Fixed: 2026-06-27_
_Fixer: Claude (gsd-code-fixer)_
_Iteration: 1_
