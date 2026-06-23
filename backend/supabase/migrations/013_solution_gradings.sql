-- Photo-based AI grading of handwritten solutions.
-- Stores one row per graded submission: the uploaded photo paths + structured
-- per-part feedback from Gemini. This table is also the data source for a future
-- "mistake log" page (every wrong question + the precise step the error occurred).

CREATE TABLE gradings (
  id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id       UUID NOT NULL,
  question_id      UUID NOT NULL REFERENCES questions(id) ON DELETE CASCADE,
  image_paths      TEXT[] NOT NULL,            -- object paths in the 'solution-uploads' bucket
  marks_awarded    NUMERIC NOT NULL,
  marks_total      NUMERIC NOT NULL,
  is_correct       BOOLEAN NOT NULL,           -- marks_awarded == marks_total
  parts            JSONB NOT NULL,             -- per-part results (verdict, marks, errors[], hints[])
  overall_feedback TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_gradings_session_question
  ON gradings (session_id, question_id, created_at);

-- Supports the future mistake-log query: wrong submissions for a session.
CREATE INDEX idx_gradings_mistakes
  ON gradings (session_id, is_correct, created_at);

GRANT ALL ON TABLE public.gradings TO anon, authenticated, service_role;

-- Private bucket for uploaded solution photos. Read via short-lived signed URLs
-- generated server-side (service role); never publicly listable.
INSERT INTO storage.buckets (id, name, public)
VALUES ('solution-uploads', 'solution-uploads', false)
ON CONFLICT (id) DO NOTHING;
