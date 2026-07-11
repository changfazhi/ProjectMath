-- Migration 031: YIJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (24 questions)
-- Source PDF bundles both papers and full solutions; QP pages stamped /JC2PE/25, solutions /JC2PE/2025.
-- Question IDs: Paper 1 = f02500NN, Paper 2 = f02510NN (prefix 'f025' — unused; scheme a=ACJC..e=RI).
-- No DDL: parts JSONB (008) and attempts.part_label already exist.

-- FLAG: Q1 answer has arbitrary constant c (general solution) — exact-match is brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'f0250001-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Reducible differential equation$$,
  $$Show that the differential equation \(y\left(\dfrac{dy}{dx}+2y\right)=\dfrac{x}{e^{4x+x^{2}}}\) can be reduced by the substitution \(z=y^{2}e^{4x}\) to \(\dfrac{dz}{dx}=\dfrac{2x}{e^{x^{2}}}\). Hence, find the general solution in the form \(y^{2}=f(x)\). \([4]\)$$,
  'exact',
  $$e^{-4x}\left(c-e^{-x^{2}}\right)$$,
  NULL,
  $$Differentiating \(z=y^{2}e^{4x}\) gives \(\dfrac{dz}{dx}=2ye^{4x}\left(\dfrac{dy}{dx}+2y\right)=2e^{4x}\cdot\dfrac{x}{e^{4x+x^{2}}}=\dfrac{2x}{e^{x^{2}}}\) (shown). Then \(z=\int 2xe^{-x^{2}}\,dx=-e^{-x^{2}}+c\), so \(y^{2}e^{4x}=c-e^{-x^{2}}\) and \(y^{2}=e^{-4x}\left(c-e^{-x^{2}}\right)\), where \(c\) is an arbitrary constant.$$,
  4,
  'YIJC H2 Math Prelim 2025'
);

-- FLAG: Q2(a) integer count; (b)/(c) date-string answers — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Two novelists (AP & GP)$$,
  $$Ronald is writing a novel. He began on 1 March 2025, writing 23 pages on the first day. On each subsequent day he writes 90% of the number of pages he wrote the previous day. Sam is also writing a novel. He began on 8 March 2025, writing 2 pages on the first day, and on each subsequent day writes 1 more page than the day before.$$,
  'exact',
  $$27 March 2025$$,
  NULL,
  $$(a) \(\dfrac{23(1-0.9^{31})}{1-0.9}=221.06\), so 221 pages (rounding down). (b) Sam's day-\(k\) pages \(=k+1\); Ronald's day-\(n\) pages \(=23(0.9)^{n-1}\) with Sam starting 7 days later. Comparing, the first day Sam writes more is day \(n=13\), i.e. 13 March 2025. (c) Comparing cumulative totals, the first day Sam's total exceeds Ronald's is day \(n=27\), i.e. 27 March 2025.$$,
  5,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the total number of pages Ronald will have written by 31 March 2025. \\([1]\\)",
    "correct_answer": "221",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the first date on which Sam writes more pages in a day than Ronald. \\([2]\\)",
    "correct_answer": "13 March 2025",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the first date on which Sam's total number of pages written exceeds Ronald's. \\([2]\\)",
    "correct_answer": "27 March 2025",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q3(a) series polynomial + validity range (only series graded) — brittle.
-- FLAG: Q3(b) 575/256 is Method-1 form; a valid Method-2 rearrangement gives 256/115.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250003-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Binomial expansion & approximating root 5$$,
  $$$$,
  'exact',
  $$\frac{575}{256}$$,
  NULL,
  $$(a) \((1+5x)^{-1/2}=1-\dfrac{5}{2}x+\dfrac{75}{8}x^{2}+\cdots\), valid for \(|5x|<1\), i.e. \(-\dfrac{1}{5}<x<\dfrac{1}{5}\). (b) Substituting \(x=\dfrac{1}{20}\): LHS \(=\dfrac{2}{5}\sqrt5\), RHS \(=\dfrac{115}{128}\), giving \(\sqrt5\approx\dfrac{575}{256}\). (c) Since \(x=\dfrac{1}{20}\) is closer to 0 than \(x=-\dfrac{4}{25}\), the substitution \(x=-\dfrac{4}{25}\) does not give a better approximation.$$,
  6,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the series expansion of \\(\\dfrac{1}{\\sqrt{1+5x}}\\), up to and including the term in \\(x^{2}\\). State the range of values of \\(x\\) for which the expansion is valid. \\([3]\\)",
    "correct_answer": "1-\\frac{5}{2}x+\\frac{75}{8}x^{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence, use the substitution \\(x=\\dfrac{1}{20}\\) to obtain an approximation of \\(\\sqrt5\\), expressing your answer as a fraction. \\([2]\\)",
    "correct_answer": "\\frac{575}{256}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Without any further calculation, explain whether using the substitution \\(x=-\\dfrac{4}{25}\\) gives a better approximation of \\(\\sqrt5\\) than the substitution used in part (b). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q4(a) answer is a line equation x=1/3 — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250004-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  2,
  $$Parametric curve tangent$$,
  $$A curve has parametric equations \(x=\dfrac{4t^{3}}{3}-t\), \(y=t-3t^{2}\).$$,
  'exact',
  $$\left(\frac{1}{3},-2\right)$$,
  NULL,
  $$\(\dfrac{dx}{dt}=4t^{2}-1\), \(\dfrac{dy}{dt}=1-6t\). (a) Tangent parallel to the \(y\)-axis \(\Rightarrow\dfrac{dx}{dt}=0\Rightarrow t=\pm\dfrac12\); take \(t=-\dfrac12\) (for \(x>0\)), giving \(x=\dfrac13\). (b) Solving \(\dfrac{4t^{3}}{3}-t=\dfrac13\Rightarrow 4t^{3}-3t-1=0\Rightarrow t=-\dfrac12\) or \(t=1\). At \(t=1\) the tangent meets the curve again at \(\left(\dfrac13,-2\right)\).$$,
  5,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "For the part of the curve where \\(x>0\\), find the equation of the tangent to the curve which is parallel to the \\(y\\)-axis. \\([3]\\)",
    "correct_answer": "x=\\frac{1}{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the coordinates of the point where the tangent meets the curve again. \\([2]\\)",
    "correct_answer": "\\left(\\frac{1}{3},-2\\right)",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "x",
        "label": "x",
        "correct_answer": "\\frac{1}{3}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "y",
        "label": "y",
        "correct_answer": "-2",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

