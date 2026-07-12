-- Migration 067: CJC 2021 JC1 H2 Math Tutorial — Vectors (Planes) (DISCUSSION only, 10 questions)
-- Source: TUTORIAL/VECTORS QNS/3. 2021 Vectors (Planes) (Teacher).pdf, DISCUSSION section (pp.30-33).
-- REVIEW PROBLEMS + Self-Practice deliberately excluded. Answers verified/re-derived against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Vectors (Planes))', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'f' (Vectors Planes) + 3-digit Q# -> cc21f001..cc21f00a. Topic aaaa0010.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading: intersection points / feet of perpendicular / images -> multi-box [x,y,z] (range); angles &
--          distances -> range; Q8(ii) scalar range; Q1 simple Cartesian plane equations -> FLAG exact.
--          Vector/scalar-product equations, line-of-intersection vector equations, two-valued answers,
--          compound/large-coefficient Cartesians, "show that" and interpret/describe parts -> null (revealed).
-- FLAG: Q1 Cartesian equations (x+y=1, -x+y+z=0, x=1) are brittle to exact-match; enabled with canonical forms.

-- Q1 (INTERMEDIATE): three planes, each in vector/scalar/Cartesian form. Grade the Cartesian equation per part.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f001-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Equations of planes in three forms$$,
  $$For each of the following, find a vector equation of \(\Pi\) in the form \(\mathbf{r}=\mathbf{a}+\lambda\mathbf{b}+\mu\mathbf{c}\), the scalar product (normal) form, and the Cartesian equation of \(\Pi\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\overrightarrow{AB}=\begin{pmatrix}-1\\1\\1\end{pmatrix}\), \(\overrightarrow{AC}=\begin{pmatrix}1\\-1\\2\end{pmatrix}\); normal \(=\overrightarrow{AB}\times\overrightarrow{AC}=\begin{pmatrix}3\\3\\0\end{pmatrix}\parallel\begin{pmatrix}1\\1\\0\end{pmatrix}\). \(\mathbf{r}=\begin{pmatrix}1\\0\\2\end{pmatrix}+\lambda\begin{pmatrix}-1\\1\\1\end{pmatrix}+\mu\begin{pmatrix}1\\-1\\2\end{pmatrix}\); \(\mathbf{r}\cdot\begin{pmatrix}1\\1\\0\end{pmatrix}=1\); \(x+y=1\). (b) Directions of \(l_1,l_2\) are \(\begin{pmatrix}1\\2\\-1\end{pmatrix}\), \(\begin{pmatrix}-1\\1\\-2\end{pmatrix}\); normal \(=\begin{pmatrix}-3\\3\\3\end{pmatrix}\parallel\begin{pmatrix}-1\\1\\1\end{pmatrix}\); through \((1,1,0)\): \(\mathbf{r}\cdot\begin{pmatrix}-1\\1\\1\end{pmatrix}=0\); \(-x+y+z=0\). (c) Parallel to the \(y\)-\(z\) plane \(\Rightarrow\) normal \(\begin{pmatrix}1\\0\\0\end{pmatrix}\); through \((1,0,2)\): \(\mathbf{r}\cdot\begin{pmatrix}1\\0\\0\end{pmatrix}=1\); \(x=1\).$$,
  9,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Plane \\(\\Pi\\) passes through the three points \\(A(1,0,2)\\), \\(B(0,1,3)\\), \\(C(2,-1,4)\\). Enter the Cartesian equation of \\(\\Pi\\).",
    "correct_answer": "x+y=1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Plane \\(\\Pi\\) contains the two lines \\(l_1:\\ \\mathbf{r}=(1+\\lambda)\\mathbf{i}+(1+2\\lambda)\\mathbf{j}-\\lambda\\mathbf{k}\\) and \\(l_2:\\ \\mathbf{r}=(2-\\mu)\\mathbf{i}+\\mu\\mathbf{j}+(2-2\\mu)\\mathbf{k}\\). Enter the Cartesian equation of \\(\\Pi\\).",
    "correct_answer": "-x+y+z=0",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Plane \\(\\Pi\\) contains the point \\(A(1,0,2)\\) and is parallel to the \\(y\\)-\\(z\\) plane. Enter the Cartesian equation of \\(\\Pi\\).",
    "correct_answer": "x=1",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q2 (INTERMEDIATE): relationship between line and plane. (i) intersect: point + angle; (ii) line lies on plane -> null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f002-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Line meeting a plane — point and angle$$,
  $$For each pair of line \(l\) and plane \(\Pi\), determine whether \(l\) intersects \(\Pi\) at a unique point, lies on \(\Pi\), or does not intersect \(\Pi\). If they meet at a unique point, find the point of intersection and the angle between \(l\) and \(\Pi\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) Substituting \(l:\ (3-2\lambda,-1+\lambda,1-3\lambda)\) into \(\mathbf{r}\cdot\begin{pmatrix}2\\1\\-3\end{pmatrix}=5\): \(2(3-2\lambda)+(-1+\lambda)-3(1-3\lambda)=2+6\lambda=5\Rightarrow\lambda=\tfrac12\), giving the point \(\left(2,-\tfrac12,-\tfrac12\right)\). \(\sin\theta=\dfrac{|\mathbf{d}\cdot\mathbf{n}|}{|\mathbf{d}||\mathbf{n}|}=\dfrac{|(-2)(2)+(1)(1)+(-3)(-3)|}{\sqrt{14}\,\sqrt{14}}=\dfrac{6}{14}=\dfrac37\Rightarrow\theta\approx0.443\text{ rad}\;(25.4^\circ)\). (ii) \(\mathbf{d}\cdot\mathbf{n}=(1)(2)+(1)(1)+(1)(-3)=0\) so \(l\) is parallel to \(\Pi\); the point \((2,1,0)\) satisfies \(2(2)+1-0=5\), so \(l\) lies on \(\Pi\).$$,
  6,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "\\(\\Pi:\\ \\mathbf{r}\\cdot\\begin{pmatrix}2\\\\1\\\\-3\\end{pmatrix}=5\\) and \\(l:\\ \\mathbf{r}=\\begin{pmatrix}3\\\\-1\\\\1\\end{pmatrix}+\\lambda\\begin{pmatrix}-2\\\\1\\\\-3\\end{pmatrix}\\). Give the point of intersection \\((x,y,z)\\) and the angle in degrees.",
    "correct_answer": "(2, -1/2, -1/2); 25.4 degrees",
    "answer_type": "range",
    "tolerance": 0.1,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "2", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "-0.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "-0.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "angle", "label": "angle (°)", "correct_answer": "25.4", "answer_type": "range", "tolerance": 0.1 }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "\\(\\Pi:\\ \\mathbf{r}\\cdot\\begin{pmatrix}2\\\\1\\\\-3\\end{pmatrix}=5\\) and \\(l:\\ \\mathbf{r}=\\begin{pmatrix}2\\\\1\\\\0\\end{pmatrix}+\\lambda\\begin{pmatrix}1\\\\1\\\\1\\end{pmatrix}\\). Describe the relationship between \\(l\\) and \\(\\Pi\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q3 (INTERMEDIATE): line of intersection + acute angle between two planes. Line -> null; angle range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f003-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Line of intersection and angle between two planes$$,
  $$Two planes are given by \(\mathbf{r}=\begin{pmatrix}1\\2\\7\end{pmatrix}+\lambda\begin{pmatrix}1\\1\\0\end{pmatrix}+\mu\begin{pmatrix}1\\0\\1\end{pmatrix}\) and \(\mathbf{r}=\begin{pmatrix}1\\2\\7\end{pmatrix}+s\begin{pmatrix}1\\2\\4\end{pmatrix}+t\begin{pmatrix}0\\1\\1\end{pmatrix}\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$Normals: \(\mathbf{n}_1=\begin{pmatrix}1\\1\\0\end{pmatrix}\times\begin{pmatrix}1\\0\\1\end{pmatrix}=\begin{pmatrix}1\\-1\\-1\end{pmatrix}\), \(\mathbf{n}_2=\begin{pmatrix}1\\2\\4\end{pmatrix}\times\begin{pmatrix}0\\1\\1\end{pmatrix}=\begin{pmatrix}-2\\-1\\1\end{pmatrix}\). Line direction \(=\mathbf{n}_1\times\mathbf{n}_2=\begin{pmatrix}-2\\1\\-3\end{pmatrix}\); both planes pass through \((1,2,7)\), so the line of intersection is \(\mathbf{r}=\begin{pmatrix}1\\2\\7\end{pmatrix}+\alpha\begin{pmatrix}-2\\1\\-3\end{pmatrix}\). \(\cos\theta=\dfrac{|\mathbf{n}_1\cdot\mathbf{n}_2|}{|\mathbf{n}_1||\mathbf{n}_2|}=\dfrac{|-2+1-1|}{\sqrt3\,\sqrt6}=\dfrac{2}{\sqrt{18}}\Rightarrow\theta\approx1.08\text{ rad}\;(61.9^\circ)\).$$,
  5,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find a vector equation of the line of intersection of the two planes.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the acute angle between the two planes, in degrees.",
    "correct_answer": "61.9",
    "answer_type": "range",
    "tolerance": 0.1
  }
]$$::jsonb
);

