-- Migration 021: Enable typed submissions for mis-flagged "show that" parts + multi-value answer boxes
--
-- Many parts were authored with answer_type: null (rendering "Show that — no submission
-- required") even though they ask the student to find/state/determine/evaluate/solve a value.
-- This migration re-classifies those parts: it sets answer_type + correct_answer (derived from
-- each question's worked solution_latex) so a typed box appears, and uses a new per-part
-- `answers[]` array to render MULTIPLE labelled boxes for parts that ask for several values.
--
-- Multi-box convention (see backend types `PartAnswerField`): the part keeps a NON-NULL
-- sentinel part-level `answer_type`/`correct_answer` (so existing "graded part" / "reveal when
-- all done" logic still counts it) and the real per-box data lives in `answers[]`. The
-- part-level correct_answer + each answers[].correct_answer are stripped before reaching the client.
--
-- Genuine proofs / sketches / prose stay null. Parts whose answer cannot be confidently derived
-- (or which are free-text prose that exact-match can't grade, or whose typed grading is known to
-- be brittle) are marked `-- FLAG:` for human review.
--
-- LaTeX-in-JSON: every backslash is doubled; the whole parts block is dollar-quoted ($$...$$).
-- Each statement rewrites the FULL parts array for one question. No DDL.
--
-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1 — DHS H2 Math Prelim 2025
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 (d0250001) — (b) enable general solution.  FLAG: arbitrary constant A → exact-match brittle.
UPDATE questions SET parts = $$[
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
    "correct_answer": "-\\frac{x}{\\sqrt{3}}\\sqrt{1-\\frac{A}{x^3}}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
WHERE id = 'd0250001-0000-0000-0000-000000000000';

-- P1 Q2 (d0250002) — (a) determine range; (b) multi-box a, b, c.  FLAG (a): range form brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Explain why this is a geometric series. Determine the range of values of \\(x\\) for the sum to infinity of this series to exist. \\([3]\\)",
    "correct_answer": "1<x<\\frac{5}{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Using \\(x = 1\\), and given that \\(\\displaystyle\\sum_{r=1}^{n} r^2 = \\dfrac{n(n+1)(2n+1)}{6}\\), find \\(\\displaystyle\\sum_{r=0}^{n-1}\\!\\left[2(4-3x)^r + (r+1)(2r+5)\\right]\\), leaving your answer in the form \\(n(an^2 + bn + c)\\), where \\(a\\), \\(b\\) and \\(c\\) are constants to be determined. \\([4]\\)",
    "correct_answer": "a=2/3, b=5/2, c=23/6",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "\\frac{2}{3}", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "\\frac{5}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "\\frac{23}{6}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
WHERE id = 'd0250002-0000-0000-0000-000000000000';

-- P1 Q3 (d0250003) — (a) first three terms; (b) multi-box a, b, c + coefficient of x^4.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Find the first three non-zero terms in the Maclaurin series for \\(e^x \\sin(x+\\pi)\\). \\([3]\\)",
    "correct_answer": "-x-x^2-\\frac{x^3}{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that the three terms found in part (a) are equal to the first three terms in the expansion of \\(ax(1+bx)^c\\) for small \\(x\\). Find the exact values of \\(a\\), \\(b\\) and \\(c\\), and hence the coefficient of \\(x^4\\) in the expansion of \\(ax(1+bx)^c\\) (as a simplified rational number). \\([5]\\)",
    "correct_answer": "a=-1, b=1/3, c=3, coeff of x^4 = -1/27",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "\\frac{1}{3}", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "3", "answer_type": "exact", "tolerance": null },
      { "key": "coeff", "label": "\\text{coeff of }x^4", "correct_answer": "-\\frac{1}{27}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
WHERE id = 'd0250003-0000-0000-0000-000000000000';

-- P1 Q4 (d0250004) — (a) possible values of l.  FLAG (a): ± (two values) in one box → brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Given that the sequence converges to \\(l\\), find the possible exact values of \\(l\\). \\([3]\\)",
    "correct_answer": "\\frac{1\\pm\\sqrt{5}}{2}",
    "answer_type": "exact",
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
WHERE id = 'd0250004-0000-0000-0000-000000000000';

-- P1 Q5 (d0250005) — (b),(d) enable "state range" answers.  FLAG (a): "state the nature of
-- turning points" is descriptive prose → kept null (exact-match cannot grade it).
-- FLAG (b),(d): inequality/range forms → brittle.
UPDATE questions SET parts = $$[
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
    "correct_answer": "-2<x<1.5, x\\neq0",
    "answer_type": "exact",
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
    "correct_answer": "-1\\le k<0",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
WHERE id = 'd0250005-0000-0000-0000-000000000000';

-- P1 Q6 (d0250006) — (b) cartesian equation; (d) exact area.  FLAG both: equation/expression in
-- parameters a, A → exact-match brittle.
UPDATE questions SET parts = $$[
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
    "correct_answer": "\\frac{x\\sqrt{a^2+x^2}}{a}",
    "answer_type": "exact",
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
    "correct_answer": "\\frac{2}{3a}\\left[(A^2+a^2)^{\\frac{3}{2}}-a^3\\right]",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
WHERE id = 'd0250006-0000-0000-0000-000000000000';

-- P1 Q7 (d0250007) — (a) range of fg; (b) expression for g(x).  FLAG (a): interval form brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Explain why the composite function \\(\\mathrm{fg}\\) exists and find the corresponding range of \\(\\mathrm{fg}\\). \\([2]\\)",
    "correct_answer": "[e^{-\\frac{1}{2}}+1,\\infty)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(\\mathrm{fg}(x) = \\dfrac{x}{\\sqrt{e}} + \\dfrac{1}{2\\ln x + 1}\\), find an expression for \\(\\mathrm{g}(x)\\) in terms of \\(x\\). \\([2]\\)",
    "correct_answer": "\\ln x-\\frac{1}{2}",
    "answer_type": "exact",
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
WHERE id = 'd0250007-0000-0000-0000-000000000000';

-- P1 Q8 (d0250008) — (a) cartesian equation; (b) values of arg; (da) multi-box alpha, beta.
-- FLAG (a),(b): equation / ± form brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "By taking \\(x = \\mathrm{Re}(z)\\) and \\(y = \\mathrm{Im}(z)\\), sketch on an Argand diagram the curve showing the positions of \\(z\\). Find the cartesian equation of this curve. \\([3]\\)",
    "correct_answer": "\\frac{x^2}{4}+\\frac{y^2}{9}=1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "By referring to the Argand diagram, find the possible values of \\(\\arg(z_1 + z_2)\\). \\([2]\\)",
    "correct_answer": "\\pm\\frac{\\pi}{2}",
    "answer_type": "exact",
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
    "prompt_latex": "Given that \\(\\alpha\\) is not real and \\(|z_1| = |z_2| = \\dfrac{\\sqrt{26}}{2}\\), find the values of \\(\\alpha\\) and \\(\\beta\\). \\([4]\\)",
    "correct_answer": "alpha = -3√2 i, beta = -13/2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "alpha", "label": "\\alpha", "correct_answer": "-3\\sqrt{2}\\,\\mathrm{i}", "answer_type": "exact", "tolerance": null },
      { "key": "beta", "label": "\\beta", "correct_answer": "-\\frac{13}{2}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
WHERE id = 'd0250008-0000-0000-0000-000000000000';

-- P1 Q9 (d0250009) — NO data change.
-- FLAG (b): "find the vector equation of l in terms of a" — solution gives no explicit closed form; left null.
-- FLAG (d): "state the conditions ... justify" — prose/justification; left null.

-- P1 Q10 (d025000a) — (a) state h; (b) write down V2.  FLAG (b): summation expression → very brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(V_1 = \\pi h\\displaystyle\\sum_{r=0}^{n-1}[\\mathrm{f}(1+rh)]^2\\). State the value of \\(h\\) in terms of \\(n\\). \\([3]\\)",
    "correct_answer": "\\frac{2}{n}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "From the diagram, \\(V_1 < V\\). Write down \\(V_2\\), a similar expression where \\(V_2 > V\\). \\([1]\\)",
    "correct_answer": "\\pi h\\sum_{r=1}^{n}[\\mathrm{f}(1+rh)]^2",
    "answer_type": "exact",
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
WHERE id = 'd025000a-0000-0000-0000-000000000000';

-- P1 Q11 (d025000b) — (b) cost of hemisphere in terms of k.
UPDATE questions SET parts = $$[
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
    "correct_answer": "\\frac{3k}{10}",
    "answer_type": "exact",
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
WHERE id = 'd025000b-0000-0000-0000-000000000000';

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2 — DHS H2 Math Prelim 2025
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q2 (d0251002) — (b) exact value of definite integral (numerically gradable).
UPDATE questions SET parts = $$[
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
    "correct_answer": "\\frac{e^2+1}{2}\\tan^{-1}e-\\frac{e}{2}-\\frac{\\pi}{4}+\\frac{1}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
WHERE id = 'd0251002-0000-0000-0000-000000000000';

-- P2 Q3 (d0251003) — NO data change.
-- FLAG (c): "determine the nature of the stationary point" — descriptive prose; left null.

-- P2 Q4 (d0251004) — (a) vector equation of OD.  FLAG (a): vector equation with parameter → brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Find a vector equation of the line \\(OD\\) in terms of \\(k\\), \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\). \\([2]\\)",
    "correct_answer": "\\lambda((1-k)\\mathbf{a}+k\\mathbf{b})",
    "answer_type": "exact",
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
WHERE id = 'd0251004-0000-0000-0000-000000000000';

-- P2 Q5 (d0251005) — (a) multi-box: differential equation + T(t).  FLAG: ODE/expression brittle.
UPDATE questions SET parts = $$[
  {
    "label": "a",
    "prompt_latex": "Write down a differential equation for the situation and find the expression of \\(T(t)\\) in terms of \\(k\\). \\([3]\\)",
    "correct_answer": "dT/dt = -k(T-30); T(t) = 30 + 130e^{-kt}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "ode", "label": "\\frac{\\mathrm{d}T}{\\mathrm{d}t}", "correct_answer": "-k(T-30)", "answer_type": "exact", "tolerance": null },
      { "key": "T", "label": "T(t)", "correct_answer": "30+130e^{-kt}", "answer_type": "exact", "tolerance": null }
    ]
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
WHERE id = 'd0251005-0000-0000-0000-000000000000';

-- P2 Q6 (d0251006) — (ai) multi-box: max & min.
-- FLAG (aii): solution gives no explicit max/min values; left null.
UPDATE questions SET parts = $$[
  {
    "label": "ai",
    "prompt_latex": "Find exactly the maximum and minimum possible values of \\(P(A \\cap B' \\cap C)\\). \\([3]\\)",
    "correct_answer": "max = 0.5, min = 0.3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "min", "label": "\\text{min}", "correct_answer": "0.3", "answer_type": "range", "tolerance": 0.005 },
      { "key": "max", "label": "\\text{max}", "correct_answer": "0.5", "answer_type": "range", "tolerance": 0.005 }
    ]
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
WHERE id = 'd0251006-0000-0000-0000-000000000000';

-- P2 Q8 (d0251008) — NO data change.
-- FLAG (b): "determine the probability distribution of X" — a full table, not a single value; left null.

-- P2 Q9 (d0251009) — NO data change.
-- FLAG (a): "state the pmcc for each diagram" — matches 3 diagrams to values from a diagram; left null.

-- P2 Q11 (d025100b) — (e) range of h.  FLAG (e): "h ≤ 1842 or h ≥ 2008" disjoint range → brittle.
UPDATE questions SET parts = $$[
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
    "correct_answer": "h\\le1842\\text{ or }h\\ge2008",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
WHERE id = 'd025100b-0000-0000-0000-000000000000';

-- ════════════════════════════════════════════════════════════════════════════
-- HCI H2 Math Prelim 2025 — Paper 1 & Paper 2
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 (c0250001) — set of x for strictly decreasing.  FLAG: set/interval form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Using differentiation, find the set of values of \\(x\\) where the curve is strictly decreasing. Give your answers in exact form. \\([4]\\)", "correct_answer": "1-\\sqrt{3}<x<1+\\sqrt{3}, x\\neq1", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0250001-0000-0000-0000-000000000000';

-- P1 Q2 (c0250002) — (a) multi-box a,b,c; (b) multi-box x10,x11.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\). \\([3]\\)", "correct_answer": "a=2, b=3, c=-5", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "3", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "-5", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "b", "prompt_latex": "Hence find the values of \\(x_{10}\\) and \\(x_{11}\\). \\([2]\\)", "correct_answer": "x10=-7210868, x11=36172738", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "x10", "label": "x_{10}", "correct_answer": "-7210868", "answer_type": "exact", "tolerance": null },
      { "key": "x11", "label": "x_{11}", "correct_answer": "36172738", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'c0250002-0000-0000-0000-000000000000';

-- P1 Q3 (c0250003) — (b) general solution.  FLAG: arbitrary constant A, equation form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Using the substitution \\(u = xy^2\\), show that the differential equation can be reduced to \\(\\dfrac{\\mathrm{d}u}{\\mathrm{d}x} = \\dfrac{\\sec x}{u}\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the general solution to the differential equation. \\([3]\\)", "correct_answer": "x^2y^4=2\\ln(\\sec x+\\tan x)+A", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0250003-0000-0000-0000-000000000000';

-- P1 Q4 (c0250004) — (a) state h (mixed with explain → grade on h).
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "State the value of \\(h\\) and, using a suitable sketch, explain whether \\(\\displaystyle\\sum_{k=1}^{5} \\bigl(h\\,\\mathrm{f}(kh)\\bigr)\\) is less or more than the area of \\(A\\). \\([3]\\)", "correct_answer": "\\frac{1}{5}", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "\\(A\\) is now split into \\(n\\) vertical strips of equal width. Using calculus, find the exact value of \\(\\displaystyle\\lim_{n\\to\\infty}\\dfrac{1}{n}\\left(\\mathrm{e}^{3/n} + \\mathrm{e}^{6/n} + \\mathrm{e}^{9/n} + \\cdots + \\mathrm{e}^{(3n-3)/n} + \\mathrm{e}^{3} + n\\right)\\). \\([3]\\)", "correct_answer": "\\frac{e^3}{3}+\\frac{2}{3}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0250004-0000-0000-0000-000000000000';

-- P1 Q8 (c0250008) — (a) range of f; (d) range of fg.  FLAG: set/interval forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the range of \\(\\mathrm{f}\\) in terms of \\(a\\). \\([1]\\)", "correct_answer": "\\mathbb{R}\\setminus\\{\\frac{a}{5}\\}", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Find the value of \\(a\\). \\([2]\\)", "correct_answer": "4", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Hence find \\(\\mathrm{f}^{2025}(2)\\). \\([2]\\)", "correct_answer": "\\frac{5}{6}", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Find the range of \\(\\mathrm{fg}\\). \\([2]\\)", "correct_answer": "[\\frac{19}{30},\\frac{7}{10})", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0250008-0000-0000-0000-000000000000';

-- P1 Q9 (c0250009) — (a) indefinite integral (FLAG +C brittle); (b) multi-box A,B.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find \\(\\displaystyle\\int (2x-1)\\cos x\\,\\mathrm{d}x\\). \\([3]\\)", "correct_answer": "(2x-1)\\sin x+2\\cos x+C", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the value of \\(\\displaystyle\\int_0^{\\pi/2} |2x-1|\\cos x\\,\\mathrm{d}x\\). Give your answer in the form \\(A - 4\\cos B\\), where \\(A\\) and \\(B\\) are exact constants to be determined. \\([4]\\)", "correct_answer": "A=pi+1, B=1/2", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "A", "label": "A", "correct_answer": "\\pi+1", "answer_type": "exact", "tolerance": null },
      { "key": "B", "label": "B", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'c0250009-0000-0000-0000-000000000000';

-- P1 Q10 (c025000a) — (a) partial fractions; (bii) solve DE.  FLAG: expression/arbitrary-form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Express \\(\\dfrac{1}{Q(500-Q)}\\) in partial fractions. \\([2]\\)", "correct_answer": "\\frac{1}{500}\\left(\\frac{1}{Q}+\\frac{1}{500-Q}\\right)", "answer_type": "exact", "tolerance": null },
  { "label": "bi", "prompt_latex": "Show that the differential equation relating \\(Q\\) and \\(t\\) is \\(\\dfrac{\\mathrm{d}Q}{\\mathrm{d}t} = kQ(500-Q)\\), where \\(k\\) is a positive constant. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bii", "prompt_latex": "Hence solve the differential equation, expressing \\(Q\\) in terms of \\(k\\) and \\(t\\). \\([5]\\)", "correct_answer": "\\frac{1000e^{500kt}}{2e^{500kt}-1}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c025000a-0000-0000-0000-000000000000';

-- P1 Q11 (c025000b) — (b) coords of E; (c) plane eqn; (d) position vector of F.  FLAG (c),(d) brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the value of \\(m\\). \\([2]\\)", "correct_answer": "3", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Given that \\(l_1\\) and \\(l_2\\) intersect, find the coordinates of the point of intersection \\(E\\). \\([2]\\)", "correct_answer": "(13,7,8)", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Find a cartesian equation of the plane \\(\\Pi\\) which contains the points \\(A\\), \\(B\\) and \\(E\\). \\([3]\\)", "correct_answer": "2x+5y-2z=45", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "The point \\(D\\) has coordinates \\((-1,-3,2)\\). Find the position vector of the point \\(F\\), the foot of perpendicular of \\(D\\) to \\(\\Pi\\). \\([3]\\)", "correct_answer": "(3,7,-2)", "answer_type": "exact", "tolerance": null },
  { "label": "e", "prompt_latex": "Find the exact area of the circle that passes through \\(A\\), \\(D\\) and \\(F\\). \\([2]\\)", "correct_answer": "74\\pi", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c025000b-0000-0000-0000-000000000000';

-- P1 Q12 (c025000c) — (c) determine k (grade k only); (e) find w1.
-- FLAG (a): "determine with justification" prose → null.  FLAG (c): remaining roots not auto-graded (only k).
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "If \\(k\\) is a purely imaginary number, determine, with justification, whether \\(\\mathrm{f}(z) = 0\\) can have real roots. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Show that \\(\\mathrm{f}(-z) = \\mathrm{f}(z)\\). \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Given that \\(2+\\mathrm{i}\\) is a root of \\(\\mathrm{f}(z) = 0\\), determine \\(k\\). Hence, or otherwise, find the remaining roots, showing your working clearly. \\([6]\\)", "correct_answer": "25", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Using the value of \\(k\\) found in part (c): given that the product of all the roots of \\(\\mathrm{f}(z) = 0\\) is \\(D\\), find the value of \\(D\\), showing your working clearly. \\([2]\\)", "correct_answer": "25", "answer_type": "exact", "tolerance": null },
  { "label": "e", "prompt_latex": "A complex number \\(w_1\\) satisfies \\(kw^4 - 6w^2 + 1 = 0\\). Given that \\(w_1\\) can be obtained from \\(2+\\mathrm{i}\\), find \\(w_1\\). \\([2]\\)", "correct_answer": "\\frac{2-\\mathrm{i}}{5}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c025000c-0000-0000-0000-000000000000';

-- P1 Q13 (c025000d) — (a) recurrence; (c) months (grade n); (d) range of a; (e) relationship.
-- FLAG (a),(d),(e): expression/range/relationship forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Write down a recurrence relationship between \\(F(n)\\) and \\(F(n+1)\\) for \\(n \\in \\mathbb{Z}^+\\), giving your answer in terms of \\(a\\). \\([2]\\)", "correct_answer": "aF(n)+1000", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Show that \\(F(3) = 3500a^2 + 1000a + 1000\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Find an expression for \\(F(n)\\). Hence find the number of months required for Frederick's followers to exceed one million if \\(a = 1.5\\). \\([4]\\)", "correct_answer": "14", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Given that the number of followers exceeds 20000 by the end of the first year, determine the range of values of \\(a\\). \\([2]\\)", "correct_answer": "a>1.05", "answer_type": "exact", "tolerance": null },
  { "label": "e", "prompt_latex": "Instead of 1000, the company provides \\(b\\) additional followers mid-month. Given that the number of followers remains constant since the end of the first month, find the relationship between \\(a\\) and \\(b\\). \\([2]\\)", "correct_answer": "b=3500(1-a)", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c025000d-0000-0000-0000-000000000000';

-- P2 Q2 (c0251002) — (a) Maclaurin terms (mixed show+find → grade on the series).  FLAG brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\(\\dfrac{\\mathrm{d}^2y}{\\mathrm{d}x^2} + \\left(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right)^2 + 1 = 0\\). Hence find the first four non-zero terms of the Maclaurin expansion of \\(y\\), leaving your answer in exact form. \\([6]\\)", "correct_answer": "\\ln\\frac{1}{\\sqrt{2}}+x-x^2+\\frac{2}{3}x^3", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Verify the result obtained in part (a) using standard series from the List of Formulae (MF27). \\([5]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'c0251002-0000-0000-0000-000000000000';

-- P2 Q3 (c0251003) — (a) multi-box A,B (numerically gradable); (c) cartesian eqn; (e) range of m.
-- FLAG (c),(e): equation/range forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} = -\\dfrac{2}{3}\\sec\\theta\\). Hence find the equation of the normal to \\(C\\) at the point where \\(\\theta = \\dfrac{\\pi}{4}\\), in the form \\(y = Ax + B\\), where \\(A\\) and \\(B\\) are exact constants. \\([4]\\)", "correct_answer": "A=3/(2√2), B=7/2-3/(2√2)", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "A", "label": "A", "correct_answer": "\\frac{3}{2\\sqrt{2}}", "answer_type": "exact", "tolerance": null },
      { "key": "B", "label": "B", "correct_answer": "\\frac{7}{2}-\\frac{3}{2\\sqrt{2}}", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "b", "prompt_latex": "Show that the normal found in part (a) will cut \\(C\\) again. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Find the Cartesian equation of \\(C\\). \\([2]\\)", "correct_answer": "\\left(\\frac{1-x}{3}\\right)^2-\\left(\\frac{y+3}{2}\\right)^2=1", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Sketch \\(C\\), indicating clearly its key features. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "Find the range of values of \\(m\\) such that there is no intersection between the line \\(y = m(x-1) - 3\\) and \\(C\\). \\([2]\\)", "correct_answer": "m<-\\frac{2}{3}\\text{ or }m>\\frac{2}{3}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0251003-0000-0000-0000-000000000000';

-- P2 Q7 (c0251007) — (d) multi-box a,b; (e) rewritten model.
-- FLAG (b): additional data point is non-unique → null.  FLAG (e): expression brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Using the regression line \\(s = 1.125t + 11\\), find the sum of the squares of the residuals. \\([1]\\)", "correct_answer": "14.75", "answer_type": "range", "tolerance": 0.005 },
  { "label": "b", "prompt_latex": "State the coordinates of an additional data point such that, with all 8 data points, the regression line remains the same. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Sketch a scatter diagram of \\(s\\) against \\(t\\) for the data given in the table. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "The models proposed are (A) \\(s = at^2 + b\\), (B) \\(s = -c\\mathrm{e}^t + d\\), (C) \\(s = f\\ln(t+h)\\), with positive constants. Explain which model gives the best fit, and state the values of the constants for the chosen model. \\([2]\\)", "correct_answer": "a=0.119, b=12.8", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "0.119", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "b", "label": "b", "correct_answer": "12.8", "answer_type": "range", "tolerance": 0.05 }
    ] },
  { "label": "e", "prompt_latex": "A temperature \\(F\\,^\\circ\\)F equals \\(C\\,^\\circ\\)C where \\(F = \\dfrac{9}{5}C + 32\\). Using the chosen model, rewrite the equation to estimate monthly sales when the temperature \\(T\\) is in degrees Fahrenheit. \\([2]\\)", "correct_answer": "0.119\\left(\\frac{5}{9}(T-32)\\right)^2+12.8", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'c0251007-0000-0000-0000-000000000000';

-- P2 Q8 (c0251008) — (b) multi-box mean & variance.  FLAG (a): "state what random means" prose → null.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "State what it means for a sample to be random in this context. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the unbiased estimates for the population mean and variance. \\([2]\\)", "correct_answer": "mean=424.18, variance=10.7", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "mean", "label": "\\text{mean}", "correct_answer": "424.18", "answer_type": "range", "tolerance": 0.005 },
      { "key": "var", "label": "\\text{variance}", "correct_answer": "10.7", "answer_type": "range", "tolerance": 0.05 }
    ] },
  { "label": "c", "prompt_latex": "State the hypotheses for the manager's test, defining any parameters you use. Carry out the test at the 5% level of significance, giving your conclusion in context. \\([5]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "The manager tests whether the mean has increased using an alternative process: 55 cans give mean 426.5 g, tested at 10% significance. Explain, with justification, how the population standard deviation of the mass under the alternative process affects the conclusion. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'c0251008-0000-0000-0000-000000000000';

-- P2 Q9 (c0251009) — (b) multi-box max & min; (e) multi-box two values of p.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\(\\mathrm{E}(X) = -0.1 + 0.4p - p^2\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the maximum and minimum possible values of \\(\\mathrm{E}(X)\\). \\([2]\\)", "correct_answer": "max=-0.06, min=-0.31", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "max", "label": "\\text{max}", "correct_answer": "-0.06", "answer_type": "range", "tolerance": 0.005 },
      { "key": "min", "label": "\\text{min}", "correct_answer": "-0.31", "answer_type": "range", "tolerance": 0.005 }
    ] },
  { "label": "c", "prompt_latex": "The game is played for 30 rounds. If \\(p = 0.4\\), find the probability that the player's mean score exceeds 0, to 3 significant figures. \\([3]\\)", "correct_answer": "0.397", "answer_type": "range", "tolerance": 0.0005 },
  { "label": "d", "prompt_latex": "The game is played for 10 rounds. Given that the probability of finding more than 3 Small traps is 10%, find the value of \\(p\\), to 3 significant figures. \\([2]\\)", "correct_answer": "0.188", "answer_type": "range", "tolerance": 0.0005 },
  { "label": "e", "prompt_latex": "Over a long period, the number of Small traps in 10 rounds follows a bimodal distribution, with one mode being 3. Find the two exact possible values of \\(p\\), showing your working clearly. \\([3]\\)", "correct_answer": "p=3/11 or 4/11", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "p1", "label": "p_1", "correct_answer": "\\frac{3}{11}", "answer_type": "exact", "tolerance": null },
      { "key": "p2", "label": "p_2", "correct_answer": "\\frac{4}{11}", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'c0251009-0000-0000-0000-000000000000';

-- P2 Q10 (c025100a) — (b) range of k; (c) multi-box two variances.  FLAG (b): range brittle; (a) prose → null.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Give a reason why the model \\(N(2,1.5^2)\\) is not suitable. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Using \\(W \\sim N(5,1^2)\\), find the range of values of \\(k\\) such that at least 90% of customers experience a wait time longer than \\(k\\) minutes. \\([2]\\)", "correct_answer": "0\\le k\\le3.71", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "With \\(\\bar{W} = \\dfrac{W_1 + W_2 + W_3}{3}\\), find \\(\\operatorname{Var}(\\bar{W} - W_1)\\) and \\(\\operatorname{Var}(\\bar{W}) + \\operatorname{Var}(W_1)\\), and hence determine whether \\(\\operatorname{Var}(\\bar{W} - W_1) = \\operatorname{Var}(\\bar{W}) + \\operatorname{Var}(W_1)\\). \\([2]\\)", "correct_answer": "Var(W̄-W1)=2/3, Var(W̄)+Var(W1)=4/3", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "v1", "label": "\\operatorname{Var}(\\bar{W}-W_1)", "correct_answer": "\\frac{2}{3}", "answer_type": "exact", "tolerance": null },
      { "key": "v2", "label": "\\operatorname{Var}(\\bar{W})+\\operatorname{Var}(W_1)", "correct_answer": "\\frac{4}{3}", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "d", "prompt_latex": "Find the probability that the mean wait time is within one minute of the wait time on the first occasion, to 3 significant figures. \\([3]\\)", "correct_answer": "0.779", "answer_type": "range", "tolerance": 0.0005 },
  { "label": "e", "prompt_latex": "On the 4th occasion the time in the restroom is \\(T \\sim N(7,1.5^2)\\), independent of \\(W\\). The customer will not wait more than 3 minutes after leaving the restroom. Given that the burger is not ready when the customer leaves the restroom, find the probability that the customer leaves without collecting the burger, to 3 significant figures. \\([4]\\)", "correct_answer": "0.0208", "answer_type": "range", "tolerance": 0.00005 },
  { "label": "f", "prompt_latex": "Kiosk wait time is reduced by 20% from the counter. 8 counter customers and 8 kiosk customers are selected, all independent. Find the probability that exactly 2 of these 16 customers have a wait time of at least 5 minutes, to 3 significant figures. \\([4]\\)", "correct_answer": "0.0575", "answer_type": "range", "tolerance": 0.00005 }
]$$::jsonb WHERE id = 'c025100a-0000-0000-0000-000000000000';

-- ════════════════════════════════════════════════════════════════════════════
-- ACJC H2 Math Prelim 2025 — Paper 1 & Paper 2
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 (a0250001) — solve inequalities.  FLAG: inequality forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Without using a calculator, solve the inequality \\(\\dfrac{x}{x+2} \\geq \\dfrac{2}{2-x}\\). \\([4]\\)", "correct_answer": "x<-2\\text{ or }x>2", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Hence, solve the inequality \\(\\dfrac{|x|}{|x|+2} \\geq \\dfrac{2}{2-|x|}\\). \\([2]\\)", "correct_answer": "x<-2\\text{ or }x>2", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0250001-0000-0000-0000-000000000000';

-- P1 Q2 (a0250002) — (a) write down d (mixed with show); (b) range of c.  FLAG (b): range brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Write down the value of \\(d\\) and show that \\(a = 2\\) and \\(b = 4\\). \\([3]\\)", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the range of values of \\(c\\) if the graph has no stationary points. \\([2]\\)", "correct_answer": "c<2", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0250002-0000-0000-0000-000000000000';

-- P1 Q3 (a0250003) — (b) multi-box coordinates (x numeric, y exact).
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} = \\dfrac{y^2(1+\\ln x)}{1 - \\ln y}\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the coordinates of the point on the curve \\(y = x^{xy}\\) whose tangent is parallel to the \\(y\\)-axis. \\([2]\\)", "correct_answer": "(1.32, e)", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1.32", "answer_type": "range", "tolerance": 0.005 },
      { "key": "y", "label": "y", "correct_answer": "\\mathrm{e}", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'a0250003-0000-0000-0000-000000000000';

-- P1 Q4 (a0250004) — multi-box a, b.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the exact volume of the solid formed when \\(R\\) is rotated about the \\(x\\)-axis through \\(2\\pi\\) radians. Give your answer in the form \\(\\dfrac{\\pi\\mathrm{e}^3}{27}(a\\mathrm{e}^3 + b)\\), where \\(a\\) and \\(b\\) are integers to be found. \\([6]\\)", "correct_answer": "a=26, b=-5", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "26", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "-5", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'a0250004-0000-0000-0000-000000000000';

-- P1 Q5 (a0250005) — (b) line eqn; (c) foot of perpendicular.  FLAG both: vector forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Given that \\(\\mathbf{a}\\cdot\\mathbf{n} = \\mathbf{b}\\cdot\\mathbf{n} \\neq 0\\), show that \\(\\overrightarrow{AB}\\) is perpendicular to \\(\\mathbf{n}\\). Hence describe the geometrical relationship between \\(\\overrightarrow{AB}\\) and the plane \\(p\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Write down the equation of a line parallel to \\(\\overrightarrow{AB}\\) that is contained in the plane \\(p\\). \\([1]\\)", "correct_answer": "\\lambda(\\mathbf{b}-\\mathbf{a})", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "The point \\(F\\) is the foot of perpendicular from a point \\(C\\) with position vector \\(\\mathbf{c}\\) to the plane \\(p\\). Find the position vector of \\(F\\) in terms of \\(\\mathbf{c}\\) and \\(\\mathbf{n}\\). \\([3]\\)", "correct_answer": "\\mathbf{c}-\\frac{\\mathbf{c}\\cdot\\mathbf{n}}{\\mathbf{n}\\cdot\\mathbf{n}}\\mathbf{n}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0250005-0000-0000-0000-000000000000';

-- P1 Q8 (a0250008) — (bii) range of g^-1.  FLAG: interval form brittle.
UPDATE questions SET parts = $$[
  { "label": "ai", "prompt_latex": "Sketch the graph of \\(y = \\mathrm{f}(|x|)\\), labelling the points where it intersects or touches the axes. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "aii", "prompt_latex": "Sketch the graph of \\(y = \\dfrac{1}{\\mathrm{f}(x)}\\), labelling intercepts and the equations of any asymptotes. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "aiii", "prompt_latex": "Describe fully a sequence of transformations which transforms the graph of \\(y = \\mathrm{f}(2x+1)\\) onto the graph of \\(y = \\mathrm{f}(x)\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bi", "prompt_latex": "The function \\(\\mathrm{g}\\) is such that \\(\\mathrm{g}(x) = \\mathrm{f}(x)\\) for \\(x \\leq k\\), and \\(\\mathrm{g}^{-1}\\) exists. Find the largest possible value of \\(k\\) in terms of \\(a\\) and \\(b\\). \\([1]\\)", "correct_answer": "\\frac{a+b}{2}", "answer_type": "exact", "tolerance": null },
  { "label": "bii", "prompt_latex": "Using the value of \\(k\\) found in (b)(i), write down the range of \\(\\mathrm{g}^{-1}\\) in terms of \\(a\\) and \\(b\\). \\([2]\\)", "correct_answer": "(-\\infty,\\frac{a+b}{2}]", "answer_type": "exact", "tolerance": null },
  { "label": "biii", "prompt_latex": "Explain why the solution to \\(\\mathrm{g}^{-1}(x) = x\\) satisfies the equation \\(\\mathrm{g}^{-1}(x) = \\mathrm{g}(x)\\). \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'a0250008-0000-0000-0000-000000000000';

-- P1 Q9 (a0250009) — (c) multi-box two points; (d) plane eqn.  FLAG: vector/equation forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\(c = -1\\). \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Show that the vector equation of the line of intersection \\(l\\) of \\(\\pi_1\\) and \\(\\pi_2\\) is \\(\\mathbf{r} = \\mathbf{i}+3\\mathbf{j}-2\\mathbf{k} + \\alpha(\\mathbf{i}-\\mathbf{j}+4\\mathbf{k})\\), where \\(\\alpha\\) is a parameter. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Find the position vectors of the points on \\(l\\) which are a distance of \\(3\\sqrt{2}\\) from the point \\(B(2, -3, 7)\\). \\([4]\\)", "correct_answer": "(3,1,6) and (34/9,2/9,82/9)", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "P1", "label": "P_1", "correct_answer": "(3,1,6)", "answer_type": "exact", "tolerance": null },
      { "key": "P2", "label": "P_2", "correct_answer": "(\\frac{34}{9},\\frac{2}{9},\\frac{82}{9})", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "d", "prompt_latex": "Find the equation of the plane \\(\\pi_3\\) parallel to \\(\\pi_2\\) and containing \\(B\\). Hence show that the distance between \\(\\pi_2\\) and \\(\\pi_3\\) is \\(\\dfrac{20}{3\\sqrt{3}}\\). \\([3]\\)", "correct_answer": "x+5y+z=-6", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0250009-0000-0000-0000-000000000000';

-- P1 Q10 (a025000a) — (a) multi-box p,q (roots not graded — FLAG); (bi) multi-box modulus,argument.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "One of the roots of \\(\\omega^4 - 2\\omega^3 + 10\\omega^2 + p\\omega + q = 0\\), where \\(p\\) and \\(q\\) are real, is \\(2 + 3\\mathrm{i}\\). Find the values of \\(p\\) and \\(q\\) and the other roots of the equation. \\([6]\\)", "correct_answer": "p=6, q=65", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "p", "label": "p", "correct_answer": "6", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "65", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "bi", "prompt_latex": "The complex numbers \\(u\\) and \\(v\\) satisfy \\(u = -\\sqrt{2} + \\mathrm{i}\\sqrt{2}\\), \\(|v| = 3\\), \\(\\arg v = \\theta\\) with \\(0 < \\theta < \\tfrac{\\pi}{4}\\). Find the modulus and argument of \\(u\\). \\([2]\\)", "correct_answer": "|u|=2, arg(u)=3pi/4", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "mod", "label": "|u|", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "arg", "label": "\\arg u", "correct_answer": "\\frac{3\\pi}{4}", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "bii", "prompt_latex": "The points \\(A\\), \\(B\\), \\(C\\) represent \\(u\\), \\(v\\), \\(u+v\\). Sketch \\(A\\), \\(B\\), \\(C\\) on an Argand diagram. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "biii", "prompt_latex": "By finding the angle \\(OAC\\) in terms of \\(\\theta\\) or otherwise, show that \\(|u+v|^2 = a + b\\cos(\\theta + K)\\), where \\(a\\), \\(b\\) and \\(K\\) are constants to be determined. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'a025000a-0000-0000-0000-000000000000';

-- P1 Q11 (a025000b) — (b) multi-box two tangents + angle.  FLAG: tangent equations brittle/order-sensitive.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that the equation of the tangent to \\(C\\) at \\(P\\!\\left(ap^2, \\tfrac{a}{p}\\right)\\) is \\(2p^3 y + x = 3ap^2\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the equations of the tangents to \\(C\\) where \\(x = a\\), and the acute angle between these tangents. \\([3]\\)", "correct_answer": "tangents 2y+x=3a and x-2y=3a; angle 53.1 deg", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "t1", "label": "\\text{tangent 1}", "correct_answer": "2y+x=3a", "answer_type": "exact", "tolerance": null },
      { "key": "t2", "label": "\\text{tangent 2}", "correct_answer": "x-2y=3a", "answer_type": "exact", "tolerance": null },
      { "key": "angle", "label": "\\text{angle}", "correct_answer": "53.1", "answer_type": "range", "tolerance": 0.1 }
    ] },
  { "label": "ci", "prompt_latex": "Show that \\((q-p)^2(q+2p) = q^3 - 3p^2 q + 2p^3\\). \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "cii", "prompt_latex": "The tangent at \\(P\\) cuts \\(C\\) again at \\(Q\\!\\left(aq^2, \\tfrac{a}{q}\\right)\\). Find \\(q\\) in terms of \\(p\\). \\([3]\\)", "correct_answer": "-2p", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "For \\(a = 1\\) (so \\(xy^2 = 1\\)), the region \\(S\\) is bounded by the tangent to \\(C\\) at \\(\\left(p^2, \\tfrac{1}{p}\\right)\\), the curve \\(C\\) and the line \\(x = p^2\\). Find the area of \\(S\\) in terms of \\(p\\). \\([3]\\)", "correct_answer": "\\frac{11p}{4}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a025000b-0000-0000-0000-000000000000';

-- P1 Q12 (a025000c) — (b) outstanding loan.  FLAG (b): expression in y.  FLAG (e): month/year text → null.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the value of \\(x\\). \\([3]\\)", "correct_answer": "76.75", "answer_type": "range", "tolerance": 0.005 },
  { "label": "b", "prompt_latex": "Find the amount of outstanding loan after Sarah's first monthly repayment. \\([1]\\)", "correct_answer": "23760(1.004)-y", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Show that the amount of outstanding loan after Sarah's \\(n\\)th monthly repayment is \\(23760(1.004)^n - 250y\\bigl((1.004)^n - 1\\bigr)\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "Sarah wants to pay off her remaining loan by the end of 3 years. Find the value of \\(y\\). \\([2]\\)", "correct_answer": "709.98", "answer_type": "range", "tolerance": 0.005 },
  { "label": "e", "prompt_latex": "Instead, she repays \\$500 per month for the first 24 months, then \\$1000 per month. Determine the month and year Sarah clears her loan, and the amount of her final repayment. \\([4]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'a025000c-0000-0000-0000-000000000000';

-- P2 Q1 (a0251001) — multi-box R and A'.  FLAG: vectors brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the position vector of the point \\(R\\) on line \\(OB\\) such that \\(AR\\) is perpendicular to \\(OB\\). Hence find the position vector of \\(A'\\), the reflection of \\(A\\) in the line \\(OB\\). \\([4]\\)", "correct_answer": "R=(2,-8/5,6/5), A'=(1,-21/5,-3/5)", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "R", "label": "R", "correct_answer": "(2,-\\frac{8}{5},\\frac{6}{5})", "answer_type": "exact", "tolerance": null },
      { "key": "Aprime", "label": "A'", "correct_answer": "(1,-\\frac{21}{5},-\\frac{3}{5})", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'a0251001-0000-0000-0000-000000000000';

-- P2 Q2 (a0251002) — (a),(b) Maclaurin series.  FLAG: series forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Using standard series from the List of Formulae (MF27), find the Maclaurin expansion of \\(\\mathrm{f}(x)\\) up to and including the term in \\(x^6\\). \\([2]\\)", "correct_answer": "1+2x^2+6x^4+20x^6", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Hence find the first four non-zero terms of the Maclaurin series for \\(\\sin^{-1}2x\\). \\([4]\\)", "correct_answer": "2x+\\frac{4}{3}x^3+\\frac{12}{5}x^5+\\frac{40}{7}x^7", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0251002-0000-0000-0000-000000000000';

-- P2 Q3 (a0251003) — (aii) sum in n; (b) multi-box u2,u3,u4,u2025.  FLAG (aii): expression brittle.
UPDATE questions SET parts = $$[
  { "label": "ai", "prompt_latex": "Show that \\(\\displaystyle\\sum_{r=1}^{n} r(r+1)^2 = \\dfrac{n(n+1)(n+2)(3n+5)}{12}\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "aii", "prompt_latex": "Hence find \\(\\displaystyle\\sum_{r=5}^{n-1}(r+2)(r+3)^2\\) in terms of \\(n\\). \\([3]\\)", "correct_answer": "\\frac{(n+1)(n+2)(n+3)(3n+8)}{12}-644", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "The sequence \\(u_1, u_2, u_3, \\ldots\\) is defined by \\(u_1 = 2\\), \\(u_{n+1} = \\dfrac{1}{1 - u_n}\\), \\(n \\geq 1\\). Find \\(u_2\\), \\(u_3\\) and \\(u_4\\). Hence find \\(u_{2025}\\). \\([3]\\)", "correct_answer": "u2=-1, u3=1/2, u4=2, u2025=1/2", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "u2", "label": "u_2", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "u3", "label": "u_3", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "u4", "label": "u_4", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "u2025", "label": "u_{2025}", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'a0251003-0000-0000-0000-000000000000';

-- P2 Q4 (a0251004) — (a) inverse; (b) range of f; (c) range of gf.  FLAG: function/interval forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find \\(\\mathrm{f}^{-1}(x)\\). \\([3]\\)", "correct_answer": "-3+\\sqrt{\\frac{1}{x}+4}", "answer_type": "exact", "tolerance": null },
  { "label": "b", "prompt_latex": "Find algebraically the range of \\(\\mathrm{f}\\). \\([4]\\)", "correct_answer": "(-\\infty,-\\frac{1}{4}]\\cup(0,\\infty)", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Find the exact range of \\(\\mathrm{gf}\\). \\([2]\\)", "correct_answer": "(0,\\mathrm{e}^{-\\frac{1}{4}}]\\cup(1,\\infty)", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0251004-0000-0000-0000-000000000000';

-- P2 Q5 (a0251005) — (bii) expression for t.  FLAG: log expression brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "By using the substitution \\(x = a\\tan\\theta\\), show that \\(\\displaystyle\\int \\dfrac{1}{x\\sqrt{x^2+a^2}}\\,\\mathrm{d}x = \\dfrac{1}{a}\\ln\\dfrac{x}{\\sqrt{x^2+a^2}+a} + c\\), where \\(x > 0\\) and \\(a > 0\\). \\([4]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bi", "prompt_latex": "Find \\(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\) in terms of \\(x\\) and \\(y\\), and by solving this differential equation show that \\(y = \\sqrt{x^2+9}\\). \\([4]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bii", "prompt_latex": "Obtain a differential equation in terms of \\(x\\) and \\(t\\) only, and hence find an expression for \\(t\\) in terms of \\(x\\). \\([4]\\)", "correct_answer": "\\frac{1}{3}\\ln\\frac{x}{\\sqrt{x^2+9}+3}+\\frac{1}{3}\\ln2", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a0251005-0000-0000-0000-000000000000';

-- P2 Q6 (a0251006) — (b) multi-box min & max.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "If \\(\\mathrm{P}(B\\mid A) = 0.2\\), \\(\\mathrm{P}(A\\mid B) = 0.6\\) and \\(\\mathrm{P}(A'\\cap B') = 0.3\\), find \\(\\mathrm{P}(A\\cap B)\\). \\([3]\\)", "correct_answer": "0.124", "answer_type": "range", "tolerance": 0.0005 },
  { "label": "b", "prompt_latex": "Events \\(X, Y, Z\\) are such that \\(X\\) and \\(Z\\) are mutually exclusive, with \\(\\mathrm{P}(X\\cap Y) = 0.1\\), \\(\\mathrm{P}(X'\\cap Y) = 0.35\\), \\(\\mathrm{P}(Y\\cap Z) = 0.2\\) and \\(\\mathrm{P}(X\\cup Y\\cup Z) = 0.95\\). Find the minimum and maximum values of \\(\\mathrm{P}(X)\\). \\([3]\\)", "correct_answer": "min=0.1, max=0.6", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "min", "label": "\\text{min}", "correct_answer": "0.1", "answer_type": "range", "tolerance": 0.005 },
      { "key": "max", "label": "\\text{max}", "correct_answer": "0.6", "answer_type": "range", "tolerance": 0.005 }
    ] }
]$$::jsonb WHERE id = 'a0251006-0000-0000-0000-000000000000';

-- P2 Q8 (a0251008) — multi-box a, b, c.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\). \\([5]\\)", "correct_answer": "a=0.1, b=0.15, c=0.35", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "0.1", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "b", "label": "b", "correct_answer": "0.15", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "c", "label": "c", "correct_answer": "0.35", "answer_type": "range", "tolerance": 0.0005 }
    ] }
]$$::jsonb WHERE id = 'a0251008-0000-0000-0000-000000000000';

-- P2 Q9 (a0251009) — NO data change.  FLAG (a): "state two assumptions" prose → null.

-- P2 Q10 (a025100a) — (b) multi-box c,d; (c) estimate.  FLAG (b): model choice not graded.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Draw a scatter diagram and explain why the relationship between \\(h\\) and \\(t\\) is not well-modelled by \\(h = a + bt\\) or \\(h = a + bt^2\\) (\\(b > 0\\)). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "For Model A \\(h = c + d\\sqrt{t}\\) and Model B \\(h = c + d\\ln t\\), explain which is a better fit, and state the least squares regression line to 3 decimal places. \\([3]\\)", "correct_answer": "c=3.890, d=5.311", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "c", "label": "c", "correct_answer": "3.890", "answer_type": "range", "tolerance": 0.005 },
      { "key": "d", "label": "d", "correct_answer": "5.311", "answer_type": "range", "tolerance": 0.005 }
    ] },
  { "label": "c", "prompt_latex": "Use your regression line in (b) to estimate the height of a 6-week-old bamboo stalk, and comment on the reliability. \\([2]\\)", "correct_answer": "13.4", "answer_type": "range", "tolerance": 0.05 },
  { "label": "d", "prompt_latex": "Comment on the suitability of using this model in the long run. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "Let \\(H\\) be the height predicted by the regression line in (b) for each \\(t\\). Find \\(S = \\sum (h - H)^2\\), giving your answer to 2 decimal places. \\([1]\\)", "correct_answer": "0.77", "answer_type": "range", "tolerance": 0.005 },
  { "label": "f", "prompt_latex": "For \\(H' = p + q\\ln t\\) with constants \\(p, q\\), would \\(\\sum (h - H')^2\\) be greater or less than \\(S\\), and why? \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'a025100a-0000-0000-0000-000000000000';

-- P2 Q11 (a025100b) — (e) range of mu0.  FLAG (e): range brittle.  (a)-(d) prose/test → null.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "State appropriate hypotheses for the test of the claim, defining any symbols you use. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Test whether the supervisor's claim is justified at the 5% level of significance. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Explain whether there is a need for the supervisor to know anything about the population distribution of \\(X\\). \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "Two years later a sample of 20 tests has mean \\(5.88\\); an officer claims the mean differs from \\(\\mu_0\\). State two assumptions needed to carry out a hypothesis test for this claim. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "Given that the officer does not reject the null hypothesis at the 1% level of significance, find the range of values of \\(\\mu_0\\). \\([3]\\)", "correct_answer": "5.52<\\mu_0<6.24", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'a025100b-0000-0000-0000-000000000000';

-- P2 Q12 (a025100c) — (c) set of n.  FLAG (c): set form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Sketch the distribution of \\(T\\) and shade the area representing the probability that a randomly chosen call takes between 1.2 and 2.8 minutes to categorise. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "For a routine call (categorised then resolved), \\(\\mathrm{P}(\\text{duration} > 8) = 0.254\\). Show that \\(k = 2.24\\) correct to 2 decimal places. \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "On a morning with 20 incoming calls, \\(n\\) are complex. Given \\(\\mathrm{P}(\\text{mean resolve time of the } n \\text{ complex calls} > 24) \\leq 0.01\\), find the set of values of \\(n\\). \\([3]\\)", "correct_answer": "13\\le n\\le20", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "After a review, the time to resolve a complex call is reduced by 20%. Find the probability that the time to resolve 2 complex calls is more than twice the time to resolve a routine call. \\([4]\\)", "correct_answer": "0.998", "answer_type": "range", "tolerance": 0.0005 }
]$$::jsonb WHERE id = 'a025100c-0000-0000-0000-000000000000';

-- ════════════════════════════════════════════════════════════════════════════
-- CJC H2 Math Prelim 2025 — Paper 1 & Paper 2
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q1 (b0250001) — (a) multi-box p,q,r; (b) range of m.  FLAG (b): range brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the values of \\(p\\), \\(q\\) and \\(r\\). \\([3]\\)", "correct_answer": "p=3, q=-3, r=4", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "p", "label": "p", "correct_answer": "3", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "-3", "answer_type": "exact", "tolerance": null },
      { "key": "r", "label": "r", "correct_answer": "4", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "b", "prompt_latex": "The curve \\(D\\) has equation \\((x-3)^2 + m(y-3)^2 = 3m\\), where \\(m\\) is a positive constant. Find the range of \\(m\\) for which curves \\(C\\) and \\(D\\) do not intersect. \\([2]\\)", "correct_answer": "0<m<4", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0250001-0000-0000-0000-000000000000';

-- P1 Q2 (b0250002) — (a) multi-box a,b,c.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\). \\([3]\\)", "correct_answer": "a=1, b=1, c=0", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "0", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "b", "prompt_latex": "Given that \\(\\displaystyle\\sum_{n=1}^{N}\\dfrac{1}{u_n} = 1 - \\dfrac{1}{N+1}\\), find \\(\\displaystyle\\sum_{n=8}^{\\infty}\\dfrac{1}{u_n}\\). \\([3]\\)", "correct_answer": "\\frac{1}{8}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0250002-0000-0000-0000-000000000000';

-- P1 Q3 (b0250003) — (b) cartesian eqn of normal.  FLAG: equation form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Sketch \\(C\\), stating clearly the coordinates of the endpoints and the \\(y\\)-intercept(s). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the exact cartesian equation of \\(l\\), the normal to \\(C\\) at the point \\(\\left(\\tfrac{1}{4}, 2\\right)\\). \\([4]\\)", "correct_answer": "8y+4x=17", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0250003-0000-0000-0000-000000000000';

-- P1 Q6 (b0250006) — (b) value of a·c (interpretation prose not graded).
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\(0 < |\\mathbf{b}| < 1\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "It is given further that \\(|\\mathbf{b}| = \\tfrac12\\) and \\(C\\) lies on \\(AB\\) with \\(AC:CB = 2:1\\). Find the value of \\(\\mathbf{a}\\cdot\\mathbf{c}\\) and state the geometrical interpretation of \\(\\mathbf{a}\\cdot\\mathbf{c}\\). \\([4]\\)", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Find the value of \\(\\dfrac{|\\mathbf{a}\\times\\mathbf{b}|}{|\\mathbf{a}\\times\\mathbf{c}|}\\). \\([2]\\)", "correct_answer": "\\frac{3}{2}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0250006-0000-0000-0000-000000000000';

-- P1 Q7 (b0250007) — (b),(c) Maclaurin/series.  FLAG: series forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that \\((1 + \\mathrm{e}^{2x})\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} + y\\mathrm{e}^x = 0\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the Maclaurin series for \\(y\\), up to and including the term in \\(x^2\\). \\([5]\\)", "correct_answer": "1-\\frac{1}{2}x+\\frac{1}{8}x^2", "answer_type": "exact", "tolerance": null },
  { "label": "c", "prompt_latex": "Deduce the series expansion for \\(\\dfrac{\\mathrm{e}^{\\frac{\\pi}{4} - \\tan^{-1}(\\mathrm{e}^x)}}{\\mathrm{e}^x + 1}\\), up to and including the term in \\(x^2\\), giving the coefficients in exact form. \\([4]\\)", "correct_answer": "\\frac{1}{2}-\\frac{1}{2}x+\\frac{3}{8}x^2", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0250007-0000-0000-0000-000000000000';

-- P1 Q8 (b0250008) — (c) foot of perpendicular.  FLAG: vector form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that a cartesian equation of \\(p\\) is \\(x - y - 2z = -3\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the acute angle between \\(l\\) and \\(p\\), in degrees. \\([2]\\)", "correct_answer": "56.4", "answer_type": "range", "tolerance": 0.05 },
  { "label": "c", "prompt_latex": "A variable point \\(R\\) lies on \\(p\\) and is at a distance of \\(\\sqrt{22}\\) from the point \\(Q(3,4,-2)\\). Find the foot of perpendicular from \\(Q\\) to \\(p\\). \\([4]\\)", "correct_answer": "(2,5,0)", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Hence describe geometrically the path traced by \\(R\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'b0250008-0000-0000-0000-000000000000';

-- P1 Q9 (b0250009) — (b) multi-box P,Q.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Given that the radius of the pond is 10 m, show that the radius \\(r\\) m satisfies \\(\\dfrac{\\mathrm{d}r}{\\mathrm{d}t} = \\dfrac{k(100 - r^2)}{2r}\\), \\(k > 0\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "The initial radius is 1 m. Solve the differential equation, expressing \\(r\\) in the form \\(r = \\sqrt{P - Q\\mathrm{e}^{-kt}}\\), where \\(P\\) and \\(Q\\) are constants. \\([6]\\)", "correct_answer": "P=100, Q=99", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "P", "label": "P", "correct_answer": "100", "answer_type": "exact", "tolerance": null },
      { "key": "Q", "label": "Q", "correct_answer": "99", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "c", "prompt_latex": "Sketch the graph of \\(r\\) against \\(t\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'b0250009-0000-0000-0000-000000000000';

-- P1 Q10 (b025000a) — (c) total in terms of d.  FLAG (b): month/year + explain text → null.  FLAG (c): expression.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Show that the total amount in the account at the end of December 2026 is \\$87\\,706.74 (to 2 d.p.). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find the month and year in which the total first exceeds \\$150\\,000, and explain whether this occurs on the first or last day of the month. \\([6]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "In a different account with no interest, he deposits \\$6000 on 1 January 2026 and \\$\\(d\\) more than the previous month on the first day of each subsequent month. Find, in terms of \\(d\\), the total at the end of December 2026. \\([2]\\)", "correct_answer": "72000+66d", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Hence find the minimum value of \\(d\\) so that he can buy the car by the end of December 2026, to the nearest integer. \\([2]\\)", "correct_answer": "1182", "answer_type": "range", "tolerance": 0.5 }
]$$::jsonb WHERE id = 'b025000a-0000-0000-0000-000000000000';

-- P1 Q11 (b025000b) — (ai) multi-box A,B; (aii) integral; (bii) exact area.  FLAG (aii),(bii): expressions brittle.
UPDATE questions SET parts = $$[
  { "label": "ai", "prompt_latex": "Show that \\(\\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\) can be expressed as \\(\\dfrac{A}{x+1} + \\dfrac{B}{3x^2+x+1}\\), where \\(A\\) and \\(B\\) are constants to be determined. \\([2]\\)", "correct_answer": "A=1, B=-1", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "A", "label": "A", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "B", "label": "B", "correct_answer": "-1", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "aii", "prompt_latex": "Hence find \\(\\displaystyle\\int \\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\,\\mathrm{d}x\\). \\([4]\\)", "correct_answer": "\\ln|x+1|-\\frac{2}{\\sqrt{11}}\\tan^{-1}\\frac{6x+1}{\\sqrt{11}}+C", "answer_type": "exact", "tolerance": null },
  { "label": "bi", "prompt_latex": "The region \\(R\\) is bounded by the curve \\(y = \\dfrac{3x^2}{(x+1)(3x^2+x+1)}\\), the line \\(x = 4\\) and the \\(x\\)-axis. Sketch the graph for \\(x \\geq 0\\), giving intercepts and asymptotes, and shade \\(R\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "bii", "prompt_latex": "Find the exact area of \\(R\\). \\([3]\\)", "correct_answer": "\\ln5+\\frac{2}{\\sqrt{11}}\\left(\\tan^{-1}\\frac{1}{\\sqrt{11}}-\\tan^{-1}\\frac{25}{\\sqrt{11}}\\right)", "answer_type": "exact", "tolerance": null },
  { "label": "biii", "prompt_latex": "Find the volume of the solid generated when \\(R\\) is rotated through \\(2\\pi\\) radians about the \\(x\\)-axis. \\([2]\\)", "correct_answer": "0.715", "answer_type": "range", "tolerance": 0.0005 }
]$$::jsonb WHERE id = 'b025000b-0000-0000-0000-000000000000';

-- P2 Q2 (b0251002) — (b) multi-box rule/domain/range; (d) inverse.  FLAG both: function/set forms brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Sketch \\(y = \\mathrm{f}(x)\\), stating asymptotes, axial intercepts and turning points if any. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Show that \\(\\mathrm{gf}\\) exists. Hence find the rule, domain and range of \\(\\mathrm{gf}\\). \\([4]\\)", "correct_answer": "rule ln(1+(x-4)^2/4), domain R\\{4}, range (0,inf)", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "rule", "label": "\\text{rule}", "correct_answer": "\\ln(1+\\frac{(x-4)^2}{4})", "answer_type": "exact", "tolerance": null },
      { "key": "domain", "label": "\\text{domain}", "correct_answer": "\\mathbb{R}\\setminus\\{4\\}", "answer_type": "exact", "tolerance": null },
      { "key": "range", "label": "\\text{range}", "correct_answer": "(0,\\infty)", "answer_type": "exact", "tolerance": null }
    ] },
  { "label": "c", "prompt_latex": "If the domain of \\(\\mathrm{f}\\) is further restricted to \\(x < k\\), state the largest value of \\(k\\) for which \\(\\mathrm{f}^{-1}\\) exists. \\([1]\\)", "correct_answer": "4", "answer_type": "exact", "tolerance": null },
  { "label": "d", "prompt_latex": "Using the restricted domain found in part (c), find \\(\\mathrm{f}^{-1}\\) in a similar form. \\([3]\\)", "correct_answer": "4-\\frac{2}{\\sqrt{x}}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0251002-0000-0000-0000-000000000000';

-- P2 Q4 (b0251004) — (d) area (type prose not graded).
-- FLAG (a): "state reason" prose → null.  FLAG (c): roots+Argand (order-sensitive/diagram) → null.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Based on the above information only, a student claims that the equation has a root \\(3 - \\mathrm{i}\\). State, with a reason, why the student's claim may not be true. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Show that \\(p = 10\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "For the rest of this question, do not use a calculator. Find the roots of \\(2z^4 - 14z^3 + 33z^2 - 26z + 10 = 0\\) and mark them clearly on a single labelled Argand diagram. \\([7]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "The points in part (c) form the vertices of a quadrilateral. Identify the type of quadrilateral and determine its area. \\([2]\\)", "correct_answer": "\\frac{15}{4}", "answer_type": "exact", "tolerance": null }
]$$::jsonb WHERE id = 'b0251004-0000-0000-0000-000000000000';

-- P2 Q6 (b0251006) — (b) multi-box y, greatest, least.  FLAG: relationship form brittle.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Complete a Venn diagram representing all the above information, giving expressions in terms of \\(x\\) and \\(y\\). \\([3]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "It is further given that \\(B\\) and \\(C\\) are independent. Find \\(y\\) in terms of \\(x\\). Hence find the greatest and least possible values of \\(y\\). \\([4]\\)", "correct_answer": "y=12-x, greatest=12, least=2", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "y", "label": "y", "correct_answer": "12-x", "answer_type": "exact", "tolerance": null },
      { "key": "greatest", "label": "\\text{greatest}", "correct_answer": "12", "answer_type": "exact", "tolerance": null },
      { "key": "least", "label": "\\text{least}", "correct_answer": "2", "answer_type": "exact", "tolerance": null }
    ] }
]$$::jsonb WHERE id = 'b0251006-0000-0000-0000-000000000000';

-- P2 Q8 (b0251008) — (aii) range of p.  FLAG (aii): range brittle.  FLAG (ai): assumptions prose → null.
UPDATE questions SET parts = $$[
  { "label": "ai", "prompt_latex": "State, in context, two assumptions needed for \\(X\\) to be well-modelled by a binomial distribution. \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "aii", "prompt_latex": "Given that the most probable number of pralines exceeding the content is 2, find the exact range of values \\(p\\) can take. \\([3]\\)", "correct_answer": "\\frac{2}{17}<p<\\frac{3}{17}", "answer_type": "exact", "tolerance": null },
  { "label": "bi", "prompt_latex": "A batch is accepted if a first sample box has at most 1 such praline; rejected if 3 or more; if exactly 2, a second box is tested and the batch accepted only if that box has at most 1. With \\(p = 0.15\\), find the probability that the batch is accepted. \\([2]\\)", "correct_answer": "0.363", "answer_type": "range", "tolerance": 0.0005 },
  { "label": "bii", "prompt_latex": "Given that the batch is accepted, find the probability that a second box of pralines is tested. \\([2]\\)", "correct_answer": "0.217", "answer_type": "range", "tolerance": 0.0005 }
]$$::jsonb WHERE id = 'b0251008-0000-0000-0000-000000000000';

-- P2 Q9 (b0251009) — (c) multi-box k,c; (d) estimate.  FLAG (c): model explanation not graded.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Given that the regression line of \\(s\\) on \\(h\\) is \\(s = -3.00799h + 100.27974\\), show that \\(\\alpha = 67.0\\). \\([2]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Draw a scatter diagram for the data. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "Explain why \\(s = kh^2 + c\\) is the better model compared with a linear model, giving appropriate reasons, and state the values of \\(k\\) and \\(c\\). \\([3]\\)", "correct_answer": "k=-0.0873, c=77.7", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "k", "label": "k", "correct_answer": "-0.0873", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "c", "label": "c", "correct_answer": "77.7", "answer_type": "range", "tolerance": 0.05 }
    ] },
  { "label": "d", "prompt_latex": "Using the better model, estimate the score for a student who spends 7 hours of screen-time a week, and comment on the reliability of the estimate. \\([2]\\)", "correct_answer": "73.4", "answer_type": "range", "tolerance": 0.05 },
  { "label": "e", "prompt_latex": "The teacher concludes that increased screen-time will cause exam scores to decrease. Comment on the validity of this statement. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'b0251009-0000-0000-0000-000000000000';

-- P2 Q11 (b025100b) — (b) multi-box mean & variance.
UPDATE questions SET parts = $$[
  { "label": "a", "prompt_latex": "Explain why the coach can carry out a hypothesis test without any assumption about the distribution of the time taken to score the first goal. \\([1]\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "Find unbiased estimates of the population mean and variance, giving your answers to 3 decimal places. \\([2]\\)", "correct_answer": "mean=47.143, variance=257.353", "answer_type": "exact", "tolerance": null,
    "answers": [
      { "key": "mean", "label": "\\text{mean}", "correct_answer": "47.143", "answer_type": "range", "tolerance": 0.005 },
      { "key": "var", "label": "\\text{variance}", "correct_answer": "257.353", "answer_type": "range", "tolerance": 0.05 }
    ] },
  { "label": "c", "prompt_latex": "Carry out the test at the 10% level of significance, stating your hypotheses and defining any symbols you use. \\([4]\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb WHERE id = 'b025100b-0000-0000-0000-000000000000';

-- ════════════════════════════════════════════════════════════════════════════
-- RI H2 Math Prelim 2025 — Paper 1 & Paper 2
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q3 (e0250003) — (c) area (cross product not separately graded — FLAG).
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Find the exact value of \\(p\\). \\([2]\\)","correct_answer":"\\frac{2\\sqrt{5}}{5}","answer_type":"exact","tolerance":null},
  {"label":"b","prompt_latex":"Evaluate \\((\\mathbf{a}+2\\mathbf{b})\\cdot(\\mathbf{a}-2\\mathbf{b})\\). \\([1]\\)","correct_answer":"0","answer_type":"exact","tolerance":null},
  {"label":"c","prompt_latex":"Evaluate \\(\\mathbf{a}\\times\\mathbf{b}\\) and hence find the area of triangle \\(OAC\\). \\([3]\\)","correct_answer":"\\frac{4\\sqrt{145}}{5}","answer_type":"exact","tolerance":null},
  {"label":"d","prompt_latex":"Use a geometrical reason to explain why \\(|\\mathbf{a}\\times\\mathbf{b}| = \\dfrac{1}{4}(|\\mathbf{a}+2\\mathbf{b}|)(|\\mathbf{a}-2\\mathbf{b}|)\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
]$$::jsonb WHERE id = 'e0250003-0000-0000-0000-000000000000';

-- P1 Q4 (e0250004) — all four parts are find/differentiate.  FLAG (a),(biii): indefinite integral +c brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Find \\(\\displaystyle\\int \\frac{9x}{(2x-1)(x+1)^2}\\,dx\\). \\([4]\\)","correct_answer":"\\ln\\left|\\frac{2x-1}{x+1}\\right|-\\frac{3}{x+1}+c","answer_type":"exact","tolerance":null},
  {"label":"bi","prompt_latex":"Differentiate \\(\\dfrac{1}{x^2+1}\\) with respect to \\(x\\). \\([1]\\)","correct_answer":"\\frac{-2x}{(x^2+1)^2}","answer_type":"exact","tolerance":null},
  {"label":"bii","prompt_latex":"Differentiate \\(\\ln\\sqrt{x^2+1}\\) with respect to \\(x\\). \\([1]\\)","correct_answer":"\\frac{x}{x^2+1}","answer_type":"exact","tolerance":null},
  {"label":"biii","prompt_latex":"Hence find \\(\\displaystyle\\int \\frac{x\\ln\\sqrt{x^2+1}}{(x^2+1)^2}\\,dx\\). \\([4]\\)","correct_answer":"-\\frac{\\ln(x^2+1)+1}{4(x^2+1)}+c","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0250004-0000-0000-0000-000000000000';

-- P1 Q6 (e0250006) — (bi) multi-box n,a,d.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"A geometric series has first term 2 and common ratio 0.8. Find algebraically the least value of \\(m\\) for the sum of the first \\(4m\\) terms to be greater than 99% of the sum to infinity. \\([3]\\)","correct_answer":"\\frac{21}{4}","answer_type":"exact","tolerance":null},
  {"label":"bi","prompt_latex":"A finite AP \\(A\\) has \\(n\\) terms, first term \\(a\\) and common difference \\(d\\). In progression \\(B\\), the \\(k\\)th term is obtained by adding the \\(k\\)th positive odd integer to the \\(k\\)th term of \\(A\\). Given that the 12th term of \\(A\\) is 25, the sum of all terms of \\(A\\) is 676, and the sum of all terms of \\(B\\) is twice the sum of all terms of \\(A\\), find the values of \\(n\\), \\(a\\) and \\(d\\). \\([4]\\)","correct_answer":"n=26, a=53/3, d=2/3","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"n","label":"n","correct_answer":"26","answer_type":"exact","tolerance":null},
      {"key":"a","label":"a","correct_answer":"\\frac{53}{3}","answer_type":"exact","tolerance":null},
      {"key":"d","label":"d","correct_answer":"\\frac{2}{3}","answer_type":"exact","tolerance":null}
    ]},
  {"label":"bii","prompt_latex":"Obtain the sum of the first ten terms of \\(B\\). \\([2]\\)","correct_answer":"\\frac{920}{3}","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0250006-0000-0000-0000-000000000000';

-- P1 Q7 (e0250007) — (a) multi-box rule + domain.  FLAG: function/domain forms brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Find \\(\\mathrm{f}^{-1}(x)\\) and state its domain. \\([3]\\)","correct_answer":"rule ln(2+3/(x-1)), domain x>1","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"rule","label":"\\mathrm{f}^{-1}(x)","correct_answer":"\\ln(2+\\frac{3}{x-1})","answer_type":"exact","tolerance":null},
      {"key":"domain","label":"\\text{domain}","correct_answer":"x>1","answer_type":"exact","tolerance":null}
    ]},
  {"label":"b","prompt_latex":"Sketch the graph of \\(y = \\mathrm{g}(x)\\) and explain why the composite function \\(\\mathrm{f}^{-1}\\mathrm{g}\\) exists. \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"c","prompt_latex":"Hence find the exact value of \\(k\\) such that \\(\\mathrm{f}^{-1}\\mathrm{g}(k) = \\ln\\dfrac{5}{2}\\). \\([3]\\)","correct_answer":"1-\\frac{\\sqrt{10}}{2}","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0250007-0000-0000-0000-000000000000';

-- P1 Q8 (e0250008) — (biii) multi-box x, m, B.  FLAG: complex number B brittle.
UPDATE questions SET parts = $$[
  {"label":"ai","prompt_latex":"The point \\(P\\) represents \\(w=u+iv\\) with \\(u,v>0\\). Explain algebraically why \\(\\arg(kw)=\\arg(w)\\) for any real constant \\(k>1\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"aii","prompt_latex":"Points \\(Q\\) and \\(R\\) represent \\(kw\\) and \\(ikw\\) (\\(k>1\\)). Plot \\(Q\\) and \\(R\\) on an Argand diagram and show the geometrical relationship between \\(P\\), \\(Q\\) and \\(R\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"bi","prompt_latex":"Points \\(A\\), \\(B\\), \\(C\\) represent \\(z\\), \\(\\mathrm{f}(z)\\), \\(\\mathrm{f}(\\mathrm{f}(z))\\) where \\(\\mathrm{f}(z)=z^2-2z\\). Show that \\(\\mathrm{f}(\\mathrm{f}(z))-\\mathrm{f}(z)=z(z-2)(z-3)(z+1)\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"bii","prompt_latex":"\\(ABC\\) is a right-angled triangle (anticlockwise, right angle at \\(B\\), \\(BC=mBA\\) with \\(m>0\\)). By considering \\(\\dfrac{\\mathrm{f}(\\mathrm{f}(z))-\\mathrm{f}(z)}{\\mathrm{f}(z)-z}\\), show that \\((z-2)(z+1)=m\\mathrm{i}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"biii","prompt_latex":"In the case \\(z=x+2\\mathrm{i}\\) with \\(x>0\\), find \\(x\\) and \\(m\\). Hence obtain the complex number represented by \\(B\\). \\([5]\\)","correct_answer":"x=3, m=10, B=-1+8i","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"x","label":"x","correct_answer":"3","answer_type":"exact","tolerance":null},
      {"key":"m","label":"m","correct_answer":"10","answer_type":"exact","tolerance":null},
      {"key":"B","label":"B","correct_answer":"-1+8\\mathrm{i}","answer_type":"exact","tolerance":null}
    ]}
]$$::jsonb WHERE id = 'e0250008-0000-0000-0000-000000000000';

-- P1 Q10 (e0250010) — (ci) y=f(x) form.  FLAG (ci): ± form brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Using the substitution \\(u=\\sqrt{2x-1}\\), show that \\(\\displaystyle\\int\\frac{x}{\\sqrt{2x-1}}\\,dx=\\int\\frac{u^2+1}{2}\\,du\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"bi","prompt_latex":"The diagram shows \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\). Indicate the asymptote, the turning point, and the \\(x\\)-intercepts. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"bii","prompt_latex":"Region \\(R\\) is bounded by the curve \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\) and the lines \\(x=1\\), \\(x=3\\), \\(y=\\dfrac{1}{2}\\). Find the exact area of \\(R\\). \\([5]\\)","correct_answer":"\\frac{11-4\\sqrt{5}}{3}","answer_type":"exact","tolerance":null},
  {"label":"ci","prompt_latex":"Express \\(x=2(y-1)^2+1\\) in the form \\(y=\\mathrm{f}(x)\\). \\([1]\\)","correct_answer":"1\\pm\\sqrt{\\frac{x-1}{2}}","answer_type":"exact","tolerance":null},
  {"label":"cii","prompt_latex":"On the same diagram as (b)(i), sketch the graph of \\(x=2(y-1)^2+1\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"ciii","prompt_latex":"Region \\(S\\) is bounded by the curves \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\), \\(x=2(y-1)^2+1\\), the lines \\(x=1\\), \\(x=4\\) and the \\(x\\)-axis. Find the volume generated when \\(S\\) is rotated through \\(2\\pi\\) radians about the \\(x\\)-axis, correct to 3 decimal places. \\([3]\\)","correct_answer":"4.518","answer_type":"range","tolerance":0.001}
]$$::jsonb WHERE id = 'e0250010-0000-0000-0000-000000000000';

-- P1 Q11 (e0250011) — (c) equation relating p and s.  FLAG: equation form brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Using \\(\\sin A+\\sin B=2\\sin\\frac{A+B}{2}\\cos\\frac{A-B}{2}\\) and \\(\\cos A-\\cos B=-2\\sin\\frac{A+B}{2}\\sin\\frac{A-B}{2}\\), show that the gradient of \\(M_p\\) is \\(-\\tan\\dfrac{p}{2}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"For \\(p=\\dfrac{\\pi}{3}\\), \\(M_p\\) and \\(N_p\\) cut the \\(x\\)-axis at \\(Q\\) and \\(R\\) respectively. Find the area of \\(\\triangle PQR\\). \\([4]\\)","correct_answer":"\\frac{\\sqrt{3}}{2}","answer_type":"exact","tolerance":null},
  {"label":"c","prompt_latex":"Point \\(S\\) has parameter \\(s\\) on \\(C\\) and \\(N_s\\) is its normal. Given \\(p\\neq\\dfrac{\\pi}{3},\\pi\\) and \\(p<s\\), and that \\(M_p\\parallel N_s\\), use \\(\\tan(A-B)=\\dfrac{\\tan A-\\tan B}{1+\\tan A\\tan B}\\) to find an equation relating \\(p\\) and \\(s\\). \\([2]\\)","correct_answer":"s-p=\\pi","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0250011-0000-0000-0000-000000000000';

-- P2 Q1 (e0251001) — (a),(bii) solve inequalities.  FLAG: disjoint-interval forms brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Without using a calculator, solve the inequality \\(\\dfrac{x^2-5x+6}{x^2-4} < \\dfrac{2x-3}{x+2}\\). \\([4]\\)","correct_answer":"x<-2\\text{ or }0<x<2\\text{ or }x>2","answer_type":"exact","tolerance":null},
  {"label":"bi","prompt_latex":"Sketch on the same diagram the graphs of \\(y = \\ln x\\) and \\(y = x-5\\), giving the equations of any asymptotes and the \\(x\\)-coordinates of the points of intersection between the two graphs. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"bii","prompt_latex":"Hence solve the inequality \\(\\ln|x| < |x|-5\\). \\([2]\\)","correct_answer":"x<-6.94\\text{ or }-0.00678<x<0\\text{ or }0<x<0.00678\\text{ or }x>6.94","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251001-0000-0000-0000-000000000000';

-- P2 Q2 (e0251002) — (aii) multi-box a,b,c; (b) Maclaurin series.  FLAG (b): series brittle.
UPDATE questions SET parts = $$[
  {"label":"ai","prompt_latex":"Show that \\(AC = \\dfrac{2}{\\cos x + \\sqrt{3}\\sin x}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"aii","prompt_latex":"Given that \\(x\\) is a sufficiently small angle, show that \\(AC \\approx a + bx + cx^2\\), where \\(a\\), \\(b\\) and \\(c\\) are constants to be determined. \\([3]\\)","correct_answer":"a=2, b=-2sqrt3, c=7","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"a","label":"a","correct_answer":"2","answer_type":"exact","tolerance":null},
      {"key":"b","label":"b","correct_answer":"-2\\sqrt{3}","answer_type":"exact","tolerance":null},
      {"key":"c","label":"c","correct_answer":"7","answer_type":"exact","tolerance":null}
    ]},
  {"label":"b","prompt_latex":"It is given that \\(2xy + \\ln y = \\ln 3\\). Show that \\((2xy^2 + y)\\dfrac{\\mathrm{d}^2 y}{\\mathrm{d}x^2} + 4y^2\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} - \\left(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right)^2 = 0\\). Hence find the Maclaurin series for \\(y\\), up to and including the term in \\(x^2\\). \\([5]\\)","correct_answer":"3-18x+162x^2","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251002-0000-0000-0000-000000000000';

-- P2 Q3 (e0251003) — (b) multi-box k values; (c) multi-box range,L; (d) range of b.  FLAG (c),(d): set/expr brittle.
UPDATE questions SET parts = $$[
  {"label":"ai","prompt_latex":"For \\(k=3\\), describe the behaviour of the sequence \\(U\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"aii","prompt_latex":"For \\(k=10\\), describe the behaviour of the sequence \\(U\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"Find the possible value(s) of \\(k\\) if the sequence \\(U\\) is a constant sequence. \\([2]\\)","correct_answer":"k=2 or 7","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"k1","label":"k_1","correct_answer":"2","answer_type":"exact","tolerance":null},
      {"key":"k2","label":"k_2","correct_answer":"7","answer_type":"exact","tolerance":null}
    ]},
  {"label":"c","prompt_latex":"For some values of \\(a\\), \\(v_n \\to L\\) as \\(n \\to \\infty\\). Find, with justification, the range of values of \\(a\\) for \\(L\\) to exist, and state the value of \\(L\\) in terms of \\(a\\) and \\(b\\). \\([3]\\)","correct_answer":"range (-1,0)U(0,1), L=b/a","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"range","label":"\\text{range of }a","correct_answer":"(-1,0)\\cup(0,1)","answer_type":"exact","tolerance":null},
      {"key":"L","label":"L","correct_answer":"\\frac{b}{a}","answer_type":"exact","tolerance":null}
    ]},
  {"label":"d","prompt_latex":"For \\(k=10\\), by using parts (a)(ii) and (c), find the range of values of \\(b\\) for the sequence \\(W\\) to converge. Hence explain whether \\(\\displaystyle\\sum_{r=1}^{\\infty} w_r\\) is a convergent series. \\([3]\\)","correct_answer":"(-7,0)\\cup(0,7)","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251003-0000-0000-0000-000000000000';

-- P2 Q4 (e0251004) — (b) eqn relating m,n; (e) plane eqn.  FLAG (e): equation brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Show that \\(p\\) has equation \\(\\mathbf{r}\\cdot\\begin{pmatrix}2\\\\3\\\\1\\end{pmatrix}=-1\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"Find an equation relating \\(m\\) and \\(n\\). \\([1]\\)","correct_answer":"3m+n=-2","answer_type":"exact","tolerance":null},
  {"label":"c","prompt_latex":"By considering the line segment \\(BC\\), show that Griffles is able to successfully navigate the obstacle without colliding into it. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"d","prompt_latex":"Show that Griffles does not activate the sensor. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"e","prompt_latex":"Find the cartesian equation of plane \\(q\\), which is parallel to \\(p\\) such that \\(E\\) is equidistant from \\(p\\) and \\(q\\). \\([3]\\)","correct_answer":"2x+3y+z=35","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251004-0000-0000-0000-000000000000';

-- P2 Q5 (e0251005) — (b) multi-box E(X), Var(X).
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Show that \\(k = \\dfrac{1}{70}\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"Find the exact values of \\(\\mathrm{E}(X)\\) and \\(\\mathrm{Var}(X)\\). \\([3]\\)","correct_answer":"E(X)=4, Var(X)=6/5","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"E","label":"\\mathrm{E}(X)","correct_answer":"4","answer_type":"exact","tolerance":null},
      {"key":"Var","label":"\\operatorname{Var}(X)","correct_answer":"\\frac{6}{5}","answer_type":"exact","tolerance":null}
    ]},
  {"label":"c","prompt_latex":"Two independent observations \\(X_1\\) and \\(X_2\\) are taken of \\(X\\). Find the probability that the difference between the two observations is at least 3. \\([3]\\)","correct_answer":"\\frac{4}{35}","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251005-0000-0000-0000-000000000000';

-- P2 Q7 (e0251007) — (a) range of sigma.  FLAG: range brittle.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"If the probability of the mass of a randomly chosen packet of Rays not exceeding \\((100-\\sigma^2)\\) grams is less than 0.2, find the possible range of values of \\(\\sigma\\). \\([2]\\)","correct_answer":"\\sigma>0.842","answer_type":"exact","tolerance":null},
  {"label":"b","prompt_latex":"Given \\(\\sigma=3\\), find the probability that the total mass of 2 randomly chosen regular packets of Rays and 3 randomly chosen packets of Luffles is greater than 0.55 kg. \\([3]\\)","correct_answer":"0.891","answer_type":"range","tolerance":0.001},
  {"label":"c","prompt_latex":"Given \\(\\sigma=3\\), the Mega Jumbo Pack consists of \\((24-n)\\) regular packets of Rays and \\(n\\) regular packets of Luffles. The probability of the mass of a Mega Jumbo Pack exceeding 20 times the mass of a regular packet of Luffles by more than 500 g is at least 0.1. Find the minimum value of \\(n\\). \\([4]\\)","correct_answer":"20","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251007-0000-0000-0000-000000000000';

-- P2 Q8 (e0251008) — (c) multi-box r,a,b; (d) estimate.  FLAG (c): model context not graded.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"On the grid provided, draw a scatter diagram of the data. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"Indicate the wrongly-stated point by labelling it \\(P\\) on your diagram. Explain why the scatter diagram for the remaining points may be consistent with a model of the form \\(y = a + \\dfrac{b}{x}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"c","prompt_latex":"Omitting \\(P\\), calculate the product moment correlation coefficient and the least squares estimates of \\(a\\) and \\(b\\) for the model \\(y = a + \\dfrac{b}{x}\\). \\([2]\\)","correct_answer":"r=0.997, a=-101, b=757","answer_type":"exact","tolerance":null,
    "answers":[
      {"key":"r","label":"r","correct_answer":"0.997","answer_type":"range","tolerance":0.0005},
      {"key":"a","label":"a","correct_answer":"-101","answer_type":"range","tolerance":0.5},
      {"key":"b","label":"b","correct_answer":"757","answer_type":"range","tolerance":0.5}
    ]},
  {"label":"d","prompt_latex":"Use the model \\(y = a + \\dfrac{b}{x}\\) with your values of \\(a\\) and \\(b\\) to estimate the wrongly-stated value of \\(y\\). Give two reasons why this estimate is reliable. \\([3]\\)","correct_answer":"71.2","answer_type":"range","tolerance":0.1}
]$$::jsonb WHERE id = 'e0251008-0000-0000-0000-000000000000';

-- P2 Q9 (e0251009) — (c) range of n.  FLAG (c): range brittle.  (a),(b) hypotheses/critical region prose → null.
UPDATE questions SET parts = $$[
  {"label":"a","prompt_latex":"Write down the null and alternative hypotheses for this test, defining any symbols you use. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"b","prompt_latex":"Stating a necessary assumption, find the critical region for this test. Hence state the conclusion of the test in context. \\([6]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
  {"label":"c","prompt_latex":"The PE department also tests at the 3% significance level whether the mean time for female GJC students is less than 14.5 minutes. A large random sample of \\(n\\) females has sample mean 14.2 minutes and sample standard deviation 1.5 minutes. Given that the department concludes the mean time is less than 14.5 minutes, find the range of values of \\(n\\). \\([5]\\)","correct_answer":"n\\ge90","answer_type":"exact","tolerance":null}
]$$::jsonb WHERE id = 'e0251009-0000-0000-0000-000000000000';
