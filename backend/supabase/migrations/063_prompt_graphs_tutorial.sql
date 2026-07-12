-- 063_prompt_graphs_tutorial.sql
-- Adds the GIVEN diagram (question-level `prompt_graph`, added in 061) to CJC
-- tutorial-discussion questions (prefix cc21) whose prompt references a diagram
-- that was never shipped. Same spec format as solution_graph; every spec was
-- validated through graphService.compileGraph (labelled points verified on-curve).
--
-- cc213002 reuses the stand-in from migration 042: given y=f(x)+3 is that base
-- curve raised by 3 => 1+4/((x+1)^2+1) (max (-1,5), HA y=1, (0,3)).
-- cc218002/005/006 had no prior solution sketch (left sketch-only in 044); a fresh
-- stand-in matching the stated features is used. For cc218002 the matching
-- y=f'(x) model sketch is also added so the "sketch f'" answer corresponds.
-- cc21b00a/00b use the equations already in the prompt; cc219006 is a square drawn
-- with segments.

-- cc213002 (Transformations): given y=f(x)+3, max (-1,5), HA y=1, passes (0,3).
UPDATE questions SET prompt_graph = $${"x_range":[-8,6],"y_range":[0,6],"curves":[{"expr":"1+4/((x+1)^2+1)","domain":[-8,6],"label":"y=f(x)+3"}],"asymptotes":[{"kind":"horizontal","expr":"1","label":"y=1"}],"points":[{"x":-1,"y":5,"label":"(-1,\\ 5)","kind":"max"},{"x":0,"y":3,"label":"(0,\\ 3)","kind":"point"}]}$$::jsonb
WHERE id = 'cc213002-0000-0000-0000-000000000000';

