<!-- refreshed: 2026-07-03 -->
# Architecture

**Analysis Date:** 2026-07-03

## System Overview

```text
┌──────────────────────────────────────────────────────────────┐
│              Browser (React 19 + Vite, port 5173)            │
│  AuthProvider → AuthContext (Firebase Auth JWT + tier)       │
│  App.tsx → React Router → Page Components                    │
│  All fetch via lib/api.ts (attaches Bearer token)            │
└────────────────────┬─────────────────────────────────────────┘
                     │  HTTP /api/* (Vite proxy in dev)
                     │  WS /socket.io  (Vite ws proxy in dev)
                     ▼
┌──────────────────────────────────────────────────────────────┐
│          Express + Socket.IO backend (port 3001)             │
│  backend/src/index.ts                                        │
│  Middleware: cors, express.json, auth.ts (Firebase JWT)      │
│  Routes → Services (thin route / business logic in service)  │
└─────────┬───────────────────────┬────────────────────────────┘
          │                       │
          ▼                       ▼
┌──────────────────┐   ┌──────────────────────────────────────┐
│ Supabase          │   │  External Services                   │
│ (Postgres +       │   │  - Firebase Auth (token verify +     │
│  Storage)         │   │    custom claims for tier)           │
│ db/supabase.ts    │   │  - Gemini 2.5-flash (chat + grading) │
└──────────────────┘   │  - Stripe (billing checkout,         │
                        │    webhooks, customer portal)        │
                        │  db/firebase.ts, db/gemini.ts,       │
                        │  db/stripe.ts                        │
                        └──────────────────────────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| `AuthProvider` | Firebase Auth state, tier resolution, login/upgrade modals | `frontend/src/contexts/AuthContext.tsx` |
| `lib/api.ts` | All HTTP calls; attaches Bearer token; handles 401/402 callbacks | `frontend/src/lib/api.ts` |
| `usePracticeSession` | Practice state machine (reducer); single/multi-part/photo answer flows | `frontend/src/hooks/usePracticeSession.ts` |
| `usePairSocket` | Subscribes desktop to pairing token room; forwards Socket.IO events to session | `frontend/src/hooks/usePairSocket.ts` |
| `useChatSession` | Optimistic send for AI chatbot; history rehydration | `frontend/src/hooks/useChatSession.ts` |
| `useStudyPlan` | Loads/caches daily study plan; cross-references attempts for status | `frontend/src/hooks/useStudyPlan.ts` |
| `middleware/auth.ts` | Verifies Firebase ID token; upserts user row in Supabase; attaches `req.user` | `backend/src/middleware/auth.ts` |
| `gate(feature)` | Composes `requireAuth` + tier check; used on every protected route | `backend/src/middleware/auth.ts` |
| `realtime.ts` | Socket.IO server; manages `pair:subscribe`/`pair:unsubscribe` room membership | `backend/src/realtime.ts` |
| `gradingService.ts` | Gemini vision grading pipeline; junk filtering; persists to Supabase | `backend/src/services/gradingService.ts` |
| `chatService.ts` | Builds Socratic system prompt; proxies Gemini; persists messages | `backend/src/services/chatService.ts` |
| `attemptService.ts` | Answer grading (exact/range/mcq/symbolic); streak upsert; Supabase write | `backend/src/services/attemptService.ts` |
| `pairService.ts` | In-memory Map of ephemeral pairing sessions (token → PairSession) | `backend/src/services/pairService.ts` |
| `featureTiers.ts` | Maps feature name → required tier (`free`/`paid`) | `backend/src/config/featureTiers.ts` |
| `billingService.ts` | Stripe checkout session creation (card + PayNow); portal session; webhook event handling; Firebase claim grants/revocations | `backend/src/services/billingService.ts` |
| `UpgradeModal.tsx` | Card/PayNow toggle; plan card selection; triggers checkout redirect via `api.billing.checkout(plan, method)` | `frontend/src/components/UpgradeModal.tsx` |
| `PremiumExpiryBanner.tsx` | Amber warning bar for PayNow users within 3 days of expiry; shown once per Singapore calendar day; "Renew now" opens UpgradeModal | `frontend/src/components/PremiumExpiryBanner.tsx` |

## Auth Model

**Current state:** Full Firebase Auth is implemented and active. The old `session_id` (localStorage UUID) identity model is replaced.

- **Frontend:** `frontend/src/lib/firebase.ts` initializes Firebase app with `VITE_FIREBASE_*` env vars. `AuthContext.tsx` listens via `onAuthStateChanged`. Reads `tier` and `expires_at` claims from `getIdTokenResult().claims` via the shared `applyTokenResult()` helper.
- **Token flow:** `lib/api.ts:getAuthHeader()` calls `auth.currentUser?.getIdToken()` before every request; appends `Authorization: Bearer <idToken>`.
- **Backend token verification:** `backend/src/middleware/auth.ts:requireAuth` → `getAuth(getFirebaseAdmin()).verifyIdToken(token)` → upserts `users` table row (`firebase_uid`, `email`) → resolves internal Supabase UUID as `req.user.uid`. Also selects `access_expires_at` and enforces PayNow expiry server-side (see Tier System below). All protected routes use `gate('feature')` which composes `requireAuth` + tier check.
- **Tier system:** `tier` is a custom Firebase Auth claim (`'free'` / `'paid'`), set by `billingService.ts` via Firebase Admin SDK on successful payment. Gated features: `aiHints`, `photoGrading`, `pairUpload` → `'paid'`; `practice`, `review` → `'free'`. For card subscriptions, `tier: 'paid'` claim has no expiry — revoked only on subscription cancellation webhook. For PayNow one-time payments, the claim includes `expires_at: ISO_string`; `requireAuth` checks `users.access_expires_at` against the current time on every request and downgrades to `'free'` if past, clearing the claim and DB field asynchronously.
- **PayNow expiry enforcement:** Server-side in `requireAuth` (authoritative); client-side via `accessExpiresAt: Date | null` in `AuthContext` (for UI only — banner display). The client cannot be trusted for access control.
- **refreshTier():** After Stripe checkout redirect, `HomePage.tsx` calls `refreshTier()` which force-refreshes the Firebase ID token (`getIdTokenResult(true)`) and immediately updates both `tier` and `accessExpiresAt` in context without waiting for `onAuthStateChanged`.
- **Error handling:** 401 → `_callbacks.onUnauthorized()` → opens `LoginModal`. 402 → `_callbacks.onPaymentRequired()` → opens `UpgradeModal`. Both callbacks registered via `setApiCallbacks()` inside `AuthContext.tsx`.
- **Auth methods:** Google OAuth (`signInWithPopup`) and email/password (`createUserWithEmailAndPassword` / `signInWithEmailAndPassword` + `sendEmailVerification`).
- **Database identity:** `req.user.uid` is the Supabase `users.id` UUID (not firebase_uid), resolved after upsert in `requireAuth`. All service calls use this UUID as the identity key.

## Layers

**Frontend:**
- `frontend/src/main.tsx` — React root; wraps `<App>` in `<AuthProvider>` + `<StrictMode>`
- `frontend/src/App.tsx` — Router definition; `RootLayout` (Header + StudyPlanSidebar shell); standalone routes for `/` (LandingPage) and `/m/:token` (MobileUploadPage)
- `frontend/src/contexts/` — `AuthContext` (only global context; no Redux or Zustand)
- `frontend/src/hooks/` — Feature-specific data and state hooks; `usePracticeSession` is the most complex (reducer pattern)
- `frontend/src/lib/` — `api.ts` (all HTTP), `firebase.ts` (client SDK init), `socket.ts` (Socket.IO singleton), `studyPlan.ts` (localStorage cache), `renderLatex.tsx`, `utils.ts`
- `frontend/src/components/` — Presentational components grouped by domain
- `frontend/src/pages/` — Route-level components that compose hooks + components
- `frontend/src/types/api.ts` — Client-side type mirror of backend types

**Backend:**
- `backend/src/index.ts` — Express + `http.Server` setup; mounts all routers; calls `initRealtime`
- `backend/src/middleware/auth.ts` — Firebase token verification + tier gate
- `backend/src/routes/` — Thin Express routers; validate with Zod; delegate to services
- `backend/src/services/` — All business logic; only layer that touches Supabase or Gemini
- `backend/src/db/` — Supabase client singleton (`supabase.ts`), Firebase Admin lazy-init (`firebase.ts`), Gemini client factory (`gemini.ts`)
- `backend/src/config/featureTiers.ts` — Feature-to-tier mapping
- `backend/src/realtime.ts` — Socket.IO initialization and `emitToPair()` helper
- `backend/src/types/index.ts` — All shared TypeScript types

## Data Flow

### Typed Answer Submission (single-part)

1. User types in `MathField` or selects MCQ in `PracticePage` (`frontend/src/pages/PracticePage.tsx`)
2. `usePracticeSession.submitAnswer(answerGiven)` dispatches `SUBMIT_START`
3. `api.attempts.submit({ question_id, answer_given, time_taken_s })` → `POST /api/attempts` with `Authorization: Bearer <token>`
4. `backend/src/middleware/auth.ts:requireAuth` verifies JWT, attaches `req.user.uid`
5. `backend/src/routes/attempts.ts` validates body with Zod; calls `attemptService.submitAttempt(uid, body)`
6. `backend/src/services/attemptService.ts` fetches question from Supabase; grades answer via `normalizeLaTeX` / `tryNumericEval` / `trySymbolicEval` / range check; writes attempt row; calls `upsertSRCard`
7. Returns `{ attempt_id, is_correct, correct_answer, solution_latex }` — `solution_latex` is `null` until all graded parts submitted
8. Route returns 201; `api.ts` resolves; `SUBMIT_SUCCESS` dispatched → `phase: 'revealed'`

### Multi-Part Question Flow

- `question.parts` arrives as `QuestionPartPublic[]`; `correct_answer` is stripped server-side before client receives it
- `MultiPartQuestion` (`frontend/src/components/question/MultiPartQuestion.tsx`) renders one answer box per part with `answer_type !== null`
- Each part calls `usePracticeSession.submitPart(partLabel, answer)` → `api.attempts.submit({ ..., part_label })`
- Backend grades the specific part; returns `solution_latex: null` until all graded parts are done
- `PART_SUBMIT_DONE` action updates `partStates[label]`; when `solution_latex !== null` in the response → transitions to `phase: 'revealed'`

### Photo Grading Pipeline

1. `PhotoAnswer.tsx` captures images → `usePracticeSession.submitPhotos(files)`
2. `api.grade.submit(questionId, images)` → `POST /api/grade` as `multipart/form-data`
3. `backend/src/routes/grade.ts` parses with `multer`; calls `gradingService.gradeSolution({ userId, question_id, images, time_taken_s })`
4. `backend/src/services/gradingService.ts` fetches question + `solution_latex` from Supabase (confidential, never returned to client)
5. Calls `getGemini().models.generateContent(...)` with base64 images + `buildGradingInstruction()` prompt + `responseSchema` for structured output
6. STEP 0 junk filter: Gemini returns `gradable: false` → `GradingError` thrown → HTTP 400 → `GRADE_REJECTED` action → student stays on question to retake
7. If gradable: writes `gradings` row + one `attempts` row per graded part to Supabase; uploads images to `solution-uploads` bucket
8. Returns `GradeResponse`; `GRADE_SUCCESS` dispatched → `phase: 'revealed'`

### QR Phone Upload Flow

1. Desktop: `api.pair.create(questionId)` → `POST /api/pair` → `pairService.createPair()` → returns `{ token, mobile_path, expires_at }`
2. Desktop: `QrPairModal.tsx` renders QR code encoding `<origin>/m/<token>`
3. Desktop: `usePairSocket(token, ...)` → `socket.emit('pair:subscribe', { token })` → joins Socket.IO room
4. Phone opens `/m/<token>` → `MobileUploadPage.tsx` → `api.pair.context(token)` to get question context
5. Phone uploads photos: `api.pair.uploadPhoto(token, image)` → `POST /api/pair/:token/photo` → `emitToPair(token, 'pair:image', { index, dataUrl })` → desktop `usePairSocket` appends to `images[]`
6. Phone taps Done: `api.pair.done(token)` → `POST /api/pair/:token/done` → backend calls `gradeSolution()` (same pipeline as direct upload)
7. Backend emits `pair:grading`, then `pair:graded` (with `GradeResponse`) or `pair:error` to the token room
8. Desktop `usePairSocket` receives events → forwards to `usePracticeSession` via `beginExternalGrading` / `receiveGrading` / `rejectExternalGrading`

### Stripe Billing Checkout Flow

**Card (recurring subscription):**
1. User clicks "Get Premium" → `UpgradeModal` → selects Card tab → picks Monthly or Annual
2. `api.billing.checkout(plan, 'card')` → `POST /api/billing/checkout` with `{ plan, method: 'card' }`
3. `billingService.createCheckoutSession()` looks up or creates Stripe Customer; creates Checkout Session (`mode: 'subscription'`, SGD price)
4. Returns `{ url }` — frontend redirects `window.location.href = url` to Stripe's hosted page
5. User fills card details on Stripe → Stripe charges card → redirects to `/roadmap?checkout=success`
6. Stripe fires `checkout.session.completed` webhook → `handleWebhookEvent` → `grantPaidTier()` → sets Firebase claim `{ tier: 'paid' }` + `subscription_status: 'active'`
7. `HomePage.tsx` detects `?checkout=success` → calls `refreshTier()` → tier flips in UI instantly → 5s gold toast

**PayNow (one-time payment):**
1. Same entry as Card; user switches to PayNow tab → picks Monthly (S$15) or Annual (S$144)
2. `api.billing.checkout(plan, 'paynow')` → `POST /api/billing/checkout` with `{ plan, method: 'paynow' }`
3. `billingService.createCheckoutSession()` creates Checkout Session (`mode: 'payment'`, `payment_method_types: ['paynow']`, metadata `paynow_plan`)
4. Stripe shows QR code page → user scans with banking app → Stripe receives PayNow network confirmation
5. Stripe fires `checkout.session.completed` webhook → `handleWebhookEvent` branches on `session.mode === 'payment'` → `grantPayNowTier()` → sets Firebase claim `{ tier: 'paid', expires_at: ISO_string }` + `access_expires_at` in DB (30 days for monthly, 365 days for annual)
6. Stripe Checkout page redirects to `/roadmap?checkout=success` → same `refreshTier()` / toast flow as card

**Subscription lifecycle (card only):**
- `customer.subscription.updated` (past_due / canceled / unpaid) → `revokePaidTier()` → claim reset to `{ tier: 'free' }`, `access_expires_at: null`
- `customer.subscription.deleted` → same revocation
- `customer.deleted` (manual Dashboard deletion) → revocation + `stripe_customer_id: null` (stale customer guard)

**PayNow expiry (no webhook):**
- `requireAuth` checks `users.access_expires_at` on every request — downgrades server-side when past
- Client shows `PremiumExpiryBanner` within 3 days of expiry (once per SGT calendar day via `localStorage`)

### AI Hint Chatbot

1. User types in `ChatPanel.tsx` → `useChatSession.send(message)` → optimistic append
2. `api.chat.send(questionId, message)` → `POST /api/chat` with auth header
3. `backend/src/routes/chat.ts` → `chatService.sendMessage(userId, questionId, message)`
4. `backend/src/services/chatService.ts` fetches question + `solution_latex` from Supabase (confidential, injected into system prompt only)
5. `buildSystemInstruction(question)` constructs Socratic system prompt with question text, parts, and reference solution
6. Calls Gemini `generateContent` with full `chat_messages` history + new user message
7. Persists both user message and model reply to `chat_messages` table (keyed by `userId` + `question_id`)
8. Returns `{ reply, history }`; `useChatSession` replaces optimistic message with real reply
9. History is scoped to auth user (not session_id); `GET /api/chat?question_id=X` rehydrates on load

## State Management

**Global:**
- `AuthContext` (`frontend/src/contexts/AuthContext.tsx`) — Firebase `User` object, `tier`, `accessExpiresAt` (PayNow expiry as `Date | null`), loading flag; mounted at root in `main.tsx`; no other global state stores

**Route-level:**
- `PracticePage` — `usePracticeSession` reducer (practice phase state machine); `useChatSession`; `usePairSocket`; local `useState` for tabs, input mode, attempts list, solution

**Data-fetching hooks (local to component trees):**
- `useTopics`, `useTopicsProgress`, `useTopicQuestions`, `useConcepts`, `useAttemptHistory`, `useFeature`, `useStudyPlan`

**Persistent client state:**
- `localStorage` — Study plan cache (`frontend/src/lib/studyPlan.ts`); expiry banner dismissed date (`premium_expiry_banner_dismissed` key, set to current SGT date on dismiss). Session_id has been removed on this branch.

**Server state:**
- Supabase Postgres — all persistent data: `users` (incl. `stripe_customer_id`, `subscription_status`, `access_expires_at`), `attempts`, `starred_questions`, `streaks`, `chat_messages`, `gradings`, `study_plan_cache`, `spaced_repetition_cards`
- Supabase Storage — `solution-uploads` bucket for graded photo images

**Ephemeral server state:**
- `backend/src/services/pairService.ts` — in-memory `Map<token, PairSession>`; never persisted; TTL enforced by `PAIR_TTL_MIN` env var (default 10 min)

## Real-Time (Socket.IO)

**Topology:**
- Single `http.Server` (wraps Express app) with Socket.IO attached at `backend/src/realtime.ts`
- Default namespace (`/`); no custom namespaces
- Rooms: one room per pairing token string

**Socket.IO events:**

| Direction | Event | Payload | Purpose |
|-----------|-------|---------|---------|
| client → server | `pair:subscribe` | `{ token }` | Desktop joins token room |
| client → server | `pair:unsubscribe` | `{ token }` | Desktop leaves token room |
| server → client | `pair:phone-connected` | — | Phone opened mobile upload page |
| server → client | `pair:image` | `{ index, dataUrl }` | Photo streamed from phone |
| server → client | `pair:grading` | — | Backend started grading |
| server → client | `pair:graded` | `{ grading: GradeResponse }` | Grading complete |
| server → client | `pair:error` | `{ message }` | Grading rejected |

**Frontend connection:** `frontend/src/lib/socket.ts` — module-level singleton via `io()` (same-origin; Vite proxies `/socket.io` as WebSocket in dev via `vite.config.ts`).

## Practice State Machine

Managed by `useReducer` in `frontend/src/hooks/usePracticeSession.ts`:

```
loading → answering → submitted → revealed → (nextQuestion) → loading
                    ↓ (GRADE_REJECTED)
                  answering   (soft error, retake photo)
                    ↓ (ERROR)
                  error
