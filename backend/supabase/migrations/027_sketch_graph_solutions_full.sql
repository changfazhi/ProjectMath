-- 027_sketch_graph_solutions_full.sql
-- Adds `solution_graph` specs to EVERY remaining sketch/draw part across all
-- 6 papers (40 parts), plus data fixes for four questions whose stored text
-- disagreed with the official 2025 solutions. Data-only — no DDL.
--
-- Spec format (compiled by graphService.compileGraph; exprs are mathjs,
-- evaluated only on the backend; labels are LaTeX rendered by KaTeX):
--   { "x_range", "y_range",
--     "curves": [{ "expr", "domain" }                      -- y = f(x)
--              | { "x_expr", "y_expr", "domain" }],        -- parametric (t)
--     "asymptotes": [{ "kind", "x"|"expr", "label"? }],
--     "points": [{ "x", "y", "label"?, "kind"?, "open"? }],-- open = hollow dot
--     "segments": [{ "from", "to", "style"?, "arrow"?, "label"? }],
--     "shade": [{ "expr", "domain", "label"? }],           -- fill to x-axis
--     "x_label"?, "y_label"? }                             -- axis labels
--
-- Every spec was cross-checked against the official school solutions in
-- 2025/<school>/. "Stand-in" in a comment means the question's function is
-- abstract, and a concrete curve was constructed to pass exactly through all
-- officially-labelled features. Compiled output snaps labelled points onto
-- the polyline, so all coordinates below were verified to lie on the curves.
--
-- Errata for migration 024's FLAG comment (its line numbers were right but
-- 16 of 17 question ids were stale). Correct ids:
--   d0250005 (f from f'/|f|), d0250006 (odd parametric), d0250007 (f/f^-1),
--   d0250008 (Argand ellipse), d025100a (normal curves), c0250004 (Riemann),
--   c0250006 (curve in b), c0251007 (scatter), a0250007 (theta-t),
--   a0250008 (f(|x|), 1/f), a025000a (Argand parallelogram),
--   a025100c (normal + shade), b0250003 (parametric), b0250004 (periodic),
--   b0250009 (r-t), b025000b (shade R), b0251001 (f, 1/f', -f(|x-1|)).
--
-- Still without a spec (deliberate — not meaningful as coordinate graphs):
--   b0251006 part (a)  — Venn diagram
--   c0250004 part (a)  — Riemann-rectangles reasoning sketch

-- ──────────────────────────────────────────────────────────────────────────
-- DHS
-- ──────────────────────────────────────────────────────────────────────────

-- d0250005 part (c): DHS P1 Q5(c). Official (P1 soln p8): VA x=0, oblique
-- y=x+3 (left, from below), HA y=3 (right, from below), max (-2,-2), min
-- (1.5,-1), x-ints (1,0),(2.5,0). Stand-in: exponential tails + Hermite
-- cubics through the official features.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-8, 8],
  "y_range": [-8, 8],
  "curves": [
    {
      "expr": "x + 3 - 3*e^((x+2)/3)",
      "domain": [-8, -2]
    },
    {
      "expr": "-2 - (x+2)^2/(-x)",
      "domain": [-2, -0.02]
    },
    {
      "expr": "(1 - x)*(3 + 1/x)",
      "domain": [0.02, 1]
    },
    {
      "expr": "4*(x-1)^2 - 4*(x-1)",
      "domain": [1, 1.5]
    },
    {
      "expr": "-1 + 2*(x-1.5)^2 - (x-1.5)^3",
      "domain": [1.5, 2.5]
    },
    {
      "expr": "3 - 3*e^(-(x-2.5)/3)",
      "domain": [2.5, 8],
      "label": "y=f(x)"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    },
    {
      "kind": "oblique",
      "expr": "x + 3",
      "label": "y=x+3"
    },
    {
      "kind": "horizontal",
      "expr": "3",
      "label": "y=3"
    }
  ],
  "points": [
    {
      "x": -2,
      "y": -2,
      "label": "(-2,\\ -2)",
      "kind": "max"
    },
    {
      "x": 1,
      "y": 0,
      "label": "(1,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 1.5,
      "y": -1,
      "label": "(1.5,\\ -1)",
      "kind": "min"
    },
    {
      "x": 2.5,
      "y": 0,
      "label": "(2.5,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'd0250005-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- d0250005 part (d): DHS P1 Q5(d). Official (P1 soln p8): y=|f(x)| (reflected
-- stand-in from (c)) with asymptotes y=-x-3, y=3, x=0; line y=kx+3k through
-- (-3,0) drawn for k=-1/2. Answer: -1 <= k < 0.
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [-8, 8],
  "y_range": [-6, 8],
  "curves": [
    {
      "expr": "-(x + 3) + 3*e^((x+2)/3)",
      "domain": [-8, -2]
    },
    {
      "expr": "2 + (x+2)^2/(-x)",
      "domain": [-2, -0.02]
    },
    {
      "expr": "(1 - x)*(3 + 1/x)",
      "domain": [0.02, 1]
    },
    {
      "expr": "4*(x-1) - 4*(x-1)^2",
      "domain": [1, 1.5]
    },
    {
      "expr": "1 - 2*(x-1.5)^2 + (x-1.5)^3",
      "domain": [1.5, 2.5]
    },
    {
      "expr": "3 - 3*e^(-(x-2.5)/3)",
      "domain": [2.5, 8],
      "label": "y=|f(x)|"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    },
    {
      "kind": "oblique",
      "expr": "-x - 3",
      "label": "y=-x-3"
    },
    {
      "kind": "horizontal",
      "expr": "3",
      "label": "y=3"
    }
  ],
  "segments": [
    {
      "from": [-8, 2.5],
      "to": [7, -5],
      "label": "y=kx+3k"
    }
  ],
  "points": [
    {
      "x": -3,
      "y": 0,
      "label": "(-3,\\ 0)",
      "kind": "point"
    },
    {
      "x": -2,
      "y": 2,
      "label": "(-2,\\ 2)",
      "kind": "min"
    },
    {
      "x": 1,
      "y": 0,
      "label": "(1,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 1.5,
      "y": 1,
      "label": "(1.5,\\ 1)",
      "kind": "max"
    },
    {
      "x": 2.5,
      "y": 0,
      "label": "(2.5,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'd0250005-0000-0000-0000-000000000000'
  AND parts->3->>'label' = 'd';

-- d0250006 part (c): DHS P1 Q6(c). Official (P1 soln p10): odd curve y =
-- x*sqrt(a^2+x^2)/a with OPEN endpoints (a, sqrt(2)a) and (-a, -sqrt(2)a).
-- Drawn for a=1.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-1.6, 1.6],
  "y_range": [-2.2, 2.2],
  "curves": [
    {
      "expr": "x*sqrt(1 + x^2)",
      "domain": [-1, 1],
      "label": "y=\\dfrac{x\\sqrt{a^2+x^2}}{a}"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 1.4142,
      "label": "(a,\\ \\sqrt{2}a)",
      "kind": "point",
      "open": true
    },
    {
      "x": -1,
      "y": -1.4142,
      "label": "(-a,\\ -\\sqrt{2}a)",
      "kind": "point",
      "open": true
    },
    {
      "x": 0,
      "y": 0,
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'd0250006-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- d0250007 part (di): DHS P1 Q7(d)(i). Official (P1 soln p12): f (x>0, open
-- at (0,1.5)), f^-1 as the reflection (plotted parametrically as x=f(t),
-- y=t), ff^-1 = y=x on (1.5,inf); dashed construction lines through
-- (1.5,1.5).
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [0, 5],
  "y_range": [0, 5],
  "curves": [
    {
      "expr": "e^x + 1/(2*x + 2)",
      "domain": [0, 1.7],
      "label": "y=f(x)"
    },
    {
      "x_expr": "e^t + 1/(2*t + 2)",
      "y_expr": "t",
      "domain": [0, 1.7],
      "label": "y=f^{-1}(x)"
    },
    {
      "expr": "x",
      "domain": [1.5, 5],
      "label": "y=ff^{-1}(x)"
    }
  ],
  "segments": [
    {
      "from": [0, 1.5],
      "to": [1.5, 1.5],
      "style": "dashed"
    },
    {
      "from": [1.5, 0],
      "to": [1.5, 1.5],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 1.5,
      "kind": "point",
      "open": true
    },
    {
      "x": 1.5,
      "y": 0,
      "kind": "point",
      "open": true
    },
    {
      "x": 1.5,
      "y": 1.5,
      "label": "(1.5,\\ 1.5)",
      "kind": "point",
      "open": true
    }
  ]
}$$::jsonb)
WHERE id = 'd0250007-0000-0000-0000-000000000000'
  AND parts->3->>'label' = 'di';

-- d0250008 part (a): DHS P1 Q8(a). Official (P1 soln p14): ellipse x^2/4 +
-- y^2/9 = 1 on the Argand plane, intercepts (±2,0), (0,±3).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-3.4, 3.4],
  "y_range": [-4, 4],
  "curves": [
    {
      "x_expr": "2*cos(t)",
      "y_expr": "3*sin(t)",
      "domain": [0, 6.2832],
      "label": "\\dfrac{x^2}{4}+\\dfrac{y^2}{9}=1"
    }
  ],
  "points": [
    {
      "x": 2,
      "y": 0,
      "label": "(2,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": -2,
      "y": 0,
      "label": "(-2,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 0,
      "y": 3,
      "label": "(0,\\ 3)",
      "kind": "intercept"
    },
    {
      "x": 0,
      "y": -3,
      "label": "(0,\\ -3)",
      "kind": "intercept"
    }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = 'd0250008-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- d0251009 part (bi): DHS P2 Q9(b)(i). Scatter of the data table in the
-- question: y falls sharply then levels off.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [0, 22],
  "y_range": [0, 100],
  "points": [
    {
      "x": 3,
      "y": 92,
      "kind": "point"
    },
    {
      "x": 5,
      "y": 50,
      "kind": "point"
    },
    {
      "x": 8,
      "y": 33,
      "kind": "point"
    },
    {
      "x": 10,
      "y": 25,
      "kind": "point"
    },
    {
      "x": 13,
      "y": 21,
      "kind": "point"
    },
    {
      "x": 15,
      "y": 19,
      "kind": "point"
    },
    {
      "x": 18,
      "y": 17,
      "kind": "point"
    },
    {
      "x": 20,
      "y": 16,
      "kind": "point"
    }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = 'd0251009-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'bi';

-- d025100a part (d): DHS P2 Q10(d). Official (P2 soln p17): two bells on one
-- axis — W ~ N(85,80) taller/narrower, X ~ N(95,9.53^2) shorter/wider; dashed
-- verticals at the means.
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [50, 130],
  "y_range": [0, 0.05],
  "curves": [
    {
      "expr": "e^(-(x-95)^2/(2*9.53^2))/(9.53*sqrt(2*pi))",
      "domain": [50, 130]
    },
    {
      "expr": "e^(-(x-85)^2/(2*80))/(sqrt(80)*sqrt(2*pi))",
      "domain": [50, 130]
    }
  ],
  "segments": [
    {
      "from": [95, 0],
      "to": [95, 0.041857],
      "style": "dashed"
    },
    {
      "from": [85, 0],
      "to": [85, 0.044603],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 95,
      "y": 0.041857,
      "label": "X",
      "kind": "max"
    },
    {
      "x": 85,
      "y": 0.044603,
      "label": "W",
      "kind": "max"
    },
    {
      "x": 85,
      "y": 0,
      "label": "85",
      "kind": "point"
    },
    {
      "x": 95,
      "y": 0,
      "label": "95",
      "kind": "point"
    }
  ],
  "x_label": "t\\ \\text{(min)}"
}$$::jsonb)
WHERE id = 'd025100a-0000-0000-0000-000000000000'
  AND parts->3->>'label' = 'd';

-- ──────────────────────────────────────────────────────────────────────────
-- CJC
-- ──────────────────────────────────────────────────────────────────────────

-- b0250003 part (a): CJC P1 Q3(a). Official (P1 key p4): parametric x=sin^2
-- t, y=1+2 sin t; endpoints (1,3),(1,-1) FILLED (examiners penalised open
-- circles), y-intercept (0,1).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-0.4, 1.6],
  "y_range": [-1.8, 3.8],
  "curves": [
    {
      "x_expr": "sin(t)^2",
      "y_expr": "1 + 2*sin(t)",
      "domain": [-1.5708, 1.5708],
      "label": "C"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 3,
      "label": "(1,\\ 3)",
      "kind": "point"
    },
    {
      "x": 1,
      "y": -1,
      "label": "(1,\\ -1)",
      "kind": "point"
    },
    {
      "x": 0,
      "y": 1,
      "label": "(0,\\ 1)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'b0250003-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- b0250004 part (a): CJC P1 Q4(a). Official (P1 key p6): periodic pieces on
-- [-pi,4pi); solid dots at (0,2),(2pi,2), hollow at (2pi,0),(4pi,0); zeros at
-- odd multiples of pi; dashed jump line at x=2pi.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-3.8, 13.2],
  "y_range": [-5.2, 3],
  "curves": [
    {
      "expr": "(x + 2*pi)*sin(x)",
      "domain": [-3.14159265358979, -0.02]
    },
    {
      "expr": "2 - 2*x/pi",
      "domain": [0, 3.14159265358979]
    },
    {
      "expr": "x*sin(x)",
      "domain": [3.14159265358979, 6.27318530717958]
    },
    {
      "expr": "2 - 2*(x - 2*pi)/pi",
      "domain": [6.28318530717958, 9.42477796076937],
      "label": "y=f(x)"
    },
    {
      "expr": "(x - 2*pi)*sin(x)",
      "domain": [9.42477796076937, 12.55637061435916]
    }
  ],
  "segments": [
    {
      "from": [6.28318530717958, 0],
      "to": [6.28318530717958, 2],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": -3.14159265358979,
      "y": 0,
      "label": "(-\\pi,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 0,
      "y": 2,
      "label": "(0,\\ 2)",
      "kind": "point"
    },
    {
      "x": 3.14159265358979,
      "y": 0,
      "label": "(\\pi,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 6.28318530717958,
      "y": 0,
      "label": "(2\\pi,\\ 0)",
      "kind": "point",
      "open": true
    },
    {
      "x": 6.28318530717958,
      "y": 2,
      "label": "(2\\pi,\\ 2)",
      "kind": "point"
    },
    {
      "x": 9.42477796076937,
      "y": 0,
      "label": "(3\\pi,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 12.56637061435916,
      "y": 0,
      "label": "(4\\pi,\\ 0)",
      "kind": "point",
      "open": true
    }
  ]
}$$::jsonb)
WHERE id = 'b0250004-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- b0250009 part (c): CJC P1 Q9(c). Official (P1 key p22): increasing from
-- (0,1) to dashed HA r=10; axes t and r. Drawn with k=0.15 (k>0 unspecified
-- in the answer).
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 40],
  "y_range": [0, 12],
  "curves": [
    {
      "expr": "sqrt(100 - 99*e^(-0.15*x))",
      "domain": [0, 40],
      "label": "r=\\sqrt{100-99e^{-kt}}"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "10",
      "label": "r=10"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 1,
      "label": "(0,\\ 1)",
      "kind": "intercept"
    }
  ],
  "x_label": "t",
  "y_label": "r"
}$$::jsonb)
WHERE id = 'b0250009-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- b025000b part (bi): CJC P1 Q11(b)(i). Official (P1 key p27): curve from
-- (0,0) up to a peak then decaying to HA y=0; R shaded between curve, x-axis
-- and dashed line x=4.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 8],
  "y_range": [0, 0.5],
  "curves": [
    {
      "expr": "3*x^2/((x+1)*(3*x^2+x+1))",
      "domain": [0, 8],
      "label": "y=\\dfrac{3x^2}{(x+1)(3x^2+x+1)}"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "shade": [
    {
      "expr": "3*x^2/((x+1)*(3*x^2+x+1))",
      "domain": [0, 4],
      "label": "R"
    }
  ],
  "segments": [
    {
      "from": [4, 0],
      "to": [4, 0.18113],
      "style": "dashed",
      "label": "x=4"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 0,
      "label": "(0,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'b025000b-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'bi';

-- b0251001 part (a): CJC P2 Q1(a). Official (P2 key p3): f has VA x=1, HA y=2
-- (below on the left, above on the right), passes through O, x-int (2,0), max
-- (3,4). Stand-in: 2-2/(1-x) | 2-2/(x-1) | Hermite cubic | 2+2/(1+(x-3)^2).
-- f(0)=0 needed so (c) has its labelled (1,0).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-6, 8],
  "y_range": [-6, 8],
  "curves": [
    {
      "expr": "2 - 2/(1 - x)",
      "domain": [-6, 1]
    },
    {
      "expr": "2 - 2/(x - 1)",
      "domain": [1, 2]
    },
    {
      "expr": "2*(x-2) + 8*(x-2)^2 - 6*(x-2)^3",
      "domain": [2, 3]
    },
    {
      "expr": "2 + 2/(1 + (x-3)^2)",
      "domain": [3, 8],
      "label": "y=f(x)"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 1,
      "label": "x=1"
    },
    {
      "kind": "horizontal",
      "expr": "2",
      "label": "y=2"
    }
  ],
  "points": [
    {
      "x": 2,
      "y": 0,
      "label": "(2,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 3,
      "y": 4,
      "label": "(3,\\ 4)",
      "kind": "max"
    },
    {
      "x": 0,
      "y": 0,
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'b0251001-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- b0251001 part (b): CJC P2 Q1(b). Official (P2 key p4): y=1/f'(x) through
-- (1,0), VA x=3, max in the 4th quadrant, down to -inf on the far left and
-- far right. Derived from the same stand-in as (a).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-6, 8],
  "y_range": [-6, 6],
  "curves": [
    {
      "expr": "-(1 - x)^2/2",
      "domain": [-6, 1]
    },
    {
      "expr": "(x - 1)^2/2",
      "domain": [1, 2]
    },
    {
      "expr": "1/(2 + 16*(x-2) - 18*(x-2)^2)",
      "domain": [2, 3]
    },
    {
      "expr": "-(1 + (x-3)^2)^2/(8*(x-3))",
      "domain": [3, 8],
      "label": "y=\\dfrac{1}{f'(x)}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 3,
      "label": "x=3"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 0,
      "label": "(1,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'b0251001-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- b0251001 part (c): CJC P2 Q1(c). Official (P2 key p5): y=-f(|x-1|): VAs
-- x=0, x=2, HA y=-2, x-ints (-1,0),(1,0),(3,0), minima (-2,-4),(4,-4). Same
-- stand-in transformed.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-6, 8],
  "y_range": [-7, 7],
  "curves": [
    {
      "expr": "-(2 + 2/(1 + (-x-2)^2))",
      "domain": [-6, -2]
    },
    {
      "expr": "-(2*(-1-x) + 8*(-1-x)^2 - 6*(-1-x)^3)",
      "domain": [-2, -1]
    },
    {
      "expr": "-2 - 2/x",
      "domain": [-1, -0.02]
    },
    {
      "expr": "-2 + 2/(1 - abs(x-1))",
      "domain": [0, 2]
    },
    {
      "expr": "-2 + 2/(x - 2)",
      "domain": [2, 3]
    },
    {
      "expr": "-(2*(x-3) + 8*(x-3)^2 - 6*(x-3)^3)",
      "domain": [3, 4]
    },
    {
      "expr": "-(2 + 2/(1 + (x-4)^2))",
      "domain": [4, 8],
      "label": "y=-f(|x-1|)"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    },
    {
      "kind": "vertical",
      "x": 2,
      "label": "x=2"
    },
    {
      "kind": "horizontal",
      "expr": "-2",
      "label": "y=-2"
    }
  ],
  "points": [
    {
      "x": -1,
      "y": 0,
      "label": "(-1,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 1,
      "y": 0,
      "label": "(1,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 3,
      "y": 0,
      "label": "(3,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": -2,
      "y": -4,
      "label": "(-2,\\ -4)",
      "kind": "min"
    },
    {
      "x": 4,
      "y": -4,
      "label": "(4,\\ -4)",
      "kind": "min"
    }
  ]
}$$::jsonb)
WHERE id = 'b0251001-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- b0251002 part (a): CJC P2 Q2(a). f(x)=4/(x-4)^2: VA x=4, HA y=0, y-int (0,
-- 1/4), no turning points.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-4, 12],
  "y_range": [0, 6],
  "curves": [
    {
      "expr": "4/(x - 4)^2",
      "domain": [-4, 12],
      "label": "y=\\dfrac{4}{(x-4)^2}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 4,
      "label": "x=4"
    },
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 0.25,
      "label": "(0,\\ \\tfrac{1}{4})",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'b0251002-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- b0251004 part (c): CJC P2 Q4(c). Official (P2 key p14): four roots on a
-- labelled Argand diagram forming a trapezium: 3±i and (1±i)/2. Axes labelled
-- Re/Im (examiners insisted).
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-1, 4.2],
  "y_range": [-2, 2],
  "segments": [
    {
      "from": [0.5, 0.5],
      "to": [3, 1]
    },
    {
      "from": [3, 1],
      "to": [3, -1]
    },
    {
      "from": [3, -1],
      "to": [0.5, -0.5]
    },
    {
      "from": [0.5, -0.5],
      "to": [0.5, 0.5]
    }
  ],
  "points": [
    {
      "x": 3,
      "y": 1,
      "label": "3+\\mathrm{i}",
      "kind": "point"
    },
    {
      "x": 3,
      "y": -1,
      "label": "3-\\mathrm{i}",
      "kind": "point"
    },
    {
      "x": 0.5,
      "y": 0.5,
      "label": "\\tfrac{1}{2}+\\tfrac{1}{2}\\mathrm{i}",
      "kind": "point"
    },
    {
      "x": 0.5,
      "y": -0.5,
      "label": "\\tfrac{1}{2}-\\tfrac{1}{2}\\mathrm{i}",
      "kind": "point"
    }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = 'b0251004-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- ──────────────────────────────────────────────────────────────────────────
-- HCI
-- ──────────────────────────────────────────────────────────────────────────

-- c0250006 part (b): HCI P1 Q6(b). Official (P1 soln p9): low bump, HA y=0,
-- y-int (0,1), max (-b/8, 16/(16-b^2)); no VAs since 0<b<4. Drawn for b=2
-- (max (-1/4, 4/3)); labels kept symbolic.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-4, 4],
  "y_range": [0, 1.8],
  "curves": [
    {
      "expr": "1/(4*x^2 + 2*x + 1)",
      "domain": [-4, 4],
      "label": "y=\\dfrac{1}{4x^2+bx+1}"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 1,
      "label": "(0,\\ 1)",
      "kind": "intercept"
    },
    {
      "x": -0.25,
      "y": 1.33333,
      "label": "\\left(-\\tfrac{b}{8},\\ \\tfrac{16}{16-b^2}\\right)",
      "kind": "max"
    }
  ]
}$$::jsonb)
WHERE id = 'c0250006-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- c0251004 part (aiii): HCI P2 Q4(a)(iii). Official (P2 soln p8): a, b, c
-- drawn from O at 120° to each other; triangle ABC equilateral. Drawn with a,
-- b lower-left/right and c up.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-1.4, 1.4],
  "y_range": [-1, 1.5],
  "segments": [
    {
      "from": [0, 0],
      "to": [-0.866, -0.5],
      "arrow": true,
      "label": "\\mathbf{a}"
    },
    {
      "from": [0, 0],
      "to": [0.866, -0.5],
      "arrow": true,
      "label": "\\mathbf{b}"
    },
    {
      "from": [0, 0],
      "to": [0, 1],
      "arrow": true,
      "label": "\\mathbf{c}"
    },
    {
      "from": [-0.866, -0.5],
      "to": [0.866, -0.5]
    },
    {
      "from": [0.866, -0.5],
      "to": [0, 1]
    },
    {
      "from": [0, 1],
      "to": [-0.866, -0.5]
    }
  ],
  "points": [
    {
      "x": -0.866,
      "y": -0.5,
      "label": "A",
      "kind": "point"
    },
    {
      "x": 0.866,
      "y": -0.5,
      "label": "B",
      "kind": "point"
    },
    {
      "x": 0,
      "y": 1,
      "label": "C",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'c0251004-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'aiii';

-- c0251007 part (c): HCI P2 Q7(c). Scatter of the question data: rising,
-- curving upward.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 10],
  "y_range": [0, 26],
  "points": [
    {
      "x": 1,
      "y": 14,
      "kind": "point"
    },
    {
      "x": 4,
      "y": 15,
      "kind": "point"
    },
    {
      "x": 5,
      "y": 15,
      "kind": "point"
    },
    {
      "x": 6,
      "y": 16,
      "kind": "point"
    },
    {
      "x": 7,
      "y": 18,
      "kind": "point"
    },
    {
      "x": 8,
      "y": 21,
      "kind": "point"
    },
    {
      "x": 9,
      "y": 23,
      "kind": "point"
    }
  ],
  "x_label": "t",
  "y_label": "s"
}$$::jsonb)
WHERE id = 'c0251007-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- ──────────────────────────────────────────────────────────────────────────
-- ASRJC
-- ──────────────────────────────────────────────────────────────────────────

