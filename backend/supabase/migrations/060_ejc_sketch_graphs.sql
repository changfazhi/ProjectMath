-- 060_ejc_sketch_graphs.sql
-- Adds solution_graph specs to the EJC sketch parts left without one in 059.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Specs use small insets near
-- vertical asymptotes (matching 032's convention) and are meant to be re-checked through
-- graphService.compileGraph before shipping (labelled min/max/intercept points verified on-curve).
-- Spec format: see migration 027 header.
-- P2 Q6(a) (probability tree diagram) is intentionally NOT covered here — it isn't a coordinate
-- graph, so it's exempt from solution_graph per skills.md §12.

-- P1 Q4: stand-in f(u) = 2*((u-4)/u)^2 for u>0 (taking k=2) — turning point (4,0), vertical
-- asymptote u=0, horizontal asymptote y=k=2, matching the given y=f(2x) diagram (turning point
-- (2,0), asymptotes x=0, y=k).

-- Q4(a) y=f(2x+4)=2*(x/(x+2))^2: turning point (0,0), VA x=-2, HA y=k.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-6, 10],
  "y_range": [-1, 10],
  "curves": [
    {
      "expr": "2*(x/(x+2))^2",
      "domain": [-1.9, 10],
      "label": "y=f(2x+4)"
    }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": -2, "label": "x=-2" },
    { "kind": "horizontal", "expr": "2", "label": "y=k" }
  ],
  "points": [
    { "x": 0, "y": 0, "label": "(0,\\ 0)", "kind": "min" }
  ]
}$$::jsonb)
WHERE id = '90250004-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- Q4(b) y=1/f(2x)=0.5*(x/(x-2))^2, domain x>0: VA x=2, HA y=1/k, open point (0,0) (domain excludes x=0).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-1, 10],
  "y_range": [-1, 10],
  "curves": [
    {
      "expr": "0.5*(x/(x-2))^2",
      "domain": [0.001, 1.9]
    },
    {
      "expr": "0.5*(x/(x-2))^2",
      "domain": [2.1, 10],
      "label": "y=\\dfrac{1}{f(2x)}"
    }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 2, "label": "x=2" },
    { "kind": "horizontal", "expr": "0.5", "label": "y=\\dfrac{1}{k}" }
  ],
  "points": [
    { "x": 0, "y": 0, "label": "(0,\\ 0)", "kind": "point", "open": true }
  ]
}$$::jsonb)
WHERE id = '90250004-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- Q4(c) y=-f(|x|): x>0 branch -2*((x-4)/x)^2, x<0 branch -2*((x+4)/x)^2 (even symmetry then
-- reflected in x-axis): turning points (±4,0), pole at x=0, HA y=-k.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-10, 10],
  "y_range": [-10, 2],
  "curves": [
    {
      "expr": "-2*((x+4)/x)^2",
      "domain": [-10, -0.1]
    },
    {
      "expr": "-2*((x-4)/x)^2",
      "domain": [0.1, 10],
      "label": "y=-f(|x|)"
    }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 0, "label": "x=0" },
    { "kind": "horizontal", "expr": "-2", "label": "y=-k" }
  ],
  "points": [
    { "x": -4, "y": 0, "label": "(-4,\\ 0)", "kind": "max" },
    { "x": 4, "y": 0, "label": "(4,\\ 0)", "kind": "max" }
  ]
}$$::jsonb)
WHERE id = '90250004-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- P2 Q3(a): C1: y=(x²-8x+28)/(2-x)=6-x-16/(x-2), VA x=2, oblique asymptote y=6-x, local
-- min-like point (-2,12) and local max-like point (6,-4). C2: ellipse centre (6,0), a=4, b=5.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-6, 14],
  "y_range": [-8, 16],
  "curves": [
    {
      "expr": "6-x-16/(x-2)",
      "domain": [-6, 1.9]
    },
    {
      "expr": "6-x-16/(x-2)",
      "domain": [2.1, 14],
      "label": "C_1"
    },
    {
      "x_expr": "6+4*cos(t)",
      "y_expr": "5*sin(t)",
      "domain": [0, 6.283185307179586],
      "label": "C_2"
    }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 2, "label": "x=2" },
    { "kind": "oblique", "expr": "6-x", "label": "y=6-x" }
  ],
  "points": [
    { "x": -2, "y": 12, "label": "(-2,\\ 12)", "kind": "min" },
    { "x": 6, "y": -4, "label": "(6,\\ -4)", "kind": "max" },
    { "x": 2, "y": 0, "label": "(2,\\ 0)", "kind": "point" },
    { "x": 10, "y": 0, "label": "(10,\\ 0)", "kind": "point" },
    { "x": 6, "y": 5, "label": "(6,\\ 5)", "kind": "point" },
    { "x": 6, "y": -5, "label": "(6,\\ -5)", "kind": "point" },
    { "x": 6, "y": 0, "label": "(6,\\ 0)", "kind": "point" }
  ]
}$$::jsonb)
WHERE id = '90251003-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- P2 Q7(b): scatter of the given (x,y) data table (7 points).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [0, 15],
  "y_range": [0, 11],
  "curves": [],
  "points": [
    { "x": 7, "y": 1.1, "kind": "point" },
    { "x": 8, "y": 5.7, "kind": "point" },
    { "x": 9, "y": 9.3, "kind": "point" },
    { "x": 10, "y": 9.8, "kind": "point" },
    { "x": 11, "y": 8.6, "kind": "point" },
    { "x": 12, "y": 6.4, "kind": "point" },
    { "x": 13, "y": 0.9, "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '90251007-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';