-- FLAG: Q5(a)/(b) union-of-intervals inequality answers — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250005-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Rational and logarithmic inequalities$$,
  $$$$,
  'exact',
  $$e^{-3}<x\le e^{\frac{1}{2}}\ \text{or}\ e<x\le e^{2}$$,
  NULL,
  $$(a) \(\dfrac{9x-8}{x^{2}+2x-3}\ge2\Rightarrow\dfrac{(x-2)(2x-1)}{(x+3)(x-1)}\le0\), giving \(-3<x\le\dfrac12\) or \(1<x\le2\). (b) Replacing \(x\) with \(\ln x\): \(-3<\ln x\le\dfrac12\) or \(1<\ln x\le2\), i.e. \(e^{-3}<x\le e^{1/2}\) or \(e<x\le e^{2}\).$$,
  6,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Without using a calculator, solve the inequality \\(\\dfrac{9x-8}{x^{2}+2x-3}\\ge 2\\). \\([4]\\)",
    "correct_answer": "-3<x\\le\\frac{1}{2}\\ \\text{or}\\ 1<x\\le2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence solve the inequality \\(\\dfrac{9\\ln x-8}{(\\ln x)^{2}+2\\ln x-3}\\ge 2\\). \\([2]\\)",
    "correct_answer": "e^{-3}<x\\le e^{\\frac{1}{2}}\\ \\text{or}\\ e<x\\le e^{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q6(a-c) abstract-f sketches — solution_graph (stand-in curves) to be added in migration 032.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250006-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Graph transformations of f$$,
  $$The diagram shows the graph of \(y=f(x)\), with asymptotes \(y=a+bx\) and \(x=0\), an \(x\)-intercept at \((c,0)\) and a turning point at \((d,e)\). Sketch the following graphs on separate diagrams, labelling the equations of any asymptotes and the coordinates of any axial intercepts and turning points.$$,
  'exact',
  $$$$,
  NULL,
  $$(a) \(y=3f(x+c)\): asymptotes \(y=3bx+3a+3bc\) and \(x=-c\); turning point \((d-c,\,3e)\). (b) \(y=\dfrac{1}{f(x)}\): asymptotes \(x=c\) and \(y=0\); turning point \((d,\,1/e)\). (c) \(y=f'(x)\): asymptotes \(x=0\) and \(y=b\); \(x\)-intercept \((d,0)\).$$,
  7,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "\\(y=3f(x+c)\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "\\(y=\\dfrac{1}{f(x)}\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "\\(y=f'(x)\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q7(a) sketch — solution_graph to be added in migration 032.
-- FLAG: Q7(b) set-of-values union and (c) range-of-k inequality — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250007-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  $$Modulus and quadratic graphs$$,
  $$$$,
  'exact',
  $$3<k\le10$$,
  NULL,
  $$(a) Sketch \(y=|2x-1|\) (V-shape, vertex \((\tfrac12,0)\)) and \(y=x^{2}-4x-2\) (minimum in the 4th quadrant) on one diagram. (b) From the GC the graphs meet at \(x=-1\) and \(x=6.16\); \(|2x-1|<x^{2}-4x-2\) for \(\{x\in\mathbb{R}:x<-1\ \text{or}\ x>6.16\}\). (c) Least \(k\): both graphs share the \(y\)-intercept \(\Rightarrow k=3\) (excluded, as \(x=0\) is not positive). Greatest \(k\): \(2x-1=x^{2}-4x-2+k\Rightarrow x^{2}-6x+(k-1)=0\) has real roots \(\Rightarrow 36-4(k-1)\ge0\Rightarrow k\le10\). Hence \(3<k\le10\).$$,
  8,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "On the same diagram, sketch the graphs \\(y=|2x-1|\\) and \\(y=x^{2}-4x-2\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence find the set of values of \\(x\\) for which \\(|2x-1|<x^{2}-4x-2\\). \\([2]\\)",
    "correct_answer": "x<-1\\ \\text{or}\\ x>6.16",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Without using a calculator, find the range of values of \\(k\\) for which \\(|2x-1|=x^{2}-4x-2+k\\) has only positive real roots. \\([4]\\)",
    "correct_answer": "3<k\\le10",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q8(a) exact value with e^{pi/4} — form variations brittle.
-- FLAG: Q8(b)(ii) indefinite integral — ungraded (many equivalent forms).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250008-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Integration by parts; ln(tan x)$$,
  $$$$,
  'exact',
  $$2$$,
  NULL,
  $$(a) Two applications of integration by parts give \(5\int_0^{\pi/4}e^{x}\cos2x\,dx=2e^{\pi/4}-1\), so \(\int_0^{\pi/4}e^{x}\cos2x\,dx=\dfrac{1}{5}\left(2e^{\pi/4}-1\right)\). (b)(i) \(\dfrac{d}{dx}\ln(\tan x)=\dfrac{\sec^{2}x}{\tan x}=\dfrac{1}{\sin x\cos x}=\dfrac{2}{\sin2x}\), so \(k=2\). (b)(ii) \(\int\operatorname{cosec}2x\,[\ln(\tan x)+\cos2x]\,dx=\dfrac14[\ln(\tan x)]^{2}+\dfrac12\ln|\sin2x|+C\).$$,
  8,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the exact value of \\(\\displaystyle\\int_0^{\\frac{\\pi}{4}} e^{x}\\cos 2x\\,dx\\). \\([4]\\)",
    "correct_answer": "\\frac{1}{5}\\left(2e^{\\frac{\\pi}{4}}-1\\right)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Show that \\(\\dfrac{d}{dx}\\ln(\\tan x)=\\dfrac{k}{\\sin 2x}\\), where \\(k\\) is a constant to be determined. \\([2]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Hence find \\(\\displaystyle\\int \\operatorname{cosec}2x\\,[\\ln(\\tan x)+\\cos 2x]\\,dx\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q9(a) complex-number answers and (b)(ii) roots — exact-match brittle (form/order).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250009-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Simultaneous complex equations; quartic roots$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$1-2i,\ -7,\ b=5$$,
  NULL,
  $$(a) From \(iw+z=3i\), \(z=3i-iw\). Substituting into \(2w^{*}-3z=12-i\) and writing \(w=A+Bi\) gives \(2A-3B=12\), \(3A-2B=8\Rightarrow A=0,\,B=-4\). So \(w=-4i\) and \(z=3i-i(-4i)=-4+3i\). (b)(i) Exactly one real root with no repeated roots and real coefficients forces an odd-degree polynomial, so \(a=0\). (b)(ii) With \(1+2i\) a root, so is \(1-2i\); \(x^{3}+bx^{2}-9x+35=(x^{2}-2x+5)(x+7)\), giving real root \(x=-7\) and \(b=5\).$$,
  9,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "The complex numbers \\(z\\) and \\(w\\) satisfy \\(iw+z=3i\\) and \\(2w^{*}-3z=12-i\\). Find \\(z\\) and \\(w\\), giving your answers in the form \\(x+iy\\) where \\(x\\) and \\(y\\) are real numbers. \\([4]\\)",
    "correct_answer": "z=-4+3i,\\ w=-4i",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "z",
        "label": "z",
        "correct_answer": "-4+3i",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "w",
        "label": "w",
        "correct_answer": "-4i",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "It is given that \\(f(x)=ax^{4}+x^{3}+bx^{2}-9x+35\\), where \\(a\\) and \\(b\\) are real numbers, and \\(f(x)=0\\) has no repeated roots. The graph of \\(y=f(x)\\) intersects the \\(x\\)-axis exactly once. Explain why \\(a=0\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "One of the roots of \\(f(x)=0\\) is \\(1+2i\\). Find the other roots and the value of \\(b\\). \\([3]\\)",
    "correct_answer": "1-2i,\\ -7,\\ b=5",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "root",
        "label": "\\text{other roots}",
        "correct_answer": "1-2i, -7",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "b",
        "label": "b",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

-- FLAG: Q10(a) plane equation and (b) vector line equation — exact-match brittle (non-unique form).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250010-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Perpendicular planes, line of intersection, triangle area$$,
  $$Planes \(p\) and \(q\) are perpendicular. Plane \(p\) has equation \(\mathbf{r}\cdot(\mathbf{i}+2\mathbf{j}-\mathbf{k})=6\). Plane \(q\) contains the line \(l\) with equation \(\mathbf{r}=\mathbf{j}-12\mathbf{k}+\lambda(4\mathbf{i}+\mathbf{j}+10\mathbf{k})\), where \(\lambda\) is a parameter. The point \(A\) has coordinates \((0,1,-12)\). The line \(l\) passes through \(p\) at the point \(B\). The point \(C\) is the foot of the perpendicular from \(A\) to \(p\).$$,
  'exact',
  $$\frac{28}{3}\sqrt{14}$$,
  NULL,
  $$(a) Normal of \(q\): \((1,2,-1)\times(4,1,10)=7(3,-2,-1)\); with the point \((0,1,-12)\), \(3x-2y-z=10\). (b) Solving \(x+2y-z=6\) and \(3x-2y-z=10\): \(\mathbf{r}=(4,1,0)+\mu(2,1,4)\). (c) \(B\): \(14-4\lambda=6\Rightarrow\lambda=2\Rightarrow\overrightarrow{OB}=(8,3,8)\). (d) \(C\): \(\overrightarrow{OC}=(0,1,-12)+s(1,2,-1)\) with \(14+6s=6\Rightarrow s=-\tfrac43\Rightarrow\overrightarrow{OC}=\tfrac13(-4,-5,-32)\). (e) \(\overrightarrow{AB}=2(4,1,10)\), \(\overrightarrow{AC}=-\tfrac43(1,2,-1)\); Area \(=\tfrac12|\overrightarrow{AB}\times\overrightarrow{AC}|=\dfrac{28}{3}\sqrt{14}\) units\(^2\).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find a cartesian equation of \\(q\\). \\([2]\\)",
    "correct_answer": "3x-2y-z=10",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find a vector equation of the line \\(m\\), where \\(p\\) and \\(q\\) meet. \\([2]\\)",
    "correct_answer": "\\mathbf{r}=\\begin{pmatrix}4\\\\1\\\\0\\end{pmatrix}+\\mu\\begin{pmatrix}2\\\\1\\\\4\\end{pmatrix}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the position vector of \\(B\\). \\([2]\\)",
    "correct_answer": "\\begin{pmatrix}8\\\\3\\\\8\\end{pmatrix}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "x",
        "label": "x",
        "correct_answer": "8",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "y",
        "label": "y",
        "correct_answer": "3",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "z",
        "label": "z",
        "correct_answer": "8",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Find the position vector of \\(C\\). \\([2]\\)",
    "correct_answer": "\\frac{1}{3}\\begin{pmatrix}-4\\\\-5\\\\-32\\end{pmatrix}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "x",
        "label": "x",
        "correct_answer": "-\\frac{4}{3}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "y",
        "label": "y",
        "correct_answer": "-\\frac{5}{3}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "z",
        "label": "z",
        "correct_answer": "-\\frac{32}{3}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "e",
    "prompt_latex": "Find the exact area of triangle \\(ABC\\). \\([2]\\)",
    "correct_answer": "\\frac{28}{3}\\sqrt{14}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q11(b) inverse-function rule (domain ungraded) and (c) surd expression — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250011-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Inverse and composite functions$$,
  $$The function \(f\) is defined by \(f:x\mapsto\dfrac{1}{x^{2}+2x}\), \(x\in\mathbb{R}\), \(x<-1\), \(x\ne-2\).$$,
  'exact',
  $$-1-\sqrt{\frac{1}{x^{2}+1}+1}$$,
  NULL,
  $$(a) Any horizontal line \(y=k\) cuts \(y=f(x)\) at most once on \(x<-1\), so \(f\) is one-one and \(f^{-1}\) exists. (b) \(y=\dfrac{1}{x^{2}+2x}\Rightarrow(x+1)^{2}=\dfrac1y+1\Rightarrow x=-1-\sqrt{\dfrac1y+1}\) (rejecting \(+\)). \(f^{-1}:x\mapsto-1-\sqrt{\dfrac1x+1}\), \(x\in\mathbb{R}\), \(x<-1\) or \(x>0\). (c) \(fg(x)=x^{2}+1\Rightarrow g(x)=f^{-1}(x^{2}+1)=-1-\sqrt{\dfrac{1}{x^{2}+1}+1}\). (d) \(R_{h}=(0,\infty)\not\subseteq D_{f}\), so \(fh\) does not exist; \(hf\) exists with \(hf(x)=(x^{2}+2x)^{2}=x^{4}+4x^{3}+4x^{2}\), \(x\in\mathbb{R}\), \(x<-1\), \(x\ne-2\).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(f\\) has an inverse. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Define \\(f^{-1}\\) in similar form. \\([4]\\)",
    "correct_answer": "-1-\\sqrt{\\frac{1}{x}+1}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The function \\(g\\) is such that \\(fg(x)=x^{2}+1\\). Find \\(g(x)\\). \\([2]\\)",
    "correct_answer": "-1-\\sqrt{\\frac{1}{x^{2}+1}+1}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "The function \\(h\\) is defined by \\(h:x\\mapsto\\dfrac{1}{x^{2}}\\), \\(x\\in\\mathbb{R}\\), \\(x\\ne0\\). Only one of the composite functions \\(fh\\) and \\(hf\\) exists. Give a definition (including the domain) of the composite that exists, and explain why the other composite does not exist. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250012-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  $$Area and volume with an ellipse$$,
  $$The diagram shows the region \(R\) bounded by the ellipse \(4x^{2}+(y-2)^{2}=4\) and the line \(y=2x\). The ellipse and the line intersect at the origin and the point \((1,2)\).$$,
  'range',
  $$2.98$$,
  0.005,
  $$(a) With \(x=\sin\theta\), \(\int_0^1\sqrt{1-x^{2}}\,dx=\int_0^{\pi/2}\cos^{2}\theta\,d\theta=\left[\tfrac12\theta+\tfrac14\sin2\theta\right]_0^{\pi/2}=\dfrac{\pi}{4}\). (b) Lower boundary \(y=2-2\sqrt{1-x^{2}}\); Area of \(R=\tfrac12(2)(1)-\int_0^1\left(2-2\sqrt{1-x^{2}}\right)dx=\dfrac{\pi}{2}-1\). (c) Volume \(=\tfrac13\pi(2)^{2}(1)-\pi\int_0^1\left(2-2\sqrt{1-x^{2}}\right)^{2}dx=2.98\) (3 s.f.).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Use the substitution \\(x=\\sin\\theta\\) to show that \\(\\displaystyle\\int_0^1\\sqrt{1-x^{2}}\\,dx=\\dfrac{\\pi}{4}\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the area of \\(R\\), giving your answer in terms of \\(\\pi\\). \\([4]\\)",
    "correct_answer": "\\frac{\\pi}{2}-1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the volume of solid generated when \\(R\\) is rotated \\(2\\pi\\) radians about the \\(x\\)-axis. \\([2]\\)",
    "correct_answer": "2.98",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- FLAG: Q13(a) answer is an equation N=e^{0.0994t} with a rounded coefficient — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0250013-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$COVID-19 spread differential equation models$$,
  $$Around November 2019 there was an outbreak of COVID-19. On 23 January 2020 there was 1 confirmed case in Singapore; 70 days later there were 1049 confirmed cases. A student models the spread with \(\dfrac{dN}{dt}=rN\), where \(r\) is a positive constant, \(N\) is the total number of confirmed cases, and \(t\) is the number of days after 23 January 2020.$$,
  'exact',
  $$\frac{ab}{4}$$,
  NULL,
  $$(a) \(N=Ae^{rt}\); \(A=1\), and \(1049=e^{70r}\Rightarrow r=\dfrac{\ln1049}{70}=0.0994\) (3 s.f.), so \(N=e^{0.0994t}\). (b) \(10^{6}=e^{0.099366t}\Rightarrow t\approx139.0\), i.e. 140 days. (c) \(N=1481e^{su}\), \(35292=1481e^{55s}\Rightarrow s=\dfrac{1}{55}\ln\dfrac{35292}{1481}=0.0577\) (3 s.f.). (d) Since \(s<r\), the measures were effective. (e) The models predict unbounded growth, unrealistic for a fixed population. (f) \(\dfrac{dN}{dv}=aN\left(1-\dfrac{N}{b}\right)=-\dfrac{a}{b}\left[\left(N-\dfrac{b}{2}\right)^{2}-\dfrac{b^{2}}{4}\right]\) is greatest when \(N=\dfrac{b}{2}\), giving maximum rate \(\dfrac{ab}{4}\).$$,
  12,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Solve the differential equation to express \\(N\\) in terms of \\(t\\). \\([4]\\)",
    "correct_answer": "e^{0.0994t}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Use the model to estimate the number of days it will take to reach 1 000 000 cases. \\([1]\\)",
    "correct_answer": "140",
    "answer_type": "range",
    "tolerance": 1
  },
  {
    "label": "c",
    "prompt_latex": "To contain the spread, Singapore began strict circuit-breaker measures on 7 April 2020, when confirmed cases stood at 1481; 55 days later, when measures were lifted, cases had surged to 35 292. The student now uses a second model \\(\\dfrac{dN}{du}=sN\\), where \\(s\\) is a positive constant and \\(u\\) is the number of days after 7 April 2020. Find the value of \\(s\\). \\([2]\\)",
    "correct_answer": "0.0577",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "d",
    "prompt_latex": "By comparing the values of \\(r\\) and \\(s\\), comment on whether the lockdown measures were effective in containing the spread of the virus. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Give a reason why neither model can estimate the actual number of confirmed cases accurately. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "f",
    "prompt_latex": "On 30 December 2020 Singapore began its COVID-19 vaccination campaign. The student now uses a third model \\(\\dfrac{dN}{dv}=aN\\left(1-\\dfrac{N}{b}\\right)\\), where \\(a\\) and \\(b\\) are positive constants and \\(v\\) is the number of days after 30 December 2020. Find the maximum rate of change of \\(N\\) in terms of \\(a\\) and \\(b\\). \\([3]\\)",
    "correct_answer": "\\frac{ab}{4}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'f0251001-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  2,
  $$Angle between vectors$$,
  $$The acute angle between two non-zero vectors \(\mathbf{a}\) and \(\mathbf{b}\) is \(\alpha\) radians, and the vectors \(\mathbf{b}\) and \(2\mathbf{a}-\mathbf{b}\) are perpendicular. Find the value of \(\alpha\) if \(|\mathbf{b}|=\sqrt2\,|\mathbf{a}|\). \([3]\)$$,
  'exact',
  $$\frac{\pi}{4}$$,
  NULL,
  $$\(\mathbf{b}\cdot(2\mathbf{a}-\mathbf{b})=0\Rightarrow2|\mathbf{a}||\mathbf{b}|\cos\alpha=|\mathbf{b}|^{2}\). With \(|\mathbf{b}|=\sqrt2|\mathbf{a}|\), \(\sqrt2\cos\alpha=1\Rightarrow\cos\alpha=\dfrac{1}{\sqrt2}\Rightarrow\alpha=\dfrac{\pi}{4}\).$$,
  3,
  'YIJC H2 Math Prelim 2025'
);

-- FLAG: Q2(c) Argand diagram — solution_graph to be added in migration 032.
-- FLAG: Q2(d) shape is a word answer ('rectangle') — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251002-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Modulus-argument and quadrilateral$$,
  $$Do not use a calculator in answering this question. It is given that \(z=\sqrt3-i\) and \(w=2iz\). The points \(O\), \(A\), \(B\) and \(C\) represent the complex numbers \(0\), \(z\), \(z+w\) and \(w\) respectively.$$,
  'exact',
  $$\text{rectangle},\ 8$$,
  NULL,
  $$(a) \(|z|=\sqrt{3+1}=2\), \(\arg z=-\tan^{-1}\dfrac{1}{\sqrt3}=-\dfrac{\pi}{6}\). (b) \(|w|=2|z|=4\); \(\arg w=\arg z+\dfrac{\pi}{2}=\dfrac{\pi}{3}\). (c) On an Argand diagram \(A\) (\(z\)) is in the 4th quadrant, \(C\) (\(w\)) in the 1st quadrant, \(B=z+w\) (parallelogram law). (d) Since \(\angle AOC=\dfrac{\pi}{2}\) and \(OABC\) is a parallelogram, it is a rectangle of area \(|z||w|=2\times4=8\).$$,
  8,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the modulus and argument of \\(z\\). \\([2]\\)",
    "correct_answer": "|z|=2,\\ \\arg z=-\\frac{\\pi}{6}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "mod",
        "label": "|z|",
        "correct_answer": "2",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "arg",
        "label": "\\arg z",
        "correct_answer": "-\\frac{\\pi}{6}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Deduce the modulus and argument of \\(w\\). \\([2]\\)",
    "correct_answer": "|w|=4,\\ \\arg w=\\frac{\\pi}{3}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "mod",
        "label": "|w|",
        "correct_answer": "4",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "arg",
        "label": "\\arg w",
        "correct_answer": "\\frac{\\pi}{3}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Illustrate these four points on a single diagram. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Identify the shape of the quadrilateral \\(OABC\\) and state its area. \\([2]\\)",
    "correct_answer": "\\text{rectangle},\\ 8",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "shape",
        "label": "\\text{shape}",
        "correct_answer": "\\text{rectangle}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "area",
        "label": "\\text{area}",
        "correct_answer": "8",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

-- FLAG: Q3(b) radius is a cube-root surd — exact-match brittle.
-- FLAG: Q3(c) cost-vs-radius sketch — solution_graph to be added in migration 032.
-- FLAG: Q3(d) 'which material' is a word answer — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251003-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Minimising the cost of a cylindrical tank$$,
  $$A closed cylindrical tank with radius \(r\) m and height \(h\) m is to hold \(1000\text{ m}^{3}\) of water. The material for the base and lid costs $50 per \(\text{m}^{2}\), while the material for the curved surface costs $30 per \(\text{m}^{2}\).$$,
  'exact',
  $$\text{curved surface},\ \$15$$,
  NULL,
  $$(a) \(h=\dfrac{1000}{\pi r^{2}}\); \(C=50(2\pi r^{2})+30(2\pi rh)=100\pi r^{2}+\dfrac{60000}{r}\). (b) \(\dfrac{dC}{dr}=200\pi r-\dfrac{60000}{r^{2}}=0\Rightarrow r=\sqrt[3]{\dfrac{300}{\pi}}\) m; \(\dfrac{d^{2}C}{dr^{2}}>0\) so \(C\) is minimum, with minimum cost $19,690.29. (c) The graph of \(C\) against \(r\) (\(r>0\)) has a single minimum at \((4.57,19700)\). (d) The curved-surface material cost has changed to $15 per \(\text{m}^{2}\) (to keep the same equation with volume doubled to \(2000\text{ m}^{3}\)).$$,
  9,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the total cost \\(C\\) (in dollars) can be expressed as \\(C=100\\pi r^{2}+\\dfrac{60000}{r}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Use differentiation to find the exact radius of the cylinder for which \\(C\\) is minimum. State the minimum cost. \\([4]\\)",
    "correct_answer": "r=\\sqrt[3]{\\frac{300}{\\pi}},\\ \\$19690.29",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "r",
        "label": "r",
        "correct_answer": "\\sqrt[3]{\\frac{300}{\\pi}}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "cost",
        "label": "\\text{min cost}",
        "correct_answer": "19690.29",
        "answer_type": "range",
        "tolerance": 0.01
      }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Sketch the graph showing the total cost as the radius of the tank varies. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "A change to one of the materials results in the cylinder's volume doubling to \\(2000\\text{ m}^{3}\\), while maintaining the same minimum cost and radius found in part (b). State which material's cost has changed and its value. \\([1]\\)",
    "correct_answer": "\\text{curved surface},\\ 15",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "material",
        "label": "\\text{material}",
        "correct_answer": "\\text{curved surface}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "value",
        "label": "\\text{new cost}",
        "correct_answer": "15",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

-- FLAG: Q4(b)(i)/(b)(ii) polynomial-in-n answers — exact-match brittle (form).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251004-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$GP conditions and sigma notation$$,
  $$$$,
  'exact',
  $$\frac{1}{6}(n+1)(n+2)(2n+9)-11$$,
  NULL,
  $$(a)(i) \(\dfrac{u_{n+1}}{u_{n}}=b\) (constant), so the sequence is a GP. (a)(ii) \(u_{2}=ab=6\) and \(u_{1}+u_{2}+u_{3}=a(1+b+b^{2})=26\) give \(3b^{2}-10b+3=0\Rightarrow b=\dfrac13\) or \(3\); \(|b|<1\Rightarrow b=\dfrac13\), \(a=18\). (b)(i) \(\sum_{r=1}^{n}r(r+2)=\sum r^{2}+2\sum r=\dfrac16 n(n+1)(2n+7)\). (b)(ii) \(\sum_{r=2}^{n}(r+1)(r+3)=\sum_{r=3}^{n+1}r(r+2)=\dfrac16(n+1)(n+2)(2n+9)-11\).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "A sequence is such that \\(u_{1}=a\\) and \\(u_{n+1}=bu_{n}\\), for \\(n\\ge1\\). Both \\(a\\) and \\(b\\) are constants. Explain why the sequence is a geometric progression. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "Given that \\(u_{2}=6\\), \\(u_{1}+u_{2}+u_{3}=26\\), and the sum to infinity exists, find the values of \\(a\\) and \\(b\\). \\([4]\\)",
    "correct_answer": "a=18,\\ b=\\frac{1}{3}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "a",
        "label": "a",
        "correct_answer": "18",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "b",
        "label": "b",
        "correct_answer": "\\frac{1}{3}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "It is given that \\(\\displaystyle\\sum_{r=1}^{n}r^{2}=\\dfrac{1}{6}n(n+1)(2n+1)\\). Find \\(\\displaystyle\\sum_{r=1}^{n}r(r+2)\\) in terms of \\(n\\). Leave your answer in factorised form. \\([2]\\)",
    "correct_answer": "\\frac{1}{6}n(n+1)(2n+7)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Hence find \\(\\displaystyle\\sum_{r=2}^{n}(r+1)(r+3)\\) in terms of \\(n\\). You do not need to leave your answer in factorised form. \\([3]\\)",
    "correct_answer": "\\frac{1}{6}(n+1)(n+2)(2n+9)-11",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q5(b)/(c) series (polynomial in x) answers — exact-match brittle (form).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251005-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Maclaurin series from an implicit relation$$,
  $$It is given that \(e^{y}=1+e^{x}\).$$,
  'exact',
  $$\frac{1}{2}+\frac{1}{2}x-\frac{1}{6}x^{3}$$,
  NULL,
  $$(a) Differentiating \(e^{y}=1+e^{x}\): \(e^{y}\dfrac{dy}{dx}=e^{x}=e^{y}-1\Rightarrow\dfrac{dy}{dx}=1-e^{-y}\). Differentiating again gives \(\dfrac{d^{2}y}{dx^{2}}+\left(\dfrac{dy}{dx}\right)^{2}=\dfrac{dy}{dx}\). (b) At \(x=0\): \(y=\ln2\), \(y'=\tfrac12\), \(y''=\tfrac14\), \(y'''=0\), \(y^{(4)}=-\tfrac18\); \(y=\ln2+\tfrac12 x+\tfrac18 x^{2}-\tfrac{1}{192}x^{4}+\cdots\). (c) \(\dfrac{e^{2x}}{1+e^{2x}}=\dfrac{dy}{dx}\Big|_{x\to x}\) with \(x\to2x\): \(=\tfrac12+\tfrac12 x-\tfrac16 x^{3}+\cdots\).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{d^{2}y}{dx^{2}}+\\left(\\dfrac{dy}{dx}\\right)^{2}=\\dfrac{dy}{dx}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence find the first four non-zero terms of the Maclaurin series for \\(y\\). \\([5]\\)",
    "correct_answer": "\\ln2+\\frac{1}{2}x+\\frac{1}{8}x^{2}-\\frac{1}{192}x^{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Hence find the Maclaurin series for \\(\\dfrac{e^{2x}}{1+e^{2x}}\\), up to and including the term in \\(x^{3}\\). \\([3]\\)",
    "correct_answer": "\\frac{1}{2}+\\frac{1}{2}x-\\frac{1}{6}x^{3}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251006-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Arrangements of coloured bricks$$,
  $$A children's game set consists of 1 red brick, 2 white bricks, 3 orange bricks and 4 blue bricks. All bricks are identical except for their colour.$$,
  'exact',
  $$1728$$,
  NULL,
  $$(a) Arrange the other 7 bricks \(\left(\dfrac{7!}{2!4!}\right)\) then slot the 3 orange into \(\binom{8}{3}\) gaps: \(\dfrac{7!}{2!4!}\times\binom{8}{3}=5880\). (b) All 10 positions distinct: \(\dfrac{10!}{2!3!4!}=12600\). (c) Casework (2 orange \(+\) 1 white in the 3rd row, or in the 4th row with red/blue): \(630+360+1440=2430\). (d) With bricks numbered, treat 4 same-colour groups: \((4-1)!\times2!\times3!\times4!=1728\).$$,
  8,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the number of ways to arrange the 10 bricks in a row if all the orange bricks are separated. \\([2]\\)",
    "correct_answer": "5880",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The 10 bricks are instead arranged in 4 rows forming a triangular stack (1 brick in the first row, 2 in the second, 3 in the third, 4 in the fourth). Find the number of arrangements if there are no restrictions. \\([1]\\)",
    "correct_answer": "12600",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "For the same 4-row stack, find the number of arrangements if there are exactly two orange bricks and only one white brick in the same row. \\([3]\\)",
    "correct_answer": "2430",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "All the 10 bricks are now numbered from 1 to 10. In how many ways can the bricks be arranged in a circle so that the ones with the same colour are next to each other? \\([2]\\)",
    "correct_answer": "1728",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251007-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  $$Two-box token game distribution$$,
  $$Customers at a shopping mall play a game with 2 boxes of tokens, \(A\) and \(B\). Box \(A\) contains \(n\) black tokens and 4 gold tokens; Box \(B\) contains 4 black tokens and 4 silver tokens. A customer first tosses a fair coin: on a head, two tokens are drawn at random from Box \(B\); otherwise one token is drawn from each box. A black token scores 1 point, a silver token 2 points, and a gold token 3 points. The total number of points is the customer's score \(X\).$$,
  'exact',
  $$\frac{7}{18}$$,
  NULL,
  $$(a) \(P(X=2)=\tfrac12\cdot\tfrac48\cdot\tfrac37+\tfrac12\cdot\tfrac{n}{n+4}\cdot\tfrac48=\dfrac{3}{28}+\dfrac{n}{4(n+4)}\). (b) \(P(X=2)=\dfrac{3}{14}\Rightarrow n=3\); distribution: \(P(X=2)=\dfrac{3}{14}\), \(P(X=3)=\dfrac{11}{28}\), \(P(X=4)=\dfrac14\), \(P(X=5)=\dfrac17\). (c) \(P(X_1=4\mid X_1+X_2\ge9)=\dfrac{P(X_1=4)P(X_2=5)}{2P(X_1=4)P(X_2=5)+P(X_1=5)P(X_2=5)}=\dfrac{7}{18}\).$$,
  8,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(P(X=2)=\\dfrac{3}{28}+\\dfrac{n}{4(n+4)}\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(P(X=2)=\\dfrac{3}{14}\\), determine the probability distribution of \\(X\\). \\([4]\\)",
    "correct_answer": "P(X{=}2)=\\frac{3}{14},\\ P(X{=}3)=\\frac{11}{28},\\ P(X{=}4)=\\frac{1}{4},\\ P(X{=}5)=\\frac{1}{7}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "x2",
        "label": "P(X=2)",
        "correct_answer": "\\frac{3}{14}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "x3",
        "label": "P(X=3)",
        "correct_answer": "\\frac{11}{28}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "x4",
        "label": "P(X=4)",
        "correct_answer": "\\frac{1}{4}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "x5",
        "label": "P(X=5)",
        "correct_answer": "\\frac{1}{7}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Find \\(P(X_1=4\\mid X_1+X_2\\ge9)\\), where \\(X_1\\) and \\(X_2\\) are independent observations of \\(X\\). \\([3]\\)",
    "correct_answer": "\\frac{7}{18}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q8(a) scatter diagram — solution_graph to be added in migration 032.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251008-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Correlation and regression (Rubik's cube)$$,
  $$Andy is learning to solve a Rubik's cube. The table shows his personal record time, \(y\) seconds, \(x\) days after he started. \[\begin{array}{c|cccccccc} x & 5 & 10 & 15 & 20 & 25 & 30 & 35 & 40\\\hline y & 220 & 150 & 100 & 70 & 48 & 35 & 25 & 18\end{array}\]$$,
  'range',
  $$45.7$$,
  0.1,
  $$(a) Scatter diagram: points fall steeply then level off (\(y\) decreasing at a decreasing rate). (b) The model \(y=a+\dfrac{b}{x}\) is appropriate: \(y\) decreases at a decreasing rate, and a linear model would eventually give negative times. (c) \(r\approx0.971\); \(y=4.05+1170\left(\dfrac{1}{x}\right)\) (3 s.f.). (d) At \(x=28\), \(y=4.0496+1165.6\left(\dfrac{1}{28}\right)=45.7\) s; reliable since \(r=0.971\) is close to 1 and \(x=28\) is within the data range. (e) \(r\) is unchanged (not affected by scaling); the model in minutes is \(y=\dfrac{1}{60}\left(4.05+1170\left(\dfrac1x\right)\right)\).$$,
  9,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Draw a scatter diagram for these values, labelling the axes. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Use your diagram and the context of the question to explain whether the relationship between \\(y\\) and \\(x\\) should be modelled by \\(y=a+bx\\) or by \\(y=a+\\dfrac{b}{x}\\), where \\(a\\) and \\(b\\) are constants. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the product moment correlation coefficient and the equation for the chosen model in part (b). \\([2]\\)",
    "correct_answer": "r=0.971,\\ y=4.05+\\frac{1170}{x}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "r",
        "label": "r",
        "correct_answer": "0.971",
        "answer_type": "range",
        "tolerance": 0.002
      },
      {
        "key": "a",
        "label": "a",
        "correct_answer": "4.05",
        "answer_type": "range",
        "tolerance": 0.05
      },
      {
        "key": "b",
        "label": "b",
        "correct_answer": "1170",
        "answer_type": "range",
        "tolerance": 5
      }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Use your equation to estimate his personal record time, 28 days after he started. Explain whether your estimate is reliable. \\([2]\\)",
    "correct_answer": "45.7",
    "answer_type": "range",
    "tolerance": 0.1
  },
  {
    "label": "e",
    "prompt_latex": "Without further calculations, explain whether the product moment correlation coefficient calculated in part (c) would be different if \\(y\\) was recorded in minutes instead. Re-write the equation for the chosen model in this case. You do not need to simplify your answer. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251009-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Normal distribution: egg tarts, donuts, buns$$,
  $$In this question, you should state the parameters of any normal distributions you use. A confectionery bakes egg tarts whose masses are normally distributed; 26% have a mass greater than 65 grams, and an egg tart is equally likely to have a mass less than 50 grams as greater than 70 grams.$$,
  'range',
  $$0.261$$,
  0.002,
  $$(a) By symmetry \(\mu=\dfrac{50+70}{2}=60\); \(P(X>65)=0.26\Rightarrow\dfrac{5}{\sigma}=0.6433\Rightarrow\sigma^{2}=60.4\) (3 s.f.). (b) \(A\sim N(80,10^{2})\): \(P(75\le A\le85)=0.383\). (c) \(B-A\sim N(-10,136)\): \(P(B-A<0)=0.804\). (d) \(T=1.1(A_1+A_2+A_3)+1.2(B_1+\cdots+B_5)\sim N(684,622.2)\); \(P(T>700)=0.261\).$$,
  10,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the mean and variance of this distribution. \\([3]\\)",
    "correct_answer": "\\text{mean}=60,\\ \\text{variance}=60.4",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "mean",
        "label": "\\text{mean}",
        "correct_answer": "60",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "var",
        "label": "\\text{variance}",
        "correct_answer": "60.4",
        "answer_type": "range",
        "tolerance": 0.05
      }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "The masses (grams) of donuts follow \\(N(80,10^{2})\\) and buns follow \\(N(70,6^{2})\\). Find the probability that the mass of a randomly chosen donut is within 5 grams from its mean. \\([1]\\)",
    "correct_answer": "0.383",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "Find the probability that the mass of a randomly chosen bun is less than the mass of a randomly chosen donut. \\([2]\\)",
    "correct_answer": "0.804",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "d",
    "prompt_latex": "A chocolate topping increases the mass of a donut by 10% and the mass of a bun by 20%. Find the probability that the total mass, with chocolate topping, of 3 randomly chosen donuts and 5 randomly chosen buns exceeds 700 grams. \\([4]\\)",
    "correct_answer": "0.261",
    "answer_type": "range",
    "tolerance": 0.002
  }
]$$::jsonb
);

