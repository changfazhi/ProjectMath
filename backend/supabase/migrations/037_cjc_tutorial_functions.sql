-- Migration 037: H2 Math Tutorial — Functions (DISCUSSION only, 7 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/2. 2021 Functions (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user. IDs cc212001..cc212007. Topic aaaa0002.
-- Gradable: inverse-function rules (FLAG'd), composite values, numeric answers. Sketches → null (deferred
-- solution_graph); "state range / does inverse exist / justify" prose → null.

-- Q1 (BASIC) — range, existence of inverse, inverse rule. Grade the inverse rule where it exists.
-- FLAG: (a) inverse-function rule — exact-match brittle. (b) no inverse → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212001-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  1,
  $$Range and existence of inverse$$,
  $$For each of the following functions: determine its range; state, with a reason, whether its inverse function exists; and if the inverse exists, find the rule and domain of the inverse function.$$,
  'exact', $$\cos^{-1}x-1$$, NULL,
  $$(a) \(R_h=[0,1]\). \(h\) is one-one on this domain, so \(h^{-1}\) exists: \(h^{-1}(x)=\cos^{-1}x-1\), \(0\le x\le 1\). (b) \(R_q=[-1,\infty)\). \(q\) is not one-one (it decreases then increases), so \(q^{-1}\) does not exist.$$,
  4,
  'H2 Math Tutorial (Functions)',
  $$[
  { "label": "a", "prompt_latex": "\\(h:x\\mapsto\\cos(x+1),\\ -1\\le x\\le -1+\\dfrac{\\pi}{2}\\)", "correct_answer": "\\cos^{-1}x-1", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "\\(q:x\\mapsto e^{x}(x-1),\\ x\\in\\mathbb{R}\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2 (INTERMEDIATE) — inverse of a shifted parabola; reflection line; solve f=f^{-1}.
-- FLAG: (ii) inverse rule brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212002-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Inverse function and reflection in y=x$$,
  $$The function \(f\) is defined by \(f:x\mapsto (x-4)^2+1\) for \(x\in\mathbb{R},\ x>4\).$$,
  'exact', $$\frac{9+\sqrt{13}}{2}$$, NULL,
  $$(ii) \(f^{-1}(x)=4+\sqrt{x-1}\), \(x>1\). (iv) The reflection line is \(y=x\). Since \(f\) is increasing, \(f(x)=f^{-1}(x)\) reduces to \(f(x)=x\): \((x-4)^2+1=x\Rightarrow x^2-9x+17=0\Rightarrow x=\dfrac{9+\sqrt{13}}{2}\) (taking \(x>4\)).$$,
  9,
  'H2 Math Tutorial (Functions)',
  $$[
  { "label": "i",   "prompt_latex": "Sketch the graph of \\(y=f(x)\\). Your sketch should indicate the position of the graph in relation to the origin.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "Find \\(f^{-1}(x)\\), stating the domain of \\(f^{-1}\\).", "correct_answer": "4+\\sqrt{x-1}", "answer_type": "exact", "tolerance": null },
  { "label": "iii", "prompt_latex": "On the same diagram as in part (i), sketch the graph of \\(y=f^{-1}(x)\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "Write down the equation of the line in which the graph of \\(y=f(x)\\) must be reflected to obtain \\(y=f^{-1}(x)\\), and hence find the exact solution of the equation \\(f(x)=f^{-1}(x)\\).", "correct_answer": "\\frac{9+\\sqrt{13}}{2}", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q3 (INTERMEDIATE) — restrict domain for inverse; composite existence & range.
-- FLAG: (ii) inverse rule brittle. (iv) exact range (interval) → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212003-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Restricted-domain inverse & composite range$$,
  $$The functions \(f\), \(g\) and \(h\) are defined by \[f:x\mapsto \left|x^2-6x+5\right|\ \text{ for } x\in\mathbb{R},\ 2\le x\le 6,\] \[g:x\mapsto \ln\!\left(x^2\right)\ \text{ for } x\in\mathbb{R},\ x\neq 0,\] \[h:x\mapsto \dfrac{1}{2-x}\ \text{ for } x\in\mathbb{R},\ x\le \tfrac{3}{2}.\]$$,
  'exact', $$3+\sqrt{4-x}$$, NULL,
  $$(i) On \([2,6]\), \(f\) folds at the root \(x=5\) and is not one-one. (ii) Longest interval \([3,5]\); there \(f(x)=4-(x-3)^2\), so \(f^{-1}(x)=3+\sqrt{4-x}\), \(0\le x\le 4\). (iii) \(R_h=(0,2]\subseteq \mathbb{R}\setminus\{0\}=D_g\), so \(gh\) exists. (iv) \(gh(x)=\ln(h^2)=2\ln h\) for \(h\in(0,2]\), giving \(R_{gh}=(-\infty,\ 2\ln 2]\).$$,
  8,
  'H2 Math Tutorial (Functions)',
  $$[
  { "label": "i",   "prompt_latex": "Give a reason why \\(f\\) does not have an inverse.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "State the longest possible interval in the domain of \\(f\\), to which the restriction of \\(f\\) would have an inverse. Hence, define \\(f^{-1}\\) in similar form for \\(f\\) restricted to this interval.", "correct_answer": "3+\\sqrt{4-x}", "answer_type": "exact", "tolerance": null },
  { "label": "iii", "prompt_latex": "Show that the composite function \\(gh\\) exists.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "Determine the exact range of the function \\(gh\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q4 (INTERMEDIATE) — self-inverse rational function.
-- FLAG: f^{-1} and the 2a/b solution are in terms of a,b — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212004-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Self-inverse function$$,
  $$The function \(f\) is defined by \(f:x\mapsto \dfrac{ax}{bx-a}\) for \(x\in\mathbb{R},\ x\neq \dfrac{a}{b}\), where \(a\) and \(b\) are non-zero constants.$$,
  'exact', $$x$$, NULL,
  $$(i) \(f^{-1}(x)=\dfrac{ax}{bx-a}\) (\(f\) is self-inverse), so \(f^2(x)=x\) for \(x\neq \dfrac{a}{b}\), and \(R_{f^2}=\left(-\infty,\dfrac{a}{b}\right)\cup\left(\dfrac{a}{b},\infty\right)\). (ii) \(R_g=\mathbb{R}\setminus\{0\}\) contains \(\dfrac{a}{b}\notin D_f\), so \(fg\) does not exist. (iii) \(\dfrac{ax}{bx-a}=x\Rightarrow bx^2-2ax=0\Rightarrow x=0\) or \(x=\dfrac{2a}{b}\).$$,
  7,
  'H2 Math Tutorial (Functions)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find \\(f^{-1}(x)\\). Hence, or otherwise, find \\(f^2(x)\\) and state the range of \\(f^2\\).",
    "correct_answer": "f^{-1}(x)=\\frac{ax}{bx-a}, f^2(x)=x",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "finv", "label": "f^{-1}(x)", "correct_answer": "\\frac{ax}{bx-a}", "answer_type": "exact", "tolerance": null },
      { "key": "fsq",  "label": "f^2(x)",    "correct_answer": "x",                "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii", "prompt_latex": "The function \\(g\\) is defined by \\(g:x\\mapsto \\dfrac{1}{x}\\) for all real non-zero \\(x\\). State whether the composite function \\(fg\\) exists, justifying your answer.", "correct_answer": null, "answer_type": null, "tolerance": null },
  {
    "label": "iii",
    "prompt_latex": "Solve the equation \\(f^{-1}(x)=x\\).",
    "correct_answer": "x=0 or x=\\frac{2a}{b}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "x1", "label": "x", "correct_answer": "0",           "answer_type": "exact", "tolerance": null },
      { "key": "x2", "label": "x", "correct_answer": "\\frac{2a}{b}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q5 (INTERMEDIATE) — piecewise periodic function; evaluate then sketch.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212005-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Piecewise periodic function$$,
  $$It is given that \[g(x)=\begin{cases}3, & 0<x\le 2\\ 5-x, & 2<x\le 4\end{cases}\] and that \(g(x)=g(x+4)\) for all real values of \(x\).$$,
  'exact', $$g(3)=2, g(8)=1, g(101)=3$$, NULL,
  $$Using period 4: \(g(3)=5-3=2\); \(g(8)=g(4)=5-4=1\); \(g(101)=g(1)=3\).$$,
  4,
  'H2 Math Tutorial (Functions)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find \\(g(3)\\), \\(g(8)\\) and \\(g(101)\\).",
    "correct_answer": "g(3)=2, g(8)=1, g(101)=3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "g3",   "label": "g(3)",   "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "g8",   "label": "g(8)",   "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "g101", "label": "g(101)", "correct_answer": "3", "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii", "prompt_latex": "Sketch the graph of \\(y=g(x)\\) for \\(-2<x\\le 8\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q6 (ADVANCED) — piecewise income-tax model; sketch/range/one-to-one (null) + two numeric answers.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212006-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Income-tax piecewise model$$,
  $$The income tax paid by a citizen in country S for any given year is based on his or her annual income for that year, modelled by the function \(f\) on domain \([0,\infty)\): \[f(x)=\begin{cases}0 & 0\le x\le 2\\ 2(x-2) & 2<x\le 3\\ 2+4(x-3) & 3<x\le 4\\ 6+7(x-4) & 4<x\le 8\\ 34+11(x-8) & x>8\end{cases}\] The annual income \(x\) (in tens of thousands of dollars) has corresponding income tax \(f(x)\) (in hundreds of dollars). For example, an annual income of \$40\,000 gives income tax \(\$100\times f(4)=\$600\).$$,
  'exact', $$Annual income \$75000; tax increase 74.6\%$$, NULL,
  $$(i) Range \([0,\infty)\); the graph is a continuous, increasing, piecewise-linear curve. (ii) \(f\) is one-to-one (strictly increasing), but the constant piece on \([0,2]\) means it is not one-to-one there — hence overall \(f\) is not one-to-one. (iii) Tax \$3050 \(\Rightarrow f(x)=30.5\); on \(4<x\le 8\), \(6+7(x-4)=30.5\Rightarrow x=7.5\), i.e. \$75\,000. (iv) 2017 income \(=1.3\times 7.5=9.75\) (\(>8\)): \(f(9.75)=34+11(1.75)=53.25\), i.e. \$5325. Percentage increase \(=\dfrac{5325-3050}{3050}\times100\%=74.6\%\).$$,
  9,
  'H2 Math Tutorial (Functions)',
  $$[
  { "label": "i",   "prompt_latex": "Sketch the graph of \\(y=f(x)\\) and state the range of \\(f\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "State whether \\(f\\) is a one-to-one function, justifying your answer. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "Mrs A's income tax for the year 2016 was \\$3050. Find her annual income in 2016 (in dollars). \\([2]\\)", "correct_answer": "75000", "answer_type": "range", "tolerance": 1 },
  { "label": "iv",  "prompt_latex": "At the start of 2017, Mrs A received a pay raise so that her annual income for 2017 is projected to increase by 30% from 2016. Calculate the percentage increase in her income tax for 2017 (give the percentage). \\([3]\\)", "correct_answer": "74.6", "answer_type": "range", "tolerance": 0.1 }
]$$::jsonb
);

-- Q7 (ADVANCED) — (a) inverse & fixed point; (b) recursively-defined function. Two-level labels.
-- FLAG: (a)(i) inverse rule brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc212007-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Inverse fixed point & a recursive function$$,
  $$$$,
  'exact', $$(x-1)^2$$, NULL,
  $$(a)(i) \(f^{-1}(x)=(x-1)^2\), \(x\ge 1\). (a)(ii) \(ff(x)=x\Rightarrow x^3-4x^2+4x-1=0\); the relevant root is \(x\approx 2.62\). Since a fixed point of \(ff\) lying on \(y=x\) also lies on both \(f\) and \(f^{-1}\), it satisfies \(f(x)=f^{-1}(x)\). (b)(i) \(g(4)=6\), \(g(7)=8\), \(g(12)=9\). (b)(ii) \(g\) is not one-to-one (e.g. different inputs share a value), so its inverse does not exist.$$,
  10,
  'H2 Math Tutorial (Functions)',
  $$[
  { "label": "ai",  "prompt_latex": "The function \\(f\\) is given by \\(f:x\\mapsto 1+\\sqrt{x}\\), for \\(x\\in\\mathbb{R},\\ x\\ge 0\\). Find \\(f^{-1}(x)\\) and state the domain of \\(f^{-1}\\).", "correct_answer": "(x-1)^2", "answer_type": "exact", "tolerance": null },
  { "label": "aii", "prompt_latex": "Show that if \\(ff(x)=x\\) then \\(x^3-4x^2+4x-1=0\\). Hence find the value of \\(x\\) for which \\(ff(x)=x\\), and explain why this value satisfies the equation \\(f(x)=f^{-1}(x)\\).", "correct_answer": "2.62", "answer_type": "range", "tolerance": 0.005 },
  { "label": "bi",  "prompt_latex": "The function \\(g\\), with domain the set of non-negative integers, is given by \\[g(n)=\\begin{cases}1 & n=0\\\\ 2+g\\left(\\tfrac{1}{2}n\\right) & n\\text{ even}\\\\ 1+g(n-1) & n\\text{ odd}\\end{cases}\\] Find \\(g(4)\\), \\(g(7)\\) and \\(g(12)\\).", "correct_answer": "g(4)=6, g(7)=8, g(12)=9", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "g4",  "label": "g(4)",  "correct_answer": "6", "answer_type": "exact", "tolerance": null },
      { "key": "g7",  "label": "g(7)",  "correct_answer": "8", "answer_type": "exact", "tolerance": null },
      { "key": "g12", "label": "g(12)", "correct_answer": "9", "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "bii", "prompt_latex": "Does \\(g\\) have an inverse? Justify your answer.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);
