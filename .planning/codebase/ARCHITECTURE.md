<!-- refreshed: 2026-06-26 -->
# Architecture

**Analysis Date:** 2026-06-26

## System Overview

```text
┌──────────────────────────────────────────────────────────────┐
│                    React SPA (Vite, port 5173)               │
│  pages/  hooks/  components/  lib/api.ts  lib/socket.ts      │
│  contexts/AuthContext.tsx  hooks/useFeature.ts               │
└──────────┬─────────────────────────┬────────────────────────┘
           │ HTTP /api/*             │ Auth (login/token)
           │ WebSocket /socket.io    │
           │                         ▼
           │               ┌─────────────────────┐
           │               │  Firebase Auth       │
           │               │  (Google + Email)    │
           │               │  ID token → client   │
           │               └─────────────────────┘
           │ Bearer token in Authorization header
           ▼
┌──────────────────────────────────────────────────────────────┐
│             Express + Socket.IO (Node, port 3001)            │
│   middleware/auth.ts (verifyIdToken, upsert user)            │
│   routes/  (thin)  →  services/  (logic)  →  db/  (clients) │
└──────────┬───────────────────────────────────────────────────┘
           │                                    │
           ▼                                    ▼
┌──────────────────┐                  ┌──────────────────────┐
│  Supabase (Postgres                 │  Gemini API           │
│  + Storage)       │                 │  (chat & grading)     │
│  db/supabase.ts  │                 │  db/gemini.ts         │
└──────────────────┘                 └──────────────────────┘
```

## Backend Layering

**Rule: routes never call Supabase directly. All DB/AI access goes through services.**

| Layer | Location | Responsibility |
|-------|----------|----------------|
| Routes | `backend/src/routes/*.ts` | Parse/validate request (Zod), call one service function, return JSON |
| Middleware | `backend/src/middleware/auth.ts` | Token verification (`verifyIdToken`), user upsert, `req.user` injection; `gate(feature)` for tier checks |
| Services | `backend/src/services/*.ts` | Business logic, orchestration, Supabase + Gemini calls |
| DB clients | `backend/src/db/supabase.ts`, `backend/src/db/gemini.ts`, `backend/src/db/firebase.ts` | Singleton client construction from env vars |
| Config | `backend/src/config/featureTiers.ts` | Maps feature names to minimum tier (`'free'` \| `'paid'`) — single source of truth for access control |
| Realtime | `backend/src/realtime.ts` | Socket.IO server init; `emitToPair()` for push events |
| Entry | `backend/src/index.ts` | Mounts all routers on `http.Server`, calls `initRealtime()`; CORS restricted to explicit origin allowlist |

The `http.Server` wrapper (not `app.listen`) is required so Socket.IO can attach to the same port.

## Frontend Architecture

**Single fetch layer:** all HTTP calls go through `frontend/src/lib/api.ts`. Two helpers:
- `request<T>()` — JSON endpoints
- `requestFormData<T>()` — multipart uploads (grade, pair photo)

**Auth identity:** `frontend/src/contexts/AuthContext.tsx` manages Firebase auth state via `onAuthStateChanged`. `useAuth()` provides `user`, `tier` (`'free'` | `'paid'` | `null` for guests), `openLoginModal()`, and `openUpgradeModal()`. All API calls in `api.ts` attach a `Bearer` token from `auth.currentUser?.getIdToken()`; 401 responses open the login modal, 402 responses open the upgrade modal. `frontend/src/hooks/useFeature.ts` maps feature names to tier requirements and is used to show/hide UI elements — the backend `gate()` middleware is the actual enforcement boundary.

**State layer:** custom hooks in `frontend/src/hooks/` own data fetching and derived state. Pages are thin consumers.

**Routing:** `frontend/src/App.tsx` defines a `createBrowserRouter` tree. `RootLayout` wraps all main routes with `<Header>`; `/m/:token` (`MobileUploadPage`) is standalone with no chrome.

## Practice State Machine

Managed by `useReducer` in `frontend/src/hooks/usePracticeSession.ts`.

```
loading
  │ LOAD_SUCCESS
  ▼
answering  ◄─── RETRY / GRADE_REJECTED (soft error, stay on question)
  │ SUBMIT_START / GRADE_START
  ▼
submitted
  │ SUBMIT_SUCCESS / GRADE_SUCCESS / PART_SUBMIT_DONE (all parts done)
  ▼
revealed
  │ next question triggered
  ▼
loading  (cycle repeats)

  (any step) → ERROR  → error phase (network/server failure)
  (no more questions) → complete
```

