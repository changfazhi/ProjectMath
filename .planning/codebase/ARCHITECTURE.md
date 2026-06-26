<!-- refreshed: 2026-06-26 -->
# Architecture

**Analysis Date:** 2026-06-26

## System Overview

```text
┌──────────────────────────────────────────────────────────────┐
│                     React Router (SPA)                        │
├──────────────────┬──────────────────┬───────────────────────┤
│  HomePage        │  PracticePage    │  HistoryPage /        │
│  (Roadmap)       │  (Question +     │  StarredPage /        │
│  `/`             │   Input)         │  StatsPage /          │
│                  │  `/practice/:...` │  ReviewPage           │
└────────┬─────────┴────────┬─────────┴──────────┬────────────┘
         │                  │                     │
         ▼                  ▼                     ▼
┌──────────────────────────────────────────────────────────────┐
│           Hooks (State + Data Fetching)                       │
│  usePracticeSession, useTopics, useChatSession, etc.         │
│  `src/hooks/`                                                │
└────────┬─────────┬────────────────┬──────────────┬───────────┘
         │         │                │              │
         ▼         ▼                ▼              ▼
┌─────────────────────┐  ┌──────────────────┐  ┌──────────────┐
│   REST API Layer    │  │  Socket.IO Client│  │  Local State │
│   `lib/api.ts`      │  │  `lib/socket.ts` │  │ (localStorage)
│  (fetch wrapper)    │  │  (pair socket)   │  │ `lib/session`
└────────┬────────────┘  └────────┬─────────┘  └──────────────┘
         │                        │
         ▼                        ▼
┌──────────────────────────────────────────────────────────────┐
│              Backend (Express + TypeScript)                    │
│  Port 3001 — REST endpoints + Socket.IO for real-time        │
│  Supabase Postgres for persistent data                        │
└──────────────────────────────────────────────────────────────┘
```

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
| **API Layer** | Fetch wrapper; grouped by domain (topics, questions, attempts, etc.) | `src/lib/api.ts` |
| **Socket** | Singleton Socket.IO connection for real-time pairing | `src/lib/socket.ts` |
| **Session** | UUID v4 generation & localStorage persistence | `src/lib/session.ts` |
| **LaTeX Renderer** | Parse mixed text+math; dispatch to Latex/LatexBlock | `src/lib/renderLatex.tsx` |
| **Theme Context** | Light/dark mode toggle; read from localStorage | `src/contexts/ThemeContext.tsx` |

## Pattern Overview

**Overall:** Modern React SPA with reducer-based state machines, hook-driven data fetching, and real-time Socket.IO for phone pairing.

**Key Characteristics:**
- **No global state manager** — local component state + context (theme) only
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
- Contains: `usePracticeSession` (reducer + methods), `useTopics`, `useChatSession`, `usePairSocket`, etc.
- Depends on: `lib/api.ts`, `lib/session.ts`, `lib/socket.ts`, types
- Used by: Pages, components

**Component Layer (UI):**
- Purpose: Render UI; accept props; dispatch events to parents
- Location: `src/components/` (organized by domain: ui, topic, question, math, chat, progress, pair, layout)
- Contains: Buttons, cards, spinners, math editors, question cards, topic roadmaps, etc.
- Depends on: Types, utils (cn, formatTime), renderLatex
- Used by: Pages, other components

**Library Layer (Utilities):**
- Purpose: Centralized cross-cutting concerns
- Location: `src/lib/`
- Contains: API wrapper (`api.ts`), socket singleton (`socket.ts`), session ID management (`session.ts`), LaTeX renderer (`renderLatex.tsx`), Tailwind utilities (`utils.ts`)
- Depends on: External (fetch, socket.io-client, uuid, katex)
- Used by: All layers

**Context Layer:**
- Purpose: Global UI state (theme)
- Location: `src/contexts/`
- Contains: ThemeProvider, useTheme
- Depends on: React
- Used by: Root App

## Data Flow

### Primary Request Path (Practice Session)

1. **Load question** (`PracticePage` mount or click)
   - Calls `session.loadNext()` or `session.loadSpecific(id)` from `usePracticeSession`
   - Dispatches `LOAD_START` → `LOAD_SUCCESS` reducer actions
   - Invokes `api.questions.next()` or `api.questions.get()` (`src/lib/api.ts`)
   - Backend returns `QuestionPublic` (LaTeX prompt, answer type, parts if multi-part)
   - Initializes `partStates` record for multi-part tracking

2. **Student answers**
   - Types in `<MathField>` or `<ExactInput>` / `<RangeInput>`, or captures photo via `<PhotoAnswer>`
   - Triggers `session.submitAnswer(latex)` or `session.submitPhotos(files[])`

