-- Migration 046: CJC 2021 JC1 H2 Math Tutorial — Techniques of Integration (DISCUSSION only, 11 questions)
-- Source: TUTORIAL/CALCULUS/4.4 Techniques of Integration (Teacher).pdf, DISCUSSION section (pp.36-38);
--         final antiderivatives verified against TUTORIAL/CALCULUS SOLUTIONS/4.4 ... Solution.pdf.
-- REVIEW PROBLEMS + Self-Practice excluded.
-- EXCLUDED per user request (sum-to/product-to-sum trig): Q2(l)  ∫ cos 4θ sin 2θ dθ  is omitted from Q2's parts.
-- Provenance stripped: source 'H2 Math Tutorial (Techniques of Integration)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index 'a' (calculus file 4.4) + 3-digit Q# -> cc21a001..cc21a00b. Topic aaaa0015.
-- GRADING POLICY: indefinite integrals are left UNGRADED (null parts) per house convention (+C and many
--   equivalent forms make exact-match unreliable, CLAUDE.md); the worked antiderivative is revealed in
--   solution_latex. Only the derivative sub-parts (Q1(a), Q10(i), Q11(i)) are graded (FLAG: algebraic form).

-- Q1: derivative + deduced integral.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a001-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  1,
  $$Integration as anti-differentiation$$,
  $$Consider \(\dfrac{x^3}{1+x^4}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) By the quotient rule, \(\dfrac{d}{dx}\dfrac{x^3}{1+x^4}=\dfrac{3x^2(1+x^4)-x^3(4x^3)}{(1+x^4)^2}=\dfrac{x^2(3-x^4)}{(1+x^4)^2}\). (b) Hence \(\displaystyle\int\dfrac{4x^2(3-x^4)}{(1+x^4)^2}\,dx=4\int\dfrac{x^2(3-x^4)}{(1+x^4)^2}\,dx=\dfrac{4x^3}{1+x^4}+C\).$$,
  4,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find \\(\\dfrac{d}{dx}\\left(\\dfrac{x^3}{1+x^4}\\right)\\).",
    "correct_answer": "\\frac{x^2(3-x^4)}{(1+x^4)^2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Deduce \\(\\displaystyle\\int\\dfrac{4x^2(3-x^4)}{(1+x^4)^2}\\,dx\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q2: 13 basic integrals (a)-(n) EXCLUDING (l). All indefinite -> ungraded (null); answers in solution.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a002-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  1,
  $$Basic integration techniques$$,
  $$Find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int\sqrt{x}(x+3)\,dx=\dfrac{2}{5}x^{5/2}+2x^{3/2}+C\). (b) \(\displaystyle\int\left(\sqrt{y}+\dfrac{1}{\sqrt{y}}\right)^2 dy=\dfrac{y^2}{2}+2y+\ln|y|+C\). (c) \(\displaystyle\int\dfrac{x+1}{x^2+2x+3}\,dx=\dfrac{1}{2}\ln|x^2+2x+3|+C\). (d) \(\displaystyle\int\dfrac{3t}{1-t}\,dt=-3t-3\ln|1-t|+C\). (e) \(\displaystyle\int\dfrac{1}{x\ln x}\,dx=\ln|\ln x|+C\). (f) \(\displaystyle\int\dfrac{e^x}{1+e^x}\,dx=\ln(1+e^x)+C\). (g) \(\displaystyle\int\dfrac{e^{\sqrt{x}}}{\sqrt{x}}\,dx=2e^{\sqrt{x}}+C\). (h) \(\displaystyle\int\sin^2\dfrac{x}{2}\,dx=\dfrac{1}{2}x-\dfrac{1}{2}\sin x+C\). (i) \(\displaystyle\int 2021^{2021x}\,dx=\dfrac{2021^{2021x}}{2021\ln 2021}+C\). (j) \(\displaystyle\int\dfrac{\sin y}{1+2\cos y}\,dy=-\dfrac{1}{2}\ln|1+2\cos y|+C\). (k) \(\displaystyle\int\tan^2 2t\,dt=\dfrac{1}{2}\tan 2t-t+C\). (m) \(\displaystyle\int\dfrac{1}{1-\cos 2x}\,dx=-\dfrac{1}{2}\cot x+C\). (n) \(\displaystyle\int\dfrac{\cos(\ln x)}{x}\,dx=\sin(\ln x)+C\).$$,
  13,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int\\sqrt{x}(x+3)\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\left(\\sqrt{y}+\\dfrac{1}{\\sqrt{y}}\\right)^2 dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{x+1}{x^2+2x+3}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{3t}{1-t}\\,dt\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{x\\ln x}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "f", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{e^x}{1+e^x}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "g", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{e^{\\sqrt{x}}}{\\sqrt{x}}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "h", "prompt_latex": "\\(\\displaystyle\\int\\sin^2\\dfrac{x}{2}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "i", "prompt_latex": "\\(\\displaystyle\\int 2021^{2021x}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "j", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{\\sin y}{1+2\\cos y}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "k", "prompt_latex": "\\(\\displaystyle\\int\\tan^2 2t\\,dt\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "m", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{1-\\cos 2x}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "n", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{\\cos(\\ln x)}{x}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q3: derive identity then find ∫sec^4 x dx. Show + indefinite integral -> ungraded (one null part).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a003-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  1,
  $$Integrating sec to the fourth power$$,
  $$Consider \(\dfrac{d}{dx}\left(\tan^3 x\right)\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(\dfrac{d}{dx}\tan^3 x=3\tan^2 x\sec^2 x=3(\sec^2 x-1)\sec^2 x=3\sec^4 x-3\sec^2 x\) (shown). Hence \(\displaystyle\int\sec^4 x\,dx=\dfrac{1}{3}\int\left(\dfrac{d}{dx}\tan^3 x+3\sec^2 x\right)dx=\dfrac{1}{3}\tan^3 x+\tan x+C\).$$,
  3,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{d}{dx}\\left(\\tan^3 x\\right)=3\\sec^4 x-3\\sec^2 x\\). Hence find \\(\\displaystyle\\int\\sec^4 x\\,dx\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q4: eight standard-form integrals (a)-(h). All indefinite -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a004-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Standard-form integrals (completing the square)$$,
  $$Find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int\dfrac{1}{2-9x^2}\,dx=\dfrac{1}{6\sqrt{2}}\ln\left|\dfrac{\sqrt{2}+3x}{\sqrt{2}-3x}\right|+C\). (b) \(\displaystyle\int\dfrac{1}{2x^2+3x+10}\,dx=\dfrac{2}{\sqrt{71}}\tan^{-1}\dfrac{4x+3}{\sqrt{71}}+C\). (c) \(\displaystyle\int\dfrac{1}{y^2-4y-13}\,dy=\dfrac{1}{2\sqrt{17}}\ln\left|\dfrac{y-2-\sqrt{17}}{y-2+\sqrt{17}}\right|+C\). (d) \(\displaystyle\int\dfrac{1}{\sqrt{5-4y-y^2}}\,dy=\sin^{-1}\dfrac{y+2}{3}+C\). (e) \(\displaystyle\int\dfrac{1}{x^2+4x+20}\,dx=\dfrac{1}{4}\tan^{-1}\dfrac{x+2}{4}+C\). (f) \(\displaystyle\int\dfrac{1}{\sqrt{25-9x^2}}\,dx=\dfrac{1}{3}\sin^{-1}\dfrac{3x}{5}+C\). (g) \(\displaystyle\int\dfrac{1}{6+4y-y^2}\,dy=\dfrac{1}{2\sqrt{10}}\ln\left|\dfrac{\sqrt{10}+y-2}{\sqrt{10}-y+2}\right|+C\). (h) \(\displaystyle\int\dfrac{1}{2y^2-4y-1}\,dy=\dfrac{\sqrt{6}}{12}\ln\left|\dfrac{\sqrt{2}y-\sqrt{2}-\sqrt{3}}{\sqrt{2}y-\sqrt{2}+\sqrt{3}}\right|+C\).$$,
  8,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{2-9x^2}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{2x^2+3x+10}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{y^2-4y-13}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{\\sqrt{5-4y-y^2}}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{x^2+4x+20}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "f", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{\\sqrt{25-9x^2}}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "g", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{6+4y-y^2}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "h", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{2y^2-4y-1}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q5: six partial-fraction integrals (a)-(f). All indefinite -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a005-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Integration using partial fractions$$,
  $$Find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int\dfrac{x}{x^2-2x-3}\,dx=\dfrac{3}{4}\ln|x-3|+\dfrac{1}{4}\ln|x+1|+C\). (b) \(\displaystyle\int\dfrac{1}{y^2(y-2)}\,dy=\dfrac{1}{2y}+\dfrac{1}{4}\ln\left|\dfrac{y-2}{y}\right|+C\). (c) \(\displaystyle\int\dfrac{3x^2+3x-2}{(1-x)(1+3x^2)}\,dx=-\ln|1-x|-\sqrt{3}\tan^{-1}(\sqrt{3}x)+C\). (d) \(\displaystyle\int\dfrac{16x+5}{4x^2+2x+1}\,dx=2\ln|4x^2+2x+1|+\dfrac{1}{\sqrt{3}}\tan^{-1}\dfrac{4x+1}{\sqrt{3}}+C\). (e) \(\displaystyle\int\dfrac{4+s}{2s^2+2s+3}\,ds=\dfrac{1}{4}\ln|2s^2+2s+3|+\dfrac{7}{2\sqrt{5}}\tan^{-1}\dfrac{2s+1}{\sqrt{5}}+C\). (f) \(\displaystyle\int\dfrac{2x-1}{x^2+4x+5}\,dx=\ln|x^2+4x+5|-5\tan^{-1}(x+2)+C\).$$,
  6,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{x}{x^2-2x-3}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{y^2(y-2)}\\,dy\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{3x^2+3x-2}{(1-x)(1+3x^2)}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{16x+5}{4x^2+2x+1}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{4+s}{2s^2+2s+3}\\,ds\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "f", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{2x-1}{x^2+4x+5}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q6: six integrals by given substitution (a)-(f). All indefinite -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a006-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Integration by substitution$$,
  $$Use the given substitutions to find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int\dfrac{1}{e^x+e^{-x}}\,dx=\tan^{-1}(e^x)+C\) (let \(u=e^x\)). (b) \(\displaystyle\int\dfrac{x+1}{(2x-1)^2}\,dx=\dfrac{1}{4}\ln|2x-1|-\dfrac{3}{4(2x-1)}+C\) (let \(u=2x-1\)). (c) \(\displaystyle\int\dfrac{1}{2+\sqrt{x}}\,dx=2\sqrt{x}-4\ln|2+\sqrt{x}|+C\) (let \(u=\sqrt{x}\)). (d) \(\displaystyle\int\sin^3 x\,dx=\dfrac{\cos^3 x}{3}-\cos x+C\) (let \(u=\cos x\)). (e) \(\displaystyle\int\dfrac{x}{\sqrt{1-x^2}}\,dx=-\sqrt{1-x^2}+C\) (let \(x=\sin\theta\)). (f) \(\displaystyle\int\dfrac{1}{(x^2+1)^2}\,dx=\dfrac{x}{2(1+x^2)}+\dfrac{1}{2}\tan^{-1}x+C\) (let \(x=\tan\theta\)).$$,
  6,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{e^x+e^{-x}}\\,dx\\), \\ let \\(u=e^x\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{x+1}{(2x-1)^2}\\,dx\\), \\ let \\(u=2x-1\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{2+\\sqrt{x}}\\,dx\\), \\ let \\(u=\\sqrt{x}\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int\\sin^3 x\\,dx\\), \\ let \\(u=\\cos x\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{x}{\\sqrt{1-x^2}}\\,dx\\), \\ let \\(x=\\sin\\theta\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "f", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{(x^2+1)^2}\\,dx\\), \\ let \\(x=\\tan\\theta\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q7: six integration-by-parts integrals (a)-(f). All indefinite -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a007-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Integration by parts$$,
  $$Find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int x^2\ln x\,dx=\dfrac{x^3}{3}\ln x-\dfrac{x^3}{9}+C\). (b) \(\displaystyle\int\ln(x^2+1)\,dx=x\ln(x^2+1)-2x+2\tan^{-1}x+C\). (c) \(\displaystyle\int x\tan^{-1}(x^2)\,dx=\dfrac{x^2}{2}\tan^{-1}(x^2)-\dfrac{1}{4}\ln(1+x^4)+C\). (d) \(\displaystyle\int x^2 e^x\,dx=x^2 e^x-2xe^x+2e^x+C\). (e) \(\displaystyle\int e^x\cos x\,dx=\dfrac{1}{2}e^x\cos x+\dfrac{1}{2}e^x\sin x+C\). (f) \(\displaystyle\int\theta\sin\theta\cos\theta\,d\theta=-\dfrac{\theta\cos 2\theta}{4}+\dfrac{1}{8}\sin 2\theta+C\) (using \(\sin\theta\cos\theta=\tfrac12\sin 2\theta\)).$$,
  6,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int x^2\\ln x\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\ln(x^2+1)\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int x\\tan^{-1}(x^2)\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int x^2 e^x\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "e", "prompt_latex": "\\(\\displaystyle\\int e^x\\cos x\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "f", "prompt_latex": "\\(\\displaystyle\\int\\theta\\sin\\theta\\cos\\theta\\,d\\theta\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q8: mixed integrals (a)-(d). All indefinite -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a008-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  2,
  $$Mixed integration techniques$$,
  $$Find the following integrals:$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) \(\displaystyle\int\dfrac{e^{2x}}{e^{2x}-3}\,dx=\dfrac{1}{2}\ln|e^{2x}-3|+C\). (b) \(\displaystyle\int\dfrac{3x^2+2}{\sqrt{x^3+2x-8}}\,dx=2\sqrt{x^3+2x-8}+C\). (c) \(\displaystyle\int\dfrac{1}{x^2+2x+5}\,dx=\dfrac{1}{2}\tan^{-1}\dfrac{x+1}{2}+C\). (d) \(\displaystyle\int x^2\ln x\,dx=\dfrac{x^3}{3}\ln x-\dfrac{x^3}{9}+C\).$$,
  9,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  { "label": "a", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{e^{2x}}{e^{2x}-3}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "b", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{3x^2+2}{\\sqrt{x^3+2x-8}}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "c", "prompt_latex": "\\(\\displaystyle\\int\\dfrac{1}{x^2+2x+5}\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null },
  { "label": "d", "prompt_latex": "\\(\\displaystyle\\int x^2\\ln x\\,dx\\)", "correct_answer": null, "answer_type": null, "tolerance": null }
]$$::jsonb
);

