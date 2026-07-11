-- Migration 045: CJC 2021 JC1 H2 Math Tutorial — Maclaurin Series (DISCUSSION only, 9 questions)
-- Source: TUTORIAL/CALCULUS/4.3 Maclaurin Series (Teacher).pdf, DISCUSSION section (pp.24-26).
-- REVIEW PROBLEMS + Self-Practice excluded. Answers verified against the tutorial answer key.
-- Provenance stripped: source 'H2 Math Tutorial (Maclaurin Series)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index '9' (calculus file 4.3) + 3-digit Q# -> cc219001..cc219009. Topic aaaa0014.
-- Q9 has two sketch parts (concrete curves) -> solution_graph deferred to a later migration.
-- FLAG: series answers and partial-fraction forms are algebraic -> exact-match brittle (enabled per skills.md option 2).

-- Q1: sums via MF26 standard series.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219001-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  1,
  $$Summing standard series$$,
  $$Using MF26,$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(e^x=\sum_{r=0}^{\infty}\dfrac{x^r}{r!}=1+x+\sum_{r=2}^{\infty}\dfrac{x^r}{r!}\), so \(\sum_{r=2}^{\infty}\dfrac{x^r}{r!}=e^x-1-x\). (ii) \(\ln(1+u)=\sum_{r=1}^{\infty}(-1)^{r+1}\dfrac{u^r}{r}\); with \(u=\tfrac12\), \(\sum_{r=1}^{\infty}(-1)^{r+1}\dfrac{1}{r\,2^r}=\ln\left(1+\tfrac12\right)=\ln\dfrac{3}{2}\).$$,
  4,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the sum \\(\\displaystyle\\sum_{r=2}^{\\infty}\\dfrac{x^r}{r!}\\), giving your answer in terms of \\(x\\).",
    "correct_answer": "e^x-1-x",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the exact value of the sum \\(\\displaystyle\\sum_{r=1}^{\\infty}(-1)^{r+1}\\dfrac{1}{r\\,2^r}\\).",
    "correct_answer": "\\ln\\frac{3}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q2: partial fractions -> binomial expansion + validity.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219002-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Expansion via partial fractions$$,
  $$Let \(f(x)=\dfrac{x^2+4x+3}{(2x+1)(x^2+1)}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(f(x)=\dfrac{1}{2x+1}+\dfrac{2}{x^2+1}\). (b) \(\dfrac{1}{2x+1}=(1+2x)^{-1}=1-2x+4x^2-8x^3+\cdots\) and \(\dfrac{2}{x^2+1}=2(1+x^2)^{-1}=2-2x^2+\cdots\). Adding: \(f(x)=3-2x+2x^2-8x^3+\cdots\). (c) Valid for \(|2x|<1\) and \(|x^2|<1\), i.e. \(-\dfrac12<x<\dfrac12\).$$,
  6,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Express \\(f(x)\\) in partial fractions.",
    "correct_answer": "\\frac{1}{2x+1}+\\frac{2}{x^2+1}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence obtain the expansion of \\(f(x)\\) in ascending powers of \\(x\\) up to and including the term in \\(x^3\\).",
    "correct_answer": "3-2x+2x^2-8x^3",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the range of values of \\(x\\) for which the expansion is valid.",
    "correct_answer": "-\\frac{1}{2}<x<\\frac{1}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q3: implicit-relation Maclaurin. (i),(iii) show/verify null; (ii) graded series.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219003-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Maclaurin series of ln(1+sin x)$$,
  $$Let \(y=\ln(1+\sin x)\).$$,
  'exact',
  $$x-\frac{x^2}{2}$$,
  NULL,
  $$\(\dfrac{dy}{dx}=\dfrac{\cos x}{1+\sin x}\), so \((1+\sin x)\dfrac{dy}{dx}=\cos x\). Differentiating and simplifying gives \(e^y\dfrac{d^2y}{dx^2}=1-e^y\left[\left(\dfrac{dy}{dx}\right)^2+1\right]\) (shown). (ii) At \(x=0\): \(y=0\), \(\dfrac{dy}{dx}=1\), \(\dfrac{d^2y}{dx^2}=-1\), so \(y=x-\dfrac{x^2}{2}+\cdots\). (iii) Using \(\sin x=x-\dfrac{x^3}{6}+\cdots\) and \(\ln(1+u)=u-\dfrac{u^2}{2}+\cdots\) with \(u=\sin x\) gives \(x-\dfrac{x^2}{2}+\cdots\), confirming (ii).$$,
  6,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(e^y\\dfrac{d^2y}{dx^2}=1-e^y\\left[\\left(\\dfrac{dy}{dx}\\right)^2+1\\right]\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the Maclaurin series for \\(y\\), up to and including the term in \\(x^2\\).",
    "correct_answer": "x-\\frac{x^2}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Verify the correctness of the series found in (ii) by using the standard series expansions for \\(\\sin x\\) and \\(\\ln(1+x)\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q4: binomial approximation. (i) expansion + validity (multi-box); (ii) numeric fraction; (iv) explain null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219004-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Cube-root binomial approximation$$,
  $$It is given that \(\sqrt[3]{8+x}\) is to be expanded in ascending powers of \(x\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\sqrt[3]{8+x}=2\left(1+\dfrac{x}{8}\right)^{1/3}=2\left[1+\dfrac13\cdot\dfrac{x}{8}+\dfrac{\frac13\left(-\frac23\right)}{2}\cdot\dfrac{x^2}{64}+\cdots\right]=2+\dfrac{x}{12}-\dfrac{x^2}{288}+\cdots\), valid for \(\left|\dfrac{x}{8}\right|<1\), i.e. \(-8<x<8\). (ii) Putting \(x=\dfrac{1}{27}\): \(\sqrt[3]{8+\tfrac{1}{27}}=\sqrt[3]{\tfrac{217}{27}}=\dfrac{\sqrt[3]{217}}{3}\), and the expansion gives \(2+\dfrac{1}{324}-\dfrac{1}{209952}=\dfrac{420551}{209952}\). Hence \(\sqrt[3]{217}=3\times\dfrac{420551}{209952}=\dfrac{420551}{69984}\). (iv) \(x=\dfrac{1}{217}\) is smaller than \(\dfrac{1}{27}\), so the neglected terms are smaller and the approximation would be better.$$,
  8,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Expand \\(\\sqrt[3]{8+x}\\) in ascending powers of \\(x\\), up to and including the term in \\(x^2\\). State the range of values of \\(x\\) for which this expansion is valid.",
    "correct_answer": "2+x/12-x^2/288, -8<x<8",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "exp", "label": "\\text{expansion}", "correct_answer": "2+\\frac{x}{12}-\\frac{x^2}{288}", "answer_type": "exact", "tolerance": null },
      { "key": "rng", "label": "\\text{valid for}", "correct_answer": "-8<x<8", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "By putting \\(x=\\dfrac{1}{27}\\) into the expansion found in (i), find an approximate value of \\(\\sqrt[3]{217}\\), leaving your answer in the form \\(\\dfrac{p}{q}\\) in its lowest terms, where \\(p,q\\in\\mathbb{Z}^+\\).",
    "correct_answer": "\\frac{420551}{69984}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "We can also substitute \\(x=\\dfrac{1}{217}\\) into the expansion found in (i) to get an approximate value of \\(\\sqrt[3]{217}\\). Explain whether this approximation is better than the approximation in part (ii).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q5: small-angle approximation in a triangle. (i) show null; (ii) find a,b (multi-box).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219005-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Small-angle approximation in a triangle$$,
  $$In the triangle \(ABC\), \(AB=1\), angle \(BAC=\theta\) radians and angle \(ABC=\dfrac{3}{4}\pi\) radians.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) Angle \(ACB=\pi-\dfrac{3\pi}{4}-\theta=\dfrac{\pi}{4}-\theta\). By the sine rule, \(\dfrac{AC}{\sin ABC}=\dfrac{AB}{\sin ACB}\), so \(AC=\dfrac{\sin\frac{3\pi}{4}}{\sin\left(\frac{\pi}{4}-\theta\right)}=\dfrac{\frac{1}{\sqrt2}}{\frac{1}{\sqrt2}(\cos\theta-\sin\theta)}=\dfrac{1}{\cos\theta-\sin\theta}\) (shown). (ii) \(AC=(\cos\theta-\sin\theta)^{-1}\approx\left(1-\theta-\dfrac{\theta^2}{2}\right)^{-1}\approx1+\theta+\dfrac{3}{2}\theta^2\), so \(a=1,\ b=\dfrac{3}{2}\).$$,
  5,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(AC=\\dfrac{1}{\\cos\\theta-\\sin\\theta}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Given that \\(\\theta\\) is a sufficiently small angle, show that \\(AC\\approx1+a\\theta+b\\theta^2\\), for constants \\(a\\) and \\(b\\) to be determined.",
    "correct_answer": "a=1, b=3/2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "1", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "\\frac{3}{2}", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- Q6: small-angle area of triangle in a square. All "show" -> ungraded (null parts). Diagram described.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219006-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  2,
  $$Small-angle area in a square$$,
  $$The diagram shows a square \(ABCD\) of side \(AB=a\) cm, with \(A\) at the bottom-left, \(B\) at the bottom-right, \(C\) at the top-right and \(D\) at the top-left. \(E\) is the point on \(BC\) such that angle \(CAE=\theta\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$The diagonal \(AC\) makes \(45^\circ\) with \(AB\); angle \(BAE=45^\circ-\theta\), so \(BE=a\tan(45^\circ-\theta)\) and \(CE=a-BE=a\left[1-\tan(45^\circ-\theta)\right]\). Using \(\tan(45^\circ-\theta)=\dfrac{1-\tan\theta}{1+\tan\theta}\), \(CE=\dfrac{2a\tan\theta}{1+\tan\theta}\). Area of \(\triangle ACE=\dfrac12\cdot CE\cdot a=\dfrac{\tan\theta}{1+\tan\theta}a^2\) (shown). For small \(\theta\), \(\tan\theta\approx\theta\), so area \(\approx\dfrac{\theta}{1+\theta}a^2\approx a^2\theta(1-\theta)\) (neglecting \(\theta^3\) and higher).$$,
  4,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that the area of \\(\\triangle ACE\\) is \\(\\dfrac{\\tan\\theta}{1+\\tan\\theta}a^2\\). If \\(\\theta\\) is sufficiently small for \\(\\theta^3\\) and higher powers of \\(\\theta\\) to be neglected, show that area \\(\\triangle ACE\\approx a^2\\theta(1-\\theta)\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (ADVANCED): Maclaurin from a differential relation.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219007-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Maclaurin series from a differential relation$$,
  $$Given that the curve \(y=f(x)\) passes through \(\left(0,\dfrac{\pi}{4}\right)\) and that \(\left(\dfrac{dy}{dx}\right)\tan y=\ln\left(\dfrac{e^x+1}{2}\right)\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) At \(x=0\): \(y=\dfrac{\pi}{4}\), and \(\ln\left(\dfrac{e^x+1}{2}\right)=\dfrac{x}{2}+\dfrac{x^2}{8}+\cdots\). Differentiating the relation and evaluating at \(0\) gives \(y=\dfrac{\pi}{4}+\dfrac{x^2}{4}+\dfrac{x^3}{24}+\cdots\). (b) \((\cot y)\ln\left(\dfrac{e^x+1}{2}\right)=\dfrac{dy}{dx}\) (from the given relation, since \(\cot y=\frac{1}{\tan y}\)); differentiating the series in (a), \(\dfrac{dy}{dx}=\dfrac{x}{2}+\dfrac{x^2}{8}+\cdots\).$$,
  8,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the Maclaurin series for \\(y\\) up to and including the first three non-zero terms.",
    "correct_answer": "\\frac{\\pi}{4}+\\frac{x^2}{4}+\\frac{x^3}{24}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Deduce the Maclaurin expansion of \\((\\cot y)\\ln\\left(\\dfrac{e^x+1}{2}\\right)\\) up to and including the term in \\(x^2\\).",
    "correct_answer": "\\frac{x}{2}+\\frac{x^2}{8}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): Maclaurin from a second-order relation.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219008-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Maclaurin expansion of an exponential composite$$,
  $$Let \(y=e^{\frac{1}{x+1}}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\dfrac{dy}{dx}=-\dfrac{y}{(x+1)^2}\). Differentiating again and combining gives \(y\dfrac{d^2y}{dx^2}-\left(\dfrac{dy}{dx}\right)^2=\dfrac{2y^2}{(x+1)^3}\) (shown). At \(x=0\): \(y=e\), \(\dfrac{dy}{dx}=-e\), \(\dfrac{d^2y}{dx^2}=3e\), so \(y=e-ex+\dfrac{3e}{2}x^2+\cdots\). (b) \(e^{\frac{-x}{x+1}}=e^{\frac{1}{x+1}-1}=e^{-1}\,y\); replacing... more directly, \(\dfrac{-x}{x+1}=-1+\dfrac{1}{x+1}\), so \(e^{\frac{-x}{x+1}}=e^{-1}e^{\frac{1}{x+1}}=e^{-1}\left(e-ex+\dfrac{3e}{2}x^2\right)=1-x+\dfrac{3}{2}x^2+\cdots\).$$,
  8,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(y\\left(\\dfrac{d^2y}{dx^2}\\right)-\\left(\\dfrac{dy}{dx}\\right)^2=\\dfrac{2y^2}{(x+1)^3}\\). Hence find the Maclaurin expansion for \\(y\\), up to and including the term in \\(x^2\\).",
    "correct_answer": "e-ex+\\frac{3e}{2}x^2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Deduce the Maclaurin expansion for \\(y=e^{\\frac{-x}{x+1}}\\) up to and including the term in \\(x^2\\).",
    "correct_answer": "1-x+\\frac{3}{2}x^2",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q9 (ADVANCED): series vs function, two sketch parts (concrete) + graded series + FLAG interval.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc219009-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Comparing a function with its Maclaurin polynomial$$,
  $$Let \(f(x)=e^x\sin x\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(ii) \(\sin x=x-\dfrac{x^3}{6}+\cdots\), \(e^x=1+x+\dfrac{x^2}{2}+\cdots\); multiplying, \(f(x)=x+x^2+\dfrac{x^3}{3}+\cdots\). Denote \(g(x)=x+x^2+\dfrac{x^3}{3}\). (i),(iii) On \(-3\le x\le3\), \(y=f(x)\) oscillates with growing amplitude while \(y=g(x)\) is the cubic that agrees with \(f\) near the origin and diverges from it toward the ends. (iv) Solving \(|g(x)-f(x)|=0.5\) with the GC gives \(-1.96<x<1.56\).$$,
  9,
  'H2 Math Tutorial (Maclaurin Series)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Sketch the graph of \\(y=f(x)\\) for \\(-3\\le x\\le3\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Using MF26, find the series expansion of \\(f(x)\\) in ascending powers of \\(x\\), up to and including the term in \\(x^3\\).",
    "correct_answer": "x+x^2+\\frac{x^3}{3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Denote the answer to part (ii) by \\(g(x)\\). On the same diagram as in part (i), sketch the graph of \\(y=g(x)\\), labelling the two graphs clearly.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "Find, for \\(-3\\le x\\le3\\), the set of values of \\(x\\) for which the value of \\(g(x)\\) is within \\(\\pm0.5\\) of the value of \\(f(x)\\).",
    "correct_answer": "-1.96<x<1.56",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);
