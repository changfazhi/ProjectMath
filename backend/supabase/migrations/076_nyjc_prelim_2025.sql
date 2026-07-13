-- Migration 076: NYJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (23 questions)
-- Source: NYJC_9758_2025_prelim_P1.pdf / P1_Solution.pdf, P2.pdf / P2_Solution.pdf.
-- Question IDs: Paper 1 = 6025 00NN, Paper 2 = 6025 10NN (prefix '6025' — next unused 4-hex-digit
-- slot; a-f taken by ACJC/CJC/HCI/DHS/RI/YIJC, '9025' EJC, '8025' JPJC, '7025' NJC, 'cafe' ASRJC).
-- NN is hex (Q10=0a, Q11=0b, Q12=0c).
-- Top-level (i)/(ii) parts are relabelled a/b/c per house style (matches RI/JPJC/NJC); genuine
-- two-level (a)(i) uses "ai"/"aii" etc.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading conventions (skills.md): clean scalars/fractions -> exact; decimals (probabilities, angles,
-- lengths, GC estimates) -> range with tolerance; indefinite integrals & arbitrary-constant/DE answers
-- -> null (revealed); proofs / "show that" / sketch / "state the shape"/"describe"/"explain"/"comment"/
-- hypothesis conclusions -> null. Two-valued/vector-valued/complex-multiroot answers left null per house
-- convention. Brittle-but-clean forms (inequalities, line/plane/asymptote equations, in-terms-of-a
-- series/coords, series expansions) are graded with a "-- FLAG:" note. Sketch parts get solution_graph
-- specs in migration 077.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q1 [4] Graphing Techniques — find p, q, r (wrapped single-part for the 3-box answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250001-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  $$Rational curve: oblique asymptote and turning point$$,
  $$Curve \(C\) has equation \(y=\dfrac{px^{2}+qx+r}{x-1}\), where \(p\), \(q\) and \(r\) are real numbers. It is given that \(C\) has a turning point at \((3,7)\) and an oblique asymptote parallel to the line \(y=\dfrac{3}{2}x+\sqrt5\).$$,
  'exact',
  $$p=\frac{3}{2},\ q=-2,\ r=\frac{13}{2}$$,
  NULL,
  $$Oblique asymptote gradient \(=p=\dfrac{3}{2}\). Through \((3,7)\): \(7=\dfrac{1.5(9)+3q+r}{2}\Rightarrow r=0.5-3q\), so \(y=\dfrac{1.5x^{2}+qx+0.5-3q}{x-1}\). Setting \(\dfrac{dy}{dx}=0\) at \(x=3\): \((3x+q)(x-1)-(1.5x^{2}+qx+0.5-3q)=0\) at \(x=3\) gives \((9+q)(2)-14=0\Rightarrow q=-2\); then \(r=0.5-3(-2)=6.5\). So \(p=\dfrac{3}{2}\), \(q=-2\), \(r=\dfrac{13}{2}\).$$,
  4,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(p\\), \\(q\\) and \\(r\\). \\([4]\\)",
    "correct_answer": "p=\\frac{3}{2},\\ q=-2,\\ r=\\frac{13}{2}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "p", "label": "p", "correct_answer": "\\frac{3}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "-2", "answer_type": "exact", "tolerance": null },
      { "key": "r", "label": "r", "correct_answer": "\\frac{13}{2}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P1 Q2 [6] App. of Differentiation — minimise volume of ornament (single-answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  '60250002-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Minimum-volume ornament (two cones and a sphere)$$,
  $$An ornament consists of two identical solid right circular cones whose flat bases are separated by a solid sphere in contact with the two bases. The axis passes through the vertex of each cone and the centre of the sphere. The distance between the vertices of the cones is \(2l\), and the radii of the bases of the cones are \(\sqrt{\tfrac{3}{2}}\,l\), where \(l\) is a constant. Find the radius of the sphere in terms of \(l\) if the total volume of the ornament is a minimum. \([\text{Volume of a sphere of radius } r \text{ is } \tfrac{4}{3}\pi r^{3}.]\) \([6]\)$$,
  'exact',
  $$\frac{l}{2}$$,
  NULL,
  $$Let the sphere radius be \(r\) and each cone height \(h\); \(2h+2r=2l\Rightarrow h=l-r\). Total volume \(V=2\left(\tfrac13\pi h\cdot\tfrac32 l^{2}\right)+\tfrac43\pi r^{3}=\pi l^{2}(l-r)+\tfrac43\pi r^{3}\). \(\dfrac{dV}{dr}=-\pi l^{2}+4\pi r^{2}=0\Rightarrow r^{2}=\tfrac{l^{2}}{4}\Rightarrow r=\tfrac{l}{2}\) (\(r>0\)). \(\dfrac{d^{2}V}{dr^{2}}=8\pi r>0\), so the volume is a minimum when \(r=\dfrac{l}{2}\).$$,
  6,
  'NYJC H2 Math Prelim 2025'
);

