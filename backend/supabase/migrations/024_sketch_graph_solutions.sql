-- 024_sketch_graph_solutions.sql
-- Adds `solution_graph` specs to sketch parts (answer_type null) so the app can
-- render a model graph in the Solution tab. Data-only — no DDL (`parts` is JSONB).
--
-- Spec format (compiled server-side by graphService.compileGraph; `expr` is
-- mathjs syntax in the variable x, evaluated only on the backend; `label` is
-- LaTeX rendered by KaTeX on the client):
--   { "x_range": [a,b], "y_range": [c,d],
--     "curves": [{ "expr", "domain": [a,b], "label"? }],
--     "asymptotes": [{ "kind": "vertical"|"horizontal"|"oblique", "x"?, "expr"?, "label"? }],
--     "points": [{ "x", "y", "label"?, "kind": "min"|"max"|"intercept"|"point" }] }
--
-- Each UPDATE uses jsonb_set on the part's index and guards on the part label,
-- so a mismatched array shape makes the UPDATE a no-op instead of corrupting data.
-- Part indices verified against the CURRENT state (i.e. after migration 021,
-- which rewrote parts for d0251005 and c0251003).

-- ---------------------------------------------------------------------------
-- DHS P2 Q1 (d0251001) part (b): sketch C, y = x + 9/(x+1).
-- VA x=-1, oblique y=x, min (2,8), max (-4,-10), y-intercept (0,9), no x-intercepts.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-10, 8],
  "y_range": [-20, 18],
  "curves": [
    { "expr": "x + 9/(x+1)", "domain": [-10, -1] },
    { "expr": "x + 9/(x+1)", "domain": [-1, 8], "label": "y=x+\\dfrac{9}{x+1}" }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": -1, "label": "x=-1" },
    { "kind": "oblique", "expr": "x", "label": "y=x" }
  ],
  "points": [
    { "x": 2, "y": 8, "label": "(2,\\ 8)", "kind": "min" },
    { "x": -4, "y": -10, "label": "(-4,\\ -10)", "kind": "max" },
    { "x": 0, "y": 9, "label": "(0,\\ 9)", "kind": "intercept" }
  ]
}$$::jsonb)
WHERE id = 'd0251001-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- ---------------------------------------------------------------------------
-- DHS P2 Q5 (d0251005) part (e): sketch T_p(t) = 30 + 177e^(-0.0619t), t >= 0.
-- Decaying exponential from (0, 207) to the horizontal asymptote T = 30.
-- (28.7, 60) is the cooling-to-60°C time found in part (d).
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${
  "x_range": [0, 80],
  "y_range": [0, 220],
  "curves": [
    { "expr": "30 + 177*e^(-0.0619*x)", "domain": [0, 80], "label": "T_p(t)=30+177e^{-0.0619t}" }
  ],
  "asymptotes": [
    { "kind": "horizontal", "expr": "30", "label": "T=30" }
  ],
  "points": [
    { "x": 0, "y": 207, "label": "(0,\\ 207)", "kind": "intercept" },
    { "x": 28.7, "y": 60, "label": "(28.7,\\ 60)", "kind": "point" }
  ]
}$$::jsonb)
WHERE id = 'd0251005-0000-0000-0000-000000000000'
  AND parts->4->>'label' = 'e';

-- ---------------------------------------------------------------------------
-- CJC P1 Q5 (b0250005) part (b): sketch y = (-2x+6)/(x-1) - x  =  -x - 2 + 4/(x-1).
-- VA x=1, oblique y=-x-2, crosses axes at (-3,0), (2,0), (0,-6). No turning points.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-8, 8],
  "y_range": [-16, 12],
  "curves": [
    { "expr": "(-2*x+6)/(x-1) - x", "domain": [-8, 1], "label": "y=\\dfrac{-2x+6}{x-1}-x" },
    { "expr": "(-2*x+6)/(x-1) - x", "domain": [1, 8] }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 1, "label": "x=1" },
    { "kind": "oblique", "expr": "-x-2", "label": "y=-x-2" }
  ],
  "points": [
    { "x": -3, "y": 0, "label": "(-3,\\ 0)", "kind": "intercept" },
    { "x": 2, "y": 0, "label": "(2,\\ 0)", "kind": "intercept" },
    { "x": 0, "y": -6, "label": "(0,\\ -6)", "kind": "intercept" }
  ]
}$$::jsonb)
WHERE id = 'b0250005-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- ---------------------------------------------------------------------------
-- HCI P2 Q3 (c0251003) part (d): sketch C — left branch of the hyperbola
-- ((1-x)/3)^2 - ((y+3)/2)^2 = 1 (0 < θ < π gives x <= -2 only).
-- Centre (1,-3), vertex (-2,-3), asymptotes y = -(2/3)x - 7/3 and y = (2/3)x - 11/3.
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [-10, 4],
  "y_range": [-11, 5],
  "curves": [
    { "expr": "-3 + 2*sqrt(((1-x)/3)^2 - 1)", "domain": [-10, -2], "label": "C" },
    { "expr": "-3 - 2*sqrt(((1-x)/3)^2 - 1)", "domain": [-10, -2] }
  ],
  "asymptotes": [
    { "kind": "oblique", "expr": "-2*x/3 - 7/3", "label": "y=-\\dfrac{2}{3}x-\\dfrac{7}{3}" },
    { "kind": "oblique", "expr": "2*x/3 - 11/3", "label": "y=\\dfrac{2}{3}x-\\dfrac{11}{3}" }
  ],
  "points": [
    { "x": -2, "y": -3, "label": "(-2,\\ -3)", "kind": "point" }
  ]
}$$::jsonb)
WHERE id = 'c0251003-0000-0000-0000-000000000000'
  AND parts->3->>'label' = 'd';

-- ---------------------------------------------------------------------------
-- FLAG: sketch parts deliberately left without a spec (need spec kinds the
-- renderer does not support yet, or depend on an unknown/abstract function):
--   d0250003 (010:211)  — y = f(x) for unknown f (graph given in booklet)
--   d0250004 (010:272)  — odd-function curve C (defined piecewise/implicitly)
--   d0250006 (010:335)  — f, f^-1, ff^-1 relationship sketch (abstract f)
--   d0250007 (010:376)  — Argand diagram locus
--   d025100a (010:1065) — normal distribution curves X and W
--   c0250001 (014:114)  — area/rectangle illustration sketch
--   c0250003 (014:184)  — curve in terms of parameter b
--   c025100a (014:821)  — scatter diagram
--   a0250004 (015:223)  — piecewise θ–t graph
--   a0250005 (015:251/258) — transformations of unknown f: f(|x|), 1/f(x)
--   a0251003 (015:375)  — Argand diagram points
--   a0251009 (015:981)  — normal curve with shaded region
--   b0250002 (016:88)   — parametric curve with endpoints
--   b0250003 (016:119)  — piecewise periodic f on [-π, 4π)
--   b0250008 (016:337)  — r–t graph (DE solution shape)
--   b0251004 (016:430)  — curve with shaded region R
--   b0251005 (016:474/481/488) — f, 1/f', -f(|x-1|) transformation sketches
