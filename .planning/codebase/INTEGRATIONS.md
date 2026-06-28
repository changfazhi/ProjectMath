# External Integrations

**Analysis Date:** 2026-06-28

## APIs & External Services

**AI / Machine Learning:**
- Google Gemini (via `@google/genai`) — powers two features:
  1. Socratic hint chatbot (`backend/src/services/chatService.ts` → `backend/src/db/gemini.ts`)
  2. Photo-based handwritten solution grading (`backend/src/services/gradingService.ts` → `backend/src/db/gemini.ts`)
  - SDK: `@google/genai` 2.9.0 (backend only — API key never exposed to browser)
  - Auth: `GEMINI_API_KEY` env var
  - Default model: `gemini-2.5-flash` (overridable via `GEMINI_MODEL` env var)
  - Client is lazily constructed in `backend/src/db/gemini.ts` (`getGemini()`) so server boots without the key

## Data Storage

**Databases:**
- Supabase (PostgreSQL)
  - Connection: `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY` env vars
  - Client: `@supabase/supabase-js` 2.45 — initialized in `backend/src/db/supabase.ts`
  - All database access goes through the backend service layer; client is never used in the frontend
  - Tables: `topics`, `questions`, `attempts`, `topic_concepts`, `starred_questions`, `chat_messages`, `gradings`, `users` (and more via SQL migrations in project root)
  - Row-level security: grants required after each `CREATE TABLE` (documented in CLAUDE.md)

**File Storage:**
- Supabase Storage — `solution-uploads` private bucket
  - Used by photo grading: images uploaded after successful Gemini grading
  - Created in migration `013_solution_gradings.sql`

**Caching:**
- None detected — no Redis, Memcached, or in-process cache library

**In-Memory State:**
- `backend/src/services/pairService.ts` — `Map` of active phone-upload pairing tokens (ephemeral, lost on restart, TTL via `PAIR_TTL_MIN`)

## Authentication & Identity

**Auth Provider:**
- Firebase Authentication
  - Frontend SDK: `firebase` 12.15 (`frontend/src/lib/firebase.ts`) — initializes `getAuth(app)` with `VITE_FIREBASE_*` env vars; used for client-side sign-in flows
  - Backend SDK: `firebase-admin` 14.1 (`backend/src/db/firebase.ts`) — verifies Bearer tokens via `getAuth(getFirebaseAdmin()).verifyIdToken(token)`
  - Backend auth middleware: `backend/src/middleware/auth.ts` — `requireAuth()` decodes token, upserts user into Supabase `users` table, attaches `req.user = { uid, tier }` for downstream handlers
  - `gate(feature)` middleware (`backend/src/middleware/auth.ts`) enforces tier-based feature access via `FEATURE_TIERS` (`backend/src/config/featureTiers.ts`)
  - Firebase Admin initialized lazily; requires `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` env vars

**Tier / Feature Gating:**
- `backend/src/config/featureTiers.ts` — `FEATURE_TIERS` map of feature → `'free' | 'paid'`
- Currently all features (`practice`, `aiHints`, `photoGrading`, `pairUpload`, `review`) are `'free'`
- `tier` claim read from Firebase ID token (`decoded['tier']`)

## Real-Time Communication

**Socket.IO:**
- Server: `socket.io` 4.8.3 — attached to `http.Server` in `backend/src/realtime.ts`
- Client: `socket.io-client` 4.8.3 — `frontend/src/lib/socket.ts` (same-origin `io()`)
- Events:
  - `pair:subscribe` / `pair:unsubscribe` — desktop joins/leaves token room
  - `pair:phone-connected` — phone opens mobile upload page
  - `pair:image` — phone photo streamed to desktop
  - `pair:grading` / `pair:graded` / `pair:error` — grading lifecycle
- Dev: Vite proxies `/socket.io` as WebSocket to `ws://localhost:3001` (`frontend/vite.config.ts`)

## Monitoring & Observability

**Error Tracking:**
- None detected — no Sentry, Datadog, or similar

**Logs:**
- `console.log` / `console.error` only — no structured logging library

## CI/CD & Deployment

**Hosting:**
- Not specified — no platform config detected (no Dockerfile, `render.yaml`, `fly.toml`, Vercel config, etc.)

**CI Pipeline:**
- None detected — no `.github/workflows/`, CircleCI, or similar config

## Environment Configuration

**Required backend env vars:**
- `SUPABASE_URL` — Supabase project URL
- `SUPABASE_SERVICE_ROLE_KEY` — Supabase service role key (full DB access)
- `GEMINI_API_KEY` — Google Gemini API key
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` — Firebase Admin SDK credentials

**Required frontend env vars:**
- `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID`

**Secrets location:**
- Backend: `backend/.env` (not committed; `.env.example` template provided)
- Frontend: `frontend/.env` (Vite exposes only `VITE_*` prefixed vars to the browser)
- Firebase Admin private key: `FIREBASE_PRIVATE_KEY` in backend env, with `\\n` → `\n` replacement applied at init time (`backend/src/db/firebase.ts`)

## Webhooks & Callbacks

**Incoming:**
- None — no webhook receiver endpoints detected

**Outgoing:**
- None — all external calls are request-initiated (Gemini API, Supabase SDK)

---

*Integration audit: 2026-06-28*
