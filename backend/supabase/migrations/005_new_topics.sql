-- Migration 005: Replace 5 placeholder topics with the full 24-topic syllabus.
-- Run AFTER migrations 001–004.

-- ─── Step 1: Insert the 24 new topics ────────────────────────────────────────
INSERT INTO topics (id, name, level) VALUES
  -- Pure Math — Column A
  ('aaaa0001-0000-0000-0000-000000000000', 'Graphing Techniques',            'H2'),
  ('aaaa0002-0000-0000-0000-000000000000', 'Functions',                      'H2'),
  ('aaaa0003-0000-0000-0000-000000000000', 'Transformation',                 'H2'),
  ('aaaa0004-0000-0000-0000-000000000000', 'Conics',                         'H2'),
  ('aaaa0005-0000-0000-0000-000000000000', 'Inequalities',                   'H2'),
  ('aaaa0006-0000-0000-0000-000000000000', 'Systems of Linear Equations',    'H2'),
  -- Pure Math — Column B
  ('aaaa0007-0000-0000-0000-000000000000', 'Sequences & Series',             'H2'),
  ('aaaa0008-0000-0000-0000-000000000000', 'Vector (Basic)',                  'H2'),
  ('aaaa0009-0000-0000-0000-000000000000', 'Vector (Lines)',                  'H2'),
  ('aaaa0010-0000-0000-0000-000000000000', 'Vector (Plane)',                  'H2'),
  ('aaaa0011-0000-0000-0000-000000000000', 'Complex Number',                 'H2'),
  ('aaaa0012-0000-0000-0000-000000000000', 'Differentiation Technique',      'H2'),
  -- Pure Math — Column C
  ('aaaa0013-0000-0000-0000-000000000000', 'Application of Differentiation', 'H2'),
  ('aaaa0014-0000-0000-0000-000000000000', 'Maclaurin Series',               'H2'),
  ('aaaa0015-0000-0000-0000-000000000000', 'Integration Technique',          'H2'),
  ('aaaa0016-0000-0000-0000-000000000000', 'Definite Integral',              'H2'),
  ('aaaa0017-0000-0000-0000-000000000000', 'Parametric Equations',           'H2'),
  ('aaaa0018-0000-0000-0000-000000000000', 'Differential Equations',         'H2'),
  -- Statistics — Column D
  ('bbbb0001-0000-0000-0000-000000000000', 'Permutation and Combination',    'H2'),
  ('bbbb0002-0000-0000-0000-000000000000', 'Probability',                    'H2'),
  ('bbbb0003-0000-0000-0000-000000000000', 'Discrete Random Variable',       'H2'),
  ('bbbb0004-0000-0000-0000-000000000000', 'Sampling and Estimation Theory', 'H2'),
  ('bbbb0005-0000-0000-0000-000000000000', 'Hypothesis Testing',             'H2'),
  ('bbbb0006-0000-0000-0000-000000000000', 'Correlation and Linear Regression', 'H2');

-- ─── Step 2: Remap existing questions to new topic UUIDs ─────────────────────
UPDATE questions
  SET topic_id = 'aaaa0012-0000-0000-0000-000000000000'
  WHERE topic_id = '11111111-0000-0000-0000-000000000001'; -- Differentiation → Differentiation Technique

UPDATE questions
  SET topic_id = 'aaaa0015-0000-0000-0000-000000000000'
  WHERE topic_id = '11111111-0000-0000-0000-000000000002'; -- Integration → Integration Technique

-- ─── Step 3: Delete old topics (CASCADE removes their concept rows only) ─────
DELETE FROM topics WHERE id IN (
  '11111111-0000-0000-0000-000000000001',
  '11111111-0000-0000-0000-000000000002',
  '11111111-0000-0000-0000-000000000003',
  '11111111-0000-0000-0000-000000000004',
  '11111111-0000-0000-0000-000000000005'
);

-- ─── Step 4: Grant permissions on topics (already granted in 001, repeated for safety) ─
GRANT ALL ON TABLE public.topics TO anon, authenticated, service_role;

