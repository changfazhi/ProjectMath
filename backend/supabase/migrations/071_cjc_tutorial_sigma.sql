-- Migration 071: CJC 2021 JC1 H2 Math Tutorial — Sigma Notation (DISCUSSION only, 3 questions)
-- Source: TUTORIAL/SEQUENCE AND SERIES QNS/2. 2021 Sigma Notation (Teacher).pdf, DISCUSSION section (pp.17-19).
-- REVIEW PROBLEMS excluded. **Method-of-differences questions excluded per request:** discussion Q4 (telescoping
--   cos series), Q5 (partial fractions + M.O.D.), Q6 (M.O.D. + change of index), Q7 (M.O.D. + factorials),
--   Q8 (surd-telescoping M.O.D.) are all NOT migrated. Only the three "evaluate/change-of-index" questions
--   (discussion Q1-Q3) are kept. IDs cc232004..cc232008 are intentionally left unminted.
-- Provenance stripped: generic source 'H2 Math Tutorial (Sigma Notation)', inline exam tags removed.
-- IDs: prefix 'cc23' + topic-index '2' (Sigma Notation = tutorial file 2) + 3-digit Q# -> cc232001..cc232003. Topic aaaa0007.
-- No DDL: parts JSONB (008) already exists.
-- Grading: Q1 (add/subtract-terms) has non-unique correction forms -> null (revealed). Q2/Q3 closed-form sums are
--          FLAG-enabled 'exact' with the answer-key canonical form (algebraic expressions -> exact-match is brittle).

-- Q1 (BASIC): add/subtract suitable terms to fix an index change. Non-unique forms -> both parts null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc232001-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Adjusting a sum after changing its index$$,
  $$Add or subtract suitable terms to make each of the following equations valid.$$,
  'exact',
  $$$$,
  NULL,
  $$(a) The right-hand sum runs to \(r=n\), which is one term more than the left-hand sum (up to \(r=n-1\)), so the extra term \(\ln(n+1)\) must be subtracted: \(\displaystyle\sum_{r=1}^{n-1}\ln(r+1)=\sum_{r=1}^{n}\ln(r+1)-\ln(n+1)\). \\ (b) The right-hand sum starts at \(n=6\), so it is missing the terms for \(n=3,4,5\); these must be added back: \(\displaystyle\sum_{n=3}^{N-2}e^{n-1}=\sum_{n=6}^{N-2}e^{n-1}+\sum_{n=3}^{5}e^{n-1}\).$$,
  4,
  'H2 Math Tutorial (Sigma Notation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "\\(\\displaystyle\\sum_{r=1}^{n-1}\\ln(r+1)=\\sum_{r=1}^{n}\\ln(r+1)+\\underline{\\qquad}\\)  — state the term(s) to add or subtract on the right.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "\\(\\displaystyle\\sum_{n=3}^{N-2}e^{n-1}=\\sum_{n=6}^{N-2}e^{n-1}+\\underline{\\qquad}\\)  — state the term(s) to add or subtract on the right.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q2 (BASIC): evaluate three closed-form sums.
-- FLAG: answers are algebraic expressions with equivalent factored/expanded forms; exact-match is brittle. Canonical forms pinned.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc232002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Evaluating sums in sigma notation$$,
  $$Find each of the following sums, giving your final answers in the simplest form.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(i) \(\displaystyle\sum_{k=0}^{n}(k+n+1)=\sum_{k=0}^{n}k+(n+1)(n+1)=\dfrac{n}{2}(n+1)+(n+1)^2=(n+1)\left(\dfrac{3}{2}n+1\right)\). \\ (ii) \(\displaystyle\sum_{r=1}^{N}\left(4r+2^{-r}\right)=4\cdot\dfrac{N}{2}(N+1)+\dfrac{2^{-1}\left(1-(2^{-1})^{N}\right)}{1-2^{-1}}=2N(N+1)+1-\dfrac{1}{2^{N}}\). \\ (iii) \(\displaystyle\sum_{k=1}^{30}\left(a^{2k}+ka\right)=\dfrac{a^{2}\left(1-a^{60}\right)}{1-a^{2}}+a\cdot\dfrac{30}{2}(31)=\dfrac{a^{2}\left(a^{60}-1\right)}{a^{2}-1}+465a\).$$,
  6,
  'H2 Math Tutorial (Sigma Notation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "\\(\\displaystyle\\sum_{k=0}^{n}(k+n+1)\\), in terms of \\(n\\).",
    "correct_answer": "(n+1)\\left(\\frac{3}{2}n+1\\right)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "\\(\\displaystyle\\sum_{r=1}^{N}\\left(4r+2^{-r}\\right)\\), in terms of \\(N\\).",
    "correct_answer": "2N(N+1)+1-\\frac{1}{2^{N}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "\\(\\displaystyle\\sum_{k=1}^{30}\\left(a^{2k}+ka\\right)\\), in terms of \\(a\\).",
    "correct_answer": "\\frac{a^{2}(a^{60}-1)}{a^{2}-1}+465a",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q3 (BASIC): use a given standard result to evaluate a shifted sum. Single graded expression (no parts).
-- FLAG: closed-form factorised expression; exact-match is brittle. Canonical form pinned to the answer key.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc232003-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Shifted sum from a given standard result$$,
  $$Given that \(\displaystyle\sum_{r=1}^{n}r(r+2)=\dfrac{1}{6}n(n+1)(2n+7)\), find \(\displaystyle\sum_{r=n}^{2n}r(r+2)\), giving your answer in a simplified factorised form.$$,
  'exact',
  $$\frac{1}{6}n(14n+19)(n+1)$$,
  NULL,
  $$\(\displaystyle\sum_{r=n}^{2n}r(r+2)=\sum_{r=1}^{2n}r(r+2)-\sum_{r=1}^{n-1}r(r+2)=\dfrac{1}{6}(2n)(2n+1)(4n+7)-\dfrac{1}{6}(n-1)(n)(2n+5)=\dfrac{1}{6}n\left(14n^{2}+33n+19\right)=\dfrac{1}{6}n(14n+19)(n+1)\).$$,
  4,
  'H2 Math Tutorial (Sigma Notation)'
);
