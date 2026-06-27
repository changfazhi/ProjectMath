# Math Trainer — Persistent Study Plan Sidebar

## What This Is

Math Trainer is a LeetCode-style H2 A-Level Math practice platform for Singapore students. This milestone adds a persistent, collapsible study plan sidebar that stays accessible from every page in the app — so students never lose their daily quest log when they navigate to a practice question and back.

## Core Value

Students can see and act on their daily study plan from anywhere in the app without losing their place.

## Requirements

### Validated

- ✓ AI-generated daily study plan via `/api/review/study-plan` — existing
- ✓ Study plan page at `/study-plan` showing quest list with correct/attempted/pending states — existing
- ✓ Today's plan persisted in `localStorage` (day-keyed, rehydrated on return) — existing
- ✓ Firebase Auth integration (in-progress on `firebase-auth` branch) — existing
- ✓ Quest items link directly to practice questions via `navigate('/practice/:topicId?question_id=...')` — existing

### Active

- [ ] Collapsible sidebar component in `RootLayout` visible on all routes
- [ ] Sidebar shows today's study plan quest list with live correct/attempted/pending status
- [ ] Sidebar collapsed to a tab/icon by default; expands on click
- [ ] When no plan exists, sidebar shows "Generate plan" prompt (links to `/review`)
- [ ] When a new day begins, sidebar shows old plan greyed out with "New day — generate today's plan" prompt
- [ ] Study plan persisted server-side via Firestore (keyed to Firebase UID) so it survives page refresh and is accessible across devices
- [ ] Quest statuses sync in real-time as user completes questions (correct/attempted/pending update without full page reload)

### Out of Scope

- Multiple concurrent study plans — one active plan per user per day only
- Push notifications or reminders — deferred to a future milestone
- Editing the AI-generated plan manually — plan is read-only, regeneration only
- Mobile-specific layout for the sidebar — responsive collapse is sufficient for now

## Context

- **Existing persistence**: `StudyPlanPage` already saves to `localStorage` under `study_plan_v1`. The new server-side store (Firestore) should be authoritative; localStorage can remain as a read-cache for offline/fast load.
- **Auth state**: Firebase Auth is being added on the `firebase-auth` branch. The sidebar should conditionally enable server sync only when a user is signed in; fall back to localStorage for anonymous sessions.
- **RootLayout**: `App.tsx` wraps all routes (except `/m/:token`) with `RootLayout`, which renders `<Header />` + `<Outlet />`. The sidebar slots alongside `<Outlet />` in this layout.
- **Status updates**: Quest status (correct/attempted/pending) is derived from attempts — `api.attempts.list()` returns the full attempt history. The sidebar needs to poll or react when the user returns from a practice page.
- **Existing study plan page**: `/study-plan` route should remain; the sidebar is an additive overlay, not a replacement.

## Constraints

- **Stack**: React 19 + Vite + Tailwind + TypeScript frontend; Express + TypeScript backend; Supabase for attempts/questions; Firebase for auth + plan storage
- **No new backend routes for this feature**: Firestore reads/writes happen client-side via Firebase SDK — no Express proxy needed
- **Auth dependency**: Full cross-device sync requires Firebase Auth (UID). Graceful fallback to localStorage for unauthenticated users is required so the feature doesn't break before auth ships

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Sidebar in `RootLayout`, not per-page | Ensures it survives route transitions without remounting | — Pending |
| Firestore for plan storage, localStorage as cache | Firestore gives cross-device sync; localStorage keeps it snappy on reload | — Pending |
| Collapsed by default | Doesn't crowd the main content area; users opt in to see the plan | — Pending |
| Quest status derived from attempts, not stored separately | Single source of truth; avoids double-write bugs | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-06-27 after initialization*
