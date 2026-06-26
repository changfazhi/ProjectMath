# Testing Patterns

**Analysis Date:** 2026-06-26

## Current State: No Tests Exist

There are no test files (`*.test.ts`, `*.spec.ts`, `*.test.tsx`, `*.spec.tsx`) and no `__tests__/` directories anywhere in the project source. No test runner (Jest, Vitest, Mocha) is configured in `backend/package.json` or `frontend/package.json`.

The only `*.test.ts` files present are inside `backend/node_modules/zod/` — these belong to the Zod library, not this project.

---

## What Should Be Tested

Given the codebase complexity, the following areas carry the highest regression risk and are the priority targets for adding tests.

### 1. LaTeX Normalization and Answer Grading (HIGH PRIORITY)

**File:** `backend/src/services/attemptService.ts`

The `normalizeLaTeX()`, `checkAnswer()`, `tryNumericEval()`, and `trySymbolicEval()` functions contain non-trivial logic with many edge cases. A regression here silently misgrades students.

Key cases to cover:
- `normalizeLaTeX`: whitespace stripping, spacing command removal (`\,`, `\;`, `\quad`), MathLive compact fraction expansion (`\frac13` → `\frac{1}{3}`)
- `checkAnswer` with `"exact"`: identical normalized strings, equivalent numeric forms, symbolic equivalence via multi-point evaluation
- `checkAnswer` with `"range"`: within tolerance, at boundary, outside tolerance, NaN inputs
- `checkAnswer` with unknown type: returns `false`
- Show-that (null answer_type) path: auto-correct without grading

Example test structure (Vitest or Jest):
```typescript
import { describe, it, expect } from 'vitest'

describe('normalizeLaTeX', () => {
  it('strips whitespace', () => expect(normalize('x + y')).toBe('x+y'))
  it('expands compact fractions', () => expect(normalize('\\frac13')).toBe('\\frac{1}{3}'))
  it('removes \\quad', () => expect(normalize('x\\quad+y')).toBe('x+y'))
})

describe('checkAnswer exact', () => {
  it('accepts equivalent numeric LaTeX', ...)
  it('accepts symbolically equivalent expressions', ...)
  it('rejects wrong answer', ...)
})
```

### 2. Zod Request Schemas (MEDIUM PRIORITY)

**Files:** `backend/src/routes/attempts.ts`, `backend/src/routes/chat.ts`, `backend/src/routes/grade.ts`, `backend/src/routes/stars.ts`, `backend/src/routes/topics.ts`

Each route defines a Zod schema. Tests should verify:
- Valid inputs parse without error
- Missing required fields throw ZodError
- Wrong types (e.g., non-UUID session_id) throw ZodError
- Optional fields are truly optional

### 3. Multi-Part Solution Reveal Logic (HIGH PRIORITY)

**File:** `backend/src/services/attemptService.ts` — `submitAttempt()` function

The logic that decides when to reveal `solution_latex` (only after all graded parts are submitted) is stateful and query-dependent. Test cases:
- Single-part question: solution revealed immediately on submit
- Multi-part with 2 graded parts: solution hidden after part A, revealed after part B
- Multi-part with show-that parts: show-that parts excluded from the "all done" check

### 4. Frontend API Client (LOW PRIORITY)

**File:** `frontend/src/lib/api.ts`

The `request<T>()` function handles error parsing from non-OK responses. Test cases:
- Non-OK response with JSON error body: throws with `body.error` message
- Non-OK response with non-JSON body: throws with `res.statusText`
- OK response: returns parsed JSON

### 5. Utility Functions (LOW PRIORITY)

**File:** `frontend/src/lib/utils.ts`

- `cn()`: filters falsy values, joins with space
- `formatTime()`: seconds < 60 format, minutes with/without remainder seconds
- `parseOption()`: splits MCQ option string on `': '`, handles missing separator

---

## Recommended Setup

**Backend** (Node.js service functions — pure unit tests):
- Runner: **Vitest** (zero-config with TypeScript, ESM-native — matches the NodeNext module setup)
- Config file: `backend/vitest.config.ts`
- Test location: co-located as `backend/src/services/attemptService.test.ts`

**Frontend** (utility functions):
- Runner: **Vitest** (already used by the Vite ecosystem; add to `frontend/`)
- Test location: co-located as `frontend/src/lib/utils.test.ts`

Install:
```bash
cd backend && npm install --save-dev vitest
cd frontend && npm install --save-dev vitest
```

Run commands (once configured):
```bash
cd backend && npx vitest run         # one-shot
cd backend && npx vitest             # watch mode
cd backend && npx vitest --coverage  # coverage report
```

---

## Files With No Test Coverage (Complete List of Critical Paths)

| File | Risk |
|---|---|
| `backend/src/services/attemptService.ts` | HIGH — grading logic, solution reveal |
| `backend/src/services/chatService.ts` | MEDIUM — rate limit enforcement, system prompt injection |
| `backend/src/services/gradingService.ts` | MEDIUM — junk filtering, structured output parsing |
| `backend/src/services/questionService.ts` | MEDIUM — correct_answer stripping before client response |
| `backend/src/services/streakService.ts` | LOW — date-boundary streak calculation |
| `backend/src/routes/attempts.ts` | MEDIUM — Zod schema, error status codes |
| `frontend/src/lib/utils.ts` | LOW — cn(), formatTime(), parseOption() |
| `frontend/src/lib/api.ts` | LOW — error parsing in request() |

---

*Testing analysis: 2026-06-26*
