-- Migration 023: add access_expires_at for PayNow one-time subscriptions
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS access_expires_at TIMESTAMPTZ;

GRANT ALL ON TABLE public.users TO anon, authenticated, service_role;
