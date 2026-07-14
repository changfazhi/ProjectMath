-- 080_vjc_sketch_graphs.sql
-- Adds solution_graph specs to the VJC (migration 079) sketch answer-parts.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Spec format: see migration 027 header.
-- Every spec compiles through graphService.compileGraph and passes on-curve/in-range checks
-- (validated via backend/vjc_graphs_gen.ts, skills.md §12).
--
-- Reproducible coordinate sketches with concrete data:
--   * P1 Q5(a):  periodic semicircle f(x) for -6<=x<=7 (four arc pieces, period 8).
--   * P1 Q11(c): y=0.14875 e^{x/2} - ln x, min (3,-0.432), roots ~1.34/4.68, VA x=0.
--   * P2 Q9(c):  normal N(4, 4.5^2) for x in [-11,19], dashed mean at x=4.
--   * P2 Q11(a): scatter of the ten (x,y) temperature/electricity points.
--
-- Left sketch-only (documented, no solution_graph) per project convention:
--   * P1 Q8(b)(i)  y=g'(x): "sketch f' from a graph of f" — the abstract g cannot be reproduced by
--     a faithful elementary stand-in (its labelled minimum (-2,-3) is inconsistent with the labelled
--     roots (-1,0)/(-4,0), HA y=3 and VA x=2 for any clean rational). Same call as migrations 044
--     Q2/Q5 and NYJC 077. Every coordinate is stated in the prompt, so nothing is hidden.
--   * P2 Q4(a)  plot Q,R on an Argand diagram for a general argument theta — genuinely abstract
--     (multi-parameter), left sketch-only.

UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [
    -7,
    8
  ],
  "y_range": [
    -1,
    5
  ],
  "curves": [
    {
      "expr": "2+sqrt(4-(x+6)^2)",
      "domain": [
        -6,
        -4
      ],
      "label": "y=\\mathrm{f}(x)"
    },
    {
      "expr": "2-sqrt(4-(x+2)^2)",
      "domain": [
        -4,
        0
      ]
    },
    {
      "expr": "2+sqrt(4-(x-2)^2)",
      "domain": [
        0,
        4
      ]
    },
    {
      "expr": "2-sqrt(4-(x-6)^2)",
      "domain": [
        4,
        7
      ]
    }
  ],
  "points": [
    {
      "x": -6,
      "y": 4,
      "label": "(-6,\\ 4)",
      "kind": "point"
    },
    {
      "x": -4,
      "y": 2,
      "label": "(-4,\\ 2)",
      "kind": "point"
    },
    {
      "x": -2,
      "y": 0,
      "label": "(-2,\\ 0)",
      "kind": "intercept"
    },
    {
      "x": 0,
      "y": 2,
      "label": "(0,\\ 2)",
      "kind": "point"
    },
    {
      "x": 2,
      "y": 4,
      "label": "(2,\\ 4)",
      "kind": "max"
    },
    {
      "x": 4,
      "y": 2,
      "label": "(4,\\ 2)",
      "kind": "point"
    },
    {
      "x": 6,
      "y": 0,
      "label": "(6,\\ 0)",
      "kind": "min"
    },
    {
      "x": 7,
      "y": 0.26795,
      "label": "(7,\\ 2-\\sqrt{3})",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = '50250005-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [
    0,
    6
  ],
  "y_range": [
    -1.5,
    5
  ],
  "curves": [
    {
      "expr": "0.14875*e^(x/2)-log(x)",
      "domain": [
        0.18,
        5.7
      ],
      "label": "y=0.14875\\mathrm{e}^{x/2}-\\ln x"
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
      "x": 3,
      "y": -0.432,
      "label": "(3,\\ -0.432)",
      "kind": "min"
    },
    {
      "x": 1.34,
      "y": 0,
      "label": "1.34",
      "kind": "intercept"
    },
    {
      "x": 4.68,
      "y": 0,
      "label": "4.68",
      "kind": "intercept"
    }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '5025000b-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [
    -11,
    19
  ],
  "y_range": [
    0,
    0.1
  ],
  "curves": [
    {
      "expr": "e^(-(x-4)^2/(2*4.5^2))/(4.5*sqrt(2*pi))",
      "domain": [
        -11,
        19
      ],
      "label": "X\\sim\\mathrm{N}(4,\\ 4.50^{2})"
    }
  ],
  "segments": [
    {
      "from": [
        4,
        0
      ],
      "to": [
        4,
        0.0886
      ],
      "style": "dashed"
    }
  ],
  "points": [
    {
      "x": 4,
      "y": 0,
      "label": "4",
      "kind": "point"
    }
  ],
  "x_label": "x"
}$$::jsonb)
WHERE id = '50251009-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [
    18,
    40
  ],
  "y_range": [
    10,
    31
  ],
  "curves": [],
  "points": [
    {
      "x": 20,
      "y": 12.5,
      "kind": "point"
    },
    {
      "x": 22,
      "y": 12.8,
      "kind": "point"
    },
    {
      "x": 24,
      "y": 13.2,
      "kind": "point"
    },
    {
      "x": 26,
      "y": 14,
      "kind": "point"
    },
    {
      "x": 28,
      "y": 14.7,
      "kind": "point"
    },
    {
      "x": 30,
      "y": 16.2,
      "kind": "point"
    },
    {
      "x": 32,
      "y": 16.2,
      "kind": "point"
    },
    {
      "x": 34,
      "y": 19.9,
      "kind": "point"
    },
    {
      "x": 36,
      "y": 22.3,
      "kind": "point"
    },
    {
      "x": 38,
      "y": 29.5,
      "kind": "point"
    }
  ],
  "x_label": "x\\,(^{\\circ}\\mathrm{C})",
  "y_label": "y\\,(\\mathrm{MWh})"
}$$::jsonb)
WHERE id = '5025100b-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';


