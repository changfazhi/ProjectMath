# Codebase Concerns

**Analysis Date:** 2026-06-29
**Branch:** firebase-auth (in-progress Firebase Auth migration)

---

## Security Concerns

### [CRITICAL] CORS production origin is a placeholder

- **Risk:** Any origin can reach the API in production if `CORS_ORIGIN` env var is not set — the fallback value `'https://yourproductiondomain.com'` is a literal string that will never match real traffic, so CORS will reject legitimate requests OR if misconfigured will open up.
- **Files:** `backend/src/index.ts` lines 19–23
- **Current state:**
  ```ts
  origin: process.env.NODE_ENV === 'production'
    ? (process.env.CORS_ORIGIN ?? 'https://yourproductiondomain.com')
    : 'http://localhost:5173',
  ```
- **Fix:** Set `CORS_ORIGIN` in production env. Document this as a required var in `.env.example`.

---

### [HIGH] Supabase service_role key bypasses all RLS

- **Risk:** The backend uses `SUPABASE_SERVICE_ROLE_KEY` which bypasses Row Level Security entirely. Every query runs with full admin privileges. There are no Supabase RLS policies providing a safety net — if backend auth logic has a bug, cross-user data leakage is possible.
- **Files:** `backend/src/db/supabase.ts` (sole Supabase client)
- **Current mitigation:** Auth middleware enforces `req.user!.uid` scoping manually in every service call. This is correct today, but fragile — a missed `.eq('session_id', userId)` filter would silently leak another user's data.
- **Fix:** Consider adding RLS policies as a defence-in-depth layer, even though service_role bypasses them in development. Alternatively, add an integration test that queries cross-user rows and asserts 0 results.

---

### [HIGH] `session_id` column stores user identity — data model mismatch

- **Risk:** The DB column is named `session_id` on tables `attempts`, `chat_messages`, `gradings`, `starred_questions`, `sr_cards`. It was originally the localStorage UUID. After the Firebase Auth migration, the backend now stores `req.user!.uid` (the Supabase `users.id` UUID, not the Firebase UID) in this column. The column name is now a lie — it stores a user identity, not a session. A future developer adding a query using the old localStorage `session_id` convention would silently corrupt cross-user isolation.
- **Files:** `backend/src/services/gradingService.ts` lines 213, 226, 312, 350; `backend/src/services/chatService.ts` lines 32, 111–112; `backend/src/services/reviewService.ts` lines 25, 46, 84; `backend/src/services/topicService.ts` lines 25, 59; `backend/src/services/diagnosticService.ts` lines 65, 200; `backend/src/types/index.ts` lines 62, 69, 110, 161
- **Fix:** Rename `session_id` to `user_id` in a DB migration. Update all service queries and type definitions.

---

### [HIGH] Firebase tier custom claims are never set — paid tier is unreachable

- **Risk:** `backend/src/middleware/auth.ts` reads `decoded['tier']` from the Firebase ID token to assign `'paid'` tier. However, there is no code anywhere in the backend that calls `setCustomUserClaims()` to grant this claim. `backend/src/config/featureTiers.ts` currently sets all features to `'free'`, which masks the bug — but if any feature is ever gated as `'paid'`, no user will ever be able to access it.
- **Files:** `backend/src/middleware/auth.ts` line 24; `backend/src/config/featureTiers.ts`
- **Fix:** Add an admin endpoint or Firebase Cloud Function to set custom claims. Document the mechanism before adding any paid-tier gates.

---

### [HIGH] `users` table has no migration file

- **Risk:** `backend/src/middleware/auth.ts` upserts into a `users` table on every authenticated request. This table is not listed in any of the 16 known SQL migration files in CLAUDE.md. The table must be created manually before the first Firebase auth login will succeed, but there is no documented migration for it.
- **Files:** `backend/src/middleware/auth.ts` lines 27–36
- **Fix:** Write and document a `017_users_table.sql` migration. Add to CLAUDE.md migration list.

---

### [MEDIUM] Email verification is not enforced after sign-up

- **Risk:** `AuthContext.tsx` calls `sendEmailVerification()` after email sign-up, but never checks `user.emailVerified` before allowing access. Unverified accounts can immediately use all features.
- **Files:** `frontend/src/contexts/AuthContext.tsx` (signUp function, onAuthStateChanged handler)
- **Current mitigation:** Google sign-in users are always verified. Email users can bypass verification.
- **Fix:** Check `user.emailVerified` in `onAuthStateChanged` and either block access or show a persistent verification banner.

---

### [MEDIUM] `dangerouslySetInnerHTML` in LandingPage from a large inline string

- **Risk:** `LandingPage.tsx` renders a 400+ line raw HTML string via `dangerouslySetInnerHTML={{ __html: MARKUP }}`. The `MARKUP` constant is static today, so XSS risk is low. But any future interpolation of user-controlled data (e.g., a name, email, or pricing value fetched from an API) into `MARKUP` would create an XSS vector with no escaping.
- **Files:** `frontend/src/pages/LandingPage.tsx` line 472
- **Fix:** Migrate marketing sections to proper JSX components. If `dangerouslySetInnerHTML` must remain, add a lint rule or comment explicitly forbidding interpolation into `MARKUP`.

