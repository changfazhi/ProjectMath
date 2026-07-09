-- Migration 030: webhook idempotency ledger for Stripe event deliveries.
--
-- Stripe delivers webhooks at-least-once: it retries any delivery that doesn't get a 2xx,
-- and may resend an event even when nothing failed (plus the Dashboard "Resend" button and
-- `stripe listen` replays). The `checkout.session.completed` PayNow branch in billingService.ts
-- is *relative* — it reads users.access_expires_at and adds a billing period on top — so a
-- redelivered event silently grants a second period for a single payment.
--
-- One row per Stripe event.id, claimed via the primary key before any side effect runs.
-- Two states rather than a bare "seen" marker: 'processing' is written before the work,
-- 'completed' only after it succeeds. A crash mid-handler therefore leaves the event
-- claimable again once claimed_at goes stale, instead of being permanently marked handled
-- with the customer's payment dropped on the floor.

CREATE TABLE IF NOT EXISTS public.stripe_events (
  id           TEXT PRIMARY KEY,                    -- Stripe event.id (evt_...)
  type         TEXT NOT NULL,
  status       TEXT NOT NULL DEFAULT 'processing',  -- 'processing' | 'completed'
  claimed_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ
);

-- Lets the stale-lease takeover query (status + claimed_at) avoid a sequential scan.
CREATE INDEX IF NOT EXISTS stripe_events_status_claimed_at_idx
  ON public.stripe_events (status, claimed_at);

GRANT ALL ON TABLE public.stripe_events TO anon, authenticated, service_role;
