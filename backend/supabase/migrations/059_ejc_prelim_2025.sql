-- Migration 059: EJC H2 Math (9758) Prelim 2025 — Papers 1 & 2 (21 questions)
-- Source: EJC_9758_2025_Prelim_P1.pdf / P1_Solutions.pdf, EJC_9758_2025_Prelim_P2.pdf / P2_Solutions.pdf.
-- Question IDs: Paper 1 = 902500NN, Paper 2 = 902510NN (prefix '9025' — hex letters a-f already taken
-- by ACJC/CJC/HCI/DHS/RI/YIJC, so this uses the next unused single hex digit).
-- No DDL: parts JSONB (008) and attempts.part_label already exist.

-- ============================================================
-- PAPER 1
-- ============================================================

-- FLAG: Q1(a)/(b) interval-inequality answers — exact-match brittle (form/order).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  1,
  $$Rational and exponential inequalities$$,
  $$$$,
  'exact',
  $$x<0\ \text{or}\ x>\frac{1}{2}\ln2$$,
  NULL,
  $$(a) \(x+1-\dfrac{1}{x-1}>0\Rightarrow\dfrac{(x+1)(x-1)-1}{x-1}>0\Rightarrow\dfrac{(x+\sqrt2)(x-\sqrt2)}{x-1}>0\). From the sign diagram, \(-\sqrt2<x<1\) or \(x>\sqrt2\). (b) Replacing \(x\) with \(e^{x}\) (noting \(e^{x}>0\) for all \(x\)): \(-\sqrt2<e^{x}<1\) or \(e^{x}>\sqrt2\). Since \(e^{x}>0\) always, \(e^{x}<1\Rightarrow x<0\); \(e^{x}>\sqrt2\Rightarrow x>\ln\sqrt2=\dfrac12\ln2\).$$,
  5,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Solve the inequality \\(x+1>\\dfrac{1}{x-1}\\), giving your answer in exact form. \\([3]\\)",
    "correct_answer": "-\\sqrt{2}<x<1\\ \\text{or}\\ x>\\sqrt{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence solve, in exact form, \\(e^{x}+1>\\dfrac{1}{e^{x}-1}\\). \\([2]\\)",
    "correct_answer": "x<0\\ \\text{or}\\ x>\\frac{1}{2}\\ln2",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  '90250002-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Maximising area of a semicircle-topped rectangle$$,
  $$Pete has 180 cm of wire. He bends it to form the outline of his brand logo, which consists of a semicircle centered on top of a rectangle. The width and length of the rectangle are \(3a\) cm and \(b\) cm respectively. The diameter of the semicircle is one-third the width of the rectangle. Find the maximum possible area enclosed by the wire, showing that it is a maximum value. Give your answer correct to 2 decimal places. \([6]\)$$,
  'range',
  $$1925.82$$,
  0.005,
  $$Perimeter: \(3a+2a+2b+\tfrac12\pi a=180\Rightarrow\left(5+\tfrac{\pi}{2}\right)a+2b=180\Rightarrow b=90-\left(\tfrac52+\tfrac{\pi}{4}\right)a\). Area \(A=3ab+\tfrac12\pi\left(\tfrac{a}{2}\right)^{2}=270a-\left(\tfrac{5\pi}{8}+\tfrac{15}{2}\right)a^{2}\). \(\dfrac{dA}{da}=270-\left(\tfrac{5\pi}{4}+15\right)a=0\Rightarrow a=\dfrac{270}{\frac{5\pi}{4}+15}=14.265\); \(\dfrac{d^{2}A}{da^{2}}=-\left(\tfrac{5\pi}{4}+15\right)<0\), so \(A\) is maximum, giving maximum area \(=1925.82\text{ cm}^{2}\).$$,
  6,
  'EJC H2 Math Prelim 2025'
);

