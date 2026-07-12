-- Migration 065: CJC 2021 JC1 H2 Math Tutorial — Vectors (Basic) (DISCUSSION only, 11 questions)
-- Source: TUTORIAL/VECTORS QNS/1. 2021 Vectors (Basic) (Teacher).pdf, DISCUSSION section (pp.37-38).
-- REVIEW PROBLEMS + Self-Practice deliberately excluded. Answers verified/re-derived against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Vectors (Basic))', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'd' (Vectors Basic) + 3-digit Q# -> cc21d001..cc21d00b. Topic aaaa0008.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading: clean scalars graded (Q2 exact, Q4 exact, Q5 angle/area range). All vector-valued answers
--          (unit vectors, position vectors), show/prove/identify/interpret parts and two-valued answers
--          are left null (revealed via solution_latex) per house convention for brittle vector answers.

-- Q1 (BASIC): unit-vector scaling. Vector-valued answer -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d001-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  1,
  $$Vector of given magnitude and direction$$,
  $$Find the vector \(\mathbf{p}\) given that \(|\mathbf{p}|=6\) and \(\mathbf{p}\) is in the direction of \(2\mathbf{i}-3\mathbf{j}+6\mathbf{k}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(|2\mathbf{i}-3\mathbf{j}+6\mathbf{k}|=\sqrt{2^2+(-3)^2+6^2}=\sqrt{49}=7\). Hence \(\mathbf{p}=6\cdot\dfrac{2\mathbf{i}-3\mathbf{j}+6\mathbf{k}}{7}=\dfrac{6}{7}\begin{pmatrix}2\\-3\\6\end{pmatrix}=\dfrac{12}{7}\mathbf{i}-\dfrac{18}{7}\mathbf{j}+\dfrac{36}{7}\mathbf{k}\).$$,
  2,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the vector \\(\\mathbf{p}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q2 (BASIC): collinearity -> single scalar p. Graded exact.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc21d002-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  1,
  $$Collinear points — find the parameter$$,
  $$The position vectors of \(A\), \(B\) and \(C\) are \(\mathbf{a}=\mathbf{i}-\mathbf{j}+2\mathbf{k}\), \(\mathbf{b}=3\mathbf{i}+5\mathbf{j}-2\mathbf{k}\) and \(\mathbf{c}=p\mathbf{j}+4\mathbf{k}\) respectively. Find the value of \(p\) such that \(A\), \(B\) and \(C\) are collinear.$$,
  'exact',
  $$-4$$,
  NULL,
  $$\(\overrightarrow{AB}=\mathbf{b}-\mathbf{a}=2\mathbf{i}+6\mathbf{j}-4\mathbf{k}\) and \(\overrightarrow{AC}=\mathbf{c}-\mathbf{a}=-\mathbf{i}+(p+1)\mathbf{j}+2\mathbf{k}\). For collinearity \(\overrightarrow{AC}=k\,\overrightarrow{AB}\). Comparing \(\mathbf{i}\): \(-1=2k\Rightarrow k=-\tfrac12\); comparing \(\mathbf{k}\): \(2=-4k\Rightarrow k=-\tfrac12\) (consistent). Comparing \(\mathbf{j}\): \(p+1=6k=-3\Rightarrow p=-4\).$$,
  2,
  'H2 Math Tutorial (Vectors (Basic))'
);

-- Q3 (BASIC): unit vectors perpendicular to two vectors (cross product). Vector-valued -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d003-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  1,
  $$Unit vectors perpendicular to two vectors$$,
  $$\(A\), \(B\) and \(C\) are the points \((0,1,2)\), \((3,2,1)\) and \((1,-1,0)\) respectively. Find the unit vectors perpendicular to both \(\overrightarrow{AB}\) and \(\overrightarrow{AC}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(\overrightarrow{AB}=\begin{pmatrix}3\\1\\-1\end{pmatrix}\), \(\overrightarrow{AC}=\begin{pmatrix}1\\-2\\-2\end{pmatrix}\). \(\overrightarrow{AB}\times\overrightarrow{AC}=\begin{pmatrix}(1)(-2)-(-1)(-2)\\(-1)(1)-(3)(-2)\\(3)(-2)-(1)(1)\end{pmatrix}=\begin{pmatrix}-4\\5\\-7\end{pmatrix}\), with magnitude \(\sqrt{16+25+49}=\sqrt{90}=3\sqrt{10}\). The required unit vectors are \(\pm\dfrac{1}{3\sqrt{10}}\begin{pmatrix}-4\\5\\-7\end{pmatrix}\).$$,
  3,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the unit vectors perpendicular to both \\(\\overrightarrow{AB}\\) and \\(\\overrightarrow{AC}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q4 (BASIC): magnitude of a cross product of combinations. Graded exact.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc21d004-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  1,
  $$Magnitude of a cross product$$,
  $$Given \(|\mathbf{a}\times\mathbf{b}|=4\), find the value of \(\left|(\mathbf{a}+2\mathbf{b})\times(3\mathbf{a}-\mathbf{b})\right|\).$$,
  'exact',
  $$28$$,
  NULL,
  $$Expanding, \((\mathbf{a}+2\mathbf{b})\times(3\mathbf{a}-\mathbf{b})=3(\mathbf{a}\times\mathbf{a})-(\mathbf{a}\times\mathbf{b})+6(\mathbf{b}\times\mathbf{a})-2(\mathbf{b}\times\mathbf{b})\). Since \(\mathbf{a}\times\mathbf{a}=\mathbf{b}\times\mathbf{b}=\mathbf{0}\) and \(\mathbf{b}\times\mathbf{a}=-\mathbf{a}\times\mathbf{b}\), this is \(-(\mathbf{a}\times\mathbf{b})-6(\mathbf{a}\times\mathbf{b})=-7(\mathbf{a}\times\mathbf{b})\). Hence the magnitude is \(7|\mathbf{a}\times\mathbf{b}|=7(4)=28\).$$,
  2,
  'H2 Math Tutorial (Vectors (Basic))'
);

-- Q5 (INTERMEDIATE): angle OAB + area of triangle. Both graded range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d005-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  2,
  $$Angle and area of a triangle$$,
  $$Relative to the origin \(O\), the points \(A\) and \(B\) have position vectors \(\mathbf{i}+3\mathbf{j}-2\mathbf{k}\) and \(-6\mathbf{i}+4\mathbf{j}-7\mathbf{k}\) respectively.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\overrightarrow{AO}=-\begin{pmatrix}1\\3\\-2\end{pmatrix}\), \(\overrightarrow{AB}=\begin{pmatrix}-7\\1\\-5\end{pmatrix}\). \(\cos\angle OAB=\dfrac{\overrightarrow{AO}\cdot\overrightarrow{AB}}{|\overrightarrow{AO}||\overrightarrow{AB}|}=\dfrac{(-1)(-7)+(-3)(1)+(2)(-5)}{\sqrt{14}\,\sqrt{75}}=\dfrac{-6}{\sqrt{14}\cdot5\sqrt3}\approx-0.1852\). So \(\angle OAB\approx100.7^\circ\). (ii) \(\overrightarrow{OA}\times\overrightarrow{OB}=\begin{pmatrix}1\\3\\-2\end{pmatrix}\times\begin{pmatrix}-6\\4\\-7\end{pmatrix}=\begin{pmatrix}-13\\19\\22\end{pmatrix}\), magnitude \(\sqrt{169+361+484}=\sqrt{1014}\). Area \(=\tfrac12\sqrt{1014}\approx15.9\).$$,
  5,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the size of angle \\(OAB\\), giving your answer to the nearest \\(0.1^\\circ\\).",
    "correct_answer": "100.7",
    "answer_type": "range",
    "tolerance": 0.1
  },
  {
    "label": "ii",
    "prompt_latex": "Find the area of triangle \\(OAB\\).",
    "correct_answer": "15.9",
    "answer_type": "range",
    "tolerance": 0.1
  }
]$$::jsonb
);

