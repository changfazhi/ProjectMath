# Coding Conventions

**Analysis Date:** 2026-06-26

## TypeScript Configuration

**Backend** (`backend/tsconfig.json`):
- `strict: true` — strict mode enforced; `no any` rule upheld by convention
- `module: "NodeNext"`, `moduleResolution: "NodeNext"` — all local imports must use `.js` extension even for `.ts` source files
  - Correct: `import { supabase } from '../db/supabase.js'`
  - Wrong: `import { supabase } from '../db/supabase'`
- `target: ES2022`

**Frontend** (`frontend/tsconfig.app.json`):
- `strict` not set, but `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch` are enforced
- `moduleResolution: "bundler"` — no extension required on imports
- `verbatimModuleSyntax: true` — use `import type` for type-only imports
- `jsx: "react-jsx"`

## Backend Patterns

### Route Responsibility
Routes are thin wrappers — validate input, call one service function, return JSON. No business logic in routes.

```typescript
// Correct — backend/src/routes/attempts.ts
router.post('/', async (req, res) => {
  const body = submitSchema.parse(req.body);   // validate
  const result = await submitAttempt(body);    // delegate
  res.status(201).json(result);                // respond
});
```

### Zod Validation
Every `req.body` and `req.query` parameter is validated with Zod before use. Inline schemas for query params; named schemas for request bodies.

```typescript
// Body schema (named)
const submitSchema = z.object({
  session_id: z.string().uuid(),
  question_id: z.string().uuid(),
  answer_given: z.string().min(1),
  time_taken_s: z.number().int().positive().optional(),
});
const body = submitSchema.parse(req.body);

// Query param (inline)
const sessionId = z.string().uuid().parse(req.query.session_id);
```

ZodError catches return HTTP 400 with `{ error, details }`. Other errors return HTTP 500.

### Database Access
Never call `supabase` from a route file. All Supabase queries live in `backend/src/services/*.ts`.

```
backend/src/
  routes/      ← HTTP handling only; import from services
  services/    ← all Supabase queries and business logic
  db/          ← supabase client, gemini client
```

### Error Handling
```typescript
if (err instanceof z.ZodError) {
  res.status(400).json({ error: 'Invalid request body', details: err.issues });
  return;
}
if ((err as Error).message.includes('not found')) {
  res.status(404).json({ error: (err as Error).message });
  return;
}
res.status(500).json({ error: (err as Error).message });
```

## Frontend Patterns

### API Calls
All HTTP requests go through `frontend/src/lib/api.ts`. Never call `fetch` directly in components or hooks.

- JSON requests: internal `request<T>(path, init?)` function
- Form data (file uploads): internal `requestFormData<T>(path, formData)` function — do NOT set `Content-Type` header; the browser sets the multipart boundary
- Exported as `api.{namespace}.{method}(...)` — e.g., `api.attempts.submit(...)`, `api.grade.submit(...)`

### CSS / Tailwind
Always compose class names via `cn()` from `frontend/src/lib/utils.ts`. Do not concatenate class strings manually.

```typescript
import { cn } from '../lib/utils'
<div className={cn('base-class', isActive && 'active-class', disabled && 'opacity-50')} />
```

### Types
All shared API types live in `frontend/src/types/api.ts`. These mirror backend types exactly — add new fields to both places. Never inline ad-hoc response types in components.

## LaTeX Rendering

Three rendering contexts — use the correct one for each:

| Context | Component/Function | Example |
|---|---|---|
| Mixed text + math | `renderLatex()` helper | Question prompts with prose |
| Pure LaTeX expression | `<Latex>` component | Correct answer display |
| Block/display math | `<LatexBlock>` component | Standalone equations |

`renderLatex()` expects `\(...\)` for inline math and `\[...\]` for display math. Do not use `$...$` or `$$...$$` delimiters in content strings.

## MathLive Keyboard

- Use `onMouseDown` (not `onClick`) on keyboard buttons to prevent the MathField from losing focus
- Always call `e.preventDefault()` on `onMouseDown` handlers
- Template strings use `#?` as placeholders: e.g., `\\frac{#?}{#?}`
- Pass `selectionMode: 'placeholder'` to `mf.insert()` so the cursor lands inside the placeholder

```typescript
// Correct — frontend/src/components/MathKeyboard.tsx pattern
<button
  onMouseDown={(e) => {
    e.preventDefault();
    mathFieldRef.current?.insert('\\frac{#?}{#?}', { selectionMode: 'placeholder' });
  }}
/>
```

## Answer Types

Defined per-question or per-part in the `answer_type` column:

| Value | Meaning | Grading |
|---|---|---|
| `"exact"` | Algebraic / LaTeX answer | `normalizeLaTeX()` string match, then numeric eval, then symbolic eval |
| `"range"` | Numerical with tolerance | `\|given − correct\| ≤ tolerance` (default 0.01) |
| `null` | Show-that / ungraded part | No answer box rendered; no submission accepted |

`normalizeLaTeX()` in `backend/src/services/attemptService.ts` applies these transforms in order:
1. Strip all whitespace
2. Remove spacing commands: `\,` `\ ` `\;` `\:` `\!` `\quad` `\qquad`
3. Normalise MathLive delimiters: `\mleft` → `\left`, `\mright` → `\right`
4. Expand compact MathLive fractions: `\frac13` → `\frac{1}{3}` (three regex passes for mixed forms)
5. Lowercase everything
6. Normalise logical connectives: `\text{or}`, `\lor` → `or`; `\text{and}`, `\land` → `and`; `\operatorname{or/and}` → plain text

The **question-level** `answer_type` column is `NOT NULL`. For a show-that single question, wrap it as a multi-part question with one `null` part and give the question row `answer_type = 'exact', correct_answer = ''`.

## SQL Conventions

- Use `$$...$$` dollar-quoting in SQL migrations to avoid backslash and quote escaping issues
- Run `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;` after every `CREATE TABLE`
- LaTeX stored in JSONB `parts` arrays requires doubled backslashes: `\frac` → `\\frac`, `\\` (LaTeX line break) → `\\\\`
- Migration files are numbered sequentially in `backend/supabase/migrations/` (e.g., `001_initial_schema.sql`)

## Naming Conventions

- **Files:** `camelCase.ts` for services/routes/hooks; `PascalCase.tsx` for React components
- **Service functions:** exported named functions (not default), e.g., `export async function submitAttempt(...)`
- **Routes:** one file per resource, default export of `Router`
- **Types:** PascalCase interfaces/types; suffix `Body` for request bodies, `Response` for responses

---

*Convention analysis: 2026-06-26*
