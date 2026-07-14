-- Migration 079: VJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (24 questions)
-- Source: VJC_9758_2025_Prelim_P1.pdf / P1_Solutions.pdf, P2.pdf / P2_Solutions.pdf.
-- Question IDs: Paper 1 = 5025 00NN, Paper 2 = 5025 10NN (prefix '5025' — next unused 4-hex-digit
-- slot, descending after NYJC '6025'/NJC '7025'; a-f taken by ACJC/CJC/HCI/DHS/RI/YIJC, '9025' EJC,
-- '8025' JPJC, 'cafe' ASRJC). NN is hex (Q10=0a, Q11=0b, Q12=0c).
-- Top-level (i)/(ii) parts are relabelled a/b/c per house style (matches RI/JPJC/NJC/NYJC); genuine
-- two-level (a)(i) uses "ai"/"aii" etc.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Solution formatting: each part label of a multi-part solution starts a NEW paragraph — every
-- solution_latex below embeds a blank line before each "(a)", "(b)", ... so the Solution tab
-- (PracticePage splits solution_latex on \n\n+) renders each part on its own line.
-- Grading conventions (skills.md): clean scalars/fractions -> exact; decimals (probabilities, angles,
-- lengths, GC estimates) -> range with tolerance; indefinite integrals & particular/general DE answers
-- -> null (revealed); proofs / "show that" / sketch / "describe"/"explain"/"comment"/"state assumption"/
-- hypothesis conclusions -> null. Two-valued/vector-valued answers left null per house convention.
-- Brittle-but-clean forms (inequalities, sets, ratios, complex numbers, in-terms-of-a series/expressions,
-- plane/regression equations) are graded with a "-- FLAG:" note. Sketch parts get solution_graph specs
-- in migration 080; given prompt diagrams get prompt_graph specs in migration 081.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q1 [3]+[2] Inequalities — solve inequality, hence set of values (ln x)
-- FLAG: both parts are inequality/set forms (brittle) graded exact on the canonical form.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Rational inequality and a logarithmic substitution$$,
  $$$$,
  'exact',
  $$0<x<e^{-1}\ \text{or}\ x>e^{\frac{1}{4}}$$,
  NULL,
  $$(a) \(\dfrac{4x-3}{4x^{2}+3x-1}\le1\Rightarrow\dfrac{4x-3}{4x^{2}+3x-1}-1\le0\Rightarrow\dfrac{-4x^{2}+x-2}{(x+1)(4x-1)}\le0\Rightarrow\dfrac{4x^{2}-x+2}{(x+1)(4x-1)}\ge0\). Since \(4x^{2}-x+2=4\left(x-\tfrac18\right)^{2}+\tfrac{31}{16}>0\) for all real \(x\), we need \((x+1)(4x-1)>0\), giving \(x<-1\) or \(x>\dfrac14\).

(b) Replacing \(x\) with \(\ln x\): \(\ln x<-1\) or \(\ln x>\dfrac14\), i.e. \(0<x<e^{-1}\) or \(x>e^{\frac14}\).$$,
  5,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Using an algebraic method, solve the inequality \\(\\dfrac{4x-3}{4x^{2}+3x-1}\\le1\\). \\([3]\\)",
    "correct_answer": "x<-1\\ \\text{or}\\ x>\\dfrac{1}{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence, find the set of values of \\(x\\) that satisfy \\(\\dfrac{4\\ln x-3}{4(\\ln x)^{2}+3\\ln x-1}\\le1\\). \\([2]\\)",
    "correct_answer": "0<x<e^{-1}\\ \\text{or}\\ x>e^{\\frac{1}{4}}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q2 [3]+[1]+[2]+[2] Functions
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250002-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  2,
  $$Iterates of a function and a composite range$$,
  $$The function \(\mathrm{f}\) is defined by \(\mathrm{f}:x\mapsto\dfrac{x-1}{x},\ x\in\mathbb{R},\ x\neq0,\ x\neq1\).$$,
  'exact',
  $$\frac{\pi}{2}$$,
  NULL,
  $$(a) \(\mathrm{f}^{-1}(x)=\dfrac{1}{1-x}\). \(\mathrm{f}^{2}(x)=\mathrm{f}\!\left(\dfrac{x-1}{x}\right)=\dfrac{\frac{x-1}{x}-1}{\frac{x-1}{x}}=\dfrac{-1}{x-1}=\dfrac{1}{1-x}=\mathrm{f}^{-1}(x)\).

(b) \(\mathrm{f}^{3}(x)=\mathrm{f}\,\mathrm{f}^{2}(x)=\mathrm{f}\,\mathrm{f}^{-1}(x)=x\).

(c) \(\mathrm{f}^{2030}(5)=\mathrm{f}^{3(676)+2}(5)=\mathrm{f}^{2}(5)=\dfrac{1}{1-5}=-\dfrac14\).

(d) Range of \(\mathrm{g}=[0,1)=\) domain of \(\mathrm{h}\). With \(\mathrm{h}(x)=-\sin ax\), the range of \(\mathrm{hg}\) is \((-1,0]\) when \(\dfrac{\pi}{2a}=1\), so \(a=\dfrac{\pi}{2}\).$$,
  8,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\mathrm{f}^{2}(x)=\\mathrm{f}^{-1}(x)\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(\\mathrm{f}^{3}(x)\\) in simplified form. \\([1]\\)",
    "correct_answer": "x",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find \\(\\mathrm{f}^{2030}(5)\\). \\([2]\\)",
    "correct_answer": "-\\frac{1}{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "The functions \\(\\mathrm{g}\\) and \\(\\mathrm{h}\\) are defined by \\(\\mathrm{g}:x\\mapsto\\dfrac{x-1}{x},\\ x\\in\\mathbb{R},\\ x\\ge1\\), and \\(\\mathrm{h}:x\\mapsto-\\sin ax,\\ x\\in\\mathbb{R}\\), where \\(a\\) is a positive constant. Find the value of \\(a\\) given that the range of \\(\\mathrm{hg}\\) is \\((-1,0]\\). \\([2]\\)",
    "correct_answer": "\\frac{\\pi}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q3 [4]+[3]+[3] Vector (Basic)
-- FLAG: Q3(a) ratio graded as the string "5:1". Q3(c) length-in-terms-of-|b| + foot vector left null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250003-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Triangle areas by cross product; collinearity; foot of perpendicular$$,
  $$Referred to the origin \(O\), points \(A\) and \(B\) have position vectors \(\mathbf{a}\) and \(\mathbf{b}\) respectively. Point \(C\) lies on \(OA\) such that \(OC:CA=2:1\). Point \(D\) lies on \(OB\) such that \(OD:DB=\lambda:\mu\). It is given that the area of triangle \(ABD\) is half the area of triangle \(ABC\).$$,
  'exact',
  $$5:1$$,
  NULL,
  $$(a) \(\text{Area }ABD=\tfrac12\left|\overrightarrow{DB}\times\overrightarrow{AB}\right|=\tfrac12\left|\dfrac{\mu}{\lambda+\mu}\mathbf{b}\times(\mathbf{b}-\mathbf{a})\right|=\dfrac{\mu}{2(\lambda+\mu)}\left|\mathbf{a}\times\mathbf{b}\right|\). \(\text{Area }ABC=\tfrac12\left|\overrightarrow{CA}\times\overrightarrow{AB}\right|=\tfrac16\left|\mathbf{a}\times\mathbf{b}\right|\). Setting \(\text{Area }ABD=\tfrac12\,\text{Area }ABC\): \(\dfrac{\mu}{2(\lambda+\mu)}=\dfrac{1}{12}\Rightarrow6\mu=\lambda+\mu\Rightarrow\lambda=5\mu\), so \(\lambda:\mu=5:1\).

(b) With \(\lambda:\mu=5:1\), \(\overrightarrow{OD}=\tfrac56\mathbf{b}\), so \(\overrightarrow{AD}=-\mathbf{a}+\tfrac56\mathbf{b}\). Also \(\overrightarrow{AE}=\tfrac14\mathbf{a}+\tfrac58\mathbf{b}-\mathbf{a}=-\tfrac34\mathbf{a}+\tfrac58\mathbf{b}\). Since \(\overrightarrow{AD}=\tfrac43\overrightarrow{AE}\) and \(A\) is common, \(A\), \(E\) and \(D\) are collinear.

