# Codebase Concerns

**Analysis Date:** 2026-06-26

---

## No Authentication / Session Hijacking

**Severity: HIGH**

**Issue:** `session_id` is a client-generated UUID stored in `localStorage` with no server-side binding to a user identity. Any client that knows (or guesses) another user's UUID can submit attempts, toggle stars, read chat history, and retrieve gradings for that session.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts`, `backend/src/routes/chat.ts`, `backend/supabase/migrations/001_initial_schema.sql` (comment: "no auth required for MVP")

**Impact:** Anyone can pollute another user's attempt history, invalidate their streaks, or retrieve their graded solution images if they learn the UUID. UUIDs are not secret by design (they are 122 bits of randomness, but are transmitted in every API request and stored in the browser).

**Fix approach:** Add JWT-based or Supabase Auth sessions, binding `session_id` to an authenticated identity on the server. As a lower-effort interim, avoid accepting `session_id` from the client body; derive it from a signed cookie or bearer token instead.

---

## No Row-Level Security on Any Table

**Severity: HIGH**

**Issue:** All migrations grant `ALL` to `anon`, `authenticated`, and `service_role` but zero RLS policies exist. Any caller with the Supabase URL and anon key — which is public and embedded in client builds — can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row in any table directly via the Supabase REST or realtime API, bypassing the Express backend entirely.

**Files:** `backend/supabase/migrations/001_initial_schema.sql` through `017_ri_prelim_2025.sql` (no `ENABLE ROW LEVEL SECURITY` or `CREATE POLICY` statement found in any migration)

**Impact:** Questions (including `correct_answer` and `solution_latex`) can be read directly from Supabase without going through the backend's stripping logic. Attempts can be forged or deleted en masse. The entire answer/solution hiding scheme depends solely on the Express layer remaining the only access path.

**Fix approach:** `ALTER TABLE questions ENABLE ROW LEVEL SECURITY` and add a policy that hides `correct_answer`/`solution_latex` for `anon`. Add RLS to `attempts`, `starred_questions`, `chat_messages`, and `gradings` to restrict reads/writes to the owning session.

---

## In-Memory Pairing State Lost on Restart

**Severity: MEDIUM**

**Issue:** `services/pairService.ts` stores active phone-pairing sessions in a module-level `Map<string, PairSession>`. A process restart (crash, deploy, OOM kill) silently drops all in-flight pairings.

**Files:** `backend/src/services/pairService.ts:9`

**Impact:** Users mid-scan lose their pairing token with no error message (the QR just stops responding). This is self-correcting (they re-scan) but creates a confusing UX and is noted explicitly as a known trade-off in the code comment ("Fine for a single instance"). It also means the service cannot horizontally scale without a shared store.

**Fix approach:** For a single-instance deployment the current approach is acceptable with documented behaviour. For scale-out, move pair state to Redis or a short-TTL Supabase table.

---

## Rate Limiting Gaps on Write Endpoints

**Severity: MEDIUM**

**Issue:** `POST /api/chat` (15/min), `POST /api/grade` (5/min), and all `/api/pair/*` routes (30/min) are rate-limited. The following write endpoints have no rate limiting:

- `POST /api/attempts` — can be called arbitrarily to flood the `attempts` table
- `POST /api/stars` — can be called arbitrarily

