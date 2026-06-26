# Testing Patterns

**Analysis Date:** 2026-06-26

## Test Framework

**Current Status:** No testing framework installed or configured.

**Runner:** None (no jest, vitest, or other test runner in package.json)

**Assertion Library:** None (would use native Node assert or a library like Vitest)

**Run Commands:**
```bash
# Currently unavailable:
# npm run test              # Run all tests
# npm run test:watch       # Watch mode
# npm run test:coverage    # Coverage report
```

## Test File Organization

**Recommended Pattern (for future implementation):**
- **Location:** Co-located with source files
- **Naming:** `[module].test.ts` or `[module].spec.ts`
  - Example: `src/services/attemptService.ts` → `src/services/attemptService.test.ts`
  - React components: `Button.tsx` → `Button.test.tsx`

**Suggested Directory Structure:**
```
backend/src/
├── services/
│   ├── attemptService.ts
│   ├── attemptService.test.ts      ← test alongside source
│   ├── gradingService.ts
│   └── gradingService.test.ts
├── routes/
│   ├── attempts.ts
│   └── attempts.test.ts
└── db/
    └── supabase.ts
    
frontend/src/
├── components/
│   ├── ui/
│   │   ├── Button.tsx
│   │   └── Button.test.tsx
│   └── question/
│       ├── AnswerInput.tsx
│       └── AnswerInput.test.tsx
└── hooks/
    ├── useChatSession.ts
    └── useChatSession.test.ts
```

## Test Structure (Recommended)

**Suite Organization:**
```typescript
import { describe, it, expect, beforeEach, afterEach } from 'vitest'

describe('attemptService.submitAttempt()', () => {
  let mockDb: any
  
  beforeEach(() => {
    // Setup: initialize mocks
    mockDb = createMockSupabase()
  })
  
  afterEach(() => {
    // Teardown: clean resources
    vi.clearAllMocks()
  })
  
  it('returns correct_answer and solution_latex on successful submit', async () => {
    const result = await submitAttempt({ /* test data */ })
    expect(result).toHaveProperty('attempt_id')
    expect(result).toHaveProperty('is_correct', true)
  })
  
  it('throws error if question not found', async () => {
    await expect(
      submitAttempt({ question_id: 'nonexistent' })
    ).rejects.toThrow('Question nonexistent not found')
  })
})
```

**Patterns:**
- **Setup:** `beforeEach()` for fresh fixtures per test
- **Teardown:** `afterEach()` for mock cleanup
- **Assertion:** `expect(actual).toBe(expected)` or `expect(fn).rejects.toThrow()`

## Mocking (Recommended Framework: Vitest)

**Framework:** Vitest (newer, better TypeScript support, drop-in Jest replacement)

**Patterns:**

**Mock Supabase Client:**
```typescript
import { vi } from 'vitest'

const mockSupabase = {
  from: vi.fn().mockReturnValue({
    insert: vi.fn().mockReturnValue({
      select: vi.fn().mockReturnValue({
        single: vi.fn().mockResolvedValue({
          data: { id: 'test-uuid' },
          error: null,
        }),
      }),
    }),
  }),
}

// Mock at module level
vi.mock('../db/supabase', () => ({
  supabase: mockSupabase,
}))
```

**Mock Express Request/Response:**
```typescript
import { vi } from 'vitest'

const mockReq = {
  body: { session_id: 'uuid', question_id: 'uuid' },
  query: {},
  files: [],
} as unknown as Express.Request

const mockRes = {
  status: vi.fn().mockReturnThis(),
  json: vi.fn().mockReturnThis(),
} as unknown as Express.Response
```

**Mock Gemini API:**
```typescript
const mockGemini = {
  generateContent: vi.fn().mockResolvedValue({
    response: {
      text: () => JSON.stringify({
        gradable: true,
        parts: [{ label: 'a', verdict: 'correct' }],
        // ...
      }),
    },
  }),
}

vi.mock('../db/gemini', () => ({
  getGemini: () => mockGemini,
}))
```

**What to Mock:**
- Database client (`supabase`) — always mock in unit tests
- External APIs (`Gemini`, `Google genai`) — mock to avoid billable API calls
- Express request/response objects in route tests
- Date/time (`vi.useFakeTimers()` for streak logic)

**What NOT to Mock:**
- Utility functions like `normalizeLaTeX()` — test them directly
- Type checking — TypeScript compiler handles this
- Core JavaScript functions (Array methods, etc.)

## Fixtures and Factories

**Test Data (Recommended):**

**Factory Pattern for Questions:**
```typescript
function createMockQuestion(overrides?: Partial<Question>): Question {
  return {
    id: 'q-uuid-001',
    topic_id: 'aaaa0001-0000-0000-0000-000000000000',
    difficulty: 2,
    name: 'Sample question',
    prompt_latex: 'Find $x$ if $2x = 4$',
    answer_type: 'exact',
    correct_answer: '2',
    tolerance: null,
    mcq_options: null,
    parts: null,
    solution_latex: 'Dividing both sides by 2: $x = 2$',
    marks: 3,
    source: 'ASRJC Prelim 2025',
    created_at: '2025-01-01T00:00:00Z',
    ...overrides,
  }
}
```

