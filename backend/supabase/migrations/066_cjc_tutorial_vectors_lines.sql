-- Migration 066: CJC 2021 JC1 H2 Math Tutorial — Vectors (Lines) (DISCUSSION only, 9 questions)
-- Source: TUTORIAL/VECTORS QNS/2. 2021 Vectors (Lines) (Teacher).pdf, DISCUSSION section (pp.23-25).
-- REVIEW PROBLEMS + Self-Practice deliberately excluded. Answers verified/re-derived against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Vectors (Lines))', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'e' (Vectors Lines) + 3-digit Q# -> cc21e001..cc21e009. Topic aaaa0009.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading: intersection points -> multi-box [x,y,z] (FLAG-enabled range); angles/distances -> range;
--          Q9(i) scalar range. Vector-equation answers, line classifications (parallel/skew), compound
--          Cartesian equations and "show that" parts are left null (revealed via solution_latex).
-- FLAG: coordinate multi-boxes and single Cartesian scalars are brittle to exact-match; graded via range.

-- Q1 (BASIC): classify four line pairs; find intersection + acute angle where they meet.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e001-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  1,
  $$Parallel, intersecting or skew lines$$,
  $$Find whether each of the following pairs of lines is parallel, intersecting or skew. If they intersect, find the point of intersection and the acute angle between the lines.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(a) Directions \(\begin{pmatrix}3\\4\\1\end{pmatrix}\) and \(\begin{pmatrix}9\\12\\3\end{pmatrix}=3\begin{pmatrix}3\\4\\1\end{pmatrix}\) are parallel; the point \((1,-1,1)\) is not on the second line, so the lines are parallel (and distinct). (b) Solving the two lines gives \(s=-2\) from the third component, which is inconsistent with the other two, so the lines are skew. (c) Solving \(4+\alpha=7+6\beta\), \(8+2\alpha=6+4\beta\), \(3+\alpha=5+5\beta\) gives \(\alpha=-3\), \(\beta=-1\); the lines intersect at \((1,2,0)\). The acute angle satisfies \(\cos\theta=\dfrac{|(1,2,1)\cdot(6,4,5)|}{\sqrt6\,\sqrt{77}}=\dfrac{19}{\sqrt{462}}\Rightarrow\theta\approx0.487\text{ rad}\;(27.9^\circ)\). (d) The line meets the \(z\)-axis \(\mathbf{r}=\gamma\begin{pmatrix}0\\0\\1\end{pmatrix}\) when \(4+2\lambda=0\) and \(2+\lambda=0\), giving \(\lambda=-2\) and intersection \((0,0,5)\). The acute angle satisfies \(\cos\theta=\dfrac{|(2,1,-2)\cdot(0,0,1)|}{3}=\dfrac23\Rightarrow\theta\approx0.841\text{ rad}\;(48.2^\circ)\).$$,
  8,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "a",
    "prompt_latex": "\\(\\mathbf{r}=\\begin{pmatrix}1\\\\-1\\\\1\\end{pmatrix}+\\lambda\\begin{pmatrix}3\\\\4\\\\1\\end{pmatrix}\\) and \\(\\mathbf{r}=\\begin{pmatrix}1\\\\2\\\\3\\end{pmatrix}+\\mu\\begin{pmatrix}9\\\\12\\\\3\\end{pmatrix}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "\\(\\mathbf{r}=\\begin{pmatrix}1\\\\0\\\\3\\end{pmatrix}+s\\begin{pmatrix}2\\\\1\\\\1\\end{pmatrix}\\) and \\(\\mathbf{r}=\\begin{pmatrix}2\\\\-1\\\\1\\end{pmatrix}+t\\begin{pmatrix}1\\\\-2\\\\0\\end{pmatrix}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "\\(\\mathbf{r}=4\\mathbf{i}+8\\mathbf{j}+3\\mathbf{k}+\\alpha(\\mathbf{i}+2\\mathbf{j}+\\mathbf{k})\\) and \\(\\mathbf{r}=7\\mathbf{i}+6\\mathbf{j}+5\\mathbf{k}+\\beta(6\\mathbf{i}+4\\mathbf{j}+5\\mathbf{k})\\). Give the point of intersection \\((x,y,z)\\) and the acute angle in degrees.",
    "correct_answer": "(1, 2, 0); 27.9 degrees",
    "answer_type": "range",
    "tolerance": 0.1,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "2", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "0", "answer_type": "range", "tolerance": 0.05 },
      { "key": "angle", "label": "angle (°)", "correct_answer": "27.9", "answer_type": "range", "tolerance": 0.1 }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "\\(\\mathbf{r}=\\begin{pmatrix}4\\\\2\\\\1\\end{pmatrix}+\\lambda\\begin{pmatrix}2\\\\1\\\\-2\\end{pmatrix}\\) and the \\(z\\)-axis. Give the point of intersection \\((x,y,z)\\) and the acute angle in degrees.",
    "correct_answer": "(0, 0, 5); 48.2 degrees",
    "answer_type": "range",
    "tolerance": 0.1,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "0", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "0", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "angle", "label": "angle (°)", "correct_answer": "48.2", "answer_type": "range", "tolerance": 0.1 }
    ]
  }
]$$::jsonb
);

