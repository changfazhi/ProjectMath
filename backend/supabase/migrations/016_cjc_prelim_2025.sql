-- Migration 016: CJC H2 Math (9758) Prelim 2025 — Paper 1 (Q1–Q11) + Paper 2 (Q1–Q11)
-- UUIDs: b0250001–b025000b (P1), b0251001–b025100b (P2). All hex valid; distinct from topic UUIDs.
-- Source: 'CJC H2 Math Prelim 2025', difficulty: 3
-- Questions table already has GRANT ALL from earlier migrations (no new table here).

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 — Conics
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250001-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  3,
  'Hyperbola from vertices and asymptotes',
  $$The curve \(C\) has equation \(\dfrac{(x+p)^2}{r} - \dfrac{(y+q)^2}{9} = 1\), where \(p, q, r\) are constants. The vertices are \((-5,3)\) and \((-1,3)\), and the asymptotes are \(y = \dfrac{3}{2}x + \dfrac{15}{2}\) and \(y = -\dfrac{3}{2}x - \dfrac{3}{2}\).$$,
  'exact', '', null,
  $$(a) The centre is the intersection of the asymptotes: \((-3, 3)\). Since the centre is \((-p, -q)\), \(p = 3\), \(q = -3\). The \(x\)-distance from a vertex to the centre is \(2\), so \(\sqrt{r} = 2 \Rightarrow r = 4\).