-- ─── Step 5: Insert topic concepts for all 24 new topics ─────────────────────

-- Graphing Techniques
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0001-0000-0000-0000-000000000000', 'Recognising standard curve shapes: polynomials, exponentials, logarithms, and trigonometric functions', 0),
  ('aaaa0001-0000-0000-0000-000000000000', 'Finding x-intercepts, y-intercepts, and turning points to sketch curves', 1),
  ('aaaa0001-0000-0000-0000-000000000000', 'Identifying vertical, horizontal, and oblique asymptotes', 2),
  ('aaaa0001-0000-0000-0000-000000000000', 'Sketching curves of the form y = |f(x)| and y = 1/f(x) from f(x)', 3),
  ('aaaa0001-0000-0000-0000-000000000000', 'Using a graphing calculator to verify sketches', 4);

-- Functions
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0002-0000-0000-0000-000000000000', 'Definition of a function: domain, codomain, and range', 0),
  ('aaaa0002-0000-0000-0000-000000000000', 'One-to-one (injective) functions and the horizontal line test', 1),
  ('aaaa0002-0000-0000-0000-000000000000', 'Composite functions f∘g and determining the domain of the composite', 2),
  ('aaaa0002-0000-0000-0000-000000000000', 'Inverse functions: existence conditions and finding f⁻¹(x)', 3),
  ('aaaa0002-0000-0000-0000-000000000000', 'Graphical relationship between f and f⁻¹ (reflection in y = x)', 4);

-- Transformation
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0003-0000-0000-0000-000000000000', 'Translations: y = f(x) + a (vertical) and y = f(x + a) (horizontal)', 0),
  ('aaaa0003-0000-0000-0000-000000000000', 'Reflections: y = −f(x) (in x-axis) and y = f(−x) (in y-axis)', 1),
  ('aaaa0003-0000-0000-0000-000000000000', 'Scaling: y = kf(x) (vertical) and y = f(kx) (horizontal)', 2),
  ('aaaa0003-0000-0000-0000-000000000000', 'Combining multiple transformations and the order in which they are applied', 3),
  ('aaaa0003-0000-0000-0000-000000000000', 'Effect of transformations on key features: intercepts, asymptotes, and turning points', 4);

-- Conics
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0004-0000-0000-0000-000000000000', 'Equation of a circle: (x − a)² + (y − b)² = r² and completing the square', 0),
  ('aaaa0004-0000-0000-0000-000000000000', 'Ellipse: standard form x²/a² + y²/b² = 1 and its key features', 1),
  ('aaaa0004-0000-0000-0000-000000000000', 'Hyperbola: standard form x²/a² − y²/b² = 1 and asymptotes', 2),
  ('aaaa0004-0000-0000-0000-000000000000', 'Parabola: y² = 4ax and focus-directrix definition', 3),
  ('aaaa0004-0000-0000-0000-000000000000', 'Finding intersections of a line with a conic section', 4);

-- Inequalities
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0005-0000-0000-0000-000000000000', 'Solving polynomial and rational inequalities algebraically', 0),
  ('aaaa0005-0000-0000-0000-000000000000', 'Graphical method: solving f(x) > g(x) using the graph of y = f(x) − g(x)', 1),
  ('aaaa0005-0000-0000-0000-000000000000', 'Modulus inequalities: |f(x)| < k and |f(x)| > k', 2),
  ('aaaa0005-0000-0000-0000-000000000000', 'Sign diagrams (number lines) to determine intervals of solution', 3),
  ('aaaa0005-0000-0000-0000-000000000000', 'Strict vs non-strict inequalities and boundary point inclusion', 4);

-- Systems of Linear Equations
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0006-0000-0000-0000-000000000000', 'Representing a system of equations as an augmented matrix', 0),
  ('aaaa0006-0000-0000-0000-000000000000', 'Row operations and Gaussian elimination to row-echelon form', 1),
  ('aaaa0006-0000-0000-0000-000000000000', 'Unique solution, infinitely many solutions, and no-solution cases', 2),
  ('aaaa0006-0000-0000-0000-000000000000', 'Back substitution to find the solution set', 3),
  ('aaaa0006-0000-0000-0000-000000000000', 'Geometric interpretation: intersection of planes in 3D space', 4);

