# Coding Conventions

**Analysis Date:** 2026-06-26

## Naming Patterns

**Files:**
- Backend routes: `lowercase.ts` (e.g., `routes/attempts.ts`, `routes/chat.ts`)
- Backend services: `camelCaseService.ts` (e.g., `attemptService.ts`, `gradingService.ts`)
- Frontend components: `PascalCase.tsx` (e.g., `Button.tsx`, `PracticePage.tsx`)
- Frontend hooks: `useCamelCase.ts` (e.g., `usePracticeSession.ts`, `useChatSession.ts`)
- Frontend utilities: `camelCase.ts` or `camelCase.tsx` (e.g., `utils.ts`, `renderLatex.tsx`)
- Test files: none currently; would follow `*.test.ts` / `*.spec.ts` convention if added

**Functions:**
- camelCase for all functions (backend and frontend)
- Private/internal functions start lowercase
- No underscore prefixes for private; use file organization instead
- Exported functions are explicit with `export` keyword

**Variables:**
- camelCase for all variables and constants
- UPPERCASE_WITH_UNDERSCORES for compile-time constants (e.g., `MAX_IMAGES`, `ALLOWED_MIME`)
- camelCase for module-level object/map constants (e.g., `variantClasses`, `sizeClasses`)

**Types:**
- PascalCase for interfaces and type aliases (e.g., `QuestionPublic`, `SubmitAttemptResponse`)
- camelCase for type properties matching database snake_case (e.g., `session_id`, `question_id`)
- Union types use PascalCase (e.g., `MathLevel`, `Difficulty`, `AttemptStatus`)
- Generic types: `T` for generic, `Omit`/`Pick` utilities from lib/types
- Type imports: `import type { TypeName }` — always use `type` keyword

## Code Style

**Formatting:**
- No Prettier installed — formatting is manual, follow existing patterns
- 2-space indentation (enforced by TypeScript config)
- Single quotes for strings (convention in the codebase, not enforced)
- Semicolons always included
- No trailing commas (convention, not enforced)

**Linting:**
- Backend: TypeScript strict mode (`strict: true` in `tsconfig.json`)
- Frontend: ESLint with flat config (`eslint.config.js`)
  - Plugins: `typescript-eslint`, `react-hooks`, `react-refresh`
  - No custom rules beyond recommended presets
  - Enforces: `react-hooks/rules-of-hooks`, `react-refresh/only-export-components`
- Frontend rule: `tsc -b && vite build` during compile phase catches linting issues
- Run linting: `npm run lint` in frontend (uses ESLint flat config)

**TypeScript:**
- **Backend (`backend/tsconfig.json`):**
  - `target: ES2022`
  - `module: NodeNext` (must use `.js` extension on all imports)
  - `strict: true`
  - `esModuleInterop: true`
  - `skipLibCheck: true`
  
- **Frontend (`frontend/tsconfig.app.json`):**
  - `target: es2023`
  - `module: esnext`
  - `moduleResolution: bundler`
  - No `.js` extensions on imports (Vite bundler handles it)
  - `noUnusedLocals: true`, `noUnusedParameters: true` — all variables must be used
  - `jsx: react-jsx` (automatic JSX transform, no `React` import needed)

## Import Organization

**Order (both backend and frontend):**
1. External library imports (`react`, `express`, etc.)
2. Type imports (`import type { ... }`)
3. Internal project imports (paths relative to src/)
4. No blank lines between groups unless importing from different domains

**Backend Example (with .js extensions):**
```typescript
import { Router } from 'express'
import { z } from 'zod'
import type { Attempt, QuestionPart } from '../types/index.js'
import { supabase } from '../db/supabase.js'
```

**Frontend Example (no .js extensions):**
```typescript
import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import type { Attempt, Difficulty } from '../types/api'
import { usePracticeSession } from '../hooks/usePracticeSession'
import { Card } from '../components/ui/Card'
```

**Path Aliases:**
- Not configured; all imports use relative paths
- Frontend imports relative to `src/`
- Backend imports relative to `src/` with `.js` extensions

## Error Handling

**Backend Patterns:**

- **Zod validation in routes:**
  ```typescript
  try {
    const body = submitSchema.parse(req.body)
    // ... handler logic
  } catch (err) {
    if (err instanceof z.ZodError) {
      res.status(400).json({ error: 'Invalid request body', details: err.issues })
      return
    }
    res.status(500).json({ error: (err as Error).message })
  }
  ```

- **Custom error classes:**
  ```typescript
  export class GradingError extends Error {
    constructor(message: string) {
      super(message)
      this.name = 'GradingError'
    }
  }
  ```