-- Q4 (INTERMEDIATE): line parallel to a plane; distance; perpendicular plane. (i)/(iii) null; (ii) distance range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f004-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Line parallel to a plane; distance and perpendicular plane$$,
  $$The line \(l\) passes through the points \(A(-1,2,3)\) and \(B(5,14,11)\). The plane \(p\) has equation \(2x+3y-6z=-7\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$\(\overrightarrow{AB}=\begin{pmatrix}6\\12\\8\end{pmatrix}=2\begin{pmatrix}3\\6\\4\end{pmatrix}\). (i) \(\begin{pmatrix}3\\6\\4\end{pmatrix}\cdot\begin{pmatrix}2\\3\\-6\end{pmatrix}=6+18-24=0\) so \(l\parallel p\); and \(2(-1)+3(2)-6(3)=-14\neq-7\), so \(A\notin p\) and \(l\) is not contained in \(p\). (ii) Distance \(=\dfrac{|2(-1)+3(2)-6(3)+7|}{\sqrt{4+9+36}}=\dfrac{7}{7}=1\) unit. (iii) Normal of required plane \(=\begin{pmatrix}3\\6\\4\end{pmatrix}\times\begin{pmatrix}2\\3\\-6\end{pmatrix}=\begin{pmatrix}-48\\26\\-3\end{pmatrix}\); through \(A(-1,2,3)\): \(-48x+26y-3z=91\).$$,
  6,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that the line \\(l\\) is parallel to, but not contained in, the plane \\(p\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the distance of the line \\(l\\) from the plane \\(p\\).",
    "correct_answer": "1",
    "answer_type": "range",
    "tolerance": 0.01
  },
  {
    "label": "iii",
    "prompt_latex": "Find a Cartesian equation of the plane which contains \\(l\\) and is perpendicular to \\(p\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q5 (INTERMEDIATE): foot of perpendicular, distance, reflection of a point in a plane.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f005-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Foot of perpendicular, distance and reflection$$,
  $$A plane passes through the points \((1,-2,1)\) and \((2,-1,-1)\) and is parallel to the line \(\mathbf{r}=\begin{pmatrix}1\\-1\\0\end{pmatrix}+s\begin{pmatrix}3\\1\\-2\end{pmatrix}\), \(s\in\mathbb{R}\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$Direction in plane \(\begin{pmatrix}1\\1\\-2\end{pmatrix}\) and the parallel line's \(\begin{pmatrix}3\\1\\-2\end{pmatrix}\) give normal \(\begin{pmatrix}0\\-4\\-2\end{pmatrix}\parallel\begin{pmatrix}0\\2\\1\end{pmatrix}\); the plane is \(2y+z=-3\). (i) Foot \(F=A+t\begin{pmatrix}0\\2\\1\end{pmatrix}\) with \(A(1,1,-1)\): \(2(1+2t)+(-1+t)=-3\Rightarrow5t=-4\Rightarrow t=-\tfrac45\), so \(F\left(1,-\tfrac35,-\tfrac95\right)\). (ii) Distance \(=|t|\,\big|\begin{pmatrix}0\\2\\1\end{pmatrix}\big|=\tfrac45\sqrt5\approx1.79\) units. (iii) Image \(A'=A+2t\begin{pmatrix}0\\2\\1\end{pmatrix}=\left(1,-\tfrac{11}{5},-\tfrac{13}{5}\right)\).$$,
  6,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the foot of perpendicular \\(F\\) of the point \\(A(1,1,-1)\\) to the plane. Give \\((x,y,z)\\).",
    "correct_answer": "(1, -3/5, -9/5)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "-0.6", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "-1.8", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "Hence or otherwise find the shortest distance between \\(A\\) and the plane.",
    "correct_answer": "1.789",
    "answer_type": "range",
    "tolerance": 0.01
  },
  {
    "label": "iii",
    "prompt_latex": "Find the image of \\(A\\) reflected about the plane. Give \\((x,y,z)\\).",
    "correct_answer": "(1, -11/5, -13/5)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "-2.2", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "-2.6", "answer_type": "range", "tolerance": 0.05 }
    ]
  }
]$$::jsonb
);

