# Roadmap: Math Trainer — Persistent Study Plan Sidebar

## Overview

Two phases deliver a persistent, collapsible study plan sidebar for Math Trainer. Phase 1 wires the sidebar into `RootLayout` with full UI and local plan display so the feature is immediately usable. Phase 2 adds Firestore-backed persistence and live quest status refresh so the plan survives device switches and reflects completed questions without a reload.

## Phases

**Phase Numbering:**

- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Collapsible Sidebar with Local Plan** - Persistent sidebar in RootLayout showing today's quest list, collapsible, with empty/new-day states (completed 2026-06-27)
- [ ] **Phase 2: Firestore Sync and Live Quest Status** - Cloud persistence keyed to Firebase UID plus live status refresh from the attempts API

## Phase Details

### Phase 1: Collapsible Sidebar with Local Plan

**Goal**: Students can see and act on their daily study plan from a persistent sidebar on any page
**Mode:** mvp
**Depends on**: Nothing (first phase)
**Requirements**: SIDE-01, SIDE-02, SIDE-03, SIDE-04, SIDE-05, SIDE-06, QUEST-01, QUEST-02, QUEST-03, QUEST-04
**Success Criteria** (what must be TRUE):

  1. A collapsed sidebar tab/icon is visible and reachable from every page in the app (roadmap, practice, history, starred, stats) without obstructing main content
  2. Clicking the tab expands a sidebar that lists all of today's quest items — each showing question name, topic, and status icon (✓ correct / ↩ attempted / numbered pending)
  3. A progress summary (e.g. "2 / 5 complete") appears at the top of the expanded quest list
  4. Clicking any quest item navigates to the correct practice question at `/practice/:topicId?question_id=...`
  5. When no plan exists the expanded sidebar shows a "Generate plan" button that links to `/review`; when a new day begins it shows the prior plan greyed out with a "New day — generate today's plan" prompt

**Plans**: 3/3 plans complete
**Wave 1**

- [x] 01-01-PLAN.md — Walking skeleton: shared studyPlan lib + useStudyPlan hook + QuestItem + StudyPlanSidebar mounted in RootLayout (open → see quests → click → navigate)

**Wave 2** *(blocked on Wave 1 completion)*

- [x] 01-02-PLAN.md — Empty / stale-day / loading / error states + refresh-on-open + WCAG focus & Escape handling

**Wave 3** *(blocked on Wave 2 completion)*

- [x] 01-03-PLAN.md — End-to-end human verification of the Phase 1 sidebar

**UI hint**: yes

### Phase 2: Firestore Sync and Live Quest Status

**Goal**: Students' study plans persist across devices when signed in and quest statuses update without a page reload
**Mode:** mvp
**Depends on**: Phase 1
**Requirements**: PERS-01, PERS-02, PERS-03, SYNC-01, SYNC-02
**Success Criteria** (what must be TRUE):

  1. A signed-in user who generates a study plan on one device sees that same plan in the sidebar on any other device after a page reload
  2. An anonymous user's plan is preserved in localStorage and displays correctly in the sidebar after a page refresh (no regression from existing behaviour)
  3. Quest statuses update to ✓ correct or ↩ attempted in the sidebar when the user returns from a practice question — no full page reload required
  4. Quest status is always derived from the attempts API (`GET /api/attempts`) — no separate status store is written or maintained

**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Collapsible Sidebar with Local Plan | 3/3 | Complete   | 2026-06-27 |
| 2. Firestore Sync and Live Quest Status | 0/TBD | Not started | - |