-- FLAG: Q10(e) answer is the boundary of an inequality (xbar >= 507); only the boundary is graded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251010-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  $$Hypothesis test on battery running time$$,
  $$A company advertises that its rechargeable batteries run for an average of 505 minutes after a full charge. 100 batteries are randomly selected and their running times, \(x\) minutes, are measured, giving \(\sum(x-500)=320\) and \(\sum(x-500)^{2}=8416\).$$,
  'range',
  $$507$$,
  0.5,
  $$(a) The values are close to 500, so \((x-500)\) gives smaller summarised figures. (b) \(\bar{x}=\dfrac{320}{100}+500=503.2\); \(s^{2}=\dfrac{1}{99}\left[8416-\dfrac{320^{2}}{100}\right]=74.7\) (3 s.f.). (c) \(H_0:\mu=505\), \(H_1:\mu<505\); by CLT \(\bar{X}\sim N\left(505,\dfrac{74.667}{100}\right)\) approximately (\(n=100\) is large); \(p\text{-value}=0.0186<0.05\), reject \(H_0\): there is sufficient evidence that the company overestimates. (d) Not necessary: \(n=100\) is large, so by CLT the sample mean is approximately normal. (e) \(s^{2}=\dfrac{50}{49}(8.5^{2})=73.724\); \(H_1:\mu>505\), reject \(H_0\) when \(\dfrac{\bar{x}-505}{\sqrt{73.724/50}}\ge1.6449\Rightarrow\bar{x}\ge507\) (3 s.f.).$$,
  12,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Suggest a reason why, in this context, the given data is summarised in terms of \\((x-500)\\) rather than \\(x\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Calculate unbiased estimates of the population mean and variance of the running time of the batteries. \\([2]\\)",
    "correct_answer": "\\bar{x}=503.2,\\ s^{2}=74.7",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "mean",
        "label": "\\bar{x}",
        "correct_answer": "503.2",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "var",
        "label": "s^{2}",
        "correct_answer": "74.7",
        "answer_type": "range",
        "tolerance": 0.05
      }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "A hypothesis test is carried out at the 5% level of significance. Determine whether the company is overestimating the average running time of the batteries. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "State, giving a reason, whether it is necessary to assume a normal distribution for the test to be valid. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "After a change in the manufacturing process, another test at the 5% significance level uses a new random sample of size 50, whose sample standard deviation is 8.5 minutes. Find the range of values of the sample mean in order to conclude that the average running time of the batteries after a full charge is more than 505 minutes. \\([4]\\)",
    "correct_answer": "507",
    "answer_type": "range",
    "tolerance": 0.5
  }
]$$::jsonb
);

