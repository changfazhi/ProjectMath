# Testing Patterns

**Analysis Date:** 2026-06-29

## Test Framework

**Status: No test framework is configured.**

Neither `frontend/package.json` nor `backend/package.json` lists any testing framework in `devDependencies`. There is no `jest.config.*`, `vitest.config.*`, `mocha`, or any other test runner present in either package.

## Test Files

**Zero test files exist in this repository.**

A search for `*.test.*` and `*.spec.*` files across the entire project returned no results.

## What IS Tested (Manual / Runtime)

There are no automated tests. Validation and correctness is currently ensured through:

1. **TypeScript strict mode** — catches type errors at compile time (both `strict: true` on backend, strict lint rules on frontend)
2. **Zod schema validation** — runtime validation of all API inputs; wrong shapes throw before service logic runs
3. **Manual browser testing** — implied by the dev workflow (`npm run dev` in both `frontend/` and `backend/`)

## Critical Untested Paths

The following are the highest-risk areas with zero test coverage:

### Answer Grading Logic (`backend/src/services/attemptService.ts`)
- `normalizeLaTeX(s)` — string normalization with many regex replacements; easy to break
- `latexToMathExpr(normalized)` — LaTeX→mathjs expression conversion; brittle for edge cases
- `tryNumericEval(raw)` — numeric evaluation via `mathjs.evaluate()`
- `trySymbolicEval(given, correct)` — multi-point symbolic equivalence check using prime substitution
- `checkAnswer(answerType, correctAnswer, givenAnswer, tolerance)` — dispatch across `exact`, `mcq`, `range`

**Risk:** A bad regex in `normalizeLaTeX` or wrong operator precedence in `latexToMathExpr` silently marks correct answers wrong or wrong answers correct.

### AI Grading Pipeline (`backend/src/services/gradingService.ts`)
- Gemini vision call + structured output parsing
- Junk-filter logic (`gradable=false` path)
- Part-label auto-detection from photos
- Image → Supabase Storage upload (only after grading success)

**Risk:** No way to replay a grading scenario in CI without a live Gemini API key.

### Chat Service (`backend/src/services/chatService.ts`)
- System instruction construction (`buildSystemInstruction()`) — injects question + solution; wrong format could leak `solution_latex`
- Rate-limit enforcement (`ChatLimitError` → HTTP 429)
- History rehydration path

### Pair/QR Flow (`backend/src/services/pairService.ts`, `backend/src/realtime.ts`)
- Token generation and TTL expiry
- Socket.IO event sequencing (`pair:phone-connected` → `pair:image` → `pair:grading` → `pair:graded`)
- Desktop ↔ phone photo transfer

### Multi-Part Answer Reveal (`backend/src/services/attemptService.ts`)
- `solution_latex` reveal logic — shown only when all graded parts have been submitted
- `gradedParts` filter (parts where `correct_answer !== null`)
- `submittedLabels` set built from existing attempts

**Risk:** A query bug here could reveal the solution too early or never.

### Frontend State Machine (`frontend/src/hooks/usePracticeSession.ts`)
- `reducer()` — 13 action types, complex phase transitions
- `GRADE_REJECTED` soft-error path (stays in `'answering'`, no penalty)
- `beginExternalGrading` / `receiveGrading` (QR phone path)

### Star Optimistic UI (`frontend/src/hooks/` or component)
- Optimistic flip → server sync → revert on failure

## Test Coverage Summary

| Area | Coverage |
|------|----------|
| `normalizeLaTeX` / `checkAnswer` | None |
| `submitAttempt` service | None |
| `gradingService` | None |
| `chatService` | None |
| `pairService` / Socket.IO | None |
| API route validation (Zod) | None |
| Auth middleware (`gate()`) | None |
| `usePracticeSession` reducer | None |
| `renderLatex()` | None |
| `lib/api.ts` error handling | None |

## Recommended Testing Priority

### Priority 1 — Unit tests for answer grading (pure functions, no I/O)

These are pure functions — trivial to test with Vitest or Jest, extremely high value:

```typescript
// backend/src/services/attemptService.test.ts
describe('normalizeLaTeX', () => {
  it('strips whitespace', () => expect(normalizeLaTeX('x + y')).toBe('x+y'))
  it('expands compact fractions: \\frac34 → \\frac{3}{4}', ...)
  it('lowercases output', ...)
})

describe('checkAnswer', () => {
  it('exact match after normalization', ...)
  it('numeric equivalence: "1/2" vs "0.5"', ...)
  it('symbolic equivalence: "x+y" vs "y+x"', ...)
  it('range: within tolerance', ...)
  it('range: outside tolerance', ...)
})
```

### Priority 2 — Integration tests for `submitAttempt` (with Supabase mock)

Mock `supabase` to return a fixture question, assert that `is_correct` and `solution_latex` are correct for single-part and multi-part scenarios.

### Priority 3 — Frontend reducer unit tests

```typescript
// frontend/src/hooks/usePracticeSession.test.ts
describe('reducer', () => {
  it('LOAD_SUCCESS initializes partStates for multi-part questions', ...)
  it('GRADE_REJECTED stays in answering phase', ...)
  it('PART_SUBMIT_DONE transitions to revealed when all parts done', ...)
})
```

### Priority 4 — Route-level integration tests (supertest)

Test Zod validation rejection, auth middleware 401/402, and happy-path responses with mocked services.

## Setting Up Tests (Recommended Stack)

**Backend:** Vitest (compatible with ESM/NodeNext without extra config)
```bash
cd backend && npm install -D vitest
```
```json
// backend/package.json scripts
"test": "vitest run",
"test:watch": "vitest"
```

**Frontend:** Vitest + `@testing-library/react`
```bash
cd frontend && npm install -D vitest @testing-library/react @testing-library/user-event jsdom
```
Add to `frontend/vite.config.ts`:
```typescript
test: { environment: 'jsdom', globals: true }
```

---

*Testing analysis: 2026-06-29*
