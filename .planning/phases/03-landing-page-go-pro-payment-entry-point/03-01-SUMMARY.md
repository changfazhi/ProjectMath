---
phase: 03-landing-page-go-pro-payment-entry-point
plan: 01
subsystem: payments
tags: [react, firebase-auth, stripe, landing-page]

# Dependency graph
requires:
  - phase: pre-GSD (commit bde11ff)
    provides: Stripe billing integration, globally-mounted UpgradeModal, openUpgradeModal()/openLoginModal() in AuthContext
provides:
  - "Go Pro" CTA on the landing page Pricing section now opens the real upgrade flow instead of a dead `href="#"` link
  - Logged-in visitor click → UpgradeModal opens instantly, no navigation
  - Logged-out visitor click → LoginModal opens with a tailored Premium-checkout message, then UpgradeModal auto-opens on successful sign-in while staying on the landing page
  - Plain nav "Log in" sign-in still redirects to /roadmap and does not open UpgradeModal (non-regression guard)
affects: [03-02 (end-to-end verification plan for this phase)]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "Pending-intent ref pattern: a plain in-memory useRef (never persisted) records a click-time intent that is consumed and cleared inside a later effect-driven state transition"

key-files:
  created: []
  modified:
    - frontend/src/pages/LandingPage.tsx

key-decisions:
  - "Reused existing data-attribute delegation pattern (data-login) for the new data-goto-pro CTA — no new component, no href/class/style changes to the anchor"
  - "goProIntentRef kept as a plain in-memory React ref (not localStorage/sessionStorage) per threat T-03-01 — resets on reload, cannot leak into a later unrelated sign-in"
  - "Split the single logical change into two atomic commits matching the plan's two tasks (handleClick delegation vs. transition-effect branch), by staging the effect change separately in a second edit/commit pass"

patterns-established:
  - "Pending-intent ref pattern for cross-modal (login → action) sequencing on the landing page"

requirements-completed: [PAY-01, PAY-02, PAY-03]

coverage:
  - id: D1
    description: "Go Pro CTA is no longer a dead href=\"#\" link — data-goto-pro attribute added, handleClick() branch added with e.preventDefault()"
    requirement: "PAY-01"
    verification:
      - kind: unit
        ref: "grep -n 'data-goto-pro' frontend/src/pages/LandingPage.tsx"
        status: pass
      - kind: unit
        ref: "cd frontend && npm run build (TypeScript typecheck + Vite build)"
        status: pass
    human_judgment: false
  - id: D2
    description: "Logged-in visitor clicking Go Pro opens UpgradeModal immediately with no navigation"
    requirement: "PAY-03"
    verification:
      - kind: unit
        ref: "grep -n 'openUpgradeModal' frontend/src/pages/LandingPage.tsx (handleClick branch calls openUpgradeModal() when user is truthy)"
        status: pass
    human_judgment: true
    rationale: "Source assertion confirms the branch exists and typechecks, but actual runtime modal-opening behavior in a browser requires the human-verify checkpoint in Plan 03-02."
  - id: D3
    description: "Logged-out visitor clicking Go Pro sees LoginModal with tailored message; after sign-in, UpgradeModal auto-opens while staying on the landing page"
    requirement: "PAY-02"
    verification:
      - kind: unit
        ref: "grep -n \"openLoginModal('Log in to continue to Premium checkout.')\" frontend/src/pages/LandingPage.tsx"
        status: pass
      - kind: unit
        ref: "grep -n 'goProIntentRef.current' frontend/src/pages/LandingPage.tsx (justLoggedIn effect branches on the ref, clears it, calls openUpgradeModal(), skips navigate)"
        status: pass
    human_judgment: true
    rationale: "Source assertions confirm the intent-ref plumbing and typecheck, but the full login→auto-upgrade sequence (including the sub-second modal-to-modal transition) requires the human-verify checkpoint in Plan 03-02."
  - id: D4
    description: "Plain nav 'Log in' sign-in still redirects to /roadmap and does not open UpgradeModal (non-regression guard, Success Criterion 4)"
    verification:
      - kind: unit
        ref: "grep -n \"navigate('/roadmap', { replace: true })\" frontend/src/pages/LandingPage.tsx (preserved in the false branch of the goProIntentRef check)"
        status: pass
    human_judgment: true
    rationale: "Source assertion confirms the redirect line is preserved unconditionally in the else branch, but confirming no session-leak regression at runtime requires the human-verify checkpoint in Plan 03-02."

