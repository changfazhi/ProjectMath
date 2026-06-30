# Technology Stack

**Analysis Date:** 2026-06-29

## Languages

**Primary:**
- TypeScript 6.0.2 — Frontend (React, `frontend/tsconfig.json` / `tsconfig.app.json`)
- TypeScript 5.6.0 — Backend (Node.js, `backend/tsconfig.json`)

**Secondary:**
- CSS (Tailwind utility classes + component `.css` files in `frontend/src/`)

## Runtime

**Environment:**
- Node.js (backend, no explicit version pin — uses `node:http`, `node:crypto` built-ins)
- Browser (frontend, ES2022 target via Vite)

**Package Manager:**
- npm (both `frontend/` and `backend/`)
- Lockfiles: `package-lock.json` present in both directories

## Frameworks

**Frontend:**
- React 19.2.6 — UI framework (`frontend/`)
- React Router DOM 7.17.0 — Client-side routing (`/`, `/practice/:topicId`, `/history`, `/starred`, `/stats`, `/m/:token`)
- Vite 8.0.12 — Dev server + build tool (`frontend/vite.config.ts`)
  - `@vitejs/plugin-react` 6.0.1 — JSX transform
  - Dev proxy: `/api` → `http://localhost:3001`, `/socket.io` → `ws://localhost:3001`
  - `server.host: true` — binds to LAN for phone QR flow

**Backend:**
- Express 4.21.0 — HTTP server, thin route layer (`backend/src/index.ts`)
- Socket.IO 4.8.3 — Real-time WebSocket for phone photo streaming (`backend/src/realtime.ts`)
  - Attached to `http.Server`, not `app.listen()`, so Socket.IO and Express share one port (3001)

**Testing:**
- None detected

**Build/Dev:**
- `tsx` 4.19.0 — TypeScript execution for backend dev (`tsx watch src/index.ts`)
- PostCSS 8.5.15 + Autoprefixer 10.5.0 — CSS processing
- Tailwind CSS 3.4.19 — Utility-first CSS; used via `cn()` from `frontend/src/lib/utils.ts`

## Key Dependencies

**Frontend — Critical:**
- `firebase` 12.15.0 — Firebase Auth client SDK; initialized in `frontend/src/lib/firebase.ts` via `getAuth()`
- `mathlive` 0.110.0 — Math input widget (`frontend/src/components/MathField.tsx`, `MathKeyboard.tsx`)
- `katex` 0.17.0 — LaTeX rendering (`frontend/src/lib/renderLatex.tsx`, `<Latex>`, `<LatexBlock>`)
- `socket.io-client` 4.8.3 — Phone-to-desktop photo streaming (`frontend/src/lib/socket.ts`)
- `qrcode.react` 4.2.0 — QR code for phone pairing modal (`frontend/src/components/QrPairModal.tsx`)
- `uuid` 14.0.0 — Session ID generation stored in `localStorage` (`frontend/src/lib/session.ts` implied by CLAUDE.md)

**Backend — Critical:**
- `@supabase/supabase-js` 2.45.0 — Primary database client; singleton in `backend/src/db/supabase.ts`
- `firebase-admin` 14.1.0 — Firebase ID token verification in auth middleware (`backend/src/db/firebase.ts`, `backend/src/middleware/auth.ts`)
- `@google/genai` 2.9.0 — Gemini AI SDK for hint chatbot + photo grading (`backend/src/db/gemini.ts`)
- `multer` 2.2.0 — Multipart form parsing for photo uploads (`backend/src/routes/grade.ts`, `routes/pair.ts`)
- `express-rate-limit` 8.5.2 — IP-keyed rate limiting on `/api/chat` and `/api/grade`
- `zod` 3.23.8 — Request body/query validation in all route handlers
- `mathjs` 15.2.0 — LaTeX normalization for answer comparison in `backend/src/services/attemptService.ts`
- `dotenv` 16.4.5 — Environment variable loading (`import 'dotenv/config'` at top of `backend/src/index.ts`)
- `cors` 2.8.5 — CORS middleware; origin locked to `localhost:5173` in dev, `CORS_ORIGIN` env var in prod

## Configuration

**Environment — Backend (`backend/.env`, never committed):**
- `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY` — Required at startup; crash if missing
- `GEMINI_API_KEY` — Lazy-loaded in `db/gemini.ts`; only `/api/chat` and `/api/grade` fail if absent
- `GEMINI_MODEL` — Optional, defaults to `gemini-2.5-flash`
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` — Required for `requireAuth` middleware
- `CHAT_RATE_LIMIT_PER_MIN` (default 15), `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40)
- `GRADE_RATE_LIMIT_PER_MIN` (default 5), `GRADE_MAX_IMAGES` (default 5), `GRADE_MAX_IMAGE_MB` (default 8)
- `PAIR_TTL_MIN` (default 10), `PAIR_RATE_LIMIT_PER_MIN`
- `PORT` (default 3001), `NODE_ENV`, `CORS_ORIGIN`

**Environment — Frontend (Vite `VITE_` prefix, `.env` at `frontend/`):**
- `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID`

**TypeScript config:**
- Backend: `module: NodeNext`, `moduleResolution: NodeNext`, `strict: true`; all local imports require `.js` extension
- Frontend: composite project referencing `tsconfig.app.json` and `tsconfig.node.json`

## Platform Requirements

**Development:**
- Node.js (version unspecified; no `.nvmrc` detected)
- Two processes: `backend/` on port 3001, `frontend/` on port 5173
- Open frontend via LAN IP (not `localhost`) to make QR codes reachable from phone

**Production:**
- No deployment config detected in repo
- CORS origin configured via `CORS_ORIGIN` env var
- Backend serves `http.Server` with Socket.IO on same port

---

*Stack analysis: 2026-06-29*
