# External Integrations

**Analysis Date:** 2026-07-03

## Firebase (Auth)

**What it does:** User authentication — ID token issuance (client), token verification (server), and user upsert into Supabase on first login.

**Client SDK (`firebase` 12.15.0):**
- File: `frontend/src/lib/firebase.ts`
- Initializes app with `initializeApp(firebaseConfig)` and exports `auth = getAuth(app)`
- Config drawn from Vite env vars: `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID`
- Features used: Auth only (no Firestore, no Storage on the client)

**Admin SDK (`firebase-admin` 14.1.0):**
- File: `backend/src/db/firebase.ts` — lazy singleton via `getFirebaseAdmin()`
- Initialized with `cert({ projectId, clientEmail, privateKey })` from env vars: `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
- Used exclusively in `backend/src/middleware/auth.ts` → `getAuth(getFirebaseAdmin()).verifyIdToken(token)`

**Auth middleware (`backend/src/middleware/auth.ts`):**
- `requireAuth` — verifies `Authorization: Bearer <idToken>`, resolves/upserts user into Supabase `users` table (selecting `id, access_expires_at`), attaches `req.user = { uid: supabase_uuid, firebaseUid, email, tier }`
- PayNow expiry enforcement: if `tier === 'paid'` and `users.access_expires_at` is in the past, downgrades `tier` to `'free'`, async-revokes Firebase claim, async-sets `subscription_status = 'expired'` in DB
- `gate(feature)` — composes `requireAuth` + tier check against `backend/src/config/featureTiers.ts`
- Tier is read from the decoded token's `tier` custom claim; defaults to `'free'`

**Secrets location:** `backend/.env` (never committed)

---

## Supabase (Postgres)

**What it does:** Primary persistent store for all application data. Accessed exclusively from the backend via the service role key (bypasses RLS).

**Client:** `@supabase/supabase-js` 2.45.0
- File: `backend/src/db/supabase.ts` — singleton `supabase = createClient(url, key)`
- Auth: service role key (`SUPABASE_SERVICE_ROLE_KEY`) — full access, no RLS
- Never imported into frontend; all access is through the backend API

**Tables (via SQL migrations run in Supabase SQL Editor):**

| Table | Migration | Purpose |
|---|---|---|
| `questions` | 001 + 008 | Questions with optional `parts JSONB` for multi-part |
| `attempts` | 001 + 008 | Per-part answer submissions with `part_label` |
| `topics` | 001 | 24 H2 Math topics |
| `topic_concepts` | 003 | Prerequisite concepts per topic |
| `starred_questions` | 004 | User-starred questions keyed by `session_id` |
| `chat_messages` | 011 | AI hint chat history keyed by `session_id + question_id` |
| `gradings` | 013 | Photo grading results (images + Gemini feedback JSON) |
| `users` | (auth middleware) | Firebase UID ↔ Supabase UUID mapping; upserted on login |

**Storage bucket:**
- `solution-uploads` — private bucket created in migration 013; graded photos stored here after successful grading

**DB access layer:** `backend/src/db/` contains one file per table (`attempts.ts`, `chat.ts`, `concepts.ts`, `grade.ts`, `questions.ts`, `stars.ts`, `streaks.ts`, `topics.ts`, `review.ts`). Route handlers call services which call these DB modules — routes never import `supabase` directly.

**Secrets location:** `backend/.env` (`SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`)

---

## Gemini API (Google AI)

**What it does:** Powers two AI features — Socratic hint chatbot and photo-based handwritten solution grading.

**SDK:** `@google/genai` 2.9.0
- File: `backend/src/db/gemini.ts` — lazy singleton `getGemini()` returning `GoogleGenAI` instance
- Model: `gemini-2.5-flash` (default); overridable via `GEMINI_MODEL` env var
- Auth: `GEMINI_API_KEY` in `backend/.env`; never exposed to browser

**Hint chatbot (`/api/chat`):**
- Route: `backend/src/routes/chat.ts`
- Service: `backend/src/services/chatService.ts`
- System instruction built by `buildSystemInstruction()` — injects question + parts + reference `solution_latex` (server-only, marked confidential); instructs model to give one small Socratic hint at a time, never the answer
- History persisted in `chat_messages` table; `GET /api/chat` rehydrates
- Rate limiting: `CHAT_RATE_LIMIT_PER_MIN` (default 15/min, IP-keyed); `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40) → `ChatLimitError` → HTTP 429

