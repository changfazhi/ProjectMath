# Coding Conventions

**Analysis Date:** 2026-06-28

## Naming Patterns

**Files:**
- React components: PascalCase `.tsx` (e.g., `QuestionCard.tsx`, `MathField.tsx`)
- Hooks: camelCase with `use` prefix, `.ts` (e.g., `usePracticeSession.ts`, `useChatSession.ts`)
- Services: camelCase suffix `Service`, `.ts` (e.g., `attemptService.ts`, `gradingService.ts`)
- Routes: camelCase noun-only, `.ts` (e.g., `attempts.ts`, `topics.ts`)
- Utilities/libs: camelCase, `.ts` (e.g., `api.ts`, `session.ts`, `renderLatex.tsx`)
- Type files: `index.ts` (backend: `src/types/index.ts`), `api.ts` (frontend: `src/types/api.ts`)

**Functions:**
- camelCase everywhere: `submitAttempt`, `normalizeLaTeX`, `checkAnswer`, `getNextQuestion`
- Boolean-returning helpers use verb prefix: `checkAnswer`, `tryNumericEval`, `trySymbolicEval`
- Service functions exported as named exports (no default class)
- React hooks: `use` prefix, exported as named exports

**Variables:**
- camelCase for local variables and parameters
- SCREAMING_SNAKE_CASE for module-level constants: `FEATURE_TIERS`, `DELIMITERS`
- `_` prefix for intentionally unused destructured variables: `const { correct_answer: _ca, solution_latex: _sl, ...pub } = q`

**Types/Interfaces:**
- Backend: `src/types/index.ts` — single source of truth
- Frontend: `src/types/api.ts` — mirrors backend types (client-safe subset)
- Interfaces use PascalCase: `QuestionPublic`, `SubmitAttemptBody`, `GradeResponse`
- Type aliases for unions: `MathLevel = 'H1' | 'H2'`, `Difficulty = 1 | 2 | 3`
- `Public` suffix for client-safe variants: `QuestionPublic`, `QuestionPartPublic`, `ChatMessagePublic`
- Derived types use `Omit`/`Pick`/`&` rather than duplication: `QuestionPublic = Omit<Question, 'correct_answer' | 'solution_latex' | 'parts'> & { parts: ... }`

## Code Style

**Formatting:**
- Backend: semicolons required, 2-space indent (TypeScript strict mode)
- Frontend: no semicolons (except in JSX returns), 2-space indent — inferred from ESLint config
- Both: single quotes for strings

**Linting:**
- Frontend: ESLint flat config (`frontend/eslint.config.js`) — `@typescript-eslint/recommended` + `eslint-plugin-react-hooks` + `eslint-plugin-react-refresh`
- Backend: TypeScript strict mode (`"strict": true` in `backend/tsconfig.json`)
- No `any` types permitted in backend (strict TS)

**TypeScript Settings (backend):**
- `target: ES2022`, `module: NodeNext`, `moduleResolution: NodeNext`
- All imports require `.js` extension (NodeNext resolution): `import { supabase } from '../db/supabase.js'`

## Import Organization

**Backend order:**
1. Node built-ins (`import http from 'node:http'`)
2. Third-party packages (`import express from 'express'`, `import { z } from 'zod'`)
3. Internal imports (`import { supabase } from '../db/supabase.js'`)
4. Type imports (`import type { ... } from '../types/index.js'`)

**Frontend order:**
1. React and react-router-dom
2. Third-party packages
3. Internal contexts/providers
4. Internal components
5. Internal hooks
6. Internal lib utilities
7. Internal types

**Path Aliases:**
- None configured. All imports use relative paths.

## Import Extensions

**Backend:** `.js` extension required on all local imports (NodeNext module resolution). Example:
```typescript
import { submitAttempt } from '../services/attemptService.js';
import type { Attempt } from '../types/index.js';
```

**Frontend:** No extension on `.ts`/`.tsx` imports (Vite handles resolution).

## Error Handling

**Backend routes pattern:**
```typescript
router.post('/', ...gate('practice'), async (req, res) => {
  try {
    const body = submitSchema.parse(req.body);  // Zod validation
    const result = await service(req.user!.uid, body);
    res.status(201).json(result);
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues });
      return;
    }
    if ((err as Error).message.includes('not found')) {
      res.status(404).json({ error: (err as Error).message });
      return;
    }
    res.status(500).json({ error: (err as Error).message });
  }
});
```

