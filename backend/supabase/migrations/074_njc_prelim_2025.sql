-- Migration 074: NJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (23 questions)
-- Source: NJC_9758_2025_Prelim_P1.pdf / P1_Solutions.pdf, P2.pdf / P2_Solutions.pdf.
-- Question IDs: Paper 1 = 7025 00NN, Paper 2 = 7025 10NN (prefix '7025' — next unused 4-hex-digit
-- slot; a-f taken by ACJC/CJC/HCI/DHS/RI/YIJC, '9025' by EJC, '8025' by JPJC). NN is hex (Q10=0a,
-- Q11=0b, Q12=0c).
-- Top-level (i)/(ii)/... parts are relabelled a/b/c/... per house style (matches RI/JPJC migrations);
-- genuine two-level (a)(i) uses "ai"/"aii" etc.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading conventions (skills.md): clean scalars/fractions -> exact; decimals (probabilities, angles,
-- lengths, GC estimates) -> range with tolerance; indefinite integrals & arbitrary-constant/DE answers
-- -> null (revealed); proofs / "show that" / sketch / "state the shape"/"describe"/"explain"/"comment"/
-- hypothesis conclusions -> null. Two-valued/vector-valued answers left null per house convention.
-- Brittle-but-clean forms (inequalities, line/asymptote/regression equations, in-terms-of-a series/coords)
-- are graded with a "-- FLAG:" note. Sketch parts get solution_graph specs in migration 075.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q1 [4] Systems of Linear Equations (single-answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  '70250001-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  2,
  $$Currency conversion (system of linear equations)$$,
  $$Paul is helping his friends convert foreign currencies back to Singapore Dollars. Assuming that, for each foreign currency, the exchange rate is the same for every friend, the amounts converted and totals received are:
\[\begin{array}{lcccc}
 & \text{Alex} & \text{Nicholas} & \text{Palmer} & \text{Maybelline}\\
\text{US Dollar (USD)} & 150 & 250 & 425 & a\\
\text{Japanese Yen (JPY)} & 5500 & 9500 & 1000 & 0\\
\text{Chinese Yuan (CNY)} & 1000 & 2200 & 2000 & 1200\\
\text{Total (SGD)} & 419.30 & 797.20 & 913.10 & 568.40
\end{array}\]
Paul has forgotten the amount of US Dollars \(a\) that Maybelline passed to him. Calculate the value of \(a\). \([4]\)$$,
  'range',
  $$275$$,
  1,
  $$Let the exchange rates (SGD per unit) for USD, JPY, CNY be \(U,J,C\). From the first three friends: \(150U+5500J+1000C=419.30\), \(250U+9500J+2200C=797.20\), \(425U+1000J+2000C=913.10\). By GC, \(U=1.2856,\ J=0.00862,\ C=0.17905\). For Maybelline: \(1.2856a+1200(0.17905)=568.40\Rightarrow a=275\).$$,
  4,
  'NJC H2 Math Prelim 2025'
);

