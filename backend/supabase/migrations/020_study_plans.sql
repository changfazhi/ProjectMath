CREATE TABLE public.study_plans (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date        DATE NOT NULL,
  items       JSONB NOT NULL DEFAULT '[]',
  reasoning   TEXT NOT NULL DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, date)
);

GRANT ALL ON TABLE public.study_plans TO anon, authenticated, service_role;
