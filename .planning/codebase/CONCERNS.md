# Codebase Concerns

**Analysis Date:** 2026-07-04

## Tech Debt

**Zero Test Coverage**
- Issue: No unit, integration, or e2e tests in the codebase. Only dev dependencies like TypeScript and linting exist.
- Files: `backend/package.json`, `frontend/package.json` (no test scripts)
- Impact: Critical services (billing, AI grading, auth) have no verification. Regressions silent. Stripe webhook bugs undetected. Grading logic changes risk breaking the core feature.
- Fix approach: Add Jest/Vitest to backend, set up at least 70% coverage on `services/` and `routes/`. Add React Testing Library for frontend components (PracticePage, MultiPartQuestion, PhotoAnswer). Create webhook mock tests for billing events.

**Large Complex Service Files**
- Issue: `gradingService.ts` (443 lines) couples image upload, Gemini grading, relevance filtering, marks normalization, and attempt recording in one file.
- Files: `backend/src/services/gradingService.ts`, `backend/src/services/billingService.ts`, `frontend/src/hooks/usePracticeSession.ts`
- Impact: Hard to test, hard to reuse, high risk of bugs when changing grading rules or part scoring logic. State machine in hook is fragile.
- Fix approach: Split `gradingService.ts` into `imagingService.ts` (upload), `gradingService.ts` (Gemini call), `markingService.ts` (marks/correctness). Extract practice session reducer to `usePracticeSessionReducer.ts`. Add unit tests per module.

**Complex State Management in Frontend Hook**
- Issue: `usePracticeSession.ts` (349 lines) manages loading, answering, submitting, grading, external socket grading, and part states in one reducer with 11 action types.
- Files: `frontend/src/hooks/usePracticeSession.ts`
- Impact: Difficult to debug; state transitions not obvious; adding a new feature (e.g., timed mode) requires coordinating multiple state branches.
- Fix approach: Break into separate hooks: `useQuestionLoader` (load/loadNext/loadSpecific), `useAnswerSubmission` (single-part flow), `usePart SubmissionFlow` (multi-part flow), `usePhotoGrading` (photos). Keep reducer simple. Add tests for each transition.

## Known Bugs

**PayNow Expiry Relies on Client-Side Auth Check**
- Symptoms: User's PayNow tier expires at `access_expires_at`, but the expiry is only enforced in `requireAuth()` middleware when they next make a request. If they keep the tab open, they keep access until logout.
- Files: `backend/src/middleware/auth.ts` (lines 44–54)
- Trigger: User's PayNow expires, they immediately refresh the page or make a request → downgrade fires. But if they don't refresh, they keep access in that session.
- Workaround: Refresh the page or log out and back in after expiry date.

**Silent Failure on Firebase Custom Claims Update**
- Symptoms: In `auth.ts` (lines 46–48), if setting custom claims fails (e.g., Firebase quota), the error is silently swallowed. Tier downgrade never happens; user stays "paid" in the frontend.
- Files: `backend/src/middleware/auth.ts`
- Trigger: Firebase Admin SDK call fails for any reason (quota, network, permissions). No retry, no alert.
- Workaround: Manually revoke via Stripe Dashboard and clear the `stripe_customer_id` field.

**Grading Attempt Recorded Even If Image Upload Fails**
- Symptoms: In `gradingService.ts`, if Gemini grades successfully but then Supabase image upload or storage fails, the grading row doesn't persist but attempts are already recorded, causing inconsistency.
- Files: `backend/src/services/gradingService.ts` (lines 350–370)
- Trigger: Grading succeeds, but network/storage bucket permission error on upload.
- Workaround: None. Data is now inconsistent. Manual DB cleanup needed.

**Socket.IO Pairing Lost on Backend Restart**
- Symptoms: Desktop and phone are mid-upload, backend restarts (deploy, crash). The pair session is lost (in-memory Map). Phone's `/api/pair/:token/done` returns 404 instead of grading.
- Files: `backend/src/services/pairService.ts` (line 9)
- Trigger: Any backend restart during an active pairing.
- Workaround: User re-scans QR to start a fresh pairing.

## Security Considerations

**Socket.IO CORS Set to Wildcard**
- Risk: `realtime.ts` (line 11) sets `cors: { origin: '*' }`, allowing any origin to connect and emit/listen to pairing events. A malicious site could sniff pairing tokens from a student's phone if they log the Socket.IO traffic.
- Files: `backend/src/realtime.ts`
- Current mitigation: Pairing tokens are cryptographically random (256 bits). Access is token-only, not session-based. Short TTL (default 10 min).
- Recommendations: Restrict CORS to `FRONTEND_URL` in production. Keep token entropy high. Add rate limiting on Socket.IO events. Log suspicious activity (multiple tokens from same IP in short time).

