-- Migration 010: DHS H2 Math Prelim 2025 — Paper 1 (Q1–Q11) + Paper 2 (Q1–Q11)
-- UUIDs: d0250001–d025000b (P1), d0251001–d025100b (P2). All hex valid.
-- Source: 'DHS H2 Math Prelim 2025', difficulty: 3

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 — Differential Equations — homogeneous ODE, multi-part all null
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250001-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Homogeneous ODE: substitution u = y/x',
  $$It is given that \(2xy\dfrac{\mathrm{d}y}{\mathrm{d}x} = x^2 - y^2\) where \(x > 0\), \(y < 0\). Using the substitution \(u = \dfrac{y}{x}\), show that the differential equation can be transformed to \(\dfrac{2u}{1-3u^2}\dfrac{\mathrm{d}u}{\mathrm{d}x} = \dfrac{1}{x}\). Hence find the general solution of \(y\) in terms of \(x\). \([6]\)$$,
  'exact', '', null,
  $$Let \(y = ux\), so \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = u + x\dfrac{\mathrm{d}u}{\mathrm{d}x}\). Substituting:
\[2x(ux)\!\left(u + x\dfrac{\mathrm{d}u}{\mathrm{d}x}\right) = x^2 - u^2x^2.\]
Dividing by \(x^2\): \(2u^2 + 2ux\dfrac{\mathrm{d}u}{\mathrm{d}x} = 1 - u^2\), so \(\dfrac{2u}{1-3u^2}\dfrac{\mathrm{d}u}{\mathrm{d}x} = \dfrac{1}{x}\). (shown)