-- FLAG: Q3(c) p, q constants — mixed "show that ... where p, q are constants" part, graded on p and q.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250003-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  $$Small-angle approximation in a right triangle$$,
  $$In the right-angled triangle \(ABC\), angle \(C\) is a right angle. \(AB=13\) cm, \(BC=5\) cm and \(X\) is a point on \(BC\) such that angle \(BAX\) is \(\alpha\) radians.$$,
  'exact',
  $$p=-\frac{65}{12},\ q=\frac{1261}{144}$$,
  NULL,
  $$(a) \(AC=\sqrt{13^{2}-5^{2}}=12\), so \(\cos\angle BAC=\dfrac{AC}{AB}=\dfrac{12}{13}\). (b) \(AX=\dfrac{AC}{\cos(\angle BAC-\alpha)}=\dfrac{12}{\cos\angle BAC\cos\alpha+\sin\angle BAC\sin\alpha}=\dfrac{12}{\frac{12}{13}\cos\alpha+\frac{5}{13}\sin\alpha}=\dfrac{156}{12\cos\alpha+5\sin\alpha}\). (c) Using \(\cos\alpha\approx1-\tfrac{\alpha^{2}}{2}\), \(\sin\alpha\approx\alpha\): \(AX\approx\dfrac{156}{12\left(1-\frac{\alpha^{2}}{2}\right)+5\alpha}=13\left[1+\left(\tfrac{5}{12}\alpha-\tfrac{\alpha^{2}}{2}\right)\right]^{-1}\approx13\left[1-\left(\tfrac{5}{12}\alpha-\tfrac{\alpha^{2}}{2}\right)+\left(\tfrac{5}{12}\alpha\right)^{2}\right]\approx13-\dfrac{65}{12}\alpha+\dfrac{1261}{144}\alpha^{2}\), giving \(p=-\dfrac{65}{12}\), \(q=\dfrac{1261}{144}\).$$,
  8,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the exact value of \\(\\cos\\angle BAC\\). \\([1]\\)",
    "correct_answer": "\\frac{12}{13}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "By considering triangle \\(AXC\\), or otherwise, show that \\(AX=\\dfrac{156}{12\\cos\\alpha+5\\sin\\alpha}\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Given that \\(\\alpha\\) is a sufficiently small angle, show that \\(AX\\approx13+p\\alpha+q\\alpha^{2}\\), where \\(p\\) and \\(q\\) are constants to be determined exactly. \\([4]\\)",
    "correct_answer": "p=-\\frac{65}{12},\\ q=\\frac{1261}{144}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "p",
        "label": "p",
        "correct_answer": "-\\frac{65}{12}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "q",
        "label": "q",
        "correct_answer": "\\frac{1261}{144}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

-- FLAG: Q4(a)-(c) sketches of an abstract f — solution_graph (stand-in curves) to be added in a future migration.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250004-0000-0000-0000-000000000000',
  'aaaa0003-0000-0000-0000-000000000000',
  2,
  $$Graph transformations of f(2x)$$,
  $$The diagram below shows the graph of \(y=f(2x)\). The graph has a turning point at \((2,0)\), and asymptotes with equations \(x=0\) and \(y=k\).$$,
  'exact',
  $$$$,
  NULL,
  $$\(f\) itself has a turning point at \((4,0)\), a vertical asymptote \(x=0\) and horizontal asymptote \(y=k\), defined for \(x>0\). (a) \(y=f(2x+4)=f(2(x+2))\) is a translation of \(y=f(2x)\) by 2 units in the negative \(x\)-direction: turning point \((0,0)\), asymptotes \(x=-2\) and \(y=k\). (b) \(y=\dfrac{1}{f(2x)}\): blows up (vertical asymptote) at \(x=2\), where \(f(2x)=0\); tends to \(0\) as \(x\to0^{+}\) (since \(f(2x)\to\infty\)); horizontal asymptote \(y=\dfrac1k\) as \(x\to\infty\). (c) \(y=-f(|x|)\): reflecting \(f\) in the \(y\)-axis gives an even function with turning points at \(x=\pm4\) and vertical behaviour at \(x=0\); reflecting in the \(x\)-axis then gives turning points \((\pm4,0)\), the graph tending to \(-\infty\) near \(x=0\), and horizontal asymptote \(y=-k\).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "State a single transformation that will transform the graph of \\(y=f(2x)\\) onto the graph of \\(y=f(2x+4)\\). Hence sketch the graph of \\(y=f(2x+4)\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Sketch the graph of \\(y=\\dfrac{1}{f(2x)}\\), on a separate clearly labelled diagram. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Sketch the graph of \\(y=-f(|x|)\\), on a separate clearly labelled diagram. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q5(b) rational q — many valid n give a valid q, exact-match only accepts one (n=3, q=37/60).
-- FLAG: Q5(c) g(r) form — depends on parameter n, exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250005-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  $$Riemann sum bounds for ln 2$$,
  $$The diagram shows the curve with equation \(y=\dfrac1x\). \(n\) rectangles of equal width are drawn under the curve between \(x=1\) and \(x=2\). Let \(S_n\) be the total area of the \(n\) rectangles.$$,
  'exact',
  $$\frac{1}{n+r}$$,
  NULL,
  $$(a) \(S_2=\left(\tfrac12\right)\left(\tfrac23\right)+\left(\tfrac12\right)\left(\tfrac12\right)=\tfrac{7}{12}\); since \(\int_1^2\tfrac1x\,dx=\ln2\) and the two rectangles lie under the curve, \(S_2<\ln2\), i.e. \(\tfrac{7}{12}<\ln2\). (b) E.g. \(n=3\) gives \(S_3=\tfrac{37}{60}\), and \(\tfrac{7}{12}<\tfrac{37}{60}<\ln2\), so \(q=\tfrac{37}{60}\) works. (c) \(S_n=\left(\tfrac1n\right)\left(\tfrac1{\frac{n+1}n}\right)+\cdots+\left(\tfrac1n\right)\left(\tfrac1{\frac{2n}n}\right)=\tfrac1{n+1}+\cdots+\tfrac1{2n}=\sum_{r=1}^{n}\tfrac1{n+r}\). (d) Drawing \(n\) rectangles of equal width **above** the curve on \([1,2]\): \(\ln2<\tfrac1n+\tfrac1{n+1}+\cdots+\tfrac1{2n-1}=\tfrac1n+\left(S_n-\tfrac1{2n}\right)=S_n+\tfrac1{2n}\) (using \(n=n+n\) so the extra leading term is \(\tfrac1n\), replacing the omitted \(\tfrac1{2n}\) term of \(S_n\)).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Let \\(n=2\\). By considering \\(S_{2}\\), show that \\(\\dfrac{7}{12}<\\ln2\\). State your reasoning clearly. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "By considering \\(S_n\\) for a suitable value of \\(n\\), find a rational number \\(q\\) such that \\(\\dfrac{7}{12}<q<\\ln2\\). \\([2]\\)",
    "correct_answer": "\\frac{37}{60}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Express \\(S_n\\) in the form \\(\\displaystyle\\sum_{r=1}^{n}g(r)\\), where the function \\(g\\) is to be determined. \\([1]\\)",
    "correct_answer": "\\frac{1}{n+r}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "By considering another suitable set of \\(n\\) rectangles, show with the aid of a diagram that \\(\\ln2<S_n+\\dfrac{1}{2n}\\) where \\(n\\) is any given positive integer. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250006-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  $$Circle theorem and tangent (vectors)$$,
  $$There are three distinct points \(A\), \(B\) and \(P\). The point \(P\) lies on the circle with centre \(O\) and diameter \(AB\). Relative to the origin \(O\), the position vectors of points \(A\) and \(P\) are \(\mathbf{a}\) and \(\mathbf{p}\) respectively.$$,
  'exact',
  $$\frac{3}{2}$$,
  NULL,
  $$(a) \(\overrightarrow{AP}=\mathbf{p}-\mathbf{a}\), \(\overrightarrow{BP}=\mathbf{p}+\mathbf{a}\); \(\overrightarrow{AP}\boldsymbol{\cdot}\overrightarrow{BP}=|\mathbf{p}|^{2}-|\mathbf{a}|^{2}=0\) since \(OA\) and \(OP\) are both radii, so \(|\mathbf{p}|=|\mathbf{a}|\). (b) By the ratio theorem, \(\mathbf{b}=\dfrac{(\lambda-1)\mathbf{a}+\mathbf{c}}{\lambda}\); since \(\mathbf{b}=-\mathbf{a}\) (as \(B\) is diametrically opposite \(A\)), \(\mathbf{c}=\lambda\mathbf{b}-(\lambda-1)\mathbf{a}=(1-2\lambda)\mathbf{a}\). (c) \(\overrightarrow{PC}=(1-2\lambda)\mathbf{a}-\mathbf{p}\); since \(PC\) is tangent, \(\overrightarrow{OP}\boldsymbol{\cdot}\overrightarrow{PC}=0\Rightarrow(1-2\lambda)\mathbf{p}\boldsymbol{\cdot}\mathbf{a}-|\mathbf{p}|^{2}=0\Rightarrow-\tfrac12(1-2\lambda)|\mathbf{a}|^{2}-|\mathbf{a}|^{2}=0\) (using \(\mathbf{p}\boldsymbol{\cdot}\mathbf{a}=|\mathbf{p}||\mathbf{a}|\cos120^{\circ}=-\tfrac12|\mathbf{a}|^{2}\)), giving \(\lambda=\dfrac32\).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "By expressing \\(\\overrightarrow{AP}\\) and \\(\\overrightarrow{BP}\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{p}\\), show that \\(\\overrightarrow{AP}\\boldsymbol{\\cdot}\\overrightarrow{BP}=0\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The point \\(C\\) with position vector \\(\\mathbf{c}\\) lies on \\(AB\\) produced such that \\(AC:AB\\) is \\(\\lambda:1\\). Find \\(\\mathbf{c}\\) in terms of \\(\\lambda\\) and \\(\\mathbf{a}\\). \\([2]\\)",
    "correct_answer": "(1-2\\lambda)\\mathbf{a}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is given that \\(PC\\) is a tangent to the circle and that angle \\(AOP\\) is \\(120^{\\circ}\\). Using a suitable scalar product, find the value of \\(\\lambda\\). \\([4]\\)",
    "correct_answer": "\\frac{3}{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q7(b) v2 = ±3√b — order/sign form brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250007-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$AP/GP with unknown third term$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$b=1,\ u_{2}=5,\ v_{2}=-3$$,
  NULL,
  $$(a) \(u_{2}=\dfrac{u_{1}+u_{3}}{2}=\dfrac{9+b}{2}\). (b) \(v_{2}^{2}=v_{1}v_{3}=9b\Rightarrow v_{2}=\pm3\sqrt{b}\). (c) \(u_{2}-v_{2}=8\Rightarrow v_{2}=u_{2}-8\Rightarrow(u_2-8)^2=9b\Rightarrow4b^{2}-14b+49=9b\Rightarrow b^{2}-50b+49=0\Rightarrow(b-1)(b-49)=0\Rightarrow b=1\) or \(b=49\); if \(b=49\), \(|r|=\tfrac73>1\) which contradicts convergence, so \(b=1\). Then \(u_{2}=\dfrac{9+1}{2}=5\) and \(v_{2}=5-8=-3\).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "An arithmetic sequence \\(u_{1},u_{2},u_{3},\\ldots\\) has \\(u_{1}=9\\) and \\(u_{3}=b\\), where \\(b\\) is a constant. Find \\(u_{2}\\) in terms of \\(b\\). \\([2]\\)",
    "correct_answer": "\\frac{9+b}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "A geometric sequence \\(v_{1},v_{2},v_{3},\\ldots\\) has \\(v_{1}=9\\) and \\(v_{3}=b\\). Find the possible values of \\(v_{2}\\) in terms of \\(b\\). \\([2]\\)",
    "correct_answer": "\\pm3\\sqrt{b}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is now given that \\(u_{2}-v_{2}=8\\), and the geometric sequence \\(v_{1},v_{2},v_{3},\\ldots\\) is convergent. Find the value of \\(b\\). Hence find \\(u_{2}\\) and \\(v_{2}\\). \\([5]\\)",
    "correct_answer": "b=1,\\ u_{2}=5,\\ v_{2}=-3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "b",
        "label": "b",
        "correct_answer": "1",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "u2",
        "label": "u_2",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "v2",
        "label": "v_2",
        "correct_answer": "-3",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250008-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  $$Complex roots of a cubic$$,
  $$Do not use a calculator in answering this question.$$,
  'exact',
  $$1-i,\ 0,\ -1$$,
  NULL,
  $$(a) \((a+bi)^{2}=2i\Rightarrow a^{2}-b^{2}=0\), \(2ab=2\); \(a=\tfrac1b\Rightarrow1-b^{4}=0\Rightarrow b^{2}=1\), so \(b=a=1\) (rejecting \(b=a=-1\) since \(0\le\arg(w)\le\tfrac\pi2\)); \(w=1+i\). (b) Since \(1+i\) is a root, \(z^{3}-z^{2}+(1-i)z+s=[z-(1+i)](z^{2}+Bz+C)\); comparing coefficients gives \(B=i\), \(C=0\), \(s=0\); \(z^{2}+iz=0\Rightarrow z(z+i)=0\Rightarrow z=0\) or \(z=-i\). (c) Substituting \(z=iv\) into \(z^3-z^2+(1-i)z+s=0\) and dividing by \(-i\) gives \(-iv^{3}+v^{2}+(1+i)v+s=0\); since \(z=iv\Rightarrow v=-iz\), the roots are \(v=-i(1+i)=1-i\), \(v=-i(0)=0\), \(v=-i(-i)=-1\).$$,
  10,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "The complex number \\(w\\) is such that \\(w^{2}=2i\\) and \\(0\\le\\arg(w)\\le\\dfrac{\\pi}{2}\\). Find \\(w\\). \\([3]\\)",
    "correct_answer": "1+i",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that one of the roots of the equation \\(z^{3}-z^{2}+(1-i)z+s=0\\) is \\(w\\), find the other roots of the equation and the value of \\(s\\). \\([5]\\)",
    "correct_answer": "0,\\ -i,\\ s=0",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      {
        "key": "roots",
        "label": "\\text{other roots}",
        "correct_answer": "0,\\ -i",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "s",
        "label": "s",
        "correct_answer": "0",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "c",
    "prompt_latex": "Hence, find the roots of the equation \\(-iv^{3}+v^{2}+(1+i)v+s=0\\). \\([2]\\)",
    "correct_answer": "1-i,\\ 0,\\ -1",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q9(a)(ii) domain interval and (b)(ii) piecewise g^n(x) and (c)(ii) range interval — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250009-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  $$Cubic, rational and quadratic functions$$,
  $$$$,
  'exact',
  $$\left(-2,\frac{1}{2}\right]$$,
  NULL,
  $$(a)(i) From the GC, the turning points of \(y=x^{3}-3x^{2}-9x+5\) are \((-1,10)\) and \((3,-22)\). (a)(ii) For \(f^{-1}\) to exist, \(f\) must be one-one; the largest such domain is \(x\le-1\), so \(a=-1\); \(D_{f^{-1}}=R_{f}=(-\infty,10]\). (b)(i) \(g^{2}(x)=\dfrac{1-2\left(\frac{1-2x}{x+2}\right)}{\frac{1-2x}{x+2}+2}=\dfrac{x+2-2(1-2x)}{1-2x+2(x+2)}=\dfrac{5x}{5}=x\). (b)(ii) Since \(g\) is self-inverse, \(g^{n}(x)=x\) if \(n\) is even, and \(g^{n}(x)=\dfrac{1-2x}{x+2}\) if \(n\) is odd. (c)(i) \(R_{h}=[0,\infty)\), \(D_{g}=\mathbb{R}\setminus\{-2\}\); since \(R_{h}\subseteq D_{g}\), \(gh\) exists. (c)(ii) From the graph of \(y=g(x)\) restricted to \([0,\infty)\), \(R_{gh}=\left(-2,\tfrac12\right]\).$$,
  11,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "ai",
    "prompt_latex": "State the coordinates of the turning points of the graph of \\(y=x^{3}-3x^{2}-9x+5\\). \\([1]\\)",
    "correct_answer": "(-1,10),\\ (3,-22)",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "x1", "label": "x_1", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "y1", "label": "y_1", "correct_answer": "10", "answer_type": "exact", "tolerance": null },
      { "key": "x2", "label": "x_2", "correct_answer": "3", "answer_type": "exact", "tolerance": null },
      { "key": "y2", "label": "y_2", "correct_answer": "-22", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "aii",
    "prompt_latex": "The function \\(f\\) is defined by \\(f(x)=x^{3}-3x^{2}-9x+5\\), \\(x\\in\\mathbb{R}\\), \\(x\\le a\\), where \\(a\\) is a constant. Find the largest possible value of \\(a\\) such that \\(f^{-1}\\) exists, and state the domain of \\(f^{-1}\\) in this case. \\([2]\\)",
    "correct_answer": "a=-1,\\ D_{f^{-1}}=(-\\infty,10]",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "domain", "label": "D_{f^{-1}}", "correct_answer": "(-\\infty,10]", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "bi",
    "prompt_latex": "The function \\(g\\) is defined by \\(g(x)=\\dfrac{1-2x}{x+2}\\), \\(x\\in\\mathbb{R}\\), \\(x\\ne-2\\). Find \\(g^{2}(x)\\). \\([2]\\)",
    "correct_answer": "x",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "bii",
    "prompt_latex": "Hence find the possible expressions of \\(g^{n}(x)\\), where \\(n\\) is a positive integer. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ci",
    "prompt_latex": "The function \\(h\\) is defined by \\(h(x)=x^{2}\\), \\(x\\in\\mathbb{R}\\), \\(x\\le0\\). Explain why the composite function \\(gh\\) exists. \\([2]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "cii",
    "prompt_latex": "Find the range of \\(gh\\). \\([2]\\)",
    "correct_answer": "\\left(-2,\\frac{1}{2}\\right]",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250010-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Definite and indefinite integration techniques$$,
  $$$$,
  'exact',
  $$e^{3}+e-2$$,
  NULL,
  $$(a) \(\displaystyle\int_0^4e^{|x-1|}\,dx=\int_0^1e^{1-x}\,dx+\int_1^4e^{x-1}\,dx=\left[-e^{1-x}\right]_0^1+\left[e^{x-1}\right]_1^4=(-1+e)+(e^{3}-1)=e^{3}+e-2\). (b) \(\displaystyle\int\sin^{2}3x+\tan^{2}3x\,dx=\int\dfrac{1-\cos6x}{2}+\sec^{2}3x-1\,dx=-\dfrac1{12}\sin6x+\dfrac13\tan3x-\dfrac12x+C\). (c) With \(x=u^{6}\), \(dx=6u^{5}\,du\): \(\displaystyle\int\dfrac{1}{\sqrt x+\sqrt[3]x}\,dx=\int\dfrac{6u^{5}}{u^{3}+u^{2}}\,du=6\int u^{2}-u+1-\dfrac1{u+1}\,du=2\sqrt x-3\sqrt[3]x+6\sqrt[6]x-6\ln\left(\sqrt[6]x+1\right)+C\).$$,
  12,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\displaystyle\\int_0^4 e^{|x-1|}\\,dx\\), leaving your answer in exact form. \\([4]\\)",
    "correct_answer": "e^{3}+e-2",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find \\(\\displaystyle\\int \\sin^{2}3x+\\tan^{2}3x\\,dx\\). \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Use the substitution \\(x=u^{6}\\), where \\(u>0\\), to find \\(\\displaystyle\\int \\dfrac{1}{\\sqrt{x}+\\sqrt[3]{x}}\\,dx\\). \\([5]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90250011-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Draining cylindrical container (differential equations)$$,
  $$A cylindrical container of height \(h\) metres is originally completely filled with water. The water is flowing out through an opening at the base of the container into a pipe. The rate of flow of water through the opening at time \(t\) seconds is proportional to the square root of the height of the water in the container, \(y\) metres. Since the container is cylindrical, the amount of water in the container is also proportional to the height of water, so the differential equation relating \(y\) and \(t\) can be written as \[\dfrac{dy}{dt}=-k\sqrt{y}\] where \(k\) is a positive constant.$$,
  'range',
  $$1.99$$,
  0.005,
  $$(a) \(\dfrac1{\sqrt y}\dfrac{dy}{dt}=-k\Rightarrow\displaystyle\int\dfrac1{\sqrt y}\,dy=\int-k\,dt\Rightarrow2\sqrt y=-kt+C\); at \(t=0\), \(y=h\Rightarrow C=2\sqrt h\); \(\sqrt y=\sqrt h-\dfrac{kt}2\). (b) When \(y=0\): \(t=\dfrac{2\sqrt h}{k}\). (c) Since \(\cos t\) varies between \(-1\) and \(1\), \(\dfrac{1+\cos t}2\) varies between \(0\) and \(1\) (rather than being constantly \(1\)), so the flow is now slower. (d) \(\dfrac1{\sqrt y}\dfrac{dy}{dt}=-\dfrac{k(1+\cos t)}2\Rightarrow2\sqrt y=-\dfrac k2(t+\sin t)+D\); at \(t=0\), \(y=h\Rightarrow D=2\sqrt h\); \(\sqrt y=\sqrt h-\dfrac{kt+k\sin t}4\). (e) With \(h=10\), \(k=0.1\): original model empties in \(63.25\) s, revised model in \(126.08\) s, giving ratio \(\dfrac{126.08}{63.25}=1.99\).$$,
  12,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Solve this differential equation to find \\(\\sqrt{y}\\) in terms of \\(t\\), \\(h\\) and \\(k\\). \\([4]\\)",
    "correct_answer": "\\sqrt{h}-\\frac{kt}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence find the time taken for the container to empty, in terms of \\(h\\) and \\(k\\). \\([2]\\)",
    "correct_answer": "\\frac{2\\sqrt{h}}{k}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is found that the water was draining too fast. To regulate the flow of water, a mechanical device is placed at the opening. This device slows the flow of water into the pipe by covering all or part of the opening, where the area covered varies with time. It is proposed to model this situation using the revised differential equation \\[\\dfrac{dy}{dt}=-k\\left(\\dfrac{1+\\cos t}{2}\\right)\\sqrt{y},\\] where \\(k\\) is the same constant as before. With reference to the possible values of \\(\\cos t\\), explain how the revised differential equation corresponds to a model with slower flow of water. \\([1]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Given again that the container is originally completely filled with water, solve the revised differential equation to find \\(\\sqrt{y}\\) in terms of \\(t\\), \\(h\\) and \\(k\\). \\([3]\\)",
    "correct_answer": "\\sqrt{h}-\\frac{kt+k\\sin t}{4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "In the case where \\(h=10\\) and \\(k=0.1\\), find the ratio of the time taken in the revised model to the time taken in the original model for the container to empty. Give your answer to 3 significant figures. \\([2]\\)",
    "correct_answer": "1.99",
    "answer_type": "range",
    "tolerance": 0.005
  }
]$$::jsonb
);

