-- Adds Stripe billing columns to the users table.
-- Run in Supabase SQL Editor after all prior migrations.

ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS stripe_customer_id TEXT UNIQUE,
  ADD COLUMN IF NOT EXISTS subscription_status TEXT;

GRANT ALL ON TABLE public.users TO anon, authenticated, service_role;
