# Codebase Concerns

**Analysis Date:** 2026-06-26

---

## No Authentication / Session Hijacking

**Severity: HIGH**

**Issue:** `session_id` is a client-generated UUID stored in `localStorage` with no server-side binding to a user identity. Any client that knows (or guesses) another user's UUID can submit attempts, toggle stars, read chat history, and retrieve gradings for that session.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts`, `backend/src/routes/chat.ts`

**Impact:** Anyone can pollute another user's attempt history, invalidate streaks, or retrieve graded solution images if they learn the UUID. UUIDs are not secret by design (they are 122 bits of randomness but are transmitted in every API request and stored in the browser).

**Fix approach:** Add JWT-based or Supabase Auth sessions, binding `session_id` to an authenticated identity on the server. As a lower-effort interim, avoid accepting `session_id` from the client body; derive it from a signed cookie or bearer token instead.

---

## No Row-Level Security on Any Table

**Severity: HIGH**

**Issue:** All migrations grant `ALL` to `anon`, `authenticated`, and `service_role` but zero RLS policies exist. Any caller with the Supabase URL and anon key — which is public and embedded in client builds — can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row in any table directly via the Supabase REST or realtime API, bypassing the Express backend entirely.

**Files:** `backend/supabase/migrations/001_initial_schema.sql` through the latest migration (no `ENABLE ROW LEVEL SECURITY` or `CREATE POLICY` statement found in any migration).

**Impact:** Questions including `correct_answer` and `solution_latex` can be read directly from Supabase without going through the backend's stripping logic. The entire answer/solution hiding scheme depends solely on the Express layer remaining the only access path.

**Fix approach:** `ALTER TABLE questions ENABLE ROW LEVEL SECURITY` and add a policy that hides `correct_answer`/`solution_latex` for `anon`. Apply RLS to `attempts`, `starred_questions`, `chat_messages`, and `gradings` to restrict reads/writes to the owning session.

---

## Wildcard CORS on Express and Socket.IO

**Severity: HIGH**

**Issue:** `app.use(cors())` in `backend/src/index.ts:20` uses the default configuration, which allows requests from any origin. Socket.IO is also initialised with `cors: { origin: '*' }` in `backend/src/realtime.ts:11`.

**Files:** `backend/src/index.ts:20`, `backend/src/realtime.ts:11`

**Impact:** Any website can make credentialed cross-origin requests to the API. Combined with the no-auth session model, this means any third-party page can call `/api/attempts` or `/api/grade` on behalf of a visiting user using their stored `session_id`.

**Fix approach:** Restrict CORS to known origins (e.g. `http://localhost:5173` in development, and the deployed frontend URL in production) via the `origin` option:
```ts
app.use(cors({ origin: process.env.CORS_ORIGIN ?? 'http://localhost:5173' }));
```

---

## Rate Limiting Gaps on Write Endpoints

**Severity: MEDIUM**

**Issue:** `POST /api/chat` (15/min), `POST /api/grade` (5/min), and `/api/pair/*` routes (30/min) are rate-limited. The following write endpoints have no rate limiting:

- `POST /api/attempts` — can be called arbitrarily to flood the `attempts` table
- `POST /api/stars` — can be called arbitrarily

