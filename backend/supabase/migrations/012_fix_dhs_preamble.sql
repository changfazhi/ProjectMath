-- Migration 012: Fix DHS P1 Q1/Q2/Q5/Q6 where prompt_latex duplicated part content.
-- These four questions had the full question text (including embedded (a)(b)(c)(d) labels)
-- in prompt_latex AND in parts JSONB, causing every sub-question to appear twice in the UI.
-- Fix: trim prompt_latex to just the preamble; parts JSONB already has the individual sub-questions.

-- P1 Q1 — Homogeneous ODE: full question was in prompt_latex with no separate preamble
UPDATE questions
SET prompt_latex = ''
WHERE id = 'd0250001-0000-0000-0000-000000000000';

-- P1 Q2 — Geometric series: keep only the setup sentence before (a)
UPDATE questions
SET prompt_latex = $$A series is given by \(\displaystyle\sum_{r=1}^{n} 2(4-3x)^r\) where \(x\) is constant.$$
WHERE id = 'd0250002-0000-0000-0000-000000000000';

-- P1 Q5 — Graphing f(x): keep only the graph description before (a)
UPDATE questions
SET prompt_latex = $$The graphs of \(y = \mathrm{f}'(x)\) and \(y = |\mathrm{f}(x)|\) are shown. The graph of \(y = \mathrm{f}'(x)\) has a horizontal asymptote \(y = 1\) and a zero asymptote \(y = 0\), passing through \((-2, 0)\) and \((1.5, 0)\). The graph of \(y = |\mathrm{f}(x)|\) has asymptotes \(y = x+3\) and \(y = -x-3\), horizontal asymptote \(y = 3\), passing through \((-3,0)\), \((1,0)\), \((2.5,0)\) with a local minimum at \((1.5, 1)\) and local maximum at \((-2, 2)\).$$
WHERE id = 'd0250005-0000-0000-0000-000000000000';

-- P1 Q6 — Parametric curve: keep only the curve definition before (a)
UPDATE questions
SET prompt_latex = $$A curve \(C\) is defined parametrically by
\[x = a\tan t,\quad y = a\sec^2 t\sin t,\quad -\frac{\pi}{4} < t < \frac{\pi}{4},\]
where \(a\) is a positive constant.$$
WHERE id = 'd0250006-0000-0000-0000-000000000000';
