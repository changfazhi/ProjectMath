-- Migration 072: CJC 2022 JC2 H2 Math Tutorial — Complex Numbers (Cartesian Form) (DISCUSSION only, 8 questions)
-- Source: TUTORIAL/5.1 Complex Numbers (Cartesian Form) + solution.pdf, DISCUSSION section (pp.27-28);
--         answers cross-checked against TUTORIAL/5.1.2 2022 Complex Numbers (Cartesian Form) Discussion Solution.
-- REVIEW PROBLEMS deliberately excluded. Answers verified/re-derived against the discussion solution PDF.
-- Provenance stripped: generic source 'H2 Math Tutorial (Complex Numbers (Cartesian Form))', inline exam tags removed.
-- IDs: new prefix 'cc24' (CJC-2022 pure-math tutorials) + topic-index '1' (Complex Numbers file 5.1) + 3-digit Q#
--      -> cc241001..cc241008. Topic aaaa0011 (Complex Number).
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading (house convention for complex Cartesian sets): clean real scalars graded exact — Q1 Re/Im parts,
--   Q7(ii) p=5; a single deterministic a+bi value (Q5a) is FLAG 'exact'. Everything two-valued / multi-valued
--   (multiple roots, "z or w" solution sets), vector-valued a+bi solutions, and every explain/describe/"why"
--   part is left null (revealed via solution_latex) — exact-match would reject correct work.

-- Q1 (BASIC): Re/Im of two expressions in z. Clean real scalars -> multi-box exact.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241001-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  1,
  $$Real and imaginary parts of expressions in z$$,
  $$Do not use a calculator in answering this question. Let \(z=\dfrac{2+i}{3-i}\). Find the real and imaginary parts of each of the following.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(a) \(\dfrac{1+z}{1-z}=\dfrac{1+\frac{2+i}{3-i}}{1-\frac{2+i}{3-i}}=\dfrac{(3-i)+(2+i)}{(3-i)-(2+i)}=\dfrac{5}{1-2i}\cdot\dfrac{1+2i}{1+2i}=\dfrac{5(1+2i)}{5}=1+2i\). So \(\operatorname{Re}=1\) and \(\operatorname{Im}=2\).