-- Q2 (INTERMEDIATE): re-do the cevian intersection using vector equations of lines. Vector answer -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e002-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  2,
  $$Intersection of two cevians (line method)$$,
  $$With reference to the origin \(O\), \(\overrightarrow{OA}=\mathbf{a}\) and \(\overrightarrow{OB}=\mathbf{b}\). The point \(C\) lies on \(OA\) produced with \(\overrightarrow{AC}=5\mathbf{a}\), and the point \(D\) lies on \(OB\) produced with \(\overrightarrow{BD}=3\mathbf{b}\). Using vector equations of the lines \(AD\) and \(BC\), find \(\overrightarrow{OE}\) in terms of \(\mathbf{a}\) and \(\mathbf{b}\), where \(E\) is the point at which \(AD\) and \(BC\) cross.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(\overrightarrow{OC}=6\mathbf{a}\), \(\overrightarrow{OD}=4\mathbf{b}\). Line \(AD\): \(\mathbf{r}=\mathbf{a}+s(4\mathbf{b}-\mathbf{a})=(1-s)\mathbf{a}+4s\,\mathbf{b}\); line \(BC\): \(\mathbf{r}=\mathbf{b}+t(6\mathbf{a}-\mathbf{b})=6t\,\mathbf{a}+(1-t)\mathbf{b}\). Comparing coefficients of the non-parallel \(\mathbf{a}\), \(\mathbf{b}\): \(1-s=6t\), \(4s=1-t\). Solving gives \(s=\tfrac{5}{23}\), so \(\overrightarrow{OE}=\dfrac{18}{23}\mathbf{a}+\dfrac{20}{23}\mathbf{b}\).$$,
  4,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\overrightarrow{OE}\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q3 (INTERMEDIATE): cube diagonals (cube described in prose). Vector parts null; diagonal angle graded range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e003-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  2,
  $$Angle between two diagonals of a cube$$,
  $$\(OABCDEFG\) is a cube of edge \(5\) cm. Taking \(O\) as the origin with \(\mathbf{i}\), \(\mathbf{j}\) and \(\mathbf{k}\) as unit vectors along the edges \(OA\), \(OC\) and \(OD\) respectively, the vertices are \(O(0,0,0)\), \(A(5,0,0)\), \(B(5,5,0)\), \(C(0,5,0)\), \(D(0,0,5)\), \(E(5,0,5)\), \(F(5,5,5)\) and \(G(0,5,5)\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(a)(i) \(\overrightarrow{OF}=\overrightarrow{OF}-\overrightarrow{OO}=\begin{pmatrix}5\\5\\5\end{pmatrix}=5\mathbf{i}+5\mathbf{j}+5\mathbf{k}\). (ii) \(\overrightarrow{AG}=\overrightarrow{OG}-\overrightarrow{OA}=\begin{pmatrix}0\\5\\5\end{pmatrix}-\begin{pmatrix}5\\0\\0\end{pmatrix}=-5\mathbf{i}+5\mathbf{j}+5\mathbf{k}\). (b) \(\cos\theta=\dfrac{|\overrightarrow{OF}\cdot\overrightarrow{AG}|}{|\overrightarrow{OF}||\overrightarrow{AG}|}=\dfrac{|-25+25+25|}{\sqrt{75}\,\sqrt{75}}=\dfrac{25}{75}=\dfrac13\), so \(\theta\approx1.23\text{ rad}\;(70.5^\circ)\).$$,
  5,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "a-i",
    "prompt_latex": "Find \\(\\overrightarrow{OF}\\) in terms of \\(\\mathbf{i}\\), \\(\\mathbf{j}\\) and \\(\\mathbf{k}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "a-ii",
    "prompt_latex": "Find \\(\\overrightarrow{AG}\\) in terms of \\(\\mathbf{i}\\), \\(\\mathbf{j}\\) and \\(\\mathbf{k}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the angle between the diagonals \\(OF\\) and \\(AG\\), in degrees.",
    "correct_answer": "70.5",
    "answer_type": "range",
    "tolerance": 0.1
  }
]$$::jsonb
);

