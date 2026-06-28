# Testing Patterns

**Analysis Date:** 2026-06-28

## Test Framework

**Runner:** None configured. No test files found in the repository.

**Test config files:** Not present (no `jest.config.*`, `vitest.config.*`, or equivalent).

**Run Commands:** Not available — no test scripts in `package.json`.

## Current State

This codebase has **no automated tests**. Neither the `backend/` nor the `frontend/` directory contains test files (`.test.ts`, `.test.tsx`, `.spec.ts`, `.spec.tsx`).

There is no test runner, assertion library, mocking framework, or coverage tooling configured.

## What Would Benefit Most from Tests

Based on codebase analysis, the following areas carry the highest risk from lack of test coverage:

**`backend/src/services/attemptService.ts` — Answer grading logic (CRITICAL)**
- `normalizeLaTeX()` — string normalization with many regex rules; regressions are silent
- `latexToMathExpr()` — LaTeX → mathjs conversion; wrong conversion produces wrong grades
- `tryNumericEval()` — numeric evaluation fallback
- `trySymbolicEval()` — multi-point symbolic evaluation using prime substitution
- `checkAnswer()` — dispatches across `exact`, `mcq`, `range` modes
- These pure functions are ideal unit test targets

**`backend/src/services/questionService.ts` — Solution stripping**
- `stripSolution()` — must never leak `correct_answer` or `solution_latex` to client

**`backend/src/services/gradingService.ts` — AI grading pipeline**
- Junk-image rejection logic (`gradable=false` path)
- `GradingError` vs attempt persistence logic

**Frontend hooks**
- `usePracticeSession.ts` — reducer state machine covering `loading → answering → submitted → revealed → complete | error` phases
- `useChatSession.ts` — optimistic send + rollback on error

## Recommended Test Setup

**Backend (Node/TypeScript):**
```bash
# Install
npm install --save-dev vitest @vitest/coverage-v8

# vitest.config.ts
import { defineConfig } from 'vitest/config'
export default defineConfig({
  test: { environment: 'node', include: ['src/**/*.test.ts'] }
})
```

**Frontend (React/TypeScript):**
```bash
# Install
npm install --save-dev vitest @vitest/coverage-v8 @testing-library/react @testing-library/user-event jsdom

# vitest.config.ts
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'
export default defineConfig({
  plugins: [react()],
  test: { environment: 'jsdom', include: ['src/**/*.test.tsx'] }
})
```

## Recommended Test File Placement

Co-locate test files with source:
```
backend/src/services/attemptService.ts
backend/src/services/attemptService.test.ts   ← new

frontend/src/hooks/usePracticeSession.ts
frontend/src/hooks/usePracticeSession.test.ts ← new
```

## Recommended Test Patterns

**Pure function unit test (answer grading):**
```typescript
// backend/src/services/attemptService.test.ts
import { describe, it, expect } from 'vitest'
// import { checkAnswer } (if exported, or test via submitAttempt mock)

describe('normalizeLaTeX', () => {
  it('strips whitespace and spacing commands', () => {
    expect(normalizeLaTeX('\\frac 1 2')).toBe('\\frac12')
  })
  it('lowercases output', () => {
    expect(normalizeLaTeX('X')).toBe('x')
  })
})

describe('checkAnswer – exact', () => {
  it('accepts normalised-equal latex strings', () => {
    expect(checkAnswer('exact', '\\frac{1}{2}', '\\frac12', null)).toBe(true)
  })
  it('rejects wrong answer', () => {
    expect(checkAnswer('exact', '\\frac{1}{2}', '\\frac{1}{3}', null)).toBe(false)
  })
})

describe('checkAnswer – range', () => {
  it('accepts value within tolerance', () => {
    expect(checkAnswer('range', '3.14', '3.14159', 0.01)).toBe(true)
  })
  it('rejects value outside tolerance', () => {
    expect(checkAnswer('range', '3.14', '3.14159', 0.001)).toBe(false)
  })
})
```

**Supabase mocking pattern (backend services):**
```typescript
import { vi, beforeEach } from 'vitest'
import * as supabaseModule from '../db/supabase.js'

beforeEach(() => {
  vi.spyOn(supabaseModule, 'supabase', 'get').mockReturnValue({
    from: () => ({
      select: () => ({ eq: () => ({ single: () => ({ data: mockQuestion, error: null }) }) }),
      insert: () => ({ select: () => ({ single: () => ({ data: { id: 'uuid' }, error: null }) }) }),
    }),
  } as any)
})
```

**React hook test pattern:**
```typescript
import { renderHook, act } from '@testing-library/react'
import { usePracticeSession } from './usePracticeSession'

it('transitions from loading to answering on load success', async () => {
  const { result } = renderHook(() => usePracticeSession('topic-id'))
  expect(result.current.phase).toBe('loading')
  await act(async () => { /* trigger load */ })
  expect(result.current.phase).toBe('answering')
})
```

## Mocking

**What to mock:**
- `supabase` client (all DB calls in backend services)
- `fetch` / `api.*` in frontend hooks
- `@google/genai` Gemini client (AI-dependent services)
- Socket.IO (`io()` in `frontend/src/lib/socket.ts`)

**What NOT to mock:**
- Pure functions (`normalizeLaTeX`, `checkAnswer`, `latexToMathExpr`) — test directly
- React reducers — test the reducer function directly with plain inputs

## Coverage

**Requirements:** None currently enforced.

**Suggested minimum targets (once tests added):**
- `backend/src/services/attemptService.ts` — 90%+ (grading logic is mission-critical)
- `backend/src/services/questionService.ts` — 80%+ (solution stripping must not leak)

## Test Types

**Unit Tests:** First priority — pure functions in `backend/src/services/attemptService.ts`

**Integration Tests:** Second priority — route handlers against a mocked Supabase client

**E2E Tests:** Not configured. Playwright or Cypress could cover the practice flow end-to-end, but is not currently in use.

---

*Testing analysis: 2026-06-28*
