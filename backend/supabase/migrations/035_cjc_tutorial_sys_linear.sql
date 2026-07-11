-- Migration 035: H2 Math Tutorial — System of Linear Equations (DISCUSSION only, 5 questions)
-- Source PDF: TUTORIAL/FUNCTIONS AND GRAPHS/0. 2021 System of Linear Equations (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS excluded. Provenance stripped per user (no source school/year; inline exam tags removed).
-- IDs: prefix 'cc21', number = <topic-index 0><3-digit Q#> → cc210001..cc210005. Topic aaaa0006.
-- No DDL: parts JSONB + attempts.part_label already exist.

-- Q1 (BASIC) — solve a 3x3 linear system for fruit prices, then compute Lee Lian's total. Single numeric answer.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc210001-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  1,
  $$Fruit prices — solve a linear system$$,
  $$Four friends buy three different kinds of fruits in the market. When they get home they cannot remember the individual prices per kilogram, but three of them can remember the total amount that they each paid. The weights of fruits and the total amount paid are shown in the following table.
\[\begin{array}{l|cccc} & \text{Suresh} & \text{Fandi} & \text{Cindy} & \text{Lee Lian}\\ \hline \text{Pineapples (kg)} & 1.15 & 1.20 & 2.15 & 1.30\\ \text{Mangoes (kg)} & 0.60 & 0.45 & 0.90 & 0.25\\ \text{Lychees (kg)} & 0.55 & 0.30 & 0.65 & 0.50\\ \text{Total paid (\$)} & 8.28 & 6.84 & 13.05 & ?\end{array}\]
Assuming that, for each variety of fruit, the price per kilogram paid by each of the friends is the same, calculate the total amount that Lee Lian paid.$$,
  'range',
  $$7.65$$,
  0.005,
  $$Let the prices per kg of pineapples, mangoes and lychees be \(p\), \(m\), \(l\). Then \(1.15p+0.60m+0.55l=8.28\), \(1.20p+0.45m+0.30l=6.84\), \(2.15p+0.90m+0.65l=13.05\). Solving gives \(p=3.00\), \(m=4.20\), \(l=2.40\). Lee Lian pays \(1.30p+0.25m+0.50l=1.30(3.00)+0.25(4.20)+0.50(2.40)=\$7.65\).$$,
  3,
  'H2 Math Tutorial (System of Linear Equations)'
);

-- Q2 (BASIC) — quadratic through 3 points; find a, b, c to 3 d.p. Multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc210002-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  1,
  $$Quadratic through three points$$,
  $$It is given that \(f(x)=ax^2+bx+c\), where \(a\), \(b\) and \(c\) are constants. The curve with equation \(y=f(x)\) passes through the points with coordinates \((-1.5,\ 4.5)\), \((2.1,\ 3.2)\) and \((3.4,\ 4.1)\). Find the values of \(a\), \(b\) and \(c\), giving your answers correct to 3 decimal places.$$,
  'range',
  $$a=0.215, b=-0.490, c=3.281$$,
  0.0005,
  $$Substituting the three points into \(y=ax^2+bx+c\) gives \(2.25a-1.5b+c=4.5\), \(4.41a+2.1b+c=3.2\), \(11.56a+3.4b+c=4.1\). Solving: \(a=0.215\), \(b=-0.490\), \(c=3.281\) (3 d.p.).$$,
  3,
  'H2 Math Tutorial (System of Linear Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(c\\), correct to 3 decimal places.",
    "correct_answer": "a=0.215, b=-0.490, c=3.281",
    "answer_type": "range",
    "tolerance": 0.0005,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "0.215", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "b", "label": "b", "correct_answer": "-0.490", "answer_type": "range", "tolerance": 0.0005 },
      { "key": "c", "label": "c", "correct_answer": "3.281", "answer_type": "range", "tolerance": 0.0005 }
    ]
  }
]$$::jsonb
);

-- Q3 (INTERMEDIATE) — two curves intersect at x=1,2,4; find a, b, p to 2 d.p. Multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc210003-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  2,
  $$Intersection of two curves — find a, b, p$$,
  $$Two curves \(y=ax^3+\sqrt{bx}\) and \(y=\ln\left(px^2\right)\) intersect at the points where \(x=1\), \(x=2\) and \(x=4\). Find the values of \(a\), \(b\) and \(p\), correct to 2 decimal places.$$,
  'range',
  $$a=-0.01, b=12.65, p=34.63$$,
  0.005,
  $$Equating the curves at each \(x\): \(a+\sqrt{b}=\ln p\) (at \(x=1\)); \(8a+\sqrt{2b}=\ln(4p)\) (at \(x=2\)); \(64a+2\sqrt{b}=\ln(16p)\) (at \(x=4\)). Treating \(\sqrt{b}\) and \(\ln p\) as unknowns and solving numerically gives \(a=-0.01\), \(b=12.65\), \(p=34.63\) (2 d.p.).$$,
  4,
  'H2 Math Tutorial (System of Linear Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the values of \\(a\\), \\(b\\) and \\(p\\), correct to 2 decimal places.",
    "correct_answer": "a=-0.01, b=12.65, p=34.63",
    "answer_type": "range",
    "tolerance": 0.005,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-0.01", "answer_type": "range", "tolerance": 0.005 },
      { "key": "b", "label": "b", "correct_answer": "12.65", "answer_type": "range", "tolerance": 0.005 },
      { "key": "p", "label": "p", "correct_answer": "34.63", "answer_type": "range", "tolerance": 0.005 }
    ]
  }
]$$::jsonb
);

