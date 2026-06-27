# Codebase Concerns

**Analysis Date:** 2026-06-27

## ~~No Authentication / Session Hijacking~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** Firebase Authentication implemented. All write endpoints are protected by `requireAuth` middleware (`backend/src/middleware/auth.ts`), which cryptographically verifies Firebase ID tokens via `getAuth(getFirebaseAdmin()).verifyIdToken()`. User identity (`req.user.uid`) is derived server-side from the verified token — never accepted from client input. `session_id` is no longer passed in request bodies or query params from the client.

---

## ~~CORS Fully Open~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** `cors()` in `backend/src/index.ts` now uses an explicit `origin` allowlist (`localhost:5173` in dev, `CORS_ORIGIN` env var in prod). Requests from arbitrary origins are rejected.

---

## No Row-Level Security on Any Table

**Severity: HIGH — Intentionally Deferred**

**Issue:** All migrations grant `ALL` to `anon`, `authenticated`, and `service_role` but zero RLS policies exist. Any caller with the Supabase URL and anon key can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row directly via the Supabase REST or realtime API, bypassing the Express backend entirely.

**Files:** `backend/supabase/migrations/001_initial_schema.sql` through `019_firebase_auth.sql` (no `ENABLE ROW LEVEL SECURITY` or `CREATE POLICY` statement in any migration)

**Impact:** Questions (including `correct_answer` and `solution_latex`) can be read directly from Supabase without going through the backend's stripping logic.

**Fix approach:** Intentionally deferred — all Supabase access goes through the Express backend using the service-role key; there is no direct browser→Supabase query path. The Express auth middleware is the enforcement layer. RLS remains a future hardening option if a direct Supabase query path is ever introduced.

---

## Auth Infrastructure Concerns

### Firebase Env Vars Not in .env.example

**Severity: HIGH**

