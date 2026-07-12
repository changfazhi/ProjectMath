-- Migration 068: JPJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (23 questions)
-- Source: 2025 JPJC H2 Math Prelim P1 QP.pdf / P1 Solution.pdf, P2 QP.pdf / P2 Solution.pdf.
-- Question IDs: Paper 1 = 8025 00NN, Paper 2 = 8025 10NN (prefix '8025' — next unused 4-hex-digit
-- slot; a-f taken by ACJC/CJC/HCI/DHS/RI/YIJC, '9025' by EJC). NN is hex (Q10=0a, Q11=0b, Q12=0c).
-- Top-level (i)/(ii)/... parts are relabelled a/b/c/... per house style (matches RI migration 017);
-- genuine two-level (a)(i) uses "ai"/"aii" etc.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading conventions (skills.md): clean scalars/fractions -> exact; decimals (probabilities, angles,
-- lengths) -> range with tolerance; indefinite integrals & arbitrary-constant answers -> null (revealed);
-- proofs / "show that" / sketch / "state/explain/comment/describe/determine whether" parts -> null.
-- Brittle-but-clean forms (inequalities, line/regression equations, in-terms-of-a series/coords) are
-- graded with a "-- FLAG:" note. Sketch parts get solution_graph specs in migration 069.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q1 [6] App. of Differentiation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250001-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Turning point and area under a rational curve$$,
  $$The curve \(C\) has equation \(y=\dfrac{1}{4x-x^{2}}\).$$,
  'exact',
  $$\frac{1}{4}\ln 3$$,
  NULL,
  $$(a) \(y=(4x-x^{2})^{-1}\Rightarrow\dfrac{dy}{dx}=-(4x-x^{2})^{-2}(4-2x)=\dfrac{2x-4}{(4x-x^{2})^{2}}\). \(\dfrac{dy}{dx}=0\Rightarrow x=2\); \(\dfrac{d^{2}y}{dx^{2}}\Big|_{x=2}=\tfrac18>0\), so \(x=2\) is a minimum. (b) Area \(=\displaystyle\int_1^2\dfrac{1}{4x-x^{2}}\,dx=\int_1^2\dfrac{1}{2^{2}-(x-2)^{2}}\,dx=\left[\tfrac14\ln\left|\dfrac{x}{4-x}\right|\right]_1^2=-\tfrac14\ln\tfrac13=\tfrac14\ln3\).$$,
  6,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\dfrac{dy}{dx}\\). Hence, find the \\(x\\)-coordinate, \\(x=x_{1}\\), of the turning point on \\(C\\) and determine its nature. \\([3]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Using calculus, find the exact area of the region between \\(C\\), the \\(x\\)-axis and the lines with equations \\(x=1\\) and \\(x=x_{1}\\). \\([3]\\)",
    "correct_answer": "\\frac{1}{4}\\ln 3",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q2 [6] Graphing Techniques
-- FLAG: Q2(a) roots in terms of a and Q2(b) modulus inequality (interval with exclusion) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250002-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Reciprocal-square and modulus curves$$,
  $$$$,
  'exact',
  $$a-1<x<a+1,\ x\neq a$$,
  NULL,
  $$(a) \(\dfrac{1}{(x-a)^{2}}=|x-a|\Rightarrow(x-a)^{3}=1\) or \((x-a)^{3}=-1\Rightarrow x-a=\pm1\Rightarrow x=a+1\) or \(x=a-1\). (b) The curve \(y=\dfrac{1}{(x-a)^{2}}\) has vertical asymptote \(x=a\) and \(y\)-intercept \(\tfrac1{a^{2}}\); \(y=|x-a|\) is a V with vertex \((a,0)\), \(y\)-intercept \(a\). They meet at \(x=a\pm1\), so \(\dfrac{1}{(x-a)^{2}}>|x-a|\) for \(a-1<x<a+1\), \(x\neq a\).$$,
  6,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find, in terms of \\(a\\), the roots of the equation \\(\\dfrac{1}{(x-a)^{2}}=|x-a|\\). \\([3]\\)",
    "correct_answer": "x=a+1,\\ x=a-1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "x1", "label": "x", "correct_answer": "a+1", "answer_type": "exact", "tolerance": null },
      { "key": "x2", "label": "x", "correct_answer": "a-1", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "On the same axes, sketch the curves with equations \\(y=\\dfrac{1}{(x-a)^{2}}\\) and \\(y=|x-a|\\), where \\(a>1\\). Hence solve the inequality \\(\\dfrac{1}{(x-a)^{2}}>|x-a|\\). \\([3]\\)",
    "correct_answer": "a-1<x<a+1,\\ x\\neq a",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q3 [4] App. of Differentiation (single-answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  '80250003-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Sliding ladder (related rates)$$,
  $$A ladder of length 3.12 m is sliding down a vertical wall such that the foot of the ladder is moving along the floor at a constant rate of 0.2 m/s. Let \(h\) m be the height of the top of the ladder above the floor and \(x\) m be the distance of the foot of the ladder from the wall. Find the rate at which the top of the ladder is sliding down the wall when it is 1.2 m above the floor. \([4]\)$$,
  'range',
  $$0.48$$,
  0.005,
  $$By Pythagoras, \(h^{2}+x^{2}=3.12^{2}\). Differentiating w.r.t. \(t\): \(2h\dfrac{dh}{dt}+2x\dfrac{dx}{dt}=0\). When \(h=1.2\), \(x=\sqrt{3.12^{2}-1.2^{2}}=2.88\) and \(\dfrac{dx}{dt}=0.2\): \(2(1.2)\dfrac{dh}{dt}+2(2.88)(0.2)=0\Rightarrow\dfrac{dh}{dt}=-0.48\). The top slides down at \(0.48\) m/s.$$,
  4,
  'JPJC H2 Math Prelim 2025'
);

-- P1 Q4 [5] Functions
-- FLAG: Q4(b) inverse-function expression form — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250004-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Inverse and composite functions$$,
  $$Functions \(f\) and \(g\) are defined by \[f:x\mapsto[\ln(x-1)]^{2}+2,\ x\ge a,\qquad g:x\mapsto4+3x-x^{2},\ x\le\tfrac32.\]$$,
  'exact',
  $$$$,
  NULL,
  $$(a) \(f\) has minimum at \(x=2\); the smallest \(a\) for which \(f\) is one-one (so \(f^{-1}\) exists) is \(a=2\). (b) Let \(y=4+3x-x^{2}=-\left(x-\tfrac32\right)^{2}+\tfrac{25}{4}\Rightarrow\left(x-\tfrac32\right)^{2}=\tfrac{25}{4}-y\Rightarrow x=\tfrac32-\sqrt{\tfrac{25}{4}-y}\) (taking \(x\le\tfrac32\)). So \(g^{-1}(x)=\tfrac32-\sqrt{\tfrac{25}{4}-x}\), \(x\le\tfrac{25}{4}\). (c) \(R_{f^{-1}}=D_{f}=[2,\infty)\), \(D_{g^{-1}}=R_{g}=\left(-\infty,\tfrac{25}{4}\right]\). Since \(R_{f^{-1}}\not\subseteq D_{g^{-1}}\), \(g^{-1}f^{-1}\) does not exist.$$,
  5,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "It is given that the function \\(f^{-1}\\) exists. State the smallest value of \\(a\\). \\([1]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find an expression for \\(g^{-1}(x)\\), stating its domain. \\([3]\\)",
    "correct_answer": "g^{-1}(x)=\\frac{3}{2}-\\sqrt{\\frac{25}{4}-x},\\ x\\le\\frac{25}{4}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "expr", "label": "g^{-1}(x)", "correct_answer": "\\frac{3}{2}-\\sqrt{\\frac{25}{4}-x}", "answer_type": "exact", "tolerance": null },
      { "key": "domain", "label": "\\text{domain}", "correct_answer": "x\\le\\frac{25}{4}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Using the value of \\(a\\) found in part (a), determine whether the composite function \\(g^{-1}f^{-1}\\) exists. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q5 [8] Conics
-- FLAG: Q5(a)(ii) inequality k>=3 and Q5(a)(iii) lines of symmetry — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250005-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  2,
  $$Hyperbola and circle; periodic piecewise function$$,
  $$$$,
  'exact',
  $$-3,\ 2$$,
  NULL,
  $$(a)(i) \(C_{1}:\dfrac{x^{2}}{9}-\dfrac{y^{2}}{4}=1\) is a hyperbola with vertices \((\pm3,0)\) and asymptotes \(y=\pm\tfrac23 x\); \(C_{2}:x^{2}+y^{2}=k^{2}\) is a circle centre \(O\), radius \(k\), meeting the axes at \((\pm k,0)\), \((0,\pm k)\). (a)(ii) They intersect when \(k\ge3\) (since \(k>0\)). (a)(iii) Common lines of symmetry: \(x=0\) and \(y=0\). (b)(i) \(f(46)=f(1)=-2(1)+6=4\) (period 5). (b)(ii) A zigzag with vertices \((-5,6),(-2,0),(0,6),(3,0),(5,6)\). (b)(iii) For \(-5\le x\le5\), \(y=f(-x)\) is \(y=f(x)\) reflected in the \(y\)-axis; its roots are \(x=-3\) and \(x=2\).$$,
  8,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "The curves \\(C_{1}\\) and \\(C_{2}\\) have equations \\(\\dfrac{x^{2}}{9}-\\dfrac{y^{2}}{4}=1\\) and \\(y^{2}+x^{2}=k^{2}\\) respectively, where \\(k\\) is a positive constant. Sketch \\(C_{1}\\) and \\(C_{2}\\) on the same diagram, stating the coordinates of any points of intersection with the axes and the equations of any asymptotes. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "State the range of values of \\(k\\) for \\(C_{1}\\) and \\(C_{2}\\) to intersect. \\([1]\\)",
    "correct_answer": "k\\ge 3",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "aiii",
    "prompt_latex": "State the equations of the common lines of symmetry for both \\(C_{1}\\) and \\(C_{2}\\). \\([1]\\)",
    "correct_answer": "x=0,\\ y=0",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "l1", "label": "\\text{line}", "correct_answer": "x=0", "answer_type": "exact", "tolerance": null },
      { "key": "l2", "label": "\\text{line}", "correct_answer": "y=0", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "The function \\(f\\), with domain the set of all real values, is given by \\[f(x)=\\begin{cases}-2x+6 & 0<x\\le3,\\\\ 3x-9 & 3<x\\le5,\\end{cases}\\] and \\(f(x)=f(x+5)\\). Find \\(f(46)\\). \\([1]\\)",
    "correct_answer": "4",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Sketch the graph of \\(y=f(x)\\) for \\(-5\\le x\\le5\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "biii",
    "prompt_latex": "Hence, state the roots of \\(f(-x)=0\\) for \\(-5\\le x\\le5\\). \\([1]\\)",
    "correct_answer": "-3,\\ 2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "r1", "label": "\\text{root}", "correct_answer": "-3", "answer_type": "exact", "tolerance": null },
      { "key": "r2", "label": "\\text{root}", "correct_answer": "2", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P1 Q6 [8] Integration Technique
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250006-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Integration by parts and volume of revolution$$,
  $$$$,
  'exact',
  $$\frac{\pi}{12}(3-19e^{-2})$$,
  NULL,
  $$(a) By parts twice: \(\displaystyle\int x^{2}e^{-2x}\,dx=-\tfrac12x^{2}e^{-2x}-\tfrac12xe^{-2x}-\tfrac14e^{-2x}+C=-\tfrac14e^{-2x}\left(2x^{2}+2x+1\right)+C\). (b) \(y=xe^{-x}\) and \(y=\tfrac1e x\) meet at \(O\) and \(P(1,\tfrac1e)\). Volume \(=\pi\displaystyle\int_0^1\left(xe^{-x}\right)^{2}-\left(\tfrac1e x\right)^{2}dx=\pi\int_0^1 x^{2}e^{-2x}-\tfrac1{e^{2}}x^{2}\,dx=\dfrac{\pi}{4}-\dfrac{19\pi}{12e^{2}}=\dfrac{\pi}{12}\left(3-19e^{-2}\right)\).$$,
  8,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\displaystyle\\int x^{2}e^{-2x}\\,dx\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The curve with equation \\(y=xe^{-x}\\) and the line with equation \\(y=\\dfrac1e x\\) meet at the origin \\(O\\) and the point \\(P\\) with \\(x\\)-coordinate 1. The region \\(R\\) is bounded by the curve and the line. Find the exact volume of the solid formed when \\(R\\) is rotated through \\(360^{\\circ}\\) about the \\(x\\)-axis. \\([4]\\)",
    "correct_answer": "\\frac{\\pi}{12}(3-19e^{-2})",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q7 [10] Definite Integral
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250007-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Integration by substitution and definite integrals$$,
  $$$$,
  'exact',
  $$4(\sqrt{2}-1)$$,
  NULL,
  $$(a)(i) \(\displaystyle\int\dfrac{x}{\sqrt{25-x^{2}}}\,dx=-\tfrac12\int-2x(25-x^{2})^{-\frac12}\,dx=-\sqrt{25-x^{2}}+C\). (a)(ii) \(\displaystyle\int_\alpha^4\left|\dfrac{x}{\sqrt{25-x^{2}}}\right|dx=3\) with \(\alpha<0\): \(-\int_\alpha^0+\int_0^4=\left[\sqrt{25-x^{2}}\right]_\alpha^0-\left[\sqrt{25-x^{2}}\right]_0^4=5-\sqrt{25-\alpha^{2}}-(3-5)=3\Rightarrow\sqrt{25-\alpha^{2}}=4\Rightarrow\alpha^{2}=9\Rightarrow\alpha=-3\). (b) \(x=4\tan\theta\Rightarrow dx=4\sec^{2}\theta\,d\theta\); limits \(0\to\tfrac\pi4\). \(\displaystyle\int_0^4\sqrt{\dfrac{x^{2}}{16+x^{2}}}\,dx=\int_0^{\pi/4}\tan\theta\cdot4\sec\theta\,d\theta=4\left[\sec\theta\right]_0^{\pi/4}=4(\sqrt2-1)\).$$,
  10,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "Find \\(\\displaystyle\\int\\dfrac{x}{\\sqrt{25-x^{2}}}\\,dx\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "Hence, given that \\(\\displaystyle\\int_\\alpha^4\\left|\\dfrac{x}{\\sqrt{25-x^{2}}}\\right|dx=3\\), where \\(\\alpha<0\\), find \\(\\alpha\\) algebraically. \\([3]\\)",
    "correct_answer": "-3",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Using the substitution \\(x=4\\tan\\theta\\), evaluate \\(\\displaystyle\\int_0^4\\sqrt{\\dfrac{x^{2}}{16+x^{2}}}\\,dx\\) exactly. \\([5]\\)",
    "correct_answer": "4(\\sqrt{2}-1)",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q8 [6] Sequences & Series
-- FLAG: Q8(a) quadratic u_n form and Q8(b)(i)/(ii) summation closed forms — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250008-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Quadratic sequence and summation$$,
  $$$$,
  'exact',
  $$\frac{(n+2)^{2}(n+3)^{2}}{2}+5n-77$$,
  NULL,
  $$(a) With \(u_{n}=an^{2}+bn+c\): \(a+b+c=9\), \(4a+2b+c=27\), \(9a+3b+c=55\Rightarrow a=5,b=3,c=1\), so \(u_{n}=5n^{2}+3n+1\). (b)(i) \(\displaystyle\sum_{r=1}^{n}(2r^{3}+5)=2\cdot\dfrac{n^{2}(n+1)^{2}}{4}+5n=\dfrac{n^{2}(n+1)^{2}}{2}+5n\). (b)(ii) \(\displaystyle\sum_{r=2}^{n}\left(2(r+2)^{3}+5\right)=\sum_{r=4}^{n+2}(2r^{3}+5)=\sum_{r=1}^{n+2}(2r^{3}+5)-\sum_{r=1}^{3}(2r^{3}+5)=\dfrac{(n+2)^{2}(n+3)^{2}}{2}+5(n+2)-\left(\tfrac{3^{2}\cdot4^{2}}{2}+15\right)=\dfrac{(n+2)^{2}(n+3)^{2}}{2}+5n-77\). (b)(iii) As \(n\to\infty\), \(\sum_{r=1}^{n}u_{r}=\dfrac{n^{2}(n+1)^{2}}{2}+5n\to\infty\), so the series does not converge.$$,
  6,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "The first three terms of a sequence are given by \\(u_{1}=9\\), \\(u_{2}=27\\) and \\(u_{3}=55\\). Given that \\(u_{n}\\) is a quadratic polynomial in \\(n\\), find \\(u_{n}\\) in terms of \\(n\\). \\([3]\\)",
    "correct_answer": "5n^{2}+3n+1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "It is given \\(\\displaystyle\\sum_{r=1}^{n}r^{3}=\\dfrac{n^{2}(n+1)^{2}}{4}\\) and \\(u_{r}=2r^{3}+5\\). Find \\(\\displaystyle\\sum_{r=1}^{n}u_{r}\\). \\([2]\\)",
    "correct_answer": "\\frac{n^{2}(n+1)^{2}}{2}+5n",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Hence, or otherwise, find \\(\\displaystyle\\sum_{r=2}^{n}\\left(2(r+2)^{3}+5\\right)\\). \\([3]\\)",
    "correct_answer": "\\frac{(n+2)^{2}(n+3)^{2}}{2}+5n-77",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "biii",
    "prompt_latex": "Explain why the series \\(\\displaystyle\\sum_{r=1}^{\\infty}u_{r}\\) does not converge. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q9 [11] Maclaurin Series
-- FLAG: Q9(b) binomial series and Q9(c) Maclaurin series (truncated polynomial forms) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80250009-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Binomial and Maclaurin series for arctan$$,
  $$It is given that \(f(x)=\dfrac{1}{4+9x^{2}}\).$$,
  'range',
  $$0.173$$,
  0.0005,
  $$(a) \(\displaystyle\int\dfrac{1}{4+9x^{2}}\,dx=\dfrac16\tan^{-1}\dfrac{3x}{2}+K\). (b) \(f(x)=\tfrac14\left(1+\tfrac{9x^{2}}{4}\right)^{-1}=\tfrac14\left(1-\tfrac{9x^{2}}{4}+\tfrac{81x^{4}}{16}-\cdots\right)=\tfrac14-\tfrac{9}{16}x^{2}+\tfrac{81}{64}x^{4}\). (c) From (a) and (b), \(\tfrac16\tan^{-1}\tfrac{3x}{2}=\int f\,dx=\tfrac14 x-\tfrac{3}{16}x^{3}+\tfrac{81}{320}x^{5}+(\text{const}=0)\Rightarrow\tan^{-1}\dfrac{3x}{2}=\dfrac32 x-\dfrac98 x^{3}+\dfrac{243}{160}x^{5}\). (d) \(\displaystyle\int_0^{0.5}\left(\tfrac32 x-\tfrac98 x^{3}+\tfrac{243}{160}x^{5}\right)dx=0.174\) (3 d.p.). (e) By GC, \(\displaystyle\int_0^{0.5}\tan^{-1}\tfrac{3x}{2}\,dx=0.173\) (3 d.p.). (f) The estimate in (d) agrees to 2 d.p. but not 3 d.p.; including more terms of the Maclaurin series improves it.$$,
  11,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\displaystyle\\int f(x)\\,dx\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the binomial expansion for \\(f(x)\\), up to and including the term in \\(x^{4}\\). Give the coefficients as exact fractions in their simplest form. \\([2]\\)",
    "correct_answer": "\\frac{1}{4}-\\frac{9}{16}x^{2}+\\frac{81}{64}x^{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Hence, find the Maclaurin series for \\(\\tan^{-1}\\dfrac{3x}{2}\\). Give the coefficients as exact fractions in their simplest form. \\([3]\\)",
    "correct_answer": "\\frac{3}{2}x-\\frac{9}{8}x^{3}+\\frac{243}{160}x^{5}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Use your series from part (c) to estimate \\(\\displaystyle\\int_0^{0.5}\\tan^{-1}\\dfrac{3x}{2}\\,dx\\), correct to 3 decimal places. \\([1]\\)",
    "correct_answer": "0.174",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "e",
    "prompt_latex": "Use your calculator to find \\(\\displaystyle\\int_0^{0.5}\\tan^{-1}\\dfrac{3x}{2}\\,dx\\), correct to 3 decimal places. \\([1]\\)",
    "correct_answer": "0.173",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "f",
    "prompt_latex": "Comparing your answers to parts (d) and (e), comment on the accuracy of your estimate in (d) and how it can be improved. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q10 [9] Transformation
-- FLAG: Q10(b)(i)/(ii) coordinates & gradients in terms of a,b — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '8025000a-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  3,
  $$Transformations of logarithm and general curves$$,
  $$$$,
  'exact',
  $$a=2,\ b=-1,\ c=3$$,
  NULL,
  $$(a) \(y=\ln\dfrac{e^{2}}{3x}=\ln e^{2}-\ln 3x=2-\ln 3x\), i.e. \(a=2,b=-1,c=3\). Transform \(y=\ln x\) by: a scaling parallel to the \(x\)-axis (factor \(\tfrac13\)) giving \(\ln 3x\); reflection in the \(x\)-axis giving \(-\ln 3x\); translation of 2 units in the positive \(y\)-direction giving \(2-\ln 3x\). (b)(i) \(g(x)=2f(x-1)\): \((a,b)\to(a+1,2b)\), so \(R=(a+1,2b)\); \(g'(x)=2f'(x-1)\Rightarrow g'(a+1)=2f'(a)=2(5)=10\). (b)(ii) \(g(x)=\dfrac{1}{f(x)}\): \(R=\left(a,\tfrac1b\right)\); \(g'(x)=-\dfrac{f'(x)}{[f(x)]^{2}}\Rightarrow g'(a)=-\dfrac{5}{b^{2}}\).$$,
  9,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(y=\\ln\\left(\\dfrac{e^{2}}{3x}\\right)\\) can be written in the form \\(y=a+b\\ln(cx)\\), where \\(a\\), \\(b\\) and \\(c\\) are integers to be found. Hence, state a sequence of transformations which transform the graph of \\(y=\\ln x\\) onto the graph of \\(y=\\ln\\left(\\dfrac{e^{2}}{3x}\\right)\\). \\([4]\\)",
    "correct_answer": "a=2,\\ b=-1,\\ c=3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "3", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "The curve \\(y=f(x)\\) passes through the point \\(P(a,b)\\), \\(b\\ne0\\), and the tangent at \\(P\\) has gradient 5. When \\(y=f(x)\\) is transformed onto \\(y=g(x)\\), \\(P\\) corresponds to the point \\(R\\). For \\(g(x)=2f(x-1)\\), state the coordinates of \\(R\\) and find the gradient of the curve at \\(R\\). \\([3]\\)",
    "correct_answer": "R=(a+1,2b),\\ \\text{gradient}=10",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "rx", "label": "R_x", "correct_answer": "a+1", "answer_type": "exact", "tolerance": null },
      { "key": "ry", "label": "R_y", "correct_answer": "2b", "answer_type": "exact", "tolerance": null },
      { "key": "grad", "label": "\\text{gradient}", "correct_answer": "10", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "bii",
    "prompt_latex": "For \\(g(x)=\\dfrac{1}{f(x)}\\), state the coordinates of \\(R\\) and find the gradient of the curve at \\(R\\). \\([2]\\)",
    "correct_answer": "R=\\left(a,\\frac{1}{b}\\right),\\ \\text{gradient}=-\\frac{5}{b^{2}}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "rx", "label": "R_x", "correct_answer": "a", "answer_type": "exact", "tolerance": null },
      { "key": "ry", "label": "R_y", "correct_answer": "\\frac{1}{b}", "answer_type": "exact", "tolerance": null },
      { "key": "grad", "label": "\\text{gradient}", "correct_answer": "-\\frac{5}{b^{2}}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P1 Q11 [8] Sequences & Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '8025000b-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Geometric daily views and arithmetic comments$$,
  $$A company posted a video on a social media platform. Let \(u_{n}\), where \(n\ge1\), denote the number of daily views recorded each day, with \(u_{n+1}=(1+k)u_{n}\), where \(k\) is a positive constant. The number of daily comments, \(v_{r}\) (\(r\ge1\)), is defined by \[v_{r}=\begin{cases}u_{r} & 1\le r\le4,\\ v_{r-1}+80 & r\ge5.\end{cases}\]$$,
  'exact',
  $$14$$,
  NULL,
  $$(a) \(\dfrac{u_{n+1}}{u_{n}}=1+k\), a constant independent of \(n\), so \(\{u_{n}\}\) is a GP. (b) \(u_{1}=311\), \(r=1+k\); \(S_{3}=311\left(1+(1+k)+(1+k)^{2}\right)=4043\Rightarrow(1+k)^{2}+(1+k)-12=0\Rightarrow k^{2}+3k-10=0\Rightarrow k=2\) (rejecting \(k=-5\)). (c) Since \(r=3>1\), the GP has no sum to infinity, so the total number of daily views has no limit. (d) For \(r\ge5\), \(v_{4}=(3^{3})311=8397\) starts an AP with first term 8397, common difference 80. \(S_{r}=S_{3}+\dfrac{r-3}{2}\left[2(8397)+(r-4)(80)\right]=40r^{2}+8117r-20668\), so \(t=20668\). (e) \(40r^{2}+8117r-20668>100000\Rightarrow40r^{2}+8117r-120668>0\Rightarrow r>13.9\); least number of days \(=14\).$$,
  8,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Explain why the sequence \\(\\{u_{n}\\}\\) is a geometric progression. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that the number of daily views recorded at the end of 1st April is 311 and the total number of daily views recorded from 1st April to 3rd April is 4043, find the value of \\(k\\). \\([3]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Explain why there is no limit to the total number of daily views in the long run. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Show that the total number of comments up to the \\(r\\)th day, where \\(r\\ge5\\), is \\(40r^{2}+8117r-t\\), where \\(t\\) is a constant to be determined. \\([3]\\)",
    "correct_answer": "20668",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Find the least number of days required for the total number of daily comments to exceed 100 000. \\([3]\\)",
    "correct_answer": "14",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q12 [12] Vector (Plane)
-- Diagram-dependent: wall corners given explicitly (A(0,0,3), B(0,5,3), C(0,5,0)) so OA/AB directions
-- are unambiguous without the figure (per CLAUDE.md convention for diagram-dependent vector questions).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '8025000c-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Inclined roof, wall and light ray (planes)$$,
  $$A designer constructs an inclined roof attached to a vertical rectangular wall positioned above horizontal ground. Points \((x,y,z)\) are defined relative to a corner of the wall at \(O(0,0,0)\), in metres, with unit vectors \(\mathbf{i}\), \(\mathbf{j}\) and \(\mathbf{k}\) (\(\mathbf{k}\) pointing vertically upwards). The other corners of the wall are \(A(0,0,3)\), \(B(0,5,3)\) and \(C(0,5,0)\), so \(AB\) is 5 m and \(A\), \(B\) are 3 m vertically above \(O\), \(C\) respectively. The roof is attached to the wall along \(AB\) and is modelled by a plane parallel to \(4\mathbf{i}+5\mathbf{j}+\mathbf{k}\).$$,
  'exact',
  $$\frac{16}{\sqrt{17}}$$,
  NULL,
  $$Normal of roof \(\mathbf{n}=\begin{pmatrix}0\\1\\0\end{pmatrix}\times\begin{pmatrix}4\\5\\1\end{pmatrix}=\begin{pmatrix}1\\0\\-4\end{pmatrix}\). (a) Plane through \(A(0,0,3)\): \(\mathbf{r}\boldsymbol{\cdot}\begin{pmatrix}1\\0\\-4\end{pmatrix}=\begin{pmatrix}0\\0\\3\end{pmatrix}\boldsymbol{\cdot}\begin{pmatrix}1\\0\\-4\end{pmatrix}=-12\), i.e. \(x-4z=-12\). (b) Wall normal \(\mathbf{n}_{1}=\begin{pmatrix}1\\0\\0\end{pmatrix}\); \(\cos\theta=\dfrac{|\mathbf{n}_{1}\boldsymbol{\cdot}\mathbf{n}|}{|\mathbf{n}_{1}||\mathbf{n}|}=\dfrac1{\sqrt{17}}\Rightarrow\theta=75.96^{\circ}\); obtuse angle \(=180^{\circ}-75.96^{\circ}=104^{\circ}\) (nearest degree). (c) \(\overrightarrow{AP}=\begin{pmatrix}4\\3\\-3\end{pmatrix}\); minimum strut length \(=\dfrac{|\overrightarrow{AP}\boldsymbol{\cdot}\mathbf{n}|}{|\mathbf{n}|}=\dfrac{|4+12|}{\sqrt{17}}=\dfrac{16}{\sqrt{17}}\). (d) Strut: \(\mathbf{r}=\begin{pmatrix}4\\3\\0\end{pmatrix}+\lambda\begin{pmatrix}1\\0\\-4\end{pmatrix}\); light ray from \(C(0,5,0)\): \(\mathbf{r}=\begin{pmatrix}0\\5\\0\end{pmatrix}+\mu\begin{pmatrix}7\\-4\\4\end{pmatrix}\). Solving \(3=5-4\mu\Rightarrow\mu=\tfrac12\), \(-4\lambda=4\mu\Rightarrow\lambda=-\tfrac12\); \(4+\lambda=7\mu\) checks (\(3.5=3.5\)), so they meet at \(\left(\tfrac72,3,2\right)\).$$,
  12,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the roof is defined by the plane \\(x-4z=-12\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the obtuse angle between the wall and the roof, correct to the nearest degree. \\([3]\\)",
    "correct_answer": "104",
    "answer_type": "range",
    "tolerance": 1
  },
  {
    "label": "c",
    "prompt_latex": "To support the roof, a wooden strut of negligible thickness has one end at \\(P(4,3,0)\\) on the ground and the other end on the roof, such that its length is a minimum. Find the exact length of the wooden strut. \\([2]\\)",
    "correct_answer": "\\frac{16}{\\sqrt{17}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "A ray of light is emitted in the direction \\(7\\mathbf{i}-4\\mathbf{j}+4\\mathbf{k}\\) from a light source at \\(C\\). Show that this light ray meets the wooden strut. Hence, find the coordinates of the point where the light ray meets the wooden strut. \\([4]\\)",
    "correct_answer": "\\left(\\frac{7}{2},\\,3,\\,2\\right)",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "3.5", "answer_type": "range", "tolerance": 0.005 },
      { "key": "y", "label": "y", "correct_answer": "3", "answer_type": "range", "tolerance": 0.005 },
      { "key": "z", "label": "z", "correct_answer": "2", "answer_type": "range", "tolerance": 0.005 }
    ]
  }
]$$::jsonb
);

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1 [9] Differential Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251001-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Spread of a video (differential equation)$$,
  $$The number of social media users who have viewed a video increases at a rate directly proportional to the number of users who have yet to view it. The number who have viewed the video \(t\) hours after upload is \(x\); the total number of users is \(P\) (fixed).$$,
  'range',
  $$28$$,
  1,
  $$(a) \(\dfrac{dx}{dt}=k(P-x)\), \(k>0\). \(\displaystyle\int\dfrac{1}{P-x}\,dx=\int k\,dt\Rightarrow-\ln(P-x)=kt+C\); at \(t=0\), \(x=0\Rightarrow C=-\ln P\); so \(P-x=Pe^{-kt}\), giving \(x=P(1-e^{-kt})\). (b) \(t=12\), \(x=\tfrac12 P\Rightarrow e^{-12k}=\tfrac12\Rightarrow k=\tfrac1{12}\ln2\). For \(x=0.8P\): \(e^{-kt}=0.2\Rightarrow t=\dfrac{-12\ln0.2}{\ln2}=27.9\approx28\) hours. (c) Increasing curve from \(O\), concave down, approaching the horizontal asymptote \(x=P\).$$,
  9,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Write down a differential equation and show that \\(x=P(1-e^{-kt})\\), where \\(k\\) is a positive constant. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is known that 12 hours after upload, half the total number of users have viewed the video. Estimate, to the nearest hour, the time needed for 80% of the total number of users to have viewed the video. \\([3]\\)",
    "correct_answer": "28",
    "answer_type": "range",
    "tolerance": 1
  },
  {
    "label": "c",
    "prompt_latex": "Sketch the graph of \\(x\\) against \\(t\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q2 [10] Vector (Basic)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251002-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Cross products, area of a triangle and angle$$,
  $$With reference to the origin \(O\), the points \(A\), \(P\) and \(Q\) have position vectors \(\mathbf{a}\), \(\mathbf{p}\) and \(\mathbf{q}\) respectively. A straight line \(l\) through \(A\) is parallel to a unit vector \(\mathbf{e}\).$$,
  'range',
  $$48.6$$,
  0.05,
  $$(a) \(l:\mathbf{r}=\mathbf{a}+\lambda\mathbf{e}\); \(Q\) on \(l\Rightarrow\mathbf{q}=\mathbf{a}+\lambda\mathbf{e}\), so \((\mathbf{q}-\mathbf{a})\times\mathbf{e}=\lambda\mathbf{e}\times\mathbf{e}=\mathbf{0}\). (b) \(|(\mathbf{p}-\mathbf{a})\times\mathbf{e}|\) is the perpendicular distance from \(P\) to \(l\) (as \(|\mathbf{e}|=1\)). (c) Area \(=\tfrac12|(\mathbf{p}-\mathbf{a})\times\mathbf{e}||\overrightarrow{AQ}|=\tfrac12|(3\mathbf{q}-\mathbf{a})\times\mathbf{e}|(2)=|(2\mathbf{q})\times\mathbf{e}+(\mathbf{q}-\mathbf{a})\times\mathbf{e}|=2|\mathbf{q}\times\mathbf{e}|\) using (a), so \(k=2\). (d) \(2|\mathbf{q}\times\mathbf{e}|=3\Rightarrow2|\mathbf{q}||\mathbf{e}|\sin\theta=3\Rightarrow2(2)(1)\sin\theta=3\Rightarrow\sin\theta=\tfrac34\Rightarrow\theta=48.6^{\circ}\), the acute angle between \(l\) and \(PQ\).$$,
  10,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "The point \\(Q\\) lies on \\(l\\). Show that \\((\\mathbf{q}-\\mathbf{a})\\times\\mathbf{e}=\\mathbf{0}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(P\\) is not on \\(l\\), give the geometrical meaning of \\(|(\\mathbf{p}-\\mathbf{a})\\times\\mathbf{e}|\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is also given that \\(\\mathbf{p}=3\\mathbf{q}\\) and \\(AQ\\) is 2 units. Using the results in (a) and (b), or otherwise, show that the area of triangle \\(APQ\\) can be written as \\(k|\\mathbf{q}\\times\\mathbf{e}|\\), where \\(k\\) is a constant to be determined. \\([4]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Hence, or otherwise, find the acute angle between \\(l\\) and \\(PQ\\), given further that the area of triangle \\(APQ\\) is 3 units\\(^{2}\\) and \\(|\\mathbf{q}|=2\\). \\([3]\\)",
    "correct_answer": "48.6",
    "answer_type": "range",
    "tolerance": 0.05
  }
]$$::jsonb
);

