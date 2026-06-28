# Codebase Structure

**Analysis Date:** 2026-06-28

## Directory Layout

```
ProjectMath/
├── backend/                    # Express + TypeScript API server
│   ├── src/
│   │   ├── index.ts            # Entry point — Express app + http.Server + Socket.IO init
│   │   ├── realtime.ts         # Socket.IO server (QR phone-upload pairing)
│   │   ├── config/
│   │   │   └── featureTiers.ts # Feature → tier mapping ('free'|'paid')
│   │   ├── db/
│   │   │   ├── supabase.ts     # Supabase JS client singleton (service role)
│   │   │   ├── firebase.ts     # Firebase Admin SDK singleton
│   │   │   └── gemini.ts       # Google Generative AI client
│   │   ├── middleware/
│   │   │   └── auth.ts         # requireAuth + gate() middleware
│   │   ├── routes/             # Thin HTTP handlers (Zod validate → service call)
│   │   │   ├── attempts.ts
│   │   │   ├── chat.ts
│   │   │   ├── concepts.ts
│   │   │   ├── grade.ts
│   │   │   ├── pair.ts
│   │   │   ├── questions.ts
│   │   │   ├── review.ts
│   │   │   ├── stars.ts
│   │   │   ├── streaks.ts
│   │   │   └── topics.ts
│   │   ├── services/           # All business logic + Supabase queries
│   │   │   ├── attemptService.ts
│   │   │   ├── chatService.ts
│   │   │   ├── conceptService.ts
│   │   │   ├── diagnosticService.ts
│   │   │   ├── gradingService.ts
│   │   │   ├── pairService.ts
│   │   │   ├── questionService.ts
│   │   │   ├── reviewService.ts
│   │   │   ├── spacedRepetitionService.ts
│   │   │   ├── starService.ts
│   │   │   ├── streakService.ts
│   │   │   └── topicService.ts
│   │   └── types/
│   │       └── index.ts        # Shared backend TypeScript types
│   ├── supabase/
│   │   └── migrations/         # Numbered SQL migration files (001–016+)
│   ├── .env                    # Never committed — SUPABASE_URL, keys, GEMINI_API_KEY, Firebase creds
│   └── package.json
├── frontend/                   # React 19 + Vite + Tailwind SPA
│   ├── src/
│   │   ├── main.tsx            # React DOM root render
│   │   ├── App.tsx             # Router setup + RootLayout
│   │   ├── App.css
│   │   ├── index.css           # Tailwind base imports
│   │   ├── assets/             # Static assets (images, icons)
│   │   ├── components/
│   │   │   ├── chat/           # ChatPanel, ChatMessage
│   │   │   ├── layout/         # Header.tsx, StudyPlanSidebar.tsx
│   │   │   ├── math/           # MathField.tsx, MathKeyboard.tsx, Latex.tsx, LatexBlock.tsx
│   │   │   ├── pair/           # QrPairModal.tsx
│   │   │   ├── progress/       # StatsBar, StreakBadge, etc.
│   │   │   ├── question/       # AnswerInput, ExactInput, GradingResult, McqInput,
│   │   │   │                   # MultiPartQuestion, PhotoAnswer, QuestionCard,
│   │   │   │                   # QuestionHeader, RangeInput, SolutionReveal
│   │   │   ├── sidebar/        # TopicDrawer and related
│   │   │   ├── topic/          # Topic node/roadmap components
│   │   │   └── ui/             # Badge, Button, Card, ErrorMessage, ProgressBar,
│   │   │                       # Spinner, StreakNotification
│   │   ├── contexts/
│   │   │   ├── AuthContext.tsx  # Firebase auth state, LoginModal trigger
│   │   │   └── ThemeContext.tsx # Dark/light theme
│   │   ├── hooks/
│   │   │   ├── useAttemptHistory.ts
│   │   │   ├── useChatSession.ts
│   │   │   ├── useConcepts.ts
│   │   │   ├── useFeature.ts
│   │   │   ├── usePairSocket.ts
│   │   │   ├── usePracticeSession.ts
│   │   │   ├── useStudyPlan.ts
│   │   │   ├── useTopicQuestions.ts
│   │   │   ├── useTopics.ts
│   │   │   ├── useTopicsProgress.ts
│   │   │   └── useVisitedTopics.ts
│   │   ├── lib/
│   │   │   ├── api.ts          # Typed fetch wrapper — all API calls go here
│   │   │   ├── firebase.ts     # Firebase Auth client SDK init
│   │   │   ├── renderLatex.tsx # Mixed text+math renderer (\(...\) / \[...\])
│   │   │   ├── session.ts      # session_id UUID from localStorage
│   │   │   ├── socket.ts       # Socket.IO client singleton
│   │   │   ├── studyPlan.ts    # Study plan utilities
│   │   │   └── utils.ts        # cn() and general helpers
│   │   ├── pages/
│   │   │   ├── HistoryPage.tsx
│   │   │   ├── HomePage.tsx    # Roadmap pan/zoom tree
│   │   │   ├── MobileUploadPage.tsx  # Standalone /m/:token route (no RootLayout)
│   │   │   ├── PracticePage.tsx
│   │   │   ├── ReviewPage.tsx
│   │   │   ├── StarredPage.tsx
│   │   │   ├── StatsPage.tsx
│   │   │   └── StudyPlanPage.tsx
│   │   └── types/
│   │       └── api.ts          # Client-side types mirroring backend response shapes
│   ├── public/                 # Static public assets
│   └── package.json
├── backend/supabase/migrations/ # SQL migration files (run in Supabase SQL Editor in order)
├── 2025/                       # Source exam PDF files organised by school
│   ├── ACJC/, ASRJC/, CJC/, DHS/, EJC/, HCI/, JPJC/...
├── images/                     # Miscellaneous images
├── .planning/                  # GSD planning artifacts
│   ├── codebase/               # This directory — codebase analysis docs
│   └── phases/                 # Phase plans and artifacts
├── skills.md                   # Exam extraction workflow reference
└── package.json                # Root — may contain setup scripts
```

