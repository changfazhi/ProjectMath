# Math Trainer — Project Guide

LeetCode-style math practice for Singapore H2 A-Level students. Express + TypeScript backend, React 19 + Vite + Tailwind + KaTeX frontend.

## Running

```bash
cd backend && npm run dev      # port 3001, tsx watch
cd frontend && npm run dev     # port 5173, Vite — proxies /api/* → 3001
```

`backend/.env` (copy from `.env.example`): set `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`. Auth requires `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` (service account — see [Authentication & Tiers](#authentication--tiers)). For the AI hint chatbot + photo grading also set `GEMINI_API_KEY` (optionally `GEMINI_MODEL`, `CHAT_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION`, `GRADE_RATE_LIMIT_PER_MIN`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB`, `PAIR_TTL_MIN`, `PAIR_RATE_LIMIT_PER_MIN`, `AI_*` gateway pacing vars). Optionally `TRUST_PROXY_HOPS` (default `1`; see [Authentication & Tiers](#authentication--tiers)). For billing set `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_*` (see `.planning/codebase/RUNBOOKS.md` for live-mode/webhook setup). For transactional emails (welcome, first-purchase, PayNow expiry reminder, receipts) set `RESEND_API_KEY`, `EMAIL_FROM` (optionally `BUSINESS_NAME`, `BUSINESS_UEN`, `SUPPORT_EMAIL`, `PAYNOW_REMINDER_DAYS`) — see [Transactional Emails](#transactional-emails). The frontend needs `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID` in `frontend/.env`. Never commit any of these; never expose service-role/Gemini/Stripe secret keys to the browser.

For the **"upload via phone"** QR flow, open the desktop app via the machine's **LAN IP** (e.g. `http://192.168.x.x:5173`), not `localhost`, so the QR is reachable from the phone (Vite runs with `server.host: true`).

## Database Setup

Run in order in the Supabase SQL Editor:

1. `001_initial_schema.sql` — core tables + indexes
2. `002_question_names.sql` — adds `name` column
3. `003_topic_concepts.sql` — `topic_concepts` table
4. `004_starred_questions.sql` — `starred_questions` table
5. `005_new_topics.sql` — 24 topics, 120 concepts, grants
6. `006_binomial_normal_topics.sql` — adds Binomial Distribution (bbbb0007) & Normal Distribution (bbbb0008) topics
7. `007_asrjc_prelim_2025.sql` — 21 ASRJC 2025 questions
8. `008_multi_part_schema.sql` — adds `parts JSONB` to questions, `part_label TEXT` to attempts
9. `009_asrjc_parts_data.sql` — per-part data for all ASRJC multi-part questions
10. `010_dhs_prelim_2025.sql` — 22 DHS H2 Math Prelim 2025 questions (Papers 1 & 2)
11. `011_chat_messages.sql` — `chat_messages` table (AI hint chatbot history)
12. `012_fix_dhs_preamble.sql` — DHS preamble fix
13. `013_solution_gradings.sql` — `gradings` table + `solution-uploads` Storage bucket (photo AI grading)
14. `014_hci_prelim_2025.sql` — 23 HCI H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–13, Paper 2 Q1–10)
15. `015_acjc_prelim_2025.sql` — 24 ACJC H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–12, Paper 2 Q1–12)
16. `016_cjc_prelim_2025.sql` — 22 CJC H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–11, Paper 2 Q1–11)
17. `017_grading_transcription.sql` — adds `transcription_latex TEXT` to `gradings` (editable AI transcription of handwriting)
18. `021_enable_typed_submissions.sql` — re-classifies mis-flagged `null` parts (find/state/determine → typed box) and adds multi-box `answers[]` data across **all 6 papers** (ASRJC, DHS, HCI, ACJC, CJC, RI). 81 `UPDATE`s on `questions.parts`, no DDL. `-- FLAG:` comments mark brittle/exact-match-risky answers and parts left null for review.
19. `024_sketch_graph_solutions.sql` — adds `solution_graph` JSONB specs to 4 sketch parts (DHS d0251001/d0251005, CJC b0250005, HCI c0251003) so the Solution tab renders a model graph. `jsonb_set` per part, label-guarded, no DDL. `-- FLAG:` lists sketch parts still without specs (Argand/scatter/normal-curve/unknown-f). Spec format: `x_range`/`y_range`/`curves[{expr (mathjs, var x), domain, label (LaTeX)}]`/`asymptotes`/`points` — compiled server-side by `graphService.compileGraph()` into polylines; `solution_graph` is stripped from public payloads (`stripSolution`) and served only via `GET /api/questions/:id/solution` as `graphs[]`, rendered by `SolutionGraph.tsx` (hand-rolled SVG + KaTeX labels, no chart deps). `compileGraph()` injects each labelled point's x into the sample grid and snaps authored point y-values onto the curve (within 5% of y-range) so dots sit exactly on the polyline — labels keep the human-readable rounded coords.
20. `026_fix_dhs_p2q1_turning_points.sql` — fixes DHS P2 Q1 (d0251001) turning points wrongly authored in 010/024 as (2, 8)/(−4, −10); official values are (2, 5)/(−4, −7). Updates the part (b) `solution_graph` points and the `solution_latex` text.
21. `027_sketch_graph_solutions_full.sql` — adds `solution_graph` specs to **all 40 remaining sketch/draw parts** across the 6 papers (verified against the official solution PDFs in `2025/<school>/`), leaving only the Venn diagram (b0251006 a) and Riemann-rectangles sketch (c0250004 a) without graphs. Extends the spec format (see below) and fixes four data errors found against the official solutions: d0250005 (|f| description + max (−2,−2)), cafe1004 (ellipse `√k`, not `k`/`k²`), cafe1005 (missing `√` in the (a)(i) integrand + draft text in solution), cafe1006 (p = √2+√2i rhombus, not 2+2i). Header carries the errata for 024's mislabelled FLAG ids. Abstract-f sketches use **stand-in curves** (concrete functions passing exactly through every officially-labelled feature; construction noted per UPDATE).
22. `028_chat_thread_id.sql` — adds `thread_id UUID NOT NULL DEFAULT uuid_generate_v4()` to `chat_messages` + an index on `(session_id, question_id, thread_id, created_at)`, so the AI hint chat can be scoped to a "conversation opened right now" thread without deleting the rows the daily quota / per-question cap count against (see AI Hint Chatbot below).
23. `029_email_tracking.sql` — adds `welcome_email_sent_at`, `first_purchase_email_sent_at` (once-ever flags, TIMESTAMPTZ) and `last_expiry_reminder_sent_on` (DATE, once-per-day dedupe) to `users` for the transactional email system (see [Transactional Emails](#transactional-emails)).
24. `030_stripe_events.sql` — `stripe_events` table (`id` = Stripe `event.id` PK, `status` `'processing'|'completed'`, `claimed_at`, `completed_at`) + a `(status, claimed_at)` index. Makes webhook handling idempotent — see [Authentication & Tiers](#authentication--tiers).

**`solution_graph` spec fields** (beyond migration 024's `curves[{expr, domain, label}]`/`asymptotes`/`points`): parametric curves `{x_expr, y_expr, domain}` (t-interval; ellipses/loci/inverse reflections — f⁻¹ is plotted as `x_expr: f(t), y_expr: t`); `points[].open` (hollow dot for excluded endpoints); `segments[{from, to, style: 'dashed'?, arrow?, label}]` (straight lines — Argand/vector diagrams, mean lines, y=x); `shade[{expr, domain, label}]` (region filled to the x-axis); `x_label`/`y_label` (KaTeX axis labels); `curves` may be empty/absent (points-only scatter diagrams). `compileGraph()` snaps labelled points onto y=f(x) curves analytically and onto parametric polylines by nearest vertex, and injects point x-values into the sample grid so extrema dots sit exactly on the polyline.

**After any `CREATE TABLE`:** `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;`

## Topic UUIDs (all H2)

`aaaa000N-0000-0000-0000-000000000000` = Pure Math, `bbbb000N-...` = Stats.

| UUID | Topic | | UUID | Topic |
|---|---|---|---|---|
| aaaa0001 | Graphing Techniques | | aaaa0010 | Vector (Plane) |
| aaaa0002 | Functions | | aaaa0011 | Complex Number |
| aaaa0003 | Transformation | | aaaa0012 | Differentiation Technique |
| aaaa0004 | Conics | | aaaa0013 | App. of Differentiation |
| aaaa0005 | Inequalities | | aaaa0014 | Maclaurin Series |
| aaaa0006 | Systems of Linear Equations | | aaaa0015 | Integration Technique |
| aaaa0007 | Sequences & Series | | aaaa0016 | Definite Integral |
| aaaa0008 | Vector (Basic) | | aaaa0017 | Parametric Equations |
| aaaa0009 | Vector (Lines) | | aaaa0018 | Differential Equations |

Stats: bbbb0001–bbbb0008 (Permutation & Combination → Normal Distribution). ASRJC questions: `cafe00NN-...` (Paper 1), `cafe10NN-...` (Paper 2). DHS questions: `d025000N-...` (Paper 1), `d025100N-...` (Paper 2). HCI questions: `c025000N-...` (Paper 1), `c025100N-...` (Paper 2). ACJC questions: `a025000N-...` (Paper 1), `a025100N-...` (Paper 2). CJC questions: `b025000N-...` (Paper 1), `b025100N-...` (Paper 2).

## Authentication & Tiers

**No more anonymous `session_id`.** The app now uses Firebase Authentication end to end; every request that needs user context carries `Authorization: Bearer <firebase-id-token>` (attached automatically in `frontend/src/lib/api.ts` via `auth.currentUser.getIdToken()`).

- **Frontend:** `lib/firebase.ts` initializes the Firebase client SDK (`VITE_FIREBASE_*` env vars) and exports `auth`.
- **Backend:** `middleware/auth.ts` — `requireAuth` verifies the ID token with `firebase-admin` (`db/firebase.ts`, needs `FIREBASE_PROJECT_ID`/`FIREBASE_CLIENT_EMAIL`/`FIREBASE_PRIVATE_KEY`), then **atomically upserts** a row in `users` keyed by `firebase_uid`. `req.user = { uid, firebaseUid, email, tier }` — **`uid` is the internal `users.id`, not the Firebase UID**; every service/table (`chat_messages`, `gradings`, `attempts`, `starred_questions`, …) is keyed on this internal id. A stale/expired token → HTTP 401.
- **Tiers:** `'free' | 'paid'`, derived **from the `users` row, never from the token's custom claim** — `deriveTier()` in `middleware/auth.ts` resolves `paid` only when `subscription_status = 'active'` and `access_expires_at` is null-or-future. A Firebase ID token lives up to an hour and `setCustomUserClaims` cannot invalidate the tokens already issued, so a claim-derived tier let a cancelled card subscriber keep paid quotas for another hour (issue #54). The row is written synchronously by the Stripe webhook, so every grant and revocation binds on the user's next request; the read is free because `requireAuth` already fetches the row to resolve the internal user id. The claim survives only as a UI hint (see below). `gate(feature)` = `requireAuth` + a check against `config/featureTiers.ts` (currently every feature is tier-accessible to `'free'`; paid buys higher **usage quotas**, not feature access).
- **The claim is decoration, the row is enforcement.** `grantPaidTier`/`grantPayNowTier`/`revokePaidTier` therefore write the `users` row **before** calling `setCustomUserClaims`, so a Firebase outage can delay the UI but can never leave a cancelled user with paid access nor a paying user without it. The frontend must not read tier from the claim either: `AuthContext` paints optimistically from `getIdTokenResult()` to avoid a "Free" flash, then overwrites from `GET /api/me` (`refreshTier()` re-reads the same route). `reconcileExpiredUser()` still flips a lapsed user's stale `paid` claim to `free`, but only when the claim actually disagrees — it is cosmetic cleanup, never enforcement.
- **Usage quotas (not rate limits):** `config/limits.ts` (`TIER_LIMITS`) caps free-tier `scansPerDay` (3) and `chatMessagesPerDay` (3) per calendar day in Singapore time; paid is unlimited. Enforced in `services/usageService.ts` (`assertScanQuota`/`assertChatQuota`, counts rows in `gradings`/`chat_messages`) → `QuotaExceededError` → HTTP 429 with `reset_at`. `GET /api/usage` returns the current summary for the signed-in user.
- **Per-user cooldowns:** `services/cooldownService.ts` — in-memory, throttles *accepted* AI requests per user (`AI_CHAT_COOLDOWN_S`=5s, `AI_GRADE_COOLDOWN_S`=60s), separate from the daily quota and from the per-minute `express-rate-limit` on each route. A failed AI call clears the stamp so errors don't cost the user their cooldown.
- **Account-keyed rate limits:** `middleware/rateLimit.ts` — `accountRateLimit()` wraps `express-rate-limit` with a `keyGenerator` (`accountKey`) that buckets by `req.user.uid`, falling back to the pairing's owner (`peekPairOwner`) on the token-authed phone routes, and only then to `ipKeyGenerator(req.ip)`. The library's **default IP key let one user starve another** — two students behind a school NAT shared a bucket (issue #55). Used by `routes/chat.ts`, `routes/grade.ts`, `routes/pair.ts`. `routes/feedback.ts` is the lone exception: it stays IP-keyed and runs *before* `requireAuth` so hammering never reaches Firebase token verification, which means it has no account to key on. These per-minute numbers are a burst guard, not the spend ceiling — sustained cost is capped by the cooldowns, the daily quotas, and the Gemini gateway pacer. **`ipKeyGenerator` must be called inline inside `accountKey`**: express-rate-limit reads the key generator's source text and rejects a bare `req.ip` (a raw IPv6 address lets one client rotate a /64 for a fresh bucket per request).
- **`trust proxy`:** `index.ts` sets `app.set('trust proxy', TRUST_PROXY_HOPS ?? 1)`. Cloud Run always fronts the container, so without this `req.ip` is Google's front end on *every* request and any IP-keyed limiter collapses the whole user base into one bucket. One hop is correct and unspoofable (Google appends the real client IP to any inbound `X-Forwarded-For`); bump to `2` behind an external HTTPS load balancer.
- **Shared Gemini gateway:** `services/geminiGateway.ts` + `config/aiLimits.ts` — all Gemini calls (`chat`/`grade`/`diagnosis`) funnel through one outbound pacer/queue so the app never bursts past Google's real per-key RPM/RPD, independent of the per-user cooldown above.
- **Billing:** `routes/billing.ts` + `services/billingService.ts` — Stripe Checkout (`POST /api/billing/checkout`, card or PayNow) and Customer Portal (`POST /api/billing/portal`) sessions for the signed-in user; `POST /api/billing/webhook` (raw body, mounted *before* `express.json()`) updates `users.subscription_status`/`access_expires_at`. See `.planning/codebase/RUNBOOKS.md` for live-mode and webhook runbooks.
- **Webhook idempotency (migration `030_stripe_events.sql`):** Stripe delivers at-least-once — it retries any delivery that doesn't get a 2xx, resends from the Dashboard button, and may duplicate an event even when nothing failed. The PayNow grant is *relative* (it reads `access_expires_at` and adds a period on top), so a replay would hand out a second period for one payment. `claimEvent()` therefore inserts `event.id` into `stripe_events` **before any side effect** (including the `cancel_at_period_end` Stripe call); the primary key makes the claim atomic without a lock. Two states, not a bare "seen" marker: `'processing'` is written up front and promoted to `'completed'` only after the handler fully succeeds, so a process that dies mid-handler leaves the event re-claimable once `claimed_at` goes stale (`CLAIM_LEASE_MS`, 5 min) instead of being permanently marked handled with the payment dropped. A duplicate of a `'completed'` event returns early → 200 (Stripe stops); a live claim throws → 500 (Stripe retries). Route-level: `WebhookSignatureError` → 400 (not from Stripe, nothing to retry), everything else → 500 so the retry re-runs the work. **`grantPaidTier`/`grantPayNowTier`/`revokePaidTier` must route their writes through `updateUserOrThrow()`** — supabase-js returns errors on the result object rather than throwing, and an unchecked write would leave a `tier: 'paid'` claim with no matching row state *and* still return 2xx, so no retry would ever correct it. Only additive arithmetic needs this; `grantPaidTier` writes absolute values and is naturally replay-safe.
- **PayNow stacking & card/PayNow switching:** Checkout is never blocked by an existing active plan (the old "you already have an active subscription" guard was removed) — the *only* remaining block is a genuine card→card duplicate (`findActiveSubscription()` in `billingService.ts` checks for an existing active/trialing Stripe subscription). Buying **PayNow while PayNow time remains** stacks the new period on top of `access_expires_at` instead of restarting from today (computed in the `checkout.session.completed` webhook handler, mode `'payment'`). Buying **PayNow while a card subscription is active** rolls the card subscription over: it's scheduled `cancel_at_period_end: true` and the new PayNow period starts from that subscription item's `current_period_end` (not from today), so there's no coverage gap or double-billing. Buying **card while PayNow time remains** sets `subscription_data.trial_end` to the current `access_expires_at`, so the card isn't charged until the PayNow period actually runs out (Stripe grants `tier: paid` immediately on `checkout.session.completed` regardless, since the user was already paid via PayNow). `revokePaidTier()` (used by the cancellation/past_due/unpaid webhooks) checks `access_expires_at` before downgrading — if PayNow access is still valid (e.g. because the card sub's scheduled cancellation from a card→PayNow rollover just fired), the tier is left alone rather than clobbered.
- **Review/diagnostics:** `routes/review.ts` also sits behind `gate('review')` — corrections/weak-topics/speed-drills/spaced-repetition item lists, plus AI-generated weakness diagnosis and study plans (cooldown-gated: weekly for free, daily for paid).

## API Endpoints

All endpoints below require `Authorization: Bearer <firebase-id-token>` **except** the ones marked *(public)*.

| Method | Path | Description |
|---|---|---|
| GET | `/api/topics?level=H2` | *(public)* List topics |
| GET | `/api/topics/:id` | *(public)* Single topic |
| GET | `/api/topics/progress` | Per-topic completion stats |
| GET | `/api/topics/accuracy` | Per-topic accuracy stats |
| GET | `/api/topics/:id/questions` | Questions with attempt status |
| GET | `/api/topics/:id/next?difficulty=N` | Next unanswered question |
| GET | `/api/topics/:id/concepts` | *(public)* Prerequisite concepts |
| GET | `/api/questions/:id` | *(public)* Single question (no answer/solution) |
| GET | `/api/questions/:id/solution` | *(public)* Solution + compiled `graphs[]` (served only after the client already has an attempt result) |
| POST | `/api/attempts` | Submit answer → `{ is_correct, correct_answer, solution_latex }` |
| GET | `/api/attempts?question_id=UUID` | User's attempt history (optionally filtered by `question_id`) |
| POST | `/api/stars` | Toggle star |
| GET | `/api/stars?topic_id=UUID` | Starred questions for a topic |
| GET | `/api/stars/all` | All starred questions with latest attempt |
| GET | `/api/streaks` | Streak stats + daily activity heatmap data |
| GET | `/api/chat?question_id=UUID` | Start a fresh AI-hint conversation → `{ thread_id }` (never returns past messages — see AI Hint Chatbot below) |
| POST | `/api/chat` | `{ question_id, thread_id, message }` → Socratic hint `{ reply, history }` (Gemini proxy; tier quota + per-user cooldown + IP rate limit) |
| GET | `/api/grade?question_id=UUID` | Past photo gradings for a question |
| POST | `/api/grade` | **multipart/form-data** (`images[]`, `question_id`, `time_taken_s?`) → AI grade of handwritten solution (Gemini vision; tier quota + cooldown + IP rate limit). Response includes `transcription_latex` (what the AI read) |
| POST | `/api/grade/text` | JSON `{ question_id, transcription_latex, time_taken_s? }` → re-grade the student's corrected LaTeX transcription (no photos, same limits as `/api/grade`) |
| POST | `/api/pair` | Create a phone-upload pairing → `{ token, mobile_path, expires_at }` (userId + tier captured server-side for the later grading call) |
| GET | `/api/pair/:token` | *(public — token is the auth)* Mobile page context; fires `pair:phone-connected` |
| POST | `/api/pair/:token/photo` | *(public — token is the auth)* **multipart** single `image` → streams to desktop via `pair:image` |
| POST | `/api/pair/:token/done` | *(public — token is the auth)* Grade collected photos → `pair:grading`/`pair:graded`/`pair:error` |
| GET | `/api/me` | The signed-in user's server-resolved `{ tier, accessExpiresAt }`. The frontend's only trustworthy source of tier — the Firebase claim can be up to an hour stale (see [Authentication & Tiers](#authentication--tiers)). Deliberately not folded into `/api/billing/status`, which hits Stripe live |
| GET | `/api/usage` | Today's scan/chat quota usage + reset time for the signed-in user |
| GET/POST | `/api/review/*` | Corrections, weak-topics, speed-drills, spaced-repetition, AI diagnosis, study plan (see [Authentication & Tiers](#authentication--tiers)) |
| POST | `/api/billing/checkout` \| `/portal` \| `/webhook` | Stripe Checkout/Portal session creation + webhook (see [Authentication & Tiers](#authentication--tiers)) |
| GET | `/api/billing/status` | Subscription status + renewal info for the signed-in user: PayNow's stored `access_expires_at`, or a live-fetched Stripe `current_period_end` (`renewsAt`) for card subscriptions (no expiry is persisted for those). Powers the days-left display on `/profile` |

`POST /api/attempts` body: `{ question_id, answer_given, part_label?, field_answers?, time_taken_s? }`. Include `part_label` for multi-part questions; include `field_answers: [{ key, value }]` for multi-box parts. `solution_latex` in the response is `null` until all graded parts of the question are submitted.

## Multi-Part Questions

Questions can have a `parts JSONB` column — an array of per-part objects:

```json
{ "label": "a", "prompt_latex": "...", "correct_answer": "\\frac{x}{5}", "answer_type": "exact", "tolerance": null }
```

- `answer_type: null` → "show that" part — no answer box rendered, no submission
- `answer_type: "exact"` or `"range"` → graded; submit with `part_label`
- `question.prompt_latex` = shared preamble only; `parts[i].prompt_latex` = per-part sub-question
- `correct_answer` is stripped from parts before sending to the client (same as question-level)
- Topic status: multi-part questions show ✓ only when **all** graded parts have a correct attempt

**Multi-box parts (several values in one sub-question, e.g. "find a, b and c"):** add an `answers[]` array to the part — `[{ "key": "a", "label": "a", "correct_answer": "\\frac{2}{3}", "answer_type": "exact", "tolerance": null }, ...]`. The frontend renders one labelled box per field; the part is correct only when **every** field matches. Keep the part-level `answer_type`/`correct_answer` as **non-null sentinels** (e.g. `"exact"` + a human-readable joined string) so the existing "graded part" / "reveal when all done" logic still counts it. The part-level and per-field `correct_answer`s are all stripped before the client (`stripSolution` in `questionService.ts`). Submit via `POST /api/attempts` with `field_answers: [{ key, value }]` (grading in `attemptService.ts`); `answer_given` carries a combined display string. Frontend: `MultiFieldInput` in `MultiPartQuestion.tsx`.

**LaTeX in parts JSON:** Every backslash must be doubled (`\frac` → `\\frac`; LaTeX `\\` line break → `\\\\`). Use dollar-quoting (`$$...$$`) in SQL to avoid quote escaping. See `skills.md` for the full workflow.

## AI Hint Chatbot

A Socratic tutor that gives progressive hints (never the final answer) for the question being attempted. **The Gemini API key lives only on the backend** — the browser talks to `/api/chat`, never to Google.

- **Proxy:** `routes/chat.ts` → `services/chatService.ts` → Gemini via `db/gemini.ts` (`@google/genai`, `gemini-2.5-flash`). Same layered pattern as the rest of the backend.
- **Guardrails:** `buildSystemInstruction()` in `chatService.ts` injects the question + `parts` + reference `solution_latex` (server-side only, marked confidential) and instructs the model to give one small hint at a time, never the answer, and refuse off-topic/jailbreak attempts. Tune the prompt there.
- **Rate limiting (layered):** `express-rate-limit` (account-keyed via `middleware/rateLimit.ts`, `CHAT_RATE_LIMIT_PER_MIN`, default 15/min) → daily tier quota (`assertChatQuota`, free = 3 messages/day SGT, paid = unlimited) → per-user cooldown (`AI_CHAT_COOLDOWN_S`, default 5s) → shared Gemini gateway pacer (`config/aiLimits.ts`). `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40) is a separate per-question cap → `ChatLimitError` → HTTP 429. See [Authentication & Tiers](#authentication--tiers).
- **History resets every open, by design:** the conversation is scoped to a `thread_id` (migration `028_chat_thread_id.sql`) that `GET /api/chat` re-mints every time the client opens the chat for a question — mount, page refresh, new tab, or a different device all start a visually empty conversation, and Gemini only sees the current thread as context (`getThreadHistory()` in `chatService.ts`). Rows are **never deleted**: `chat_messages` (keyed by the internal `users.id` + `question_id` + `thread_id`) keeps every message ever sent, so the daily quota and the 40-message-per-question cap (both counted across all threads via `countMessagesForQuestion()`) can't be reset by reopening the chat. `correct_answer`/`solution_latex` are **never** returned to the client.
- **Frontend:** `useChatSession` hook (optimistic send, rolls back on error) + `ChatPanel.tsx`. On `PracticePage` one shared chat instance renders as a sticky right rail on `lg` screens and inside the existing **Hints tab** on mobile (`hidden lg:flex` / `lg:hidden`). Model replies render through `renderLatex()`.

## Photo-Based AI Grading

Students photograph **handwritten** working; Gemini grades it against the stored model solution (it is an *examiner*, not a solver). Primary answer flow on `PracticePage`; typed/MathLive input remains a "Type instead" fallback.

- **Pipeline:** `routes/grade.ts` → `services/gradingService.ts` → Gemini (`db/gemini.ts`). Images arrive as `multipart/form-data` (`multer`), sent to Gemini as base64 `inlineData`, and uploaded to the private `solution-uploads` bucket **only after** grading succeeds.
- **Structured output** (`responseSchema`, deterministic): `{ gradable, rejection_reason, ignored_images[{index,reason}], parts[{label, verdict, marks_awarded, marks_total, errors[{step,description}], hints[], summary}], overall_feedback, transcription_latex }`.
- **Editable transcription + re-grade:** Gemini also transcribes the handwriting verbatim into `transcription_latex`. The frontend `TranscriptionEditor` shows it as editable LaTeX (textarea + live `renderLatex()` preview) next to the feedback; if the scan was wrong the student edits it and re-grades via `POST /api/grade/text` → `gradeTranscription()` (text-only, no photos, `image_paths: []`). Both entry points share `runGrading()` in `gradingService.ts`; `buildGradingInstruction(question, mode)` swaps photo/text framing. The phone-upload flow grades on the phone but the editor/re-grade happens on the desktop (the desktop receives the full `GradeResponse` with `transcription_latex` over Socket.IO).
- **Grading rules** (`buildGradingInstruction()`): credit valid alternative methods; sketches need labelled intercepts + asymptote equations + stationary points + correct shape; "hence" parts must use earlier results; auto-detect which part each photo covers; pin every error to the step. Confidential `solution_latex` injected for reference only.
- **Junk filtering (STEP 0):** photos are numbered (`Photo N:`); blanks/objects/unrelated photos go in `ignored_images`. If nothing relevant remains → `gradable=false` → `GradingError` (HTTP 400 / `pair:error`) with no stored image, `gradings` row, or attempt. Frontend shows a soft `GRADE_REJECTED` (stay on the question to retake), not the global error screen.
- **Persistence:** one `gradings` row per submission (images + feedback; future "mistake log" via `WHERE is_correct=false`) + one `attempts` row per graded part (correct = full marks) so streaks/progress/roadmap ✓ keep working.
- **Limits/UI:** account-keyed `GRADE_RATE_LIMIT_PER_MIN` (5) + daily tier quota (`assertScanQuota`, free = 3 scans/day SGT) + per-user cooldown (`AI_GRADE_COOLDOWN_S`, 60s) + `GRADE_MAX_IMAGES` (5) + `GRADE_MAX_IMAGE_MB` (8). `PhotoAnswer.tsx` → `session.submitPhotos()` → `GradingResult.tsx`; `api.grade.*` uses `requestFormData`. Per-part `marks` is an optional `parts` JSONB field (AI infers when absent).

## Upload via Phone (QR pairing + Socket.IO)

Desktops have no camera: "📱 Upload via phone" shows a QR; the phone opens `/m/:token`, snaps photos that stream live to the desktop over Socket.IO, and **Done** grades them via the same `gradeSolution()`.

- **Backend:** `realtime.ts` (Socket.IO on the `http.Server`; desktops `pair:subscribe` to a token room; `emitToPair()`). `services/pairService.ts` = in-memory `Map` of capability tokens (`crypto.randomBytes(32).base64url`, `PAIR_TTL_MIN` default 10). `routes/pair.ts`: `POST /api/pair`, `GET /api/pair/:token` (+`pair:phone-connected`), `POST /api/pair/:token/photo` (→`pair:image`), `POST /api/pair/:token/done` (→`pair:grading`→`gradeSolution`→`pair:graded`|`pair:error`). Auth = possession of the unguessable token.
- **Frontend:** `lib/socket.ts` (same-origin `io()`), `usePairSocket` (forwards events into `usePracticeSession` via `beginExternalGrading`/`receiveGrading`/`rejectExternalGrading`), `QrPairModal.tsx` (QR = `origin + mobile_path`), `MobileUploadPage.tsx` at top-level route `/m/:token` (outside `RootLayout`). `api.pair.*`.
- **Dev:** Vite needs `server.host: true` + `/socket.io` ws proxy; open the desktop via the machine's **LAN IP** (not `localhost`) so the QR is phone-reachable.

## Transactional Emails

Four classes of account/billing emails, sent via **Resend** (`db/resend.ts`, lazy client — same "don't crash the server if the key is missing" pattern as `db/mailer.ts`). All sending goes through `services/emailService.ts`; templates (subject/html/text) live in `emails/templates.ts`. The existing feedback-form email is unrelated and keeps using Gmail/`nodemailer`.

| # | Email | Trigger | Frequency |
|---|---|---|---|
| 1 | Welcome / induction (promotes Premium) | `middleware/auth.ts`, first time a Firebase user upserts into `users` | Once per account |
| 2 | First-purchase congrats | `services/billingService.ts`, `checkout.session.completed` webhook, right after the tier is granted | Once per account |
| 3 | PayNow expiry reminder | `jobs/payNowExpiryReminder.ts`, daily cron | Once/day for the last `PAYNOW_REMINDER_DAYS` (default 3) days before `access_expires_at` |
| 4 | Transaction receipt | `services/billingService.ts` — `checkout.session.completed` (first PayNow/subscription payment) **and** `invoice.payment_succeeded` with `billing_reason === 'subscription_cycle'` (renewals) | Every successful charge |

- **Once-ever / once-per-day flags live on `users`** (migration `029_email_tracking.sql`): `welcome_email_sent_at`, `first_purchase_email_sent_at` (TIMESTAMPTZ, null until sent), `last_expiry_reminder_sent_on` (DATE). Each send site uses a **conditional update as an atomic claim** — `UPDATE ... WHERE id = ? AND <flag> IS NULL` (or `< today` for the daily one) `.select('id')` — and only sends if the update actually matched a row. This is what prevents double-sends under concurrent requests (several API calls firing on first login) or Stripe's at-least-once webhook redelivery, without needing a lock.
- **Receipt dedup on renewals:** Stripe fires `invoice.payment_succeeded` for a subscription's first invoice too (`billing_reason: 'subscription_create'`), which would double up with the `checkout.session.completed` receipt — the webhook handler only sends from that event when `billing_reason === 'subscription_cycle'` (a true renewal).
- **PayNow vs card subscription:** the reminder job only ever queries `access_expires_at IS NOT NULL` — that column is exclusively set on the PayNow (one-time payment) path and is `null` for card subscriptions (see [Authentication & Tiers](#authentication--tiers)), so card subscribers never get this email.
- **Failure handling:** `emailService.ts` catches and logs every send internally, returning `boolean` rather than throwing — a Resend outage must never break login, checkout, or the webhook response. Callers only persist the "sent" flag when the send actually succeeded, so a transient failure gets retried on the next opportunity instead of being silently marked done.
- **Cron:** `node-cron`, registered in `index.ts` via `startPayNowExpiryReminderCron()`, runs daily at 09:00 `Asia/Singapore`. In-process (the backend is one long-running `http.Server`), not a separate worker.
- **Setup:** requires `RESEND_API_KEY` + a Resend-verified sending domain for `EMAIL_FROM` — see `.planning/codebase/RUNBOOKS.md` for the walkthrough. `BUSINESS_NAME`/`BUSINESS_UEN`/`SUPPORT_EMAIL` are placeholders in `.env.example` — fill in real values before going live. The receipt is a best-effort simple receipt (reference, date, description, amount) and does **not** implement GST/IRAS tax-invoice formatting.

## Frontend Architecture

- **Routes:** `/` (roadmap + TopicDrawer), `/practice/:topicId`, `/history`, `/starred` (bookmarked questions), `/profile` (account, plan/billing, usage, streak heatmap + analytics; `/stats` redirects here)
- **Session:** Firebase Authentication (`lib/firebase.ts`) — the signed-in user's ID token is attached to every API call (`lib/api.ts`). See [Authentication & Tiers](#authentication--tiers).
- **Roadmap:** Pan/zoom tree layout. Node click → `TopicDrawer` (right panel, concepts + question list). Row click → `/practice/:topicId?question_id=<uuid>`.
- **PracticePage:** `?question_id=` → `loadSpecific(id)`; otherwise `loadNext()`. Both idempotent — safe under StrictMode double-invoke. Never use a `firstLoad` ref. Has difficulty filter (Any/Easy/Medium/Hard), 3-tab layout (Question | Attempts | Hints), and a `StatsBar` showing session correct/total and streak count.
- **Practice state machine:** `loading → answering → submitted → revealed → complete | error`
- **Multi-part flow:** `question.parts != null` → `<MultiPartQuestion>` renders per-part boxes with inline ✓/✗; on all graded parts done → phase transitions to `revealed` and `<SolutionReveal>` appears.
- **Stars:** Optimistic UI — flip locally, sync to server, revert on failure. `/starred` page lists all starred questions with latest attempt via `GET /api/stars/all`.
- **Streaks:** `StreakNotification` modal fires once per day on first correct answer. `/profile` page shows current/best streak cards and a GitHub-style weekly heatmap (daily activity from `GET /api/streaks`).
- **Account menu:** Header's "Your Account" dropdown (`AccountMenu.tsx`) replaces the old flat Sign-out button — **Profile** (→ `/profile`) and **Sign out**. `/profile` also surfaces email, member-since date, plan (Free/Premium) with days-left-to-renewal (`GET /api/billing/status`), a "Manage subscription" Stripe portal link, and today's AI usage (`useUsage()`).

## Math Input (MathLive)

- **`MathField.tsx`** — wraps `<math-field>`. Exposes `insert(latex)`, `getValue()`, `focus()`. Suppresses built-in keyboard and hamburger menu.
- **`MathKeyboard.tsx`** — 10-group symbol panel. Use `onMouseDown` (not `onClick`) to avoid stealing focus. Template strings use `#?` placeholders; pass `selectionMode: 'placeholder'` to `mf.insert()`.
- **Correct answer display:** raw LaTeX → `<Latex>` directly, not `renderLatex()`.
- **MathLive compact notation:** `\frac34` (not `\frac{3}{4}`) for single-char numerator/denominator. `normalizeLaTeX()` in `answerChecker.ts` expands this automatically (unit-tested in `answerChecker.test.ts`; `npm test` in `backend/` runs vitest).

## Key Conventions

- **Backend:** Strict TS, no `any`. Zod validates all `req.body`/`req.query`. Routes thin — logic in services. Never call `supabase` from a route. `NodeNext` module resolution — `.js` extension on all imports.
- **Frontend:** All fetch via `lib/api.ts`. Tailwind via `cn()` from `lib/utils.ts`. Types in `src/types/api.ts` mirror backend.
- **LaTeX rendering:** Mixed text+math → `renderLatex()` (`\(...\)` / `\[...\]` delimiters). Pure LaTeX → `<Latex>`. Block display → `<LatexBlock>`.
- **Answer types:** `exact` (normaliseLaTeX string match) or `range` (`|given − correct| ≤ tolerance`). `answer_type: null` = show-that (ungraded).
- **Solution hiding:** `correct_answer` and `solution_latex` stripped before sending to client; returned only after attempt submission.

## Adding Questions

See **`skills.md`** for the full step-by-step workflow: reading PDFs from Google Drive, classifying parts, writing INSERT/UPDATE migrations, JSON escaping rules, and validating before running in Supabase.

Quick reference for `answer_type`:
- Text answer / proof / sketch → `null`
- Algebraic / LaTeX → `"exact"`
- Numerical with tolerance → `"range"`
- Indefinite integrals → always `null` (too many equivalent forms)

## Status

**Built:** Full backend + frontend, Firebase Authentication with free/paid tiers, Stripe/PayNow subscription billing, per-tier usage quotas + per-user cooldowns + a shared Gemini gateway pacer for all AI calls, roadmap with pan/zoom, practice session with multi-part support, MathLive keyboard, star system, history, 24-topic syllabus, 21 ASRJC + 22 DHS + 23 HCI + 24 ACJC + 22 CJC Prelim 2025 questions (Papers 1 & 2 each), streak system with daily heatmap, profile page (/profile — account, plan/billing incl. days-left-to-renewal, usage, streak heatmap, per-topic accuracy; /stats redirects here) with a "Your Account" header dropdown (Profile/Sign out), starred questions page (/starred), AI hint chatbot (Gemini proxy, Socratic hints beside the question, history persists per signed-in account), photo-based AI grading of handwritten solutions (Gemini vision, primary answer flow, ignores irrelevant/blank photos), "upload via phone" QR pairing with live Socket.IO photo transfer, model solution graphs for every sketch question (44 parts incl. scatter/Argand/normal/parametric; migrations 024+027), review system (corrections/weak-topics/speed-drills/spaced-repetition + AI weakness diagnosis + AI study plan), transactional emails via Resend (welcome/induction, first-purchase congrats, PayNow expiry reminder cron, transaction receipts incl. renewals).

**Not built:** Timed mock mode, admin question editor, "mistake log" page (data already captured in `gradings`).

## Common Pitfalls

| Problem | Fix |
|---|---|
| `permission denied for table X` | Run `GRANT ALL` after `CREATE TABLE` |
| Drawer click loads wrong question | Use `loadSpecific()` not `loadNext()` — StrictMode fires effects twice |
| Backend crashes on start | `.env` missing — copy `.env.example` |
| `tsx`/`vite: command not found` | `npm run setup` from project root |
| Math keyboard steals focus | `onMouseDown` + `e.preventDefault()` on keyboard buttons |
| Cursor after fraction, not inside | Pass `selectionMode: 'placeholder'` to `mf.insert()` and use `#?` |
| `syntax error at or near "\"` in Supabase | Unescaped `'` in SQL — use `$$...$$` dollar-quoting instead |
| Part answer not grading | `answer_type` must be non-null and `correct_answer` non-null on the part |
| Solution not revealing after last part | Run migration 008 — `part_label` column missing from attempts |
| `null value in column "answer_type" violates not-null constraint` | The **question-level** `answer_type` column is `NOT NULL`. For an ungraded single-task question, do **not** insert it as a no-parts row with `answer_type = null`. Instead wrap it as a multi-part question with **one `null` part** (the ask) and give the question row a non-null fallback `'exact', ''` (parts override it). Only the per-part `answer_type` may be `null`. |
| Backend crashes: `Missing GEMINI_API_KEY` | Add `GEMINI_API_KEY` to `backend/.env` (see `.env.example`) |
| Backend crashes: `Missing Firebase Admin env vars` | Add `FIREBASE_PROJECT_ID`/`FIREBASE_CLIENT_EMAIL`/`FIREBASE_PRIVATE_KEY` to `backend/.env` (service account JSON — `\n` in the private key must stay literal, `db/firebase.ts` unescapes it) |
| `401 Authentication required` / `Invalid or expired token` | No `Authorization: Bearer` header, or an expired Firebase ID token — check the frontend is signed in and `lib/api.ts` is attaching `auth.currentUser.getIdToken()` |
| `402 Subscription required` | Route is gated `paid`-only in `config/featureTiers.ts` for a free-tier user — check `FEATURE_TIERS`/`req.user.tier` |
| One user's requests rate-limit everybody else | `req.ip` is the proxy's address — `app.set('trust proxy', …)` is missing or too low, so every caller shares one bucket. Tell-tale: `ERR_ERL_UNEXPECTED_X_FORWARDED_FOR` in the logs (express-rate-limit logs its validations rather than throwing). Note the AI routes are account-keyed and immune; only `routes/feedback.ts` still depends on `req.ip` (issue #55) |
| A custom `keyGenerator` throws `ERR_ERL_KEY_GEN_IPV6` | express-rate-limit greps the key generator's **source text** for `req.ip` without `ipKeyGenerator`. Call `ipKeyGenerator()` inline in that same function — putting it in a helper the generator calls will not satisfy the check |
| Chat returns `permission denied for table chat_messages` | Run migration 011 incl. its `GRANT ALL` |
| Grading returns `permission denied for table gradings` | Run migration 013 incl. its `GRANT ALL` |
| Grading: `Bucket not found` / upload fails | Run migration 013 (creates the `solution-uploads` bucket) |
| QR code opens but phone can't reach it | Open the desktop via the machine's LAN IP, not `localhost` (Vite `server.host: true`) |
| Phone photos don't appear on desktop | `/socket.io` ws proxy missing from `vite.config.ts`, or backend not on `http.Server`+Socket.IO |
| `<em>`/`<b>` text renders with a large, uneven gap on both sides | The tag is a **direct child of a `display:flex; gap:...` container** mixed inline with plain text (e.g. a checklist `<li>` with a checkmark `<span>` + raw text). Flexbox blockifies every in-flow child including inline ones, so the emphasis tag becomes its own flex item and the `gap` gets inserted around it. Fix: wrap the whole text run in one `<span>` so the tag nests inside normal inline flow instead of sitting as a flex sibling (see `LandingPage.tsx`'s checklist `<li>`s) |
| Italic (`<em>`) text looks oddly cramped or spaced next to the following word | The Google Fonts `<link>` in `index.html` didn't request the `ital` axis for that family, so the browser fakes italics by skewing the upright glyphs (no real italic file loaded — check via `document.fonts`, look for a `style: 'italic'` entry). Fix: add `ital,wght@0,...;1,...` to that family's Google Fonts URL |
| Transactional emails silently not sending (no crash) | Missing `RESEND_API_KEY`, or `EMAIL_FROM`'s domain isn't verified in the Resend dashboard yet — check backend logs for `Failed to send email "..."`, sending is intentionally best-effort and never throws (see [Transactional Emails](#transactional-emails)) |
| PayNow expiry reminder never fires for a user | Only PayNow (one-time payment) users get it — `access_expires_at` is `null` for card subscriptions by design; also check `users.subscription_status = 'active'` and that the backend process has been running long enough to hit the 09:00 `Asia/Singapore` cron tick |
| Renewal charge has no receipt email | Live/CLI webhook endpoint isn't subscribed to `invoice.payment_succeeded` — add it (Dashboard → Developers → Webhooks, or it's included automatically under `stripe listen` with no `--events` filter) |
| Webhook returns `permission denied for table stripe_events` | Run migration 030 incl. its `GRANT ALL` — every webhook 500s until then |
| Cancelled/past-due user keeps Premium for up to an hour | A tier read from `decoded['tier']` instead of the `users` row. Firebase ID tokens cache the claim for ~1h and `setCustomUserClaims` can't invalidate the issued ones — always derive tier via `deriveTier(row)` in `middleware/auth.ts`, and never read `tier`/`expires_at` claims in the frontend for anything but first paint (issue #54) |
| One PayNow payment granted two billing periods | A `checkout.session.completed` replay ran the additive grant twice. Should be impossible post-migration-030; check `stripe_events` for the event id and that `claimEvent()` still runs before every side effect |
| Webhook stuck retrying, event row sits at `'processing'` | The handler threw after claiming. It's re-claimable after `CLAIM_LEASE_MS` (5 min) — read the backend log for the real error; the 500 body is deliberately generic |