**Photo grading (`/api/grade`):**
- Route: `backend/src/routes/grade.ts`
- Service: `backend/src/services/gradingService.ts`
- System instruction built by `buildGradingInstruction()` — injects model solution; instructs Gemini to act as examiner, not solver; credits valid alternative methods
- Images sent as base64 `inlineData` via `@google/genai` multimodal API
- Structured output via `responseSchema` (deterministic JSON): `{ gradable, rejection_reason, ignored_images, parts[{label, verdict, marks_awarded, marks_total, errors, hints, summary}], overall_feedback }`
- Junk filtering (STEP 0): blanks/unrelated images → `ignored_images`; if nothing gradable → `gradable=false` → HTTP 400 with no stored data
- Images stored in Supabase `solution-uploads` bucket only after successful grading
- Rate limiting: `GRADE_RATE_LIMIT_PER_MIN` (default 5/min, IP-keyed); `GRADE_MAX_IMAGES` (default 5); `GRADE_MAX_IMAGE_MB` (default 8)

**Secrets location:** `backend/.env` (`GEMINI_API_KEY`, optionally `GEMINI_MODEL`)

---

## Socket.IO (Real-time)

**What it does:** Live photo streaming from a student's phone to the desktop app during the QR-pairing upload flow.

**Server:** `socket.io` 4.8.3 — `backend/src/realtime.ts`
- Attached to the raw `http.Server` instance (same port 3001 as Express)
- CORS: `origin: '*'`
- Desktop clients join a token-specific room via `pair:subscribe`; events are emitted only to that room via `emitToPair(token, event, payload)`

**Client:** `socket.io-client` 4.8.3 — `frontend/src/lib/socket.ts`
- Singleton `getSocket()` connecting to same origin (tunnels through Vite `/socket.io` proxy in dev)
- Hook: `frontend/src/hooks/usePairSocket.ts` — forwards Socket.IO events into practice session state

**Events:**

| Event | Direction | Payload | Purpose |
|---|---|---|---|
| `pair:subscribe` | Client → Server | `{ token }` | Desktop joins room for its token |
| `pair:unsubscribe` | Client → Server | `{ token }` | Desktop leaves room |
| `pair:phone-connected` | Server → Desktop | — | Phone opened the mobile upload page |
| `pair:image` | Server → Desktop | image data | Phone sent a photo |
| `pair:grading` | Server → Desktop | — | Grading started |
| `pair:graded` | Server → Desktop | grading result | Grading complete |
| `pair:error` | Server → Desktop | error message | Grading failed or image rejected |

---

## Phone Pairing (QR + Token)

**What it does:** Lets students photograph handwritten work on their phone and transfer it to the desktop session without any auth.

**Backend service:** `backend/src/services/pairService.ts`
- In-memory `Map` of capability tokens (32-byte `crypto.randomBytes` → base64url)
- TTL: `PAIR_TTL_MIN` env var (default 10 minutes)
- No database persistence — tokens are ephemeral

**Routes (`backend/src/routes/pair.ts`):**
- `POST /api/pair` — creates token → returns `{ token, mobile_path, expires_at }`
- `GET /api/pair/:token` — mobile page context; fires `pair:phone-connected` Socket.IO event
- `POST /api/pair/:token/photo` — receives single image via multipart; emits `pair:image` to desktop
- `POST /api/pair/:token/done` — triggers grading pipeline; emits `pair:grading` → `pair:graded` or `pair:error`

**Auth model:** Possession of the unguessable token (no user credentials required)

**Frontend components:**
- `frontend/src/components/QrPairModal.tsx` — displays QR code (URL = `origin + mobile_path`)
- `frontend/src/pages/MobileUploadPage.tsx` — top-level route `/m/:token` (outside `RootLayout`)

---

## Data Storage

**Primary database:** Supabase (Postgres) — see Supabase section above

**File storage:** Supabase Storage (`solution-uploads` private bucket) — graded photos only

**Client-side storage:**
- `localStorage` — study plan (`study_plan_v1`); PayNow expiry banner dismissed date (`premium_expiry_banner_dismissed`); managed in `frontend/src/lib/studyPlan.ts` and `frontend/src/components/PremiumExpiryBanner.tsx`

**Caching:** None

---

## Stripe (Billing)

**What it does:** Freemium billing with two payment methods and two billing periods. Upgrades unlock AI grading, AI hints chatbot, and phone QR upload.

| Method | Period | Price | Mode | Renewal |
|---|---|---|---|---|
| Card | Monthly | S$15 / month | `subscription` | Auto-renews; cancel anytime via portal |
| Card | Annual | S$144 / year | `subscription` | Auto-renews; cancel anytime via portal |
| PayNow | Monthly | S$15 one-time | `payment` | No auto-renewal; 30-day access |
| PayNow | Annual | S$144 one-time | `payment` | No auto-renewal; 365-day access |

**SDK:** `stripe` 22.x (Node.js) — server-side only, never exposed to browser.
- File: `backend/src/db/stripe.ts` — lazy singleton `getStripe()` (same pattern as `getGemini()`)
- API version: `2026-06-24.dahlia`

