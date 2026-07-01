# Coding Conventions

**Analysis Date:** 2026-06-29

## TypeScript Configuration

**Backend** (`backend/tsconfig.json`):
- `strict: true`
- `module: NodeNext`, `moduleResolution: NodeNext`
- All backend imports use the `.js` extension even for `.ts` source files (NodeNext requirement)
  - Example: `import { supabase } from '../db/supabase.js'`
- `target: ES2022`, `esModuleInterop: true`
- No `any` — the CLAUDE.md explicitly prohibits it. Cast using `as Error`, `as unknown`, etc.

**Frontend** (`frontend/tsconfig.app.json`):
- `moduleResolution: bundler` (no extensions needed on imports)
- `verbatimModuleSyntax: true` — use `import type` for type-only imports
- `noUnusedLocals: true`, `noUnusedParameters: true`
- `noFallthroughCasesInSwitch: true`
- Linting: `typescript-eslint` + `eslint-plugin-react-hooks` + `eslint-plugin-react-refresh`

## Backend Layering

Strict three-layer architecture — never skip layers:

```
Route handler  (backend/src/routes/*.ts)
   ↓
Service layer  (backend/src/services/*Service.ts)
   ↓
DB layer       (backend/src/db/supabase.ts, backend/src/db/gemini.ts)
```

- Routes are thin: parse + validate request, call one service function, respond.
- Services own all business logic. Never call `supabase` from a route file.
- DB modules export configured clients only (`supabase`, `gemini`).

**Route pattern** (`backend/src/routes/attempts.ts`):
```typescript
router.post('/', ...gate('practice'), async (req, res) => {
  try {
    const body = submitSchema.parse(req.body)        // Zod parse
    const result = await submitAttempt(req.user!.uid, body)
    res.status(201).json(result)
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues })
      return
    }
    if ((err as Error).message.includes('not found')) {
      res.status(404).json({ error: (err as Error).message })
      return
    }
    res.status(500).json({ error: (err as Error).message })
  }
})
```

## Zod Validation

Every route validates inputs with Zod before passing to the service layer.

- `req.body` → declare a named schema (e.g., `submitSchema`), call `.parse(req.body)`
- `req.query` → inline: `z.string().uuid().parse(req.query.question_id)` or via schema
- ZodError caught in the route's catch block → HTTP 400 with `details: err.issues`
- No validation in service layer — services assume pre-validated inputs

## Authentication & Auth Middleware

`backend/src/middleware/auth.ts` exports `requireAuth` and `gate(feature)`.

- `gate(feature)` returns `[requireAuth, tierCheck]` as a `RequestHandler[]` array
- Routes spread it: `router.get('/', ...gate('practice'), handler)`
- Authenticated user is on `req.user!.uid` (Supabase user `id`, not Firebase UID)
- Tier on `req.user!.tier` — `'free' | 'paid'`
- Feature-tier mapping: `backend/src/config/featureTiers.ts`

## Error Handling Patterns

**Backend:**
- Service functions throw `new Error(message)` on failure
- Supabase errors: `if (error) throw new Error(error.message)`
- Route catches classify by error message string (`.includes('not found')`) or instance type
- Non-critical async: fire-and-forget with `.catch(() => {})`:
  ```typescript
  upsertSRCard(...).catch(() => { /* non-critical */ })
  ```

**Frontend:**
- `frontend/src/lib/api.ts` `request()` centralizes all fetch calls
- 401 → calls `_callbacks.onUnauthorized()` then throws
- 402 → calls `_callbacks.onPaymentRequired()` then throws
- Non-ok responses: reads JSON body for `error` field, falls back to `res.statusText`
- Components never call `fetch` directly — always through `api.*`

## Frontend API Pattern

All HTTP calls go through `frontend/src/lib/api.ts`:

```typescript
export const api = {
  topics: { list, get, questions, concepts, progress, accuracy },
  questions: { next, get, solution },
  attempts: { submit, list },
  stars: { toggle, list, listAll },
  streaks: { get },
  chat: { history, send },
  grade: { submit, history },
  pair: { create, context, uploadPhoto, done },
  review: { corrections, weakTopics, speedDrills, spaced, random, diagnosis, studyPlan },
}
```

