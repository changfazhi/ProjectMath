-- Migration 038: H2 Math Tutorial — Transformations (DISCUSSION only, 9 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/3. 2021 Transformations (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user. IDs cc213001..cc213009. Topic aaaa0003.
-- Transformation topic → most parts are "sketch" or "describe the transformation" → null (sketches get a
-- deferred solution_graph; descriptions are prose). Gradable: partial-fraction constants, asymptote
-- equations (FLAG'd), and the reversed original-curve equation (FLAG'd).

-- Q1 (BASIC) — describe the sequence of transformations. Prose → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213001-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  1,
  $$Sequence of transformations of 1/x$$,
  $$The graph of \(y=\dfrac{2}{3x-1}\) is to be obtained from \(y=\dfrac{1}{x}\) by a sequence of transformations.$$,
  'exact', $$$$, NULL,
  $$Write \(\dfrac{2}{3x-1}=\dfrac{2}{3\left(x-\frac{1}{3}\right)}\). Translate \(y=\dfrac{1}{x}\) by 1 unit in the positive \(x\)-direction (to \(\dfrac{1}{x-1}\)); scale parallel to the \(x\)-axis by factor \(\dfrac{1}{3}\); scale parallel to the \(y\)-axis by factor 2.$$,
  2,
  'H2 Math Tutorial (Transformations)',
  $$[
  { "label": "a", "prompt_latex": "Explain how the graph of \\(y=\\dfrac{2}{3x-1}\\) may be obtained from \\(y=\\dfrac{1}{x}\\) by a sequence of appropriate transformations.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2 (INTERMEDIATE) — transform a given curve four ways. All sketch → null (deferred solution_graph).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213002-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Transforming a given curve$$,
  $$The diagram shows the curve \(y=f(x)+3\). It has a maximum point at \((-1,5)\), a horizontal asymptote \(y=1\), and passes through \((0,3)\). Sketch, on separate diagrams, each of the following, indicating clearly the asymptote, turning point and intercepts where possible.$$,
  'exact', $$$$, NULL,
  $$Base curve \(y=f(x)\): asymptote \(y=-2\), max. \((-1,2)\), passes \((0,0)\). (i) \(y=f(x)\): as above. (ii) \(y=-f(x)+3\): asymptote \(y=5\), min. \((-1,1)\), \((0,3)\). (iii) \(y=f(-x+3)\): asymptote \(y=-2\), max. \((4,2)\), \((3,0)\). (iv) \(y=f(2x+1)\): asymptote \(y=-2\), max. \((-1,2)\), \((-0.5,0)\).$$,
  8,
  'H2 Math Tutorial (Transformations)',
  $$[
  { "label": "i",   "prompt_latex": "\\(y=f(x)\\)",       "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "\\(y=-f(x)+3\\)",    "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "\\(y=f(-x+3)\\)",    "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "\\(y=f(2x+1)\\)",    "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q3 (INTERMEDIATE) — work backwards for k,l,m; sketch reciprocal.
-- FLAG: (i) constants in terms of a,b,c — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213003-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Quartic transformation & reciprocal sketch$$,
  $$The curve \(y=x^4\) is transformed onto the curve \(y=f(x)\). The turning point \((0,0)\) on \(y=x^4\) corresponds to the point \((a,b)\) on \(y=f(x)\), and \(y=f(x)\) also passes through the point \((0,c)\). It is given that \(f(x)\) has the form \(k(x-l)^4+m\), where \(a\), \(b\) and \(c\) are positive constants with \(c>b\).$$,
  'exact', $$l=a, m=b, k=\frac{c-b}{a^4}$$, NULL,
  $$The turning point shift gives \(l=a\) and \(m=b\), so \(f(x)=k(x-a)^4+b\). Since \(y=f(x)\) passes through \((0,c)\): \(c=k a^4+b\Rightarrow k=\dfrac{c-b}{a^4}\).$$,
  6,
  'H2 Math Tutorial (Transformations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Express \\(k\\), \\(l\\) and \\(m\\) in terms of \\(a\\), \\(b\\) and \\(c\\).",
    "correct_answer": "l=a, m=b, k=(c-b)/a^4",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "k", "label": "k", "correct_answer": "\\frac{c-b}{a^4}", "answer_type": "exact", "tolerance": null },
      { "key": "l", "label": "l", "correct_answer": "a",               "answer_type": "exact", "tolerance": null },
      { "key": "m", "label": "m", "correct_answer": "b",               "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii", "prompt_latex": "By sketching \\(y=f(x)\\), or otherwise, sketch \\(y=\\dfrac{1}{f(x)}\\). State, in terms of \\(a\\), \\(b\\) and \\(c\\), the coordinates of any points where \\(y=\\dfrac{1}{f(x)}\\) crosses the axes and of any turning points.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q4 (INTERMEDIATE) — reverse a sequence of transformations to recover the original curve. Single answer.
-- FLAG: cartesian equation answer — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc213004-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Recover original curve from transformations$$,
  $$The curve \(y=f(x)\) undergoes, in succession, the following transformations: A: a translation of 4 units in the positive \(x\)-direction; B: a reflection in the \(y\)-axis; C: a stretch with scale factor 2 parallel to the \(x\)-axis. The equation of the resulting curve is \(y=\dfrac{x-1}{x+1}\). Obtain the equation of the original curve \(y=f(x)\).$$,
  'exact',
  $$\frac{2x+9}{2x+7}$$,
  NULL,
  $$Reversing C, then B, then A on \(y=\dfrac{x-1}{x+1}\): undo C by \(x\to 2x\), undo B by \(x\to -x\), undo A by \(x\to x+4\). This gives \(y=f(x)=\dfrac{2x+9}{2x+7}\).$$,
  4,
  'H2 Math Tutorial (Transformations)'
);

-- Q5 (INTERMEDIATE) — rational curve; asymptotes [gradable], cuts/stationary (coords → null), modulus sketches.
-- FLAG: (i) asymptote equations brittle. (ii)/(iii) coordinates → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213005-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Rational curve & modulus transformations$$,
  $$The curve has equation \(y=\dfrac{2x-x^2}{x^2-2x-3}\).$$,
  'exact', $$x=3, x=-1, y=-1$$, NULL,
  $$Denominator \((x-3)(x+1)\Rightarrow\) vertical asymptotes \(x=3\), \(x=-1\); equal degrees \(\Rightarrow\) horizontal asymptote \(y=-1\). (ii) Cuts axes at \((0,0)\) and \((2,0)\). (iii) Stationary point \(\left(1,-\dfrac{1}{4}\right)\). The two modulus graphs follow by reflecting parts of the sketch: \(y=\left|\cdot\right|\) reflects negative \(y\) upward; \(y\) with \(|x|\) mirrors the \(x\ge 0\) part into \(x<0\).$$,
  8,
  'H2 Math Tutorial (Transformations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the equations of the asymptotes of the curve.",
    "correct_answer": "x=3, x=-1, y=-1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "v1", "label": "\\text{vertical}", "correct_answer": "x=3",  "answer_type": "exact", "tolerance": null },
      { "key": "v2", "label": "\\text{vertical}", "correct_answer": "x=-1", "answer_type": "exact", "tolerance": null },
      { "key": "h",  "label": "\\text{horizontal}", "correct_answer": "y=-1", "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii",  "prompt_latex": "Find where the curve cuts the axes.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "Find the stationary point of the curve.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "Hence sketch the graph of \\(y\\), and use it to obtain the graphs of \\(y=\\left|\\dfrac{2x-x^2}{x^2-2x-3}\\right|\\) and \\(y=\\dfrac{2|x|-x^2}{x^2-2|x|-3}\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q6 (INTERMEDIATE) — reciprocal graphs of three given curves. Pure sketch → null (deferred solution_graph).
-- FLAG: source curves are hand-drawn in the PDF; the descriptions below are approximate reconstructions.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213006-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Reciprocal graphs$$,
  $$For each given graph of \(y=f(x)\), sketch on a separate diagram the graph of \(y=\dfrac{1}{f(x)}\).$$,
  'exact', $$$$, NULL,
  $$In each case, use the reciprocal rules: zeros of \(f\) become vertical asymptotes of \(\dfrac{1}{f}\); vertical asymptotes of \(f\) become zeros; a maximum of \(f\) above the \(x\)-axis becomes a minimum of \(\dfrac{1}{f}\) (and vice versa); \(y\)-values are inverted.$$,
  6,
  'H2 Math Tutorial (Transformations)',
  $$[
  { "label": "a", "prompt_latex": "\\(y=f(x)\\) is the upward parabola through \\((0,2)\\), \\((1,0)\\) and \\((2,0)\\) with minimum point \\(\\left(\\tfrac{3}{2},-\\tfrac{1}{4}\\right)\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(y=f(x)\\) is a rational curve with vertical asymptote \\(x=-1\\) and horizontal asymptote \\(y=-1\\), passing through \\((0,1)\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(y=f(x)\\) is a decreasing curve with vertical asymptote \\(x=-1\\) and an oblique asymptote, passing through \\(\\left(-\\tfrac{5}{2},0\\right)\\) and \\((0,2)\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q7 (INTERMEDIATE) — partial fractions; asymptotes; sketch f and |1/f|.
-- FLAG: (ii) asymptote equations brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213007-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Partial fractions, asymptotes & reciprocal modulus$$,
  $$The curve \(C\) has equation \(f(x)=\dfrac{(x-9)^2}{(x-3)(x+3)}\).$$,
  'exact', $$P=1, Q=6, R=-24$$, NULL,
  $$(i) \(f(x)=1+\dfrac{6}{x-3}-\dfrac{24}{x+3}\), so \(P=1\), \(Q=6\), \(R=-24\). (ii) Asymptotes \(y=1\), \(x=3\), \(x=-3\); \(C\) cuts the axes at \((9,0)\) and \((0,-9)\).$$,
  9,
  'H2 Math Tutorial (Transformations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Express \\(f(x)\\) in the form \\(P+\\dfrac{Q}{x-3}+\\dfrac{R}{x+3}\\).",
    "correct_answer": "P=1, Q=6, R=-24",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "P", "label": "P", "correct_answer": "1",   "answer_type": "exact", "tolerance": null },
      { "key": "Q", "label": "Q", "correct_answer": "6",   "answer_type": "exact", "tolerance": null },
      { "key": "R", "label": "R", "correct_answer": "-24", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "State the equations of all the asymptotes of \\(C\\) and the coordinates of the points where \\(C\\) cuts the axes.",
    "correct_answer": "y=1, x=3, x=-3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "h",  "label": "\\text{horizontal}", "correct_answer": "y=1",  "answer_type": "exact", "tolerance": null },
      { "key": "v1", "label": "\\text{vertical}",   "correct_answer": "x=3",  "answer_type": "exact", "tolerance": null },
      { "key": "v2", "label": "\\text{vertical}",   "correct_answer": "x=-3", "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "iii", "prompt_latex": "Sketch on separate diagrams (a) \\(y=f(x)\\) and (b) \\(y=\\left|\\dfrac{1}{f(x)}\\right|\\), making clear the main relevant features of each curve.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q8 (ADVANCED) — work backwards from y=f(3-x/2). All sketch → null (deferred solution_graph).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213008-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  3,
  $$Working backwards from a transformed curve$$,
  $$The graph of \(y=f\!\left(3-\dfrac{x}{2}\right)\) has 2 stationary points at \((8,-2)\) and \((14,2)\), intersects the \(x\)-axis at \(x=6\), \(x=10\) and \(x=18\), and has a horizontal asymptote \(y=-4\).$$,
  'exact', $$$$, NULL,
  $$(a) \(y=\dfrac{1}{f\left(3-\frac{x}{2}\right)}\): asymptotes \(x=6,\ x=10,\ x=18,\ y=-\dfrac{1}{4},\ y=0\); stationary max. \(\left(8,-\dfrac{1}{2}\right)\), min. \(\left(14,\dfrac{1}{2}\right)\); axial intercept \((0,0)\). (b) \(y=f(x)\): asymptotes \(x=3,\ y=-4\); stationary max. \((-4,2)\), min. \((-1,-2)\); axial intercepts \((-6,0),(-2,0),(0,0)\).$$,
  8,
  'H2 Math Tutorial (Transformations)',
  $$[
  { "label": "a", "prompt_latex": "Sketch \\(y=\\dfrac{1}{f\\left(3-\\frac{x}{2}\\right)}\\), showing clearly the asymptotes, stationary points and points of intersection with the axes.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Sketch \\(y=f(x)\\), showing clearly the asymptotes, stationary points and points of intersection with the axes.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q9 (ADVANCED) — describe transformation (null) + sketch a piecewise function twice (null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc213009-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  3,
  $$Transformation & piecewise-function sketches$$,
  $$A curve has equation \(y=f(x)\), where \[f(x)=\begin{cases}1 & 0\le x\le 1\\ \tfrac{1}{4}(x-3)^2 & 1<x\le 3\\ 0 & \text{otherwise.}\end{cases}\]$$,
  'exact', $$$$, NULL,
  $$(i) A translation of 3 units in the positive \(x\)-direction, followed by a scaling parallel to the \(y\)-axis by factor \(\dfrac{1}{4}\) (or the two in reverse order). (ii)/(iii) Sketch the piecewise curve, then apply the horizontal scale \(x\to\frac{1}{2}x\) and vertical shift \(+1\) for \(y=1+f\left(\tfrac{1}{2}x\right)\).$$,
  8,
  'H2 Math Tutorial (Transformations)',
  $$[
  { "label": "i",   "prompt_latex": "State a sequence of transformations that will transform the curve \\(y=x^2\\) onto the curve \\(y=\\tfrac{1}{4}(x-3)^2\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "Sketch the curve \\(y=f(x)\\) for \\(-1\\le x\\le 4\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "On a separate diagram, sketch the curve \\(y=1+f\\left(\\tfrac{1}{2}x\\right)\\), for \\(-1\\le x\\le 4\\).", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);
