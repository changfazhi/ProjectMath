# Math Trainer — Project Guide

LeetCode-style math practice for Singapore H2 A-Level students. Express + TypeScript backend, React 19 + Vite + Tailwind + KaTeX frontend.

## Running

```bash
cd backend && npm run dev      # port 3001, tsx watch
cd frontend && npm run dev     # port 5173, Vite — proxies /api/* → 3001
```

`backend/.env` (copy from `.env.example`): set `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY`. For the AI hint chatbot + photo grading also set `GEMINI_API_KEY` (optionally `GEMINI_MODEL`, `CHAT_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION`, `GRADE_RATE_LIMIT_PER_MIN`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB`, `PAIR_TTL_MIN`, `PAIR_RATE_LIMIT_PER_MIN`). Never commit; never expose to the browser.

For the **"upload via phone"** QR flow, open the desktop app via the machine's **LAN IP** (e.g. `http://192.168.x.x:5173`), not `localhost`, so the QR is reachable from the phone (Vite runs with `server.host: true`).

## Database Setup

Run in order in the Supabase SQL Editor:

1. `001_initial_schema.sql` — core tables + indexes
2. `002_question_names.sql` — adds `name` column
3. `003_topic_concepts.sql` — `topic_concepts` table
4. `004_starred_questions.sql` — `starred_questions` table
5. `005_new_topics.sql` — 24 topics, 120 concepts, grants
6. `006_binomial_normal_topics.sql` — adds Binomial Distribution (bbbb0007) & Normal Distribution (bbbb0008) topics
7. `007_asrjc_prelim_2025.sql` — 21 ASRJC 2025 questions
8. `008_multi_part_schema.sql` — adds `parts JSONB` to questions, `part_label TEXT` to attempts
9. `009_asrjc_parts_data.sql` — per-part data for all ASRJC multi-part questions
10. `010_dhs_prelim_2025.sql` — 22 DHS H2 Math Prelim 2025 questions (Papers 1 & 2)
11. `011_chat_messages.sql` — `chat_messages` table (AI hint chatbot history)
12. `012_fix_dhs_preamble.sql` — DHS preamble fix
13. `013_solution_gradings.sql` — `gradings` table + `solution-uploads` Storage bucket (photo AI grading)
14. `014_hci_prelim_2025.sql` — 23 HCI H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–13, Paper 2 Q1–10)
15. `015_acjc_prelim_2025.sql` — 24 ACJC H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–12, Paper 2 Q1–12)
16. `016_cjc_prelim_2025.sql` — 22 CJC H2 Math (9758) Prelim 2025 questions (Paper 1 Q1–11, Paper 2 Q1–11)
17. `017_grading_transcription.sql` — adds `transcription_latex TEXT` to `gradings` (editable AI transcription of handwriting)

**After any `CREATE TABLE`:** `GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;`

## Topic UUIDs (all H2)

`aaaa000N-0000-0000-0000-000000000000` = Pure Math, `bbbb000N-...` = Stats.

| UUID | Topic | | UUID | Topic |
|---|---|---|---|---|
| aaaa0001 | Graphing Techniques | | aaaa0010 | Vector (Plane) |
| aaaa0002 | Functions | | aaaa0011 | Complex Number |
| aaaa0003 | Transformation | | aaaa0012 | Differentiation Technique |
| aaaa0004 | Conics | | aaaa0013 | App. of Differentiation |
| aaaa0005 | Inequalities | | aaaa0014 | Maclaurin Series |
| aaaa0006 | Systems of Linear Equations | | aaaa0015 | Integration Technique |
| aaaa0007 | Sequences & Series | | aaaa0016 | Definite Integral |
| aaaa0008 | Vector (Basic) | | aaaa0017 | Parametric Equations |
| aaaa0009 | Vector (Lines) | | aaaa0018 | Differential Equations |