-- P2 Q3 [10] Parametric Equations
-- FLAG: Q3(b) equation of normal (line equation) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251003-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  2,
  $$Parametric curve: tangent, normal and area$$,
  $$The curve \(C\) has parametric equations \(x=\sin\theta+1\) and \(y=\sqrt3\cos\theta-1\), where \(-\tfrac\pi2\le\theta\le\tfrac\pi2\).$$,
  'exact',
  $$1$$,
  NULL,
  $$(a) \(\dfrac{dx}{d\theta}=\cos\theta\), \(\dfrac{dy}{d\theta}=-\sqrt3\sin\theta\Rightarrow\dfrac{dy}{dx}=-\sqrt3\tan\theta\). (b) At \(T\), \(\dfrac{dy}{dx}=\tan\tfrac{3\pi}{4}=-1\Rightarrow-\sqrt3\tan t=-1\Rightarrow t=\tfrac\pi6\); \(T=\left(\tfrac32,\tfrac12\right)\), gradient of normal \(=1\); normal: \(y-\tfrac12=1\left(x-\tfrac32\right)\Rightarrow y=x-1\). (c) Tangent parallel to \(x\)-axis \(\Rightarrow-\sqrt3\tan\theta=0\Rightarrow\theta=0\Rightarrow y=\sqrt3-1\). (d) At \(Q\) (on \(y=\sqrt3-1\) and \(y=x-1\)): \(x=\sqrt3\). Area of quadrilateral bounded by axes, normal and tangent \(=\tfrac12(\sqrt3+1)(\sqrt3-1)=\tfrac12(2)=1\).$$,
  10,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{dy}{dx}=-\\sqrt3\\tan\\theta\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The tangent to \\(C\\) at point \\(T(\\sin t+1,\\sqrt3\\cos t-1)\\) makes an angle of \\(\\dfrac{3\\pi}{4}\\) with the positive \\(x\\)-axis. Find the equation of the normal to \\(C\\) at \\(T\\). \\([3]\\)",
    "correct_answer": "y=x-1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the exact \\(y\\)-coordinate of the point on \\(C\\) where the tangent to \\(C\\) is parallel to the \\(x\\)-axis. \\([2]\\)",
    "correct_answer": "\\sqrt{3}-1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find the area of the quadrilateral bounded by the axes, the normal to \\(C\\) at \\(T\\) and the tangent in (c). \\([3]\\)",
    "correct_answer": "1",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q4 [11] Complex Number
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251004-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Cubic with complex roots and Argand square$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$3+i,\ \frac{3}{5},\ p=-33,\ q=-30$$,
  NULL,
  $$(a) Real coefficients \(\Rightarrow3+i\) is also a root, giving factor \((w-(3-i))(w-(3+i))=w^{2}-6w+10\). Then \(5w^{3}+pw^{2}+68w+q=(w^{2}-6w+10)(5w+a)\); comparing: \(-6a+50=68\Rightarrow a=-3\), so \(p=a-30=-33\), \(q=10a=-30\), and the third root is \(-\tfrac{a}{5}=\tfrac35\). Other roots: \(3+i\), \(\tfrac35\); \(p=-33\), \(q=-30\). (b) \(Z_{1}(-1,2)\), \(Z_{2}(2,1)\), \(Z_{3}=Z_{1}+Z_{2}=(1,3)\); \(OZ_{1}Z_{3}Z_{2}\) is a parallelogram (\(\overrightarrow{OZ_{3}}=\overrightarrow{OZ_{1}}+\overrightarrow{OZ_{2}}\)). (b)(i) \(\dfrac{z_{1}}{z_{2}}=\dfrac{-1+2i}{2+i}\times\dfrac{2-i}{2-i}=\dfrac{5i}{5}=i\). (b)(ii) \(z_{1}=iz_{2}\Rightarrow OZ_{1}\perp OZ_{2}\) and \(|z_{1}|=|z_{2}|=\sqrt5\); with the parallelogram from (b), \(OZ_{2}Z_{3}Z_{1}\) is a square.$$,
  11,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "One of the roots of the equation \\(5w^{3}+pw^{2}+68w+q=0\\), where \\(p\\) and \\(q\\) are real, is \\(3-i\\). Find the other roots of the equation and the values of \\(p\\) and \\(q\\). \\([5]\\)",
    "correct_answer": "3+i,\\ \\frac{3}{5},\\ p=-33,\\ q=-30",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "root2", "label": "\\text{root}", "correct_answer": "3+i", "answer_type": "exact", "tolerance": null },
      { "key": "root3", "label": "\\text{root}", "correct_answer": "\\frac{3}{5}", "answer_type": "exact", "tolerance": null },
      { "key": "p", "label": "p", "correct_answer": "-33", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "-30", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Two complex numbers are given by \\(z_{1}=-1+2i\\) and \\(z_{2}=2+i\\). Draw an Argand diagram showing \\(z_{1}\\) and \\(z_{2}\\), labelling the origin \\(O\\) and the points \\(Z_{1}\\), \\(Z_{2}\\) representing \\(z_{1}\\), \\(z_{2}\\). Given that \\(z_{3}=z_{1}+z_{2}\\), mark the point \\(Z_{3}\\), showing clearly the geometrical relationship between \\(Z_{1}\\), \\(Z_{2}\\) and \\(Z_{3}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Find \\(\\dfrac{z_{1}}{z_{2}}\\) in the form \\(k\\mathrm{i}\\). \\([2]\\)",
    "correct_answer": "i",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Hence, or otherwise, show that \\(OZ_{2}Z_{3}Z_{1}\\) is a square. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q5 [6] Permutations & Combinations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251005-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  1,
  $$Drawing coloured orbs (combinations)$$,
  $$A pouch contains 5 red orbs, 4 blue orbs and 3 green orbs (12 distinct orbs). A player draws four orbs without replacement; order is not relevant. Find the number of ways this can be done such that$$,
  'exact',
  $$270$$,
  NULL,
  $$(a) \(\binom{12}{4}=495\). (b) At least two colours \(=495-\binom54-\binom44=495-5-1=489\). (c) At least one of each colour = (2R,1B,1G)+(1R,2B,1G)+(1R,1B,2G) \(=\binom52\binom41\binom31+\binom51\binom42\binom31+\binom51\binom41\binom32=120+90+60=270\).$$,
  6,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "there are no restrictions, \\([1]\\)",
    "correct_answer": "495",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "there are at least two colours present, \\([2]\\)",
    "correct_answer": "489",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "at least one orb of each colour is drawn. \\([3]\\)",
    "correct_answer": "270",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q6 [7] Hypothesis Testing
-- FLAG: Q6(c) range of sigma (compound inequality) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251006-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Hypothesis test on mean watch time$$,
  $$A streaming platform claims the average time a user spends watching content per visit is more than 15 minutes. A team samples 80 users; the sample mean time is 16 minutes and the population standard deviation is \(\sigma\) minutes.$$,
  'exact',
  $$0<\sigma<5.44$$,
  NULL,
  $$(a) A 1-tail test, because the claim is directional (mean is more than 15). (b) By the Central Limit Theorem, since \(n=80\) is large, \(\bar X\) is approximately normal regardless of the population distribution, so a test is possible. (c) \(H_{0}:\mu=15\), \(H_{1}:\mu>15\); under \(H_{0}\), \(\bar X\sim N\left(15,\tfrac{\sigma^{2}}{80}\right)\). Test statistic \(z=\dfrac{16-15}{\sigma/\sqrt{80}}=\dfrac{1}{\sqrt{\sigma^{2}/80}}\). Reject \(H_{0}\) at 5% if \(z>1.6449\Rightarrow\sqrt{\sigma^{2}/80}<0.60794\Rightarrow0<\sigma<5.44\). (d) At the 5% significance level, there is a 0.05 probability of concluding that the mean time exceeds 15 minutes when in fact it is 15 minutes.$$,
  7,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Explain why the team should carry out a 1-tail test. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "A test at the 5% significance level indicates that the platform's claim is valid. Explain why the team is able to carry out a hypothesis test without knowing anything about the distribution of the times spent by the users. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the range of values of \\(\\sigma\\). \\([4]\\)",
    "correct_answer": "0<\\sigma<5.44",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Explain, in the context of the question, the meaning of 'at the 5% significance level'. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q7 [7] Discrete Random Variables
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251007-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Number of heads from a chosen coin count$$,
  $$A player selects one ball at random from a bag containing four balls numbered '1', '1', '2', '3', then tosses that number of fair coins. The number of heads obtained, \(X\), has probability distribution: \[\begin{array}{c|cccc}x&0&1&2&3\\\hline P(X=x)&a&\tfrac{15}{32}&b&\tfrac1{32}\end{array}\]$$,
  'range',
  $$0.129$$,
  0.0005,
  $$(a) \(a=P(X=0)=\tfrac12\cdot\tfrac12+\tfrac14\cdot\tfrac14+\tfrac14\cdot\tfrac18=\tfrac{11}{32}\); \(b=1-\tfrac{11}{32}-\tfrac{15}{32}-\tfrac1{32}=\tfrac5{32}\). (b) \(E(X)=0\cdot\tfrac{11}{32}+1\cdot\tfrac{15}{32}+2\cdot\tfrac5{32}+3\cdot\tfrac1{32}=\tfrac78\); \(E(X^{2})=\tfrac{15}{32}+4\cdot\tfrac5{32}+9\cdot\tfrac1{32}=\tfrac{11}{8}\); \(Var(X)=\tfrac{11}{8}-\left(\tfrac78\right)^{2}=\tfrac{39}{64}\). (c) With \(n=50\), by CLT \(\bar X\sim N\left(\tfrac78,\tfrac{39/64}{50}\right)\); \(P(\bar X>1)=0.129\).$$,
  7,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the exact values of \\(a\\) and \\(b\\). \\([3]\\)",
    "correct_answer": "a=\\frac{11}{32},\\ b=\\frac{5}{32}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "\\frac{11}{32}", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "\\frac{5}{32}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(E(X)\\) and show that \\(\\mathrm{Var}(X)=\\dfrac{39}{64}\\). \\([2]\\)",
    "correct_answer": "\\frac{7}{8}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The player plays 50 games. Find the probability that the average number of heads obtained per game exceeds 1. \\([2]\\)",
    "correct_answer": "0.129",
    "answer_type": "range",
    "tolerance": 0.0005
  }
]$$::jsonb
);

