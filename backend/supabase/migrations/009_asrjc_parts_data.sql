-- Migration 009: Populate parts JSONB for ASRJC multi-part questions
-- Splits each question's prompt_latex into preamble + per-part breakdown.
-- cafe0001 (P1Q1), cafe0004 (P1Q5a), cafe1001 (P2Q1) stay as single-answer.
-- All backslashes are doubled inside JSON strings (JSON \\ = one LaTeX \).

-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 1
-- ════════════════════════════════════════════════════════════════════════════

-- P1 Q2 — Definite Integral [cafe0002]
UPDATE questions SET
  prompt_latex = '',
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\cos 3\\theta = 4\\cos^3\\theta - 3\\cos\\theta\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence, or otherwise, evaluate \\(\\displaystyle\\int_0^{\\pi/6} \\sin 2\\theta \\cos 3\\theta \\, d\\theta\\) exactly. \\([4]\\)",
      "correct_answer": "\\frac{3\\sqrt{3}}{10} - \\frac{2}{5}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe0002-0000-0000-0000-000000000000';

-- P1 Q4 — Folium of Descartes [cafe0003]
UPDATE questions SET
  prompt_latex = $$The Folium of Descartes is defined by \(x^3 + y^3 = 3axy\), where \(a \neq 0\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\(\\dfrac{dy}{dx} = \\dfrac{ay - x^2}{y^2 - ax}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The point \\(\\!\\left(\\tfrac{3}{2}a,\\,\\tfrac{3}{2}a\\right)\\) lies on the curve. Show that the equation of the normal at this point is independent of \\(a\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Given that the curve has a stationary point at \\((pa,\\, qa)\\) where \\(p\\) and \\(q\\) are positive constants, find the exact values of \\(p\\) and \\(q\\). \\([4]\\)",
      "correct_answer": "p = 2^{\\frac{1}{3}}, q = 2^{\\frac{2}{3}}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe0003-0000-0000-0000-000000000000';

-- P1 Q7 — Area and volume (circle and line) [cafe0005]
UPDATE questions SET
  prompt_latex = $$Curve \(C\): \(x^2 + y^2 = 4\). Line \(L\): \(3y = x + 2\). Region \(A\) is enclosed between \(C\) and \(L\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Use the substitution \\(x = 2\\sin\\theta\\) to show that the area of region \\(A\\) can be written as \\(\\displaystyle\\int_b^a 4\\cos^2\\theta\\,d\\theta - c\\), stating the exact values of \\(a\\), \\(b\\) and \\(c\\). Hence evaluate the area exactly. \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Region \\(B\\) is bounded by \\(C\\), \\(L\\) and the line \\(x = 2\\). Find the volume generated when region \\(B\\) is rotated through \\(2\\pi\\) radians about the \\(y\\)-axis, giving your answer to 2 decimal places. \\([3]\\)",
      "correct_answer": "8.46",
      "answer_type": "range",
      "tolerance": 0.005
    }
  ]$$::jsonb
WHERE id = 'cafe0005-0000-0000-0000-000000000000';

-- P1 Q8 — AP-GP and sequence proof [cafe0006]
UPDATE questions SET
  prompt_latex = '',
  parts = $$[
    {
      "label": "ai",
      "prompt_latex": "The 9th, 5th and 2nd terms of an arithmetic progression are successive terms of a geometric progression with first term \\(a\\) and common ratio \\(r\\), where \\(r \\neq 1\\) and \\(a > 0\\). Find the value of \\(r\\) and deduce that the geometric series is convergent. \\([3]\\)",
      "correct_answer": "\\frac{3}{4}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Using the value of \\(r\\) found in (a)(i), find the least value of \\(n\\) such that the sum of all terms after the \\(n\\)th term of the geometric progression is less than 1\\% of its sum of the first \\(n\\) terms. \\([3]\\)",
      "correct_answer": "17",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "The sum of the first \\(n\\) terms of a sequence is \\(S_n = nq\\ln^2(n+1)\\), where \\(q\\) is a constant. Prove that the sequence is an arithmetic progression. \\([4]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe0006-0000-0000-0000-000000000000';

-- P1 Q9 — Line and plane [cafe0007]
UPDATE questions SET
  prompt_latex = $$Line \(\ell\): \(\dfrac{x-2}{a} = y-2 = \dfrac{1-2z}{b}\). Plane \(\pi\): \(3x - y + 4z = 10\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Given that \\(\\ell\\) and \\(\\pi\\) do not intersect, show that \\(a \\neq \\frac{10}{3}\\) and \\(b = \\frac{5}{2}\\). \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Given \\(a = 1\\), \\(b = 3\\), find the point of intersection of \\(\\ell\\) and \\(\\pi\\). \\([3]\\)",
      "correct_answer": "(-13, -5, 11)",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "ci",
      "prompt_latex": "Given \\(a = 1\\), \\(b = \\frac{5}{2}\\), find the distance between \\(\\ell\\) and \\(\\pi\\). \\([2]\\)",
      "correct_answer": "\\frac{7}{\\sqrt{26}}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "cii",
      "prompt_latex": "Determine whether \\(\\ell\\) and the origin lie on the same side of \\(\\pi\\). State the equation of the plane equidistant from \\(\\ell\\) and parallel to \\(\\pi\\). \\([3]\\)",
      "correct_answer": "3x - y + 4z = -4",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe0007-0000-0000-0000-000000000000';

-- P1 Q10 — Functions and inverse [cafe0008]
UPDATE questions SET
  prompt_latex = $$The function \(f\) is defined by \(f: x \mapsto 2x - \dfrac{1}{2x}\), \(0 < x < 2\). It is given that \(f^{-1}\) exists.$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Define \\(f^{-1}\\) in a similar form, stating its domain. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch the graphs of \\(y = f(x)\\) and \\(y = f^{-1}(x)\\) on the same diagram. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "The region \\(R\\) is bounded by \\(y = f^{-1}(x)\\), \\(y = x\\) and the \\(y\\)-axis. Find the exact area of \\(R\\). \\([3]\\)",
      "correct_answer": "\\frac{\\ln 2}{4}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Another function \\(g\\) is defined by \\(g: x \\mapsto \\begin{cases} \\frac{3}{2} + 3x^3 - 11 & x \\leq 3 \\\\ \\frac{x-1}{3x^2} & 3 < x \\leq 5 \\end{cases}\\). Show that \\(gf\\) exists and find the range of \\(gf\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe0008-0000-0000-0000-000000000000';

-- P1 Q11 — Differential equations [cafe0009]
UPDATE questions SET
  prompt_latex = $$Compounds X and Y react to form a product. Let \(x\) and \(y\) be concentrations (mol/kL) at time \(t\) minutes.$$,
  parts = $$[
    {
      "label": "ai",
      "prompt_latex": "In a pseudo-first-order reaction: \\(\\dfrac{dx}{dt} = -ax\\). Solve for \\(x\\) in terms of \\(t\\), \\(x_0\\) and \\(a\\). \\([3]\\)",
      "correct_answer": "x_0 e^{-at}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Show that the half-life \\(t_{0.5} = \\dfrac{\\ln 2}{a}\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "In another experiment the rate is \\(\\dfrac{dx}{dt} = -kxy^2\\). Every 1 mol of X reacts with 2 mol of Y, and \\(y - y_0 = 2(x - x_0)\\). Initial concentrations: \\(x_0 = 1\\) mol/kL, \\(y_0 = 4\\) mol/kL. Show that \\(\\dfrac{dx}{dt} = -bx(x+1)^2\\) for some positive constant \\(b\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Given \\(x = 0.5\\) mol/kL at \\(t = 1\\) min, find the concentration of X at \\(t = 2\\) min, to 3 significant figures. \\([6]\\)",
      "correct_answer": "0.314",
      "answer_type": "range",
      "tolerance": 0.0005
    }
  ]$$::jsonb
WHERE id = 'cafe0009-0000-0000-0000-000000000000';


-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2 — Section A: Pure Mathematics
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q2 — Inequalities [cafe1002]
UPDATE questions SET
  prompt_latex = '',
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Without a graphing calculator, solve \\(\\dfrac{x^2 + 2}{x + 1} \\geq \\dfrac{x + 4}{2}\\). \\([3]\\)",
      "correct_answer": "x \\leq -3 \\text{ or } -1 < x \\leq 2",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Hence solve \\(1 + \\dfrac{e^x + 3}{e^x + 1} \\geq \\dfrac{e^x + 2}{2} + 2\\). \\([2]\\)",
      "correct_answer": "x \\leq \\ln 2",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1002-0000-0000-0000-000000000000';

-- P2 Q3 — Maclaurin series [cafe1003]
UPDATE questions SET
  prompt_latex = $$Given that \(y = \tan^{-1}\!\left(\dfrac{x}{5}\right)\):$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Show that \\((25 + x^2)\\dfrac{d^2y}{dx^2} + 2x\\dfrac{dy}{dx} = 0\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "By further differentiation, find the Maclaurin series of \\(y\\) up to and including the term in \\(x^3\\). \\([3]\\)",
      "correct_answer": "\\frac{x}{5} - \\frac{x^3}{375}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1003-0000-0000-0000-000000000000';

-- P2 Q4 — Parametric curves and ellipse [cafe1004]
UPDATE questions SET
  prompt_latex = $$Curve \(C\): \(x = \cos t + \frac{1}{2}\cos 5t\), \(y = \sin t + \frac{1}{2}\sin 5t\), \(0 \leq t \leq \frac{\pi}{2}\).
Curve \(D\): \(x = 2 + k\cos\theta\), \(y = \frac{3}{2}\sin\theta\), \(0 \leq \theta \leq 2\pi\), \(k > 0\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Find the coordinates of the point on \\(C\\) when \\(t = 0\\). \\([1]\\)",
      "correct_answer": "\\left(\\frac{3}{2}, 0\\right)",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the Cartesian equation of \\(D\\). \\([2]\\)",
      "correct_answer": "\\frac{(x-2)^2}{k^2} + \\frac{4y^2}{9} = 1",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Sketch \\(C\\) and \\(D\\) on the same diagram. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Hence determine the range of values of \\(k\\) such that \\[\\frac{(\\cos t + \\tfrac{1}{2}\\cos 5t - 2)^2}{k^2} + \\frac{4(\\sin t + \\tfrac{1}{2}\\sin 5t)^2}{9} = 1\\] has no real solutions. \\([1]\\)",
      "correct_answer": "0 < k < \\frac{1}{4}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1004-0000-0000-0000-000000000000';

-- P2 Q5 — Integration techniques [cafe1005]
UPDATE questions SET
  prompt_latex = '',
  parts = $$[
    {
      "label": "ai",
      "prompt_latex": "Find \\(\\displaystyle\\int \\frac{1 - 2x}{3 + 2x - x^2}\\,dx\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Find \\(\\displaystyle\\int x\\ln(2-x^2)\\,dx\\), where \\(-\\sqrt{2} < x < \\sqrt{2}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "A function \\(f\\) is defined by \\(f(x) = |e^x - 2|\\). Sketch the graph of \\(y = f(x)\\), indicating any asymptotes. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Hence find \\(\\displaystyle\\int_0^{\\ln 3} |e^x - 2|\\,dx\\) in exact form. \\([3]\\)",
      "correct_answer": "4\\ln 2 - 2\\ln 3",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1005-0000-0000-0000-000000000000';

-- P2 Q6 — Complex numbers [cafe1006]
UPDATE questions SET
  prompt_latex = $$Points \(P\) and \(Q\) are represented by complex numbers \(p = 2 + 2i\) and \(q\) where \(\arg(q) = \dfrac{2\pi}{3}\) and \(|q| = 2\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Find \\(|p|\\) and \\(\\arg(p)\\) in exact form. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Sketch \\(P\\) and \\(Q\\) on an Argand diagram. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Use the Argand diagram to deduce \\(\\operatorname{Re}(q)\\) and \\(\\operatorname{Im}(q)\\) in exact form. Enter \\(\\operatorname{Im}(q)\\). \\([2]\\)",
      "correct_answer": "\\sqrt{3}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "The point \\(R\\) represents \\(p + q\\). What shape is the quadrilateral \\(OPRQ\\)? \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "By considering \\(\\arg(p + q)\\) or otherwise, show that \\(\\tan\\!\\left(\\dfrac{11\\pi}{24}\\right) = \\sqrt{6} + \\sqrt{3} + \\sqrt{2} + \\sqrt{2}\\). \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1006-0000-0000-0000-000000000000';


-- ════════════════════════════════════════════════════════════════════════════
-- PAPER 2 — Section B: Probability and Statistics
-- ════════════════════════════════════════════════════════════════════════════

-- P2 Q7 — Discrete random variable [cafe1007]
UPDATE questions SET
  prompt_latex = $$Anthony plays a game with a fair four-sided die (faces: 1, 2, 3, 4). If the outcome is prime he wins that many dollars; if non-prime he loses that many dollars. \(X\) = amount won per roll.$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Tabulate the distribution of \\(X\\) and find \\(\\text{E}(X)\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find \\(\\text{Var}(X)\\). \\([1]\\)",
      "correct_answer": "\\frac{15}{2}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Let \\(X_1, X_2\\) be two independent observations of \\(X\\). Find \\(\\text{E}(|X_1 + X_2|)\\). \\([2]\\)",
      "correct_answer": "\\frac{13}{4}",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Now a biased six-sided die (faces: 2, 3, 4, 5, 6, 7) is used. \\(P(3) = p\\), \\(P(5) = 2p\\); the remaining four faces each have equal probability. Find the exact value of \\(p\\) for the game to be fair. \\([3]\\)",
      "correct_answer": "\\frac{1}{55}",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1007-0000-0000-0000-000000000000';

-- P2 Q8 — Linear regression [cafe1008]
UPDATE questions SET
  prompt_latex = $$A study examines exercise hours per week \(t\) and fasting blood sugar \(S\) (mg/dL):
\[\begin{array}{c|cccccccc} t & 1.5 & 1.8 & 2.1 & 2.4 & 2.5 & 3.1 & 3.5 & 4.2 \\ \hline S & 119 & 108 & 100 & 95 & 93 & 88 & 86 & 85 \end{array}\]$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Draw a scatter diagram of \\(S\\) against \\(t\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Comment on whether a linear model is appropriate. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Of the models \\(A: S = a + bt^2\\), \\(B: S = a + b/t\\), \\(C: S = a + b\\ln t\\) (with \\(a, b > 0\\)), which is most appropriate? Explain. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Using model B, find the product moment correlation coefficient between \\(S\\) and \\(1/t\\). \\([1]\\)",
      "correct_answer": "0.988",
      "answer_type": "range",
      "tolerance": 0.0005
    },
    {
      "label": "e",
      "prompt_latex": "Find the regression line of \\(S\\) on \\(1/t\\) and estimate the exercise time (in hours) for \\(S = 99\\) mg/dL. Give your answer to 3 significant figures. \\([3]\\)",
      "correct_answer": "2.23",
      "answer_type": "range",
      "tolerance": 0.01
    }
  ]$$::jsonb
WHERE id = 'cafe1008-0000-0000-0000-000000000000';

-- P2 Q9 — Normal distribution [cafe1009]
UPDATE questions SET
  prompt_latex = $$Cylindrical blocks: \(X \sim N(280, 6^2)\). Cuboidal blocks: \(Y \sim N(220, 5^2)\). All blocks independent.$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "Find \\(P(X - Y > 65)\\). \\([2]\\)",
      "correct_answer": "0.261",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "b",
      "prompt_latex": "Find \\(M\\) such that \\(P(2X + 3Y < M) = 0.355\\). Give \\(M\\) to the nearest integer. \\([2]\\)",
      "correct_answer": "1213",
      "answer_type": "range",
      "tolerance": 1
    },
    {
      "label": "c",
      "prompt_latex": "A deluxe seesaw uses 2 cylindrical blocks (each drilled, losing 5\\% mass), 3 cuboidal blocks (each drilled, losing 3\\% mass), 7 screws \\(S_0 \\sim N(8, 1.2^2)\\), and 1 plank \\(W \\sim N(540, 8^2)\\). Find the probability that the total mass of all components exceeds 1785 g. \\([4]\\)",
      "correct_answer": "0.123",
      "answer_type": "range",
      "tolerance": 0.002
    }
  ]$$::jsonb
WHERE id = 'cafe1009-0000-0000-0000-000000000000';

-- P2 Q10 — Binomial distribution [cafe1010]
UPDATE questions SET
  prompt_latex = $$Solar panels: 2% defect rate, packed in batches of 10. \(S \sim B(10, 0.02)\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "State two assumptions for \\(S\\) to follow a binomial distribution. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find \\(P(S \\geq 2)\\). \\([2]\\)",
      "correct_answer": "0.0162",
      "answer_type": "range",
      "tolerance": 0.0002
    },
    {
      "label": "c",
      "prompt_latex": "100 schools each receive 10 solar panels. A school complains if \\(S \\geq 2\\). Let \\(Y\\) = number of schools that complain. Find \\(P(Y \\leq 5)\\). \\([2]\\)",
      "correct_answer": "0.994",
      "answer_type": "range",
      "tolerance": 0.002
    },
    {
      "label": "d",
      "prompt_latex": "LED lights: 1\\% defect rate, 25 per school, so \\(L \\sim B(25, 0.01)\\). Let \\(A\\) = total defective LEDs from 100 schools, \\(B\\) = total defective panels from 100 schools. The factory is fined if \\(A + B > 50\\). By using a suitable approximation, find \\(P(A + B > 50)\\). \\([5]\\)",
      "correct_answer": "0.226",
      "answer_type": "range",
      "tolerance": 0.002
    }
  ]$$::jsonb
WHERE id = 'cafe1010-0000-0000-0000-000000000000';

-- P2 Q11 — Probability and combinatorics [cafe1011]
UPDATE questions SET
  prompt_latex = '',
  parts = $$[
    {
      "label": "ai",
      "prompt_latex": "A survey of 100 library members gives the following data on visits per week:\n\\[\\begin{array}{l|ccc} & {\\leq 1\\text{ day}} & {2\\text{--}4\\text{ days}} & {\\geq 5\\text{ days}} \\\\ \\hline \\text{Male} & 15 & 25 & 22 \\\\ \\text{Female} & 20 & 18 & n \\end{array}\\]\nLet \\(A\\) = event of visiting \\(\\leq 4\\) days, \\(B\\) = event of visiting \\(\\geq 2\\) days, \\(F\\) = female. Find \\(P(A \\cup B')\\). \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aii",
      "prompt_latex": "Using the survey above, find \\(P(F \\mid A')\\). \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "aiii",
      "prompt_latex": "Given that \\(P(A \\cap B) = \\frac{3}{10}\\), find the value of \\(n\\) and determine whether \\(A\\) and \\(B\\) are independent. \\([3]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "bi",
      "prompt_latex": "A librarian creates 4-letter access codes using letters from BOOKKEEPER. How many codes can be formed if all 4 letters are distinct? \\([1]\\)",
      "correct_answer": "360",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "bii",
      "prompt_latex": "Find the total number of 4-letter codes that can be formed from the letters of BOOKKEEPER with no restriction. \\([3]\\)",
      "correct_answer": "758",
      "answer_type": "exact",
      "tolerance": null
    },
    {
      "label": "biii",
      "prompt_latex": "A team of 12 is chosen from 18 volunteers: 5 youths, 6 young adults, 7 seniors. At least one from each group must be chosen. In how many ways can the team be formed? \\([3]\\)",
      "correct_answer": "18550",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1011-0000-0000-0000-000000000000';

-- P2 Q12 — Hypothesis testing [cafe1012]
UPDATE questions SET
  prompt_latex = $$Flour bags claim to be 1.5 kg. A sample of 40 bags from machine A gives \(\sum x = 60.32\), \(\sum x^2 = 90.993\).$$,
  parts = $$[
    {
      "label": "a",
      "prompt_latex": "What does it mean for the sample to be a random sample? \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find unbiased estimates of the population mean and variance. \\([2]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "c",
      "prompt_latex": "Test at 5\\% significance whether machine A produces overweight bags. State your hypotheses clearly and define any symbols used. \\([5]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "d",
      "prompt_latex": "Explain the meaning of the \\(p\\)-value obtained in context. \\([1]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "e",
      "prompt_latex": "Machine B bags follow \\(N(\\mu, 0.00198)\\). A sample of \\(n\\) bags has mean 1.489 kg. Find the minimum integer value of \\(n\\) for which there is sufficient evidence at the 5\\% level that \\(\\mu \\neq 1.5\\) kg. \\([3]\\)",
      "correct_answer": "63",
      "answer_type": "exact",
      "tolerance": null
    }
  ]$$::jsonb
WHERE id = 'cafe1012-0000-0000-0000-000000000000';
