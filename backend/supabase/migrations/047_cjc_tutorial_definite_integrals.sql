-- Migration 047: CJC 2022 JC2 H2 Math Tutorial — Definite Integrals (DISCUSSION only, 9 questions kept of 11)
-- Source: TUTORIAL/CALCULUS/4.5 Definite Integrals Lecture Notes + solutions.pdf, DISCUSSION section (pp.33-36).
-- REVIEW PROBLEMS excluded. Answers verified against the tutorial answer key (p.36).
-- EXCLUDED per user request:
--   * Q7 [x=θ-sinθ, y=1-cosθ; find area bounded by C and the x-axis] — finding area parametrically.
--   * Q9 [∫|cos(x/2)cos x| dx] — evaluating it needs a product-to-sum factor formula (dropped with 046 Q2(l)).
--   Both ID slots (cc21b007, cc21b009) are intentionally left unused so remaining IDs track source Q numbers.
-- Provenance stripped: source 'H2 Math Tutorial (Definite Integrals)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'b' (file 4.5) + 3-digit Q# -> cc21b001..cc21b00b (007, 009 skipped). Topic aaaa0016.
-- Q4(i) sketch (concrete piecewise-periodic) -> solution_graph deferred to a later migration.
-- FLAG: exact surd/fraction/parametric-form answers and ranges are brittle to exact-match (skills.md option 2).

