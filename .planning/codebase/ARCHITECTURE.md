<!-- refreshed: 2026-06-28 -->
# Architecture

**Analysis Date:** 2026-06-28

## System Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                   React 19 SPA (port 5173)                  │
│                 `frontend/src/`                             │
├──────────────┬──────────────────┬───────────────────────────┤
│   Pages      │   Hooks (state)  │     Components (UI)       │
│ `pages/`     │ `hooks/`         │  `components/`            │
└──────┬───────┴────────┬─────────┴────────────┬──────────────┘
       │                │                       │
       ▼                ▼                       ▼
┌─────────────────────────────────────────────────────────────┐
│              lib/api.ts  (fetch + Firebase auth header)     │
│              lib/firebase.ts  (Firebase Auth client SDK)    │
└─────────────────────────────┬───────────────────────────────┘
                              │  HTTP /api/*  +  Socket.IO
                              ▼
┌─────────────────────────────────────────────────────────────┐
│             Express + TypeScript backend (port 3001)        │
│             `backend/src/`                                  │
├──────────────┬──────────────────┬───────────────────────────┤
│  routes/     │  services/       │   db/                     │
│  (thin HTTP  │  (business       │   supabase.ts             │
│   handlers)  │   logic)         │   firebase.ts             │
│              │                  │   gemini.ts               │
└──────────────┴────────┬─────────┴────────────┬──────────────┘
                        │                       │
                        ▼                       ▼
              ┌──────────────────┐   ┌──────────────────────┐
              │  Supabase (PG)   │   │  Firebase Admin SDK  │
              │  (data storage)  │   │  (ID token verify)   │
              └──────────────────┘   └──────────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| `index.ts` | Express app + Socket.IO bootstrap | `backend/src/index.ts` |
| `realtime.ts` | Socket.IO server for QR phone-upload pairing | `backend/src/realtime.ts` |
| `middleware/auth.ts` | Firebase ID token verification + tier gate | `backend/src/middleware/auth.ts` |
| `config/featureTiers.ts` | Maps feature name → required tier | `backend/src/config/featureTiers.ts` |
| `db/supabase.ts` | Single Supabase client (service role) | `backend/src/db/supabase.ts` |
| `db/firebase.ts` | Firebase Admin SDK singleton | `backend/src/db/firebase.ts` |
| `db/gemini.ts` | Google Generative AI client | `backend/src/db/gemini.ts` |
| `routes/*` | Thin HTTP handlers — parse, validate (Zod), delegate to service | `backend/src/routes/` |
| `services/*` | All business logic, Supabase queries, answer grading | `backend/src/services/` |
| `App.tsx` | Router setup + RootLayout with Header + StudyPlanSidebar | `frontend/src/App.tsx` |
| `lib/api.ts` | Typed fetch wrapper — injects Firebase auth header | `frontend/src/lib/api.ts` |
| `lib/firebase.ts` | Firebase Auth client SDK init | `frontend/src/lib/firebase.ts` |
| `lib/socket.ts` | Socket.IO client singleton | `frontend/src/lib/socket.ts` |
| `contexts/AuthContext.tsx` | Firebase auth state, `LoginModal` trigger, `setApiCallbacks` | `frontend/src/contexts/AuthContext.tsx` |
| `contexts/ThemeContext.tsx` | Dark/light theme toggle | `frontend/src/contexts/ThemeContext.tsx` |
| `hooks/usePracticeSession.ts` | Practice state machine (loading→answering→submitted→revealed→complete\|error) | `frontend/src/hooks/usePracticeSession.ts` |
| `hooks/useChatSession.ts` | Optimistic AI hint chat state | `frontend/src/hooks/useChatSession.ts` |
| `hooks/usePairSocket.ts` | Phone QR-upload Socket.IO events → `usePracticeSession` | `frontend/src/hooks/usePairSocket.ts` |
| `pages/PracticePage.tsx` | Practice UI — question, answer input, tabs | `frontend/src/pages/PracticePage.tsx` |
| `pages/HomePage.tsx` | Roadmap pan/zoom + TopicDrawer | `frontend/src/pages/HomePage.tsx` |

## Pattern Overview

**Overall:** Layered monorepo (frontend SPA / backend REST API)

**Key Characteristics:**
- Backend is strictly layered: routes → services → db clients. Routes never call `supabase` directly.
- All API calls on the frontend go through `lib/api.ts`; no component calls `fetch` directly.
- Firebase handles authentication; Supabase handles data storage. The backend bridges them — it verifies the Firebase ID token and resolves/upserts a row in `supabase.users`.
- Business logic (answer normalisation, grading, spaced repetition, chat prompt) lives entirely in `backend/src/services/`.

## Layers

**Routes Layer:**
- Purpose: Parse HTTP requests, validate body/query with Zod, call one service function, return HTTP response
- Location: `backend/src/routes/`
- Contains: `attempts.ts`, `chat.ts`, `concepts.ts`, `grade.ts`, `pair.ts`, `questions.ts`, `review.ts`, `stars.ts`, `streaks.ts`, `topics.ts`
- Depends on: `services/`, `middleware/auth.ts`, `zod`
- Used by: Express app in `backend/src/index.ts`

**Services Layer:**
- Purpose: All business logic — answer grading, AI prompt building, spaced-repetition scheduling, solution hiding, Supabase queries
- Location: `backend/src/services/`
- Contains: `attemptService.ts`, `chatService.ts`, `conceptService.ts`, `diagnosticService.ts`, `gradingService.ts`, `pairService.ts`, `questionService.ts`, `reviewService.ts`, `spacedRepetitionService.ts`, `starService.ts`, `streakService.ts`, `topicService.ts`
- Depends on: `db/supabase.ts`, `db/gemini.ts`
- Used by: `routes/`

**DB / Client Layer:**
- Purpose: Singleton clients for external services
- Location: `backend/src/db/`
- Contains: `supabase.ts` (Supabase JS client), `firebase.ts` (Firebase Admin), `gemini.ts` (Google Generative AI)
- Depends on: env vars only
- Used by: `services/`, `middleware/auth.ts`

**Frontend Pages:**
- Purpose: Top-level route components — own page-level state and compose hooks + components
- Location: `frontend/src/pages/`
- Depends on: `hooks/`, `components/`, `lib/api.ts`

**Frontend Hooks:**
- Purpose: State machines and data-fetching logic; reusable across pages
- Location: `frontend/src/hooks/`
- Depends on: `lib/api.ts`, `lib/socket.ts`
- Used by: Pages

**Frontend Components:**
- Purpose: Presentational UI; receive props, emit events via callbacks
- Location: `frontend/src/components/`
- Subdivided by: `chat/`, `layout/`, `math/`, `pair/`, `progress/`, `question/`, `sidebar/`, `topic/`, `ui/`

**Frontend Lib:**
- Purpose: Singletons and pure utilities shared across the frontend
- Location: `frontend/src/lib/`
- Contains: `api.ts`, `firebase.ts`, `socket.ts`, `renderLatex.tsx`, `utils.ts`, `studyPlan.ts`

## Data Flow

### Practice Answer Submission (typed)

1. User types in `MathField.tsx` → submits in `AnswerInput.tsx` (`frontend/src/components/question/`)
2. `usePracticeSession.submitAnswer()` dispatches `SUBMIT_START`, calls `api.attempts.submit()`
3. `lib/api.ts` `request()` attaches Firebase Bearer token, POSTs to `/api/attempts`
4. `backend/src/routes/attempts.ts` validates with Zod, calls `submitAttempt(req.user.uid, body)`
5. `backend/src/services/attemptService.ts` fetches question, normalises LaTeX, grades answer, inserts attempt row via `supabase`
6. Returns `{ is_correct, correct_answer, solution_latex }` (solution only revealed after all parts)
7. `usePracticeSession` dispatches `SUBMIT_SUCCESS` → state transitions to `submitted` or `revealed`

### Photo Grading Flow

1. `PhotoAnswer.tsx` collects images → `usePracticeSession.submitPhotos()`
2. `lib/api.ts` `requestFormData()` POSTs multipart to `/api/grade`
3. `backend/src/routes/grade.ts` → `gradingService.gradeSolution()` → Gemini vision via `db/gemini.ts`
4. Structured JSON response graded per-part; images uploaded to Supabase Storage on success
5. One `gradings` row + one `attempts` row per graded part inserted
6. `GradingResult.tsx` renders per-part verdict

### QR Phone-Upload Flow

1. Desktop: `QrPairModal.tsx` POSTs `/api/pair` → receives `{ token, mobile_path }`
2. Desktop subscribes to Socket.IO room via `usePairSocket` / `lib/socket.ts`
3. Phone opens `/m/:token` → `MobileUploadPage.tsx` (standalone route, no RootLayout)
4. Phone POSTs photos to `/api/pair/:token/photo` → backend emits `pair:image` to desktop room
5. Phone POSTs `/api/pair/:token/done` → backend calls `gradeSolution()`, emits `pair:graded` or `pair:error`
6. `usePairSocket` forwards events into `usePracticeSession` via `beginExternalGrading` / `receiveGrading`

**State Management:**
- Backend: stateless (all state in Supabase), except in-memory `Map` for active pair tokens in `pairService.ts`
- Frontend: local React state via `useReducer` in `usePracticeSession`; `session_id` UUID persisted in `localStorage` via `lib/session.ts`

## Key Abstractions

**`gate(feature)` middleware:**
- Purpose: Compose `requireAuth` + tier check into a 2-element `RequestHandler[]` array
- Location: `backend/src/middleware/auth.ts`
- Usage: `router.post('/', ...gate('practice'), handler)`

**`api` object (frontend):**
- Purpose: Namespace-grouped typed fetch calls; every backend endpoint has a corresponding `api.*.method()` call
- Location: `frontend/src/lib/api.ts`
- Pattern: `api.attempts.submit(body)`, `api.grade.submit(formData)`, `api.chat.send(body)`

**Practice state machine:**
- Purpose: Model the lifecycle of one question attempt
- States: `loading → answering → submitted → revealed → complete | error`
- Location: `frontend/src/hooks/usePracticeSession.ts` (useReducer)

**`emitToPair(token, event, payload)`:**
- Purpose: Decouple Socket.IO from route handlers; routes import this function, not `io` directly
- Location: `backend/src/realtime.ts`

## Entry Points

**Backend:**
- Location: `backend/src/index.ts`
- Triggers: `npm run dev` (tsx watch) or compiled `node dist/index.js`
- Responsibilities: Creates Express app, mounts all routers, creates `http.Server`, calls `initRealtime()`

**Frontend:**
- Location: `frontend/src/main.tsx`
- Triggers: Vite dev server or built `dist/index.html`
- Responsibilities: Renders `<App />` into `#root`

**Mobile Upload:**
- Location: `frontend/src/pages/MobileUploadPage.tsx` at route `/m/:token`
- Responsibilities: Standalone page; no header/auth — camera capture + photo relay via HTTP

## Architectural Constraints

- **Module resolution:** Backend uses `NodeNext` — all imports must include `.js` extension (e.g. `import { supabase } from '../db/supabase.js'`)
- **No `supabase` in routes:** Routes call services only; `supabase` client is imported only in `backend/src/services/` and `backend/src/middleware/auth.ts`
- **No `fetch` in components:** All API calls go through `frontend/src/lib/api.ts`
- **Global state:** Pair token map is module-level in `pairService.ts` (in-memory, lost on restart); Socket.IO `io` instance is module-level in `realtime.ts`
- **Socket.IO on `http.Server`:** Express `app.listen()` must NOT be used — `http.createServer(app)` + `initRealtime(httpServer)` is required for Socket.IO to attach
- **Strict TypeScript, no `any`:** Backend enforces this; Zod validates all `req.body`/`req.query`

## Anti-Patterns

### Calling Supabase from a route handler

**What happens:** A route file imports `supabase` and queries the DB directly.
**Why it's wrong:** Bypasses the service layer; makes the route untestable and breaks the layered contract.
**Do this instead:** All DB access goes through a service function in `backend/src/services/`. Routes only parse, validate, and delegate.

### Using `fetch` directly in a React component

**What happens:** A component or hook calls `fetch('/api/...')` without going through `lib/api.ts`.
**Why it's wrong:** Skips Firebase auth header injection and the centralised 401/402 error handling callbacks.
**Do this instead:** Use `api.*` methods from `frontend/src/lib/api.ts`.

### Using `firstLoad` refs to guard StrictMode double-invoke

**What happens:** A `useRef(false)` guards the first `useEffect` call to prevent double data fetch.
**Why it's wrong:** React StrictMode double-invokes effects intentionally; `loadNext()` and `loadSpecific()` are idempotent and safe to call twice.
**Do this instead:** Keep data-loading functions idempotent; do not add `firstLoad` guards.

## Error Handling

**Strategy:** Services throw typed `Error` instances with descriptive messages; route handlers catch and map to HTTP status codes.

**Patterns:**
- `ZodError` → 400 with `details`
- `message.includes('not found')` → 404
- `ChatLimitError` → 429
- `GradingError` (gradable=false) → 400
- Default → 500

## Cross-Cutting Concerns

**Logging:** `console.log` / `console.error` only — no structured logging framework
**Validation:** Zod in every route that accepts a request body or query params
**Authentication:** Firebase ID token verified by `requireAuth` in `backend/src/middleware/auth.ts`; all protected routes use `gate(feature)`

---

*Architecture analysis: 2026-06-28*
