-- 031_user_stripe_subscription.sql
--
-- Records the user's live Stripe card subscription on their row. Fixes issue #57.
--
-- `access_expires_at` was doing two jobs at once: "the PayNow period runs until this instant" and
-- "downgrade the user once this instant passes". Nothing on the row could say "a card subscription
-- is live" — `stripe_customer_id` is set for PayNow buyers too — so `grantPaidTier` resolved the
-- ambiguity by nulling `access_expires_at` whenever a card subscription was bought. That destroyed
-- the record of PayNow time the user had already paid for: cancelling the card immediately then
-- dropped them straight to free, because `revokePaidTier`'s "still has PayNow time?" guard reads
-- the very column the grant had erased.
--
-- With the subscription id recorded, the two facts are independent: `access_expires_at` means only
-- "PayNow paid until", and a live card subscription is paid regardless of it.
--
-- No GRANT needed — ALTER TABLE, not CREATE TABLE.

ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS stripe_subscription_id TEXT;

-- Backfill using the invariant that held before this migration: an active subscriber with no
-- PayNow expiry was, necessarily, a card subscriber. We can't recover their real subscription id
-- from SQL, so mark them with a sentinel; the next `customer.subscription.updated` webhook (which
-- every live subscription emits at least once per billing cycle) replaces it with the real id.
--
-- `deriveTier` treats any non-null value as "card subscription live", so these users keep their
-- access across the deploy. Without this they would all resolve to free.
UPDATE public.users
SET stripe_subscription_id = 'legacy_unbackfilled'
WHERE subscription_status = 'active'
  AND access_expires_at IS NULL
  AND stripe_customer_id IS NOT NULL
  AND stripe_subscription_id IS NULL;

COMMENT ON COLUMN public.users.stripe_subscription_id IS
  'Live Stripe card subscription, or NULL. Independent of access_expires_at (PayNow). Cleared by revokePaidTier.';
