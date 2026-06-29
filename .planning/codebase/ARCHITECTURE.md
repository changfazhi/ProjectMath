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

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| **Pages** | Route handlers; fetch data via hooks; compose layouts | `src/pages/*.tsx` |
| **Hooks** | State machines, data fetching, cancellation, caching | `src/hooks/*.ts` |
| **Components (UI)** | Reusable button, card, spinner, badge, modal | `src/components/ui/` |
| **Components (Topic)** | Roadmap, drawer, question table, concepts | `src/components/topic/` |
| **Components (Question)** | Input types, multi-part, photo, grading result | `src/components/question/` |
| **Components (Math)** | LaTeX rendering (inline/block), MathLive editor, keyboard | `src/components/math/` |
| **Components (Chat)** | AI hint chatbot panel; message history | `src/components/chat/` |
| **Components (Progress)** | Stats bar (streak, session counts), attempt history | `src/components/progress/` |
| **Components (Pair)** | QR modal for phone pairing; mobile upload page | `src/components/pair/` |
| **API Layer** | Fetch wrapper with auth; grouped by domain (topics, questions, attempts, etc.) | `src/lib/api.ts` |
| **Socket** | Singleton Socket.IO connection for real-time pairing | `src/lib/socket.ts` |
| **LaTeX Renderer** | Parse mixed text+math; dispatch to Latex/LatexBlock | `src/lib/renderLatex.tsx` |
| **Auth Context** | Firebase auth state; login/upgrade modals; tier | `src/contexts/AuthContext.tsx` |
| **Theme Context** | Light/dark mode toggle; read from localStorage | `src/contexts/ThemeContext.tsx` |

## Pattern Overview

**Overall:** Modern React SPA with reducer-based state machines, hook-driven data fetching, Firebase Auth identity, and real-time Socket.IO for phone pairing.

**Key Characteristics:**
- **Firebase Auth** — Google + email login; ID tokens verified server-side; user identity from `req.user.uid`
- **Feature gating** — `gate(feature)` middleware on backend; `useFeature(feature)` hook on frontend
- **No global state manager** — local component state + contexts (auth, theme) only
- **Reducer state machines** — complex UI flows (practice session) use `useReducer` with typed actions
- **Optimistic UI** — chat messages roll back on error; stars flip locally then sync
- **Cancellation-aware** — hooks track `cancelled` flag to prevent state leaks after unmount
- **Separation of concerns** — API calls isolated in `lib/api.ts`, never called from routes directly
- **Strict TypeScript** — no `any`; types mirror backend API models

## Layers

**Page Layer:**
- Purpose: Route handlers; map URL params to hook calls; compose layouts
- Location: `src/pages/`
- Contains: HomePage, PracticePage, HistoryPage, StarredPage, StatsPage, ReviewPage, MobileUploadPage
- Depends on: Hooks, components, API types
- Used by: React Router

**Hook Layer (State + Data):**
- Purpose: Encapsulate state machines, data fetching, side-effect logic
- Location: `src/hooks/`
- Contains: `usePracticeSession` (reducer + methods), `useTopics`, `useChatSession`, `usePairSocket`, `useFeature`, etc.
- Depends on: `lib/api.ts`, `lib/socket.ts`, `contexts/AuthContext`, types
- Used by: Pages, components

**Component Layer (UI):**
- Purpose: Render UI; accept props; dispatch events to parents
- Location: `src/components/` (organized by domain: ui, topic, question, math, chat, progress, pair, layout)
- Contains: Buttons, cards, spinners, math editors, question cards, topic roadmaps, login modal, upgrade modal, etc.
- Depends on: Types, utils (cn, formatTime), renderLatex
- Used by: Pages, other components

**Library Layer (Utilities):**
- Purpose: Centralized cross-cutting concerns
- Location: `src/lib/`
- Contains: API wrapper with auth (`api.ts`), socket singleton (`socket.ts`), LaTeX renderer (`renderLatex.tsx`), Tailwind utilities (`utils.ts`)
- Depends on: External (fetch, socket.io-client, katex, firebase)
- Used by: All layers

**Context Layer:**
- Purpose: Global UI and auth state
- Location: `src/contexts/`
- Contains: AuthContext (Firebase state, tier, modals), ThemeContext (light/dark)
- Depends on: React, Firebase SDK
- Used by: Root App, hooks

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

## Data Flow

### Primary Request Path (Practice Session)

1. **Load question** (`PracticePage` mount or click)
   - Calls `session.loadNext()` or `session.loadSpecific(id)` from `usePracticeSession`
   - Invokes `api.questions.next()` or `api.questions.get()` — Bearer token attached by `api.ts`
   - Backend returns `QuestionPublic` (LaTeX prompt, answer type, parts if multi-part)