(b) \(z+\dfrac{1}{z}=\dfrac{2+i}{3-i}+\dfrac{3-i}{2+i}=\dfrac{(2+i)^2+(3-i)^2}{(3-i)(2+i)}=\dfrac{(3+4i)+(8-6i)}{7+i}=\dfrac{11-2i}{7+i}\cdot\dfrac{7-i}{7-i}=\dfrac{75-25i}{50}=\dfrac{3}{2}-\dfrac{1}{2}i\). So \(\operatorname{Re}=\dfrac{3}{2}\) and \(\operatorname{Im}=-\dfrac{1}{2}\).$$,
  6,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the real and imaginary parts of \\(\\dfrac{1+z}{1-z}\\).",
    "correct_answer": "Re = 1, Im = 2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "Re", "label": "Re", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "Im", "label": "Im", "correct_answer": "2", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Find the real and imaginary parts of \\(z+\\dfrac{1}{z}\\).",
    "correct_answer": "Re = 3/2, Im = -1/2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "Re", "label": "Re", "correct_answer": "\\frac{3}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "Im", "label": "Im", "correct_answer": "-\\frac{1}{2}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q2 (BASIC): solve zz*-2z+2z*=5-4i. Two-valued complex answer -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241002-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  1,
  $$Equation involving z and its conjugate$$,
  $$Solve the equation \(zz^{*}-2z+2z^{*}=5-4i\).$$,
  'exact',
  $$$$,
  NULL,
  $$Let \(z=a+bi\) where \(a,b\) are real. Then \(zz^{*}=a^2+b^2\), so \(zz^{*}-2z+2z^{*}=(a^2+b^2)-2(a+bi)+2(a-bi)=a^2+b^2-4bi=5-4i\). Comparing parts: \(-4b=-4\Rightarrow b=1\); \(a^2+b^2=5\Rightarrow a^2=4\Rightarrow a=\pm2\). Hence \(z=2+i\) or \(z=-2+i\).$$,
  3,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Solve the equation \\(zz^{*}-2z+2z^{*}=5-4i\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q3 (INTERMEDIATE): roots of a quadratic with complex coefficients. Two roots -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241003-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Quadratic with complex coefficients$$,
  $$Do not use a calculator in answering this question. Find the roots of the equation \(w^{2}(1-i)+4w+(10+10i)=0\), giving your answers in cartesian form \(a+ib\).$$,
  'exact',
  $$$$,
  NULL,
  $$\(w=\dfrac{-4\pm\sqrt{16-4(1-i)(10+10i)}}{2(1-i)}\). Since \((1-i)(10+10i)=10(1-i)(1+i)=10(2)=20\), the discriminant is \(16-80=-64\) and \(\sqrt{-64}=8i\). Thus \(w=\dfrac{-4\pm8i}{2(1-i)}\cdot\dfrac{1+i}{1+i}=(-1\pm2i)(1+i)\). So \(w=(-1+2i)(1+i)=-3+i\) or \(w=(-1-2i)(1+i)=1-3i\).$$,
  4,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the roots of \\(w^{2}(1-i)+4w+(10+10i)=0\\) in cartesian form \\(a+ib\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q4 (INTERMEDIATE): two systems of simultaneous complex equations. Complex-/two-valued solutions -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241004-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Simultaneous equations in complex numbers$$,
  $$Answer both parts below.$$,
  'exact',
  $$$$,
  NULL,
  $$(a) From \(iz+2w=1\): \(z=\dfrac{1-2w}{i}=-i+2iw\). Substituting into \(4z+(3-i)w^{*}=-6\) and writing \(w=a+bi\) gives \((3a-9b)+(7a-3b)i=-6+4i\), so \(3a-9b=-6\) and \(7a-3b=4\Rightarrow a=1,\ b=1\). Hence \(w=1+i\) and \(z=-i+2i(1+i)=-2+i\).

(b) From \(z=w+2i-1\), \(w=z-2i+1\); substituting into \(z^{2}-iw+\tfrac{5}{2}=0\) gives \(z^{2}-iz-i+\tfrac12=0\), so \(z=\dfrac{i\pm(1+2i)}{2}\). Hence \(z=\dfrac{1}{2}+\dfrac{3}{2}i,\ w=\dfrac{3}{2}-\dfrac{1}{2}i\), or \(z=-\dfrac{1}{2}-\dfrac{1}{2}i,\ w=\dfrac{1}{2}-\dfrac{5}{2}i\).$$,
  6,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Solve the simultaneous equations \\(iz+2w=1\\) and \\(4z+(3-i)w^{*}=-6\\), giving \\(z\\) and \\(w\\) in the form \\(a+bi\\) where \\(a\\) and \\(b\\) are real.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Solve the simultaneous equations \\(z=w+2i-1\\) and \\(z^{2}-iw+\\dfrac{5}{2}=0\\), giving \\(z\\) and \\(w\\) in the form \\(x+yi\\) where \\(x\\) and \\(y\\) are real.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q5 (INTERMEDIATE): (a) square a complex number (single a+bi, FLAG exact); (b) solve related equation (two roots -> null).
-- FLAG: (a) single complex value a+bi; exact-match on complex formatting is brittle. Canonical form pinned.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241005-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Square of a complex number; a related equation$$,
  $$A graphic calculator is not to be used in answering this question.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$\((1-4i)^{2}=1-8i+16i^{2}=-15-8i\).

Then \(\left(\dfrac{z}{2}+3\right)^{2}=15+8i=-(1-4i)^{2}=\big(i(1-4i)\big)^{2}=(4+i)^{2}\), so \(\dfrac{z}{2}+3=\pm(4+i)\Rightarrow\dfrac{z}{2}=1+i\) or \(-7-i\Rightarrow z=2+2i\) or \(z=-14-2i\).$$,
  5,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "Express \\((1-4i)^{2}\\) in the form \\(a+bi\\).",
    "correct_answer": "-15-8i",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence, find the roots of the equation \\(\\left(\\dfrac{z}{2}+3\\right)^{2}=15+8i\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q6 (INTERMEDIATE): possibilities for roots of a real quartic. Worded/describe -> null (revealed).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241006-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Possible real and complex roots of a real quartic$$,
  $$Consider the equation \(2z^{4}+az^{3}+bz^{2}+cz+d=0\), where \(a\), \(b\), \(c\) and \(d\) are real numbers. What are the possibilities for the numbers of real and complex roots of this equation?$$,
  'exact',
  $$$$,
  NULL,
  $$Because the coefficients are real, any non-real roots occur in complex conjugate pairs. Hence the possibilities are: \(4\) real roots; or \(2\) real roots and \(1\) pair of complex conjugate roots; or \(2\) pairs of complex conjugate roots.$$,
  3,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "a",
    "prompt_latex": "State the possibilities for the numbers of real and complex roots of the equation.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (INTERMEDIATE): quartic given one complex root. (ii) p=5 exact; (i) explain, (iii)/(iv) multi-valued roots -> null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241007-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  2,
  $$Quartic with a given complex root$$,
  $$One of the roots of the equation \(z^{4}-z^{3}+4z^{2}+3z+p=0\) is \(1-2i\), where \(p\) is a constant.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(i) The conjugate-root theorem applies only when the coefficients are real. Here \(p\) is only stated to be a constant, so it need not be real; the statement is only correct if \(p\) is real.

(ii) Substituting \(z=1-2i\) into the equation and simplifying gives \(-5+p=0\), so \(p=5\).

(iii) With \(p=5\) the coefficients are real, so \(1+2i\) is also a root. Factorising, \(z^{4}-z^{3}+4z^{2}+3z+5=(z^{2}-2z+5)(z^{2}+z+1)\); solving \(z^{2}+z+1=0\) gives \(z=\dfrac{-1\pm\sqrt{3}\,i}{2}\). The other roots are \(1+2i,\ \dfrac{-1+\sqrt{3}\,i}{2},\ \dfrac{-1-\sqrt{3}\,i}{2}\).

(iv) Let \(z=iw\); then the equation becomes \(z^{4}-z^{3}+4z^{2}+3z+5=0\) with roots \(z=1\pm2i,\ \dfrac{-1\pm\sqrt{3}\,i}{2}\). Since \(w=\dfrac{z}{i}=-iz\), the roots of \(w\) are \(-i+2,\ -i-2,\ \dfrac{i+\sqrt{3}}{2},\ \dfrac{i-\sqrt{3}}{2}\).$$,
  8,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "i",
    "prompt_latex": "A student says that one of the other roots must be \\(1+2i\\). Explain why this statement is not entirely correct.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Determine the value of \\(p\\).",
    "correct_answer": "5",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Find the exact values of all the other roots of the equation.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "Determine the roots of \\(w\\) such that \\(w^{4}+iw^{3}-4w^{2}+3iw+5=0\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): real/imaginary comparison. Brittle expression b(a,k) + explain (i), two-valued real roots (ii) -> null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc241008-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Real roots via real/imaginary comparison$$,
  $$The complex number \(w\) is such that \(kw^{2}+kww^{*}+iw-iw^{*}-1=0\), where \(w^{*}\) is the complex conjugate of \(w\) and \(k\) is a real, non-zero constant.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(i) Writing \(w=a+bi\): \(kw(w+w^{*})+i(w-w^{*})-1=0\Rightarrow k(a+bi)(2a)+i(2bi)-1=0\Rightarrow(2ka^{2}-2b-1)+2kab\,i=0\). Comparing parts: \(2kab=0\), and since \(k\neq0\) this gives \(ab=0\), so \(a=0\) or \(b=0\); hence \(w\) is purely imaginary or purely real. The real part gives \(2ka^{2}-2b-1=0\Rightarrow b=\dfrac{2ka^{2}-1}{2}\).

(ii) Here \(k=2\). A real root has \(b=0\), so \(\dfrac{2(2)a^{2}-1}{2}=0\Rightarrow4a^{2}=1\Rightarrow a=\pm\dfrac{1}{2}\). Hence \(w=-\dfrac{1}{2}\) or \(w=\dfrac{1}{2}\).$$,
  7,
  'H2 Math Tutorial (Complex Numbers (Cartesian Form))',
  $$[
  {
    "label": "i",
    "prompt_latex": "For \\(w=a+bi\\) where \\(a\\) and \\(b\\) are real, obtain an expression for \\(b\\) in terms of \\(a\\) and \\(k\\). Explain why \\(w\\) is either purely real or purely imaginary.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Using your result in part (i), or otherwise, find the real roots of the equation \\(2w^{2}+2ww^{*}+iw-iw^{*}-1=0\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);
