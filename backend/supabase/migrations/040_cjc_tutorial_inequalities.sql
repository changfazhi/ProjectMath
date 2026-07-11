-- Migration 040: H2 Math Tutorial — Inequalities (DISCUSSION only, 7 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/5. 2021 Inequalities (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user. IDs cc215001..cc215007. Topic aaaa0005.
-- Inequality solution sets are inherently brittle for exact-match (skills.md). Policy applied: FLAG-enable
-- only the CLEAN single-interval answers (Q1(iv), Q4, Q5(b), Q6a/b); compound "or"/union/surd/isolated-point
-- solution sets are left null (the revealed solution_latex is the answer key). Sketch parts → null (deferred graph).

-- Q1 (INTERMEDIATE) — solve five inequalities. Only (iv) is a single clean interval → gradable (FLAG).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Solution sets of rational inequalities$$,
  $$Without using a calculator, find the solution sets of the following inequalities.$$,
  'exact', $$$$, NULL,
  $$(i) \(-1<x<1\) or \(x=-2\). (ii) no real solutions (\(\varnothing\)). (iii) \(1<x<3,\ x\neq 2\). (iv) \(\dfrac{7}{9}<x\le 1\). (v) \(-3\le x<3\) or \(x\ge 5\).$$,
  10,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "i",   "prompt_latex": "\\(\\dfrac{(x+2)^2}{x^2-1}\\le 0\\)",        "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "\\(\\dfrac{x^2+2x+2}{x^2-x+2}<0\\)",        "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "\\(\\dfrac{1}{(x-1)(x-3)}<-1\\)",            "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "\\(1\\le\\dfrac{1}{3x-2}<3\\)",              "correct_answer": "\\frac{7}{9}<x\\le 1", "answer_type": "exact", "tolerance": null },
  { "label": "v",   "prompt_latex": "\\(\\dfrac{12}{x-3}\\le x+1\\)",             "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2 (INTERMEDIATE) — solve f(x)<=2/3, then two substitution "hence" parts. All compound → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215002-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Inequality by substitution$$,
  $$It is given that \(f(x)=\dfrac{x-5}{2x-3}\).$$,
  'exact', $$$$, NULL,
  $$Solving \(f(x)\le\dfrac{2}{3}\): \(x\le -9\) or \(x>\dfrac{3}{2}\). (i) With \(x\to\ln x\): \(0<x\le e^{-9}\) or \(x>e^{3/2}\). (ii) With \(x\to\left|x+\tfrac12\right|\): \(x>1\) or \(x<-2\).$$,
  9,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "a", "prompt_latex": "Using an algebraic method, solve the inequality \\(f(x)\\le\\dfrac{2}{3}\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the exact range of values of \\(x\\) for which \\(f(\\ln x)\\le\\dfrac{2}{3}\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Hence find the exact range of values of \\(x\\) for which \\(f\\left(\\left|x+\\dfrac{1}{2}\\right|\\right)\\le\\dfrac{2}{3}\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q3 (INTERMEDIATE) — sketch (null) + modulus inequality (compound, in a,b → null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215003-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Modulus inequality via graphs$$,
  $$The constants \(a\) and \(b\) are positive.$$,
  'exact', $$$$, NULL,
  $$(i) \(y=\dfrac{1}{x-a}\) has asymptotes \(x=a\), \(y=0\); \(y=b|x-a|\) is a V with vertex \((a,0)\). They meet at \(\left(a+\dfrac{1}{\sqrt{b}},\ \sqrt{b}\right)\). (ii) \(\dfrac{1}{x-a}<b|x-a|\Rightarrow x>a+\dfrac{1}{\sqrt{b}}\) or \(x<a\).$$,
  6,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "i",  "prompt_latex": "On the same axes, sketch the graphs of \\(y=\\dfrac{1}{x-a}\\) and \\(y=b|x-a|\\), where \\(a\\) and \\(b\\) are positive constants.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii", "prompt_latex": "Hence, or otherwise, solve the inequality \\(\\dfrac{1}{x-a}<b|x-a|\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q4 (INTERMEDIATE) — modulus inequality, single clean interval answer. Single-answer question.
-- FLAG: solution is an interval — exact-match brittle, but single & clean, so enabled.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc215004-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Modulus inequality (analytic)$$,
  $$Use a non-graphical method to solve the inequality \(\left|\dfrac{2x-3}{x+5}\right|\le\dfrac{2}{3}\).$$,
  'exact',
  $$-\frac{1}{8}\le x\le \frac{19}{4}$$,
  NULL,
  $$Squaring: \(9(2x-3)^2\le 4(x+5)^2\Rightarrow 32x^2-140x+41\le 0\Rightarrow (8x+1)(4x-... )\); solving gives \(-\dfrac{1}{8}\le x\le \dfrac{19}{4}\).$$,
  4,
  'H2 Math Tutorial (Inequalities)'
);

-- Q5 (ADVANCED) — modulus inequality then "hence". (a) compound → null; (b) single → gradable (FLAG).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215005-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  3,
  $$Modulus inequality with substitution$$,
  $$Solve the inequalities below, using the first result to obtain the second.$$,
  'exact', $$x>\ln 0.5$$, NULL,
  $$(a) \(\left|\dfrac{x}{2}+3\right|>3-x^2\Rightarrow x>0\) or \(x<-0.5\). (b) Substituting \(x\to e^{x}\)-type reasoning gives \(x>\ln 0.5\).$$,
  6,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "a", "prompt_latex": "Solve \\(\\left|\\dfrac{x}{2}+3\\right|>3-x^2\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence solve \\(\\left|\\dfrac{e^{x}}{2}-3\\right|>3-e^{2x}\\).", "correct_answer": "x>\\ln 0.5", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q6 (ADVANCED) — range of k for positive-definite quadratic; deduce for k*(...). Both single intervals → gradable (FLAG).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215006-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  3,
  $$Inequalities and roots (range of k)$$,
  $$Consider the quadratic expression \(x^2+2kx+15-2k\).$$,
  'exact', $$-5<k<3$$, NULL,
  $$For \(x^2+2kx+15-2k>0\) for all real \(x\), the discriminant must be negative: \((2k)^2-4(15-2k)<0\Rightarrow k^2+2k-15<0\Rightarrow -5<k<3\). For \(k\left(x^2+2kx+15-2k\right)>0\) for all real \(x\), also require \(k>0\), giving \(0<k<3\).$$,
  6,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "a", "prompt_latex": "Find the range of values of \\(k\\) for which \\(x^2+2kx+15-2k>0\\) for all real \\(x\\).", "correct_answer": "-5<k<3", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Deduce the range of values of \\(k\\) for which \\(k\\left(x^2+2kx+15-2k\\right)>0\\) for all real \\(x\\).", "correct_answer": "0<k<3", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q7 (ADVANCED) — rational inequality then trig "hence". Both compound with surds → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc215007-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  3,
  $$Rational inequality & trigonometric application$$,
  $$Solve the inequalities below, using the first result to obtain the second.$$,
  'exact', $$$$, NULL,
  $$(a) \(\dfrac{3x-1}{1-2x^2}\ge 1\Rightarrow -2\le x<-\dfrac{1}{\sqrt{2}}\) or \(\dfrac{1}{2}\le x<\dfrac{1}{\sqrt{2}}\). (b) With \(x=\sin\theta\) and \(\cos 2\theta=1-2\sin^2\theta\): \(-\dfrac{\pi}{2}\le\theta<-\dfrac{\pi}{4}\) or \(\dfrac{\pi}{6}\le\theta<\dfrac{\pi}{4}\).$$,
  8,
  'H2 Math Tutorial (Inequalities)',
  $$[
  { "label": "a", "prompt_latex": "Without using a calculator, solve \\(\\dfrac{3x-1}{1-2x^2}\\ge 1\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the solution of \\(\\dfrac{3\\sin\\theta-1}{\\cos 2\\theta}\\ge 1\\), where \\(-\\dfrac{\\pi}{2}\\le\\theta\\le\\dfrac{\\pi}{2}\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);