-- Sequences & Series
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0007-0000-0000-0000-000000000000', 'Arithmetic progressions: common difference, general term, and sum formula', 0),
  ('aaaa0007-0000-0000-0000-000000000000', 'Geometric progressions: common ratio, general term, sum formula, and sum to infinity', 1),
  ('aaaa0007-0000-0000-0000-000000000000', 'Sigma notation and properties of summation', 2),
  ('aaaa0007-0000-0000-0000-000000000000', 'Method of differences for summing series telescopically', 3),
  ('aaaa0007-0000-0000-0000-000000000000', 'Mathematical induction for proving series and divisibility results', 4);

-- Vector (Basic)
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0008-0000-0000-0000-000000000000', 'Vector notation: column vectors, unit vectors i, j, k', 0),
  ('aaaa0008-0000-0000-0000-000000000000', 'Addition, subtraction, and scalar multiplication of vectors', 1),
  ('aaaa0008-0000-0000-0000-000000000000', 'Magnitude of a vector and finding unit vectors', 2),
  ('aaaa0008-0000-0000-0000-000000000000', 'Scalar (dot) product: a·b = |a||b|cosθ and its geometric meaning', 3),
  ('aaaa0008-0000-0000-0000-000000000000', 'Cross product: a × b and its direction and magnitude', 4);

-- Vector (Lines)
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0009-0000-0000-0000-000000000000', 'Vector equation of a line: r = a + λb', 0),
  ('aaaa0009-0000-0000-0000-000000000000', 'Parametric form and Cartesian form of a line in 3D', 1),
  ('aaaa0009-0000-0000-0000-000000000000', 'Conditions for parallel, intersecting, and skew lines', 2),
  ('aaaa0009-0000-0000-0000-000000000000', 'Finding the foot of perpendicular from a point to a line', 3),
  ('aaaa0009-0000-0000-0000-000000000000', 'Shortest distance between two skew lines', 4);

-- Vector (Plane)
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0010-0000-0000-0000-000000000000', 'Normal vector and equation of a plane: r·n = d', 0),
  ('aaaa0010-0000-0000-0000-000000000000', 'Converting between vector, parametric, and Cartesian forms of a plane', 1),
  ('aaaa0010-0000-0000-0000-000000000000', 'Angle between two planes using their normal vectors', 2),
  ('aaaa0010-0000-0000-0000-000000000000', 'Relationship between a line and a plane: intersection point and angle', 3),
  ('aaaa0010-0000-0000-0000-000000000000', 'Distance from a point to a plane using the formula', 4);

-- Complex Number
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0011-0000-0000-0000-000000000000', 'Cartesian form z = x + iy: real part, imaginary part, complex conjugate', 0),
  ('aaaa0011-0000-0000-0000-000000000000', 'Argand diagram: geometric representation of complex numbers', 1),
  ('aaaa0011-0000-0000-0000-000000000000', 'Modulus |z| and argument arg(z); principal argument in (−π, π]', 2),
  ('aaaa0011-0000-0000-0000-000000000000', 'Polar form z = r(cosθ + i sinθ) and exponential form z = re^{iθ}', 3),
  ('aaaa0011-0000-0000-0000-000000000000', 'De Moivre''s theorem and finding nth roots of complex numbers', 4);

-- Differentiation Technique
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0012-0000-0000-0000-000000000000', 'Chain rule for composite functions: d/dx[f(g(x))] = f''(g(x))·g''(x)', 0),
  ('aaaa0012-0000-0000-0000-000000000000', 'Product rule: d/dx[uv] = u''v + uv''', 1),
  ('aaaa0012-0000-0000-0000-000000000000', 'Quotient rule: d/dx[u/v] = (u''v − uv'') / v²', 2),
  ('aaaa0012-0000-0000-0000-000000000000', 'Derivatives of exponential, logarithmic, and trigonometric functions', 3),
  ('aaaa0012-0000-0000-0000-000000000000', 'Implicit differentiation for curves not expressed as y = f(x)', 4);

