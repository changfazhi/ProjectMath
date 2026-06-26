# External Integrations

**Analysis Date:** 2026-06-26

## APIs & External Services

**AI Chatbot (Socratic Hints):**
- Google Gemini API (`gemini-2.5-flash` model)
  - SDK: `@google/genai` 2.9.0
  - Auth: `GEMINI_API_KEY` (backend-only, via `backend/src/db/gemini.ts`)
  - Endpoint: `POST /api/chat` → proxy to Gemini
  - Implementation: `backend/src/services/chatService.ts` → `backend/src/db/gemini.ts`
  - Rate limiting: `CHAT_RATE_LIMIT_PER_MIN` (default 15/min, IP-keyed) + `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40 per question)
  - Behavior: Socratic tutor that gives progressive hints, never the final answer; reference `solution_latex` injected server-side only

**Photo-Based AI Grading (Vision):**
- Google Gemini API (same `gemini-2.5-flash` model, structured output)
  - SDK: `@google/genai` 2.9.0
  - Auth: `GEMINI_API_KEY` (reuses backend-only key)
  - Endpoint: `POST /api/grade` → multipart upload (images) → Gemini vision grading
  - Implementation: `backend/src/services/gradingService.ts` → `backend/src/db/gemini.ts`
  - Rate limiting: `GRADE_RATE_LIMIT_PER_MIN` (default 5/min, IP-keyed)
  - File limits: `GRADE_MAX_IMAGES` (default 5 images), `GRADE_MAX_IMAGE_MB` (default 8 MB per image)
  - Structured output: Deterministic JSON schema with `gradable`, `parts[{label, verdict, marks_awarded, marks_total, errors, hints, summary}]`, `overall_feedback`
  - Junk filtering: Auto-ignores blank/unrelated/object photos in `ignored_images`

## Data Storage

**Primary Database:**
- Supabase (PostgreSQL)
  - Connection: `SUPABASE_URL` + `SUPABASE_SERVICE_ROLE_KEY`
  - Client: `@supabase/supabase-js` 2.45.0 (via `backend/src/db/supabase.ts`)
  - Tables: `topics`, `questions`, `attempts`, `stars`, `chat_messages`, `gradings`, `topic_concepts`, `starred_questions` (view)
  - Schema: Multi-part questions supported via `parts JSONB` column (array of `{label, prompt_latex, answer_type, tolerance, marks}`)
  - Migrations: 16 SQL migration files in `backend/migrations/` (001–016, covering schema, 24 topics, 5 schools of prelim questions)

**File Storage:**
- Supabase Storage (`solution-uploads` bucket)
  - Location: `backend/src/services/gradingService.ts`
  - Purpose: Stores graded handwritten solution images after successful AI grading
  - Access: Private bucket, indexed by `session_id`, `question_id`, `grading_id`

**Session Storage (Frontend):**
- Browser `localStorage`
  - Key: `session_id` (UUID v4)
  - Persists across browser sessions (no auth, anonymous tracking)

## Authentication & Identity

**Auth Provider:**
- None (anonymous session-based)
  - Implementation: `frontend/src/lib/session.ts` generates/stores UUID v4 in `localStorage`
  - Backend: All endpoints accept `session_id` as a query parameter or request body field
  - No user accounts, no login required

## Monitoring & Observability

**Error Tracking:**
- Not detected (no Sentry, Rollbar, or similar)
- Backend throws typed errors (`ChatLimitError`, `GradingError`) mapped to HTTP status codes in routes

**Logs:**
- Console output only
  - Backend: `console.log()` on startup; errors via `console.error()` (no structured logging)
  - Frontend: Browser DevTools console (no error boundary reporting)

## CI/CD & Deployment

**Hosting:**
- Not specified in codebase (no GitHub Actions, Docker config, or deployment scripts)
- Assumed manual or external CI/CD

**Dev Setup:**
- Local monorepo: `npm run setup` → install both backend & frontend
- Dev server: `npm run dev` (root) → spawns backend (`npm run dev` in `backend/`) + frontend (`npm run dev` in `frontend/`) concurrently via `dev.js`
- Backend: TSX watch mode (`tsx watch src/index.ts`), port 3001
- Frontend: Vite dev server, port 5173, `server.host: true` for LAN access

## Environment Configuration

**Required Environment Variables (Backend .env):**
```
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
GEMINI_API_KEY=your-gemini-key-here
PORT=3001 (optional, default 3001)
GEMINI_MODEL=gemini-2.5-flash (optional)
CHAT_RATE_LIMIT_PER_MIN=15 (optional)
CHAT_MAX_MESSAGES_PER_QUESTION=40 (optional)
GRADE_RATE_LIMIT_PER_MIN=5 (optional)
GRADE_MAX_IMAGES=5 (optional)
GRADE_MAX_IMAGE_MB=8 (optional)
PAIR_TTL_MIN=10 (optional)
PAIR_RATE_LIMIT_PER_MIN=30 (optional)
```

**Secrets Location:**
- Backend `.env` file (never committed, listed in `.gitignore`)
- Supabase project settings (cloud-hosted)
- Google Cloud API credentials (external)
- Never exposed to frontend via `fetch()` or environment variables

## Webhooks & Callbacks

**Incoming Webhooks:**
- None detected

**Outgoing Webhooks:**
- None detected (Gemini API is request-response only)

**Real-Time Events (Socket.IO):**
- `pair:subscribe` — desktop joins a token room
- `pair:unsubscribe` — desktop leaves a token room
- `pair:phone-connected` — emitted when phone connects to a pairing token
- `pair:image` — emitted when phone uploads a photo
- `pair:grading` → `pair:graded` — emitted after photo grading completes
- `pair:error` — emitted if grading fails
- Implementation: `backend/src/realtime.ts` (Socket.IO server), `backend/src/routes/pair.ts` (pairing token lifecycle)

## API Endpoints

| Method | Path | Authentication | Purpose |
|--------|------|---|---|
| GET | `/api/topics` | Session ID (optional) | List all topics (optionally filtered by `?level=H2`) |
| GET | `/api/topics/:id` | None | Get single topic |
| GET | `/api/topics/:id/questions` | Session ID | Get questions for a topic with attempt status |
| GET | `/api/topics/:id/next` | Session ID + Difficulty filter | Get next unanswered question |
| GET | `/api/topics/:id/concepts` | None | Get prerequisite concepts for a topic |
| GET | `/api/topics/progress` | Session ID | Per-topic completion stats (correct/total) |
| GET | `/api/topics/accuracy` | Session ID | Per-topic accuracy metrics (questions_solved, attempts, etc.) |
| GET | `/api/questions/:id` | None | Get single question (no answer/solution stripped) |
| GET | `/api/questions/:id/solution` | None | Get solution LaTeX after submission |
| POST | `/api/attempts` | Session ID | Submit answer → graded against `correct_answer` |
| GET | `/api/attempts` | Session ID | Get session attempt history (optionally filtered by `?question_id=`) |
| POST | `/api/stars` | Session ID | Toggle star on a question |
| GET | `/api/stars` | Session ID + Topic ID | Get starred question IDs for a topic |
| GET | `/api/stars/all` | Session ID | Get all starred questions with latest attempt |
| GET | `/api/streaks` | Session ID | Get current/best streak + daily activity heatmap data |
| GET | `/api/chat` | Session ID + Question ID | Get chat message history for a question |
| POST | `/api/chat` | Session ID + Question ID | Send message → Socratic hint via Gemini |
| GET | `/api/grade` | Session ID + Question ID | Get past photo gradings for a question |
| POST | `/api/grade` | Session ID + Question ID | **multipart** (`images[]`) → AI grade via Gemini vision |
| POST | `/api/pair` | Session ID + Question ID | Create phone-upload pairing → `{token, mobile_path, expires_at}` |
| GET | `/api/pair/:token` | Token (URL param) | Mobile page context; fires `pair:phone-connected` |
| POST | `/api/pair/:token/photo` | Token (URL param) | **multipart** single `image` → streams to desktop via `pair:image` |
| POST | `/api/pair/:token/done` | Token (URL param) | Grade collected photos → `pair:grading`/`pair:graded`/`pair:error` |
| GET | `/api/review/corrections` | Session ID | Get questions the student got wrong (for review) |
| GET | `/api/review/weak-topics` | Session ID | Get topics with low accuracy (for review) |
| GET | `/api/review/speed-drills` | Session ID | Get recently attempted questions (for speed practice) |
| GET | `/api/review/spaced` | Session ID | Get previously correct questions due for spaced repetition |
| GET | `/api/review/random` | None | Get random questions (for mixed practice) |
| GET | `/health` | None | Health check endpoint |

## Request/Response Examples

**Submit Answer (Multi-Part):**
```json
POST /api/attempts
{
  "session_id": "uuid",
  "question_id": "uuid",
  "part_label": "a",           // For multi-part questions
  "answer_given": "\\frac{x}{5}",
  "time_taken_s": 120
}