-- Q9 (ADVANCED): derivative (show) then ∫sin^-1 x dx. Show + indefinite integral -> ungraded.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a009-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  $$Integrating an inverse sine$$,
  $$Consider \(\sqrt{1-x^2}\) for \(|x|<1\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(i) \(\dfrac{d}{dx}\sqrt{1-x^2}=\dfrac{1}{2}(1-x^2)^{-1/2}(-2x)=\dfrac{-x}{\sqrt{1-x^2}}\) (shown). (ii) By parts with \(u=\sin^{-1}x\), \(dv=dx\): \(\displaystyle\int\sin^{-1}x\,dx=x\sin^{-1}x-\int\dfrac{x}{\sqrt{1-x^2}}\,dx=x\sin^{-1}x+\sqrt{1-x^2}+C\).$$,
  4,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(\\dfrac{d}{dx}\\sqrt{1-x^2}=\\dfrac{-x}{\\sqrt{1-x^2}}\\), \\(|x|<1\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Hence find \\(\\displaystyle\\int\\sin^{-1}x\\,dx\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q10: state derivative (graded) then ∫ x^3 cos(x^2) dx (indefinite -> ungraded).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a00a-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  $$Integration by parts using a stated derivative$$,
  $$Consider \(\sin(x^2)\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\dfrac{d}{dx}\sin(x^2)=2x\cos(x^2)\). (ii) By parts with \(u=x^2\), \(dv=2x\cos(x^2)\,dx\) so \(v=\sin(x^2)\): \(\displaystyle\int x^3\cos(x^2)\,dx=\dfrac{1}{2}\int x^2\cdot 2x\cos(x^2)\,dx=\dfrac{1}{2}x^2\sin(x^2)-\dfrac{1}{2}\int 2x\sin(x^2)\,dx=\dfrac{1}{2}x^2\sin(x^2)+\dfrac{1}{2}\cos(x^2)+C\).$$,
  4,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  {
    "label": "i",
    "prompt_latex": "State the derivative of \\(\\sin(x^2)\\).",
    "correct_answer": "2x\\cos(x^2)",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find \\(\\displaystyle\\int x^3\\cos(x^2)\\,dx\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q11 (ADVANCED): find derivative (graded) then ∫ e^{2x} sin^-1(e^{2x}) dx (indefinite -> ungraded).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21a00b-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  $$Integrating an inverse sine of an exponential$$,
  $$Consider \(\left(1-e^{4x}\right)^{1/2}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\dfrac{d}{dx}\left(1-e^{4x}\right)^{1/2}=\dfrac{1}{2}\left(1-e^{4x}\right)^{-1/2}\left(-4e^{4x}\right)=-\dfrac{2e^{4x}}{\sqrt{1-e^{4x}}}\). (ii) By parts with \(u=\sin^{-1}(e^{2x})\), \(dv=e^{2x}\,dx\): \(\displaystyle\int e^{2x}\sin^{-1}(e^{2x})\,dx=\dfrac{1}{2}e^{2x}\sin^{-1}(e^{2x})-\int\dfrac{1}{2}e^{2x}\cdot\dfrac{2e^{2x}}{\sqrt{1-e^{4x}}}\,dx=\dfrac{1}{2}e^{2x}\sin^{-1}(e^{2x})+\dfrac{1}{2}\left(1-e^{4x}\right)^{1/2}+C\).$$,
  5,
  'H2 Math Tutorial (Techniques of Integration)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find \\(\\dfrac{d}{dx}\\left(1-e^{4x}\\right)^{\\frac{1}{2}}\\).",
    "correct_answer": "-\\frac{2e^{4x}}{\\sqrt{1-e^{4x}}}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Hence find \\(\\displaystyle\\int e^{2x}\\sin^{-1}\\left(e^{2x}\\right)\\,dx\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);