**Gemini API Key Required in Environment, No Secrets Rotation**
- Risk: `GEMINI_API_KEY` stored in `.env`. If `.env` is leaked (e.g., committed, exposed in logs), attacker can call Gemini API on your bill.
- Files: `backend/src/db/gemini.ts`, `backend/.env` (not versioned but risk in CI/CD)
- Current mitigation: Key is backend-only; never sent to frontend. Rate limiting on `/api/chat` and `/api/grade`.
- Recommendations: Use Google Cloud Secret Manager or HashiCorp Vault. Rotate key quarterly. Monitor Gemini API usage for anomalies. Set per-project quota limits.

**Firebase Private Key Escaped in Environment**
- Risk: `FIREBASE_PRIVATE_KEY` must be manually escaped (`\\n` → newline) in `.env`. If set incorrectly, Firebase init fails; if committed with actual key, it's exposed.
- Files: `backend/src/db/firebase.ts` (line 16), `.env`
- Current mitigation: `.env` is `.gitignored`. CI/CD typically passes as environment variable (safer).
- Recommendations: Use JSON file upload or environment variable that accepts literal newlines (e.g., base64-encoded). Document the escaping requirement clearly. Validate on boot that Firebase initialized correctly.

**Stripe Webhook Secret Not Validated on Missing Secret**
- Risk: In `routes/billing.ts` (line 88) and `billingService.ts` (line 162), if `STRIPE_WEBHOOK_SECRET` is missing, it throws an error that might leak to client. If webhook is unauthenticated, attacker can grant themselves paid tier.
- Files: `backend/src/routes/billing.ts`, `backend/src/services/billingService.ts`
- Current mitigation: Signature verification via `stripe.webhooks.constructEvent()` throws on invalid signature. Missing secret throws generic error (500).
- Recommendations: Validate `STRIPE_WEBHOOK_SECRET` exists on boot, not on first webhook. Return 401 (not 500) if secret is missing. Log webhook verification failures without exposing details.

**LaTeX Stored Without Sanitization**
- Risk: User-submitted `answer_given` (LaTeX) is stored as-is in `attempts` and `gradings` tables. If displayed in admin panel or exported without proper escaping, could execute arbitrary LaTeX or JavaScript if rendered unsanitized.
- Files: `backend/src/services/gradingService.ts` (line 370), `backend/src/services/attemptService.ts`
- Current mitigation: Frontend uses `<Latex>` component which sanitizes via KaTeX; doesn't allow arbitrary HTML.
- Recommendations: Validate LaTeX input (e.g., blacklist `\immediate\write`, `\input`, other I/O macros). Document safe rendering. Add a Content Security Policy header.

## Performance Bottlenecks