(b) \((x-3)^2 + m(y-3)^2 = 3m\) is an ellipse centred \((3,3)\). \(C\) and \(D\) do not intersect when \(0 < m < 4\).$$,
  5, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the values of \\(p\\), \\(q\\) and \\(r\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The curve \\(D\\) has equation \\((x-3)^2 + m(y-3)^2 = 3m\\), where \\(m\\) is a positive constant. Find the range of \\(m\\) for which curves \\(C\\) and \\(D\\) do not intersect. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q2 — Sequences & Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Quadratic nth term and a telescoping sum',
  $$The \(n\)th term of a sequence is \(u_n = an^2 + bn + c\). The first three terms are \(2\), \(6\) and \(12\).$$,
  'exact', '\frac{1}{8}', null,
  $$(a) Using \(u_1=2, u_2=6, u_3=12\) (GC): \(a = 1\), \(b = 1\), \(c = 0\), so \(u_n = n(n+1)\).

(b) \(\displaystyle\sum_{n=1}^{\infty}\dfrac{1}{u_n} = 1\). Hence \(\displaystyle\sum_{n=8}^{\infty}\dfrac{1}{u_n} = 1 - \sum_{n=1}^{7}\dfrac{1}{u_n} = 1 - \left(1 - \dfrac{1}{8}\right) = \dfrac{1}{8}\).$$,
  6, 'CJC H2 Math Prelim 2025',
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
      "prompt_latex": "Given that \\(\\displaystyle\\sum_{n=1}^{N}\\dfrac{1}{u_n} = 1 - \\dfrac{1}{N+1}\\), find \\(\\displaystyle\\sum_{n=8}^{\\infty}\\dfrac{1}{u_n}\\). \\([3]\\)",
      "correct_answer": "\\frac{1}{8}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q3 — Parametric Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250003-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  'Parametric curve sketch and normal',
  $$A curve \(C\) has parametric equations \(x = \sin^2 t\), \(y = 1 + 2\sin t\), for \(-\dfrac{\pi}{2} \leq t \leq \dfrac{\pi}{2}\).$$,
  'exact', '', null,
  $$(a) Endpoints \((1,3)\) (at \(t=\tfrac{\pi}{2}\)) and \((1,-1)\) (at \(t=-\tfrac{\pi}{2}\)); \(y\)-intercept \((0,1)\) (at \(t=0\)).

(b) At \(\left(\tfrac{1}{4}, 2\right)\), \(\sin t = \tfrac12\), \(t = \tfrac{\pi}{6}\). \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \dfrac{2\cos t}{2\sin t\cos t} = \dfrac{1}{\sin t} = 2\), so the normal gradient is \(-\tfrac12\). Normal: \(y = -\tfrac12 x + \tfrac{17}{8}\), i.e. \(8y + 4x = 17\).$$,
  6, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Sketch \\(C\\), stating clearly the coordinates of the endpoints and the \\(y\\)-intercept(s). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the exact cartesian equation of \\(l\\), the normal to \\(C\\) at the point \\(\\left(\\tfrac{1}{4}, 2\\right)\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q4 — Definite Integral (periodic piecewise function)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250004-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Periodic piecewise function: graph and area',
  $$\(\mathrm{f}(x) = \begin{cases} 2 - \dfrac{2}{\pi}x & 0 \leq x < \pi \\ x\sin x & \pi \leq x < 2\pi \end{cases}\) and \(\mathrm{f}(x) = \mathrm{f}(x + 2\pi)\) for all real \(x\).$$,
  'exact', '2\pi+1', null,
  $$(a) Periodic, period \(2\pi\): a line from \((0,2)\) down to \((\pi,0)\), then the \(x\sin x\) arc dipping below the axis to \((2\pi,0)\), repeated.

(b) Area \(= \displaystyle\int_0^{\pi}\!\left(2 - \tfrac{2}{\pi}x\right)\mathrm{d}x + \left|\int_{\pi}^{3\pi/2} x\sin x\,\mathrm{d}x\right| = \pi + (\pi + 1) = 2\pi + 1\) units\(^2\).$$,
  7, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Sketch the graph of \\(y = \\mathrm{f}(x)\\) for \\(-\\pi \\leq x < 4\\pi\\). (You do not need to label stationary points.) \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the exact area bounded by the curve \\(y = \\mathrm{f}(x)\\), the \\(x\\)-axis and the lines \\(x = 0\\) and \\(x = \\dfrac{3\\pi}{2}\\). \\([4]\\)",
      "correct_answer": "2\\pi+1",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q5 — Sequences & Series (recurrence limit, graph, monotonicity)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250005-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Recurrence: limit and monotonicity via a graph',
  $$A sequence of negative real numbers is given by \(u_1 = -1\) and \(u_{n+1} = \dfrac{-2u_n + 6}{u_n - 1}\), for \(n \geq 1\).$$,
  'exact', '-3', null,
  $$(a) As \(n\to\infty\), \(u_n, u_{n+1} \to l\): \(l = \dfrac{-2l+6}{l-1} \Rightarrow l^2 + l - 6 = 0 \Rightarrow (l+3)(l-2)=0\). Since the terms are negative, \(l = -3\).

(b) \(y = \dfrac{-2x+6}{x-1} - x\): asymptotes \(x = 1\) and \(y = -x - 2\); crosses the axes at \((-3,0)\), \((2,0)\), \((0,-6)\).

(c) \(u_{n+1} - u_n = \dfrac{-2u_n+6}{u_n-1} - u_n\). From the graph, when \(x < -3\), \(y > 0\); so if \(u_n < -3\), \(u_{n+1} - u_n > 0\), i.e. \(u_{n+1} > u_n\). (shown)$$,
  8, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that \\(u_n \\to l\\) as \\(n \\to \\infty\\), find the value of \\(l\\). \\([3]\\)",
      "correct_answer": "-3",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch the graph of \\(y = \\dfrac{-2x+6}{x-1} - x\\), stating the equations of the asymptotes and the coordinates of the points where it crosses the axes. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Hence show that \\(u_{n+1} > u_n\\) if \\(u_n < l\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q6 — Vector (Basic)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250006-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  'Unit vector, perpendicularity and a vector-product ratio',
  $$Relative to the origin \(O\), points \(A\), \(B\), \(C\) have position vectors \(\mathbf{a}\), \(\mathbf{b}\), \(\mathbf{c}\). It is given that \(\mathbf{a}\) is a unit vector and \(\mathbf{b}\) is perpendicular to \(\mathbf{b} - \mathbf{a}\).$$,
  'exact', '\frac{3}{2}', null,
  $$(a) \(\mathbf{b}\cdot(\mathbf{b}-\mathbf{a}) = 0 \Rightarrow |\mathbf{b}|^2 = |\mathbf{b}|\cos\theta\) (as \(|\mathbf{a}|=1\)), so \(|\mathbf{b}| = \cos\theta\). Since \(\mathbf{a},\mathbf{b}\) are not parallel and \(|\mathbf{b}|>0\), \(0 < |\mathbf{b}| < 1\). (shown)

Given \(|\mathbf{b}| = \tfrac12\) and \(C\) on \(AB\) with \(AC:CB = 2:1\), so \(\mathbf{c} = \tfrac13\mathbf{a} + \tfrac23\mathbf{b}\).

(b) \(\mathbf{a}\cdot\mathbf{b} = |\mathbf{b}|^2 = \tfrac14\); \(\mathbf{a}\cdot\mathbf{c} = \tfrac13 + \tfrac23(\tfrac14) = \tfrac12\). \(\mathbf{a}\cdot\mathbf{c}\) is the length of projection of \(\mathbf{c}\) on \(\mathbf{a}\).

(c) \(\mathbf{a}\times\mathbf{c} = \tfrac23\mathbf{a}\times\mathbf{b}\), so \(\dfrac{|\mathbf{a}\times\mathbf{b}|}{|\mathbf{a}\times\mathbf{c}|} = \dfrac{1}{\tfrac23} = \dfrac{3}{2}\).$$,
  9, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(0 < |\\mathbf{b}| < 1\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "It is given further that \\(|\\mathbf{b}| = \\tfrac12\\) and \\(C\\) lies on \\(AB\\) with \\(AC:CB = 2:1\\). Find the value of \\(\\mathbf{a}\\cdot\\mathbf{c}\\) and state the geometrical interpretation of \\(\\mathbf{a}\\cdot\\mathbf{c}\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the value of \\(\\dfrac{|\\mathbf{a}\\times\\mathbf{b}|}{|\\mathbf{a}\\times\\mathbf{c}|}\\). \\([2]\\)",
      "correct_answer": "\\frac{3}{2}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q7 — Maclaurin Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250007-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  'Maclaurin series from an implicit relation with arctan',
  $$The curve \(y = \mathrm{f}(x)\) satisfies \(\ln y = \dfrac{\pi}{4} - \tan^{-1}(\mathrm{e}^x)\).$$,
  'exact', '', null,
  $$(a) Differentiating: \(\dfrac{1}{y}\dfrac{\mathrm{d}y}{\mathrm{d}x} = -\dfrac{\mathrm{e}^x}{1 + \mathrm{e}^{2x}}\), so \((1 + \mathrm{e}^{2x})\dfrac{\mathrm{d}y}{\mathrm{d}x} + y\mathrm{e}^x = 0\). (shown)

(b) At \(x=0\): \(y = 1\), \(y' = -\tfrac12\), \(y'' = \tfrac14\). So \(y = 1 - \tfrac12 x + \tfrac18 x^2 + \cdots\).

(c) \(\dfrac{\mathrm{e}^{\frac{\pi}{4} - \tan^{-1}(\mathrm{e}^x)}}{\mathrm{e}^x + 1} = \dfrac{y}{\mathrm{e}^x+1}\); using \(\mathrm{e}^x + 1 = 2 + x + \tfrac12 x^2 + \cdots\) gives \(\tfrac12 - \tfrac12 x + \tfrac{3}{8}x^2 + \cdots\).$$,
  9, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\((1 + \\mathrm{e}^{2x})\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} + y\\mathrm{e}^x = 0\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the Maclaurin series for \\(y\\), up to and including the term in \\(x^2\\). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Deduce the series expansion for \\(\\dfrac{\\mathrm{e}^{\\frac{\\pi}{4} - \\tan^{-1}(\\mathrm{e}^x)}}{\\mathrm{e}^x + 1}\\), up to and including the term in \\(x^2\\), giving the coefficients in exact form. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q8 — Vector (Plane)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250008-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Plane, angle with a line, foot of perpendicular, locus',
  $$The plane \(p\) passes through \(A(1,0,2)\), \(B(2,-1,3)\) and \(C(-4,-1,0)\). The line \(l\) has equation \(\mathbf{r} = \begin{pmatrix}2\\0\\5\end{pmatrix} + \lambda\begin{pmatrix}2\\-1\\-1\end{pmatrix}\), \(\lambda \in \mathbb{R}\).$$,
  'range', '56.4', 0.05,
  $$(a) \(\overrightarrow{AB}\times\overrightarrow{AC} = (1,-1,1)\times(-5,-1,-2) = (3,-3,-6) = 3(1,-1,-2)\). A normal is \((1,-1,-2)\); \(\mathbf{r}\cdot(1,-1,-2) = 1-0-4 = -3\), so \(x - y - 2z = -3\). (shown)

(b) \(\sin\theta = \dfrac{|(1,-1,-2)\cdot(2,-1,-1)|}{\sqrt{6}\sqrt{6}} = \dfrac{5}{6} \Rightarrow \theta = 56.4^\circ\) (1 d.p.).

(c) Foot \(F\) of perpendicular from \(Q(3,4,-2)\): \(F = (2,5,0)\).

(d) \(R\) lies on \(p\) at distance \(\sqrt{22}\) from \(Q\). \(|\overrightarrow{QF}|^2 = 6\), so the locus is a circle on \(p\), centre \((2,5,0)\), radius \(\sqrt{22-6} = 4\).$$,
  11, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that a cartesian equation of \\(p\\) is \\(x - y - 2z = -3\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the acute angle between \\(l\\) and \\(p\\), in degrees. \\([2]\\)",
      "correct_answer": "56.4",
      "answer_type": "range",
      "tolerance": 0.05
    },
    {
      "label": "c",
      "prompt_latex": "A variable point \\(R\\) lies on \\(p\\) and is at a distance of \\(\\sqrt{22}\\) from the point \\(Q(3,4,-2)\\). Find the foot of perpendicular from \\(Q\\) to \\(p\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Hence describe geometrically the path traced by \\(R\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q9 — Differential Equations (duckweed)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0250009-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Duckweed growth differential equation',
  $$Duckweed forms a circular patch of radius \(r\) m at the centre of a circular pond of radius 10 m. The rate of increase of the area covered by duckweed is directly proportional to the area of the pond not yet covered.$$,
  'exact', '', null,
  $$(a) \(\dfrac{\mathrm{d}A}{\mathrm{d}t} = k(100\pi - \pi r^2)\), and \(A = \pi r^2 \Rightarrow \dfrac{\mathrm{d}A}{\mathrm{d}t} = 2\pi r\dfrac{\mathrm{d}r}{\mathrm{d}t}\). Hence \(\dfrac{\mathrm{d}r}{\mathrm{d}t} = \dfrac{k(100 - r^2)}{2r}\). (shown)

(b) Separating: \(\displaystyle\int\dfrac{2r}{100 - r^2}\,\mathrm{d}r = \int k\,\mathrm{d}t\), so \(-\ln|100 - r^2| = kt + C'\), giving \(100 - r^2 = Q\mathrm{e}^{-kt}\). With \(r(0)=1\), \(Q = 99\). Hence \(r = \sqrt{100 - 99\mathrm{e}^{-kt}}\) (\(P = 100\), \(Q = 99\)).

(c) Increasing curve from \((0,1)\) towards the horizontal asymptote \(r = 10\).$$,
  11, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that the radius of the pond is 10 m, show that the radius \\(r\\) m satisfies \\(\\dfrac{\\mathrm{d}r}{\\mathrm{d}t} = \\dfrac{k(100 - r^2)}{2r}\\), \\(k > 0\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The initial radius is 1 m. Solve the differential equation, expressing \\(r\\) in the form \\(r = \\sqrt{P - Q\\mathrm{e}^{-kt}}\\), where \\(P\\) and \\(Q\\) are constants. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Sketch the graph of \\(r\\) against \\(t\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q10 — Sequences & Series (savings: GP then AP)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b025000a-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Car savings: geometric interest then arithmetic deposits',
  $$Mr Huat needs to save at least \$150\,000. He deposits \$6000 on the first day of each month; at each month end the total (including interest) increases by 3%. His first deposit is on 1 January 2026.$$,
  'range', '1182', 0.5,
  $$(a) End of Dec 2026 \(= \displaystyle\sum_{k=1}^{12} 6000(1.03)^k = 6000(1.03)\dfrac{1.03^{12}-1}{1.03-1} = \$87\,706.74\). (shown)

(b) End of \(n\)th month \(= 206000(1.03^n - 1) \geq 150000 \Rightarrow 1.03^n \geq 1.7282 \Rightarrow n \geq 18.5\). Least \(n = 19\): July 2027. The total exceeds \$150000 at the start of July 2027 (with the 19th deposit), i.e. on the first day.

(c) No interest, deposits up by \$\(d\) each month: end of Dec 2026 \(= \dfrac{12}{2}(2\cdot 6000 + 11d) = 72000 + 66d\).

(d) \(72000 + 66d \geq 150000 \Rightarrow d \geq 1181.8\), so minimum \(d = \$1182\) (nearest integer).$$,
  12, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the total amount in the account at the end of December 2026 is \\$87\\,706.74 (to 2 d.p.). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the month and year in which the total first exceeds \\$150\\,000, and explain whether this occurs on the first or last day of the month. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "In a different account with no interest, he deposits \\$6000 on 1 January 2026 and \\$\\(d\\) more than the previous month on the first day of each subsequent month. Find, in terms of \\(d\\), the total at the end of December 2026. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Hence find the minimum value of \\(d\\) so that he can buy the car by the end of December 2026, to the nearest integer. \\([2]\\)",
      "correct_answer": "1182",
      "answer_type": "range",
      "tolerance": 0.5
    }
  ]$$::jsonb
);

-- P1 Q11 — Integration Technique (partial fractions, area, volume)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b025000b-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  'Partial fractions, area and volume of revolution',
  $$Consider \(\dfrac{3x^2}{(x+1)(3x^2+x+1)}\).$$,
  'range', '0.715', 0.0005,
  $$(a)(i) \(\dfrac{3x^2}{(x+1)(3x^2+x+1)} = \dfrac{1}{x+1} - \dfrac{1}{3x^2+x+1}\) (so \(A = 1\), \(B = -1\)).

(a)(ii) \(\displaystyle\int = \ln|x+1| - \dfrac{2}{\sqrt{11}}\tan^{-1}\!\left(\dfrac{6x+1}{\sqrt{11}}\right) + C\).

(b)(i) For \(x \geq 0\): horizontal asymptote \(y = 0\), passes through \((0,0)\); \(R\) bounded by the curve, \(x = 4\) and the \(x\)-axis.

(b)(ii) Area \(= \ln 5 + \dfrac{2}{\sqrt{11}}\left[\tan^{-1}\dfrac{1}{\sqrt{11}} - \tan^{-1}\dfrac{25}{\sqrt{11}}\right]\).

(b)(iii) Volume \(= \pi\displaystyle\int_0^4 \left(\dfrac{3x^2}{(x+1)(3x^2+x+1)}\right)^2\mathrm{d}x = 0.715\) (3 s.f.).$$,
  12, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "Show that \\(\\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\) can be expressed as \\(\\dfrac{A}{x+1} + \\dfrac{B}{3x^2+x+1}\\), where \\(A\\) and \\(B\\) are constants to be determined. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Hence find \\(\\displaystyle\\int \\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\,\\mathrm{d}x\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "The region \\(R\\) is bounded by the curve \\(y = \\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\), the line \\(x = 4\\) and the \\(x\\)-axis. Sketch the graph for \\(x \\geq 0\\), giving intercepts and asymptotes, and shade \\(R\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Find the exact area of \\(R\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "biii",
      "prompt_latex": "Find the volume of the solid generated when \\(R\\) is rotated through \\(2\\pi\\) radians about the \\(x\\)-axis. \\([2]\\)",
      "correct_answer": "0.715",
      "answer_type": "range",
      "tolerance": 0.0005
    }
  ]$$::jsonb
);

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q1 — Graphing Techniques (graph transformations)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251001-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  'Sketching related graphs from y=f(|x|) and y=f''(x)',
  $$The graph of \(y = \mathrm{f}(|x|)\) has turning points at \((-3,4)\) and \((3,4)\), crosses the \(x\)-axis at \((-2,0)\) and \((2,0)\), with asymptotes \(x = -1\), \(x = 1\) and \(y = 2\). The graph of \(y = \mathrm{f}'(x)\) crosses the \(x\)-axis at \((3,0)\), with asymptotes \(x = 1\) and \(y = 0\).$$,
  'exact', '', null,
  $$(a) \(y = \mathrm{f}(x)\): the \(x \geq 0\) part of \(y = \mathrm{f}(|x|)\) (turning point \((3,4)\), intercept \((2,0)\), asymptotes \(x=1\), \(y=2\)), with the \(x<0\) part inferred from \(\mathrm{f}'\).

(b) \(y = \dfrac{1}{\mathrm{f}'(x)}\): \(x\)-intercept \((1,0)\), vertical asymptote \(x = 3\), maximum point in the 4th quadrant.

(c) \(y = -\mathrm{f}(|x-1|)\): reflect \(y = \mathrm{f}(|x|)\) in the \(x\)-axis and translate 1 unit in the positive \(x\)-direction.$$,
  8, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Sketch \\(y = \\mathrm{f}(x)\\), labelling asymptotes, axial intercepts and turning points where applicable. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch \\(y = \\dfrac{1}{\\mathrm{f}'(x)}\\), labelling asymptotes, axial intercepts and turning points where applicable. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Sketch \\(y = -\\mathrm{f}(|x-1|)\\), labelling asymptotes, axial intercepts and turning points where applicable. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q2 — Functions
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251002-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Composite existence and a restricted-domain inverse',
  $$\(\mathrm{f}: x \mapsto \dfrac{4}{(x-4)^2}\), \(x \in \mathbb{R}, x \neq 4\); \(\mathrm{g}: x \mapsto \ln\!\left(1 + \dfrac{1}{x}\right)\), \(x \in \mathbb{R}, x > 0\).$$,
  'exact', '', null,
  $$(a) \(y = \mathrm{f}(x)\): vertical asymptote \(x = 4\), horizontal asymptote \(y = 0\), passes through \(\left(0, \tfrac14\right)\), no turning point.

(b) \(R_{\mathrm{f}} = (0, \infty) = D_{\mathrm{g}}\), so \(\mathrm{gf}\) exists. \(\mathrm{gf}(x) = \ln\!\left(1 + \dfrac{(x-4)^2}{4}\right)\), \(D_{\mathrm{gf}} = \mathbb{R}\setminus\{4\}\), \(R_{\mathrm{gf}} = (0, \infty)\).

(c) The vertex of \(\mathrm{f}\) is at \(x = 4\), so the largest \(k\) (with \(x < k\)) for \(\mathrm{f}^{-1}\) to exist is \(4\).

(d) \(y = \dfrac{4}{(x-4)^2} \Rightarrow x = 4 - \dfrac{2}{\sqrt{y}}\) (rej. \(+\) since \(x < 4\)). \(\mathrm{f}^{-1}: x \mapsto 4 - \dfrac{2}{\sqrt{x}}\), \(x > 0\).$$,
  10, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Sketch \\(y = \\mathrm{f}(x)\\), stating asymptotes, axial intercepts and turning points if any. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that \\(\\mathrm{gf}\\) exists. Hence find the rule, domain and range of \\(\\mathrm{gf}\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "If the domain of \\(\\mathrm{f}\\) is further restricted to \\(x < k\\), state the largest value of \\(k\\) for which \\(\\mathrm{f}^{-1}\\) exists. \\([1]\\)",
      "correct_answer": "4",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Using the restricted domain found in part (c), find \\(\\mathrm{f}^{-1}\\) in a similar form. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q3 — App. of Differentiation (hexagonal pyramid optimisation)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251003-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Maximising the volume of a hexagonal pyramid',
  $$A right hexagonal pyramid is folded from a star net of equal edge length \(a\) cm: a hexagonal base of edge \(x\) cm (six equilateral triangles) and six isosceles triangles of base \(x\) and slant side \(a\), giving vertical height \(h\) cm. Its volume is \(V = \dfrac{\sqrt{3}}{2}x^2 h\).$$,
  'exact', '(\sqrt{5}+\sqrt{3})a^2', null,
  $$(a) By Pythagoras \(h = \sqrt{a^2 - x^2}\), so \(V = \dfrac{\sqrt{3}}{2}x^2\sqrt{a^2-x^2}\) and \(V^2 = \dfrac{3}{4}x^4(a^2 - x^2) = \dfrac{3}{4}(a^2 x^4 - x^6)\). (shown)

(b) \(\dfrac{\mathrm{d}(V^2)}{\mathrm{d}x} = 0 \Rightarrow 4a^2 x^3 - 6x^5 = 0 \Rightarrow x^2 = \dfrac{2}{3}a^2\). Then \(V_{\max} = \sqrt{\dfrac{a^6}{9}} = \dfrac{a^3}{3}\).

(c) \(A = 6\cdot\tfrac12 x\sqrt{a^2 - \tfrac{x^2}{4}} + 6\cdot\tfrac12 x\sqrt{x^2 - \tfrac{x^2}{4}}\); with \(x^2 = \tfrac23 a^2\), \(A = \left(\sqrt{5} + \sqrt{3}\right)a^2\).$$,
  10, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the volume satisfies \\(V^2 = \\dfrac{3}{4}(a^2 x^4 - x^6)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find, in terms of \\(a\\), the maximum possible volume of the hexagonal pyramid. (You need not show it is a maximum.) \\([4]\\)",
      "correct_answer": "\\frac{a^3}{3}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find, in terms of \\(a\\), the total surface area of the hexagonal pyramid when the volume is a maximum. \\([4]\\)",
      "correct_answer": "(\\sqrt{5}+\\sqrt{3})a^2",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q4 — Complex Number
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251004-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  'Quartic with a complex root and an Argand quadrilateral',
  $$One of the roots of \(2z^4 - 14z^3 + 33z^2 - 26z + p = 0\), where \(p\) is a constant, is \(3 + \mathrm{i}\).$$,
  'exact', '', null,
  $$(a) The claim that \(3 - \mathrm{i}\) is a root need not be true: the conjugate root theorem requires all coefficients to be real, but \(p\) is not stated to be real.

(b) Substituting \(z = 3+\mathrm{i}\): \(2(3+\mathrm{i})^4 - 14(3+\mathrm{i})^3 + 33(3+\mathrm{i})^2 - 26(3+\mathrm{i}) + p = 0\) gives \(p = 10\). (shown)

(c) With \(p = 10\) (real), roots: \(3 \pm \mathrm{i}\) and (from \(2z^2 - 2z + 1 = 0\)) \(\dfrac{1 \pm \mathrm{i}}{2}\).

(d) The four points \((3,1), (3,-1), \left(\tfrac12,\tfrac12\right), \left(\tfrac12,-\tfrac12\right)\) form a trapezium of area \(\dfrac12(1+2)(2.5) = \dfrac{15}{4}\) units\(^2\).$$,
  12, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Based on the above information only, a student claims that the equation has a root \\(3 - \\mathrm{i}\\). State, with a reason, why the student's claim may not be true. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Show that \\(p = 10\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "For the rest of this question, do not use a calculator. Find the roots of \\(2z^4 - 14z^3 + 33z^2 - 26z + 10 = 0\\) and mark them clearly on a single labelled Argand diagram. \\([7]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "The points in part (c) form the vertices of a quadrilateral. Identify the type of quadrilateral and determine its area. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q5 — Sampling and Estimation (sample vs population, combinations)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251005-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  3,
  'Basketball club: sample vs population and team selection',
  $$A basketball club has 5 centers, 8 forwards and 7 guards (20 members). The coach gives a questionnaire to all members and receives replies from everyone. A match team consists of 1 center, 2 forwards and 2 guards.$$,
  'exact', '2940', null,
  $$(a) The 20 members form a population, since the coach surveyed all members of the club.

(b) A random sample reduces bias / is fair / is representative of the whole membership.

(c) Number of teams \(= {}^5C_1 \times {}^8C_2 \times {}^7C_2 = 5 \times 28 \times 21 = 2940\).$$,
  3, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Explain whether the 20 members form a sample or a population. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Explain an advantage of choosing a random sample in each category of members for the match. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "How many different teams can be formed? \\([1]\\)",
      "correct_answer": "2940",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q6 — Probability (Venn diagram with independence)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  'Student leaders, sports CCA and science faculty',
  $$Of 100 students: 25 are student leaders (\(A\)), 30 are in a sports CCA (\(B\)), 40 study in a science faculty (\(C\)); \(\mathrm{n}(A\cap B) = 15\); \(\mathrm{n}(A\cap B\cap C) = x\); the number in a sports CCA and science faculty but not a leader is \(y\). \(A\) and \(C\) are independent.$$,
  'exact', '', null,
  $$(a) Since \(A, C\) independent, \(\mathrm{P}(A\cap C) = \tfrac{25}{100}\cdot\tfrac{40}{100} = \tfrac{10}{100}\), so \(\mathrm{n}(A\cap C) = 10\). The Venn regions are \(x\), \(15-x\), \(10-x\), \(15-y\), \(y\), \(30-y\), with outside \(30 + y\).

(b) \(B, C\) independent: \(\mathrm{n}(B\cap C) = 12\), so \(x + y = 12 \Rightarrow y = 12 - x\). With \(x \geq 0\) and \(\mathrm{n}(A\cap B'\cap C) = 10 - x \geq 0\): greatest \(y = 12\) (at \(x=0\)), least \(y = 2\) (at \(x=10\)).$$,
  7, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Complete a Venn diagram representing all the above information, giving expressions in terms of \\(x\\) and \\(y\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "It is further given that \\(B\\) and \\(C\\) are independent. Find \\(y\\) in terms of \\(x\\). Hence find the greatest and least possible values of \\(y\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q7 — Discrete Random Variable (mystery boxes)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251007-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  'Mystery boxes: distribution and break-even count',
  $$A doll is hidden in one of \(n\) identical boxes. A player opens boxes (paying per box) until the doll is found, up to 3 tries. \(X\) is the number of empty boxes opened in a game.$$,
  'exact', '16', null,
  $$(a) \(\mathrm{P}(X=2) = \dfrac{n-1}{n}\cdot\dfrac{n-2}{n-1}\cdot\dfrac{1}{n-2} = \dfrac{1}{n}\). (shown)

(b) \(\mathrm{P}(X=0)=\mathrm{P}(X=1)=\mathrm{P}(X=2)=\dfrac1n\), \(\mathrm{P}(X=3)=\dfrac{n-3}{n}\).

(c) With \(n=10\), \(\sigma = 1.0198\), so \(\mathrm{P}(X \leq \sigma) = \mathrm{P}(X=0)+\mathrm{P}(X=1) = 0.2\).

(d) Amounts \$5, \$8, \$10.50, \$10.50 (paid over the tries). \(\mathrm{E}(\text{amount}) = \dfrac{10.5n - 8}{n}\); for no profit or loss against a \$10 cost, \(\dfrac{10.5n-8}{n} = 10 \Rightarrow n = 16\).$$,
  8, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\mathrm{P}(X = 2) = \\dfrac{1}{n}\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the probability distribution of \\(X\\), leaving your answers in terms of \\(n\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "If \\(n = 10\\), find \\(\\mathrm{P}(X \\leq \\sigma)\\), where \\(\\sigma\\) is the standard deviation of \\(X\\). \\([2]\\)",
      "correct_answer": "0.2",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "d",
      "prompt_latex": "If the cost price of a doll is \\$10, find the number of boxes \\(n\\) the owner should prepare so that he makes neither a profit nor a loss. \\([3]\\)",
      "correct_answer": "16",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q8 — Binomial Distribution (pralines quality control)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251008-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  'Pralines: binomial model and a two-box acceptance scheme',
  $$Pralines are packed in boxes of 16. The proportion exceeding the recommended sugar content is \(p\); \(X\) is the number in a box that exceed it.$$,
  'range', '0.217', 0.0005,
  $$(a)(i) Assumptions: the probability \(p\) is constant for every praline; whether a praline exceeds the content is independent of any other praline.

(a)(ii) \(X \sim \mathrm{B}(16, p)\) with mode 2: \(\mathrm{P}(X=2) > \mathrm{P}(X=1)\) gives \(p > \tfrac{2}{17}\), and \(\mathrm{P}(X=2) > \mathrm{P}(X=3)\) gives \(p < \tfrac{3}{17}\). So \(\tfrac{2}{17} < p < \tfrac{3}{17}\).

With \(p = 0.15\):
(b)(i) \(\mathrm{P}(\text{accepted}) = \mathrm{P}(X\leq 1)[1 + \mathrm{P}(X=2)] = 0.363\) (3 s.f.).

(b)(ii) \(\mathrm{P}(\text{2nd box tested} \mid \text{accepted}) = \dfrac{\mathrm{P}(X=2)\mathrm{P}(X\leq1)}{0.3627} = 0.217\) (3 s.f.).$$,
  9, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "State, in context, two assumptions needed for \\(X\\) to be well-modelled by a binomial distribution. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Given that the most probable number of pralines exceeding the content is 2, find the exact range of values \\(p\\) can take. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "A batch is accepted if a first sample box has at most 1 such praline; rejected if 3 or more; if exactly 2, a second box is tested and the batch accepted only if that box has at most 1. With \\(p = 0.15\\), find the probability that the batch is accepted. \\([2]\\)",
      "correct_answer": "0.363",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "bii",
      "prompt_latex": "Given that the batch is accepted, find the probability that a second box of pralines is tested. \\([2]\\)",
      "correct_answer": "0.217",
      "answer_type": "range",
      "tolerance": 0.0005
    }
  ]$$::jsonb
);

-- P2 Q9 — Correlation & Regression (screen-time vs score)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b0251009-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  'Screen-time vs exam score regression',
  $$For 7 students, screen-time \(h\) hours/week and average score \(s\): \(h = 8.5, 14, 20, 27, 10.5, 17, 23\) and \(s = 68, 61, 44, 12, \alpha, 58, 31\).$$,
  'exact', '', null,
  $$(a) The regression line of \(s\) on \(h\) passes through \((\bar{h}, \bar{s})\): \(\bar{h} = 17.1429\), \(\bar{s} = -3.00799(17.1429) + 100.27974 = 48.714\). From \(\dfrac{68+61+44+12+\alpha+58+31}{7} = 48.714\), \(\alpha = 67.0\). (shown)

(b) Scatter diagram: points decreasing, concave-up.

(c) \(r\) for \(s = kh^2 + c\) is \(-0.991\), closer to \(-1\) than \(-0.961\) for the linear model; from GC \(s = -0.0873h^2 + 77.7\).

(d) At \(h = 7\): \(s = 73.4\). Unreliable: \(h = 7\) is outside the data range (extrapolation).

(e) Correlation is not causation; other factors may contribute.$$,
  9, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that the regression line of \\(s\\) on \\(h\\) is \\(s = -3.00799h + 100.27974\\), show that \\(\\alpha = 67.0\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Draw a scatter diagram for the data. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Explain why \\(s = kh^2 + c\\) is the better model compared with a linear model, giving appropriate reasons, and state the values of \\(k\\) and \\(c\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Using the better model, estimate the score for a student who spends 7 hours of screen-time a week, and comment on the reliability of the estimate. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "The teacher concludes that increased screen-time will cause exam scores to decrease. Comment on the validity of this statement. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q10 — Normal Distribution (fishing vessels)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b025100a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  'Fishing vessels: combinations of normal variables',
  $$Fish caught by Standard vessels \(S \sim \mathrm{N}(300, \sigma^2)\) and Large vessels \(L \sim \mathrm{N}(540, 110^2)\) (kg).$$,
  'exact', '24', null,
  $$(a) \(\mathrm{P}(S > 400) = 0.08 \Rightarrow \dfrac{400-300}{\sigma} = 1.40507 \Rightarrow \sigma = 71.2\) (3 s.f.). (shown)

(b) \(S_1+S_2+S_3+L_1+L_2 \sim \mathrm{N}(1980, 198.484^2)\); \(\mathrm{P}(\geq 2100) = 0.273\).

(c) Assumption: the catches of all vessels are independent of one another.

(d) Premium vessels catch twice as much: \(3S + 2L \sim \mathrm{N}(1980, 306.574^2)\); \(\mathrm{P}(\geq 2100) = 0.348\).

(e) \(\bar{L} \sim \mathrm{N}\!\left(540, \tfrac{110^2}{n}\right)\); \(\mathrm{P}(\bar{L} < 552) \geq 0.7 \Rightarrow \dfrac{6\sqrt{n}}{55} \geq 0.5244 \Rightarrow n \geq 23.1\). Least \(n = 24\).$$,
  13, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "A Standard vessel returning with more than 400 kg is a Bumper catch, which occurs 8% of the time. Show that \\(\\sigma \\approx 71.2\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "On a trip, 3 Standard and 2 Large vessels are sent, with a target of at least 2100 kg. Find the probability that they meet the target. \\([2]\\)",
      "correct_answer": "0.273",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "c",
      "prompt_latex": "State an assumption needed in your calculation in part (b). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Company B uses 1 Premium-Standard and 1 Premium-Large vessel, each catching twice as much, with the same target of 2100 kg. Find the probability that these two vessels meet the target. \\([2]\\)",
      "correct_answer": "0.348",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "e",
      "prompt_latex": "In a sample of \\(n\\) trips, the probability that a Large vessel's average catch is less than 552 kg is at least 0.7. Find the least possible value of \\(n\\). \\([3]\\)",
      "correct_answer": "24",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q11 — Hypothesis Testing (football first-goal time)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'b025100b-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  'Hypothesis test on time to score the first goal',
  $$EastHam's average time to score their first goal is 50 minutes. After a new tactic, for a sample of 35 matches the total first-goal time is 1650 minutes with variance \(250\) minutes\(^2\). The coach tests whether the average time has decreased.$$,
  'exact', '', null,
  $$(a) Since \(n = 35\) is large, by the Central Limit Theorem \(\bar{X}\) is approximately normal, so no assumption about the distribution of the time is needed.

(b) Unbiased mean \(= \dfrac{1650}{35} = 47.143\); unbiased variance \(s^2 = \dfrac{35}{34}(250) = 257.353\) (3 d.p.).

(c) \(H_0: \mu = 50\) vs \(H_1: \mu < 50\). By CLT \(\bar{X} \sim \mathrm{N}\!\left(50, \tfrac{257.353}{35}\right)\); \(z = -1.054\), \(p\text{-value} = 0.146 > 0.1\). Do not reject \(H_0\): insufficient evidence at the 10% level that the average time has decreased.$$,
  7, 'CJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Explain why the coach can carry out a hypothesis test without any assumption about the distribution of the time taken to score the first goal. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find unbiased estimates of the population mean and variance, giving your answers to 3 decimal places. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Carry out the test at the 10% level of significance, stating your hypotheses and defining any symbols you use. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);
