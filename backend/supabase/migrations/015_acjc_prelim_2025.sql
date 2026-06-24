-- Migration 015: ACJC H2 Math (9758) Prelim 2025 — Paper 1 (Q1–Q12) + Paper 2 (Q1–Q12)
-- UUIDs: a0250001–a025000c (P1), a0251001–a025100c (P2). All hex valid; distinct from topic UUIDs.
-- Source: 'ACJC H2 Math Prelim 2025', difficulty: 3
-- Questions table already has GRANT ALL from earlier migrations (no new table here).

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 — Inequalities
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  3,
  'Rational inequality and its modulus form',
  $$Two related inequalities.$$,
  'exact', '', null,
  $$(a) \(\dfrac{x}{x+2} - \dfrac{2}{2-x} \geq 0 \Rightarrow \dfrac{-(x^2+4)}{(x+2)(2-x)} \geq 0\). Since \(x^2+4 > 0\), this needs \((x+2)(2-x) < 0\), i.e. \((x+2)(x-2) > 0\). So \(x < -2\) or \(x > 2\).

(b) Replacing \(x\) with \(|x|\): \(|x| < -2\) (no solution) or \(|x| > 2\), giving \(x < -2\) or \(x > 2\).$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Without using a calculator, solve the inequality \\(\\dfrac{x}{x+2} \\geq \\dfrac{2}{2-x}\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence, solve the inequality \\(\\dfrac{|x|}{|x|+2} \\geq \\dfrac{2}{2-|x|}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q2 — Graphing Techniques
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250002-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  'Oblique-asymptote rational graph with no stationary points',
  $$The graph of \(y = \dfrac{ax^2 + bx + c}{x + d}\) has a vertical asymptote \(x = -1\) and an oblique asymptote \(y = 2x + 2\). It is given that \(c \neq 2\).$$,
  'exact', '', null,
  $$(a) Vertical asymptote \(x = -1 \Rightarrow d = 1\). Writing \(2x^2+4x+c = (x+1)(2x+2) + (c-2)\) gives \(y = 2x+2 + \dfrac{c-2}{x+1}\), so the oblique asymptote is \(2x+2\); comparing, \(a = 2\), \(b = 4\).

(b) \(y' = 2 - \dfrac{c-2}{(x+1)^2}\). No stationary points needs \(2(x+1)^2 = c-2\) to have no solution, i.e. \(c - 2 < 0\). So \(c < 2\).$$,
  5, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Write down the value of \\(d\\) and show that \\(a = 2\\) and \\(b = 4\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the range of values of \\(c\\) if the graph has no stationary points. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q3 — Differentiation Technique
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250003-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  3,
  'Implicit/logarithmic differentiation of y = x^{xy}',
  $$It is given that \(y = x^{xy}\), where \(x > 0\), \(y > 0\).$$,
  'exact', '', null,
  $$(a) \(\ln y = xy\ln x\). Differentiating: \(\dfrac{1}{y}\dfrac{\mathrm{d}y}{\mathrm{d}x} = (y + x y')\ln x + y\), so \(y'\!\left(\dfrac{1 - xy\ln x}{y}\right) = y(1+\ln x)\). Since \(xy\ln x = \ln y\), \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \dfrac{y^2(1+\ln x)}{1 - \ln y}\). (shown)

(b) Tangent parallel to the \(y\)-axis \(\Rightarrow\) denominator \(1-\ln y = 0 \Rightarrow y = \mathrm{e}\). Then \(\ln y = xy\ln x\) gives \(1 = x\mathrm{e}\ln x \Rightarrow x\ln x = \mathrm{e}^{-1}\), so \(x = 1.32\) (GC). The point is \((1.32, \mathrm{e})\).$$,
  5, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} = \\dfrac{y^2(1+\\ln x)}{1 - \\ln y}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the coordinates of the point on the curve \\(y = x^{xy}\\) whose tangent is parallel to the \\(y\\)-axis. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q4 — Definite Integral (single ungraded task → one null part)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250004-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Volume of revolution of y = x ln x',
  $$The region \(R\) is bounded by the curve \(y = x\ln x\), the lines \(x = \mathrm{e}\), \(x = \mathrm{e}^2\) and the \(x\)-axis.$$,
  'exact', '', null,
  $$\(V = \pi\displaystyle\int_{\mathrm{e}}^{\mathrm{e}^2} (x\ln x)^2\,\mathrm{d}x = \pi\int_{\mathrm{e}}^{\mathrm{e}^2} x^2(\ln x)^2\,\mathrm{d}x\). Integrating by parts twice:
\[\pi\left[\frac{x^3}{3}(\ln x)^2 - \frac{2}{9}x^3\ln x + \frac{2}{27}x^3\right]_{\mathrm{e}}^{\mathrm{e}^2} = \frac{\pi\mathrm{e}^3}{27}\left(26\mathrm{e}^3 - 5\right).\]
So \(a = 26\), \(b = -5\).$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the exact volume of the solid formed when \\(R\\) is rotated about the \\(x\\)-axis through \\(2\\pi\\) radians. Give your answer in the form \\(\\dfrac{\\pi\\mathrm{e}^3}{27}(a\\mathrm{e}^3 + b)\\), where \\(a\\) and \\(b\\) are integers to be found. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q5 — Vector (Plane)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250005-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Vectors, a plane through the origin, and a foot of perpendicular',
  $$Relative to the origin \(O\), the points \(A\) and \(B\) have non-zero, non-parallel position vectors \(\mathbf{a}\) and \(\mathbf{b}\). The plane \(p\) has equation \(\mathbf{r}\cdot\mathbf{n} = 0\).$$,
  'exact', '', null,
  $$(a) \(\overrightarrow{AB}\cdot\mathbf{n} = \mathbf{b}\cdot\mathbf{n} - \mathbf{a}\cdot\mathbf{n} = 0\), so \(\overrightarrow{AB} \perp \mathbf{n}\). As \(\mathbf{n}\) is normal to \(p\), \(\overrightarrow{AB}\) is parallel to the plane \(p\).

(b) The origin lies on \(p\), so a suitable line is \(\mathbf{r} = \lambda(\mathbf{b} - \mathbf{a})\), \(\lambda \in \mathbb{R}\).

(c) \(\overrightarrow{OF} = \mathbf{c} - \dfrac{\mathbf{c}\cdot\mathbf{n}}{\mathbf{n}\cdot\mathbf{n}}\,\mathbf{n}\).$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that \\(\\mathbf{a}\\cdot\\mathbf{n} = \\mathbf{b}\\cdot\\mathbf{n} \\neq 0\\), show that \\(\\overrightarrow{AB}\\) is perpendicular to \\(\\mathbf{n}\\). Hence describe the geometrical relationship between \\(\\overrightarrow{AB}\\) and the plane \\(p\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Write down the equation of a line parallel to \\(\\overrightarrow{AB}\\) that is contained in the plane \\(p\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "The point \\(F\\) is the foot of perpendicular from a point \\(C\\) with position vector \\(\\mathbf{c}\\) to the plane \\(p\\). Find the position vector of \\(F\\) in terms of \\(\\mathbf{c}\\) and \\(\\mathbf{n}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q6 — App. of Differentiation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250006-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Minimising the material of an open cylindrical tank',
  $$An open cylindrical tank has external radius \(r\) cm, external height \(h\) cm, and is made of material of thickness \(a\) cm throughout. The internal volume is fixed at \(1000\pi\) cm\(^3\).$$,
  'exact', 'a+10', null,
  $$(a) Internal volume \(\pi(r-a)^2(h-a) = 1000\pi \Rightarrow h - a = \dfrac{1000}{(r-a)^2}\). Then
\[V = \pi r^2 h - 1000\pi = 1000\pi\left[\frac{r^2}{(r-a)^2} - 1\right] + \pi r^2 a,\]
so \(k = 1000\).

(b) \(\dfrac{\mathrm{d}V}{\mathrm{d}r} = 2\pi a r\left[1 - \dfrac{1000}{(r-a)^3}\right] = 0 \Rightarrow (r-a)^3 = 1000 \Rightarrow r - a = 10\). So \(r = a + 10\).$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the volume of material needed is \\(V = k\\pi\\left[\\dfrac{r^2}{(r-a)^2} - 1\\right] + \\pi r^2 a\\), where \\(k\\) is a constant to be determined. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find, in terms of \\(a\\), the value of \\(r\\) that minimises \\(V\\). (You need not show that your answer gives a minimum.) \\([3]\\)",
      "correct_answer": "a+10",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q7 — Differential Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250007-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Newton''s law of cooling for a cup of tea',
  $$A cup of tea, initially at \(85^\circ\)C, cools in a room at \(25^\circ\)C. After 20 minutes its temperature is \(55^\circ\)C. The rate of change of the temperature is proportional to the difference between the temperature of the tea and the room temperature.$$,
  'exact', '', null,
  $$(a) \(\dfrac{\mathrm{d}\theta}{\mathrm{d}t} = -k(\theta - 25)\). Solving: \(\theta - 25 = A\mathrm{e}^{-kt}\). \(\theta(0) = 85 \Rightarrow A = 60\); \(\theta(20) = 55 \Rightarrow \mathrm{e}^{-20k} = \tfrac{1}{2} \Rightarrow k = \tfrac{1}{20}\ln 2 \approx 0.0347\). Hence \(\theta = 25 + 60\mathrm{e}^{-kt}\). (shown)

(b) Decreasing curve from \((0, 85)\) approaching the horizontal asymptote \(\theta = 25\) as \(t \to \infty\).$$,
  7, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that \\(\\theta\\) is the temperature of the tea \\(t\\) minutes after it is left to cool, show that \\(\\theta = 25 + 60\\mathrm{e}^{-kt}\\), where \\(k\\) is a constant to be determined. \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch the graph of \\(\\theta\\) against \\(t\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q8 — Functions
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250008-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Graph transformations and a restricted-domain inverse',
  $$The curve \(y = \mathrm{f}(x)\) for \(x \leq b\), where \(\mathrm{f}\) is a quadratic function, meets the \(x\)-axis at \((a, 0)\) and \((b, 0)\) and the \(y\)-axis at \((0, c)\), with \(a < 0 < b\) (the same scale on both axes; \(\mathrm{f}\) opens downward).$$,
  'exact', '', null,
  $$(a)(i) Reflect the part of the curve for \(x \geq 0\) in the \(y\)-axis (replacing \(x\) by \(|x|\)).
(a)(ii) \(y = \dfrac{1}{\mathrm{f}(x)}\): vertical asymptotes \(x = a\), \(x = b\); passes through \((0, \tfrac{1}{c})\); minimum where \(\mathrm{f}\) is maximum.
(a)(iii) From \(y = \mathrm{f}(2x+1)\): scale parallel to the \(x\)-axis by factor 2, then translate 1 unit in the positive \(x\)-direction.

(b)(i) The vertex is at \(x = \dfrac{a+b}{2}\); for \(\mathrm{g}^{-1}\) to exist the largest value of \(k\) is \(\dfrac{a+b}{2}\).
(b)(ii) \(R_{\mathrm{g}^{-1}} = D_{\mathrm{g}} = \left(-\infty, \dfrac{a+b}{2}\right]\).
(b)(iii) \(\mathrm{g}\) and \(\mathrm{g}^{-1}\) are reflections in \(y = x\); if \(\mathrm{g}^{-1}(x) = x\) the point lies on \(y = x\), so \(\mathrm{g}\) passes through it too, giving \(\mathrm{g}^{-1}(x) = \mathrm{g}(x)\).$$,
  10, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "Sketch the graph of \\(y = \\mathrm{f}(|x|)\\), labelling the points where it intersects or touches the axes. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Sketch the graph of \\(y = \\dfrac{1}{\\mathrm{f}(x)}\\), labelling intercepts and the equations of any asymptotes. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aiii",
      "prompt_latex": "Describe fully a sequence of transformations which transforms the graph of \\(y = \\mathrm{f}(2x+1)\\) onto the graph of \\(y = \\mathrm{f}(x)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "The function \\(\\mathrm{g}\\) is such that \\(\\mathrm{g}(x) = \\mathrm{f}(x)\\) for \\(x \\leq k\\), and \\(\\mathrm{g}^{-1}\\) exists. Find the largest possible value of \\(k\\) in terms of \\(a\\) and \\(b\\). \\([1]\\)",
      "correct_answer": "\\frac{a+b}{2}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Using the value of \\(k\\) found in (b)(i), write down the range of \\(\\mathrm{g}^{-1}\\) in terms of \\(a\\) and \\(b\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "biii",
      "prompt_latex": "Explain why the solution to \\(\\mathrm{g}^{-1}(x) = x\\) satisfies the equation \\(\\mathrm{g}^{-1}(x) = \\mathrm{g}(x)\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q9 — Vector (Plane)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0250009-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Line of intersection of two planes; distance between parallel planes',
  $$The planes \(\pi_1\) and \(\pi_2\) have equations \(3x + c(y+z) - 2 = 0\) and \(\mathbf{r} = (\mathbf{i}+3\mathbf{j}-2\mathbf{k}) + s(2\mathbf{i}-\mathbf{j}+3\mathbf{k}) + t(\mathbf{i}-\mathbf{k})\), where \(c\) is a constant and \(s, t\) are parameters. The point \(A(1, 3, -2)\) lies in both planes.$$,
  'exact', '', null,
  $$(a) Substituting \(A\) into \(\pi_1\): \(3 + c(3-2) - 2 = 0 \Rightarrow c = -1\).

(b) \(\mathbf{n}_1 = (3,-1,-1)\), \(\mathbf{n}_2 = (1,5,1)\); \(\mathbf{n}_1\times\mathbf{n}_2 = (4,-4,16) = 4(1,-1,4)\). With \(A\) on the line: \(\mathbf{r} = \mathbf{i}+3\mathbf{j}-2\mathbf{k} + \alpha(\mathbf{i}-\mathbf{j}+4\mathbf{k})\).

(c) \(P = (1+\alpha, 3-\alpha, -2+4\alpha)\); \(|\overrightarrow{BP}|^2 = 18\) gives \(9\alpha^2 - 43\alpha + 50 = 0\), so \(\alpha = 2\) or \(\tfrac{25}{9}\). Points \((3, 1, 6)\) and \(\left(\tfrac{34}{9}, \tfrac{2}{9}, \tfrac{82}{9}\right)\).

(d) \(\pi_3\): \(\mathbf{r}\cdot(1,5,1) = -6\); \(\pi_2\): \(\mathbf{r}\cdot(1,5,1) = 14\). Distance \(= \dfrac{|14-(-6)|}{\sqrt{27}} = \dfrac{20}{3\sqrt{3}}\). (shown)$$,
  9, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(c = -1\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that the vector equation of the line of intersection \\(l\\) of \\(\\pi_1\\) and \\(\\pi_2\\) is \\(\\mathbf{r} = \\mathbf{i}+3\\mathbf{j}-2\\mathbf{k} + \\alpha(\\mathbf{i}-\\mathbf{j}+4\\mathbf{k})\\), where \\(\\alpha\\) is a parameter. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the position vectors of the points on \\(l\\) which are a distance of \\(3\\sqrt{2}\\) from the point \\(B(2, -3, 7)\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Find the equation of the plane \\(\\pi_3\\) parallel to \\(\\pi_2\\) and containing \\(B\\). Hence show that the distance between \\(\\pi_2\\) and \\(\\pi_3\\) is \\(\\dfrac{20}{3\\sqrt{3}}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q10 — Complex Number
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025000a-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  'Quartic with a complex root; Argand diagram with cosine rule',
  $$Do not use a calculator in answering this question.$$,
  'exact', '', null,
  $$(a) Real coefficients \(\Rightarrow 2-3\mathrm{i}\) is also a root, giving factor \(\omega^2 - 4\omega + 13\). Writing \(\omega^4 - 2\omega^3 + 10\omega^2 + p\omega + q = (\omega^2-4\omega+13)(\omega^2+2\omega+5)\) gives the other factor \(\omega^2+2\omega+5\) (roots \(-1\pm 2\mathrm{i}\)), and \(p = 6\), \(q = 65\).

(b)(i) \(u = -\sqrt{2} + \mathrm{i}\sqrt{2}\): \(|u| = 2\), \(\arg u = \dfrac{3\pi}{4}\).
(b)(ii) Parallelogram \(OACB\) with \(OB\) longer than \(OA\) and \(\arg v = \theta \in (0, \tfrac{\pi}{4})\).
(b)(iii) \(\angle AOB = \tfrac{3\pi}{4} - \theta\); by the cosine rule \(|u+v|^2 = 4 + 9 + 12\cos\!\left(\tfrac{3\pi}{4}-\theta\right) = 13 - 12\cos\!\left(\theta + \tfrac{\pi}{4}\right)\). So \(a = 13\), \(b = -12\), \(K = \tfrac{\pi}{4}\).$$,
  13, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "One of the roots of \\(\\omega^4 - 2\\omega^3 + 10\\omega^2 + p\\omega + q = 0\\), where \\(p\\) and \\(q\\) are real, is \\(2 + 3\\mathrm{i}\\). Find the values of \\(p\\) and \\(q\\) and the other roots of the equation. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "The complex numbers \\(u\\) and \\(v\\) satisfy \\(u = -\\sqrt{2} + \\mathrm{i}\\sqrt{2}\\), \\(|v| = 3\\), \\(\\arg v = \\theta\\) with \\(0 < \\theta < \\tfrac{\\pi}{4}\\). Find the modulus and argument of \\(u\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "The points \\(A\\), \\(B\\), \\(C\\) represent \\(u\\), \\(v\\), \\(u+v\\). Sketch \\(A\\), \\(B\\), \\(C\\) on an Argand diagram. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "biii",
      "prompt_latex": "By finding the angle \\(OAC\\) in terms of \\(\\theta\\) or otherwise, show that \\(|u+v|^2 = a + b\\cos(\\theta + K)\\), where \\(a\\), \\(b\\) and \\(K\\) are constants to be determined. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q11 — Parametric Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025000b-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  'Tangents to a parametric rectangular-hyperbola-type curve',
  $$The curve \(C\) is defined by \(x = at^2\), \(y = \dfrac{a}{t}\), \(t \neq 0\), where \(a\) is a positive constant.$$,
  'exact', '\frac{11p}{4}', null,
  $$(a) \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \dfrac{-a/t^2}{2at} = -\dfrac{1}{2t^3}\). At \(t = p\) the tangent is \(y - \tfrac{a}{p} = -\tfrac{1}{2p^3}(x - ap^2)\), i.e. \(2p^3 y + x = 3ap^2\). (shown)

(b) \(x = a \Rightarrow t = \pm 1\). Tangents: \(2y + x = 3a\) and \(-2y + x = 3a\), with gradients \(-\tfrac12\) and \(\tfrac12\). Acute angle \(= 53.1^\circ\) (\(0.927\) rad).

(c)(i) \((q-p)^2(q+2p) = q^3 - 3p^2 q + 2p^3\). (shown)

(c)(ii) Substituting \(Q(aq^2, a/q)\): \(2p^3\!\cdot\!\tfrac{a}{q} + aq^2 = 3ap^2 \Rightarrow q^3 - 3p^2 q + 2p^3 = 0 \Rightarrow (q-p)^2(q+2p) = 0\). Since \(q \neq p\), \(q = -2p\).

(d) With \(a = 1\), \(S = \displaystyle\int_{p^2}^{4p^2}\!\left[\frac{3p^2-x}{2p^3} + \frac{1}{\sqrt{x}}\right]\mathrm{d}x = \frac{3p}{4} + 2p = \frac{11p}{4}\).$$,
  9, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the equation of the tangent to \\(C\\) at \\(P\\!\\left(ap^2, \\tfrac{a}{p}\\right)\\) is \\(2p^3 y + x = 3ap^2\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the equations of the tangents to \\(C\\) where \\(x = a\\), and the acute angle between these tangents. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "ci",
      "prompt_latex": "Show that \\((q-p)^2(q+2p) = q^3 - 3p^2 q + 2p^3\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "cii",
      "prompt_latex": "The tangent at \\(P\\) cuts \\(C\\) again at \\(Q\\!\\left(aq^2, \\tfrac{a}{q}\\right)\\). Find \\(q\\) in terms of \\(p\\). \\([3]\\)",
      "correct_answer": "-2p",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "For \\(a = 1\\) (so \\(xy^2 = 1\\)), the region \\(S\\) is bounded by the tangent to \\(C\\) at \\(\\left(p^2, \\tfrac{1}{p}\\right)\\), the curve \\(C\\) and the line \\(x = p^2\\). Find the area of \\(S\\) in terms of \\(p\\). \\([3]\\)",
      "correct_answer": "\\frac{11p}{4}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q12 — Sequences & Series (loan: AP then GP)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025000c-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Tuition-fee loan: arithmetic saving then geometric repayment',
  $$Sarah started a 4-year course in Aug 2021. The annual tuition fee (after grant) is \$8250; she took a Tuition Fee Loan (TFL) covering 90% of fees, interest-free during study. She set aside \$\(x\) in Aug 2021, increasing by \$2 each month, and with this repaid one-fifth of her total TFL at the end of July 2025. After graduation the TFL accrues 0.4% interest per month on the end-of-month balance (first charged 31 Aug 2025); she repays \$\(y\) on the 1st of each month from 1 Sep 2025.$$,
  'range', '709.98', 0.005,
  $$(a) Total TFL \(= 0.9 \times 8250 \times 4 = \$23760\); one-fifth \(= \$5940\). Saving is an AP with \(a = x\), \(d = 2\), \(n = 48\): \(\tfrac{48}{2}(2x + 47\cdot 2) = 5940 \Rightarrow x = 76.75\).

(b) After the 1st repayment: \(\$\bigl(23760(1.004) - y\bigr)\).

(c) After the \(n\)th repayment: \(23760(1.004)^n - 250y\bigl((1.004)^n - 1\bigr)\). (shown, summing the GP)

(d) Setting the balance after 36 repayments \(\leq 0\): \(y \geq 709.9769\), so \(y = \$709.98\).

(e) After 24 payments of \$500 the balance is \$13580.49; needing \(m\) further payments of \$1000: \(m = 14\). She clears the loan in October 2028, with a final repayment of \$991.20.$$,
  12, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the value of \\(x\\). \\([3]\\)",
      "correct_answer": "76.75",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "b",
      "prompt_latex": "Find the amount of outstanding loan after Sarah's first monthly repayment. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Show that the amount of outstanding loan after Sarah's \\(n\\)th monthly repayment is \\(23760(1.004)^n - 250y\\bigl((1.004)^n - 1\\bigr)\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Sarah wants to pay off her remaining loan by the end of 3 years. Find the value of \\(y\\). \\([2]\\)",
      "correct_answer": "709.98",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "e",
      "prompt_latex": "Instead, she repays \\$500 per month for the first 24 months, then \\$1000 per month. Determine the month and year Sarah clears her loan, and the amount of her final repayment. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q1 — Vector (Lines): foot of perpendicular and reflection (single task → one null part)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251001-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  3,
  'Reflection of a point in a line through the origin',
  $$It is given that \(\overrightarrow{OA} = 3\mathbf{i} + \mathbf{j} + 3\mathbf{k}\) and \(\overrightarrow{OB} = 5\mathbf{i} - 4\mathbf{j} + 3\mathbf{k}\).$$,
  'exact', '', null,
  $$\(R\) on \(OB\): \(\overrightarrow{OR} = \dfrac{\overrightarrow{OA}\cdot\overrightarrow{OB}}{|\overrightarrow{OB}|^2}\overrightarrow{OB} = \dfrac{20}{50}(5,-4,3) = \left(2, -\tfrac{8}{5}, \tfrac{6}{5}\right)\).
\(A'\) is the reflection: \(\overrightarrow{OA'} = 2\overrightarrow{OR} - \overrightarrow{OA} = \left(1, -\tfrac{21}{5}, -\tfrac{3}{5}\right)\).$$,
  4, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the position vector of the point \\(R\\) on line \\(OB\\) such that \\(AR\\) is perpendicular to \\(OB\\). Hence find the position vector of \\(A'\\), the reflection of \\(A\\) in the line \\(OB\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q2 — Maclaurin Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251002-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  'Maclaurin series of (1-4x^2)^{-1/2} and of arcsin 2x',
  $$It is given that \(\mathrm{f}(x) = \dfrac{1}{\sqrt{1-4x^2}}\), where \(-\tfrac12 < x < \tfrac12\).$$,
  'exact', '', null,
  $$(a) \((1-4x^2)^{-1/2} = 1 + 2x^2 + 6x^4 + 20x^6 + \cdots\).

(b) \(\dfrac{\mathrm{d}}{\mathrm{d}x}\sin^{-1}2x = \dfrac{2}{\sqrt{1-4x^2}} = 2\mathrm{f}(x)\), so integrating (constant \(0\) since \(\sin^{-1}0 = 0\)):
\[\sin^{-1}2x = 2x + \tfrac{4}{3}x^3 + \tfrac{12}{5}x^5 + \tfrac{40}{7}x^7 + \cdots.\]$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using standard series from the List of Formulae (MF27), find the Maclaurin expansion of \\(\\mathrm{f}(x)\\) up to and including the term in \\(x^6\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the first four non-zero terms of the Maclaurin series for \\(\\sin^{-1}2x\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q3 — Sequences & Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251003-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Sum of r(r+1)^2 and a periodic recurrence',
  $$You may use \(\displaystyle\sum_{r=1}^{n} r^2 = \dfrac{n(n+1)(2n+1)}{6}\) and \(\displaystyle\sum_{r=1}^{n} r^3 = \dfrac{n^2(n+1)^2}{4}\).$$,
  'exact', '', null,
  $$(a)(i) \(r(r+1)^2 = r^3 + 2r^2 + r\); summing and factorising gives \(\displaystyle\sum_{r=1}^{n} r(r+1)^2 = \dfrac{n(n+1)(n+2)(3n+5)}{12}\). (shown)

(a)(ii) Putting \(m = r+2\), \(\displaystyle\sum_{r=5}^{n-1}(r+2)(r+3)^2 = \sum_{m=7}^{n+1} m(m+1)^2 = \dfrac{(n+1)(n+2)(n+3)(3n+8)}{12} - 644\).

(b) \(u_2 = -1\), \(u_3 = \tfrac12\), \(u_4 = 2\); the sequence has period 3, and \(2025 = 3\times 675\), so \(u_{2025} = u_3 = \tfrac12\).$$,
  9, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "Show that \\(\\displaystyle\\sum_{r=1}^{n} r(r+1)^2 = \\dfrac{n(n+1)(n+2)(3n+5)}{12}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Hence find \\(\\displaystyle\\sum_{r=5}^{n-1}(r+2)(r+3)^2\\) in terms of \\(n\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The sequence \\(u_1, u_2, u_3, \\ldots\\) is defined by \\(u_1 = 2\\), \\(u_{n+1} = \\dfrac{1}{1 - u_n}\\), \\(n \\geq 1\\). Find \\(u_2\\), \\(u_3\\) and \\(u_4\\). Hence find \\(u_{2025}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q4 — Functions
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251004-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Inverse and range of a rational function; composite range',
  $$The function \(\mathrm{f}\) is defined by \(\mathrm{f}: x \mapsto \dfrac{1}{x^2 + 6x + 5}\), for \(x \geq -3\), \(x \neq -1\). The function \(\mathrm{g}\) is defined by \(\mathrm{g}: x \mapsto \mathrm{e}^x\), for \(x \in \mathbb{R}\).$$,
  'exact', '', null,
  $$(a) \(y = \dfrac{1}{(x+3)^2 - 4} \Rightarrow (x+3)^2 = \dfrac{1}{y} + 4\); since \(x \geq -3\), \(\mathrm{f}^{-1}(x) = -3 + \sqrt{\dfrac{1}{x} + 4}\).

(b) The quadratic \(yx^2 + 6yx + 5y - 1 = 0\) has real roots \(\Rightarrow\) discriminant \(\geq 0\): \(16y^2 + 4y \geq 0\), giving \(R_{\mathrm{f}} = \left(-\infty, -\tfrac14\right] \cup (0, \infty)\).

(c) \(R_{\mathrm{gf}} = \mathrm{e}^{R_{\mathrm{f}}} = \left(0, \mathrm{e}^{-1/4}\right] \cup (1, \infty)\).$$,
  9, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find \\(\\mathrm{f}^{-1}(x)\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find algebraically the range of \\(\\mathrm{f}\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the exact range of \\(\\mathrm{gf}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q5 — Differential Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251005-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Trig-substitution integral and a coupled chemical-reaction model',
  $$A reaction has \(x\) kg of substance X and \(y\) kg of substance Y at time \(t\), with \(\dfrac{\mathrm{d}x}{\mathrm{d}t} = xy\) and \(\dfrac{\mathrm{d}y}{\mathrm{d}t} = x^2\). Initially \(x = 4\), \(y = 5\).$$,
  'exact', '', null,
  $$(a) With \(x = a\tan\theta\): \(\displaystyle\int \dfrac{1}{x\sqrt{x^2+a^2}}\,\mathrm{d}x = \dfrac1a\int \operatorname{cosec}\theta\,\mathrm{d}\theta = \dfrac1a\ln\dfrac{x}{\sqrt{x^2+a^2}+a} + c\). (shown)

(b)(i) \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \dfrac{x^2}{xy} = \dfrac{x}{y}\); \(y\,\mathrm{d}y = x\,\mathrm{d}x \Rightarrow y^2 = x^2 + 9\) (using \(x=4, y=5\)), so \(y = \sqrt{x^2+9}\). (shown)

(b)(ii) \(\dfrac{\mathrm{d}x}{\mathrm{d}t} = x\sqrt{x^2+9}\). Using part (a) with \(a = 3\): \(t = \dfrac13\ln\dfrac{x}{\sqrt{x^2+9}+3} + \dfrac13\ln 2\).$$,
  12, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "By using the substitution \\(x = a\\tan\\theta\\), show that \\(\\displaystyle\\int \\dfrac{1}{x\\sqrt{x^2+a^2}}\\,\\mathrm{d}x = \\dfrac{1}{a}\\ln\\dfrac{x}{\\sqrt{x^2+a^2}+a} + c\\), where \\(x > 0\\) and \\(a > 0\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "Find \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(x\\) and \\(y\\), and by solving this differential equation show that \\(y = \\sqrt{x^2+9}\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Obtain a differential equation in terms of \\(x\\) and \\(t\\) only, and hence find an expression for \\(t\\) in terms of \\(x\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q6 — Probability
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  'Conditional probability and min/max of an event probability',
  $$Two independent probability problems.$$,
  'range', '0.124', 0.0005,
  $$(a) \(\mathrm{P}(A\cap B) = 0.2\,\mathrm{P}(A) = 0.6\,\mathrm{P}(B)\), and \(\mathrm{P}(A\cup B) = 1 - 0.3 = 0.7\). Let \(k = \mathrm{P}(A\cap B)\); then \(\mathrm{P}(A) = 5k\), \(\mathrm{P}(B) = \tfrac{5k}{3}\), and \(5k + \tfrac{5k}{3} - k = 0.7\) gives \(k = \dfrac{21}{170} \approx 0.124\).

(b) Using a Venn diagram with \(X, Z\) mutually exclusive: \(\mathrm{P}(X)_{\min} = 0.1\), \(\mathrm{P}(X)_{\max} = 0.6\).$$,
  6, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "If \\(\\mathrm{P}(B\\mid A) = 0.2\\), \\(\\mathrm{P}(A\\mid B) = 0.6\\) and \\(\\mathrm{P}(A'\\cap B') = 0.3\\), find \\(\\mathrm{P}(A\\cap B)\\). \\([3]\\)",
      "correct_answer": "0.124",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "b",
      "prompt_latex": "Events \\(X, Y, Z\\) are such that \\(X\\) and \\(Z\\) are mutually exclusive, with \\(\\mathrm{P}(X\\cap Y) = 0.1\\), \\(\\mathrm{P}(X'\\cap Y) = 0.35\\), \\(\\mathrm{P}(Y\\cap Z) = 0.2\\) and \\(\\mathrm{P}(X\\cup Y\\cup Z) = 0.95\\). Find the minimum and maximum values of \\(\\mathrm{P}(X)\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q7 — Permutation & Combination
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251007-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  'Grouping 12 people into three games',
  $$A gathering of 12 people breaks into 3 groups of 4 to play 3 different games: carrom, UNO and bridge.$$,
  'exact', '\frac{3}{10}', null,
  $$(a) \(\dbinom{12}{4}\dbinom{8}{4}\dbinom{4}{4} = 34650\).

(b) By complementation: \(34650 - 3\dbinom{10}{2}\dbinom{8}{4} = 25200\).

(c) Favourable \(= 3\cdot 2\cdot\dbinom{9}{2}\dbinom{7}{3} = 7560\), so \(\mathrm{P} = \dfrac{7560}{25200} = \dfrac{3}{10}\).$$,
  7, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the number of ways these 12 people can be grouped. \\([1]\\)",
      "correct_answer": "34650",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Aaron and Sandy do not want to be in the same group. Find the number of ways these 12 people can be grouped with this restriction. \\([3]\\)",
      "correct_answer": "25200",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Given that Aaron and Sandy are not in the same group, find the probability that a third person Billy is in the same group as Aaron. \\([3]\\)",
      "correct_answer": "\\frac{3}{10}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q8 — Discrete Random Variable (single task → one null part)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251008-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  'Find unknown probabilities from E(X) and Var(X)',
  $$The discrete random variable \(X\) has \(\mathrm{P}(X = x)\): \(0.1\) at \(x=-2\), \(a\) at \(x=-1\), \(0.3\) at \(x=0\), \(b\) at \(x=1\), \(c\) at \(x=3\). It is given that \(\mathrm{E}(X) = 0.9\) and \(\operatorname{Var}(X) = 2.99\).$$,
  'exact', '', null,
  $$From \(\mathrm{E}(X) = 0.9\), \(\mathrm{E}(X^2) = \operatorname{Var}(X) + 0.9^2 = 3.8\), and \(\sum \mathrm{P} = 1\):
solving the three equations gives \(a = 0.1\), \(b = 0.15\), \(c = 0.35\).$$,
  5, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q9 — Binomial Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a0251009-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  'Rotten oranges: binomial probabilities and an inspection scheme',
  $$A supplier's oranges are 1% rotten and are packed 20 to a box at random. \(X\) is the number of rotten oranges in a box; assume \(X \sim \mathrm{B}(20, 0.01)\). A box with between 2 and 5 rotten oranges (inclusive) is "substandard".$$,
  'range', '0.0196', 0.00005,
  $$(b) \(\mathrm{P}(2 \leq X \leq 5) = \mathrm{P}(X\leq 5) - \mathrm{P}(X\leq 1) = 0.0169\).

(c) \(\mathrm{E}(X) = 20(0.01) = 0.2\).

(d) \(Y \sim \mathrm{B}(10, 0.0169)\); \(\mathrm{P}(Y \leq 2) = 0.999\).

(e) Reject if first box has \(\geq 2\) rotten, or first box has exactly 1 and second box has \(\geq 2\):
\(\mathrm{P}(X\geq 2) + \mathrm{P}(X=1)\mathrm{P}(X\geq 2) = 0.0196\).$$,
  8, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "State in context two assumptions for \\(X\\) to follow a binomial distribution. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the probability that a randomly chosen box is substandard. \\([1]\\)",
      "correct_answer": "0.0169",
      "answer_type": "range",
      "tolerance": 0.00005
    },
    {
      "label": "c",
      "prompt_latex": "Find the expected number of rotten oranges in a box. \\([1]\\)",
      "correct_answer": "0.2",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "d",
      "prompt_latex": "A truckload of 10 randomly chosen boxes is sent to the seller. Find the probability that not more than 2 boxes are substandard. \\([2]\\)",
      "correct_answer": "0.999",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "e",
      "prompt_latex": "The seller accepts the truckload if the first box has no rotten oranges; rejects it if the first box has more than 1; if the first box has exactly 1, a second box is opened and the truckload is accepted only if it has at most 1 rotten orange. Find the probability that he rejects the entire truckload. \\([2]\\)",
      "correct_answer": "0.0196",
      "answer_type": "range",
      "tolerance": 0.00005
    }
  ]$$::jsonb
);

-- P2 Q10 — Correlation & Regression
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025100a-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  'Bamboo growth: model selection and residuals',
  $$Bamboo height \(h\) inches at age \(t\) weeks: \(t = 1,2,3,4,5,7,8,9\) and \(h = 3.6, 7.4, 10.2, 11.7, 12.6, 14.1, 14.5, 15.5\).$$,
  'range', '0.77', 0.005,
  $$(a) The points rise with a concave-down shape, so neither \(h = a+bt\) nor \(h = a+bt^2\) (\(b>0\)) fits.

(b) Model B (\(h = c + d\ln t\), \(r = 0.997\)) fits better than Model A (\(r = 0.974\)). Line: \(h = 3.890 + 5.311\ln t\).

(c) At \(t = 6\): \(h = 3.890 + 5.311\ln 6 = 13.4\). Reliable: \(t = 6\) is within the data range and \(r\) is close to 1.

(d) Unsuitable in the long run: as \(t\to\infty\), \(\ln t \to\infty\), so \(h\) grows without bound.

(e) \(S = \sum (h - H)^2 = 0.77\).

(f) Greater (or equal): \(S\) is the minimum sum of squared residuals for the least-squares line.$$,
  11, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Draw a scatter diagram and explain why the relationship between \\(h\\) and \\(t\\) is not well-modelled by \\(h = a + bt\\) or \\(h = a + bt^2\\) (\\(b > 0\\)). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "For Model A \\(h = c + d\\sqrt{t}\\) and Model B \\(h = c + d\\ln t\\), explain which is a better fit, and state the least squares regression line to 3 decimal places. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Use your regression line in (b) to estimate the height of a 6-week-old bamboo stalk, and comment on the reliability. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Comment on the suitability of using this model in the long run. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Let \\(H\\) be the height predicted by the regression line in (b) for each \\(t\\). Find \\(S = \\sum (h - H)^2\\), giving your answer to 2 decimal places. \\([1]\\)",
      "correct_answer": "0.77",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "f",
      "prompt_latex": "For \\(H' = p + q\\ln t\\) with constants \\(p, q\\), would \\(\\sum (h - H')^2\\) be greater or less than \\(S\\), and why? \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q11 — Hypothesis Testing
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025100b-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  'Hypothesis test on mean circuit-board test time',
  $$The time \(X\) (minutes) to test a circuit board has standard deviation \(0.63\); under ordinary conditions \(\mathrm{E}(X) = 5.82\). After an incentive scheme, a sample of 150 tests has mean \(5.74\); the supervisor claims testing is faster.$$,
  'exact', '', null,
  $$(a) \(H_0: \mu = 5.82\) vs \(H_1: \mu < 5.82\), where \(\mu\) is the population mean test time, at 5% significance.

(b) By CLT (\(n = 150\) large), \(z = \dfrac{5.74 - 5.82}{0.63/\sqrt{150}} = -1.56\), \(p\text{-value} = 0.0599 > 0.05\). Do not reject \(H_0\): insufficient evidence that testing is faster.

(c) No need — since \(n\) is large, by CLT \(\bar{X}\) is approximately normal regardless of the population distribution.

(d) The sample of 20 is small, so assume (1) \(X\) is normally distributed and (2) the population standard deviation is still \(0.63\).

(e) For "do not reject \(H_0\)" at 1%: \(\left|\dfrac{5.88 - \mu_0}{0.63/\sqrt{20}}\right| < 2.576\), giving \(5.52 < \mu_0 < 6.24\).$$,
  11, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "State appropriate hypotheses for the test of the claim, defining any symbols you use. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Test whether the supervisor's claim is justified at the 5% level of significance. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Explain whether there is a need for the supervisor to know anything about the population distribution of \\(X\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Two years later a sample of 20 tests has mean \\(5.88\\); an officer claims the mean differs from \\(\\mu_0\\). State two assumptions needed to carry out a hypothesis test for this claim. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Given that the officer does not reject the null hypothesis at the 1% level of significance, find the range of values of \\(\\mu_0\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q12 — Normal Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'a025100c-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  'Call-centre categorise/resolve times (Normal distributions)',
  $$State the parameters of any distribution you use. Time to categorise a call \(T \sim \mathrm{N}(2, 0.2^2)\). Routine resolve time \(X \sim \mathrm{N}(5, k)\); complex resolve time \(Y \sim \mathrm{N}(20, 6^2)\). Call duration \(=\) categorise time \(+\) resolve time.$$,
  'range', '0.998', 0.0005,
  $$(a) Bell curve for \(T \sim \mathrm{N}(2, 0.2^2)\); shade between \(1.2\) and \(2.8\) (essentially the whole area).

(b) \(T + X \sim \mathrm{N}(7, 0.2^2 + k)\); \(\mathrm{P}(T+X > 8) = 0.254\) gives \(\dfrac{1}{\sqrt{0.04 + k}} = 0.66196\), so \(k = 2.24\) (2 d.p.). (shown)

(c) \(\bar{Y} \sim \mathrm{N}\!\left(20, \tfrac{36}{n}\right)\); \(\mathrm{P}(\bar{Y} > 24) \leq 0.01\) gives \(n \geq 12.18\), so (with \(n \leq 20\)) \(\{n \in \mathbb{Z}^+ : 13 \leq n \leq 20\}\).

(d) Reduced complex time \(0.8Y\). \(W = 0.8Y_1 + 0.8Y_2 - 2X \sim \mathrm{N}(22, 55.04)\); \(\mathrm{P}(W > 0) = 0.998\).$$,
  12, 'ACJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Sketch the distribution of \\(T\\) and shade the area representing the probability that a randomly chosen call takes between 1.2 and 2.8 minutes to categorise. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "For a routine call (categorised then resolved), \\(\\mathrm{P}(\\text{duration} > 8) = 0.254\\). Show that \\(k = 2.24\\) correct to 2 decimal places. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "On a morning with 20 incoming calls, \\(n\\) are complex. Given \\(\\mathrm{P}(\\text{mean resolve time of the } n \\text{ complex calls} > 24) \\leq 0.01\\), find the set of values of \\(n\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "After a review, the time to resolve a complex call is reduced by 20%. Find the probability that the time to resolve 2 complex calls is more than twice the time to resolve a routine call. \\([4]\\)",
      "correct_answer": "0.998",
      "answer_type": "range",
      "tolerance": 0.0005
    }
  ]$$::jsonb
);
