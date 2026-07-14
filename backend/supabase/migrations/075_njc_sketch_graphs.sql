-- 075_njc_sketch_graphs.sql
-- Adds solution_graph specs to the NJC (migration 074) sketch parts.
-- Data-only (jsonb_set per part, label-guarded, no DDL). Spec format: see migration 027 header.
-- Every spec is intended to compile through graphService.compileGraph (skills.md §12).
-- Abstract-parameter curves use a representative value, noted per spec; the label keeps the
-- symbolic coordinates. 3-D figures (P1 Q12 canopy) are not 2-D coordinate graphs and are omitted.

-- ============================================================
-- PAPER 1
-- ============================================================

-- P1 Q3(a): y=-b/(x-a) (VA x=a, HA y=0, y-int (0,b/a)) and y=|x-a| (V-vertex (a,0), y-int (0,a)).
-- Representative a=3, b=2 (a>b>1).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-2, 8],
  "y_range": [-4, 6],
  "curves": [
    { "expr": "-2/(x-3)", "domain": [-2, 2.9], "label": "y=-\\dfrac{b}{x-a}" },
    { "expr": "-2/(x-3)", "domain": [3.1, 8] },
    { "expr": "abs(x-3)", "domain": [-2, 8], "label": "y=|x-a|" }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 3, "label": "x=a" }
  ],
  "points": [
    { "x": 3, "y": 0, "label": "(a,\\ 0)", "kind": "point" },
    { "x": 0, "y": 3, "label": "(0,\\ a)", "kind": "point" },
    { "x": 0, "y": 0.6666666666666666, "label": "\\left(0,\\ \\dfrac{b}{a}\\right)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '70250003-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- P1 Q4(b): y=1/f(x), f(x)=1-sqrt(q^2-x^2). Representative q=2: VAs x=±sqrt(3), end-points (±2,1),
-- middle branch max at (0, 1/(1-q))=(0,-1).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-3, 3],
  "y_range": [-5, 5],
  "curves": [
    { "expr": "1/(1-sqrt(4-x^2))", "domain": [-2, -1.74] },
    { "expr": "1/(1-sqrt(4-x^2))", "domain": [-1.72, 1.72], "label": "y=\\dfrac{1}{f(x)}" },
    { "expr": "1/(1-sqrt(4-x^2))", "domain": [1.74, 2] }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 1.7320508075688772, "label": "x=\\sqrt{q^2-1}" },
    { "kind": "vertical", "x": -1.7320508075688772, "label": "x=-\\sqrt{q^2-1}" }
  ],
  "points": [
    { "x": 2, "y": 1, "label": "(q,\\ 1)", "kind": "point" },
    { "x": -2, "y": 1, "label": "(-q,\\ 1)", "kind": "point" },
    { "x": 0, "y": -1, "label": "\\left(0,\\ \\dfrac{1}{1-q}\\right)", "kind": "max" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '70250004-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- P1 Q5(b): C=(2x^2+28x+8)/(x-2)=2x+32+72/(x-2). VA x=2, oblique y=2x+32, max (-4,12), min (8,60),
-- x-int (-0.292,0), y-int (0,-4).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-16, 18],
  "y_range": [-30, 90],
  "curves": [
    { "expr": "(2*x^2+28*x+8)/(x-2)", "domain": [-16, 1.7] },
    { "expr": "(2*x^2+28*x+8)/(x-2)", "domain": [2.3, 18], "label": "C" }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": 2, "label": "x=2" },
    { "kind": "oblique", "expr": "2*x+32", "label": "y=2x+32" }
  ],
  "points": [
    { "x": -4, "y": 12, "label": "(-4,\\ 12)", "kind": "max" },
    { "x": 8, "y": 60, "label": "(8,\\ 60)", "kind": "min" },
    { "x": 0, "y": -4, "label": "(0,\\ -4)", "kind": "point" },
    { "x": -0.292, "y": 0, "label": "(-0.292,\\ 0)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '70250005-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- P1 Q7(c): C: x=e^{4t}, y=t^2, t>=0 => y=(1/16)(ln x)^2 for x>=1. Starts (1,0), through P(e,1/16),
-- increasing.
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${
  "x_range": [0, 9],
  "y_range": [0, 0.4],
  "curves": [
    { "expr": "(1/16)*(log(x))^2", "domain": [1, 8], "label": "C" }
  ],
  "points": [
    { "x": 1, "y": 0, "label": "(1,\\ 0)", "kind": "intercept" },
    { "x": 2.718281828459045, "y": 0.0625, "label": "P\\left(e,\\ \\tfrac{1}{16}\\right)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '70250007-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- ============================================================
-- PAPER 2
-- ============================================================

-- P2 Q1(b): Argand diagram. w=(-sqrt3,1), -w=(sqrt3,-1)=A, 2-w=(2+sqrt3,-1)=B.
-- OA=|-w|=2 and AB=|2|=2, so triangle OAB is isosceles; AB is parallel to the real axis.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${
  "x_range": [-3, 5],
  "y_range": [-3, 3],
  "curves": [],
  "segments": [
    { "from": [0, 0], "to": [-1.7320508075688772, 1], "arrow": true, "style": "dashed" },
    { "from": [0, 0], "to": [1.7320508075688772, -1], "arrow": true },
    { "from": [0, 0], "to": [3.732050807568877, -1], "arrow": true, "style": "dashed" },
    { "from": [1.7320508075688772, -1], "to": [3.732050807568877, -1] }
  ],
  "points": [
    { "x": -1.7320508075688772, "y": 1, "label": "W\\,(w)", "kind": "point" },
    { "x": 1.7320508075688772, "y": -1, "label": "A\\,(-w)", "kind": "point" },
    { "x": 3.732050807568877, "y": -1, "label": "B\\,(2-w)", "kind": "point" },
    { "x": 0, "y": 0, "label": "O", "kind": "point" }
  ],
  "x_label": "\\mathrm{Re}",
  "y_label": "\\mathrm{Im}"
}$$::jsonb)
WHERE id = '70251001-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- P2 Q2(a): ellipse E (x-a)^2+4y^2=4, centre (a,0), semi-axes 2 (x) and 1 (y). Representative a=1;
-- vertices (a±2,0), (a,±1).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [-3, 5],
  "y_range": [-2, 2],
  "curves": [
    { "x_expr": "1+2*cos(t)", "y_expr": "sin(t)", "domain": [0, 6.283185307179586], "label": "E" }
  ],
  "points": [
    { "x": -1, "y": 0, "label": "(a-2,\\ 0)", "kind": "point" },
    { "x": 3, "y": 0, "label": "(a+2,\\ 0)", "kind": "point" },
    { "x": 1, "y": 1, "label": "(a,\\ 1)", "kind": "point" },
    { "x": 1, "y": -1, "label": "(a,\\ -1)", "kind": "point" }
  ],
  "x_label": "x",
  "y_label": "y"
}$$::jsonb)
WHERE id = '70251002-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- P2 Q4(d): P against h, P=A|293-6.5h|^b, representative A=1.4935e-8, b=5.2015. U-shaped, min at
-- h=45.08 (where 293-6.5h=0), passing (0,101300) and symmetric about h=45.08.
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [0, 95],
  "y_range": [0, 115000],
  "curves": [
    { "expr": "1.4935e-8*abs(293-6.5*x)^5.2015", "domain": [0, 90], "label": "P=A|293-6.5h|^{b}" }
  ],
  "points": [
    { "x": 0, "y": 101300, "label": "(0,\\ 101300)", "kind": "point" },
    { "x": 45.08, "y": 0, "label": "45.1", "kind": "min" }
  ],
  "x_label": "h",
  "y_label": "P"
}$$::jsonb)
WHERE id = '70251004-0000-0000-0000-000000000000' AND parts->3->>'label' = 'd';

-- P2 Q8(a): scatter of the six (s,p) data points.
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${
  "x_range": [28, 58],
  "y_range": [110, 190],
  "curves": [],
  "points": [
    { "x": 32, "y": 120, "kind": "point" },
    { "x": 37, "y": 150, "kind": "point" },
    { "x": 41, "y": 168, "kind": "point" },
    { "x": 46, "y": 172, "kind": "point" },
    { "x": 50, "y": 179, "kind": "point" },
    { "x": 54, "y": 183, "kind": "point" }
  ],
  "x_label": "s",
  "y_label": "p"
}$$::jsonb)
WHERE id = '70251008-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- P2 Q11(d): distribution of G ~ N(97.2, 81), sd=9. Bell curve with mean marked.
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${
  "x_range": [70, 124],
  "y_range": [0, 0.05],
  "curves": [
    { "expr": "e^(-(x-97.2)^2/(2*81))/(9*sqrt(2*pi))", "domain": [70, 124], "label": "G\\sim N(97.2,\\ 81)" }
  ],
  "segments": [
    { "from": [97.2, 0], "to": [97.2, 0.0443], "style": "dashed" }
  ],
  "points": [
    { "x": 97.2, "y": 0, "label": "\\mu=97.2", "kind": "point" }
  ],
  "x_label": "G",
  "y_label": ""
}$$::jsonb)
WHERE id = '7025100b-0000-0000-0000-000000000000' AND parts->3->>'label' = 'd';

-- P2 Q11(e): same curve, shading P(79<G<106).
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${
  "x_range": [70, 124],
  "y_range": [0, 0.05],
  "curves": [
    { "expr": "e^(-(x-97.2)^2/(2*81))/(9*sqrt(2*pi))", "domain": [70, 124], "label": "G\\sim N(97.2,\\ 81)" }
  ],
  "shade": [
    { "expr": "e^(-(x-97.2)^2/(2*81))/(9*sqrt(2*pi))", "domain": [79, 106], "label": "P(79<G<106)" }
  ],
  "segments": [
    { "from": [97.2, 0], "to": [97.2, 0.0443], "style": "dashed" }
  ],
  "points": [
    { "x": 97.2, "y": 0, "label": "\\mu=97.2", "kind": "point" }
  ],
  "x_label": "G",
  "y_label": ""
}$$::jsonb)
WHERE id = '7025100b-0000-0000-0000-000000000000' AND parts->4->>'label' = 'e';
