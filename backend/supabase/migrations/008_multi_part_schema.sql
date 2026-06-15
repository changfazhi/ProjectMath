-- Migration 008: Add parts column to questions and part_label to attempts
-- Enables multi-part question display and per-part answer submission

ALTER TABLE questions ADD COLUMN IF NOT EXISTS parts JSONB;
ALTER TABLE attempts  ADD COLUMN IF NOT EXISTS part_label TEXT;
