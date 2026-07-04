---
gsd_state_version: 1.0
milestone: v1.1
milestone_name: Landing Page Payment Entry Point
status: planning
last_updated: "2026-07-04T03:40:00.000Z"
last_activity: 2026-07-04
progress:
  total_phases: 1
  completed_phases: 0
  total_plans: 0
  completed_plans: 0
  percent: 0
---

# Project State

## Project Reference

See: .planning/PROJECT.md (updated 2026-07-04)

**Core value:** Visitors can start a Premium upgrade directly from the landing page's pricing pitch, without first having to find their way into the app.
**Current focus:** Phase 3 — Landing Page "Go Pro" Payment Entry Point

## Current Position

Phase: Phase 3 — Landing Page "Go Pro" Payment Entry Point (roadmap created, not yet planned)
Plan: —
Status: Roadmap created — ready for planning
Last activity: 2026-07-04 — v1.1 roadmap created (Phase 3, continues numbering from v1.0's Phases 1–2)

## Performance Metrics

**Velocity:**

- Total plans completed: 5 (v1.0)
- Average duration: —
- Total execution time: —

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 1 (v1.0) | 3 | - | - |
| 2 (v1.0) | 2 | - | - |
| 3 | 0/TBD | - | - |

**Recent Trend:**

- Last 5 plans: —
- Trend: —

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- Reuse the existing globally-mounted `UpgradeModal` / `openUpgradeModal()` rather than a landing-page-specific modal — avoids duplicating checkout logic
- Keep the Header "Get Premium" button unchanged — it stays as a second, unmodified entry point
- Milestone v1.1 is frontend-only wiring: no new backend routes (`POST /api/billing/checkout` and the upgrade modal already exist)

### Pending Todos

None yet.

### Blockers/Concerns

- The login → auto-open-upgrade flow must distinguish "Go Pro" intent from a plain login: the existing `prevUserRef`/`justLoggedIn` transition in `LandingPage.tsx` currently redirects every fresh sign-in to `/roadmap`. `openLoginModal(message?)` (`AuthContext.tsx:71`) has no post-login callback/intent parameter yet — some form of pending-intent needs to thread through so only "Go Pro" sign-ins open the upgrade modal.

## Deferred Items

| Category | Item | Status | Deferred At |
|----------|------|--------|-------------|
| Billing | Going live with real Stripe payments / production deployment | Deferred | v1.1 (see DEPLOYMENT.md) |
| Sidebar | SYNC-01 live quest status refresh (from v1.0 Phase 2) | Carried over | v1.0 |

## Session Continuity

Last session: 2026-07-04
Stopped at: v1.1 roadmap created (Phase 3); ready for `/gsd-plan-phase 3`
Resume file: None