(c) \(O\) on the perpendicular bisector of \(AB\Rightarrow|\mathbf{a}|=|\mathbf{b}|\). Length of projection of \(\mathbf{a}\) on \(\mathbf{b}=\dfrac{|\mathbf{a}\cdot\mathbf{b}|}{|\mathbf{b}|}=|\mathbf{a}|\cos\tfrac{\pi}{4}=\dfrac{1}{\sqrt2}|\mathbf{b}|\). Then \(\overrightarrow{OF}=\left(\dfrac{1}{\sqrt2}|\mathbf{b}|\right)\dfrac{\mathbf{b}}{|\mathbf{b}|}=\dfrac{1}{\sqrt2}\mathbf{b}\).$$,
  10,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the area of triangle \\(ABD\\) is given by \\(\\dfrac{\\mu}{2(\\lambda+\\mu)}\\left|\\mathbf{a}\\times\\mathbf{b}\\right|\\). Hence find the ratio \\(\\lambda:\\mu\\). \\([4]\\)",
    "correct_answer": "5:1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The point \\(E\\) has position vector \\(\\dfrac{1}{4}\\mathbf{a}+\\dfrac{5}{8}\\mathbf{b}\\). Show that \\(A\\), \\(E\\) and \\(D\\) are collinear. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is further given that the angle \\(AOB\\) is \\(\\dfrac{\\pi}{4}\\) and \\(O\\) lies on the perpendicular bisector of the line segment \\(AB\\). Find the length of projection of \\(\\mathbf{a}\\) on \\(\\mathbf{b}\\), giving your answer in terms of \\(|\\mathbf{b}|\\). Hence find the position vector of the point \\(F\\), the foot of perpendicular from \\(A\\) to \\(OB\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q4 [2]+[2]+[2] Sequences & Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250004-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Recurrence behaviour; a second-difference arithmetic progression$$,
  $$$$,
  'exact',
  $$\frac{1}{5}$$,
  NULL,
  $$(a)(i) When \(p=1\): \(u_{1}=1,\ u_{2}=\tfrac59,\ u_{3}=\tfrac{25}{49},\ u_{4}=\tfrac{125}{249},\ldots\). The sequence is decreasing and converges to \(\dfrac12\).

(a)(ii) From \(u_{n+1}=\dfrac{5u_{n}}{8u_{n}+1}\), \(\dfrac{1}{u_{n+1}}=\dfrac85+\dfrac{1}{5u_{n}}\); working backwards with the GC from \(u_{6}=\dfrac{3125}{6253}\) gives \(u_{1}=\dfrac15\), so \(p=\dfrac15\).

(b) \(w_{n+1}-w_{n}=(v_{n+2}-v_{n+1})-(v_{n+1}-v_{n})=v_{n+2}-2v_{n+1}+v_{n}=k\), a constant. Since consecutive terms differ by a constant, \(\{w_{n}\}\) is an arithmetic progression.$$,
  6,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "A sequence is such that \\(u_{1}=p\\), where \\(p\\) is a constant and \\(u_{n+1}=\\dfrac{5u_{n}}{8u_{n}+1}\\), for \\(n\\ge1\\). Describe how the sequence behaves when \\(p=1\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "Find the value of \\(p\\) for which \\(u_{6}=\\dfrac{3125}{6253}\\). \\([2]\\)",
    "correct_answer": "\\frac{1}{5}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Another sequence \\(v_{1},v_{2},v_{3},\\ldots\\) is such that for all \\(n\\ge1\\), \\(v_{n+2}-2v_{n+1}+v_{n}=k\\), where \\(k\\) is a constant. Let \\(w_{n}=v_{n+1}-v_{n}\\) for \\(n\\ge1\\). Explain why the sequence \\(\\{w_{n}\\}\\) is an arithmetic progression. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q5 [3]+[1]+[1]+[2] Conics (periodic function sketch + hyperbola intersection)
-- FLAG: Q5(d) range of a graded exact on "a>=3". Q5(a) sketch -> solution_graph in 080.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250005-0000-0000-0000-000000000000',
  'aaaa0004-0000-0000-0000-000000000000',
  3,
  $$Periodic semicircle function and a hyperbola$$,
  $$The function \(\mathrm{f}\) is given by \[\mathrm{f}(x)=\begin{cases}2+\sqrt{2^{2}-(x-2)^{2}}, & 0<x\le4,\\ 2-\sqrt{2^{2}-(x-6)^{2}}, & 4<x\le8.\end{cases}\] It is given that \(\mathrm{f}(x)=\mathrm{f}(x+8)\) for all real values of \(x\). The curve \(C\) has equation \(\dfrac{(y-3)^{2}}{a^{2}}-(x+2)^{2}=1\), where \(a\) is a positive real constant.$$,
  'exact',
  $$a\ge3$$,
  NULL,
  $$(a) The graph is periodic with period \(8\): on \((0,4]\) it is the upper semicircle of centre \((2,2)\), radius \(2\); on \((4,8]\) the lower semicircle of centre \((6,2)\), radius \(2\). Over \(-6\le x\le7\) the end points are \((-6,4)\) and \((7,2-\sqrt3)\); it cuts the axes at \((-2,0)\), \((0,2)\) and \((6,0)\), with high/low points \((2,4)\) and \((6,0)\).

(b) Area \(=2\times4+\tfrac12\pi(2^{2})=8+2\pi\).

(c) \(\dfrac{(y-3)^{2}}{a^{2}}=(x+2)^{2}\Rightarrow y-3=\pm a(x+2)\), so the asymptotes are \(y=3+a(x+2)\) and \(y=3-a(x+2)\).

(d) \(C\) is a hyperbola centred at \((-2,3)\) with vertices \((-2,3+a)\) and \((-2,3-a)\). When \(a=3\) there is exactly one intersection, at \((-2,0)\). Hence there is at most one intersection between \(C\) and \(y=\mathrm{f}(x)\) when \(a\ge3\).$$,
  7,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "On the diagram, sketch the graph of \\(y=\\mathrm{f}(x)\\) for \\(-6\\le x\\le7\\), indicating clearly the coordinates of the end points and the points where the graph cuts the axes. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Without integrating, write down the exact area of the region bounded by \\(y=\\mathrm{f}(x)\\), the line \\(x=4\\), the \\(x\\)-axis and the \\(y\\)-axis. \\([1]\\)",
    "correct_answer": "8+2\\pi",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "State the equations of the asymptotes of \\(C\\) in terms of \\(a\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Determine the range of values of \\(a\\) if there is at most one intersection between \\(C\\) and the graph of \\(y=\\mathrm{f}(x)\\). \\([2]\\)",
    "correct_answer": "a\\ge3",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q6 [2]+[2]+[2]+[2] Sequences & Series (method of differences result given)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250006-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Bounding, convergence and a re-indexed sum$$,
  $$It is given that \(\displaystyle\sum_{r=2}^{n}\dfrac{1}{r(r^{2}-1)}=\dfrac{1}{4}+\dfrac{1}{2(n+1)}-\dfrac{1}{2n}\).$$,
  'exact',
  $$27$$,
  NULL,
  $$(a) \(\dfrac{1}{2(n+1)}-\dfrac{1}{2n}=\dfrac{-1}{2n(n+1)}<0\) for all \(n\ge2\), so \(\displaystyle\sum_{r=2}^{n}\dfrac{1}{r(r^{2}-1)}=\dfrac14+\left(\text{negative}\right)<\dfrac14\).

(b) As \(n\to\infty\), \(\dfrac{1}{2(n+1)}\to0\) and \(\dfrac{1}{2n}\to0\), so the sum \(\to\dfrac14\), a constant. Hence the series converges and its value is \(\dfrac14\).

(c) \(\left|\dfrac{1}{2(n+1)}-\dfrac{1}{2n}\right|<0.0007\). By GC, \(n=26\) gives \(0.000712>0.0007\) and \(n=27\) gives \(0.000661<0.0007\). The smallest value of \(n\) is \(27\).

