-- Seed data — run after 001_initial_schema.sql
-- Covers Differentiation and Integration (H2) with 5 questions each

-- ─── Topics ───────────────────────────────────────────────────────────────────
INSERT INTO topics (id, name, level) VALUES
  ('11111111-0000-0000-0000-000000000001', 'Differentiation',  'H2'),
  ('11111111-0000-0000-0000-000000000002', 'Integration',      'H2'),
  ('11111111-0000-0000-0000-000000000003', 'Functions & Graphs', 'H2'),
  ('11111111-0000-0000-0000-000000000004', 'Sequences & Series', 'H2'),
  ('11111111-0000-0000-0000-000000000005', 'Statistics',       'H1');

-- ─── Differentiation questions ────────────────────────────────────────────────
INSERT INTO questions
  (id, topic_id, difficulty, prompt_latex, answer_type, correct_answer, tolerance, mcq_options, solution_latex, marks)
VALUES
  (
    '22222222-0000-0000-0000-000000000001',
    '11111111-0000-0000-0000-000000000001',
    1,
    'Find \(\dfrac{dy}{dx}\) when \(y = 3x^2 - 4x + 7\).',
    'exact',
    '6x - 4',
    NULL,
    NULL,
    'Differentiating term by term: \(\dfrac{d}{dx}(3x^2) = 6x\), \(\dfrac{d}{dx}(-4x) = -4\), \(\dfrac{d}{dx}(7) = 0\). Therefore \(\dfrac{dy}{dx} = 6x - 4\).',
    1
  ),
  (
    '22222222-0000-0000-0000-000000000002',
    '11111111-0000-0000-0000-000000000001',
    1,
    'Given \(f(x) = e^{2x}\), find \(f''(x)\).',
    'exact',
    '2e^{2x}',
    NULL,
    NULL,
    'Using the chain rule: \(f''(x) = e^{2x} \cdot \dfrac{d}{dx}(2x) = 2e^{2x}\).',
    1
  ),
  (
    '22222222-0000-0000-0000-000000000003',
    '11111111-0000-0000-0000-000000000001',
    2,
    'Find \(\dfrac{dy}{dx}\) when \(y = x^2 \ln x\).',
    'exact',
    '2x\ln x + x',
    NULL,
    NULL,
    'Apply the product rule with \(u = x^2\) and \(v = \ln x\):\n\[\dfrac{dy}{dx} = 2x \cdot \ln x + x^2 \cdot \dfrac{1}{x} = 2x\ln x + x\]',
    2
  ),
  (
    '22222222-0000-0000-0000-000000000004',
    '11111111-0000-0000-0000-000000000001',
    2,
    'Which of the following is the derivative of \(\sin(3x^2)\)?',
    'mcq',
    'B',
    NULL,
    '["A: \\cos(3x^2)", "B: 6x\\cos(3x^2)", "C: 3\\cos(3x^2)", "D: 6x\\cos(6x)"]',
    'Chain rule: \(\dfrac{d}{dx}\sin(3x^2) = \cos(3x^2) \cdot 6x = 6x\cos(3x^2)\). Answer: **B**.',
    1
  ),
  (
    '22222222-0000-0000-0000-000000000005',
    '11111111-0000-0000-0000-000000000001',
    3,
    'A curve has equation \(y = \dfrac{x^2 - 1}{x + 2}\). Find the x-coordinates of the stationary points.',
    'exact',
    'x = -1 + \sqrt{5}, x = -1 - \sqrt{5}',
    NULL,
    NULL,
    'Using the quotient rule: \(\dfrac{dy}{dx} = \dfrac{2x(x+2) - (x^2-1)}{(x+2)^2} = \dfrac{x^2+4x+1}{(x+2)^2}\). Setting numerator to zero: \(x^2 + 4x + 1 = 0 \Rightarrow x = -2 \pm \sqrt{3}\).\n\nWait — \(x = \dfrac{-4 \pm \sqrt{12}}{2} = -2 \pm \sqrt{3}\).',
    4
  );

-- ─── Integration questions ────────────────────────────────────────────────────
INSERT INTO questions
  (id, topic_id, difficulty, prompt_latex, answer_type, correct_answer, tolerance, mcq_options, solution_latex, marks)
VALUES
  (
    '33333333-0000-0000-0000-000000000001',
    '11111111-0000-0000-0000-000000000002',
    1,
    'Evaluate \(\displaystyle\int (4x^3 - 2x + 5)\,dx\).',
    'exact',
    'x^4 - x^2 + 5x + C',
    NULL,
    NULL,
    'Integrate term by term: \(\int 4x^3\,dx = x^4\), \(\int -2x\,dx = -x^2\), \(\int 5\,dx = 5x\). Result: \(x^4 - x^2 + 5x + C\).',
    2
  ),
  (
    '33333333-0000-0000-0000-000000000002',
    '11111111-0000-0000-0000-000000000002',
    1,
    'Evaluate \(\displaystyle\int_0^2 (3x^2 + 1)\,dx\).',
    'range',
    '10',
    0.01,
    NULL,
    '\[\int_0^2 (3x^2 + 1)\,dx = \Big[x^3 + x\Big]_0^2 = (8 + 2) - (0) = 10\]',
    2
  ),
  (
    '33333333-0000-0000-0000-000000000003',
    '11111111-0000-0000-0000-000000000002',
    2,
    'Evaluate \(\displaystyle\int e^{3x}\,dx\).',
    'exact',
    '\frac{1}{3}e^{3x} + C',
    NULL,
    NULL,
    'Let \(u = 3x\), \(du = 3\,dx\). Then \(\int e^{3x}\,dx = \dfrac{1}{3}\int e^u\,du = \dfrac{1}{3}e^{3x} + C\).',
    1
  ),
  (
    '33333333-0000-0000-0000-000000000004',
    '11111111-0000-0000-0000-000000000002',
    2,
    'Which substitution simplifies \(\displaystyle\int x\sqrt{x^2+1}\,dx\)?',
    'mcq',
    'C',
    NULL,
    '["A: x = \\tan\\theta", "B: x = \\sin\\theta", "C: u = x^2 + 1", "D: u = \\sqrt{x^2+1}"]',
    'Let \(u = x^2 + 1\), then \(du = 2x\,dx\), so \(x\,dx = \dfrac{du}{2}\). The integral becomes \(\dfrac{1}{2}\int\sqrt{u}\,du = \dfrac{1}{3}u^{3/2} + C = \dfrac{1}{3}(x^2+1)^{3/2} + C\). Answer: **C**.',
    1
  ),
  (
    '33333333-0000-0000-0000-000000000005',
    '11111111-0000-0000-0000-000000000002',
    3,
    'Use integration by parts to evaluate \(\displaystyle\int_1^e x\ln x\,dx\). Give your answer to 3 significant figures.',
    'range',
    '2.10',
    0.005,
    NULL,
    'Let \(u = \ln x\), \(dv = x\,dx\). Then \(du = \frac{1}{x}dx\), \(v = \frac{x^2}{2}\).\n\[\int x\ln x\,dx = \frac{x^2}{2}\ln x - \int \frac{x}{2}\,dx = \frac{x^2}{2}\ln x - \frac{x^2}{4} + C\]\n\[\Bigg[\frac{x^2}{2}\ln x - \frac{x^2}{4}\Bigg]_1^e = \left(\frac{e^2}{2}\cdot 1 - \frac{e^2}{4}\right) - \left(0 - \frac{1}{4}\right) = \frac{e^2}{4} + \frac{1}{4} = \frac{e^2+1}{4} \approx \frac{8.389}{4} \approx 2.10\]',
    3
  );
