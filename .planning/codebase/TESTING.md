# Testing Patterns

**Analysis Date:** 2026-07-04

## Test Framework

**Runner:**
- Not detected — no test framework installed

**Assertion Library:**
- Not detected

**Run Commands:**
- No test commands defined in `backend/package.json` or `frontend/package.json`

## Current Testing Status

**Test files:**
- No `.test.ts`, `.test.tsx`, `.spec.ts`, or `.spec.tsx` files found in the codebase
- Zero test coverage

**Configuration:**
- No `jest.config.js`, `vitest.config.ts`, `mocha.opts`, or equivalent
- No test setup files

## Recommended Testing Approach

Given the technology stack and project structure, the following frameworks are recommended for addition:

**Backend (Express + TypeScript):**
- Framework: Vitest (modern, fast, great TS support) or Jest (mature, comprehensive)
- Mocking: `vitest.mock()` or Jest's `jest.mock()`
- HTTP testing: `supertest` for Express route testing
- Database testing: Use an isolated Supabase test project or mock the `supabase` client

**Frontend (React + TypeScript):**
- Framework: Vitest or Jest with `@testing-library/react`
- Component testing: `@testing-library/react` for user-centric testing
- Mocking: `vitest.mock()` for hooks and API calls
- Async testing: `waitFor()` from testing library

## Testing Patterns to Establish

### Backend Route Testing

Routes should test:
1. Happy path with valid input
2. Zod validation failures (400)
3. Authentication failures (401)
4. Payment/subscription gating (402)
5. Resource not found (404)
6. Internal errors (500)

**Suggested structure for `routes/attempts.test.ts`:**
```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest'
import supertest from 'supertest'
import app from '../index'
import * as attemptService from '../services/attemptService'

vi.mock('../services/attemptService')
vi.mock('../middleware/auth')

describe('POST /api/attempts', () => {
  let req: supertest.SuperTest<supertest.Test>

  beforeEach(() => {
    req = supertest(app)
    vi.clearAllMocks()
  })

  it('submits a valid attempt', async () => {
    const mockResult = { is_correct: true, correct_answer: '\\frac{1}{2}', solution_latex: null }
    vi.mocked(attemptService.submitAttempt).mockResolvedValue(mockResult)

    const res = await req
      .post('/api/attempts')
      .send({
        question_id: '00000000-0000-0000-0000-000000000001',
        answer_given: '\\frac{1}{2}',
      })

    expect(res.status).toBe(201)
    expect(res.body).toEqual(mockResult)
  })

  it('rejects invalid question_id (not UUID)', async () => {
    const res = await req
      .post('/api/attempts')
      .send({
        question_id: 'not-a-uuid',
        answer_given: '\\frac{1}{2}',
      })

    expect(res.status).toBe(400)
    expect(res.body.error).toContain('Invalid request body')
  })

  it('returns 401 when not authenticated', async () => {
    // Mock auth to reject
    // Response should be 401
  })
})
```

### Service Testing

Services should test:
1. Main business logic with mocked dependencies
2. Error cases (database failures, API errors)
3. Complex calculations (LaTeX normalization, symbolic evaluation)
4. State transitions (e.g., multi-part grading)

**Suggested structure for `services/attemptService.test.ts`:**
```typescript
import { describe, it, expect, vi } from 'vitest'
import { normalizeLaTeX, checkAnswer } from '../services/attemptService'
import * as questionService from './questionService'

vi.mock('./questionService')

describe('normalizeLaTeX()', () => {
  it('normalizes compact MathLive fractions', () => {
    const result = normalizeLaTeX('\\frac13')
    expect(result).toBe('\\frac{1}{3}')
  })

  it('removes spacing', () => {
    const result = normalizeLaTeX('\\frac{1}{2} + \\frac{1}{3}')
    expect(result).toBe('\\frac{1}{2}+\\frac{1}{3}')
  })

  it('handles "or" and "and"', () => {
    const result = normalizeLaTeX('\\text{or}')
    expect(result).toContain('or')
  })
})

describe('checkAnswer()', () => {
  it('matches exact LaTeX answers', () => {
    const isCorrect = checkAnswer('exact', '\\frac{1}{2}', '\\frac{1}{2}')
    expect(isCorrect).toBe(true)
  })

  it('ignores whitespace in exact answers', () => {
    const isCorrect = checkAnswer('exact', '\\frac{1}{2}', '\\frac{1}{2} ')
    expect(isCorrect).toBe(true)
  })

  it('checks range answers within tolerance', () => {
    const isCorrect = checkAnswer('range', '1.5', '1.51', 0.1)
    expect(isCorrect).toBe(true)
  })
})
```

### Frontend Hook Testing

Hooks should test:
1. Initial state
2. Effects (loading data, cleanup)
3. Error handling
4. Dependency updates