---

### [LOW] Phone upload pairing token is used as the sole auth credential

- **Risk:** The `GET /api/pair/:token` and `POST /api/pair/:token/photo` endpoints require no Bearer token — possession of the 32-byte random token is the only credential. If the token leaks (via logs, screenshot of the QR, or compromised network), an attacker can upload photos to an in-progress grading session.
- **Files:** `backend/src/routes/pair.ts` (GET and POST handlers for `/:token`)
- **Current mitigation:** 10-minute TTL, 256-bit entropy token, max 5 photos per session. The attack window is narrow.
- **Fix:** Low priority. Document the intentional design in the route comment.

---

## Technical Debt

### [MEDIUM] `getActivityDate()` uses an unexplained 16-hour offset

- **Problem:** `PracticePage.tsx` computes the "activity date" for streak tracking by subtracting 16 hours: `new Date(Date.now() - 16 * 60 * 60 * 1000)`. This is a workaround for timezone issues (Singapore is UTC+8, so "today" for a student at 11pm SGT maps to the next UTC date). The number 16 is unexplained.
- **Files:** `frontend/src/pages/PracticePage.tsx` lines 27–28
- **Fix:** Replace with `Intl.DateTimeFormat('en-SG', { timeZone: 'Asia/Singapore' })` date formatting, or document the offset with a comment.

---

### [MEDIUM] `ThemeContext` deleted but `dark:` Tailwind classes remain throughout

- **Problem:** `frontend/src/contexts/ThemeContext.tsx` was deleted on the firebase-auth branch. `UpgradeModal.tsx` and `LoginModal.tsx` still use `dark:bg-slate-900`, `dark:text-slate-100`, `dark:text-slate-400` throughout. Without a `ThemeProvider` setting the `dark` class on `<html>`, these variants are permanently inactive. Any component still importing from `ThemeContext` will throw at runtime.
- **Files:** `frontend/src/components/UpgradeModal.tsx`; `frontend/src/components/LoginModal.tsx`
- **Fix:** Either restore `ThemeContext` and re-add `<ThemeProvider>` in `App.tsx`, or strip all `dark:` class variants from the affected components.

---

### [MEDIUM] Duplicate `FEATURE_TIERS` definition in frontend and backend

- **Problem:** Feature tier configuration exists in two places with identical values: `backend/src/config/featureTiers.ts` and `frontend/src/hooks/useFeature.ts`. These will drift. The frontend copy cannot be trusted for access control — it is only for UI gating. The backend copy is authoritative.
- **Files:** `backend/src/config/featureTiers.ts`; `frontend/src/hooks/useFeature.ts`
- **Fix:** Accept the duplication (two different purposes) but add a cross-reference comment in both files.

---

### [LOW] `mathjs evaluate()` used for range-answer grading is not length-limited

- **Risk:** `backend/src/services/attemptService.ts` uses `evaluate()` from `mathjs` to numerically compare student answers. A crafted answer with very deep recursion or expensive computation (e.g., `factorial(10000)`) could cause a slow response. Zod enforces `min(1)` but no `max()` on `answer_given`.
- **Files:** `backend/src/services/attemptService.ts` (latexToMathExpr + evaluate usage)
- **Fix:** Add `z.string().min(1).max(500)` to `answer_given` in the submit schema; consider using `mathjs.limitedEvaluate` to restrict available functions.

---

## Architectural Risks

### [HIGH] In-memory `pairService` — no persistence across restarts

- **Risk:** All in-flight phone-upload pairing sessions live in a `Map` in `backend/src/services/pairService.ts`. A backend restart (deploy, crash, process manager restart) silently drops all active pairings.
- **Files:** `backend/src/services/pairService.ts` lines 12–13
- **Accepted:** The module comment documents this as intentional ("Fine for a single instance"). The 10-minute TTL makes this a minor inconvenience.
- **Scaling risk:** This will not work behind a multi-instance load balancer.

---

### [HIGH] Socket.IO has no distributed adapter — single server only

- **Risk:** `backend/src/realtime.ts` uses an in-process Socket.IO server with no adapter (Redis, etc.). Desktop and phone must hit the same process for live photo transfer events to propagate. Horizontal scaling breaks the feature silently.
- **Files:** `backend/src/realtime.ts`
- **Fix:** If deploying multiple instances, add `@socket.io/redis-adapter`.

---

### [MEDIUM] Gemini API calls have no retry or fallback logic

- **Risk:** Both `chatService.ts` and `gradingService.ts` call Gemini once. A transient 503 or rate-limit response from Gemini returns a 500 to the student — their grading submission is lost with no recovery path.
- **Files:** `backend/src/services/chatService.ts`; `backend/src/services/gradingService.ts`
- **Fix:** Wrap Gemini calls in exponential backoff retry (1–2 retries for 5xx/429). Use `p-retry` or a simple loop.

