# External Integrations

**Analysis Date:** 2026-06-29

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
- `requireAuth` — verifies `Authorization: Bearer <idToken>`, resolves/upserts user into Supabase `users` table, attaches `req.user = { uid: supabase_uuid, tier }`
- `gate(feature)` — composes `requireAuth` + tier check against `backend/src/config/featureTiers.ts`
- Tier is read from the decoded token's `tier` custom claim; defaults to `'free'`
- All tiers currently set to `'free'` in `featureTiers.ts` (gating infrastructure exists but not enforced)

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
- `localStorage` — session UUID (`session_id`), study plan (`study_plan_v1`), first-seed guard; managed in `frontend/src/lib/session.ts` and `frontend/src/lib/studyPlan.ts`

**Caching:** None

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

**Frontend (`frontend/.env`):**
- `VITE_FIREBASE_API_KEY`
- `VITE_FIREBASE_AUTH_DOMAIN`
- `VITE_FIREBASE_PROJECT_ID`
- `VITE_FIREBASE_APP_ID`

---

*Integration audit: 2026-06-29*
