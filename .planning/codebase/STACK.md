# Technology Stack

**Analysis Date:** 2026-07-04

## Languages

**Primary:**
- TypeScript 5.6 (strict mode) - Backend (`backend/src/**/*.ts`) and frontend (`frontend/src/**/*.tsx`)
- JavaScript/Node.js - Dev scripts (`dev.js`)

**Secondary:**
- CSS 3 - Styling via Tailwind
- LaTeX - Mathematical notation throughout (KaTeX + MathLive rendering)

## Runtime

**Environment:**
- Node.js v24.16.0 (current production runtime)
- npm 11.13.0 (package manager)

**Package Manager:**
- npm with `package-lock.json` (committed to repo)
- Lockfiles: Present in both `backend/` and `frontend/`

## Frameworks

**Backend:**
- Express.js 4.21.0 - HTTP server and REST API routing
- Socket.IO 4.8.3 - Real-time bidirectional communication (phone upload QR pairing)

**Frontend:**
- React 19.2.6 - UI framework
- Vite 8.0.12 - Build tool and dev server
- React Router DOM 7.17.0 - Client-side routing (`/`, `/practice/:topicId`, `/history`, `/starred`, `/profile` (`/stats` redirects here), `/m/:token`)

**Styling & Math:**
- Tailwind CSS 3.4.19 - Utility-first CSS styling
- KaTeX 0.17.0 - Math rendering (static LaTeX display, `<Latex>` component)
- MathLive 0.110.0 - Interactive math input editor (`MathField.tsx`, `MathKeyboard.tsx`)

**Testing:**
- No test framework detected (no Jest, Vitest, Mocha configs)

**Linting & Format:**
- ESLint (flat config, `frontend/eslint.config.js`) - TypeScript, React, React Hooks, React Refresh plugins
- TypeScript strict compiler (`tsconfig.json` across backend and frontend)

## Key Dependencies

**Critical:**
- `@supabase/supabase-js` 2.45.0 - PostgreSQL database and file storage client
- `@google/genai` 2.9.0 - Gemini AI for hints and photo grading
- `stripe` 22.3.0 - Payment processing (subscriptions and PayNow one-time payments)
- `firebase` 12.15.0 (frontend) - Authentication and Firestore (if used)
- `firebase-admin` 14.1.0 (backend) - Firebase Admin SDK for custom claims and user management

**Infrastructure:**
- `socket.io` 4.8.3 (backend) + `socket.io-client` 4.8.3 (frontend) - Real-time bidirectional communication
- `multer` 2.2.0 - Multipart form-data parsing for image uploads
- `cors` 2.8.5 - Cross-Origin Resource Sharing middleware
- `dotenv` 16.4.5 - Environment variable loading
- `express-rate-limit` 8.5.2 - IP-based rate limiting for `/api/chat` and `/api/grade`
- `mathjs` 15.2.0 - Math expression evaluation and normalization

**Utilities:**
- `zod` 3.23.8 - Schema validation for request bodies and query strings
- `uuid` 14.0.0 - UUID v4 generation (session IDs, pairing tokens, gradings)
- `qrcode.react` 4.2.0 - QR code generation (phone pairing flow)
- `autoprefixer` 10.5.0 - CSS vendor prefixing
- `postcss` 8.5.15 - CSS transformation pipeline

**Dev Dependencies:**
- `tsx` 4.19.0 (backend) - TypeScript execution with watch mode (`npm run dev`)
- `@vitejs/plugin-react` 6.0.1 - React Fast Refresh for dev HMR
- TypeScript language server tools (`@types/node`, `@types/react`, `@types/express`, `@types/multer`, `@types/katex`, `@types/uuid`, `@types/cors`)

## Configuration

**Environment:**
- Environment variables loaded via `dotenv` at backend startup (`backend/src/index.ts` imports `dotenv/config`)
- Critical secrets stored in `backend/.env` (not committed; see `.env.example`)
- Frontend environment variables prefixed `VITE_` for Vite access (Firebase config)

**Key configs required:**
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_SERVICE_ROLE_KEY` - Server-side Supabase auth key
- `GEMINI_API_KEY` - Google Gemini API key (optional, graceful fallback if missing)
- `STRIPE_SECRET_KEY` - Stripe secret key
- `STRIPE_WEBHOOK_SECRET` - Webhook signature verification
- `STRIPE_PRICE_MONTHLY`, `STRIPE_PRICE_SEMESTERLY` - Stripe price IDs (card subscriptions)
- `STRIPE_PRICE_MONTHLY_PAYNOW`, `STRIPE_PRICE_SEMESTERLY_PAYNOW` - Stripe price IDs (one-time PayNow)
- `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `FIREBASE_PRIVATE_KEY` - Firebase Admin SDK (server-side auth claims)
- `VITE_FIREBASE_API_KEY`, `VITE_FIREBASE_AUTH_DOMAIN`, `VITE_FIREBASE_PROJECT_ID`, `VITE_FIREBASE_APP_ID` - Firebase client config
- `PORT` - Backend HTTP port (default 3001)
- `CORS_ORIGIN` - Production CORS origin
- `FRONTEND_URL` - Stripe redirect base (default `http://localhost:5173`)
- `NODE_ENV` - Environment mode (`production` vs dev)
- Optional: `GEMINI_MODEL`, `CHAT_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION`, `GRADE_RATE_LIMIT_PER_MIN`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB`, `PAIR_TTL_MIN`, `AI_RPM_LIMIT`, `AI_RPD_LIMIT`, `AI_OUTBOUND_RPM`, `AI_CHAT_COOLDOWN_S`, `AI_GRADE_COOLDOWN_S`, `AI_CHAT_QUEUE_MAX_WAIT_S`, `AI_GRADE_QUEUE_MAX_WAIT_S`, `AI_QUEUE_MAX_LENGTH`

**Build:**
- **Backend:** TypeScript compiled to CommonJS (NodeNext module resolution) → `dist/` directory
  - Config: `backend/tsconfig.json` (target ES2022, strict: true)
  - Entry: `backend/src/index.ts` → `backend/dist/index.js`
  - Script: `npm run build` (tsc), `npm run dev` (tsx watch)

- **Frontend:** Vite SPA build
  - Config: `frontend/vite.config.ts` (React plugin, proxy to `:3001/api` and `:3001/socket.io`)
  - Entry: `frontend/src/main.tsx` → `frontend/dist/index.html` + JS/CSS bundles
  - TypeScript: `frontend/tsconfig.json` references `tsconfig.app.json` and `tsconfig.node.json`
  - Script: `npm run dev` (Vite on :5173, LAN-bound), `npm run build` (tsc -b && vite build)

## Platform Requirements

**Development:**
- Node.js v24+ (uses ES2022 features)
- npm 11+ (lock file format)
- PostgreSQL database (Supabase backend)
- Google Cloud credentials for Gemini API (optional; backend gracefully boots without it)
- Firebase credentials (service account JSON + client config)
- Stripe account with API keys
- LAN IP exposure required for phone QR upload flow (Vite `server.host: true`)

**Production:**
- Node.js v24+ with npm
- Supabase PostgreSQL + Storage
- Stripe account and webhooks configured
- Firebase project (Auth + Firestore if used)
- Google Cloud Gemini API key (for AI features)
- HTTPS enforcement on frontend
- Persistent file storage for `/solution-uploads` bucket (Supabase storage)

---

*Stack analysis: 2026-07-04*
