# Math Trainer — Project Guide

LeetCode-style math practice for Singapore H2 A-Level students. Express + TypeScript backend, React 19 + Vite + Tailwind + KaTeX frontend.

## Running

```bash
cd backend && npm run dev      # port 3001, tsx watch
cd frontend && npm run dev     # port 5173, Vite — proxies /api/* → 3001
```

`backend/.env` (copy from `.env.example`): set `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` (Supabase dashboard → Settings → API). Never commit; never expose to the browser.

## Database Setup

Run in order in the Supabase SQL Editor:

1. `001_initial_schema.sql` — core tables + indexes
2. `002_question_names.sql` — adds `name` column to questions
3. `003_topic_concepts.sql` — creates `topic_concepts` table
4. `004_starred_questions.sql` — creates `starred_questions` table
5. `005_new_topics.sql` — inserts 24 topics, 120 concepts, grants permissions

`seed.sql` — **dev only**: TRUNCATEs everything and re-inserts from scratch.

**Permission gotcha:** Tables created via raw SQL need explicit grants, otherwise Supabase returns "permission denied" even with the service_role key. After any `CREATE TABLE`:
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

✱ = has existing sample questions (4 each). Stats: bbbb0001 Permutation and Combination → bbbb0002 Probability → bbbb0003 Discrete Random Variable → bbbb0004 Sampling and Estimation Theory → bbbb0005 Hypothesis Testing → bbbb0006 Correlation and Linear Regression.

## API Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/api/topics?level=H2` | List topics |
| GET | `/api/topics/:topicId/questions?session_id=UUID` | Questions with per-session attempt status |
| GET | `/api/topics/:topicId/next?session_id=UUID&difficulty=N` | Next unanswered question |
| GET | `/api/topics/:topicId/concepts` | Prerequisite concepts |
| GET | `/api/questions/:id` | Single question (no answer/solution) |
| POST | `/api/attempts` | Submit answer → `{ is_correct, correct_answer, solution_latex }` |
| GET | `/api/attempts?session_id=UUID` | Session history |
| POST | `/api/stars` | Toggle star `{ session_id, question_id }` → `{ starred: bool }` |
| GET | `/api/stars?session_id=UUID&topic_id=UUID` | Starred question IDs for a topic |

## Frontend Architecture

- **Routes:** `/` (roadmap + TopicDrawer), `/practice/:topicId`, `/history`
- **Session:** UUID v4 in `localStorage` as `session_id` (`lib/session.ts`). No auth in MVP.
- **TopicDrawer:** Clicking a roadmap node slides in a right panel with prerequisite concepts and a question list (Status / Star / Name / Difficulty). Clicking a row navigates to `/practice/:topicId?question_id=<uuid>`.
- **PracticePage:** If `?question_id=` is present, calls `loadSpecific(id)` instead of `loadNext()`. Both are idempotent — safe under React StrictMode's double effect invocation. Never use a `firstLoad` ref to skip the second call.
- **Practice state machine:** `loading → answering → submitted → revealed → complete | error`
- **Stars:** Optimistic UI — flip locally, sync to server, revert on failure (`useTopicQuestions.ts`).
- **Roadmap canvas:** `CANVAS_W=1020, CANVAS_H=700, NODE_W=176, NODE_H=72`. Cols at cx=100/340/580/870, rows at cy=60/170/280/390/500/610. Colors: violet (ColA), indigo (ColB), sky (ColC), emerald (ColD stats).

## Key Conventions

- **Backend:** Strict TS, no `any`. Zod validates all `req.body`/`req.query`. Routes are thin — all logic lives in services. Never call `supabase` from a route. `NodeNext` module system — use `.js` extension on imports even for `.ts` files.
- **Frontend:** All fetch calls go through `lib/api.ts`. Use `cn()` from `lib/utils.ts` for Tailwind classes. Frontend types mirror backend in `src/types/api.ts`.
- **Answer types:** `exact` (trim + case-insensitive) or `range` (`|given − correct| ≤ tolerance`). No MCQ.
- **Solution hiding:** `correct_answer` and `solution_latex` are never sent to the client until after an attempt is submitted (`stripSolution()` in `questionService.ts`).

## Status

**Built:** Backend (schema, services, routes, answer checking), full frontend (roadmap, drawer, practice session, history, star system), 24-topic syllabus with 5 prerequisite concepts each, 8 sample questions.

**Not built yet:** Auth (Supabase Auth), progress analytics, timed mock paper mode, admin question editor. Only 2 of 24 topics have questions — adding more questions is the most useful next step.

## Common Pitfalls

| Problem | Fix |
|---|---|
| "permission denied for table X" | Run the GRANT statement above after creating the table |
| Drawer click loads wrong question | Use `loadSpecific()` not `loadNext()` — StrictMode fires effects twice |
| Backend crashes on start | `.env` is missing — copy from `.env.example` and fill in credentials |
| `tsx`/`vite: command not found` | `npm run setup` from the project root to install all deps |
