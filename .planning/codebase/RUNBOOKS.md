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

## Stripe: PayNow Stacking & Card/PayNow Switching

**What changed:** Checkout used to reject any purchase while `subscription_status === 'active'`. It no longer does — PayNow purchases always stack, and switching between card and PayNow is allowed at any point, in either direction. Logic lives in `backend/src/services/billingService.ts`.

**Scenarios and what happens:**

| Starting state | Action | Result |
|---|---|---|
| PayNow, N days left | Buy another PayNow plan | New period's duration is added on top of the existing `access_expires_at` (stacks, does not restart from today) |
| PayNow, N days left | Start a card subscription | Checkout session is created with `subscription_data.trial_end = access_expires_at` — card isn't charged until the PayNow period actually ends. Tier flips to `paid` immediately (already was), `access_expires_at` clears to `null` since the Stripe subscription is now the source of truth |
| Active card subscription | Buy a PayNow plan | The card subscription is set to `cancel_at_period_end: true` (no double-billing next cycle); the PayNow period is computed from that subscription item's `current_period_end`, not from today |
| Active card subscription | Start another card subscription | Blocked — `findActiveSubscription()` finds the existing active/trialing subscription and throws. This is the only remaining checkout block; user is directed to the billing portal |

**Where to look when debugging:**
- `findActiveSubscription()` — lists a customer's subscriptions and returns one with status `active` or `trialing`.
- `checkout.session.completed` webhook handler, `mode === 'payment'` branch — computes the PayNow stacking baseline (existing `access_expires_at` if still future, else an active card subscription's `items.data[0].current_period_end`, else now).
- `revokePaidTier()` — before downgrading on `customer.subscription.updated`/`deleted` (canceled/past_due/unpaid), it checks whether `access_expires_at` is still in the future and no-ops if so. This matters because a card→PayNow rollover's scheduled `cancel_at_period_end` fires its own cancellation webhook later — without this guard it would wipe out the PayNow access that already replaced it.

**Testing locally:** with `stripe listen` forwarding (see below), buy PayNow, then immediately buy PayNow again — check `users.access_expires_at` advanced by a full extra period rather than resetting. Then start a card subscription — check the Stripe Dashboard shows the subscription as `trialing` with `trial_end` matching `access_expires_at`, not charged yet. Stripe's [test clocks](https://docs.stripe.com/billing/testing/test-clocks) are useful for fast-forwarding past a trial/period end without waiting in real time.

---

## Stripe: Dev Webhook Forwarding

Run in a separate terminal whenever testing any checkout or billing flow locally. Must be running for webhooks to reach `localhost`.

```bash
stripe listen --forward-to localhost:3001/api/billing/webhook
```

Copy the printed `whsec_...` into `backend/.env` as `STRIPE_WEBHOOK_SECRET`. Each developer gets their own unique `whsec_...` — the Stripe secret key and price IDs are shared across the team, but `STRIPE_WEBHOOK_SECRET` is per-machine.
