# Math Trainer — Project Guide

LeetCode-style math practice for Singapore H2 A-Level students. Express + TypeScript backend, React 19 + Vite + Tailwind + KaTeX frontend.

## Running

```bash
cd backend && npm run dev      # port 3001, tsx watch
cd frontend && npm run dev     # port 5173, Vite — proxies /api/* → 3001
```

`backend/.env` (copy from `.env.example`): set `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`. Never commit; never expose to the browser.

## Database Setup

Run in order in the Supabase SQL Editor:

1. `001_initial_schema.sql` — core tables + indexes
2. `002_question_names.sql` — adds `name` column to questions
3. `003_topic_concepts.sql` — creates `topic_concepts` table
4. `004_starred_questions.sql` — creates `starred_questions` table
5. `005_new_topics.sql` — inserts 24 topics, 120 concepts, grants permissions

`seed.sql` — **dev only**: TRUNCATEs everything and re-inserts from scratch.

**Permission gotcha:** After any `CREATE TABLE`, run:
```sql
GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;
```

## Topic UUIDs (all H2)

UUID pattern: `aaaa000N-0000-0000-0000-000000000000` (Pure Math), `bbbb000N-0000-0000-0000-000000000000` (Stats).

| UUID | Topic | | UUID | Topic |
|---|---|---|---|---|
| aaaa0001 | Graphing Techniques | | aaaa0010 | Vector (Plane) |
| aaaa0002 | Functions | | aaaa0011 | Complex Number |
| aaaa0003 | Transformation | | aaaa0012 | Differentiation Technique ✱ |
| aaaa0004 | Conics | | aaaa0013 | Application of Differentiation |
| aaaa0005 | Inequalities | | aaaa0014 | Maclaurin Series |
| aaaa0006 | Systems of Linear Equations | | aaaa0015 | Integration Technique ✱ |
| aaaa0007 | Sequences & Series | | aaaa0016 | Definite Integral |
| aaaa0008 | Vector (Basic) | | aaaa0017 | Parametric Equations |
| aaaa0009 | Vector (Lines) | | aaaa0018 | Differential Equations |

✱ = has sample questions (4 each). Stats: bbbb0001–bbbb0006 (Permutation → Regression).

## API Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/api/topics?level=H2` | List topics |
| GET | `/api/topics/:topicId/questions?session_id=UUID` | Questions with attempt status |
| GET | `/api/topics/:topicId/next?session_id=UUID&difficulty=N` | Next unanswered question |
| GET | `/api/topics/:topicId/concepts` | Prerequisite concepts |
| GET | `/api/questions/:id` | Single question (no answer/solution) |
| POST | `/api/attempts` | Submit answer → `{ is_correct, correct_answer, solution_latex }` |
| GET | `/api/attempts?session_id=UUID` | Session history |
| POST | `/api/stars` | Toggle star → `{ starred: bool }` |
| GET | `/api/stars?session_id=UUID&topic_id=UUID` | Starred question IDs |

## Frontend Architecture

- **Routes:** `/` (roadmap + TopicDrawer), `/practice/:topicId`, `/history`
- **Session:** UUID v4 in `localStorage` as `session_id` (`lib/session.ts`). No auth in MVP.
- **TopicDrawer:** Roadmap node click → right panel with concepts + question list. Row click → `/practice/:topicId?question_id=<uuid>`.
- **PracticePage:** `?question_id=` → `loadSpecific(id)`; otherwise `loadNext()`. Both idempotent — safe under StrictMode double-invoke. Never use a `firstLoad` ref.
- **Practice state machine:** `loading → answering → submitted → revealed → complete | error`
- **Stars:** Optimistic UI — flip locally, sync to server, revert on failure (`useTopicQuestions.ts`).
- **Roadmap canvas:** `CANVAS_W=1020, CANVAS_H=700, NODE_W=176, NODE_H=72`. Cols at cx=100/340/580/870, rows at cy=60/170/280/390/500/610.

## Math Input (MathLive)

Answer input uses **MathLive** (`mathlive` npm) `<math-field>` web component — renders math visually, not raw LaTeX.

- **`MathField.tsx`** — React wrapper. Exposes `insert(latex)`, `getValue()`, `focus()` via `useImperativeHandle`. MathLive's own keyboard and hamburger menu are suppressed (shadow DOM style injection + `menuItems = []`).
- **`MathKeyboard.tsx`** — 10-group symbol panel. Use `onMouseDown` (not `onClick`) on buttons to avoid stealing focus from the math field. Template inserts use `#?` placeholders (e.g. `\frac{#?}{#?}`) so MathLive lands cursor in the first slot.
- **`selectionMode: 'placeholder'`** must be passed to `mf.insert()` for cursor-in-slot to work.
- **Correct answer display:** `correct_answer` is always raw LaTeX — render with `<Latex>` directly, not `renderLatex()` (which requires `\(...\)` delimiters).
- **MathLive compact notation:** Single-character fractions output `\frac34` not `\frac{3}{4}`. Multi-character fractions use full braces. Account for this when writing `correct_answer` values in the DB.

## Key Conventions

- **Backend:** Strict TS, no `any`. Zod validates all `req.body`/`req.query`. Routes are thin — all logic in services. Never call `supabase` from a route. `NodeNext` module system — `.js` extension on imports even for `.ts` files.
- **Frontend:** All fetch calls via `lib/api.ts`. Use `cn()` from `lib/utils.ts` for Tailwind. Frontend types mirror backend in `src/types/api.ts`.
- **LaTeX rendering:** Mixed text+math → `renderLatex()` (handles `\(...\)` / `\[...\]` delimiters). Pure LaTeX string → `<Latex>` directly. Display block → `<LatexBlock>`.
- **Answer types:** `exact` (trim + case-insensitive string match) or `range` (`|given − correct| ≤ tolerance`). No MCQ.
- **Solution hiding:** `correct_answer` and `solution_latex` stripped before sending to client (`stripSolution()` in `questionService.ts`), only returned after attempt submission.

## Status

**Built:** Backend (schema, services, routes, answer checking), full frontend (roadmap, drawer, practice session, history, star system), visual math input keyboard (MathLive), 24-topic syllabus with 5 prerequisite concepts each, 8 sample questions.

**Not built yet:** Auth (Supabase Auth), progress analytics, timed mock paper mode, admin question editor. Only 2 of 24 topics have questions — adding more questions is the most useful next step.

## Common Pitfalls

| Problem | Fix |
|---|---|
| "permission denied for table X" | Run GRANT statement after CREATE TABLE |
| Drawer click loads wrong question | Use `loadSpecific()` not `loadNext()` — StrictMode fires effects twice |
| Backend crashes on start | `.env` missing — copy `.env.example` and fill credentials |
| `tsx`/`vite: command not found` | `npm run setup` from project root |
| Math keyboard steals focus | Use `onMouseDown` + `e.preventDefault()` on keyboard buttons |
| Cursor lands after fraction, not inside | Pass `selectionMode: 'placeholder'` to `mf.insert()` and use `#?` in template strings |
