-- Migration 034b: strip provenance from already-loaded tutorial rows.
-- The first cut of 034 stored source = 'CJC 2021 JC1 Tutorial (<Topic>)' and left an inline exam-reference
-- tag in the Q2 prompt; both surface on the frontend (QuestionHeader renders question.source verbatim).
-- Per user: remove where the questions come from. Idempotent — safe to re-run.

-- 1) Genericise the source string on any tutorial row (covers all topics if more were loaded).
UPDATE questions
SET source = replace(source, 'CJC 2021 JC1 Tutorial', 'H2 Math Tutorial')
WHERE source LIKE 'CJC 2021 JC1 Tutorial%';

-- 2) Remove the inline exam-reference tag from the parametric Q2 prompt.
UPDATE questions
SET prompt_latex = $$Find the cartesian equation of the curve with parametric equations \(x=-4t-\dfrac{1}{t},\ y=3t+\dfrac{1}{2t}\), where \(t\in\mathbb{R},\ t\neq 0\).$$
WHERE id = 'cc216002-0000-0000-0000-000000000000';
