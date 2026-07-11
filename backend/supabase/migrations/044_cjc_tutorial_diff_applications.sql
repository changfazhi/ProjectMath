-- Migration 044: CJC 2021 JC1 H2 Math Tutorial — Applications of Differentiation (DISCUSSION only, 12 questions)
-- Source: TUTORIAL/CALCULUS/4.2 Applications of Differentiation (Teacher).pdf, DISCUSSION section (pp.32-36).
-- REVIEW PROBLEMS + Self-Practice excluded. The struck-out Q11 (2011/DHS parametric connected-rates) is deleted
-- in the source and is NOT migrated. Answers verified against the tutorial answer key.
-- Provenance stripped: source 'H2 Math Tutorial (Applications of Differentiation)', inline exam tags removed.
-- IDs: prefix 'cc21' + topic-index '8' (calculus file 4.2) + 3-digit Q# -> cc218001..cc21800c. Topic aaaa0013.
-- Sketch parts (Q2, Q5 abstract derivative graphs; Q12(iii) concrete parametric) get solution_graph in a later migration.
-- FLAG: several answers are line/curve equations, ranges, or parametric-form expressions — exact-match brittle,
--        enabled per skills.md option 2 with canonical forms.

-- Q1: identify graph of f vs f'. Prose/reasoning -> ungraded (one null part wrapper). Diagram described in prose.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218001-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  1,
  $$Identify the graph of f and of f'$$,
  $$Two diagrams show the graph of \(f\) and its derivative \(f'\). In Diagram 1 the curve rises gently to a local maximum, then decreases to a local minimum lying below the \(x\)-axis (just left of the \(y\)-axis), then increases very steeply. In Diagram 2 the curve rises to a single rounded maximum above the \(x\)-axis, then decreases slightly before rising steeply. State clearly, with reasons, which is the graph of \(f\) and which is the graph of \(f'\).$$,
  'exact',
  $$See solution$$,
  NULL,
  $$Diagram 2 is \(y=f(x)\) and Diagram 1 is \(y=f'(x)\). Reason: at each turning point of \(f\) (Diagram 2) the derivative must be zero, and Diagram 1 crosses the \(x\)-axis exactly there. Between the maximum and the minimum of \(f\) (where \(f\) is decreasing) the derivative is negative — matching the portion of Diagram 1 that dips below the \(x\)-axis — while beyond the minimum \(f\) increases steeply, so \(f'\) is large and positive, matching Diagram 1's steep rise.$$,
  3,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "State clearly, with reasons, which is the graph of \\(f\\) and which is the graph of \\(f'\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q2: sketch y=f'(x) from a given graph of f. Sketch -> null part (solution_graph deferred).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218002-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  1,
  $$Sketch the derivative graph$$,
  $$The diagram shows the graph of \(y=f(x)\). It has a maximum point \((4a,3a)\) and asymptotes \(x=2a\) and \(y=a\). Sketch the graph of \(y=f'(x)\), where \(f'\) is the gradient function of \(f\), showing the relevant features of the graph.$$,
  'exact',
  $$See solution graph$$,
  NULL,
  $$Since \(x=2a\) is a vertical asymptote of \(f\), it is a vertical asymptote of \(f'\) as well. As \(x\to\pm\infty\), \(f\to a\) (horizontal), so \(f'\to 0\): the \(x\)-axis is a horizontal asymptote of \(f'\). At the maximum \((4a,3a)\), \(f'=0\), so \(y=f'(x)\) cuts the \(x\)-axis at \(x=4a\). For \(2a<x<4a\), \(f\) is increasing so \(f'>0\); for \(x>4a\), \(f\) is decreasing so \(f'<0\); for \(x<2a\), \(f\) is increasing so \(f'>0\).$$,
  3,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Sketch the graph of \\(y=f'(x)\\), showing the relevant features.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q3: tangent where curve defined implicitly. (a) show+tangent-at-A null; (b),(c) FLAG-enabled brittle forms.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218003-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Tangent to an implicitly-defined curve$$,
  $$The curve \(C\) has the equation \(2^{-y}=x\). The point \(A\) on \(C\) has \(x\)-coordinate \(a\) where \(a>0\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$From \(2^{-y}=x\), \(-y\ln 2=\ln x\Rightarrow y=-\dfrac{\ln x}{\ln 2}\), so \(\dfrac{dy}{dx}=-\dfrac{1}{x\ln 2}\); at \(A\), \(\dfrac{dy}{dx}=-\dfrac{1}{a\ln 2}\) (shown). At \(A\), \(y=-\dfrac{\ln a}{\ln 2}\), so the tangent at \(A\) is \(y=-\dfrac{1}{a\ln 2}x+\dfrac{1}{\ln 2}-\dfrac{\ln a}{\ln 2}\). (b) For the tangent through the origin, the point of tangency has \(x\)-coordinate \(e\); the tangent is \(y=-\dfrac{1}{e\ln 2}x\). (c) A line \(y=mx\) meets \(C\) at two distinct points when \(-\dfrac{1}{e\ln 2}<m<0\).$$,
  6,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\dfrac{dy}{dx}=-\\dfrac{1}{a\\ln 2}\\) at \\(A\\) and find the equation of the tangent to \\(C\\) at \\(A\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Hence find the equation of the tangent to \\(C\\) which passes through the origin, giving your answer in the form \\(y=\\ldots\\)",
    "correct_answer": "-\\frac{x}{e\\ln 2}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "The straight line \\(y=mx\\) intersects \\(C\\) at 2 distinct points. Write down the range of values of \\(m\\).",
    "correct_answer": "-\\frac{1}{e\\ln 2}<m<0",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q4: connected rates (spherical balloon), two graded parts.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218004-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  1,
  $$Connected rates of change (balloon)$$,
  $$Air is pumped into a spherical balloon at a constant rate of \(16\ \text{cm}^3/\text{s}\). [The surface area of a sphere of radius \(r\) is \(4\pi r^2\) and the volume is \(\dfrac{4}{3}\pi r^3\).]$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(V=\dfrac{4}{3}\pi r^3\Rightarrow\dfrac{dV}{dr}=4\pi r^2\), and \(\dfrac{dV}{dt}=16\), so \(\dfrac{dr}{dt}=\dfrac{16}{4\pi r^2}=\dfrac{4}{\pi r^2}\). (i) \(S=4\pi r^2\Rightarrow\dfrac{dS}{dt}=8\pi r\dfrac{dr}{dt}=8\pi r\cdot\dfrac{4}{\pi r^2}=\dfrac{32}{r}\); at \(r=4\), \(\dfrac{dS}{dt}=8\ \text{cm}^2/\text{s}\). (ii) \(\dfrac{dr}{dt}=\dfrac{4}{\pi r^2}\Rightarrow\text{time}=\int_4^8\dfrac{\pi r^2}{4}\,dr=\dfrac{\pi}{12}\left[r^3\right]_4^8=\dfrac{\pi}{12}(512-64)=\dfrac{112\pi}{3}\ \text{s}\).$$,
  5,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Calculate the rate at which the surface area is increasing, at the instant when the radius is \\(4\\) cm.",
    "correct_answer": "8",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Calculate the time taken for the radius to change from \\(4\\) cm to \\(8\\) cm.",
    "correct_answer": "\\frac{112\\pi}{3}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q5: sketch y=g'(x) from a given graph of g. Sketch -> null part (solution_graph deferred).
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218005-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Sketch the derivative graph (with asymptotes)$$,
  $$The diagram shows the graph of \(y=g(x)\). The intersections of the graph with the axes have coordinates \((0,1)\), \((1,0)\) and \((3,0)\). The asymptotes of the graph are the lines \(x=2\) and \(y=-x+2\). Sketch the graph of \(y=g'(x)\), making clear the main relevant features.$$,
  'exact',
  $$See solution graph$$,
  NULL,
  $$\(x=2\) is a vertical asymptote of \(g\), hence also of \(g'\). Since \(g\) has the oblique asymptote \(y=-x+2\), for large \(|x|\) the gradient \(g'\to -1\): \(y=-1\) is a horizontal asymptote of \(g'\). To the left of \(x=2\) the curve is decreasing (from \((0,1)\) through \((1,0)\)) so \(g'<0\); to the right of \(x=2\) the curve is decreasing through \((3,0)\) toward the oblique asymptote so \(g'<0\) there too, approaching \(-1\).$$,
  3,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Sketch the graph of \\(y=g'(x)\\), making clear the main relevant features.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q6: reasoning from a derivative graph. (i),(iia) prose/union -> null; (iib) single interval FLAG.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218006-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Reasoning from the graph of f'$$,
  $$The diagram shows the graph of \(y=f'(x)\). The curve cuts the \(x\)-axis at \((a,0)\) and \((-a,0)\), and has a stationary point at \((0,b)\) which lies below the \(x\)-axis. The line \(y=k\) (with \(k>0\)) is an asymptote.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$From the graph, \(f'>0\) for \(x<-a\) and \(x>a\), and \(f'<0\) for \(-a<x<a\). (i) Stationary points of \(y=f(x)\) occur where \(f'=0\): \(x=-a\) is a maximum (\(f'\) changes \(+\) to \(-\)) and \(x=a\) is a minimum (\(f'\) changes \(-\) to \(+\)). (ii)(a) \(f\) is strictly increasing where \(f'>0\): \(x<-a\) or \(x>a\). (ii)(b) \(f\) is concave downward where \(f''<0\), i.e. where \(f'\) is decreasing; since \(f'\) has its minimum at \(x=0\), \(f'\) is decreasing for \(x<0\).$$,
  5,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "State the \\(x\\)-coordinates of the stationary points of the curve \\(y=f(x)\\), and determine the nature of each point.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iia",
    "prompt_latex": "State the range of values of \\(x\\) for which the graph of \\(y=f(x)\\) is strictly increasing.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iib",
    "prompt_latex": "State the range of values of \\(x\\) for which the graph of \\(y=f(x)\\) is concave downward.",
    "correct_answer": "x<0",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q7: implicit curve; vertical tangents (multi-box), stationary-point justification (null), triangle area.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218007-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Tangents and area for an implicit curve$$,
  $$The equation of a curve is \(y^2-xy=-1\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Differentiating: \(2y\dfrac{dy}{dx}-y-x\dfrac{dy}{dx}=0\Rightarrow\dfrac{dy}{dx}=\dfrac{y}{2y-x}\). (i) Tangents parallel to the \(y\)-axis occur where \(2y-x=0\), i.e. \(x=2y\). Substituting into \(y^2-xy=-1\): \(y^2-2y^2=-1\Rightarrow y^2=1\Rightarrow y=\pm1\), giving \(x=\pm2\). The tangents are \(x=2\) and \(x=-2\). (ii) Stationary points need \(\dfrac{dy}{dx}=0\Rightarrow y=0\); but \(y=0\) gives \(0-0=-1\), impossible, so \(C\) has no stationary points. (iii) At \(y=2\): \(4-2x=-1\Rightarrow x=\tfrac52\), so the point is \(\left(\tfrac52,2\right)\); \(\dfrac{dy}{dx}=\dfrac{2}{4-5/2}=\dfrac{4}{3}\), so the normal has gradient \(-\tfrac34\): \(y-2=-\tfrac34\left(x-\tfrac52\right)\). Its intercepts are \(\left(\tfrac{31}{6},0\right)\) and \(\left(0,\tfrac{31}{8}\right)\), giving a right-angled triangle of area \(\tfrac12\cdot\tfrac{31}{6}\cdot\tfrac{31}{8}=\dfrac{961}{96}\) units\(^2\).$$,
  8,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the equations of all tangents to the curve that are parallel to the \\(y\\)-axis.",
    "correct_answer": "x=2,\\ x=-2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "t1", "label": "x=", "correct_answer": "2", "answer_type": "exact", "tolerance": null },
      { "key": "t2", "label": "x=", "correct_answer": "-2", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "ii",
    "prompt_latex": "State and justify whether the curve has any stationary points.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iii",
    "prompt_latex": "Find the area of the region bounded by the axes, and the normal to the curve at the point where the \\(y\\)-coordinate is \\(2\\).",
    "correct_answer": "\\frac{961}{96}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q8: kinematics. (i) velocity; (ii) max height & time (multi-box); (iii) velocity at s=0.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218008-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Kinematics: vertical motion$$,
  $$The height above ground of an object moving vertically is given by \(s=-16t^2+96t+112\), with \(s\) measured in metres and \(t\) in seconds.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(v=\dfrac{ds}{dt}=-32t+96\). (i) At \(t=0\), \(v=96\ \text{m/s}\). (ii) Maximum height when \(v=0\Rightarrow t=3\ \text{s}\); then \(s=-16(9)+96(3)+112=256\ \text{m}\). (iii) \(s=0\Rightarrow -16t^2+96t+112=0\Rightarrow t^2-6t-7=0\Rightarrow(t-7)(t+1)=0\Rightarrow t=7\); \(v=-32(7)+96=-128\ \text{m/s}\), so the object is travelling vertically downward.$$,
  7,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Find the velocity of the object when \\(t=0\\).",
    "correct_answer": "96",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Find its maximum height reached and when it occurs.",
    "correct_answer": "height 256 m at t=3 s",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "h", "label": "\\text{max height (m)}", "correct_answer": "256", "answer_type": "exact", "tolerance": null },
      { "key": "t", "label": "t\\ (\\text{s})", "correct_answer": "3", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "iii",
    "prompt_latex": "Find its velocity when \\(s=0\\), and hence state the direction of travel of the object.",
    "correct_answer": "-128",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q9: maximization (rectangle in semicircle). (a) perimeter FLAG; (b) show area null; (c) exact p.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc218009-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Maximization: rectangle in a semicircle$$,
  $$A rectangle \(PQRS\) is inscribed in a semicircle with radius \(10\) cm, with side \(PQ\) of length \(x\) cm lying along the diameter and the vertices \(R\) and \(S\) on the arc.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$The top corners lie on the circle, so the height is \(h=\sqrt{100-\left(\tfrac{x}{2}\right)^2}=\tfrac12\sqrt{400-x^2}\). (a) Perimeter \(p=2x\)... more precisely \(p=2\cdot\tfrac12\sqrt{400-x^2}+2x=\sqrt{400-x^2}+2x\). (b) Area \(A=x\cdot h=\dfrac{x}{2}\sqrt{400-x^2}\) (shown). (c) \(A^2=\dfrac{x^2(400-x^2)}{4}\); maximizing, \(\dfrac{d(A^2)}{dx}=0\Rightarrow 400-2x^2=0\Rightarrow x^2=200\Rightarrow x=10\sqrt2\). Then \(p=\sqrt{400-200}+2\cdot10\sqrt2=\sqrt{200}+20\sqrt2=10\sqrt2+20\sqrt2=30\sqrt2\).$$,
  6,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find, in terms of \\(x\\), an expression for the perimeter \\(p\\) cm of the rectangle \\(PQRS\\).",
    "correct_answer": "\\sqrt{400-x^2}+2x",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "Show that the area \\(A\\) cm\\(^2\\) of the rectangle \\(PQRS\\) is given by \\(A=\\dfrac{x}{2}\\sqrt{400-x^2}\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "c",
    "prompt_latex": "Find the exact value of \\(p\\) when \\(A\\) has its stationary value.",
    "correct_answer": "30\\sqrt{2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q10: parametric tangent (find a,b multi-box); explanation null.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21800a-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  $$Tangent to a parametric curve$$,
  $$The parametric equations of a curve are \(x=\ln(\cos\theta)\), \(y=\ln(\sin\theta)\), \(0<\theta<\dfrac{\pi}{2}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\dfrac{dx}{d\theta}=-\tan\theta\), \(\dfrac{dy}{d\theta}=\cot\theta\), so \(\dfrac{dy}{dx}=-\cot^2\theta\). (a) At \(\theta=\dfrac{\pi}{4}\): \(x=\ln\tfrac{1}{\sqrt2}=-\tfrac12\ln2\), \(y=-\tfrac12\ln2\), gradient \(=-1\). Tangent: \(y+\tfrac12\ln2=-\left(x+\tfrac12\ln2\right)\Rightarrow y=-x-\ln2\), so \(a=-1,\ b=-\ln2\). (b) Solving \(-x-\ln2=\ln(\sin\theta)\) with \(x=\ln(\cos\theta)\) leads to \(\sin2\theta=1\), whose only solution in \(\left(0,\tfrac{\pi}{2}\right)\) is \(\theta=\tfrac{\pi}{4}\) (the point of tangency), so the tangent does not meet the curve again.$$,
  6,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Find the equation of the tangent to the curve at the point where \\(\\theta=\\dfrac{\\pi}{4}\\), giving your answer in the form \\(y=ax+b\\) where \\(a\\) and \\(b\\) are exact values to be found.",
    "correct_answer": "a=-1, b=-\\ln 2",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "a", "label": "a", "correct_answer": "-1", "answer_type": "exact", "tolerance": null },
      { "key": "b", "label": "b", "correct_answer": "-\\ln 2", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "b",
    "prompt_latex": "Explain, using an algebraic method, why the tangent will not meet the curve again.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  }
]$$::jsonb
);

-- Q11 (ADVANCED): sphere inscribed in cone. (a) find V FLAG; (b) h for min V.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21800b-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  $$Minimizing the volume of a cone about a fixed sphere$$,
  $$A sphere with fixed radius \(a\) is inscribed in a cone of base radius \(r\) and height \(h\) (the sphere touches the base and the slanted surface of the cone). [Volume of cone \(V=\dfrac{1}{3}\pi r^2 h\).]$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$By similar triangles, \(r^2=\dfrac{a^2 h}{h-2a}\) (shown), so \(V=\dfrac{1}{3}\pi r^2 h=\dfrac{\pi a^2 h^2}{3(h-2a)}\). (b) \(\dfrac{dV}{dh}=\dfrac{\pi a^2}{3}\cdot\dfrac{2h(h-2a)-h^2}{(h-2a)^2}=\dfrac{\pi a^2}{3}\cdot\dfrac{h(h-4a)}{(h-2a)^2}\). Setting \(=0\) (with \(h>2a\)) gives \(h=4a\), which minimizes \(V\).$$,
  6,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(r^2=\\dfrac{a^2 h}{h-2a}\\) and find the volume of the cone, \\(V\\), in terms of \\(a\\) and \\(h\\).",
    "correct_answer": "\\frac{\\pi a^2 h^2}{3(h-2a)}",
    "answer_type": "exact",
    "tolerance": null
  },
  {
    "label": "b",
    "prompt_latex": "As \\(h\\) varies, find the value of \\(h\\) that gives the minimum \\(V\\), leaving your answer in terms of \\(a\\). (You do not need to verify that \\(V\\) is the minimum.)",
    "correct_answer": "4a",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);

-- Q12 (ADVANCED): parametric curve, six parts (mix of null, multi-box, range, FLAG). (iii) sketch -> graph deferred.
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc21800c-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  3,
  $$Parametric curve: turning point, tangent, area, Cartesian form$$,
  $$A curve \(C\) has parametric equations \(x=\sin t\), \(y=\sin 2t\), where \(-\dfrac{\pi}{3}\le t\le 0\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\dfrac{dx}{dt}=\cos t\), \(\dfrac{dy}{dt}=2\cos 2t\). (i) \(\dfrac{dy}{dx}=\dfrac{2\cos 2t}{\cos t}=\dfrac{2(2\cos^2 t-1)}{\cos t}=2(2\cos t-\sec t)\) (shown). (ii) Turning point when \(\dfrac{dy}{dx}=0\Rightarrow 2\cos t-\sec t=0\Rightarrow\cos^2 t=\tfrac12\), so \(h=\tfrac12\) and \(\cos t=\tfrac{1}{\sqrt2}\Rightarrow t=-\tfrac{\pi}{4}\). Then \(x=\sin\left(-\tfrac{\pi}{4}\right)=-\tfrac{\sqrt2}{2}\), \(y=\sin\left(-\tfrac{\pi}{2}\right)=-1\): turning point \(\left(-\tfrac{\sqrt2}{2},-1\right)\), a minimum. (iii) Endpoints: \(t=0\to(0,0)\); \(t=-\tfrac{\pi}{3}\to\left(-\tfrac{\sqrt3}{2},-\tfrac{\sqrt3}{2}\right)\). (iv) At \(t=-\tfrac{\pi}{6}\): \(P=\left(-\tfrac12,-\tfrac{\sqrt3}{2}\right)\), \(\dfrac{dy}{dx}=\dfrac{2}{\sqrt3}\). Tangent \(y=\dfrac{2}{\sqrt3}x-\dfrac{1}{2\sqrt3}\); normal \(y=-\dfrac{\sqrt3}{2}x-\dfrac{3\sqrt3}{4}\). (v) \(Q,R\) are the \(y\)-intercepts of the tangent and normal; with \(S\) the foot of the perpendicular from \(P\) to the \(x\)-axis, the quadrilateral \(PRQS\) has area \(\dfrac{13}{16\sqrt3}\approx0.469\). (vi) \(x=\sin t\Rightarrow\cos t=\sqrt{1-x^2}\) (since \(\cos t\ge0\) on the range), so \(y=2\sin t\cos t=2x\sqrt{1-x^2}\), with \(-\tfrac{\sqrt3}{2}\le x\le0\).$$,
  12,
  'H2 Math Tutorial (Applications of Differentiation)',
  $$[
  {
    "label": "i",
    "prompt_latex": "Show that \\(\\dfrac{dy}{dx}=2(2\\cos t-\\sec t)\\).",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "ii",
    "prompt_latex": "Show that \\(C\\) has a turning point when \\(\\cos t=\\sqrt{h}\\), where \\(h\\) is a real number to be determined. Find the exact coordinates of the turning point (and explain why it is a minimum).",
    "correct_answer": "h=1/2, turning point (-sqrt2/2, -1)",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "h", "label": "h", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null },
      { "key": "pt", "label": "\\text{turning point}", "correct_answer": "\\left(-\\frac{\\sqrt{2}}{2},\\ -1\\right)", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "iii",
    "prompt_latex": "Sketch \\(C\\), showing clearly the coordinates of the end points.",
    "correct_answer": null,
    "answer_type": null,
    "tolerance": null
  },
  {
    "label": "iv",
    "prompt_latex": "Find the equations of the tangent and the normal to the curve at the point \\(P\\) where \\(t=-\\dfrac{\\pi}{6}\\).",
    "correct_answer": "tangent y=2x/sqrt3-1/(2 sqrt3); normal y=-sqrt3/2 x-3 sqrt3/4",
    "answer_type": "exact",
    "tolerance": null,
    "answers": [
      { "key": "tan", "label": "\\text{tangent } y=", "correct_answer": "\\frac{2}{\\sqrt{3}}x-\\frac{1}{2\\sqrt{3}}", "answer_type": "exact", "tolerance": null },
      { "key": "nor", "label": "\\text{normal } y=", "correct_answer": "-\\frac{\\sqrt{3}}{2}x-\\frac{3\\sqrt{3}}{4}", "answer_type": "exact", "tolerance": null }
    ]
  },
  {
    "label": "v",
    "prompt_latex": "The tangent and the normal at \\(P\\) meet the \\(y\\)-axis at the points \\(Q\\) and \\(R\\) respectively. Find the area of the quadrilateral \\(PRQS\\) where \\(S\\) is the foot of the perpendicular from \\(P\\) to the \\(x\\)-axis.",
    "correct_answer": "0.469",
    "answer_type": "range",
    "tolerance": 0.001
  },
  {
    "label": "vi",
    "prompt_latex": "Find the Cartesian equation of \\(C\\).",
    "correct_answer": "2x\\sqrt{1-x^2}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
);