- **Error throwing for logic errors:**
  ```typescript
  if (!question) throw new Error(`Question ${id} not found`)
  ```

- **Service → Route error propagation:**
  - Services throw descriptive errors
  - Routes catch and map to HTTP status codes
  - Client gets JSON `{ error: string }` or `{ error: string, details?: ... }`

**Frontend Patterns:**

- **Try-catch with type assertion:**
  ```typescript
  try {
    const result = await someAsyncFn()
    // ... process
  } catch (e) {
    const error = (e as Error).message
    setError(error)
  }
  ```

- **Optimistic UI with rollback:**
  ```typescript
  const snapshot = state
  setState(newState)
  try {
    await api.call()
  } catch (e) {
    setState(snapshot) // revert on failure
    setError((e as Error).message)
  }
  ```

- **Cancelled flag for cleanup:**
  ```typescript
  let cancelled = false
  fetchData()
    .then(data => {
      if (!cancelled) setState(data)
    })
  return () => {
    cancelled = true
  }
  ```

## Logging

**Framework:** `console` (no logging library)

**Patterns:**
- `console.log()` on startup: `Math Trainer backend running on http://localhost:${PORT}`
- No logging in service/business logic
- Errors logged implicitly through `res.status(500).json({ error: msg })`
- No debug/verbose logging infrastructure

## Comments

**When to Comment:**
- Complex algorithms or regex patterns (see `attemptService.ts` with normalizeLaTeX explanation)
- API endpoint documentation above route handlers (e.g., `// POST /api/grade — multipart upload...`)
- Special handling notes (e.g., `// Images are held in memory: forwarded to Gemini as base64`)
- Clarifications about edge cases (e.g., multi-part question reveal logic)

**When NOT to Comment:**
- Self-explanatory variable/function names
- Simple loops or conditionals
- Standard patterns (useEffect, useState usage)

**JSDoc/TSDoc:**
- Not used in this codebase
- Types are explicit enough without JSDoc

## Function Design

**Size:** 
- Most functions 15–50 lines
- Largest services (e.g., gradingService.ts) break complex logic into helpers
- Routes are thin (~15 lines) — delegate to services

**Parameters:**
- Prefer object parameters over multiple args (readability)
  ```typescript
  // Good
  export async function submitAttempt(body: SubmitAttemptBody): Promise<SubmitAttemptResponse>
  
  // Over
  export async function submitAttempt(sessionId, questionId, answerGiven, ...): ...
  ```

**Return Values:**
- Backend services return typed objects (e.g., `SubmitAttemptResponse`)
- Frontend hooks return structured objects: `{ data, loading, error, action }`
- Never return `null` for missing — throw error or return optional type
- Async functions: always `Promise<T>` (never fire-and-forget in backend)

## Module Design

**Exports:**
- Named exports only (no default exports)
  - Exception: router files use `export default router`
- One primary export per file is typical

**Barrel Files:**
- `src/types/index.ts` re-exports all types (for cleaner imports)
- Otherwise avoided; imports are relative

**Backend Layer Structure:**
- `routes/` — thin request handlers, validation, error mapping
- `services/` — business logic, database access
- `db/` — Supabase and Gemini clients
- `types/` — TypeScript definitions
- `index.ts` — Express app setup and routing

**Frontend Layer Structure:**
- `pages/` — full-page components
- `components/` — reusable React components (ui/, question/, topic/, math/, chat/, etc.)
- `hooks/` — custom hooks for state/side-effects
- `lib/` — utilities (api, session, socket, utils, renderLatex)
- `types/` — TypeScript definitions
- `contexts/` — React Context (currently ThemeContext)
- `main.tsx` — entry point
- `App.tsx` — router setup

## Constants & Configuration

**Environment Variables (Backend):**
- `PORT` — server port (default 3001)
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` — database credentials
- `GEMINI_API_KEY`, `GEMINI_MODEL` — AI grading
- `CHAT_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION` — hint chatbot limits
- `GRADE_RATE_LIMIT_PER_MIN`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB` — photo grading limits
- `PAIR_TTL_MIN` — phone upload pairing token lifetime
- Read from process.env with fallbacks: `process.env.PORT ?? 3001`

**Magic Numbers/Constants:**
- Stored as UPPERCASE module-level constants
- Defaults provided via `??` operator
  ```typescript
  const MAX_IMAGES = Number(process.env.GRADE_MAX_IMAGES ?? 5)
  ```

---

*Convention analysis: 2026-06-26*