-- ============================================================
-- PAPER 2
-- ============================================================

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251001-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Implicit curve tangents$$,
  $$The curve \(C\) has equation \(x^{3}+y^{3}-3xy=k\), where \(k\) is a positive constant. \(C\) intersects the \(x\)-axis at the point \(A\).$$,
  'exact',
  $$y=k^{\frac{1}{3}}x-k^{\frac{2}{3}}$$,
  NULL,
  $$Differentiating \(C\) w.r.t. \(x\): \(3x^{2}+3y^{2}\dfrac{dy}{dx}-3x\dfrac{dy}{dx}-3y=0\Rightarrow\dfrac{dy}{dx}=\dfrac{y-x^{2}}{y^{2}-x}\). (a) When \(y=0\): \(x^{3}=k\Rightarrow x=k^{1/3}\); \(\dfrac{dy}{dx}=x=k^{1/3}\); tangent: \(y=k^{1/3}\left(x-k^{1/3}\right)=k^{1/3}x-k^{2/3}\). (b) Tangent parallel to \(y\)-axis \(\Rightarrow y^{2}-x=0\Rightarrow x=y^{2}\); substituting into \(C\) with \(k=3\): \(y^{6}+y^{3}-3y^{3}-3=0\Rightarrow y^{6}-2y^{3}-3=0\Rightarrow(y^{3}-3)(y^{3}+1)=0\Rightarrow y=3^{1/3}\) or \(y=-1\).$$,
  8,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the equation of the tangent to \\(C\\) at \\(A\\). Give your answer in the form \\(y=px+q\\), where \\(p\\) and \\(q\\) are constants to be found in terms of \\(k\\). \\([5]\\)",
    "correct_answer": "p=k^{\\frac{1}{3}},\\ q=-k^{\\frac{2}{3}}",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "p", "label": "p", "correct_answer": "k^{\\frac{1}{3}}", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "-k^{\\frac{2}{3}}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "There are two points on \\(C\\) where the tangents are parallel to the \\(y\\)-axis. Given that \\(k=3\\), find the exact \\(y\\)-coordinates of these two points. \\([3]\\)",
    "correct_answer": "y=3^{\\frac{1}{3}}\\ \\text{or}\\ y=-1",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "y1", "label": "y_1", "correct_answer": "3^{\\frac{1}{3}}", "answer_type": "exact", "tolerance": null },
      { "key": "y2", "label": "y_2", "correct_answer": "-1", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- FLAG: Q2(a) limits "0 or 1/2" — order/form brittle.
-- FLAG: Q2(b) compound numeric+word-judgement table (u2, u3 for 3 cases, convergence) — left ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251002-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  $$Logistic-type recurrence sequence$$,
  $$A sequence \(u_{1},u_{2},u_{3},\ldots\) is defined by \[u_{n+1}=2u_{n}(1-u_{n})\] for all positive integers \(n\).$$,
  'exact',
  $$0\ \text{or}\ \frac{1}{2}$$,
  NULL,
  $$(a) Let \(L\) be the limit: \(L=2L(1-L)\Rightarrow2L^{2}-L=0\Rightarrow L(2L-1)=0\Rightarrow L=0\) or \(L=\dfrac12\). (b) \(u_{1}=0\): \(u_{2}=0\), \(u_{3}=0\); convergent. \(u_{1}=0.01\): \(u_{2}=0.0198\) (exact), \(u_{3}=0.0388\) (3 s.f.); convergent. \(u_{1}=-0.01\): \(u_{2}=-0.0202\) (exact), \(u_{3}=-0.0412\) (3 s.f.); not convergent.$$,
  8,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the possible limits of the sequence, if the sequence is convergent. \\([2]\\)",
    "correct_answer": "0\\ \\text{or}\\ \\frac{1}{2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "For each of the following, evaluate \\(u_{2}\\) and \\(u_{3}\\), and state whether the sequence is convergent: \\(\\bullet\\ u_{1}=0\\); \\(\\bullet\\ u_{1}=0.01\\); \\(\\bullet\\ u_{1}=-0.01\\). \\([6]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q3(a) sketch of C1 (rational curve) and C2 (ellipse) — solution_graph to be added in a future migration.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251003-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  3,
  $$Rational curve and ellipse — sketch and volume$$,
  $$The curve \(C_{1}\) has equation \(y=\dfrac{x^{2}-8x+28}{2-x}\). The curve \(C_{2}\) has equation \(\dfrac{(x-6)^{2}}{16}+\dfrac{y^{2}}{25}=1\).$$,
  'range',
  $$58.7$$,
  0.05,
  $$(a) \(C_{1}\) has vertical asymptote \(x=2\), oblique asymptote \(y=6-x\) (by polynomial division), a local max/min pair at \((-2,12)\) and \((6,-4)\), and passes through \(x\)-intercepts... it does not cross the \(x\)-axis in the shown range. \(C_{2}\) is an ellipse centred \((6,0)\) with vertices \((2,0)\), \((10,0)\), \((6,5)\), \((6,-5)\). (b) The \(x\)-coordinates of the intersections of \(C_1\) and \(C_2\) are \(4.6391\) and \(7.7172\) (5 s.f.). Rewriting \(C_2\) as \(y^{2}=25\left(1-\dfrac{(x-6)^{2}}{16}\right)\), the required volume \(=\pi\displaystyle\int_{4.6391}^{7.7172}25\left(1-\dfrac{(x-6)^{2}}{16}\right)-\left(\dfrac{x^{2}-8x+28}{2-x}\right)^{2}dx=58.7\) units\(^{3}\) (3 s.f.).$$,
  11,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Sketch \\(C_{1}\\) and \\(C_{2}\\) on the same diagram, stating the coordinates of any vertices, turning points, intersections with the \\(x\\)-axis and the equations of any asymptotes. \\([7]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the volume of solid obtained when the smaller region bounded by \\(C_{1}\\) and \\(C_{2}\\) is rotated through \\(2\\pi\\) radians about the \\(x\\)-axis. \\([4]\\)",
    "correct_answer": "58.7",
    "answer_type": "range",
    "tolerance": 0.05
  }
]$$::jsonb
);

