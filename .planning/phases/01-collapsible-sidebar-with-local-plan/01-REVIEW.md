---
phase: 01-collapsible-sidebar-with-local-plan
status: issues-found
reviewed_at: 2026-06-27
findings_count: 10
critical: 0
high: 1
medium: 3
low: 6
---

# Phase 01 Code Review

**Phase: 01 — Collapsible Sidebar with Local Plan**
Files reviewed: `StudyPlanSidebar.tsx`, `useStudyPlan.ts`, `studyPlan.ts`, `QuestItem.tsx`, `App.tsx`, `StudyPlanPage.tsx`, `types/api.ts`, `ReviewPage.tsx`

## Summary

4 correctness bugs (1 high, 3 medium) and 6 quality findings. No critical issues. The core sidebar feature works, but the focus management effect has an accessibility regression on every page load, and multi-part quest status is computed incorrectly.

---

## Findings

### [HIGH] Focus management effect fires on mount, stealing keyboard focus

**File:** `frontend/src/components/layout/StudyPlanSidebar.tsx:20–26`

```ts
useEffect(() => {
  if (isOpen) {
    closeRef.current?.focus()
  } else {
    triggerRef.current?.focus()  // fires on mount with isOpen=false
  }
}, [isOpen])
```

The `else` branch has no guard against the initial mount. On every page load, `isOpen=false`, the effect fires, and `triggerRef.current?.focus()` moves keyboard focus to the sidebar trigger tab regardless of where the user's focus was.

**Failure scenario:** Student navigates to `/practice/:topicId` via keyboard. The `StudyPlanSidebar` mounts, the effect fires, and focus teleports to the sidebar trigger button on the left edge — away from the question they were about to interact with. Screen readers also announce the trigger unexpectedly. Fix: add a ref that tracks whether the panel has ever been opened before calling `focus()` in the `else` branch.

---

### [MEDIUM] `todayStr()` uses UTC — stale detection fires 8 hours early for Singapore users

**File:** `frontend/src/lib/studyPlan.ts:12`

```ts
export function todayStr() {
  return new Date().toISOString().slice(0, 10)  // UTC date, not local date
}
```

**Failure scenario:** A student generates a plan at 1am Singapore time on Wednesday (= 5pm Tuesday UTC). `p.date` is saved as `"2026-06-30"` (Tuesday UTC). At 8am Wednesday Singapore (= midnight UTC Wednesday), `todayStr()` returns `"2026-07-01"`. The plan appears stale even though it is 7 hours old and was made on the same local calendar day. Fix: `new Date().toLocaleDateString('en-CA')` (ISO format, local timezone) or `new Date(Date.now() + 8*3600*1000).toISOString().slice(0, 10)`.

---

### [MEDIUM] Multi-part quest marked ✓ when only one part is correct

**File:** `frontend/src/hooks/useStudyPlan.ts:36`

```ts
const correctSet = new Set(attempts.filter(a => a.is_correct).map(a => a.question_id))
```

Per CLAUDE.md: "one `attempts` row per graded part" and "show ✓ only when **all** graded parts have a correct attempt." `correctSet` groups by `question_id` only — if part A is correct and part B is not, `question_id` enters `correctSet` and the sidebar shows ✓.

**Failure scenario:** A 3-part question in today's plan: student answers part A correctly, skips B and C. Sidebar shows quest as ✓ complete. Student sees a full progress bar tick. The same bug exists verbatim in `StudyPlanPage.tsx:138`. Fix: group by `(question_id, part_label)` and only mark `question_id` correct when every non-null-`part_label` attempt for it has `is_correct=true`.

---

### [MEDIUM] All-time attempt history inflates sidebar quest status

**File:** `frontend/src/hooks/useStudyPlan.ts:34`

```ts
const attempts = await api.attempts.list()
```

No date filter. A question answered correctly weeks ago enters `correctSet` and the sidebar immediately shows it as ✓ before the student works on it today.

**Failure scenario:** Today's spaced-repetition plan includes a question the student mastered last month. The sidebar shows ✓ before the student opens it; they skip it. If the intent is to review today's plan items fresh, the fetch should filter attempts to today or scope to the current plan's `question_id` set. If "ever correct = no need to redo" is the desired behavior, this is by design — but should be documented in a comment.