## Directory Purposes

**`backend/src/routes/`:**
- Purpose: One file per resource; thin HTTP handlers only
- Contains: Zod schema definitions, `gate()` calls, response shaping
- Key rule: Never import `supabase` here — delegate to services

**`backend/src/services/`:**
- Purpose: All business logic, answer normalisation, AI prompt building, Supabase queries
- Contains: One service file per domain (attempts, chat, grading, spaced repetition, etc.)
- Key rule: Services are the only place that calls `supabase` (plus `auth.ts`)

**`backend/src/db/`:**
- Purpose: Singleton client instances for external services
- Key files: `supabase.ts` (Supabase), `firebase.ts` (Firebase Admin), `gemini.ts` (Gemini AI)

**`backend/supabase/migrations/`:**
- Purpose: Numbered SQL files applied in order in Supabase SQL Editor
- Naming: `NNN_description.sql` (e.g. `001_initial_schema.sql`)
- Not applied automatically — manual execution required

**`frontend/src/components/`:**
- Purpose: Reusable presentational components; no direct API calls
- Subdivided by feature domain (`chat/`, `math/`, `question/`, etc.)
- `ui/` contains primitive atoms (Button, Card, Badge, Spinner)

**`frontend/src/hooks/`:**
- Purpose: State management and data fetching; composable by pages
- Each hook handles one domain: `usePracticeSession` (practice flow), `useChatSession` (AI chat), `usePairSocket` (QR flow)

**`frontend/src/lib/`:**
- Purpose: Shared singletons and utilities; consumed by hooks and components
- `api.ts` is the exclusive gateway to all backend calls

**`frontend/src/pages/`:**
- Purpose: Route-level components; compose hooks + components, own page layout
- `MobileUploadPage.tsx` is the exception — outside `RootLayout`, no auth required

**`frontend/src/types/api.ts`:**
- Purpose: Client-side TypeScript interfaces that mirror backend response shapes
- Must stay in sync with backend `backend/src/types/index.ts`

**`2025/`:**
- Purpose: Source PDF exam papers from JCs; used with the exam extraction skill to generate SQL migrations
- Not served by the application

## Key File Locations

**Entry Points:**
- `backend/src/index.ts`: Backend server startup
- `frontend/src/main.tsx`: Frontend React root
- `frontend/src/App.tsx`: Router and layout shell

