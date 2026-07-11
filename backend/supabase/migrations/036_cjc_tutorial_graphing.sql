-- Migration 036: H2 Math Tutorial — Graphing Techniques (DISCUSSION only, 9 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/1. 2021 Graphing Techniques (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user. IDs cc211001..cc211009. Topic aaaa0001.
-- Graphing topic → many parts are sketch (null; deferred solution_graph) or domain/range answers
-- (inequalities → brittle for exact-match → left null per skills.md default). Gradable boxes: asymptote
-- equations (FLAG'd), the a/b constants in Q8, and the real-root count in Q8(v).

-- Q1 (BASIC) — determine odd/even. Parity classification is not cleanly MathLive-typeable → all parts null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211001-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  1,
  $$Odd or even functions$$,
  $$Determine whether each of the following functions is odd or even, justifying your answer.$$,
  'exact', $$$$, NULL,
  $$(i) \(f(-x)=\dfrac{x^4+3x^2+2}{x^6-1}=f(x)\): even. (ii) \(g(-x)=-3x^3-5x=-g(x)\): odd. (iii) \(\csc(-x)=-\csc x\): odd.$$,
  3,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "i",  "prompt_latex": "\\(f(x)=\\dfrac{x^4+3x^2+2}{x^6-1}\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii", "prompt_latex": "\\(g(x)=3x^3+5x\\)",                       "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii","prompt_latex": "\\(h(x)=\\csc x\\)",                        "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2 (BASIC) — state symmetry (prose). Single ungraded task → one null part.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211002-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  1,
  $$Symmetry of a curve$$,
  $$The curve has equation \(y^4=x^2+5\).$$,
  'exact', $$$$, NULL,
  $$The equation is unchanged when \(x\to -x\) and when \(y\to -y\), so the graph is symmetric about both the \(y\)-axis and the \(x\)-axis, and hence about the origin.$$,
  2,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "a", "prompt_latex": "State the symmetry of the graph of \\(y^4=x^2+5\\), showing your working clearly.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q3 (BASIC) — maximal range of x and y (domains/ranges are inequalities → brittle → null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211003-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  1,
  $$Maximal possible domain and range$$,
  $$For each of the following functions, state, with a reason, the maximal possible range of values of \(x\) and of \(y\).$$,
  'exact', $$$$, NULL,
  $$(a) \(y=\dfrac{1}{x^2+1}\): \(x\in\mathbb{R}\); since \(x^2+1\ge 1\), \(0<y\le 1\). (b) \(y=-e^{x-3}\): \(x\in\mathbb{R}\); since \(e^{x-3}>0\), \(y<0\).$$,
  3,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "a", "prompt_latex": "\\(y=\\dfrac{1}{x^2+1}\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(y=-e^{x-3}\\)",         "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q4 (INTERMEDIATE) — sketch five graphs. All sketch → null; deferred solution_graph each.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211004-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Sketching graphs: intercepts, asymptotes, turning points$$,
  $$Sketch the graph represented by each of the following equations, clearly indicating the equations of any asymptote(s), axial intercept(s), the coordinates of the turning point(s), and any restriction on the range of values of \(x\) and \(y\). (Exact values are not required.)$$,
  'exact', $$$$, NULL,
  $$(a) axial intercept \((0,15)\), min. pt. \((0.5,14.75)\). (b) axial intercepts \((0,-2),(2.46,0)\), max. pt. \((0.107,-1.95)\), min. pt. \((1.56,-5.02)\). (c) axial intercept/min. pt. \((0,0)\), max. pt. \((-2.00,2.17)\), asymptote \(y=0\). (d) infinitely many \(x\)-intercepts at odd multiples of \(\tfrac{\pi}{4}\); asymptotes \(x=0\), \(y=0\). (e) axial intercept \((1,0)\), asymptote \(x=0\), max. pt. \((2.72,0.184)\).$$,
  10,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "a", "prompt_latex": "\\(y=x^2-x+15\\)",              "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(y=2x^3-5x^2+x-2\\)",         "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(y=4x^2 e^{x}\\)",            "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(y=\\dfrac{5\\cos 2x}{x}\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(y=\\dfrac{\\ln x}{2x}\\)",   "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q5 (INTERMEDIATE) — sketch a rational family for two parameter cases + a discussion. All null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211005-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Rational curve family: parameter cases$$,
  $$Sketch the graphs of \(y=\dfrac{ax+1}{x-b}\), where the constants \(a\) and \(b\) are given below. You should indicate the important characteristics of each graph clearly in your diagrams.$$,
  'exact', $$$$, NULL,
  $$In both cases the asymptotes are \(x=b\) and \(y=a\), with axial intercepts \(\left(0,-\dfrac{1}{b}\right)\) and \(\left(-\dfrac{1}{a},0\right)\) (the graphs in (i) and (ii) are different in shape). If \(ab+1=0\) then \(ax+1=a(x-b)\), so \(y=a\) for all \(x\neq b\): the graph degenerates to the horizontal line \(y=a\) with a hole at \(x=b\).$$,
  6,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "i",   "prompt_latex": "\\(-1<a<0\\) and \\(0<b<1\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii",  "prompt_latex": "\\(a<-1\\) and \\(b>1\\).",     "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "What could be said about the graph if \\(ab+1=0\\)?", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q6 (INTERMEDIATE) — rational curve; (i) asymptotes [gradable], (ii) sketch, (iii) range of k.
-- FLAG: (i) asymptote equations — exact-match brittle. (iii) range of k (inequality) → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211006-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Rational curve, asymptotes & no-real-roots$$,
  $$The curve \(C\) has equation \(y=\dfrac{x^2}{x-2}\).$$,
  'exact', $$y=x+2, x=2$$, NULL,
  $$(i) By long division \(y=x+2+\dfrac{4}{x-2}\), so the asymptotes are \(y=x+2\) (oblique) and \(x=2\) (vertical). (ii) Axial intercept and max. pt. at \((0,0)\); min. pt. at \((4,8)\). (iii) \(x^2=k(x^2-4)\Rightarrow (k-1)x^2-4k=0\); analysing for no real roots gives \(0<k\le 1\).$$,
  6,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the equation(s) of the asymptote(s) of \\(C\\).",
    "correct_answer": "y=x+2, x=2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "obl",  "label": "\\text{oblique}",  "correct_answer": "y=x+2", "answer_type": "exact", "tolerance": null },
      { "key": "vert", "label": "\\text{vertical}", "correct_answer": "x=2",   "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii",  "prompt_latex": "Sketch the curve \\(C\\), labelling the equation(s) of its asymptote(s) and the coordinates of any axial intercepts and turning points.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "Hence find the range of values of \\(k\\) for which the equation \\(x^2=k\\left(x^2-4\\right)\\) has no real roots.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q7 (INTERMEDIATE) — rational curve; (i) asymptotes [gradable], (ii) range of k (surds) null, (iii) sketch.
-- FLAG: (i) asymptote equations brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211007-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Rational curve, asymptotes & no-real-roots (surd range)$$,
  $$The curve \(C\) has equation \(y=\dfrac{x^2+9x+16}{x+2}\).$$,
  'exact', $$y=x+7, x=-2$$, NULL,
  $$(i) \(y=x+7+\dfrac{2}{x+2}\), so the asymptotes are \(y=x+7\) (oblique) and \(x=-2\) (vertical). (ii) \(k(x+2)=x^2+9x+16\Rightarrow x^2+(9-k)x+(16-2k)=0\); no real roots when discriminant \(<0\), giving \(5-2\sqrt2<k<5+2\sqrt2\). (iii) min. pt. \((-0.586,7.83)\), max. pt. \((-3.41,2.17)\); axial intercepts \((0,8),(-6.56,0),(-2.44,0)\).$$,
  7,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the equations of the asymptotes of \\(C\\).",
    "correct_answer": "y=x+7, x=-2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "obl",  "label": "\\text{oblique}",  "correct_answer": "y=x+7", "answer_type": "exact", "tolerance": null },
      { "key": "vert", "label": "\\text{vertical}", "correct_answer": "x=-2",  "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii",  "prompt_latex": "Find, leaving your answers in exact form, the range of values of \\(k\\) for which the equation \\(k=\\dfrac{x^2+9x+16}{x+2}\\) has no real roots.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iii", "prompt_latex": "Sketch \\(C\\), showing the equations of the asymptotes, the coordinates of the stationary points, and the coordinates of the points of intersection of \\(C\\) with the \\(x\\)- and \\(y\\)-axes.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q8 (ADVANCED) — work backwards for a,b; other asymptote; range y can't take; sketch; count real roots.
-- FLAG: (ii) asymptote equation brittle. (iii) range of y → null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211008-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  $$Determine a, b from asymptote & stationary point$$,
  $$The curve \(C\) has equation \(y=\dfrac{x^2+ax+4}{x+b}\). It is given that \(C\) has a vertical asymptote \(x=-1\) and a stationary point at \(x=2\).$$,
  'exact', $$a=-4, b=1$$, NULL,
  $$(i) Vertical asymptote \(x=-1\Rightarrow b=1\). With \(b=1\), the stationary condition at \(x=2\) gives \(a=-4\). (ii) \(y=x-5+\dfrac{9}{x+1}\), so the other (oblique) asymptote is \(y=x-5\). (iii) For real \(x\), the range of \(y\) excludes \(-12<y<0\), i.e. \(y\) cannot take values in \(\{y\in\mathbb{R}:-12<y<0\}\). (iv) max. pt. \((-4,-12)\), min. pt. \((2,0)\); axial intercepts \((0,4),(2,0)\). (v) The equation \(\left(4-x^2\right)(x+1)^2=\left(x^2-4x+4\right)^2\) has 2 real roots.$$,
  10,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Determine the values of \\(a\\) and \\(b\\).",
    "correct_answer": "a=-4, b=1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-4", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "1",  "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "ii",  "prompt_latex": "Find the equation of the other asymptote of \\(C\\).", "correct_answer": "y=x-5", "answer_type": "exact", "tolerance": null },
  { "label": "iii", "prompt_latex": "Find, without using a calculator, the set of values that \\(y\\) cannot take.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "iv",  "prompt_latex": "Sketch \\(C\\), showing clearly any axial intercepts, asymptotes and stationary points.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "v",   "prompt_latex": "Deduce the number of real roots of the equation \\(\\left(4-x^2\\right)(x+1)^2=\\left(x^2-4x+4\\right)^2\\).", "correct_answer": "2", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q9 (ADVANCED) — differentiation to find a-range (null); sketch (null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc211009-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  $$No stationary points & sketch of a rational curve$$,
  $$The curve \(D\) has equation \(y=\dfrac{2x^2+ax+3a}{x-2}\), where \(a\) is a non-zero constant and \(a>-4\).$$,
  'exact', $$$$, NULL,
  $$(i) Differentiating and requiring the numerator of \(\dfrac{dy}{dx}\) to have no real roots (so \(D\) has no stationary points) gives \(a<-1.6\) (with \(a>-4\)). (ii) For \(a=-3\): asymptotes \(x=2\) and \(y=2x+1\); the curve crosses the axes as found from \(\dfrac{2x^2-3x-9}{x-2}\).$$,
  6,
  'H2 Math Tutorial (Graphing Techniques)',
  $$[
  { "label": "i",  "prompt_latex": "By differentiation, find the range of values of \\(a\\) for which \\(D\\) has no stationary points.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii", "prompt_latex": "Given that \\(a=-3\\), sketch \\(D\\), giving the equations of the asymptotes and the coordinates of the points of intersection with the axes.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);
