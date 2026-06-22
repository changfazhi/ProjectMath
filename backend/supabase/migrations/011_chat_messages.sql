-- Persisted AI hint chat history, keyed by session + question.
CREATE TABLE chat_messages (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID NOT NULL,
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  role        TEXT NOT NULL CHECK (role IN ('user', 'model')),
  content     TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chat_messages_session_question
  ON chat_messages (session_id, question_id, created_at);

GRANT ALL ON TABLE public.chat_messages TO anon, authenticated, service_role;