**Stripe resources (sandbox account `acct_1ToaOKKGxkiNQqZh`):**
- Product: `prod_UoZ2ZzgZseMDCF` — "ProjectMath Premium" (SGD)
- Card Monthly: `price_1Tp1yVKGxkiNQqZhbHMAkSye` — S$15.00/month recurring
- Card Annual: `price_1Tp1yXKGxkiNQqZh4CPPsbK7` — S$144.00/year recurring
- PayNow Monthly: `price_1Tp1yYKGxkiNQqZhHimzyTTq` — S$15.00 one-time
- PayNow Annual: `price_1Tp1yZKGxkiNQqZhAgumFiMx` — S$144.00 one-time

**Routes (`backend/src/routes/billing.ts`) — mounted BEFORE `express.json()` in `index.ts`:**
- `POST /api/billing/checkout` — `requireAuth`; body `{ plan: 'monthly'|'annual', method: 'card'|'paynow' }` → resolves Price ID server-side → returns `{ url }` (Stripe Checkout Session redirect URL)
- `POST /api/billing/portal` — `requireAuth` → Stripe Customer Portal session → `{ url }` (card subscribers only)
- `POST /api/billing/webhook` — NO auth; raw body (`express.raw`) for signature verification → handles Stripe events

**Checkout session creation (`billingService.createCheckoutSession`):**
- Card: `mode: 'subscription'`, standard price, `metadata: { user_id, firebase_uid }`
- PayNow: `mode: 'payment'`, `payment_method_types: ['paynow']`, `metadata: { user_id, firebase_uid, paynow_plan }`
- Duplicate guard: blocks if `subscription_status === 'active'` unless `access_expires_at` is past (allows PayNow repurchase after expiry)
- Stale customer guard: verifies Stripe Customer exists before use; recreates if deleted from Dashboard

**Webhook events handled (`billingService.handleWebhookEvent`):**
- `checkout.session.completed` — branches on `session.mode`:
  - `'subscription'` → `grantPaidTier()`: sets `{ tier: 'paid' }` claim, `subscription_status: 'active'`, `access_expires_at: null`
  - `'payment'` → `grantPayNowTier()`: sets `{ tier: 'paid', expires_at: ISO }` claim, `subscription_status: 'active'`, `access_expires_at: <now + 30 or 365 days>`
- `customer.subscription.updated` (canceled/past_due/unpaid) → `revokePaidTier()`: `{ tier: 'free' }` claim, `access_expires_at: null`
- `customer.subscription.deleted` → `revokePaidTier()`: same as above, `subscription_status: 'canceled'`
- `customer.deleted` → `revokePaidTier()` + `stripe_customer_id: null` (handles manual Dashboard deletion)

**Tier propagation:** Firebase custom claim `tier` → decoded in `requireAuth` → `req.user.tier` → `gate()` middleware enforces `featureTiers.ts`

**PayNow expiry enforcement (server-side):** `requireAuth` reads `users.access_expires_at` on every authenticated request. If `tier === 'paid'` and the timestamp has passed, the middleware downgrades `tier` to `'free'` for the current request, then asynchronously revokes the Firebase claim and sets `subscription_status: 'expired'` in DB. No webhook is involved — expiry is purely time-based.

**Feature gates (as of 2026-07-03):**
- `aiHints`: paid
- `photoGrading`: paid
- `pairUpload`: paid
- `practice`, `review`: free

**DB columns on `users` table:**
- `stripe_customer_id TEXT UNIQUE` — added migration 022; links Supabase user to Stripe Customer
- `subscription_status TEXT` — added migration 022; mirrors Stripe status (`active`, `canceled`, `past_due`, `expired`, null)
- `access_expires_at TIMESTAMPTZ` — added migration 023; non-null only for PayNow users; null for card subscribers and free users

**Frontend integration:**
- `api.billing.checkout(plan, method)` / `api.billing.portal()` in `frontend/src/lib/api.ts`
- `UpgradeModal.tsx` — Card/PayNow toggle at top; per-tab plan cards with appropriate framing (card: "auto-renews, cancel anytime"; PayNow: "one-time, no auto-renewal"); S$ prices
- `Header.tsx` — "✦ Get Premium" button (gold gradient) for free users; "✦ Premium" badge (amber) for paid users; badge click opens billing portal
- `HomePage.tsx` — two-effect pattern handles `?checkout=success` redirect: effect 1 detects param on mount; effect 2 fires when `user` resolves; calls `refreshTier()` → `accessExpiresAt` updated; 5s gold toast
- `PremiumExpiryBanner.tsx` — amber warning bar; shown only when `accessExpiresAt !== null` (PayNow users) and within 3 days of expiry; dismissed once per Singapore calendar day via `localStorage` key `premium_expiry_banner_dismissed`; "Renew now" opens UpgradeModal; mounted in `RootLayout` in `App.tsx`
- `AuthContext.tsx` — exposes `accessExpiresAt: Date | null` read from `expires_at` Firebase claim; `refreshTier()` calls `getIdTokenResult(true)` and updates both `tier` and `accessExpiresAt` via shared `applyTokenResult()`

