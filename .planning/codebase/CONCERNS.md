# Codebase Concerns

**Analysis Date:** 2026-06-28

## Security Considerations

**Unauthenticated Solution Exposure:**
- Risk: `GET /api/questions/:id/solution` returns `solution_latex` (the model answer) with no auth check. Any client that knows a question UUID can fetch the full solution without submitting an attempt.
- Files: `backend/src/routes/questions.ts` (lines 43–54)
- Current mitigation: None. The route has no `requireAuth` or `gate()` guard.
- Recommendations: Add `requireAuth` (or `gate('practice')`) to this endpoint. Solutions should only be revealed post-submission, which is already enforced correctly on `POST /api/attempts`.

**Internal Error Messages Leaked to Clients:**
- Risk: Every catch block across all routes does `res.status(500).json({ error: (err as Error).message })`. Supabase error strings, SQL fragments, and internal service messages are sent directly to the browser.
- Files: `backend/src/routes/attempts.ts`, `topics.ts`, `questions.ts`, `grade.ts`, `pair.ts`, `review.ts`, `stars.ts`, `concepts.ts`, `chat.ts`, `streaks.ts`
- Current mitigation: None.
- Recommendations: Map known error types to safe user messages; log the full error server-side only. At minimum, replace 500 catch-alls with a generic `"Internal server error"` string.

**Socket.IO CORS Wildcard:**
- Risk: `cors: { origin: '*' }` on the Socket.IO server allows any origin to connect and subscribe to any pairing token room.
- Files: `backend/src/realtime.ts` (line 11)
- Current mitigation: Pairing tokens are 256-bit random values, so brute-forcing a room name is infeasible. However, a known token (e.g., intercepted QR link) can be subscribed from any origin.
- Recommendations: Restrict origin to `process.env.CORS_ORIGIN` in production, matching the HTTP CORS policy on `backend/src/index.ts`.

**Tier Read From Unverified Firebase Custom Claim:**
- Risk: `auth.ts` reads `decoded['tier']` from the Firebase ID token custom claim. Custom claims must be set server-side via Firebase Admin SDK; if that mechanism is not implemented, all users will always evaluate as `'free'` — the gate silently fails open.
- Files: `backend/src/middleware/auth.ts` (line 24), `backend/src/config/featureTiers.ts`
- Current mitigation: All features are currently set to `'free'` tier in `FEATURE_TIERS`, so the gate has no practical effect. The `subscription_tier` column in the `users` table (`019_firebase_auth.sql`) is never read by the backend.
- Recommendations: Either (a) build a Stripe webhook that sets custom claims via Firebase Admin, or (b) read `subscription_tier` from the `users` Supabase row (already upserted on login) rather than relying on the unset custom claim.

**No Row-Level Security on Supabase Tables:**
- Risk: The backend uses `SUPABASE_SERVICE_ROLE_KEY` which bypasses RLS entirely. No RLS policies exist on any table. A Supabase key leak would expose the entire database.
- Files: `backend/src/db/supabase.ts`, all `backend/supabase/migrations/*.sql`
- Current mitigation: The service role key is server-side only; the frontend never sees it.
- Recommendations: Add RLS policies scoped to `session_id = auth.uid()` as a defence-in-depth measure. For the current single-server model this is low priority, but important before any client-direct Supabase access is introduced.

**No Rate Limiting on Attempts, Stars, or Streaks:**
- Risk: `POST /api/attempts`, `POST /api/stars`, `GET /api/streaks` have no rate limiter. An authenticated user can submit thousands of attempts per second, inflating streak counts and SR card state.
- Files: `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts`, `backend/src/routes/streaks.ts`
- Current mitigation: Only chat, grade, and pair routes have `express-rate-limit`.
- Recommendations: Add an IP-based limiter (e.g. 60 req/min) to attempts and stars routes.

---

## Tech Debt

**`session_id` Column Name Mismatch After Auth Migration:**
- Issue: All database tables (`attempts`, `starred_questions`, `chat_messages`, `gradings`, `spaced_repetition_cards`) use a column named `session_id` but now store Firebase-resolved user UUIDs from the `users` table, not browser session UUIDs. The comment in migration 001 says "client-generated UUID stored in localStorage (no auth required for MVP)."
- Files: `backend/supabase/migrations/001_initial_schema.sql` (line 31), `backend/supabase/migrations/004_starred_questions.sql`, `backend/supabase/migrations/011_chat_messages.sql`, `backend/supabase/migrations/013_solution_gradings.sql`, `backend/supabase/migrations/018_spaced_repetition.sql`
- Impact: Misleading column semantics; any future migration or external query will assume localStorage UUIDs. Historical data from pre-auth users stored random UUIDs that cannot be migrated without an ID mapping.
- Fix approach: Add a migration to rename `session_id` to `user_id` across all tables and update indexes. Keep the old column as an alias until all services are updated.