**Authentication:**
- `backend/src/middleware/auth.ts`: `requireAuth` + `gate()` — all protected routes use this
- `backend/src/db/firebase.ts`: Firebase Admin singleton
- `frontend/src/lib/firebase.ts`: Firebase Auth client
- `frontend/src/contexts/AuthContext.tsx`: Auth state + `LoginModal` trigger

**API Contract:**
- `frontend/src/lib/api.ts`: All frontend → backend calls
- `frontend/src/types/api.ts`: Shared response types

**Answer Grading:**
- `backend/src/services/attemptService.ts`: `normalizeLaTeX()`, `latexToMathExpr()`, answer comparison
- `backend/src/services/gradingService.ts`: Photo AI grading via Gemini

**Real-time (QR Pairing):**
- `backend/src/realtime.ts`: Socket.IO server
- `frontend/src/lib/socket.ts`: Socket.IO client
- `frontend/src/hooks/usePairSocket.ts`: Event forwarding hook

**Math Rendering:**
- `frontend/src/lib/renderLatex.tsx`: `renderLatex()` for mixed text+math
- `frontend/src/components/math/`: `MathField.tsx` (MathLive input), `MathKeyboard.tsx`, `Latex.tsx`, `LatexBlock.tsx`

**Database Schema:**
- `backend/supabase/migrations/`: All SQL — `001_initial_schema.sql` through `016_cjc_prelim_2025.sql`

## Naming Conventions

**Backend files:**
- Routes: `<resource>.ts` (e.g. `attempts.ts`, `grade.ts`)
- Services: `<resource>Service.ts` (e.g. `attemptService.ts`, `gradingService.ts`)
- DB clients: short noun (e.g. `supabase.ts`, `firebase.ts`, `gemini.ts`)
- Imports: must use `.js` extension (NodeNext resolution)

**Frontend files:**
- Components: `PascalCase.tsx` (e.g. `QuestionCard.tsx`, `PhotoAnswer.tsx`)
- Hooks: `use<Domain>.ts` (e.g. `usePracticeSession.ts`, `useChatSession.ts`)
- Pages: `<Name>Page.tsx` (e.g. `PracticePage.tsx`, `HistoryPage.tsx`)
- Lib utilities: `camelCase.ts` (e.g. `renderLatex.tsx`, `studyPlan.ts`)

**SQL migrations:**
- `NNN_description.sql` — three-digit prefix ensures ordered application

## Where to Add New Code

**New API endpoint:**
1. Add route handler: `backend/src/routes/<resource>.ts`
2. Add business logic: `backend/src/services/<resource>Service.ts`
3. Mount router in: `backend/src/index.ts`
4. Add typed fetch method to: `frontend/src/lib/api.ts`
5. Add response types to: `frontend/src/types/api.ts`

**New frontend page:**
1. Page component: `frontend/src/pages/<Name>Page.tsx`
2. Register route in: `frontend/src/App.tsx` (inside `RootLayout` children, or standalone)
3. Add nav link to: `frontend/src/components/layout/Header.tsx`

**New question component:**
- Implementation: `frontend/src/components/question/`

**New shared UI primitive:**
- Implementation: `frontend/src/components/ui/`

**New data-fetching hook:**
- Implementation: `frontend/src/hooks/use<Domain>.ts`

**New database table:**
1. Write migration: `backend/supabase/migrations/<NNN>_description.sql`
2. Include `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;`
3. Run manually in Supabase SQL Editor

**New feature tier gate:**
1. Add feature name to `backend/src/config/featureTiers.ts`
2. Use `...gate('<feature>')` in the route

## Special Directories

**`.planning/`:**
- Purpose: GSD workflow artifacts (phase plans, codebase maps)
- Generated: Partially (by GSD commands)
- Committed: Yes

**`backend/dist/`:**
- Purpose: Compiled TypeScript output
- Generated: Yes (`npm run build`)
- Committed: No

**`frontend/dist/`:**
- Purpose: Vite production build output
- Generated: Yes (`npm run build`)
- Committed: No

**`2025/`:**
- Purpose: Source exam PDF files for exam extraction workflow
- Generated: No (manually added)
- Committed: Yes (tracked by git but not served)

---

*Structure analysis: 2026-06-28*
