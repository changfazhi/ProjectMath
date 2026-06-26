# Codebase Structure

**Analysis Date:** 2026-06-26

## Directory Layout

```
frontend/
├── src/
│   ├── main.tsx                    # React root entry; renders App
│   ├── App.tsx                     # Router setup; RootLayout
│   ├── App.css                     # Global styles
│   ├── index.css                   # Tailwind imports
│   │
│   ├── pages/                      # Route handlers
│   │   ├── HomePage.tsx            # Roadmap + topic drawer (/)
│   │   ├── PracticePage.tsx        # Question answering (/practice/:topicId)
│   │   ├── HistoryPage.tsx         # Past attempts (/history)
│   │   ├── StarredPage.tsx         # Bookmarked questions (/starred)
│   │   ├── StatsPage.tsx           # Streak heatmap & analytics (/stats)
│   │   ├── ReviewPage.tsx          # Spaced-repetition queue (/review)
│   │   └── MobileUploadPage.tsx    # Phone upload target (/m/:token)
│   │
│   ├── hooks/                      # State + data fetching
│   │   ├── usePracticeSession.ts   # Practice state machine (reducer)
│   │   ├── useTopics.ts            # Fetch all topics + loading
│   │   ├── useTopicsProgress.ts    # Per-topic completion stats
│   │   ├── useTopicQuestions.ts    # Questions in a topic
│   │   ├── useChatSession.ts       # AI hint chat messages
│   │   ├── usePairSocket.ts        # Phone pairing socket listener
│   │   ├── useAttemptHistory.ts    # Past attempts for a question
│   │   ├── useConcepts.ts          # Topic prerequisite concepts
│   │   └── useVisitedTopics.ts     # Track visited topics in localStorage
│   │
│   ├── components/
│   │   ├── ui/                     # Reusable primitives
│   │   │   ├── Button.tsx          # Base button component
│   │   │   ├── Card.tsx            # Card wrapper
│   │   │   ├── Badge.tsx           # Status/label badge
│   │   │   ├── Spinner.tsx         # Loading spinner
│   │   │   ├── ErrorMessage.tsx    # Error display
│   │   │   ├── ProgressBar.tsx     # Progress bar
│   │   │   └── StreakNotification.tsx # Modal for streak milestone
│   │   │
│   │   ├── layout/
│   │   │   └── Header.tsx          # Top nav bar (logo, settings)
│   │   │
│   │   ├── topic/                  # Topic-related UI
│   │   │   ├── RoadmapGraph.tsx    # SVG pan/zoom tree layout
│   │   │   ├── TopicDrawer.tsx     # Right slide-out panel
│   │   │   ├── TopicCard.tsx       # Individual topic node
│   │   │   ├── TopicGrid.tsx       # Grid layout for topics
│   │   │   ├── ConceptsList.tsx    # Prerequisite concepts
│   │   │   ├── QuestionTable.tsx   # Questions in topic (table)
│   │   │   └── AccuracyTable.tsx   # Topic accuracy stats
│   │   │
│   │   ├── question/               # Question-answering UI
│   │   │   ├── QuestionCard.tsx    # Question prompt display
│   │   │   ├── QuestionHeader.tsx  # Question title + metadata
│   │   │   ├── AnswerInput.tsx     # Router for answer type
│   │   │   ├── ExactInput.tsx      # LaTeX answer box (MathLive)
│   │   │   ├── RangeInput.tsx      # Numerical range answer
│   │   │   ├── McqInput.tsx        # Multiple-choice
│   │   │   ├── PhotoAnswer.tsx     # Camera/photo upload
│   │   │   ├── MultiPartQuestion.tsx # Per-part sub-questions
│   │   │   ├── GradingResult.tsx   # Grading outcome (photo)
│   │   │   └── SolutionReveal.tsx  # Model solution display
│   │   │
│   │   ├── math/                   # Math input & rendering
│   │   │   ├── Latex.tsx           # KaTeX inline renderer
│   │   │   ├── LatexBlock.tsx      # KaTeX block renderer
│   │   │   ├── MathField.tsx       # MathLive editor wrapper
│   │   │   └── MathKeyboard.tsx    # Symbol panel for MathLive
│   │   │
│   │   ├── chat/
│   │   │   └── ChatPanel.tsx       # AI hint chatbot UI
│   │   │
│   │   ├── progress/
│   │   │   ├── StatsBar.tsx        # Session streak/count display
│   │   │   └── AttemptRow.tsx      # Past attempt list item
│   │   │
│   │   └── pair/
│   │       └── QrPairModal.tsx     # QR modal for phone pairing
│   │
│   ├── lib/                        # Utilities & cross-cutting
│   │   ├── api.ts                  # Fetch wrapper & domains
│   │   ├── socket.ts               # Socket.IO singleton
│   │   ├── session.ts              # UUID session ID (localStorage)
│   │   ├── renderLatex.tsx         # Parse mixed text+math
│   │   └── utils.ts                # Tailwind cn(), formatTime()
│   │
│   ├── contexts/
│   │   └── ThemeContext.tsx        # Light/dark mode context
│   │
│   ├── types/
│   │   ├── api.ts                  # API response types (mirrors backend)
│   │   └── mathlive.d.ts           # MathLive type definitions
│   │
│   └── assets/                     # Static assets (icons, images)
│       └── [files]
│
├── index.html                      # Entry HTML; mounts #root
├── vite.config.ts                  # Vite dev server + proxy config
├── tsconfig.json                   # TypeScript config (base)
├── tsconfig.app.json               # App-specific TS config
├── tsconfig.node.json              # Node TS config (Vite, etc.)
├── eslint.config.js                # ESLint rules
├── package.json                    # Dependencies & scripts
├── package-lock.json               # Lockfile
├── public/                         # Static files (served by Vite)
└── .planning/codebase/             # This documentation
```

