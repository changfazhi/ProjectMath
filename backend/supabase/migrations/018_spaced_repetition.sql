-- SM-2 spaced repetition state per (session, question).
-- ef = Wozniak easiness factor, starts at 2.5.
-- interval_days = days until next review.
-- repetitions = consecutive correct-review count; reset to 0 on failure.
-- due_at = when the card is next due for review.

CREATE TABLE IF NOT EXISTS spaced_repetition_cards (
  id               uuid          PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id       uuid          NOT NULL,
  question_id      uuid          NOT NULL,
  topic_id         uuid          NOT NULL,
  ef               numeric(4,2)  NOT NULL DEFAULT 2.50,
  interval_days    integer       NOT NULL DEFAULT 1,
  repetitions      integer       NOT NULL DEFAULT 0,
  due_at           timestamptz   NOT NULL DEFAULT NOW(),
  last_reviewed_at timestamptz,
  created_at       timestamptz   NOT NULL DEFAULT NOW(),
  UNIQUE(session_id, question_id)
);

GRANT ALL ON TABLE public.spaced_repetition_cards TO anon, authenticated, service_role;

-- Seed existing wrong-only answers (no correct attempt) as immediately due.
-- This ensures existing users see their backlog in the new Review card.
INSERT INTO spaced_repetition_cards (session_id, question_id, topic_id, due_at)
SELECT DISTINCT ON (a.session_id, a.question_id)
  a.session_id,
  a.question_id,
  q.topic_id,
  NOW()
FROM attempts a
JOIN questions q ON q.id = a.question_id
WHERE a.is_correct = false
  AND NOT EXISTS (
    SELECT 1 FROM attempts a2
    WHERE a2.session_id = a.session_id
      AND a2.question_id = a.question_id
      AND a2.is_correct = true
  )
ON CONFLICT (session_id, question_id) DO NOTHING;