**Subscription/Tier System Is Scaffolded But Non-Functional:**
- Issue: The auth middleware reads a Firebase custom claim (`tier`) that is never set. `FEATURE_TIERS` sets every feature to `'free'`. The `UpgradeModal` shows "Premium plans are coming soon!" with no payment integration. The `users` table has `stripe_customer_id` and `subscription_tier` columns that are never written.
- Files: `backend/src/config/featureTiers.ts`, `backend/src/middleware/auth.ts` (line 24), `frontend/src/components/UpgradeModal.tsx`, `backend/supabase/migrations/019_firebase_auth.sql`
- Impact: The gating infrastructure exists but provides no monetisation. Dead columns in the DB.
- Fix approach: Implement a Stripe webhook handler that updates `subscription_tier` in Supabase and sets Firebase custom claims via Admin SDK; or remove the scaffolding until payment is planned.

**Migrations 017–019 Not Documented in CLAUDE.md:**
- Issue: `CLAUDE.md` documents migrations 001–016 but omits 017 (`017_ri_prelim_2025.sql`), 018 (`018_spaced_repetition.sql`), and 019 (`019_firebase_auth.sql`). A developer following the setup guide will miss three required migrations.
- Files: `/Users/chang/ProjectMath/CLAUDE.md` (Database Setup section), `backend/supabase/migrations/017_ri_prelim_2025.sql`, `backend/supabase/migrations/018_spaced_repetition.sql`, `backend/supabase/migrations/019_firebase_auth.sql`
- Impact: New environment setup will be broken without these migrations.
- Fix approach: Add entries 17, 18, and 19 to the Database Setup section of CLAUDE.md.

**`getWeakTopicsItems` Returns All Questions from Weak Topics (Unbounded):**
- Issue: `getWeakTopicsItems()` fetches all questions from the bottom 25% of topics and returns every single one with no cap. On a large question bank this could return hundreds of items.
- Files: `backend/src/services/reviewService.ts` (lines 73–77)
- Impact: Over-large review queues degrade UX; no practical upper bound on response payload size.
- Fix approach: Add `.slice(0, N)` (e.g. 20) or accept a `limit` parameter before returning.

**`fetchQuestionMap()` Called Redundantly Across Review Functions:**
- Issue: `getCorrectionsItems`, `getWeakTopicsItems`, `getSpeedDrillItems` each independently call `fetchQuestionMap()` which does a full `SELECT id, topic_id FROM questions`. On three simultaneous review tab loads, this runs three identical full-table fetches.
- Files: `backend/src/services/reviewService.ts` (lines 12–20, 24, 45, 80)
- Impact: Unnecessary DB reads; minor performance overhead today but will worsen as question count grows.
- Fix approach: Cache the question map with a short TTL (e.g. 5 minutes) at the module level, or accept it as a parameter so callers can share one fetch.

**`getActivityDate()` Hardcoded Timezone Offset:**
- Issue: `getActivityDate()` subtracts 16 hours to shift UTC midnight to Singapore time (UTC+8). This is a magic constant that breaks for users in other timezones and silently drifts during daylight saving transitions (though Singapore does not observe DST, students accessing from overseas would be affected).
- Files: `frontend/src/pages/PracticePage.tsx` (lines 27–28), `frontend/src/pages/StatsPage.tsx` (line 16)
- Impact: Streak notifications may fire on the wrong calendar day for non-SGT users.
- Fix approach: Use `Intl.DateTimeFormat` with `timeZone: 'Asia/Singapore'` to compute the local date string reliably.

---

## Performance Bottlenecks

**Full Attempts Table Scan Per Review Request:**
- Problem: `getCorrectionsItems`, `getWeakTopicsItems`, `getSpeedDrillItems` each fetch all rows from `attempts` for a user with only `session_id` filtering. For an active user with thousands of attempts this is a full sequential scan on the filtered set.
- Files: `backend/src/services/reviewService.ts` (lines 25, 46, 84)
- Cause: No aggregation pushed to the database; grouping and filtering done in JS.
- Improvement path: Move aggregation to Supabase RPC (PostgreSQL function) or add a materialised summary table updated on each attempt insert.

**`getPersonalisedStudyPlan` and `getWeaknessDiagnosis` Call Gemini Synchronously on Every Request:**
- Problem: Both AI diagnostic functions make a synchronous Gemini API call (2–5 second latency) on every HTTP request with no caching.
- Files: `backend/src/services/diagnosticService.ts`
- Cause: No result caching.
- Improvement path: Cache results in the `users` table or a dedicated `diagnoses` table with a `generated_at` timestamp; re-generate only when stale (e.g. after 24 hours or after N new attempts).

**`SELECT *` Everywhere:**
- Problem: All service-layer Supabase queries use `.select('*')`. For `questions`, this includes `solution_latex` (potentially multi-KB LaTeX strings) even when only metadata is needed.
- Files: `backend/src/services/questionService.ts` (lines 19, 49, 64, 81), `backend/src/services/chatService.ts` (lines 31, 114), `backend/src/services/topicService.ts` (lines 7, 114), `backend/src/services/attemptService.ts` (line 217)
- Cause: Convenience; column stripping is done in JS after fetch.
- Improvement path: Project only the required columns in `.select()` calls, especially for list endpoints that never need `solution_latex` or `correct_answer`.