-- Q1: formulate (do not evaluate) definite-integral expressions. All expressions -> ungraded (null parts).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b001-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  1,
  $$Formulating area and volume integrals$$,
  $$For each of the following, formulate and write down a definite integral expression (without evaluating it). In diagram (a) the region is bounded above by \(y=\sqrt[3]{x}\), below by \(y=\dfrac{1}{x}\), and on the right by \(x=8\), the two curves meeting at \((1,1)\). In diagram (b) the region between \(y=e^x\) (above) and \(y=xe^{x^2}\) (below) runs from \(x=0\) to their intersection at \((1,e)\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a)(i) Area \(=\displaystyle\int_1^8\left(\sqrt[3]{x}-\dfrac{1}{x}\right)dx\). (a)(ii) Volume about the \(x\)-axis \(=\pi\displaystyle\int_1^8\left[\left(\sqrt[3]{x}\right)^2-\left(\dfrac{1}{x}\right)^2\right]dx\). (b)(i) Area \(=\displaystyle\int_0^1\left(e^x-xe^{x^2}\right)dx\). (b)(ii) Volume about the \(x\)-axis \(=\pi\displaystyle\int_0^1\left[\left(e^x\right)^2-\left(xe^{x^2}\right)^2\right]dx\).$$,
  4,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  { "label": "ai", "prompt_latex": "(a) Write down a definite integral for the area of the shaded region.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "aii", "prompt_latex": "(a) Write down a definite integral for the volume of the solid of revolution formed when the shaded region is fully rotated about the \\(x\\)-axis.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bi", "prompt_latex": "(b) Write down a definite integral for the area of the shaded region.", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bii", "prompt_latex": "(b) Write down a definite integral for the volume of the solid of revolution formed when the shaded region is fully rotated about the \\(x\\)-axis.", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q2: partial-fraction definite integral in the form a ln b + c tan^-1 d (multi-box).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b002-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Definite integral via partial fractions$$,
  $$Using partial fractions, find \(\displaystyle\int_0^2\dfrac{9x^2+x-13}{(2x-5)(x^2+9)}\,dx\). Give your answer in the form \(a\ln b+c\tan^{-1}d\), where \(a,b,c\) and \(d\) are rational numbers to be determined.$$,
  'exact',
  $$a=3/2, b=13/45, c=8/3, d=2/3$$,
  NULL,
  $$\(\dfrac{9x^2+x-13}{(2x-5)(x^2+9)}=\dfrac{3}{2x-5}+\dfrac{3x+8}{x^2+9}\). Integrating from \(0\) to \(2\): \(\left[\dfrac{3}{2}\ln|2x-5|+\dfrac{3}{2}\ln(x^2+9)+\dfrac{8}{3}\tan^{-1}\dfrac{x}{3}\right]_0^2=\dfrac{3}{2}\ln\dfrac{13}{45}+\dfrac{8}{3}\tan^{-1}\dfrac{2}{3}\). So \(a=\dfrac32,\ b=\dfrac{13}{45},\ c=\dfrac83,\ d=\dfrac23\).$$,
  6,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the values of \\(a\\), \\(b\\), \\(c\\) and \\(d\\).",
    "correct_answer": "a=3/2, b=13/45, c=8/3, d=2/3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "\\frac{3}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "\\frac{13}{45}", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "\\frac{8}{3}", "answer_type": "exact", "tolerance": null },
      { "key": "d", "label": "d", "correct_answer": "\\frac{2}{3}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q3: (a) find p (FLAG); (b) modulus definite integral in terms of k (FLAG).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b003-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Definite integrals: parameter and modulus$$,
  $$Answer the following.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\displaystyle\int_0^1\dfrac{1}{4-x^2}\,dx=\dfrac{1}{4}\ln 3\) and \(\displaystyle\int_0^{\frac{1}{2p}}\dfrac{1}{\sqrt{1-p^2x^2}}\,dx=\dfrac{1}{p}\sin^{-1}\dfrac{1}{2}=\dfrac{\pi}{6p}\). Equating: \(\dfrac{1}{4}\ln 3=\dfrac{\pi}{6p}\Rightarrow p=\dfrac{2\pi}{3\ln 3}\). (b) \(x^2-5x+6=(x-2)(x-3)\); for \(k>3\), \(\displaystyle\int_0^k|x^2-5x+6|\,dx=\int_0^2(\cdots)-\int_2^3(\cdots)+\int_3^k(\cdots)=\dfrac{k^3}{3}-\dfrac{5k^2}{2}+6k+\dfrac{1}{3}\).$$,
  6,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the exact value of \\(p\\) such that \\(\\displaystyle\\int_0^1\\dfrac{1}{4-x^2}\\,dx=\\int_0^{\\frac{1}{2p}}\\dfrac{1}{\\sqrt{1-p^2x^2}}\\,dx\\).",
    "correct_answer": "\\frac{2\\pi}{3\\ln 3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(\\displaystyle\\int_0^k\\left|x^2-5x+6\\right|\\,dx\\), \\(k>3\\), giving your answer in terms of \\(k\\).",
    "correct_answer": "\\frac{k^3}{3}-\\frac{5k^2}{2}+6k+\\frac{1}{3}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q4: piecewise periodic function. (i) sketch (graph deferred); (ii) definite integral.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b004-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Definite integral of a periodic piecewise function$$,
  $$It is given that \(f(x)=\begin{cases} xe^x & 0<x\le 1,\\ e(2-x) & 1<x\le 2,\end{cases}\) and that \(f(x)=f(x+2)\) for all real values of \(x\).$$,
  'exact',
  $$2+e$$,
  NULL,
  $$(i) The graph on \((0,2]\) rises as \(xe^x\) to \((1,e)\), then falls linearly along \(e(2-x)\) to \((2,0)\); it repeats with period \(2\). (ii) Over one period, \(\displaystyle\int_0^2 f(x)\,dx=\int_0^1 xe^x\,dx+\int_1^2 e(2-x)\,dx=\left[(x-1)e^x\right]_0^1+e\left[2x-\tfrac{x^2}{2}\right]_1^2=1+\dfrac{e}{2}\). The interval \([-1,3]\) has length \(4=2\) periods, so \(\displaystyle\int_{-1}^{3}f(x)\,dx=2\int_0^2 f(x)\,dx=2\left(1+\dfrac{e}{2}\right)=2+e\).$$,
  5,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Sketch the graph of \\(y=f(x)\\) for \\(-2<x\\le 4\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the exact value of \\(\\displaystyle\\int_{-1}^{3}f(x)\\,dx\\).",
    "correct_answer": "2+e",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q5: by parts vs substitution. (a) graded value; (b) derivative (FLAG) then same integral.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b005-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Definite integral by parts and by substitution$$,
  $$The use of a graphing calculator is not allowed in this question.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) By parts, \(\displaystyle\int_0^1 x\tan^{-1}x\,dx=\left[\dfrac{x^2}{2}\tan^{-1}x\right]_0^1-\dfrac12\int_0^1\dfrac{x^2}{1+x^2}\,dx=\dfrac{\pi}{8}-\dfrac12\left[x-\tan^{-1}x\right]_0^1=\dfrac{\pi}{4}-\dfrac{1}{2}\). (b) \(\dfrac{d}{d\theta}(\tan^2\theta)=2\tan\theta\sec^2\theta\). With \(\theta=\tan^{-1}x\), \(x=\tan\theta\), \(dx=\sec^2\theta\,d\theta\), and the integral becomes \(\displaystyle\int_0^{\pi/4}\theta\cdot 2\tan\theta\sec^2\theta\,d\theta\)... which evaluates to the same value \(\dfrac{\pi}{4}-\dfrac{1}{2}\).$$,
  6,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "By using integration by parts, find \\(\\displaystyle\\int_0^1 x\\tan^{-1}x\\,dx\\).",
    "correct_answer": "\\frac{\\pi}{4}-\\frac{1}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(\\dfrac{d}{d\\theta}\\left(\\tan^2\\theta\\right)\\). Hence use the substitution \\(\\theta=\\tan^{-1}x\\) to evaluate \\(\\displaystyle\\int_0^1 x\\tan^{-1}x\\,dx\\).",
    "correct_answer": "2\\tan\\theta\\sec^2\\theta",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q6: single-answer volume about a vertical line.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc21b006-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Volume of revolution about a vertical line$$,
  $$Find the exact volume generated when the area enclosed between \(y^2=x\) and \(x=1\) is rotated about the line \(x=1\) through \(2\pi\) radians.$$,
  'exact',
  $$\frac{16\pi}{15}$$,
  NULL,
  $$Using discs perpendicular to the axis \(x=1\): the radius at height \(y\) is \(1-x=1-y^2\), with \(-1\le y\le1\). Volume \(=\pi\displaystyle\int_{-1}^{1}(1-y^2)^2\,dy=2\pi\int_0^1(1-2y^2+y^4)\,dy=2\pi\left[y-\dfrac{2y^3}{3}+\dfrac{y^5}{5}\right]_0^1=2\pi\cdot\dfrac{8}{15}=\dfrac{16\pi}{15}\).$$,
  4,
  'H2 Math Tutorial (Definite Integrals)'
);

