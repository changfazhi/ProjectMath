-- Migration 048: CJC 2022 JC2 H2 Math Tutorial — Differential Equations (DISCUSSION only, 10 questions)
-- Source: TUTORIAL/CALCULUS/4.6 Differential Equations Lecture Notes + solution.pdf, DISCUSSION section (pp.20-22).
-- REVIEW PROBLEMS + Self-Practice excluded. Answers verified against the tutorial answer key (p.22).
-- Provenance stripped: source 'H2 Math Tutorial (Differential Equations)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'c' (file 4.6) + 3-digit Q# -> cc21c001..cc21c00a. Topic aaaa0018.
-- Sketch parts (Q1(b), Q2(b), Q7(iii), Q8(iii), Q9(c)) are concrete curves -> solution_graph deferred.
-- GRADING POLICY: general solutions with arbitrary constants are left UNGRADED (null, brittle) and revealed;
--   D.E. right-hand sides and clean particular values are graded. FLAG: brittle algebraic/interval forms.

-- Q1: 2nd-order direct integration. (a) general solution null; (b) sketch particular curve (graph deferred).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c001-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  1,
  $$Second-order direct integration$$,
  $$Consider the differential equation \(\dfrac{d^2y}{dx^2}=10-6x\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$Integrating twice: \(\dfrac{dy}{dx}=10x-3x^2+A\), then \(y=5x^2-x^3+Ax+B\) (general solution). Given \(\dfrac{dy}{dx}=0\) and \(y=100\) at \(x=0\): \(A=0\) and \(B=100\), so the particular curve is \(y=5x^2-x^3+100\), which has a stationary point at the origin's shift and a point of inflexion; it rises then falls for large \(x\).$$,
  4,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the general solution of the differential equation, expressing \\(y\\) in terms of \\(x\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Given that \\(\\dfrac{dy}{dx}=0\\) and \\(y=100\\) when \\(x=0\\), sketch this curve.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q2: separable, general solution + sketch. (graph deferred)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c002-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  1,
  $$Separable equation and curve sketch$$,
  $$Consider the differential equation \(\dfrac{dy}{dx}=(1-y)^2\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$Separating: \(\displaystyle\int\dfrac{dy}{(1-y)^2}=\int dx\Rightarrow\dfrac{1}{1-y}=x+C\Rightarrow y=1-\dfrac{1}{x+C}\) (general solution). With \(y=0\) at \(x=0\): \(C=1\), so \(y=1-\dfrac{1}{x+1}\). This curve has a vertical asymptote \(x=-1\) and horizontal asymptote \(y=1\), passing through the origin.$$,
  4,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the general solution of the differential equation, expressing \\(y\\) in terms of \\(x\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Sketch the curve for which \\(y=0\\) when \\(x=0\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q3: (a) show; (b) particular solution FLAG.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c003-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Particular solution of a second-order equation$$,
  $$Consider \(\dfrac{d}{dx}\left(\dfrac{y}{\sqrt{1-x}}\right)=\dfrac{1}{\sqrt{1-x}}\cdot\dfrac{dy}{dx}+\dfrac{1}{2}y(1-x)^{-3/2}\).$$,
  'exact',
  $$e^{-2\sqrt{1-x}+2}$$,
  NULL,
  $$Recognising the left side, the equation \(\dfrac{d^2y}{dx^2}=\dfrac{1}{\sqrt{1-x}}\dfrac{dy}{dx}+\dfrac12 y(1-x)^{-3/2}\) becomes \(\dfrac{d}{dx}\left(\dfrac{y}{\sqrt{1-x}}\right)=\dfrac{dy}{dx}\cdot\dfrac{1}{\sqrt{1-x}}+\cdots\). Writing \(u=\dfrac{y}{\sqrt{1-x}}\) leads to \(\dfrac{du}{dx}=\dfrac{u}{\sqrt{1-x}}\), so \(\ln u=-2\sqrt{1-x}+c\). The tangent at \((0,1)\) parallel to \(y=x\) gives \(\dfrac{dy}{dx}=1\) there, fixing the constants; hence \(y=e^{-2\sqrt{1-x}+2}\).$$,
  6,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{d}{dx}\\left(\\dfrac{y}{\\sqrt{1-x}}\\right)=\\dfrac{1}{\\sqrt{1-x}}\\cdot\\dfrac{dy}{dx}+\\dfrac{1}{2}y(1-x)^{-3/2}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence find the particular solution of \\(\\dfrac{d^2y}{dx^2}=\\dfrac{1}{\\sqrt{1-x}}\\cdot\\dfrac{dy}{dx}+\\dfrac{1}{2}y(1-x)^{-3/2}\\), given that its tangent at \\((0,1)\\) is parallel to the line \\(y=x\\).",
    "correct_answer": "e^{-2\\sqrt{1-x}+2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q4: substitution reduction, all "show" -> ungraded (null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c004-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Reducing an equation by substitution$$,
  $$Consider the differential equation \(x^2\dfrac{dy}{dx}-2xy+y^2=0\), where \(x>0\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$With \(y=ux^2\): \(\dfrac{dy}{dx}=u'x^2+2ux\). Substituting, \(x^2(u'x^2+2ux)-2x(ux^2)+u^2x^4=0\Rightarrow x^4 u'+u^2x^4=0\Rightarrow\dfrac{du}{dx}+u^2=0\) (shown). Then \(\displaystyle\int\dfrac{du}{u^2}=-\int dx\Rightarrow-\dfrac{1}{u}=-x-C\Rightarrow u=\dfrac{1}{x+C}\), so \(y=ux^2=\dfrac{x^2}{C+x}\) (shown).$$,
  6,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that, by using the substitution \\(y=ux^2\\), the differential equation may be reduced to the form \\(\\dfrac{du}{dx}+u^2=0\\). Hence show that the general solution may be expressed as \\(y=\\dfrac{x^2}{C+x}\\), where \\(C\\) is an arbitrary constant.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q5: (i) obtain reduced D.E. (graded RHS); (ii) show general solution (null).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c005-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Substitution then direct integration$$,
  $$The variables \(x\) and \(y\) are related by \(xe^y\dfrac{dy}{dx}+e^y=2x\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) With \(z=xe^y\), \(\dfrac{dz}{dx}=e^y+xe^y\dfrac{dy}{dx}\), which is exactly the left side, so \(\dfrac{dz}{dx}=2x\). (ii) Integrating, \(z=x^2+k\Rightarrow xe^y=x^2+k\Rightarrow e^y=x+\dfrac{k}{x}\Rightarrow y=\ln\left(x+\dfrac{k}{x}\right)\) (shown).$$,
  6,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "By means of the substitution \\(z=xe^y\\), obtain a differential equation relating \\(z\\) and \\(x\\), giving \\(\\dfrac{dz}{dx}\\) in terms of \\(x\\).",
    "correct_answer": "2x",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Hence, or otherwise, show that the general solution is \\(y=\\ln\\left(x+\\dfrac{k}{x}\\right)\\) where \\(k\\) is an arbitrary constant.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q6: formulate differential equations from context (do not solve). (a),(b) FLAG RHS; (c) show null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c006-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  2,
  $$Formulating differential equations from context$$,
  $$For each of the following parts, formulate a differential equation (D.E.) based on the context. There is no need to solve the D.E.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) The number of trees \(x\) increases at \(\dfrac{x-k}{t}\) and by \(1000\) planted per year, and decreases at \(\dfrac{5000}{t+5}\): \(\dfrac{dx}{dt}=\dfrac{x-k}{t}+1000-\dfrac{5000}{t+5}\). (b) Rate of increase \(\propto P\) and rate of decrease is constant \(m\): \(\dfrac{dP}{dt}=kP-m\) with \(k,m>0\). (c) Growth rate \(\propto\) length and loss rate \(\propto\) (length)\(^2\): \(\dfrac{dx}{dt}=k_1 x-k_2 x^2\); since the leaf stops growing (constant) at \(x=6\), \(\dfrac{dx}{dt}=0\) there gives \(k_1=6k_2\), so \(\dfrac{dx}{dt}=k x(6-x)\) (shown).$$,
  6,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "The number of trees in a forest after \\(t\\) years is \\(x\\). The number increases at a rate of \\(\\dfrac{x-k}{t}\\) per year (where \\(k\\) is the initial number of trees), trees are chopped off at a rate of \\(\\dfrac{5000}{t+5}\\) per year, and \\(1000\\) new trees are planted every year. Write down a differential equation \\(\\dfrac{dx}{dt}=\\ldots\\) to model the population.",
    "correct_answer": "\\frac{x-k}{t}+1000-\\frac{5000}{t+5}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "The rate of increase of a population of size \\(P\\) after \\(t\\) years is proportional to the population size, and the rate of decrease is a constant \\(m\\). Set up a differential equation \\(\\dfrac{dP}{dt}=\\ldots\\) for the population \\(P\\).",
    "correct_answer": "kP-m",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The length \\(x\\) cm of a bamboo leaf increases at a rate proportional to its length and decreases at a rate proportional to the square of its length. The leaf is \\(1\\) cm when it sprouts and stops growing at \\(6\\) cm. Show that \\(\\dfrac{dx}{dt}=kx(6-x)\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q7 (ADVANCED): (i) write D.E. (graded); (ii) show; (iii) sketch (graph deferred); (iv) explain.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c007-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Exponential growth of a heated rod$$,
  $$When a metal rod is heated, its length \(L\) increases at a rate proportional to \(L\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\dfrac{dL}{dt}=kL\). (ii) Separating, \(\ln L=kt+c\Rightarrow L=Ae^{kt}\) (shown). (iii) With \(L(0)=50\), \(L=50e^{kt}\) (\(k>0\)): an increasing exponential curve through \((0,50)\). (iv) The model predicts \(L\to\infty\) as \(t\to\infty\), i.e. unbounded expansion, which is not physically appropriate — a real rod's expansion tends to a finite limit as the temperature stabilises.$$,
  7,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Write down a differential equation which expresses \\(\\dfrac{dL}{dt}\\) in terms of \\(L\\).",
    "correct_answer": "kL",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Show that the general solution of the differential equation is of the form \\(L=Ae^{kt}\\), where \\(A\\) and \\(k\\) are constants.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "The rod has an initial length of \\(50\\) cm. Sketch the graph of \\(L\\) against \\(t\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "Explain why the differential equation in part (i) does not appropriately describe the expansion of the rod when it is heated.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q8 (ADVANCED): logistic fish population. (i) range FLAG; (ii) show; (iii) large-t + sketch (graph deferred).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c008-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Logistic model for a fish population$$,
  $$A population of fish is modelled by the differential equation \(\dfrac{dP}{dt}=0.02P(100-P)\), where \(P\) is the size of the population at time \(t\) (in weeks). Initially, \(P=20\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) The population is strictly increasing when \(\dfrac{dP}{dt}>0\), i.e. \(0<P<100\). (ii) Separating and using partial fractions \(\dfrac{1}{P(100-P)}=\dfrac{1}{100}\left(\dfrac1P+\dfrac{1}{100-P}\right)\) with \(P(0)=20\) gives \(P=\dfrac{100}{1+4e^{-2t}}\) (shown). (iii) As \(t\to\infty\), \(e^{-2t}\to0\) so \(P\to100\): the population approaches the carrying capacity \(100\). The graph is an increasing logistic (S-shaped) curve from \((0,20)\) with horizontal asymptote \(P=100\).$$,
  8,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the range of values of \\(P\\) for which the population is strictly increasing.",
    "correct_answer": "0<P<100",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Given that initially \\(P=20\\), show that \\(P=\\dfrac{100}{1+4e^{-2t}}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "What happens to \\(P\\) for large values of \\(t\\)? Sketch the graph of \\(P\\) against \\(t\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q9 (ADVANCED): Newton's law of cooling. (a) show; (b) time (range); (c) large-t + sketch (graph deferred).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c009-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Newton's law of warming$$,
  $$A bottle containing liquid is taken from a refrigerator and placed in a room where the temperature is a constant \(20^\circ\text{C}\). As the liquid warms up, the rate of increase of its temperature \(\theta\,^\circ\text{C}\) after time \(t\) minutes is proportional to the temperature difference \((20-\theta)\,^\circ\text{C}\). Initially the temperature of the liquid is \(10^\circ\text{C}\) and the rate of increase of the temperature is \(1^\circ\text{C}\) per minute.$$,
  'exact',
  $$6.93$$,
  NULL,
  $$(a) \(\dfrac{d\theta}{dt}=k(20-\theta)\); at \(t=0\), \(\theta=10\) and \(\dfrac{d\theta}{dt}=1\Rightarrow k=\dfrac{1}{10}\). Solving with \(\theta(0)=10\) gives \(\theta=20-10e^{-t/10}\) (shown). (b) \(15=20-10e^{-t/10}\Rightarrow e^{-t/10}=\dfrac12\Rightarrow t=10\ln2\approx6.93\) min. (c) As \(t\to\infty\), \(\theta\to20\): the temperature approaches room temperature. The graph rises from \((0,10)\) toward the horizontal asymptote \(\theta=20\).$$,
  8,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "a",
    "prompt_latex": "By setting up and solving a differential equation, show that \\(\\theta=20-10e^{-\\frac{1}{10}t}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Find the time it takes the liquid to reach a temperature of \\(15^\\circ\\text{C}\\), giving your answer in minutes correct to 3 significant figures.",
    "correct_answer": "6.93",
    "answer_type": "range",
    "tolerance": 0.005
  },
  {
    "label": "c",
    "prompt_latex": "State what happens to \\(\\theta\\) for large values of \\(t\\), and sketch a graph of \\(\\theta\\) against \\(t\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q10 (ADVANCED): salt-tank mixing. (i) show; (ii) amount after 1 hour (range, nearest gram).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21c00a-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  $$Salt-tank mixing problem$$,
  $$Salt is dissolved in a tank filled with \(120\) litres of water. Salt water containing \(20\) g of salt per litre is poured in at a constant rate of \(3\) litres per minute, and the mixture flows out at a constant rate of \(3\) litres per minute. The contents are kept well mixed at all times. Let the amount of salt in the tank (in grams) be \(S\) and the time (in minutes) be \(t\).$$,
  'exact',
  $$1954$$,
  NULL,
  $$(i) Rate in \(=20\times3=60\) g/min; rate out \(=\dfrac{S}{120}\times3=\dfrac{S}{40}\) g/min. So \(\dfrac{dS}{dt}=60-\dfrac{S}{40}=\dfrac{1}{40}(2400-S)\) (shown). (ii) Solving with \(S(0)=400\): \(S=2400-2000e^{-t/40}\). At \(t=60\): \(S=2400-2000e^{-1.5}\approx2400-446.3=1953.7\approx1954\) g.$$,
  7,
  'H2 Math Tutorial (Differential Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(\\dfrac{dS}{dt}=\\dfrac{1}{40}(2400-S)\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Given that \\(400\\) g of salt was dissolved in the tank initially, find the amount of salt in the tank after 1 hour, giving your answer to the nearest gram.",
    "correct_answer": "1954",
    "answer_type": "range",
    "tolerance": 1
  }
]$$::jsonb
);