## Directory Purposes

**`src/pages/`:**
- Purpose: Route handlers mapped 1:1 to paths in React Router
- Contains: One `.tsx` per route (HomePage, PracticePage, etc.)
- Key files: `PracticePage.tsx` (largest, ~300 lines); handles all question flow UI

**`src/hooks/`:**
- Purpose: Encapsulate data fetching, state machines, side effects
- Contains: Custom hooks; no React components
- Key files: `usePracticeSession.ts` (reducer-based state machine); `useTopics.ts`, `useChatSession.ts` (data fetching)
- Pattern: Return object with state + methods; cleanup functions in useEffect

**`src/components/ui/`:**
- Purpose: Reusable, domain-agnostic UI primitives
- Contains: Button, Card, Badge, Spinner, ErrorMessage, ProgressBar, StreakNotification
- Dependencies: None except React; accept className for Tailwind customization

**`src/components/topic/`:**
- Purpose: Topic navigation and visualization
- Contains: RoadmapGraph (complex SVG), TopicDrawer (panel), ConceptsList, QuestionTable, AccuracyTable
- Key file: `RoadmapGraph.tsx` — hardcoded node positions and edges; rendered as SVG canvas

**`src/components/question/`:**
- Purpose: Question answering UI
- Contains: QuestionCard (prompt), AnswerInput (dispatcher), ExactInput (MathLive), PhotoAnswer (camera), MultiPartQuestion, GradingResult, SolutionReveal
- Pattern: Leaf components accept single responsibility; parent (PracticePage) composes them

**`src/components/math/`:**
- Purpose: Math rendering and input
- Contains: Latex (KaTeX inline), LatexBlock (KaTeX display), MathField (MathLive wrapper), MathKeyboard (symbol grid)
- Key file: `MathField.tsx` — wraps `<math-field>` web component; exposes insert(), getValue(), focus()

**`src/lib/api.ts`:**
- Purpose: Single entry point for all backend communication
- Contains: `request()` and `requestFormData()` wrappers; namespaced domains (topics, questions, attempts, stars, chat, grade, pair, review)
- Pattern: `api.topics.list()`, `api.attempts.submit()`, `api.chat.send()`, etc.

**`src/lib/socket.ts`:**
- Purpose: Singleton Socket.IO connection
- Contains: `getSocket()` — returns shared connection; auto-connect
- Used by: `usePairSocket()` hook for phone pairing real-time events

**`src/lib/session.ts`:**
- Purpose: Session UUID management
- Contains: `getSessionId()` (get or create UUID v4 in localStorage), `clearSession()`
- Pattern: Simple singleton utilities

**`src/lib/renderLatex.tsx`:**
- Purpose: Parse mixed text+LaTeX; convert to JSX
- Splits by `\(...\)` (inline) and `\[...\]` (block) delimiters
- Returns ReactNode[] for composition into larger UI

**`src/contexts/ThemeContext.tsx`:**
- Purpose: Global theme state (light/dark)
- Contains: `ThemeProvider`, `useTheme()`
- Pattern: Simple React Context; reads/writes `localStorage.getItem('math_trainer_theme')`

**`src/types/api.ts`:**
- Purpose: TypeScript interfaces for all API responses
- Contains: `QuestionPublic`, `Attempt`, `ChatMessage`, `GradingResult`, `GradeResponse`, etc.
- Pattern: 1:1 mirror of backend data models