3. **Submit answer (typed)**
   - Calls `api.attempts.submit({ session_id, question_id, answer_given, time_taken_s })`
   - Dispatches `SUBMIT_START` → `SUBMIT_SUCCESS` reducer actions
   - Backend grades against `question.correct_answer` (normalized LaTeX or range check)
   - Returns `{ is_correct, correct_answer, solution_latex }`
   - Session moves to `revealed` phase; solution card shows via `<SolutionReveal>`
   - Streaks/session counts update

4. **Submit photo (handwritten)**
   - Calls `api.grade.submit(sessionId, questionId, images[], timeTakenS)`
   - Dispatches `GRADE_START` → `GRADE_SUCCESS` or `GRADE_REJECTED` actions
   - Backend (Gemini vision) returns `{ parts[], is_correct, overall_feedback, ignored_images, solution_latex }`
   - On success → `revealed` phase; on failure (junk photo) → stay in `answering` phase with error toast
   - Grading persisted in `gradings` table; images uploaded to `solution-uploads` bucket

5. **Multi-part flow**
   - User submits part (a), (b), etc. via `session.submitPart(label, answer)`
   - Each part dispatches `PART_SUBMIT_START` → `PART_SUBMIT_DONE`
   - When all graded parts done (solution_latex returned) → transition to `revealed`
   - Ungraded parts (answer_type: null) show no input

### Secondary Flow: Phone Upload Pairing

1. **Desktop initiates QR** (`PracticePage`)
   - Calls `api.pair.create(sessionId, questionId)`
   - Gets back `{ token, mobile_path, expires_at }`
   - Displays QR via `<QrPairModal>`
   - Subscribes to socket room: `getSocket().emit('pair:subscribe', { token })`

2. **Phone opens QR**
   - Navigates to `/m/:token`
   - `<MobileUploadPage>` calls `api.pair.context(token)` to verify & fetch question
   - `usePairSocket(token)` subscribes to same room

3. **Phone snaps & uploads photos**
   - Each photo: `api.pair.uploadPhoto(token, file)` → multipart upload
   - Backend emits `pair:image` socket event with base64 dataURL
   - Desktop listens via `usePairSocket` → state shows live preview

4. **Phone hits "Done"**
   - Calls `api.pair/:token/done`
   - Backend (async) grades via `gradeSolution()` with all photos
   - Emits `pair:grading` → `pair:graded` socket events
   - Desktop's `usePairSocket` handlers call `session.beginExternalGrading()` → `session.receiveGrading(grading)`
   - Practice state machine transitions to `revealed` (same as local photo flow)

### Secondary Flow: AI Hint Chat

1. **User opens Hints tab** (`PracticePage`)
   - Calls `api.chat.history(sessionId, questionId)` via `useChatSession` hook
   - Rehydrates `messages[]` from persistent `chat_messages` table

2. **User types message**
   - Optimistically appends to local `messages[]`
   - Calls `api.chat.send(sessionId, questionId, text)`
   - Backend (Gemini) returns `{ reply, history }`
   - On success → update messages; on error → rollback to snapshot

3. **Chat lifecycle**
   - History persists across sessions (same session_id + question_id)
   - Hints are Socratic (never the answer); guardrails enforced on backend
   - `<ChatPanel>` renders on desktop as right-rail on `lg` screens, inside Hints tab on mobile

**State Management:**
- Practice session: Reducer-based state machine with explicit `PracticePhase` states (loading → answering → submitted → revealed → complete)
- Topics/questions: Simple useState with loading/error (via `useTopics`, `useTopicQuestions`)
- Chat messages: useState + optimistic updates with rollback
- Stars: Optimistic flip locally; sync to server asynchronously
- Session ID: localStorage singleton via `getSessionId()`
- Theme: Context + localStorage

## Key Abstractions

**Practice State Machine:**
- Purpose: Orchestrate complex question-answering flow (load → answer → submit → reveal → navigate)
- Examples: `src/hooks/usePracticeSession.ts`
- Pattern: `useReducer` with typed discriminated unions for actions; phase-driven UI logic in pages/components

**API Client:**
- Purpose: Single entry point for all backend communication; type-safe request/response
- Examples: `src/lib/api.ts` → grouped by domain (topics, questions, attempts, stars, chat, grade, pair, review)
- Pattern: Namespace objects with methods that return `request<T>()` or `requestFormData<T>()`

**Custom Hooks:**
- Purpose: Isolate data fetching, caching, and error handling
- Examples: `useTopics()`, `useChatSession()`, `usePairSocket()`, `useAttemptHistory()`
- Pattern: useState for data/loading/error; useEffect for fetch; return cleanup callback for cancellation