Two base helpers:
- `request<T>(path, init?)` — JSON requests, injects `Content-Type: application/json` + auth header
- `requestFormData<T>(path, fd)` — multipart, injects auth header only (no Content-Type)

Both helpers call `auth.currentUser?.getIdToken()` from Firebase to get the Bearer token.

## Custom Hook Patterns

Hooks live in `frontend/src/hooks/`:

| Hook | Pattern |
|------|---------|
| `usePracticeSession.ts` | `useReducer` state machine + `useCallback` actions |
| `useChatSession.ts` | Optimistic send with rollback on error |
| `usePairSocket.ts` | Socket.IO event listeners → calls into practice session |
| `useTopics.ts`, `useTopicsProgress.ts` | `useState` + `useEffect` data fetch |
| `useFeature.ts` | Reads `useAuth().tier` to check feature access |
| `useVisitedTopics.ts` | `localStorage`-backed Set |
| `useStudyPlan.ts` | Study plan fetch + sync |

**State machine pattern** (`usePracticeSession.ts`):
- `useReducer` with explicit `PracticeState` type and discriminated union `Action` type
- Phase progression: `'loading' → 'answering' → 'submitted' → 'revealed' → 'complete' | 'error'`
- Phase `'answering'` returns to itself for `GRADE_REJECTED` (soft error, no penalty)

## Multi-Part Question Submission Pattern

Multi-part questions (`question.parts != null`) track per-part state in `partStates: Record<string, PartState>` inside `usePracticeSession`. Each part has `phase: 'idle' | 'submitting' | 'done'` and an optional `isCorrect` flag.

**The reveal trigger lives entirely in the frontend reducer — never in the backend signal.**

The session transitions to `phase: 'revealed'` only when every graded part in the *current session* has `phase === 'done'` in `updatedPartStates`. "Graded" means `part.answer_type !== null` (show-that parts are excluded).

```ts
// CORRECT — PART_SUBMIT_DONE case in usePracticeSession.ts
const gradedParts = state.question?.parts?.filter((p) => p.answer_type !== null) ?? []
const allPartsSubmitted = gradedParts.every((p) => updatedPartStates[p.label]?.phase === 'done')
if (allPartsSubmitted) { /* transition to revealed */ }
```

**Never use `action.solutionLatex !== null` as the reveal trigger.** The backend returns `solution_latex` whenever all graded parts exist in the DB across *any* historical attempt — including previous retries. On a retry the backend returns `solution_latex` after the very first part is submitted (old attempts cover the rest), so using it as a gate causes immediate premature reveal, locks out remaining input boxes, and incorrectly scores the question as wrong. `action.solutionLatex` is used only as the solution *content* when the frontend decides to reveal:

```ts
result: { ..., solution_latex: action.solutionLatex }  // content only, not a trigger
```

**Scoring invariant:** `sessionTotal` and `streak` are incremented exactly once, at the moment of reveal. `allCorrect` is `true` only if every graded part in `updatedPartStates` has `isCorrect === true`.

**Show-that parts:** `answer_type === null` → excluded from `gradedParts`, never reach `phase: 'done'`, and do not block reveal. UI renders "Show that — no submission required".

**Multi-box parts:** Parts with an `answers[]` array carry a non-null `answer_type` sentinel at the part level. They are included in `gradedParts` and behave identically to single-box graded parts — the whole part becomes `'done'` once the multi-box submit fires.

**Files:**
- `frontend/src/hooks/usePracticeSession.ts` — `PART_SUBMIT_DONE` reducer case (reveal logic)
- `frontend/src/components/question/MultiPartQuestion.tsx` — `PartInput`, `MultiFieldInput` (per-part UI)
- `frontend/src/pages/PracticePage.tsx` — `showTypedMultiPart`, `revealed` prop passed to `MultiPartQuestion`

## Naming Conventions

**Files:**
- React components: `PascalCase.tsx` (e.g., `QuestionCard.tsx`, `ChatPanel.tsx`)
- Hooks: `camelCase` prefixed `use` (e.g., `usePracticeSession.ts`)
- Backend routes: `camelCase` domain noun (e.g., `attempts.ts`, `chat.ts`)
- Backend services: `camelCase` + `Service` suffix (e.g., `attemptService.ts`)