Stats: bbbb0001–bbbb0008 (Permutation & Combination → Normal Distribution). ASRJC questions: `cafe00NN-...` (Paper 1), `cafe10NN-...` (Paper 2). DHS questions: `d025000N-...` (Paper 1), `d025100N-...` (Paper 2). HCI questions: `c025000N-...` (Paper 1), `c025100N-...` (Paper 2). ACJC questions: `a025000N-...` (Paper 1), `a025100N-...` (Paper 2). CJC questions: `b025000N-...` (Paper 1), `b025100N-...` (Paper 2).

## API Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/api/topics?level=H2` | List topics |
| GET | `/api/topics/:id` | Single topic |
| GET | `/api/topics/progress?session_id=UUID` | Per-topic completion stats |
| GET | `/api/topics/:id/questions?session_id=UUID` | Questions with attempt status |
| GET | `/api/topics/:id/next?session_id=UUID&difficulty=N` | Next unanswered question |
| GET | `/api/topics/:id/concepts` | Prerequisite concepts |
| GET | `/api/questions/:id` | Single question (no answer/solution) |
| POST | `/api/attempts` | Submit answer → `{ is_correct, correct_answer, solution_latex }` |
| GET | `/api/attempts?session_id=UUID` | Session history (optionally filtered by `question_id`) |
| POST | `/api/stars` | Toggle star |
| GET | `/api/stars?session_id=UUID&topic_id=UUID` | Starred questions for a topic |
| GET | `/api/stars/all?session_id=UUID` | All starred questions with latest attempt |
| GET | `/api/streaks?session_id=UUID` | Streak stats + daily activity heatmap data |
| GET | `/api/chat?session_id=UUID&question_id=UUID` | AI hint chat history for a question |
| POST | `/api/chat` | Send a message → Socratic hint `{ reply, history }` (Gemini proxy, IP rate-limited) |
| GET | `/api/grade?session_id=UUID&question_id=UUID` | Past photo gradings for a question |
| POST | `/api/grade` | **multipart/form-data** (`images[]`, `session_id`, `question_id`, `time_taken_s?`) → AI grade of handwritten solution (Gemini vision, IP rate-limited). Response includes `transcription_latex` (what the AI read) |
| POST | `/api/grade/text` | JSON `{ question_id, transcription_latex, time_taken_s? }` → re-grade the student's corrected LaTeX transcription (no photos, same rate limit as `/api/grade`) |
| POST | `/api/pair` | Create a phone-upload pairing → `{ token, mobile_path, expires_at }` |
| GET | `/api/pair/:token` | Mobile page context (secret-free); fires `pair:phone-connected` |
| POST | `/api/pair/:token/photo` | **multipart** single `image` → streams to desktop via `pair:image` |
| POST | `/api/pair/:token/done` | Grade collected photos → `pair:grading`/`pair:graded`/`pair:error` |

`POST /api/attempts` body: `{ session_id, question_id, answer_given, part_label?, time_taken_s? }`. Include `part_label` for multi-part questions. `solution_latex` in the response is `null` until all graded parts of the question are submitted.

## Multi-Part Questions

Questions can have a `parts JSONB` column — an array of per-part objects:

```json
{ "label": "a", "prompt_latex": "...", "correct_answer": "\\frac{x}{5}", "answer_type": "exact", "tolerance": null }
```

- `answer_type: null` → "show that" part — no answer box rendered, no submission
- `answer_type: "exact"` or `"range"` → graded; submit with `part_label`
- `question.prompt_latex` = shared preamble only; `parts[i].prompt_latex` = per-part sub-question
- `correct_answer` is stripped from parts before sending to the client (same as question-level)
- Topic status: multi-part questions show ✓ only when **all** graded parts have a correct attempt

**LaTeX in parts JSON:** Every backslash must be doubled (`\frac` → `\\frac`; LaTeX `\\` line break → `\\\\`). Use dollar-quoting (`$$...$$`) in SQL to avoid quote escaping. See `skills.md` for the full workflow.

## AI Hint Chatbot

A Socratic tutor that gives progressive hints (never the final answer) for the question being attempted. **The Gemini API key lives only on the backend** — the browser talks to `/api/chat`, never to Google.

