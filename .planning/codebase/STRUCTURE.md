# Codebase Structure

**Analysis Date:** 2026-06-29

## Directory Layout

```
ProjectMath/
├── backend/                    # Express + TypeScript API server
│   ├── src/
│   │   ├── index.ts            # Entry point: Express app, router mounts, http.Server, Socket.IO init
│   │   ├── realtime.ts         # Socket.IO setup; emitToPair() helper
│   │   ├── config/
│   │   │   └── featureTiers.ts # Maps feature name → 'free'|'paid'
│   │   ├── db/
│   │   │   ├── supabase.ts     # Supabase JS client singleton
│   │   │   ├── firebase.ts     # Firebase Admin SDK lazy-init
│   │   │   └── gemini.ts       # @google/genai client factory + GEMINI_MODEL constant
│   │   ├── middleware/
│   │   │   └── auth.ts         # requireAuth (JWT verify + user upsert), gate(feature)
│   │   ├── routes/
│   │   │   ├── topics.ts       # GET /api/topics, /api/topics/:id, /api/topics/progress, /accuracy
│   │   │   ├── questions.ts    # GET /api/topics/:id/questions, /next, /api/questions/:id, /solution
│   │   │   ├── concepts.ts     # GET /api/topics/:id/concepts
│   │   │   ├── attempts.ts     # POST /api/attempts, GET /api/attempts
│   │   │   ├── stars.ts        # POST /api/stars, GET /api/stars, GET /api/stars/all
│   │   │   ├── streaks.ts      # GET /api/streaks
│   │   │   ├── chat.ts         # GET /api/chat, POST /api/chat
│   │   │   ├── grade.ts        # GET /api/grade, POST /api/grade (multipart)
│   │   │   ├── pair.ts         # POST /api/pair, GET /api/pair/:token, POST /api/pair/:token/photo, /done
│   │   │   └── review.ts       # GET /api/review/corrections, /weak-topics, /speed-drills, /spaced, /random, /diagnosis, /study-plan
│   │   ├── services/
│   │   │   ├── attemptService.ts      # Answer grading logic (exact/range/mcq/symbolic eval)
│   │   │   ├── chatService.ts         # AI hint chatbot; Gemini proxy; message persistence
│   │   │   ├── conceptService.ts      # Topic concept queries
│   │   │   ├── diagnosticService.ts   # Weakness diagnosis for study plan
│   │   │   ├── gradingService.ts      # Photo AI grading; Gemini vision; image upload
│   │   │   ├── pairService.ts         # Ephemeral in-memory pairing session store
│   │   │   ├── questionService.ts     # Question fetch (with/without solution); next unanswered
│   │   │   ├── reviewService.ts       # Review queue builders (corrections, speed drills, spaced, etc.)
│   │   │   ├── spacedRepetitionService.ts  # SR card upsert after each attempt
│   │   │   ├── starService.ts         # Star toggle and list
│   │   │   ├── streakService.ts       # Streak computation + heatmap data
│   │   │   └── topicService.ts        # Topic list, single topic, progress stats, accuracy
│   │   └── types/
│   │       └── index.ts        # All backend TypeScript types (shared source of truth)
│   ├── supabase/
│   │   └── migrations/         # 001–019 SQL migration files (run in Supabase SQL Editor)
│   ├── .env.example
│   ├── package.json
│   └── tsconfig.json
│
├── frontend/                   # React 19 + Vite + Tailwind + KaTeX SPA
│   ├── src/
│   │   ├── main.tsx            # React root; mounts <AuthProvider><App /></AuthProvider>
│   │   ├── App.tsx             # Router definition; RootLayout; route tree
│   │   ├── index.css           # Tailwind directives + global styles
│   │   ├── App.css             # App-level overrides
│   │   ├── contexts/
│   │   │   └── AuthContext.tsx # Firebase Auth state; tier; login/upgrade modal orchestration
│   │   ├── hooks/
│   │   │   ├── usePracticeSession.ts  # Practice state machine (useReducer); answer submission
│   │   │   ├── usePairSocket.ts       # Socket.IO pairing subscription
│   │   │   ├── useChatSession.ts      # AI chatbot send + history
│   │   │   ├── useStudyPlan.ts        # Daily study plan fetch + localStorage cache
│   │   │   ├── useTopics.ts           # Topic list fetch
│   │   │   ├── useTopicsProgress.ts   # Per-topic completion stats
│   │   │   ├── useTopicQuestions.ts   # Questions for a topic with attempt status
│   │   │   ├── useConcepts.ts         # Prerequisite concepts for a topic
│   │   │   ├── useAttemptHistory.ts   # Session attempt list
│   │   │   ├── useFeature.ts          # Feature-tier gate check
│   │   │   └── useVisitedTopics.ts    # Tracks which topics have been opened
│   │   ├── lib/
│   │   │   ├── api.ts          # All HTTP calls; Bearer token injection; 401/402 callbacks
│   │   │   ├── firebase.ts     # Firebase client SDK init (VITE_FIREBASE_* env vars)
│   │   │   ├── socket.ts       # Socket.IO singleton (same-origin io())
│   │   │   ├── studyPlan.ts    # localStorage study plan cache helpers
│   │   │   ├── renderLatex.tsx # Mixed text+math rendering (\(...\) / \[...\])
│   │   │   └── utils.ts        # cn() (clsx + tailwind-merge), formatTime, etc.
│   │   ├── components/
│   │   │   ├── chat/
│   │   │   │   └── ChatPanel.tsx          # AI hint chat UI; renders on desktop as side rail, mobile as Hints tab
│   │   │   ├── layout/
│   │   │   │   ├── Header.tsx             # Top nav bar; user avatar/auth; streak indicator
│   │   │   │   └── StudyPlanSidebar.tsx   # Collapsible right sidebar; study plan quests
│   │   │   ├── math/
│   │   │   │   ├── Latex.tsx              # Inline KaTeX render (pure LaTeX strings)
│   │   │   │   ├── LatexBlock.tsx         # Block KaTeX render
│   │   │   │   ├── MathField.tsx          # MathLive <math-field> wrapper; exposes insert/getValue/focus
│   │   │   │   └── MathKeyboard.tsx       # 10-group symbol keyboard; onMouseDown to avoid focus steal
│   │   │   ├── pair/
│   │   │   │   └── QrPairModal.tsx        # QR code modal for phone upload pairing
│   │   │   ├── progress/
│   │   │   │   ├── AttemptRow.tsx         # Single attempt row in history list
│   │   │   │   └── StatsBar.tsx           # Session correct/total + streak count display
│   │   │   ├── question/
│   │   │   │   ├── AnswerInput.tsx        # Selects ExactInput/RangeInput/McqInput based on answer_type
│   │   │   │   ├── ExactInput.tsx         # MathField + MathKeyboard for LaTeX answers
│   │   │   │   ├── GradingResult.tsx      # Photo grading result display (per-part verdicts, feedback)
│   │   │   │   ├── McqInput.tsx           # Multiple-choice option buttons
│   │   │   │   ├── MultiPartQuestion.tsx  # Renders per-part answer boxes for multi-part questions
│   │   │   │   ├── PhotoAnswer.tsx        # Camera capture + file upload; preview grid; submit button
│   │   │   │   ├── QuestionCard.tsx       # Question prompt display (LaTeX rendered)
│   │   │   │   ├── QuestionHeader.tsx     # Topic breadcrumb + question name + difficulty badge
│   │   │   │   ├── RangeInput.tsx         # Numerical input for range-type answers
│   │   │   │   └── SolutionReveal.tsx     # Solution LaTeX + per-part correct answers after reveal
│   │   │   ├── sidebar/
│   │   │   │   └── QuestItem.tsx          # Single quest row in StudyPlanSidebar
│   │   │   ├── topic/
│   │   │   │   ├── AccuracyTable.tsx      # Per-topic accuracy stats table
│   │   │   │   ├── ConceptsList.tsx       # Prerequisite concepts list in TopicDrawer
│   │   │   │   ├── QuestionTable.tsx      # Question list with attempt status in TopicDrawer
│   │   │   │   ├── RoadmapGraph.tsx       # Pan/zoom prerequisite graph (HomePage)
│   │   │   │   ├── TopicCard.tsx          # Topic card for grid view
│   │   │   │   ├── TopicDrawer.tsx        # Right panel; concepts + question list; opens from roadmap node click
│   │   │   │   └── TopicGrid.tsx          # Grid of TopicCards
│   │   │   └── ui/
│   │   │       ├── Badge.tsx              # Difficulty/status badge
│   │   │       ├── Button.tsx             # Styled button primitive
│   │   │       ├── Card.tsx               # Container card primitive
│   │   │       ├── ErrorMessage.tsx       # Error display
│   │   │       ├── ProgressBar.tsx        # Topic completion progress bar
│   │   │       ├── Spinner.tsx            # Loading spinner
│   │   │       └── StreakNotification.tsx # Modal that fires once per day on first correct answer
│   │   ├── components/ (root-level)
│   │   │   ├── LoginModal.tsx             # Email/password + Google sign-in modal
│   │   │   └── UpgradeModal.tsx           # Subscription upgrade prompt modal
│   │   ├── pages/
│   │   │   ├── LandingPage.tsx     # Marketing landing page at route /
│   │   │   ├── HomePage.tsx        # Roadmap graph at /roadmap
│   │   │   ├── PracticePage.tsx    # Main practice interface at /practice/:topicId
│   │   │   ├── HistoryPage.tsx     # Attempt history at /history
│   │   │   ├── StatsPage.tsx       # Streak cards + heatmap at /stats
│   │   │   ├── StarredPage.tsx     # Bookmarked questions at /starred
│   │   │   ├── ReviewPage.tsx      # Spaced repetition / review queue at /review
│   │   │   ├── StudyPlanPage.tsx   # Study plan detail view at /study-plan
│   │   │   └── MobileUploadPage.tsx # Standalone phone upload at /m/:token (no RootLayout)
│   │   └── types/
│   │       ├── api.ts              # Client-side type mirror of backend/src/types/index.ts
│   │       └── mathlive.d.ts       # MathLive Web Component type declarations
│   ├── public/
│   │   ├── favicon.svg
│   │   └── icons.svg
│   ├── .env.example
│   ├── eslint.config.js
│   ├── index.html
│   ├── package.json
│   ├── postcss.config.js
│   └── vite.config.ts (proxies /api/* and /socket.io → localhost:3001)
│
├── .planning/
│   ├── codebase/               # Codebase map documents (this file)
│   └── phases/                 # Phase plans and summaries
├── 2025/                       # Exam PDFs by school (gitignored)
├── images/                     # (gitignored)
├── CLAUDE.md                   # Project guide for Claude Code
├── dev.js                      # Convenience script to run backend + frontend concurrently
└── package.json                # Root package (npm run setup, npm run dev)
```