**Suggested structure for `hooks/useTopics.test.ts`:**
```typescript
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { useTopics } from './useTopics'
import * as api from '../lib/api'

vi.mock('../lib/api')

describe('useTopics()', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('loads topics on mount', async () => {
    const mockTopics = [
      { id: '1', name: 'Topic 1', level: 'H2' },
    ]
    vi.mocked(api.api.topics.list).mockResolvedValue(mockTopics)

    const { result } = renderHook(() => useTopics('H2'))

    expect(result.current.loading).toBe(true)

    await waitFor(() => {
      expect(result.current.loading).toBe(false)
    })

    expect(result.current.topics).toEqual(mockTopics)
  })

  it('handles errors', async () => {
    const error = new Error('Network failure')
    vi.mocked(api.api.topics.list).mockRejectedValue(error)

    const { result } = renderHook(() => useTopics('H2'))

    await waitFor(() => {
      expect(result.current.error).toBe('Network failure')
    })
  })
})
```

### Frontend Component Testing

Components should test:
1. Rendering with given props
2. User interactions (clicks, form input)
3. Conditional rendering (based on state/props)
4. Accessibility (labels, ARIA attributes)

**Suggested structure for `components/PremiumExpiryBanner.test.tsx`:**
```typescript
import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import { PremiumExpiryBanner } from './PremiumExpiryBanner'
import * as authContext from '../contexts/AuthContext'

vi.mock('../contexts/AuthContext')

describe('PremiumExpiryBanner', () => {
  it('does not render when tier is free', () => {
    vi.mocked(authContext.useAuth).mockReturnValue({
      tier: 'free',
      accessExpiresAt: null,
    })

    const { container } = render(<PremiumExpiryBanner onRenew={() => {}} />)
    expect(container.firstChild).toBeNull()
  })

  it('renders when expiry is within 3 days', () => {
    const expiryDate = new Date()
    expiryDate.setDate(expiryDate.getDate() + 2)

    vi.mocked(authContext.useAuth).mockReturnValue({
      tier: 'paid',
      accessExpiresAt: expiryDate,
    })

    render(<PremiumExpiryBanner onRenew={() => {}} />)
    expect(screen.getByText(/expires in/)).toBeInTheDocument()
  })
})
```

## Mocking Strategy

**Database (Supabase):**
- Mock the `supabase` client at `src/db/supabase.ts`
- Return controlled responses for each test case
- Never use a real database in unit tests

```typescript
vi.mock('../db/supabase', () => ({
  supabase: {
    from: vi.fn((table: string) => ({
      select: vi.fn().mockReturnValue({
        eq: vi.fn().mockReturnValue({
          single: vi.fn().mockResolvedValue({
            data: { id: '1', name: 'Test' },
            error: null,
          }),
        }),
      }),
    })),
  },
}))
```

**External APIs (Gemini, Stripe):**
- Mock at the DB wrapper level (`src/db/gemini.ts`, `src/db/stripe.ts`)
- Return realistic response shapes
- Test error cases separately

**Middleware (Auth):**
- Mock `requireAuth()` in route tests
- Inject test user via `req.user`

**API calls (Frontend):**
- Mock `lib/api.ts` entirely or use MSW (Mock Service Worker)
- Never make real HTTP requests in unit tests

## What to Mock vs. What NOT to Mock

**DO mock:**
- External APIs (Gemini, Stripe, Firebase Auth)
- Database calls (Supabase)
- Rate limiters and timers
- Randomness (crypto, UUIDs)

**DO NOT mock:**
- Utility functions (`normalizeLaTeX()`, `cn()`)
- Core business logic (grading, validation)
- React hooks when testing components (use `renderHook()` instead)
- CSS/styling

## Coverage Expectations

Given the lack of existing tests, priority order for coverage:

1. **Critical paths (high priority):**
   - Answer submission and grading logic (`services/attemptService.ts`, `services/gradingService.ts`)
   - LaTeX normalization and evaluation
   - Authentication and subscription gating
   - Payment webhook handling (`routes/billing.ts`)

2. **Medium priority:**
   - Chat service (hint generation and history)
   - Star and streak calculations
   - Topic progress calculations

3. **Lower priority:**
   - UI components (render checks only; detailed interaction tests can follow)
   - Utility functions

## Integration Testing

For end-to-end critical flows (optional, can be added later):

**Setup:**
- Use Testcontainers or a test Supabase instance
- Mock external APIs (Gemini, Stripe, Firebase)
- Use `supertest` to drive HTTP requests

**Flows to test:**
1. User signs in → attempts a question → submits answer → grading succeeds
2. User stars a question → retrieves starred list
3. Subscription workflow: checkout → webhook → access granted

## CI/CD Integration

**Suggested GitHub Actions workflow:**

```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - run: npm ci
      - run: npm run test
      - run: npm run test:coverage
      - uses: codecov/codecov-action@v3
```

Add to `package.json`:
```json
"scripts": {
  "test": "vitest run",
  "test:watch": "vitest",
  "test:coverage": "vitest run --coverage"
}
```

---

*Testing analysis: 2026-07-04*