-- P1 Q2 [6] Complex Number ("do not use a calculator")
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250002-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Simultaneous complex equations; rotation$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$z=1+i,\ w=-1+i$$,
  NULL,
  $$(a) \(3z-w=4+2\mathrm{i}\Rightarrow6z-2w=8+4\mathrm{i}\); adding \((1+\mathrm{i})z+2w=-2+4\mathrm{i}\) gives \((7+\mathrm{i})z=6+8\mathrm{i}\Rightarrow z=\dfrac{6+8\mathrm{i}}{7+\mathrm{i}}\cdot\dfrac{7-\mathrm{i}}{7-\mathrm{i}}=\dfrac{50+50\mathrm{i}}{50}=1+\mathrm{i}\). Then \(w=3z-4-2\mathrm{i}=3(1+\mathrm{i})-4-2\mathrm{i}=-1+\mathrm{i}\). (b) \(\dfrac{w}{z}=\dfrac{-1+\mathrm{i}}{1+\mathrm{i}}\cdot\dfrac{1-\mathrm{i}}{1-\mathrm{i}}=\dfrac{-1+\mathrm{i}+\mathrm{i}+1}{2}=\mathrm{i}\), so \(w=\mathrm{i}z\). The map \(OZ\mapsto OW\) is a rotation about \(O\) through \(\tfrac{\pi}{2}\) (\(90^{\circ}\)) anticlockwise.$$,
  6,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the values of \\(z\\) and \\(w\\) that satisfy the equations \\((1+\\mathrm{i})z+2w=-2+4\\mathrm{i}\\) and \\(3z-w=4+2\\mathrm{i}\\), expressing your answers in the form \\(c+d\\mathrm{i}\\), where \\(c,d\\in\\mathbb{R}\\). \\([4]\\)",
    "correct_answer": "z=1+i,\\ w=-1+i",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "z", "label": "z", "correct_answer": "1+i", "answer_type": "exact", "tolerance": null },
      { "key": "w", "label": "w", "correct_answer": "-1+i", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Points \\(W\\) and \\(Z\\) represent \\(w\\) and \\(z\\) found in part (a). Find \\(\\dfrac{w}{z}\\) in the form \\(p+q\\mathrm{i}\\), where \\(p,q\\in\\mathbb{R}\\). Hence, state the transformation that maps line segment \\(OZ\\) onto line segment \\(OW\\). \\([2]\\)",
    "correct_answer": "i",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q3 [7] Inequalities (modulus + reciprocal graph, then solve)
-- FLAG: Q3(b) two-interval modulus/reciprocal inequality in terms of a,b — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250003-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Reciprocal and modulus graphs; inequality$$,
  $$Throughout this question \(a\) and \(b\) are positive constants with \(a>b>1\).$$,
  'exact',
  $$x<a-\sqrt{b}\ \text{or}\ x>a$$,
  NULL,
  $$(a) \(y=|x-a|\) is a V with vertex \((a,0)\), crossing the axes at \((a,0)\) and \((0,a)\). \(y=-\dfrac{b}{x-a}\) has vertical asymptote \(x=a\), horizontal asymptote \(y=0\), and \(y\)-intercept \(\left(0,\dfrac{b}{a}\right)\). (b) The curves meet where \(-\dfrac{b}{x-a}=-(x-a)\Rightarrow(x-a)^{2}=b\Rightarrow x=a-\sqrt{b}\) (rejecting \(x=a+\sqrt{b}\) since there \(-\tfrac{b}{x-a}<0<|x-a|\)). Reading the sketch, \(-\dfrac{b}{x-a}<|x-a|\) for \(x<a-\sqrt{b}\) or \(x>a\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "On the same axes, sketch the graphs of \\(y=-\\dfrac{b}{x-a}\\) and \\(y=|x-a|\\), where \\(a\\) and \\(b\\) are positive constants and \\(a>b>1\\). State, in terms of \\(a\\) and \\(b\\), the coordinates of the points where the curves cross the \\(x\\)- and \\(y\\)-axes. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence or otherwise, solve the inequality \\(-\\dfrac{b}{x-a}<|x-a|\\). \\([4]\\)",
    "correct_answer": "x<a-\\sqrt{b}\\ \\text{or}\\ x>a",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q4 [7] Transformation / Conics — all parts state-shape/sketch/describe (no gradable box)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250004-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Semicircle, reciprocal curve and transformations$$,
  $$A curve has equation \(y=f(x)\), where \(f(x)=1-\sqrt{q^{2}-x^{2}}\) for \(q>1\).$$,
  'exact',
  $$$$,
  NULL,
  $$Since \((y-1)^{2}=q^{2}-x^{2}\Rightarrow x^{2}+(y-1)^{2}=q^{2}\) with \(y\le1\), \(y=f(x)\) is a (lower) semicircle, centre \((0,1)\), radius \(q\). (a) Shape: a semicircle. (b) \(y=\dfrac{1}{f(x)}\) has vertical asymptotes where \(f(x)=0\), i.e. \(x=\pm\sqrt{q^{2}-1}\), and end-points \((\pm q,1)\). (c) From \(y=1-\sqrt{q^{2}-x^{2}}\): replace \(y\) by \(y+1\) (translate \(1\) unit in the \(-y\) direction) to get \(y=-\sqrt{q^{2}-x^{2}}\); replace \(x\) by \(qx\) (scale factor \(\tfrac1q\) parallel to the \(x\)-axis) to get \(y=-q\sqrt{1-x^{2}}\); replace \(y\) by \(qy\) (scale factor \(\tfrac1q\) parallel to the \(y\)-axis) to get \(y=-\sqrt{1-x^{2}}\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State the shape of \\(y=f(x)\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Sketch the curve \\(y=\\dfrac{1}{f(x)}\\), giving the equations of any asymptotes and the coordinates of the end-points. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Describe the transformations that map the graph of \\(y=f(x)\\) to \\(y=-\\sqrt{1-x^{2}}\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q5 [8] Graphing Techniques
-- FLAG: Q5(a) oblique asymptote (line equation) — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250005-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  $$Rational curve: oblique asymptote and sketch$$,
  $$The curve \(C\) has equation \(y=\dfrac{2x^{2}+kx+8}{x+p}\), where \(k\) and \(p\) are constants. It is given that \(C\) has a vertical asymptote \(x=2\) and a stationary point at \(x=-4\).$$,
  'exact',
  $$y=2x+32$$,
  NULL,
  $$(a) Vertical asymptote \(x=2\Rightarrow p=-2\). \(\dfrac{dy}{dx}=\dfrac{(x-2)(4x+k)-(2x^{2}+kx+8)}{(x-2)^{2}}\); setting it to \(0\) at \(x=-4\): \((-6)(-16+k)-(32-4k+8)=0\Rightarrow k=28\). Then \(y=\dfrac{2x^{2}+28x+8}{x-2}=2x+32+\dfrac{72}{x-2}\), so the oblique asymptote is \(y=2x+32\). (b) \(C\) has asymptotes \(x=2\) and \(y=2x+32\), stationary points \((-4,12)\) (max) and \((8,60)\) (min), \(x\)-intercept \((-0.292,0)\) and \(y\)-intercept \((0,-4)\).$$,
  8,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the equation of the oblique asymptote of \\(C\\). \\([5]\\)",
    "correct_answer": "y=2x+32",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Sketch \\(C\\), clearly labelling the equations of asymptotes and the coordinates of stationary points. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q6 [8] Sequences & Series
-- FLAG: Q6(a)(i) polynomial coefficients and Q6(b) sum in terms of n,d — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250006-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Geometric series equation; arithmetic progression sum$$,
  $$$$,
  'exact',
  $$6dn^{2}-3dn+21n$$,
  NULL,
  $$(a)(i) \(S_{\infty}=\dfrac{1}{1-r}\), \(S_{3}=\dfrac{1-r^{3}}{1-r}\); \(\dfrac{1}{1-r}=\left(\dfrac{1-r^{3}}{1-r}\right)^{2}\Rightarrow1-r=(1-r^{3})^{2}\Rightarrow r^{6}-2r^{3}+r=0\Rightarrow r^{5}-2r^{2}+1=0\) (\(r\ne0\)) \(\Rightarrow(r-1)(r^{4}+r^{3}+r^{2}-r-1)=0\); since \(r\ne1\), \(r^{4}+r^{3}+r^{2}-r-1=0\), so \(a=1,b=1,c=-1,d=-1\). (a)(ii) By GC (with \(|r|<1\)): \(r=-0.661\) or \(r=0.848\) (3 s.f.). (b) Sum of \(4n\) terms \(=\dfrac{4n}{2}[2(7)+(4n-1)d]=28n+8dn^{2}-2dn\). Removed (every 4th) terms form an AP with first term \(7+3d\), common difference \(4d\), \(n\) terms: sum \(=7n+nd+2dn^{2}\). Remaining \(=28n+8dn^{2}-2dn-7n-nd-2dn^{2}=6dn^{2}-3dn+21n\).$$,
  8,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "An infinite geometric series \\(S\\) has first term 1 and non-zero common ratio \\(r\\). The sum to infinity of \\(S\\) equals the square of the sum of the first three terms of \\(S\\). Show that \\(r\\) satisfies \\(r^{4}+ar^{3}+br^{2}+cr+d=0\\), where \\(a,b,c,d\\) are constants to be determined. \\([3]\\)",
    "correct_answer": "a=1,\\ b=1,\\ c=-1,\\ d=-1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "c", "label": "c", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "d", "label": "d", "correct_answer": "-1", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "aii",
    "prompt_latex": "Find the possible values of \\(r\\). \\([1]\\)",
    "correct_answer": "r=-0.661\\ \\text{or}\\ r=0.848",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "r1", "label": "r", "correct_answer": "-0.661", "answer_type": "range", "tolerance": 0.005 },
      { "key": "r2", "label": "r", "correct_answer": "0.848", "answer_type": "range", "tolerance": 0.005 }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "An arithmetic progression with \\(4n\\) terms has first term 7 and common difference \\(d\\). Every 4th term is removed. Find the sum of the remaining terms in terms of \\(n\\) and \\(d\\). \\([4]\\)",
    "correct_answer": "6dn^{2}-3dn+21n",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q7 [7] Parametric Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250007-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  $$Parametric curve: Cartesian form and steepest tangent$$,
  $$The curve \(C\) is defined parametrically by \(x=e^{4t}\), \(y=t^{2}\), where \(t\ge0\).$$,
  'exact',
  $$P\left(e,\ \tfrac{1}{16}\right)$$,
  NULL,
  $$(a) \(t=\tfrac14\ln x\Rightarrow y=\left(\tfrac14\ln x\right)^{2}=\tfrac{1}{16}(\ln x)^{2}\). (b) \(\dfrac{dy}{dx}=\dfrac{2t}{4e^{4t}}=\dfrac{1}{8x}\ln x\). Steepest gradient where \(\dfrac{d^{2}y}{dx^{2}}=\tfrac18\left[-x^{-2}\ln x+x^{-2}\right]=0\Rightarrow\ln x=1\Rightarrow x=e\), giving \(P\left(e,\tfrac{1}{16}\right)\). (c) \(C\) starts at \((1,0)\) (when \(t=0\)) and increases, passing through \(P\left(e,\tfrac{1}{16}\right)\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the Cartesian equation of \\(C\\). \\([2]\\)",
    "correct_answer": "\\frac{1}{16}(\\ln x)^{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The tangent at point \\(P\\) has the steepest gradient. Find the exact coordinates of \\(P\\). [You do not need to show that the gradient at \\(P\\) is the steepest.] \\([3]\\)",
    "correct_answer": "P\\left(e,\\ \\frac{1}{16}\\right)",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "e", "answer_type": "exact", "tolerance": null },
      { "key": "y", "label": "y", "correct_answer": "\\frac{1}{16}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Sketch \\(C\\), indicating the coordinates of \\(P\\) and the point where \\(C\\) crosses the axes clearly. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q8 [10] Maclaurin Series
-- FLAG: Q8(a)/(b)/(c) series & validity range in terms of a — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250008-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Binomial and Maclaurin expansions; estimate an integral$$,
  $$In this question, you may use expansions from the List of Formulae and Results (MF27). It is given that \(a>0\).$$,
  'exact',
  $$\frac{11a}{16}$$,
  NULL,
  $$(a) \(\dfrac{a}{a-x}-1=\left(1-\dfrac{x}{a}\right)^{-1}-1=\dfrac{x}{a}+\dfrac{x^{2}}{a^{2}}+\cdots\), valid for \(|x|<a\), i.e. \(-a<x<a\). (b) \(e^{\frac{a}{a-x}-1}=e^{\frac{x}{a}+\frac{x^{2}}{a^{2}}+\cdots}=1+\left(\dfrac{x}{a}+\dfrac{x^{2}}{a^{2}}\right)+\tfrac12\left(\dfrac{x}{a}\right)^{2}+\cdots=1+\dfrac{x}{a}+\dfrac{3}{2}\dfrac{x^{2}}{a^{2}}+\cdots\). (c) \(\displaystyle\int_0^{a/2}\left(1+\dfrac{x}{a}+\dfrac{3}{2}\dfrac{x^{2}}{a^{2}}\right)dx=\left[x+\dfrac{x^{2}}{2a}+\dfrac{x^{3}}{2a^{2}}\right]_0^{a/2}=\dfrac{a}{2}+\dfrac{a}{8}+\dfrac{a}{16}=\dfrac{11a}{16}\). The neglected terms are all positive, so the approximating curve lies below \(y=e^{\frac{a}{a-x}-1}\); hence the approximation under-estimates.$$,
  10,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find, in terms of \\(a\\), the series expansion of \\(\\dfrac{a}{a-x}-1\\), in ascending powers of \\(x\\), up to and including the term in \\(x^{2}\\). State, in terms of \\(a\\), the range of \\(x\\) for which the expansion is valid. \\([4]\\)",
    "correct_answer": "\\frac{x}{a}+\\frac{x^{2}}{a^{2}},\\ -a<x<a",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "series", "label": "\\text{expansion}", "correct_answer": "\\frac{x}{a}+\\frac{x^{2}}{a^{2}}", "answer_type": "exact", "tolerance": null },
      { "key": "range", "label": "\\text{validity}", "correct_answer": "-a<x<a", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Hence, find the Maclaurin expansion of \\(e^{\\frac{a}{a-x}-1}\\) in ascending powers of \\(x\\), up to and including the term in \\(x^{2}\\). \\([2]\\)",
    "correct_answer": "1+\\frac{x}{a}+\\frac{3}{2}\\frac{x^{2}}{a^{2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Use the expansion in part (b) to approximate \\(\\displaystyle\\int_0^{a/2}e^{\\frac{a}{a-x}-1}\\,dx\\). Explain why this approximation is an under-estimation. \\([4]\\)",
    "correct_answer": "\\frac{11a}{16}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q9 [11] Integration Technique — indefinite integrals (all null, revealed)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70250009-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  $$Integration by parts and by substitution$$,
  $$$$,
  'exact',
  $$$$,
  NULL,
  $$(a) By parts twice: \(\displaystyle\int\cos(3\ln x)\,dx=x\cos(3\ln x)+3x\sin(3\ln x)-9\int\cos(3\ln x)\,dx\Rightarrow\int\cos(3\ln x)\,dx=\dfrac{x}{10}\cos(3\ln x)+\dfrac{3x}{10}\sin(3\ln x)+C\). (b)(i) With \(P(x)=1-x\): \(\displaystyle\int\dfrac{1-x}{1-\sqrt{x}}\,dx=\int(1+\sqrt{x})\,dx=x+\tfrac23 x^{3/2}+c\). (b)(ii) With \(u=1-\sqrt{x}\), \(\displaystyle\int\dfrac{1}{1-\sqrt{x}}\,dx=2(u-\ln u)+c=-2\sqrt{x}-2\ln(1-\sqrt{x})+C\). Hence with \(P(x)=x\): \(\displaystyle\int\dfrac{x}{1-\sqrt{x}}\,dx=-\int\dfrac{1-x}{1-\sqrt{x}}\,dx+\int\dfrac{1}{1-\sqrt{x}}\,dx=-x-\tfrac23 x^{3/2}-2\sqrt{x}-2\ln(1-\sqrt{x})+C\).$$,
  11,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\displaystyle\\int\\cos(3\\ln x)\\,dx\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Let \\(I\\) be the indefinite integral \\(\\displaystyle\\int\\dfrac{P(x)}{1-\\sqrt{x}}\\,dx\\), \\(0<x<1\\), where \\(P(x)\\) is a polynomial in \\(x\\). Find \\(I\\) when \\(P(x)=1-x\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "By using the substitution \\(u=1-\\sqrt{x}\\), find \\(I\\) when \\(P(x)=1\\). Hence find \\(I\\) when \\(P(x)=x\\). \\([5]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q10 [10] Sequences & Series
-- FLAG: Q10(c) recurrence coefficient f(n) — rational in n, exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '7025000a-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Sequence from a partial-sum formula; convergence$$,
  $$A sequence of numbers \(u_{1},u_{2},u_{3},\ldots\) has sum \(S_{n}=\displaystyle\sum_{r=1}^{n}u_{r}\). It is given that \(S_{n}=A-\dfrac{2}{(n+1)!}\), where \(A\) is a non-zero constant.$$,
  'exact',
  $$14$$,
  NULL,
  $$(a) \(u_{1}=S_{1}=A-\tfrac{2}{2!}=1\Rightarrow A=2\). (b) \(u_{n}=S_{n}-S_{n-1}=\dfrac{2}{n!}-\dfrac{2}{(n+1)!}=\dfrac{2n}{(n+1)!}=\dfrac{2}{(n+1)[(n-1)!]}\) (checks for \(n=1\)). (c) \(u_{n+1}=\dfrac{2}{(n+2)(n!)}\Rightarrow\dfrac{u_{n+1}}{u_{n}}=\dfrac{n+1}{n(n+2)}\), so \(u_{n+1}=\dfrac{n+1}{n(n+2)}\,u_{n}\). (d) As \(n\to\infty\), \(\dfrac{2}{(n+1)!}\to0\), so \(S_{n}\to A=2\); the series converges. (e) \(u_{m}+u_{m+1}+\cdots=2-\left[2-\dfrac{2}{m!}\right]=\dfrac{2}{m!}\le10^{-10}\); by GC \(\tfrac{2}{13!}=3.21\times10^{-10}\), \(\tfrac{2}{14!}=2.29\times10^{-11}\), so least \(m=14\).$$,
  10,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the value of \\(A\\) if \\(u_{1}=1\\). \\([1]\\)",
    "correct_answer": "2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Show that \\(u_{n}=\\dfrac{2}{(n+1)[(n-1)!]}\\) for \\(n\\ge1\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find a recurrence relation in the form \\(u_{n+1}=[f(n)]\\,u_{n}\\). \\([2]\\)",
    "correct_answer": "\\frac{n+1}{n(n+2)}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Explain why \\(S_{n}\\) converges as \\(n\\to\\infty\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Hence, find the least value of \\(m\\) such that the sum of the infinite series \\(u_{m}+u_{m+1}+u_{m+2}+\\cdots\\) does not exceed \\(10^{-10}\\). \\([3]\\)",
    "correct_answer": "14",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q11 [10] Functions
-- FLAG: Q11(a) range interval in terms of a — exact-match brittle. Q11(b) piecewise inverse left null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '7025000b-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Piecewise function: range, inverse and composite$$,
  $$The function \(f\) is defined by \[f(x)=\begin{cases}\dfrac{a}{2}+\dfrac{4}{3}\left(x-\dfrac12\right)^{2} & x\in\mathbb{R},\ \tfrac12<x<2,\\[2mm]\dfrac{a}{x} & x\in\mathbb{R},\ x\ge2,\end{cases}\] where \(a\) is a positive constant. The function \(g\) is defined by \(g(x)=3+e^{x}\), for \(x\in\mathbb{R}\).$$,
  'exact',
  $$\ln 4$$,
  NULL,
  $$(a) On \(\tfrac12<x<2\), \(f\) increases from \(\tfrac{a}{2}\) (excluded) to \(\tfrac{a}{2}+3\) (excluded); on \(x\ge2\), \(f=\tfrac{a}{x}\) decreases from \(\tfrac{a}{2}\) to \(0\). Hence \(R_{f}=\left(0,\ \tfrac{a}{2}+3\right)\). (b) For \(\tfrac12<x<2\): \(x=\tfrac12+\sqrt{\tfrac34\left(y-\tfrac{a}{2}\right)}\Rightarrow f^{-1}(x)=\tfrac12+\sqrt{\tfrac34\left(x-\tfrac{a}{2}\right)}\), \(\tfrac{a}{2}<x<\tfrac{a}{2}+3\); for \(x\ge2\): \(f^{-1}(x)=\tfrac{a}{x}\), \(0<x\le\tfrac{a}{2}\). (c) \(R_{g}=(3,\infty)\subseteq\left(\tfrac12,\infty\right)=D_{f}\), so \(fg\) exists. (d) \(fg(k)=f(3+e^{k})=\dfrac{a}{3+e^{k}}\) (since \(3+e^{k}>2\)); \(\dfrac{a}{3+e^{k}}=\dfrac{a}{7}\Rightarrow e^{k}=4\Rightarrow k=\ln4\).$$,
  10,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the range of \\(f\\). \\([3]\\)",
    "correct_answer": "\\left(0,\\ \\frac{a}{2}+3\\right)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(f^{-1}(x)\\) and state its domain. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Show that \\(fg\\) exists. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find the exact value of \\(k\\) for which \\(fg(k)=\\dfrac{a}{7}\\). \\([3]\\)",
    "correct_answer": "\\ln 4",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q12 [12] Vector (Plane)
-- FLAG: Q12(a) simple cartesian plane y=0 — exact-match brittle but clean.
-- 3D canopy figure not reproduced as a 2-D graph; all data given as vectors, so prose is self-contained.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '7025000c-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Triangular canopy: planes, lines and a trapezium$$,
  $$A model of a triangular canopy \(ABC\) is held taut by three vertical columns \(OA\), \(DB\) and \(EC\). With \(O\) as origin, unit vector \(\mathbf{i}\) is along \(OD\), \(\mathbf{k}\) is along \(OA\) (vertically upward), and \(\mathbf{j}\) is perpendicular to both. The bases lie on the horizontal ground \(ODE\) (perpendicular to \(OA\)). Points \(A\) and \(B\) have position vectors \(\overrightarrow{OA}=3\mathbf{k}\) and \(\overrightarrow{OB}=10\mathbf{i}+4\mathbf{k}\); point \(C\) has \(\overrightarrow{OC}=6\mathbf{i}+4\mathbf{j}+2\mathbf{k}\).$$,
  'exact',
  $$\frac{16}{\sqrt{17}}$$,
  NULL,
  $$(a) \(O\), \(A(0,0,3)\) and \(B(10,0,4)\) all have \(y=0\), so plane \(OAB\) is \(y=0\). (b) \(\overrightarrow{OM}=\overrightarrow{OA}+\lambda(\overrightarrow{OB}-\overrightarrow{OA})=\begin{pmatrix}10\lambda\\0\\3+\lambda\end{pmatrix}\), \(0\le\lambda\le1\). (c) \(\overrightarrow{MC}=\begin{pmatrix}6-10\lambda\\4\\-1-\lambda\end{pmatrix}\), \(\overrightarrow{EC}=\begin{pmatrix}0\\0\\1\end{pmatrix}\); \(\overrightarrow{MC}\cdot\overrightarrow{EC}=-1-\lambda=0\Rightarrow\lambda=-1\notin[0,1]\), so \(\angle MCE\ne90^{\circ}\). (d) \(ECFG\) lies on \(x-y=2\); its intersection with \(y=0\) is the line \(x=2\) (direction \(\mathbf{k}\)), so \(\overrightarrow{FG}\parallel\mathbf{k}\parallel\overrightarrow{CE}\); hence \(ECFG\) has a pair of parallel sides — a trapezium. (e) With \(F(2,0,3.2)\), \(E(6,4,0)\), \(C(6,4,2)\): shortest distance from \(F\) to line \(CE\) \(=\left|\overrightarrow{CF}\times\hat{\mathbf{k}}\right|=\sqrt{32}=4\sqrt2\). \(EC=2\), \(FG=3.2\); area \(=\tfrac12(2+3.2)(4\sqrt2)=\dfrac{52}{5}\sqrt2\).$$,
  12,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State the cartesian equation of plane \\(OAB\\). \\([1]\\)",
    "correct_answer": "y=0",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "A marking \\(M\\) is placed on the line segment \\(AB\\). Find \\(\\overrightarrow{OM}\\) in terms of a parameter \\(\\lambda\\), stating the range of \\(\\lambda\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Cables are laid in straight lines to connect \\(M\\) to \\(C\\) and then \\(C\\) to \\(E\\). Explain why it is not possible for angle \\(MCE\\) to be \\(90^{\\circ}\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Points \\(F\\) and \\(G\\) lie on lines \\(AB\\) and \\(OD\\) respectively. Streamers connect \\(E\\), \\(C\\), \\(F\\) and \\(G\\); the quadrilateral \\(ECFG\\) lies on the plane with cartesian equation \\(x-y=2\\). Show that quadrilateral \\(ECFG\\) is a trapezium. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Find the shortest distance between \\(F\\) and the line \\(CE\\). Hence or otherwise, find the area enclosed by the streamers. \\([5]\\)",
    "correct_answer": "\\text{distance}=4\\sqrt{2},\\ \\text{area}=\\frac{52}{5}\\sqrt{2}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "dist", "label": "\\text{distance}", "correct_answer": "4\\sqrt{2}", "answer_type": "exact", "tolerance": null },
      { "key": "area", "label": "\\text{area}", "correct_answer": "\\frac{52}{5}\\sqrt{2}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1 [7] Complex Number ("do not use a calculator")
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251001-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Modulus, argument and an Argand diagram$$,
  $$Do not use a calculator in answering this question. The complex number \(w\) is such that \(w=\mathrm{i}-\sqrt3\).$$,
  'exact',
  $$-\frac{\pi}{12}$$,
  NULL,
  $$(a) \(|w|=\sqrt{(-\sqrt3)^{2}+1^{2}}=2\); \(\arg(w)=\pi-\tan^{-1}\dfrac{1}{\sqrt3}=\pi-\dfrac{\pi}{6}=\dfrac{5\pi}{6}\). (b) \(w=(-\sqrt3,1)\), \(-w=(\sqrt3,-1)\), \(2-w=(2+\sqrt3,-1)\); with \(|w|=2\), triangle \(O(-w)(2-w)\) is isosceles and \(2-w\) lies with \(-w\) on a horizontal line. (c) By the isosceles triangle (base angles \(\theta\), \(2\theta=\tfrac{\pi}{6}\Rightarrow\theta=\tfrac{\pi}{12}\)), \(\arg(2-w)=-\dfrac{\pi}{12}\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(|w|\\) and \\(\\arg(w)\\) in exact form. \\([2]\\)",
    "correct_answer": "|w|=2,\\ \\arg(w)=\\frac{5\\pi}{6}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "mod", "label": "|w|", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "arg", "label": "\\arg(w)", "correct_answer": "\\frac{5\\pi}{6}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Represent \\(w\\), \\(-w\\) and \\(2-w\\) in the same Argand diagram, illustrating clearly the geometrical relationship between them. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Hence, find \\(\\arg(2-w)\\) exactly. \\([2]\\)",
    "correct_answer": "-\\frac{\\pi}{12}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q2 [11] Conics
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251002-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  2,
  $$Ellipse: sketch, normal and volume of revolution$$,
  $$The curve \(E\) has equation \((x-a)^{2}+4y^{2}=4\), where \(0<a<2\).$$,
  'range',
  $$0.517$$,
  0.005,
  $$(a) \(\dfrac{(x-a)^{2}}{4}+y^{2}=1\) is an ellipse, centre \((a,0)\), with vertices \((a\pm2,0)\) and \((a,\pm1)\). (b) With \(a=1\): at \(x=0\), \(y=\pm\tfrac{\sqrt3}{2}\); differentiating, \(2(x-1)+8y\dfrac{dy}{dx}=0\Rightarrow\dfrac{dy}{dx}=-\dfrac{x-1}{4y}\), so the normal gradient is \(\dfrac{4y}{x-1}\). At \(\left(0,-\tfrac{\sqrt3}{2}\right)\) this is \(2\sqrt3\); the normal is \(y=2\sqrt3\,x-\tfrac{\sqrt3}{2}\). (c) The normal meets \(E\) at \((0.5306,0.9721)\); \(y\)-intercept of \(E\) is \(0.8660\). Volume \(=\tfrac13\pi(0.5306)^{2}\left(\tfrac{\sqrt3}{2}+0.9721\right)-\pi\displaystyle\int_{0.8660}^{0.9721}\left(1-\sqrt{4-4y^{2}}\right)^{2}dy=0.517\) units\(^{3}\) (3 s.f.).$$,
  11,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Sketch \\(E\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "You are now given that \\(a=1\\). Show that the equation of a normal to \\(E\\) at \\(x=0\\) is \\(y=2\\sqrt3\\,x-\\dfrac{\\sqrt3}{2}\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The region \\(R\\) is bounded by \\(E\\), the normal in part (b) and the \\(y\\)-axis. Find the volume of the solid generated when \\(R\\) is rotated through \\(2\\pi\\) radians about the \\(y\\)-axis. \\([5]\\)",
    "correct_answer": "0.517",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P2 Q3 [9] Vector (Basic)
-- Q3(a) two-valued (t,alpha) pairs left null (revealed). Q3(b) greatest projection graded (range).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251003-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Cross product, collinearity and projection$$,
  $$With respect to an origin \(O\), points \(P\) and \(Q\) have variable position vectors \(\mathbf{p}=(\cos t)\mathbf{i}+(\sin t)\mathbf{j}-\mathbf{k}\) and \(\mathbf{q}=(\cos2t)\mathbf{i}-(\sin2t)\mathbf{j}+\alpha\mathbf{k}\), where \(\alpha\) is a real parameter and \(0<t<\pi\).$$,
  'range',
  $$1.06$$,
  0.005,
  $$(a) \(O,P,Q\) collinear \(\Rightarrow\mathbf{p}\times\mathbf{q}=\mathbf{0}\). The \(\mathbf{k}\)-component gives \(-\sin2t\cos t-\cos2t\sin t=-\sin3t=0\Rightarrow t=\tfrac{\pi}{3}\) or \(\tfrac{2\pi}{3}\); the \(\mathbf{i}\)/\(\mathbf{j}\)-components give \(\alpha\sin t=\sin2t\) etc., so \(t=\tfrac{\pi}{3},\alpha=1\) and \(t=\tfrac{2\pi}{3},\alpha=-1\). (b) With \(\alpha=0.5\): \(\mathbf{p}\cdot\mathbf{q}=\cos t\cos2t-\sin t\sin2t-0.5=\cos3t-0.5\). Length of projection \(=\dfrac{|\mathbf{p}\cdot\mathbf{q}|}{|\mathbf{p}|}=\dfrac{|\cos3t-0.5|}{\sqrt2}\); greatest when \(\cos3t=-1\): \(\dfrac{1.5}{\sqrt2}=\dfrac{3}{2\sqrt2}=1.06\) (3 s.f.).$$,
  9,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "By considering the cross product or otherwise, find the exact values of \\(t\\) and \\(\\alpha\\) if \\(O\\), \\(P\\) and \\(Q\\) are collinear. \\([5]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that \\(\\alpha=0.5\\). Show that \\(\\mathbf{p}\\cdot\\mathbf{q}=\\cos3t-0.5\\). Find the greatest length of projection of \\(\\mathbf{q}\\) onto \\(\\mathbf{p}\\). \\([4]\\)",
    "correct_answer": "1.06",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P2 Q4 [13] Differential Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251004-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Atmospheric pressure model (differential equation)$$,
  $$The rate of decrease of atmospheric pressure \(P\) Pascals with respect to altitude \(h\) kilometres above sea level is proportional to \(\dfrac{P}{T}\), where \(T\) is the temperature in Kelvin. \(T\) decreases linearly by \(6.5\) K per kilometre of altitude, and \(T=293\) K at sea level.$$,
  'range',
  $$32500$$,
  50,
  $$(a) \(T=293-6.5h\), so \(\dfrac{dP}{dh}=-\dfrac{kP}{293-6.5h}\), \(k>0\). (b) \(\displaystyle\int\dfrac1P\,dP=\int-\dfrac{k}{293-6.5h}\,dh\Rightarrow\ln P=\dfrac{k}{6.5}\ln|293-6.5h|+C\Rightarrow P=A|293-6.5h|^{b}\), \(b=\dfrac{k}{6.5}>0\) (positive, since \(k>0\)). (c) From \(P=101300\) at \(h=0\) and \(P=80000\) at \(h=2\): \(\left(\dfrac{293}{280}\right)^{b}=\dfrac{101300}{80000}\Rightarrow b=5.2015\), \(A=\dfrac{101300}{293^{5.2015}}=1.4935\times10^{-8}\). At \(h=8.848\): \(P=1.4935\times10^{-8}|293-6.5(8.848)|^{5.2015}=32500\) Pa (3 s.f.). (d) \(P\) decreases to \(0\) at \(h=45.1\) then increases; limitation: for \(h>45.1\) the model gives \(T<0\) (impossible) / \(P\) increasing without bound.$$,
  13,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find a differential equation for \\(\\dfrac{dP}{dh}\\) in terms of \\(P\\) and \\(h\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(P>0\\), solve this model in part (a) to show that \\(P=A|293-6.5h|^{b}\\), where \\(A\\) and \\(b\\) are constants. Explain whether \\(b\\) is positive or negative. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is given that the atmospheric pressures are \\(101\\,300\\) Pa at sea level and \\(80\\,000\\) Pa at \\(h=2\\). Find the atmospheric pressure at the top of Mount Everest with an altitude of \\(8848\\) metres. \\([4]\\)",
    "correct_answer": "32500",
    "answer_type": "range",
    "tolerance": 50
  },
  {
    "label": "d",
    "prompt_latex": "For \\(h\\ge0\\), sketch the graph of \\(P\\) against \\(h\\). Explain a limitation of this model. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q5 [5] Binomial Distribution
-- FLAG: Q5(b) two-sided range of p — exact-match brittle but clean fractions.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251005-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Binomial ratio of successive probabilities; mode$$,
  $$The random variable \(Y\) has distribution \(\mathrm{B}(12,p)\) for \(0<p<1\).$$,
  'exact',
  $$\frac{4}{13}<p<\frac{5}{13}$$,
  NULL,
  $$(a) \(\dfrac{P(Y=k)}{P(Y=k-1)}=\dfrac{\binom{12}{k}p^{k}(1-p)^{12-k}}{\binom{12}{k-1}p^{k-1}(1-p)^{13-k}}=\dfrac{(13-k)p}{k(1-p)}\). (b) Mode \(4\Rightarrow P(Y=4)>P(Y=3)\) and \(P(Y=4)>P(Y=5)\). From \(\dfrac{P(Y=4)}{P(Y=3)}=\dfrac{9p}{4(1-p)}>1\Rightarrow p>\tfrac{4}{13}\); from \(\dfrac{P(Y=5)}{P(Y=4)}=\dfrac{8p}{5(1-p)}<1\Rightarrow p<\tfrac{5}{13}\). Hence \(\tfrac{4}{13}<p<\tfrac{5}{13}\).$$,
  5,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{P(Y=k)}{P(Y=k-1)}=\\dfrac{(13-k)p}{k(1-p)}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that the mode of the distribution is 4. Find the exact range of values of \\(p\\). \\([3]\\)",
    "correct_answer": "\\frac{4}{13}<p<\\frac{5}{13}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q6 [7] Discrete Random Variables
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251006-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Board game: probability distribution, mean and variance$$,
  $$A circular board has 6 sectors labelled \(A,B,C,D,E,F\) (clockwise). A pawn starts on sector \(A\) and is moved clockwise by the number shown on a fair die with faces \(2,2,3,4,4,5\); e.g. a toss of \(4\) moves the pawn from \(A\) to \(E\). The game ends when the pawn lands on sector \(F\). Let \(T\) be the number of tosses required until the game ends.$$,
  'exact',
  $$E(S)=\frac{145}{36},\ \mathrm{Var}(S)=\frac{39275}{1296}$$,
  NULL,
  $$(a) \(P(T=1)=P(5)=\tfrac16\). \(P(T=2)=P(2,3)=\left(\tfrac26\right)\left(\tfrac16\right)\cdot2!=\tfrac19\). \(P(T=3)=P(2,4,5)+P(3,3,5)+P(3,4,4)=\tfrac{5}{36}\) (shown). \(P(T\ge4)=1-\tfrac16-\tfrac19-\tfrac{5}{36}=\tfrac{7}{12}\). (b) \(S=5T\) for \(t=1,2,3\), else \(0\): \(P(S=5)=\tfrac16,P(S=10)=\tfrac19,P(S=15)=\tfrac5{36},P(S=0)=\tfrac7{12}\). \(E(S)=5\cdot\tfrac16+10\cdot\tfrac19+15\cdot\tfrac{5}{36}=\tfrac{145}{36}\). \(\mathrm{Var}(S)=25\cdot\tfrac16+100\cdot\tfrac19+225\cdot\tfrac{5}{36}-\left(\tfrac{145}{36}\right)^{2}=\tfrac{39275}{1296}\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(P(T=3)=\\dfrac{5}{36}\\). Hence complete the probability distribution table for \\(T\\), giving \\(P(T=1)\\), \\(P(T=2)\\) and \\(P(T\\ge4)\\). \\([4]\\)",
    "correct_answer": "P(T=1)=\\frac16,\\ P(T=2)=\\frac19,\\ P(T\\ge4)=\\frac{7}{12}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "t1", "label": "P(T=1)", "correct_answer": "\\frac{1}{6}", "answer_type": "exact", "tolerance": null },
      { "key": "t2", "label": "P(T=2)", "correct_answer": "\\frac{1}{9}", "answer_type": "exact", "tolerance": null },
      { "key": "t4", "label": "P(T\\ge4)", "correct_answer": "\\frac{7}{12}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "The score \\(S\\) for each game is given by \\(S=5T\\) for \\(t=1,2,3\\) and \\(S=0\\) for \\(t\\ge4\\). Find \\(E(S)\\) and \\(\\mathrm{Var}(S)\\). \\([3]\\)",
    "correct_answer": "E(S)=\\frac{145}{36},\\ \\mathrm{Var}(S)=\\frac{39275}{1296}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "es", "label": "E(S)", "correct_answer": "\\frac{145}{36}", "answer_type": "exact", "tolerance": null },
      { "key": "vars", "label": "\\mathrm{Var}(S)", "correct_answer": "\\frac{39275}{1296}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P2 Q7 [7] Permutations & Combinations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251007-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Toy train arrangements$$,
  $$A toy train is made up of 3 types of units: engine, carriage and wagon. There are 4 identical engines \(E\), 3 identical carriages \(C\) and 2 identical wagons \(W\).$$,
  'exact',
  $$56$$,
  NULL,
  $$(a) By inclusion–exclusion: (first unit \(E\)) \(\dfrac{8!}{3!3!2!}=560\), (last two \(EE\)) \(\dfrac{7!}{2!3!2!}=210\), (both) \(\dfrac{6!}{3!2!}=60\); total \(=560+210-60=710\). (b) First unit \(E\); the remaining \(3E,3C,2W\) are arranged with all carriages before all wagons. Choose 5 of the 8 remaining positions for \(3C,2W\) (order fixed as \(CCCWW\)): \(\binom{8}{5}=56\); the other 3 positions take the engines. Total \(=56\).$$,
  7,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "All the train units are placed in a line such that either the first unit is an engine or the last two units are engines, or both. Find the number of ways to form the toy train. \\([4]\\)",
    "correct_answer": "710",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "For another kind of toy train, all the units are placed in a line such that the first unit is an engine and all the carriages are in front of the wagons (e.g. \\(E\\,C\\,C\\,E\\,E\\,C\\,W\\,E\\,W\\)). Find the number of ways to form the toy train. \\([3]\\)",
    "correct_answer": "56",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q8 [8] Correlation & Linear Regression
-- FLAG: Q8(c) regression coefficients & r graded by range; equation form is brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251008-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Blood pressure vs haemoglobin: model choice and regression$$,
  $$A study records the haemoglobin level \(s\) (mmol/mol) and blood pressure \(p\) (mmHg) of six patients aged 50–60:
\[\begin{array}{c|cccccc}
s & 32 & 37 & 41 & 46 & 50 & 54\\\hline
p & 120 & 150 & 168 & 172 & 179 & 183
\end{array}\]
It is thought that \(p\) can be modelled by \(p=a+bs^{2}\) or \(p=c+\dfrac{d}{s}\), where \(a,b,c\) are positive and \(d\) is negative.$$,
  'range',
  $$170$$,
  1,
  $$(a) Scatter of the six points. (b) As \(s\) increases, \(p\) increases at a decreasing rate (concave), matching \(p=c+\dfrac{d}{s}\) (which is increasing and concave for \(d<0\)); the better model is \(p=c+\dfrac{d}{s}\). (c) By GC (regressing \(p\) on \(\tfrac1s\)): \(p=276.88-\dfrac{4822.6}{s}\approx277-\dfrac{4820}{s}\), \(r=-0.973\) (3 s.f.). (d) At \(s=45\): \(p=276.88-\dfrac{4822.6}{45}=170\) (3 s.f.). Since \(s=45\) lies within the data range \([32,54]\) and \(r=-0.973\) is close to \(-1\) (strong linear relationship between \(p\) and \(\tfrac1s\)), the estimate is reliable.$$,
  8,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Draw a scatter diagram of these data. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "By using your diagram, explain which of \\(p=a+bs^{2}\\) or \\(p=c+\\dfrac{d}{s}\\) is the better model. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Using the model chosen in part (b), write down the equation relating \\(s\\) and \\(p\\), giving the numerical values of the coefficients. State the product moment correlation coefficient for this model. \\([2]\\)",
    "correct_answer": "p=277-\\frac{4820}{s},\\ r=-0.973",
    "answer_type": "range",
    "tolerance": 1,
    "answers": [
      { "key": "c", "label": "c", "correct_answer": "277", "answer_type": "range", "tolerance": 1 },
      { "key": "d", "label": "d", "correct_answer": "-4820", "answer_type": "range", "tolerance": 10 },
      { "key": "r", "label": "r", "correct_answer": "-0.973", "answer_type": "range", "tolerance": 0.005 }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Estimate the value of \\(p\\) when \\(s=45\\). Determine whether this estimate is reliable. \\([3]\\)",
    "correct_answer": "170",
    "answer_type": "range",
    "tolerance": 1
  }
]$$::jsonb
);

-- P2 Q9 [9] Probability
-- FLAG: Q9(c) recurrence coefficient and Q9(d) probability in terms of n — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '70251009-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Cartoon-character coupons: conditional probability and a recurrence$$,
  $$A supermarket prints one of 10 equally likely cartoon characters \(A,B,\ldots,J\) on each receipt. A shopper receives three receipts after three purchases.$$,
  'exact',
  $$1-\left(\frac{7}{10}\right)^{n}$$,
  NULL,
  $$(a) \(P(\text{exactly one }A)=\binom{3}{1}(0.1)(0.9)^{2}=0.243\). (b) \(P(\text{one each of }A,B,C)=3!\,(0.1)^{3}=0.006\); required \(=\dfrac{0.006}{0.243}=\dfrac{2}{81}\). (c) \(p_{1}=\dfrac{3}{10}\); to get the 8th new character on the \(n\)th purchase, the previous \(n-1\) must fail (prob \(\tfrac{7}{10}\) each), so \(p_{n}=\dfrac{7}{10}p_{n-1}\). (d) \(P(\text{at most }n)=\displaystyle\sum_{r=1}^{n}\left(\tfrac{7}{10}\right)^{r-1}\tfrac{3}{10}=1-\left(\tfrac{7}{10}\right)^{n}\).$$,
  9,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the probability that only one receipt has the character \\(A\\) printed on it. \\([2]\\)",
    "correct_answer": "0.243",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "b",
    "prompt_latex": "Given that exactly one of the cartoon characters printed is \\(A\\), find the probability that the other two characters printed are \\(B\\) and \\(C\\). \\([3]\\)",
    "correct_answer": "\\frac{2}{81}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "To redeem a gift, exactly 8 distinct characters are needed; Tom has 7. Let \\(p_{n}\\) be the probability that Tom redeems the gift on exactly the \\(n\\)th additional purchase. Find \\(p_{1}\\) and the recurrence relation \\(p_{n}=f(p_{n-1})\\), for \\(n\\ge2\\). \\([2]\\)",
    "correct_answer": "p_{1}=\\frac{3}{10},\\ p_{n}=\\frac{7}{10}p_{n-1}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "p1", "label": "p_1", "correct_answer": "\\frac{3}{10}", "answer_type": "exact", "tolerance": null },
      { "key": "rec", "label": "p_n", "correct_answer": "\\frac{7}{10}p_{n-1}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Find the probability, in terms of \\(n\\), that at most \\(n\\) additional purchases are needed to redeem the gift. \\([2]\\)",
    "correct_answer": "1-\\left(\\frac{7}{10}\\right)^{n}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q10 [12] Hypothesis Testing
-- FLAG: Q10(e) critical region in terms of n — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '7025100a-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Lunch-box heights: estimates, hypothesis test and critical region$$,
  $$A production manager samples lunch boxes to check that the mean height is \(12.8\) cm. For a random sample of 48 boxes, heights \(x\) cm satisfy \(\sum(x-13)=-3.6\) and \(\sum(x-13)^{2}=12.02\).$$,
  'exact',
  $$\bar{x}\ge 12.8+\frac{0.411}{\sqrt{n}}$$,
  NULL,
  $$(a) Random: every lunch box produced that day is equally likely to be chosen, and selections are independent. (b) Since the height distribution is unknown, \(n\ge30\) lets the Central Limit Theorem apply so \(\bar X\) is approximately normal. (c) \(\bar x=13+\dfrac{-3.6}{48}=12.925\); \(s^{2}=\dfrac{1}{47}\left(12.02-\dfrac{(-3.6)^{2}}{48}\right)=0.25\). (d) \(H_{0}:\mu=12.8\) vs \(H_{1}:\mu\ne12.8\). Under \(H_{0}\), \(\bar X\sim N\!\left(12.8,\tfrac{0.25}{48}\right)\); \(z_{\text{stat}}=1.732\), \(p\text{-value}=0.0833<0.10\), so reject \(H_{0}\): there is sufficient evidence at the \(10\%\) level that the mean height is not \(12.8\) cm. (e) With variance \(0.04\), one-tailed \(H_{1}:\mu>12.8\) at \(2\%\): critical region \(\bar x\ge12.8+\dfrac{0.411}{\sqrt{n}}\).$$,
  12,
  'NJC H2 Math Prelim 2025',
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
    "prompt_latex": "Explain why the manager should take a sample of at least 30 lunch boxes to carry out a hypothesis test. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Calculate the unbiased estimates of the population mean and variance of the height of the lunch boxes. \\([2]\\)",
    "correct_answer": "\\bar{x}=12.925,\\ s^{2}=0.25",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "mean", "label": "\\text{mean}", "correct_answer": "12.925", "answer_type": "exact", "tolerance": null },
      { "key": "var", "label": "\\text{variance}", "correct_answer": "0.25", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "The production manager claims that the mean height of the lunch boxes is 12.8 cm. Test his claim at the 10% level of significance, stating the hypotheses clearly. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "The production line is replaced so the population variance is reduced to \\(0.04\\) cm\\(^{2}\\). A hypothesis test at the 2% level (hoping the mean does not exceed 12.8 cm) uses another random sample of \\(n\\) lunch boxes. Assuming \\(n\\) is sufficiently large, find the critical region for this test in terms of \\(n\\). \\([4]\\)",
    "correct_answer": "\\bar{x}\\ge 12.8+\\frac{0.411}{\\sqrt{n}}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q11 [12] Normal Distribution
-- FLAG: Q11(b) range of c (inequality) — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '7025100b-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Fasting glucose: normal distribution and combinations$$,
  $$The fasting glucose concentration (mmol/L) of a randomly chosen man is \(X\sim N(5.4,0.5^{2})\) and of a randomly chosen woman is \(Y\sim N(5.0,0.3^{2})\).$$,
  'range',
  $$0.814$$,
  0.002,
  $$(a) \(X-Y\sim N(0.4,\ 0.5^{2}+0.3^{2})=N(0.4,0.34)\); \(P(X>Y)=P(X-Y>0)=0.754\) (3 s.f.). Assumption: the man's and woman's concentrations are independent. (b) \(P(X-5.4\ge c)\le0.03\Rightarrow P\!\left(Z\ge\tfrac{c}{0.5}\right)\le0.03\Rightarrow\tfrac{c}{0.5}\ge1.8808\Rightarrow c\ge0.940\) (3 s.f.). (c) \(\bar Y\sim N\!\left(5.0,\tfrac{0.3^{2}}{4}\right)=N(5.0,0.0225)\). For \(k>5.4\), \(p_{1}=P(X>k)=P\!\left(Z>\tfrac{k-5.4}{0.5}\right)\), \(p_{2}=P(\bar Y>k)=P\!\left(Z>\tfrac{k-5.0}{0.15}\right)\); since \(\tfrac{k-5.0}{0.15}>\tfrac{k-5.4}{0.5}\), \(p_{1}>p_{2}\). (d)/(e) \(G=18.0X\sim N(97.2,\ 18^{2}\cdot0.5^{2})=N(97.2,81)\); \(P(79<G<106)=0.814\) (3 s.f.).$$,
  12,
  'NJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "If one man and one woman are chosen randomly, find the probability that the man's fasting glucose concentration exceeds the woman's. State an assumption you make in your calculation. \\([3]\\)",
    "correct_answer": "0.754",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "b",
    "prompt_latex": "The fasting glucose concentration of at most \\(3\\%\\) of men exceeds \\(5.4\\) mmol/L by \\(c\\) mmol/L. Find the range of \\(c\\). \\([2]\\)",
    "correct_answer": "c\\ge 0.940",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "For \\(k>5.4\\), explain which of the following has a larger value: \\(p_{1}\\), the probability that the concentration of a randomly chosen man is greater than \\(k\\); or \\(p_{2}\\), the probability that the mean concentration of four randomly chosen women is greater than \\(k\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Concentration can also be measured in mg/dL, where \\(1\\) mmol/L \\(=18.0\\) mg/dL. The random variable \\(G\\) denotes the concentration, in mg/dL, of a randomly chosen man. Draw a sketch to show the distribution of \\(G\\), including the main features of the curve. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "On your sketch, shade the region represented by \\(P(79<G<106)\\) and state its value. \\([2]\\)",
    "correct_answer": "0.814",
    "answer_type": "range",
    "tolerance": 0.002
  }
]$$::jsonb
);