Read endpoints (GET) are entirely unprotected, which is less critical but could enable enumeration or heavy DB load.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts` (no `rateLimit` import or middleware)

**Impact:** A malicious client can write millions of attempt rows, degrading DB performance or inflating reported streak/progress counts. No Gemini cost risk here, but DB storage and query cost grows unbounded.

**Fix approach:** Add a global `rateLimit` middleware in `backend/src/index.ts` (e.g. 120 req/min per IP) as a backstop, and apply a tighter limiter to `POST /api/attempts` (e.g. 60/min).

---

## Gemini API Key Confirmed Backend-Only

**Severity: LOW (no action required)**

A full grep of `frontend/src` for "gemini", "GEMINI", "api_key", and "apiKey" returned zero matches. The key is consumed only in `backend/src/db/gemini.ts` via `process.env.GEMINI_API_KEY`. The frontend communicates exclusively via `/api/chat` and `/api/grade` proxied through Express. No leak risk detected.

---

## Unhandled Promise Rejection: POST /api/pair/:token/done

**Severity: MEDIUM**

**Issue:** The `/:token/done` route responds `202` immediately, then calls `gradeSolution()` asynchronously with no surrounding `try/catch` wrapping the `emitToPair` call after `res` has already been sent. If `emitToPair` throws (e.g. socket layer failure), the error is unhandled at the process level. The existing `try/catch` inside the handler only guards the grading call itself.

**Files:** `backend/src/routes/pair.ts:107-136`

**Impact:** An uncaught rejection in a socket emit would crash the Node process in older Node versions (now a warning in Node 18+), or silently swallow the error, leaving the desktop in a "grading…" spinner indefinitely.

**Fix approach:** Wrap the entire post-`res` async block in a top-level `try/catch` that also handles `emitToPair` failures and emits a `pair:error` event as a fallback.

---

## Solution Reveal Logic: Race Condition on Multi-Part Submission

**Severity: MEDIUM**

**Issue:** In `attemptService.ts`, after inserting the new attempt, the code queries existing attempts to decide if all graded parts are done. This read-after-write is not atomic. Two concurrent submissions for the last two parts of the same question could both observe the other's part as "not yet submitted" and both withhold `solution_latex`, or conversely both include it (double-reveal).

**Files:** `backend/src/services/attemptService.ts:179-191`

**Impact:** Students may not see the solution after completing all parts if concurrent submissions race. Low probability in practice (single user, sequential UI), but present in the logic.

**Fix approach:** Use a database-level aggregate or a `SELECT FOR UPDATE` pattern rather than a separate read after insert.

---

## Raw Error Messages Surfaced to Clients

**Severity: MEDIUM**

**Issue:** Several routes return `(err as Error).message` directly in 500 responses. Supabase error messages can contain table names, column names, constraint names, and SQL fragments — exposing schema details to clients.

**Files:** `backend/src/routes/attempts.ts:31`, `backend/src/routes/stars.ts:25`, `backend/src/routes/chat.ts:53`, `backend/src/routes/grade.ts:84`, `backend/src/routes/pair.ts:50,74`

**Fix approach:** Introduce a central error handler in `backend/src/index.ts` that logs the full error server-side and returns a generic `{ error: "Internal server error" }` for unclassified 500s.

---

## `GET /api/chat` Not Rate-Limited

**Severity: LOW**

**Issue:** `GET /api/chat` rehydrates full chat history for any `session_id` + `question_id` pair without any rate limiting. Only `POST /api/chat` carries the `chatLimiter`.

**Files:** `backend/src/routes/chat.ts:24-37`

**Impact:** Low direct cost (no Gemini call), but enables unbounded DB reads and could be used for enumeration of chat sessions if `session_id` values are known or guessable.

---

## Missing Cleanup of Old Pair Images in Memory

**Severity: LOW**

**Issue:** `pairService.ts` sweeps expired `PairSession` entries every 60 seconds. However, image buffers (`GradeImage[]` containing raw `Buffer` objects) are held in the pair session until `closePair()` is called. If a session expires before `/:token/done` is called, the sweep deletes the `PairSession` but the garbage collector must reclaim the image buffers. With many concurrent uploads of large images (up to 8 MB × 5 = 40 MB per session), memory pressure could spike.

**Files:** `backend/src/services/pairService.ts:67-72`

**Fix approach:** Acceptable for current single-user scale; monitor Node.js heap if usage grows.

---

## No TODO/FIXME Comments in Backend Source

**Severity: LOW (informational)**

A grep across `backend/src` found no `TODO`, `FIXME`, or `HACK` comments and no stray `console.log` calls beyond the startup message in `index.ts:51`. The frontend similarly has no debug logging or hardcoded API keys. Code hygiene is good.

---

*Concerns audit: 2026-06-26*