**Gemini API Calls Unoptimized**
- Problem: Every `POST /api/chat` and `POST /api/grade` calls Gemini with full question + reference solution every time. No caching. If student asks same hint 5 times, API is called 5 times (bill = 5×).
- Files: `backend/src/services/chatService.ts` (lines 97–101), `backend/src/services/gradingService.ts` (lines 310–318)
- Cause: Stateless design; each call is independent. System instruction built fresh every time.
- Improvement path: Cache system instruction (it doesn't change per question). For chat, reuse the same conversation so Gemini uses context from earlier messages (costs less). For grading, batch multiple images in one call if possible.

**No Rate Limiting on Read Endpoints**
- Problem: GET `/api/topics`, `/api/questions`, `/api/topics/:id/questions` have no rate limiting. A bot could crawl the entire question bank in seconds or perform DOS.
- Files: `backend/src/routes/topics.ts`, `backend/src/routes/questions.ts`
- Cause: Rate limiting only on write and expensive operations (chat, grade, pair). Data endpoints assumed low-risk.
- Improvement path: Add IP-based rate limit (e.g., 100 req/min) to all public GET endpoints. Or cache responses and set aggressive ETag/304 responses.

**In-Memory Pair Sessions Unbounded Growth**
- Problem: `pairService.ts` uses an in-memory Map. Expired pairs are cleaned every 60 seconds, but if many pairs are created and each lasts 10 min, the Map could have thousands of entries.
- Files: `backend/src/services/pairService.ts` (lines 9, 67–71)
- Cause: Cleanup interval (60s) doesn't guarantee immediate removal; relies on passive sweep.
- Improvement path: Use Redis for pairing instead of in-memory Map. Or add an explicit cleanup call after each pair closes. Monitor Map size in production.

**Full Grading Feedback Sent Over Socket.IO for Phone Uploads**
- Problem: The entire grading feedback (marks, errors, hints, transcription) is base64 images are streamed as `dataUrl` (line 91 in `pair.ts`). Large images + detailed feedback = large Socket.IO messages. Could cause lag on slow connections.
- Files: `backend/src/routes/pair.ts` (line 91)
- Cause: No message compression. All data sent in one emit.
- Improvement path: Compress feedback JSON. Send image paths separately; let phone re-fetch. Paginate if feedback exceeds 1MB.

## Fragile Areas

**Grading Rules in Prompt Injection Risk**
- Files: `backend/src/services/gradingService.ts` (lines 85–182)
- Why fragile: The Gemini system instruction is a long prose document with specific rules. Slight phrasing changes can affect output. Rules are not validated against Gemini's actual behavior — if Gemini ignores a rule (e.g., "don't give the final answer"), there's no fallback.
- Safe modification: Test grading output before deploying prompt changes. Add safeguards: check that the final answer is not in the hints. Flag suspicious outputs (e.g., solution contains "hint", verdict is not one of 3 expected values). Consider a second-pass review step if grading verdict is surprising.

**Multi-Part Question Part-Label Matching**
- Files: `backend/src/services/gradingService.ts` (line 255), `backend/src/services/attemptService.ts`
- Why fragile: Part labels are matched case-insensitively by string comparison. If a question has parts labeled "a", "A", "i", "I", a mismatch in the DB or frontend could map answers to wrong parts. Gemini might also invent labels if confused.
- Safe modification: Validate question before insertion: parts must have unique labels (case-insensitive). In grading, check every label returned by Gemini matches a part in the question; reject if not. Add a test for questions with edge-case labels (e.g., "i", "ii", "I", "II").

**Firebase Custom Claims Desync from Supabase**
- Files: `backend/src/middleware/auth.ts` (lines 46–54), `backend/src/services/billingService.ts` (lines 126–148)
- Why fragile: Tier lives in two places: Firebase custom claims (`tier: 'paid'`) and Supabase (`subscription_status`). If one update fails but the other succeeds, they're out of sync. The frontend trusts Firebase claims; if they're stale, the UI won't match the backend.
- Safe modification: Make Supabase the source of truth. Fetch tier from Supabase in `requireAuth()` instead of trusting Firebase claims. Or add a background job that periodically syncs Firebase → Supabase for consistency checks.

**Answer Type Null Workaround for Ungraded Questions**
- Files: `backend/src/types/index.ts`, documentation in CLAUDE.md
- Why fragile: For an ungraded single-part question (e.g., "show that"), the answer_type must NOT be null on the question row (DB constraint), but the part's answer_type can be null. This is a confusing workaround documented in comments. New developers might not understand it and create invalid schema.
- Safe modification: Add a database constraint or migration that validates: if all parts have `answer_type = null`, the question must have a default `answer_type` (e.g., 'exact', ''). Or allow `answer_type NULL` on questions and handle it in the app. Document this schema rule clearly in `skills.md`.

## Scaling Limits

**Gemini API Quota**
- Current capacity: Default API quotas apply (typically 1500 req/min for free tier, higher for billed projects). Rate limiting in code is 15 req/min for chat, 5 req/min for grading.
- Limit: If 100 students all submit photos at once, grading queue backs up. Gemini quota could be hit. No async queue — all requests are synchronous, so students wait for grading (user experience degrades).
- Scaling path: Add a job queue (Redis + Bull or AWS SQS). Grade async; socket.io notify when done. Scale to multiple Gemini projects or use batch API. Monitor quota usage and auto-scale rate limits.

**Supabase Concurrent Connections**
- Current capacity: Depends on Supabase tier. Free tier: 3 connections, ~50 req/s sustained.
- Limit: At 100 active students, connection pool could exhaust. Multi-part grading makes multiple DB calls (insert gradings, insert attempts, update users). No connection pooling configured in the app.
- Scaling path: Add PgBouncer or Supabase connection pooling. Batch DB inserts. Consider moving to self-hosted PostgreSQL with proper pooling.

**Socket.IO Memory Per Connection**
- Current capacity: In-memory Map holds pair sessions; each can have up to 5 images (default). Each image in memory ≈ 8MB (GRADE_MAX_IMAGE_MB).
- Limit: 100 concurrent pairs = 500 images = 4GB memory. Backend crashes if out of memory.
- Scaling path: Use Redis as Socket.IO adapter + session store. Stream images to disk/S3 instead of holding in memory.

**Stripe API Rate Limits**
- Current capacity: Stripe allows 100 req/s per API key.
- Limit: If 50 users checkout simultaneously, webhook processing + customer lookups could hit limits.
- Scaling path: Implement exponential backoff for Stripe API calls. Queue webhooks; process async. Cache customer ID lookups.

## Dependencies at Risk

**Stripe Integration Recent, Not Battle-Tested**
- Risk: Billing was recently added (commit `bde11ff` on current branch). Webhook handlers, tier updates, and Stripe customer sync are untested (no tests exist). If a webhook type is missed (e.g., `payment_intent.succeeded` for non-subscription payments), refunds won't propagate.
- Impact: Users charged but not granted access. Payment disputes. Revenue leaks.
- Migration plan: Write integration tests that mock Stripe webhooks and verify Firebase + Supabase state updates. Add monitoring for webhook latency. Test refund and subscription cancellation end-to-end before going live.

**Gemini Model Version Pinned to Dahlia (API version 2026-06-24)**
- Risk: In `stripe.ts` (line 9), Stripe API version is hardcoded to `2026-06-24.dahlia`. If this version is deprecated, client code breaks. Similar risk for `GEMINI_MODEL` default (line 4 in `gemini.ts`).
- Impact: API calls fail with version-not-found errors. Requires code change + deploy to fix.
- Migration plan: Document Stripe/Gemini version pins. Monitor deprecation timelines. Set up a quarterly review to check if new versions offer improvements (e.g., cheaper grading).

**Socket.IO Major Version Jump Risk**
- Risk: `socket.io` (4.8.3) and `socket.io-client` (4.8.3) are in sync, but if either is upgraded, Socket.IO protocol changes could break pairing.
- Impact: Phones can't upload to desktops after deploy.
- Migration plan: Keep socket.io versions in sync. Test protocol compatibility when upgrading. Use SemVer strictly; don't auto-upgrade major versions.

**MathLive Keyboard Integration Fragile**
- Risk: `MathField.tsx` wraps `<math-field>` Web Component. If MathLive API changes (e.g., `insert()` method signature), input breaks. Custom keyboard suppression (`suppressed-menu`, keyboard off) might not work in newer versions.
- Impact: Math input stops working.
- Migration plan: Pin `mathlive` version. Test math input thoroughly on each frontend build. Consider a fallback text input for LaTeX.

## Test Coverage Gaps

**Untested Critical Flows:**

**Billing Webhook Processing**
- What's not tested: Stripe webhook reception, signature verification, event routing, Firebase + Supabase state updates, error recovery.
- Files: `backend/src/routes/billing.ts`, `backend/src/services/billingService.ts`
- Risk: Silent failures in webhook handling. Customer subscription canceled in Stripe but tier not revoked in app. User keeps paid access. Or opposite: tier revoked but not in Stripe.
- Priority: **High**

**AI Grading with Gemini**
- What's not tested: Photo upload, Gemini call with various image qualities, junk filtering (ignored_images), part label matching, marks normalization, attempt recording, image storage upload failure recovery.
- Files: `backend/src/services/gradingService.ts`, `backend/src/routes/grade.ts`
- Risk: Grading logic bugs undetected (e.g., incorrect marks awarded, parts marked incorrectly). Image storage fails but attempts recorded. Gemini hallucinations.
- Priority: **High**

**Multi-Part Question Submission**
- What's not tested: Multi-part flow (submitting each part separately), revelation only after all graded parts done, field answers (multi-box parts), interaction with photo grading.
- Files: `frontend/src/hooks/usePracticeSession.ts`, `backend/src/services/attemptService.ts`
- Risk: Off-by-one errors in part submission logic. Solution reveals too early or too late. Field answers don't grade correctly.
- Priority: **High**

**Phone Upload Pairing Socket.IO Flow**
- What's not tested: Desktop subscribes to token, phone connects, sends photos, desktop receives images in real-time, grading completes, desktop receives grading result, pair expires.
- Files: `backend/src/realtime.ts`, `backend/src/routes/pair.ts`, `frontend/src/hooks/usePairSocket.ts`
- Risk: Socket.IO events lost, images not streamed, grading doesn't propagate back. Desktop/phone out of sync.
- Priority: **High**

**Auth Middleware Tier Enforcement**
- What's not tested: Free user accessing paid feature (should 402), PayNow expiry (should downgrade), Firebase token invalid (should 401), concurrent tier updates.
- Files: `backend/src/middleware/auth.ts`, `backend/src/config/featureTiers.ts`
- Risk: Access control bypassed. Free users access paid features. PayNow users don't get downgraded.
- Priority: **High**

**Frontend API Error Handling**
- What's not tested: Network errors, 401/402/5xx responses, missing fields in API responses, type mismatches.
- Files: `frontend/src/lib/api.ts`
- Risk: App crashes if API returns unexpected shape. User sees white screen instead of error message.
- Priority: **Medium**

---

*Concerns audit: 2026-07-04*
