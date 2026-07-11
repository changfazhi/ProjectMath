-- Migration 042: solution_graph specs for the ABSTRACT-f cc21 tutorial sketch parts.
-- Data-only (jsonb_set, label-guarded, no DDL). Each spec is a STAND-IN curve
-- constructed to pass through every officially-labelled feature (asymptotes,
-- turning points, intercepts from the tutorial answer keys), then compiled &
-- validated through graphService.compileGraph() (all 10 render; points on-curve).
-- Where a parameter is abstract, a representative value is used and the point
-- LABELS stay symbolic (e.g. "(a, 1/b)", "x=b"). Authored in backend/gen042.ts.
--
--   038 Q2(i-iv): base f(x)=-2+4/((x+1)^2+1); each transform is a clean closed form.
--   038 Q3(ii):  1/((x-1)^4+1)  (stand-in a=1,b=1,c=2).
--   038 Q6(a,b): reciprocals of the (reconstructed) base curves.
--   036 Q5(i,ii): y=(ax+1)/(x-b) at representative a,b.
--   040 Q3(i):   y=1/(x-a) & y=b|x-a| at a=1,b=1.
--
-- NOT INCLUDED (left without a model graph): 038 Q6(c) — source curve is
-- under-specified in the PDF; 038 Q8(a)/(b) — a clean stand-in cannot match all
-- of {VA, HA, 3 intercepts, 2 turning points} simultaneously, so no faithful
-- diagram is shipped rather than a misleading one. These remain sketch-only.

