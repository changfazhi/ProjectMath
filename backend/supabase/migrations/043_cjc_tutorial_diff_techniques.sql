-- Migration 043: CJC 2021 JC1 H2 Math Tutorial — Techniques of Differentiation (DISCUSSION only, 10 questions)
-- Source: TUTORIAL/CALCULUS/4.1 Techniques of Differentiation (Teacher).pdf, DISCUSSION section (pp.24-25).
-- REVIEW PROBLEMS and Self-Practice deliberately excluded. Answers verified against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Techniques of Differentiation)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index '7' (calculus file 4.1) + 3-digit Q# -> cc217001..cc21700a. Topic aaaa0012.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- FLAG: the derivative results (Q3-Q6, Q9, and Q2 sub-parts) are algebraic LaTeX forms — exact-match is brittle
--        for products/quotients/surds; enabled per skills.md option 2 with canonical forms.

-- Q1: single numerical answer (GC), 5 s.f.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217001-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  1,
  $$Approximate value of a derivative (GC)$$,
  $$Find the approximate value of the following derivative, correct to 5 significant figures: \[\frac{d}{dx}\,2^{\,3x^2+\sin^2\!\left(e^{x^2}\right)}\Big|_{x=1}.\]$$,
  'range',
  $$12.017$$,
  0.005,
  $$Using the GC to differentiate numerically at \(x=1\): \(\dfrac{d}{dx}\,2^{\,3x^2+\sin^2(e^{x^2})}\big|_{x=1}\approx 12.017\).$$,
  2,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q2: nine derivatives (a)-(i), all graded exact. FLAG: algebraic forms brittle to exact-match.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc217002-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  1,
  $$Derivatives of nine functions$$,
  $$Find the derivatives of the following:$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\dfrac{d}{dx}\dfrac{\pi\sqrt{8100+x^2}}{x}=\dfrac{-8100\pi}{x^2\sqrt{8100+x^2}}\). (b) \(\dfrac{d}{dx}\sec^3(2x)=6\sec^3(2x)\tan(2x)\). (c) \(\dfrac{d}{dx}\sin\sqrt{x^2+1}=\dfrac{x\cos\sqrt{x^2+1}}{\sqrt{x^2+1}}\). (d) \(\dfrac{d}{dx}\log_3\dfrac{x^2-1}{5}=\dfrac{2x}{(x^2-1)\ln 3}\). (e) \(\dfrac{d}{dx}\ln[(x^3+2)(x^2+3)]=\dfrac{3x^2}{x^3+2}+\dfrac{2x}{x^2+3}\). (f) \(\dfrac{d}{dx}x^2 e^{x\sin 2x}=xe^{x\sin 2x}\left(2+x\sin 2x+2x^2\cos 2x\right)\). (g) \(\dfrac{d}{dx}\left(\dfrac{1}{\sin^{-1}3x}\right)^4=\dfrac{-12}{\left(\sin^{-1}3x\right)^5\sqrt{1-9x^2}}\). (h) \(\dfrac{d}{dx}\sin^{-1}(2\sin x)=\dfrac{2\cos x}{\sqrt{1-4\sin^2 x}}\). (i) \(\dfrac{d}{dx}\tan^{-1}\dfrac{1+x}{1-x}=\dfrac{1}{1+x^2}\).$$,
  9,
  'H2 Math Tutorial (Techniques of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "\\(\\dfrac{\\pi\\sqrt{8100+x^2}}{x}\\)",
    "correct_answer": "\\frac{-8100\\pi}{x^2\\sqrt{8100+x^2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "\\(\\sec^3(2x)\\)",
    "correct_answer": "6\\sec^3(2x)\\tan(2x)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "\\(\\sin\\sqrt{x^2+1}\\)",
    "correct_answer": "\\frac{x\\cos\\sqrt{x^2+1}}{\\sqrt{x^2+1}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "d",
    "prompt_latex": "\\(\\log_3\\dfrac{x^2-1}{5}\\)",
    "correct_answer": "\\frac{2x}{(x^2-1)\\ln 3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "e",
    "prompt_latex": "\\(\\ln\\left[(x^3+2)(x^2+3)\\right]\\)",
    "correct_answer": "\\frac{3x^2}{x^3+2}+\\frac{2x}{x^2+3}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "f",
    "prompt_latex": "\\(x^2 e^{x\\sin 2x}\\)",
    "correct_answer": "xe^{x\\sin 2x}\\left(2+x\\sin 2x+2x^2\\cos 2x\\right)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "g",
    "prompt_latex": "\\(\\left(\\dfrac{1}{\\sin^{-1}3x}\\right)^4\\)",
    "correct_answer": "\\frac{-12}{\\left(\\sin^{-1}3x\\right)^5\\sqrt{1-9x^2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "h",
    "prompt_latex": "\\(\\sin^{-1}(2\\sin x)\\)",
    "correct_answer": "\\frac{2\\cos x}{\\sqrt{1-4\\sin^2 x}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "i",
    "prompt_latex": "\\(\\tan^{-1}\\dfrac{1+x}{1-x}\\)",
    "correct_answer": "\\frac{1}{1+x^2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q3: implicit differentiation. FLAG: quotient form brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217003-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Implicit differentiation$$,
  $$A curve has equation \(xy^2+3e^y=4x\). Find \(\dfrac{dy}{dx}\) in terms of \(x\) and \(y\).$$,
  'exact',
  $$\frac{4-y^2}{2xy+3e^y}$$,
  NULL,
  $$Differentiating implicitly: \(y^2+x\cdot 2y\dfrac{dy}{dx}+3e^y\dfrac{dy}{dx}=4\). Hence \(\dfrac{dy}{dx}(2xy+3e^y)=4-y^2\), giving \(\dfrac{dy}{dx}=\dfrac{4-y^2}{2xy+3e^y}\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q4: implicit differentiation. FLAG: form very brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217004-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Implicit differentiation with inverse trig$$,
  $$A curve has equation \(\sin^{-1}y+xe^y=3x\). Find \(\dfrac{dy}{dx}\) in terms of \(x\) and \(y\).$$,
  'exact',
  $$\frac{\left(3-e^y\right)\sqrt{1-y^2}}{1+xe^y\sqrt{1-y^2}}$$,
  NULL,
  $$Differentiating: \(\dfrac{1}{\sqrt{1-y^2}}\dfrac{dy}{dx}+e^y+xe^y\dfrac{dy}{dx}=3\). So \(\dfrac{dy}{dx}\left(\dfrac{1}{\sqrt{1-y^2}}+xe^y\right)=3-e^y\), giving \(\dfrac{dy}{dx}=\dfrac{\left(3-e^y\right)\sqrt{1-y^2}}{1+xe^y\sqrt{1-y^2}}\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q5: logarithmic differentiation. FLAG: form brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217005-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Logarithmic differentiation$$,
  $$Find \(\dfrac{dy}{dx}\) given that \(y=x^{\sqrt{x}}\) where \(x>0\).$$,
  'exact',
  $$x^{\sqrt{x}}\left(\frac{2+\ln x}{2\sqrt{x}}\right)$$,
  NULL,
  $$\(\ln y=\sqrt{x}\ln x\). Differentiating: \(\dfrac{1}{y}\dfrac{dy}{dx}=\dfrac{1}{2\sqrt{x}}\ln x+\sqrt{x}\cdot\dfrac{1}{x}=\dfrac{\ln x}{2\sqrt{x}}+\dfrac{1}{\sqrt{x}}=\dfrac{2+\ln x}{2\sqrt{x}}\). Hence \(\dfrac{dy}{dx}=x^{\sqrt{x}}\left(\dfrac{2+\ln x}{2\sqrt{x}}\right)\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q6: derivative of inverse trig with surd. FLAG: modulus form brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217006-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Derivative of an inverse-trig composite$$,
  $$Find \(\dfrac{d}{dx}\sin^{-1}\sqrt{1-x^2}\).$$,
  'exact',
  $$\frac{-x}{|x|\sqrt{1-x^2}}$$,
  NULL,
  $$Let \(u=\sqrt{1-x^2}\), so \(\dfrac{du}{dx}=\dfrac{-x}{\sqrt{1-x^2}}\). Then \(\dfrac{d}{dx}\sin^{-1}u=\dfrac{1}{\sqrt{1-u^2}}\dfrac{du}{dx}=\dfrac{1}{\sqrt{1-(1-x^2)}}\cdot\dfrac{-x}{\sqrt{1-x^2}}=\dfrac{1}{|x|}\cdot\dfrac{-x}{\sqrt{1-x^2}}=\dfrac{-x}{|x|\sqrt{1-x^2}}\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q7: parametric differentiation, exact value(s) of t. FLAG: two-value answer.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217007-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Parametric gradient$$,
  $$A curve has parametric equations \(x=3t-\dfrac{1}{t}\), \(y=t+\dfrac{4}{3t}\). Find the exact value(s) of \(t\) at the point(s) on the curve at which the gradient is \(\dfrac{1}{6}\).$$,
  'exact',
  $$\pm\sqrt{3}$$,
  NULL,
  $$\(\dfrac{dx}{dt}=3+\dfrac{1}{t^2}\), \(\dfrac{dy}{dt}=1-\dfrac{4}{3t^2}\). So \(\dfrac{dy}{dx}=\dfrac{1-\frac{4}{3t^2}}{3+\frac{1}{t^2}}=\dfrac{3t^2-4}{9t^2+3}\). Setting \(=\dfrac16\): \(6(3t^2-4)=9t^2+3\Rightarrow 18t^2-24=9t^2+3\Rightarrow 9t^2=27\Rightarrow t^2=3\). Hence \(t=\pm\sqrt{3}\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q8: parametric curve, two parts.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc217008-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  2,
  $$Parametric curve and intersection$$,
  $$A curve \(C\) is defined by the parametric equations \(x=\dfrac{1}{\sqrt{1+t^2}}\), \(y=t^3+1\) where \(t\le 0\).$$,
  'exact',
  $$-1$$,
  NULL,
  $$(i) \(\dfrac{dx}{dt}=-t(1+t^2)^{-3/2}\), \(\dfrac{dy}{dt}=3t^2\). So \(\dfrac{dy}{dx}=\dfrac{3t^2}{-t(1+t^2)^{-3/2}}=-3t(1+t^2)^{3/2}\). (ii) At the intersection with \(y=\dfrac{1}{x^2}-2\): note \(\dfrac{1}{x^2}=1+t^2\), so \(t^3+1=(1+t^2)-2=t^2-1\Rightarrow t^3-t^2+2=0\Rightarrow(t+1)(t^2-2t+2)=0\). Since \(t^2-2t+2>0\), \(t=-1\).$$,
  6,
  'H2 Math Tutorial (Techniques of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find \\(\\dfrac{dy}{dx}\\) in terms of \\(t\\).",
    "correct_answer": "-3t(1+t^2)^{\\frac{3}{2}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find the value of \\(t\\) at the point \\(P\\) where curve \\(C\\) cuts another curve \\(y=\\dfrac{1}{x^2}-2\\).",
    "correct_answer": "-1",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q9: differentiate a physics formula. FLAG: quotient form brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc217009-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  3,
  $$Differentiating a gas-law formula$$,
  $$If gas in a cylinder is maintained at a constant temperature \(T\), the pressure \(P\) is related to the volume \(V\) by a formula of the form \(P=\dfrac{nRT}{V-nb}-\dfrac{an^2}{V^2}\), where \(a,b,n\) and \(R\) are constants. Find \(\dfrac{dP}{dV}\).$$,
  'exact',
  $$\frac{2an^2}{V^3}-\frac{nRT}{(V-nb)^2}$$,
  NULL,
  $$\(\dfrac{dP}{dV}=-nRT(V-nb)^{-2}-an^2\cdot(-2)V^{-3}=\dfrac{2an^2}{V^3}-\dfrac{nRT}{(V-nb)^2}\).$$,
  3,
  'H2 Math Tutorial (Techniques of Differentiation)'
);

-- Q10: inverse-tan identity, four parts. (ii)-(iv) ungraded (expression w/ dy/dx, show, explain).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21700a-0000-0000-0000-000000000000',
  'aaaa0012-0000-0000-0000-000000000000',
  3,
  $$Implicit inverse-tangent relation$$,
  $$It is given that \(x\) and \(y\) satisfy the equation \(\tan^{-1}x+\tan^{-1}y+\tan^{-1}(xy)=\dfrac{7}{12}\pi\).$$,
  'exact',
  $$\frac{1}{\sqrt{3}}$$,
  NULL,
  $$(i) When \(x=1\): \(\dfrac{\pi}{4}+2\tan^{-1}y=\dfrac{7\pi}{12}\Rightarrow\tan^{-1}y=\dfrac{\pi}{6}\Rightarrow y=\dfrac{1}{\sqrt{3}}\). (ii) \(\dfrac{d}{dx}\tan^{-1}(xy)=\dfrac{1}{1+(xy)^2}\left(x\dfrac{dy}{dx}+y\right)\). (iii) Differentiating the whole relation: \(\dfrac{1}{1+x^2}+\dfrac{1}{1+y^2}\dfrac{dy}{dx}+\dfrac{1}{1+(xy)^2}\left(x\dfrac{dy}{dx}+y\right)=0\). At \(x=1,\ y=\tfrac{1}{\sqrt3}\): \(1+(xy)^2=\tfrac43\), \(1+y^2=\tfrac43\), giving \(\dfrac{1}{2}+\dfrac{3}{4}\dfrac{dy}{dx}+\dfrac{3}{4}\left(\dfrac{dy}{dx}+\dfrac{1}{\sqrt3}\right)=0\Rightarrow\dfrac{dy}{dx}=-\dfrac{1}{3}-\dfrac{1}{2\sqrt3}\). (iv) Parts (i)-(iii) evaluate \(y\) and \(\dfrac{dy}{dx}\) at the specific point \(x=1\); (i) supplies the coordinates used in (iii), and (ii) supplies the term needed to differentiate the \(\tan^{-1}(xy)\) piece.$$,
  8,
  'H2 Math Tutorial (Techniques of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the value of \\(y\\) when \\(x=1\\).",
    "correct_answer": "\\frac{1}{\\sqrt{3}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Express \\(\\dfrac{d}{dx}\\tan^{-1}(xy)\\) in terms of \\(x\\), \\(y\\) and \\(\\dfrac{dy}{dx}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Show that when \\(x=1\\), \\(\\dfrac{dy}{dx}=-\\dfrac{1}{3}-\\dfrac{1}{2\\sqrt{3}}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "Explain how parts (i), (ii) and (iii) are related.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);
