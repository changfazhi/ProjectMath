-- Migration 014: HCI H2 Math (9758) Prelim 2025 — Paper 1 (Q1–Q13) + Paper 2 (Q1–Q10)
-- UUIDs: c0250001–c025000d (P1), c0251001–c025100a (P2). All hex valid.
-- Source: 'HCI H2 Math Prelim 2025', difficulty: 3
-- Questions table already has GRANT ALL from earlier migrations (no new table here).

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 — App. of Differentiation — strictly decreasing (single ungraded set answer; wrapped as one null part)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250001-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Strictly decreasing interval of a rational curve',
  $$A curve has equation \(y = x + 1 + \dfrac{3}{x-1}\).$$,
  'exact', '', null,
  $$\(y = x + 1 + 3(x-1)^{-1}\), so \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = 1 - \dfrac{3}{(x-1)^2}\).
Strictly decreasing requires \(\dfrac{\mathrm{d}y}{\mathrm{d}x} < 0\):
\[1 - \dfrac{3}{(x-1)^2} < 0 \implies (x-1)^2 < 3 \implies 1-\sqrt{3} < x < 1+\sqrt{3},\ x \neq 1.\]
Set of values: \(\{x \in \mathbb{R} : 1-\sqrt{3} < x < 1 \ \text{or}\ 1 < x < 1+\sqrt{3}\}\).$$,
  4, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using differentiation, find the set of values of \\(x\\) where the curve is strictly decreasing. Give your answers in exact form. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q2 — Sequences & Series — recurrence with (-3)^n term
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Recurrence relation: find constants then later terms',
  $$A sequence of real numbers \(x_n\) satisfies the recurrence relation \(x_{n+1} = a(-3)^n + bn^2 + cx_n\), for \(n,a,b,c \in \mathbb{Z}\) and \(n \geq 1\). It is given that \(x_1 = 1,\ x_2 = -8,\ x_3 = 70\) and \(x_4 = -377\).$$,
  'exact', '', null,
  $$Forming equations from \(x_2,x_3,x_4\):
\[-8 = -3a + b + c,\quad 70 = 9a + 4b - 8c,\quad -377 = -27a + 9b + 70c.\]
Solving (by GC): \(a = 2,\ b = 3,\ c = -5\), so \(x_{n+1} = 2(-3)^n + 3n^2 - 5x_n\).
Iterating with the GC: \(x_{10} = -7\,210\,868\) and \(x_{11} = 36\,172\,738\).$$,
  5, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the values of \\(x_{10}\\) and \\(x_{11}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q3 — Differential Equations — substitution u = xy^2
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250003-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'ODE via substitution u = xy^2',
  $$It is given that \(\left(2xy\dfrac{\mathrm{d}y}{\mathrm{d}x} + y^2\right)\cos x = \dfrac{1}{xy^2}\), where \(0 < x < \dfrac{\pi}{2}\) and \(y \neq 0\).$$,
  'exact', '', null,
  $$(a) With \(u = xy^2\), \(\dfrac{\mathrm{d}u}{\mathrm{d}x} = y^2 + 2xy\dfrac{\mathrm{d}y}{\mathrm{d}x}\). The equation becomes \(\dfrac{\mathrm{d}u}{\mathrm{d}x}\cos x = \dfrac{1}{u}\), i.e. \(\dfrac{\mathrm{d}u}{\mathrm{d}x} = \dfrac{\sec x}{u}\). (shown)

(b) Separating: \(\displaystyle\int u\,\mathrm{d}u = \int \sec x\,\mathrm{d}x\), so \(\dfrac{u^2}{2} = \ln|\sec x + \tan x| + C\). Since \(\sec x, \tan x > 0\) on \((0,\tfrac{\pi}{2})\), \(x^2y^4 = 2\ln(\sec x + \tan x) + A\).$$,
  6, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using the substitution \\(u = xy^2\\), show that the differential equation can be reduced to \\(\\dfrac{\\mathrm{d}u}{\\mathrm{d}x} = \\dfrac{\\sec x}{u}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the general solution to the differential equation. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q4 — Definite Integral — Riemann sums and a limit
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250004-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Riemann sum estimate and limit as an integral',
  $$The function \(\mathrm{f}(x) = \mathrm{e}^{3x} + 1\), for \(0 \leq x \leq 1\). The region \(A\) bounded by the curve and the lines \(y = 0\), \(x = 0\) and \(x = 1\) is split into 5 vertical strips of equal width \(h\).$$,
  'exact', '\frac{e^3}{3}+\frac{2}{3}', null,
  $$(a) \(h = \dfrac{1}{5}\). The heights \(\mathrm{f}(kh)\) are taken at the right edge of each strip; since \(\mathrm{f}\) is increasing, each rectangle lies above the curve, so \(\displaystyle\sum_{k=1}^{5} h\,\mathrm{f}(kh)\) (the sum of 5 rectangles) is greater than the area of \(A\).

(b) As \(n \to \infty\) the sum is \(\displaystyle\int_0^1 (\mathrm{e}^{3x} + 1)\,\mathrm{d}x = \left[\dfrac{\mathrm{e}^{3x}}{3} + x\right]_0^1 = \dfrac{\mathrm{e}^3}{3} + 1 - \dfrac{1}{3} = \dfrac{\mathrm{e}^3}{3} + \dfrac{2}{3}.\)$$,
  6, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "State the value of \\(h\\) and, using a suitable sketch, explain whether \\(\\displaystyle\\sum_{k=1}^{5} \\bigl(h\\,\\mathrm{f}(kh)\\bigr)\\) is less or more than the area of \\(A\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "\\(A\\) is now split into \\(n\\) vertical strips of equal width. Using calculus, find the exact value of \\(\\displaystyle\\lim_{n\\to\\infty}\\dfrac{1}{n}\\left(\\mathrm{e}^{3/n} + \\mathrm{e}^{6/n} + \\mathrm{e}^{9/n} + \\cdots + \\mathrm{e}^{(3n-3)/n} + \\mathrm{e}^{3} + n\\right)\\). \\([3]\\)",
      "correct_answer": "\\frac{e^3}{3}+\\frac{2}{3}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q5 — App. of Differentiation — tram track optimisation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250005-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Maximise travel time on a circular-then-straight track',
  $$A tram runs along a circular path of centre \(O\) and radius 450 m from a fixed point \(A\) to a variable point \(B\), then straight to a fixed point \(C\). The angle \(AOB = \theta\), where \(0 \leq \theta \leq \pi\). The speed along the arc is 8 m/s and along \(BC\) is \(\sqrt{6}\) m/s. (\(C\) lies so that \(B\hat{O}C = 2\theta\) and \(BC = 900\cos\theta\)... per the diagram, \(\angle OBC\) is a semicircle angle.)$$,
  'range', '6.41', 0.005,
  $$(a) Arc \(AB = 450\theta\), time \(= \dfrac{450\theta}{8} = \dfrac{225\theta}{4}\). With \(BC = 900\cos\dfrac{\theta}{2}\), time along \(BC = \dfrac{900\cos(\theta/2)}{\sqrt{6}} = 150\sqrt{6}\cos\dfrac{\theta}{2}\). Total \(T = \dfrac{225\theta}{4} + 150\sqrt{6}\cos\dfrac{\theta}{2}\). (shown)

(b) \(\dfrac{\mathrm{d}T}{\mathrm{d}\theta} = \dfrac{225}{4} - 75\sqrt{6}\sin\dfrac{\theta}{2} = 0 \implies \sin\dfrac{\theta}{2} = \dfrac{3}{4\sqrt{6}} \implies \theta = 0.62237\).
\(T = \dfrac{225(0.62237)}{4} + 150\sqrt{6}\cos(0.31118) = 384.78\) s \(= 6.41\) minutes (3 s.f.).$$,
  6, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the time taken for the tram to travel from \\(A\\) to \\(C\\) is \\(\\dfrac{225}{4}\\theta + 150\\sqrt{6}\\cos\\dfrac{\\theta}{2}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Use calculus to find the maximum time taken for the tram to travel from \\(A\\) to \\(C\\), giving your answer in minutes to 3 significant figures. (You need not show that your answer gives a maximum.) \\([3]\\)",
      "correct_answer": "6.41",
      "answer_type": "range",
      "tolerance": 0.005
    }
  ]$$::jsonb
);

