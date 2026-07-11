-- Migration 034: CJC 2021 JC1 H2 Math Tutorial — Parametric Equations (DISCUSSION only, 2 questions)
-- Source: TUTORIAL/FUNCTIONS AND GRAPHS/6. 2021 Parametric Equations (Teacher).pdf, DISCUSSION section.
-- REVIEW PROBLEMS deliberately excluded. Answers verified against the tutorial answer key + solution PDF.
-- Question IDs: prefix 'cc21' (CJC 2021 tutorial), number = <topic-index 6><3-digit Q#> → cc216001, cc216002.
-- No DDL: parts JSONB (008) and attempts.part_label already exist.
-- Sketch model graphs are DEFERRED to a later migration (per plan) — each (i)–(viii) sketch part will get a
-- solution_graph then. This migration only lands the questions + gradable cartesian-equation boxes.

-- FLAG: Q1(i),(ii),(iii),(v) answers are implicit cartesian EQUATIONS (with '='), and Q2 likewise —
--       exact-match is brittle for equation forms (ordering/rearrangement). (iv),(vi),(vii),(viii) are y=f(x), clean.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc216001-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  2,
  $$Parametric curves: sketch & cartesian equations$$,
  $$Sketch the curves of the following equations, labelling the coordinates of the axial intercepts. Then, find the cartesian equations of the curves.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(x=\cos\theta,\ y=2\sin\theta\): \(\cos^2\theta+\sin^2\theta=1\Rightarrow x^2+\frac{y^2}{4}=1\), with \(0\le x\le 1\) (right half of the ellipse). (ii) \(\sec^2 t-\tan^2 t=1\Rightarrow \frac{x^2}{4}-y^2=1\). (iii) \(y=\sin 2t=2\sin t\cos t\); with \(x=\cos t\), \(y^2=4x^2(1-x^2)\Rightarrow x^2-\frac{y^2}{4}=x^4\). (iv) \(\cot\theta=\frac{x}{2},\ \sin^2\theta=\frac{y}{2}\); \(1+\cot^2\theta=\csc^2\theta\Rightarrow 1+\frac{x^2}{4}=\frac{2}{y}\Rightarrow y=\frac{8}{x^2+4}\). (v) \(x^{2/3}=\cos^2\theta,\ y^{2/3}=\sin^2\theta\Rightarrow x^{2/3}+y^{2/3}=1\) (astroid). (vi) \(t=\frac{x}{2}\Rightarrow y=\frac{x^2}{4}-1\), \(-4\le x\le 10\). (vii) \(y=e^{3t}=(e^t)^3=x^3\), \(e^{-0.5}\le x\le e^{0.5}\). (viii) \(t=\sqrt{x^2-4}\Rightarrow y=\ln\sqrt{x^2-4}\), \(x>2\).$$,
  8,
  'H2 Math Tutorial (Parametric Equations)',
  $$[
  {
    "label": "i",
    "prompt_latex": "\\(x=\\cos\\theta,\\ y=2\\sin\\theta,\\ -\\frac{\\pi}{2}\\le\\theta\\le\\frac{\\pi}{2}\\)",
    "correct_answer": "x^2+\\frac{y^2}{4}=1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "\\(x=2\\sec t,\\ y=\\tan t,\\ 0\\le t\\le 2\\pi\\)",
    "correct_answer": "\\frac{x^2}{4}-y^2=1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "\\(x=\\cos t,\\ y=\\sin 2t,\\ 0\\le t\\le 2\\pi\\)",
    "correct_answer": "x^2-\\frac{y^2}{4}=x^4",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "\\(x=2\\cot\\theta,\\ y=2\\sin^2\\theta,\\ 0\\le\\theta\\le 2\\pi\\)",
    "correct_answer": "\\frac{8}{x^2+4}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "v",
    "prompt_latex": "\\(x=\\cos^3\\theta,\\ y=\\sin^3\\theta,\\ 0\\le\\theta\\le 2\\pi\\)",
    "correct_answer": "x^{\\frac{2}{3}}+y^{\\frac{2}{3}}=1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "vi",
    "prompt_latex": "\\(x=2t,\\ y=t^2-1,\\ -2\\le t\\le 5\\)",
    "correct_answer": "\\frac{x^2}{4}-1",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "vii",
    "prompt_latex": "\\(x=e^{t},\\ y=e^{3t},\\ -0.5\\le t\\le 0.5\\)",
    "correct_answer": "x^3",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "viii",
    "prompt_latex": "\\(x=\\sqrt{t^2+4},\\ y=\\ln t,\\ t>0\\)",
    "correct_answer": "\\ln\\sqrt{x^2-4}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- FLAG: Q2 answer is a cartesian EQUATION (implicit, '=0' form) — exact-match brittle.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc216002-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  2,
  $$Cartesian equation from parametric form$$,
  $$Find the cartesian equation of the curve with parametric equations \(x=-4t-\dfrac{1}{t},\ y=3t+\dfrac{1}{2t}\), where \(t\in\mathbb{R},\ t\neq 0\).$$,
  'exact',
  $$3x^2+10xy+8y^2+2=0$$,
  NULL,
  $$Let \(u=t\) and \(v=\dfrac{1}{t}\), so \(uv=1\). Then \(x=-4u-v\) and \(y=3u+\tfrac12 v\). Solving the linear system: \(u=y+\tfrac12 x\) and \(v=-3x-4y\). Substituting into \(uv=1\): \(\left(y+\tfrac12 x\right)(-3x-4y)=1\Rightarrow -\tfrac32 x^2-5xy-4y^2=1\). Multiplying by \(-2\): \(3x^2+10xy+8y^2+2=0\).$$,
  3,
  'H2 Math Tutorial (Parametric Equations)'
);