-- Application of Differentiation
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0013-0000-0000-0000-000000000000', 'Finding stationary points and classifying them (max, min, inflection) using the second derivative', 0),
  ('aaaa0013-0000-0000-0000-000000000000', 'Increasing and decreasing functions: sign of dy/dx on intervals', 1),
  ('aaaa0013-0000-0000-0000-000000000000', 'Optimisation problems: finding maximum or minimum values in context', 2),
  ('aaaa0013-0000-0000-0000-000000000000', 'Connected rates of change using the chain rule', 3),
  ('aaaa0013-0000-0000-0000-000000000000', 'Equations of tangent and normal lines to a curve at a given point', 4);

-- Maclaurin Series
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0014-0000-0000-0000-000000000000', 'Definition: f(x) = f(0) + f''(0)x + f''''(0)x²/2! + ⋯', 0),
  ('aaaa0014-0000-0000-0000-000000000000', 'Standard series: e^x, sin x, cos x, ln(1+x), (1+x)^n with ranges of validity', 1),
  ('aaaa0014-0000-0000-0000-000000000000', 'Finding new series by substitution into standard series', 2),
  ('aaaa0014-0000-0000-0000-000000000000', 'Finding series by differentiating or integrating a known series', 3),
  ('aaaa0014-0000-0000-0000-000000000000', 'Using series to evaluate limits as x → 0', 4);

-- Integration Technique
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0015-0000-0000-0000-000000000000', 'Integration by substitution (reverse chain rule)', 0),
  ('aaaa0015-0000-0000-0000-000000000000', 'Integration by parts: ∫u dv = uv − ∫v du', 1),
  ('aaaa0015-0000-0000-0000-000000000000', 'Partial fractions decomposition before integrating rational functions', 2),
  ('aaaa0015-0000-0000-0000-000000000000', 'Using trigonometric identities to simplify integrands', 3),
  ('aaaa0015-0000-0000-0000-000000000000', 'Standard integrals: 1/x, e^x, sin x, cos x, 1/(a²+x²), 1/√(a²−x²)', 4);

-- Definite Integral
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0016-0000-0000-0000-000000000000', 'Fundamental Theorem of Calculus: ∫_a^b f(x) dx = F(b) − F(a)', 0),
  ('aaaa0016-0000-0000-0000-000000000000', 'Area between a curve and the x-axis or y-axis', 1),
  ('aaaa0016-0000-0000-0000-000000000000', 'Area enclosed between two curves', 2),
  ('aaaa0016-0000-0000-0000-000000000000', 'Volume of revolution about the x-axis or y-axis using the disc method', 3),
  ('aaaa0016-0000-0000-0000-000000000000', 'Properties of definite integrals: linearity and symmetry', 4);

-- Parametric Equations
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0017-0000-0000-0000-000000000000', 'Expressing curves using a parameter t: x = f(t), y = g(t)', 0),
  ('aaaa0017-0000-0000-0000-000000000000', 'Converting between parametric and Cartesian forms', 1),
  ('aaaa0017-0000-0000-0000-000000000000', 'Differentiation: dy/dx = (dy/dt) / (dx/dt)', 2),
  ('aaaa0017-0000-0000-0000-000000000000', 'Second derivative d²y/dx² in terms of the parameter', 3),
  ('aaaa0017-0000-0000-0000-000000000000', 'Integration: area under a parametric curve ∫y (dx/dt) dt', 4);

-- Differential Equations
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('aaaa0018-0000-0000-0000-000000000000', 'Separable differential equations: separating variables and integrating', 0),
  ('aaaa0018-0000-0000-0000-000000000000', 'Integrating factor method for first-order linear DEs: dy/dx + P(x)y = Q(x)', 1),
  ('aaaa0018-0000-0000-0000-000000000000', 'Applying initial or boundary conditions to find the particular solution', 2),
  ('aaaa0018-0000-0000-0000-000000000000', 'Formulating differential equations from rates of change in context', 3),
  ('aaaa0018-0000-0000-0000-000000000000', 'Sketching solution curves and interpreting them in context', 4);

-- Permutation and Combination
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0001-0000-0000-0000-000000000000', 'Fundamental counting principle (multiplication rule)', 0),
  ('bbbb0001-0000-0000-0000-000000000000', 'Permutations: ⁿPᵣ = n! / (n−r)! for ordered arrangements', 1),
  ('bbbb0001-0000-0000-0000-000000000000', 'Combinations: ⁿCᵣ = n! / (r!(n−r)!) for unordered selections', 2),
  ('bbbb0001-0000-0000-0000-000000000000', 'Arrangements with identical objects and circular arrangements', 3),
  ('bbbb0001-0000-0000-0000-000000000000', 'Arrangements with restrictions (e.g. must be together or must be separated)', 4);

-- Probability
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0002-0000-0000-0000-000000000000', 'Sample space, events, and the probability axioms', 0),
  ('bbbb0002-0000-0000-0000-000000000000', 'Addition rule: P(A∪B) = P(A) + P(B) − P(A∩B)', 1),
  ('bbbb0002-0000-0000-0000-000000000000', 'Conditional probability: P(A|B) = P(A∩B) / P(B)', 2),
  ('bbbb0002-0000-0000-0000-000000000000', 'Independence: P(A∩B) = P(A)·P(B)', 3),
  ('bbbb0002-0000-0000-0000-000000000000', 'Venn diagrams and probability tree diagrams', 4);

-- Discrete Random Variable
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0003-0000-0000-0000-000000000000', 'Probability distribution table: P(X = x) for all possible values', 0),
  ('bbbb0003-0000-0000-0000-000000000000', 'Expectation: E(X) = Σ x·P(X=x) and E(g(X))', 1),
  ('bbbb0003-0000-0000-0000-000000000000', 'Variance: Var(X) = E(X²) − [E(X)]²', 2),
  ('bbbb0003-0000-0000-0000-000000000000', 'Binomial distribution B(n, p): conditions, mean np, variance np(1−p)', 3),
  ('bbbb0003-0000-0000-0000-000000000000', 'Poisson distribution Po(λ): conditions, mean λ, variance λ', 4);

-- Sampling and Estimation Theory
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0004-0000-0000-0000-000000000000', 'Population parameters vs sample statistics', 0),
  ('bbbb0004-0000-0000-0000-000000000000', 'Unbiased estimates of population mean and variance from a sample', 1),
  ('bbbb0004-0000-0000-0000-000000000000', 'Central Limit Theorem: X̄ ~ N(μ, σ²/n) for large n', 2),
  ('bbbb0004-0000-0000-0000-000000000000', 'Confidence intervals for the population mean', 3),
  ('bbbb0004-0000-0000-0000-000000000000', 'Choosing sample size to achieve a desired margin of error', 4);

-- Hypothesis Testing
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0005-0000-0000-0000-000000000000', 'Null hypothesis H₀ and alternative hypothesis H₁', 0),
  ('bbbb0005-0000-0000-0000-000000000000', 'One-tailed and two-tailed tests; significance level α', 1),
  ('bbbb0005-0000-0000-0000-000000000000', 'Test statistic, critical region, and p-value interpretation', 2),
  ('bbbb0005-0000-0000-0000-000000000000', 'z-test for population mean when σ is known', 3),
  ('bbbb0005-0000-0000-0000-000000000000', 'Conclusion in context: reject or do not reject H₀', 4);

-- Correlation and Linear Regression
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0006-0000-0000-0000-000000000000', 'Scatter diagrams and types of linear correlation', 0),
  ('bbbb0006-0000-0000-0000-000000000000', 'Product moment correlation coefficient r: range, interpretation', 1),
  ('bbbb0006-0000-0000-0000-000000000000', 'Least squares regression line y on x: y = a + bx', 2),
  ('bbbb0006-0000-0000-0000-000000000000', 'Using the regression line for prediction (interpolation vs extrapolation)', 3),
  ('bbbb0006-0000-0000-0000-000000000000', 'Transforming data to linearise a non-linear relationship', 4);