2. **Submit answer (typed)**
   - Calls `api.attempts.submit({ question_id, answer_given, time_taken_s })` with Bearer token
   - Backend (`gate('practice')`) verifies token → grades against `question.correct_answer`
   - Returns `{ is_correct, correct_answer, solution_latex }` → session moves to `revealed`

3. **Submit photo (handwritten)**
   - Calls `api.grade.submit(questionId, images[], timeTakenS)` with Bearer token
   - Backend (`gate('photoGrading')`) returns structured grading; persists to `gradings` + `attempts` tables
   - On junk photo (`gradable=false`) → `GRADE_REJECTED` → student stays in `answering` to retake

4. **Multi-part flow**
   - Each part submits individually; overall phase transitions to `revealed` when `solution_latex` is returned (all graded parts done)

### Secondary Flow: Phone Upload Pairing

1. Desktop calls `api.pair.create(questionId)` with Bearer token → gets `{ token, mobile_path }`; subscribes to socket room
2. Phone opens `/m/:token`, snaps photos via `api.pair.uploadPhoto()` — desktop sees live preview via `pair:image`
3. Phone hits "Done" → backend grades via `gradeSolution()` → emits `pair:graded` → desktop transitions to `revealed`

### Secondary Flow: AI Hint Chat

1. User opens Hints tab → `api.chat.history(questionId)` with Bearer token rehydrates messages from `chat_messages`
2. User sends message → `api.chat.send(questionId, text)` → backend (`gate('aiHints')`) calls Gemini → returns `{ reply, history }`
3. Optimistic send with rollback on error; history persisted per Firebase UID + question_id

## State Management

- **Auth state:** `AuthContext` (Firebase UID, tier, `onAuthStateChanged` listener)
- **Practice session:** Reducer-based state machine with explicit `PracticePhase` states
- **Topics/questions:** Simple useState with loading/error (via `useTopics`, `useTopicQuestions`)
- **Chat messages:** useState + optimistic updates with rollback
- **Stars:** Optimistic flip locally; sync to server asynchronously
- **Theme:** Context + localStorage

## Key Abstractions

**Practice State Machine:**
- Purpose: Orchestrate complex question-answering flow (load → answer → submit → reveal → navigate)
- Location: `src/hooks/usePracticeSession.ts`
- Pattern: `useReducer` with typed discriminated unions for actions; phase-driven UI logic in pages/components

**API Client:**
- Purpose: Single entry point for all backend communication; attaches Firebase Bearer token; type-safe request/response
- Location: `src/lib/api.ts` → grouped by domain (topics, questions, attempts, stars, chat, grade, pair, review)
- Pattern: Namespace objects with methods that return `request<T>()` or `requestFormData<T>()`

**Custom Hooks:**
- Purpose: Isolate data fetching, caching, and error handling
- Examples: `useTopics()`, `useChatSession()`, `usePairSocket()`, `useAttemptHistory()`
- Pattern: useState for data/loading/error; useEffect for fetch; cleanup with `cancelled` flag

**Auth Context:**
- Purpose: Firebase auth state; login/upgrade modals; tier-based feature gating on frontend
- Location: `src/contexts/AuthContext.tsx`
- Pattern: `onAuthStateChanged` listener; `useAuth()` hook for consumers; `openLoginModal()` called from `api.ts` on 401

## Entry Points

**App Root:** `src/main.tsx` → `createRoot()` → `src/App.tsx` — bootstraps React, sets up router, auth context, and theme context.

**Router:** `src/App.tsx` → `createBrowserRouter()`. Routes: `/` (HomePage), `/practice/:topicId` (PracticePage), `/m/:token` (MobileUploadPage, standalone), `/history`, `/starred`, `/stats`, `/review`.

**HTTP API:** `src/lib/api.ts` → `request()` / `requestFormData()`. Bearer token from `auth.currentUser?.getIdToken()` attached to every request. Backend target: `http://localhost:3001/api/*` (dev via Vite proxy).

**Socket.IO:** `src/lib/socket.ts` → `getSocket()` singleton. Events: `pair:subscribe`, `pair:phone-connected`, `pair:image`, `pair:grading`, `pair:graded`, `pair:error`.

## Architectural Constraints

- **Auth:** Firebase ID tokens (JWTs) verified server-side by `requireAuth` middleware; guest access allowed on public GET routes only
- **Routing:** React Router SPA; no server-side rendering
- **Global state:** Only Auth context, Theme context, and socket.io-client singleton; no Redux/Zustand/Recoil
- **API calls:** Always via `lib/api.ts` wrapper; never direct `fetch()` from components or pages
- **Component state:** Local `useState` or reducer; never prop drilling beyond 1–2 levels
- **Async safety:** All fetch hooks track `cancelled` flag to prevent state updates after unmount
- **Circular imports:** None detected; module dependency graph is acyclic