-- FLAG: Q4(d) vector equation of the line of reflection — non-unique form, exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251004-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  $$Lines, planes and reflection$$,
  $$Relative to the origin \(O\), point \(A\) has position vector given by \(\mathbf{a}=\begin{pmatrix}1\\2\\1\end{pmatrix}\). The line \(l_{1}\) passes through the point \(A\) and is parallel to \(\begin{pmatrix}t\\3-t^{2}\\1\end{pmatrix}\). The plane \(p\) has equation \(\mathbf{r}=\lambda\begin{pmatrix}0\\5\\2\end{pmatrix}+\mu\begin{pmatrix}5\\0\\t\end{pmatrix}\), \(\lambda,\mu\in\mathbb{R}\), where \(t\) is a real constant. It is known that \(l_{1}\) and \(p\) are parallel and \(l_{1}\) is not on \(p\).$$,
  'exact',
  $$\mathbf{r}=k\begin{pmatrix}13\\34\\5\end{pmatrix},\ k\in\mathbb{R}$$,
  NULL,
  $$Normal of \(p\): \(\begin{pmatrix}0\\5\\2\end{pmatrix}\times\begin{pmatrix}5\\0\\t\end{pmatrix}=\begin{pmatrix}5t\\10\\-25\end{pmatrix}=5\begin{pmatrix}t\\2\\-5\end{pmatrix}\), so \(p:\mathbf{r}\boldsymbol{\cdot}\begin{pmatrix}t\\2\\-5\end{pmatrix}=0\). (a) \(l_{1}\parallel p\Rightarrow\begin{pmatrix}t\\3-t^{2}\\1\end{pmatrix}\boldsymbol{\cdot}\begin{pmatrix}t\\2\\-5\end{pmatrix}=0\Rightarrow t^{2}+6-2t^{2}-5=0\Rightarrow t^{2}=1\Rightarrow t=\pm1\); since \(A\) is not on \(p\), \(\begin{pmatrix}1\\2\\1\end{pmatrix}\boldsymbol{\cdot}\begin{pmatrix}t\\2\\-5\end{pmatrix}\ne0\Rightarrow t+4-5\ne0\Rightarrow t\ne1\), so \(t=-1\). (b) With \(t=-1\), direction of \(l_1\) is \(\begin{pmatrix}-1\\2\\1\end{pmatrix}\), and \(l_2\) has direction \(\mathbf{a}=\begin{pmatrix}1\\2\\1\end{pmatrix}\); \(\theta=\cos^{-1}\left|\dfrac1{\sqrt6}\begin{pmatrix}-1\\2\\1\end{pmatrix}\boldsymbol{\cdot}\dfrac1{\sqrt6}\begin{pmatrix}1\\2\\1\end{pmatrix}\right|=\cos^{-1}\left|\dfrac46\right|=48.2^{\circ}\). (c) \(|\mathbf{a}\boldsymbol{\cdot}\mathbf{n}|\) is the perpendicular distance from \(A\) to \(p\); \(|\mathbf{a}\boldsymbol{\cdot}\mathbf{n}|=\left|\begin{pmatrix}1\\2\\1\end{pmatrix}\boldsymbol{\cdot}\dfrac1{\sqrt{30}}\begin{pmatrix}-1\\2\\-5\end{pmatrix}\right|=\left|\dfrac{-2}{\sqrt{30}}\right|=\dfrac2{\sqrt{30}}\). (d) Foot of perpendicular \(N\) from \(A\) to \(p\): \(\overrightarrow{ON}=\dfrac1{15}\begin{pmatrix}14\\32\\10\end{pmatrix}\); point of reflection \(B\) with \(\overrightarrow{OB}=2\overrightarrow{ON}-\overrightarrow{OA}=\dfrac1{15}\begin{pmatrix}13\\34\\5\end{pmatrix}\); since the reflected line passes through \(O\) (on \(l_2\)) and \(B\), its equation is \(\mathbf{r}=k\begin{pmatrix}13\\34\\5\end{pmatrix}\), \(k\in\mathbb{R}\).$$,
  13,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(t=-1\\). \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The line \\(l_{2}\\) passes through the origin and point \\(A\\). Find the acute angle between \\(l_{1}\\) and \\(l_2\\), in degrees. \\([2]\\)",
    "correct_answer": "48.2",
    "answer_type": "range",
    "tolerance": 0.05
  },
  {
    "label": "c",
    "prompt_latex": "The vector \\(\\mathbf{n}\\) is a unit vector normal to \\(p\\). State the geometrical meaning of \\(|\\mathbf{a}\\boldsymbol{\\cdot}\\mathbf{n}|\\) and find the exact value of \\(|\\mathbf{a}\\boldsymbol{\\cdot}\\mathbf{n}|\\). \\([3]\\)",
    "correct_answer": "\\frac{2}{\\sqrt{30}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "Find a vector equation of the line of reflection of \\(l_{2}\\) in \\(p\\). \\([4]\\)",
    "correct_answer": "\\mathbf{r}=k\\begin{pmatrix}13\\\\34\\\\5\\end{pmatrix},\\ k\\in\\mathbb{R}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251005-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Arranging coloured glasses$$,
  $$Mary is setting up a tabletop display using 6 glasses, arranged around a circular tray. There are 4 different colours of glasses – Red, Blue, Green and Yellow. For each colour, Mary owns one tall and one short glass, so she has 8 glasses in total.$$,
  'exact',
  $$336$$,
  NULL,
  $$(a) Number of ways to choose the 6 glasses \(=\dbinom86-\dbinom41=24\); required number of ways \(=24\times(6-1)!=2880\). (b) Number of ways \(=4\times4=16\). (c) Let \(A\) be the event blue glasses adjacent, \(B\) the event yellow glasses adjacent. \(n(A')=4!\times\dbinom52\times2!=480\) (arrange 4 non-blue glasses, slot in blues); \(n(A'\cap B)=3!\times2!\times\dbinom42\times2!=144\) (group yellows, arrange with red/green, slot in blues). Required \(=n(A')-n(A'\cap B)=336\).$$,
  7,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "In how many ways can Mary arrange 6 of the 8 glasses around the circular tray, such that at least one glass of each colour is used? \\([3]\\)",
    "correct_answer": "2880",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Mary decides to give away one tall glass and one short glass to support a charity drive. In how many ways can she choose the two glasses to give away? \\([1]\\)",
    "correct_answer": "16",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Mary decides to give away the red tall glass and green short glass. She now wants to arrange the remaining 6 glasses in a straight row, such that no two adjacent glasses are of the same colour. Find the number of different arrangements. \\([3]\\)",
    "correct_answer": "336",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q6(a) probability tree diagram — not a coordinate graph, no solution_graph pipeline used.
-- FLAG: Q6(b) inequality "p>0.928" — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Three-stage game probability tree$$,
  $$An online game consists of three stages. All players start with Stage 1, and no matter whether they win or lose, they proceed to Stage 2. Players are allowed to proceed to Stage 3 only if they have won at least one of the first two stages. Ming's probability of winning Stage 1 is \(p\). If Ming wins a stage, his probability of winning the next stage is halved. If he loses a stage, his probability of winning remains unchanged in the next stage.$$,
  'range',
  $$0.583$$,
  0.0005,
  $$(a) [tree: Stage 1 win \(p\)/lose \(1-p\); after a win, next-stage win prob halves, after a loss it is unchanged.] (b) \(P(\text{wins all 3})=p(0.5p)(0.5^{2}p)=0.125p^{3}>0.1\Rightarrow p^{3}>0.8\Rightarrow p>0.928\) (3 s.f.). (c) With \(p=0.9\): \(P(\text{exactly 2 of 3}\mid\text{proceeds to Stage 3})=\dfrac{0.9(0.45)(1-0.225)+0.9(0.55)(0.45)+0.1(0.9)(0.45)}{1-(0.1)(0.1)}=\dfrac{0.577125}{0.99}=0.583\) (3 s.f.).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Draw a probability tree diagram to represent all possible outcomes for Ming over the three stages. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the range of possible values of \\(p\\) if the probability that Ming wins all three stages is more than 0.1. \\([2]\\)",
    "correct_answer": "p>0.928",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "It is now known that \\(p=0.9\\). Given that Ming proceeds to Stage 3, find the probability that he wins exactly two stages out of the three. \\([4]\\)",
    "correct_answer": "0.583",
    "answer_type": "range",
    "tolerance": 0.0005
  }
]$$::jsonb
);

