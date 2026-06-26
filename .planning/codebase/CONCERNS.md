# Codebase Concerns

**Analysis Date:** 2026-06-26

## Tech Debt

### Socket.IO CORS Configuration

**Issue:** Permissive CORS origin (`'*'`) in `realtime.ts` line 11 allows any origin to connect to the pairing socket
**Files:** `backend/src/realtime.ts`
**Impact:** In production, this could allow malicious external sites to receive/emit pairing events. An attacker could intercept or disrupt the phone-to-desktop upload flow if they can trick a user into visiting their site.
**Fix approach:** Restrict `cors.origin` to the actual frontend domain(s). In development, use the frontend dev server URL; in production, use the deployed frontend URL. Pass origin from environment config.

### In-Memory Pair Sessions Without Horizontal Scaling

**Issue:** Pairing handshakes stored in a plain Map (`pairs: new Map<string, PairSession>()`) in `pairService.ts` lines 9-10. Single-instance only; restart drops in-flight pairings.
**Files:** `backend/src/services/pairService.ts`
**Impact:** Cannot scale to multiple backend instances without rewriting pair storage. A second instance would not see tokens created on the first instance. Users scanning a QR on one machine and grading on another might connect to different instances and lose the handshake.
**Fix approach:** Migrate pair storage from in-memory to Supabase with a `pair_sessions` table (token, session_id, question_id, expires_at) and implement token lookup via DB. Use a separate cleanup cron job or TTL-based deletion in Supabase.

### IP-Based Rate Limiting Not Load-Balancer Aware

**Issue:** Rate limits in `chat.ts`, `grade.ts`, and `pair.ts` use `express-rate-limit` with default IP detection (from `req.ip`). Behind a load balancer or proxy, all requests appear from the same IP.
**Files:** `backend/src/routes/chat.ts` (line 9), `backend/src/routes/grade.ts` (line 24), `backend/src/routes/pair.ts` (line 25)
**Impact:** All users behind a load balancer or shared proxy (corporate networks) hit the same rate limit bucket. One heavy user could exhaust the limit for everyone else.
**Fix approach:** Configure `express-rate-limit` with `keyGenerator: (req, res) => req.headers['x-forwarded-for'] ?? req.ip` or use a custom header set by the load balancer. Verify trust proxy settings in Express.

### Large Component Files

**Issue:** `PracticePage.tsx` is 598 lines, `RoadmapGraph.tsx` is 321 lines — above recommended component size.
**Files:** `frontend/src/pages/PracticePage.tsx`, `frontend/src/components/topic/RoadmapGraph.tsx`
**Impact:** Harder to test, maintain, and reason about. Violates single responsibility. RoadmapGraph has hardcoded positions (an unmaintainable approach for scaling to more topics).
**Fix approach:** Split PracticePage into smaller sub-components: `<QuestionDisplay>`, `<AnswerPanel>`, `<HistoryPanel>`, `<HintsTab>`. Refactor RoadmapGraph to accept layout data from props instead of hardcoded POSITIONS.

### Missing Error Boundaries

**Issue:** No React error boundary components in the app. A runtime error in any component crashes the entire page.
**Files:** `frontend/src/App.tsx`, `frontend/src/pages/*.tsx`
**Impact:** Users lose all session context and must refresh. Questions or attempts in-flight may be lost.
**Fix approach:** Add a root error boundary in App.tsx that catches unhandled errors and displays a fallback UI with a "reload" button. Add a secondary boundary around PracticePage to isolate practice-specific crashes.

## Scaling Limits

### LaTeX Evaluation Performance Risk

**Issue:** `attemptService.ts` uses `mathjs.evaluate()` on user-supplied LaTeX expressions (lines 49, 60, 82–90). No timeout or complexity bounds.
**Files:** `backend/src/services/attemptService.ts`
**Impact:** A maliciously crafted or very complex expression (e.g., deeply nested functions) could cause the evaluation to hang indefinitely, blocking the request thread and exhausting backend capacity.
**Fix approach:** Wrap `evaluate()` calls in a timeout (e.g., 100ms). Reject expressions exceeding a maximum length or depth. Test with adversarial inputs.

### Image Storage In-Memory Before Upload

**Issue:** Images are held in multer memory storage, then converted to base64, sent to Gemini, and uploaded to Supabase storage. Multiple copies exist in RAM simultaneously.
**Files:** `backend/src/routes/grade.ts` (line 14), `backend/src/routes/pair.ts` (line 16)
**Impact:** With `GRADE_MAX_IMAGES=5` and `GRADE_MAX_IMAGE_MB=8`, a single request can use ~40MB RAM. Under concurrent load, this could exhaust heap memory (especially on memory-constrained deployments).
**Fix approach:** Stream images directly to Supabase Storage instead of buffering in memory. For Gemini, fetch from Supabase after upload rather than encoding from memory.