## AI Hint Chatbot Flow

```
PracticePage → ChatPanel → useChatSession
  → api.chat.send()
  → POST /api/chat  (routes/chat.ts, gate('aiHints'))
  → chatService.sendMessage()   (services/chatService.ts)
      buildSystemInstruction()  — injects question + solution_latex (server-only)
  → Gemini API  (db/gemini.ts, gemini-2.5-flash)
  → persist to chat_messages table
  → return { reply, history }
```

Rate-limited by `express-rate-limit` (IP-keyed). Protected by `gate('aiHints')` — requires login; tier can be raised to `'paid'` in `featureTiers.ts` when subscription is introduced. `correct_answer` and `solution_latex` are never returned to the browser.

## Photo Grading Pipeline

```
PhotoAnswer.tsx → usePracticeSession.submitPhotos()
  → api.grade.submit()  (multipart/form-data, gate('photoGrading'))
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

### Access Level Reference

| Who | `'free'` feature | `'paid'` feature |
|---|---|---|
| Guest (not signed in) | blocked → login modal | blocked → login modal |
| Signed-in free user | allowed | blocked → upgrade modal |
| Paid user | allowed | allowed |

To change a feature's access level, edit **both**:
1. `backend/src/config/featureTiers.ts` — enforcement (security boundary)
2. `frontend/src/hooks/useFeature.ts` — UX gating (keep in sync manually)

---

## Weakness Diagnostic & Study Plan Flow

### Unlock gate

Both the Weakness Diagnostic and the Personalised Study Plan require **≥ 5 unique questions attempted** before they unlock. The check lives in `backend/src/services/diagnosticService.ts → buildTopicStats()`:

```typescript
const uniqueQuestionsAttempted = new Set(attempts.map(a => a.question_id)).size
if (uniqueQuestionsAttempted < 5) throw new Error('Attempt at least 5 unique questions…')
```

`buildTopicStats` is called by both `getWeaknessDiagnosis` and `getPersonalisedStudyPlan`, so the gate is enforced at both endpoints. The backend returns HTTP 403 for the diagnosis endpoint and HTTP 500 (with the same message) for the study-plan endpoint when below the threshold.

The frontend `ReviewPage` mirrors this gate: it reads `streaks.uniqueQuestionsAttempted` (returned by `GET /api/streaks`) and renders the Weakness Diagnostic card in a locked, non-interactive state until the count reaches 5. The lock message counts down: "N to go". `uniqueQuestionsAttempted` is a dedicated field on `StreakStats` (distinct from `totalAttempts`) so retrying the same question multiple times does not count toward the threshold.

### Weakness Diagnostic flow

```
ReviewPage → handleDiagnosis() → api.review.diagnosis()
  → GET /api/review/diagnosis  (routes/review.ts, gate('review'))
  → getWeaknessDiagnosis(uid)  (services/diagnosticService.ts)
      buildTopicStats(uid)      — 3 Supabase queries (topics, questions, attempts)
      Gemini API                — classifies topics as weak/moderate/strong + ai_insight per topic
  → DiagnosisResult displayed inline on ReviewPage (no navigation)
```

The diagnosis result is ephemeral — it is never persisted. Re-clicking the button calls Gemini again. The "Today's Personalised Study Plan" CTA is only rendered after `diagState === 'shown'`, so the plan button is unreachable until a successful diagnosis.

### Study Plan generation & pre-fetch pattern

The study plan is generated **algorithmically** (no second Gemini call). Generation happens inside `handleStudyPlan()` on `ReviewPage`, not on `StudyPlanPage`. This pre-fetch pattern means the loading spinner shows on the page the user is already looking at, and `StudyPlanPage` renders instantly from cache.

```
ReviewPage → handleStudyPlan()
  1. Check localStorage for today's plan (PLAN_KEY = 'study_plan_v1', date = en-CA string)
  2. If absent → api.review.studyPlan()
       → GET /api/review/study-plan  (gate('review'))
       → getPersonalisedStudyPlan(uid)  (diagnosticService.ts)
           buildTopicStats(uid)  — same 3 Supabase queries as diagnosis
           3 more Supabase queries (all questions, attempts, topic names)
           Select up to 10 unsolved questions from weakest topics (algorithmic)
       → { items, reasoning }
  3. savePlan(planData)                          — synchronous localStorage write
  4. savePlanRemote(uid, planData).catch(() => {}) — background Firestore write (fire-and-forget)
  5. navigate('/study-plan')