Read endpoints (GET) are entirely unprotected, enabling enumeration or heavy DB load.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts` (no `rateLimit` import or middleware)

**Impact:** A malicious client can write millions of attempt rows, degrading DB performance or inflating reported streak/progress counts. No Gemini cost risk here, but DB storage and query cost grows unbounded.

**Fix approach:** Add a global `rateLimit` middleware in `backend/src/index.ts` (e.g. 120 req/min per IP) as a backstop, and apply a tighter limiter to `POST /api/attempts` (e.g. 60/min).

---

## Raw Error Messages Surfaced to Clients

**Severity: MEDIUM**

**Issue:** Several routes return `(err as Error).message` directly in 500 responses. Supabase error messages can contain table names, column names, constraint names, and SQL fragments — exposing schema details to clients.

**Files:** `backend/src/routes/attempts.ts:31`, `backend/src/routes/stars.ts:25`, `backend/src/routes/chat.ts:53`, `backend/src/routes/grade.ts:84`, `backend/src/routes/pair.ts:50,74`

**Fix approach:** Introduce a central error handler in `backend/src/index.ts` that logs the full error server-side and returns a generic `{ error: "Internal server error" }` for unclassified 500s. Domain-specific error classes (`PairError`, `ChatLimitError`, `GradingError`) already propagate cleanly — the pattern just needs extending to the catch-all path.

---

## Unhandled Promise Rejection: POST /api/pair/:token/done

**Severity: MEDIUM**

**Issue:** The `/:token/done` route responds `202` immediately, then calls `gradeSolution()` asynchronously with no surrounding `try/catch` wrapping the `emitToPair` call after `res` has already been sent. If `emitToPair` throws (e.g. socket layer failure), the error is unhandled at the process level.

**Files:** `backend/src/routes/pair.ts:107-136`

**Impact:** An uncaught rejection in a socket emit would crash the Node process in older Node versions (now a warning in Node 18+), or silently swallow the error, leaving the desktop in a "grading…" spinner indefinitely.

**Fix approach:** Wrap the entire post-`res` async block in a top-level `try/catch` that handles `emitToPair` failures and emits a `pair:error` event as a fallback.

---

## Solution Reveal Race Condition on Multi-Part Submission

**Severity: MEDIUM**

**Issue:** In `attemptService.ts`, after inserting the new attempt, the code queries existing attempts to decide if all graded parts are done. This read-after-write is not atomic. Two concurrent submissions for the last two parts of the same question could both observe the other's part as "not yet submitted" and withhold `solution_latex`, or both include it.

**Files:** `backend/src/services/attemptService.ts:179-191`

**Impact:** Students may not see the solution after completing all parts if concurrent submissions race. Low probability in practice (single user, sequential UI), but present in the logic.

**Fix approach:** Use a database-level aggregate or a `SELECT FOR UPDATE` pattern rather than a separate read after insert.

---

## In-Memory Pairing State Lost on Restart

**Severity: MEDIUM**

**Issue:** `services/pairService.ts` stores active phone-pairing sessions in a module-level `Map<string, PairSession>`. A process restart silently drops all in-flight pairings. The service cannot horizontally scale without a shared store.

**Files:** `backend/src/services/pairService.ts:9`

**Impact:** Users mid-scan lose their pairing token with no error message (the QR just stops responding). Self-correcting (they re-scan) but confusing. Noted explicitly in the code comment: "Fine for a single instance."

**Fix approach:** Acceptable for single-instance deployment. For scale-out, move pair state to Redis or a short-TTL Supabase table.

---

## No Tests

**Severity: MEDIUM**

**Issue:** No test files exist anywhere in the project. No `jest.config.*`, `vitest.config.*`, or `*.test.*` / `*.spec.*` files were found in `backend/` or `frontend/`.

**Impact:** All validation of the attempt scoring logic (`normalizeLaTeX`, `answer_type` dispatch), multi-part solution-reveal gating, and Gemini prompt building relies entirely on manual testing. Regressions in these paths are invisible until a student reports a wrong grade.

**Priority areas to test first:**
- `backend/src/services/attemptService.ts` — `normalizeLaTeX`, `exact`/`range` grading, multi-part reveal gating
- `backend/src/services/gradingService.ts` — structured output parsing, `gradable=false` handling
- `backend/src/routes/attempts.ts` — Zod validation, 400 vs 500 distinction

---

## `GET /api/chat` Not Rate-Limited

**Severity: LOW**

**Issue:** `GET /api/chat` rehydrates full chat history for any `session_id` + `question_id` pair without rate limiting. Only `POST /api/chat` carries the `chatLimiter`.

**Files:** `backend/src/routes/chat.ts:24-37`

**Impact:** Low direct cost (no Gemini call), but enables unbounded DB reads and enumeration of chat sessions.

---

## Memory Pressure: Pair Image Buffers

**Severity: LOW**

**Issue:** Image buffers (`GradeImage[]` containing raw `Buffer` objects) are held in the pair session until `closePair()` is called. With up to 5 images × 8 MB each, a single session can hold 40 MB in process memory. Multiple concurrent sessions before the 60-second sweep could create meaningful heap pressure.

**Files:** `backend/src/services/pairService.ts:67-72`

**Fix approach:** Acceptable for current single-user scale. Monitor Node.js heap if concurrent usage grows.

---

## Untracked 2025 Prelim SQL Files

**Severity: LOW (informational)**

**Issue:** A `2025/` directory exists in the project root containing subdirectories for school-specific prelim questions (ACJC, ASRJC, CJC, DHS, EJC at minimum). These files are untracked by git (shown as `?? 2025/` in `git status`) but appear to be source material for future SQL migrations.

**Impact:** Working SQL or PDF source material not committed to the repo risks being lost on a disk failure, and the migration history becomes incomplete.

**Fix approach:** Either commit the `2025/` source files or add them to `.gitignore` explicitly so the decision is documented.

---

## Missing Features (Not Built)

**Severity: LOW (informational)**

The following features are documented as intentionally not built. They are captured here so they surface during planning:

- **Auth system** — no user accounts; session UUID in `localStorage` is the only identity mechanism
- **Timed mock mode** — no exam simulation capability
- **Admin question editor** — questions must be added via raw SQL migrations in Supabase
- **Mistake log page** — grading data already captured in `gradings` table (`WHERE is_correct=false`), UI not built

---

## Gemini API Key: No Leak Risk Detected

**Severity: INFORMATIONAL**

A grep of `frontend/src` for "gemini", "GEMINI", "api_key", and "apiKey" returned zero matches. The key is consumed only in `backend/src/db/gemini.ts` via `process.env.GEMINI_API_KEY`. The frontend communicates exclusively via `/api/chat` and `/api/grade` proxied through Express.

---

*Concerns audit: 2026-06-26*