answering → complete  (no more questions in topic)
```

`PracticePhase` type: `'loading' | 'answering' | 'submitted' | 'revealed' | 'complete' | 'error'`

## Anti-Patterns

### Bypassing `lib/api.ts` for direct fetch

**What happens:** Calling `fetch('/api/...')` directly in a component instead of using `api.*` methods.
**Why it's wrong:** Auth header won't be attached; 401/402 callbacks won't fire; type safety lost.
**Do this instead:** Always use `api.*` from `frontend/src/lib/api.ts`.

### Calling Supabase from a route handler

**What happens:** Importing `supabase` in `backend/src/routes/*.ts` and running queries there.
**Why it's wrong:** Violates the thin-route pattern; business logic leaks into transport layer.
**Do this instead:** Delegate to a service function in `backend/src/services/`.

### Using `session_id` as identity on the firebase-auth branch

**What happens:** Passing `session_id` query param to protected endpoints.
**Why it's wrong:** Session_id identity has been removed; backend uses `req.user.uid` from the verified JWT.
**Do this instead:** Rely on `req.user.uid` server-side; let `lib/api.ts` attach the token automatically.

### Mutating state directly in a route effect

**What happens:** Using `useEffect` with a `firstLoad` ref guard in `PracticePage`.
**Why it's wrong:** React StrictMode double-invokes effects; `firstLoad` refs break under StrictMode.
**Do this instead:** `loadSpecific(id)` and `loadNext()` are idempotent — call them directly in the effect without guards.

## Error Handling

**Backend pattern:**
- Zod parse errors → 400 with `{ error, details }`
- `ChatLimitError` → 429
- `GradingError` → 400 (soft, retryable; no attempt row written)
- Auth failures → 401 / 402
- All other thrown errors → 500 with `{ error: message }`

**Frontend pattern:**
- `lib/api.ts:request()` throws on non-ok; 401 triggers login modal; 402 triggers upgrade modal
- Hooks catch errors and set local `error` state or dispatch `ERROR`/`GRADE_REJECTED` actions
- `GRADE_REJECTED` keeps student on question (soft); `ERROR` transitions to error screen

## Cross-Cutting Concerns

**LaTeX rendering:**
- Mixed text+math → `renderLatex()` from `frontend/src/lib/renderLatex.tsx` (`\(...\)` / `\[...\]` delimiters)
- Pure LaTeX → `<Latex>` from `frontend/src/components/math/Latex.tsx`
- Block display → `<LatexBlock>` from `frontend/src/components/math/LatexBlock.tsx`

**Answer normalization:** `normalizeLaTeX()` in `backend/src/services/attemptService.ts` strips whitespace, expands compact MathLive notation (`\frac34` → `\frac{3}{4}`), lowercases.

**Rate limiting:** `express-rate-limit` on `POST /api/chat` and `POST /api/grade`; IP-keyed; configured via env vars `CHAT_RATE_LIMIT_PER_MIN` (default 15) and `GRADE_RATE_LIMIT_PER_MIN` (default 5). Billing routes (`/api/billing/checkout`, `/api/billing/portal`) have no explicit rate limit beyond Firebase token verification cost.

**Validation:** Zod on all `req.body` and `req.query` in every route handler.

**Logging:** `console.log` / `console.error` only; no structured logging framework.

### Webhook Router Ordering

The billing router **must** be mounted before `express.json()` in `backend/src/index.ts`. The webhook endpoint (`POST /api/billing/webhook`) uses `express.raw({ type: 'application/json' })` to receive the raw body for Stripe signature verification. If `express.json()` runs first, the body is consumed and verification fails with a 400. Non-webhook billing routes (`/checkout`, `/portal`) apply `express.json()` per-route explicitly.

---

*Architecture analysis: 2026-07-03*