StudyPlanPage mounts → loadPlan()
  → resolvePlan(uid)  [localStorage-first — see below]
  → plan found in localStorage immediately (no network wait)
  → api.attempts.list()  — derive correct/attempted/pending per quest
  → render quest list
```

If the user navigates directly to `/study-plan` without going through ReviewPage (e.g. bookmarked URL), `StudyPlanPage` falls through to calling `api.review.studyPlan()` itself via the same fallback path.

### Plan storage: `resolvePlan` — localStorage-first

`frontend/src/lib/studyPlan.ts → resolvePlan(uid)` uses a **localStorage-first** strategy for today's plan:

```
resolvePlan(uid)
  1. loadStoredPlan()  — synchronous read of 'study_plan_v1'
  2. If plan exists AND date == today → return immediately (no Firestore call)
  3. Else (miss or stale) → try Firestore with 5-second timeout
       loadRemotePlan(uid) races Promise.race([getDoc(...), 5s timeout])
       On hit → savePlan(remote) + return remote
       On miss or timeout/error → return whatever localStorage held (may be null)
```

The localStorage fast-path eliminates all Firestore latency on the same device. Firestore is only queried when localStorage has no plan for today (cross-device scenario: user opens on a second device). The 5-second timeout prevents Firestore connectivity issues from causing indefinite loading.

> **Note:** Firestore is used only for study plan cross-device persistence. The main database is Supabase. If the Firebase project does not have a Firestore database provisioned, all `getDoc`/`setDoc` calls fail silently and the plan is localStorage-only (single device). Supabase (attempts, stars, streaks, history) syncs across devices via the backend as normal.

### `useStudyPlan` hook — two-effect architecture

The sidebar hook (`frontend/src/hooks/useStudyPlan.ts`) separates plan loading from status refreshing to avoid a Firestore call on every window focus:

| Effect | Trigger | What it does |
|--------|---------|--------------|
| **Full load** | `isOpen` becomes true, `user.uid` changes, or `authLoading` settles | `resolvePlan` (may hit Firestore) + `api.attempts.list()`. Populates `planItemsRef` cache. |
| **Status refresh** | `refreshKey` increments (window focus / tab visibility) | `api.attempts.list()` only — no Firestore. Recomputes correct/attempted/pending against cached `planItemsRef`. |

When the sidebar closes, `planItemsRef.current` is reset to `null` so the next open triggers a full load (picks up any new plan generated since last open).

Status is always **derived** from the attempt list — never written to localStorage or Firestore (`SYNC-02` requirement).

---

## Error Handling

**Backend:** services throw typed errors (e.g., `GradingError`, `ChatLimitError`); routes catch and map to HTTP status codes. Zod parse failures return 400. Auth failures return 401 (missing/invalid token) or 402 (insufficient tier).

**Frontend:** `api.ts` throws `Error` with the server's `error` field as the message. 401 responses open the login modal; 402 responses open the upgrade modal. Photo grading uses the softer `GRADE_REJECTED` path to avoid dropping to the error screen.

## Anti-Patterns

### Calling Supabase from a route
**What happens:** route handler imports `supabase` and queries directly.
**Why it's wrong:** bypasses service layer, scatters business logic, makes testing harder.
**Do this instead:** delegate to the corresponding service in `backend/src/services/`.

### Using `loadNext()` when a specific question is intended
**What happens:** `loadNext()` called from the drawer or a `?question_id=` URL.
**Why it's wrong:** `loadNext()` fetches a random unanswered question; under StrictMode double-invoke it may return different questions.
**Do this instead:** use `loadSpecific(id)` for all drawer clicks and `?question_id=` param reads.

### Direct backend calls from components
**What happens:** A component calls `fetch()` directly instead of using `api.ts` or a hook.
**Why it's wrong:** bypasses Bearer token injection and centralised error handling; may leak after unmount.
**Do this instead:** create a hook in `src/hooks/` that calls `api.*`, or add a new domain to `src/lib/api.ts`.

### Prop drilling state
**What happens:** Passing state through 3+ intermediate components to reach the leaf that needs it.
**Why it's wrong:** components become tightly coupled; renders cascade unnecessarily.
**Do this instead:** lift state to a custom hook and call it directly from the leaf, or use Context for global UI state (auth, theme).

---

*Architecture analysis: 2026-06-26 — updated 2026-06-26 to reflect Firebase Auth + feature gating; merged with frontend architecture detail from main. Updated 2026-06-28: Weakness Diagnostic & Study Plan flow documented (unique-question threshold, localStorage-first resolvePlan, pre-fetch pattern, two-effect useStudyPlan hook).*
