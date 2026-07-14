-- 081_vjc_prompt_graphs.sql
-- Adds question-level prompt_graph specs for the VJC (migration 079) questions whose prompt shows a
-- GIVEN diagram. Same spec format as solution_graph; compiled by compileGraph and attached to the
-- PUBLIC payload (stripSolution), rendered in the prompt before any attempt. Data-only, no DDL
-- (prompt_graph column added in migration 061). All specs validated via backend/vjc_graphs_gen.ts.
--
--   * P1 Q9 (50250009): region bounded by the sideways parabola x=6-(y-2)^2, the lines y=8, y=2-x and
--     the y-axis; regions R and S labelled, passing through (6,2).
--   * P2 Q8 (50251008): concentric target board, radii 12/24/40 cm, regions Gold/Red/Blue.
--   * P2 Q2 (50251002): trapezoidal prism drawn as a representative oblique projection (segments +
--     vertex labels A..H); the exact dimensions (AB=5x, DC=3x, 60 deg, AE=y) are given in the prose.
--
-- Not reproduced (given diagram, but abstract / prose-complete):
--   * P1 Q8(b) given y=g(x): abstract g with an inconsistent labelled minimum — see migration 080
--     header; all coordinates are stated in the prompt.
--   * P2 Q4 given Argand: only shows a generic point P at argument theta (pi/2<theta<pi); left in prose.

UPDATE questions
SET prompt_graph = $${
  "x_range": [
    -6,
    8
  ],
  "y_range": [
    -2,
    9
  ],
  "curves": [
    {
      "x_expr": "6-(t-2)^2",
      "y_expr": "t",
      "domain": [
        -1.2,
        5.2
      ],
      "label": "x=6-(y-2)^{2}"
    }
  ],
  "segments": [
    {
      "from": [
        -5,
        8
      ],
      "to": [
        7,
        8
      ],
      "label": "y=8"
    },
    {
      "from": [
        -5,
        7
      ],
      "to": [
        4,
        -2
      ],
      "label": "y=2-x"
    },
    {
      "from": [
        0,
        -2
      ],
      "to": [
        0,
        9
      ],
      "style": "dashed"
    },
    {
      "from": [
        2.3,
        4.2
      ],
      "to": [
        2.3,
        4.2
      ],
      "label": "R"
    },
    {
      "from": [
        3.6,
        1.4
      ],
      "to": [
        3.6,
        1.4
      ],
      "label": "S"
    }
  ],
  "points": [
    {
      "x": 6,
      "y": 2,
      "label": "(6,\\ 2)",
      "kind": "point"
    }
  ]
}$$::jsonb
WHERE id = '50250009-0000-0000-0000-000000000000';

UPDATE questions
SET prompt_graph = $${
  "x_range": [
    -45,
    45
  ],
  "y_range": [
    -45,
    45
  ],
  "curves": [
    {
      "x_expr": "12*cos(t)",
      "y_expr": "12*sin(t)",
      "domain": [
        0,
        6.2832
      ]
    },
    {
      "x_expr": "24*cos(t)",
      "y_expr": "24*sin(t)",
      "domain": [
        0,
        6.2832
      ]
    },
    {
      "x_expr": "40*cos(t)",
      "y_expr": "40*sin(t)",
      "domain": [
        0,
        6.2832
      ]
    }
  ],
  "segments": [
    {
      "from": [
        0,
        0
      ],
      "to": [
        40,
        0
      ]
    },
    {
      "from": [
        0,
        5
      ],
      "to": [
        0,
        5
      ],
      "label": "\\text{Gold}"
    },
    {
      "from": [
        0,
        18
      ],
      "to": [
        0,
        18
      ],
      "label": "\\text{Red}"
    },
    {
      "from": [
        0,
        32
      ],
      "to": [
        0,
        32
      ],
      "label": "\\text{Blue}"
    },
    {
      "from": [
        6,
        -3
      ],
      "to": [
        6,
        -3
      ],
      "label": "12"
    },
    {
      "from": [
        18,
        -3
      ],
      "to": [
        18,
        -3
      ],
      "label": "24"
    },
    {
      "from": [
        33,
        -3
      ],
      "to": [
        33,
        -3
      ],
      "label": "40"
    }
  ]
}$$::jsonb
WHERE id = '50251008-0000-0000-0000-000000000000';

UPDATE questions
SET prompt_graph = $${
  "x_range": [
    -2.2,
    6.2
  ],
  "y_range": [
    -3,
    3
  ],
  "curves": [],
  "segments": [
    {
      "from": [
        0,
        0
      ],
      "to": [
        5,
        0
      ]
    },
    {
      "from": [
        5,
        0
      ],
      "to": [
        4,
        1.732
      ]
    },
    {
      "from": [
        4,
        1.732
      ],
      "to": [
        1,
        1.732
      ]
    },
    {
      "from": [
        1,
        1.732
      ],
      "to": [
        0,
        0
      ]
    },
    {
      "from": [
        -0.7,
        -1.7
      ],
      "to": [
        4.3,
        -1.7
      ]
    },
    {
      "from": [
        4.3,
        -1.7
      ],
      "to": [
        3.3,
        0.032
      ]
    },
    {
      "from": [
        3.3,
        0.032
      ],
      "to": [
        0.3,
        0.032
      ],
      "style": "dashed"
    },
    {
      "from": [
        0.3,
        0.032
      ],
      "to": [
        -0.7,
        -1.7
      ],
      "style": "dashed"
    },
    {
      "from": [
        0,
        0
      ],
      "to": [
        -0.7,
        -1.7
      ]
    },
    {
      "from": [
        5,
        0
      ],
      "to": [
        4.3,
        -1.7
      ]
    },
    {
      "from": [
        4,
        1.732
      ],
      "to": [
        3.3,
        0.032
      ]
    },
    {
      "from": [
        1,
        1.732
      ],
      "to": [
        0.3,
        0.032
      ],
      "style": "dashed"
    },
    {
      "from": [
        2.5,
        -0.28
      ],
      "to": [
        2.5,
        -0.28
      ],
      "label": "5x"
    },
    {
      "from": [
        2.5,
        1.95
      ],
      "to": [
        2.5,
        1.95
      ],
      "label": "3x"
    },
    {
      "from": [
        5.05,
        -0.9
      ],
      "to": [
        5.05,
        -0.9
      ],
      "label": "y"
    },
    {
      "from": [
        0.55,
        0.18
      ],
      "to": [
        0.55,
        0.18
      ],
      "label": "60^{\\circ}"
    }
  ],
  "points": [
    {
      "x": 0,
      "y": 0,
      "label": "A",
      "kind": "point"
    },
    {
      "x": 5,
      "y": 0,
      "label": "B",
      "kind": "point"
    },
    {
      "x": 4,
      "y": 1.732,
      "label": "C",
      "kind": "point"
    },
    {
      "x": 1,
      "y": 1.732,
      "label": "D",
      "kind": "point"
    },
    {
      "x": -0.7,
      "y": -1.7,
      "label": "E",
      "kind": "point"
    },
    {
      "x": 4.3,
      "y": -1.7,
      "label": "F",
      "kind": "point"
    },
    {
      "x": 3.3,
      "y": 0.032,
      "label": "G",
      "kind": "point"
    },
    {
      "x": 0.3,
      "y": 0.032,
      "label": "H",
      "kind": "point"
    }
  ]
}$$::jsonb
WHERE id = '50251002-0000-0000-0000-000000000000';