-- Q2(i) y=f(x): stand-in -2+4/((x+1)^2+1); max(-1,2), HA y=-2, (0,0)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-8,6],"y_range":[-3,3],"curves":[{"expr":"-2+4/((x+1)^2+1)","domain":[-8,6],"label":"y=f(x)"}],"asymptotes":[{"kind":"horizontal","expr":"-2","label":"y=-2"}],"points":[{"x":-1,"y":2,"label":"(-1,\\ 2)","kind":"max"},{"x":0,"y":0,"label":"(0,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc213002-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q2(ii) y=-f(x)+3 = 5-4/((x+1)^2+1); min(-1,1), HA y=5, (0,3)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-8,6],"y_range":[0,6],"curves":[{"expr":"5-4/((x+1)^2+1)","domain":[-8,6],"label":"y=-f(x)+3"}],"asymptotes":[{"kind":"horizontal","expr":"5","label":"y=5"}],"points":[{"x":-1,"y":1,"label":"(-1,\\ 1)","kind":"min"},{"x":0,"y":3,"label":"(0,\\ 3)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213002-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q2(iii) y=f(-x+3) = -2+4/((x-4)^2+1); max(4,2), HA y=-2, (3,0)
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-3,11],"y_range":[-3,3],"curves":[{"expr":"-2+4/((x-4)^2+1)","domain":[-3,11],"label":"y=f(-x+3)"}],"asymptotes":[{"kind":"horizontal","expr":"-2","label":"y=-2"}],"points":[{"x":4,"y":2,"label":"(4,\\ 2)","kind":"max"},{"x":3,"y":0,"label":"(3,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc213002-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

-- Q2(iv) y=f(2x+1) = -2+4/(4(x+1)^2+1); max(-1,2), HA y=-2, (-0.5,0)
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-5,3],"y_range":[-3,3],"curves":[{"expr":"-2+4/(4*(x+1)^2+1)","domain":[-5,3],"label":"y=f(2x+1)"}],"asymptotes":[{"kind":"horizontal","expr":"-2","label":"y=-2"}],"points":[{"x":-1,"y":2,"label":"(-1,\\ 2)","kind":"max"},{"x":-0.5,"y":0,"label":"(-0.5,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc213002-0000-0000-0000-000000000000' AND parts->3->>'label' = 'iv';

-- Q3(ii) y=1/f(x); stand-in 1/((x-1)^4+1): max (a,1/b)=(1,1), y-int (0,1/c)=(0,0.5), HA y=0
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-3,5],"y_range":[-0.2,1.3],"curves":[{"expr":"1/((x-1)^4+1)","domain":[-3,5],"label":"y=\\dfrac{1}{f(x)}"}],"asymptotes":[{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":1,"y":1,"label":"\\left(a,\\ \\tfrac{1}{b}\\right)","kind":"max"},{"x":0,"y":0.5,"label":"\\left(0,\\ \\tfrac{1}{c}\\right)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213003-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q6(a) reciprocal of parabola (x-1)(x-2): 1/(x^2-3x+2); VA x=1,x=2, HA y=0, dip max (1.5,-4), (0,0.5)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-2,4],"y_range":[-8,4],"curves":[{"expr":"1/(x^2-3*x+2)","domain":[-2,0.9],"label":"y=\\dfrac{1}{f(x)}"},{"expr":"1/(x^2-3*x+2)","domain":[1.1,1.9]},{"expr":"1/(x^2-3*x+2)","domain":[2.1,4]}],"asymptotes":[{"kind":"vertical","x":1,"label":"x=1"},{"kind":"vertical","x":2,"label":"x=2"},{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":1.5,"y":-4,"label":"\\left(\\tfrac{3}{2},-4\\right)","kind":"max"},{"x":0,"y":0.5,"label":"(0,\\ \\tfrac{1}{2})","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213006-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- Q6(b) reciprocal of f=-1+2/(x+1): 1/f=(x+1)/(1-x); VA x=1, HA y=-1, (-1,0), (0,1)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-5,5],"y_range":[-6,4],"curves":[{"expr":"(x+1)/(1-x)","domain":[-5,0.9],"label":"y=\\dfrac{1}{f(x)}"},{"expr":"(x+1)/(1-x)","domain":[1.1,5]}],"asymptotes":[{"kind":"vertical","x":1,"label":"x=1"},{"kind":"horizontal","expr":"-1","label":"y=-1"}],"points":[{"x":-1,"y":0,"label":"(-1,\\ 0)","kind":"intercept"},{"x":0,"y":1,"label":"(0,\\ 1)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213006-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- Q5(i) y=(ax+1)/(x-b), -1<a<0,0<b<1. Stand-in a=-0.5,b=0.5: VA x=b, HA y=a, (2,0)=(-1/a,0), (0,-2)=(0,-1/b)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-6,7],"y_range":[-6,5],"curves":[{"expr":"(-0.5*x+1)/(x-0.5)","domain":[-6,0.4],"label":"y=\\dfrac{ax+1}{x-b}"},{"expr":"(-0.5*x+1)/(x-0.5)","domain":[0.6,7]}],"asymptotes":[{"kind":"vertical","x":0.5,"label":"x=b"},{"kind":"horizontal","expr":"-0.5","label":"y=a"}],"points":[{"x":2,"y":0,"label":"\\left(-\\tfrac{1}{a},0\\right)","kind":"intercept"},{"x":0,"y":-2,"label":"\\left(0,-\\tfrac{1}{b}\\right)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc211005-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q5(ii) a<-1,b>1. Stand-in a=-2,b=2: VA x=b, HA y=a, (0.5,0)=(-1/a,0), (0,-0.5)=(0,-1/b)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-6,10],"y_range":[-8,5],"curves":[{"expr":"(-2*x+1)/(x-2)","domain":[-6,1.9],"label":"y=\\dfrac{ax+1}{x-b}"},{"expr":"(-2*x+1)/(x-2)","domain":[2.1,10]}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=b"},{"kind":"horizontal","expr":"-2","label":"y=a"}],"points":[{"x":0.5,"y":0,"label":"\\left(-\\tfrac{1}{a},0\\right)","kind":"intercept"},{"x":0,"y":-0.5,"label":"\\left(0,-\\tfrac{1}{b}\\right)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc211005-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q3(i) stand-in a=1,b=1: y=1/(x-1) (VA x=1, HA y=0) and y=|x-1|; intersection (a+1/sqrt(b), sqrt(b))=(2,1)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-3,5],"y_range":[-5,5],"curves":[{"expr":"1/(x-1)","domain":[-3,0.9],"label":"y=\\dfrac{1}{x-a}"},{"expr":"1/(x-1)","domain":[1.1,5]},{"expr":"abs(x-1)","domain":[-3,5],"label":"y=b|x-a|"}],"asymptotes":[{"kind":"vertical","x":1,"label":"x=a"},{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":2,"y":1,"label":"\\left(a+\\tfrac{1}{\\sqrt{b}},\\ \\sqrt{b}\\right)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc215003-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

