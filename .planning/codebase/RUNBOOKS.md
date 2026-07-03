# Operational Runbooks

Step-by-step guides for operational tasks that require specific sequencing. Retrieve this file when asked how to perform any of the procedures below.

---

## Stripe: Sandbox → Live Mode

**When:** Ready to accept real payments from real users.
**Prerequisite:** Deployed backend with a public HTTPS URL.

### Step 1 — Activate live mode in Stripe Dashboard

Toggle from "Test" to "Live" in the top-left of the Stripe Dashboard. Products, prices, customers, and webhooks are completely separate per mode — nothing carries over automatically.

### Step 2 — Recreate products and prices in live mode

Test-mode price IDs (`price_1Tp1y...`) are invalid in live mode. In live mode Dashboard:
- Create product "ProjectMath Premium" (SGD)
- Create all four prices:
  - Card Monthly: S$15.00/month recurring
  - Card Annual: S$144.00/year recurring
  - PayNow Monthly: S$15.00 one-time
  - PayNow Annual: S$144.00 one-time
- Copy the four new `price_live_...` IDs

**PayNow in live mode:** Requires Singapore business registration and Stripe verification. Go to Dashboard → Settings → Payment methods → enable PayNow. Stripe may request business documents before approval.

### Step 3 — Create a live webhook endpoint

`stripe listen` is a dev-only tool. Production requires a registered HTTPS endpoint:
- Dashboard → Developers → Webhooks → Add endpoint
- URL: `https://your-domain.com/api/billing/webhook`
- Events to subscribe:
  - `checkout.session.completed`
  - `customer.subscription.updated`
  - `customer.subscription.deleted`
  - `customer.deleted`
- Copy the `whsec_...` signing secret shown after creation

### Step 4 — Configure the Stripe Customer Portal

One-time setup per mode (not in code):
- Dashboard → Settings → Billing → Customer portal
- Enable "Cancel subscriptions" and any other self-service options desired

### Step 5 — Update production environment variables

No code changes needed — the integration is fully env-var-driven:

```
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...          # from step 3
STRIPE_PRICE_MONTHLY=price_live_...      # card monthly, from step 2
STRIPE_PRICE_ANNUAL=price_live_...       # card annual, from step 2
STRIPE_PRICE_MONTHLY_PAYNOW=price_live_...
STRIPE_PRICE_ANNUAL_PAYNOW=price_live_...
FRONTEND_URL=https://your-domain.com     # Stripe uses this for success/cancel redirects
CORS_ORIGIN=https://your-domain.com      # CORS allow-list for the backend
```

The live secret key is at Dashboard → Developers → API keys → Secret key (live mode).

### Step 6 — Deploy and smoke-test

Stripe provides live-mode test cards (real card network, no actual charge) for a final sanity check. Available at Dashboard → Developers → Testing (while in live mode).

---

## Stripe: Reset a Test Account to Free Tier (dev only)

Useful during development to re-test the upgrade flow from scratch.

```bash
cd backend
npx tsx scripts/reset-user-tier.ts <email>
```

Clears: Firebase custom claim → `{ tier: 'free' }`; DB fields → `stripe_customer_id: null`, `subscription_status: null`, `access_expires_at: null`.

The user must sign out and back in (or wait up to 1 hour for token cache to expire) for the UI to reflect the change.

---

## Stripe: Dev Webhook Forwarding

Run in a separate terminal whenever testing any checkout or billing flow locally. Must be running for webhooks to reach `localhost`.

```bash
stripe listen --forward-to localhost:3001/api/billing/webhook
```

Copy the printed `whsec_...` into `backend/.env` as `STRIPE_WEBHOOK_SECRET`. Each developer gets their own unique `whsec_...` — the Stripe secret key and price IDs are shared across the team, but `STRIPE_WEBHOOK_SECRET` is per-machine.