- **Proxy:** `routes/chat.ts` → `services/chatService.ts` → Gemini via `db/gemini.ts` (`@google/genai`, `gemini-2.5-flash`). Same layered pattern as the rest of the backend.
- **Guardrails:** `buildSystemInstruction()` in `chatService.ts` injects the question + `parts` + reference `solution_latex` (server-side only, marked confidential) and instructs the model to give one small hint at a time, never the answer, and refuse off-topic/jailbreak attempts. Tune the prompt there.
- **Rate limiting:** `express-rate-limit` (IP-keyed, `CHAT_RATE_LIMIT_PER_MIN`, default 15/min) on `POST /api/chat` is the primary bill defence; `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40) is a second per-question cap → `ChatLimitError` → HTTP 429.
- **History:** persisted in `chat_messages` (keyed by `session_id` + `question_id`); `GET /api/chat` rehydrates. `correct_answer`/`solution_latex` are **never** returned to the client.
- **Frontend:** `useChatSession` hook (optimistic send, rolls back on error) + `ChatPanel.tsx`. On `PracticePage` one shared chat instance renders as a sticky right rail on `lg` screens and inside the existing **Hints tab** on mobile (`hidden lg:flex` / `lg:hidden`). Model replies render through `renderLatex()`.

## Photo-Based AI Grading

Students photograph **handwritten** working; Gemini grades it against the stored model solution (it is an *examiner*, not a solver). Primary answer flow on `PracticePage`; typed/MathLive input remains a "Type instead" fallback.

- **Pipeline:** `routes/grade.ts` → `services/gradingService.ts` → Gemini (`db/gemini.ts`). Images arrive as `multipart/form-data` (`multer`), sent to Gemini as base64 `inlineData`, and uploaded to the private `solution-uploads` bucket **only after** grading succeeds.
- **Structured output** (`responseSchema`, deterministic): `{ gradable, rejection_reason, ignored_images[{index,reason}], parts[{label, verdict, marks_awarded, marks_total, errors[{step,description}], hints[], summary}], overall_feedback, transcription_latex }`.
- **Editable transcription + re-grade:** Gemini also transcribes the handwriting verbatim into `transcription_latex`. The frontend `TranscriptionEditor` shows it as editable LaTeX (textarea + live `renderLatex()` preview) next to the feedback; if the scan was wrong the student edits it and re-grades via `POST /api/grade/text` → `gradeTranscription()` (text-only, no photos, `image_paths: []`). Both entry points share `runGrading()` in `gradingService.ts`; `buildGradingInstruction(question, mode)` swaps photo/text framing. The phone-upload flow grades on the phone but the editor/re-grade happens on the desktop (the desktop receives the full `GradeResponse` with `transcription_latex` over Socket.IO).
- **Grading rules** (`buildGradingInstruction()`): credit valid alternative methods; sketches need labelled intercepts + asymptote equations + stationary points + correct shape; "hence" parts must use earlier results; auto-detect which part each photo covers; pin every error to the step. Confidential `solution_latex` injected for reference only.
- **Junk filtering (STEP 0):** photos are numbered (`Photo N:`); blanks/objects/unrelated photos go in `ignored_images`. If nothing relevant remains → `gradable=false` → `GradingError` (HTTP 400 / `pair:error`) with no stored image, `gradings` row, or attempt. Frontend shows a soft `GRADE_REJECTED` (stay on the question to retake), not the global error screen.
- **Persistence:** one `gradings` row per submission (images + feedback; future "mistake log" via `WHERE is_correct=false`) + one `attempts` row per graded part (correct = full marks) so streaks/progress/roadmap ✓ keep working.
- **Limits/UI:** `GRADE_RATE_LIMIT_PER_MIN` (5), `GRADE_MAX_IMAGES` (5), `GRADE_MAX_IMAGE_MB` (8). `PhotoAnswer.tsx` → `session.submitPhotos()` → `GradingResult.tsx`; `api.grade.*` uses `requestFormData`. Per-part `marks` is an optional `parts` JSONB field (AI infers when absent).

## Upload via Phone (QR pairing + Socket.IO)

Desktops have no camera: "📱 Upload via phone" shows a QR; the phone opens `/m/:token`, snaps photos that stream live to the desktop over Socket.IO, and **Done** grades them via the same `gradeSolution()`.

- **Backend:** `realtime.ts` (Socket.IO on the `http.Server`; desktops `pair:subscribe` to a token room; `emitToPair()`). `services/pairService.ts` = in-memory `Map` of capability tokens (`crypto.randomBytes(32).base64url`, `PAIR_TTL_MIN` default 10). `routes/pair.ts`: `POST /api/pair`, `GET /api/pair/:token` (+`pair:phone-connected`), `POST /api/pair/:token/photo` (→`pair:image`), `POST /api/pair/:token/done` (→`pair:grading`→`gradeSolution`→`pair:graded`|`pair:error`). Auth = possession of the unguessable token.
- **Frontend:** `lib/socket.ts` (same-origin `io()`), `usePairSocket` (forwards events into `usePracticeSession` via `beginExternalGrading`/`receiveGrading`/`rejectExternalGrading`), `QrPairModal.tsx` (QR = `origin + mobile_path`), `MobileUploadPage.tsx` at top-level route `/m/:token` (outside `RootLayout`). `api.pair.*`.
- **Dev:** Vite needs `server.host: true` + `/socket.io` ws proxy; open the desktop via the machine's **LAN IP** (not `localhost`) so the QR is phone-reachable.

## Frontend Architecture

- **Routes:** `/` (roadmap + TopicDrawer), `/practice/:topicId`, `/history`, `/starred` (bookmarked questions), `/stats` (streak heatmap + analytics)
- **Session:** UUID v4 in `localStorage` as `session_id` (`lib/session.ts`). No auth.
- **Roadmap:** Pan/zoom tree layout. Node click → `TopicDrawer` (right panel, concepts + question list). Row click → `/practice/:topicId?question_id=<uuid>`.
- **PracticePage:** `?question_id=` → `loadSpecific(id)`; otherwise `loadNext()`. Both idempotent — safe under StrictMode double-invoke. Never use a `firstLoad` ref. Has difficulty filter (Any/Easy/Medium/Hard), 3-tab layout (Question | Attempts | Hints), and a `StatsBar` showing session correct/total and streak count.
- **Practice state machine:** `loading → answering → submitted → revealed → complete | error`
- **Multi-part flow:** `question.parts != null` → `<MultiPartQuestion>` renders per-part boxes with inline ✓/✗; on all graded parts done → phase transitions to `revealed` and `<SolutionReveal>` appears.
- **Stars:** Optimistic UI — flip locally, sync to server, revert on failure. `/starred` page lists all starred questions with latest attempt via `GET /api/stars/all`.
- **Streaks:** `StreakNotification` modal fires once per day on first correct answer. `/stats` page shows current/best streak cards and a GitHub-style weekly heatmap (daily activity from `GET /api/streaks`).

## Math Input (MathLive)

- **`MathField.tsx`** — wraps `<math-field>`. Exposes `insert(latex)`, `getValue()`, `focus()`. Suppresses built-in keyboard and hamburger menu.
- **`MathKeyboard.tsx`** — 10-group symbol panel. Use `onMouseDown` (not `onClick`) to avoid stealing focus. Template strings use `#?` placeholders; pass `selectionMode: 'placeholder'` to `mf.insert()`.
- **Correct answer display:** raw LaTeX → `<Latex>` directly, not `renderLatex()`.
- **MathLive compact notation:** `\frac34` (not `\frac{3}{4}`) for single-char numerator/denominator. `normalizeLaTeX()` in `attemptService.ts` expands this automatically.