## Key File Locations

**Entry Points:**
- `src/main.tsx` — React DOM mount
- `src/App.tsx` — Router & theme setup
- `index.html` — HTML shell with `<div id="root">`

**Configuration:**
- `vite.config.ts` — Dev server (port 5173), API proxy, Socket.IO proxy
- `tsconfig.json` — TypeScript strict mode, lib ES2020
- `eslint.config.js` — ESLint rules (React, React Hooks)
- `package.json` — Dependencies (React 19, Vite, KaTeX, MathLive, Tailwind, Socket.IO)

**Core Logic:**
- `src/hooks/usePracticeSession.ts` — Practice state machine (reducer, 337 lines)
- `src/lib/api.ts` — REST wrapper & domain grouping (206 lines)
- `src/components/topic/RoadmapGraph.tsx` — SVG tree visualization (hardcoded layout)

**Testing:**
- No test files found; no test framework configured

## Naming Conventions

**Files:**
- Components: `PascalCase.tsx` (e.g., `QuestionCard.tsx`)
- Hooks: `useCarmelCase.ts` (e.g., `usePracticeSession.ts`)
- Utilities: `camelCase.ts` or `.tsx` (e.g., `api.ts`, `renderLatex.tsx`)
- Types: `api.ts` (grouped in one file; not distributed)

**Directories:**
- Feature/domain-based (e.g., `components/topic/`, `components/question/`)
- Grouped by responsibility (e.g., `hooks/`, `lib/`, `contexts/`)
- No index re-exports (direct imports)

**Variables & Functions:**
- camelCase for variables, functions
- PascalCase for React components, classes, types
- UPPER_SNAKE_CASE for constants (e.g., `SESSION_KEY`, `NODE_W`, `POSITIONS`)

## Where to Add New Code

**New Feature (e.g., new answer type, new page):**

1. **New page route:**
   - Create file in `src/pages/NewPage.tsx`
   - Add route in `src/App.tsx` router config
   - If it needs data, create hook in `src/hooks/useNewPageData.ts`

2. **New API endpoint:**
   - Add domain group in `src/lib/api.ts` (e.g., `api.newFeature = { ... }`)
   - Define response types in `src/types/api.ts`
   - Call from hooks, never directly from components

3. **New component:**
   - Place in appropriate subdirectory of `src/components/`
   - If UI primitive → `src/components/ui/`
   - If domain-specific → `src/components/{domain}/`
   - Keep props simple; use hooks for complex state

4. **New state/logic:**
   - Create hook in `src/hooks/useNewFeature.ts`
   - Use `useReducer` for state machines; simple `useState` for leaf state
   - Export both state and methods (e.g., return `{ ...state, loadData, submitAnswer }`)
   - Add cleanup logic in useEffect return

5. **New utility:**
   - Small helpers → `src/lib/utils.ts`
   - Domain-specific (e.g., LaTeX normalization) → new file in `src/lib/`
   - Cross-component rendering → `src/lib/renderLatex.tsx` (already handles mixed text+math)

**New Component/Module:**
- Location depends on purpose:
  - UI primitives → `src/components/ui/`
  - Topic functionality → `src/components/topic/`
  - Question UI → `src/components/question/`
  - Math rendering/input → `src/components/math/`
  - Real-time features → `src/components/pair/`, `src/components/chat/`
  - Progress/stats → `src/components/progress/`

**Utilities & Helpers:**
- Shared utilities → `src/lib/` as separate files or extend `utils.ts`
- LaTeX-related → integrate into `renderLatex.tsx` or create `src/lib/latex.ts`
- Session/auth → extend `src/lib/session.ts`
- API wrapper → add domain group to `src/lib/api.ts`

## Special Directories

**`src/assets/`:**
- Purpose: Static imports (icons, images, fonts)
- Generated: No
- Committed: Yes

**`public/`:**
- Purpose: Files served as-is by Vite; `/` in URL maps to `public/`
- Generated: No
- Committed: Yes (typically favicons, robots.txt)

**`.planning/codebase/`:**
- Purpose: Architecture & structure documentation
- Generated: Yes (by `/gsd-map-codebase`)
- Committed: Yes

**`node_modules/`:**
- Purpose: Installed dependencies
- Generated: Yes
- Committed: No (in .gitignore)

**`dist/`:**
- Purpose: Built output (Vite)
- Generated: Yes (`npm run build`)
- Committed: No (in .gitignore)

---

*Structure analysis: 2026-06-26*
