# Operational Runbooks

Step-by-step guides for operational tasks that require specific sequencing. Retrieve this file when asked how to perform any of the procedures below.

---

## Stripe: Sandbox → Live Mode

**When:** Ready to accept real payments from real users.
**Prerequisite:** Deployed backend with a public HTTPS URL.

### Step 1 — Activate live mode in Stripe Dashboard

Toggle from "Test" to "Live" in the top-left of the Stripe Dashboard. Products, prices, customers, and webhooks are completely separate per mode — nothing carries over automatically.

### Step 2 — Recreate products and prices in live mode

Test-mode price IDs are invalid in live mode. In live mode Dashboard:
- Create product "ProjectMath Premium" (SGD)
- Create all four prices:
  - Card Monthly: S$5.00/month recurring
  - Card Semesterly: S$25.00 every 6 months recurring — under "Billing period" choose **Custom**, set interval **Monthly** with a count of **6** (Stripe has no native "semi-annual" interval, so this is expressed as `interval=month, interval_count=6`)
  - PayNow Monthly: S$5.00 one-time
  - PayNow Semesterly: S$25.00 one-time
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
STRIPE_PRICE_SEMESTERLY=price_live_...   # card semesterly (6-month), from step 2
STRIPE_PRICE_MONTHLY_PAYNOW=price_live_...
STRIPE_PRICE_SEMESTERLY_PAYNOW=price_live_...
FRONTEND_URL=https://your-domain.com     # Stripe uses this for success/cancel redirects
CORS_ORIGIN=https://your-domain.com      # CORS allow-list for the backend
```

The live secret key is at Dashboard → Developers → API keys → Secret key (live mode).

### Step 6 — Deploy and smoke-test

Stripe provides live-mode test cards (real card network, no actual charge) for a final sanity check. Available at Dashboard → Developers → Testing (while in live mode).

---

## Stripe: Change Subscription Pricing (Test Mode)

**When:** The premium plan's price or billing period changes. Prices in Stripe are immutable — you cannot edit the amount on an existing Price object, only create a new one and swap the ID.

### Step 1 — Create the new prices in the Test Mode Dashboard

Dashboard (ensure the "Test mode" toggle, top-right, is on) → Product catalog → "ProjectMath Premium" (or create it if missing, currency SGD):
- Card Monthly: S$5.00/month recurring
- Card Semesterly: S$25.00 every 6 months recurring — under "Billing period" choose **Custom**, interval **Monthly**, count **6** (Stripe has no native "semi-annual" interval)
- PayNow Monthly: S$5.00 one-time
- PayNow Semesterly: S$25.00 one-time

Copy each new `price_test_...` ID.

### Step 2 — Update `backend/.env`

```
STRIPE_PRICE_MONTHLY=price_test_...
STRIPE_PRICE_SEMESTERLY=price_test_...
STRIPE_PRICE_MONTHLY_PAYNOW=price_test_...
STRIPE_PRICE_SEMESTERLY_PAYNOW=price_test_...
```

Restart the backend (`npm run dev` in `backend/`) so it picks up the new env values.

### Step 3 — Archive the old prices (optional cleanup)

Old prices with active test subscriptions still work for existing subscribers (Stripe won't retroactively change what they're billed) — archive them in the Dashboard (Product catalog → price → "..." → Archive) once you've confirmed no test subscriptions still reference them, so they stop cluttering the picker.

### Step 4 — Smoke-test checkout

Run through `POST /api/billing/checkout` for both `plan: "monthly"` and `plan: "semesterly"`, both `method: "card"` and `method: "paynow"`, using a [Stripe test card](https://docs.stripe.com/testing) — confirm the checkout page shows the new amount.

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
