-- Migration 033: persist the computed PayNow expiry on the event ledger.
-- A checkout.session.completed(payment) delivery that granted access but then failed to mark
-- itself 'completed' gets replayed after its lease goes stale; without a stored expiry the
-- replay recomputes from the already-extended access_expires_at and stacks a second period for
-- one payment (issue #61). Storing the absolute expiry lets the replay converge to the same value.
ALTER TABLE public.stripe_events ADD COLUMN IF NOT EXISTS computed_expires_at TIMESTAMPTZ;