**LaTeX Renderer:**
- Purpose: Parse mixed text+math strings; delegate to appropriate component
- Examples: `src/lib/renderLatex.tsx` → splits by `\(...\)` and `\[...\]` delimiters
- Pattern: Functional; returns ReactNode[]; used for feedback, hints, error messages

## Entry Points

**App Root:**
- Location: `src/main.tsx` → `createRoot()` → `src/App.tsx`
- Triggers: HTML `<div id="root">` on first load
- Responsibilities: Bootstrap React; set up router and theme context

**Router (Browser History):**
- Location: `src/App.tsx` → `createBrowserRouter()` → `<RouterProvider>`
- Triggers: URL changes; internal `<Link>` clicks
- Routes:
  - `/` → `<HomePage>` (roadmap)
  - `/practice/:topicId` → `<PracticePage>` (question answering)
  - `/m/:token` → `<MobileUploadPage>` (phone upload, standalone)
  - `/history`, `/starred`, `/stats`, `/review` → respective pages

**HTTP API (Fetch):**
- Location: `src/lib/api.ts` → `request()` or `requestFormData()`
- Triggers: Page components call hooks; hooks call api methods
- Backend target: `http://localhost:3001/api/*` (dev via Vite proxy; prod via same origin)

**Socket.IO (Real-Time):**
- Location: `src/lib/socket.ts` → `getSocket()` singleton
- Triggers: `usePairSocket()` hook in `PracticePage` and `MobileUploadPage`
- Events: `pair:subscribe`, `pair:phone-connected`, `pair:image`, `pair:grading`, `pair:graded`, `pair:error`

## Architectural Constraints

- **Routing:** React Router SPA only; no server-side rendering
- **Threading:** Single-threaded JavaScript event loop; heavy computation (LaTeX parsing, image compression) blocks UI briefly
- **Global state:** Only localStorage (session ID, theme) and socket.io-client singleton; no Redux/Zustand/Recoil
- **Circular imports:** None detected; module dependency graph is acyclic
- **API calls:** Always via `lib/api.ts` wrapper; never direct `fetch()` from components or pages
- **Component state:** Local `useState` or reducer; never prop drilling beyond 1–2 levels (use hooks or context instead)
- **Async safety:** All fetch hooks track `cancelled` flag to prevent state updates after unmount
- **Memory:** Chat and grading history kept in memory; clearing localStorage clears session history

## Anti-Patterns

### Direct Backend Calls from Components

**What happens:** A component calls `fetch()` directly instead of using `api.ts` or a hook.

**Why it's wrong:** Breaks centralized error handling; duplicates request/response logic; harder to test; may leak after unmount.

**Do this instead:** Create a hook in `src/hooks/` that calls `api.*`, or add a new domain to `src/lib/api.ts`. Wrap fetch in a hook with cancellation cleanup.

### Prop Drilling State

**What happens:** Passing state through 3+ intermediate components to reach the leaf that needs it.

**Why it's wrong:** Components become tightly coupled; harder to refactor; TypeScript prop inference breaks; renders cascade.

**Do this instead:** Lift state to a custom hook (e.g., `usePracticeSession()`) and call it directly from the leaf component. Or use Context for global UI state (like theme).

### Untyped API Responses

**What happens:** Omitting types from `src/types/api.ts` and using `any` in API calls.

**Why it's wrong:** TypeScript loses type checking; refactoring backend breaks silently; autocomplete fails; frontend may crash at runtime.

**Do this instead:** Define an interface in `src/types/api.ts`; pass it to `request<T>()`. Always check types match backend migrations.

## Error Handling

**Strategy:** Graceful degradation; soft errors keep the user on the current page; hard errors surface an error screen.

**Patterns:**
- **API errors:** Returned as `Error` from `request()`; caught in hook try/catch; stored in state as `error: string`
- **Grading junk photos:** HTTP 400 with message → dispatches `GRADE_REJECTED` action → soft error toast, user stays on question
- **Network timeout:** No timeout set (browser default); user can retry manually or page may hang
- **Missing question:** Caught as "no questions found" → `COMPLETE` phase → "You've finished this topic" UI
- **Invalid LaTeX:** Caught in `Latex` component → renders `[LaTeX error]`

## Cross-Cutting Concerns

**Logging:** No logger imported; browser console used for ad-hoc debugging.

**Validation:** Backend validates all inputs; frontend does light type checking and LaTeX normalization. No client-side schema validation (Zod).

**Authentication:** No auth — anonymous sessions via localStorage UUID. Backend trusts `session_id` from request; no verification of user identity.

---

*Architecture analysis: 2026-06-26*