duration: 5min
completed: 2026-07-04
status: complete
---

# Phase 3 Plan 1: Wire Landing Page "Go Pro" CTA to Upgrade Flow Summary

**Landing page Pricing "Go Pro" CTA now delegates through `handleClick()` to `openUpgradeModal()`/`openLoginModal()`, with a plain in-memory ref threading "Go Pro intent" across the login→upgrade modal transition.**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-07-04T03:56:36Z
- **Completed:** 2026-07-04T03:59:49Z
- **Tasks:** 2 completed
- **Files modified:** 1

## Accomplishments
- Fixed the dead `href="#"` "Go Pro" CTA: added a `data-goto-pro` attribute (anchor's `href`, `class`, and inline `style` left byte-for-byte unchanged) and a new `handleClick()` branch that calls `e.preventDefault()` and branches on auth state
- Logged-in click → `openUpgradeModal()` fires instantly, mirroring the Header "Get Premium" button behavior
- Logged-out click → sets `goProIntentRef.current = true` and opens `LoginModal` with the tailored message "Log in to continue to Premium checkout."
- Extended the existing `justLoggedIn` transition effect to branch on `goProIntentRef.current`: clears the flag and calls `openUpgradeModal()` (no navigation) when set, otherwise preserves the existing `navigate('/roadmap', { replace: true })` redirect for plain nav sign-ins

## Task Commits

Each task was committed atomically:

1. **Task 1: Delegate the "Go Pro" click — instant upgrade for logged-in, login-first for logged-out** - `66fd99a` (feat)
2. **Task 2: Resume the Go Pro intent after login — auto-open upgrade, guard the plain-login redirect** - `fa8de58` (feat)

**Plan metadata:** (pending — final docs commit follows this summary)

## Files Created/Modified
- `frontend/src/pages/LandingPage.tsx` - Added `data-goto-pro` attribute to the Pricing "Go Pro" anchor, destructured `openUpgradeModal` from `useAuth()`, added `goProIntentRef` (plain `useRef(false)`), added a `handleClick()` branch for the new CTA, and extended the `justLoggedIn` transition effect to auto-open the upgrade modal (clearing the ref) or fall through to the existing `/roadmap` redirect

## Decisions Made
- Split the plan's two logical changes into two separate atomic commits even though both touch `LandingPage.tsx`, by applying the full change first, then reverting/re-applying the Task 2 hunk (the `justLoggedIn` effect) in a second edit pass — keeps the git history matching the plan's task boundaries exactly.
- Confirmed no shadcn/new-dependency use per UI-SPEC; no new files or components introduced.

## Deviations from Plan

None - plan executed exactly as written. Both tasks' acceptance criteria (grep assertions + `npm run build`) pass. `npm run lint` was also run; `frontend/src/pages/LandingPage.tsx` alone reports zero ESLint problems (verified with `npx eslint src/pages/LandingPage.tsx` in isolation) — the 20 pre-existing lint errors surfaced by the full `npm run lint` run are all in `StudyPlanPage.tsx`, unrelated to this plan's files, and out of scope per the deviation rules' scope boundary (logged here, not fixed).

## Issues Encountered
None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- All three PAY requirements (PAY-01, PAY-02, PAY-03) are source-verified and typecheck-clean; only `LandingPage.tsx` was touched, `UpgradeModal`/`LoginModal`/`AuthContext`/`Header` are unchanged.
- Runtime/browser verification of the three flows (logged-in instant open, logged-out login-then-upgrade, plain-login non-regression) is deferred to Plan 03-02's human-verify checkpoint, as designed by the phase plan.

---
*Phase: 03-landing-page-go-pro-payment-entry-point*
*Completed: 2026-07-04*

## Self-Check: PASSED

- FOUND: frontend/src/pages/LandingPage.tsx
- FOUND: 66fd99a (Task 1 commit)
- FOUND: fa8de58 (Task 2 commit)
