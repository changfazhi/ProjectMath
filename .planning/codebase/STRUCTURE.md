# Codebase Structure

**Analysis Date:** 2026-07-04

## Directory Layout

```
/Users/chang/ProjectMath/
├── backend/                  # Express + TypeScript server
│   ├── src/
│   │   ├── index.ts         # Entry point; Express app setup + routes
│   │   ├── realtime.ts      # Socket.IO initialization
│   │   ├── config/
│   │   │   └── featureTiers.ts  # Subscription tier definitions
│   │   ├── db/
│   │   │   ├── supabase.ts  # Supabase client
│   │   │   ├── gemini.ts    # Gemini AI client
│   │   │   ├── firebase.ts  # Firebase admin SDK
│   │   │   └── stripe.ts    # Stripe client
│   │   ├── middleware/
│   │   │   └── auth.ts      # Firebase token verification + tier gating
│   │   ├── routes/          # HTTP endpoint handlers
│   │   │   ├── topics.ts    # GET /api/topics, /api/topics/:id
│   │   │   ├── questions.ts # GET /api/questions/:id, /api/topics/:id/questions
│   │   │   ├── attempts.ts  # POST /api/attempts, GET /api/attempts
│   │   │   ├── concepts.ts  # GET /api/topics/:id/concepts
│   │   │   ├── stars.ts     # POST/GET /api/stars
│   │   │   ├── streaks.ts   # GET /api/streaks
│   │   │   ├── chat.ts      # POST/GET /api/chat (AI hints)
│   │   │   ├── grade.ts     # POST /api/grade (photo grading)
│   │   │   ├── pair.ts      # POST /api/pair (phone QR pairing)
│   │   │   ├── review.ts    # GET /api/review/* (study recommendations)
│   │   │   └── billing.ts   # POST /api/billing (Stripe checkout)
│   │   ├── services/        # Business logic
│   │   │   ├── topicService.ts      # Topic listing + progress calculation
│   │   │   ├── questionService.ts   # Question loading + solution stripping
│   │   │   ├── attemptService.ts    # Answer grading (exact/range/mcq)
│   │   │   ├── chatService.ts       # Gemini Socratic tutor
│   │   │   ├── gradingService.ts    # Photo grading (Gemini vision)
│   │   │   ├── starService.ts       # Favorite/bookmark management
│   │   │   ├── streakService.ts     # Streak + heatmap data
│   │   │   ├── pairService.ts       # Phone upload token management
│   │   │   ├── spacedRepetitionService.ts  # SRS cards
│   │   │   ├── reviewService.ts     # Study recommendations
│   │   │   ├── billingService.ts    # Stripe integration
│   │   │   └── diagnosticService.ts # Weakness analysis
│   │   └── types/
│   │       └── index.ts         # Shared types (Question, Attempt, etc.)
│   ├── supabase/
│   │   └── migrations/          # SQL migrations (topics, questions, schema)
│   ├── scripts/                 # Utility scripts
│   ├── package.json
│   ├── tsconfig.json
│   └── .env.example
│
├── frontend/                 # React 19 + Vite
│   ├── src/
│   │   ├── main.tsx        # React root; mounts App
│   │   ├── App.tsx         # Router setup; RootLayout + pages
│   │   ├── index.css       # Global Tailwind styles
│   │   ├── components/     # Reusable UI components
│   │   │   ├── question/   # Question display, answers, grading
│   │   │   │   ├── QuestionCard.tsx
│   │   │   │   ├── QuestionHeader.tsx
│   │   │   │   ├── AnswerInput.tsx    # MathLive + type input
│   │   │   │   ├── MultiPartQuestion.tsx  # Multi-part workflow
│   │   │   │   ├── MultiFieldInput.tsx    # Multi-box inputs (a, b, c)
│   │   │   │   ├── PhotoAnswer.tsx   # Camera + photo upload
│   │   │   │   ├── GradingResult.tsx # Grading feedback display
│   │   │   │   ├── TranscriptionEditor.tsx  # Edit AI transcription
│   │   │   │   ├── McqInput.tsx
│   │   │   │   └── SolutionReveal.tsx    # Show answer after correct
│   │   │   ├── chat/       # AI hint chatbot
│   │   │   │   └── ChatPanel.tsx
│   │   │   ├── math/       # Math rendering
│   │   │   │   ├── MathField.tsx    # MathLive wrapper
│   │   │   │   ├── MathKeyboard.tsx # Symbol panel
│   │   │   │   ├── Latex.tsx        # Render pure LaTeX
│   │   │   │   └── LatexBlock.tsx   # Block display math
│   │   │   ├── progress/   # Progress tracking UI
│   │   │   │   ├── StatsBar.tsx     # Session correct/total + streak
│   │   │   │   └── AttemptRow.tsx   # Attempt history row
│   │   │   ├── topic/      # Topic browsing
│   │   │   │   ├── TopicGrid.tsx
│   │   │   │   ├── TopicCard.tsx
│   │   │   │   ├── TopicDrawer.tsx  # Right-side question list
│   │   │   │   ├── QuestionTable.tsx
│   │   │   │   ├── RoadmapGraph.tsx # Pan/zoom topic tree
│   │   │   │   ├── AccuracyTable.tsx
│   │   │   │   └── ConceptsList.tsx
│   │   │   ├── pair/       # Phone upload
│   │   │   │   ├── QrPairModal.tsx  # Generate QR
│   │   │   │   └── PhonePreview.tsx
│   │   │   ├── layout/     # Page structure
│   │   │   │   ├── Header.tsx       # Nav bar + auth
│   │   │   │   └── StudyPlanSidebar.tsx
│   │   │   ├── sidebar/    # Topic sidebar
│   │   │   │   └── QuestItem.tsx
│   │   │   ├── ui/         # Generic UI atoms
│   │   │   │   ├── Button.tsx
│   │   │   │   ├── Card.tsx
│   │   │   │   ├── Badge.tsx
│   │   │   │   ├── Spinner.tsx
│   │   │   │   ├── ErrorMessage.tsx
│   │   │   │   ├── ProgressBar.tsx
│   │   │   │   └── StreakNotification.tsx
│   │   │   ├── LoginModal.tsx
│   │   │   ├── UpgradeModal.tsx
│   │   │   └── PremiumExpiryBanner.tsx
│   │   ├── pages/          # Route-level pages
│   │   │   ├── LandingPage.tsx   # Marketing landing page (/)
│   │   │   ├── HomePage.tsx      # Roadmap (/roadmap)
│   │   │   ├── PracticePage.tsx  # Question solver (/practice/:topicId)
│   │   │   ├── HistoryPage.tsx   # Attempt history (/history)
│   │   │   ├── StatsPage.tsx     # Streak + heatmap (/stats)
│   │   │   ├── StarredPage.tsx   # Bookmarks (/starred)
│   │   │   ├── ReviewPage.tsx    # Study recommendations (/review)
│   │   │   ├── StudyPlanPage.tsx # Roadmap alternative (/study-plan)
│   │   │   └── MobileUploadPage.tsx  # Phone upload (/m/:token)
│   │   ├── hooks/          # Custom hooks (data fetching + state)
│   │   │   ├── usePracticeSession.ts # Question workflow state machine
│   │   │   ├── useTopics.ts          # Fetch topic list
│   │   │   ├── useTopicQuestions.ts  # Fetch questions for a topic
│   │   │   ├── useTopicsProgress.ts  # Fetch progress per topic
│   │   │   ├── useAttemptHistory.ts  # Fetch attempt list
│   │   │   ├── useChatSession.ts     # Chat state management
│   │   │   ├── usePairSocket.ts      # Phone upload Socket.IO
│   │   │   ├── useStudyPlan.ts       # Study plan data
│   │   │   ├── useConcepts.ts        # Topic concepts
│   │   │   ├── useVisitedTopics.ts   # Track visited topics
│   │   │   └── useFeature.ts         # Feature flag checks
│   │   ├── contexts/       # Global state (React Context)
│   │   │   └── AuthContext.tsx  # Firebase auth + subscription tier + modals
│   │   ├── lib/            # Utilities + API
│   │   │   ├── api.ts      # Centralized HTTP client (all endpoints)
│   │   │   ├── socket.ts   # Socket.IO instance
│   │   │   ├── firebase.ts # Firebase config
│   │   │   ├── renderLatex.tsx  # Mixed text+math rendering
│   │   │   ├── studyPlan.ts    # Study plan algorithms
│   │   │   └── utils.ts        # cn(), formatTime(), etc.
│   │   ├── types/          # TypeScript interfaces
│   │   │   └── api.ts      # API types (mirror backend)
│   │   └── assets/         # Images, icons
│   ├── public/             # Static files (favicon, etc.)
│   ├── vite.config.ts      # Vite config (proxy to backend)
│   ├── tsconfig.json
│   ├── tsconfig.app.json
│   ├── tsconfig.node.json
│   ├── package.json
│   └── index.html
│
├── .planning/              # GSD planning artifacts
│   ├── codebase/           # This directory
│   │   └── *.md            # ARCHITECTURE.md, STRUCTURE.md, etc.
│   └── phases/             # Phase plans + execution logs
│
├── 2025/                   # Exam papers (organized by school + subject)
│   ├── ASRJC/, DHS/, HCI/, ACJC/, CJC/, RI/, etc.
│   └── (directories contain extracted question PDFs)
│
├── package.json            # Root workspace (concurrently)
├── CLAUDE.md               # Project guidelines
└── .gitignore
```

