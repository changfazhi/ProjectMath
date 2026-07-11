-- Migration 039: H2 Math Tutorial — Conics (DISCUSSION only, 4 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/4. 2021 Conics (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user. IDs cc214001..cc214004. Topic aaaa0004.
-- Sketches → null (deferred solution_graph). Gradable: max distance (Q2), the b-range (Q3, FLAG'd), tunnel width (Q4).

-- Q1 (BASIC) — sketch five conics without a GC. All sketch → null (deferred solution_graph).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc214001-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  1,
  $$Sketching conics without a calculator$$,
  $$Sketch the following without the use of a graphic calculator, indicating clearly any intercepts, asymptotes, turning points and lines of symmetry.$$,
  'exact', $$$$, NULL,
  $$(a) ellipse \(\dfrac{x^2}{(r/a)^2}+\dfrac{y^2}{(r/b)^2}=1\). (b) hyperbola \(\dfrac{(x-1)^2}{4^2}-\dfrac{(y+1)^2}{2^2}=1\). (c) parabola \(y=\dfrac{x^2+x-2}{3}\). (d) ellipse \((x+2)^2+4(y-1)^2=4\). (e) hyperbola \(\dfrac{x^2}{1/4}-\dfrac{y^2}{1/36}=... \) (rewrite \(36y^2-4x^2=1\)).$$,
  10,
  'H2 Math Tutorial (Conics)',
  $$[
  { "label": "a", "prompt_latex": "\\(a^2x^2+b^2y^2=r^2,\\ a>b>0\\)",     "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(x^2-4y^2-2x-8y-39=0\\)",           "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(x^2+x-3y=2\\)",                    "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(x^2+4y^2+4x-8y+4=0\\)",           "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(36y^2=4x^2+1\\)",                 "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2 (BASIC) — sketch an ellipse; lines of symmetry [FLAG] + max distance [gradable].
-- FLAG: (ii) line-of-symmetry equations brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc214002-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  1,
  $$Ellipse: symmetry & maximum distance$$,
  $$Consider the curve \(4x^2+y^2+2y-3=0\).$$,
  'exact', $$8$$, NULL,
  $$Completing the square: \(4x^2+(y+1)^2=4\Rightarrow x^2+\dfrac{(y+1)^2}{4}=1\), an ellipse with centre \((0,-1)\), semi-axes 1 (horizontal) and 2 (vertical). Lines of symmetry: \(x=0\) and \(y=-1\). The point of the ellipse farthest from \((0,5)\) is \((0,-3)\), giving maximum distance \(5-(-3)=8\).$$,
  4,
  'H2 Math Tutorial (Conics)',
  $$[
  { "label": "i", "prompt_latex": "Sketch the curve \\(4x^2+y^2+2y-3=0\\).", "correct_answer": null, "answer_type": null, "tolerance": null },
  {
    "label": "ii",
    "prompt_latex": "Write down the equation(s) of its line(s) of symmetry.",
    "correct_answer": "x=0, y=-1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "l1", "label": "\\text{line}", "correct_answer": "x=0",  "answer_type": "exact", "tolerance": null },
      { "key": "l2", "label": "\\text{line}", "correct_answer": "y=-1", "answer_type": "exact", "tolerance": null }
    ]
  },
  { "label": "iii", "prompt_latex": "Find the maximum distance of the point \\((0,5)\\) to the curve.", "correct_answer": "8", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q3 (INTERMEDIATE) — sketch a reciprocal-product curve; deduce b-range for two intersections.
-- FLAG: (ii) single-bound inequality in terms of mu — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc214003-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  2,
  $$Curve sketch & ellipse intersection condition$$,
  $$Let \(y=\dfrac{2}{x(x-\mu)}\), where \(\mu\) is a positive constant.$$,
  'exact', $$b>\frac{64}{\mu^4}$$, NULL,
  $$(i) Vertical asymptotes \(x=0\) and \(x=\mu\); horizontal asymptote \(y=0\); turning point at \(x=\dfrac{\mu}{2}\), giving \(\left(\dfrac{\mu}{2},-\dfrac{8}{\mu^2}\right)\). (ii) With \(a=\dfrac{\mu}{2}\), the ellipse \(b(x-a)^2+a^2y^2=a^2b\) and the curve meet twice when \(b>\dfrac{64}{\mu^4}\).$$,
  6,
  'H2 Math Tutorial (Conics)',
  $$[
  { "label": "i", "prompt_latex": "Sketch the graph of \\(y=\\dfrac{2}{x(x-\\mu)}\\), indicating clearly any axial intercept(s), asymptote(s) and coordinates of turning point(s).", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "ii", "prompt_latex": "Given \\(a=\\dfrac{\\mu}{2}\\), deduce the range of values of \\(b\\) in terms of \\(\\mu\\) such that the graphs of \\(b(x-a)^2+a^2y^2=a^2b\\) and \\(y=\\dfrac{2}{x(x-\\mu)}\\) intersect twice, where \\(a\\) and \\(b\\) are positive real numbers.", "correct_answer": "b>\\frac{64}{\\mu^4}", "answer_type": "exact", "tolerance": null }
]$$::jsonb
);

-- Q4 (ADVANCED) — half-ellipse tunnel; equal-area rectangles; find width. Single numeric answer (diagram described in prose).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc214004-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  3,
  $$Half-ellipse tunnel width$$,
  $$A tunnel's cross-section is a half-ellipse with centre \(O\) at the midpoint of its base, full width \(MN\) and maximum height 2000 mm. Two rectangles are inscribed with their bases on \(MN\) and centred on \(O\). The inner rectangle \(ABCD\) has base \(AB=1000\) mm (the narrow track gauge) with top vertices \(C\) and \(D\) on the ellipse; the outer rectangle \(EFGH\) has base \(EF=1435\) mm (the international track gauge) with top vertices \(G\) and \(H\) on the ellipse. The areas of \(ABCD\) and \(EFGH\) are equal. Find the width \(MN\) of the tunnel, giving your answer to the nearest mm.$$,
  'range',
  $$1749$$,
  1,
  $$Take the ellipse as \(\dfrac{x^2}{A^2}+\dfrac{y^2}{2000^2}=1\) with \(A=\dfrac{MN}{2}\); the upper half is \(y=2000\sqrt{1-\dfrac{x^2}{A^2}}\). Rectangle \(ABCD\) has area \(1000\cdot y(500)\) and \(EFGH\) has area \(1435\cdot y(717.5)\). Setting them equal: \(1000\sqrt{1-\dfrac{500^2}{A^2}}=1435\sqrt{1-\dfrac{717.5^2}{A^2}}\). Solving gives \(A\approx 874.5\), so \(MN=2A\approx 1749\) mm.$$,
  6,
  'H2 Math Tutorial (Conics)'
);