-- cafe0008 part (b): ASRJC P1 Q10(b). Official (P1 soln p21): f = 2x - 1/(2x)
-- on (0,2) with VA x=0, OPEN endpoint (2, 15/4); f^-1 the reflection (HA y=0,
-- open endpoint (15/4, 2)); line y=x. f^-1 plotted parametrically.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-4, 5],
  "y_range": [-4, 5],
  "curves": [
    {
      "expr": "2*x - 1/(2*x)",
      "domain": [0.02, 2],
      "label": "y=f(x)"
    },
    {
      "x_expr": "2*t - 1/(2*t)",
      "y_expr": "t",
      "domain": [0.02, 2],
      "label": "y=f^{-1}(x)"
    },
    {
      "expr": "x",
      "domain": [-4, 5],
      "label": "y=x"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    },
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "points": [
    {
      "x": 2,
      "y": 3.75,
      "label": "\\left(2,\\ \\tfrac{15}{4}\\right)",
      "kind": "point",
      "open": true
    },
    {
      "x": 3.75,
      "y": 2,
      "label": "\\left(\\tfrac{15}{4},\\ 2\\right)",
      "kind": "point",
      "open": true
    },
    {
      "x": 0.5,
      "y": 0,
      "kind": "intercept"
    },
    {
      "x": 0,
      "y": 0.5,
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'cafe0008-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- cafe1004 part (c): ASRJC P2 Q4(c). Official (P2 soln p5): rosette C from
-- (0, 3/2) to (3/2, 0) with an inner loop; ellipse D centred (2,0), semi-axes
-- sqrt(k) and 3/2. Drawn for k=0.2. NOTE: official D is x = 2 + sqrt(k) cos θ
-- — the stored prompt/answer had k/k² typos, fixed in this migration.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-0.3, 3],
  "y_range": [-1.8, 1.8],
  "curves": [
    {
      "x_expr": "cos(t) + 0.5*cos(5*t)",
      "y_expr": "sin(t) + 0.5*sin(5*t)",
      "domain": [0, 1.5707963267949],
      "label": "C"
    },
    {
      "x_expr": "2 + sqrt(0.2)*cos(t)",
      "y_expr": "1.5*sin(t)",
      "domain": [0, 6.2831853071796],
      "label": "D"
    }
  ],
  "points": [
    {
      "x": 1.5,
      "y": 0,
      "label": "\\left(\\tfrac{3}{2},\\ 0\\right)",
      "kind": "point"
    },
    {
      "x": 0,
      "y": 1.5,
      "label": "\\left(0,\\ \\tfrac{3}{2}\\right)",
      "kind": "point"
    },
    {
      "x": 1.5528,
      "y": 0,
      "label": "2-\\sqrt{k}",
      "kind": "point"
    },
    {
      "x": 2.4472,
      "y": 0,
      "label": "2+\\sqrt{k}",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'cafe1004-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- cafe1005 part (bi): ASRJC P2 Q5(b)(i). Official (P2 soln p7): y = |e^x - 2|
-- with HA y=2 (dashed), y-int (0,1), cusp (ln 2, 0).
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-3, 2],
  "y_range": [0, 5],
  "curves": [
    {
      "expr": "abs(e^x - 2)",
      "domain": [-3, 1.9],
      "label": "y=|e^x-2|"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "2",
      "label": "y=2"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 1,
      "label": "(0,\\ 1)",
      "kind": "intercept"
    },
    {
      "x": 0.69315,
      "y": 0,
      "label": "(\\ln 2,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'cafe1005-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'bi';

-- cafe1006 part (b): ASRJC P2 Q6(b). Official (P2 soln p8): rays from O to P
-- (arg pi/4, |p|=2) and Q (arg 2pi/3, |q|=2). NOTE: official p = sqrt2 +
-- sqrt2 i — the stored 2+2i broke parts (d)/(e); fixed in this migration.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-2.2, 2.2],
  "y_range": [-0.4, 2.4],
  "segments": [
    {
      "from": [0, 0],
      "to": [1.41421, 1.41421],
      "style": "dashed"
    },
    {
      "from": [0, 0],
      "to": [-1, 1.73205],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 1.41421,
      "y": 1.41421,
      "label": "P",
      "kind": "point"
    },
    {
      "x": -1,
      "y": 1.73205,
      "label": "Q",
      "kind": "point"
    }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = 'cafe1006-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- cafe1008 part (a): ASRJC P2 Q8(a). Scatter of the question data:
-- decreasing, concave up.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [0, 5],
  "y_range": [0, 130],
  "points": [
    {
      "x": 1.5,
      "y": 119,
      "kind": "point"
    },
    {
      "x": 1.8,
      "y": 108,
      "kind": "point"
    },
    {
      "x": 2.1,
      "y": 100,
      "kind": "point"
    },
    {
      "x": 2.4,
      "y": 95,
      "kind": "point"
    },
    {
      "x": 2.5,
      "y": 93,
      "kind": "point"
    },
    {
      "x": 3.1,
      "y": 88,
      "kind": "point"
    },
    {
      "x": 3.5,
      "y": 86,
      "kind": "point"
    },
    {
      "x": 4.2,
      "y": 85,
      "kind": "point"
    }
  ],
  "x_label": "t",
  "y_label": "S"
}$$::jsonb)
WHERE id = 'cafe1008-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- ──────────────────────────────────────────────────────────────────────────
-- RI
-- ──────────────────────────────────────────────────────────────────────────

-- e0250005 part (ai): RI P1 Q5(a)(i). Official (P1 soln p8): f' has zeros
-- (1,0),(4,0), VAs x=0, x=2, HA y=0; positive rising to +inf at 0-, -inf at
-- 0+ through (1,0) to +inf at 2-, +inf at 2+ through (4,0) dipping then back
-- to 0-. Stand-in built from these features.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-6, 10],
  "y_range": [-6, 6],
  "curves": [
    {
      "expr": "0.3/(-x)",
      "domain": [-6, -0.02]
    },
    {
      "expr": "2*(x - 1)/(x*(2 - x))",
      "domain": [0, 2]
    },
    {
      "expr": "3*(4 - x)/(x - 2)^2",
      "domain": [2, 10],
      "label": "y=f'(x)"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    },
    {
      "kind": "vertical",
      "x": 2,
      "label": "x=2"
    },
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 0,
      "label": "(1,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 4,
      "y": 0,
      "label": "(4,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'e0250005-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'ai';

-- e0250005 part (aii): RI P1 Q5(a)(ii). Official (P1 soln p8): 1/f has VAs
-- x=1 (twin +inf), x=3 (sign change), HA y=1/2, min (4, 1/4), OPEN circles at
-- O and (2,0). Stand-in from features.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-6, 10],
  "y_range": [-4, 4],
  "curves": [
    {
      "expr": "-0.5*x/(1 - x)",
      "domain": [-6, -0.02]
    },
    {
      "expr": "0.4*x/(1 - x)^2",
      "domain": [0, 1]
    },
    {
      "expr": "0.4*(2 - x)/(x - 1)^2",
      "domain": [1, 2]
    },
    {
      "expr": "-0.4*(x - 2)/(3 - x)^2",
      "domain": [2, 3]
    },
    {
      "expr": "0.5 + 0.25/(x - 3)^2 - 0.5/(x - 3)",
      "domain": [3, 10],
      "label": "y=\\dfrac{1}{f(x)}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 1,
      "label": "x=1"
    },
    {
      "kind": "vertical",
      "x": 3,
      "label": "x=3"
    },
    {
      "kind": "horizontal",
      "expr": "0.5",
      "label": "y=\\tfrac{1}{2}"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 0,
      "kind": "point",
      "open": true
    },
    {
      "x": 2,
      "y": 0,
      "label": "(2,\\ 0)",
      "kind": "point",
      "open": true
    },
    {
      "x": 4,
      "y": 0.25,
      "label": "(4,\\ \\tfrac{1}{4})",
      "kind": "min"
    }
  ]
}$$::jsonb)
WHERE id = 'e0250005-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'aii';

