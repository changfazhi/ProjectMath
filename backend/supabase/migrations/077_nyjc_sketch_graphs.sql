-- 077_nyjc_sketch_graphs.sql
-- Adds solution_graph specs to the NYJC (migration 076) sketch parts.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Spec format: see migration 027 header.
-- Every spec is intended to compile through graphService.compileGraph (skills.md §12).
--
-- Reproducible coordinate sketches with concrete data get a solution_graph below:
--   * P1 Q12(c): B against t for B=100(11/10)^t (concrete exponential).
--   * P2 Q10(b): scatter of the ten (a,t) points with the regression line t on a.
--
-- The remaining sketch parts are left sketch-only (documented here, no solution_graph):
--   * P1 Q4(a)  y=f(a-x): abstract f with five free-parameter labelled points (A..E) — no faithful
--     stand-in (skills.md §12 accepts sketch-only for genuinely abstract multi-parameter sketches).
--   * P1 Q4(b)(i)/(ii)  y=|g(x)| / y=g(|x|): abstract g with two distinct horizontal asymptotes and a
--     vertical asymptote — not expressible by an elementary stand-in; left sketch-only.
--   * P2 Q3(a): Riemann-rectangle illustration of a limit — an illustrative (non-coordinate) diagram,
--     not a model curve; skipped per skills.md §12.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q12(c): B=100(11/10)^t, increasing exponential from (0,100). Part index 2, label "c".
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 25],
  "y_range": [0, 1100],
  "curves": [
    { "expr": "100*(11/10)^x", "domain": [0, 24], "label": "B=100\\left(\\dfrac{11}{10}\\right)^{t}" }
  ],
  "points": [
    { "x": 0, "y": 100, "label": "(0,\\ 100)", "kind": "point" }
  ],
  "x_label": "t",
  "y_label": "B"
}$$::jsonb)
WHERE id = '6025000c-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q10(b): scatter of the ten (a,t) data points with the regression line t=0.8957914a+14.16013.
-- Part index 1, label "b". (k=40 so the fifth point is (22,40).)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [15, 82],
  "y_range": [10, 95],
  "curves": [
    { "expr": "0.8957914*x+14.16013", "domain": [15, 82], "label": "t=0.8957914a+14.16013" }
  ],
  "points": [
    { "x": 21, "y": 20, "kind": "point" },
    { "x": 56, "y": 70, "kind": "point" },
    { "x": 42, "y": 56, "kind": "point" },
    { "x": 77, "y": 75, "kind": "point" },
    { "x": 22, "y": 40, "kind": "point" },
    { "x": 34, "y": 42, "kind": "point" },
    { "x": 40, "y": 50, "kind": "point" },
    { "x": 41, "y": 52, "kind": "point" },
    { "x": 48, "y": 60, "kind": "point" },
    { "x": 47, "y": 60, "kind": "point" }
  ],
  "x_label": "a",
  "y_label": "t"
}$$::jsonb)
WHERE id = '6025100a-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';