## Frontend Routes

| Route | Component | Description |
|-------|-----------|-------------|
| `/` | `LandingPage` | Marketing landing page; standalone layout (no Header/Sidebar) |
| `/roadmap` | `HomePage` via `RootLayout` | Pan/zoom prerequisite graph; `TopicDrawer` on node click |
| `/practice/:topicId` | `PracticePage` via `RootLayout` | Practice session; `?question_id=<uuid>` loads specific question |
| `/history` | `HistoryPage` via `RootLayout` | Full attempt history list |
| `/stats` | `StatsPage` via `RootLayout` | Streak cards + GitHub-style heatmap |
| `/starred` | `StarredPage` via `RootLayout` | All starred questions with latest attempt |
| `/review` | `ReviewPage` via `RootLayout` | Spaced repetition / review queue |
| `/study-plan` | `StudyPlanPage` via `RootLayout` | Detailed study plan view |
| `/m/:token` | `MobileUploadPage` | Phone photo upload; standalone (no RootLayout) |

`RootLayout` renders `<Header>` + `<StudyPlanSidebar>` + `<Outlet>`.

## Backend Route Files and Endpoints

| File | Endpoints |
|------|-----------|
| `routes/topics.ts` | `GET /api/topics?level=H2`, `GET /api/topics/:id`, `GET /api/topics/progress`, `GET /api/topics/accuracy` |
| `routes/questions.ts` | `GET /api/topics/:id/questions`, `GET /api/topics/:id/next?difficulty=N`, `GET /api/questions/:id`, `GET /api/questions/:id/solution` |
| `routes/concepts.ts` | `GET /api/topics/:id/concepts` |
| `routes/attempts.ts` | `POST /api/attempts`, `GET /api/attempts?question_id=UUID` |
| `routes/stars.ts` | `POST /api/stars`, `GET /api/stars?topic_id=UUID`, `GET /api/stars/all` |
| `routes/streaks.ts` | `GET /api/streaks` |
| `routes/chat.ts` | `GET /api/chat?question_id=UUID`, `POST /api/chat` |
| `routes/grade.ts` | `GET /api/grade?question_id=UUID`, `POST /api/grade` (multipart/form-data) |
| `routes/pair.ts` | `POST /api/pair`, `GET /api/pair/:token`, `POST /api/pair/:token/photo`, `POST /api/pair/:token/done` |
| `routes/review.ts` | `GET /api/review/corrections`, `/weak-topics`, `/speed-drills`, `/spaced`, `/random`, `/diagnosis`, `/study-plan` |