-- FLAG: Q7(b) scatter diagram + comment — solution_graph to be added in a future migration.
-- FLAG: Q7(d) regression-line equation — non-unique form, exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251007-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Correlation and quadratic regression$$,
  $$An investigation into the relationship between two variables \(x\) and \(y\) results in the following data. \[\begin{array}{c|ccccccc}x&7&8&9&10&11&12&13\\\hline y&1.1&5.7&9.3&9.8&8.6&6.4&0.9\end{array}\]$$,
  'range',
  $$-0.997$$,
  0.0005,
  $$(a) \(r=0.00208\) (3 s.f.). (b) The scatter diagram shows a non-linear (curved) relationship between \(x\) and \(y\). (c) \(r=-0.997\), indicating a (very) strong negative linear correlation between \(y\) and \((x-10)^{2}\). (d) Regression line: \(y=-0.987(x-10)^{2}+9.92\); at \(x=17\), \(y=-38.4\); this estimate is not valid because \(x=17\) lies outside the data range \(7\le x\le13\).$$,
  9,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Calculate the product moment correlation coefficient between \\(x\\) and \\(y\\). \\([1]\\)",
    "correct_answer": "0.00208",
    "answer_type": "range",
    "tolerance": 0.00001
  },
  {
    "label": "b",
    "prompt_latex": "Draw a scatter diagram of the data and comment on the relationship between \\(x\\) and \\(y\\) based on the scatter diagram. \\([3]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Several possible models for the relationship between \\(x\\) and \\(y\\) are proposed; one is chosen for further investigation. Calculate the product moment correlation coefficient between \\(y\\) and \\((x-10)^{2}\\), and comment on its value. \\([2]\\)",
    "correct_answer": "-0.997",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "d",
    "prompt_latex": "Find the equation of the regression line of \\(y\\) on \\((x-10)^{2}\\). Use the equation of the regression line to estimate the value of \\(y\\) when \\(x=17\\) and comment on the reliability of this estimate. \\([3]\\)",
    "correct_answer": "y=-0.987(x-10)^{2}+9.92,\\ y(17)=-38.4",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "eq", "label": "\\text{regression line}", "correct_answer": "y=-0.987(x-10)^{2}+9.92", "answer_type": "exact", "tolerance": null },
      { "key": "y17", "label": "y(17)", "correct_answer": "-38.4", "answer_type": "range", "tolerance": 0.05 }
    ]
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251008-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Expectation and variance of random variables$$,
  $$$$,
  'exact',
  $$p=0.2,\ q=0.35,\ r=0.3$$,
  NULL,
  $$(a) \(E(X-3)=E(X)-3=1\); \(Var(X-3)=E[(X-3)^{2}]-[E(X-3)]^{2}=40-1=39\); \(Var(X)=Var(X-3)=39\). (b) With \(Y\sim B\left(3,\tfrac13\right)\) and \(f(t)=\tfrac1{t+1}\): \(E[f(Y)]=\sum f(y)P(Y=y)=\tfrac8{27}+\tfrac29+\tfrac2{27}+\tfrac1{108}=\tfrac{65}{108}\) (or \(0.602\), 3 s.f.). (c) \(p+q+r=0.85\); from \(E(W)=-0.2\): \(-3p-q+2r=-0.35\); from \(E(W^{3})=-3.2\): \(-27p-q+8r=-3.35\); solving, \(p=0.2\), \(q=0.35\), \(r=0.3\).$$,
  10,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "\\(X\\) is a random variable such that \\(\\mathrm{E}(X)=4\\) and \\(\\mathrm{E}\\!\\left[(X-3)^{2}\\right]=40\\). Find the value of \\(\\mathrm{Var}(X)\\). \\([3]\\)",
    "correct_answer": "39",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Let \\(Y\\) be a discrete random variable. Let f be a function which is defined for all values that \\(Y\\) can take. Then \\(f(Y)\\) is also a random variable, and its expectation is given by \\[\\mathrm{E}[f(Y)]=\\sum_{y} f(y)\\,\\mathrm{P}(Y=y).\\] Suppose now that \\(Y\\sim B\\!\\left(3,\\dfrac13\\right)\\) and \\(f(t)=\\dfrac{1}{t+1}\\). Find the value of \\(\\mathrm{E}[f(Y)]\\). \\([3]\\)",
    "correct_answer": "\\frac{65}{108}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "\\(W\\) is a random variable with the following probability distribution: \\[\\begin{array}{c|cccc}w&-3&-1&1&2\\\\\\hline \\mathrm{P}(W=w)&p&q&0.15&r\\end{array}\\] It is given that \\(\\mathrm{E}(W)=-0.2\\) and \\(\\mathrm{E}(W^{3})=-3.2\\). Find the values of \\(p\\), \\(q\\) and \\(r\\). \\([4]\\)",
    "correct_answer": "p=0.2,\\ q=0.35,\\ r=0.3",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "p", "label": "p", "correct_answer": "0.2", "answer_type": "exact", "tolerance": null },
      { "key": "q", "label": "q", "correct_answer": "0.35", "answer_type": "exact", "tolerance": null },
      { "key": "r", "label": "r", "correct_answer": "0.3", "answer_type": "exact", "tolerance": null }
    ]
  }
]$$::jsonb
);

