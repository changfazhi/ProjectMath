# External Integrations

**Analysis Date:** 2026-07-04

## APIs & External Services

**AI & ML:**
- **Google Gemini 2.5 Flash** - LLM for Socratic hints and photo-based solution grading
  - SDK/Client: `@google/genai` (2.9.0)
  - Auth: `GEMINI_API_KEY` env var
  - Usage: `backend/src/db/gemini.ts` (lazy singleton), consumed by:
    - `backend/src/services/chatService.ts` → `/api/chat` (hints via `sendHintMessage()`)
    - `backend/src/services/gradingService.ts` → `/api/grade` (photo grading via `gradeSolution()` and `gradeTranscription()`)
  - Model selection: `GEMINI_MODEL` env var (default `gemini-2.5-flash`)
  - Rate limits: `CHAT_RATE_LIMIT_PER_MIN` (default 15), `GRADE_RATE_LIMIT_PER_MIN` (default 5)
  - Per-question caps: `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40)

**Payments & Billing:**
- **Stripe** - Payment processing for subscriptions and one-time purchases
  - SDK/Client: `stripe` (22.3.0)
  - Auth: `STRIPE_SECRET_KEY` env var, webhook verification via `STRIPE_WEBHOOK_SECRET`
  - API Version: `2026-06-24.dahlia` (specified in `backend/src/db/stripe.ts`)
  - Usage:
    - Checkout sessions: `backend/src/services/billingService.ts` → `/api/billing/checkout` (card or PayNow)
    - Billing portal: `backend/src/services/billingService.ts` → `/api/billing/portal`
    - Webhooks: `/api/billing/webhook` (handles `checkout.session.completed`, `customer.subscription.updated/deleted`, `customer.deleted`)
  - Price configurations:
    - `STRIPE_PRICE_MONTHLY` - Card monthly subscription
    - `STRIPE_PRICE_ANNUAL` - Card annual subscription
    - `STRIPE_PRICE_MONTHLY_PAYNOW` - One-time PayNow monthly access (30 days)
    - `STRIPE_PRICE_ANNUAL_PAYNOW` - One-time PayNow annual access (365 days)
  - Customer lifecycle: Lookup via `stripe_customer_id` in `users` table; guards against deleted customers on Portal/Checkout

## Data Storage

**Databases:**
- **Supabase PostgreSQL** - Primary application data
  - Connection: `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` env vars
  - Client: `@supabase/supabase-js` (2.45.0)
  - Initialization: `backend/src/db/supabase.ts` (lazy singleton)
  - Tables managed: `topics`, `questions`, `parts` (JSONB), `attempts`, `stars`, `chat_messages`, `gradings`, `users`, `topic_concepts`
  - Grants: `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;` (required after each migration)
  - Backend entrypoint: `backend/src/routes/*` → `backend/src/services/*` → `supabase` queries (no direct calls in routes)

**File Storage:**
- **Supabase Storage** - `solution-uploads` bucket for photo grading submissions
  - Access: Service role key (server-side only)
  - Upload location: `backend/src/services/gradingService.ts` → `uploadImages()` after grading passes relevance check
  - Path structure: `{userId}/{questionId}/{randomUUID}.{ext}` (extensions: jpg, png, webp, heic, heif)
  - Lifecycle: Photos only persisted after Gemini grades successfully and rejects junk submissions

**Caching:**
- None detected (no Redis, Memcached, or in-memory distributed caching)
- Session state: In-memory ephemeral `Map<token, pairState>` via `backend/src/services/pairService.ts`

## Authentication & Identity

**Auth Provider:**
- **Firebase Authentication** (client + server)
  - Frontend: `firebase` (12.15.0) — client-side auth via Google OAuth and email/password
    - Config: `frontend/src/lib/firebase.ts` (initialized with `VITE_FIREBASE_*` env vars)
    - Methods: `signInWithPopup` (Google), `signInWithEmailAndPassword`, `createUserWithEmailAndPassword`, `sendEmailVerification`
    - Token: Frontend fetches ID token for API requests (Authorization header)
  - Backend: `firebase-admin` (14.1.0) — server-side claims and token validation
    - Config: `backend/src/db/firebase.ts` (cert-based initialization with `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`)
    - Usage: `backend/src/middleware/auth.ts` (verifies ID tokens), `billingService.ts` (sets custom claims: `tier`, `expires_at`)
    - Flow: User signs in → Firebase returns ID token → Frontend sends in Authorization header → Backend validates and checks custom claims

**Authorization:**
- Custom claims on Firebase: `tier` ('free' | 'paid'), `expires_at` (ISO string for PayNow expiry)
- Tier-gated features:
  - `practice` — Free (all users)
  - `aiHints` — Paid (requires `tier: 'paid'` claim)
  - `photoGrading` — Paid
  - `pairUpload` — Paid
  - `review` — Free
- Backend middleware: `backend/src/middleware/auth.ts` (requireAuth handler, 401/402 responses)
- Frontend callbacks: `setApiCallbacks()` in `frontend/src/lib/api.ts` (onUnauthorized → LoginModal, onPaymentRequired → UpgradeModal)

**Session Management:**
- No traditional server-side sessions
- Frontend: UUID v4 stored in localStorage as `session_id` (loaded in `frontend/src/lib/session.ts`)
- Stateless: Session ID passed in request body/query string to correlate attempts, chat history, gradings

## Monitoring & Observability

**Error Tracking:**
- Not detected (no Sentry, DataDog, or similar)
- Errors logged to console/stdout via `console.error()` calls

**Logs:**
- `console.log()` / `console.error()` in backend (prefixed by `dev.js` with `[backend]` label)
- Frontend errors: Standard browser console
- No centralized logging system detected

## CI/CD & Deployment

**Hosting:**
- Not detected from codebase (infrastructure not version-controlled)
- Likely: Vercel (frontend), Railway/Render/Heroku (backend) based on CLAUDE.md patterns

**CI Pipeline:**
- Not detected; no `.github/workflows/`, `.gitlab-ci.yml`, or similar

## Environment Configuration

**Required env vars (backend `.env`):**
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `GEMINI_API_KEY` (optional if hints/grading disabled)
- `GEMINI_MODEL` (optional, default `gemini-2.5-flash`)
- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `STRIPE_PRICE_MONTHLY`
- `STRIPE_PRICE_ANNUAL`
- `STRIPE_PRICE_MONTHLY_PAYNOW`
- `STRIPE_PRICE_ANNUAL_PAYNOW`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_CLIENT_EMAIL`
- `FIREBASE_PRIVATE_KEY`
- `PORT` (optional, default 3001)
- `CORS_ORIGIN` (optional, default 'https://yourproductiondomain.com' in prod)
- `FRONTEND_URL` (optional, default 'http://localhost:5173')
- `NODE_ENV` (optional, affects CORS origin selection)
- Rate limit overrides: `CHAT_RATE_LIMIT_PER_MIN`, `GRADE_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB`, `PAIR_TTL_MIN`

**Frontend env vars (`.env`):**
- `VITE_FIREBASE_API_KEY`
- `VITE_FIREBASE_AUTH_DOMAIN`
- `VITE_FIREBASE_PROJECT_ID`
- `VITE_FIREBASE_APP_ID`

**Secrets location:**
- Backend: `backend/.env` (committed as `.env.example` in repo; actual secrets never committed)
- Frontend: `.env` (Vite reads into `import.meta.env`)
- Both: Git ignored via `.gitignore` (assumed standard pattern)

## Webhooks & Callbacks

**Incoming:**
- **Stripe Webhooks** — `/api/billing/webhook` (requires `STRIPE_WEBHOOK_SECRET` for signature verification)
  - Events handled: `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `customer.deleted`
  - Payload: Raw JSON body, signature in `stripe-signature` header
  - Mounted before `express.json()` to access raw body (signature verification requirement)

**Outgoing:**
- **Socket.IO events** — `/socket.io` WebSocket connection for phone upload pairing
  - Desktop → Backend: `pair:subscribe` (join room for token), `pair:unsubscribe` (leave room)
  - Backend → Desktop: `pair:phone-connected`, `pair:image`, `pair:grading`, `pair:graded`, `pair:error`
  - Implementation: `backend/src/realtime.ts` (Socket.IO server attached to HTTP server), `emitToPair(token, event, payload)`
  - CORS: `{ origin: '*' }` to allow phone and desktop same-origin or direct connections

**Stripe Event Flow:**
1. Checkout completed → Stripe calls `/api/billing/webhook`
2. Backend verifies signature, looks up user by `stripe_customer_id`
3. Backend sets Firebase custom claims (`tier: 'paid'`, or `tier: 'paid'` + `expires_at` for PayNow)
4. Frontend calls `refreshTier()` on next auth state check → reads new claims → displays Premium UI

---

*Integration audit: 2026-07-04*