-- cc218002 (App. of Differentiation): given y=f(x), max (4a,3a), asy x=2a, y=a (a=1).
UPDATE questions SET prompt_graph = $${"x_range":[-6,12],"y_range":[-6,6],"curves":[{"expr":"1+3/(2-x)","domain":[-6,1.9]},{"expr":"1+8/(x-2)-8/(x-2)^2","domain":[2.1,12],"label":"y=f(x)"}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2a"},{"kind":"horizontal","expr":"1","label":"y=a"}],"points":[{"x":4,"y":3,"label":"(4a,\\ 3a)","kind":"max"}]}$$::jsonb
WHERE id = 'cc218002-0000-0000-0000-000000000000';

-- cc218002 solution: y=f'(x) from the same stand-in (VA x=2a, HA y=0, cuts x-axis at (4a,0)).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-6,12],"y_range":[-2,4],"curves":[{"expr":"3/(2-x)^2","domain":[-6,1.9]},{"expr":"-8/(x-2)^2+16/(x-2)^3","domain":[2.1,12],"label":"y=f'(x)"}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2a"},{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":4,"y":0,"label":"(4a,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc218002-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- cc218005 (App. of Differentiation): given y=g(x), intercepts (0,1),(1,0),(3,0),
-- asy x=2 and oblique y=-x+2. (A single rational stand-in cannot hold all three
-- intercepts AND both branches' monotonicity, so the two branches use separate
-- expressions that hit the labelled intercepts; asymptotes drawn as reference.)
UPDATE questions SET prompt_graph = $${"x_range":[-4,8],"y_range":[-6,6],"curves":[{"expr":"(2-2*x)/(2-x)","domain":[-4,1.9]},{"expr":"-x+2+1/(x-2)","domain":[2.1,8],"label":"y=g(x)"}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2"},{"kind":"oblique","expr":"-x+2","label":"y=-x+2"}],"points":[{"x":0,"y":1,"label":"(0,\\ 1)","kind":"point"},{"x":1,"y":0,"label":"(1,\\ 0)","kind":"intercept"},{"x":3,"y":0,"label":"(3,\\ 0)","kind":"intercept"}]}$$::jsonb
WHERE id = 'cc218005-0000-0000-0000-000000000000';

-- cc218006 (App. of Differentiation): given y=f'(x), zeros (±a,0), min (0,b)<0, asy y=k>0 (a=2,b=-3,k=2).
UPDATE questions SET prompt_graph = $${"x_range":[-6,6],"y_range":[-4,3],"curves":[{"expr":"2-5/(1+0.375*x^2)","domain":[-6,6],"label":"y=f'(x)"}],"asymptotes":[{"kind":"horizontal","expr":"2","label":"y=k"}],"points":[{"x":-2,"y":0,"label":"(-a,\\ 0)","kind":"intercept"},{"x":2,"y":0,"label":"(a,\\ 0)","kind":"intercept"},{"x":0,"y":-3,"label":"(0,\\ b)","kind":"min"}]}$$::jsonb
WHERE id = 'cc218006-0000-0000-0000-000000000000';

-- cc21b00a (Definite Integrals): region A between y=x^2 and the minor arc of x^2+y^2=12.
UPDATE questions SET prompt_graph = $${"x_range":[-4,4],"y_range":[-0.5,4],"curves":[{"expr":"x^2","domain":[-1.7320508,1.7320508],"label":"y=x^2"},{"x_expr":"sqrt(12)*cos(t)","y_expr":"sqrt(12)*sin(t)","domain":[1.0471976,2.0943951],"label":"x^2+y^2=12"}],"points":[{"x":1.7320508,"y":3,"label":"(\\sqrt3,\\ 3)","kind":"point"},{"x":-1.7320508,"y":3,"label":"(-\\sqrt3,\\ 3)","kind":"point"},{"x":0,"y":1.7,"label":"A","kind":"point"}]}$$::jsonb
WHERE id = 'cc21b00a-0000-0000-0000-000000000000';

-- cc21b00b (Definite Integrals): region R bounded by y=2x, y=3/2, x-axis, y=sqrt((3x^2-1)/x^2).
UPDATE questions SET prompt_graph = $${"x_range":[0,1.6],"y_range":[0,2],"curves":[{"expr":"2*x","domain":[0,0.75],"label":"y=2x"},{"expr":"sqrt(3-1/x^2)","domain":[0.5773503,1.1547005],"label":"y=\\sqrt{\\dfrac{3x^2-1}{x^2}}"}],"segments":[{"from":[0.75,1.5],"to":[1.1547005,1.5],"label":"y=\\tfrac{3}{2}"}],"points":[{"x":0.75,"y":1.5,"label":"\\left(\\tfrac34,\\tfrac32\\right)","kind":"point"},{"x":0.5773503,"y":0,"label":"\\left(\\tfrac{1}{\\sqrt3},0\\right)","kind":"point"},{"x":0.7,"y":0.55,"label":"R","kind":"point"}]}$$::jsonb
WHERE id = 'cc21b00b-0000-0000-0000-000000000000';

-- cc219006 (Maclaurin Series): square ABCD side a, E on BC with angle CAE=theta (a=4, theta=20 deg schematic).
UPDATE questions SET prompt_graph = $${"x_range":[-1,5.5],"y_range":[-1,5.5],"segments":[{"from":[0,0],"to":[4,0]},{"from":[4,0],"to":[4,4]},{"from":[4,4],"to":[0,4]},{"from":[0,4],"to":[0,0]},{"from":[0,0],"to":[4,4]},{"from":[0,0],"to":[4,1.8652306326199943]}],"points":[{"x":0,"y":0,"label":"A","kind":"point"},{"x":4,"y":0,"label":"B","kind":"point"},{"x":4,"y":4,"label":"C","kind":"point"},{"x":0,"y":4,"label":"D","kind":"point"},{"x":4,"y":1.8652306326199943,"label":"E","kind":"point"}]}$$::jsonb
WHERE id = 'cc219006-0000-0000-0000-000000000000';