**Issue:** `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, and `FIREBASE_PRIVATE_KEY` are required by `backend/src/db/firebase.ts` but were not present in `.env.example` before the firebase-auth PR. Any developer cloning the repo and following the standard setup will get a backend crash on start with a cryptic Firebase SDK error rather than a clear "missing env var" message.

**Files:** `backend/src/db/firebase.ts`, `backend/.env.example`

**Impact:** New developers blocked from running the backend. CI/CD pipelines fail silently.

**Fix approach:** Verify `.env.example` now includes all three Firebase vars with placeholder values and inline comments. Add startup validation in `backend/src/db/firebase.ts` that throws a clear error listing all missing vars before the Firebase SDK initialises.

### Migration 019 Has No Automated Path

**Severity: HIGH**

**Issue:** `backend/supabase/migrations/019_firebase_auth.sql` creates the `users` table (firebase_uid, email, subscription_tier, stripe_customer_id). This migration must be run manually in the Supabase SQL editor. There is no automated migration runner, no CI step, and no validation that the table exists before `requireAuth` tries to upsert into it. If the migration hasn't run, every authenticated request returns HTTP 500 (`Failed to resolve user`).

**Files:** `backend/supabase/migrations/019_firebase_auth.sql`, `backend/src/middleware/auth.ts` (lines 27–38)

**Fix approach:** Add a startup health-check query in `backend/src/index.ts` that selects from `public.users` and logs a fatal error with migration instructions if the table is missing.

### Tier Claim Reads from Firebase Custom Claim, Not Supabase users Table

**Severity: MEDIUM**

**Issue:** `requireAuth` in `backend/src/middleware/auth.ts` (line 24) reads `decoded['tier']` from the Firebase ID token custom claim to determine `free`/`paid` tier. The `users` table in Supabase has a `subscription_tier` column (migration 019) but it is never read during auth. The two sources can diverge: a Supabase row may say `paid` while the Firebase custom claim says `free` (or vice versa after a failed Stripe webhook).

**Files:** `backend/src/middleware/auth.ts` (line 24), `backend/supabase/migrations/019_firebase_auth.sql` (line 6)

**Impact:** Subscription tier inconsistencies are silently ignored. The Firebase custom claim is the single source of truth, but it is only updated via a server SDK call — if that call fails, the user is stuck on the wrong tier with no self-healing path.

**Fix approach:** On each `requireAuth` call, cross-check `decoded.tier` against `users.subscription_tier` and prefer the DB value (which is writable by the Stripe webhook). Alternatively, remove the `tier` column from Supabase and commit to Firebase custom claims as the sole tier source, documented explicitly.

### All Feature Tiers Currently Set to 'free' — Gate Logic Untested

**Severity: MEDIUM**

**Issue:** `backend/src/config/featureTiers.ts` sets every feature to `'free'`. The `gate()` middleware in `backend/src/middleware/auth.ts` (lines 48–59) implements payment enforcement logic that is never exercised. When tiers are eventually activated, the payment wall will be untested code.

**Files:** `backend/src/config/featureTiers.ts`, `backend/src/middleware/auth.ts` (lines 48–59)

**Fix approach:** Add integration tests for `gate()` before activating paid tiers. The 402 response path and `Subscription required` error are confirmed untested.

### CORS Production Fallback Hardcoded to Placeholder Domain

**Severity: MEDIUM**

**Issue:** `backend/src/index.ts` (line 23) falls back to `'https://yourproductiondomain.com'` if `CORS_ORIGIN` env var is missing in production. This silently blocks all cross-origin requests with no error log.

**Files:** `backend/src/index.ts` (lines 20–24)

**Fix approach:** Throw a fatal startup error if `NODE_ENV === 'production'` and `CORS_ORIGIN` is not set. Replace the placeholder string with a startup assertion.

---

## Session ID / User ID Schema Mismatch

**Severity: HIGH**

**Issue:** Core tables (`attempts`, `starred_questions`, `chat_messages`, `gradings`, `spaced_repetition_cards`) have a `session_id UUID` column created before auth was introduced. The backend services now write the Firebase-derived Supabase user UUID into this column under the name `session_id` (e.g. `starService.ts` line 37: `{ session_id: userId, ... }`, `chatService.ts` lines 111–112). The column is semantically a user identifier but structurally named and typed as a guest session token.

**Files:**
- `backend/supabase/migrations/001_initial_schema.sql` (line 34: `session_id UUID NOT NULL`)
- `backend/supabase/migrations/004_starred_questions.sql` (line 3)
- `backend/supabase/migrations/011_chat_messages.sql` (line 4)
- `backend/supabase/migrations/013_solution_gradings.sql` (line 8)
- `backend/supabase/migrations/018_spaced_repetition.sql` (line 9)
- `backend/src/services/starService.ts` (lines 24, 32, 37, 45, 61, 109)
- `backend/src/services/chatService.ts` (lines 32, 111–112)
- `backend/src/services/gradingService.ts` (lines 213, 226, 312, 350)
- `backend/src/services/topicService.ts` (line 25)

**Impact:**
1. Column naming is misleading — future developers will not know whether `session_id` holds a guest token or a user UUID without reading the auth middleware.
2. Pre-auth guest data (rows where `session_id` is a localStorage UUID, not a Supabase user UUID) cannot be attributed to any user — those rows are orphaned permanently with no migration path.
3. A foreign key from `session_id` to `users.id` cannot be added without a data-cleaning migration, leaving referential integrity absent.

**Fix approach:** Rename `session_id` → `user_id` across all tables in a future migration, add `REFERENCES users(id) ON DELETE CASCADE`, and document that pre-auth guest rows will be dropped or archived before the migration runs.

---

## Tech Debt

### In-Memory Pair Sessions Without Horizontal Scaling

**Issue:** Pairing handshakes stored in a plain `Map` (`pairs`) in `pairService.ts` (line 9). Single-instance only; restart drops in-flight pairings.

**Files:** `backend/src/services/pairService.ts`

**Impact:** Cannot scale to multiple backend instances without rewriting pair storage. Users mid-scan lose their pairing on deploy.

**Fix approach:** Migrate pair storage to a Supabase `pair_sessions` table (token, user_id, question_id, expires_at) with a cleanup cron. The existing TTL sweep pattern (lines 67–72) maps cleanly to a Supabase `DELETE WHERE expires_at < NOW()` job.

### IP-Based Rate Limiting Not Load-Balancer Aware

**Issue:** Rate limits in `chat.ts`, `grade.ts`, and `pair.ts` use `express-rate-limit` with default IP detection. Behind a load balancer or proxy, all requests appear from the same IP.

**Files:** `backend/src/routes/chat.ts`, `backend/src/routes/grade.ts`, `backend/src/routes/pair.ts`

**Impact:** All users behind a load balancer share one rate limit bucket.

**Fix approach:** Configure `keyGenerator: (req) => req.headers['x-forwarded-for'] ?? req.ip` or use a custom header from the load balancer.

### Large Component Files

**Issue:** `PracticePage.tsx` is ~598 lines, `RoadmapGraph.tsx` is ~321 lines.

**Files:** `frontend/src/pages/PracticePage.tsx`, `frontend/src/components/topic/RoadmapGraph.tsx`

**Impact:** Hard to test and maintain. `RoadmapGraph` has hardcoded pixel positions — unmaintainable as topic count grows.

**Fix approach:** Split `PracticePage` into sub-components. Refactor `RoadmapGraph` to accept layout data from props rather than hardcoded `POSITIONS`.

### Missing Error Boundaries

**Issue:** No React error boundary components. A runtime error in any component crashes the entire page.

**Files:** `frontend/src/App.tsx`, `frontend/src/pages/*.tsx`

**Fix approach:** Add a root error boundary in `App.tsx` with a fallback UI and "reload" button.

### toggleStar Missing Dependency in useTopicQuestions

**Issue:** `useTopicQuestions.ts` (line 72) returns `toggleStar` wrapped in `useCallback` with an empty dependency array `[]`. `toggleStar` calls `api.stars.toggle` which implicitly depends on auth state. If the auth token changes mid-session (refresh or sign-in), the stale closure continues making requests under the old user context.

**Files:** `frontend/src/hooks/useTopicQuestions.ts` (line 72)

**Fix approach:** Add `user` to the `useCallback` dependency array to keep the callback current. The `useEffect` on line 44 already has `user` as a dependency — the `useCallback` should match.

---

## Rate Limiting Gaps on Write Endpoints

**Severity: MEDIUM (partially mitigated by auth)**

**Issue:** `POST /api/chat` (15/min), `POST /api/grade` (5/min), and all `/api/pair/*` routes (30/min) are rate-limited. The following write endpoints have no rate limiting: `POST /api/attempts`, `POST /api/stars`.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts` (no `rateLimit` import or middleware)

**Partial mitigation:** Both endpoints now require a verified Firebase token. Anonymous bulk-write abuse is eliminated. Authenticated abuse (a logged-in user hammering the endpoint) is still possible.

**Fix approach:** Add a global `rateLimit` middleware in `backend/src/index.ts` (e.g. 120 req/min per IP) as a backstop, plus a per-user limiter for subscription-differentiated caps when tiers are introduced.

---

## Scaling Limits

### LaTeX Evaluation Performance Risk

**Issue:** `attemptService.ts` uses `mathjs.evaluate()` on user-supplied LaTeX expressions (lines 49, 60, 82–90). No timeout or complexity bounds.

**Files:** `backend/src/services/attemptService.ts`

**Impact:** A maliciously crafted expression could block the Node.js event loop and exhaust backend capacity.

**Fix approach:** Wrap `evaluate()` calls in a 100ms timeout. Reject expressions exceeding a maximum character length before evaluation.

### Image Storage In-Memory Before Upload

**Issue:** Images are held in multer memory storage, then converted to base64, sent to Gemini, and uploaded to Supabase. Multiple copies exist in RAM simultaneously.

**Files:** `backend/src/routes/grade.ts` (line 14), `backend/src/routes/pair.ts` (line 16)

**Impact:** With `GRADE_MAX_IMAGES=5` and `GRADE_MAX_IMAGE_MB=8`, a single request can use ~40MB RAM. Under concurrent load this could exhaust heap memory.

**Fix approach:** Stream images directly to Supabase Storage instead of buffering in memory.

### Single-Instance In-Memory Caching

**Issue:** No distributed caching. Question data, topic trees, and attempt history are queried from Supabase on every request.

**Impact:** Supabase query quota and latency increase as user count grows.

**Fix approach:** Add Redis or Memcached for frequently accessed read-only data (topics, questions, concepts).

---

## Performance Bottlenecks

### Sequential Queries in getNextQuestion

**Issue:** `questionService.ts` fetches all questions, then correct attempts separately — two queries where one could suffice.

**Files:** `backend/src/services/questionService.ts`

**Fix approach:** Use a single query with a subselect or LEFT JOIN. Add index on `(topic_id, is_correct, user_id)`.

### LaTeX Rendering Not Memoized

**Issue:** `renderLatex()` creates a React node tree on every render. No memoization.

**Files:** `frontend/src/lib/renderLatex.tsx`

**Fix approach:** Memoize via `useMemo` at call sites or cache parsed output by input string.

### RoadmapGraph Hardcoded Coordinates

**Issue:** Topic layout uses hardcoded pixel coordinates. Adding a new topic requires manual editing of all x/y values.

**Files:** `frontend/src/components/topic/RoadmapGraph.tsx` (lines 12–45)

**Fix approach:** Implement a graph layout algorithm (e.g. force-directed via d3-force).

---

## Security Considerations

### Token Stored in IndexedDB (XSS Risk)

**Severity: LOW (accepted)**

**Issue:** Firebase stores ID tokens in browser IndexedDB. Any injected XSS script can read and exfiltrate the token (valid for up to 1 hour).

**Mitigating factors:** React escapes HTML by default, eliminating the most common XSS vector. The app stores no financially sensitive data.

**Fix approach:** Accepted tradeoff for current scope. Revisit httpOnly cookie-based sessions if PII or payment data is added.

### Unvalidated Chat and Grade Instruction Content

**Issue:** `chatService.ts` and `gradingService.ts` inject `question.solution_latex` into the Gemini system instruction verbatim.

**Files:** `backend/src/services/chatService.ts`, `backend/src/services/gradingService.ts`

**Impact:** Low risk (data is manually inserted by admins), but violates defense-in-depth.

**Fix approach:** Sanitize LaTeX content before injecting into prompts.

### Socket.IO Events Not Validated

**Issue:** `realtime.ts` accepts arbitrary data from `socket.on('pair:subscribe')` without Zod validation.

**Files:** `backend/src/realtime.ts`

**Fix approach:** Validate event payloads with Zod. Token must be a base64url string of known length.

### No CSRF Protection on State-Changing Endpoints

**Issue:** `POST /api/attempts`, `POST /api/stars`, `POST /api/grade` accept JSON without a CSRF token.

**Files:** `backend/src/routes/*.ts`

**Impact:** Low risk for a pure API with strict CORS. Document that endpoints are API-only.

**Fix approach:** Enforce same-origin CORS strictly. No further action required if always served as API.

### No Rate Limiting on Question Lookups

**Issue:** `GET /api/questions/:id` has no rate limiting. A bot could enumerate all question content including solution previews.

**Files:** `backend/src/routes/questions.ts`

**Fix approach:** Add global rate limiting in `backend/src/index.ts`.

---

## Fragile Areas

### Multi-Part Question State Machine

**Issue:** Multi-part grading depends on parts being marked graded (`answer_type !== null`). If a migration adds a part without setting `answer_type` correctly, that part becomes invisible to the progress system.

**Files:** `backend/src/services/attemptService.ts` (lines 179–180), `backend/src/services/gradingService.ts` (lines 204–206)

**Safe modification:** Always set `answer_type` explicitly. Add a validation query to detect parts with `NULL answer_type` and missing `correct_answer`.

### Attempt Recording in Photo Grading Label Matching

**Issue:** `gradingService.ts` maps graded parts by case-insensitive label match. If a label is spelled differently in the parts array vs. returned by Gemini, that part's attempt is silently skipped.

**Files:** `backend/src/services/gradingService.ts`

**Safe modification:** Validate that labels returned by Gemini exactly match `question.parts` labels. Return a grading error if a label is unrecognised.

### Race Condition in Solution Reveal

**Issue:** `attemptService.ts` queries attempts twice: once to submit, once to check if all parts are done. A concurrent submission could reveal the solution prematurely or not at all.

**Files:** `backend/src/services/attemptService.ts`

**Safe modification:** Use a database transaction or a separate `question_completion` table to atomically record all-parts-done status.

### Socket.IO Connection Failure Silent

**Issue:** `socket.ts` calls `io()` with no error handling. If the backend is down, the connection silently fails and no event handlers fire.

**Files:** `frontend/src/lib/socket.ts`

**Safe modification:** Add `socket.on('connect_error', ...)` handler. Show "Connection lost" UI to the user.

---

## Test Coverage Gaps

**Zero tests exist anywhere in the codebase.** The following areas are highest priority.

### Auth Middleware Untested

**Issue:** `requireAuth` (token verification, Supabase upsert, error paths) and `gate()` (tier checking, 402 responses) have no tests. These are the primary security and access-control boundaries.

**Files:** `backend/src/middleware/auth.ts`

**Priority:** High

**Fix approach:** Mock `firebase-admin/auth` and `supabase`. Test: valid token, expired token, missing header, upsert failure, free-tier user hitting a paid gate, paid-tier user passing a gate.

### No Tests for Gemini Integration

**Issue:** `chatService.ts` and `gradingService.ts` call Gemini without unit test mocks.

**Priority:** Medium

**Fix approach:** Mock `getGemini()` in tests. Create fixture responses for valid and invalid model outputs.

### No Tests for Rate Limiting

**Issue:** No test suite validates that rate limiters correctly reject requests after the limit.

**Priority:** High — Rate limiting is a cost control for Gemini API.

**Fix approach:** Write integration tests that exhaust rate limits and verify 429 responses.

### No Tests for Multi-Part Question Logic

**Issue:** Multi-part state machines (attempt submission, solution reveal) have no tests.

**Priority:** High — Multi-part is used for most prelim questions.

**Fix approach:** Add tests for: (a) single-part vs. multi-part submission, (b) show-that parts (answer_type=null), (c) all-parts-done reveal logic, (d) concurrent submissions.

### No Tests for Photo Grading

**Issue:** Photo grading label matching and attempt recording untested.

**Priority:** High — Photo grading is a primary answer flow.

**Fix approach:** Mock Gemini responses. Test valid, rejected, and edge-case gradings. Verify attempt records are created with correct labels.

---

## Known Issues

### Malformed Answers Not Rejected Gracefully

**Issue:** `attemptService.ts` attempts to evaluate invalid LaTeX with `mathjs.evaluate()`. If `trySymbolicEval` fails, it returns false without logging the failure.

**Files:** `backend/src/services/attemptService.ts` (lines 47–94)

**Workaround:** Client-side validation in MathField should prevent most syntax errors before submission.

**Recommendation:** Add structured logging to `attemptService` to track parse failures.

### Socket.IO Event Loss on Disconnect

**Issue:** If a desktop disconnects while a grading result is being emitted, the event is lost.

**Files:** `backend/src/realtime.ts`, `backend/src/routes/pair.ts`

**Workaround:** Phone side should show "Sent to desktop" and allow manual refresh.

**Recommendation:** Emit a grading event to Supabase as a fallback if Socket.IO delivery fails.

---

## Missing Critical Features

### No Admin Question Editor

**Issue:** Questions are added only via SQL migrations. No UI to create or edit questions in production.

**Priority:** Low for MVP, Medium for production use.

### No Mistake Log / Review History UI

**Issue:** Photo gradings and chat hints are persisted (`gradings`, `chat_messages`) but no UI surfaces them for learning from past mistakes.

**Priority:** Medium.

### No Timed Mock Exams

**Issue:** No timer, no exam mode, no question shuffling.

**Priority:** Low for MVP.

---

## Database Schema Issues

### session_id Column Should Be Renamed user_id

See **Session ID / User ID Schema Mismatch** above. This is the highest-priority schema concern.

### Migrations Missing GRANT Statements

**Issue:** Several migrations lack `GRANT ALL ON TABLE ... TO anon, authenticated, service_role` after `CREATE TABLE`.

**Files:** `backend/supabase/migrations/003_topic_concepts.sql`, `008_multi_part_schema.sql`, `009_asrjc_parts_data.sql`, `010_dhs_prelim_2025.sql`, `012_fix_dhs_preamble.sql`

**Fix approach:** Add GRANT statements to every CREATE TABLE migration as standard practice. Migration 019 includes its GRANT on line 11 — use that as the template.

### No Foreign Key from session_id to users

**Issue:** `attempts.session_id`, `starred_questions.session_id`, `chat_messages.session_id`, `gradings.session_id`, `spaced_repetition_cards.session_id` have no `REFERENCES users(id)` constraint. Orphan rows accumulate silently.

**Fix approach:** As part of the `session_id → user_id` rename migration, add `REFERENCES users(id) ON DELETE CASCADE`.

### No Foreign Key Constraints on Attempts

**Issue:** `attempts.question_id` has no `ON DELETE CASCADE`. Deleting a question leaves orphan attempt rows.

**Fix approach:** Add `ON DELETE CASCADE` to the `question_id` FK in a future migration.

### No Composite Unique Constraint on Starred Questions

**Issue:** `starred_questions` table UNIQUE constraint is on `session_id` — verify it survives the session_id → user_id rename migration intact, or duplicate (user_id, question_id) pairs could accumulate.

**Files:** `backend/supabase/migrations/004_starred_questions.sql` (line 6)

---

## Dependency Issues

### Oversized mathjs Dependency

**Issue:** `mathjs` is heavy (~40KB gzipped) for just evaluating simple algebraic expressions.

**Files:** `backend/package.json`, `backend/src/services/attemptService.ts`

**Priority:** Low (mathjs is stable and correct; not a blocker).

**Alternative:** Replace with a custom evaluator for the subset of operations actually needed.

---

## Future Critical: Stripe Webhook Lacks Signature Verification

**Severity: FUTURE CRITICAL**

**Issue:** When the subscription payment flow is added, `POST /api/webhooks/stripe` will receive events from Stripe. Without verifying the `Stripe-Signature` header, any actor can send a forged `customer.subscription.created` event and upgrade themselves for free.

**Fix approach:** Use `stripe.webhooks.constructEvent(rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET)` before processing any webhook payload. Must also sync the resulting tier to both `users.subscription_tier` in Supabase AND the Firebase custom claim via the Admin SDK — otherwise the tier source-of-truth divergence described above will occur on every webhook event.

---

*Concerns audit: 2026-06-27 — updated for firebase-auth merge: added auth infrastructure risks (Firebase env vars, migration 019 manual path, tier claim source-of-truth divergence, gate() untested, CORS placeholder), session_id/user_id schema mismatch, toggleStar stale closure. Stripe webhook concern expanded to cover tier sync requirement.*
