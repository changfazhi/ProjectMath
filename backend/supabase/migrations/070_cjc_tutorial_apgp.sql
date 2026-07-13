-- Migration 070: CJC 2021 JC1 H2 Math Tutorial — Arithmetic & Geometric Progressions (DISCUSSION only, 9 questions)
-- Source: TUTORIAL/SEQUENCE AND SERIES QNS/1. 2021 AP and GP (Teacher).pdf, DISCUSSION section (pp.33-34).
-- REVIEW PROBLEMS deliberately excluded. Answers verified/re-derived against the discussion solution PDF.
-- Provenance stripped: generic source 'H2 Math Tutorial (Arithmetic & Geometric Progressions)', inline exam tags removed.
-- IDs: new prefix 'cc23' + topic-index '1' (AP & GP = tutorial file 1) + 3-digit Q# -> cc231001..cc231009. Topic aaaa0007.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Grading: clean scalars/counts graded (k, P, min-years, -286, least-n, smallest-n, day, dollar values via range).
--          Money values graded 'range' with a rounding tolerance. Two brittle expression asks (Q5 S_n/S, Q6 u_n)
--          are FLAG-enabled 'exact' with canonical forms pinned to the answer key. Show/prove parts -> null (revealed).

-- Q1 (BASIC): loan repaid by increasing instalments — find k and P (two clean scalars). Multi-box.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231001-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Loan repaid by increasing instalments$$,
  $$The cost of Sonia's new car was \(\$P\). She accepted an interest-free loan of \(\$P\), which she agreed to repay by monthly instalments. The first instalment was \(\$1200\). The instalments were increased by \(\$50\) per month, so the second and third instalments were \(\$1250\) and \(\$1300\) respectively. Given that the loan was repaid in \(k\) instalments and that the final instalment was \(\$3250\), find the values of \(k\) and \(P\).$$,
  'exact',
  $$k = 42, \ P = 93450$$,
  NULL,
  $$The instalments form an arithmetic progression with \(a=1200\), \(d=50\). The final (\(k\)th) instalment is \(T_k=3250\): \(1200+(k-1)(50)=3250\Rightarrow k=42\). The loan equals the total repaid: \(P=S_{42}=\dfrac{42}{2}\left[1200+3250\right]=93450\). Hence \(k=42\) and \(P=93450\).$$,
  4,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the values of \\(k\\) and \\(P\\).",
    "correct_answer": "k = 42, P = 93450",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "k", "label": "k", "correct_answer": "42", "answer_type": "exact", "tolerance": null },
      { "key": "P", "label": "P", "correct_answer": "93450", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q2 (BASIC): salary GP — (i)/(ii) money values (range), (iii) minimum number of years (exact).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Salary with a fixed percentage increase$$,
  $$Jack starts working in a company with an annual salary of \(\$16\,000\) in the first year. He will receive an annual salary increase of \(4\%\) each year. Assuming that he works in the company until his retirement, find the following.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$Annual salaries form a GP with \(a=16000\), \(r=1.04\). (i) Salary in the \(25\)th year \(=16000(1.04^{24})=\$41012.87\). (ii) Total over \(25\) years \(=\dfrac{16000(1.04^{25}-1)}{1.04-1}\approx\$666334.53\). (iii) Require \(\dfrac{16000(1.04^{n}-1)}{0.04}>1\,000\,000\Rightarrow 1.04^{n}>3.5\Rightarrow n>\dfrac{\ln 3.5}{\ln 1.04}=31.9\ldots\); minimum number of years is \(32\).$$,
  6,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the amount (in dollars) he will earn in his 25th year.",
    "correct_answer": "41012.87",
    "answer_type": "range",
    "tolerance": 0.5
  },
  {
    "label": "ii",
    "prompt_latex": "Find the total amount (in dollars) that he will earn over the 25-year period.",
    "correct_answer": "666334.53",
    "answer_type": "range",
    "tolerance": 5
  },
  {
    "label": "iii",
    "prompt_latex": "Find the minimum number of years he has to work for his total earnings to exceed \\(\\$1\\) million.",
    "correct_answer": "32",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q3 (BASIC): sum to infinity bound — pure show-that -> single null part (one-null-part wrapper).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231003-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  1,
  $$Bars in GP — bound on total length$$,
  $$Musical instrument \(A\) consists of metal bars of decreasing lengths. The first bar of instrument \(A\) has length \(20\) cm and the lengths of the bars form a geometric progression. The \(25\)th bar has length \(5\) cm. Show that the total length of all the bars must be less than \(357\) cm, no matter how many bars there are.$$,
  'exact',
  $$$$,
  NULL,
  $$Here \(a=20\) and \(ar^{24}=5\Rightarrow r^{24}=\tfrac{1}{4}\Rightarrow r=\left(\tfrac12\right)^{1/12}\), with \(0<r<1\). Since \(0<r<1\), the total length of any number of bars is bounded above by the sum to infinity: \(S_\infty=\dfrac{20}{1-\left(\tfrac12\right)^{1/12}}\approx 356.34<357\). Hence the total length of all the bars is always less than \(357\) cm.$$,
  4,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the total length of all the bars must be less than \\(357\\) cm, no matter how many bars there are.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q4 (INTERMEDIATE): (a) sum of first 20 negative terms of an AP; (b) GP sum + least n. Two clean scalars.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231004-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$AP negative-terms sum; GP sum and least n$$,
  $$Answer both parts below.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(a) The AP has \(a=1000\), \(d=-1.4\). For \(u_n<0\): \(1000+(n-1)(-1.4)<0\Rightarrow n>715.28\ldots\), so the first negative term is \(u_{716}=1000+715(-1.4)=-1\). The sum of the first \(20\) negative terms \(=\dfrac{20}{2}\big[2(-1)+19(-1.4)\big]=-286\). \\ (b) The GP has \(a=2\), \(r=\tfrac14\): \(S_n=\dfrac{2\left(1-(1/4)^n\right)}{1-\tfrac14}=\dfrac{8}{3}\left(1-\left(\tfrac14\right)^n\right)\). The sum of the next \(n\) terms is \(S_{2n}-S_n=\dfrac{8}{3}\left[\left(\tfrac14\right)^n-\left(\tfrac14\right)^{2n}\right]\). From GC, \(n=4\to0.0104>0.008\), \(n=5\to0.0026<0.008\); least \(n=5\).$$,
  6,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "An arithmetic series has first term \\(1000\\) and common difference \\(-1.4\\). Find the sum of the first \\(20\\) negative terms of the series.",
    "correct_answer": "-286",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the sum to the first \\(n\\) terms of the geometric series \\(2+\\dfrac{1}{2}+\\dfrac{1}{8}+\\cdots\\). Hence, or otherwise, find the least value of \\(n\\) for which the sum of the next \\(n\\) terms is less than \\(0.008\\). Enter the least value of \\(n\\).",
    "correct_answer": "5",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q5 (INTERMEDIATE): convergence condition + write-down S_n, S + show-that.
-- FLAG: (b) S_n and S are exponential-fraction expressions; exact-match is brittle. Canonical forms pinned to the answer key.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231005-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Convergent GP in \(e^{-x}\); sum expressions$$,
  $$Given that the geometric series \(1+e^{-x}+e^{-2x}+\cdots\) has a sum to infinity.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$The series is geometric with \(a=1\) and \(r=e^{-x}\). A sum to infinity exists iff \(|e^{-x}|<1\Leftrightarrow e^{-x}<1\Leftrightarrow -x<0\Leftrightarrow x>0\) (shown). \\ When \(x=10\): \(S_n=\dfrac{1-e^{-10n}}{1-e^{-10}}\) and \(S=\dfrac{1}{1-e^{-10}}\). \\ Then \(S-S_n=\dfrac{e^{-10n}}{1-e^{-10}}<\dfrac{S}{10^{100}}=\dfrac{1}{10^{100}\left(1-e^{-10}\right)}\Rightarrow e^{-10n}<10^{-100}\Rightarrow 10n>100\ln 10\Rightarrow n>10\ln 10\) (shown).$$,
  7,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(x>0\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "When \\(x=10\\), write down expressions for \\(S_n\\), the sum to \\(n\\) terms, and for \\(S\\), the sum to infinity.",
    "correct_answer": "S_n = (1-e^{-10n})/(1-e^{-10}), S = 1/(1-e^{-10})",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "Sn", "label": "S_n", "correct_answer": "\\frac{1-e^{-10n}}{1-e^{-10}}", "answer_type": "exact", "tolerance": null },
      { "key": "S", "label": "S", "correct_answer": "\\frac{1}{1-e^{-10}}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "For \\(S-S_n<\\dfrac{S}{10^{100}}\\), show that \\(n>10\\ln 10\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q6 (INTERMEDIATE): given S_n, find u_n and prove GP.
-- FLAG: (a) u_n has an abstract parameter a and several equivalent forms; exact-match is brittle. Canonical form pinned.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231006-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Recover the nth term from S_n; prove GP$$,
  $$The sum of the first \(n\) terms of a series, \(S_n\), is given by \(S_n=\dfrac{1}{a}\left[1-(a-1)^{n}\right]\), where \(a\) is a constant and \(a\neq 0\), \(a\neq 1\).$$,
  'exact',
  $$See parts$$,
  NULL,
  $$For \(n\ge 2\), \(u_n=S_n-S_{n-1}=\dfrac{1}{a}\left[1-(a-1)^n\right]-\dfrac{1}{a}\left[1-(a-1)^{n-1}\right]=\dfrac{1}{a}(a-1)^{n-1}\big(-(a-1)+1\big)=\dfrac{1}{a}(a-1)^{n-1}(2-a)\). Also \(u_1=S_1=\dfrac{1}{a}(2-a)\), which fits, so \(u_n=\dfrac{1}{a}(a-1)^{n-1}(2-a)\) for all \(n\in\mathbb{Z}^+\). Then \(\dfrac{u_n}{u_{n-1}}=\dfrac{\frac{1}{a}(a-1)^{n-1}(2-a)}{\frac{1}{a}(a-1)^{n-2}(2-a)}=a-1\), a constant, so the series is geometric (common ratio \(a-1\)).$$,
  6,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find an expression for the \\(n\\)th term of the series, \\(u_n\\).",
    "correct_answer": "\\frac{1}{a}(a-1)^{n-1}(2-a)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Prove that the series with \\(n\\)th term \\(u_n\\) is a geometric series.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (ADVANCED): AP terms forming a GP — show convergent + smallest n.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231007-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$AP terms forming a GP; compare partial sums$$,
  $$The seventh, third and first terms of an arithmetic progression with non-zero common difference are the first three terms of a geometric progression respectively. The seventh term of the arithmetic progression is \(3\).$$,
  'exact',
  $$See parts$$,
  NULL,
  $$Let the AP have first term \(a\) and common difference \(d\). The GP's first three terms are \(a+6d,\ a+2d,\ a\), so \(\dfrac{a+2d}{a+6d}=\dfrac{a}{a+2d}\Rightarrow a(a+6d)=(a+2d)^2\Rightarrow 4d^2-2ad=0\Rightarrow a=2d\) (since \(d\neq 0\)). The GP common ratio is \(r=\dfrac{a}{a+2d}=\dfrac{2d}{4d}=\tfrac12\), so \(|r|=\tfrac12<1\) and the series converges (shown). \\ With \(U_7=a+6d=3\) and \(a=2d\): \(8d=3\Rightarrow d=\tfrac38,\ a=\tfrac34\). Require \(\dfrac{n}{2}\big[2a+(n-1)d\big]-\dfrac{a(1-r^n)}{1-r}\ge 100\), i.e. \(\dfrac{3n}{16}(3+n)-6\left[1-\left(\tfrac12\right)^n\right]\ge 100\). From GC: \(n=22\to 97.1\), \(n=23\to 106.1\); smallest \(n=23\).$$,
  7,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the geometric series is convergent.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the smallest value of \\(n\\) such that the sum of the first \\(n\\) terms of the arithmetic progression exceeds the sum of the first \\(n\\) terms of the geometric progression by at least \\(100\\).",
    "correct_answer": "23",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): NAPFA training (capped GP jog + AP swim) — total distance + first day. Multi-box (range + exact).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231008-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$NAPFA training — capped jogging GP and swimming AP$$,
  $$A student wants to build up his stamina for the \(2.4\) km run in the National Physical Fitness Assessment (NAPFA) test. He combines swimming and jogging on a daily basis. On day \(1\) he jogs \(200\) m and swims \(200\) m. From day \(2\) onwards, each day he increases his jogging distance by \(20\%\) of the previous day's jogging distance (capped at \(400\) m per day), and adds \(50\) m to the previous day's swimming distance.$$,
  'range',
  $$Total \(\approx 20973.6\) m; first on the 37th day$$,
  NULL,
  $$Jogging forms a GP with \(a=200\), \(r=1.2\): day 4 is \(200(1.2^3)=345.6\) m and day 5 would exceed \(400\) m, so jogging is capped at \(400\) m for days 5–20. Total jogging \(=\dfrac{200(1.2^4-1)}{1.2-1}+400(16)=7473.6\) m. Swimming forms an AP with \(a=200\), \(d=50\): total \(=\dfrac{20}{2}\big[2(200)+19(50)\big]=13500\) m. Total distance after \(20\) days \(=7473.6+13500=20973.6\) m. \\ For a one-day total of \(2400\) m (jogging is \(400\) m from day 5), need swimming \(\ge 2000\): \(200+(n-1)50\ge 2000\Rightarrow n\ge 37\); first on the \(37\)th day.$$,
  8,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the total distance (in metres) he will have swum and jogged after \\(20\\) days, and the number of the first day on which he can cover a total distance of \\(2.4\\) km in one day.",
    "correct_answer": "Total 20973.6 m; day 37",
    "answer_type": "range",
    "tolerance": 1,
    "answers": [
      { "key": "total", "label": "Total distance (m)", "correct_answer": "20973.6", "answer_type": "range", "tolerance": 1 },
      { "key": "day", "label": "Day", "correct_answer": "37", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q9 (ADVANCED): monthly compound-interest deposits — (a)/(b) money (range), (c) months to exceed $2000 (exact).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc231009-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  $$Monthly deposits with compound interest$$,
  $$A student puts \(\$10\) on \(1\) January \(2009\) into a bank account which pays compound interest at a rate of \(2\%\) per month on the last day of each month. She puts a further \(\$10\) into the account on the first day of each subsequent month.$$,
  'exact',
  $$See parts$$,
  NULL,
  $$(a) The original \(\$10\) grows for \(24\) months to \(10(1.02)^{24}\), so the interest earned \(=10(1.02)^{24}-10\approx\$6.08\). \\ (b) The \(24\) deposits accumulate to \(10(1.02)^{24}+10(1.02)^{23}+\cdots+10(1.02)=10\cdot\dfrac{1.02(1.02^{24}-1)}{1.02-1}\approx\$310.30\). \\ (c) After \(n\) months, total \(=10\cdot\dfrac{1.02(1.02^{n}-1)}{0.02}>2000\Rightarrow 1.02(1.02^{n}-1)>4\Rightarrow n>80.4\ldots\); the total first exceeds \(\$2000\) after \(81\) complete months.$$,
  8,
  'H2 Math Tutorial (Arithmetic & Geometric Progressions)',
  $$[
  {
    "label": "a",
    "prompt_latex": "How much compound interest (in dollars) has her original \\(\\$10\\) earned at the end of \\(2\\) years?",
    "correct_answer": "6.08",
    "answer_type": "range",
    "tolerance": 0.05
  },
  {
    "label": "b",
    "prompt_latex": "How much in total (in dollars) is in the account at the end of \\(2\\) years?",
    "correct_answer": "310.30",
    "answer_type": "range",
    "tolerance": 0.5
  },
  {
    "label": "c",
    "prompt_latex": "After how many complete months will the total in the account first exceed \\(\\$2000\\)?",
    "correct_answer": "81",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);