**Webhook router ordering:** Billing router is mounted before `app.use(express.json())` in `backend/src/index.ts`. The `/webhook` sub-route uses `express.raw({ type: 'application/json' })`; `/checkout` and `/portal` apply `express.json()` per-route. Order is critical — reversing it breaks webhook signature verification.

**Dev setup:**
1. Run `stripe listen --forward-to localhost:3001/api/billing/webhook` in a separate terminal
2. Copy the printed `whsec_...` into `backend/.env` as `STRIPE_WEBHOOK_SECRET`
3. Each developer runs their own `stripe listen` → gets their own unique `whsec_...` (the Stripe secret key and price IDs are shared; only the webhook secret is per-machine)
4. To reset a test account to free: `npx tsx backend/scripts/reset-user-tier.ts <email>`

**PayNow test mode:** Stripe shows a QR code with a "Simulate scan" button. Clicking it opens a separate "PayNow test payment page" where "Authorize test payment" fires the webhook. The auto-redirect back to `success_url` does NOT happen in test mode (sandbox limitation); navigate manually to `/roadmap?checkout=success`. In live mode, the user stays on the QR page while paying via their banking app and the page auto-redirects after confirmation.

---

## Authentication & Identity

**Auth provider:** Firebase Auth (see Firebase section above)
- Client-side sign-in; ID token passed as `Authorization: Bearer` header to all protected backend routes
- Backend resolves Firebase UID → Supabase `users.id` on every authenticated request (via upsert)
- Session identity also tracked via anonymous `session_id` in `localStorage` (used for attempts, stars, streaks, chat history — no login required for basic practice)

---

## Monitoring & Observability

**Error tracking:** None detected

**Logs:** `console.log` / `console.error` only; no structured logging library

---

## CI/CD & Deployment

**Hosting:** Not configured in repo

**CI pipeline:** None detected

---

## Environment Variables — Full Reference

**Backend (`backend/.env`):**
- `SUPABASE_URL` — Supabase project URL (required)
- `SUPABASE_SERVICE_ROLE_KEY` — Service role key (required)
- `FIREBASE_PROJECT_ID` — Firebase project (required for auth)
- `FIREBASE_CLIENT_EMAIL` — Service account email (required for auth)
- `FIREBASE_PRIVATE_KEY` — Service account private key, `\n` escaped (required for auth)
- `GEMINI_API_KEY` — Google AI key (required for chat/grade)
- `GEMINI_MODEL` — Model override (optional, default `gemini-2.5-flash`)
- `CHAT_RATE_LIMIT_PER_MIN` — default 15
- `CHAT_MAX_MESSAGES_PER_QUESTION` — default 40
- `GRADE_RATE_LIMIT_PER_MIN` — default 5
- `GRADE_MAX_IMAGES` — default 5
- `GRADE_MAX_IMAGE_MB` — default 8
- `PAIR_TTL_MIN` — default 10
- `PAIR_RATE_LIMIT_PER_MIN` — default (unspecified in code)
- `PORT` — default 3001
- `NODE_ENV` — controls CORS origin selection
- `CORS_ORIGIN` — production frontend URL
- `STRIPE_SECRET_KEY` — `sk_test_...` dev / `sk_live_...` prod (required for billing; shared across team)
- `STRIPE_WEBHOOK_SECRET` — **per-developer**: `whsec_...` from `stripe listen` (dev); Stripe Dashboard webhook endpoint secret (prod); each developer must run `stripe listen` and use the printed secret in their own `.env`
- `STRIPE_PRICE_MONTHLY` — `price_1Tp1yVKGxkiNQqZhbHMAkSye` (S$15/mo card recurring, SGD)
- `STRIPE_PRICE_ANNUAL` — `price_1Tp1yXKGxkiNQqZh4CPPsbK7` (S$144/yr card recurring, SGD)
- `STRIPE_PRICE_MONTHLY_PAYNOW` — `price_1Tp1yYKGxkiNQqZhHimzyTTq` (S$15 PayNow one-time, SGD)
- `STRIPE_PRICE_ANNUAL_PAYNOW` — `price_1Tp1yZKGxkiNQqZhAgumFiMx` (S$144 PayNow one-time, SGD)
- `FRONTEND_URL` — default `http://localhost:5173`; override in production for Stripe redirect URLs

**Frontend (`frontend/.env`):**
- `VITE_FIREBASE_API_KEY`
- `VITE_FIREBASE_AUTH_DOMAIN`
- `VITE_FIREBASE_PROJECT_ID`
- `VITE_FIREBASE_APP_ID`

---

*Integration audit: 2026-07-03*
