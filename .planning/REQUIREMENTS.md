# Requirements: Math Trainer — Persistent Study Plan Sidebar

**Defined:** 2026-06-27
**Core Value:** Students can see and act on their daily study plan from anywhere in the app without losing their place.

## v1 Requirements

### Sidebar UI

- [x] **SIDE-01**: User sees a collapsed sidebar tab/icon accessible from every page in the app
- [x] **SIDE-02**: User can expand the sidebar by clicking the tab/icon to reveal their study plan
- [x] **SIDE-03**: User can collapse the sidebar by clicking again (collapsed state is default)
- [x] **SIDE-04**: When no study plan has been generated today, the expanded sidebar shows a "Generate plan" button that navigates to `/review`
- [x] **SIDE-05**: When a new day begins and a prior day's plan exists, the sidebar shows that plan greyed out with a prominent "New day — generate today's plan" prompt
- [x] **SIDE-06**: The sidebar does not overlay or obstruct main page content when collapsed

### Quest List

- [x] **QUEST-01**: The expanded sidebar lists all quest items from today's study plan (question name, topic, status icon)
- [x] **QUEST-02**: Each quest item shows its current status: ✓ correct, ↩ attempted, or numbered (pending)
- [x] **QUEST-03**: Clicking a quest item navigates the user to that practice question (`/practice/:topicId?question_id=...`)
- [x] **QUEST-04**: A progress summary (e.g. "2 / 5 complete") is visible at the top of the quest list

### Persistence

- [x] **PERS-01**: When user is signed in (Firebase Auth), today's study plan is saved server-side under their UID so it survives page refresh and is accessible across devices *(implemented via `study_plans` Supabase table; `getPersonalisedStudyPlan` upserts by `user_id+date`)*
- [x] **PERS-02**: When user is not signed in (anonymous/no auth), study plan falls back to `localStorage` (existing behaviour preserved)
- [x] **PERS-03**: On load, the sidebar fetches from the server (if signed in) with `localStorage` as a fast-load cache *(`useStudyPlan` checks localStorage first; if empty, calls `/api/review/study-plan` which returns the DB-saved plan)*

### Status Sync

- [ ] **SYNC-01**: Quest statuses (correct/attempted/pending) update in the sidebar when the user returns from a practice page without requiring a full page reload
- [x] **SYNC-02**: Status is derived from the attempts API (`GET /api/attempts`) — no separate status store *(`useStudyPlan` calls `api.attempts.list()` and derives correct/attempted/pending inline)*

## v2 Requirements

### Notifications

- **NOTF-01**: User can opt in to a daily reminder to complete their study plan
- **NOTF-02**: Sidebar badge shows count of incomplete quests

### Advanced Sidebar

- **ADV-01**: User can pin/unpin individual quest items
- **ADV-02**: Sidebar has a swipe-to-open gesture on mobile

## Out of Scope

| Feature | Reason |
|---------|--------|
| Editing the AI-generated plan | Plan is read-only; AI owns curation. Manual edits deferred. |
| Multiple plans per day | One plan per user per day keeps the UX simple |
| Push notifications / reminders | Deferred to a future milestone |
| Mobile-specific sidebar layout | Responsive collapse sufficient; native mobile app is out of scope |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| SIDE-01 | Phase 1 | Complete |
| SIDE-02 | Phase 1 | Complete |
| SIDE-03 | Phase 1 | Complete |
| SIDE-04 | Phase 1 | Complete |
| SIDE-05 | Phase 1 | Complete |
| SIDE-06 | Phase 1 | Complete |
| QUEST-01 | Phase 1 | Complete |
| QUEST-02 | Phase 1 | Complete |
| QUEST-03 | Phase 1 | Complete |
| QUEST-04 | Phase 1 | Complete |
| PERS-01 | Phase 2 | Complete |
| PERS-02 | Phase 2 | Complete |
| PERS-03 | Phase 2 | Complete |
| SYNC-01 | Phase 2 | Pending |
| SYNC-02 | Phase 2 | Complete |

**Coverage:**

- v1 requirements: 15 total
- Mapped to phases: 15
- Unmapped: 0 ✓

---
*Requirements defined: 2026-06-27*
*Last updated: 2026-06-29 — PERS-01/02/03, SYNC-02 marked complete after codebase review confirmed implementation*