-- Q4 (ADVANCED) — traffic-flow network (diagram described in prose). (i) formulate, (ii) general solution, (iii) 3 volumes.
-- FLAG: (i) system-of-equations answer and (ii) parametric general solution are not exact-match gradable → null; only (iii) graded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc210004-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  3,
  $$Traffic-flow network$$,
  $$In a particular city, the traffic flow at four junctions A, B, C and D is as follows. The junctions are arranged in a square with A at the top-left, D at the top-right, B at the bottom-left and C at the bottom-right. The average hourly volumes of vehicles on the external roads are: into A from the north 450 and out of A to the west 620; out of D to the north 330 and into D from the east 620; into B from the west 550 and out of B to the south 470; out of C to the east 580 and into C from the south 380. The internal one-way flows are \(x_1\) from D to A, \(x_2\) from A to B, \(x_3\) from B to C, and \(x_4\) from C to D. At each junction, the number of vehicles entering must be the same as the number leaving.$$,
  'range',
  $$A–D (x1)=440, A–B (x2)=270, B–C (x3)=350$$,
  0.5,
  $$Balancing each junction (in = out): A: \(450+x_1=620+x_2\Rightarrow x_1-x_2=170\); B: \(550+x_2=470+x_3\Rightarrow x_2-x_3=-80\); C: \(x_3+380=580+x_4\Rightarrow x_3-x_4=200\); D: \(620+x_4=330+x_1\Rightarrow x_1-x_4=290\). Solving in terms of \(x_4=k\): \(x_1=290+k\), \(x_2=120+k\), \(x_3=200+k\), \(x_4=k\), \(k\in\mathbb{R}\). Given the flow between C and D is \(x_4=150\): \(x_1=440\) (A–D), \(x_2=270\) (A–B), \(x_3=350\) (B–C).$$,
  6,
  'H2 Math Tutorial (System of Linear Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Formulate a system of 4 linear equations in \\(x_1\\), \\(x_2\\), \\(x_3\\) and \\(x_4\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "By solving the system of linear equations in part (i), find the solution(s) for \\(x_1\\), \\(x_2\\), \\(x_3\\) and \\(x_4\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "It is observed that the average hourly volume of vehicles between junctions C and D is 150. Using this and your solution in part (ii), write down the average hourly volumes of vehicles between junctions A and D, A and B, and B and C.",
    "correct_answer": "A-D=440, A-B=270, B-C=350",
    "answer_type": "range",
    "tolerance": 0.5,
    "answers": [
      { "key": "AD", "label": "\\text{A--D}", "correct_answer": "440", "answer_type": "range", "tolerance": 0.5 },
      { "key": "AB", "label": "\\text{A--B}", "correct_answer": "270", "answer_type": "range", "tolerance": 0.5 },
      { "key": "BC", "label": "\\text{B--C}", "correct_answer": "350", "answer_type": "range", "tolerance": 0.5 }
    ]
  }
]$$::jsonb
);

-- Q5 (ADVANCED) — integer linear system with inequality constraints (chocolate bars). Multi-box W, M, D.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc210005-0000-0000-0000-000000000000',
  'aaaa0006-0000-0000-0000-000000000000',
  3,
  $$Chocolate bars — constrained integer system$$,
  $$A confectionery recently created three types of chocolate: Organic white, Organic milk and Organic dark, available in 250 g bars. Cocoa butter, an essential ingredient, makes up 25%, 20% and 15% of the mass of an Organic white, Organic milk and Organic dark chocolate bar respectively. To prepare for an upcoming Food Expo, the confectionery decides to manufacture a total of 300 bars, with more than 70 bars of each type. It intends to use 14 kg of cocoa butter in the production of this batch. If the number of milk chocolate bars is to be smaller than the number of white chocolate bars, determine how many bars of each type can be produced.$$,
  'range',
  $$W=74, M=72, D=154$$,
  0.5,
  $$Let \(W\), \(M\), \(D\) be the numbers of white, milk and dark bars. Then \(W+M+D=300\) and, from the cocoa-butter mass (per bar \(0.25\times250=62.5\) g, \(50\) g, \(37.5\) g): \(62.5W+50M+37.5D=14000\), which simplifies to \(2W+M=220\). Hence \(M=220-2W\) and \(D=80+W\). The constraints \(M>70\) and \(M<W\) give \(73.33<W<75\), so \(W=74\). Then \(M=72\) and \(D=154\).$$,
  5,
  'H2 Math Tutorial (System of Linear Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Determine how many bars of each type (white \\(W\\), milk \\(M\\), dark \\(D\\)) can be produced.",
    "correct_answer": "W=74, M=72, D=154",
    "answer_type": "range",
    "tolerance": 0.5,
    "answers": [
      { "key": "W", "label": "W", "correct_answer": "74", "answer_type": "range", "tolerance": 0.5 },
      { "key": "M", "label": "M", "correct_answer": "72", "answer_type": "range", "tolerance": 0.5 },
      { "key": "D", "label": "D", "correct_answer": "154", "answer_type": "range", "tolerance": 0.5 }
    ]
  }
]$$::jsonb
);