-- e0250007 part (b): RI P1 Q7(b). Official (P1 soln p15): parabola arm
-- 2(x-1)^2+2 for x<=0 down to sharp point (0,4), then V-shape 2+|2-x| with
-- min (2,2) and filled endpoint (3,3).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-2, 4.5],
  "y_range": [0, 8],
  "curves": [
    {
      "expr": "2*(x - 1)^2 + 2",
      "domain": [-2, 0]
    },
    {
      "expr": "2 + abs(2 - x)",
      "domain": [0, 3],
      "label": "y=g(x)"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 4,
      "label": "(0,\\ 4)",
      "kind": "point"
    },
    {
      "x": 2,
      "y": 2,
      "label": "(2,\\ 2)",
      "kind": "min"
    },
    {
      "x": 3,
      "y": 3,
      "label": "(3,\\ 3)",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'e0250007-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- e0250008 part (aii): RI P1 Q8(a)(ii). Official (P1 soln p18): dashed rays
-- OQ (through P) and OR with OR = OQ rotated 90° anticlockwise; right angle
-- at O. Drawn for w=2+i, k=1.5.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-3, 4],
  "y_range": [-0.6, 4],
  "segments": [
    {
      "from": [0, 0],
      "to": [3, 1.5],
      "style": "dashed"
    },
    {
      "from": [0, 0],
      "to": [-1.5, 3],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 2,
      "y": 1,
      "label": "P",
      "kind": "point"
    },
    {
      "x": 3,
      "y": 1.5,
      "label": "Q",
      "kind": "point"
    },
    {
      "x": -1.5,
      "y": 3,
      "label": "R",
      "kind": "point"
    }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = 'e0250008-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'aii';

-- e0250009 part (c): RI P1 Q9(c). C = 50e^(q arctan t), q = -0.62285:
-- decreasing from (0,50) to HA C = 50e^(q pi/2) ≈ 18.8.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 60],
  "y_range": [0, 60],
  "curves": [
    {
      "expr": "50*e^(-0.62285*atan(x))",
      "domain": [0, 60],
      "label": "C=50e^{q\\tan^{-1}t}"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "50*e^(-0.62285*pi/2)",
      "label": "C\\approx 18.8"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 50,
      "label": "(0,\\ 50)",
      "kind": "intercept"
    }
  ],
  "x_label": "t",
  "y_label": "C"
}$$::jsonb)
WHERE id = 'e0250009-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'c';

