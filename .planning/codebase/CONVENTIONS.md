# Coding Conventions

**Analysis Date:** 2026-06-26

## Naming Patterns

**Files:**
- Backend routes: `lowercase.ts` (e.g., `routes/attempts.ts`, `routes/chat.ts`)
- Backend middleware: `camelCase.ts` (e.g., `middleware/auth.ts`)
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
- camelCase for type properties matching database snake_case (e.g., `question_id`, `user_id`)
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
import { gate } from '../middleware/auth.js'
import { supabase } from '../db/supabase.js'
```

**Frontend Example (no .js extensions):**
```typescript
import { useEffect, useState } from 'react'
import { useParams } from 'react-router-dom'
import type { Attempt, Difficulty } from '../types/api'
import { useAuth } from '../contexts/AuthContext'
import { usePracticeSession } from '../hooks/usePracticeSession'
import { Card } from '../components/ui/Card'
```

**Path Aliases:**
- Not configured; all imports use relative paths
- Frontend imports relative to `src/`
- Backend imports relative to `src/` with `.js` extensions

## Backend Patterns

### Route Responsibility
Routes are thin wrappers — apply auth middleware, validate input, call one service function, return JSON. No business logic in routes.

```typescript
// Correct — backend/src/routes/attempts.ts
router.post('/', ...gate('practice'), async (req, res) => {
  const body = submitSchema.parse(req.body)          // validate (no session_id)
  const result = await submitAttempt(req.user!.uid, body)  // delegate with uid
  res.status(201).json(result)                       // respond
})
```

### Zod Validation
Every `req.body` and `req.query` parameter is validated with Zod before use. Inline schemas for query params; named schemas for request bodies.

`session_id` is **not** validated from request input — user identity comes from `req.user!.uid` set by `requireAuth` middleware after verifying the Firebase token.

```typescript
// Body schema (named) — no session_id
const submitSchema = z.object({
  question_id: z.string().uuid(),
  answer_given: z.string().min(1),
  time_taken_s: z.number().int().positive().optional(),
})
const body = submitSchema.parse(req.body)

// Query param (inline) — no session_id
const questionId = z.string().uuid().parse(req.query.question_id)
```

ZodError catches return HTTP 400 with `{ error, details }`. Other errors return HTTP 500.

### Authentication & Feature Gating

**`requireAuth`** (`backend/src/middleware/auth.ts`): verifies the Firebase ID token from the `Authorization: Bearer <token>` header, upserts the user row via atomic `INSERT ... ON CONFLICT DO UPDATE`, and sets `req.user = { uid: UUID, tier: 'free' | 'paid' }`. Returns 401 if the token is missing or invalid.

**`gate(feature)`** (`backend/src/middleware/auth.ts`): composes `requireAuth` with a tier check against `FEATURE_TIERS[feature]` from `backend/src/config/featureTiers.ts`. Returns 402 if the user's tier is insufficient.

```typescript
// Use gate() on every route that requires identity
router.post('/', ...gate('practice'), handler)   // free tier
router.post('/', ...gate('aiHints'), handler)    // currently free, can flip to 'paid'

// Public routes (no auth required)
router.get('/', handler)
```

**`FEATURE_TIERS`** (`backend/src/config/featureTiers.ts`): the single source of truth for which tier each feature requires. Changing a feature from free to paid is a one-line edit here — no route changes needed.

**Frontend:** `useFeature(feature)` in `frontend/src/hooks/useFeature.ts` mirrors `FEATURE_TIERS` for UX gating only (show/hide buttons, show upgrade prompt). It is not a security boundary. Backend `gate()` is always the enforcement layer; `api.ts` handles 401 by opening the login modal and 402 by opening the upgrade modal.

### Database Access
Never call `supabase` from a route file. All Supabase queries live in `backend/src/services/*.ts`.

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

- **Service → Route error propagation:**
  - Services throw descriptive errors
  - Routes catch and map to HTTP status codes
  - Client gets JSON `{ error: string }` or `{ error: string, details?: ... }`

**Frontend Patterns:**

- **Try-catch with type assertion:**
  ```typescript
  try {
    const result = await someAsyncFn()
  } catch (e) {
    setError((e as Error).message)
  }
  ```

- **Optimistic UI with rollback:**
  ```typescript
  const snapshot = state
  setState(newState)
  try {
    await api.call()
  } catch (e) {
    setState(snapshot)
    setError((e as Error).message)
  }
  ```

- **Cancelled flag for cleanup:**
  ```typescript
  let cancelled = false
  fetchData().then(data => { if (!cancelled) setState(data) })
  return () => { cancelled = true }
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
- API endpoint documentation above route handlers
- Special handling notes (e.g., `// Images are held in memory: forwarded to Gemini as base64`)
- Clarifications about edge cases (e.g., multi-part question reveal logic)

**When NOT to Comment:**
- Self-explanatory variable/function names
- Simple loops or conditionals
- Standard patterns (useEffect, useState usage)

**JSDoc/TSDoc:** Not used in this codebase; types are explicit enough without it.

## Function Design

**Size:**
- Most functions 15–50 lines
- Largest services (e.g., gradingService.ts) break complex logic into helpers
- Routes are thin (~15 lines) — delegate to services

**Parameters:**
- Prefer object parameters over multiple positional args
  ```typescript
  // Good
  export async function submitAttempt(uid: string, body: SubmitAttemptBody): Promise<SubmitAttemptResponse>
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
- `middleware/` — auth middleware (`requireAuth`, `gate`)
- `services/` — business logic, database access
- `db/` — Supabase, Gemini, and Firebase Admin clients
- `config/` — `featureTiers.ts` (feature-to-tier mapping)
- `types/` — TypeScript definitions
- `index.ts` — Express app setup and routing

**Frontend Layer Structure:**
- `pages/` — full-page components
- `components/` — reusable React components (ui/, question/, topic/, math/, chat/, progress/, pair/, layout/)
- `hooks/` — custom hooks for state/side-effects; includes `useFeature.ts`
- `lib/` — utilities (api with auth, socket, utils, renderLatex)
- `types/` — TypeScript definitions
- `contexts/` — React Context (AuthContext, ThemeContext)
- `main.tsx` — entry point
- `App.tsx` — router setup

## Constants & Configuration

**Environment Variables (Backend):**
- `PORT` — server port (default 3001)
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` — database credentials
- `GEMINI_API_KEY`, `GEMINI_MODEL` — AI grading
- `FIREBASE_PROJECT_ID` (or service account JSON) — Firebase Admin initialization
- `CORS_ORIGIN` — allowed origin for CORS (e.g., `http://localhost:5173` in dev)
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

*Convention analysis: 2026-06-26 — merged: auth middleware patterns from firebase-auth branch + naming / style / module design detail from main branch*
