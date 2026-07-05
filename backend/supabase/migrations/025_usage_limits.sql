-- 025_usage_limits.sql
-- Tier-based usage limits: persist the weakness diagnosis (so the Review page can show the
-- latest result without re-running Gemini) and add indexes for the daily quota counts.

-- Persisted weakness diagnosis: one row per user, latest result only (upsert on regenerate).
CREATE TABLE public.user_diagnoses (
  user_id      UUID PRIMARY KEY REFERENCES public.users(id) ON DELETE CASCADE,
  result       JSONB NOT NULL,               -- full DiagnosisResult payload
  generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
GRANT ALL ON TABLE public.user_diagnoses TO anon, authenticated, service_role;

-- Index-only daily quota counts. Existing indexes lead with (session_id, question_id, ...),
-- which can't serve a "count this user's rows since SGT midnight" range scan efficiently.
CREATE INDEX idx_gradings_session_created
  ON gradings (session_id, created_at);
CREATE INDEX idx_chat_messages_session_role_created
  ON chat_messages (session_id, role, created_at);
