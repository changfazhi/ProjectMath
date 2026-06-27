# Codebase Concerns

**Analysis Date:** 2026-06-26

## ~~No Authentication / Session Hijacking~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** Firebase Authentication implemented. All write endpoints are protected by `requireAuth` middleware (`backend/src/middleware/auth.ts`), which cryptographically verifies Firebase ID tokens via `getAuth(getFirebaseAdmin()).verifyIdToken()` (modern `firebase-admin/auth` named export). User identity (`req.user.uid`) is derived server-side from the verified token — never accepted from client input. `session_id` is no longer passed in request bodies or query params.

---

## No Row-Level Security on Any Table

**Severity: HIGH — Intentionally Deferred**

**Issue:** All migrations grant `ALL` to `anon`, `authenticated`, and `service_role` but zero RLS policies exist. Any caller with the Supabase URL and anon key can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row directly via the Supabase REST or realtime API, bypassing the Express backend entirely.

**Files:** `backend/supabase/migrations/001_initial_schema.sql` through `017_ri_prelim_2025.sql` (no `ENABLE ROW LEVEL SECURITY` or `CREATE POLICY` statement found in any migration)

**Impact:** Questions (including `correct_answer` and `solution_latex`) can be read directly from Supabase without going through the backend's stripping logic.

**Fix approach:** Intentionally deferred — all Supabase access goes through the Express backend using the service-role key; there is no direct browser→Supabase query path. The Express auth middleware is the enforcement layer. RLS remains a future hardening option if a direct Supabase query path is ever introduced.

---

## Tech Debt

### ~~CORS Fully Open~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** `cors()` in `backend/src/index.ts` now uses an explicit `origin` allowlist (`localhost:5173` in dev, production domain in prod). Requests from arbitrary origins are rejected.

### In-Memory Pair Sessions Without Horizontal Scaling

**Issue:** Pairing handshakes stored in a plain Map (`pairs: new Map<string, PairSession>()`) in `pairService.ts` lines 9-10. Single-instance only; restart drops in-flight pairings.
**Files:** `backend/src/services/pairService.ts`
**Impact:** Cannot scale to multiple backend instances without rewriting pair storage.
**Fix approach:** Migrate pair storage from in-memory to Supabase with a `pair_sessions` table (token, question_id, expires_at) and implement token lookup via DB. Use a separate cleanup cron job or TTL-based deletion in Supabase.

### IP-Based Rate Limiting Not Load-Balancer Aware

**Issue:** Rate limits in `chat.ts`, `grade.ts`, and `pair.ts` use `express-rate-limit` with default IP detection (from `req.ip`). Behind a load balancer or proxy, all requests appear from the same IP.
**Files:** `backend/src/routes/chat.ts` (line 9), `backend/src/routes/grade.ts` (line 24), `backend/src/routes/pair.ts` (line 25)
**Impact:** All users behind a load balancer or shared proxy hit the same rate limit bucket.
**Fix approach:** Configure `express-rate-limit` with `keyGenerator: (req, res) => req.headers['x-forwarded-for'] ?? req.ip` or use a custom header set by the load balancer.

### Large Component Files

**Issue:** `PracticePage.tsx` is 598 lines, `RoadmapGraph.tsx` is 321 lines — above recommended component size.
**Files:** `frontend/src/pages/PracticePage.tsx`, `frontend/src/components/topic/RoadmapGraph.tsx`
**Impact:** Harder to test, maintain, and reason about. RoadmapGraph has hardcoded positions (an unmaintainable approach for scaling to more topics).
**Fix approach:** Split PracticePage into smaller sub-components. Refactor RoadmapGraph to accept layout data from props instead of hardcoded POSITIONS.

### Missing Error Boundaries

**Issue:** No React error boundary components in the app. A runtime error in any component crashes the entire page.
**Files:** `frontend/src/App.tsx`, `frontend/src/pages/*.tsx`
**Impact:** Users lose all session context and must refresh.
**Fix approach:** Add a root error boundary in App.tsx that catches unhandled errors and displays a fallback UI with a "reload" button.

---

## Rate Limiting Gaps on Write Endpoints

**Severity: MEDIUM (partially mitigated)**