All endpoints except `/health` and `/api/pair/:token` (mobile page context) require auth via `gate()`.

## Where Types Are Defined

**Backend canonical types:** `backend/src/types/index.ts`
- All domain types: `Topic`, `Question`, `QuestionPart`, `Attempt`, `Grading`, `ChatMessage`, `PairSession`, etc.
- Public variants (client-safe, secrets stripped): `QuestionPublic`, `QuestionPartPublic`, `ChatMessagePublic`
- Response types: `SubmitAttemptResponse`, `GradeResponse`, `CreatePairResponse`, `StudyPlanResponse`

**Frontend type mirror:** `frontend/src/types/api.ts`
- Mirrors backend public types; kept in sync manually
- Additional frontend-only types: `QuestStatus`, `StudyPlanItem`, `Quest` (in `hooks/useStudyPlan.ts`)

**MathLive types:** `frontend/src/types/mathlive.d.ts` — Web Component ambient declaration

## Key Files

| File | Role |
|------|------|
| `backend/src/index.ts` | Backend entry point; all router mounts |
| `backend/src/middleware/auth.ts` | Firebase JWT verification + tier gating |
| `backend/src/realtime.ts` | Socket.IO init; `emitToPair()` |
| `backend/src/services/attemptService.ts` | Core answer grading logic |
| `backend/src/services/gradingService.ts` | Photo AI grading pipeline |
| `backend/src/services/chatService.ts` | AI chatbot proxy + Socratic prompt |
| `backend/src/config/featureTiers.ts` | Feature access control table |
| `backend/src/types/index.ts` | All backend types |
| `frontend/src/main.tsx` | React root; `AuthProvider` wraps everything |
| `frontend/src/App.tsx` | Route tree definition |
| `frontend/src/lib/api.ts` | All HTTP calls; auth token injection |
| `frontend/src/lib/firebase.ts` | Firebase client SDK init |
| `frontend/src/contexts/AuthContext.tsx` | Global auth state |
| `frontend/src/hooks/usePracticeSession.ts` | Practice state machine |
| `frontend/src/hooks/usePairSocket.ts` | Socket.IO pairing events |
| `frontend/src/types/api.ts` | Frontend type mirror |