Response:
{
  "attempt_id": "uuid",
  "is_correct": true,
  "correct_answer": "\\frac{x}{5}",
  "solution_latex": null    // Only non-null after all graded parts submitted
}
```

**Grade Photos:**
```
POST /api/grade
multipart/form-data:
  images: [File, File, ...]
  session_id: "uuid"
  question_id: "uuid"
  time_taken_s?: 180

Response (Structured via Gemini JSON schema):
{
  "gradable": true,
  "rejection_reason": "",
  "ignored_images": [],
  "parts": [
    {
      "label": "a",
      "verdict": "correct",
      "marks_awarded": 2,
      "marks_total": 2,
      "errors": [],
      "hints": ["Check intercepts on both axes"],
      "summary": "Correct sketch with labelled intercepts."
    }
  ],
  "overall_feedback": "Well done! All parts correct."
}
```

**Phone Upload Pairing:**
```
POST /api/pair
{
  "session_id": "uuid",
  "question_id": "uuid"
}

Response:
{
  "token": "32-byte base64url string (unguessable)",
  "mobile_path": "/m/{token}",
  "expires_at": "2026-06-26T12:15:00Z"
}

Phone opens: https://desktop.local:5173/m/{token}
→ Snaps photos → Sends to: POST /api/pair/{token}/photo
→ Desktop receives via: socket.on('pair:image', ...)
→ Submits grading: POST /api/pair/{token}/done
```

---

*Integration audit: 2026-06-26*