-- e0250010 part (bi): RI P1 Q10(b)(i). y = 2 - x/sqrt(2x-1): VA x=1/2, max
-- (1,1), x-intercepts 4±2sqrt(3).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [0, 12],
  "y_range": [-4, 3],
  "curves": [
    {
      "expr": "2 - x/sqrt(2*x - 1)",
      "domain": [0.5, 12],
      "label": "y=2-\\dfrac{x}{\\sqrt{2x-1}}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0.5,
      "label": "x=\\tfrac{1}{2}"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 1,
      "label": "(1,\\ 1)",
      "kind": "max"
    },
    {
      "x": 0.5359,
      "y": 0,
      "label": "x=4-2\\sqrt{3}",
      "kind": "intercept"
    },
    {
      "x": 7.4641,
      "y": 0,
      "label": "x=4+2\\sqrt{3}",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'e0250010-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'bi';

-- e0250010 part (cii): RI P1 Q10(c)(ii). The (b)(i) curve plus the parabola
-- x=2(y-1)^2+1 as two branches y = 1 ± sqrt((x-1)/2); vertex (1,1),
-- lower-branch x-intercept (3,0).
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${
  "x_range": [0, 12],
  "y_range": [-4, 4],
  "curves": [
    {
      "expr": "2 - x/sqrt(2*x - 1)",
      "domain": [0.5, 12],
      "label": "y=2-\\dfrac{x}{\\sqrt{2x-1}}"
    },
    {
      "expr": "1 + sqrt((x - 1)/2)",
      "domain": [1, 12],
      "label": "x=2(y-1)^2+1"
    },
    {
      "expr": "1 - sqrt((x - 1)/2)",
      "domain": [1, 12]
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0.5,
      "label": "x=\\tfrac{1}{2}"
    }
  ],
  "points": [
    {
      "x": 1,
      "y": 1,
      "label": "(1,\\ 1)",
      "kind": "max"
    },
    {
      "x": 3,
      "y": 0,
      "label": "(3,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 0.5359,
      "y": 0,
      "label": "x=4-2\\sqrt{3}",
      "kind": "intercept"
    },
    {
      "x": 7.4641,
      "y": 0,
      "label": "x=4+2\\sqrt{3}",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'e0250010-0000-0000-0000-000000000000'
  AND parts->4->>'label' = 'cii';

-- e0251001 part (bi): RI P2 Q1(b)(i). y = ln x (VA x=0) and y = x-5 on one
-- diagram; intersections x = 0.00678 and x = 6.94.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-1, 9.5],
  "y_range": [-6, 4],
  "curves": [
    {
      "expr": "log(x)",
      "domain": [0.001, 9.5],
      "label": "y=\\ln x"
    },
    {
      "expr": "x - 5",
      "domain": [-1, 9.5],
      "label": "y=x-5"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 0,
      "label": "x=0"
    }
  ],
  "points": [
    {
      "x": 0.00678,
      "y": -4.99322,
      "label": "x=0.00678",
      "kind": "point"
    },
    {
      "x": 6.94,
      "y": 1.94,
      "label": "x=6.94",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'e0251001-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'bi';

-- e0251008 part (a): RI P2 Q8(a). Scatter of the 7 data points from the
-- question (P=(4.4,100) is the outlier, labelled only in part (b)).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [0, 5],
  "y_range": [0, 300],
  "points": [
    {
      "x": 2,
      "y": 280,
      "kind": "point"
    },
    {
      "x": 2.2,
      "y": 250,
      "kind": "point"
    },
    {
      "x": 2.5,
      "y": 190,
      "kind": "point"
    },
    {
      "x": 3,
      "y": 150,
      "kind": "point"
    },
    {
      "x": 4,
      "y": 90,
      "kind": "point"
    },
    {
      "x": 4.4,
      "y": 100,
      "kind": "point"
    },
    {
      "x": 4.5,
      "y": 70,
      "kind": "point"
    }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = 'e0251008-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- ──────────────────────────────────────────────────────────────────────────
-- ACJC
-- ──────────────────────────────────────────────────────────────────────────

-- a0250007 part (b): ACJC P1 Q7(b). Official (P1 soln p6): theta = 25 +
-- 60e^(-0.0347t), decreasing from (0,85) to dashed HA theta=25.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [0, 120],
  "y_range": [0, 95],
  "curves": [
    {
      "expr": "25 + 60*e^(-0.0347*x)",
      "domain": [0, 120],
      "label": "\\theta=25+60e^{-kt}"
    }
  ],
  "asymptotes": [
    {
      "kind": "horizontal",
      "expr": "25",
      "label": "\\theta=25"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 85,
      "label": "(0,\\ 85)",
      "kind": "intercept"
    }
  ],
  "x_label": "t",
  "y_label": "\\theta"
}$$::jsonb)
WHERE id = 'a0250007-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- a0250008 part (ai): ACJC P1 Q8(a)(i). Official (P1 soln p6): y=f(|x|) is an
-- M-shape with a dip at (0,c) and FILLED endpoints (-b,0),(b,0). Stand-in: f
-- = -(x+2)(x-4)/2 (a=-2, b=4, c=4), symbolic labels kept.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-5.5, 5.5],
  "y_range": [-1, 6],
  "curves": [
    {
      "expr": "-(abs(x) + 2)*(abs(x) - 4)/2",
      "domain": [-4, 4],
      "label": "y=f(|x|)"
    }
  ],
  "points": [
    {
      "x": -4,
      "y": 0,
      "label": "(-b,\\ 0)",
      "kind": "point"
    },
    {
      "x": 4,
      "y": 0,
      "label": "(b,\\ 0)",
      "kind": "point"
    },
    {
      "x": 0,
      "y": 4,
      "label": "(0,\\ c)",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'a0250008-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'ai';

-- a0250008 part (aii): ACJC P1 Q8(a)(ii). Official (P1 soln p7, Fig 1):
-- y=1/f(x) only for x<=b (f undefined beyond) — left branch to -inf at x=a-,
-- central U between VAs x=a, x=b with y-int (0,1/c); NO branch right of x=b.
-- Same stand-in.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-6, 6],
  "y_range": [-4, 4],
  "curves": [
    {
      "expr": "-2/((x + 2)*(x - 4))",
      "domain": [-6, 4],
      "label": "y=\\dfrac{1}{f(x)}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": -2,
      "label": "x=a"
    },
    {
      "kind": "vertical",
      "x": 4,
      "label": "x=b"
    },
    {
      "kind": "horizontal",
      "expr": "0",
      "label": "y=0"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 0.25,
      "label": "\\left(0,\\ \\tfrac{1}{c}\\right)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'a0250008-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'aii';

-- a025000a part (bii): ACJC P1 Q10(b)(ii). Official (P1 soln p12):
-- parallelogram OACB — A: u (|u|=2, arg 3pi/4), B: v (|v|=3, arg theta in
-- (0,pi/4), longer than OA), C: u+v; dashed sides AC, BC. Drawn for theta =
-- pi/8.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [-2.5, 4],
  "y_range": [-0.6, 3.6],
  "segments": [
    {
      "from": [0, 0],
      "to": [-1.4142, 1.4142],
      "arrow": true
    },
    {
      "from": [0, 0],
      "to": [2.7716, 1.1481],
      "arrow": true
    },
    {
      "from": [0, 0],
      "to": [1.3574, 2.5623],
      "arrow": true
    },
    {
      "from": [-1.4142, 1.4142],
      "to": [1.3574, 2.5623],
      "style": "dashed"
    },
    {
      "from": [2.7716, 1.1481],
      "to": [1.3574, 2.5623],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": -1.4142,
      "y": 1.4142,
      "label": "A:\\ u",
      "kind": "point"
    },
    {
      "x": 2.7716,
      "y": 1.1481,
      "label": "B:\\ v",
      "kind": "point"
    },
    {
      "x": 1.3574,
      "y": 2.5623,
      "label": "C:\\ u+v",
      "kind": "point"
    }
  ],
  "x_label": "\\mathrm{Re}(z)",
  "y_label": "\\mathrm{Im}(z)"
}$$::jsonb)
WHERE id = 'a025000a-0000-0000-0000-000000000000'
  AND parts->2->>'label' = 'bii';

-- a025100a part (a): ACJC P2 Q10(a). Bamboo scatter from the question data:
-- rising, concave-down.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [0, 10],
  "y_range": [0, 18],
  "points": [
    {
      "x": 1,
      "y": 3.6,
      "kind": "point"
    },
    {
      "x": 2,
      "y": 7.4,
      "kind": "point"
    },
    {
      "x": 3,
      "y": 10.2,
      "kind": "point"
    },
    {
      "x": 4,
      "y": 11.7,
      "kind": "point"
    },
    {
      "x": 5,
      "y": 12.6,
      "kind": "point"
    },
    {
      "x": 7,
      "y": 14.1,
      "kind": "point"
    },
    {
      "x": 8,
      "y": 14.5,
      "kind": "point"
    },
    {
      "x": 9,
      "y": 15.5,
      "kind": "point"
    }
  ],
  "x_label": "t",
  "y_label": "h"
}$$::jsonb)
WHERE id = 'a025100a-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- a025100c part (a): ACJC P2 Q12(a). Official (P2 soln p14): bell T ~ N(2,
-- 0.2^2) with the area between 1.2 and 2.8 shaded (virtually all of it);
-- dashed line at the mean.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [1, 3],
  "y_range": [0, 2.3],
  "curves": [
    {
      "expr": "e^(-(x - 2)^2/(2*0.2^2))/(0.2*sqrt(2*pi))",
      "domain": [1, 3],
      "label": "T\\sim N(2,\\ 0.2^2)"
    }
  ],
  "shade": [
    {
      "expr": "e^(-(x - 2)^2/(2*0.2^2))/(0.2*sqrt(2*pi))",
      "domain": [1.2, 2.8]
    }
  ],
  "segments": [
    {
      "from": [2, 0],
      "to": [2, 1.99471],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 1.2,
      "y": 0,
      "label": "1.2",
      "kind": "point"
    },
    {
      "x": 2.8,
      "y": 0,
      "label": "2.8",
      "kind": "point"
    }
  ],
  "x_label": "t"
}$$::jsonb)
WHERE id = 'a025100c-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'a';