-- P1 Q3 [4]+[4] Vector (Basic)
-- FLAG: Q3(b) k in terms of lambda — "show that ... where k is to be determined" graded on k.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250003-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Right angle by dot product; area of a sub-triangle$$,
  $$$$,
  'exact',
  $$\frac{\lambda}{2}$$,
  NULL,
  $$(a) With \(\overrightarrow{AB}+\overrightarrow{BC}=\overrightarrow{AC}\), \(|\overrightarrow{AC}|^{2}=(\overrightarrow{AB}+\overrightarrow{BC})\cdot(\overrightarrow{AB}+\overrightarrow{BC})=AB^{2}+BC^{2}+2\,\overrightarrow{AB}\cdot\overrightarrow{BC}\). Given \(AB^{2}+BC^{2}=AC^{2}\), \(\overrightarrow{AB}\cdot\overrightarrow{BC}=0\), so \(\angle ABC=90^{\circ}\). (b) \(\mathbf{d}=(1-\lambda)\mathbf{a}+\lambda\mathbf{c}\). Area \(ABD=\tfrac12|\overrightarrow{AB}\times\overrightarrow{BD}|=\tfrac12|(\mathbf{b}-\mathbf{a})\times((1-\lambda)\mathbf{a}+\lambda\mathbf{c}-\mathbf{b})|=\tfrac{\lambda}{2}|\mathbf{a}\times\mathbf{b}+\mathbf{b}\times\mathbf{c}+\mathbf{c}\times\mathbf{a}|\), so \(k=\dfrac{\lambda}{2}\).$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "A triangle \\(ABC\\) is such that \\(AB^{2}+BC^{2}=AC^{2}\\). By considering \\(\\overrightarrow{AB}+\\overrightarrow{BC}=\\overrightarrow{AC}\\) and using \\(|\\mathbf{v}|^{2}=\\mathbf{v}\\cdot\\mathbf{v}\\), prove that \\(\\angle ABC\\) is a right angle. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "In a triangle \\(ABC\\), the point \\(D\\) divides \\(AC\\) in the ratio \\(\\lambda:1-\\lambda\\), where \\(0<\\lambda<1\\). Let \\(\\mathbf{a},\\mathbf{b},\\mathbf{c},\\mathbf{d}\\) be the position vectors of \\(A,B,C,D\\). Show that the area of triangle \\(ABD\\) is \\(k\\,|\\mathbf{a}\\times\\mathbf{b}+\\mathbf{b}\\times\\mathbf{c}+\\mathbf{c}\\times\\mathbf{a}|\\), where \\(k\\) is to be determined in terms of \\(\\lambda\\). \\([4]\\)",
    "correct_answer": "\\frac{\\lambda}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q4 [3]+[3]+[2] Transformation — all sketches (null; solution_graph in 077)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250004-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Graph transformations of f and g$$,
  $$$$,
  'exact',
  $$$$,
  NULL,
  $$(a) \(y=f(a-x)\) is the graph of \(y=f(x)\) reflected in the line \(x=\tfrac{a}{2}\); the images are \(A'(2a,0)\), \(B'(0,b)\), \(C'(a-c,-b)\), \(D'(a-d,0)\), \(E'(a-e,0)\). (b)(i) \(y=|g(x)|\) reflects the part of \(y=g(x)\) below the \(x\)-axis to above it: the left branch reflects up to the asymptote \(y=m\); asymptotes become \(y=0\), \(y=m\), \(x=-n\), with \(P(0,p)\) unchanged (\(p>0\)). (b)(ii) \(y=g(|x|)\) keeps \(x\ge0\) part of \(y=g(x)\) and reflects it in the \(y\)-axis; asymptote \(y=0\) only, passing through \(P(0,p)\), symmetric about the \(y\)-axis.$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "The graph of \\(y=f(x)\\) has turning points at \\(A(-a,0)\\), \\(B(a,b)\\) and \\(C(c,-b)\\) and crosses the \\(x\\)-axis at \\(D(d,0)\\) and \\(E(e,0)\\), rising to the right. Sketch the graph of \\(y=f(a-x)\\), labelling the coordinates of the images of \\(A\\), \\(B\\), \\(C\\), \\(D\\) and \\(E\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "The graph of \\(y=g(x)\\) has asymptotes \\(y=0\\), \\(y=-m\\) and \\(x=-n\\), and crosses the \\(y\\)-axis at \\(P(0,p)\\), where \\(p<m\\). Sketch the graph of \\(y=|g(x)|\\), labelling the asymptote(s) and the coordinates of \\(P\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Sketch the graph of \\(y=g(|x|)\\), labelling the asymptote(s) and the coordinates of \\(P\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q5 [4]+[1]+[3] Sequences & Series
-- FLAG: Q5(a) sum in terms of m,n (non-unique, "need not simplify") left null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250005-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Sum of a quadratic series; common terms; odd-integer series$$,
  $$The \(n\)th term of a series \(G\) is \(g_{n}=3n^{2}-17n+17\), where \(n\ge1\).$$,
  'exact',
  $$45$$,
  NULL,
  $$(a) \(\displaystyle\sum_{r=m+1}^{n}g_{r}=3\left(\sum_{r=1}^{n}r^{2}-\sum_{r=1}^{m}r^{2}\right)+17\sum_{r=m+1}^{n}(1-r)=\tfrac{n}{2}(n+1)(2n+1)-\tfrac{m}{2}(m+1)(2m+1)+17\cdot\tfrac{n-m}{2}(1-m-n)\). (b) The \(n\)th term of \(H\) is \(h_{n}=7(5^{n-3})+10\); by GC the smallest number common to both \(G\) and \(H\) is \(45\). (c) \(S_{n}=\tfrac{b}{2}(3^{n}-1)\Rightarrow j_{n}=S_{n}-S_{n-1}=\tfrac{b}{2}(3^{n}-3^{n-1})=b\,3^{n-1}\); since \(b\) is a positive odd integer and \(3^{n-1}\) is odd, \(j_{n}\) is a positive odd integer, hence a term of the AP \(1,3,5,\dots\).$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Given that \\(\\displaystyle\\sum_{r=1}^{n}r^{2}=\\tfrac{n}{6}(n+1)(2n+1)\\), find \\(\\displaystyle\\sum_{r=m+1}^{n}g_{r}\\). (You need not simplify your answer.) \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The \\(n\\)th term of a series \\(H\\) is \\(h_{n}=7(5^{\\,n-3})+10\\), where \\(n\\ge1\\). State the smallest number that can be found in both series \\(H\\) and \\(G\\). \\([1]\\)",
    "correct_answer": "45",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The sum of the first \\(n\\) terms of a series \\(J\\) is \\(\\tfrac{b}{2}(3^{n}-1)\\), where \\(b\\) is a positive odd integer. By finding the \\(n\\)th term of \\(J\\), explain why each term of \\(J\\) is a term of the arithmetic progression with first term 1 and common difference 2. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q6 [3]+[1]+[1]+[3] Complex Number
-- FLAG: Q6(a)/(b)/(b)(i) arguments in terms of alpha,beta — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250006-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Argand diagram: rhombus and reflection of a point$$,
  $$Points \(P\), \(Q\) and \(R\) represent the complex numbers \(p\), \(q\) and \(r\) on an Argand diagram, where \(\arg(p)=\alpha\), \(\arg(q)=\beta\), \(0<\alpha<\beta<\tfrac{\pi}{2}\), \(\beta>2\alpha\), and \(r=p+q\).$$,
  'exact',
  $$\frac{\alpha+\beta}{2}$$,
  NULL,
  $$(a) If \(|p|=|q|\) then \(OPRQ\) is a rhombus, and its diagonal \(OR\) bisects \(\angle POQ\), so \(\arg(r)=\alpha+\tfrac12(\beta-\alpha)=\tfrac{\alpha+\beta}{2}\). (b) Reflecting \(Q\) in \(OP\), \(\angle POQ'=\beta-\alpha\). (b)(i) \(\arg(q')=\alpha-(\beta-\alpha)=2\alpha-\beta\). (b)(ii) \(|q'|=|q|\), so \(q'=|q|\cos(2\alpha-\beta)+\mathrm{i}\,|q|\sin(2\alpha-\beta)\); real part \(|q|\cos(2\alpha-\beta)\), imaginary part \(|q|\sin(2\alpha-\beta)\).$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "If \\(|p|=|q|\\), describe the shape of the quadrilateral \\(OPRQ\\). Hence find \\(\\arg(r)\\) in terms of \\(\\alpha\\) and \\(\\beta\\). \\([3]\\)",
    "correct_answer": "\\frac{\\alpha+\\beta}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The point \\(Q'\\), representing \\(q'\\), is the reflection of \\(Q\\) in \\(OP\\). State the angle \\(POQ'\\). \\([1]\\)",
    "correct_answer": "\\beta-\\alpha",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bi",
    "prompt_latex": "Find the argument of \\(q'\\), in terms of \\(\\alpha\\) and \\(\\beta\\). \\([1]\\)",
    "correct_answer": "2\\alpha-\\beta",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Find the real and imaginary parts of \\(q'\\) and write down \\(q'\\) in the form \\(a+\\mathrm{i}b\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q7 [4]+[4] Integration Technique
-- FLAG: Q7(b) definite integral in terms of a,b — left null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250007-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  $$Definite integrals by substitution and by modulus splitting$$,
  $$$$,
  'exact',
  $$\pi-2$$,
  NULL,
  $$(a) With \(x=\sin^{2}\theta\), \(dx=2\sin\theta\cos\theta\,d\theta\); limits \(0\to0\), \(\tfrac12\to\tfrac{\pi}{4}\). \(\displaystyle\int_{0}^{1/2}\sqrt{\tfrac{16x}{1-x}}\,dx=\int_{0}^{\pi/4}\tfrac{4\sin\theta}{\cos\theta}(2\sin\theta\cos\theta)\,d\theta=\int_{0}^{\pi/4}8\sin^{2}\theta\,d\theta=\int_{0}^{\pi/4}4(1-\cos2\theta)\,d\theta=[4\theta-2\sin2\theta]_{0}^{\pi/4}=\pi-2\). (b) \(\tfrac12 x^{2}-x+1=\tfrac12(x-1)^{2}+\tfrac12\); split at \(x=1\): \(\displaystyle\int_{a}^{b}\tfrac{|x-1|}{\sqrt{\frac12 x^{2}-x+1}}\,dx=-2\sqrt2+2\left(\tfrac12 a^{2}-a+1\right)^{1/2}+2\left(\tfrac12 b^{2}-b+1\right)^{1/2}\).$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Use the substitution \\(x=\\sin^{2}\\theta\\), where \\(0\\le\\theta\\le\\tfrac{\\pi}{2}\\), to find \\(\\displaystyle\\int_{0}^{1/2}\\sqrt{\\dfrac{16x}{1-x}}\\,dx\\) exactly. \\([4]\\)",
    "correct_answer": "\\pi-2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(\\displaystyle\\int_{a}^{b}\\dfrac{|x-1|}{\\sqrt{\\tfrac12 x^{2}-x+1}}\\,dx\\) in terms of \\(a\\) and \\(b\\), where \\(a<1<b\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q8 [2]+[2]+[2]+[2] Sequences & Series (AP/GP)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250008-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Arithmetic progression; embedded geometric progression$$,
  $$A sequence is such that \(u_{n+1}=u_{n}+1.5\) for \(n=1,2,3,\dots\).$$,
  'range',
  $$64.311$$,
  0.005,
  $$(a) AP with common difference \(1.5\): \(u_{50}=u_{1}+49(1.5)\); \(u_{50}=99u_{1}\Rightarrow 99u_{1}=u_{1}+73.5\Rightarrow u_{1}=0.75\). (b) \(u_{2}+u_{4}+\dots+u_{2n}\) is an AP with first term \(u_{2}=2.25\), common difference \(3\); sum \(=\tfrac{n}{2}(1.5+3n)>2025\); by GC least \(n=37\). (c)(i) \(u_{25},u_{k},u_{5}\) geometric \(\Rightarrow u_{k}^{2}=u_{5}u_{25}\Rightarrow[0.75+(k-1)1.5]^{2}=6.75\times36.75\Rightarrow 0.75+(k-1)1.5=15.75\Rightarrow k=11\). (c)(ii) ratio \(=\tfrac{15.75}{36.75}=\tfrac37\); \(S_{13}=\dfrac{36.75\left(1-(3/7)^{13}\right)}{1-3/7}=64.311\) (3 d.p.).$$,
  8,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Given that \\(u_{50}=99u_{1}\\), show that \\(u_{1}=0.75\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the least value of \\(n\\) such that \\(u_{2}+u_{4}+u_{6}+\\dots+u_{2n}\\) is more than 2025. \\([2]\\)",
    "correct_answer": "37",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ci",
    "prompt_latex": "It is given that \\(u_{25}\\), \\(u_{k}\\) and \\(u_{5}\\) are the first three terms of a geometric progression. Find \\(k\\). \\([2]\\)",
    "correct_answer": "11",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "cii",
    "prompt_latex": "Find the sum of the first 13 terms of the geometric series, giving your answer to 3 decimal places. \\([2]\\)",
    "correct_answer": "64.311",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P1 Q9 [2]+[2]+[2]+[3] Functions
-- FLAG: Q9(c)/(d) rational functions — exact-match brittle but clean. Q9(b) yes/no+reason left null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60250009-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Rational function: excluded value, inverse and composite$$,
  $$The function \(f\) is defined by \(f(x)=\dfrac{x+1}{2x-3}\) for \(x\in\mathbb{R}\), \(x\ne k\).$$,
  'exact',
  $$\frac{11x-22}{4x-13}$$,
  NULL,
  $$(a) \(k=\tfrac32\); at \(x=\tfrac32\) the denominator \(2x-3=0\), so \(f\) is undefined there. (b) \(R_{f}=\mathbb{R}\setminus\{\tfrac12\}\) and \(D_{f}=\mathbb{R}\setminus\{\tfrac32\}\); since \(R_{f}\not\subseteq D_{f}\), \(f^{2}\) does not exist. (c) \(y=\tfrac{x+1}{2x-3}\Rightarrow(2x-3)y=x+1\Rightarrow x=\tfrac{3y+1}{2y-1}\), so \(f^{-1}(x)=\dfrac{3x+1}{2x-1}\). (d) \(fh(x)=\tfrac{3x-7}{2x-1}\Rightarrow h(x)=f^{-1}\!\left(\tfrac{3x-7}{2x-1}\right)=\dfrac{3\left(\frac{3x-7}{2x-1}\right)+1}{2\left(\frac{3x-7}{2x-1}\right)-1}=\dfrac{9x-21+2x-1}{6x-14-2x+1}=\dfrac{11x-22}{4x-13}\).$$,
  9,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State the value of \\(k\\) and explain why this value has to be excluded from the domain of \\(f\\). \\([2]\\)",
    "correct_answer": "\\frac{3}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Determine, with a reason, if \\(f^{2}\\) exists. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find \\(f^{-1}(x)\\). \\([2]\\)",
    "correct_answer": "\\frac{3x+1}{2x-1}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Hence find \\(h(x)\\) for which \\(fh(x)=\\dfrac{3x-7}{2x-1}\\), \\(x\\ne\\tfrac12\\). \\([3]\\)",
    "correct_answer": "\\frac{11x-22}{4x-13}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q10 [4]+[1]+[3]+[1] Maclaurin Series
-- FLAG: Q10(a)/(c) series/closed-form answers — exact-match brittle but canonical.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '6025000a-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Maclaurin series of a composite integral; approximation$$,
  $$In this question you may use expansions from the List of Formulae (MF27).$$,
  'exact',
  $$\frac{1}{3}\sin(x^{3})$$,
  NULL,
  $$(a) \(\cos(t^{3})=1-\tfrac{t^{6}}{2}+\tfrac{t^{12}}{24}-\cdots\); \(\displaystyle\int_{0}^{x}t^{2}\cos(t^{3})\,dt\approx\int_{0}^{x}\left(t^{2}-\tfrac{t^{8}}{2}+\tfrac{t^{14}}{24}\right)dt=\tfrac{x^{3}}{3}-\tfrac{x^{9}}{18}+\tfrac{x^{15}}{360}\). (b) At \(x=0.1\): \(\tfrac{0.1^{3}}{3}-\tfrac{0.1^{9}}{18}+\tfrac{0.1^{15}}{360}\approx0.00033\) (5 d.p.). (c) \(\displaystyle\int_{0}^{x}t^{2}\cos(t^{3})\,dt=\left[\tfrac13\sin(t^{3})\right]_{0}^{x}=\tfrac13\sin(x^{3})\); at \(x=0.1\), \(\tfrac13\sin(0.001)=0.00033\) (5 d.p.). (d) The two values agree to 5 d.p.; the series approximation is accurate because \(x=0.1\) is small (close to 0).$$,
  9,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the Maclaurin expansion of \\(\\cos(t^{3})\\) in ascending powers of \\(t\\), up to and including the term in \\(t^{12}\\). Hence find the Maclaurin series of \\(\\displaystyle\\int_{0}^{x}t^{2}\\cos(t^{3})\\,dt\\) up to and including the term in \\(x^{15}\\), given that \\(x\\) is small. \\([4]\\)",
    "correct_answer": "\\frac{x^{3}}{3}-\\frac{x^{9}}{18}+\\frac{x^{15}}{360}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "cos", "label": "\\cos(t^{3})", "correct_answer": "1-\\frac{t^{6}}{2}+\\frac{t^{12}}{24}", "answer_type": "exact", "tolerance": null },
      { "key": "int", "label": "\\text{series}", "correct_answer": "\\frac{x^{3}}{3}-\\frac{x^{9}}{18}+\\frac{x^{15}}{360}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Use your expansion from part (a) to find an approximate value for \\(\\displaystyle\\int_{0}^{0.1}t^{2}\\cos(t^{3})\\,dt\\), correct to 5 decimal places. \\([1]\\)",
    "correct_answer": "0.00033",
    "answer_type": "range",
    "tolerance": 0.00001
  },
  {
    "label": "c",
    "prompt_latex": "Find \\(\\displaystyle\\int_{0}^{x}t^{2}\\cos(t^{3})\\,dt\\) in terms of \\(x\\). Hence evaluate \\(\\displaystyle\\int_{0}^{0.1}t^{2}\\cos(t^{3})\\,dt\\), correct to 5 decimal places. \\([3]\\)",
    "correct_answer": "\\frac{1}{3}\\sin(x^{3})",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "form", "label": "\\text{integral}", "correct_answer": "\\frac{1}{3}\\sin(x^{3})", "answer_type": "exact", "tolerance": null },
      { "key": "val", "label": "\\text{value}", "correct_answer": "0.00033", "answer_type": "range", "tolerance": 0.00001 }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Comparing your answers to parts (b) and (c), and with reference to the value of \\(x\\), comment on the accuracy of your approximations. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q11 [3]+[4]+[4] Definite Integral (area and volumes of revolution)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '6025000b-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Hyperbola and line: area and volumes of revolution$$,
  $$The curve \(C\) has equation \(x^{2}-y^{2}=16\), where \(y\ge0\). The line \(L\) has equation \(y=-\tfrac12 x+\tfrac{11}{2}\).$$,
  'range',
  $$8.47$$,
  0.005,
  $$(a) \(y=\sqrt{x^{2}-16}\); the area \(=\displaystyle\int_{5}^{8}\sqrt{x^{2}-16}\,dx-\int_{5}^{8}\left(-\tfrac12 x+\tfrac{11}{2}\right)dx=8.47\) units\(^{2}\) (3 s.f.). (b) For \(x\ge0\), volume \(=\pi\displaystyle\int_{4}^{5}(x^{2}-16)\,dx+\tfrac13\pi(3)^{2}(6)=\pi\left[\tfrac{x^{3}}{3}-16x\right]_{4}^{5}+18\pi=\dfrac{67}{3}\pi\) units\(^{3}\). (c) Rotating about the \(y\)-axis: volume \(=\pi(5)^{2}(3)-\pi\displaystyle\int_{0}^{3}(y^{2}+16)\,dy=75\pi-57\pi=18\pi\) units\(^{3}\).$$,
  11,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the area enclosed by \\(C\\), \\(L\\) and the line \\(x=8\\). \\([3]\\)",
    "correct_answer": "8.47",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "b",
    "prompt_latex": "For \\(x\\ge0\\), the region bounded by \\(C\\), \\(L\\) and the \\(x\\)-axis is rotated about the \\(x\\)-axis through \\(2\\pi\\) radians. Find the exact volume generated. \\([4]\\)",
    "correct_answer": "\\frac{67\\pi}{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The region bounded by \\(C\\), the line \\(x=5\\) and the \\(x\\)-axis is rotated about the \\(y\\)-axis through \\(2\\pi\\) radians. Find the exact volume generated. \\([4]\\)",
    "correct_answer": "18\\pi",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P1 Q12 [1]+[4]+[2]+[5]+[1] Differential Equations
-- FLAG: Q12(b) fully-determined exponential solution — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '6025000c-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Biomass growth models (differential equations)$$,
  $$Scientists study a biomass whose rate of growth is proportional to the amount present. A sample of \(100\) grams was collected initially and grew to \(110\) grams after one day. The amount of biomass at time \(t\) days is \(B\) grams.$$,
  'range',
  $$102.30893$$,
  0.001,
  $$(a) \(\dfrac{dB}{dt}=kB\), \(k\in\mathbb{R}\). (b) \(\ln B=kt+C\Rightarrow B=De^{kt}\); \(B=100\) at \(t=0\Rightarrow D=100\); \(B=110\) at \(t=1\Rightarrow k=\ln\tfrac{11}{10}\), so \(B=100\left(\tfrac{11}{10}\right)^{t}\). (c) Increasing exponential from \((0,100)\); left on its own the biomass grows without bound. (d) With \(\dfrac{dB}{dt}=\dfrac{mB}{3+2t^{2}}\): \(\ln B=\dfrac{m}{\sqrt6}\tan^{-1}\!\left(\sqrt{\tfrac23}\,t\right)+C\); \(B=100\) at \(t=0\), \(B=101\) at \(t=1\Rightarrow m=0.035596\); \(B=100\,e^{0.014532\tan^{-1}(\sqrt{2/3}\,t)}\). (e) As \(t\to\infty\), \(\tan^{-1}\!\left(\sqrt{\tfrac23}\,t\right)\to\tfrac{\pi}{2}\), so \(B\to100\,e^{0.014532(\pi/2)}=102.30893\) grams.$$,
  13,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Write down a differential equation relating \\(B\\) and \\(t\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Solve the differential equation obtained in part (a), expressing \\(B\\) in terms of \\(t\\). \\([4]\\)",
    "correct_answer": "100\\left(\\frac{11}{10}\\right)^{t}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Sketch the graph of \\(B\\) against \\(t\\), and explain what would happen if the biomass was left on its own. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "A second \\(100\\)-gram sample is treated so that its growth follows \\(\\dfrac{dB}{dt}=\\dfrac{mB}{3+2t^{2}}\\), where \\(m\\) is a constant. After 1 day it grew to \\(101\\) grams. Find \\(B\\) in terms of \\(t\\). \\([5]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "Determine the amount of the second biomass sample after a long time, leaving your answer to 5 decimal places. \\([1]\\)",
    "correct_answer": "102.30893",
    "answer_type": "range",
    "tolerance": 0.001
  }
]$$::jsonb
);

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1 [2]+[4] Inequalities
-- FLAG: Q1(a)/(b) interval/set answers — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  $$Modulus and rational inequalities$$,
  $$$$,
  'exact',
  $$x<-7\ \text{or}\ -3-\sqrt{5}\le x\le-3+\sqrt{5}\ \text{or}\ x>2$$,
  NULL,
  $$(a) \(3|x-3|\le|1-2x|\Rightarrow9(x-3)^{2}\le(1-2x)^{2}\Rightarrow5x^{2}-50x+80\le0\Rightarrow(x-2)(x-8)\le0\), so \(\{x\in\mathbb{R}:2\le x\le8\}\). (b) \(\dfrac{x+18}{x^{2}+5x-14}\ge-1\Rightarrow\dfrac{x^{2}+6x+4}{(x+7)(x-2)}\ge0\Rightarrow\dfrac{(x+3-\sqrt5)(x+3+\sqrt5)}{(x+7)(x-2)}\ge0\); from the sign diagram, \(x<-7\) or \(-3-\sqrt5\le x\le-3+\sqrt5\) or \(x>2\).$$,
  6,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the set of values of \\(x\\) for which \\(3|x-3|\\le|1-2x|\\). \\([2]\\)",
    "correct_answer": "2\\le x\\le8",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Without using a calculator, solve \\(\\dfrac{x+18}{x^{2}+5x-14}\\ge-1\\). \\([4]\\)",
    "correct_answer": "x<-7\\ \\text{or}\\ -3-\\sqrt{5}\\le x\\le-3+\\sqrt{5}\\ \\text{or}\\ x>2",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q2 [2]+[4] Complex Number — (a) explain, (b) three roots (multi-valued, revealed)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251002-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Conjugate roots and a substitution$$,
  $$It is given that the roots of \(-\mathrm{i}x^{3}+5\mathrm{i}x^{2}+ax+b=0\), where \(a\) and \(b\) are purely imaginary, are \(2+\mathrm{i}\), \(2-\mathrm{i}\) and \(1\).$$,
  'exact',
  $$$$,
  NULL,
  $$(a) Writing \(a=\lambda\mathrm{i}\), \(b=\mu\mathrm{i}\) (\(\lambda,\mu\in\mathbb{R}\)) and dividing by \(-\mathrm{i}\) gives \(x^{3}-5x^{2}-\lambda x-\mu=0\), which has all real coefficients; hence its non-real roots occur in conjugate pairs. (b) In \(\mathrm{i}x^{3}+5\mathrm{i}x^{2}+a^{*}x+b=0\), since \(a\) is purely imaginary \(a^{*}=-a\); substituting \(x\to-x\) into the equation of part (a) shows the roots satisfy \(-x=2+\mathrm{i},2-\mathrm{i},1\), so \(x=-2-\mathrm{i},\,-2+\mathrm{i},\,-1\).$$,
  6,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Explain why the complex roots occur in conjugate pairs. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "By using part (a) and an appropriate substitution, find the roots of the equation \\(\\mathrm{i}x^{3}+5\\mathrm{i}x^{2}+a^{*}x+b=0\\), where the complex conjugate of \\(a\\) is denoted by \\(a^{*}\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q3 [3]+[4] Definite Integral (Riemann sum as an integral)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251003-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Limit of a Riemann sum as a definite integral$$,
  $$$$,
  'exact',
  $$3\ln3-2$$,
  NULL,
  $$(a) Each of the \(n\) rectangles has width \(\tfrac{2}{n}\) and heights \(f\!\left(1+\tfrac{2k}{n}\right)\); as \(n\to\infty\) the total area tends to the area under \(y=f(x)\) from \(x=1\) to \(x=3\), i.e. \(\displaystyle\int_{1}^{3}f(x)\,dx\). (b) With \(f(x)=\ln x\): \(\displaystyle\lim_{n\to\infty}\sum_{k=1}^{n}\ln\!\left(1+\tfrac{2k}{n}\right)\tfrac{2}{n}=\int_{1}^{3}\ln x\,dx=[x\ln x-x]_{1}^{3}=3\ln3-2\).$$,
  7,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Given that \\(f\\) is a continuous function, explain, with the aid of a sketch, why \\(\\displaystyle\\lim_{n\\to\\infty}\\frac{2}{n}\\left\\{f\\!\\left(1+\\tfrac{2}{n}\\right)+f\\!\\left(1+\\tfrac{4}{n}\\right)+\\dots+f\\!\\left(1+\\tfrac{2n}{n}\\right)\\right\\}=\\int_{1}^{3}f(x)\\,dx\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence evaluate \\(\\displaystyle\\lim_{n\\to\\infty}\\sum_{k=1}^{n}\\ln\\!\\left(1+\\tfrac{2k}{n}\\right)\\frac{2}{n}\\) exactly. \\([4]\\)",
    "correct_answer": "3\\ln3-2",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q4 [2]+[6]+[2] App. of Differentiation (implicit)
-- FLAG: Q4(a) derivative expression — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251004-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  $$Implicit curve: tangent parallel to y-axis$$,
  $$The equation of a curve \(C\) is \(x^{3}+xy+2y^{3}=k\), where \(k\) is a constant.$$,
  'exact',
  $$k=-220\ \text{or}\ k=-212$$,
  NULL,
  $$(a) Differentiating: \(3x^{2}+y+x\dfrac{dy}{dx}+6y^{2}\dfrac{dy}{dx}=0\Rightarrow\dfrac{dy}{dx}=\dfrac{-y-3x^{2}}{x+6y^{2}}\). (b) Tangent parallel to the \(y\)-axis \(\Rightarrow x+6y^{2}=0\Rightarrow x=-6y^{2}\); substituting, \((-6y^{2})^{3}+(-6y^{2})y+2y^{3}=k\Rightarrow216y^{6}+4y^{3}+k=0\). Real \(y\) needs discriminant \(4^{2}-4(216)k\ge0\Rightarrow k\le\tfrac{1}{54}\). (c) \(x=-6\Rightarrow-6y^{2}=-6\Rightarrow y=\pm1\); \(216+4(\pm1)+k=0\Rightarrow k=-220\) or \(k=-212\).$$,
  10,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\dfrac{dy}{dx}\\) in terms of \\(x\\) and \\(y\\). \\([2]\\)",
    "correct_answer": "\\frac{-y-3x^{2}}{x+6y^{2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "It is given that \\(C\\) has a tangent which is parallel to the \\(y\\)-axis. Show that the \\(y\\)-coordinate of the points of contact must satisfy \\(216y^{6}+4y^{3}+k=0\\). Hence show that \\(k\\le\\tfrac{1}{54}\\). \\([6]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the possible values of \\(k\\) in the case where the line \\(x=-6\\) is a tangent to \\(C\\). \\([2]\\)",
    "correct_answer": "k=-220\\ \\text{or}\\ k=-212",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "k1", "label": "k", "correct_answer": "-220", "answer_type": "exact", "tolerance": null },
      { "key": "k2", "label": "k", "correct_answer": "-212", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- P2 Q5 [3]+[3]+[3]+[2] Vector (Plane)
-- FLAG: Q5(c) distance and Q5(d) plane equation — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251005-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Two planes: angle, line of intersection and distance$$,
  $$Two planes \(p_{1}\) and \(p_{2}\) have cartesian equations \(4x+y+z=8\) and \(4x+3y-z=0\) respectively.$$,
  'exact',
  $$-x+2y+2z=7$$,
  NULL,
  $$(a) \(\cos\theta=\dfrac{|(4,1,1)\cdot(4,3,-1)|}{\sqrt{18}\sqrt{26}}=\dfrac{18}{\sqrt{18}\sqrt{26}}=\dfrac{3}{\sqrt{13}}\), so \(\sin\theta=\dfrac{2}{\sqrt{13}}\); \(m=2,\ n=13\). (b) \(A(1,0,4)\) satisfies both. \((4,1,1)\times(4,3,-1)=(-4,8,8)=4(-1,2,2)\), so \(l:\ \mathbf{r}=(1,0,4)+\lambda(-1,2,2)\). (c) \(\overrightarrow{AB}=(0,3,-3)\); \(\overrightarrow{AB}\cdot(-1,2,2)=0\), so \(AB\perp l\). \(|\overrightarrow{AB}|=3\sqrt2\); distance from \(B\) to \(p_{2}=|\overrightarrow{AB}|\sin\theta=3\sqrt2\cdot\dfrac{2}{\sqrt{13}}=\dfrac{12}{\sqrt{26}}\). (d) \(p_{3}\) has normal \((-1,2,2)\) and passes through \(B(1,3,1)\): \(-1+6+2=7\), so \(-x+2y+2z=7\).$$,
  11,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the sine of the acute angle between \\(p_{1}\\) and \\(p_{2}\\) in the form \\(\\dfrac{m}{\\sqrt{n}}\\), where \\(m\\) and \\(n\\) are positive integers to be determined. \\([3]\\)",
    "correct_answer": "\\frac{2}{\\sqrt{13}}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "m", "label": "m", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "n", "label": "n", "correct_answer": "13", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Verify that the point \\(A\\) with coordinates \\((1,0,4)\\) lies on \\(p_{1}\\) and \\(p_{2}\\). Hence, without a calculator, find the vector equation of the line \\(l\\) formed by the intersection of \\(p_{1}\\) and \\(p_{2}\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "\\(B\\) is a point on \\(p_{1}\\) with coordinates \\((1,3,1)\\). Show that \\(AB\\) is perpendicular to \\(l\\) and hence use part (a) to deduce exactly the shortest distance from \\(B\\) to \\(p_{2}\\). \\([3]\\)",
    "correct_answer": "\\frac{12}{\\sqrt{26}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find the cartesian equation of the plane \\(p_{3}\\) which contains \\(B\\) and is perpendicular to both \\(p_{1}\\) and \\(p_{2}\\). \\([2]\\)",
    "correct_answer": "-x+2y+2z=7",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q6 [1]+[3]+[2] Probability
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Two dice: mutually exclusive, independent, conditional$$,
  $$Two fair six-sided dice are thrown. Events \(A\), \(B\) and \(C\) are defined as follows. \(A\): the sum of the two scores is odd. \(B\): at least one of the two scores is greater than 4. \(C\): the two scores are equal.$$,
  'exact',
  $$\frac{1}{10}$$,
  NULL,
  $$(a)(i) If the scores are equal the sum is even, so \(A\) and \(C\) cannot occur together: \(A\) and \(C\) are mutually exclusive. (a)(ii) \(P(A)=\tfrac12\), \(P(B)=\tfrac59\), \(P(A\cap B)=\tfrac{10}{36}=\tfrac{5}{18}=P(A)P(B)\), so \(A\) and \(B\) are independent. (b) \(P(C\mid B)=\dfrac{P(C\cap B)}{P(B)}=\dfrac{P(5,5)+P(6,6)}{P(B)}=\dfrac{2/36}{5/9}=\dfrac{1}{10}\).$$,
  6,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "Find, giving your reasons clearly, which pair of the events are mutually exclusive. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "aii",
    "prompt_latex": "Find, giving your reasons clearly, which pair of the events are independent. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(P(C\\mid B)\\). \\([2]\\)",
    "correct_answer": "\\frac{1}{10}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q7 [1]+[1]+[3]+[2]+[2] Discrete Random Variables
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251007-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Difference of successes and failures in 5 trials$$,
  $$The random variable \(S\) is the number of successes in 5 independent trials with probability of success \(\tfrac13\) in each. The random variable \(D\) is the difference between the number of successes and the number of failures in 5 such trials.$$,
  'exact',
  $$\frac{65}{9}$$,
  NULL,
  $$\(S\sim\mathrm{B}(5,\tfrac13)\) and \(D=|S-(5-S)|=|2S-5|\). (a) \(D\) takes the values \(1,3,5\). (b) \(P(D=1)=P(S=2)+P(S=3)=\tfrac{40}{81}\). (c) \(P(D=1)=\tfrac{40}{81}\), \(P(D=3)=\tfrac{10}{27}\), \(P(D=5)=\tfrac{11}{81}\); \(E(D^{2})=1\cdot\tfrac{40}{81}+9\cdot\tfrac{10}{27}+25\cdot\tfrac{11}{81}=\tfrac{65}{9}\). (d) \(E(S)=\tfrac53\), \(E(S^{2})=\mathrm{Var}(S)+[E(S)]^{2}=\tfrac{10}{9}+\tfrac{25}{9}=\tfrac{35}{9}\). (e) \(D^{2}=(2S-5)^{2}=4S^{2}-20S+25\Rightarrow E(D^{2})=4\cdot\tfrac{35}{9}-20\cdot\tfrac53+25=\tfrac{65}{9}\), verifying part (c).$$,
  9,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State the values that \\(D\\) can take. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Show that \\(P(D=1)=\\dfrac{40}{81}\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "By finding the probability distribution of \\(D\\), find the exact value of \\(E(D^{2})\\). \\([3]\\)",
    "correct_answer": "\\frac{65}{9}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find the exact values of \\(E(S)\\) and \\(E(S^{2})\\). \\([2]\\)",
    "correct_answer": "E(S)=\\frac{5}{3},\\ E(S^{2})=\\frac{35}{9}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "es", "label": "E(S)", "correct_answer": "\\frac{5}{3}", "answer_type": "exact", "tolerance": null },
      { "key": "es2", "label": "E(S^{2})", "correct_answer": "\\frac{35}{9}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "e",
    "prompt_latex": "Hence, by showing that \\(D^{2}=4S^{2}-20S+25\\), verify the value of \\(E(D^{2})\\) found in part (c). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q8 [2]+[6]+[2] Hypothesis Testing
-- FLAG: Q8(b) confidence-style set of values of w — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251008-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  $$Two-tailed test on the mean mass of adult trout$$,
  $$Helen tests whether a water-treatment plant has changed the mean mass of adult trout (previously \(w\) kg) at the \(10\%\) level. She catches \(45\) trout with masses \(X\) kg summarised by \(n=45\), \(\sum x=80.1\), \(\sum(x-\bar{x})^{2}=24.29\).$$,
  'exact',
  $$1.60<w<1.96$$,
  NULL,
  $$(a) \(\bar{x}=\dfrac{80.1}{45}=1.78\); \(s^{2}=\dfrac{24.29}{44}=0.55205\approx0.552\). (b) \(H_{0}:\mu=w\) vs \(H_{1}:\mu\ne w\) at \(10\%\). Since \(n=45\) is large, by the CLT \(\bar{X}\sim\mathrm{N}\!\left(w,\tfrac{s^{2}}{45}\right)\) approximately; \(z_{\text{calc}}=\dfrac{1.78-w}{s/\sqrt{45}}\). \(H_{0}\) not rejected when \(-1.6448<\dfrac{1.78-w}{\sqrt{0.55205}/\sqrt{45}}<1.6448\Rightarrow1.5978<w<1.9622\Rightarrow\{w:1.60<w<1.96\}\). (c) Since \(n=45\) is large, by the Central Limit Theorem the sample mean is approximately normal, so the population distribution need not be known.$$,
  10,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Calculate unbiased estimates of the population mean and variance of the mass of adult trout. \\([2]\\)",
    "correct_answer": "\\bar{x}=1.78,\\ s^{2}=0.552",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "mean", "label": "\\text{mean}", "correct_answer": "1.78", "answer_type": "range", "tolerance": 0.005 },
      { "key": "var", "label": "\\text{variance}", "correct_answer": "0.552", "answer_type": "range", "tolerance": 0.005 }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Use an algebraic method to calculate the set of values of \\(w\\) for which there is insufficient evidence to conclude that the mean mass has changed. State your hypotheses and define any symbols. \\([6]\\)",
    "correct_answer": "1.60<w<1.96",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Explain why there is no need for Helen to know anything about the population distribution of the mass of adult trout. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- P2 Q9 [2]+[1]+[4]+[4] Binomial Distribution
-- FLAG: Q9(c) exact range of p — exact-match brittle but clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '60251009-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Faulty plates and bowls (binomial models)$$,
  $$A workshop makes 100 plates each working day; the number of faulty plates is modelled by \(\mathrm{B}(100,p)\).$$,
  'range',
  $$0.333$$,
  0.005,
  $$(a) Each plate is faulty with constant probability \(p\), and plates are faulty independently of one another. (b) \(P(X=3)=\binom{100}{3}p^{3}(1-p)^{97}=161700\,p^{3}(1-p)^{97}\). (c) Mode \(3\Rightarrow P(X=3)>P(X=2)\) and \(P(X=3)>P(X=4)\): \(\tfrac{98}{3}p>1-p\Rightarrow p>\tfrac{3}{101}\) and \(\tfrac{97}{4}p<1-p\Rightarrow p<\tfrac{4}{101}\); so \(\tfrac{3}{101}<p<\tfrac{4}{101}\). (d) With \(p=0.01\): \((0.99)^{2}(1-q)^{2}+2(0.99)(0.01)(1-q)^{2}+(0.99)^{2}(2q)(1-q)=0.88\Rightarrow0.9999(1-q)^{2}+1.9602q(1-q)=0.88\); by GC \(q=0.33333\approx0.333\).$$,
  11,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State, in context, two assumptions needed for the number of faulty plates made in a day to be well modelled by a binomial distribution. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Show that the probability that exactly 3 faulty plates are produced on a randomly chosen working day is \\(161700\\,p^{3}(1-p)^{97}\\). \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Given that the most likely number of faulty plates produced on a working day is 3, find the possible range of values of \\(p\\), leaving your answer in exact form. \\([4]\\)",
    "correct_answer": "\\frac{3}{101}<p<\\frac{4}{101}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "The number of faulty bowls follows a binomial distribution with probability \\(q\\), independent of plate faults. Sets contain 2 randomly chosen bowls and 2 randomly chosen plates. When \\(p=0.01\\), the probability that a set contains at most 1 faulty item is \\(0.88\\). Write down an equation satisfied by \\(q\\), and hence find the value of \\(q\\). \\([4]\\)",
    "correct_answer": "0.333",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- P2 Q10 [2]+[2]+[1]+[2]+[3] Correlation & Linear Regression
-- FLAG: Q10(d) inequality on S. Official guide writes "S >= 353", but that is a typo: the LSRL is the
-- minimiser and its own sum of squared residuals is 352.1937..., so the true bound is S >= 352.19
-- (>= 352 to 3 s.f.); "353" would be violated by the LSRL itself. Left null (revealed) since the
-- inequality's form (>= 352 vs >= 352.19 vs >= 352.194) is too brittle for exact-match.
-- Q10(b) scatter+line -> solution_graph in 077.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '6025100a-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  $$Time in a gallery vs age: regression and model choice$$,
  $$The time spent, \(t\) minutes, in an art gallery and the age, \(a\) years, of ten visitors are:
\[\begin{array}{|c|cccccccccc|}
\hline
t & 20 & 70 & 56 & 75 & k & 42 & 50 & 52 & 60 & 60\\
a & 21 & 56 & 42 & 77 & 22 & 34 & 40 & 41 & 48 & 47\\
\hline
\end{array}\]$$,
  'range',
  $$67.9$$,
  0.5,
  $$(a) \(\bar{a}=42.8\), \(\bar{t}=\tfrac{485+k}{10}\); \((\bar{a},\bar{t})\) lies on \(t=0.8957914a+14.16013\Rightarrow\tfrac{485+k}{10}=0.8957914(42.8)+14.16013\Rightarrow k=40\). (b) Scatter plot with a positive linear trend; the regression line passes through \((42.8,52.5)\). (c) \(t=0.8957914(60)+14.16013=67.9\approx68\) minutes. (d) The least-squares line minimises the sum of squared residuals \(=352.19\); any line \(t=ma+c\) gives \(S\ge352.19\). (e) Model A (\(t=p+\tfrac{q}{a}\)): \(r=-0.929\); Model B (\(t=pe^{qa}\Rightarrow\ln t=qa+\ln p\)): \(r=0.833\). Since \(|{-0.929}|>|0.833|\), Model A is more appropriate (\(|r|\) closer to 1).$$,
  10,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "A linear model is proposed for \\(t\\) and \\(a\\). Given that the least squares regression line of \\(t\\) on \\(a\\) is \\(t=0.8957914a+14.16013\\), show that \\(k=40\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Sketch a scatter diagram of \\(t\\) against \\(a\\) for the data, and draw the line in part (a) on the same diagram. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Use the least squares regression line of \\(t\\) on \\(a\\) to estimate the time spent in the gallery by a 60-year-old visitor. \\([1]\\)",
    "correct_answer": "67.9",
    "answer_type": "range",
    "tolerance": 0.5
  },
  {
    "label": "d",
    "prompt_latex": "A line \\(t=ma+c\\) is used to model the data, with sum of squared residuals \\(S=\\displaystyle\\sum_{i=1}^{10}\\left[t_{i}-(ma_{i}+c)\\right]^{2}\\). Find an inequality that is satisfied by \\(S\\). \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "For the models (A) \\(t=p+\\dfrac{q}{a}\\) and (B) \\(t=pe^{qa}\\), find the product moment correlation coefficient for each and explain, with a reason, which model is more appropriate. \\([3]\\)",
    "correct_answer": "r_{A}=-0.929,\\ r_{B}=0.833",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "ra", "label": "r_{A}", "correct_answer": "-0.929", "answer_type": "range", "tolerance": 0.005 },
      { "key": "rb", "label": "r_{B}", "correct_answer": "0.833", "answer_type": "range", "tolerance": 0.005 }
    ]
  }
]$$::jsonb
);

