# Deployment — Google Cloud Run (decided 2026-07-05)

**Decision: single Cloud Run container. Express serves the built frontend statically; Socket.IO kept as-is.** Supersedes the earlier Vercel-vs-Railway notes (bottom).

## Why this shape

- Cloud Run supports WebSockets, so Socket.IO works — no Supabase Realtime migration needed.
- The real constraint is per-instance state: the pairing `Map` (`backend/src/services/pairService.ts`), Socket.IO rooms (`backend/src/realtime.ts`), and the in-memory `express-rate-limit` counters. Hence **`--max-instances=1` is load-bearing** — raising it without re-architecting breaks QR pairing silently/intermittently (phone POSTs hit instance A, desktop socket lives on B).
- One container keeps everything same-origin: relative `/api` fetches in `lib/api.ts`, the same-origin `io()` in `lib/socket.ts`, and the QR built from `window.location.origin` all work unchanged.
- Capacity: the workload is I/O-bound (Gemini/Supabase/Stripe do the heavy lifting); one instance handles hundreds of concurrent users. Each open QR-pairing socket counts against Cloud Run per-instance concurrency → set `--concurrency=250`.
- Instance restarts/deploys drop in-flight pairings → user rescans the QR (`PairError` already handles it). Photos are only persisted after grading succeeds, so nothing is lost.

**Escape hatch (only if >1 instance is ever needed):** move pair state to a `pair_sessions` table, replace Socket.IO fan-out with Supabase Realtime broadcast (photos via Storage + signed URLs — broadcast payloads are too small for base64 images), rate limiting to a shared store. Do this when metrics say so, not before.

## What was changed for this (branch `sketch-graph-model-solutions`)

- `backend/src/index.ts` — in production, serves `../public` statically + SPA fallback (excludes `/api`, `/socket.io`, `/health`). Override path with `FRONTEND_DIST`.
- `frontend/src/lib/socket.ts` — `transports: ['websocket']` (no long-polling handshake → no stickiness dependency).
- `Dockerfile` (repo root) — 3-stage: frontend Vite build, backend tsc build, slim runtime with prod deps only; frontend dist → `/app/public`. Plus `.dockerignore`.

## Deploy

```bash
gcloud run deploy math-trainer \
  --source . \
  --region asia-southeast1 \
  --allow-unauthenticated \
  --max-instances=1 \
  --min-instances=1 \
  --session-affinity \
  --timeout=3600 \
  --concurrency=250 \
  --memory=512Mi
```

- `--max-instances=1` — required (see above). Never raise without the escape-hatch migration.
- `--min-instances=1` — avoids multi-second cold starts for real users (~$10–15/mo).
- `--timeout=3600` — max; sockets dropped at the limit auto-reconnect (socket.io-client). Pairings are 10-min TTL so this never bites.
- `--session-affinity` — belt-and-braces with websocket-only transport.

### Env vars / secrets (Secret Manager via `--set-secrets`, rest via `--set-env-vars`)