-- ──────────────────────────────────────────────────────────────────────────
-- CJC
-- ──────────────────────────────────────────────────────────────────────────

-- b0251009 part (b): CJC P2 Q9(b). Scatter of the 7 data points (alpha = 67
-- at h = 10.5): decreasing, concave-down... official: decreasing; drawn from
-- the question data.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [0, 30],
  "y_range": [0, 80],
  "points": [
    {
      "x": 8.5,
      "y": 68,
      "kind": "point"
    },
    {
      "x": 10.5,
      "y": 67,
      "kind": "point"
    },
    {
      "x": 14,
      "y": 61,
      "kind": "point"
    },
    {
      "x": 17,
      "y": 58,
      "kind": "point"
    },
    {
      "x": 20,
      "y": 44,
      "kind": "point"
    },
    {
      "x": 23,
      "y": 31,
      "kind": "point"
    },
    {
      "x": 27,
      "y": 12,
      "kind": "point"
    }
  ],
  "x_label": "h",
  "y_label": "s"
}$$::jsonb)
WHERE id = 'b0251009-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

-- ──────────────────────────────────────────────────────────────────────────
-- DATA FIXES — stored text that disagreed with the official 2025 solutions
-- ──────────────────────────────────────────────────────────────────────────

-- DHS P1 Q5 (d0250005): the preamble's description of the given y=|f(x)|
-- graph was wrong (official: VA x=0; oblique y=-x-3; HA y=3; |f| does NOT
-- pass through (-3,0); (-2,2) is a local MIN and (1.5,1) a local MAX of |f|),
-- and solution (c) claimed max (-2,2) — official sketch shows max (-2,-2) and
-- states y=-x-3 is not an asymptote of y=f(x).
UPDATE questions
SET prompt_latex = replace(prompt_latex,
  $$The graph of \(y = |\mathrm{f}(x)|\) has asymptotes \(y = x+3\) and \(y = -x-3\), horizontal asymptote \(y = 3\), passing through \((-3,0)\), \((1,0)\), \((2.5,0)\) with a local minimum at \((1.5, 1)\) and local maximum at \((-2, 2)\).$$,
  $$The graph of \(y = |\mathrm{f}(x)|\) has vertical asymptote \(x = 0\), oblique asymptote \(y = -x-3\) and horizontal asymptote \(y = 3\), touching the \(x\)-axis at \((1,0)\) and \((2.5,0)\), with a local minimum at \((-2, 2)\) and a local maximum at \((1.5, 1)\).$$)