**Multi-part questions:** each part has its own `PartState` (`idle → submitting → done`). The overall phase transitions to `revealed` only when `solution_latex` is returned by the server (i.e., all graded parts have been submitted).

## AI Hint Chatbot Flow

```
PracticePage → ChatPanel → useChatSession
  → api.chat.send()
  → POST /api/chat  (routes/chat.ts)
  → chatService.sendMessage()   (services/chatService.ts)
      buildSystemInstruction()  — injects question + solution_latex (server-only)
  → Gemini API  (db/gemini.ts, gemini-2.5-flash)
  → persist to chat_messages table
  → return { reply, history }
```

Rate-limited by `express-rate-limit` (IP-keyed). Protected by `gate('aiHints')` — requires login; tier can be raised to `'paid'` in `featureTiers.ts` when subscription is introduced. History rehydrated on page load via `GET /api/chat`. `correct_answer` and `solution_latex` are never returned to the browser.

## Photo Grading Pipeline

```
PhotoAnswer.tsx → usePracticeSession.submitPhotos()
  → api.grade.submit()  (multipart/form-data)
  → POST /api/grade  (routes/grade.ts, multer)
  → gradingService.gradeSolution()  (services/gradingService.ts)
      buildGradingInstruction()  — injects solution_latex (confidential)
      STEP 0: junk filter (blank/irrelevant → ignored_images)
      if gradable=false → GradingError (HTTP 400), no DB writes
  → Gemini vision API  (db/gemini.ts, structured JSON output)
  → upload images to Supabase Storage (solution-uploads bucket)
  → insert gradings row + attempts rows per graded part
  → return GradeResponse to client
```

Rejected photos (`GRADE_REJECTED` action) keep the student in `answering` phase to retake. Accepted grades dispatch `GRADE_SUCCESS` → `revealed`.

## Socket.IO Phone Pairing Flow

```
Desktop: QrPairModal → POST /api/pair → { token, mobile_path }
         → usePairSocket subscribes: socket.emit('pair:subscribe', { token })

Phone:   /m/:token (MobileUploadPage)
         → GET /api/pair/:token  → emitToPair(token, 'pair:phone-connected')
         → POST /api/pair/:token/photo  → emitToPair(token, 'pair:image', dataUrl)
         → POST /api/pair/:token/done
             → gradeSolution()  (same as local grading pipeline)
             → emitToPair(token, 'pair:grading')
             → emitToPair(token, 'pair:graded', GradeResponse)
                         OR 'pair:error'

Desktop: usePairSocket receives events → calls into usePracticeSession:
           beginExternalGrading() / receiveGrading() / rejectExternalGrading()
```

Auth = possession of the unguessable 32-byte base64url token. Token TTL default 10 minutes (in-memory `Map` in `pairService.ts`).

## Error Handling

**Backend:** services throw typed errors (e.g., `GradingError`, `ChatLimitError`); routes catch and map to HTTP status codes. Zod parse failures return 400.

**Frontend:** `api.ts` throws `Error` with the server's `error` field as the message. Hooks dispatch `ERROR` action → `error` phase → `<ErrorMessage>` component. Photo grading uses the softer `GRADE_REJECTED` path to avoid dropping to the error screen.

## Feature Gating

All feature-to-tier assignments live in `backend/src/config/featureTiers.ts`:

```typescript
export const FEATURE_TIERS: Record<string, 'free' | 'paid'> = {
  practice:     'free',
  aiHints:      'free',
  photoGrading: 'free',
  pairUpload:   'free',
}
```

Routes apply `gate(feature)` middleware, which enforces the tier check and returns 402 for insufficient tier. To move a feature behind a paywall, change its value in `featureTiers.ts` — no route changes needed.

The frontend `useFeature(feature)` hook mirrors this config for UX gating (hiding buttons, showing prompts) but is **not** a security boundary. The backend middleware is always authoritative.

---

## Anti-Patterns

### Calling Supabase from a route
**What happens:** route handler imports `supabase` and queries directly.
**Why it's wrong:** bypasses service layer, scatters business logic, makes testing harder.
**Do this instead:** delegate to the corresponding service in `backend/src/services/`.

### Using `loadNext()` when a specific question is intended
**What happens:** `loadNext()` called from the drawer or a `?question_id=` URL.
**Why it's wrong:** `loadNext()` fetches a random unanswered question; under StrictMode double-invoke it may return different questions.
**Do this instead:** use `loadSpecific(id)` for all drawer clicks and `?question_id=` param reads.

---

*Architecture analysis: 2026-06-26 — updated 2026-06-26 to reflect Firebase Auth + feature gating*