Secrets: `SUPABASE_SERVICE_ROLE_KEY`, `GEMINI_API_KEY`, `FIREBASE_PRIVATE_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `RESEND_API_KEY`.
Plain: `SUPABASE_URL`, `FIREBASE_PROJECT_ID`, `FIREBASE_CLIENT_EMAIL`, `STRIPE_PRICE_MONTHLY`, `STRIPE_PRICE_SEMESTERLY`, `STRIPE_PRICE_MONTHLY_PAYNOW`, `STRIPE_PRICE_SEMESTERLY_PAYNOW`, `CORS_ORIGIN=<run URL>`, `FRONTEND_URL=<run URL>`, `EMAIL_FROM` (must use a domain verified in Resend — see below), `BUSINESS_NAME`, `BUSINESS_UEN`, `SUPPORT_EMAIL`.
Optional tuning: `GEMINI_MODEL`, `CHAT_RATE_LIMIT_PER_MIN`, `CHAT_MAX_MESSAGES_PER_QUESTION`, `GRADE_RATE_LIMIT_PER_MIN`, `GRADE_MAX_IMAGES`, `GRADE_MAX_IMAGE_MB`, `PAIR_TTL_MIN`, `PAIR_RATE_LIMIT_PER_MIN`, `AI_RPM_LIMIT`, `AI_RPD_LIMIT`, `AI_OUTBOUND_RPM`, `AI_CHAT_COOLDOWN_S`, `AI_GRADE_COOLDOWN_S`, `AI_CHAT_QUEUE_MAX_WAIT_S`, `AI_GRADE_QUEUE_MAX_WAIT_S`, `AI_QUEUE_MAX_LENGTH`, `PAYNOW_REMINDER_DAYS` (see `.env.example` — defaults match the `gemini-2.5-flash` free tier; update if the model/tier changes).

### Domain + Resend (transactional emails) — do this before going live

Local dev can get away with Resend's shared `onboarding@resend.dev` sender (see `.planning/codebase/RUNBOOKS.md` → **Transactional Emails: Resend Setup**), but that sender can only deliver **to the email address on the Resend account itself** — every real user's welcome/receipt/reminder email will silently fail to send until a real domain is verified. Needed once, before real users sign up:

1. Buy a domain if you don't already have one for this project (any registrar — Namecheap/Cloudflare/Porkbun; doesn't need to be the same domain the app is deployed on, a subdomain like `mail.yourdomain.com` works too).
2. Resend Dashboard → **Domains** → **Add Domain** → add the SPF/DKIM DNS records it gives you at your registrar → wait for "Verified".
3. Set `EMAIL_FROM="ProjectMath <noreply@yourdomain.com>"` (matching the verified domain) as a Cloud Run env var, replacing the `onboarding@resend.dev` placeholder used locally.
4. Fill in real `BUSINESS_NAME`/`SUPPORT_EMAIL` (and `BUSINESS_UEN` if applicable) — these appear on every email and on the receipt.

`NODE_ENV=production` is baked into the image; `PORT` is injected by Cloud Run.

### Post-deploy one-offs

1. Stripe dashboard → add webhook endpoint at the deployed `/api/billing` webhook path; subscribe to `checkout.session.completed`, `customer.subscription.updated`, `customer.subscription.deleted`, `customer.deleted`, **and `invoice.payment_succeeded`** (drives the renewal-charge receipt email); store its signing secret as `STRIPE_WEBHOOK_SECRET` and redeploy.
2. Firebase console → Auth → add the Cloud Run domain to authorized domains.
3. Smoke test: `/health`; sign in (check the welcome email lands); full photo-grade via QR from a phone on **mobile data** (proves WebSockets through Cloud Run's frontend); Stripe test-mode checkout + check webhook delivery log (check the first-purchase congrats + receipt emails land). **Sign in with an account whose email is NOT the Resend account owner's address** — this is the only step that actually proves the domain-verified path works for real users, since every other test in this project (including local dev) was run against the Resend account's own inbox. See `.planning/codebase/RUNBOOKS.md` → Transactional Emails: Resend Setup, Step 5.

### Local container test (machine with Docker)

```bash
docker build -t math-trainer .
docker run --env-file backend/.env -e PORT=8080 -p 8080:8080 math-trainer
```

Check: app at `http://localhost:8080`, hard refresh on `/practice/...` (SPA fallback), QR flow from a phone via `http://<LAN-IP>:8080`.

---

## Superseded notes (Vercel era, kept for context)

- Vercel Hobby runs serverless functions fine (Supabase over HTTP is no problem) — static-vs-dynamic was never the blocker; Socket.IO + in-memory pairing state was.
- Option A was frontend→Vercel + backend→Railway/Render/Fly (split origin, needs `VITE_API_BASE_URL` + `io(baseUrl)` rewiring). Option B was the Supabase Realtime rewrite. Cloud Run single-container replaces both: no rewiring, no rewrite.