## Key Conventions

- **Backend:** Strict TS, no `any`. Zod validates all `req.body`/`req.query`. Routes thin — logic in services. Never call `supabase` from a route. `NodeNext` module resolution — `.js` extension on all imports.
- **Frontend:** All fetch via `lib/api.ts`. Tailwind via `cn()` from `lib/utils.ts`. Types in `src/types/api.ts` mirror backend.
- **LaTeX rendering:** Mixed text+math → `renderLatex()` (`\(...\)` / `\[...\]` delimiters). Pure LaTeX → `<Latex>`. Block display → `<LatexBlock>`.
- **Answer types:** `exact` (normaliseLaTeX string match) or `range` (`|given − correct| ≤ tolerance`). `answer_type: null` = show-that (ungraded).
- **Solution hiding:** `correct_answer` and `solution_latex` stripped before sending to client; returned only after attempt submission.

## Adding Questions

See **`skills.md`** for the full step-by-step workflow: reading PDFs from Google Drive, classifying parts, writing INSERT/UPDATE migrations, JSON escaping rules, and validating before running in Supabase.

Quick reference for `answer_type`:
- Text answer / proof / sketch → `null`
- Algebraic / LaTeX → `"exact"`
- Numerical with tolerance → `"range"`
- Indefinite integrals → always `null` (too many equivalent forms)

