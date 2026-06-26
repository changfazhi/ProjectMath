CREATE TABLE users (
  id                  UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  firebase_uid        TEXT        UNIQUE NOT NULL,
  email               TEXT,
  display_name        TEXT,
  subscription_tier   TEXT        NOT NULL DEFAULT 'free',
  stripe_customer_id  TEXT,
  created_at          TIMESTAMPTZ DEFAULT NOW()
);

GRANT ALL ON TABLE public.users TO anon, authenticated, service_role;
