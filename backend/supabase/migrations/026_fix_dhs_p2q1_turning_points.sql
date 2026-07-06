-- Migration 026: fix DHS P2 Q1 (d0251001) turning-point values.
--
-- Migrations 010 (solution_latex) and 024 (solution_graph points) both state
-- min (2, 8) and max (-4, -10) for y = x + 9/(x+1). The official DHS suggested
-- solutions (and the algebra: y(2) = 2 + 9/3 = 5, y(-4) = -4 - 3 = -7) give
-- A(-4, -7) and B(2, 5). The wrong y-values put the model-sketch dots 3 units
-- off the curve.

-- Correct the sketch spec's labelled points (part b).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph,points}', $$[
  { "x": 2, "y": 5, "label": "(2,\\ 5)", "kind": "min" },
  { "x": -4, "y": -7, "label": "(-4,\\ -7)", "kind": "max" },
  { "x": 0, "y": 9, "label": "(0,\\ 9)", "kind": "intercept" }
]$$::jsonb)
WHERE id = 'd0251001-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b'
  AND parts->1->'solution_graph' IS NOT NULL;

-- Correct the written solution text.
UPDATE questions
SET solution_latex = replace(
  replace(solution_latex, $$(local min, \(y=8\))$$, $$(local min, \(y=5\))$$),
  $$(local max, \(y=-10\))$$,
  $$(local max, \(y=-7\))$$
)
WHERE id = 'd0251001-0000-0000-0000-000000000000';