---

### [MEDIUM] Multi-part question partial submission state is not rehydrated on reload

- **Risk:** If a student submits parts A and B of a 3-part question, then reloads the page, the `partStates` reducer in `usePracticeSession` starts fresh. Previously submitted parts show as 'idle' rather than 'done', and the student must re-submit them.
- **Files:** `frontend/src/hooks/usePracticeSession.ts` (reducer `LOAD_SUCCESS` action)
- **Current mitigation:** Attempt history is persisted in the DB. The Attempts tab shows prior results.
- **Fix:** On `LOAD_SUCCESS`, call `GET /api/attempts?question_id=...` and pre-populate `partStates` with prior results.

---

## Frontend Concerns

### [MEDIUM] No route-level auth guards — relies on API 401 triggering login modal

- **Risk:** All `/roadmap`, `/practice/:topicId`, `/history`, etc. routes render without checking auth state. An unauthenticated user sees a loading spinner until the first API call returns 401, which triggers `openLoginModal()`. This produces a flash of loading UI before the modal appears.
- **Files:** `frontend/src/App.tsx` (router definition); `frontend/src/lib/api.ts` lines 53–57
- **Fix:** Add a `<RequireAuth>` wrapper component that checks `useAuth().loading` and `useAuth().user` and shows the login modal or redirects to `/` immediately on mount.

---

### [LOW] StrictMode double-invoke causes two API calls on every `PracticePage` mount

- **Risk:** `loadNext` and `loadSpecific` are `useCallback` functions invoked from `useEffect`. StrictMode mounts effects twice, causing two network requests. The second overwrites the first. No data corruption — just wasted requests.
- **Files:** `frontend/src/hooks/usePracticeSession.ts` lines 193–230
- **Note:** CLAUDE.md explicitly forbids the `firstLoad` ref workaround. The current approach is correct per convention.

---

## In-Progress / WIP (firebase-auth branch)

### Modified files and their state

| File | Status | Notes |
|---|---|---|
| `frontend/src/App.tsx` | Modified | `ThemeProvider` removed; `/` now routes to `LandingPage`; `/roadmap` is the new app entry |
| `frontend/src/pages/HomePage.tsx` | Modified | Likely updated links from `/` to `/roadmap` (not fully reviewed) |
| `frontend/src/pages/PracticePage.tsx` | Modified | "← Topics" link updated from `/` to `/roadmap` |
| `frontend/src/pages/ReviewPage.tsx` | Modified | SVG icon components added; `dark:` Tailwind classes replaced with inline styles; cosmetic only |
| `frontend/src/components/layout/Header.tsx` | Modified | Uses `useAuth()` to render Sign in / Sign out button |
| `frontend/src/components/layout/StudyPlanSidebar.tsx` | Modified | Accessibility improvements (focus management via refs) |
| `frontend/src/components/topic/RoadmapGraph.tsx` | Modified | Not reviewed |
| `frontend/src/contexts/ThemeContext.tsx` | **Deleted** | Dark mode removed; `dark:` class usages in other components are now dead |
| `frontend/src/pages/LandingPage.tsx` | **Untracked (new)** | 475-line marketing page; not yet committed |
| `frontend/index.html` | Modified | Not reviewed (likely font/title changes) |

### Not yet implemented / placeholder state

1. **Custom claims for `tier`** — No mechanism to promote a user to `'paid'`. The `UpgradeModal` shows "coming soon." The monetization path is a shell with no backend wiring.

2. **`users` table migration** — The table is required by `requireAuth` but has no documented SQL migration file. Deployment without this table will cause all authenticated requests to return 500.

3. **Email verification enforcement** — `sendEmailVerification()` is called but never checked. Email sign-ups can access the full app with an unverified address.

4. **LandingPage pricing section** — Static HTML showing `$15/mo` / `$12/mo` pricing cards with no payment integration (Stripe, etc.).

5. **`LandingPage.tsx` is untracked** — The file has not been committed. Switching branches or resetting will lose it.

---

## Test Coverage Gaps

### [HIGH] No test suite exists

- No `*.test.*` or `*.spec.*` files found in the repository.
- No `jest.config.*`, `vitest.config.*`, or test runner configured.
- **Critical untested paths:**
  - `backend/src/services/attemptService.ts` — `normalizeLaTeX()` has 15+ regex transforms; a broken regex silently marks correct answers wrong
  - `backend/src/services/attemptService.ts` — `latexToMathExpr()` + `mathjs evaluate()` range grading
  - `backend/src/middleware/auth.ts` — Firebase token verification and `users` upsert
  - `backend/src/services/pairService.ts` — token expiry, image count limits
  - Multi-part completion detection: "all graded parts correct" logic in `attemptService.ts`
- **Priority:** High — LaTeX normalization regressions are silent and affect grading accuracy for every student.

---

*Concerns audit: 2026-06-29*