-- Q4 (INTERMEDIATE): point on a line + perpendicular distance. (i) show -> null; (ii) distance range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e004-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  2,
  $$Point on a line and perpendicular distance$$,
  $$A line has vector equation \(\mathbf{r}=(\mathbf{i}+2\mathbf{j}+3\mathbf{k})+\lambda(\mathbf{i}+2\mathbf{j}+5\mathbf{k})\), \(\lambda\in\mathbb{R}\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) Setting \(\mathbf{i}+\lambda=3\) gives \(\lambda=2\); then \(2+2\lambda=6\) and \(3+5\lambda=13\), so \(A(3,6,13)\) lies on the line. (ii) Take \(Q(1,2,3)\) on the line and \(\mathbf{d}=\begin{pmatrix}1\\2\\5\end{pmatrix}\). \(\overrightarrow{QB}=\begin{pmatrix}0\\5\\1\end{pmatrix}\), \(\overrightarrow{QB}\times\mathbf{d}=\begin{pmatrix}23\\1\\-5\end{pmatrix}\), \(|\overrightarrow{QB}\times\mathbf{d}|=\sqrt{555}\). Perpendicular distance \(=\dfrac{\sqrt{555}}{\sqrt{30}}=\sqrt{\dfrac{37}{2}}\approx4.30\) units.$$,
  5,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that the point \\(A(3,6,13)\\) lies on the line.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the perpendicular distance from the point \\(B(1,7,4)\\) to the line.",
    "correct_answer": "4.301",
    "answer_type": "range",
    "tolerance": 0.01
  }
]$$::jsonb
);

-- Q5 (INTERMEDIATE): equation of a line, projection length, perpendicular distance.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e005-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  2,
  $$Line through two points, projection and distance$$,
  $$The line \(l\) passes through the points \(A(2,-1,5)\) and \(B(-1,-4,2)\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\overrightarrow{AB}=\begin{pmatrix}-3\\-3\\-3\end{pmatrix}=-3\begin{pmatrix}1\\1\\1\end{pmatrix}\), so \(l:\ \mathbf{r}=\begin{pmatrix}2\\-1\\5\end{pmatrix}+\lambda\begin{pmatrix}1\\1\\1\end{pmatrix}\). (ii) With \(P(4,5,3)\), \(\overrightarrow{AP}=\begin{pmatrix}2\\6\\-2\end{pmatrix}\). Length of projection of \(\overrightarrow{AP}\) on \(l\) is \(\dfrac{|\overrightarrow{AP}\cdot(1,1,1)|}{\sqrt3}=\dfrac{6}{\sqrt3}=2\sqrt3\) units. (iii) Perpendicular distance \(=\sqrt{|\overrightarrow{AP}|^2-(2\sqrt3)^2}=\sqrt{44-12}=\sqrt{32}=4\sqrt2\) units.$$,
  6,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find a vector equation of \\(l\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the length of projection of \\(\\overrightarrow{AP}\\) on \\(l\\), where \\(P(4,5,3)\\).",
    "correct_answer": "3.464",
    "answer_type": "range",
    "tolerance": 0.01
  },
  {
    "label": "iii",
    "prompt_latex": "Hence find the perpendicular distance from the point \\(P\\) to \\(l\\).",
    "correct_answer": "5.657",
    "answer_type": "range",
    "tolerance": 0.01
  }
]$$::jsonb
);