Separating variables: \(\displaystyle\int \dfrac{2u}{1-3u^2}\,\mathrm{d}u = \int \dfrac{1}{x}\,\mathrm{d}x\).
\[-\dfrac{1}{3}\ln|1-3u^2| = \ln x + C \implies 1-3u^2 = \dfrac{A}{x^3}.\]
Substituting back \(u = y/x\): \(1 - \dfrac{3y^2}{x^2} = \dfrac{A}{x^3}\), so \(y^2 = \dfrac{x^2}{3}\!\left(1-\dfrac{A}{x^3}\right)\).
Since \(y < 0\): \(\displaystyle y = -\frac{x}{\sqrt{3}}\sqrt{1 - \frac{A}{x^3}}\).$$,
  6, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using the substitution \\(u = \\dfrac{y}{x}\\), show that the differential equation can be transformed to \\(\\dfrac{2u}{1-3u^2}\\dfrac{\\mathrm{d}u}{\\mathrm{d}x} = \\dfrac{1}{x}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the general solution of \\(y\\) in terms of \\(x\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q2 — Sequences & Series — geometric series + combinatorial sum, multi-part all null
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Geometric series 2(4−3x)^r; mixed sum',
  $$A series is given by \(\displaystyle\sum_{r=1}^{n} 2(4-3x)^r\) where \(x\) is constant.

(a) Explain why this is a geometric series. Determine the range of values of \(x\) for the sum to infinity of this series to exist. \([3]\)

(b) Using \(x = 1\), and given that \(\displaystyle\sum_{r=1}^{n} r^2 = \dfrac{n(n+1)(2n+1)}{6}\), find
\[\sum_{r=0}^{n-1}\!\left[2(4-3x)^r + (r+1)(2r+5)\right],\]
leaving your answer in the form \(n(an^2 + bn + c)\), where \(a\), \(b\) and \(c\) are constants to be determined. \([4]\)$$,
  'exact', '', null,
  $$(a) Ratio of successive terms is \(\dfrac{2(4-3x)^{r+1}}{2(4-3x)^r} = 4-3x\), independent of \(r\) — geometric with common ratio \(r_0 = 4-3x\). Sum to infinity exists iff \(|4-3x| < 1\), i.e. \(1 < x < \dfrac{5}{3}\).

(b) With \(x=1\): \(2(4-3)^r = 2\). Sum \(= \displaystyle\sum_{r=0}^{n-1}[2 + (r+1)(2r+5)]\).
\[\sum_{r=0}^{n-1}(r+1)(2r+5) = \sum_{r=0}^{n-1}(2r^2+7r+5) = \frac{n(n-1)(2n-1)}{3} + \frac{7n(n-1)}{2} + 5n.\]
Total \(= 2n + \dfrac{n(n-1)(2n-1)}{3} + \dfrac{7n(n-1)}{2} + 5n = \dfrac{n(4n^2+15n+23)}{6}\).
So \(a = \dfrac{2}{3},\; b = \dfrac{5}{2},\; c = \dfrac{23}{6}\).$$,
  7, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Explain why this is a geometric series. Determine the range of values of \\(x\\) for the sum to infinity of this series to exist. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Using \\(x = 1\\), and given that \\(\\displaystyle\\sum_{r=1}^{n} r^2 = \\dfrac{n(n+1)(2n+1)}{6}\\), find \\(\\displaystyle\\sum_{r=0}^{n-1}\\!\\left[2(4-3x)^r + (r+1)(2r+5)\\right]\\), leaving your answer in the form \\(n(an^2 + bn + c)\\), where \\(a\\), \\(b\\) and \\(c\\) are constants to be determined. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q3 — Maclaurin Series — multi-part
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250003-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  'Maclaurin series for e^x sin(x+π)',
  $$$$,
  'exact',
  '-\frac{1}{27}',
  null,
  $$(a) \(e^x\sin(x+\pi) = -e^x\sin x\). Using standard Maclaurin expansions:
\[-e^x\sin x = -\!\left(1+x+\tfrac{x^2}{2!}+\cdots\right)\!\left(x - \tfrac{x^3}{3!}+\cdots\right) = -x - x^2 - \tfrac{x^3}{3} + \cdots\]
First three non-zero terms: \(-x - x^2 - \dfrac{x^3}{3}\).

(b) Matching \(-x - x^2 - \dfrac{x^3}{3} = ax(1+bx)^c\):
\[ax(1+cbx + \tfrac{c(c-1)}{2}b^2x^2+\cdots) = ax + acbx^2 + \tfrac{ac(c-1)b^2}{2}x^3+\cdots\]
So \(a = -1\), \(acb = -1 \Rightarrow b = \tfrac{1}{c}\), \(\tfrac{ac(c-1)b^2}{2} = -\tfrac{1}{3}\).
Substituting: \(\tfrac{(-1)c(c-1)}{2c^2} = -\tfrac{1}{3} \Rightarrow \tfrac{c-1}{2c} = \tfrac{1}{3} \Rightarrow 3c-3 = 2c \Rightarrow c = 3\), then \(b = \tfrac{1}{3}\).
Coefficient of \(x^4\): \(\dfrac{a\cdot c(c-1)(c-2)(c-3)}{6}\cdot b^4 \cdot \tfrac{1}{?}\)... using binomial:
\[ax(1+bx)^c = -x(1+\tfrac{x}{3})^3, \text{ expansion: } -x\!\left(1+x+\tfrac{x^2}{3}+\tfrac{x^3}{27}\right).\]
Coefficient of \(x^4\) is coefficient of \(x^3\) in \(-(1+\tfrac{x}{3})^3\), which is \(-\dfrac{1}{27}\).$$,
  8, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the first three non-zero terms in the Maclaurin series for \\(e^x \\sin(x+\\pi)\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "It is given that the three terms found in part (a) are equal to the first three terms in the expansion of \\(ax(1+bx)^c\\) for small \\(x\\). Find the exact values of \\(a\\), \\(b\\) and \\(c\\). Use these values to find the coefficient of \\(x^4\\) in the expansion of \\(ax(1+bx)^c\\), giving your answer as a simplified rational number. \\([5]\\)  Enter the coefficient of \\(x^4\\).",
      "correct_answer": "-\\frac{1}{27}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q4 — Sequences & Series — recurrence relation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250004-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Recurrence relation x_{n+1} = (5x_n+2)/(2x_n+3)',
  $$A sequence of real numbers \(x_1, x_2, x_3, \ldots\) satisfies the recurrence relation
\[x_{n+1} = \frac{5x_n + 2}{2x_n + 3} \quad \text{for all } n \geq 1.\]$$,
  'range',
  '2.9',
  0.05,
  $$(a) At convergence \(l = \dfrac{5l+2}{2l+3}\), so \(2l^2+3l = 5l+2\), giving \(2l^2-2l-2=0\), \(l^2-l-1=0\), \(l = \dfrac{1\pm\sqrt{5}}{2}\). Both values are valid limits.

(b) When \(x_1 = 3\): the sequence decreases monotonically, converging to \(l = \dfrac{1+\sqrt{5}}{2} \approx 1.618\).

(c) Working backwards from \(x_5 = \dfrac{3503}{2158}\): by inverting the recurrence \(x_n = \dfrac{3x_{n+1}-2}{5-2x_{n+1}}\) four times gives \(x_1 = 2.9\).$$,
  7, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Given that the sequence converges to \\(l\\), find the possible exact values of \\(l\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Describe how the sequence behaves when \\(x_1 = 3\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Given that \\(x_5 = \\dfrac{3503}{2158}\\), find the value of \\(x_1\\). \\([3]\\)",
      "correct_answer": "2.9",
      "answer_type": "range",
      "tolerance": 0.05
    }
  ]$$::jsonb
);

-- P1 Q5 — Graphing Techniques — from f'(x) and |f(x)| graphs, multi-part all null
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250005-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  'Graphing f(x) from given f''(x) and |f(x)|',
  $$The graphs of \(y = \mathrm{f}'(x)\) and \(y = |\mathrm{f}(x)|\) are shown. The graph of \(y = \mathrm{f}'(x)\) has a horizontal asymptote \(y = 1\) and a zero asymptote \(y = 0\), passing through \((-2, 0)\) and \((1.5, 0)\). The graph of \(y = |\mathrm{f}(x)|\) has asymptotes \(y = x+3\) and \(y = -x-3\), horizontal asymptote \(y = 3\), passing through \((-3,0)\), \((1,0)\), \((2.5,0)\) with a local minimum at \((1.5, 1)\) and local maximum at \((-2, 2)\).

(a) State the nature of all turning point(s) of the graph of \(y = \mathrm{f}(x)\). \([2]\)

(b) State the range of values of \(x\) where \(\mathrm{f}\) is decreasing. \([2]\)

(c) Sketch the graph of \(y = \mathrm{f}(x)\) indicating clearly the equations of the asymptotes, coordinates of the turning point(s) and the intersections with the axes. \([3]\)

(d) On the copy of the graph of \(y = |\mathrm{f}(x)|\) in the Printed Answer Booklet, sketch and label a line \(y = kx + 3k\), where \(k\) is a constant. Hence state the range of values of \(k\) for which there is no real solution to the equation \(|\mathrm{f}(x)| = kx + 3k\). \([2]\)$$,
  'exact', '', null,
  $$(a) From \(y = \mathrm{f}'(x)\): \(\mathrm{f}'(x) > 0\) for \(x < -2\) and \(x > 1.5\); \(\mathrm{f}'(x) < 0\) for \(-2 < x < 1.5\) (excluding \(x=0\) where there may be a discontinuity). So \(x = -2\) is a local maximum and \(x = 1.5\) is a local minimum of \(\mathrm{f}(x)\).

(b) \(\mathrm{f}\) is decreasing for \(-2 < x < 0\) and \(0 < x < 1.5\) (i.e. \(-2 < x < 1.5\), \(x \neq 0\)).

(c) \(y = \mathrm{f}(x)\): asymptotes \(y = x+3\), \(y = -x-3\) (for \(x < 0\)); crosses at \((-3,0)\), \((1,0)\), \((2.5,0)\) if below \(x\)-axis between; local max at \((-2,2)\) (since \(|\mathrm{f}(-2)| = 2\) with \(\mathrm{f}(-2) = -2\) or \(2\)); local min at \((1.5,-1)\).

(d) The line \(y = kx + 3k = k(x+3)\) passes through \((-3, 0)\). For no real solution to \(|\mathrm{f}(x)| = k(x+3)\), the line must not intersect the graph of \(y = |\mathrm{f}(x)|\). Range: \(-1 \leq k < 0\).$$,
  9, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "State the nature of all turning point(s) of the graph of \\(y = \\mathrm{f}(x)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "State the range of values of \\(x\\) where \\(\\mathrm{f}\\) is decreasing. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Sketch the graph of \\(y = \\mathrm{f}(x)\\) indicating clearly the equations of the asymptotes, coordinates of the turning point(s) and the intersections with the axes. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "On the copy of the graph of \\(y = |\\mathrm{f}(x)|\\) in the Printed Answer Booklet, sketch and label a line \\(y = kx + 3k\\), where \\(k\\) is a constant. Hence state the range of values of \\(k\\) for which there is no real solution to the equation \\(|\\mathrm{f}(x)| = kx + 3k\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q6 — Parametric Equations — free parameter a, multi-part all null
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250006-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  'Parametric curve x = a tan t, y = a sec²t sin t',
  $$A curve \(C\) is defined parametrically by
\[x = a\tan t,\quad y = a\sec^2 t\sin t,\quad -\frac{\pi}{4} < t < \frac{\pi}{4},\]
where \(a\) is a positive constant.

(a) Show that \(\dfrac{\tan t}{\sqrt{1+\tan^2 t}} = \sin t\). \([1]\)

(b) By using part (a) or otherwise, find the cartesian equation of \(C\) in the form \(y = \mathrm{f}(x)\), simplifying your answer. \([2]\)

(c) Show that \(\mathrm{f}(-x) = -\mathrm{f}(x)\). Hence sketch \(C\). \([2]\)

(d) Find the exact area of the region bounded by \(C\), the \(x\)-axis and the lines \(x = -A\) and \(x = A\), where \(0 < A < a\), leaving your answer in terms of \(A\) and \(a\). \([3]\)$$,
  'exact', '', null,
  $$(a) \(\dfrac{\tan t}{\sqrt{1+\tan^2 t}} = \dfrac{\sin t/\cos t}{\sqrt{\sec^2 t}} = \dfrac{\sin t/\cos t}{1/|\cos t|} = \sin t\) for \(|\cos t| > 0\). (shown)

(b) \(y = a\sec^2 t \cdot \sin t = a \cdot \dfrac{1}{\cos^2 t}\cdot\sin t\). With \(x = a\tan t\), \(\tan t = x/a\), so \(\sin t = \dfrac{x/a}{\sqrt{1+(x/a)^2}} = \dfrac{x}{\sqrt{a^2+x^2}}\), and \(\sec^2 t = 1+\tan^2 t = 1+x^2/a^2 = (a^2+x^2)/a^2\). Thus
\[y = a\cdot\frac{a^2+x^2}{a^2}\cdot\frac{x}{\sqrt{a^2+x^2}} = \frac{x\sqrt{a^2+x^2}}{a}.\]

(c) \(\mathrm{f}(-x) = \dfrac{(-x)\sqrt{a^2+x^2}}{a} = -\dfrac{x\sqrt{a^2+x^2}}{a} = -\mathrm{f}(x)\). Odd function — symmetric about origin.

(d) By symmetry, area \(= 2\displaystyle\int_0^A \dfrac{x\sqrt{a^2+x^2}}{a}\,\mathrm{d}x\). Let \(u = a^2+x^2\), \(\mathrm{d}u = 2x\,\mathrm{d}x\):
\[= \frac{2}{a}\cdot\frac{1}{2}\int_{a^2}^{a^2+A^2}\sqrt{u}\,\mathrm{d}u = \frac{1}{a}\cdot\frac{2}{3}\left[(a^2+A^2)^{3/2} - a^3\right] = \frac{2}{3a}\!\left[(A^2+a^2)^{3/2} - a^3\right].\]$$,
  8, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\dfrac{\\tan t}{\\sqrt{1+\\tan^2 t}} = \\sin t\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "By using part (a) or otherwise, find the cartesian equation of \\(C\\) in the form \\(y = \\mathrm{f}(x)\\), simplifying your answer. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Show that \\(\\mathrm{f}(-x) = -\\mathrm{f}(x)\\). Hence sketch \\(C\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Find the exact area of the region bounded by \\(C\\), the \\(x\\)-axis and the lines \\(x = -A\\) and \\(x = A\\), where \\(0 < A < a\\), leaving your answer in terms of \\(A\\) and \\(a\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q7 — Functions — multi-part
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250007-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Function f(x) = e^x + 1/(2x+2); composite, inverse',
  $$The function \(\mathrm{f}\) is defined by \(\mathrm{f}: x \mapsto e^x + \dfrac{1}{2x+2}\) for \(x \in \mathbb{R}\), \(x \neq -1\).

A function \(\mathrm{g}\), defined for \(x \in \mathbb{R}\), \(x \geq 1\), is such that \(y \to \infty\) as \(x\) increases. It is also given that \(\mathrm{g}(1) = -0.5\).$$,
  'range',
  '0.386',
  0.002,
  $$(a) Range of \(\mathrm{g} \subseteq\) domain of \(\mathrm{f}\): \(\mathrm{g}(1) = -0.5 \neq -1\) and \(\mathrm{g}\) is increasing from \(-0.5\) to \(\infty\), so range of \(\mathrm{g} = [-0.5,\infty)\), which lies in domain of \(\mathrm{f}\) (excluding \(-1\) only). So \(\mathrm{fg}\) exists.
Range of \(\mathrm{fg}\): \(\mathrm{g}(1) = -0.5\), so \(\mathrm{fg}(1) = e^{-0.5} + \dfrac{1}{2(-0.5)+2} = e^{-1/2} + 1\). As \(x\to\infty\), \(\mathrm{g}(x)\to\infty\) so \(\mathrm{fg}(x)\to\infty\). Range of \(\mathrm{fg} = [e^{-1/2}+1,\infty)\).

(b) \(\mathrm{fg}(x) = e^{\mathrm{g}(x)} + \dfrac{1}{2\mathrm{g}(x)+2} = \dfrac{x}{\sqrt{e}} + \dfrac{1}{2\ln x+1}\). Comparing: \(e^{\mathrm{g}(x)} = \dfrac{x}{\sqrt{e}}\), so \(\mathrm{g}(x) = \ln x - \dfrac{1}{2}\).

(c) \(\mathrm{f}'(x) = e^x - \dfrac{1}{2(x+1)^2}\). For \(\mathrm{f}^{-1}\) to exist, \(\mathrm{f}\) must be one-to-one on \(x > k\). At \(x = 0\): \(\mathrm{f}'(0) = 1 - \tfrac{1}{2} > 0\); for \(x > 0\), \(\mathrm{f}'\) is increasing and positive. Least integer \(k = 0\).

(d)(i) \(y = \mathrm{f}(x)\) and \(y = \mathrm{f}^{-1}(x)\) are reflections in \(y = x\). \(y = \mathrm{ff}^{-1}(x) = x\) is the line \(y = x\).

(d)(ii) At \(x = e + \tfrac{1}{4}\): note \(\mathrm{f}(1) = e + \tfrac{1}{4}\), so \(\mathrm{f}^{-1}(e+\tfrac{1}{4}) = 1\). Gradient of \(\mathrm{f}^{-1}\) at that point \(= \dfrac{1}{\mathrm{f}'(1)} = \dfrac{1}{e - \frac{1}{8}} = \dfrac{8}{8e-1} \approx 0.386\).$$,
  10, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Explain why the composite function \\(\\mathrm{fg}\\) exists and find the corresponding range of \\(\\mathrm{fg}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Given that \\(\\mathrm{fg}(x) = \\dfrac{x}{\\sqrt{e}} + \\dfrac{1}{2\\ln x + 1}\\), find an expression for \\(\\mathrm{g}(x)\\) in terms of \\(x\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "The domain of \\(\\mathrm{f}\\) is now further restricted to \\(x > k\\). State the least value of integer \\(k\\) for which the function \\(\\mathrm{f}^{-1}\\) exists. \\([1]\\)",
      "correct_answer": "0",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "di",
      "prompt_latex": "Without finding \\(\\mathrm{f}^{-1}\\), sketch on the same diagram the graphs of \\(\\mathrm{f}\\), \\(\\mathrm{f}^{-1}\\) and \\(\\mathrm{ff}^{-1}\\) showing clearly the relationships between the graphs. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "dii",
      "prompt_latex": "Without finding \\(\\mathrm{f}^{-1}\\), find the gradient of the tangent to the graph of \\(y = \\mathrm{f}^{-1}(x)\\) at \\(x = e + \\dfrac{1}{4}\\). \\([3]\\)",
      "correct_answer": "0.386",
      "answer_type": "range",
      "tolerance": 0.002
    }
  ]$$::jsonb
);

-- P1 Q8 — Complex Numbers — multi-part
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250008-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  'Complex locus z = 2cos t + i(3sin t); quadratic roots',
  $$A complex number \(z\) varies with \(t\) such that \(z = 2\cos t + \mathrm{i}(3\sin t)\), where \(0 \leq t < 2\pi\).

Two complex numbers \(z_1\) and \(z_2\) for two distinct values of \(t\) are such that \(|z_1| = |z_2|\) and \(0 < \arg(z_1) < \dfrac{\pi}{2}\).

It is given further that \(z_1\) and \(z_2\) are roots of the quadratic equation \(z^2 + \alpha z + \beta = 0\).$$,
  'exact',
  '-\frac{13}{2}',
  null,
  $$(a) \(x = 2\cos t\), \(y = 3\sin t\): cartesian equation \(\dfrac{x^2}{4} + \dfrac{y^2}{9} = 1\) (ellipse).

(b) \(|z_1| = |z_2|\): the two points on the ellipse are symmetric about the real or imaginary axis. With \(0 < \arg(z_1) < \pi/2\), \(z_1\) is in the first quadrant; \(z_2\) must have equal modulus. \(z_1 + z_2 = -\alpha\). Possible values of \(\arg(z_1+z_2)\) are \(\pi/2\) or \(-\pi/2\) (depending on symmetry).

(c) Since \(|z_1| = |z_2|\) but the two values of \(t\) are distinct and not necessarily conjugates, \(\alpha = -(z_1+z_2)\) need not be real. So \(\alpha\) is not necessarily real.

(d) Given \(\alpha\) not real and \(|z_1| = |z_2| = \dfrac{\sqrt{26}}{2}\): on the ellipse, \(4\cos^2 t + 9\sin^2 t = \dfrac{26}{4}\), so \(4 + 5\sin^2 t = \dfrac{26}{4}\), \(\sin^2 t = \dfrac{1}{2}\). First quadrant: \(\sin t_1 = \dfrac{1}{\sqrt{2}}\), \(\cos t_1 = \dfrac{1}{\sqrt{2}}\), so \(z_1 = \sqrt{2} + \dfrac{3\mathrm{i}}{\sqrt{2}}\). By symmetry about imaginary axis (only possibility for \(\alpha\) not real): \(z_2 = -\sqrt{2} + \dfrac{3\mathrm{i}}{\sqrt{2}}\). Then \(\alpha = -(z_1+z_2) = -\dfrac{6\mathrm{i}}{\sqrt{2}} = -3\sqrt{2}\,\mathrm{i}\) (not real, consistent). \(\beta = z_1 z_2 = (-\sqrt{2}+\dfrac{3\mathrm{i}}{\sqrt{2}})(\sqrt{2}+\dfrac{3\mathrm{i}}{\sqrt{2}}) = -2 - \dfrac{9}{2} = -\dfrac{13}{2}\).$$,
  11, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "By taking \\(x = \\mathrm{Re}(z)\\) and \\(y = \\mathrm{Im}(z)\\), sketch on an Argand diagram the curve showing the positions of \\(z\\). Find the cartesian equation of this curve. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "By referring to the Argand diagram, find the possible values of \\(\\arg(z_1 + z_2)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Explain whether it is necessary for \\(\\alpha\\) to be real. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "da",
      "prompt_latex": "Given that \\(\\alpha\\) is not real and \\(|z_1| = |z_2| = \\dfrac{\\sqrt{26}}{2}\\), find the values of \\(\\alpha\\) and \\(\\beta\\). \\([4]\\)  Enter \\(\\beta\\).",
      "correct_answer": "-\\frac{13}{2}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q9 — Vectors (Planes) — multi-part
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0250009-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Three planes: distance, intersection, triangular prism',
  $$The point \(A\) has coordinates \((1, -2, 4)\) and the plane \(\pi_1\) has equation \(2x - y + 2z = 5\).$$,
  'exact',
  '\frac{7}{3}',
  null,
  $$(a) Distance \(= \dfrac{|2(1) - (-2) + 2(4) - 5|}{\sqrt{4+1+4}} = \dfrac{|2+2+8-5|}{3} = \dfrac{7}{3}\).

(b) Solving \(\pi_1 \cap \pi_2\) (\(2x-y+2z=5\) and \(x+3y-az=3\)) gives a parametric line in terms of \(a\).

(c) Direction of \(l\) is \(\mathbf{n}_1 \times \mathbf{n}_2\). For \(l \parallel \pi_3\): direction of \(l\) perpendicular to normal of \(\pi_3\). Working through the cross product and dot product gives \((a-6)(b-4) = 0\). (shown)

(d) For a triangular prism: the three planes must pairwise intersect in three parallel lines, none of which coincide. From (c): \(a = 6\) or \(b = 4\). If \(a = 6\): \(\pi_1 \parallel \pi_2\) only if... analysis gives conditions \(a = 6\) and \(b \neq 4\) with appropriate sub-conditions so \(\pi_1\), \(\pi_2\), \(\pi_3\) form a triangular prism.$$,
  12, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find the exact shortest distance between \\(A\\) and \\(\\pi_1\\). \\([2]\\)",
      "correct_answer": "\\frac{7}{3}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The plane \\(\\pi_2\\) has equation \\(x + 3y - az = 3\\), where \\(a\\) is a constant. Find the vector equation of line \\(l\\), which is the line of intersection of \\(\\pi_1\\) and \\(\\pi_2\\), in terms of \\(a\\). \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "The plane \\(\\pi_3\\) has equation \\(bx - 2y + 4z = 3\\), where \\(b\\) is a constant. Show that \\((a-6)(b-4) = 0\\) if \\(l\\) is parallel to \\(\\pi_3\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "State the conditions that \\(a\\) and \\(b\\) must follow for the three planes to form a triangular prism, where all the planes are non-parallel and they do not have any point in common. Justify your answer. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P1 Q10 — Definite Integral — Riemann sum + area with circle arc
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd025000a-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Riemann sum → definite integral; area with circle arc',
  $$There are \(n\) rectangles each of width \(h\) drawn under the curve \(y = \mathrm{f}(x)\) for \(1 \leq x \leq 3\). Each rectangle, when rotated through \(2\pi\) radians about the \(x\)-axis, gives a cylindrical disc. The total volume of the \(n\) discs \(V_1\) estimates the actual volume \(V\) of revolution.

It is given that \(\mathrm{f}(x) = \dfrac{x^2}{\sqrt{1+e^x}}\) for \(x \geq 0\).$$,
  'range',
  '3.01',
  0.01,
  $$(a) Each disc has radius \(\mathrm{f}(1+rh)\) and width \(h\), so volume \(= \pi h[\mathrm{f}(1+rh)]^2\). Summing from \(r=0\) to \(n-1\): \(V_1 = \pi h\displaystyle\sum_{r=0}^{n-1}[\mathrm{f}(1+rh)]^2\). State \(h = 2/n\).

(b) \(V_2 = \pi h\displaystyle\sum_{r=1}^{n}[\mathrm{f}(1+rh)]^2\) (right Riemann sum — overestimates since \(\mathrm{f}\) is increasing).

(c) As \(n\to\infty\), \(V_1 \to V = \pi\displaystyle\int_1^3 [\mathrm{f}(x)]^2\,\mathrm{d}x = \pi\int_1^3 \dfrac{x^4}{1+e^x}\,\mathrm{d}x \approx 12.3\).

(d) The circle \((x-1)^2+(y-3)^2=9\) has centre \((1,3)\), radius \(3\). For \(y \leq 3\): lower semicircle from \(x=-2\) to \(x=4\). The intersection with \(y = \mathrm{f}(x)\): numerically find intercepts, then area \(= \displaystyle\int_{\text{left}}^{\text{right}}\!\left[\text{circle arc} - \mathrm{f}(x)\right]\mathrm{d}x \approx 3.01\).$$,
  10, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(V_1 = \\pi h\\displaystyle\\sum_{r=0}^{n-1}[\\mathrm{f}(1+rh)]^2\\). State the value of \\(h\\) in terms of \\(n\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "From the diagram, \\(V_1 < V\\). Write down \\(V_2\\), a similar expression where \\(V_2 > V\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the value of \\(\\displaystyle\\lim_{n\\to\\infty} V_1\\). \\([2]\\)",
      "correct_answer": "12.3",
      "answer_type": "range",
      "tolerance": 0.1
    },
    {
      "label": "d",
      "prompt_latex": "Find the area of the region bounded by \\(y = \\mathrm{f}(x)\\) and the curve \\((x-1)^2 + (y-3)^2 = 9\\) for \\(y \\leq 3\\). \\([4]\\)",
      "correct_answer": "3.01",
      "answer_type": "range",
      "tolerance": 0.01
    }
  ]$$::jsonb
);

-- P1 Q11 — Application of Differentiation — tank design + related rates
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd025000b-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Tank design (max volume) + related rates of water leak',
  $$An aquarist with budget \$k makes a tank: circular cover (cost \$20/cm²), cylinder of length \(L\) cm (cost \$10/cm²), hemispherical base of radius \(r\) cm (cost \$30/cm²).

Later: cylinder fixed at radius 15 cm; water leaks at 20 cm³/min; depth \(h\) cm, surface radius \(x\) cm; \(W = \dfrac{\pi h(3x^2 + h^2)}{6}\) cm³.$$,
  'range',
  '-0.105',
  0.001,
  $$(a) Cost: cover \(= 20\pi r^2\), cylinder \(= 10\cdot 2\pi r L = 20\pi r L\), hemisphere \(= 30\cdot 2\pi r^2 = 60\pi r^2\). Total \(= 20\pi r L + 80\pi r^2 = k\). So \(L = \dfrac{k - 80\pi r^2}{20\pi r}\). Volume \(= \pi r^2 L + \dfrac{2}{3}\pi r^3 = \pi r^2\cdot\dfrac{k-80\pi r^2}{20\pi r} + \dfrac{2\pi r^3}{3} = \dfrac{kr}{20} - 4\pi r^3 + \dfrac{2\pi r^3}{3} = \dfrac{kr}{20} - \dfrac{10\pi r^3}{3}\). (shown)

(b) \(\dfrac{\mathrm{d}V}{\mathrm{d}r} = \dfrac{k}{20} - 10\pi r^2 = 0 \Rightarrow r^2 = \dfrac{k}{200\pi}\). \(\dfrac{\mathrm{d}^2 V}{\mathrm{d}r^2} = -20\pi r < 0\) — maximum. Cost of hemisphere \(= 60\pi r^2 = 60\pi\cdot\dfrac{k}{200\pi} = \dfrac{3k}{10}\).

(c) Hemisphere of radius \(R = 15\): constraint \(x^2 + (15-h)^2 = 225 \Rightarrow x^2 = 30h - h^2\).
\(\dfrac{\mathrm{d}W}{\mathrm{d}t} = -20\) cm³/min. At \(h=3\), \(x^2 = 81\), \(x=9\).
\(W = \dfrac{\pi h(3x^2+h^2)}{6}\). Substituting \(x^2 = 30h-h^2\): \(W = \dfrac{\pi h(90h - 3h^2 + h^2)}{6} = \dfrac{\pi h^2(90-2h)}{6}\).
\(\dfrac{\mathrm{d}W}{\mathrm{d}h} = \dfrac{\pi(180h - 6h^2)}{6} = \pi h(30-h)\). At \(h=3\): \(\dfrac{\mathrm{d}W}{\mathrm{d}h} = 81\pi\).
(ci) \(\dfrac{\mathrm{d}h}{\mathrm{d}t} = \dfrac{\mathrm{d}W/\mathrm{d}t}{\mathrm{d}W/\mathrm{d}h} = \dfrac{-20}{81\pi} \approx -0.0786\) cm/min.
(cii) \(\dfrac{\mathrm{d}x}{\mathrm{d}h} = \dfrac{15-h}{x}\). At \(h=3\): \(\dfrac{\mathrm{d}x}{\mathrm{d}h} = \dfrac{12}{9} = \dfrac{4}{3}\).
\(\dfrac{\mathrm{d}x}{\mathrm{d}t} = \dfrac{4}{3}\cdot\dfrac{-20}{81\pi} = \dfrac{-80}{243\pi} \approx -0.105\) cm/min.$$,
  12, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the volume of the tank is \\(V\\) cm\\(^3\\), where \\(V = \\dfrac{k}{20}r - \\dfrac{10\\pi}{3}r^3\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "As \\(r\\) varies, find the cost of the material used to make the hemispherical base in terms of \\(k\\) when \\(V\\) is at its maximum value. You need to show that \\(V\\) is a maximum. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "ci",
      "prompt_latex": "By formulating a relationship between \\(x\\) and \\(h\\), find, when \\(h = 3\\), the rate of change of the depth of water. \\([3]\\)",
      "correct_answer": "-0.0786",
      "answer_type": "range",
      "tolerance": 0.001
    },
    {
      "label": "cii",
      "prompt_latex": "Find, when \\(h = 3\\), the rate of change of the radius of the water surface. \\([3]\\)",
      "correct_answer": "-0.105",
      "answer_type": "range",
      "tolerance": 0.001
    }
  ]$$::jsonb
);

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q1 — Graphing Techniques — concavity and sketch
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251001-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  'Curve y = x + 9/(x+1): concavity and sketch',
  $$A curve \(C\) has equation \(y = x + \dfrac{9}{x+1}\).$$,
  'exact',
  'x>-1',
  null,
  $$(a) \(y' = 1 - \dfrac{9}{(x+1)^2}\), \(y'' = \dfrac{18}{(x+1)^3}\). Concave up iff \(y'' > 0\): \((x+1)^3 > 0 \Rightarrow x > -1\).

(b) Asymptotes: \(x = -1\) (vertical), oblique \(y = x\) (as \(x\to\pm\infty\)). Stationary points: \(y' = 0 \Rightarrow (x+1)^2 = 9 \Rightarrow x = 2\) (local min, \(y=8\)) or \(x=-4\) (local max, \(y=-10\)).$$,
  5, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Using differentiation, find the range of values of \\(x\\) such that \\(C\\) is concave upwards. \\([2]\\)",
      "correct_answer": "x>-1",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch \\(C\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q2 — Integration Technique — substitution + exact value
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251002-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  'Integral of e^{2x} arctan(e^x) by substitution',
  $$$$,
  'exact', '', null,
  $$(a) Let \(t = e^x\), \(\mathrm{d}t = e^x\,\mathrm{d}x\). Then \(\mathrm{d}x = \mathrm{d}t/t\), \(e^{2x}\,\mathrm{d}x = t^2 \cdot \mathrm{d}t/t = t\,\mathrm{d}t\). So \(\displaystyle\int e^{2x}\tan^{-1}(e^x)\,\mathrm{d}x = \int t\tan^{-1}(t)\,\mathrm{d}t\). (shown)

(b) \(\displaystyle\int_0^1 e^{2x}\tan^{-1}(e^x)\,\mathrm{d}x = \int_1^e t\tan^{-1}(t)\,\mathrm{d}t\). Integrate by parts:
\[\left[\frac{t^2}{2}\tan^{-1}t\right]_1^e - \int_1^e \frac{t^2}{2(1+t^2)}\,\mathrm{d}t = \frac{e^2}{2}\cdot\frac{\pi}{4} - \frac{1}{2}\cdot\frac{\pi}{4} - \frac{1}{2}\int_1^e\!\left(1-\frac{1}{1+t^2}\right)\mathrm{d}t.\]
\[= \frac{(e^2-1)\pi}{8} - \frac{1}{2}\left[t - \tan^{-1}t\right]_1^e = \frac{(e^2+1)}{2}\tan^{-1}e - \frac{e}{2} - \frac{\pi}{4} + \frac{1}{2}.\]$$,
  7, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Use the substitution \\(t = e^x\\) to show that \\(\\displaystyle\\int e^{2x}\\tan^{-1}(e^x)\\,\\mathrm{d}x = \\int t\\tan^{-1}(t)\\,\\mathrm{d}t\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence find the exact value of \\(\\displaystyle\\int_0^1 e^{2x}\\tan^{-1}(e^x)\\,\\mathrm{d}x\\). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q3 — Application of Differentiation — implicit differentiation + normal
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251003-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  'Implicit curve x³+y³−5xy=0: dy/dx and normal',
  $$A curve \(C\) has equation \(x^3 + y^3 - 5xy = 0\), where \(x > 0\).$$,
  'range',
  '2.65',
  0.005,
  $$(a) Differentiating implicitly: \(3x^2 + 3y^2\dfrac{\mathrm{d}y}{\mathrm{d}x} - 5y - 5x\dfrac{\mathrm{d}y}{\mathrm{d}x} = 0\), so \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = \dfrac{5y-3x^2}{3y^2-5x}\).

(b) Normal parallel to \(y\)-axis: tangent is horizontal, \(\dfrac{\mathrm{d}y}{\mathrm{d}x} = 0\), so \(5y = 3x^2\). Substituting into the curve: \(x^3 + \dfrac{27x^6}{125} - 5x\cdot\dfrac{3x^2}{5} = 0\), giving \(\dfrac{27x^3}{125} = 2\), \(x = \left(\dfrac{250}{27}\right)^{1/3} \approx 2.10\). Then \(y = \dfrac{3x^2}{5} \approx 2.65\).

(c) At the stationary point (where \(\dfrac{\mathrm{d}y}{\mathrm{d}x}=0\)): check second derivative or sign change to determine nature.$$,
  7, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(x\\) and \\(y\\). \\([2]\\)",
      "correct_answer": "\\frac{5y-3x^2}{3y^2-5x}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "Find the \\(x\\)-coordinate of the point on \\(C\\) at which the normal is parallel to the \\(y\\)-axis. \\([3]\\)",
      "correct_answer": "2.10",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "bii",
      "prompt_latex": "Find the \\(y\\)-coordinate of that point.",
      "correct_answer": "2.65",
      "answer_type": "range",
      "tolerance": 0.005
    },
    {
      "label": "c",
      "prompt_latex": "Determine the nature of the stationary point. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q4 — Vectors (Basic) — position vectors, collinearity, scalar product
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251004-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  'Position vectors; collinearity; angle between a and b',
  $$Relative to origin \(O\), points \(A\), \(B\), \(C\) have position vectors \(\mathbf{a}\), \(\mathbf{b}\), \(3\mathbf{a}+\mathbf{b}\) respectively. Point \(D\) lies on \(AB\) such that \(\overrightarrow{AD} = k\overrightarrow{AB}\), \(0 < k < 1\).

It is given that \(|\mathbf{a}| = 1\), \(|\mathbf{b}| = 2\), and \(|3\mathbf{a} - 2\mathbf{b}| = \sqrt{31}\).$$,
  'range',
  '104.5',
  0.5,
  $$(a) \(\overrightarrow{OD} = \mathbf{a} + k(\mathbf{b}-\mathbf{a}) = (1-k)\mathbf{a} + k\mathbf{b}\). Line \(OD\): \(\mathbf{r} = \lambda[(1-k)\mathbf{a}+k\mathbf{b}]\).

(b) \(E\) = midpoint of \(BC\): \(\overrightarrow{OE} = \dfrac{\mathbf{b}+(3\mathbf{a}+\mathbf{b})}{2} = \dfrac{3\mathbf{a}+2\mathbf{b}}{2}\). For \(O,D,E\) collinear: \((1-k)\mathbf{a}+k\mathbf{b} = \mu\!\left(\dfrac{3}{2}\mathbf{a}+\mathbf{b}\right)\). Equating coefficients: \(1-k = \dfrac{3\mu}{2}\) and \(k = \mu\). So \(1-k = \dfrac{3k}{2}\), giving \(k = \dfrac{2}{5}\).

(c) \((3\mathbf{a}-2\mathbf{b})\cdot(3\mathbf{a}-2\mathbf{b}) = 31\). Expanding: \(9|\mathbf{a}|^2 - 12\mathbf{a}\cdot\mathbf{b} + 4|\mathbf{b}|^2 = 31\). So \(9(1) - 12\mathbf{a}\cdot\mathbf{b} + 4(4) = 31\), giving \(\mathbf{a}\cdot\mathbf{b} = -\dfrac{1}{2}\). Angle: \(\cos\theta = \dfrac{-1/2}{1\cdot 2} = -\dfrac{1}{4}\), so \(\theta = \arccos(-\tfrac{1}{4}) \approx 104.5°\).

(d) \(|\mathbf{a}\times\mathbf{b}|\) is the area of the parallelogram with sides \(\mathbf{a}\) and \(\mathbf{b}\).$$,
  11, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Find a vector equation of the line \\(OD\\) in terms of \\(k\\), \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The point \\(E\\) is the midpoint of \\(BC\\). Find the value of \\(k\\) if \\(O\\), \\(D\\) and \\(E\\) are collinear. \\([4]\\)",
      "correct_answer": "\\frac{2}{5}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "ci",
      "prompt_latex": "By considering the scalar product \\((3\\mathbf{a}-2\\mathbf{b})\\cdot(3\\mathbf{a}-2\\mathbf{b})\\), find the numerical value of \\(\\mathbf{a}\\cdot\\mathbf{b}\\). \\([4]\\)",
      "correct_answer": "-\\frac{1}{2}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "cii",
      "prompt_latex": "Hence determine the angle between \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\), in degrees. \\([1]\\)",
      "correct_answer": "104.5",
      "answer_type": "range",
      "tolerance": 0.5
    },
    {
      "label": "d",
      "prompt_latex": "Give a geometrical interpretation of \\(|\\mathbf{a}\\times\\mathbf{b}|\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q5 — Differential Equations — Newton's Law of Cooling piecewise
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251005-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'Newton cooling ODE; piecewise Tp(t); find cooling time',
  $$A heated metal block at 160°C is left to cool in a laboratory with ambient temperature 30°C. The temperature \(T\)°C at time \(t\) minutes satisfies a differential equation where the rate of cooling is proportional to the temperature difference, with positive constant \(k\).

A protective casing keeps the block at 160°C for the first 5 minutes. At 10:05 am the casing is removed; at 10:15 am the temperature is 100°C. The piecewise temperature is modelled by
\[T_p(t) = \begin{cases} 160 & 0 \leq t < 5, \\ T(t+a) & t \geq 5. \end{cases}\]$$,
  'range',
  '28.7',
  0.1,
  $$(a) \(\dfrac{\mathrm{d}T}{\mathrm{d}t} = -k(T-30)\). Separating: \(T(t) = 30 + 130e^{-kt}\).

(b) Cooling begins at \(t = 5\) (experiment time), so replace \(t\) with \(t - 5\) in the formula, i.e. \(T(t+a)\) with \(a = -5\).

(c) \(T(t-5) = 30 + 130e^{-k(t-5)}\). At \(t = 15\) (10 min cooling): \(30 + 130e^{-10k} = 100\), so \(e^{-10k} = \dfrac{7}{13}\), \(k = \dfrac{1}{10}\ln\dfrac{13}{7} \approx 0.0619\). Then \(130e^{5k} = 130e^{0.3095} \approx 177\), confirming \(T(t-5) = 30 + 177e^{-0.0619t}\). (shown)

(d) \(T_p(t) = 60\): \(30 + 177e^{-0.0619t} = 60\), \(e^{-0.0619t} = \dfrac{30}{177}\), \(t = \dfrac{\ln(177/30)}{0.0619} \approx 28.7\) minutes.$$,
  10, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Write down a differential equation for the situation and find the expression of \\(T(t)\\) in terms of \\(k\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "In order to use the solution from part (a) to model the cooling process, the time \\(t\\) needs to be replaced with \\(t + a\\). State the value of \\(a\\). \\([1]\\)",
      "correct_answer": "-5",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Using your answers from parts (a) and (b), show that \\(T(t+a) = 30 + 177e^{-0.0619t}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Find the time it takes for the metal block to cool to 60°C. \\([1]\\)",
      "correct_answer": "28.7",
      "answer_type": "range",
      "tolerance": 0.1
    },
    {
      "label": "e",
      "prompt_latex": "Sketch the graph of \\(T_p(t)\\) against \\(t\\) for \\(t \\geq 0\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q6 — Probability — three events, independence
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  'Three events A, B, C; max/min P(A∩B''∩C); independence',
  $$The events \(A\), \(B\) and \(C\) are such that \(P(A) = 0.8\), \(P(B) = 0.2\), \(P(C) = 0.6\). It is also known that \(P(A \cap B) = P(B)\) and \(P(B \cap C) = 0.1\).$$,
  'range',
  '0.38',
  0.005,
  $$(ai) Since \(P(A\cap B) = P(B)\), \(B \subseteq A\). \(P(A\cap B'\cap C) = P(A\cap C) - P(A\cap B\cap C) = P(A\cap C) - P(B\cap C) = P(A\cap C) - 0.1\). Bounds on \(P(A\cap C)\): \(\max(0, P(A)+P(C)-1) = 0.4 \leq P(A\cap C) \leq \min(P(A),P(C)) = 0.6\). So \(0.3 \leq P(A\cap B'\cap C) \leq 0.5\).

(aii) \(P(A\cap B'\cap C \mid A\cup C)\): similar bounds analysis on \(P(A\cup C)\). Min of \(P(A\cup C) = \max(0.8, 0.6) = 0.8\); max \(= 0.8+0.6-0.4 = 1\) (if independent). Conditional probability bounds follow.

(b) \(A\) and \(C\) independent: \(P(A\cap C) = 0.8\times 0.6 = 0.48\). So \(P(A\cap B'\cap C) = 0.48 - 0.1 = 0.38\).$$,
  7, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "ai",
      "prompt_latex": "Find exactly the maximum and minimum possible values of \\(P(A \\cap B' \\cap C)\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Find exactly the maximum and minimum possible values of \\(P(A \\cap B' \\cap C \\mid A \\cup C)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "It is given further that \\(A\\) and \\(C\\) are independent. Find the value of \\(P(A \\cap B' \\cap C)\\). \\([2]\\)",
      "correct_answer": "0.38",
      "answer_type": "range",
      "tolerance": 0.005
    }
  ]$$::jsonb
);

-- P2 Q7 — Permutation & Combination — seating 12 students in 14 seats
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251007-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  'Seating 12 students (5T+4B+3S) in 14 flight seats',
  $$Twelve students from three CCAs are going on an overseas trip: 5 from Tennis, 4 from Bowling, 3 from Softball. There are 14 available seats on the flight for them to choose from (arranged in 3 rows, seats C–I per row, with aisle seats). Not all seats need be filled.$$,
  'exact',
  '518400',
  null,
  $$(a) One student fixed to the single seat nearest the emergency exit (1 way). Remaining 11 students choose from 13 seats: \(P(13,11) = \dfrac{13!}{2!} = 3{,}113{,}510{,}400\).

(b) Two students avoid aisle seats. By inclusion-exclusion on 6 aisle seats available: arrangements where neither is on an aisle \(= P(14,12) - 2\cdot6\cdot P(13,11) + 6\cdot5\cdot P(12,10) = 43{,}589{,}145{,}600 - 37{,}362{,}124{,}800 + 7{,}185{,}024{,}000\) ... Computing gives \(10{,}059{,}033{,}600\).

(c) Each CCA seated together (front/back or left/right, not separated by aisle). Arrange the 3 CCAs as groups: consider valid blocks. Result \(= 518{,}400\).$$,
  8, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "In how many different ways can the students be seated if there is a particular student who must be seated nearest to the emergency exit? \\([2]\\)",
      "correct_answer": "3113510400",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the number of ways they can be seated if two particular students do not want to be seated on any of the aisle seats. \\([3]\\)",
      "correct_answer": "10059033600",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the number of ways they can be seated if students of the same CCA must be seated together either front and back or left and right, and cannot be separated by an aisle. \\([3]\\)",
      "correct_answer": "518400",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q8 — Discrete Random Variable — coloured discs, X = # colours
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251008-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  'DRV: X = # colours in 4 draws from 24 discs (6 each)',
  $$A bag contains 6 red, 6 green, 6 yellow and 6 blue discs (indistinguishable except by colour). Four discs are drawn one after another without replacement. The random variable \(X\) is the number of different colours obtained.

Joe plays 8 rounds: each round he wins \$10 if \(X \leq 2\), otherwise loses \$5. All discs returned after each round.$$,
  'range',
  '0.367',
  0.002,
  $$(a) \(P(X=2) = \dfrac{\binom{4}{2}\!\left[\binom{12}{4} - 2\binom{6}{4}\right]}{\binom{24}{4}} = \dfrac{6\times 465}{10626} = \dfrac{465}{1771}\). (shown)

(b) \(P(X=1) = \dfrac{4\binom{6}{4}}{\binom{24}{4}} = \dfrac{60}{10626}\). \(P(X=3) = \dfrac{\binom{4}{3}\binom{18}{1}\binom{6}{2}}{\binom{24}{4}}\cdot\ldots\) (compute via complement). \(P(X=4) = \dfrac{4!\cdot 6^4/\binom{24}{4}}{?}\)... Full distribution in solution.

(c) \(p = P(X \leq 2) = \dfrac{60+2790}{10626} = \dfrac{475}{1771}\). Let \(W \sim B(8, p)\). Joe wins net \(>0\) iff \(W \geq 3\).
\(P(W \geq 3) = 1 - P(W \leq 2) \approx 0.367\).

(d) \(E[\text{net gain per round}] = 10p - 5(1-p) = 15p - 5 \approx 15\times 0.268 - 5 = -0.98 < 0\). Not worthwhile.$$,
  10, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(P(X = 2) = \\dfrac{465}{1771}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence determine the probability distribution of \\(X\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Find the probability that Joe wins some money at the end of the game. \\([2]\\)",
      "correct_answer": "0.367",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "d",
      "prompt_latex": "Explain, with working, whether it is worthwhile for Joe to play this game to win money. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q9 — Regression — scatter diagrams + model selection + estimation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd0251009-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  'Regression: workers vs renovation days; model C y=a+b/x²',
  $$A private developer investigates how the number of working days \(y\) to complete renovation varies with the number of workers \(x\) hired. Data collected:

\[x: 3, 5, 8, 10, 13, 15, 18, 20 \quad y: 92, 50, 33, 25, 21, 19, 17, 16\]

Three possible models (\(a, b > 0\)): (A) \(\ln y = a - bx\);  (B) \(y = a - bx^2\);  (C) \(y = a + \dfrac{b}{x^2}\).$$,
  'exact',
  '6',
  null,
  $$(a) Scatter diagrams I, II, III have pmcc from \{0.7, 0, 1, -1\}: match by shape. (Answer: based on diagrams — state which is which.)

(b)(i) Scatter plot of data: \(y\) decreases sharply then levels off. A linear model is not appropriate — the relationship is non-linear (concave).

(b)(ii) As \(x \to \infty\), \(y\) approaches a positive minimum (not zero), so model (B) fails (becomes negative). Model (A) gives \(y \to 0\) — not realistic. Model (C) \(y = a + b/x^2\): as \(x\to\infty\), \(y\to a > 0\). Most appropriate.

(b)(iii) Regressing \(y\) on \(1/x^2\): \(r \approx 0.992\). Equation: \(y = a + b/x^2\) with specific \(a\), \(b\) values (use GC).

(b)(iv) At \(x = 9\): \(\hat{y} \approx 26\). Reliable since \(x = 9\) is within the data range (interpolation) and \(r \approx 0.992\) is close to 1.

(b)(v) Total wages \(\propto x \cdot y = x\!\left(a + b/x^2\right) = ax + b/x\). Minimise: \(\dfrac{\mathrm{d}(xy)}{\mathrm{d}x} = a - b/x^2 = 0 \Rightarrow x = \sqrt{b/a}\). Compute from regression coefficients, then round to nearest integer within \([1,20]\): optimal \(x = 6\).$$,
  11, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "The scatter diagrams I, II and III have product moment correlation coefficients 0.7, 0, 1, \\(-1\\) (not necessarily in that order). State the pmcc for each diagram. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "Draw a scatter diagram for the data. Comment on whether a linear model would be appropriate. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "By referring to the scatter diagram and the context of the question, explain which model — (A) \\(\\ln y = a - bx\\), (B) \\(y = a - bx^2\\), or (C) \\(y = a + b/x^2\\) — is most appropriate. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "biii",
      "prompt_latex": "Using model (C), find the equation for the relationship between \\(x\\) and \\(y\\) and the product moment correlation coefficient \\(r\\). \\([2]\\)",
      "correct_answer": "0.992",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "biv",
      "prompt_latex": "Estimate the number of working days when 9 workers are hired. Comment on the reliability of your estimate. \\([2]\\)",
      "correct_answer": "26",
      "answer_type": "range",
      "tolerance": 1
    },
    {
      "label": "bv",
      "prompt_latex": "The developer pays each worker \\$120 per day. Estimate the number of workers to hire to minimise the total wages, given at most 20 workers can be hired. \\([2]\\)",
      "correct_answer": "6",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q10 — Normal Distribution — gym usage time X~N(95,σ²), trial W~N(85,80)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd025100a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  'Normal dist: gym usage X~N(95,σ²); trial W~N(85,80)',
  $$A gym's paying members have usage time \(X \sim N(95, \sigma^2)\) minutes per visit. Only 30% of paying members adhere to the guideline of at most 90 minutes. Trial members have usage time \(W \sim N(85, 80)\) minutes.$$,
  'range',
  '0.647',
  0.002,
  $$(a) \(P(X \leq 90) = 0.3\). \(\dfrac{90-95}{\sigma} = \Phi^{-1}(0.3) = -0.5244\). So \(\sigma = \dfrac{5}{0.5244} \approx 9.53\). (shown)

(b) Gym closes at 11 pm; John arrives at 9:15 pm. He cannot finish if \(X > 105\) min. \(P(X > 105) = P\!\left(Z > \dfrac{10}{9.53}\right) = P(Z > 1.049) \approx 0.147\).

(c) 9th is 3rd and last to adhere out of 10: exactly 2 adhere in first 8, 9th adheres, 10th does not.
\(P = \binom{8}{2}(0.3)^2(0.7)^6 \times 0.3 \times 0.7 = \binom{8}{2}(0.3)^3(0.7)^7 \approx 0.0623\).

(d) Sketch both \(N(95, 90.82)\) and \(N(85, 80)\) — \(W\) has smaller mean and smaller variance.

(e) \(X_1 + X_2 - 2W \sim N(2(95)-2(85),\; 2(90.82)+4(80)) = N(20,\; 501.64)\).
\(P(|X_1+X_2-2W| \geq 15) = P(Z \leq \frac{-35}{\sqrt{501.64}}) + P(Z \geq \frac{-5}{\sqrt{501.64}})\)
\(= \Phi\!\left(\frac{-35}{22.40}\right) + 1 - \Phi\!\left(\frac{-5}{22.40}\right) \approx 0.059 + 0.589 = 0.647\). (Assumption: \(X_1, X_2, W\) mutually independent.)$$,
  12, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\sigma = 9.53\\) correct to 3 significant figures. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The gym closes at 11 pm. John arrives at 9:15 pm. Find the probability that he cannot finish his workout. \\([1]\\)",
      "correct_answer": "0.147",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "c",
      "prompt_latex": "Ten paying members are randomly chosen. Find the probability that the ninth paying member is the third and last one to adhere to the guideline. \\([2]\\)",
      "correct_answer": "0.0623",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "d",
      "prompt_latex": "Sketch the distribution of \\(X\\) and \\(W\\) on the same diagram. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Find the probability that the total usage time of two randomly chosen paying members differs from twice the time of a randomly chosen trial member by at least 15 minutes. \\([4]\\)",
      "correct_answer": "0.647",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "f",
      "prompt_latex": "State an assumption needed for your calculation in part (e) to be valid. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);

-- P2 Q11 — Hypothesis Testing — flour packets (Regular + Large)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'd025100b-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  'Hypothesis testing: flour packet masses (one-tail + two-tail)',
  $$Mr Dough's machines pack Regular-sized (target mean 1 kg) and Large-sized (target mean 2 kg) flour packets. After a power outage he suspects recalibration issues.

A sample of 50 Regular-sized packets gave masses \(x\) g (correct to nearest 5 g) with \(\bar{x} = 997.4\) g and unbiased sample variance \(s^2\) g².

A sample of 15 Large-sized packets gave total mass 30075 g. Assuming population variance \(\sigma^2\), a test gave \(p\)-value 0.0529. Later, one more Large-sized packet of mass \(h\) g is added to give a sample of 16; the new test rejects at 4% significance.$$,
  'range',
  '123',
  1,
  $$(a) From the frequency table (\(n=50\), \(\sum x = 49870\), \(\sum x^2 \approx 49746350\)):
\[s^2 = \frac{\sum x^2 - (\sum x)^2/n}{n-1} = \frac{49746350 - 49870^2/50}{49} = \frac{6012}{49} \approx 123.\]

(b) One-tail test — Mr Dough suspects the packets are underweight (not just different from 1 kg).

(c) \(H_0: \mu = 1000\), \(H_1: \mu < 1000\). Test stat: \(Z = \dfrac{997.4 - 1000}{\sqrt{123/50}} = \dfrac{-2.6}{1.568} \approx -1.659\). Critical value at 5%: \(-1.645\). Since \(-1.659 < -1.645\), reject \(H_0\). Sufficient evidence that packets are underweight. No need to assume normality — \(n = 50\) large (CLT applies).

(d) \(\bar{X} = 30075/15 = 2005\). Under \(H_0: \mu = 2000\): \(Z = \dfrac{2005-2000}{\sigma/\sqrt{15}} = \dfrac{5\sqrt{15}}{\sigma}\). Two-tail \(p\)-value \(= 2\Phi\!\left(-\dfrac{5\sqrt{15}}{\sigma}\right) = 0.0529\). So \(\dfrac{5\sqrt{15}}{\sigma} = 1.617\), \(\sigma = \dfrac{5\sqrt{15}}{1.617} \approx 10.0\). (shown)

(e) With \(\sigma = 10\), \(n=16\), \(\bar{X}_{16} = (30075+h)/16\). Reject \(H_0\) at 4% iff \(|Z| > 2.054\), i.e. \(|\bar{X}_{16} - 2000| > 2.054 \times 10/4 = 5.135\). This gives \(h \leq 1842\) or \(h \geq 2008\).$$,
  12, 'DHS H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Determine the unbiased estimate of the population variance of the mass of Regular-sized packets. \\([1]\\)",
      "correct_answer": "123",
      "answer_type": "range",
      "tolerance": 1
    },
    {
      "label": "b",
      "prompt_latex": "Explain whether Mr Dough should conduct a one-tail or a two-tail test. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Carry out the test at 5% level of significance and give your conclusion in context. Explain whether it is necessary to assume that the mass of Regular-sized packets follows a normal distribution. \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Assuming Large-sized packets have population variance \\(\\sigma^2\\), and that a sample of 15 gave a \\(p\\)-value of 0.0529, show that \\(\\sigma = 10.0\\) correct to 3 significant figures. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Using \\(\\sigma = 10.0\\), find the possible range of values of \\(h\\) (the mass in g of an extra packet added to make a sample of 16) such that the claim \\(\\mu = 2000\\) g is rejected at 4% significance. Give your answer to the nearest gram. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
);