WHERE id = 'd0250005-0000-0000-0000-000000000000';

UPDATE questions
SET solution_latex = replace(solution_latex,
  $$(c) \(y = \mathrm{f}(x)\): asymptotes \(y = x+3\), \(y = -x-3\) (for \(x < 0\)); crosses at \((-3,0)\), \((1,0)\), \((2.5,0)\) if below \(x\)-axis between; local max at \((-2,2)\) (since \(|\mathrm{f}(-2)| = 2\) with \(\mathrm{f}(-2) = -2\) or \(2\)); local min at \((1.5,-1)\).$$,
  $$(c) \(y = \mathrm{f}(x)\): vertical asymptote \(x = 0\); oblique asymptote \(y = x+3\) (as \(x \to -\infty\)); horizontal asymptote \(y = 3\) (as \(x \to +\infty\)); crosses the \(x\)-axis at \((1,0)\) and \((2.5,0)\); local maximum \((-2,-2)\); local minimum \((1.5,-1)\). Note that \(y = -x-3\) is an asymptote of \(y = |\mathrm{f}(x)|\) but not of \(y = \mathrm{f}(x)\).$$)
WHERE id = 'd0250005-0000-0000-0000-000000000000';

-- ASRJC P2 Q4 (cafe1004): official curve D is x = 2 + sqrt(k) cos(theta), so
-- the cartesian equation is (x-2)^2/k + 4y^2/9 = 1 (semi-axis sqrt(k), not k).
-- The stored preamble/answer/part-(d) prompt mixed k and k^2.
UPDATE questions
SET prompt_latex = replace(prompt_latex, $$x = 2 + k\cos\theta$$, $$x = 2 + \sqrt{k}\cos\theta$$)
WHERE id = 'cafe1004-0000-0000-0000-000000000000';