**Issue:** `POST /api/chat` (15/min), `POST /api/grade` (5/min), and all `/api/pair/*` routes (30/min) are rate-limited. The following write endpoints have no rate limiting: `POST /api/attempts`, `POST /api/stars`.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts` (no `rateLimit` import or middleware)

**Partial mitigation (auth):** `POST /api/attempts` and `POST /api/stars` now require a verified Firebase token (`requireAuth`). Anonymous bulk-write abuse is eliminated. Authenticated abuse (a logged-in user spamming the endpoint) is still possible.

**Remaining fix:** Add a global `rateLimit` middleware in `backend/src/index.ts` (e.g. 120 req/min per IP) as a backstop, and a per-user limiter for subscription-differentiated caps when tiers are introduced.

---

## Scaling Limits

### LaTeX Evaluation Performance Risk

**Issue:** `attemptService.ts` uses `mathjs.evaluate()` on user-supplied LaTeX expressions (lines 49, 60, 82–90). No timeout or complexity bounds.
**Files:** `backend/src/services/attemptService.ts`
**Impact:** A maliciously crafted or very complex expression could block the request thread and exhaust backend capacity.
**Fix approach:** Wrap `evaluate()` calls in a timeout (e.g., 100ms). Reject expressions exceeding a maximum length or depth.

### Image Storage In-Memory Before Upload

**Issue:** Images are held in multer memory storage, then converted to base64, sent to Gemini, and uploaded to Supabase storage. Multiple copies exist in RAM simultaneously.
**Files:** `backend/src/routes/grade.ts` (line 14), `backend/src/routes/pair.ts` (line 16)
**Impact:** With `GRADE_MAX_IMAGES=5` and `GRADE_MAX_IMAGE_MB=8`, a single request can use ~40MB RAM. Under concurrent load, this could exhaust heap memory.
**Fix approach:** Stream images directly to Supabase Storage instead of buffering in memory.

### Single-Instance In-Memory Caching

**Issue:** No distributed caching. Question data, topic trees, and attempt history are queried from Supabase on every request.
**Impact:** Supabase query quota and latency increase as user count grows.
**Fix approach:** Add Redis or Memcached for frequently accessed data (topics, questions, concepts).

---

## Performance Bottlenecks

### Sequential Queries in `getNextQuestion`

**Issue:** `questionService.ts` fetches all questions, then correct attempts separately — two queries where one could suffice.
**Files:** `backend/src/services/questionService.ts`
**Fix approach:** Use a single query with a subselect or LEFT JOIN. Add index on `(topic_id, is_correct, user_id)`.

### LaTeX Rendering Not Optimized

**Issue:** `renderLatex()` creates a React node per part. No memoization or virtualization for large content.
**Files:** `frontend/src/lib/renderLatex.tsx`
**Fix approach:** Memoize the renderLatex function. For very large content, consider pre-compiled LaTeX.

### RoadmapGraph Hardcoded Coordinates

**Issue:** Topic layout is hardcoded with pixel coordinates. Adding a new topic requires manual editing of all x/y values.
**Files:** `frontend/src/components/topic/RoadmapGraph.tsx` (lines 12–45)
**Fix approach:** Implement a graph layout algorithm (e.g., force-directed via d3-force).

---

## Security Considerations

### Token Stored in IndexedDB (XSS Risk)

**Severity: LOW**

**Issue:** Firebase stores ID tokens in browser IndexedDB. Any JavaScript running on the page — including injected XSS code — can read it. A stolen token is valid for up to 1 hour.

**Mitigating factors:** React escapes HTML by default, eliminating the most common XSS vector. The app stores no financially sensitive data.

**Fix approach:** Accepted tradeoff for current app scope. If the app expands to store sensitive personal data, revisit httpOnly cookie-based sessions.

### Unvalidated Chat and Grade Instruction Content

**Issue:** `chatService.ts` and `gradingService.ts` inject `question.solution_latex` into the system instruction verbatim.
**Files:** `backend/src/services/chatService.ts`, `backend/src/services/gradingService.ts`
**Impact:** Low risk (data is manually inserted), but violates defense-in-depth.
**Fix approach:** Sanitize LaTeX content before injecting into prompts.

### Socket.IO Events Not Typed or Validated

**Issue:** `realtime.ts` accepts arbitrary data from `socket.on('pair:subscribe')` without validation.
**Files:** `backend/src/realtime.ts`
**Fix approach:** Validate event payloads with Zod. Define explicit event schemas (token must be a base64url string).

### No CSRF Protection on State-Changing Endpoints

**Issue:** `POST /api/attempts`, `POST /api/stars`, `POST /api/grade` accept JSON but don't validate a CSRF token.
**Files:** `backend/src/routes/*.ts`
**Impact:** Low risk for a pure API with strict CORS. Document that endpoints are API-only.
**Fix approach:** Enforce same-origin CORS strictly. No action required if always served as an API.

### No Rate Limiting on Question Lookups

**Issue:** `GET /api/questions/:id` has no rate limiting. A bot could enumerate question content.
**Files:** `backend/src/routes/questions.ts`
**Fix approach:** Add rate limiting to protect against accidental abuse (e.g., infinite loops in client code).

---

## Fragile Areas

### Multi-Part Question State Machine

**Issue:** Multi-part grading depends on parts being marked graded (answer_type !== null). If a migration adds a part without setting answer_type correctly, that part becomes invisible to the progress system.
**Files:** `backend/src/services/attemptService.ts` (lines 179–180), `backend/src/services/gradingService.ts` (lines 204–206)
**Safe modification:** Always set answer_type explicitly. Add a validation query to detect parts with NULL answer_type and missing correct_answer.

### Attempt Recording in Photo Grading

**Issue:** `gradingService.ts` maps graded parts by case-insensitive label match. If a label is spelled differently in the parts array vs. returned by Gemini, that part's attempt won't be created.
**Files:** `backend/src/services/gradingService.ts`
**Safe modification:** Validate that labels returned by Gemini exactly match the question.parts labels. Return a grading error if a label is unrecognized.

### Race Condition in Solution Reveal

**Issue:** `attemptService.ts` queries attempts twice: once to submit, once to check if all parts are done. A concurrent submission could reveal the solution prematurely or not at all.
**Files:** `backend/src/services/attemptService.ts`
**Safe modification:** Use a database transaction or a separate "question_completion" table to atomically record all-parts-done status.

### Socket.IO Connection Assumes Success

**Issue:** `socket.ts` calls `io()` with no error handling. If the backend is down, the connection silently fails and no event handlers fire.
**Files:** `frontend/src/lib/socket.ts`
**Safe modification:** Add error handlers (`socket.on('connect_error', ...)`). Show "Connection lost" UI to the user.

---

## Test Coverage Gaps

### No Tests for Gemini Integration

**Issue:** `chatService.ts` and `gradingService.ts` call Gemini without unit test mocks.
**Priority:** Medium
**Fix approach:** Mock `getGemini()` in tests. Create fixture responses for valid and invalid model outputs.

### No Tests for Rate Limiting

**Issue:** No test suite validates that rate limiters correctly reject requests after the limit.
**Priority:** High — Rate limiting is a cost control.
**Fix approach:** Write integration tests that exhaust rate limits and verify 429 responses.

### No Tests for Multi-Part Question Logic

**Issue:** Multi-part state machines (attempt submission, solution reveal) have no tests.
**Priority:** High — Multi-part is used for most prelim questions.
**Fix approach:** Add tests for: (a) single-part vs. multi-part submission, (b) show-that parts (answer_type=null), (c) all-parts-done reveal logic, (d) concurrent submissions.

### No Tests for Photo Grading

**Issue:** Photo grading label matching and attempt recording untested.
**Priority:** High — Photo grading is a core feature.
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
**Workaround:** Phone-side should show "Sent to desktop" and allow manual refresh.
**Recommendation:** Emit a grading event to Supabase as a fallback if Socket.IO delivery fails.

---

## Missing Critical Features

### No Admin Question Editor

**Issue:** Questions are added only via SQL migrations. No UI to create or edit questions in production.
**Priority:** Low for MVP, Medium for production use.

### No Mistake Log / Review History

**Issue:** Photo gradings and chat hints are persisted, but no UI to browse them or learn from past mistakes.
**Priority:** Medium.

### No Timed Mock Exams

**Issue:** No timer, no exam mode, no question shuffling.
**Priority:** Low for MVP.

---

## Database Schema Issues

### Migrations Missing GRANT Statements

**Issue:** Several migrations lack `GRANT ALL ON TABLE ... TO anon, authenticated, service_role` after CREATE TABLE.
**Files:** `backend/supabase/migrations/003_topic_concepts.sql`, `008_multi_part_schema.sql`, `009_asrjc_parts_data.sql`, `010_dhs_prelim_2025.sql`, `012_fix_dhs_preamble.sql`
**Fix approach:** Add GRANT statements to every CREATE TABLE migration as standard practice.

### No Foreign Key Constraints on Attempts

**Issue:** `attempts.question_id` is nullable in some queries; no ON DELETE CASCADE.
**Fix approach:** Ensure `attempts.question_id` is NOT NULL and has ON DELETE CASCADE.

### No Composite Unique Constraint on Starred Questions

**Issue:** `starred_questions` table allows duplicate (user_id, question_id) pairs if submission is retried.
**Fix approach:** Add UNIQUE (user_id, question_id) constraint.

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

**Fix approach:** When implementing Stripe, use `stripe.webhooks.constructEvent(rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET)` before processing any webhook payload. This is a two-line fix but must not be skipped.

---

*Concerns audit: 2026-06-26 — merged: auth resolutions from firebase-auth branch + full tech debt / scaling / security audit from main branch*