**Backend services pattern:**
- Services throw `new Error(message)` on failure
- Supabase errors: `if (error) throw new Error(error.message)`
- "Not found" conveyed via `return null` or `throw new Error('X not found')`

**Frontend API pattern (`lib/api.ts`):**
- All fetch via `request<T>()` helper — throws `Error` on non-2xx
- 401 → calls `_callbacks.onUnauthorized()` then throws
- 402 → calls `_callbacks.onPaymentRequired()` then throws
- Callers (hooks) store error in local state; components render from state

**Fire-and-forget non-critical operations:**
```typescript
upsertSRCard(...).catch(() => {
  // Non-critical; SR state will self-correct on next attempt.
});
```

## Validation

**Backend: Zod everywhere.**
- Schema defined inline or above the route handler
- `schema.parse(req.body)` — throws `ZodError` on failure
- Query params also validated: `z.string().uuid().parse(req.query.question_id)`
- Example: `backend/src/routes/attempts.ts`

**Frontend:** No form validation library. Input constraints via TypeScript types and controlled component state.

## Authentication

**Pattern:** `gate(featureName)` middleware array spread onto routes:
```typescript
router.post('/', ...gate('practice'), async (req, res) => { ... });
```
- `gate()` composes `[requireAuth, tierCheck]` — both are `RequestHandler[]`
- `req.user!` (non-null assertion) safe only after `gate()` middleware
- Feature tiers in `backend/src/config/featureTiers.ts`

## Database Access

**Rule: Never call `supabase` from a route file.** All DB access goes through service functions.
- DB client: `backend/src/db/supabase.ts`
- Pattern: `const { data, error } = await supabase.from('table').select(...)` → check error → return typed data

## Logging

**Framework:** `console.log` / `console.error` — no structured logging library.

**Patterns:**
- Backend startup: `console.log(\`Math Trainer backend running on http://localhost:${PORT}\`)`
- No per-request logging
- Silent swallow of non-critical async errors with inline comment explaining why

## Comments

**When to comment:**
- Non-obvious business logic (answer normalization, symbolic evaluation)
- Fire-and-forget with rationale: `// Non-critical; SR state will self-correct on next attempt.`
- Clarifying notes on constraints: `// Atomic upsert — safe under concurrent first-logins.`
- Section headers within long files using `// ── Header ──────────────────────`

**JSDoc/TSDoc:** Not used. Types are self-documenting via TypeScript interfaces.

## React Component Design

**Export style:** Named exports for all components:
```typescript
export function QuestionCard({ ... }: Props) { ... }
```

**Props interface:** Inline or above component, PascalCase name matching component:
```typescript
interface Props { ... }
export function ComponentName({ prop1, prop2 }: Props) { ... }
```

**State management:** `useReducer` for complex multi-phase state (`usePracticeSession.ts`), `useState` for simple local state. No global state library.

**Context pattern:**
- `createContext<Type | null>(null)` with non-null assertion in hook
- Hook exported: `export function useAuth(): AuthContextValue`
- Hook throws if used outside provider: `if (!ctx) throw new Error('useAuth must be used inside AuthProvider')`
- Example: `frontend/src/contexts/AuthContext.tsx`, `frontend/src/contexts/ThemeContext.tsx`

## API Client Pattern

All HTTP calls go through the namespaced `api` object in `frontend/src/lib/api.ts`:
```typescript
api.attempts.submit({ question_id, answer_given })
api.topics.list()
api.grade.submit(questionId, images, timeTakenS)
```
Never call `fetch()` directly in components or hooks — always use `api.*`.

## Tailwind Usage

Use `cn()` from `frontend/src/lib/utils.ts` for conditional class merging:
```typescript
import { cn } from '../lib/utils'
className={cn('base-class', isActive && 'active-class', disabled && 'opacity-50')}
```

## Math Rendering

Three utilities, each for a different context:
- `renderLatex(source)` — mixed text + math with `\(...\)` / `\[...\]` delimiters → returns `ReactNode[]`
- `<Latex>{rawLatex}</Latex>` — pure LaTeX inline
- `<LatexBlock>{rawLatex}</LatexBlock>` — pure LaTeX block display

Never pass raw LaTeX to `renderLatex()` and never use `renderLatex()` for pure-LaTeX strings.

---

*Convention analysis: 2026-06-28*