## Status

**Built:** Full backend + frontend, roadmap with pan/zoom, practice session with multi-part support, MathLive keyboard, star system, history, 24-topic syllabus, 21 ASRJC + 22 DHS + 23 HCI + 24 ACJC + 22 CJC Prelim 2025 questions (Papers 1 & 2 each), streak system with daily heatmap (/stats), starred questions page (/starred), AI hint chatbot (Gemini proxy, Socratic hints beside the question), photo-based AI grading of handwritten solutions (Gemini vision, primary answer flow, ignores irrelevant/blank photos), "upload via phone" QR pairing with live Socket.IO photo transfer.

**Not built:** Auth, timed mock mode, admin question editor, "mistake log" page (data already captured in `gradings`).

## Common Pitfalls

| Problem | Fix |
|---|---|
| `permission denied for table X` | Run `GRANT ALL` after `CREATE TABLE` |
| Drawer click loads wrong question | Use `loadSpecific()` not `loadNext()` — StrictMode fires effects twice |
| Backend crashes on start | `.env` missing — copy `.env.example` |
| `tsx`/`vite: command not found` | `npm run setup` from project root |
| Math keyboard steals focus | `onMouseDown` + `e.preventDefault()` on keyboard buttons |
| Cursor after fraction, not inside | Pass `selectionMode: 'placeholder'` to `mf.insert()` and use `#?` |
| `syntax error at or near "\"` in Supabase | Unescaped `'` in SQL — use `$$...$$` dollar-quoting instead |
| Part answer not grading | `answer_type` must be non-null and `correct_answer` non-null on the part |
| Solution not revealing after last part | Run migration 008 — `part_label` column missing from attempts |
| `null value in column "answer_type" violates not-null constraint` | The **question-level** `answer_type` column is `NOT NULL`. For an ungraded single-task question, do **not** insert it as a no-parts row with `answer_type = null`. Instead wrap it as a multi-part question with **one `null` part** (the ask) and give the question row a non-null fallback `'exact', ''` (parts override it). Only the per-part `answer_type` may be `null`. |
| Backend crashes: `Missing GEMINI_API_KEY` | Add `GEMINI_API_KEY` to `backend/.env` (see `.env.example`) |
| Chat returns `permission denied for table chat_messages` | Run migration 011 incl. its `GRANT ALL` |
| Grading returns `permission denied for table gradings` | Run migration 013 incl. its `GRANT ALL` |
| Grading: `Bucket not found` / upload fails | Run migration 013 (creates the `solution-uploads` bucket) |
| QR code opens but phone can't reach it | Open the desktop via the machine's LAN IP, not `localhost` (Vite `server.host: true`) |
| Phone photos don't appear on desktop | `/socket.io` ws proxy missing from `vite.config.ts`, or backend not on `http.Server`+Socket.IO |