-- P2 Q8 [8] Binomial Distribution
-- FLAG: Q8(d) range of p (compound inequality) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251008-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Faulty speakers and quality control (binomial)$$,
  $$A company makes portable speakers; each carton has 24 speakers. It is given that 2% of speakers are faulty.$$,
  'exact',
  $$0<p\le0.0703$$,
  NULL,
  $$(a) Assumptions: whether a speaker is faulty is independent of every other speaker; the probability that any speaker is faulty is constant. (b) \(X\sim B(24,0.02)\): \(P(X\le1)=0.917\). (c) \(P(\text{substandard})=P(X>1)=0.082613\); \(Y\sim B(50,0.082613)\), \(P(Y=0)=0.0134\) (equivalently \([P(X\le1)]^{50}\)). (d) \(F\sim B(3,p)\); \(P(\text{accept})=P(F=0)+P(F=1)P(F=0)=(1-p)^{3}\left[1+3p(1-p)^{2}\right]\ge0.95\Rightarrow0<p\le0.0703\) (from GC).$$,
  8,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State, in context, two assumptions needed for the number of faulty speakers in a randomly chosen carton to be well modelled by a binomial distribution. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the probability that a randomly chosen carton contains at most one faulty speaker. \\([1]\\)",
    "correct_answer": "0.917",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "c",
    "prompt_latex": "A carton with more than one faulty speaker is 'substandard'. Find the probability that, out of 50 cartons, there are no substandard cartons. \\([2]\\)",
    "correct_answer": "0.0134",
    "answer_type": "range",
    "tolerance": 0.0002
  },
  {
    "label": "d",
    "prompt_latex": "Flash drives are packed in batches of one hundred, with each drive faulty with probability \\(p\\) (\\(0<p<1\\)). A sample of 3 is tested: if 2 or 3 are faulty the batch is rejected; if none are faulty it is accepted; if exactly one is faulty a second sample of 3 is tested and the batch is accepted only if that sample has no faulty drive. Find the range of \\(p\\) such that at least 95% of batches are accepted. \\([3]\\)",
    "correct_answer": "0<p\\le0.0703",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q9 [9] Probability
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '80251009-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Independence and bounds on probabilities$$,
  $$Events \(A\) and \(B\) are such that \(P(B)=\tfrac13\), \(P(A\mid B)=\tfrac25\) and \(P(A\cup B)=\tfrac35\).$$,
  'exact',
  $$$$,
  NULL,
  $$(a) \(P(A\cap B)=P(A\mid B)P(B)=\tfrac25\cdot\tfrac13=\tfrac2{15}\). \(P(A)=P(A\cup B)-P(B)+P(A\cap B)=\tfrac35-\tfrac13+\tfrac2{15}=\tfrac25\). Since \(P(A)=P(A\mid B)=\tfrac25\), \(A\) and \(B\) are independent. (b) \(P(A'\cap B)=P(B)-P(A\cap B)=\tfrac13-\tfrac2{15}=\tfrac15\). (c) With \(P(C)=\tfrac12\), \(A\) and \(C\) mutually exclusive: from the Venn diagram \(P(B\cap C)\le P(A'\cap B)\Rightarrow\tfrac12-P(B'\cap C)\le\tfrac15\Rightarrow P(B'\cap C)\ge\tfrac3{10}\); and \(P(A\cup B)+P(B'\cap C)\le1\Rightarrow P(B'\cap C)\le\tfrac25\). Least \(=\tfrac3{10}\), greatest \(=\tfrac25\).$$,
  9,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(P(A)\\) and hence determine whether events \\(A\\) and \\(B\\) are independent. \\([4]\\)",
    "correct_answer": "\\frac{2}{5}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the exact value of \\(P(A'\\cap B)\\). \\([1]\\)",
    "correct_answer": "\\frac{1}{5}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "For a third event \\(C\\), it is given that \\(P(C)=\\tfrac12\\) and that \\(A\\) and \\(C\\) are mutually exclusive. Find exactly the greatest and least possible values of \\(P(B'\\cap C)\\). \\([4]\\)",
    "correct_answer": "\\text{least}=\\frac{3}{10},\\ \\text{greatest}=\\frac{2}{5}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "least", "label": "\\text{least}", "correct_answer": "\\frac{3}{10}", "answer_type": "exact", "tolerance": null },
      { "key": "greatest", "label": "\\text{greatest}", "correct_answer": "\\frac{2}{5}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P2 Q10 [12] Normal Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '8025100a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Yarn ball lengths (normal distribution)$$,
  $$Machine \(A\) produces balls of 2-ply yarn with lengths (m) following \(N(\mu,\sigma^{2})\): 80% have lengths under 340 m and 10% under 280 m. For the rest of the question let \(\mu=300\) and \(\sigma=20\). Machine \(B\) produces balls of 3-ply yarn with lengths following \(N(220,6^{2})\).$$,
  'range',
  $$0.815$$,
  0.0005,
  $$(a) \(\dfrac{340-\mu}{\sigma}=0.84162\), \(\dfrac{280-\mu}{\sigma}=-1.28155\); solving, \(\mu=316\) and \(\sigma=28.3\). (b) \(B\sim N(220,6^{2})\): \([P(B>230)]^{2}[P(B<215)]^{3}\dfrac{5!}{2!3!}=0.000189\). (c) \(T=A_{1}+A_{2}+B_{1}+B_{2}+B_{3}\sim N(1260,908)\); \(P(T>k)=0.385\Rightarrow k=1268.81\). (d) \(X=0.91(A_{1}+A_{2}+A_{3})\sim N(819,993.72)\), \(Y=0.95(B_{1}+\cdots+B_{4})\sim N(836,129.96)\); \(X-Y\sim N(-17,1123.68)\); \(P(|X-Y|<50)=P(-50<X-Y<50)=0.815\).$$,
  12,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Assuming the lengths of 2-ply yarn from Machine \\(A\\) follow \\(N(\\mu,\\sigma^{2})\\), find \\(\\mu\\) and show that \\(\\sigma=28.3\\). \\([3]\\)",
    "correct_answer": "316",
    "answer_type": "range",
    "tolerance": 1
  },
  {
    "label": "b",
    "prompt_latex": "Five balls of 3-ply yarn from Machine \\(B\\) are randomly chosen. Find the probability that two of them have lengths more than 230 m and three have lengths less than 215 m. \\([2]\\)",
    "correct_answer": "0.000189",
    "answer_type": "range",
    "tolerance": 0.000001
  },
  {
    "label": "c",
    "prompt_latex": "The probability that two randomly chosen balls of 2-ply yarn from Machine \\(A\\) and three randomly chosen balls of 3-ply yarn from Machine \\(B\\) have total length exceeding \\(k\\) metres is 0.385. Find the value of \\(k\\), correct to 2 decimal places. \\([3]\\)",
    "correct_answer": "1268.81",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "d",
    "prompt_latex": "The lengths of 2-ply yarn from Machine \\(A\\) are reduced by 9% and the lengths of 3-ply yarn from Machine \\(B\\) are reduced by 5%. Find the probability that the total length of three randomly chosen balls of 2-ply yarn from Machine \\(A\\) is within 50 metres of the total length of four randomly chosen balls of 3-ply yarn from Machine \\(B\\). \\([4]\\)",
    "correct_answer": "0.815",
    "answer_type": "range",
    "tolerance": 0.0005
  }
]$$::jsonb
);

-- P2 Q11 [11] Correlation & Linear Regression
-- FLAG: Q11(a)(i)/(a)(ii) abstract "possible scatter" sketches — no faithful solution_graph (sketch-only).
-- FLAG: Q11(b)(iv) regression-line equation form — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '8025100b-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Scatter diagrams and logarithmic regression$$,
  $$Eight cities are linked by rail to the capital. The distance \(d\) km and rail price \(\$p\) are: \[\begin{array}{c|cccccccc}\text{City}&A&B&C&D&E&F&G&H\\\hline d&124&44&76&148&16&180&104&195\\ p&156&53&99&169&23&177&138&178\end{array}\]$$,
  'range',
  $$184.13$$,
  0.05,
  $$(a)(i) For \(r=0\): a scatter with no linear trend (e.g. points symmetric about a horizontal band). (a)(ii) For \(r\approx0.8\): points rising with mild scatter. (b)(i) Scatter of the eight \((d,p)\) points. (b)(ii) Residuals may be positive or negative; squaring avoids cancellation when they are summed. (b)(iii) Not appropriate: as \(d\) increases, \(p\) increases at a decreasing rate (a curved trend). (b)(iv) \(p=-184.60+68.958\ln d\approx-185+69.0\ln d\); at \(d=210\), \(p=184.13\). (b)(v) \(d=210\) is outside the data range \(16\le d\le195\), so this is extrapolation and may be unreliable. (b)(vi) \(t\) is unchanged; \(s\) increases by 10.$$,
  11,
  'JPJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "Draw a scatter diagram, with 7 points all in the first quadrant, for which the product moment correlation coefficient between \\(x\\) and \\(y\\) is 0. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "Draw a scatter diagram, with 7 points all in the first quadrant, for which the product moment correlation coefficient between \\(x\\) and \\(y\\) is approximately 0.8. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Draw a scatter diagram of the data. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "For a line of best fit \\(p=f(d)\\), the residual for a point \\((a,b)\\) is the vertical distance between \\((a,f(a))\\) and \\((a,b)\\). Explain why, in general, the sum of the squares of the residuals rather than the sum of the residuals is used. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "biii",
    "prompt_latex": "Using the scatter diagram in (b)(i), explain if a linear relationship between the distance and the rail price is appropriate. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "biv",
    "prompt_latex": "The relationship between \\(d\\) and \\(p\\) is modelled by \\(p=s+t\\ln d\\). Find the equation of this regression line and use it to estimate the rail price for a city 210 km from the capital. \\([2]\\)",
    "correct_answer": "p=-185+69.0\\ln d,\\ p(210)=184.13",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "eq", "label": "\\text{regression line}", "correct_answer": "p=-185+69.0\\ln d", "answer_type": "exact", "tolerance": null },
      { "key": "est", "label": "p(210)", "correct_answer": "184.13", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "bv",
    "prompt_latex": "Comment on the reliability of the estimate in (b)(iv). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bvi",
    "prompt_latex": "Following an adjustment, all rail prices are increased by 10 dollars. Without any further calculations, state any change you would expect in the values of \\(s\\) and \\(t\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

