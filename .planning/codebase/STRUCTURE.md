# Codebase Structure

**Analysis Date:** 2026-06-26

## Directory Layout

```
ProjectMath/
├── backend/
│   ├── src/
│   │   ├── index.ts              # Express app + http.Server + router mounts
│   │   ├── realtime.ts           # Socket.IO server; emitToPair() helper
│   │   ├── routes/               # Thin HTTP handlers (Zod validation only)
│   │   ├── services/             # Business logic; all DB/AI access
│   │   ├── db/                   # Singleton clients (Supabase, Gemini)
│   │   └── types/                # Shared TypeScript types (index.ts)
│   ├── supabase/
│   │   └── migrations/           # Numbered SQL migrations (run in Supabase SQL Editor)
│   ├── package.json
│   └── tsconfig.json
├── frontend/
│   ├── src/
│   │   ├── App.tsx               # Router definition; RootLayout
│   │   ├── main.tsx              # React DOM entry point
│   │   ├── pages/                # Route-level components (one per route)
│   │   ├── components/           # Reusable UI components (grouped by domain)
│   │   ├── hooks/                # Data-fetching and state hooks
│   │   ├── lib/                  # Utilities and singleton clients
│   │   ├── contexts/             # React context providers
│   │   └── types/                # TypeScript types mirroring backend API
│   ├── package.json
│   └── vite.config.ts
├── skills.md                     # Question-authoring workflow (PDF → SQL migration)
└── CLAUDE.md                     # Project guide for AI coding assistants
```

## Backend Subdirectories

**`backend/src/routes/`**
- Purpose: Thin Express routers. Parse and validate inputs (Zod), delegate to one service, return JSON.
- One file per resource: `topics.ts`, `questions.ts`, `attempts.ts`, `concepts.ts`, `stars.ts`, `streaks.ts`, `chat.ts`, `grade.ts`, `pair.ts`, `review.ts`.
- **Never** import `supabase` here.

**`backend/src/services/`**
- Purpose: All business logic. Calls `db/supabase.ts` and/or `db/gemini.ts`. Returns typed values.
- Key files: `attemptService.ts` (answer grading, `normalizeLaTeX()`), `gradingService.ts` (photo AI pipeline), `chatService.ts` (Gemini Socratic tutor), `pairService.ts` (in-memory token store), `topicService.ts`, `questionService.ts`, `starService.ts`, `streakService.ts`, `conceptService.ts`, `reviewService.ts`.

**`backend/src/db/`**
- Purpose: Singleton client construction from environment variables.
- `supabase.ts` — Supabase JS client (service role key, never exposed to frontend).
- `gemini.ts` — `@google/genai` client; `gemini-2.5-flash` model used by chat and grading services.

**`backend/src/types/`**
- `index.ts` — Shared TypeScript interfaces for DB rows and service return shapes.

**`backend/supabase/migrations/`**
- Purpose: Sequential SQL files applied manually in the Supabase SQL Editor (not via CLI migration runner).
- Naming: `NNN_description.sql` where NNN is zero-padded sequential number.
- Schema migrations: 001–008 (core tables, multi-part support).
- Data migrations: 007, 009–016+ (question sets per school/year).
- Each `CREATE TABLE` must be followed by `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;`.

## Frontend Subdirectories

**`frontend/src/pages/`**
- Purpose: One component per route. Thin — compose hooks and components.
- `HomePage.tsx` — roadmap + `TopicDrawer`
- `PracticePage.tsx` — full practice session (tabs: Question | Attempts | Hints)
- `HistoryPage.tsx` — attempt history
- `StatsPage.tsx` — streak heatmap + analytics
- `StarredPage.tsx` — bookmarked questions
- `ReviewPage.tsx` — question review
- `MobileUploadPage.tsx` — standalone phone upload at `/m/:token`

