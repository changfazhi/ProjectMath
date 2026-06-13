CREATE TABLE topic_concepts (
  id         UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  topic_id   UUID NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  concept    TEXT NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_topic_concepts_topic_id ON topic_concepts(topic_id);
