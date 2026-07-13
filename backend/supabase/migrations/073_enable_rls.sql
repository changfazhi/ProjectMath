-- 073: Lock down PostgREST access — enable RLS on every table and revoke the anon/authenticated
-- grants that earlier migrations handed out.
--
-- The backend is the only client of this database and it uses the service-role key, which
-- bypasses RLS and keeps its own GRANT — nothing in the app changes. What this closes: Supabase
-- exposes PostgREST publicly at https://<ref>.supabase.co/rest/v1/, and the anon key is a
-- publishable credential. With GRANT ALL to anon and no RLS, that key was a master key to every
-- table (user emails, Stripe customer ids, question solutions). With RLS enabled and no policies,
-- anon/authenticated get nothing even if a future migration re-grants by habit.
--
-- If a table was created under a different name in your instance, drop that line rather than
-- letting the whole migration fail.

ALTER TABLE public.topics                   ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.topic_concepts           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attempts                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users                    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.starred_questions        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.gradings                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.spaced_repetition_cards  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plans              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_diagnoses           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stripe_events            ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON public.topics                  FROM anon, authenticated;
REVOKE ALL ON public.topic_concepts          FROM anon, authenticated;
REVOKE ALL ON public.questions               FROM anon, authenticated;
REVOKE ALL ON public.attempts                FROM anon, authenticated;
REVOKE ALL ON public.users                   FROM anon, authenticated;
REVOKE ALL ON public.starred_questions       FROM anon, authenticated;
REVOKE ALL ON public.chat_messages           FROM anon, authenticated;
REVOKE ALL ON public.gradings                FROM anon, authenticated;
REVOKE ALL ON public.spaced_repetition_cards FROM anon, authenticated;
REVOKE ALL ON public.study_plans             FROM anon, authenticated;
REVOKE ALL ON public.user_diagnoses          FROM anon, authenticated;
REVOKE ALL ON public.stripe_events           FROM anon, authenticated;

-- Sequences picked up by GRANT ALL in some earlier migrations; harmless if none exist.
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM anon, authenticated;