### Single-Instance In-Memory Caching

**Issue:** No distributed caching. Question data, topic trees, and attempt history are queried from Supabase on every request.
**Files:** `backend/src/routes/*.ts`, `backend/src/services/*.ts`
**Impact:** Supabase query quota and latency increase as user count grows. No local cache fallback if Supabase is degraded.
**Fix approach:** Add Redis or Memcached for frequently accessed data (topics, questions, concepts). Implement cache invalidation strategies.

## Performance Bottlenecks

### Sequential Queries in `getNextQuestion`

**Issue:** `questionService.ts` lines 17–35 fetch all questions, then fetch correct attempts separately. Two queries where one could suffice.
**Files:** `backend/src/services/questionService.ts`
**Impact:** High latency on topics with many questions. No compound index on (topic_id, session_id, is_correct).
**Fix approach:** Use a single query with a subselect or LEFT JOIN to fetch questions and their attempt status in one call. Add index on `(topic_id, is_correct, session_id)`.

### LaTeX Rendering Not Optimized

**Issue:** `renderLatex()` in `frontend/src/lib/renderLatex.tsx` uses a regex split and creates a React node per part. No memoization or virtualization for large content.
**Files:** `frontend/src/lib/renderLatex.tsx`
**Impact:** Rendering a question with many inline LaTeX expressions (e.g., a long proof) could cause jank.
**Fix approach:** Memoize the renderLatex function. For very large content, consider a virtualized renderer or pre-compiled LaTeX (via KaTeX's server-side or WebAssembly builds).

### RoadmapGraph Hardcoded Coordinates

**Issue:** Topic layout is hardcoded in POSITIONS object with pixel coordinates. Adding a new topic requires manual editing and testing of all x/y values.
**Files:** `frontend/src/components/topic/RoadmapGraph.tsx` (lines 12–45)
**Impact:** Not scalable. Any new topic (beyond the 24 currently listed) breaks the layout. No automatic layout algorithm.
**Fix approach:** Implement a graph layout algorithm (e.g., force-directed via d3-force) that automatically positions nodes based on the EDGES array.

## Security Considerations

### Unvalidated Chat and Grade Instruction Content

**Issue:** `chatService.ts` (line 72) and `gradingService.ts` (line 144) inject `question.solution_latex` into the system instruction verbatim. If a question contains malicious content (though unlikely given manual data entry), it could influence model behavior unpredictably.
**Files:** `backend/src/services/chatService.ts`, `backend/src/services/gradingService.ts`
**Impact:** Low risk (data is manually inserted), but violates the principle of defense-in-depth.
**Fix approach:** Sanitize LaTeX content before injecting into prompts (escape any special characters that could break the prompt format).

### Socket.IO Events Not Typed or Validated

**Issue:** `realtime.ts` (lines 16, 20) accepts arbitrary data from `socket.on('pair:subscribe')` without validation.
**Files:** `backend/src/realtime.ts`
**Impact:** A malicious client could send junk data that crashes the event handler or causes unexpected behavior.
**Fix approach:** Validate event payloads with Zod. Define explicit event schemas (token must be a string, must match the format of a base64url token).

### No CSRF Protection on State-Changing Endpoints

**Issue:** `POST /api/attempts`, `POST /api/stars`, `POST /api/grade` accept JSON but don't validate a CSRF token or same-origin referer.
**Files:** `backend/src/routes/*.ts`
**Impact:** Low risk for a pure API (browsers enforce same-origin on fetch). But if endpoints are ever exposed to a browser context without strict CORS, CSRF attacks are possible.
**Fix approach:** Document that this is an API-only service and enforce same-origin CORS strictly. No action required if always served as an API.

### No Rate Limiting on Question Lookups

**Issue:** `GET /api/questions/:id` has no rate limiting. A bot could enumerate all questions.
**Files:** `backend/src/routes/questions.ts`
**Impact:** Trivial for a motivated actor, but not a significant threat (question IDs are UUIDs, hard to guess; questions are eventually revealed anyway).
**Fix approach:** Add rate limiting to protect against accidental abuse (e.g., infinite loops in client code).

## Fragile Areas

### Multi-Part Question State Machine

**Issue:** Multi-part grading depends on parts being marked graded (answer_type !== null). If a migration adds a part without setting answer_type correctly, that part becomes invisible to the progress system.
**Files:** `backend/src/services/attemptService.ts` (lines 179–180), `backend/src/services/gradingService.ts` (lines 204–206)
**Impact:** Students could submit a multi-part question, think it's complete, but actually have an ungraded part hidden. Progress tracking would show complete when it's not.
**Safe modification:** Always set answer_type explicitly (never leave it NULL) when adding parts. Add a validation query to detect parts with NULL answer_type and missing correct_answer.

### Attempt Recording in Photo Grading

**Issue:** `gradingService.ts` (lines 189–238) maps graded parts by case-insensitive label match. If a label is spelled differently in the parts array vs. returned by Gemini, the record won't match and that part's attempt won't be created.
**Files:** `backend/src/services/gradingService.ts`
**Impact:** Photo grades could silently fail to record attempts for parts, breaking streak and progress tracking.
**Safe modification:** Add validation to ensure labels returned by Gemini exactly match (case-sensitive) the question.parts labels. Return a grading error if a label is unrecognized.

### Race Condition in Solution Reveal

**Issue:** `attemptService.ts` (lines 178–191) queries attempts twice: once to submit, once to check if all parts are done. A concurrent submission could reveal the solution prematurely or not at all.
**Files:** `backend/src/services/attemptService.ts`
**Impact:** Inconsistent reveal state. User might see solution for a part before all parts are submitted, or vice versa.
**Safe modification:** Use a database transaction or a separate "question_completion" table to atomically record all-parts-done status.

### Socket.IO Connection Assumes Success

**Issue:** `socket.ts` (line 9) calls `io()` with no error handling. If the backend is down, the connection silently fails and no event handlers fire.
**Files:** `frontend/src/lib/socket.ts`
**Impact:** Phone upload flow hangs indefinitely if Socket.IO connect fails. User sees a loading state forever.
**Safe modification:** Add error handlers (`socket.on('error', ...)`, `socket.on('connect_error', ...)`). Emit a connection status event to React so the UI can show "Connection lost" and retry.

## Test Coverage Gaps

### No Tests for Gemini Integration

**Issue:** `chatService.ts` and `gradingService.ts` call Gemini without unit test mocks. Integration tests would require API key and quota.
**Files:** `backend/src/services/chatService.ts`, `backend/src/services/gradingService.ts`, `backend/src/db/gemini.ts`
**Impact:** Difficult to test edge cases (model returns invalid JSON, rate limit exceeded, network error). A Gemini API change could break undetected.
**Priority:** Medium — Gemini integration is critical for the app.
**Fix approach:** Mock `getGemini()` in tests. Create fixture responses for valid and invalid model outputs. Test response schema validation.

### No Tests for Rate Limiting

**Issue:** No test suite validates that rate limiters correctly reject requests after the limit.
**Files:** `backend/src/routes/chat.ts`, `backend/src/routes/grade.ts`, `backend/src/routes/pair.ts`
**Impact:** A code change could silently break rate limiting, exposing the app to bill shock or DoS.
**Priority:** High — Rate limiting is a cost control.
**Fix approach:** Write integration tests that exhaust rate limits and verify 429 responses.

### No Tests for Multi-Part Question Logic

**Issue:** Multi-part state machines (attempt submission, solution reveal) have no tests.
**Files:** `backend/src/services/attemptService.ts`, `frontend/src/hooks/usePracticeSession.ts`
**Impact:** Regressions could silently break multi-part grading. The race condition mentioned above would be caught by a test.
**Priority:** High — Multi-part is used for most prelim questions.
**Fix approach:** Add tests for: (a) single-part vs. multi-part submission, (b) show-that parts (answer_type=null), (c) all-parts-done reveal logic, (d) concurrent submissions.

### No Tests for Photo Grading

**Issue:** Photo grading label matching and attempt recording untested.
**Files:** `backend/src/services/gradingService.ts`
**Impact:** Unreliable photo grading could go undetected.
**Priority:** High — Photo grading is a core feature.
**Fix approach:** Mock Gemini responses. Test valid, rejected, and edge-case gradings. Verify attempt records are created with correct labels.

## Known Issues

### Malformed Answers Not Rejected Gracefully

**Issue:** `attemptService.ts` attempts to evaluate invalid LaTeX (e.g., unclosed braces) with `mathjs.evaluate()`. If `trySymbolicEval` fails, it returns false (treating the answer as incorrect) without logging the failure.
**Files:** `backend/src/services/attemptService.ts` (lines 47–94)
**Impact:** Student's answer could be marked wrong due to LaTeX syntax error, not actual incorrectness. No visibility into why it failed.
**Workaround:** Client-side validation in MathField should prevent most syntax errors before submission.
**Recommendation:** Add structured logging to `attemptService` to track parse failures.

### Socket.IO Event Loss on Disconnect

**Issue:** If a desktop disconnects while a grading result is being emitted, the event is lost.
**Files:** `backend/src/realtime.ts` (line 29), `backend/src/routes/pair.ts` (lines 121–132)
**Impact:** User's phone completes upload and gets HTTP 202, but the result never appears on the desktop. User sees a spinner forever.
**Workaround:** Phone-side should show "Sent to desktop" and allow manual refresh. Desktop should poll for grading results on reconnect.
**Recommendation:** Emit a grading event to a persistent store (Supabase) as a fallback if Socket.IO delivery fails.

### Session IDs Are Unencrypted in localStorage

**Issue:** Session IDs stored in localStorage are UUIDs with no encryption. If a browser is compromised, an attacker gains full access to the user's session history.
**Files:** `frontend/src/lib/session.ts`
**Impact:** Low severity (no sensitive auth; only affects personal study records). But in a production educational app with real student data, this is a compliance issue.
**Workaround:** Session data is ephemeral (doesn't persist across devices). For production, add browser-level encryption or use SessionStorage instead of localStorage.

## Missing Critical Features

### No Admin Question Editor

**Issue:** Questions are added only via SQL migrations. No UI to create or edit questions in production.
**Files:** None (feature does not exist)
**Impact:** Operationally heavy to add new questions. Typos or mistakes require a migration rollback and reapply.
**Priority:** Low for MVP (manually managed), Medium for production use.

### No Mistake Log / Review History

**Issue:** Photo gradings and chat hints are persisted, but no UI to browse them or learn from past mistakes.
**Files:** `backend/src/services/gradingService.ts` (creates `gradings` table) but no query endpoint.
**Impact:** Lost learning opportunity. Students don't see a consolidated record of what they got wrong.
**Priority:** Medium.

### No Offline Mode

**Issue:** All data is server-side. No sync or offline cache.
**Files:** Entire app
**Impact:** Cannot practice without internet. Session data (progress, streak) is lost if server is down.
**Priority:** Low for MVP.

### No Timed Mock Exams

**Issue:** No timer, no exam mode, no question shuffling.
**Files:** Entire app
**Impact:** Cannot use for timed practice before exams.
**Priority:** Low for MVP.

## Database Schema Issues

### Migrations Missing GRANT Statements

**Issue:** Several migrations lack `GRANT ALL ON TABLE ... TO anon, authenticated, service_role` after CREATE TABLE.
**Files:** `backend/supabase/migrations/003_topic_concepts.sql`, `backend/supabase/migrations/008_multi_part_schema.sql`, `backend/supabase/migrations/009_asrjc_parts_data.sql`, `backend/supabase/migrations/010_dhs_prelim_2025.sql`, `backend/supabase/migrations/012_fix_dhs_preamble.sql`
**Impact:** Permissions denied errors when querying those tables. Already documented in CLAUDE.md but easy to miss.
**Fix approach:** Add GRANT statements to every CREATE TABLE migration as a standard practice.

### No Foreign Key Constraints on Attempts

**Issue:** `attempts.question_id` is nullable in some queries and no ON DELETE CASCADE for edge cases.
**Files:** `backend/supabase/migrations/001_initial_schema.sql`
**Impact:** Orphaned attempt records if a question is deleted. Hard to debug.
**Fix approach:** Ensure `attempts.question_id` is NOT NULL and has ON DELETE CASCADE. Add index on `(session_id, attempted_at)` for faster history queries.

### No Composite Unique Constraint on Starred Questions

**Issue:** `starred_questions` table allows duplicate (session_id, question_id) pairs if submission is retried.
**Files:** `backend/supabase/migrations/004_starred_questions.sql`
**Impact:** Star toggle idempotency is not guaranteed at the DB level.
**Fix approach:** Add UNIQUE (session_id, question_id) constraint.

## Dependency Issues

### Unused or Borderline Dependencies

**Issue:** `mathjs` is heavy (~40KB gzipped) for just evaluating simple expressions. Alternative: write a minimal safe evaluator.
**Files:** `backend/package.json` (line 17), `backend/src/services/attemptService.ts`
**Impact:** Unnecessary bundle size and execution overhead. mathjs is powerful but overkill for the subset of math used in answers (basic algebra, fractions).
**Priority:** Low (mathjs is stable and correct; not a blocker).
**Alternative:** Replace with a custom evaluator for the subset of operations actually needed.

---

*Concerns audit: 2026-06-26*