---

### [LOW] `isEmpty` renders "No plan yet" for a stale plan with 0 items

**File:** `frontend/src/components/layout/StudyPlanSidebar.tsx:43, 155`

```ts
const isEmpty = !loading && !error && total === 0  // true when stale+empty
// StaleBanner gate:
{isStale && !loading && !error && total > 0 && <StaleBanner />}  // never renders when total=0
```

When `isStale=true` and `total=0`, the stale banner is suppressed and "No plan yet" appears instead. The state requires an externally crafted localStorage entry but is reachable.

---

### [LOW] `Quest` interface defined identically in two files

**File:** `frontend/src/hooks/useStudyPlan.ts:6–9` and `frontend/src/pages/StudyPlanPage.tsx:11–14`

`StudyPlanPage` declares its own local `interface Quest extends StudyPlanItem { status: QuestStatus; index: number }` instead of importing the exported one from `useStudyPlan`. Adding a field to `Quest` will require two edits.

---

### [LOW] Attempt-status derivation logic duplicated verbatim

**Files:** `useStudyPlan.ts:36–45` and `StudyPlanPage.tsx:138–149`

`correctSet` / `triedSet` build + three-way `status` ternary appears twice identically. If the "correct" rule changes (e.g., all parts must be correct), both copies must be updated.

---

### [LOW] Full attempt history refetched on every sidebar open

**File:** `frontend/src/hooks/useStudyPlan.ts:34`

```ts
useEffect(() => {
  if (!isOpen) return
  // ...
  const attempts = await api.attempts.list()
}, [isOpen])
```

Every open triggers a full round-trip. No memoization. On a long session (50+ attempts) the payload grows and each sidebar toggle re-fetches it. Consider caching the attempt list outside the effect or reusing `useAttemptHistory`.

---

### [LOW] `ReviewPage.tsx` has its own inlined copy of the UTC stale check

**File:** `frontend/src/pages/ReviewPage.tsx` (unchanged)

```ts
const today = new Date().toISOString().slice(0, 10)
```

This is a separate copy of `todayStr()` that was not replaced when `studyPlan.ts` was extracted. When the UTC date bug is fixed in `studyPlan.ts`, `ReviewPage.tsx` will retain the broken version.

---

### [LOW] Inline style in `StudyPlanPage.tsx` violates CLAUDE.md

**File:** `frontend/src/pages/StudyPlanPage.tsx:255`

```tsx
style={{ width: `${pct}%` }}
```

CLAUDE.md: "No inline styles; no CSS Modules; no per-component `.css` files." The shared `<ProgressBar>` component (used correctly in `StudyPlanSidebar.tsx:106`) handles the dynamic width internally. `StudyPlanPage` should use `<ProgressBar>` rather than a hand-rolled bar with an inline style.

---

### [LOW] `Quest` status transform is a pure function buried in two side-effectful hooks

Items × attempts → `Quest[]` is stateless and testable in isolation but lives inside two `useEffect` callbacks. Extracting it as `computeQuestStatuses(items, attempts)` in `studyPlan.ts` would eliminate the duplication and make the business logic unit-testable.

---

## Recommended fixes (priority order)

1. **HIGH** — Add mount guard to focus effect: `const mountedRef = useRef(false); if (!mountedRef.current) { mountedRef.current = true; return; }` before the `else` branch
2. **MEDIUM** — Fix `todayStr()` to use local date: `new Date().toLocaleDateString('en-CA')`
3. **MEDIUM** — Fix multi-part correct detection: group attempts by `(question_id, part_label)`, mark question correct only when all parts pass
4. **MEDIUM** — Clarify intent for all-time attempt history (add comment or filter to today)
5. **LOW** — Import `Quest` from `useStudyPlan` in `StudyPlanPage` (remove local duplicate)
6. **LOW** — Extract `computeQuestStatuses()` pure function to `studyPlan.ts`
7. **LOW** — Replace hand-rolled progress bar in `StudyPlanPage` with `<ProgressBar>`
8. **LOW** — Replace `ReviewPage.tsx` inline `todayStr` with import from `studyPlan.ts`