-- Q6 (INTERMEDIATE): two parallel lines; explain + distance between them. (a) explain -> null; (b) distance range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e006-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  2,
  $$Distance between two parallel lines$$,
  $$Two lines are given by \(l_1:\ 4(1-x)=y=2z+4\) and \(l_2:\ 8-4x=y+3=2z\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$Writing each line in vector form: \(l_1:\ \mathbf{r}=\begin{pmatrix}1\\0\\-2\end{pmatrix}+t\begin{pmatrix}-1\\4\\2\end{pmatrix}\) and \(l_2:\ \mathbf{r}=\begin{pmatrix}2\\-3\\0\end{pmatrix}+s\begin{pmatrix}-1\\4\\2\end{pmatrix}\). (a) The direction vectors are identical, so \(l_1\) and \(l_2\) are parallel. (b) With \(\overrightarrow{Q_1Q_2}=\begin{pmatrix}1\\-3\\2\end{pmatrix}\), \(\mathbf{d}=\begin{pmatrix}-1\\4\\2\end{pmatrix}\): \(\overrightarrow{Q_1Q_2}\times\mathbf{d}=\begin{pmatrix}-14\\-4\\1\end{pmatrix}\), \(|\cdots|=\sqrt{213}\), \(|\mathbf{d}|=\sqrt{21}\). Distance \(=\dfrac{\sqrt{213}}{\sqrt{21}}=\sqrt{\dfrac{71}{7}}\approx3.19\) units.$$,
  5,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Explain why \\(l_1\\) and \\(l_2\\) are parallel.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the distance between \\(l_1\\) and \\(l_2\\).",
    "correct_answer": "3.187",
    "answer_type": "range",
    "tolerance": 0.01
  }
]$$::jsonb
);