UPDATE questions
SET parts = jsonb_set(parts, '{1,correct_answer}',
  to_jsonb($$\frac{(x-2)^2}{k} + \frac{4y^2}{9} = 1$$::text))
WHERE id = 'cafe1004-0000-0000-0000-000000000000'
  AND parts->1->>'label' = 'b';

UPDATE questions
SET parts = jsonb_set(parts, '{3,prompt_latex}',
  to_jsonb(replace(parts->3->>'prompt_latex', $$5t - 2)^2}{k^2}$$, $$5t - 2)^2}{k}$$)))
WHERE id = 'cafe1004-0000-0000-0000-000000000000'
  AND parts->3->>'label' = 'd';

UPDATE questions
SET solution_latex = $$(a) When \(t=0\): \(x = 1+\frac{1}{2} = \frac{3}{2}\), \(y = 0\). Point: \(\left(\frac{3}{2}, 0\right)\).

(b) \(\cos\theta = \dfrac{x-2}{\sqrt{k}}\), \(\sin\theta = \dfrac{2y}{3}\). Using \(\cos^2\theta+\sin^2\theta=1\):
\[\frac{(x-2)^2}{k} + \frac{4y^2}{9} = 1\]
This is an ellipse centred at \((2, 0)\) with semi-axes \(\sqrt{k}\) (horizontal) and \(\frac{3}{2}\) (vertical).

