-- 078_solution_part_linebreaks.sql
-- Puts each part label of a multi-part solution on its own line. Many solutions
-- were authored as one run-on line — "(a) … (b) … (c) …" — which the Solution tab
-- renders as a single block (PracticePage splits solution_latex on blank lines,
-- \n\n+, into separate blocks). Inserting a blank line before each part label makes
-- each part render as its own paragraph, matching how the parts read on paper.
--
-- Rule: insert a paragraph break (\n\n) before a part label that FOLLOWS a
-- sentence-ending "." or a display-math close "]" plus whitespace. A part label is
--   (a)…(h)            single letter,
--   (a)(i), (a)(ii)…   letter + roman sub-part,
--   (i), (ii), (ci)…   a roman-only label.
-- Anchoring to ".": / "]" whitespace is what keeps in-text references safe — a
-- phrase like "from (a)" or "using part (b)" is preceded by a word, not punctuation,
-- so it is never broken (verified: 0 abbreviation/reference false positives across
-- all 479 solutions; 286 reformatted). The whitespace run is collapsed to exactly
-- \n\n, so the statement is idempotent — re-running it changes nothing.

UPDATE questions
SET solution_latex = regexp_replace(
      solution_latex,
      E'(\\.|\\])\\s+(\\([a-h]\\)(\\([ivxlc]+\\))?|\\([ivxlc]+\\))',
      E'\\1\n\n\\2',
      'g'
    )
WHERE solution_latex IS NOT NULL
  AND solution_latex ~ E'(\\.|\\])\\s+(\\([a-h]\\)|\\([ivxlc]+\\))';