(d) Let \(s=r-m\): \(\displaystyle\sum_{r=m+1}^{N}\dfrac{1}{(r-m)(r-m+1)(r-m+2)}=\sum_{r=2}^{N-m+1}\dfrac{1}{r(r^{2}-1)}=\dfrac14+\dfrac{1}{2(N-m+2)}-\dfrac{1}{2(N-m+1)}\).$$,
  8,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\displaystyle\\sum_{r=2}^{n}\\dfrac{1}{r(r^{2}-1)}\\) is less than \\(\\dfrac{1}{4}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Give a reason why the series \\(\\displaystyle\\sum_{r=2}^{\\infty}\\dfrac{1}{r(r^{2}-1)}\\) converges, and write down its value. \\([2]\\)",
    "correct_answer": "\\frac{1}{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the smallest value of \\(n\\) for which \\(\\displaystyle\\sum_{r=2}^{n}\\dfrac{1}{r(r^{2}-1)}\\) differs from \\(\\displaystyle\\sum_{r=2}^{\\infty}\\dfrac{1}{r(r^{2}-1)}\\) by less than \\(0.0007\\). \\([2]\\)",
    "correct_answer": "27",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find \\(\\displaystyle\\sum_{r=m+1}^{N}\\dfrac{1}{(r-m)(r-m+1)(r-m+2)}\\), where \\(m\\) and \\(N\\) are integers with \\(N>m>0\\). (There is no need to express your answer as a single algebraic fraction.) \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q7 [3]+[4]+[2] Complex Numbers (no calculator)
-- FLAG: Q7(a) single complex value graded exact "15-20i". Q7(b)(i) two complex roots left null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250007-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Modulus equation and cube roots on a circle$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$1$$,
  NULL,
  $$(a) Let \(z=a+b\mathrm{i}\). \(\dfrac{4|z|}{15-z^{*}}=5\mathrm{i}\Rightarrow4\sqrt{a^{2}+b^{2}}=5\mathrm{i}(15-(a-b\mathrm{i}))=-5b+(75-5a)\mathrm{i}\). Comparing parts: \(75-5a=0\Rightarrow a=15\) and \(4\sqrt{a^{2}+b^{2}}=-5b\Rightarrow16(225+b^{2})=25b^{2}\Rightarrow9b^{2}=3600\Rightarrow b=-20\) (since \(b<0\)). So \(z=15-20\mathrm{i}\).

(b)(i) \((w-\mathrm{i})^{3}=-\mathrm{i}\Rightarrow w^{3}-3\mathrm{i}w^{2}-3w+2\mathrm{i}=0=(w-2\mathrm{i})(w^{2}-\mathrm{i}w-1)\). Solving \(w^{2}-\mathrm{i}w-1=0\): \(w=\dfrac{\mathrm{i}\pm\sqrt{(-\mathrm{i})^{2}-4(-1)}}{2}=\dfrac{\mathrm{i}\pm\sqrt3}{2}\), i.e. \(w=\dfrac{\sqrt3}{2}+\dfrac12\mathrm{i}\) or \(-\dfrac{\sqrt3}{2}+\dfrac12\mathrm{i}\).

(b)(ii) With \(A=k\mathrm{i}\), setting \(W_{1}A=W_{2}A\): \(\left|\dfrac{\sqrt3+\mathrm{i}}{2}-k\mathrm{i}\right|=|2\mathrm{i}-k\mathrm{i}|\Rightarrow\tfrac34+\left(\tfrac12-k\right)^{2}=(2-k)^{2}\Rightarrow k=1\). Then \(W_{1}A=W_{2}A=W_{3}A=1\), so the three points lie on a circle of radius \(1\) centred at \(A\) (with \(k=1\)).$$,
  9,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the complex number \\(z\\) which satisfies the equation \\(\\dfrac{4|z|}{15-z^{*}}=5\\mathrm{i}\\). \\([3]\\)",
    "correct_answer": "15-20i",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "The complex number \\(w\\) is such that \\((w-\\mathrm{i})^{3}=-\\mathrm{i}\\). Given that one possible value of \\(w\\) is \\(2\\mathrm{i}\\), find the two other possible values of \\(w\\). Give your answers in cartesian form \\(a+b\\mathrm{i}\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "The points \\(W_{1}\\), \\(W_{2}\\) and \\(W_{3}\\) on the Argand diagram represent the three roots of the equation \\((w-\\mathrm{i})^{3}=-\\mathrm{i}\\), and the point \\(A\\) represents the complex number \\(k\\mathrm{i}\\), where \\(k\\) is a positive real number. Show that the points \\(W_{1}\\), \\(W_{2}\\) and \\(W_{3}\\) lie on a circle with centre \\(A\\) for some value of \\(k\\), stating the value of \\(k\\). \\([2]\\)",
    "correct_answer": "1",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q8 [5]+[2]+[2] Transformation (+ derivative graph, area)
-- Q8(a) multi-box a,b (equation of C shown in solution). Q8(b)(i) sketch -> solution_graph in 080
-- (stand-in g reused as prompt_graph in 081).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250008-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  3,
  $$Reverse transformations; sketch and area under g'$$,
  $$$$,
  'exact',
  $$3$$,
  NULL,
  $$(a) Reversing B (replace \(x\) with \(\tfrac{x}{2}\)) then A (replace \(y\) with \(-y\)) on \(y=ax^{2}+\dfrac{b}{x}\) gives \(\mathrm{f}(x)=-\dfrac{ax^{2}}{4}-\dfrac{2b}{x}\). Since \(\left(-1,\tfrac13\right)\) is a turning point of \(y=\dfrac{1}{\mathrm{f}(x)}\), \((-1,3)\) is a turning point of \(y=\mathrm{f}(x)\): \(-\dfrac{a}{4}+2b=3\) and \(\dfrac12 a+2b=0\). Solving, \(a=-4\), \(b=1\), and the resulting curve \(y=-4x^{2}+\dfrac1x\) reverses to \(C:\ y=x^{2}-\dfrac{2}{x}\).

(b)(i) \(y=\mathrm{g}'(x)\) passes through \((-2,0)\) (the minimum of \(\mathrm{g}\)) with asymptotes \(x=2\) and \(y=0\).

(b)(ii) Required area \(=-\displaystyle\int_{-4}^{-2}\mathrm{g}'(x)\,dx=-\big[\mathrm{g}(-2)-\mathrm{g}(-4)\big]=-[-3-0]=3\) units\(^{2}\).$$,
  9,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "A curve \\(C\\) with equation \\(y=\\mathrm{f}(x)\\) undergoes in succession the following transformations. A: A reflection in the \\(x\\)-axis. B: A stretch parallel to the \\(x\\)-axis with scale factor \\(\\dfrac{1}{2}\\), with the \\(y\\)-axis invariant. The resulting curve has equation \\(y=ax^{2}+\\dfrac{b}{x}\\), where \\(a\\) and \\(b\\) are real constants. Given that \\(\\left(-1,\\dfrac{1}{3}\\right)\\) is a turning point of \\(y=\\dfrac{1}{\\mathrm{f}(x)}\\), find the values of \\(a\\) and \\(b\\) and state the equation of \\(C\\). \\([5]\\)",
    "correct_answer": "a=-4,\\ b=1,\\ C:\\ y=x^{2}-\\frac{2}{x}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-4", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "1", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "The diagram shows the curve \\(y=\\mathrm{g}(x)\\). The curve has a minimum point at \\((-2,-3)\\) and crosses the \\(x\\)-axis at \\((-1,0)\\) and \\((-4,0)\\). The line \\(x=2\\) is the vertical asymptote and the line \\(y=3\\) is the horizontal asymptote. Sketch the graph of \\(y=\\mathrm{g}'(x)\\), labelling the coordinates of all relevant point(s) and state the equations of any asymptotes. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Find the area of the region bounded by the graph of \\(y=\\mathrm{g}'(x)\\), the lines \\(x=-4\\), \\(x=-2\\) and the \\(x\\)-axis. \\([2]\\)",
    "correct_answer": "3",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q9 [5]+[3] Definite Integral (area + volume of revolution). Given region diagram -> prompt_graph in 081.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50250009-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Area and volume for a sideways parabola region$$,
  $$The region \(R\) is bounded by the curve \(C\) with equation \(x=6-(y-2)^{2}\), the lines \(y=8\), \(y=2-x\) and the \(y\)-axis. The region \(S\) is bounded by \(C\) and the line \(y=2-x\). The curve \(C\) passes through the point \((6,2)\).$$,
  'range',
  $$327.25$$,
  0.005,
  $$(a) Intersection of \(C\) and \(y=2-x\): \(2-y=6-(y-2)^{2}\Rightarrow y^{2}-5y=0\Rightarrow y=0\) or \(5\). On the \(y\)-axis \((x=0)\): \(y=2\pm\sqrt6\). Integrating with respect to \(y\), Area of \(R=-\left[\displaystyle\int_{2+\sqrt6}^{5}\left(6-(y-2)^{2}\right)dy+\int_{5}^{8}(2-y)\,dy\right]=\dfrac{9}{2}+4\sqrt6\) units\(^{2}\).

(b) Writing \(y=2\pm\sqrt{6-x}\), Volume \(=\pi\displaystyle\int_{-3}^{6}\left(2+\sqrt{6-x}\right)^{2}dx-\pi\int_{-3}^{2}(2-x)^{2}\,dx-\pi\int_{2}^{6}\left(2-\sqrt{6-x}\right)^{2}dx=327.25\) units\(^{3}\).$$,
  8,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the exact area of region \\(R\\). \\([5]\\)",
    "correct_answer": "\\frac{9}{2}+4\\sqrt{6}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the volume of the solid of revolution formed when region \\(S\\) is rotated through \\(360^{\\circ}\\) about the \\(x\\)-axis, leaving your answer to 2 decimal places. \\([3]\\)",
    "correct_answer": "327.25",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P1 Q10 [1]+[4]+[3] Integration Technique
-- Q10(a)(i) multi-box A,B. Q10(a)(ii) indefinite integral left null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025000a-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Linear-over-quadratic integral and integration by parts$$,
  $$$$,
  'exact',
  $$\frac{\pi}{12}+\frac{\sqrt{3}}{8}$$,
  NULL,
  $$(a)(i) \(1+4x=A(2x-2)+B\Rightarrow2A=4,\ B-2A=1\Rightarrow A=2,\ B=5\), so \(1+4x=2(2x-2)+5\).

(a)(ii) \(\displaystyle\int\dfrac{1+4x}{x^{2}-2x+5}\,dx=2\displaystyle\int\dfrac{2x-2}{x^{2}-2x+5}\,dx+5\displaystyle\int\dfrac{1}{(x-1)^{2}+4}\,dx=2\ln(x^{2}-2x+5)+\dfrac52\tan^{-1}\dfrac{x-1}{2}+C\).

(b) \(\displaystyle\int_{0}^{\pi/3}x\sin2x\,dx=\left[-\tfrac12 x\cos2x\right]_{0}^{\pi/3}+\tfrac12\displaystyle\int_{0}^{\pi/3}\cos2x\,dx=\left[-\tfrac12 x\cos2x\right]_{0}^{\pi/3}+\tfrac14\big[\sin2x\big]_{0}^{\pi/3}=\dfrac{\pi}{12}+\dfrac{\sqrt3}{8}\).$$,
  8,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "Express \\(1+4x\\) in the form \\(A(2x-2)+B\\), where \\(A\\) and \\(B\\) are constants to be determined. \\([1]\\)",
    "correct_answer": "A=2,\\ B=5",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "A", "label": "A", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "B", "label": "B", "correct_answer": "5", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "aii",
    "prompt_latex": "Hence, find \\(\\displaystyle\\int\\dfrac{1+4x}{x^{2}-2x+5}\\,dx\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the exact value of \\(\\displaystyle\\int_{0}^{\\pi/3}x\\sin2x\\,dx\\). \\([3]\\)",
    "correct_answer": "\\frac{\\pi}{12}+\\frac{\\sqrt{3}}{8}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q11 [3]+[5]+[2] Differential Equations
-- FLAG: Q11(a) f(u) graded exact on the reduced RHS. Q11(b) particular solution left null (revealed,
-- exponential+log expression). Q11(c) sketch -> solution_graph in 080.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025000b-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Substitution reduction and particular solution of a DE$$,
  $$It is given that \(2\dfrac{dy}{dx}+\dfrac{2}{x}-\ln x=y\).$$,
  'exact',
  $$\frac{1}{2}u\ln u$$,
  NULL,
  $$(a) With \(y=\ln\!\left(\dfrac{u}{x}\right)=\ln u-\ln x\), \(\dfrac{dy}{dx}=\dfrac1u\dfrac{du}{dx}-\dfrac1x\). Substituting into the DE: \(2\left(\dfrac1u\dfrac{du}{dx}-\dfrac1x\right)+\dfrac2x-\ln x=\ln u-\ln x\Rightarrow\dfrac2u\dfrac{du}{dx}=\ln u\Rightarrow\dfrac{du}{dx}=\dfrac12 u\ln u\). So \(\mathrm{f}(u)=\dfrac12 u\ln u\).

(b) \(\displaystyle\int\dfrac{1}{u\ln u}\,du=\displaystyle\int\dfrac12\,dx\Rightarrow\ln|\ln u|=\dfrac x2+C\Rightarrow\ln u=A\mathrm{e}^{x/2}\). Then \(y=\ln u-\ln x=A\mathrm{e}^{x/2}-\ln x\). Since \(y\) is minimum at \(x=3\), \(\dfrac{dy}{dx}=\dfrac A2\mathrm{e}^{x/2}-\dfrac1x=0\Rightarrow A=\dfrac23\mathrm{e}^{-3/2}=0.14875\). Hence \(y=0.149\mathrm{e}^{x/2}-\ln x\).

(c) The curve has a minimum at \((3,-0.432)\), cuts the \(x\)-axis near \(x=1.34\) and \(x=4.68\), and has the vertical asymptote \(x=0\).$$,
  10,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Use the substitution \\(y=\\ln\\!\\left(\\dfrac{u}{x}\\right)\\) to show that the differential equation can be reduced to \\(\\dfrac{du}{dx}=\\mathrm{f}(u)\\), where the function \\(\\mathrm{f}(u)\\) is to be found. \\([3]\\)",
    "correct_answer": "\\frac{1}{2}u\\ln u",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(y\\) has a minimum value at \\(x=3\\), solve the differential equation \\(2\\dfrac{dy}{dx}+\\dfrac{2}{x}-\\ln x=y\\), to find the particular solution for \\(y\\) in terms of \\(x\\). \\([5]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Sketch the graph of this particular solution. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q12 [3]+[2]+[2]+[2]+[3] Sequences & Series (AP/GP application)
-- FLAG: Q12(d) range of r graded exact on "r>1.25". Q12(e) "determine if" conclusion left null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025000c-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Dosing pumps: geometric and arithmetic progressions$$,
  $$A chemical processing plant uses two dosing pumps, Pump A and Pump B, each tested over a 10-hour trial period. Pump A dosed \(4.5\) litres in the first hour, and for each subsequent hour the volume dosed decreased by a constant percentage \(r\%\). Pump B dosed \(4.7\) litres in the first hour, and for each subsequent hour the volume dosed decreased by \(0.1\) litres.$$,
  'exact',
  $$r>1.25$$,
  NULL,
  $$(a) Pump A dosing forms a GP with first term \(4.5\) and common ratio \(1-\dfrac{r}{100}\). Total over \(10\) hours \(=\dfrac{4.5\left[1-\left(1-\frac{r}{100}\right)^{10}\right]}{1-\left(1-\frac{r}{100}\right)}=\dfrac{450}{r}\left[1-\left(1-\dfrac{r}{100}\right)^{10}\right]\), so \(k=10\).

(b) Pump B total \(=\dfrac{10}{2}\left[2(4.7)+9(-0.1)\right]=42.5\). Setting \(\dfrac{450}{r}\left[1-\left(1-\frac{r}{100}\right)^{10}\right]=42.5\), by GC \(r=1.2771\approx1.28\).

(c) With \(r=1\): \(4.5(0.99)^{n-1}\ge4.0\Rightarrow n\le12.719\). Pump A should operate for \(12\) complete hours.

(d) Running continuously, Pump A's total tends to \(\dfrac{4.5}{r/100}=\dfrac{450}{r}\). The supplier's claim is invalid when \(\dfrac{450}{r}<360\Rightarrow r>1.25\).

(e) Pump B total over \(n\) hours \(=\dfrac{n}{2}\left[2(4.7)+(n-1)(-0.1)\right]=4.75n-0.05n^{2}\). Then \(4.75n-0.05n^{2}\ge150\Rightarrow0.05n^{2}-4.75n+150\le0\); the discriminant \((-4.75)^{2}-4(0.05)(150)=-7.43<0\) with positive leading coefficient, so there is no real \(n\). Hence Pump B can never dose at least \(150\) litres.$$,
  12,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the total volume of liquid dosed by Pump A at the end of the trial period is \\(\\dfrac{450}{r}\\left[1-\\left(1-\\dfrac{r}{100}\\right)^{k}\\right]\\) litres, where \\(k\\) is a constant to be determined. \\([3]\\)",
    "correct_answer": "10",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It would be ideal if at the end of the trial period the total volume dosed by Pump A is equal to that of Pump B. Find the value of \\(r\\) for this ideal situation. \\([2]\\)",
    "correct_answer": "1.28",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "c",
    "prompt_latex": "After the trial period the pumps are reset and installed in the plant, performing as observed during the trial. Pump A is installed in Reaction Line 1 and will cease to operate if the volume dosed in the next hour falls below \\(4.0\\) litres. With \\(r=1\\), find the number of complete hours that Pump A should be in operation. \\([2]\\)",
    "correct_answer": "12",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Before operations begin in Reaction Line 2, Pump A breaks down. A supplier claims that with a new motor Pump A can dose at least \\(360\\) litres of liquid in total if it ran continuously without stopping. Determine the range of values of \\(r\\) for which the supplier's claim is invalid. \\([2]\\)",
    "correct_answer": "r>1.25",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "The company decides to use Pump B in Reaction Line 2. Using an algebraic method, determine whether Pump B can dose at least \\(150\\) litres of liquid if left to run continuously without stopping. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1 [2]+[2]+[2]+[2] Maclaurin Series
-- FLAG: Q1(a) series in terms of a graded exact on canonical form.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251001-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Series of ln(a+x), sin and cos composites$$,
  $$It is given that \(\mathrm{f}(x)=\ln(a+x)\), \(x\in\mathbb{R}\), \(x>-a\), where \(a\) is a constant.$$,
  'exact',
  $$3$$,
  NULL,
  $$(a) \(\ln(a+x)=\ln\!\left[a\left(1+\dfrac{x}{a}\right)\right]=\ln a+\dfrac{x}{a}-\dfrac{x^{2}}{2a^{2}}+\dfrac{x^{3}}{3a^{3}}+\cdots\).

(b) With \(a=1\), \(\sin[\ln(1+x)]=\sin\!\left(x-\dfrac{x^{2}}{2}+\dfrac{x^{3}}{3}-\cdots\right)=\left(x-\dfrac{x^{2}}{2}+\dfrac{x^{3}}{3}\right)-\dfrac{1}{6}x^{3}+\cdots=x-\dfrac12 x^{2}+\dfrac16 x^{3}\).

(c) Differentiating (b): \(\dfrac{1}{1+x}\cos[\ln(1+x)]=1-x+\dfrac12 x^{2}+\cdots\), so \(\cos[\ln(1+x)]=(1+x)\left(1-x+\dfrac12 x^{2}\right)=1-\dfrac12 x^{2}\).

(d) \(\displaystyle\int_{1}^{3}\left(x-\dfrac12 x^{2}+\dfrac16 x^{3}\right)dx=3\). The expansion of \(\sin[\ln(1+x)]\) is only valid for \(x\in(-1,1]\); since the integration is over \([1,3]\), which lies outside this interval, the expansion is not valid there, so the value is not a good approximation.$$,
  8,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Using the standard series from the List of Formulae (MF27), find the series expansion for \\(\\mathrm{f}(x)\\), up to and including the term in \\(x^{3}\\). \\([2]\\)",
    "correct_answer": "\\ln a+\\frac{x}{a}-\\frac{x^{2}}{2a^{2}}+\\frac{x^{3}}{3a^{3}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that \\(a=1\\). Hence, or otherwise, show that the series expansion of \\(\\sin[\\mathrm{f}(x)]\\), up to and including the term in \\(x^{3}\\), is given by \\(x-\\dfrac{1}{2}x^{2}+\\dfrac{1}{6}x^{3}\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Deduce the Maclaurin series for \\(\\cos[\\mathrm{f}(x)]\\) up to and including the term in \\(x^{2}\\). \\([2]\\)",
    "correct_answer": "1-\\frac{1}{2}x^{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find \\(\\displaystyle\\int_{1}^{3}\\left(x-\\dfrac{1}{2}x^{2}+\\dfrac{1}{6}x^{3}\\right)dx\\). Without the use of a calculator or any further calculation, explain whether this value is a good approximation to the value of \\(\\displaystyle\\int_{1}^{3}\\sin[\\mathrm{f}(x)]\\,dx\\). \\([2]\\)",
    "correct_answer": "3",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q2 [4]+[4]+[2] Applications of Differentiation. Given 3-D prism diagram -> prompt_graph in 081.
-- FLAG: Q2(b) x in terms of k graded exact on the cube-root form. Q2(c) two values -> multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251002-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  $$Minimum surface area of a trapezoidal prism$$,
  $$The diagram shows a trapezoidal prism with fixed volume \(4k\sqrt{3}\) units\(^{3}\), with variables \(x\) and \(y\). The top surface \(ABCD\) is an isosceles trapezium with \(AB\) of length \(5x\) units, \(DC\) of length \(3x\) units, \(AD=BC\) and \(\angle ABC=\angle BAD=60^{\circ}\). The rectangular sides \(ABFE\) and \(BCGF\) are perpendicular to both the top surface \(ABCD\) and the bottom surface \(EFGH\), with \(AE=BF=DH=CG=y\) units.$$,
  'range',
  $$x=2.41,\ 6.10$$,
  0.005,
  $$(a) The trapezium has height \(x\tan60^{\circ}=\sqrt3 x\) and slant side \(BC=\dfrac{x}{\cos60^{\circ}}=2x\). Volume \(=\tfrac12(5x+3x)(\sqrt3 x)\,y=4\sqrt3 x^{2}y=4\sqrt3 k\Rightarrow y=\dfrac{k}{x^{2}}\). Surface area \(A=2\left[\tfrac12(5x+3x)(\sqrt3 x)\right]+(3x+5x+2\cdot2x)y=8\sqrt3 x^{2}+12xy=8\sqrt3 x^{2}+\dfrac{12k}{x}\).

(b) \(\dfrac{dA}{dx}=16\sqrt3 x-\dfrac{12k}{x^{2}}=0\Rightarrow x^{3}=\dfrac{12k}{16\sqrt3}=\dfrac{\sqrt3 k}{4}\Rightarrow x=\left(\dfrac{\sqrt3 k}{4}\right)^{1/3}\). Since \(\dfrac{d^{2}A}{dx^{2}}=16\sqrt3+\dfrac{24k}{x^{3}}>0\), \(A\) is a minimum there.

(c) When \(V=1000\), \(k=\dfrac{250}{\sqrt3}\). Then \(800=8\sqrt3 x^{2}+\dfrac{12}{x}\cdot\dfrac{250}{\sqrt3}\); by GC, \(x=2.41\) or \(x=6.10\) (rejecting the negative root).$$,
  10,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the total external surface area \\(A\\) of the trapezoidal prism is given by \\(A=8x^{2}\\sqrt{3}+\\dfrac{12k}{x}\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Using differentiation, find the value of \\(x\\) in terms of \\(k\\) at which \\(A\\) is a minimum. \\([4]\\)",
    "correct_answer": "\\left(\\frac{\\sqrt{3}k}{4}\\right)^{\\frac{1}{3}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is given instead that the volume of the prism is \\(1000\\) units\\(^{3}\\) and its external surface area is \\(800\\) units\\(^{2}\\). Find the two possible values of \\(x\\). \\([2]\\)",
    "correct_answer": "x=2.41,\\ 6.10",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "x1", "label": "x (smaller)", "correct_answer": "2.41", "answer_type": "range", "tolerance": 0.005 },
      { "key": "x2", "label": "x (larger)", "correct_answer": "6.10", "answer_type": "range", "tolerance": 0.005 }
    ]
  }
]$$::jsonb
);