**`frontend/src/components/`**
- Grouped by domain, not by UI type:
  - `chat/` — `ChatPanel.tsx`
  - `layout/` — `Header.tsx`
  - `math/` — `Latex.tsx`, `LatexBlock.tsx`, `MathField.tsx`, `MathKeyboard.tsx`
  - `pair/` — `QrPairModal.tsx`
  - `progress/` — `AttemptRow.tsx`, `StatsBar.tsx`
  - `question/` — `AnswerInput.tsx`, `ExactInput.tsx`, `GradingResult.tsx`, `McqInput.tsx`, `MultiPartQuestion.tsx`, `PhotoAnswer.tsx`, `QuestionCard.tsx`, `QuestionHeader.tsx`, `RangeInput.tsx`, `SolutionReveal.tsx`
  - `topic/` — `AccuracyTable.tsx`, `ConceptsList.tsx`, `QuestionTable.tsx`, `RoadmapGraph.tsx`, `TopicCard.tsx`, `TopicDrawer.tsx`, `TopicGrid.tsx`
  - `ui/` — generic primitives: `Badge.tsx`, `Button.tsx`, `Card.tsx`, `ErrorMessage.tsx`, `ProgressBar.tsx`, `Spinner.tsx`, `StreakNotification.tsx`

**`frontend/src/hooks/`**
- Purpose: Data-fetching logic and complex UI state. Consumed by pages.
- `usePracticeSession.ts` — primary state machine (`useReducer`); owns question loading, answer submission, photo grading, external grading via socket.
- `useChatSession.ts` — optimistic chat send with rollback on error.
- `usePairSocket.ts` — Socket.IO event forwarding into `usePracticeSession`.
- `useTopics.ts`, `useTopicsProgress.ts`, `useTopicQuestions.ts`, `useAttemptHistory.ts`, `useConcepts.ts`, `useVisitedTopics.ts` — data fetching hooks.

**`frontend/src/lib/`**
- `api.ts` — **Single fetch layer.** All HTTP calls. `request<T>()` for JSON, `requestFormData<T>()` for multipart. Never call `fetch` directly from components.
- `session.ts` — `getSessionId()`: UUID v4, persisted to `localStorage`.
- `socket.ts` — Socket.IO client singleton (same-origin `io()`).
- `renderLatex.tsx` — Mixed text+math renderer (`\(...\)` / `\[...\]` delimiters).
- `utils.ts` — `cn()` Tailwind class merger.

**`frontend/src/contexts/`**
- `ThemeContext.tsx` — Dark/light theme provider; wraps the entire app in `App.tsx`.

**`frontend/src/types/`**
- `api.ts` — TypeScript interfaces mirroring the backend API contract (`Topic`, `QuestionPublic`, `Attempt`, `GradeResponse`, etc.).
- `mathlive.d.ts` — Type declarations for the MathLive web component.

## Naming Conventions

**Backend files:** camelCase for service/db files; camelCase for route files.

**Frontend files:** PascalCase for components and pages; camelCase for hooks (`use` prefix), lib utilities, and context files.

**Migration files:** `NNN_snake_case_description.sql` — sequential, manual.

## Where to Add New Code

**New API endpoint:**
1. Route handler: `backend/src/routes/<resource>.ts`
2. Service logic: `backend/src/services/<resource>Service.ts`
3. Mount in: `backend/src/index.ts`
4. Frontend call: add to `frontend/src/lib/api.ts` under the appropriate namespace

**New page/route:**
1. Page component: `frontend/src/pages/<Name>Page.tsx`
2. Register route: `frontend/src/App.tsx` router array

**New reusable component:**
- Domain-specific: `frontend/src/components/<domain>/<Name>.tsx`
- Generic UI primitive: `frontend/src/components/ui/<Name>.tsx`

**New data-fetching logic:**
- `frontend/src/hooks/use<Resource>.ts`

**New question data (school/year):**
- New migration: `backend/supabase/migrations/NNN_<school>_prelim_<year>.sql`
- Follow UUID scheme documented in `CLAUDE.md` and `skills.md`

---

*Structure analysis: 2026-06-26*