-- Q7 (ADVANCED): solve a cross-product equation; describe the set geometrically. Vector/prose -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e007-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  3,
  $$Set of vectors satisfying a cross-product equation$$,
  $$The variable vector \(\mathbf{v}\) satisfies the equation \(\mathbf{v}\times(\mathbf{i}-3\mathbf{k})=2\mathbf{j}\). Find the set of vectors \(\mathbf{v}\) and describe this set geometrically.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$Let \(\mathbf{v}=\begin{pmatrix}x\\y\\z\end{pmatrix}\). Then \(\mathbf{v}\times\begin{pmatrix}1\\0\\-3\end{pmatrix}=\begin{pmatrix}-3y\\3x+z\\-y\end{pmatrix}=\begin{pmatrix}0\\2\\0\end{pmatrix}\). Hence \(y=0\) and \(3x+z=2\), i.e. \(z=2-3x\). So \(\mathbf{v}=\begin{pmatrix}x\\0\\2-3x\end{pmatrix}=\begin{pmatrix}0\\0\\2\end{pmatrix}+x\begin{pmatrix}1\\0\\-3\end{pmatrix}\). The set represents the position vectors of the points on the line through \((0,0,2)\) with direction \(\begin{pmatrix}1\\0\\-3\end{pmatrix}\).$$,
  4,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the set of vectors \\(\\mathbf{v}\\) and describe this set geometrically.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): line through two points, foot of perpendicular, reflected line.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e008-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  3,
  $$Line, foot of perpendicular and reflected line$$,
  $$The points \(A\) and \(B\) have position vectors \(7\mathbf{i}+8\mathbf{j}+9\mathbf{k}\) and \(-\mathbf{i}-8\mathbf{j}+\mathbf{k}\) respectively.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\overrightarrow{AB}=\begin{pmatrix}-8\\-16\\-8\end{pmatrix}=-8\begin{pmatrix}1\\2\\1\end{pmatrix}\), so the line is \(\mathbf{r}=\begin{pmatrix}7\\8\\9\end{pmatrix}+\lambda\begin{pmatrix}1\\2\\1\end{pmatrix}\). (ii) With \(C(1,8,3)\), let \(N=(7+\lambda,8+2\lambda,9+\lambda)\). \(\overrightarrow{CN}\cdot\begin{pmatrix}1\\2\\1\end{pmatrix}=0\Rightarrow(6+\lambda)+2(2\lambda)+(6+\lambda)=12+6\lambda=0\Rightarrow\lambda=-2\), so \(N(5,4,7)\). Since \(A\) is at \(\lambda=0\), \(N\) at \(\lambda=-2\) and \(B\) at \(\lambda=-8\), \(AN:NB=2:6=1:3\). (iii) The reflection of \(C\) in the line is \(C'=2N-C=(9,0,11)\); the reflected line passes through \(A(7,8,9)\) and \(C'\) with direction \(\begin{pmatrix}2\\-8\\2\end{pmatrix}=2\begin{pmatrix}1\\-4\\1\end{pmatrix}\), giving \(x-7=\dfrac{y-8}{-4}=z-9\).$$,
  8,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find a vector equation of the line through \\(A\\) and \\(B\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "The perpendicular to this line from the point \\(C\\) with position vector \\(\\mathbf{i}+8\\mathbf{j}+3\\mathbf{k}\\) meets the line at \\(N\\). Find the coordinates \\((x,y,z)\\) of \\(N\\). (The ratio \\(AN:NB\\) is given in the solution.)",
    "correct_answer": "(5, 4, 7)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "4", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "7", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "iii",
    "prompt_latex": "Find a Cartesian equation of the line which is a reflection of the line \\(AC\\) in the line \\(AB\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q9 (ADVANCED): cables meeting; minimise a length. (i) scalar range; (ii) show -> null; (iii) coords + length.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21e009-0000-0000-0000-000000000000',
  'aaaa0009-0000-0000-0000-000000000000',
  3,
  $$Electricity cables — intersection and minimum length$$,
  $$Electrical engineers are installing electricity cables on a building site. Points \((x,y,z)\) are defined relative to a main switching site at \((0,0,0)\), where units are metres; cables are laid in straight lines and their widths may be neglected. An existing cable \(C\) starts at the main switching site and goes in the direction \(\begin{pmatrix}3\\1\\-2\end{pmatrix}\). A new cable is installed which passes through the points \(P(1,2,-1)\) and \(Q(5,7,a)\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) Cable \(C:\ \mathbf{r}=\mu\begin{pmatrix}3\\1\\-2\end{pmatrix}\); the new cable is \(\mathbf{r}=\begin{pmatrix}1\\2\\-1\end{pmatrix}+t\begin{pmatrix}4\\5\\a+1\end{pmatrix}\). From \(3\mu=1+4t\) and \(\mu=2+5t\): \(t=-\tfrac{5}{11}\), \(\mu=-\tfrac{3}{11}\). The third component gives \(-2\mu=-1+t(a+1)\Rightarrow a=-\tfrac{22}{5}\). (iii) With \(a=-3\), let \(R=\mu\begin{pmatrix}3\\1\\-2\end{pmatrix}\). Minimising \(PR\) means \(\overrightarrow{PR}\cdot\begin{pmatrix}3\\1\\-2\end{pmatrix}=0\): \(3(3\mu-1)+(\mu-2)-2(-2\mu+1)=14\mu-7=0\Rightarrow\mu=\tfrac12\), so \(R\left(\tfrac32,\tfrac12,-1\right)\). Then \(\overrightarrow{PR}=\begin{pmatrix}1/2\\-3/2\\0\end{pmatrix}\) and the minimum length is \(\sqrt{\tfrac14+\tfrac94}=\dfrac{\sqrt{10}}{2}\approx1.58\) m. (ii) For \(\angle PRQ=90^\circ\) one shows \(\overrightarrow{RP}\cdot\overrightarrow{RQ}\) cannot be zero for any \(R\) on \(C\), so it is not possible.$$,
  8,
  'H2 Math Tutorial (Vectors (Lines))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the value of \\(a\\) for which \\(C\\) and the new cable will meet.",
    "correct_answer": "-4.4",
    "answer_type": "range",
    "tolerance": 0.01
  },
  {
    "label": "ii",
    "prompt_latex": "It is now given that \\(a=-3\\). The engineers wish to connect \\(P\\) and \\(Q\\) to a point \\(R\\) on \\(C\\). Show that it is not possible for angle \\(PRQ\\) to be \\(90^\\circ\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "The engineers make the length of \\(PR\\) as small as possible. Find the coordinates \\((x,y,z)\\) of \\(R\\) and the exact minimum length (in metres).",
    "correct_answer": "R(3/2, 1/2, -1); length (1/2)sqrt(10)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "0.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "-1", "answer_type": "range", "tolerance": 0.05 },
      { "key": "length", "label": "min length", "correct_answer": "1.581", "answer_type": "range", "tolerance": 0.01 }
    ]
  }
]$$::jsonb
);