-- Q6 (INTERMEDIATE): show ABCD is a parallelogram + identify shape. Prose/proof -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d006-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  2,
  $$Parallelogram from vector conditions$$,
  $$Referred to an origin \(O\), the position vectors of four non-collinear points \(A\), \(B\), \(C\) and \(D\) are \(\mathbf{a}\), \(\mathbf{b}\), \(\mathbf{c}\) and \(\mathbf{d}\) respectively.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) From \(\mathbf{a}-\mathbf{b}=\mathbf{d}-\mathbf{c}\) we get \(\mathbf{b}-\mathbf{a}=\mathbf{c}-\mathbf{d}\), i.e. \(\overrightarrow{AB}=\overrightarrow{DC}\). Thus \(AB\) and \(DC\) are parallel and equal in length, so \(ABCD\) is a parallelogram. (b) \(|\mathbf{a}-\mathbf{c}|=|\overrightarrow{CA}|\) and \(|\mathbf{b}-\mathbf{d}|=|\overrightarrow{DB}|\) are the lengths of the two diagonals. Equal diagonals in a parallelogram \(\Rightarrow\) the parallelogram is a rectangle (a square if the sides are also equal).$$,
  4,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Given that \\(\\mathbf{a}-\\mathbf{b}=\\mathbf{d}-\\mathbf{c}\\), show that \\(ABCD\\) is a parallelogram.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given also that \\(|\\mathbf{a}-\\mathbf{c}|=|\\mathbf{b}-\\mathbf{d}|\\), identify the shape of the parallelogram \\(ABCD\\), justifying your answer.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (INTERMEDIATE): scalar-product identity + length of projection. Both "show that" -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d007-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  2,
  $$Scalar product and length of projection$$,
  $$The angle between two unit vectors \(\mathbf{a}\) and \(\mathbf{b}\) is \(\theta\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \((3\mathbf{a}-\mathbf{b})\cdot(\mathbf{a}+3\mathbf{b})=3\,\mathbf{a}\cdot\mathbf{a}+9\,\mathbf{a}\cdot\mathbf{b}-\mathbf{b}\cdot\mathbf{a}-3\,\mathbf{b}\cdot\mathbf{b}=3(1)+8(\mathbf{a}\cdot\mathbf{b})-3(1)=8\,\mathbf{a}\cdot\mathbf{b}=8\cos\theta\), using \(|\mathbf{a}|=|\mathbf{b}|=1\). (b) With \(\theta=60^\circ\), \(\mathbf{a}\cdot\mathbf{b}=\tfrac12\). Length of projection of \((3\mathbf{a}-\mathbf{b})\) onto \((\mathbf{a}+3\mathbf{b})\) is \(\dfrac{|(3\mathbf{a}-\mathbf{b})\cdot(\mathbf{a}+3\mathbf{b})|}{|\mathbf{a}+3\mathbf{b}|}\). Numerator \(=8(\tfrac12)=4\); \(|\mathbf{a}+3\mathbf{b}|^2=1+6(\tfrac12)+9=13\). Hence the length is \(\dfrac{4}{\sqrt{13}}\).$$,
  4,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "a",
    "prompt_latex": "By expanding the scalar product, show that \\((3\\mathbf{a}-\\mathbf{b})\\cdot(\\mathbf{a}+3\\mathbf{b})=8\\cos\\theta\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(\\theta=60^\\circ\\), show that the length of projection of \\((3\\mathbf{a}-\\mathbf{b})\\) onto \\((\\mathbf{a}+3\\mathbf{b})\\) is \\(\\dfrac{4}{\\sqrt{13}}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (INTERMEDIATE): perpendicularity, reflection point, geometric meanings. All show/vector/prose -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d008-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  2,
  $$Perpendicularity, reflection and geometric meaning$$,
  $$The points \(A\) and \(B\) have position vectors \(\mathbf{a}\) and \(\mathbf{b}\) respectively, relative to the origin \(O\), such that \(|\mathbf{a}|=|\mathbf{b}|\). The point \(P\) with position vector \(\mathbf{p}\) lies on \(AB\) such that \(\mathbf{b}\cdot\mathbf{p}=\mathbf{a}\cdot\mathbf{p}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(i) \(\mathbf{b}\cdot\mathbf{p}=\mathbf{a}\cdot\mathbf{p}\Rightarrow(\mathbf{b}-\mathbf{a})\cdot\mathbf{p}=0\), i.e. \(\overrightarrow{AB}\cdot\overrightarrow{OP}=0\), so \(AB\) is perpendicular to \(OP\). (ii) Writing \(\mathbf{p}=\mathbf{a}+t(\mathbf{b}-\mathbf{a})\) and imposing \((\mathbf{b}-\mathbf{a})\cdot\mathbf{p}=0\) with \(|\mathbf{a}|=|\mathbf{b}|\) gives \(t=\tfrac12\), so \(P\) is the midpoint of \(AB\) and \(\mathbf{p}=\tfrac12(\mathbf{a}+\mathbf{b})\). The reflection \(D\) of \(O\) in the line \(AB\) satisfies \(\overrightarrow{OD}=2\mathbf{p}=\mathbf{a}+\mathbf{b}\). (iii)(a) \(\dfrac{1}{|\mathbf{b}|}|\mathbf{a}\cdot\mathbf{b}|\) is the length of projection of \(\mathbf{a}\) onto \(\mathbf{b}\). (b) \(|\mathbf{a}\times\mathbf{b}|\) is the area of the parallelogram \(OADB\) (with \(D\) as above), i.e. twice the area of triangle \(OAB\).$$,
  6,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(AB\\) is perpendicular to \\(OP\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Determine the position vector of the point \\(D\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\), where \\(D\\) is the reflection of \\(O\\) about the line \\(AB\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "(a) Give the geometrical meaning of \\(\\dfrac{1}{|\\mathbf{b}|}|\\mathbf{a}\\cdot\\mathbf{b}|\\). (b) Give the geometrical meaning of \\(|\\mathbf{a}\\times\\mathbf{b}|\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q9 (ADVANCED): show a projection-length formula (ratio theorem). "Show that" -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d009-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Length of projection via the ratio theorem$$,
  $$Relative to an origin \(O\), the position vectors of \(A\) and \(B\) are \(\mathbf{a}\) and \(\mathbf{b}\) respectively, and \(\mathbf{c}\) is the position vector of the point \(C\) on \(AB\) which divides \(AB\) in the ratio \(3:1\). Given that angle \(AOB\) is acute, show that the length \(d\) of the projection of \(\overrightarrow{OC}\) on \(\overrightarrow{OB}\) is given by \(d=\dfrac{3}{4}|\mathbf{b}|+\dfrac{\mathbf{a}\cdot\mathbf{b}}{4|\mathbf{b}|}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$By the ratio theorem, \(\overrightarrow{OC}=\dfrac{1\cdot\mathbf{a}+3\cdot\mathbf{b}}{4}=\dfrac{\mathbf{a}+3\mathbf{b}}{4}\). The length of projection of \(\overrightarrow{OC}\) on \(\overrightarrow{OB}\) is \(\dfrac{\overrightarrow{OC}\cdot\mathbf{b}}{|\mathbf{b}|}=\dfrac{\frac14(\mathbf{a}+3\mathbf{b})\cdot\mathbf{b}}{|\mathbf{b}|}=\dfrac{\mathbf{a}\cdot\mathbf{b}+3|\mathbf{b}|^2}{4|\mathbf{b}|}=\dfrac{3}{4}|\mathbf{b}|+\dfrac{\mathbf{a}\cdot\mathbf{b}}{4|\mathbf{b}|}\). (The projection is positive because \(\angle AOB\) is acute.)$$,
  4,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(d=\\dfrac{3}{4}|\\mathbf{b}|+\\dfrac{\\mathbf{a}\\cdot\\mathbf{b}}{4|\\mathbf{b}|}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q10 (ADVANCED): cross-product relation + two values of lambda. (i) show, (ii) two-valued -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d00a-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Cross-product relation and possible values$$,
  $$Vectors \(\mathbf{a}\), \(\mathbf{b}\) and \(\mathbf{c}\) are such that \(\mathbf{a}\neq\mathbf{0}\) and \(\mathbf{a}\times3\mathbf{b}=2\mathbf{a}\times\mathbf{c}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(i) \(\mathbf{a}\times3\mathbf{b}=2\mathbf{a}\times\mathbf{c}\Rightarrow\mathbf{a}\times(3\mathbf{b}-2\mathbf{c})=\mathbf{0}\). Since \(\mathbf{a}\neq\mathbf{0}\), \(3\mathbf{b}-2\mathbf{c}\) is parallel to \(\mathbf{a}\), so \(3\mathbf{b}-2\mathbf{c}=\lambda\mathbf{a}\) for some constant \(\lambda\). (ii) With \(\mathbf{a}\), \(\mathbf{c}\) unit vectors, \(|\mathbf{b}|=4\) and the angle between \(\mathbf{b}\) and \(\mathbf{c}\) equal to \(60^\circ\): \(|3\mathbf{b}-2\mathbf{c}|^2=|\lambda\mathbf{a}|^2=\lambda^2\). Now \(|3\mathbf{b}-2\mathbf{c}|^2=9|\mathbf{b}|^2-12\,\mathbf{b}\cdot\mathbf{c}+4|\mathbf{c}|^2=9(16)-12(4)(1)\cos60^\circ+4(1)=144-24+4=124\). Hence \(\lambda^2=124\) and \(\lambda=\pm2\sqrt{31}\).$$,
  5,
  'H2 Math Tutorial (Vectors (Basic))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(3\\mathbf{b}-2\\mathbf{c}=\\lambda\\mathbf{a}\\), where \\(\\lambda\\) is a constant.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "It is now given that \\(\\mathbf{a}\\) and \\(\\mathbf{c}\\) are unit vectors, that \\(|\\mathbf{b}|=4\\) and that the angle between \\(\\mathbf{b}\\) and \\(\\mathbf{c}\\) is \\(60^\\circ\\). Using a suitable scalar product, find exactly the two possible values of \\(\\lambda\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q11 (ADVANCED): intersection of AD and BC (diagram given -> described in prose). Vector answer -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21d00b-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Intersection of two cevians$$,
  $$With reference to the origin \(O\), the points \(A\), \(B\), \(C\) and \(D\) are such that \(\overrightarrow{OA}=\mathbf{a}\) and \(\overrightarrow{OB}=\mathbf{b}\). The point \(C\) lies on \(OA\) produced with \(\overrightarrow{AC}=5\mathbf{a}\), and the point \(D\) lies on \(OB\) produced with \(\overrightarrow{BD}=3\mathbf{b}\). The lines \(AD\) and \(BC\) cross at \(E\). Find \(\overrightarrow{OE}\) in terms of \(\mathbf{a}\) and \(\mathbf{b}\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(\overrightarrow{OC}=\mathbf{a}+5\mathbf{a}=6\mathbf{a}\) and \(\overrightarrow{OD}=\mathbf{b}+3\mathbf{b}=4\mathbf{b}\). Line \(AD\): \(\mathbf{r}=\mathbf{a}+s(4\mathbf{b}-\mathbf{a})=(1-s)\mathbf{a}+4s\,\mathbf{b}\). Line \(BC\): \(\mathbf{r}=\mathbf{b}+t(6\mathbf{a}-\mathbf{b})=6t\,\mathbf{a}+(1-t)\mathbf{b}\). Equating coefficients (\(\mathbf{a}\), \(\mathbf{b}\) non-parallel): \(1-s=6t\) and \(4s=1-t\). Solving, \(t=1-4s\Rightarrow1-s=6(1-4s)\Rightarrow23s=5\Rightarrow s=\tfrac{5}{23}\). Hence \(\overrightarrow{OE}=\left(1-\tfrac{5}{23}\right)\mathbf{a}+4\left(\tfrac{5}{23}\right)\mathbf{b}=\dfrac{18}{23}\mathbf{a}+\dfrac{20}{23}\mathbf{b}\).$$,
  4,
  'H2 Math Tutorial (Vectors (Basic))',
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