-- P2 Q3 [3]+[3]+[2]+[5] Vector (Plane)
-- Q3(a) coords -> multi-box [x,y,z]. Q3(b) two plane cartesians left null. Q3(d) grade volume (clean scalar).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251003-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Pyramid: foot of perpendicular, planes, angle and volume$$,
  $$With reference to the point \(O\) as the origin and the \(x\)-\(y\) plane as a horizontal plane, the pyramid \(OPQRV\) has a parallelogram base \(OPQR\) and height \(OV\). The position vectors of the points \(P\) and \(R\) are \(-3\mathbf{i}+4\mathbf{j}+3\mathbf{k}\) and \(5\mathbf{i}-2\mathbf{j}-\mathbf{k}\) respectively.$$,
  'exact',
  $$\frac{344}{3}$$,
  NULL,
  $$(a) \(\overrightarrow{PR}=\begin{pmatrix}8\\-6\\-4\end{pmatrix}=-2\begin{pmatrix}-4\\3\\2\end{pmatrix}\). Line \(PR:\ \mathbf{r}=\begin{pmatrix}5\\-2\\-1\end{pmatrix}+\lambda\begin{pmatrix}-4\\3\\2\end{pmatrix}\). For \(OS\) minimum, \(\overrightarrow{OS}\cdot\begin{pmatrix}-4\\3\\2\end{pmatrix}=0\Rightarrow(-20-6-2)+\lambda(16+9+4)=0\Rightarrow\lambda=\dfrac{28}{29}\). So \(\overrightarrow{OS}=\dfrac{1}{29}\begin{pmatrix}33\\26\\27\end{pmatrix}\), i.e. \(S=\left(\dfrac{33}{29},\dfrac{26}{29},\dfrac{27}{29}\right)\).