-- FLAG: Q11(d) answer is method-dependent: CLT gives 0.215, exact B(1500,0.04) gives 0.194.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'f0251011-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Binomial: torn T-shirts and blouses$$,
  $$In a large shipment of second-hand T-shirts, 4% of the T-shirts are torn. The T-shirts are sold in boxes of 25 pieces each. Let \(X\) denote the number of torn T-shirts in a box.$$,
  'range',
  $$0.130$$,
  0.002,
  $$(a) Each T-shirt is torn with the same constant probability, and whether one T-shirt is torn is independent of any other. (b) \(X\sim B(25,0.04)\): \(P(X\ge2)=1-P(X\le1)=0.264\). (c) \(Y\sim B(10,0.26419)\): \(P(Y>3)=0.258\). (d) With \(E(X)=1\), \(Var(X)=0.96\); by CLT \(\bar{X}\sim N\left(1,\dfrac{0.96}{60}\right)\), \(P(\bar{X}>1.1)=0.215\) (an exact binomial treatment of the 1500 T-shirts gives 0.194). (e) \(A\sim B(60,0.26419)\): comparing \(P(A=15),P(A=16),P(A=17)\), the most probable number is 16. (f) \(W\sim B(25,p)\): \(\binom{25}{2}p^{2}(1-p)^{23}=0.206\Rightarrow300p^{2}(1-p)^{23}=0.206\); with \(p>0.1\), \(p=0.130\) (3 s.f.).$$,
  13,
  'YIJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State, in the context of the question, two assumptions needed to model \\(X\\) by a binomial distribution. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "You are now given that \\(X\\) can be modelled by a binomial distribution. A box is randomly chosen. Find the probability that a box contains at least 2 torn T-shirts. \\([2]\\)",
    "correct_answer": "0.264",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "A box is deemed to be of inferior quality if it contains at least 2 torn T-shirts. Find the probability that, in a random sample of 10 boxes of T-shirts, more than 3 boxes are of inferior quality. \\([2]\\)",
    "correct_answer": "0.258",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "d",
    "prompt_latex": "A distributor purchases a batch of 60 boxes of T-shirts. Find the probability that the average number of torn T-shirts per box is more than 1.1. \\([3]\\)",
    "correct_answer": "0.215",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "e",
    "prompt_latex": "Find the most probable number of boxes of inferior quality in the batch of 60 boxes. \\([2]\\)",
    "correct_answer": "16",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "f",
    "prompt_latex": "In a large shipment of second-hand blouses, a proportion \\(p\\) of the blouses is torn; the blouses are also sold in boxes of 25 and the number of torn blouses in a box is binomial. It is known that the probability of a box containing exactly 2 torn blouses is 0.206. Write down an equation satisfied by \\(p\\). Hence find the value of \\(p\\), given that \\(p>0.1\\). \\([2]\\)",
    "correct_answer": "0.130",
    "answer_type": "range",
    "tolerance": 0.002
  }
]$$::jsonb
);
