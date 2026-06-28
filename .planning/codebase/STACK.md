# Technology Stack

**Analysis Date:** 2026-06-28

## Languages

**Primary:**
- TypeScript 5.6 (backend) / ~6.0 (frontend) — all source code in both workspaces

**Secondary:**
- None — no Python, Go, or other languages detected

## Runtime

**Environment:**
- Node.js (backend) — `tsx watch` for dev, compiled to `dist/` for production

**Package Manager:**
- npm — used in root workspace + both sub-workspaces
- Lockfile: `package-lock.json` present at repo root

## Frameworks

**Backend:**
- Express 4.21 — HTTP server and REST API (`backend/src/index.ts`)
- Socket.IO 4.8.3 (server) — real-time phone-upload pairing (`backend/src/realtime.ts`)

**Frontend:**
- React 19.2 — UI library
- React Router 7.17 — client-side routing (`frontend/src/App.tsx`)
- Vite 8.0 — dev server + build tool (`frontend/vite.config.ts`)
- Tailwind CSS 3.4 — utility-first styling

**Testing:**
- Not detected — no jest/vitest config or test files found

**Build/Dev:**
- tsx 4.19 — TypeScript runner for backend dev (`tsx watch src/index.ts`)
- concurrently 9.0 — runs backend + frontend in parallel (`package.json` root `dev` script via `dev.js`)
- PostCSS 8.5 + autoprefixer — Tailwind processing

## Key Dependencies

**Critical:**
- `@supabase/supabase-js` 2.45 — primary database client (backend only, `backend/src/db/supabase.ts`)
- `firebase-admin` 14.1 — server-side Firebase Auth token verification (`backend/src/db/firebase.ts`)
- `firebase` 12.15 — client-side Firebase Auth SDK (`frontend/src/lib/firebase.ts`)
- `@google/genai` 2.9 — Gemini AI client for hints + photo grading (`backend/src/db/gemini.ts`)
- `socket.io-client` 4.8.3 — desktop-side Socket.IO for live photo pairing (`frontend/src/lib/socket.ts`)

**Infrastructure:**
- `express-rate-limit` 8.5 — IP-keyed rate limiting on `/api/chat` and `/api/grade`
- `multer` 2.2 — multipart file uploads for photo grading (`backend/src/routes/grade.ts`)
- `zod` 3.23 — runtime request validation across all routes
- `mathjs` 15.2 — math expression evaluation (likely for answer tolerance checks)
- `dotenv` 16.4 — environment variable loading (`backend/src/index.ts`)

**Frontend UI:**
- `katex` 0.17 — LaTeX rendering in frontend (`frontend/src/lib/renderLatex.tsx`)
- `mathlive` 0.110 — interactive math input widget (`frontend/src/components/MathField.tsx`)
- `qrcode.react` 4.2 — QR code display for phone-upload pairing (`frontend/src/components/QrPairModal.tsx`)
- `uuid` 14.0 — session UUID generation (`frontend/src/lib/session.ts`)

## Configuration

**Environment (backend):**
- `backend/.env` (never committed) — required vars:
  - `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`
  - `GEMINI_API_KEY`, optionally `GEMINI_MODEL` (default: `gemini-2.5-flash`)
  - `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY`
  - `CHAT_RATE_LIMIT_PER_MIN` (default 15), `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40)
  - `GRADE_RATE_LIMIT_PER_MIN` (default 5), `GRADE_MAX_IMAGES` (default 5), `GRADE_MAX_IMAGE_MB` (default 8)
  - `PAIR_TTL_MIN` (default 10), `PAIR_RATE_LIMIT_PER_MIN`
  - `CORS_ORIGIN` (production only), `PORT` (default 3001)

**Environment (frontend):**
- `frontend/.env` — required vars:
  - `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID`

**TypeScript (backend):**
- `backend/tsconfig.json` — `target: ES2022`, `module: NodeNext`, `moduleResolution: NodeNext`, strict mode
- `.js` extension required on all relative imports (NodeNext resolution)

**TypeScript (frontend):**
- Composite project: `frontend/tsconfig.json` references `tsconfig.app.json` and `tsconfig.node.json`

**Build (backend):**
- `tsc` compiles to `backend/dist/`
- Dev: `tsx watch src/index.ts` (no compile step)

**Linting:**
- ESLint 10 with `typescript-eslint` + `eslint-plugin-react-hooks` + `eslint-plugin-react-refresh` (frontend)

## Platform Requirements

**Development:**
- Node.js (version not pinned — no `.nvmrc` detected)
- Backend on port 3001, frontend Vite dev server on port 5173
- `VITE_*` env vars for frontend Firebase config
- Open desktop via LAN IP (not `localhost`) for phone QR upload feature — Vite runs with `server.host: true`

**Production:**
- Backend: `npm run build` (tsc) then `node dist/index.js`
- Frontend: `tsc -b && vite build` outputs to `frontend/dist/`
- Deployment target not specified — no Dockerfile, Procfile, or platform config detected

---

*Stack analysis: 2026-06-28*