---

## Fragile Areas

**`PracticePage.tsx` God Component (503 lines):**
- Files: `frontend/src/pages/PracticePage.tsx`
- Why fragile: Manages practice session state, photo grading state, QR pairing state, chat state, attempts list state, solution tab state, streak notification, tab switching, and diff filter in a single component. Interleaving of concerns means a bug in one flow (e.g. pairing) can corrupt unrelated state (e.g. answer submission).
- Safe modification: All state mutations go through `usePracticeSession` hook; isolate further by extracting a `<PairFlow>` and `<SolutionTab>` component before adding new features.
- Test coverage: No automated tests exist for this component.

**In-Memory Pair Store Lost on Backend Restart:**
- Files: `backend/src/services/pairService.ts`
- Why fragile: All active pairings are held in a `Map` in Node.js memory. Any backend restart (deploy, OOM kill, crash) silently drops all in-flight phone upload sessions. Users mid-upload see the grading request fail with no indication of why.
- Safe modification: The comment acknowledges this trade-off. Acceptable for single-instance dev use; add a user-visible error message on the `pair:error` event for expired tokens.
- Test coverage: None.

**`normalizeLaTeX` / `trySymbolicEval` Answer Matching Is Brittle:**
- Files: `backend/src/services/attemptService.ts` (lines 7–95)
- Why fragile: The regex-based LaTeX normaliser and the two-point symbolic evaluator can produce false positives (e.g. `x+1` matches `1+x` for numeric `x=2`, `x=11`) or false negatives (e.g. complex LaTeX that the `latexToMathExpr` regex misparses). Failures are silent — the attempt is marked wrong or right with no indication of a normalisation bug.
- Safe modification: Add unit tests with edge cases before extending the normaliser. Log cases where symbolic eval succeeds but string match fails.
- Test coverage: Zero — no test files exist in the entire project.

**`CORS_ORIGIN` Default Placeholder in Production Config:**
- Files: `backend/src/index.ts` (line 22)
- Why fragile: If `NODE_ENV=production` but `CORS_ORIGIN` is unset, the fallback is `'https://yourproductiondomain.com'` — a literal placeholder that will reject all browser requests in production. This is an easy misconfiguration that silently breaks the entire API.
- Safe modification: Add an explicit startup check: if `NODE_ENV=production && !process.env.CORS_ORIGIN`, throw and refuse to start.

---

## Missing Critical Features

**No Error Monitoring / Observability:**
- Problem: There is no error tracking (Sentry, Bugsnag, etc.) and no structured logging beyond `console.log` at startup. Runtime errors in services are silently swallowed or returned to the client as raw strings.
- Blocks: Production debugging; catching Gemini API failures, Supabase timeouts, or rate-limit exhaustion.

**No Test Suite:**
- Problem: Zero test files exist (`*.test.ts`, `*.spec.ts`, `*.test.tsx`) across backend and frontend.
- Files: Entire `backend/src/` and `frontend/src/` trees
- Risk: Any refactor to the answer-checking logic (`attemptService.ts`), multi-part flow (`PracticePage.tsx`), or SR algorithm (`spacedRepetitionService.ts`) can introduce regressions with no automated safety net.
- Priority: High — especially for `normalizeLaTeX`, `checkAnswer`, `sm2`, and `buildTopicStats`.

**Mistake Log Page Not Built:**
- Problem: `CLAUDE.md` notes "mistake log" page is not built. The `gradings` table stores `is_correct=false` gradings which contain per-part error descriptions, but no UI surfaces this data.
- Blocks: Students cannot review AI-identified errors in their handwritten solutions.

**No Admin Question Editor:**
- Problem: Questions are added exclusively via raw SQL migrations. Errors in `parts` JSONB (wrong escaping, wrong `answer_type`) are only caught at runtime when students attempt the question.
- Blocks: Iterating on question content without developer access.

---

## Dependencies at Risk

**`@google/genai` SDK (Gemini):**
- Risk: The Gemini API is used for three distinct features (chat hints, photo grading, diagnostics). A single `GEMINI_API_KEY` covers all three. API quota exhaustion or model deprecation would silently break all AI features simultaneously.
- Impact: Chat, photo grading, and AI diagnosis all fail.
- Migration plan: Add per-feature fallback error handling; separate keys per use-case if quota allows.

**`mathjs` for LaTeX Evaluation:**
- Risk: `evaluate()` from `mathjs` is called with user-supplied strings derived from LaTeX normalisation. While the current `latexToMathExpr` regex guards against obvious injection, `mathjs` `evaluate()` can execute arbitrary expressions (matrix operations, unit conversions) that may throw or return unexpected types.
- Impact: An edge-case student answer could cause an unhandled exception in `tryNumericEval` — currently caught by the `try/catch`, so it fails closed (returns `null`). Low severity.
- Migration plan: Wrap the entire `checkAnswer` call in a try/catch and add a timeout if `mathjs` evaluation proves slow on complex expressions.

---

*Concerns audit: 2026-06-28*