**Functions:**
- React components: `PascalCase`
- Custom hooks: `useCamelCase`
- Service functions: camelCase verb-noun (e.g., `submitAttempt`, `getAttemptsBySession`)
- Utilities: camelCase verb-noun (e.g., `normalizeLaTeX`, `renderLatex`, `formatTime`)

**Types/Interfaces:**
- `PascalCase` throughout (e.g., `QuestionPublic`, `SubmitAttemptResponse`, `PracticePhase`)
- Frontend types in `frontend/src/types/api.ts` mirror backend types in `backend/src/types/index.ts`

**Constants:**
- `UPPER_SNAKE_CASE` for module-level constants (e.g., `FEATURE_TIERS`, `DELIMITERS`)

## LaTeX Rendering

Three rendering primitives — choose based on context:

| Primitive | When to Use | Source |
|-----------|-------------|--------|
| `renderLatex(source)` | Mixed text + math content (question prompts, AI chat replies, grading feedback). Splits on `\(...\)` (inline) and `\[...\]` (block) delimiters. Returns `ReactNode[]`. | `frontend/src/lib/renderLatex.tsx` |
| `<Latex>{rawLatex}</Latex>` | Pure LaTeX, inline display (keyboard button labels, correct answer display) | `frontend/src/components/math/Latex.tsx` |
| `<LatexBlock>{rawLatex}</LatexBlock>` | Pure LaTeX, block/display-mode (used internally by `renderLatex()`) | `frontend/src/components/math/LatexBlock.tsx` |

**Usage locations for `renderLatex()`:**
- `QuestionCard.tsx` — `question.prompt_latex`
- `MultiPartQuestion.tsx` — `part.prompt_latex`
- `ChatPanel.tsx` — AI reply content
- `GradingResult.tsx` — part summaries, error descriptions, hints, overall feedback
- `McqInput.tsx` — MCQ option text
- `PracticePage.tsx` — solution reveal blocks

**Rule:** Never pass raw LaTeX to plain `<span>` or string interpolation.

## State Placement

| State Type | Location |
|------------|----------|
| Auth (user, tier, loading) | `AuthContext` in `frontend/src/contexts/AuthContext.tsx` |
| Practice session (question, phase, results) | `usePracticeSession` hook |
| Chat messages | `useChatSession` hook |
| Study plan | `useStudyPlan` hook |
| Visited topics (cross-session) | `useVisitedTopics` — `localStorage`-backed |
| UI toggles local to one component | `useState` in that component |

## Styling Pattern

- Tailwind CSS utility classes throughout
- Class merging via `cn(...classes)` from `frontend/src/lib/utils.ts`:
  ```typescript
  export function cn(...classes: (string | undefined | false | null)[]): string {
    return classes.filter(Boolean).join(' ')
  }
  ```
  (Custom — no `clsx` or `tailwind-merge` dependency)
- Responsive breakpoints: `lg:hidden` / `hidden lg:flex` for mobile/desktop splits

## Import Style

**Backend:** Always use `.js` extension on relative imports:
```typescript
import { supabase } from '../db/supabase.js'
import type { Attempt } from '../types/index.js'
```

**Frontend:** No extensions, no path aliases — plain relative imports:
```typescript
import { api } from '../lib/api'
import type { QuestionPublic } from '../types/api'
```

Use `import type` (not bare `import`) for type-only imports (enforced by `verbatimModuleSyntax`).

## Deviations from Typical React/Express Conventions

1. **No session_id in headers** — Firebase UID resolved to Supabase `users.id` is used as session key, available as `req.user!.uid` after the `gate()` middleware.
2. **`gate()` returns a handler array** — spread with `...gate('feature')` in route definitions, not used as a single middleware argument.
3. **`useReducer` for practice state** — chosen over multiple `useState` to make the state machine explicit and prevent impossible states.
4. **StrictMode double-invoke rule** — never guard effects with a `firstLoad` ref; use idempotent `loadSpecific(id)` / `loadNext()` instead.
5. **Fire-and-forget spaced repetition** — `upsertSRCard()` called without `await`, errors swallowed, deliberately non-blocking.
6. **Error classification by string match** — `(err as Error).message.includes('not found')` instead of custom error classes.

---

*Convention analysis: 2026-06-29*