-- Q6 (INTERMEDIATE): angle between planes, line of intersection, equidistant point. (i) angle range; (ii)/(iii) null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f006-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  2,
  $$Angle, line of intersection and an equidistant point$$,
  $$The planes \(p_1\) and \(p_2\) have equations \(\mathbf{r}\cdot\begin{pmatrix}2\\-2\\1\end{pmatrix}=1\) and \(\mathbf{r}\cdot\begin{pmatrix}-6\\3\\2\end{pmatrix}=-1\) respectively, and meet in the line \(l\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\cos\theta=\dfrac{|\mathbf{n}_1\cdot\mathbf{n}_2|}{|\mathbf{n}_1||\mathbf{n}_2|}=\dfrac{|-12-6+2|}{3\cdot7}=\dfrac{16}{21}\Rightarrow\theta\approx40.4^\circ\). (ii) \((1,1,1)\) satisfies both equations (\(2-2+1=1\), \(-6+3+2=-1\)); the direction of \(l\) is \(\mathbf{n}_1\times\mathbf{n}_2=\begin{pmatrix}-7\\-10\\-6\end{pmatrix}\), so \(l:\ \mathbf{r}=\begin{pmatrix}1\\1\\1\end{pmatrix}+\lambda\begin{pmatrix}7\\10\\6\end{pmatrix}\). (iii) For \(A(4,3,c)\) equidistant: \(\dfrac{|c+1|}{3}=\dfrac{|2c-14|}{7}\Rightarrow7|c+1|=3|2c-14|\), giving \(c=-49\) or \(c=\dfrac{35}{13}\).$$,
  7,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the acute angle between \\(p_1\\) and \\(p_2\\), in degrees.",
    "correct_answer": "40.4",
    "answer_type": "range",
    "tolerance": 0.1
  },
  {
    "label": "ii",
    "prompt_latex": "Verify that the point \\((1,1,1)\\) lies on both \\(p_1\\) and \\(p_2\\). Hence or otherwise find a vector equation for \\(l\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "The point \\(A(4,3,c)\\) is equidistant from the planes \\(p_1\\) and \\(p_2\\). Calculate the two possible values of \\(c\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (ADVANCED): intersection of line and plane + reflected line. (i) point multi-box; (ii) vector eqn -> null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f007-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Intersection and reflection of a line in a plane$$,
  $$Given a line \(l:\ \mathbf{r}=\begin{pmatrix}10\\4\\2\end{pmatrix}+\lambda\begin{pmatrix}9\\-1\\0\end{pmatrix}\), \(\lambda\in\mathbb{R}\), and a plane \(\Pi:\ \mathbf{r}\cdot\begin{pmatrix}3\\-1\\2\end{pmatrix}=2\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(3(10+9\lambda)-(4-\lambda)+2(2)=2\Rightarrow30+28\lambda=2\Rightarrow\lambda=-1\); intersection \((1,5,2)\). (ii) Reflect a point of \(l\), say \((10,4,2)\): its foot on \(\Pi\) is at \((4,6,-2)\) (parameter \(-2\) along \(\mathbf{n}\)), so the reflected point is \((-2,8,-6)\). The reflected line passes through \((1,5,2)\) and \((-2,8,-6)\) with direction \(\begin{pmatrix}3\\-3\\8\end{pmatrix}\): \(\mathbf{r}=\begin{pmatrix}1\\5\\2\end{pmatrix}+t\begin{pmatrix}3\\-3\\8\end{pmatrix}\).$$,
  6,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the point of intersection \\((x,y,z)\\) between \\(l\\) and \\(\\Pi\\).",
    "correct_answer": "(1, 5, 2)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "1", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "2", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "Find the vector equation of the reflection of line \\(l\\) about \\(\\Pi\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): plane/line with parameters. (i)(a)/(i)(b) null; (ii) value of a -> range.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f008-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Plane and line with a parameter$$,
  $$The plane \(p\) has equation \(\mathbf{r}=\begin{pmatrix}1\\-3\\2\end{pmatrix}+\lambda\begin{pmatrix}1\\2\\0\end{pmatrix}+\mu\begin{pmatrix}a\\4\\-2\end{pmatrix}\) and the line \(l\) has equation \(\mathbf{r}=\begin{pmatrix}a-1\\a\\a+1\end{pmatrix}+t\begin{pmatrix}-2\\1\\2\end{pmatrix}\), where \(a\) is a constant and \(\lambda\), \(\mu\), \(t\) are parameters.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$When \(a=0\), the normal of \(p\) is \(\begin{pmatrix}1\\2\\0\end{pmatrix}\times\begin{pmatrix}0\\4\\-2\end{pmatrix}=\begin{pmatrix}-4\\2\\4\end{pmatrix}\parallel\begin{pmatrix}2\\-1\\-2\end{pmatrix}\), which is parallel to \(l\)'s direction \(\begin{pmatrix}-2\\1\\2\end{pmatrix}\), so \(l\perp p\). (a) Solving gives \(\lambda=-\tfrac89\), \(\mu=\tfrac{19}{18}\), \(t=-\tfrac59\) at the intersection point. (b) \(p:\ -2x+y+2z=-1\); planes at perpendicular distance \(12\) are \(-2x+y+2z=k\) with \(\dfrac{|k+1|}{3}=12\Rightarrow k=35\) or \(-37\), i.e. \(-2x+y+2z=35\) and \(-2x+y+2z=-37\). (ii) \(l\) and \(p\) fail to meet in a unique point when \(\begin{pmatrix}-2\\1\\2\end{pmatrix}\) is perpendicular to \(p\)'s normal \(\begin{pmatrix}-4\\2\\4-2a\end{pmatrix}\): \(8+2+2(4-2a)=18-4a=0\Rightarrow a=\tfrac92\).$$,
  9,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i-a",
    "prompt_latex": "In the case where \\(a=0\\), show that \\(l\\) is perpendicular to \\(p\\) and find the values of \\(\\lambda\\), \\(\\mu\\) and \\(t\\) which give the coordinates of the point at which \\(l\\) and \\(p\\) intersect.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "i-b",
    "prompt_latex": "In the case where \\(a=0\\), find the Cartesian equations of the planes such that the perpendicular distance from each plane to \\(p\\) is \\(12\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the value of \\(a\\) such that \\(l\\) and \\(p\\) do not meet in a unique point.",
    "correct_answer": "4.5",
    "answer_type": "range",
    "tolerance": 0.01
  }
]$$::jsonb
);

