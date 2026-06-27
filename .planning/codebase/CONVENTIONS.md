# Coding Conventions

**Analysis Date:** 2026-06-27

## Naming Patterns

**Files:**
- Backend: camelCase for service/utility files (`attemptService.ts`, `chatService.ts`), camelCase for routes (`attempts.ts`, `chat.ts`)
- Frontend: PascalCase for components (`ChatPanel.tsx`, `GradingResult.tsx`), camelCase for hooks (`usePracticeSession.ts`, `useChatSession.ts`), camelCase for lib utilities (`api.ts`, `session.ts`, `utils.ts`)
- SQL migrations: zero-padded numeric prefix (`001_initial_schema.sql`, `016_cjc_prelim_2025.sql`)

**Functions:**
- Backend service functions: camelCase verb+noun (`submitAttempt`, `getAttemptsBySession`, `buildGradingInstruction`)
- Private helpers: camelCase, unexported (`normalizeLaTeX`, `checkAnswer`, `tryNumericEval`)
- Middleware: camelCase verb phrases (`requireAuth`)
- Gate factory: short noun (`gate(feature)`)

**Variables:**
- camelCase throughout TypeScript
- Database column names use snake_case (matches Supabase schema)
- Boolean DB columns: `is_` prefix (`is_correct`, `is_completed`)

**Types:**
- PascalCase interfaces and type aliases (`PracticeState`, `QuestionPart`, `SubmitAttemptBody`)
- Reducer action discriminants use ALL_CAPS strings (`'LOAD_START'`, `'SUBMIT_SUCCESS'`)
- React state phases: union string literals (`'loading' | 'answering' | 'submitted' | 'revealed' | 'complete' | 'error'`)

## TypeScript Configuration

**Backend (`backend/tsconfig.json`):**
- `"strict": true` — no implicit any, strict null checks
- `"module": "NodeNext"`, `"moduleResolution": "NodeNext"` — all internal imports must use `.js` extension even for `.ts` source files
- Target: `ES2022`

**Frontend:**
- Strict mode enabled via Vite-managed tsconfig
- No `.js` extension needed on imports

**No `any` rule:** Never use `any`. Use `unknown` and narrow with type guards, or use `as SomeType` only when shape is certain (e.g., after Supabase `.single()`).

## Import Organization

**Backend order:**
1. Third-party packages (`express`, `zod`, `firebase-admin/auth`)
2. Internal `../db/*` (Supabase client, Gemini client, Firebase Admin)
3. Internal `../services/*`
4. Internal `../types/index.js`

**Frontend order:**
1. React and React hooks
2. Third-party packages
3. Internal `../lib/*` (`api`, `session`, `utils`)
4. Internal `../hooks/*`
5. Internal `../types/api`
6. Internal components

**Path Aliases:**
- Frontend: `@/` alias pointing to `src/` (Vite + tsconfig)
- Backend: relative paths only; no aliases

## Backend Architecture Rules

**Routes are thin.** Every route file follows this exact pattern:
1. Define a Zod schema at module level for request body / query params
2. `schema.parse(req.body)` inside the try block
3. Delegate to a service function with `req.user!.uid` and parsed body
4. Return result with appropriate HTTP status
5. Catch `ZodError` → 400, "not found" domain errors → 404, all others → 500

**Never call `supabase` from a route file.** All DB access lives in `backend/src/services/`.

**Auth pattern:**
- `requireAuth` (`backend/src/middleware/auth.ts`): verifies Firebase ID token, upserts user into Supabase `users` table, sets `req.user = { uid: string, tier: 'free' | 'paid' }`
- `gate(feature)` returns `[requireAuth, tierCheck]` — spread as route middleware: `router.post('/', ...gate('practice'), async (req, res) => { ... })`
- Inside handler, `req.user!.uid` is safe (non-null assertion is correct after gate)

**Canonical route structure (`backend/src/routes/attempts.ts`):**
```typescript
const submitSchema = z.object({
  question_id: z.string().uuid(),
  answer_given: z.string().min(1),
  time_taken_s: z.number().int().positive().optional(),
});

router.post('/', ...gate('practice'), async (req, res) => {
  try {
    const body = submitSchema.parse(req.body);
    const result = await submitAttempt(req.user!.uid, body);
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

**Zod validation:**
- All `req.body` validated with a module-level schema
- Query params validated inline: `z.string().uuid().parse(req.query.field)`

## Frontend Architecture Rules

**All HTTP calls through `frontend/src/lib/api.ts`.** Never use `fetch` directly in components or hooks.

The `api` object is namespaced by resource:
- `api.topics.list()`, `api.topics.questions(topicId)`
- `api.attempts.submit(body)`, `api.attempts.list(questionId?)`
- `api.grade.submit(questionId, images, timeTakenS?)`
- `api.pair.create(questionId)`, `api.pair.uploadPhoto(token, image)`

**Auth headers:** `lib/api.ts` auto-attaches Firebase ID token via `getAuthHeader()`. No component handles auth headers.

**Error handling from `api.ts`:**
- HTTP 401 → `_callbacks.onUnauthorized()` + throws `'Sign in to continue'`
- HTTP 402 → `_callbacks.onPaymentRequired()` + throws `'Subscription required'`
- Other non-ok → parses `{ error: string }` from body and throws that message

**State machines in hooks:** Complex UI state uses `useReducer` with explicit `Action` union types, not multiple `useState` booleans. See `frontend/src/hooks/usePracticeSession.ts` for the canonical pattern (phase state machine + dispatch-based updates).

**Tailwind styling:**
- Use `cn()` from `frontend/src/lib/utils.ts` for conditional class merging
- No inline styles; no CSS Modules; no per-component `.css` files

## LaTeX Rendering

| Situation | Use |
|-----------|-----|
| Mixed prose + math (question text with `\(...\)` delimiters) | `renderLatex()` function |
| Pure LaTeX string (no surrounding prose) | `<Latex>` component |
| Block/display math | `<LatexBlock>` component |

Never pass raw LaTeX to `renderLatex()` without delimiters — it will render as plain text.

## Error Handling

**Backend services:**
- Supabase errors: always check `if (error) throw new Error(error.message)` immediately after the call
- Services throw `Error` with descriptive messages; routes map them to HTTP status codes
- Fire-and-forget side effects: wrap in `.catch(() => { /* non-critical */ })`:
  ```typescript
  upsertSRCard(userId, questionId, topicId, isCorrect).catch(() => {
    // Non-critical; SR state will self-correct on next attempt.
  });
  ```

**Frontend hooks:**
- Reducer state carries `error: string | null`
- Dispatch `{ type: 'ERROR', message: string }` to enter error state
- Soft errors use dedicated action types (`GRADE_REJECTED`) that keep phase at `'answering'` so the student can retry without entering the global error screen

## Comments

- Explain non-obvious decisions, not what the code does
- Confidential AI prompt data: mark with `// server-side only, marked confidential`
- Fire-and-forget patterns: always comment why the failure is safe to ignore
- SQL constraint nuances: comment inline when the constraint is non-obvious

## Module Exports

**Backend services:** Named exports only. No default exports from service files.

**Backend routes:** `export default router` (single default export per file).

**Frontend hooks:** Named export of the hook function. Internal types exported only when callers need them.

**Frontend `lib/api.ts`:** Named `api` object export + `setApiCallbacks` named export.

---

*Convention analysis: 2026-06-27*