## Directory Purposes

**Backend: `backend/src/`**
- **index.ts** — Initializes Express, mounts routes, starts http.Server, attaches Socket.IO
- **realtime.ts** — Socket.IO server factory; manages pairing room subscriptions
- **config/** — Feature tier definitions (free vs. paid)
- **db/** — Third-party client setup (no query logic here)
- **middleware/** — Request-level auth + feature gating
- **routes/** — Thin HTTP handlers; parse → validate → call service → respond
- **services/** — Business logic; coordinate db + external APIs (Gemini, Stripe)
- **types/** — Shared TS interfaces (Question, Attempt, etc.)

**Frontend: `frontend/src/`**
- **main.tsx** — Entry point; mounts React to DOM
- **App.tsx** — Router + RootLayout
- **components/** — Reusable UI; organized by concern (question, chat, math, etc.)
- **pages/** — Route-level containers; load data via hooks, manage page state
- **hooks/** — Data fetching + state management; encapsulate business logic
- **contexts/** — Global state (AuthContext: login, tier, modal toggles)
- **lib/** — Utilities + API abstraction
- **types/** — Frontend TS types (mirrors backend api.ts types)

**Supabase: `backend/supabase/`**
- **migrations/** — SQL DDL/DML; run sequentially to build schema
- Migrations install tables, indexes, RLS policies, and question data

## Key File Locations

**Entry Points:**
- Frontend: `frontend/src/main.tsx` → `frontend/src/App.tsx` (loads AuthProvider, router)
- Backend: `backend/src/index.ts` (Express app, routes, Socket.IO)
- Frontend Router: `frontend/src/App.tsx` (createBrowserRouter, routes for all pages)

**Configuration:**
- Frontend Vite: `frontend/vite.config.ts` (dev server, proxies to backend, LAN binding)
- Backend TypeScript: `backend/tsconfig.json` (NodeNext, ESM)
- Frontend TypeScript: `frontend/tsconfig.json` (React, DOM lib)
- Feature Tiers: `backend/src/config/featureTiers.ts` (defines which features are free/paid)

**Core Logic:**
- Attempt Grading: `backend/src/services/attemptService.ts` (exact/range/mcq checking, multipoint symbolic eval)
- Photo Grading: `backend/src/services/gradingService.ts` (Gemini vision, structured grading output)
- Chat (Hints): `backend/src/services/chatService.ts` (Gemini Socratic tutor, rate-limited)
- Session State: `frontend/src/hooks/usePracticeSession.ts` (question workflow reducer)
- API Client: `frontend/src/lib/api.ts` (all HTTP endpoints, auth injection, error mapping)

**Testing:**
- No test files present (TDD not implemented)

**Database:**
- Schema: `backend/supabase/migrations/` (001_initial_schema.sql → 021_enable_typed_submissions.sql)
- Questions: Auto-loaded from Supabase on app startup (no fixtures)

## Naming Conventions

**Files:**
- Routes: `backend/src/routes/<feature>.ts` (singular, kebab-case for multi-word: attempts.ts, chat.ts, grade.ts)
- Services: `backend/src/services/<feature>Service.ts` (Service suffix, camelCase)
- Pages: `frontend/src/pages/<PascalCase>Page.tsx` (uppercase P, -Page suffix)
- Components: `frontend/src/components/<feature>/<Name>.tsx` (PascalCase, organized in subfolders by feature)
- Hooks: `frontend/src/hooks/use<Name>.ts` (use prefix, camelCase, kebab-case for multi-word: usePracticeSession)
- Contexts: `frontend/src/contexts/<Name>Context.tsx` (Context suffix)

**Functions:**
- Service exports: `getAttemptsBySession()`, `submitAttempt()`, `calculateTopicProgress()` (imperative verbs, camelCase)
- React hooks: `usePracticeSession()`, `useTopics()` (use prefix, camelCase)
- Utilities: `normalizeLaTeX()`, `latexToMathExpr()`, `checkAnswer()` (descriptive camelCase)
- API endpoints: `api.topics.list()`, `api.questions.get()`, `api.attempts.submit()` (nested object, lowercase, matching REST semantics)

**Variables:**
- Session: `sessionId` (UUIDv4, stored in localStorage under key 'session_id')
- User: `req.user` (injected by auth middleware, contains `{ uid, firebaseUid, email, tier }`)
- State: `phase`, `question`, `result`, `gradingResult` (specific domain names, not generic `state`)
- React state: `const [isLoading, setIsLoading] = useState(false)` (boolean with is/set prefix)

**Types:**
- Public API types: `QuestionPublic`, `SubmitAttemptResponse`, `GradeResponse` (Response suffix for endpoint returns)
- Database types: `Question`, `Attempt`, `Topic` (base name, full shape)
- Enum-like: `type MathLevel = 'H1' | 'H2'`, `type PracticePhase = 'loading' | 'answering' | ...` (union types, lowercase strings)

**Routes / API Endpoints:**
- Resource: `/api/topics`, `/api/questions`, `/api/attempts` (plural, REST)
- Sub-resource: `/api/topics/:id/questions`, `/api/topics/:id/concepts` (nested)
- Action: `/api/topics/:id/next` (verb phrase for special query)
- Collection: `/api/stars/all`, `/api/chat` (list all or stream)

## Where to Add New Code

**New Feature (e.g., "AI workout generation"):**

1. **Backend service:** `backend/src/services/workoutService.ts` — exports functions to generate, store, retrieve workouts
2. **Backend route:** `backend/src/routes/workouts.ts` — POST /api/workouts, GET /api/workouts/:id
3. **Backend middleware:** If paywalled feature, add to `backend/src/config/featureTiers.ts` (e.g., `workouts: 'paid'`)
4. **Frontend hook:** `frontend/src/hooks/useWorkouts.ts` — data fetching + state (mirrors api.workouts.* calls)
5. **Frontend page or component:** `frontend/src/pages/WorkoutPage.tsx` or `frontend/src/components/workout/WorkoutCard.tsx`
6. **Frontend API client:** Add to `frontend/src/lib/api.ts` → `export const api = { ..., workouts: { ... } }`
7. **Frontend types:** `frontend/src/types/api.ts` → add Workout, WorkoutResponse interfaces

**New Component:**
- Location: `frontend/src/components/<category>/<Name>.tsx` (organize by parent feature)
- Props: Type strictly with interfaces; no `any`
- Hooks: Use custom hooks for data; keep component presentational if possible
- Styles: Tailwind via `cn()` from `frontend/src/lib/utils.ts`

**New Hook:**
- Location: `frontend/src/hooks/use<Name>.ts`
- Pattern: Call `api.<namespace>.<method>()`, manage loading/error/data state, return clean interface
- Example: `usePracticeSession()` returns object with `{ phase, question, submitAnswer(), ... }`

**New Service:**
- Location: `backend/src/services/<domain>Service.ts`
- Pattern: Export pure functions that take user ID + params, call supabase or external APIs, return domain objects
- No side effects (logging OK); all validation in route (Zod), all errors thrown (route catches)

**New Migration:**
- Location: `backend/supabase/migrations/<NNN>_<description>.sql`
- Pattern: Number sequentially; use dollar-quoting (`$$...$$`) for LaTeX/multi-line strings; include GRANT statements for RLS
- Run in Supabase SQL Editor to test before committing

**Test:**
- Status: No test files exist; testing is manual (run app, verify in browser/Postman)
- If adding: Create `backend/src/services/__tests__/` and `frontend/src/hooks/__tests__/` directories
- Framework: Jest (dev dependency installed but unused)

## Special Directories

**`backend/supabase/migrations/`**
- Purpose: Version-controlled schema + data
- Generated: No (hand-written)
- Committed: Yes
- Pattern: Each migration is one `.sql` file; idempotent within a transaction; numbered 001–021+ in order
- Content: CREATE TABLE, ALTER TABLE, INSERT INTO questions, GRANT RLS policies

**`backend/dist/`, `frontend/dist/`**
- Purpose: Compiled output (TypeScript → JavaScript for backend; Vite bundle for frontend)
- Generated: Yes (npm run build)
- Committed: No (.gitignore)
- Used: Production deployment (Node runs from dist/, web server serves from frontend/dist/)

**`.planning/codebase/`**
- Purpose: Architecture documentation (this directory)
- Generated: By gsd-map-codebase agent
- Committed: Yes
- Content: ARCHITECTURE.md, STRUCTURE.md, etc. — consumed by gsd-plan-phase and gsd-execute-phase

**`2025/ASRJC/`, `2025/DHS/`, etc.**
- Purpose: Exam papers organized by school + year
- Generated: No (manually downloaded from school websites)
- Committed: Yes (git-lfs for large PDFs if used)
- Use: Source material for question extraction (see skill-exam-extraction.md)

---

*Structure analysis: 2026-07-04*
