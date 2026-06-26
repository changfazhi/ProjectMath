# Technology Stack

**Analysis Date:** 2026-06-26

## Languages

**Primary:**
- TypeScript 5.6.0 (backend) / ~6.0.2 (frontend) - Full codebase compiled to strict mode (`strict: true`)
- JavaScript (dev scripts and build tooling)

## Runtime

**Environment:**
- Node.js (backend - `@types/node ^22.0.0`)
- Browser (frontend - React 19 + DOM APIs)

**Package Manager:**
- npm (monorepo setup with `npm run setup` for bulk install)
- Lockfile: `package-lock.json` (present in backend, frontend, and root)

## Frameworks

**Backend:**
- Express 4.21.0 - RESTful API server (routing, CORS, request handling)
- Socket.IO 4.8.3 - Real-time WebSocket communication for "upload via phone" QR pairing

**Frontend:**
- React 19.2.6 - UI framework with hooks
- React Router 7.17.0 - Client-side routing (`/`, `/practice/:topicId`, `/history`, `/starred`, `/stats`)
- React DOM 19.2.6 - DOM rendering

**Math Rendering:**
- KaTeX 0.17.0 - Server-side LaTeX → HTML rendering for math display
- MathLive 0.110.0 - Interactive math input field with symbol keyboard and MathField API

**Development:**
- Vite 8.0.12 - Frontend bundler and dev server (port 5173, HMR, Vite proxy to `/api` and `/socket.io`)
- TypeScript 5.6.0 (backend) / ~6.0.2 (frontend) - Type checking and compilation
- TSX 4.19.0 - TypeScript runtime executor for `npm run dev` (backend)

## Key Dependencies

**Backend - Critical:**
- @supabase/supabase-js 2.45.0 - PostgreSQL database client and auth SDK
- @google/genai 2.9.0 - Google Gemini API client (AI chatbot hints + photo grading)
- express-rate-limit 8.5.2 - IP-keyed rate limiting for `/api/chat` and `/api/grade` (prevents AI bill overruns)
- multer 2.2.0 - Multipart form-data parsing for photo uploads to `/api/grade` and `/api/pair/:token/photo`
- zod 3.23.8 - Runtime schema validation for all `req.body` and `req.query` parameters

**Backend - Infrastructure:**
- cors 2.8.5 - CORS middleware for cross-origin requests
- dotenv 16.4.5 - `.env` file loading (never expose secrets to browser)
- mathjs 15.2.0 - Mathematical expression parsing and evaluation

**Frontend - Critical:**
- socket.io-client 4.8.3 - WebSocket client for live photo transfer from phone
- qrcode.react 4.2.0 - QR code generation for "upload via phone" pairing
- uuid 14.0.0 - Session ID generation (stored in `localStorage`)

**Frontend - Build/Lint:**
- @vitejs/plugin-react 6.0.1 - React Fast Refresh plugin for Vite
- @eslint/js 10.0.1 - ESLint core
- eslint-plugin-react-hooks 7.1.1 - React Hooks linting rules
- eslint-plugin-react-refresh 0.5.2 - Linting for Fast Refresh compatibility
- typescript-eslint 8.59.2 - TypeScript support for ESLint
- tailwindcss 3.4.19 - Utility-first CSS framework
- autoprefixer 10.5.0 - PostCSS plugin for vendor prefixes
- postcss 8.5.15 - CSS transformation pipeline

## Configuration

**Environment (Backend):**
- `.env` file (required, never committed):
  - `SUPABASE_URL` - Supabase project URL
  - `SUPABASE_SERVICE_ROLE_KEY` - Supabase service role key (backend-only, never exposed to frontend)
  - `PORT` - Server port (default 3001)
  - `GEMINI_API_KEY` - Google Gemini API key (backend-only)
  - `GEMINI_MODEL` - Gemini model ID (default `gemini-2.5-flash`)
  - `CHAT_RATE_LIMIT_PER_MIN` - Rate limit for `/api/chat` (default 15)
  - `CHAT_MAX_MESSAGES_PER_QUESTION` - Per-question chat message cap (default 40)
  - `GRADE_RATE_LIMIT_PER_MIN` - Rate limit for `/api/grade` (default 5)
  - `GRADE_MAX_IMAGES` - Max images per grading request (default 5)
  - `GRADE_MAX_IMAGE_MB` - Max image file size in MB (default 8)
  - `PAIR_TTL_MIN` - QR pairing token lifetime in minutes (default 10)
  - `PAIR_RATE_LIMIT_PER_MIN` - Rate limit for photo uploads (default 30)

**Frontend:**
- No `.env` file (public assets only; API calls proxied to backend)
- `localStorage` holds `session_id` (UUID v4, persistent session tracking)

**Build (Backend):**
- `tsconfig.json`: `target: ES2022`, `module: NodeNext`, `strict: true`
- TypeScript compilation → `dist/` directory
- Runtime: `node dist/index.js` (production)

**Build (Frontend):**
- `vite.config.ts`: React plugin, CORS proxy to backend at `localhost:3001`, Socket.IO WebSocket proxy
- TypeScript compilation + Vite bundling → `dist/` directory
- Dev server: `vite` (port 5173, `server.host: true` for LAN access)

**Code Quality:**
- `.eslintrc.js` (frontend) - ESLint configuration with React hooks and refresh rules
- No Prettier found — formatting is ESLint-based only

## Platform Requirements

**Development:**
- Node.js 22+ (for `@types/node ^22.0.0`)
- npm 10+
- Modern browser (for Socket.IO, MathLive, React 19, QRCode rendering)
- For "upload via phone" flow: **Desktop accessed via LAN IP** (e.g., `http://192.168.x.x:5173`), not `localhost`, so QR is reachable from phone

**Production:**
- Node.js 22+ (backend server)
- Supabase PostgreSQL database (cloud-hosted)
- Google Cloud credentials (Gemini API access)
- Static file hosting for React SPA (frontend `dist/`)

## API Endpoints

**See INTEGRATIONS.md for detailed endpoint documentation.**

---

*Stack analysis: 2026-06-26*
