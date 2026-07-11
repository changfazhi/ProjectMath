-- 032_yijc_sketch_graphs.sql
-- Adds solution_graph specs to the 7 YIJC sketch parts left without one in 031.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Specs compiled &
-- validated through graphService.compileGraph (points verified on-curve).
-- Q6 (a-c) use a stand-in base f(x)=-1-x-4/x² (a=-1,b=-1,c=-2,d=2,e=-4) whose
-- shape matches the official abstract diagram; labels stay symbolic.
-- Spec format: see migration 027 header.

-- Q6(a) y=3f(x+c). Stand-in f(x)=-1-x-4/x² (c=-2) → 3-3x-12/(x-2)²: VA x=-c(=2), oblique y=3bx+3a+3bc(=-3x+3), max (d-c,3e)=(4,-12), x-int (0,0).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [
    -5,
    8
  ],
  "y_range": [
    -16,
    16
  ],
  "curves": [
    {
      "expr": "3-3*x-12/(x-2)^2",
      "domain": [
        -5,
        1.9
      ]
    },
    {
      "expr": "3-3*x-12/(x-2)^2",
      "domain": [
        2.1,
        8
      ],
      "label": "y=3f(x+c)"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": 2,
      "label": "x=-c"
    },
    {
      "kind": "oblique",
      "expr": "-3*x+3",
      "label": "y=3bx+3a+3bc"
    }
  ],
  "points": [
    {
      "x": 4,
      "y": -12,
      "label": "(d-c,\\ 3e)",
      "kind": "max"
    },
    {
      "x": 0,
      "y": 0,
      "label": "(0,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'f0250006-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- Q6(b) y=1/f(x). Stand-in 1/f = -x^2/(x^3+x^2+4): VA x=c(=-2), HA y=0, min (d,1/e)=(2,-0.25), touches (0,0).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [
    -6,
    6
  ],
  "y_range": [
    -2,
    2
  ],
  "curves": [
    {
      "expr": "-x^2/(x^3+x^2+4)",
      "domain": [
        -6,
        -2.1
      ]
    },
    {
      "expr": "-x^2/(x^3+x^2+4)",
      "domain": [
        -1.9,
        6
      ],
      "label": "y=\\dfrac{1}{f(x)}"
    }
  ],
  "asymptotes": [
    {
      "kind": "vertical",
      "x": -2,
      "label": "x=c"
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
      "y": -0.25,
      "label": "\\left(d,\\ \\dfrac{1}{e}\\right)",
      "kind": "min"
    }
  ]
}$$::jsonb)
WHERE id = 'f0250006-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- Q6(c) y=f'(x). Stand-in f'(x)=-1+8/x^3: VA x=0, HA y=b(=-1), x-int (d,0)=(2,0).
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [
    -6,
    6
  ],
  "y_range": [
    -6,
    6
  ],
  "curves": [
    {
      "expr": "-1+8/x^3",
      "domain": [
        -6,
        -0.9
      ]
    },
    {
      "expr": "-1+8/x^3",
      "domain": [
        0.9,
        6
      ],
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
      "kind": "horizontal",
      "expr": "-1",
      "label": "y=b"
    }
  ],
  "points": [
    {
      "x": 2,
      "y": 0,
      "label": "(d,\\ 0)",
      "kind": "intercept"
    }
  ]
}$$::jsonb)
WHERE id = 'f0250006-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- Q7(a) y=|2x-1| (V, vertex (0.5,0)) and y=x^2-4x-2 (min (2,-6), y-int (0,-2)); intersect at (-1,3) and (6.16,11.31).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [
    -3,
    8
  ],
  "y_range": [
    -8,
    14
  ],
  "curves": [
    {
      "expr": "abs(2*x-1)",
      "domain": [
        -3,
        8
      ],
      "label": "y=|2x-1|"
    },
    {
      "expr": "x^2-4*x-2",
      "domain": [
        -3,
        8
      ],
      "label": "y=x^2-4x-2"
    }
  ],
  "points": [
    {
      "x": 0.5,
      "y": 0,
      "label": "\\left(\\tfrac12,\\ 0\\right)",
      "kind": "min"
    },
    {
      "x": 2,
      "y": -6,
      "label": "(2,\\ -6)",
      "kind": "min"
    },
    {
      "x": 0,
      "y": -2,
      "label": "(0,\\ -2)",
      "kind": "intercept"
    },
    {
      "x": -1,
      "y": 3,
      "label": "(-1,\\ 3)",
      "kind": "point"
    },
    {
      "x": 6.16,
      "y": 11.31,
      "label": "(6.16,\\ 11.3)",
      "kind": "point"
    }
  ]
}$$::jsonb)
WHERE id = 'f0250007-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- Q2(c) Argand: O(0), A≡z(√3,-1), C≡w(2,2√3), B≡z+w. Rectangle OABC.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [
    -1,
    5
  ],
  "y_range": [
    -2,
    4.5
  ],
  "curves": [],
  "points": [
    {
      "x": 0,
      "y": 0,
      "label": "O",
      "kind": "point"
    },
    {
      "x": 1.7320508075688772,
      "y": -1,
      "label": "A\\equiv z",
      "kind": "point"
    },
    {
      "x": 3.732050807568877,
      "y": 2.4641016151377544,
      "label": "B\\equiv z+w",
      "kind": "point"
    },
    {
      "x": 2,
      "y": 3.4641016151377544,
      "label": "C\\equiv w",
      "kind": "point"
    }
  ],
  "segments": [
    {
      "from": [
        0,
        0
      ],
      "to": [
        1.7320508075688772,
        -1
      ],
      "style": "solid"
    },
    {
      "from": [
        1.7320508075688772,
        -1
      ],
      "to": [
        3.732050807568877,
        2.4641016151377544
      ],
      "style": "solid"
    },
    {
      "from": [
        3.732050807568877,
        2.4641016151377544
      ],
      "to": [
        2,
        3.4641016151377544
      ],
      "style": "solid"
    },
    {
      "from": [
        2,
        3.4641016151377544
      ],
      "to": [
        0,
        0
      ],
      "style": "solid"
    },
    {
      "from": [
        0,
        0
      ],
      "to": [
        3.732050807568877,
        2.4641016151377544
      ],
      "style": "dashed"
    }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = 'f0251002-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- Q3(c) C=100πr²+60000/r, r>0. Min at (4.571, 19690.29) ≈ (4.57, 19700).
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [
    0,
    9
  ],
  "y_range": [
    0,
    40000
  ],
  "curves": [
    {
      "expr": "100*pi*x^2+60000/x",
      "domain": [
        0.5,
        9
      ],
      "label": "C=100\\pi r^2+\\dfrac{60000}{r}"
    }
  ],
  "points": [
    {
      "x": 4.570781497340833,
      "y": 19690.28711006198,
      "label": "(4.57,\\ 19700)",
      "kind": "min"
    }
  ],
  "x_label": "r",
  "y_label": "C"
}$$::jsonb)
WHERE id = 'f0251003-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- Q8(a) scatter (x days vs y seconds); curve of best fit is y=a+b/x (part c), not drawn here.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [
    0,
    45
  ],
  "y_range": [
    0,
    240
  ],
  "curves": [],
  "points": [
    {
      "x": 5,
      "y": 220,
      "kind": "point"
    },
    {
      "x": 10,
      "y": 150,
      "kind": "point"
    },
    {
      "x": 15,
      "y": 100,
      "kind": "point"
    },
    {
      "x": 20,
      "y": 70,
      "kind": "point"
    },
    {
      "x": 25,
      "y": 48,
      "kind": "point"
    },
    {
      "x": 30,
      "y": 35,
      "kind": "point"
    },
    {
      "x": 35,
      "y": 25,
      "kind": "point"
    },
    {
      "x": 40,
      "y": 18,
      "kind": "point"
    }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = 'f0251008-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';