(b) \(\overrightarrow{OP}\times\overrightarrow{OR}=2\begin{pmatrix}1\\6\\-7\end{pmatrix}\), a normal to the base. With \(\mathbf{r}\cdot\begin{pmatrix}1\\6\\-7\end{pmatrix}=t\), \(\dfrac{|t|}{\sqrt{1+36+49}}=2\sqrt{86}\Rightarrow|t|=172\). The planes are \(x+6y-7z=172\) and \(x+6y-7z=-172\).

(c) \(\cos\theta=\dfrac{\left|\begin{pmatrix}1\\6\\-7\end{pmatrix}\cdot\begin{pmatrix}0\\0\\1\end{pmatrix}\right|}{\sqrt{86}}=\dfrac{7}{\sqrt{86}}\Rightarrow\theta=41.0^{\circ}\).

(d) \(\overrightarrow{OQ}=\overrightarrow{OP}+\overrightarrow{OR}=\begin{pmatrix}2\\2\\2\end{pmatrix}\). Writing \(\overrightarrow{OQ}=\overrightarrow{OV}+\overrightarrow{VQ}=a\begin{pmatrix}1\\6\\-7\end{pmatrix}+b\begin{pmatrix}0\\-5\\8\end{pmatrix}\) gives \(a=2\), so \(\overrightarrow{OV}=2\begin{pmatrix}1\\6\\-7\end{pmatrix}=\begin{pmatrix}2\\12\\-14\end{pmatrix}\). Volume \(=\dfrac13\left|(\overrightarrow{OP}\times\overrightarrow{OR})\cdot\overrightarrow{OV}\right|=\dfrac13(4+144+196)=\dfrac{344}{3}\) units\(^{3}\).$$,
  13,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the coordinates of the point \\(S\\) that lies on the line \\(PR\\) such that the distance from \\(O\\) to \\(S\\) is a minimum. \\([3]\\)",
    "correct_answer": "\\left(\\frac{33}{29},\\ \\frac{26}{29},\\ \\frac{27}{29}\\right)",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "\\frac{33}{29}", "answer_type": "exact", "tolerance": null },
      { "key": "y", "label": "y", "correct_answer": "\\frac{26}{29}", "answer_type": "exact", "tolerance": null },
      { "key": "z", "label": "z", "correct_answer": "\\frac{27}{29}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Find the cartesian equations of the planes such that the perpendicular distance from each plane to the base \\(OPQR\\) is \\(2\\sqrt{86}\\) units. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the acute angle between \\(OV\\) and the vertical. \\([2]\\)",
    "correct_answer": "41.0",
    "answer_type": "range",
    "tolerance": 0.05
  },
  {
    "label": "d",
    "prompt_latex": "Given that \\(QV\\) is parallel to the vector \\(-5\\mathbf{j}+8\\mathbf{k}\\), find the position vector of the point \\(V\\). Hence find the exact volume of the pyramid \\(OPQRV\\). \\([5]\\) [Volume of a pyramid \\(=\\dfrac{1}{3}\\times\\text{base area}\\times\\text{height}\\).]",
    "correct_answer": "\\frac{344}{3}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q4 [3]+[1]+[2]+[2]+[1] Complex Numbers (no calculator)
-- FLAG: Q4(c) complex value graded exact. Q4(a) sketch abstract (general theta) left null, no graph.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251004-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Rotation by i-sqrt3, quadrilateral area and a tangent identity$$,
  $$Do not use a calculator in answering this question. The complex number \(z\) has modulus \(1\) and argument \(\theta\), where \(\dfrac{\pi}{2}<\theta<\pi\), and the complex number \(w\) is given by \(w=\mathrm{i}\sqrt{3}\,z\). The point \(P\) on the Argand diagram represents \(z\).$$,
  'exact',
  $$\frac{1}{\sqrt{2}}$$,
  NULL,
  $$(a) \(w=\mathrm{i}\sqrt3\,z\) scales \(z\) by \(\sqrt3\) and rotates it by \(\dfrac{\pi}{2}\), so \(OQ=\sqrt3\), \(OP=1\) and angle \(POQ=90^{\circ}\); \(R\) (representing \(z-w\)) completes the rectangle \(ORPQ\) (with \(\overrightarrow{OR}=-w\)).

(b) Area of \(ORPQ=\dfrac12(1)\left(\sqrt3+\sqrt3\right)=\sqrt3\).

(c) With \(\theta=\dfrac{3\pi}{4}\): \(z=\cos\dfrac{3\pi}{4}+\mathrm{i}\sin\dfrac{3\pi}{4}=-\dfrac{1}{\sqrt2}+\dfrac{1}{\sqrt2}\mathrm{i}\).

(d) \(z-w=z-\sqrt3\,\mathrm{i}z=\left(-\dfrac{1}{\sqrt2}+\dfrac{1}{\sqrt2}\mathrm{i}\right)\left(1-\sqrt3\,\mathrm{i}\right)=\dfrac{1}{\sqrt2}\left[\left(\sqrt3-1\right)+\left(\sqrt3+1\right)\mathrm{i}\right]\), so \(k=\dfrac{1}{\sqrt2}\).

(e) \(\arg(z-w)=\dfrac{3\pi}{4}-\dfrac{\pi}{3}=\dfrac{5\pi}{12}\), so \(\tan\dfrac{5\pi}{12}=\dfrac{\sqrt3+1}{\sqrt3-1}\).$$,
  9,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "On the copy of the Argand diagram with origin \\(O\\), plot the points \\(Q\\) and \\(R\\) to represent \\(w\\) and \\(z-w\\) respectively. Show clearly the geometrical relationship between the points \\(P\\), \\(Q\\) and \\(R\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the area of the quadrilateral \\(ORPQ\\). \\([1]\\)",
    "correct_answer": "\\sqrt{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is given that \\(\\theta=\\dfrac{3\\pi}{4}\\). Find \\(z\\) in the form \\(x+y\\mathrm{i}\\), where \\(x\\) and \\(y\\) are real numbers. \\([2]\\)",
    "correct_answer": "-\\frac{1}{\\sqrt{2}}+\\frac{1}{\\sqrt{2}}i",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Show that \\(z-w=k\\left[\\left(\\sqrt{3}-1\\right)+\\left(\\sqrt{3}+1\\right)\\mathrm{i}\\right]\\), where \\(k\\) is a constant to be determined. \\([2]\\)",
    "correct_answer": "\\frac{1}{\\sqrt{2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Hence show that \\(\\tan\\dfrac{5\\pi}{12}=\\dfrac{\\sqrt{3}+1}{\\sqrt{3}-1}\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q5 [1]+[2]+[2] Permutations & Combinations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251005-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Counting codes and character-position probabilities$$,
  $$A code consists of 10 characters. The first 5 characters are formed using 5 letters chosen from the set \(\{A,B,C,D,E,F,G,H\}\) and the last 5 characters are formed using 5 digits chosen from the set \(\{1,2,3,4,5,6,7,8,9,0\}\). The code allows for repetitions of letters and/or digits.$$,
  'range',
  $$0.2$$,
  0.002,
  $$(a) Number of codes \(=8^{5}\times10^{5}=3\,276\,800\,000\).

(b)(i) \(\text{P}=\dfrac{\binom{5}{3}7^{2}\cdot\binom{5}{1}9^{4}}{8^{5}\,10^{5}}\approx0.00491\).

(b)(ii) \(\text{P}(E\text{ first})+\text{P}(4\text{ tenth})-2\,\text{P}(\text{both})=\dfrac18+\dfrac{1}{10}-2\left(\dfrac18\cdot\dfrac{1}{10}\right)=0.2\).$$,
  5,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the number of different codes that can be formed. \\([1]\\)",
    "correct_answer": "3276800000",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Find the probability that a code chosen at random contains the letter E exactly thrice and the digit 5 exactly once. \\([2]\\)",
    "correct_answer": "0.00491",
    "answer_type": "range",
    "tolerance": 0.0002
  },
  {
    "label": "bii",
    "prompt_latex": "Find the probability that a code chosen at random has E as the first character or 4 as its tenth character, but not both. \\([2]\\)",
    "correct_answer": "0.2",
    "answer_type": "range",
    "tolerance": 0.002
  }
]$$::jsonb
);

