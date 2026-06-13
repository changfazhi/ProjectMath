CREATE TABLE starred_questions (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id  UUID NOT NULL,
  question_id UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  starred_at  TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (session_id, question_id)
);
CREATE INDEX idx_starred_session_id ON starred_questions(session_id);
