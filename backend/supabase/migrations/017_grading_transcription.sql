-- Editable LaTeX transcription for photo-graded solutions.
-- Gemini now transcribes the student's handwritten working + final answer into
-- LaTeX so the student can review it and correct any mis-scans, then re-grade the
-- corrected text. We store that transcription per grading row. Re-grade rows
-- (graded from typed LaTeX, not photos) have an empty image_paths array.

ALTER TABLE gradings ADD COLUMN transcription_latex TEXT;