**Factory for Multi-Part Questions:**
```typescript
function createMockMultiPartQuestion(): Question {
  return createMockQuestion({
    answer_type: null,
    correct_answer: '',
    parts: [
      {
        label: 'a',
        prompt_latex: 'Part (a) question',
        correct_answer: 'x = 2',
        answer_type: 'exact',
        tolerance: null,
        marks: 3,
      },
      {
        label: 'b',
        prompt_latex: 'Hence find $y$',
        correct_answer: 'y = 4',
        answer_type: 'exact',
        tolerance: null,
        marks: 2,
      },
    ],
  })
}
```

**Location:**
- Store in a `src/__tests__/fixtures/` or `src/__tests__/factories/` directory
- Or co-locate in the same test file for simpler tests
- Export factories for reuse across test suites

## Coverage

**Requirements:** Not enforced currently.

**Recommended (for future):**
- Minimum 70% coverage for business logic (services)
- Minimum 50% coverage for routes (many conditional error paths)
- Component coverage less critical (more brittle); focus on hooks

**View Coverage:**
```bash
# With Vitest:
npm run test:coverage

# Outputs HTML report in coverage/index.html
```

## Test Types

**Unit Tests:**
- **Scope:** Individual functions and classes
- **Approach (Backend):**
  - Test `attemptService.ts` functions: `checkAnswer()`, `normalizeLaTeX()`, `submitAttempt()`
  - Mock Supabase, test business logic in isolation
  - Example: `checkAnswer('exact', '2', '2')` → `true`
  
- **Approach (Frontend):**
  - Test hooks: `usePracticeSession()`, `useChatSession()`
  - Mock `api.*`, test state transitions
  - Use `renderHook` from Vitest + React Testing Library

**Integration Tests:**
- **Scope:** Route + service + database
- **Approach:**
  - Test full request path: `POST /api/attempts` → validation → service → response
  - Use in-memory SQLite or test database for real schema testing
  - Verify Zod validation catches bad inputs

**E2E Tests:**
- **Framework:** Not implemented; would use Playwright or Cypress
- **Scope:** Full user workflows (login via QR → upload photo → grade)
- **Recommended:** Only critical paths (happy path + major error cases)

## Common Patterns

**Async Testing (with Vitest):**
```typescript
it('submits attempt and returns result', async () => {
  const result = await submitAttempt(body)
  expect(result.is_correct).toBe(true)
})

// With promises
it('fetches questions', () => {
  return api.topics.questions('topic-id', 'session-id')
    .then(qs => {
      expect(qs).toHaveLength(5)
    })
})
```

**Error Testing:**
```typescript
it('throws on missing question', async () => {
  await expect(
    submitAttempt({ ...body, question_id: 'missing' })
  ).rejects.toThrow('not found')
})

// Specific error type
it('catches ZodError from invalid body', () => {
  expect(() => {
    submitSchema.parse({ session_id: 'not-a-uuid' })
  }).toThrow(z.ZodError)
})
```

**React Hook Testing (with Testing Library + Vitest):**
```typescript
import { renderHook, waitFor } from '@testing-library/react'
import { usePracticeSession } from './usePracticeSession'

it('loads question on mount', async () => {
  const { result } = renderHook(() => usePracticeSession())
  
  await waitFor(() => {
    expect(result.current.question).toBeDefined()
  })
})

it('submits answer and updates state', async () => {
  const { result } = renderHook(() => usePracticeSession())
  
  act(() => {
    result.current.submitAnswer('2')
  })
  
  await waitFor(() => {
    expect(result.current.isCorrect).toBe(true)
  })
})
```

**Component Testing (render + user interaction):**
```typescript
import { render, screen } from '@testing-library/react'
import { Button } from './Button'

it('renders button with children', () => {
  render(<Button>Click me</Button>)
  expect(screen.getByText('Click me')).toBeInTheDocument()
})

it('disables button when loading', () => {
  render(<Button loading>Submit</Button>)
  expect(screen.getByRole('button')).toBeDisabled()
})
```

## Recommended Setup (For Future)

**Install:**
```bash
npm install --save-dev vitest @testing-library/react @testing-library/jest-dom @testing-library/user-event
npm install --save-dev @vitest/ui  # for UI runner
```

**Backend `vitest.config.ts`:**
```typescript
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    environment: 'node',
    globals: true,
  },
})
```

**Frontend `vitest.config.ts`:**
```typescript
import { defineConfig } from 'vitest/config'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: ['src/__tests__/setup.ts'],
  },
})
```

**Add to `package.json` scripts:**
```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:coverage": "vitest --coverage"
  }
}
```

---

*Testing analysis: 2026-06-26*
