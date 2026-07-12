-- 069_jpjc_sketch_graphs.sql
-- Adds solution_graph specs to the JPJC (migration 068) sketch parts.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Spec format: see migration 027 header.
-- Every spec validated through graphService.compileGraph before shipping.
-- Abstract "possible scatter" sketches (P2 Q11 a(i)/a(ii)) are intentionally NOT covered — any
-- arrangement of 7 points satisfies them, so there is no faithful stand-in (skills.md §12).
-- Abstract-parameter curves use a representative value, noted per spec.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q2(b): y=1/(x-a)^2 (VA x=a) and y=|x-a| (V-vertex (a,0)), representative a=2.
-- Meet at x=a±1 (here (1,1),(3,1)); region 1/(x-a)^2>|x-a| is a-1<x<a+1, x!=a.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-1, 5],
  "y_range": [0, 6],
  "curves": [
    { "expr": "1/(x-2)^2", "domain": [-1, 1.9] },
    { "expr": "1/(x-2)^2", "domain": [2.1, 5], "label": "y=\\dfrac{1}{(x-a)^2}" },
    { "expr": "abs(x-2)", "domain": [-1, 5], "label": "y=|x-a|" }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 2, "label": "x=a" }
  ],
  "points": [
    { "x": 1, "y": 1, "label": "(a-1,\\ 1)", "kind": "point" },
    { "x": 3, "y": 1, "label": "(a+1,\\ 1)", "kind": "point" },
    { "x": 0, "y": 0.25, "label": "\\left(0,\\ \\tfrac{1}{a^2}\\right)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '80250002-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- P1 Q5(a)(i): hyperbola x^2/9-y^2/4=1 (vertices (±3,0), asymptotes y=±2x/3) and circle
-- x^2+y^2=k^2 — representative k=5 (>=3 so they intersect), intercepts (±5,0),(0,±5).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-8, 8],
  "y_range": [-8, 8],
  "curves": [
    { "x_expr": "3/cos(t)", "y_expr": "2*tan(t)", "domain": [-1.3, 1.3], "label": "C_1" },
    { "x_expr": "-3/cos(t)", "y_expr": "2*tan(t)", "domain": [-1.3, 1.3] },
    { "x_expr": "5*cos(t)", "y_expr": "5*sin(t)", "domain": [0, 6.283185307179586], "label": "C_2" }
  ],
  "asymptotes": [
    { "kind": "oblique", "expr": "2/3*x", "label": "y=\\dfrac{2}{3}x" },
    { "kind": "oblique", "expr": "-2/3*x", "label": "y=-\\dfrac{2}{3}x" }
  ],
  "points": [
    { "x": 3, "y": 0, "label": "(3,\\ 0)", "kind": "point" },
    { "x": -3, "y": 0, "label": "(-3,\\ 0)", "kind": "point" },
    { "x": 5, "y": 0, "label": "(k,\\ 0)", "kind": "point" },
    { "x": -5, "y": 0, "label": "(-k,\\ 0)", "kind": "point" },
    { "x": 0, "y": 5, "label": "(0,\\ k)", "kind": "point" },
    { "x": 0, "y": -5, "label": "(0,\\ -k)", "kind": "point" }
  ]
}$$::jsonb)
WHERE id = '80250005-0000-0000-0000-000000000000' AND parts->0->>'label' = 'ai';

-- P1 Q5(b)(ii): periodic piecewise f over -5<=x<=5, continuous zigzag with
-- vertices (-5,6),(-2,0),(0,6),(3,0),(5,6).
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${
  "x_range": [-6, 6],
  "y_range": [-1, 7],
  "curves": [
    { "expr": "-2*x-4", "domain": [-5, -2] },
    { "expr": "3*x+6", "domain": [-2, 0] },
    { "expr": "-2*x+6", "domain": [0, 3] },
    { "expr": "3*x-9", "domain": [3, 5], "label": "y=f(x)" }
  ],
  "points": [
    { "x": -5, "y": 6, "label": "(-5,\\ 6)", "kind": "point" },
    { "x": -2, "y": 0, "label": "(-2,\\ 0)", "kind": "point" },
    { "x": 0, "y": 6, "label": "(0,\\ 6)", "kind": "point" },
    { "x": 3, "y": 0, "label": "(3,\\ 0)", "kind": "point" },
    { "x": 5, "y": 6, "label": "(5,\\ 6)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '80250005-0000-0000-0000-000000000000' AND parts->4->>'label' = 'bii';

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1(c): x against t, x=P(1-e^{-kt}) — representative P=1, k=0.5. Rises from O,
-- concave down, to horizontal asymptote x=P.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 10],
  "y_range": [0, 1.2],
  "curves": [
    { "expr": "1-e^(-0.5*x)", "domain": [0, 10], "label": "x=P(1-e^{-kt})" }
  ],
  "asymptotes": [
    { "kind": "horizontal", "expr": "1", "label": "x=P" }
  ],
  "points": [
    { "x": 0, "y": 0, "label": "O", "kind": "point" }
  ],
  "x_label": "t",
  "y_label": "x"
}$$::jsonb)
WHERE id = '80251001-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- P2 Q4(b): Argand diagram. Z1(-1,2), Z2(2,1), Z3=Z1+Z2=(1,3); OZ2Z3Z1 is a square.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-3, 3],
  "y_range": [-1, 4],
  "curves": [],
  "segments": [
    { "from": [0, 0], "to": [-1, 2], "arrow": true },
    { "from": [0, 0], "to": [2, 1], "arrow": true },
    { "from": [0, 0], "to": [1, 3], "arrow": true, "style": "dashed" },
    { "from": [-1, 2], "to": [1, 3] },
    { "from": [2, 1], "to": [1, 3] }
  ],
  "points": [
    { "x": -1, "y": 2, "label": "Z_1(-1,\\ 2)", "kind": "point" },
    { "x": 2, "y": 1, "label": "Z_2(2,\\ 1)", "kind": "point" },
    { "x": 1, "y": 3, "label": "Z_3(1,\\ 3)", "kind": "point" },
    { "x": 0, "y": 0, "label": "O", "kind": "point" }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = '80251004-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- P2 Q11(b)(i): scatter of the eight (d,p) rail data points.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 210],
  "y_range": [0, 200],
  "curves": [],
  "points": [
    { "x": 124, "y": 156, "kind": "point" },
    { "x": 44, "y": 53, "kind": "point" },
    { "x": 76, "y": 99, "kind": "point" },
    { "x": 148, "y": 169, "kind": "point" },
    { "x": 16, "y": 23, "kind": "point" },
    { "x": 180, "y": 177, "kind": "point" },
    { "x": 104, "y": 138, "kind": "point" },
    { "x": 195, "y": 178, "kind": "point" }
  ],
  "x_label": "d",
  "y_label": "p"
}$$::jsonb)
WHERE id = '8025100b-0000-0000-0000-000000000000' AND parts->2->>'label' = 'bi';