-- P1 Q6 — Transformation — transformations and a reciprocal sketch
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250006-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  3,
  'Transformations of a parabola and reciprocal sketch',
  $$Given that \(b\) is a real constant with \(0 < b < 4\).$$,
  'exact', '', null,
  $$(a) \(y = 4x^2 + bx + 1 = 4\left(x + \dfrac{b}{8}\right)^2 + 1 - \dfrac{b^2}{16}\). From \(y = x^2\): (1) translate \(\dfrac{b}{8}\) in the negative \(x\)-direction; (2) scale parallel to the \(y\)-axis by factor 4; (3) translate \(1 - \dfrac{b^2}{16}\) in the positive \(y\)-direction.

(b) For \(y = \dfrac{1}{4x^2 + bx + 1}\): since \(0 < b < 4\) the discriminant \(b^2 - 16 < 0\), so the denominator has no real zeros and is always positive — no vertical asymptotes; horizontal asymptote \(y = 0\). \(y\)-intercept \((0,1)\); no \(x\)-intercepts; maximum turning point at \(\left(-\dfrac{b}{8},\ \dfrac{16}{16-b^2}\right)\).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Describe fully a sequence of transformations that transforms the curve \\(y = x^2\\) to the curve \\(y = 4x^2 + bx + 1\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch the curve \\(y = \\dfrac{1}{4x^2 + bx + 1}\\), giving the equation of any asymptotes and the coordinates of any axial intercepts and turning points, in terms of \\(b\\) where appropriate. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q7 — Sequences & Series — series involving e and factorials
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250007-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Infinite series with factorials summing to e',
  $$Series involving \(\mathrm{e}\) and factorials.$$,
  'exact', '2e-\frac{217}{40}', null,
  $$(a) From MF27, \(\mathrm{e}^x = \displaystyle\sum_{r=0}^{\infty}\dfrac{x^r}{r!}\). Putting \(x = 1\) gives \(\displaystyle\sum_{r=0}^{\infty}\dfrac{1}{r!} = \mathrm{e}\).

(b) \(\displaystyle\sum_{r=0}^{\infty}\dfrac{r+1}{r!} = \sum_{r=0}^{\infty}\dfrac{r}{r!} + \sum_{r=0}^{\infty}\dfrac{1}{r!} = \sum_{r=1}^{\infty}\dfrac{1}{(r-1)!} + \mathrm{e} = \mathrm{e} + \mathrm{e} = 2\mathrm{e}\). (shown)

(c) \(\displaystyle\sum_{r=6}^{\infty}\dfrac{r+1}{r!} = 2\mathrm{e} - \sum_{r=0}^{5}\dfrac{r+1}{r!} = 2\mathrm{e} - \dfrac{217}{40}\).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Use the formula listed in the List of Formulae (MF27) to explain why \\(\\displaystyle\\sum_{r=0}^{\\infty}\\dfrac{1}{r!} = \\mathrm{e}\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that \\(\\displaystyle\\sum_{r=0}^{\\infty}\\dfrac{r+1}{r!} = 2\\mathrm{e}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the value, in terms of \\(\\mathrm{e}\\), of \\(\\displaystyle\\sum_{r=6}^{\\infty}\\dfrac{r+1}{r!}\\). \\([3]\\)",
      "correct_answer": "2e-\\frac{217}{40}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q8 — Functions — self-inverse function and composition
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250008-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Self-inverse rational function and composition',
  $$The function \(\mathrm{f}\) is defined by \(\mathrm{f}: x \mapsto \dfrac{ax-3}{5x-4}\), for \(x \in \mathbb{R},\ x \neq \dfrac{4}{5}\), and \(a \in \mathbb{R}\). It is given that \(\mathrm{f}(x) = \mathrm{f}^{-1}(x)\) for all \(x\) in the domain of \(\mathrm{f}\). Another function \(\mathrm{g}\) is defined by \(\mathrm{g}: x \mapsto \left(x - \dfrac{1}{5}\right)^2 + \dfrac{2}{5}\), for \(x \in \mathbb{R},\ 0 < x < \dfrac{3}{5}\).$$,
  'exact', '', null,
  $$(a) Horizontal asymptote \(y = \dfrac{a}{5}\), so \(R_{\mathrm{f}} = \mathbb{R} \setminus \left\{\dfrac{a}{5}\right\}\).

(b) \(\mathrm{f} = \mathrm{f}^{-1}\) requires the function to be self-inverse: \(a = 4\).

(c) Since \(\mathrm{f} = \mathrm{f}^{-1}\), \(\mathrm{f}^2(x) = x\), so \(\mathrm{f}^{2025} = \mathrm{f}\). Hence \(\mathrm{f}^{2025}(2) = \mathrm{f}(2) = \dfrac{4(2)-3}{5(2)-4} = \dfrac{5}{6}\).

(d) For \(0 < x < \dfrac{3}{5}\), \(R_{\mathrm{g}} = \left[\dfrac{2}{5}, \dfrac{14}{25}\right)\); applying \(\mathrm{f}\), \(R_{\mathrm{fg}} = \left[\dfrac{19}{30}, \dfrac{7}{10}\right)\).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the range of \\(\\mathrm{f}\\) in terms of \\(a\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the value of \\(a\\). \\([2]\\)",
      "correct_answer": "4",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Hence find \\(\\mathrm{f}^{2025}(2)\\). \\([2]\\)",
      "correct_answer": "\\frac{5}{6}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Find the range of \\(\\mathrm{fg}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q9 — Integration Technique — integration by parts and a modulus integral
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0250009-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  'Integration by parts and a modulus definite integral',
  $$Integration of \((2x-1)\cos x\).$$,
  'exact', '', null,
  $$(a) By parts: \(\displaystyle\int (2x-1)\cos x\,\mathrm{d}x = (2x-1)\sin x - \int 2\sin x\,\mathrm{d}x = (2x-1)\sin x + 2\cos x + C\).

(b) On \(\left[0, \tfrac{1}{2}\right]\), \(|2x-1| = 1-2x\); on \(\left[\tfrac{1}{2}, \tfrac{\pi}{2}\right]\), \(|2x-1| = 2x-1\). Let \(F(x) = (2x-1)\sin x + 2\cos x\). Then
\[\int_0^{\pi/2} |2x-1|\cos x\,\mathrm{d}x = \bigl[-F(x)\bigr]_0^{1/2} + \bigl[F(x)\bigr]_{1/2}^{\pi/2} = (2 - 2\cos\tfrac{1}{2}) + (\pi - 1 - 2\cos\tfrac{1}{2}) = \pi + 1 - 4\cos\tfrac{1}{2}.\]
So \(A = \pi + 1\), \(B = \dfrac{1}{2}\).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find \\(\\displaystyle\\int (2x-1)\\cos x\\,\\mathrm{d}x\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the value of \\(\\displaystyle\\int_0^{\\pi/2} |2x-1|\\cos x\\,\\mathrm{d}x\\). Give your answer in the form \\(A - 4\\cos B\\), where \\(A\\) and \\(B\\) are exact constants to be determined. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q10 — Differential Equations — logistic population model
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c025000a-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Logistic bird-population differential equation',
  $$A population of birds \(Q\) at time \(t\) years has birth rate proportional to \(Q\) and death rate proportional to \(Q^2\). Initially \(Q = 1000\), and the population is unchanged when \(Q = 500\).$$,
  'exact', '', null,
  $$(a) \(\dfrac{1}{Q(500-Q)} = \dfrac{1}{500}\left(\dfrac{1}{Q} + \dfrac{1}{500-Q}\right)\).

(b)(i) \(\dfrac{\mathrm{d}Q}{\mathrm{d}t} = aQ - bQ^2\); at \(Q = 500\), \(\dfrac{\mathrm{d}Q}{\mathrm{d}t} = 0 \Rightarrow a = 500b\). Hence \(\dfrac{\mathrm{d}Q}{\mathrm{d}t} = bQ(500-Q) = kQ(500-Q)\) with \(k = b > 0\). (shown)

(b)(ii) \(\displaystyle\int \dfrac{\mathrm{d}Q}{Q(500-Q)} = \int k\,\mathrm{d}t \Rightarrow \dfrac{1}{500}\ln\left|\dfrac{Q}{500-Q}\right| = kt + C\). So \(\dfrac{Q}{500-Q} = H\mathrm{e}^{500kt}\); using \(Q(0) = 1000\) gives \(H = -2\). Hence \(Q = \dfrac{1000\mathrm{e}^{500kt}}{2\mathrm{e}^{500kt} - 1}\).$$,
  9, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Express \\(\\dfrac{1}{Q(500-Q)}\\) in partial fractions. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "Show that the differential equation relating \\(Q\\) and \\(t\\) is \\(\\dfrac{\\mathrm{d}Q}{\\mathrm{d}t} = kQ(500-Q)\\), where \\(k\\) is a positive constant. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Hence solve the differential equation, expressing \\(Q\\) in terms of \\(k\\) and \\(t\\). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q11 — Vector (Plane) — perpendicular lines, plane and foot of perpendicular
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c025000b-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Perpendicular lines, plane, and foot of perpendicular',
  $$Points \(A(15,3,0)\) and \(B(5,9,5)\). Perpendicular lines \(l_1: \mathbf{r} = (15-\lambda)\mathbf{i} + (3+2\lambda)\mathbf{j} + 4\lambda\mathbf{k}\) and \(l_2: \mathbf{r} = (5+8\mu)\mathbf{i} + (9-2\mu)\mathbf{j} + (5+m\mu)\mathbf{k}\), where \(\lambda,\mu\) are parameters and \(m\) is a constant.$$,
  'exact', '74\pi', null,
  $$(a) Directions \(\mathbf{d}_1 = (-1,2,4)\), \(\mathbf{d}_2 = (8,-2,m)\). Perpendicular: \(-8 - 4 + 4m = 0 \Rightarrow m = 3\).

(b) Solving \(l_1 = l_2\): \(\lambda = 2,\ \mu = 1\), giving \(E(13,7,8)\).

(c) \(\overrightarrow{AB} = (-10,6,5)\), \(\overrightarrow{AE} = (-2,4,8)\); normal \(\overrightarrow{AB}\times\overrightarrow{AE} = (28,70,-28) = 14(2,5,-2)\). Plane: \(2x + 5y - 2z = 45\).

(d) Foot \(F\) on the line through \(D(-1,-3,2)\) with direction \((2,5,-2)\): \(F = (3,7,-2)\).

(e) \(\angle DFA = 90^\circ\), so \(AD\) is a diameter; \(|AD|^2 = 16^2 + 6^2 + 2^2 = 296\), radius\(^2 = 74\). Area \(= 74\pi\) units\(^2\).$$,
  12, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the value of \\(m\\). \\([2]\\)",
      "correct_answer": "3",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Given that \\(l_1\\) and \\(l_2\\) intersect, find the coordinates of the point of intersection \\(E\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find a cartesian equation of the plane \\(\\Pi\\) which contains the points \\(A\\), \\(B\\) and \\(E\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "The point \\(D\\) has coordinates \\((-1,-3,2)\\). Find the position vector of the point \\(F\\), the foot of perpendicular of \\(D\\) to \\(\\Pi\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Find the exact area of the circle that passes through \\(A\\), \\(D\\) and \\(F\\). \\([2]\\)",
      "correct_answer": "74\\pi",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q12 — Complex Number — quartic with real coefficients
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c025000c-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  'Quartic complex equation z^4 - 6z^2 + k = 0',
  $$Do not use a graphing calculator for this question. It is given that \(\mathrm{f}(z) = z^4 - 6z^2 + k\), where \(k\) is a non-zero constant.$$,
  'exact', '25', null,
  $$(a) If a real root \(x\) existed, \(x^4 - 6x^2 = -k\): the LHS is real but \(-k\) is purely imaginary — contradiction. So \(\mathrm{f}(z)=0\) has no real roots.

(b) \(\mathrm{f}(-z) = (-z)^4 - 6(-z)^2 + k = z^4 - 6z^2 + k = \mathrm{f}(z)\).

(c) \((2+\mathrm{i})^2 = 3 + 4\mathrm{i}\), \((2+\mathrm{i})^4 = -7 + 24\mathrm{i}\). Then \(\mathrm{f}(2+\mathrm{i}) = -7 + 24\mathrm{i} - 6(3+4\mathrm{i}) + k = k - 25 = 0 \Rightarrow k = 25\). Real coefficients give the conjugate root \(2-\mathrm{i}\); since \(\mathrm{f}(-z)=\mathrm{f}(z)\), \(-2-\mathrm{i}\) and \(-2+\mathrm{i}\) are also roots. Remaining roots: \(2-\mathrm{i},\ -2-\mathrm{i},\ -2+\mathrm{i}\).

(d) Product of all roots \(D = (2+\mathrm{i})(2-\mathrm{i})(-2-\mathrm{i})(-2+\mathrm{i}) = 5 \times 5 = 25\).

(e) \(kw^4 - 6w^2 + 1 = 0\) with \(w = \dfrac{1}{z}\); taking \(z = 2+\mathrm{i}\), \(w_1 = \dfrac{1}{2+\mathrm{i}} = \dfrac{2-\mathrm{i}}{5}\).$$,
  12, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "If \\(k\\) is a purely imaginary number, determine, with justification, whether \\(\\mathrm{f}(z) = 0\\) can have real roots. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that \\(\\mathrm{f}(-z) = \\mathrm{f}(z)\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Given that \\(2+\\mathrm{i}\\) is a root of \\(\\mathrm{f}(z) = 0\\), determine \\(k\\). Hence, or otherwise, find the remaining roots, showing your working clearly. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Using the value of \\(k\\) found in part (c): given that the product of all the roots of \\(\\mathrm{f}(z) = 0\\) is \\(D\\), find the value of \\(D\\), showing your working clearly. \\([2]\\)",
      "correct_answer": "25",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "A complex number \\(w_1\\) satisfies \\(kw^4 - 6w^2 + 1 = 0\\). Given that \\(w_1\\) can be obtained from \\(2+\\mathrm{i}\\), find \\(w_1\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q13 — Sequences & Series — followers recurrence model
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c025000d-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Social-media followers recurrence model',
  $$Frederick starts an account. From the second month, organic followers at month end are \(a\) times the previous month-end total (\(a > 0\)), plus 1000 additional followers mid-month. \(F(n)\) is the total followers at the end of \(n\) months. He has 3500 followers at the end of the first month.$$,
  'exact', '', null,
  $$(a) \(F(n+1) = aF(n) + 1000\).

(b) \(F(1) = 3500\); \(F(3) = aF(2) + 1000 = a(aF(1) + 1000) + 1000 = 3500a^2 + 1000a + 1000\). (shown)

(c) \(F(n) = 3500a^{n-1} + 1000\dfrac{a^{n-1}-1}{a-1}\). With \(a = 1.5\), solving \(F(n) > 1\,000\,000\) by GC gives \(n = 14\) months.

(d) \(F(12) = 3500a^{11} + 1000\dfrac{a^{11}-1}{a-1} > 20000\) gives \(a > 1.05\) (3 s.f.).

(e) With additional \(b\): \(F(n+1) = aF(n) + b\). Constant from month 1 \(\Rightarrow F(1) = aF(1) + b \Rightarrow b = F(1)(1-a) = 3500(1-a)\).$$,
  12, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Write down a recurrence relationship between \\(F(n)\\) and \\(F(n+1)\\) for \\(n \\in \\mathbb{Z}^+\\), giving your answer in terms of \\(a\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that \\(F(3) = 3500a^2 + 1000a + 1000\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find an expression for \\(F(n)\\). Hence find the number of months required for Frederick's followers to exceed one million if \\(a = 1.5\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Given that the number of followers exceeds 20000 by the end of the first year, determine the range of values of \\(a\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Instead of 1000, the company provides \\(b\\) additional followers mid-month. Given that the number of followers remains constant since the end of the first month, find the relationship between \\(a\\) and \\(b\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q1 — Definite Integral — area and volume of revolution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251001-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Area and volume of revolution between two root curves',
  $$The region \(A\) is bounded by the curves \(y = \sqrt{x+1}\), \(y = \sqrt{7-2x}\), the \(x\)-axis and the \(y\)-axis.$$,
  'range', '47.4', 0.05,
  $$The curves meet where \(x+1 = 7-2x \Rightarrow x = 2,\ y = \sqrt{3}\), at \((2,\sqrt{3})\).

(a) Area \(= \displaystyle\int_0^2 \sqrt{x+1}\,\mathrm{d}x + \int_2^{3.5} \sqrt{7-2x}\,\mathrm{d}x = \dfrac{2}{3}(3\sqrt{3}-1) + \sqrt{3} = 3\sqrt{3} - \dfrac{2}{3}\) units\(^2\).

(b) Rotating \(A\) about the \(y\)-axis (with \(x = y^2-1\) and \(x = \dfrac{7-y^2}{2}\)) gives \(V = 47.4\) units\(^3\) (3 s.f.).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the exact area of \\(A\\). \\([4]\\)",
      "correct_answer": "3\\sqrt{3}-\\frac{2}{3}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the volume of the solid obtained when \\(A\\) is rotated through \\(2\\pi\\) radians about the \\(y\\)-axis. Give your answer to 3 significant figures. \\([3]\\)",
      "correct_answer": "47.4",
      "answer_type": "range",
      "tolerance": 0.05
    }
  ]$$::jsonb
);

-- P2 Q2 — Maclaurin Series — implicit relation and series verification
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251002-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  'Maclaurin series of ln(sin(x + pi/4))',
  $$It is given that \(y = \ln\!\left[\sin\!\left(x + \dfrac{\pi}{4}\right)\right]\), where \(-\dfrac{\pi}{4} < x < \dfrac{3\pi}{4}\).$$,
  'exact', '', null,
  $$(a) \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \cot\!\left(x+\tfrac{\pi}{4}\right)\); \(\dfrac{\mathrm{d}^2y}{\mathrm{d}x^2} = -\operatorname{cosec}^2\!\left(x+\tfrac{\pi}{4}\right) = -\left(1 + \left(\dfrac{\mathrm{d}y}{\mathrm{d}x}\right)^2\right)\), so \(\dfrac{\mathrm{d}^2y}{\mathrm{d}x^2} + \left(\dfrac{\mathrm{d}y}{\mathrm{d}x}\right)^2 + 1 = 0\). (shown)
At \(x = 0\): \(y = \ln\dfrac{1}{\sqrt{2}}\), \(y' = 1\), \(y'' = -2\), \(y''' = 4\). Hence \(y = \ln\dfrac{1}{\sqrt{2}} + x - x^2 + \dfrac{2}{3}x^3 + \cdots\).

(b) \(y = \ln\dfrac{1}{\sqrt{2}} + \ln(\sin x + \cos x)\); expanding \(\sin x + \cos x = 1 + x - \dfrac{x^2}{2} - \dfrac{x^3}{6} + \cdots\) and using \(\ln(1+u)\) gives \(\ln\dfrac{1}{\sqrt{2}} + x - x^2 + \dfrac{2}{3}x^3 + \cdots\). (verified)$$,
  11, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\dfrac{\\mathrm{d}^2y}{\\mathrm{d}x^2} + \\left(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right)^2 + 1 = 0\\). Hence find the first four non-zero terms of the Maclaurin expansion of \\(y\\), leaving your answer in exact form. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Verify the result obtained in part (a) using standard series from the List of Formulae (MF27). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q3 — Parametric Equations — normal, cartesian form and intersections
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251003-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  'Parametric hyperbola: normal and intersections',
  $$The parametric equations of the curve \(C\) are \(x = 1 - 3\operatorname{cosec}\theta\) and \(y = 2\cot\theta - 3\), where \(0 < \theta < \pi\).$$,
  'exact', '', null,
  $$(a) \(\dfrac{\mathrm{d}x}{\mathrm{d}\theta} = 3\operatorname{cosec}\theta\cot\theta\), \(\dfrac{\mathrm{d}y}{\mathrm{d}\theta} = -2\operatorname{cosec}^2\theta\), so \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = -\dfrac{2}{3}\sec\theta\). (shown)
At \(\theta = \dfrac{\pi}{4}\): \((x,y) = (1-3\sqrt{2}, -1)\), gradient \(-\dfrac{2\sqrt{2}}{3}\), so normal gradient \(\dfrac{3}{2\sqrt{2}}\). Normal: \(y = \dfrac{3}{2\sqrt{2}}x - \dfrac{3}{2\sqrt{2}} + \dfrac{7}{2}\).

(b) Substituting the parametric forms into the normal and solving (GC) gives \(\theta = 2.95319\) as well as \(\theta = \dfrac{\pi}{4}\), so the normal cuts \(C\) again.

(c) Using \(\operatorname{cosec}^2\theta - \cot^2\theta = 1\): \(\left(\dfrac{1-x}{3}\right)^2 - \left(\dfrac{y+3}{2}\right)^2 = 1\).

(d) A hyperbola centred \((1,-3)\) (left branch only for \(0<\theta<\pi\)).

(e) The line \(y = m(x-1) - 3\) passes through the centre. No intersection with \(C\) when \(m < -\dfrac{2}{3}\) or \(m > \dfrac{2}{3}\).$$,
  13, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} = -\\dfrac{2}{3}\\sec\\theta\\). Hence find the equation of the normal to \\(C\\) at the point where \\(\\theta = \\dfrac{\\pi}{4}\\), in the form \\(y = Ax + B\\), where \\(A\\) and \\(B\\) are exact constants. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that the normal found in part (a) will cut \\(C\\) again. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the Cartesian equation of \\(C\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Sketch \\(C\\), indicating clearly its key features. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Find the range of values of \\(m\\) such that there is no intersection between the line \\(y = m(x-1) - 3\\) and \\(C\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q4 — Vector (Basic) — three unit vectors summing to zero
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251004-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  'Three unit vectors with zero sum',
  $$\(A\), \(B\), \(C\) are coplanar points with position vectors \(\mathbf{a}\), \(\mathbf{b}\), \(\mathbf{c}\) which are unit vectors such that \(\mathbf{a} + \mathbf{b} + \mathbf{c} = \mathbf{0}\).$$,
  'exact', '\sqrt{3}', null,
  $$(a)(i) \(\mathbf{c} = -(\mathbf{a}+\mathbf{b})\), so \(\mathbf{c}\cdot\mathbf{c} = |\mathbf{a}|^2 + 2\mathbf{a}\cdot\mathbf{b} + |\mathbf{b}|^2 = 2 + 2\mathbf{a}\cdot\mathbf{b} = 1\), giving \(\mathbf{a}\cdot\mathbf{b} = -\dfrac{1}{2}\).

(a)(ii) \(\cos\angle AOB = \dfrac{\mathbf{a}\cdot\mathbf{b}}{|\mathbf{a}||\mathbf{b}|} = -\dfrac{1}{2}\), so \(\angle AOB = 120^\circ\).

(a)(iii) By symmetry the three vectors are at \(120^\circ\); triangle \(ABC\) is equilateral.

(b) \(D\) has position vector \(\mathbf{a}+\mathbf{b} = -\mathbf{c}\). The area of quadrilateral \(ACBD = \sqrt{3}\).$$,
  9, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "By considering \\(\\mathbf{c}\\cdot\\mathbf{c}\\), find the value of \\(\\mathbf{a}\\cdot\\mathbf{b}\\). \\([3]\\)",
      "correct_answer": "-\\frac{1}{2}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Find the angle \\(\\angle AOB\\), in degrees. \\([2]\\)",
      "correct_answer": "120",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "aiii",
      "prompt_latex": "Draw the position vectors \\(\\mathbf{a}\\), \\(\\mathbf{b}\\) and \\(\\mathbf{c}\\) on a single diagram. Using your diagram, identify the type of triangle \\(ABC\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The point \\(D\\) has position vector \\(\\mathbf{a}+\\mathbf{b}\\). Find the area of the quadrilateral \\(ACBD\\). \\([2]\\)",
      "correct_answer": "\\sqrt{3}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q5 — Permutation & Combination — arrangements of INSPIRATION
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251005-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  'Arrangements of the letters of INSPIRATION',
  $$The eleven letters in the word INSPIRATION are each printed on separate, identical cards. (The letter I appears 3 times, N appears 2 times.)$$,
  'exact', '\frac{2}{55}', null,
  $$(a)(i) Number of arrangements \(= \dfrac{11!}{3!\,2!} = 3\,326\,400\).

(a)(ii) NN together: \(\dfrac{10!}{3!} = 604\,800\). The three I's separated: \(\dfrac{8!}{2!}\times{}^{9}C_3 = 1\,693\,440\). Both: \({}^{8}C_3 \times 7! = 282\,240\). "Exactly one of the two conditions" \(= 604\,800 + 1\,693\,440 - 2(282\,240) = 1\,733\,760\).

(b) Removing 3 cards leaving 8 distinct: \(\dfrac{{}^{2}C_1\,{}^{3}C_2 + {}^{2}C_1\,{}^{6}C_1 + {}^{3}C_3 \cdots}{{}^{11}C_3} = \dfrac{2}{55}\).$$,
  6, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "Find the number of ways in which the cards can be arranged in a row if there are no restrictions. \\([1]\\)",
      "correct_answer": "3326400",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Find the number of arrangements in which the letters N are together or the letters I must all be separated, but not both. \\([3]\\)",
      "correct_answer": "1733760",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Three of the eleven cards are removed at random. Find the probability that the letters on the eight cards left behind are all distinct. \\([2]\\)",
      "correct_answer": "\\frac{2}{55}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q6 — Probability — basketball free-throw game
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  'Basketball free-throw conditional probability',
  $$A game has at most three throws; it ends when a player makes a successful shot. One player is selected per game: \(\mathrm{P}(\text{Ben}) = 0.7\). Ben and John succeed on any single attempt with probability 0.1 and 0.07 respectively; shots are independent.$$,
  'exact', '11', null,
  $$(a) \(\mathrm{P}(\text{win}) = 0.7(1-0.9^3) + 0.3(1-0.93^3) = 0.2483929 \approx 0.248\).

(b) \(\mathrm{P}(\text{John} \mid \text{did not win}) = \dfrac{0.3(0.93^3)}{1 - 0.2483929} = 0.321\) (3 s.f.).

(c) \(\mathrm{P}(\text{win within } n) = 1 - (1-0.2483929)^n \geq 0.95 \Rightarrow (0.7516071)^n \leq 0.05\). Least \(n = 11\).$$,
  8, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the probability that the team wins the game, to 3 significant figures. \\([3]\\)",
      "correct_answer": "0.248",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "b",
      "prompt_latex": "The team did not win the game. Find the probability that John was selected to shoot, to 3 significant figures. \\([3]\\)",
      "correct_answer": "0.321",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "c",
      "prompt_latex": "The team attempts the game repeatedly until the first game is won. Find the least number of attempts required such that the probability of winning within \\(n\\) games is at least 0.95. \\([2]\\)",
      "correct_answer": "11",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q7 — Correlation & Regression — ice-cream sales models
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251007-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  'Ice-cream sales regression and model choice',
  $$Monthly ice-cream sales \(s\) (thousand dollars) at temperature \(t\,^\circ\mathrm{C}\): \(t = 1,4,5,6,7,8,9\) and \(s = 14,15,15,16,18,21,23\). The regression line of \(s\) on \(t\) is \(s = 1.125t + 11\).$$,
  'range', '14.75', 0.005,
  $$(a) Sum of squares of residuals \(= 14.75\).

(b) Any point on the regression line keeps it unchanged, e.g. \((\bar{t},\bar{s}) = (5.71, 17.4)\) or \((0, 11)\).

(c) Scatter diagram: points rising and curving upward.

(d) As \(t\) increases, \(s\) increases at an increasing rate (concave up, positive gradient), so model (A) \(s = at^2 + b\) fits best, with \(a = 0.119\) and \(b = 12.8\) (3 s.f.).

(e) With \(t = \dfrac{5}{9}(T - 32)\): \(s = 0.119\left(\dfrac{5}{9}(T-32)\right)^2 + 12.8\).$$,
  7, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using the regression line \\(s = 1.125t + 11\\), find the sum of the squares of the residuals. \\([1]\\)",
      "correct_answer": "14.75",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "b",
      "prompt_latex": "State the coordinates of an additional data point such that, with all 8 data points, the regression line remains the same. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Sketch a scatter diagram of \\(s\\) against \\(t\\) for the data given in the table. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "The models proposed are (A) \\(s = at^2 + b\\), (B) \\(s = -c\\mathrm{e}^t + d\\), (C) \\(s = f\\ln(t+h)\\), with positive constants. Explain which model gives the best fit, and state the values of the constants for the chosen model. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "A temperature \\(F\\,^\\circ\\)F equals \\(C\\,^\\circ\\)C where \\(F = \\dfrac{9}{5}C + 32\\). Using the chosen model, rewrite the equation to estimate monthly sales when the temperature \\(T\\) is in degrees Fahrenheit. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q8 — Hypothesis Testing — mean mass of a can of beans
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251008-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  'Hypothesis test on mean mass of a can of beans',
  $$A producer claims the mean mass of a can of beans is 425 g. A random sample of 50 cans gives, in \(x\) g, \(\sum x = 21209\) and \(\sum (x - 424.18)^2 = 522\).$$,
  'exact', '', null,
  $$(a) A random sample: every can in the population has an equal chance of being selected, independently of the others.

(b) \(\bar{x} = \dfrac{21209}{50} = 424.18\); unbiased variance \(s^2 = \dfrac{522}{49} = 10.7\) (3 s.f.).

(c) \(H_0: \mu = 425\) vs \(H_1: \mu \neq 425\). With \(n = 50\) large, by CLT the test statistic \(\sim N(0,1)\). \(p\text{-value} = 0.0757 > 0.05\), so do not reject \(H_0\): insufficient evidence that the mean mass differs from 425 g.

(d) For the increase test (\(n = 55\), \(\bar{y} = 426.5\), 10% level), \(H_0\) is rejected iff \(z \geq 1.2816\), i.e. iff \(\sigma < 8.68\) (3 s.f.). So whether the manager concludes an increase depends on whether \(\sigma\) is below 8.68.$$,
  11, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "State what it means for a sample to be random in this context. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the unbiased estimates for the population mean and variance. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "State the hypotheses for the manager's test, defining any parameters you use. Carry out the test at the 5% level of significance, giving your conclusion in context. \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "The manager tests whether the mean has increased using an alternative process: 55 cans give mean 426.5 g, tested at 10% significance. Explain, with justification, how the population standard deviation of the mass under the alternative process affects the conclusion. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q9 — Discrete Random Variable — treasure hunt scores
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c0251009-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  'Treasure-hunt discrete random variable',
  $$Each round gives a score \(X\): outcomes Cursed trap \((-3,\ \mathrm{P}=0.2)\), Small trap \((-0.3,\ \mathrm{P}=p)\), Mystery box \((p,\ \mathrm{P}=q)\), Gold chest \((5,\ \mathrm{P}=0.1)\). Rounds are independent.$$,
  'range', '0.188', 0.0005,
  $$(a) \(q = 0.7 - p\). \(\mathrm{E}(X) = -3(0.2) - 0.3p + p(0.7-p) + 5(0.1) = -0.1 + 0.4p - p^2\). (shown)

(b) Maximising the quadratic on the valid range: \(\mathrm{E}(X)_{\max} = -0.06\) at \(p = 0.2\); \(\mathrm{E}(X)_{\min} = -0.31\) at \(p = 0.7\).

(c) With \(p = 0.4\): \(\mathrm{E}(X) = -0.1\), \(\operatorname{Var}(X) = 4.374\). For \(n = 30\), \(\bar{X} \sim N(-0.1, \tfrac{4.374}{30})\); \(\mathrm{P}(\bar{X} > 0) = 0.397\) (3 s.f.).

(d) \(Y \sim B(10,p)\), \(\mathrm{P}(Y > 3) = 0.10 \Rightarrow p = 0.188\) (3 s.f.).

(e) For the mode to be 3: \(\mathrm{P}(Y=2) = \mathrm{P}(Y=3)\) and \(\mathrm{P}(Y=4) = \mathrm{P}(Y=3)\) give \(p = \dfrac{3}{11}\) or \(p = \dfrac{4}{11}\).$$,
  12, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\mathrm{E}(X) = -0.1 + 0.4p - p^2\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the maximum and minimum possible values of \\(\\mathrm{E}(X)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "The game is played for 30 rounds. If \\(p = 0.4\\), find the probability that the player's mean score exceeds 0, to 3 significant figures. \\([3]\\)",
      "correct_answer": "0.397",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "d",
      "prompt_latex": "The game is played for 10 rounds. Given that the probability of finding more than 3 Small traps is 10%, find the value of \\(p\\), to 3 significant figures. \\([2]\\)",
      "correct_answer": "0.188",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "e",
      "prompt_latex": "Over a long period, the number of Small traps in 10 rounds follows a bimodal distribution, with one mode being 3. Find the two exact possible values of \\(p\\), showing your working clearly. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q10 — Normal Distribution — burger-shop wait times
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'c025100a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  'Burger-shop wait times (Normal distribution)',
  $$Wait time \(W\) (minutes) is first proposed as \(N(2, 1.5^2)\), then re-modelled as \(W \sim N(5, 1^2)\). State the parameters of any distributions you use.$$,
  'range', '0.0575', 0.00005,
  $$(a) Under \(N(2,1.5^2)\), \(\mathrm{P}(W < 0) = 0.0912\), i.e. about 9% of orders would have a negative wait time — unrealistic.

(b) \(\mathrm{P}(W > k) \geq 0.9\) with \(W \sim N(5,1^2)\) gives \(0 \leq k \leq 3.71\) (3 s.f.).

(c) \(\operatorname{Var}(\bar{W} - W_1) = \dfrac{2}{3}\) and \(\operatorname{Var}(\bar{W}) + \operatorname{Var}(W_1) = \dfrac{4}{3}\); they are not equal.

(d) \(\bar{W} - W_1 \sim N(0, \tfrac{2}{3})\); \(\mathrm{P}(|\bar{W} - W_1| < 1) = 0.779\) (3 s.f.).

(e) \(W - T \sim N(-2, 3.25)\); \(\mathrm{P}(W - T > 3 \mid W - T > 0) = \dfrac{\mathrm{P}(W-T>3)}{\mathrm{P}(W-T>0)} = 0.0208\) (3 s.f.).

(f) Kiosk time \(K = 0.8W \sim N(4, 0.8^2)\), \(\mathrm{P}(K \geq 5) = 0.10565\). With \(X \sim B(8,0.5)\) (counter) and \(Y \sim B(8,0.10565)\) (kiosk), \(\mathrm{P}(X + Y = 2) = 0.0575\) (3 s.f.).$$,
  16, 'HCI H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Give a reason why the model \\(N(2,1.5^2)\\) is not suitable. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Using \\(W \\sim N(5,1^2)\\), find the range of values of \\(k\\) such that at least 90% of customers experience a wait time longer than \\(k\\) minutes. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "With \\(\\bar{W} = \\dfrac{W_1 + W_2 + W_3}{3}\\), find \\(\\operatorname{Var}(\\bar{W} - W_1)\\) and \\(\\operatorname{Var}(\\bar{W}) + \\operatorname{Var}(W_1)\\), and hence determine whether \\(\\operatorname{Var}(\\bar{W} - W_1) = \\operatorname{Var}(\\bar{W}) + \\operatorname{Var}(W_1)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Find the probability that the mean wait time is within one minute of the wait time on the first occasion, to 3 significant figures. \\([3]\\)",
      "correct_answer": "0.779",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "e",
      "prompt_latex": "On the 4th occasion the time in the restroom is \\(T \\sim N(7,1.5^2)\\), independent of \\(W\\). The customer will not wait more than 3 minutes after leaving the restroom. Given that the burger is not ready when the customer leaves the restroom, find the probability that the customer leaves without collecting the burger, to 3 significant figures. \\([4]\\)",
      "correct_answer": "0.0208",
      "answer_type": "range",
      "tolerance": 0.00005
    },
    {
      "label": "f",
      "prompt_latex": "Kiosk wait time is reduced by 20% from the counter. 8 counter customers and 8 kiosk customers are selected, all independent. Find the probability that exactly 2 of these 16 customers have a wait time of at least 5 minutes, to 3 significant figures. \\([4]\\)",
      "correct_answer": "0.0575",
      "answer_type": "range",
      "tolerance": 0.00005
    }
  ]$$::jsonb
);