-- Q7 EXCLUDED (parametric area). ID cc21b007 intentionally unused.

-- Q8: Riemann sum. (a) show; (b) deduce definite integral; (c) explain underestimate.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b008-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Definite integral as the limit of a sum$$,
  $$The graph of \(y=x^3+1\) from \(x=0\) to \(x=1\) is approximated by the total area \(A\) of \(n\) rectangles, each of width \(\dfrac{1}{n}\), whose heights are taken at the left endpoints. It is given that \(\displaystyle\sum_{r=1}^{n}r^3=\left[\dfrac{n(n+1)}{2}\right]^2\).$$,
  'exact',
  $$\frac{5}{4}$$,
  NULL,
  $$(a) \(A=\displaystyle\sum_{r=1}^{n}\dfrac{1}{n}\left[\left(\dfrac{r-1}{n}\right)^3+1\right]\); using \(\sum r^3\) and simplifying gives \(A=1+\dfrac{1}{4}\left(1-\dfrac{1}{n}\right)^2\) (shown). (b) As \(n\to\infty\), \(A\to 1+\dfrac{1}{4}=\dfrac{5}{4}\), so \(\displaystyle\int_0^1(x^3+1)\,dx=\dfrac{5}{4}\). (c) Since \(y=x^3+1\) is increasing on \([0,1]\), each left-endpoint rectangle lies below the curve, so the total rectangle area underestimates the exact area.$$,
  6,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(A=1+\\dfrac{1}{4}\\left(1-\\dfrac{1}{n}\\right)^2\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence deduce the exact value of \\(\\displaystyle\\int_0^1 (x^3+1)\\,dx\\).",
    "correct_answer": "\\frac{5}{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Explain why the total area of the rectangles is less than the actual area under the curve.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q9 EXCLUDED per user request (product-to-sum factor formula): the modulus definite integral of
--   cos(x/2)cos x requires a product-to-sum step to evaluate, so it is dropped alongside 046 Q2(l).
--   ID cc21b009 intentionally left unused so remaining IDs still track source Q numbers.

-- Q10 (ADVANCED): area & volume via trig substitution. (a) show; (i) area; (ii) volume.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b00a-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Area and volume with a trig substitution$$,
  $$The diagram shows the region \(A\) bounded by the curve \(y=x^2\) and a minor arc of the circle \(x^2+y^2=12\) (in the first two quadrants, symmetric about the \(y\)-axis).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Using \(x=\sqrt{12}\cos\theta\), \(\displaystyle\int_0^{\sqrt3}\sqrt{12-x^2}\,dx=\pi+\dfrac{3\sqrt3}{2}\) (shown). The curve and circle meet where \(x^2+x^4=12\Rightarrow x^2=3\Rightarrow x=\pm\sqrt3\) (so \(y=3\)). (i) By symmetry, area \(A=2\left[\displaystyle\int_0^{\sqrt3}\sqrt{12-x^2}\,dx-\int_0^{\sqrt3}x^2\,dx\right]=2\left[\left(\pi+\dfrac{3\sqrt3}{2}\right)-\sqrt3\right]=2\pi+\sqrt3\). (ii) Rotating about the \(y\)-axis through \(\pi\) (half turn), the parabola contributes \(x^2=y\) and the circle \(x^2=12-y^2\): \(V=\dfrac{\pi}{2}\left[\displaystyle\int_0^3 y\,dy+\int_3^{\sqrt{12}}(12-y^2)\,dy\right]=\pi\left(16\sqrt3-\dfrac{45}{2}\right)\).$$,
  9,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "By using the substitution \\(x=\\sqrt{12}\\cos\\theta\\), show that \\(\\displaystyle\\int_0^{\\sqrt3}\\sqrt{12-x^2}\\,dx=\\pi+\\dfrac{3\\sqrt3}{2}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "i",
    "prompt_latex": "Find the exact area of region \\(A\\).",
    "correct_answer": "2\\pi+\\sqrt{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the exact volume of the solid of revolution formed when region \\(A\\) is rotated through \\(\\pi\\) radians about the \\(y\\)-axis.",
    "correct_answer": "\\pi\\left(16\\sqrt{3}-\\frac{45}{2}\\right)",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q11 (ADVANCED): area & volume, 3 d.p. (both graded, range).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21b00b-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Area and volume bounded by lines and a curve$$,
  $$The diagram shows the shaded region \(R\) bounded by the lines \(y=2x\), \(y=\dfrac{3}{2}\), the \(x\)-axis and the curve \(y=\sqrt{\dfrac{3x^2-1}{x^2}}\). Give your answers correct to 3 decimal places.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$The line \(y=2x\) meets \(y=\tfrac32\) at \(x=\tfrac34\); the curve \(y=\sqrt{\tfrac{3x^2-1}{x^2}}\) has \(x\)-intercept at \(x=\tfrac{1}{\sqrt3}\) and meets \(y=\tfrac32\) at \(x=\tfrac{2}{\sqrt3}\). (a) Area of \(R\approx 0.485\) units\(^2\). (b) Volume when \(R\) is rotated through \(2\pi\) about the \(x\)-axis \(\approx 1.907\) units\(^3\).$$,
  7,
  'H2 Math Tutorial (Definite Integrals)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the area of region \\(R\\).",
    "correct_answer": "0.485",
    "answer_type": "range",
    "tolerance": 0.001
  },
  {
    "label": "b",
    "prompt_latex": "Find the volume of the solid generated when \\(R\\) is rotated through \\(2\\pi\\) about the \\(x\\)-axis.",
    "correct_answer": "1.907",
    "answer_type": "range",
    "tolerance": 0.001
  }
]$$::jsonb
);
