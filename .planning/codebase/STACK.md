# Technology Stack

**Analysis Date:** 2026-06-26

## Languages

**Primary:**
- TypeScript 5.6 (backend) / 6.0 (frontend) — all source code; strict mode on backend

**Secondary:**
- SQL — Supabase migrations in `backend/supabase/migrations/`

## Runtime

**Environment:**
- Node.js (backend, port 3001)
- Browser (frontend, port 5173 via Vite)

**Package Manager:**
- npm (both workspaces, independent)
- Lockfiles: `backend/package-lock.json`, `frontend/package-lock.json`

## Frameworks

**Backend Core:**
- Express ^4.21.0 — HTTP server + routing
- tsx ^4.19.0 — TypeScript runner for development (`tsx watch src/index.ts`)
- Socket.IO ^4.8.3 — Real-time pairing events (desktop ↔ phone upload flow)

**Frontend Core:**
- React ^19.2.6 — UI framework
- react-dom ^19.2.6 — DOM renderer
- react-router-dom ^7.17.0 — Client-side routing (`/`, `/practice/:topicId`, `/history`, `/starred`, `/stats`, `/m/:token`)
- Vite ^8.0.12 — Dev server + build tool

**Build/Dev:**
- @vitejs/plugin-react ^6.0.1 — React fast refresh in Vite
- TypeScript compiler (`tsc`) — production build for both sides

## Key Dependencies

**Backend Critical:**
- @supabase/supabase-js ^2.45.0 — Database + Storage client; initialized in `backend/src/db/supabase.ts`
- @google/genai ^2.9.0 — Gemini API client (AI hints + photo grading); initialized in `backend/src/db/gemini.ts`
- zod ^3.23.8 — Request body/query validation (all routes)
- express-rate-limit ^8.5.2 — IP-based rate limiting on `/api/chat` and `/api/grade`
- multer ^2.2.0 — Multipart file uploads for photo grading (`/api/grade`, `/api/pair/:token/photo`)
- mathjs ^15.2.0 — Numeric answer tolerance evaluation (`range` answer type)
- cors ^2.8.5 — CORS middleware on Express
- dotenv ^16.4.5 — Loads `backend/.env`

**Frontend Critical:**
- katex ^0.17.0 — LaTeX rendering in the browser
- mathlive ^0.110.0 — Web component math input (`<math-field>`); wrapped in `frontend/src/components/MathField.tsx`
- socket.io-client ^4.8.3 — Real-time connection to backend; singleton in `frontend/src/lib/socket.ts`
- qrcode.react ^4.2.0 — QR code display in `frontend/src/components/QrPairModal.tsx`
- uuid ^14.0.0 — Generates `session_id` stored in localStorage (`frontend/src/lib/session.ts`)

**Frontend Dev:**
- tailwindcss ^3.4.19 — Utility-first CSS
- autoprefixer ^10.5.0 — PostCSS plugin for Tailwind
- postcss ^8.5.15 — CSS build pipeline
- eslint ^10.3.0 + typescript-eslint ^8.59.2 + eslint-plugin-react-hooks ^7.1.1 — Linting

## Configuration

**Environment (backend):**
- `backend/.env` (copy from `backend/.env.example`); never committed
- Required: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`
- Optional: `GEMINI_API_KEY`, `GEMINI_MODEL` (default `gemini-2.5-flash`), `CHAT_RATE_LIMIT_PER_MIN` (default 15), `CHAT_MAX_MESSAGES_PER_QUESTION` (default 40), `GRADE_RATE_LIMIT_PER_MIN` (default 5), `GRADE_MAX_IMAGES` (default 5), `GRADE_MAX_IMAGE_MB` (default 8), `PAIR_TTL_MIN` (default 10), `PAIR_RATE_LIMIT_PER_MIN`

**Build:**
- `backend/tsconfig.json` — `target: ES2022`, `module: NodeNext`, `moduleResolution: NodeNext`, strict
- `frontend/tsconfig.json` — composite project references (`tsconfig.app.json`, `tsconfig.node.json`)
- `frontend/vite.config.ts` — Vite config with `/api` and `/socket.io` proxy rules
- `frontend/postcss.config.js` — Tailwind + autoprefixer

## Platform Requirements

**Development:**
- Node.js (no `.nvmrc` — version unspecified)
- Both servers started independently: `cd backend && npm run dev`, `cd frontend && npm run dev`
- Phone upload flow requires opening frontend via LAN IP (Vite `server.host: true`)

**Production:**
- Backend: `npm run build` (tsc → `dist/`) then `npm start` (`node dist/index.js`)
- Frontend: `npm run build` (tsc + vite build)
- Deployment target: not specified in codebase

---

*Stack analysis: 2026-06-26*
