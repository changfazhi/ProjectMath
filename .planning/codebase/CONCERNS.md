# Codebase Concerns

**Analysis Date:** 2026-06-26

---

## ~~No Authentication / Session Hijacking~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** Firebase Authentication implemented. All write endpoints are protected by `requireAuth` middleware (`backend/src/middleware/auth.ts`), which cryptographically verifies Firebase ID tokens via `getFirebaseAdmin().auth().verifyIdToken()`. User identity (`req.user.uid`) is derived server-side from the verified token — never accepted from client input. `session_id` is no longer passed in request bodies or query params.

---

## No Row-Level Security on Any Table

**Severity: HIGH**

**Issue:** All migrations grant `ALL` to `anon`, `authenticated`, and `service_role` but zero RLS policies exist. Any caller with the Supabase URL and anon key — which is public and embedded in client builds — can `SELECT`, `INSERT`, `UPDATE`, or `DELETE` any row in any table directly via the Supabase REST or realtime API, bypassing the Express backend entirely.

**Files:** `backend/supabase/migrations/001_initial_schema.sql` through `017_ri_prelim_2025.sql` (no `ENABLE ROW LEVEL SECURITY` or `CREATE POLICY` statement found in any migration)

**Impact:** Questions (including `correct_answer` and `solution_latex`) can be read directly from Supabase without going through the backend's stripping logic. Attempts can be forged or deleted en masse. The entire answer/solution hiding scheme depends solely on the Express layer remaining the only access path.

**Fix approach:** Intentionally deferred — all Supabase access goes through the Express backend using the service-role key; there is no direct browser→Supabase query path. The Express auth middleware is the enforcement layer. RLS remains a future hardening option if a direct Supabase query path is ever introduced.

---

## In-Memory Pairing State Lost on Restart

**Severity: MEDIUM**

**Issue:** `services/pairService.ts` stores active phone-pairing sessions in a module-level `Map<string, PairSession>`. A process restart (crash, deploy, OOM kill) silently drops all in-flight pairings.

**Files:** `backend/src/services/pairService.ts:9`

**Impact:** Users mid-scan lose their pairing token with no error message (the QR just stops responding). This is self-correcting (they re-scan) but creates a confusing UX and is noted explicitly as a known trade-off in the code comment ("Fine for a single instance"). It also means the service cannot horizontally scale without a shared store.

**Fix approach:** For a single-instance deployment the current approach is acceptable with documented behaviour. For scale-out, move pair state to Redis or a short-TTL Supabase table.

---

## Rate Limiting Gaps on Write Endpoints

**Severity: MEDIUM (partially mitigated)**

**Issue:** `POST /api/chat` (15/min), `POST /api/grade` (5/min), and all `/api/pair/*` routes (30/min) are rate-limited. The following write endpoints have no rate limiting:

- `POST /api/attempts` — can be called arbitrarily to flood the `attempts` table
- `POST /api/stars` — can be called arbitrarily

Read endpoints (GET) are entirely unprotected, which is less critical but could enable enumeration or heavy DB load.

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/stars.ts` (no `rateLimit` import or middleware)

**Partial mitigation (auth plan):** `POST /api/attempts` and `POST /api/stars` now require a verified Firebase token (`requireAuth`). Anonymous bulk-write abuse is eliminated. Authenticated abuse (a logged-in user spamming the endpoint) is still possible.

**Remaining fix:** Add a global `rateLimit` middleware in `backend/src/index.ts` (e.g. 120 req/min per IP) as a backstop, and a per-user limiter for subscription-differentiated caps when tiers are introduced.

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

---

## ~~CORS Fully Open~~ — RESOLVED

**Severity: HIGH → RESOLVED**

**Resolution:** `cors()` in `backend/src/index.ts` now uses an explicit `origin` allowlist (`localhost:5173` in dev, production domain in prod). Requests from arbitrary origins are rejected.

---

## Token Stored in IndexedDB (XSS Risk)

**Severity: LOW**

**Issue:** Firebase stores ID tokens in browser IndexedDB. Any JavaScript running on the page — including injected XSS code — can read it. A stolen token is valid for up to 1 hour.

**Mitigating factors:** React escapes HTML by default, eliminating the most common XSS vector. The app stores no financially sensitive data. The alternative (httpOnly cookies + server-managed sessions) is significantly more complex.

**Fix approach:** Accepted tradeoff for current app scope. If the app expands to store sensitive personal data, revisit httpOnly cookie-based sessions.

---

## Stripe Webhook Lacks Signature Verification (Future Critical)

**Severity: FUTURE CRITICAL**

**Issue:** When the subscription payment flow is added, `POST /api/webhooks/stripe` will receive events from Stripe. Without verifying the `Stripe-Signature` header, any actor can send a forged `customer.subscription.created` event and upgrade themselves for free.

**Fix approach:** When implementing Stripe, use `stripe.webhooks.constructEvent(rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET)` before processing any webhook payload. This is a two-line fix but must not be skipped.

---

*Concerns audit: 2026-06-26 — updated 2026-06-26 to reflect Firebase Auth resolutions and new concerns*