## Naming Conventions

**Files:**
- React components: PascalCase (`PracticePage.tsx`, `ChatPanel.tsx`)
- Hooks: camelCase prefixed with `use` (`usePracticeSession.ts`)
- Lib/utilities: camelCase (`api.ts`, `renderLatex.tsx`, `studyPlan.ts`)
- Backend routes/services: camelCase (`attemptService.ts`, `chatService.ts`)
- SQL migrations: zero-padded number + description (`001_initial_schema.sql`)

**Directories:**
- Frontend: lowercase, domain-grouped (`components/question/`, `hooks/`, `lib/`, `pages/`)
- Backend: lowercase, role-grouped (`routes/`, `services/`, `db/`, `middleware/`, `config/`)

## Where to Add New Code

**New API endpoint:**
1. Route handler → `backend/src/routes/<domain>.ts` (new file or add to existing)
2. Business logic → `backend/src/services/<domain>Service.ts`
3. Mount in `backend/src/index.ts`
4. Add types to `backend/src/types/index.ts`
5. Add client method to `frontend/src/lib/api.ts`
6. Mirror types in `frontend/src/types/api.ts`

**New frontend page:**
1. Page component → `frontend/src/pages/<Name>Page.tsx`
2. Add route in `frontend/src/App.tsx` (inside `RootLayout` children or standalone)
3. Add nav link in `frontend/src/components/layout/Header.tsx` if needed

**New data-fetching hook:**
1. Hook → `frontend/src/hooks/use<Feature>.ts`
2. Uses `api.*` from `frontend/src/lib/api.ts`

**New UI component:**
1. Generic primitive → `frontend/src/components/ui/`
2. Domain-specific → `frontend/src/components/<domain>/`

**New database table:**
1. Write migration → `backend/supabase/migrations/<NNN>_<description>.sql`
2. Include `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;`
3. Run in Supabase SQL Editor
4. Add types to `backend/src/types/index.ts`

**New feature gating:**
1. Add entry to `backend/src/config/featureTiers.ts`
2. Use `gate('featureName')` in route handlers instead of `requireAuth`

## Special Directories

**`backend/supabase/migrations/`:**
- Purpose: SQL migration files applied sequentially in Supabase SQL Editor
- Generated: No (hand-written)
- Committed: Yes
- Naming: `<NNN>_<description>.sql`; currently 001–019

**`frontend/public/`:**
- Purpose: Static assets served as-is; `favicon.svg`, `icons.svg`
- Generated: No

**`2025/`:**
- Purpose: Exam PDFs organized by school (ACJC, ASRJC, CJC, DHS, HCI, etc.)
- Generated: No
- Committed: No (gitignored)

**`.planning/`:**
- Purpose: GSD workflow artifacts (codebase maps, phase plans, summaries)
- Generated: Partially (by GSD tools)
- Committed: Yes

---

*Structure analysis: 2026-06-29*
