# Testing Patterns

**Analysis Date:** 2026-06-27

## Test Framework

**Runner:** None configured.

No test runner (Jest, Vitest, Mocha, etc.) is present in either `backend/package.json` or `frontend/package.json`. No `*.test.ts`, `*.spec.ts`, `*.test.tsx`, or `*.spec.tsx` files exist anywhere in the repository.

**Run Commands:** Not applicable — no test suite exists.

## Test File Organization

**Location:** Not applicable.

**Naming:** Not applicable.

## Current State

This codebase has **no automated tests of any kind:**
- No unit tests for service logic
- No integration tests for API routes
- No component tests for React components
- No end-to-end tests
- No snapshot tests
- No test configuration files

This is a solo-developer project where correctness is currently validated manually via the running application.

## Areas of Highest Risk (Untested Logic)

The following backend service functions contain complex logic that is entirely untested. Any future test suite should prioritize these:

**`backend/src/services/attemptService.ts` — answer grading pipeline:**
- `normalizeLaTeX(s)` — strips whitespace/spacing commands, normalizes MathLive compact notation (`\frac13` → `\frac{1}{3}`)
- `latexToMathExpr(normalized)` — converts LaTeX to mathjs-evaluable expressions
- `tryNumericEval(raw)` — attempts numeric evaluation via mathjs; returns `null` on failure
- `trySymbolicEval(given, correct)` — multi-point symbolic evaluation substituting prime numbers for variables; the most complex grading path
- `checkAnswer(answerType, correctAnswer, givenAnswer, tolerance)` — dispatches to `exact`/`mcq` (string match → numeric → symbolic) or `range` (float comparison with tolerance)

**`backend/src/services/gradingService.ts` — Gemini photo grading:**
- `buildGradingInstruction()` — constructs the Gemini system prompt including confidential solution
- Structured output schema parsing (`gradable`, `parts[{label, verdict, marks_awarded}]`)
- Junk photo detection logic (STEP 0 filtering)

**`backend/src/services/chatService.ts` — AI hint chatbot:**
- `buildSystemInstruction()` — constructs Socratic tutor prompt
- Rate limiting integration (`ChatLimitError`)

**`backend/src/services/spacedRepetitionService.ts` — SM-2 algorithm:**
- `upsertSRCard()` — SM-2 spaced repetition card updates; fire-and-forget from `attemptService.ts`

## Recommended Test Strategy (If Implementing)

**Framework recommendation:** Vitest for both backend and frontend (consistent API, fast, TypeScript-native).

**Where to start — highest value per effort:**

1. **Unit tests for `normalizeLaTeX` and `checkAnswer`** in `backend/src/services/attemptService.ts`. These are pure functions with no dependencies. A suite of 30–40 cases covering LaTeX normalization edge cases and the three answer type branches would catch most grading regressions.

2. **Unit tests for `trySymbolicEval`** — this is the most complex logic in the codebase. Test commutativity, algebraic equivalences, and division-by-zero edge cases.

3. **Integration tests for core API routes** — `POST /api/attempts`, `GET /api/topics`, `GET /api/topics/:id/questions`. Mock Supabase via `vi.mock('../db/supabase.js')`.

4. **Component tests for `PracticePage` state machine** — test that `usePracticeSession` reducer transitions correctly between phases using `renderHook` from `@testing-library/react`.

**Example unit test structure (Vitest):**
```typescript
// backend/src/services/attemptService.test.ts
import { describe, it, expect } from 'vitest'

describe('normalizeLaTeX', () => {
  it('strips spacing commands', () => {
    expect(normalizeLaTeX('\\frac{1}{2}\\,')).toBe('\\frac{1}{2}')
  })
  it('expands compact fractions', () => {
    expect(normalizeLaTeX('\\frac34')).toBe('\\frac{3}{4}')
  })
})

describe('checkAnswer', () => {
  it('exact: matches normalized LaTeX', () => {
    expect(checkAnswer('exact', '\\frac{1}{2}', '\\frac12', null)).toBe(true)
  })
  it('range: accepts within tolerance', () => {
    expect(checkAnswer('range', '3.14159', '3.14', 0.01, null)).toBe(true)
  })
})
```

**Mocking pattern for Supabase:**
```typescript
vi.mock('../db/supabase.js', () => ({
  supabase: {
    from: vi.fn().mockReturnThis(),
    select: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    single: vi.fn().resolves({ data: { id: 'uuid' }, error: null }),
  },
}))
```

## Coverage

**Requirements:** None enforced.

**Tooling:** Not configured.

---

*Testing analysis: 2026-06-27*