-- P2 Q6 [3]+[1]+[2] Probability
-- Q6(a) p exact. Q6(c) q and minimum -> multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  $$Conditional probability, independence and a minimised union$$,
  $$Two events \(A\) and \(B\) are such that \(\text{P}(A)=p\) and \(\text{P}(B)=\dfrac{5}{4}p\). It is given that \(\text{P}(A\cup B)=\text{P}(A\mid B)=0.6\).$$,
  'exact',
  $$0.4$$,
  NULL,
  $$(a) \(\text{P}(A\mid B)=0.6\Rightarrow\text{P}(A\cap B)=0.6\cdot\dfrac54 p=0.75p\). Then \(\text{P}(A\cup B)=p+\dfrac54 p-0.75p=0.6\Rightarrow1.5p=0.6\Rightarrow p=0.4\).

(b) \(\text{P}(A\mid B)=0.6\neq0.4=\text{P}(A)\), so \(A\) and \(B\) are not independent; hence \(A'\) and \(B\) are also not independent.

(c) For the minimum of \(\text{P}(A\cup C\cup D)\), take \(q=x\) so that the excess overlaps vanish, giving \(q=0.4\). Then \(\text{P}(A\cup C\cup D)=1.55-3q+x=1.55-3(0.4)+0.4=0.75\).$$,
  6,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the value of \\(p\\). \\([3]\\)",
    "correct_answer": "0.4",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Explain whether the events \\(A'\\) and \\(B\\) are independent. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The events \\(C\\) and \\(D\\) are such that \\(\\text{P}(C)=0.55\\), \\(\\text{P}(D)=0.6\\) and \\(\\text{P}(A\\cap C)=\\text{P}(A\\cap D)=\\text{P}(C\\cap D)=q\\). Find the value of \\(q\\) that gives the minimum value of \\(\\text{P}(A\\cup C\\cup D)\\) and state the minimum value of \\(\\text{P}(A\\cup C\\cup D)\\). \\([2]\\)",
    "correct_answer": "q=0.4,\\ \\min=0.75",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "q", "label": "q", "correct_answer": "0.4", "answer_type": "exact", "tolerance": null },
      { "key": "min", "label": "\\min P(A\\cup C\\cup D)", "correct_answer": "0.75", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P2 Q7 [2]+[2]+[1]+[2] Binomial Distribution
-- FLAG: Q7(d) set of values graded exact on canonical form.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251007-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Unripe apples and modal number of unripe oranges$$,
  $$A shop sells apples in bags of 12. The average number of unripe apples in a bag is \(2.16\).$$,
  'exact',
  $$\{n\in\mathbb{Z}:12\le n\le17\}$$,
  NULL,
  $$(a) The probability that each apple is unripe is constant; and the ripeness of an apple is independent of the other apples.

(b) \(p=\dfrac{2.16}{12}=0.18\). Let \(X\sim\text{B}(12,0.18)\). \(\text{P}(X>3)=1-\text{P}(X\le3)\approx0.155\).

(c) Let \(Y\sim\text{B}(20,0.15515)\). \(\text{P}(Y<4)=\text{P}(Y\le3)\approx0.623\).

(d) Let \(W\sim\text{B}(n,0.16)\). The mode is \(2\Rightarrow\text{P}(W=1)<\text{P}(W=2)\) and \(\text{P}(W=3)<\text{P}(W=2)\). By GC, \(\{n\in\mathbb{Z}:12\le n\le17\}\).$$,
  7,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State two assumptions needed for the number of unripe apples in a bag to be well modelled by a binomial distribution. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "A bag of apples is sold at a reduced price if more than 3 apples are unripe. Find the probability that a randomly selected bag of apples is sold at a reduced price. \\([2]\\)",
    "correct_answer": "0.155",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "Twenty bags of apples are selected at random. Find the probability that fewer than 4 of these bags will be sold at a reduced price. \\([1]\\)",
    "correct_answer": "0.623",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "d",
    "prompt_latex": "The shop also sells oranges in bags of \\(n\\) oranges. On average, the proportion of oranges that is unripe is \\(0.16\\). It is known that the modal number of unripe oranges in a bag is 2. Find the set of possible values of \\(n\\). \\([2]\\)",
    "correct_answer": "\\{n\\in\\mathbb{Z}:12\\le n\\le17\\}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q8 [1]+[4] Discrete Random Variables. Given target-board diagram -> prompt_graph in 081.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251008-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Score distribution on a concentric target board$$,
  $$The diagram shows a circular target board of radius \(40\) cm, divided by two concentric circles of radii \(12\) cm and \(24\) cm into three regions: Gold (innermost), Red and Blue (outermost). Arrows are shot at the board; the scores for hitting the Gold, Red and Blue regions are \(10\), \(6\) and \(3\) points respectively, and arrows that land outside the board score \(0\) points. Alex shoots one arrow at the board. The probability that his shot lands on the board is \(p\), where \(p>0.5\); if it lands on the board it is equally likely to hit any position on the board. Let \(X\) represent the score obtained from a single shot. You may assume that the arrow does not land on the boundary of any region.$$,
  'range',
  $$0.95$$,
  0.005,
  $$(a) \(\text{P}(X=6)=p\cdot\dfrac{\pi(24^{2})-\pi(12^{2})}{\pi(40^{2})}=p\cdot\dfrac{432}{1600}=0.27p\).

(b) Similarly \(\text{P}(X=10)=0.09p\), \(\text{P}(X=3)=0.64p\) and \(\text{P}(X=0)=1-p\). \(\text{E}(X)=3(0.64p)+6(0.27p)+10(0.09p)=4.44p\). \(\text{Var}(X)=\left[3^{2}(0.64p)+6^{2}(0.27p)+10^{2}(0.09p)\right]-(4.44p)^{2}=24.48p-19.7136p^{2}\). Setting this \(=5.464476\): \(19.7136p^{2}-24.48p+5.464476=0\Rightarrow p=0.292\) (rejected since \(p>0.5\)) or \(p=0.95\).$$,
  5,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\text{P}(X=6)=0.27p\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(\\text{Var}(X)=5.464476\\), find the value of \\(p\\). \\([4]\\)",
    "correct_answer": "0.95",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P2 Q9 [2]+[2]+[2] Normal Distribution. Q9(c) sketch -> solution_graph in 080.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '50251009-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  2,
  $$Symmetry, standard deviation and a normal sketch$$,
  $$The random variable \(X\) has distribution \(\text{N}(\mu,\sigma^{2})\).$$,
  'range',
  $$4.50$$,
  0.005,
  $$(a) By symmetry about \(\mu\), \(\text{P}(X>2\mu-k)=\text{P}(X<k)=1-\text{P}(X>k)=1-0.45=0.55\).

(b) \(\text{P}(1<X<4)=0.2475\Rightarrow\text{P}(X<1)=0.5-0.2475=0.2525\). Then \(\dfrac{1-4}{\sigma}=-0.66664\Rightarrow\sigma=4.50\) (to 3 s.f.).

(c) The sketch is the bell curve of \(X\sim\text{N}(4,4.50^{2})\), symmetric about the mean \(x=4\), shown for \(x\) from \(-11\) to \(19\).$$,
  6,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Given that \\(\\text{P}(X>k)=0.45\\), find the value of \\(\\text{P}(X>2\\mu-k)\\). \\([2]\\)",
    "correct_answer": "0.55",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that \\(\\mu=4\\) and \\(\\text{P}(1<X<4)=0.2475\\). Find the value of \\(\\sigma\\). \\([2]\\)",
    "correct_answer": "4.50",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "c",
    "prompt_latex": "Draw a sketch to show the distribution of \\(X\\) for \\(x\\) between \\(-11\\) and \\(19\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q10 [2]+[3]+[3]+[2] Normal Distribution (sampling / combinations of normals)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025100a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Kiwi masses: sample means, price difference and assortment boxes$$,
  $$In this question you should state the parameters of any distributions you use. An orchard sells kiwis of two varieties, Type \(A\) and Type \(B\). The masses, in grams, of Type \(A\) and Type \(B\) kiwis follow the distributions \(\text{N}(110,6^{2})\) and \(\text{N}(85,8^{2})\) respectively, and are independent. Type \(A\) kiwis are packed in bags of 30, while Type \(B\) kiwis are packed in bags of 60.$$,
  'range',
  $$0.197$$,
  0.002,
  $$(a) \(\bar{A}\sim\text{N}\!\left(110,\dfrac{6^{2}}{30}\right)=\text{N}(110,1.2)\). \(\text{P}(109<\bar{A}<115)=0.819\).

(b) \(\bar{B}\sim\text{N}\!\left(85,\dfrac{16}{15}\right)\). Then \(0.025\bar{A}\sim\text{N}(2.75,0.00075)\), \(0.015\bar{B}\sim\text{N}(1.275,0.00024)\), so \(0.025\bar{A}-0.015\bar{B}\sim\text{N}(1.475,0.00099)\). \(\text{P}\!\left(0<0.025\bar{A}-0.015\bar{B}\le1.5\right)\approx0.787\).

(c) Let \(T=G_{1}+\cdots+G_{50}\). Since \(50\) is large, by CLT \(T\sim\text{N}(4500,1250)\) approximately, and with \(S=A_{1}+\cdots+A_{30}\sim\text{N}(3300,1080)\), \(S+T\sim\text{N}(7800,2330)\). Required probability \(=\left[\text{P}(S+T<7850)\right]^{10}\approx0.197\).

(d) Approximation: by the Central Limit Theorem the sample sum of Type \(G\) masses is approximately normally distributed, since the number of kiwis per bag, \(50\), is large. Assumption: the masses of the kiwis are independent.$$,
  10,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "In a randomly chosen bag of Type \\(A\\) kiwis, find the probability that the mean mass of kiwis is between \\(109\\) grams and \\(115\\) grams. \\([2]\\)",
    "correct_answer": "0.819",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "b",
    "prompt_latex": "The selling prices of Type \\(A\\) and Type \\(B\\) kiwis are \\$25 per kilogram and \\$15 per kilogram respectively. Find the probability that the average selling price of a kiwi from a bag of Type \\(A\\) kiwis is more than the average selling price of a kiwi from a bag of Type \\(B\\) kiwis by at most \\$1.50. \\([3]\\)",
    "correct_answer": "0.787",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "The orchard also produces genetically modified Type \\(G\\) kiwis, packed in bags of 50. The masses of Type \\(G\\) kiwis are identically distributed with a mean of \\(90\\) grams and a standard deviation of \\(5\\) grams. Each Assortment Box contains one bag of Type \\(A\\) kiwis and one bag of Type \\(G\\) kiwis, and is fit for sale if the total mass of the kiwis in the box is at least \\(7.85\\) kilograms. Ten Assortment Boxes are selected at random. Find the probability that none of the boxes are fit for sale. \\([3]\\)",
    "correct_answer": "0.197",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "d",
    "prompt_latex": "State, in context, the approximation(s) and assumption(s) needed for the distribution(s) used in part (c). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q11 [1]+[1]+[1]+[3]+[2]+[1] Correlation & Regression. Q11(a) scatter -> solution_graph in 080.
-- FLAG: Q11(c)/(e) regression equations graded exact on canonical form.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025100b-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  $$Temperature and electricity: choosing and rescaling a model$$,
  $$An energy company is studying the relationship between the average daily temperature, \(x\) (in degrees Celsius), and the amount of electricity consumed, \(y\) (in megawatt-hours, MWh). For a random sample of ten days, the records are: \[\begin{array}{|c|c|c|c|c|c|c|c|c|c|c|}\hline x & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38\\\hline y & 12.5 & 12.8 & 13.2 & 14.0 & 14.7 & 16.2 & 16.2 & 19.9 & 22.3 & 29.5\\\hline\end{array}\] It is thought that the data can be modelled by one of \(y=a+bx^{2}\) or \(y=c+dx\), where \(a,b,c,d\) are constants.$$,
  'exact',
  $$y=4.83+0.00434(F-32)^{2}$$,
  NULL,
  $$(a) The scatter diagram shows that as \(x\) increases, \(y\) increases by increasing amounts.

(b)(i) From GC, \(r=0.89056\approx0.891\).

(b)(ii) From GC, \(r=0.92229\approx0.922\).

(c) Since \(y\) increases by increasing amounts and the product moment correlation coefficient between \(x^{2}\) and \(y\) (\(0.922\)) is closer to \(1\) than that between \(x\) and \(y\) (\(0.891\)), \(y=a+bx^{2}\) is the better model. With \(a=4.8291\) and \(b=0.014074\): \(y=4.83+0.0141x^{2}\).

(d) \(y=4.8291+0.014074(37)^{2}\approx24.1\). Since \(x=37\) lies within the data range \(20\le x\le38\) and \(r\approx0.922\) is close to \(1\), the estimate is reliable.

(e) With \(x=\dfrac{5}{9}(F-32)\): \(y=4.8291+0.014074\left[\dfrac{5}{9}(F-32)\right]^{2}\approx4.83+0.00434(F-32)^{2}\).$$,
  9,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Draw a scatter diagram for these values, labelling the axes clearly. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Find the value of the product moment correlation coefficient between \\(x\\) and \\(y\\). \\([1]\\)",
    "correct_answer": "0.891",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "bii",
    "prompt_latex": "Find the value of the product moment correlation coefficient between \\(x^{2}\\) and \\(y\\). \\([1]\\)",
    "correct_answer": "0.922",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "Using your answers in parts (a) and (b), explain which of \\(y=a+bx^{2}\\) and \\(y=c+dx\\) is the better model and find the equation of a suitable regression line for this model. \\([3]\\)",
    "correct_answer": "y=4.83+0.0141x^{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Use the equation of your regression line to estimate the electricity consumption on a day with an average temperature of \\(37^{\\circ}\\)C. Comment on the reliability of your estimate. \\([2]\\)",
    "correct_answer": "24.1",
    "answer_type": "range",
    "tolerance": 0.05
  },
  {
    "label": "e",
    "prompt_latex": "In some regions temperature is measured in degrees Fahrenheit, where \\(F=\\dfrac{9}{5}C+32\\). Rewrite the equation of your regression line found in part (c) in terms of \\(y\\) and \\(F\\), where \\(F\\) is the average daily temperature in degrees Fahrenheit. \\([1]\\)",
    "correct_answer": "y=4.83+0.00434(F-32)^{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q12 [1]+[2]+[4]+[1]+[1]+[3] Hypothesis Testing
-- Q12(b) mean+variance -> multi-box. FLAG: Q12(f) set of values graded exact on canonical form.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '5025100c-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  $$Recovery-time test: estimates, one-tailed test and a critical mean$$,
  $$A hospital introduces a new medication regimen to help patients recover from a viral infection more quickly. Previously, the average recovery time was \(7.2\) days. After adopting the new regimen, a random sample of \(40\) patients is observed, and their recovery times \(x\), in days, are recorded, summarised by \(\displaystyle\sum(x-7.2)=-42\) and \(\displaystyle\sum(x-7.2)^{2}=648\).$$,
  'exact',
  $$\{k\in\mathbb{R}:k>6.47\}$$,
  NULL,
  $$(a) The hospital should carry out a one-tailed test, as it wants to test whether the new regimen has reduced the mean recovery time.

(b) Unbiased estimate of the population mean: \(\bar{x}=7.2+\dfrac{-42}{40}=6.15\). Unbiased estimate of the population variance: \(s^{2}=\dfrac{1}{39}\left(648-\dfrac{(-42)^{2}}{40}\right)=15.4846\approx15.5\).

(c) Let \(\mu\) be the population mean recovery time. \(H_{0}:\mu=7.2\), \(H_{1}:\mu<7.2\), at the \(5\%\) level. Since \(n=40\) is large, by CLT \(Z=\dfrac{\bar{X}-7.2}{S/\sqrt{n}}\sim\text{N}(0,1)\) approximately. With \(\bar{x}=6.15\), \(s^{2}=15.4846\), the \(p\)-value \(=0.0457<0.05\), so \(H_{0}\) is rejected: there is sufficient evidence that the mean recovery time has reduced.

(d) A \(5\%\) significance level means there is a probability of \(0.05\) that the test concludes the mean recovery time has reduced when it is actually \(7.2\) days.

(e) No. Since the distribution of recovery time under the new regimen is unknown, the sample size must be large enough for the Central Limit Theorem to apply so that the sample mean is approximately normal; a sample of \(10\) is not large enough.

(f) \(s^{2}=\dfrac{30}{29}(1.7)^{2}=2.9897\). The rejection region is \(z\le-2.3263\). Since \(H_{0}\) is not rejected, \(\dfrac{k-7.2}{\sqrt{2.9897/30}}>-2.3263\Rightarrow k>6.4656\), so \(\{k\in\mathbb{R}:k>6.47\}\).$$,
  12,
  'VJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Explain whether the hospital should carry out a one-tailed test or a two-tailed test. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Calculate unbiased estimates of the population mean and variance of the recovery times under the new regimen. \\([2]\\)",
    "correct_answer": "\\bar{x}=6.15,\\ s^{2}=15.5",
    "answer_type": "range",
    "tolerance": null,
    "answers": [
      { "key": "mean", "label": "\\text{mean}", "correct_answer": "6.15", "answer_type": "range", "tolerance": 0.005 },
      { "key": "var", "label": "\\text{variance}", "correct_answer": "15.5", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Carry out an appropriate test at the \\(5\\%\\) significance level. You should state clearly the hypotheses for your test and define any parameters that you use. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Explain, in the context of the question, the meaning of 'at the \\(5\\%\\) significance level'. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Explain whether it would have been sufficient for the hospital to take a random sample of \\(10\\) patients and record their recovery times under the new regimen in order to carry out the hypothesis test. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "f",
    "prompt_latex": "It was discovered that an intern had made an error in recording the recovery times. A new random sample of \\(30\\) patients gave a sample standard deviation of \\(1.7\\) days and sample mean \\(k\\). A test at the \\(1\\%\\) significance level concludes that the average recovery time did not improve from \\(7.2\\) days. Find the set of values of \\(k\\). \\([3]\\)",
    "correct_answer": "\\{k\\in\\mathbb{R}:k>6.47\\}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);