(c) Curve \(C\) is a rosette-like curve running from \(\left(0, \frac{3}{2}\right)\) (at \(t = \frac{\pi}{2}\)) to \(\left(\frac{3}{2}, 0\right)\) (at \(t = 0\)) with a small inner loop. Ellipse \(D\) is centred at \((2,0)\), extending from \(2-\sqrt{k}\) to \(2+\sqrt{k}\) horizontally and \(-\frac{3}{2}\) to \(\frac{3}{2}\) vertically.

(d) The equation has no real solutions exactly when \(C\) and \(D\) do not intersect: the leftmost point of \(D\) must lie to the right of the rightmost point of \(C\):
\[2 - \sqrt{k} > \frac{3}{2} \implies \sqrt{k} < \frac{1}{2} \implies 0 < k < \frac{1}{4}.\]$$
WHERE id = 'cafe1004-0000-0000-0000-000000000000';

-- ASRJC P2 Q5 (cafe1005): part (a)(i)'s integrand is (1-2x)/sqrt(3+2x-x^2)
-- in the official paper (the stored prompt dropped the square root; the
-- stored final answer was already the sqrt version's). Also removes draft
-- "Wait — checking" text left in the stored solution.
UPDATE questions
SET parts = jsonb_set(parts, '{0,prompt_latex}',
  to_jsonb(replace(parts->0->>'prompt_latex', $$\frac{1 - 2x}{3 + 2x - x^2}$$, $$\frac{1 - 2x}{\sqrt{3 + 2x - x^2}}$$)))
WHERE id = 'cafe1005-0000-0000-0000-000000000000'
  AND parts->0->>'label' = 'ai';

UPDATE questions
SET solution_latex = $$(a)(i) Complete the square: \(3+2x-x^2 = 4-(x-1)^2\), and write \(1-2x = (2-2x) - 1\):
\[\int\frac{1-2x}{\sqrt{3+2x-x^2}}\,dx = \int\frac{2-2x}{\sqrt{3+2x-x^2}}\,dx - \int\frac{1}{\sqrt{2^2-(x-1)^2}}\,dx\]
\[= 2\sqrt{3+2x-x^2} - \sin^{-1}\!\left(\frac{x-1}{2}\right) + C\]

(a)(ii) Integration by parts with \(u = \ln(2-x^2)\), \(dv = x\,dx\):
\[\int x\ln(2-x^2)\,dx = \frac{x^2}{2}\ln(2-x^2) + \int\frac{x^3}{2-x^2}\,dx = \frac{x^2}{2}\ln(2-x^2) + \int\left(-x + \frac{2x}{2-x^2}\right)dx\]
\[= \frac{x^2}{2}\ln(2-x^2) - \frac{x^2}{2} - \ln(2-x^2) + C = \left(\frac{x^2}{2}-1\right)\ln(2-x^2) - \frac{x^2}{2} + C\]

(b)(i) \(e^x - 2 = 0\) at \(x = \ln 2\), so \(y = |e^x-2|\) touches the \(x\)-axis at \((\ln 2, 0)\), has \(y\)-intercept \((0,1)\), and horizontal asymptote \(y = 2\) (as \(x \to -\infty\), \(e^x \to 0\) so \(|e^x - 2| \to 2\)).

(b)(ii) Splitting at \(x = \ln 2\):
\[\int_0^{\ln 3}|e^x-2|\,dx = \int_0^{\ln 2}(2-e^x)\,dx + \int_{\ln 2}^{\ln 3}(e^x-2)\,dx = \left[2x - e^x\right]_0^{\ln 2} + \left[e^x - 2x\right]_{\ln 2}^{\ln 3}\]
\[= (2\ln 2 - 2) - (-1) + (3 - 2\ln 3) - (2 - 2\ln 2) = 4\ln 2 - 2\ln 3\]$$
WHERE id = 'cafe1005-0000-0000-0000-000000000000';

-- ASRJC P2 Q6 (cafe1006): official p = sqrt(2) + sqrt(2)i (|p| = |q| = 2, so
-- OPRQ is a RHOMBUS and the diagonal bisects the angle — which is exactly
-- what part (e) relies on). The stored p = 2+2i broke (d) and (e); the (e)
-- target constant is 2, not sqrt(2).
UPDATE questions
SET prompt_latex = replace(prompt_latex, $$p = 2 + 2i$$, $$p = \sqrt{2} + \sqrt{2}i$$)
WHERE id = 'cafe1006-0000-0000-0000-000000000000';

UPDATE questions
SET parts = jsonb_set(parts, '{4,prompt_latex}',
  to_jsonb(replace(parts->4->>'prompt_latex', $$\sqrt{6} + \sqrt{3} + \sqrt{2} + \sqrt{2}$$, $$\sqrt{6} + \sqrt{3} + \sqrt{2} + 2$$)))
WHERE id = 'cafe1006-0000-0000-0000-000000000000'
  AND parts->4->>'label' = 'e';

UPDATE questions
SET solution_latex = $$(a) \(|p| = \sqrt{2+2} = 2\). \(\arg(p) = \tan^{-1}\!\left(\frac{\sqrt{2}}{\sqrt{2}}\right) = \frac{\pi}{4}\).

(b) \(P\) is at \((\sqrt{2}, \sqrt{2})\) (distance 2 from \(O\) at angle \(\frac{\pi}{4}\)); \(Q\) is at distance 2 from \(O\) at angle \(\frac{2\pi}{3}\), in the second quadrant.

(c) \(q = 2\!\left(\cos\frac{2\pi}{3} + i\sin\frac{2\pi}{3}\right) = 2\!\left(-\frac{1}{2} + i\frac{\sqrt{3}}{2}\right) = -1 + \sqrt{3}\,i\).
\(\operatorname{Re}(q) = -1\), \(\operatorname{Im}(q) = \sqrt{3}\).

(d) \(|p| = |q| = 2\), so the parallelogram \(OPRQ\) (with \(R = p+q\)) has all sides equal: it is a rhombus.

(e) In a rhombus the diagonal bisects the angle at the vertex, so
\[\arg(p+q) = \frac{1}{2}\!\left(\arg p + \arg q\right) = \frac{1}{2}\!\left(\frac{\pi}{4}+\frac{2\pi}{3}\right) = \frac{11\pi}{24}.\]
Also \(p + q = (\sqrt{2}-1) + (\sqrt{2}+\sqrt{3})i\), so
\[\tan\frac{11\pi}{24} = \frac{\sqrt{2}+\sqrt{3}}{\sqrt{2}-1} = \frac{(\sqrt{2}+\sqrt{3})(\sqrt{2}+1)}{(\sqrt{2}-1)(\sqrt{2}+1)} = 2+\sqrt{2}+\sqrt{6}+\sqrt{3} = \sqrt{6}+\sqrt{3}+\sqrt{2}+2. \text{ (shown)}\]$$
WHERE id = 'cafe1006-0000-0000-0000-000000000000';