-- FLAG: Q9(b) compound sample-mean range + assumption — left ungraded per house convention.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251009-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  $$Canteen queue time hypothesis tests$$,
  $$The students in Eunoia Junior College (EJC) have been complaining of long queue times at the canteen during peak hours. It was claimed that the average queue time per student is 20 minutes. It is known that the standard deviation of the queue times is 3.8 minutes. The admin manager of EJC wishes to test if the average queue time is in fact 20 minutes. She examines a random sample of 15 students to determine the average queue time.$$,
  'exact',
  $$\bar{t}=19.3,\ s^{2}=9.48$$,
  NULL,
  $$(a) A sample is random if every student is equally likely to be selected, and the selection of any student is independent of the selection of others. (b) Under \(H_{0}:\mu=20\), \(\bar X\sim N\left(20,\dfrac{3.8^{2}}{15}\right)\); \(H_{0}\) not rejected at the 5% level \(\Leftrightarrow18.1<\bar x<21.9\) (assuming the queue times are normally distributed). (c) \(\bar t=\dfrac{\sum(t-20)}{50}+20=19.3\); \(s^{2}=\dfrac1{49}\left(489-\dfrac{(-35)^{2}}{50}\right)=\dfrac{929}{98}=9.4796=9.48\) (3 s.f.). (d) \(H_0:\mu=20\), \(H_1:\mu<20\). Since \(n=50\) is large, by the Central Limit Theorem \(\bar T\sim N\left(20,\dfrac{9.4796}{50}\right)\) approximately; at the 10% level the critical region is \(\bar t<19.442\); since \(\bar t=19.3<19.442\), reject \(H_0\) and conclude there is sufficient evidence that EuOrder has reduced the queue time.$$,
  11,
  'EJC H2 Math Prelim 2025',
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
    "prompt_latex": "Given that the admin manager concludes that there is no reason to reject the null hypothesis at the 5% level of significance, find the range of possible values of the sample mean, and state an assumption needed for your calculations. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "To reduce the queue time, a lunch pre-order system, EuOrder, was introduced. The admin manager is tasked to find out if there is any improvement to the average queue time per student. She obtained a random sample of 50 students and recorded their queue times, \\(t\\) minutes, on a particular day. The results are summarised as follows: \\[\\sum(t-20)=-35\\qquad\\sum(t-20)^{2}=489.\\] Find unbiased estimates of the population mean and variance. \\([2]\\)",
    "correct_answer": "\\bar{t}=19.3,\\ s^{2}=9.48",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "mean", "label": "\\bar t", "correct_answer": "19.3", "answer_type": "exact", "tolerance": null },
      { "key": "variance", "label": "s^2", "correct_answer": "9.48", "answer_type": "range", "tolerance": 0.0005 }
    ]
  },
  {
    "label": "d",
    "prompt_latex": "Test, at the 10% level of significance, the claim that EuOrder has reduced the average queue time at the canteen. \\([4]\\)",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  '90251010-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  2,
  $$Smoothie mass distributions$$,
  $$In this question you should state the parameters of any distributions you use. A drinks stall specialises in fruit smoothies, which contain apples. The apples used by the stall have masses, in grams, that follow the distribution \(N(100,6^{2})\).$$,
  'exact',
  $$53$$,
  NULL,
  $$Let \(X\sim N(100,6^{2})\). (a) \(P(X\le105)=0.798\) (3 s.f.). (b) Let \(Y\) be the mass of a prepared apple; \(E(Y)=0.7(100)=70\), \(Var(Y)=0.7^{2}(6^{2})=17.64\), \(Y\sim N(70,17.64)\); \(P(Y>78)=0.0284\) (3 s.f.). (c) Let \(T\) be the total mass of a Signature smoothie; \(E(T)=2(70)+130+12(2.5)+50=350\), \(Var(T)=2(17.64)+8^{2}+12(0.6^{2})=103.6\), \(T\sim N(350,103.6)\); \(P(T\ge m)=0.9\Rightarrow m=336.96\approx337\) g. (d) \(P(330<T<360)=0.81236\); \(R\sim B(25,0.81236)\), \(P(R\ge20)=1-P(R\le19)=0.677\) (3 s.f.). (e) Let \(W\) be the total mass of \(n\) blackcurrants and milk; \(E(W)=2.5n+175\), \(Var(W)=0.36n\), \(W\sim N(2.5n+175,0.36n)\); \(P(W>300)\ge0.95\); from the GC, \(n=52\) gives \(0.8761\), \(n=53\) gives \(0.957\), so the least value of \(n=53\).$$,
  14,
  'EJC H2 Math Prelim 2025',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the probability that the mass of a randomly chosen apple is no more than 105 grams. \\([1]\\)",
    "correct_answer": "0.798",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "b",
    "prompt_latex": "Before the apples can be blended, they need to be prepared by peeling them and removing their cores. This preparation process reduces the mass of each apple by 30%. Find the probability that the mass of a randomly chosen apple, after preparation, is more than 78 grams. \\([3]\\)",
    "correct_answer": "0.0284",
    "answer_type": "range",
    "tolerance": 0.0002
  },
  {
    "label": "c",
    "prompt_latex": "The stall sells its Signature smoothie, which uses 2 prepared apples, 1 peeled banana and 12 blackcurrants; all of these are randomly chosen. The stall also adds a fixed 50 grams of milk before blending everything together. You should ignore any changes in mass from the blending process. The masses of peeled bananas, in grams, follow the distribution \\(N(130,8^{2})\\). The masses of blackcurrants, in grams, follow the distribution \\(N(2.5,0.6^{2})\\). 90% of the Signature smoothies have a mass of at least \\(m\\) grams. Find the value of \\(m\\). \\([4]\\)",
    "correct_answer": "337",
    "answer_type": "range",
    "tolerance": 1
  },
  {
    "label": "d",
    "prompt_latex": "A teacher purchases 25 Signature smoothies for her form class. Find the probability that at least 20 of the Signature smoothies have masses between 330 and 360 grams. \\([3]\\)",
    "correct_answer": "0.677",
    "answer_type": "range",
    "tolerance": 0.0005
  },
  {
    "label": "e",
    "prompt_latex": "The stall also makes blackcurrant smoothies using \\(n\\) blackcurrants and a fixed 175 grams of milk. Find the smallest value of \\(n\\) such that the probability of the mass of a blackcurrant smoothie exceeding 300 grams is at least 0.95. \\([3]\\)",
    "correct_answer": "53",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);
