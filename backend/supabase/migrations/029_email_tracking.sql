-- Migration 029: tracking columns for the transactional email system.
-- welcome_email_sent_at / first_purchase_email_sent_at are once-ever flags (checked, then
-- set, by the code that sends each email — see emailService.ts). last_expiry_reminder_sent_on
-- dedupes the daily PayNow-expiry reminder so a cron re-run on the same day is a no-op.

ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS welcome_email_sent_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS first_purchase_email_sent_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS last_expiry_reminder_sent_on DATE;

GRANT ALL ON TABLE public.users TO anon, authenticated, service_role;
