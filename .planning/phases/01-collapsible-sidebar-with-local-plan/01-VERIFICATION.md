---
phase: 01-collapsible-sidebar-with-local-plan
verified: 2026-06-27T00:00:00Z
status: passed
score: 5/5 must-haves verified
behavior_unverified: 0
overrides_applied: 0
re_verification: false
---

# Phase 1: Collapsible Sidebar with Local Plan — Verification Report

**Phase Goal:** Persistent sidebar in RootLayout showing today's quest list, collapsible, with empty/new-day states
**Verified:** 2026-06-27
**Status:** PASSED
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths (Roadmap Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | A collapsed sidebar tab/icon is visible and reachable from every page without obstructing content | VERIFIED | `StudyPlanSidebar` mounted in `RootLayout` (App.tsx:22) covering all routes under `/`; trigger is `position: fixed left-0 top-1/2 z-50`; panel has `pointer-events-none` when closed; human verified across 5 routes |
| 2 | Clicking the tab expands a sidebar listing today's quests with name, topic, and status icon (✓/↩/numbered) | VERIFIED | Toggle via `setIsOpen`; `QuestItem` renders all three status variants from `useStudyPlan(isOpen)` data; human verified |
| 3 | A progress summary ("N / M complete") appears at the top of the expanded quest list | VERIFIED | `showProgress` guard at `StudyPlanSidebar.tsx:42` renders `{correctCount} / {total} complete` + `<ProgressBar>` when plan is active and non-stale; human verified |
| 4 | Clicking any quest item navigates to `/practice/:topicId?question_id=...` | VERIFIED | `handleQuestSelect` calls `navigate(\`/practice/${quest.topic_id}?question_id=${quest.question_id}\`)` at `StudyPlanSidebar.tsx:39`; `QuestItem.onClick` passes the quest to `onSelect`; human verified |
| 5 | Empty state shows "Generate plan" → `/review`; stale state shows prior plan greyed out with "New day" prompt | VERIFIED | `isEmpty` branch renders "No plan yet" + `Button onClick={() => navigate('/review')}`; `isStale` branch renders quest list with `opacity-40` + amber footer banner with "Generate plan" → `/review`; human verified both states via DevTools localStorage manipulation |

**Score: 5/5 truths verified**

---

### Requirements Coverage

| Requirement | Description | Status | Evidence |
|-------------|-------------|--------|----------|
| SIDE-01 | Collapsed sidebar tab accessible from every page | VERIFIED | Fixed trigger in `RootLayout`; covers `/`, `/practice/:topicId`, `/history`, `/starred`, `/stats`, `/review`, `/study-plan` |
| SIDE-02 | Expand sidebar by clicking tab | VERIFIED | `setIsOpen(o => !o)` on trigger; `translate-x-0` when open |
| SIDE-03 | Collapse sidebar by clicking again; default collapsed | VERIFIED | `useState(false)` default; same toggle handler closes; close button, backdrop click, and Escape also close |
| SIDE-04 | Empty state: "Generate plan" button → `/review` | VERIFIED | `isEmpty = !loading && !error && total === 0`; renders "No plan yet" + `<Button onClick={() => navigate('/review')}>Generate plan</Button>` |
| SIDE-05 | Stale-day state: prior plan greyed + "New day" banner | VERIFIED | `isStale: p.date !== todayStr()` in `loadStoredPlan()`; list wrapped in `cn(isStale && 'opacity-40')`; amber banner in footer |
| SIDE-06 | Sidebar does not obstruct content when collapsed | VERIFIED | Panel off-screen at `-translate-x-full`; backdrop `pointer-events-none`; trigger is 40px wide fixed element not in document flow |
| QUEST-01 | Sidebar lists all quest items (name, topic, status icon) | VERIFIED | `quests.map(quest => <QuestItem>)` renders all items; `QuestItem` shows `question_name`, `topic_name`, and status icon |
| QUEST-02 | Each quest shows ✓ correct, ↩ attempted, or numbered pending | VERIFIED | Three-branch render in `QuestItem.tsx:21–35`; status derived from `correctSet`/`triedSet` against `api.attempts.list()` |
| QUEST-03 | Clicking quest navigates to correct practice question | VERIFIED | `navigate(\`/practice/${quest.topic_id}?question_id=${quest.question_id}\`)` in `handleQuestSelect` |
| QUEST-04 | Progress summary ("N / M complete") visible at top | VERIFIED | `correctCount / total` rendered at `StudyPlanSidebar.tsx:103–107`; guarded to hide on stale/empty/error/loading states |

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `frontend/src/App.tsx` | Mounts `StudyPlanSidebar` in `RootLayout` | VERIFIED | Lines 4, 22: imports and renders `<StudyPlanSidebar />` as sibling of `<main>` inside `div.relative.flex-1.overflow-hidden` |
| `frontend/src/components/layout/StudyPlanSidebar.tsx` | Trigger tab + sliding panel + all states | VERIFIED | 170 lines; implements trigger, backdrop, panel, all 5 UI states, focus management, Escape key |
| `frontend/src/hooks/useStudyPlan.ts` | Loads plan from localStorage + derives quest statuses from attempts API | VERIFIED | Calls `loadStoredPlan()` + `api.attempts.list()`; derives status on `isOpen` trigger; returns `{ quests, isStale, loading, error, correctCount, total }` |
| `frontend/src/lib/studyPlan.ts` | Shared localStorage helpers extracted from `StudyPlanPage` | VERIFIED | Exports `PLAN_KEY`, `StoredPlan`, `todayStr`, `savePlan`, `loadStoredPlan`; imported by both `useStudyPlan.ts` and `StudyPlanPage.tsx` |
| `frontend/src/components/sidebar/QuestItem.tsx` | Quest row with status icon and navigation | VERIFIED | 49 lines; three status variants (correct/attempted/pending); `onSelect` handler for navigation |
| `frontend/src/types/api.ts` | `QuestStatus` and `StudyPlanItem` types | VERIFIED | `QuestStatus = 'correct' | 'attempted' | 'pending'` at line 223; `StudyPlanItem` at line 225 |

---

### Key Link Verification

| From | To | Via | Status |
|------|----|-----|--------|
| `App.tsx` | `StudyPlanSidebar.tsx` | `import { StudyPlanSidebar }` + JSX `<StudyPlanSidebar />` | WIRED |
| `StudyPlanSidebar.tsx` | `useStudyPlan.ts` | `import { useStudyPlan }` + `useStudyPlan(isOpen)` call | WIRED |
| `StudyPlanSidebar.tsx` | `QuestItem.tsx` | `import { QuestItem }` + `quests.map(q => <QuestItem>)` | WIRED |
| `useStudyPlan.ts` | `studyPlan.ts` | `import { loadStoredPlan }` + `loadStoredPlan()` call | WIRED |
| `useStudyPlan.ts` | `lib/api.ts` | `import { api }` + `api.attempts.list()` | WIRED |
| `StudyPlanPage.tsx` | `studyPlan.ts` | `import { todayStr, savePlan, loadStoredPlan }` | WIRED (shared lib extraction confirmed) |

---

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|--------------------|--------|
| `StudyPlanSidebar.tsx` | `quests`, `correctCount`, `total` | `useStudyPlan(isOpen)` → `loadStoredPlan()` (localStorage) + `api.attempts.list()` (backend) | Yes — localStorage plan + live attempts endpoint | FLOWING |
| `useStudyPlan.ts` | `quests` | `plan.items.map(...)` with status from attempts API response | Yes — real API response mapped to status | FLOWING |

---

### Behavioral Spot-Checks

Step 7b: The relevant behavioral truths (status refresh on panel open, navigation on quest click, stale detection) were all exercised by a human verifier in Plan 01-03. No automated tests exist for the sidebar feature. Automated spot-checks skipped — human sign-off is the behavioral evidence for this phase.

---

### Anti-Patterns Found

No `TBD`, `FIXME`, or `XXX` markers found in phase files. No stub returns (`return null`, `return []`, `return {}`) in production paths. No placeholder text in rendered UI.

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `StudyPlanSidebar.tsx` | 20–26 | Focus effect fires on mount (no mount guard), stealing keyboard focus | WARNING | Accessibility regression on every page load — keyboard focus teleports to sidebar trigger. Tracked in 01-REVIEW.md #1 (HIGH). Does not block phase acceptance per task instructions. |
| `studyPlan.ts` | 12 | `todayStr()` uses UTC date, not local date | WARNING | Stale detection triggers 8h early for Singapore users. Tracked in 01-REVIEW.md #2 (MEDIUM). |
| `useStudyPlan.ts` | 36 | `correctSet` groups by `question_id` only — multi-part quest marked ✓ when only one part correct | WARNING | Quest status inaccurate for multi-part questions. Tracked in 01-REVIEW.md #3 (MEDIUM). |
| `useStudyPlan.ts` | 34 | `api.attempts.list()` returns all-time history — no date filter | WARNING | Quest may show as ✓ from a previous session. Tracked in 01-REVIEW.md #4 (MEDIUM). |

---

### Known Issues (Non-Blocking)

All four issues below are tracked in `.planning/phases/01-collapsible-sidebar-with-local-plan/01-REVIEW.md` and do not block the phase PASS verdict (per project instructions — human verification in Plan 01-03 confirmed all 10 requirements passing in the running app).

1. **HIGH — Focus theft on mount:** `useEffect` in `StudyPlanSidebar.tsx:20–26` calls `triggerRef.current?.focus()` on initial mount (`isOpen=false`). On every page load, keyboard focus moves to the sidebar trigger regardless of where the user was. Fix: add a mount-guard ref before the `else` branch.

2. **MEDIUM — UTC stale detection:** `todayStr()` in `studyPlan.ts:12` returns UTC date via `.toISOString().slice(0,10)`. For Singapore users (UTC+8), a plan generated at 1am local time on Wednesday is stored with a Tuesday UTC date and becomes stale at midnight UTC (8am local). Fix: `new Date().toLocaleDateString('en-CA')`.

3. **MEDIUM — Multi-part quest ✓ bug:** `correctSet` in `useStudyPlan.ts:36` groups by `question_id` only. A multi-part question enters `correctSet` when any one part is correct, not when all graded parts are correct. Fix: group by `(question_id, part_label)` and only promote when all non-null parts pass.

4. **MEDIUM — All-time attempt scope:** `api.attempts.list()` returns all-time history. A question answered correctly in a prior session shows ✓ in today's sidebar without today's attempt. This may or may not be the intended behavior — no comment in code. Fix or document intent.

---

### Human Verification

All seven acceptance criteria checks were performed by a human in Plan 01-03 (2026-06-27) and signed off as approved. Evidence: `01-03-SUMMARY.md` documents each check passing. No further human verification items remain open.

---

## Gaps Summary

No gaps. All five roadmap success criteria are verified through a combination of static code analysis (artifacts exist, are substantive, and are wired) and human verification (Plan 01-03 sign-off confirming all behaviors in the running app). Four correctness bugs are documented as known issues in `01-REVIEW.md` but do not constitute gaps against the phase acceptance criteria.

---

_Verified: 2026-06-27_
_Verifier: Claude (gsd-verifier)_
