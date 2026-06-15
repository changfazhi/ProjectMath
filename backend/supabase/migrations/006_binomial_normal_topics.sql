-- Migration 006: Add Binomial Distribution and Normal Distribution topics
-- Insert between Discrete Random Variable (bbbb0003) and Sampling and Estimation Theory (bbbb0004)

INSERT INTO topics (id, name, level) VALUES
  ('bbbb0007-0000-0000-0000-000000000000', 'Binomial Distribution', 'H2'),
  ('bbbb0008-0000-0000-0000-000000000000', 'Normal Distribution',   'H2');

-- Binomial Distribution concepts
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0007-0000-0000-0000-000000000000', 'Conditions for binomial distribution: n independent Bernoulli trials, constant probability p, binary outcomes', 0),
  ('bbbb0007-0000-0000-0000-000000000000', 'P(X = r) = C(n,r) × p^r × (1−p)^(n−r) for X ~ B(n, p)', 1),
  ('bbbb0007-0000-0000-0000-000000000000', 'Mean E(X) = np and variance Var(X) = np(1−p)', 2),
  ('bbbb0007-0000-0000-0000-000000000000', 'Computing cumulative binomial probabilities P(X ≤ r) and P(X ≥ r) using GC', 3),
  ('bbbb0007-0000-0000-0000-000000000000', 'Normal approximation to binomial when n is large and both np > 5 and n(1−p) > 5', 4);

-- Normal Distribution concepts
INSERT INTO topic_concepts (topic_id, concept, sort_order) VALUES
  ('bbbb0008-0000-0000-0000-000000000000', 'X ~ N(μ, σ²): bell-shaped curve symmetric about mean μ; total area under curve = 1', 0),
  ('bbbb0008-0000-0000-0000-000000000000', 'Standardisation: Z = (X − μ)/σ ~ N(0, 1); convert any normal to standard normal', 1),
  ('bbbb0008-0000-0000-0000-000000000000', 'Finding P(X < a), P(X > a), P(a < X < b) using GC normal CDF', 2),
  ('bbbb0008-0000-0000-0000-000000000000', 'Linear combinations: if X, Y independent normal then aX + bY ~ N(aμ_X + bμ_Y, a²σ²_X + b²σ²_Y)', 3),
  ('bbbb0008-0000-0000-0000-000000000000', 'Reverse lookup: finding unknown μ or σ given a stated probability condition', 4);

GRANT ALL ON TABLE public.topics        TO anon, authenticated, service_role;
GRANT ALL ON TABLE public.topic_concepts TO anon, authenticated, service_role;
