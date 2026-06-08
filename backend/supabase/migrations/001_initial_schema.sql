-- Run this in the Supabase SQL editor (Dashboard → SQL Editor → New Query)

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── Topics ───────────────────────────────────────────────────────────────────
CREATE TABLE topics (
  id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name            TEXT NOT NULL,
  level           TEXT NOT NULL CHECK (level IN ('H1', 'H2')),
  parent_topic_id UUID REFERENCES topics(id) ON DELETE SET NULL,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- ─── Questions ────────────────────────────────────────────────────────────────
CREATE TABLE questions (
  id             UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  topic_id       UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  difficulty     INT  NOT NULL CHECK (difficulty BETWEEN 1 AND 3),
  prompt_latex   TEXT NOT NULL,
  answer_type    TEXT NOT NULL CHECK (answer_type IN ('exact', 'mcq', 'range')),
  correct_answer TEXT NOT NULL,
  tolerance      FLOAT,                 -- used only when answer_type = 'range'
  mcq_options    JSONB,                 -- used only when answer_type = 'mcq'
  solution_latex TEXT NOT NULL,
  marks          INT  NOT NULL DEFAULT 1,
  source         TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

-- ─── Attempts ─────────────────────────────────────────────────────────────────
-- session_id is a client-generated UUID stored in localStorage (no auth required for MVP)
CREATE TABLE attempts (
  id           UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id   UUID NOT NULL,
  question_id  UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  answer_given TEXT NOT NULL,
  is_correct   BOOLEAN NOT NULL,
  time_taken_s INT,
  attempted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_attempts_session_id   ON attempts(session_id);
CREATE INDEX idx_attempts_question_id  ON attempts(question_id);
CREATE INDEX idx_questions_topic_id    ON questions(topic_id);