-- P2 Q11 [3]+[3]+[2]+[3]+[3] Normal Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '6025100b-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Masses of apples: normal distribution and combinations$$,
  $$A machine grades apples by mass. Apples over 120 g are "large" and under 80 g are "small"; in a large batch \(15\%\) are large and \(10\%\) are small. Masses are normally distributed. State the parameters of any normal distributions you use.$$,
  'range',
  $$0.276$$,
  0.002,
  $$(a) \(\dfrac{120-\mu}{\sigma}=1.0364\) and \(\dfrac{80-\mu}{\sigma}=-1.2816\); solving, \(\mu=102.12\approx102\), \(\sigma=17.256\approx17.3\). (b) \(X_{1}-X_{2}\sim\mathrm{N}(0,595.54)\); \(P(|X_{1}-X_{2}|\ge20)=0.412\). (c) \(P(110<X<140)=0.30988\); expected number \(=20(0.30988)=6.20\). (d) \(\bar{X}\sim\mathrm{N}\!\left(102.12,\tfrac{17.256^{2}}{20}\right)\); \(P(\bar{X}\le105)=0.772\). (e) Price of 3 boxes \(C=0.0029(T_{1}+T_{2}+T_{3})\sim\mathrm{N}(17.769,0.15025)\); \(P(C>18)=0.276\).$$,
  14,
  'NYJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the mean mass of a randomly chosen apple and show that the standard deviation is \\(17.3\\) g, correct to 3 significant figures. \\([3]\\)",
    "correct_answer": "102.12",
    "answer_type": "range",
    "tolerance": 0.5
  },
  {
    "label": "b",
    "prompt_latex": "Two apples are chosen at random. Find the probability that the difference in their masses is at least 20 g. \\([3]\\)",
    "correct_answer": "0.412",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "c",
    "prompt_latex": "Apples with mass between 110 g and 140 g are \"premium\". Find the expected number of premium apples in a randomly chosen box of 20. \\([2]\\)",
    "correct_answer": "6.20",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "d",
    "prompt_latex": "Find the probability that the mean mass of apples in a randomly chosen box is at most 105 g. \\([3]\\)",
    "correct_answer": "0.772",
    "answer_type": "range",
    "tolerance": 0.002
  },
  {
    "label": "e",
    "prompt_latex": "The boxes are sold by weight at \\(\\$2.90\\) per kilogram. Find the probability that the total price of 3 randomly chosen boxes exceeds \\(\\$18\\). \\([3]\\)",
    "correct_answer": "0.276",
    "answer_type": "range",
    "tolerance": 0.002
  }
]$$::jsonb
);