-- Q9 (ADVANCED): geometric interpretation of vector equations. All interpret/derive -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f009-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Geometric interpretation of line and plane equations$$,
  $$In this question \(\mathbf{a}\) and \(\mathbf{b}\) are constant vectors, \(\mathbf{n}\) is a constant unit vector, \(d\) is a constant scalar and \(t\) is a parameter.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(i) \(\mathbf{r}=\mathbf{a}+t\mathbf{b}\) represents a straight line passing through the point with position vector \(\mathbf{a}\) and parallel to the direction \(\mathbf{b}\). (ii) \(\mathbf{r}\cdot\mathbf{n}=d\) represents a plane with unit normal \(\mathbf{n}\); since \(\mathbf{n}\) is a unit vector, \(d\) is the perpendicular distance of the plane from the origin. (iii) Substituting \(\mathbf{r}=\mathbf{a}+t\mathbf{b}\) into \(\mathbf{r}\cdot\mathbf{n}=d\): \((\mathbf{a}+t\mathbf{b})\cdot\mathbf{n}=d\Rightarrow t=\dfrac{d-\mathbf{a}\cdot\mathbf{n}}{\mathbf{b}\cdot\mathbf{n}}\) (valid as \(\mathbf{b}\cdot\mathbf{n}\neq0\)). Hence \(\mathbf{r}=\mathbf{a}+\left(\dfrac{d-\mathbf{a}\cdot\mathbf{n}}{\mathbf{b}\cdot\mathbf{n}}\right)\mathbf{b}\), which is the (unique) point where the line meets the plane.$$,
  6,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Interpret geometrically the vector equation \\(\\mathbf{r}=\\mathbf{a}+t\\mathbf{b}\\), where \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\) are constant vectors and \\(t\\) is a parameter.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Interpret geometrically the vector equation \\(\\mathbf{r}\\cdot\\mathbf{n}=d\\), where \\(\\mathbf{n}\\) is a constant unit vector and \\(d\\) is a constant scalar, stating what \\(d\\) represents.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Given that \\(\\mathbf{b}\\cdot\\mathbf{n}\\neq0\\), solve the equations \\(\\mathbf{r}=\\mathbf{a}+t\\mathbf{b}\\) and \\(\\mathbf{r}\\cdot\\mathbf{n}=d\\) to find \\(\\mathbf{r}\\) in terms of \\(\\mathbf{a}\\), \\(\\mathbf{b}\\), \\(\\mathbf{n}\\) and \\(d\\). Interpret the solution geometrically.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q10 (ADVANCED): ray-tracing (reflection). (i)/(iii)/(iv) show/determine -> null; (ii) foot of perpendicular multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21f00a-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Ray tracing — reflection off a plane$$,
  $$In computer graphics, ray tracing traces the paths of light rays onto surfaces and computes the paths of the reflected rays. The point \(A\) has coordinates \((3,4,2)\) and the line \(l\) has equation \(x-1=\dfrac{y+2}{3}=\dfrac{3-z}{2}\). A light ray travels in a straight line \(l_{SA}\) from a point source at \(S(4,2,3)\) towards \(A\) and is reflected off the plane \(\Pi\) (which contains \(A\) and \(l\)); the reflected ray travels along a line \(m\), and \(l_{SA}\) and \(m\) make equal angles with the normal to \(\Pi\) and lie in a plane perpendicular to \(\Pi\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(l\) has point \((1,-2,3)\) and direction \(\begin{pmatrix}1\\3\\-2\end{pmatrix}\); with \(\overrightarrow{(1,-2,3)\to A}=\begin{pmatrix}2\\6\\-1\end{pmatrix}\), the normal is \(\begin{pmatrix}1\\3\\-2\end{pmatrix}\times\begin{pmatrix}2\\6\\-1\end{pmatrix}=\begin{pmatrix}9\\-3\\0\end{pmatrix}\parallel\begin{pmatrix}3\\-1\\0\end{pmatrix}\); through \(A\): \(3x-y=5\). (ii) \(F=S+t\begin{pmatrix}3\\-1\\0\end{pmatrix}\): \(3(4+3t)-(2-t)=5\Rightarrow10+10t=5\Rightarrow t=-\tfrac12\), so \(F\left(\tfrac52,\tfrac52,3\right)\). (iii) The reflected direction is that of \(\overrightarrow{FA}\) reflected, giving \(m:\ \dfrac{x-3}{2}=y-4=2-z\). (iv) Following \(m\) from \(A\) back towards the \(xy\)-plane and checking the \(x,y\) range determines whether it reaches the \(4\times3\) window.$$,
  9,
  'H2 Math Tutorial (Vectors (Planes))',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that the Cartesian equation of the plane \\(\\Pi\\) which contains \\(A\\) and the line \\(l\\) is \\(3x-y=5\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the foot of the perpendicular, \\(F\\), from \\(S(4,2,3)\\) to the plane \\(\\Pi\\). Give \\((x,y,z)\\).",
    "correct_answer": "(5/2, 5/2, 3)",
    "answer_type": "range",
    "tolerance": 0.05,
    "answers": [
      { "key": "x", "label": "x", "correct_answer": "2.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "y", "label": "y", "correct_answer": "2.5", "answer_type": "range", "tolerance": 0.05 },
      { "key": "z", "label": "z", "correct_answer": "3", "answer_type": "range", "tolerance": 0.05 }
    ]
  },
  {
    "label": "iii",
    "prompt_latex": "Hence, by finding \\(\\overrightarrow{FA}\\) or otherwise, show that a Cartesian equation for the line \\(m\\) is \\(\\dfrac{x-3}{2}=y-4=2-z\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "The viewing window is the rectangle in the \\(xy\\)-plane starting at the origin, \\(4\\) units in the positive \\(x\\)-direction and \\(3\\) units in the positive \\(y\\)-direction. Determine whether the reflected ray along \\(m\\) will reach the viewing window.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);
