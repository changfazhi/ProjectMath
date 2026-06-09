# Math Trainer — Project Guide

A LeetCode-style practice platform for Singapore H1/H2 A-Level Mathematics students.

## Project Structure

```
ProjectMath/
├── backend/                  ← Express + TypeScript REST API (this session built this)
│   ├── src/
│   │   ├── types/index.ts    ← All shared types (Topic, Question, Attempt, etc.)
│   │   ├── db/supabase.ts    ← Supabase client (uses service role key)
│   │   ├── services/         ← Business logic; routes call services, not DB directly
│   │   │   ├── topicService.ts
│   │   │   ├── questionService.ts
│   │   │   └── attemptService.ts
│   │   ├── routes/           ← Express routers (thin — validation + call service)
│   │   │   ├── topics.ts
│   │   │   ├── questions.ts
│   │   │   └── attempts.ts
│   │   └── index.ts          ← Server entrypoint
│   └── supabase/
│       ├── migrations/001_initial_schema.sql   ← Run first in Supabase SQL editor
│       └── seed.sql                            ← Run second; adds 10 sample questions
└── CLAUDE.md
```

Frontend lives in a separate folder (not yet created). Backend is the only thing built so far.

---

## Running the Backend

```bash
cd backend
cp .env.example .env        # fill in SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY
npm install
npm run dev                 # tsx watch — hot reload on save
```

Server starts on `http://localhost:3001`.

---

## Environment Variables

| Variable | Where to find it |
|---|---|
| `SUPABASE_URL` | Supabase dashboard → Settings → API → Project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase dashboard → Settings → API → service_role (secret) |

Never commit `.env`. The service role key bypasses RLS — fine for a backend server, never expose it to a browser.

---

## Database Setup

Run these two files **in order** in the Supabase SQL Editor:

1. `backend/supabase/migrations/001_initial_schema.sql` — creates tables and indexes
2. `backend/supabase/seed.sql` — inserts 5 topics and 8 sample questions

Tables:
- `topics` — name, level (H1/H2), optional parent_topic_id for sub-topics
- `questions` — prompt_latex, answer_type, correct_answer, solution_latex, etc.
- `attempts` — keyed by session_id (client UUID), not user auth for MVP

---

## API Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/api/topics?level=H2` | List all topics, optionally filtered by level |
| GET | `/api/topics/:id` | Get a single topic |
| GET | `/api/topics/:topicId/next?session_id=UUID&difficulty=2` | Next question for topic (skips already-correct) |
| GET | `/api/questions/:id` | Get question by ID (no solution, no answer) |
| POST | `/api/attempts` | Submit answer → returns `{ is_correct, correct_answer, solution_latex }` |
| GET | `/api/attempts?session_id=UUID` | List session's attempt history |

The core practice loop is:
1. `GET /api/topics` → user picks a topic
2. `GET /api/topics/:topicId/next?session_id=...` → receive a question (no solution)
3. User submits answer → `POST /api/attempts`
4. Response includes `is_correct`, `correct_answer`, and `solution_latex` — display solution
5. Repeat from step 2

---

## Key Conventions

### TypeScript
- Strict mode on. No `any`. Use `unknown` + narrowing when the shape is uncertain.
- All DB types defined in `src/types/index.ts`. Keep them in sync with the Supabase schema.
- Module system: `NodeNext` — imports must include `.js` extension even for `.ts` source files.
- Zod validates all incoming request bodies and query params. Never trust raw `req.body` or `req.query`.

### Services vs Routes
- Routes handle HTTP concerns only: parse/validate input, call service, return response + status code.
- Services contain all business logic and DB calls. Never call `supabase` directly from a route.

### Answer Types
Two answer types are supported:

| Type | How checking works |
|---|---|
| `exact` | Case-insensitive string match after `.trim()` |
| `range` | `|parseFloat(given) - parseFloat(correct)| <= tolerance` |

MCQ is **not used** — do not add MCQ questions. Proof-type questions ("show that", "sketch") are not yet supported — add them as view-only later.

### Questions
- `prompt_latex` and `solution_latex` are LaTeX strings. The frontend renders them with KaTeX.
- The solution is **never** sent to the client until after an attempt is submitted. `questionService.ts` strips it via `stripSolution()`.

### Sessions
- No auth in MVP. The client generates a UUID v4 on first load and stores it in `localStorage` as `session_id`.
- `session_id` is passed as a query param or in the request body. The backend trusts it as-is.
- When auth is added later, `session_id` becomes `user_id` from Supabase Auth.

---

## Adding New Questions

Insert directly via Supabase SQL Editor or add to `seed.sql`:

```sql
INSERT INTO questions (topic_id, difficulty, prompt_latex, answer_type, correct_answer, tolerance, mcq_options, solution_latex, marks)
VALUES (
  '<topic-uuid>',
  2,                          -- 1=easy, 2=medium, 3=hard
  'Find \(\int \sin x \, dx\)',
  'exact',
  '-\cos x + C',
  NULL,
  NULL,
  '\[\int \sin x \, dx = -\cos x + C\]',
  1
);
```

---

## What's Built vs What's Next

**Built (this session):**
- Full backend: schema, services, routes, answer checking, session-based progress

**Not yet built:**
- Frontend (React + Vite + KaTeX)
- User auth (Supabase Auth)
- Progress dashboard / analytics
- Timed mock paper mode
- Admin UI for authoring questions
