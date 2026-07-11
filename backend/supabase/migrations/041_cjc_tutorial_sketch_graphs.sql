-- Migration 041: solution_graph specs for the CONCRETE cc21 tutorial sketch parts.
-- Data-only: jsonb_set per part, label-guarded (skills.md §12 step 2), no DDL.
-- Every spec was authored in backend/gen041.ts and compiled through
-- graphService.compileGraph() — all 30 render non-empty polylines and every
-- min/max/intercept point snaps on-curve (skills.md §12 step 5).
-- Covers: 034 Parametric Q1(i–viii); 039 Conics Q1(a–e); 036 Graphing Q4(a–e),
-- Q6(ii),Q7(iii),Q8(iv),Q9(ii); 037 Functions Q2(i),Q2(iii),Q5(ii),Q6(i);
-- 038 Transformations Q5(iv),Q7(iii),Q9(ii),Q9(iii).
-- Abstract-f transform sketches (038 Q2/Q3/Q6/Q8, 036 Q5, 040 Q3) need stand-in
-- curves verified vs the official diagrams — deferred to migration 042.
-- Conic Q1(a) uses representative constants (a=2,b=1,r=2); labels stay symbolic.

-- x=cos t, y=2 sin t: right half of ellipse x^2+y^2/4=1
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-0.5,1.5],"y_range":[-2.5,2.5],"curves":[{"x_expr":"cos(t)","y_expr":"2*sin(t)","domain":[-1.5707963267948966,1.5707963267948966],"label":"x^2+\\frac{y^2}{4}=1"}],"points":[{"x":1,"y":0,"label":"(1,\\ 0)","kind":"intercept"},{"x":0,"y":2,"label":"(0,\\ 2)","kind":"point"},{"x":0,"y":-2,"label":"(0,\\ -2)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- x=2 sec t, y=tan t: hyperbola x^2/4 - y^2 = 1
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-8,8],"y_range":[-4,4],"curves":[{"x_expr":"2/cos(t)","y_expr":"tan(t)","domain":[0,6.283185307179586],"label":"\\frac{x^2}{4}-y^2=1"}],"asymptotes":[{"kind":"oblique","expr":"0.5*x","label":"y=\\tfrac{x}{2}"},{"kind":"oblique","expr":"-0.5*x","label":"y=-\\tfrac{x}{2}"}],"points":[{"x":2,"y":0,"label":"(2,\\ 0)","kind":"point"},{"x":-2,"y":0,"label":"(-2,\\ 0)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- x=cos t, y=sin 2t: figure-eight, x^2-y^2/4=x^4
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-1.5,1.5],"y_range":[-1.5,1.5],"curves":[{"x_expr":"cos(t)","y_expr":"sin(2*t)","domain":[0,6.283185307179586],"label":"x^2-\\frac{y^2}{4}=x^4"}],"points":[{"x":1,"y":0,"label":"(1,\\ 0)","kind":"point"},{"x":-1,"y":0,"label":"(-1,\\ 0)","kind":"point"},{"x":0,"y":0,"label":"(0,\\ 0)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

-- Witch of Agnesi y=8/(x^2+4)
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-10,10],"y_range":[-0.5,2.5],"curves":[{"expr":"8/(x^2+4)","domain":[-10,10],"label":"y=\\dfrac{8}{x^2+4}"}],"asymptotes":[{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":0,"y":2,"label":"(0,\\ 2)","kind":"max"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->3->>'label' = 'iv';

-- Astroid x^(2/3)+y^(2/3)=1
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${"x_range":[-1.5,1.5],"y_range":[-1.5,1.5],"curves":[{"x_expr":"cos(t)^3","y_expr":"sin(t)^3","domain":[0,6.283185307179586],"label":"x^{2/3}+y^{2/3}=1"}],"points":[{"x":1,"y":0,"label":"(1,\\ 0)","kind":"point"},{"x":-1,"y":0,"label":"(-1,\\ 0)","kind":"point"},{"x":0,"y":1,"label":"(0,\\ 1)","kind":"point"},{"x":0,"y":-1,"label":"(0,\\ -1)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->4->>'label' = 'v';

-- y=x^2/4 - 1, -4<=x<=10
UPDATE questions
SET parts = jsonb_set(parts, '{5,solution_graph}', $${"x_range":[-5,11],"y_range":[-2,25],"curves":[{"expr":"x^2/4-1","domain":[-4,10],"label":"y=\\dfrac{x^2}{4}-1"}],"points":[{"x":0,"y":-1,"label":"(0,\\ -1)","kind":"min"},{"x":2,"y":0,"label":"(2,\\ 0)","kind":"intercept"},{"x":-2,"y":0,"label":"(-2,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->5->>'label' = 'vi';

-- y=x^3, e^-0.5<=x<=e^0.5
UPDATE questions
SET parts = jsonb_set(parts, '{6,solution_graph}', $${"x_range":[0,2],"y_range":[0,5],"curves":[{"expr":"x^3","domain":[0.6065306597126334,1.6487212707001282],"label":"y=x^3"}],"points":[{"x":0.6065306597126334,"y":0.22313016014842982,"label":"(e^{-0.5},\\ e^{-1.5})","kind":"point","open":false},{"x":1.6487212707001282,"y":4.4816890703380645,"label":"(e^{0.5},\\ e^{1.5})","kind":"point","open":false}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->6->>'label' = 'vii';

-- y=ln sqrt(x^2-4), x>2 (vertical asymptote x=2)
UPDATE questions
SET parts = jsonb_set(parts, '{7,solution_graph}', $${"x_range":[1,8],"y_range":[-4,3],"curves":[{"expr":"log(sqrt(x^2-4))","domain":[2.02,8],"label":"y=\\ln\\sqrt{x^2-4}"}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2"}],"points":[{"x":2.23606797749979,"y":0,"label":"(\\sqrt5,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc216001-0000-0000-0000-000000000000' AND parts->7->>'label' = 'viii';

-- ellipse a^2x^2+b^2y^2=r^2, a>b>0. Representative a=2,b=1,r=2 -> x^2+y^2/4=1
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-1.5,1.5],"y_range":[-2.5,2.5],"curves":[{"x_expr":"cos(t)","y_expr":"2*sin(t)","domain":[0,6.283185307179586],"label":"\\frac{x^2}{(r/a)^2}+\\frac{y^2}{(r/b)^2}=1"}],"points":[{"x":1,"y":0,"label":"(r/a,\\ 0)","kind":"point"},{"x":-1,"y":0,"label":"(-r/a,\\ 0)","kind":"point"},{"x":0,"y":2,"label":"(0,\\ r/b)","kind":"point"},{"x":0,"y":-2,"label":"(0,\\ -r/b)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc214001-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- hyperbola (x-1)^2/36 - (y+1)^2/9 = 1, centre (1,-1)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-12,14],"y_range":[-8,6],"curves":[{"x_expr":"1+6/cos(t)","y_expr":"-1+3*tan(t)","domain":[0,6.283185307179586],"label":"\\frac{(x-1)^2}{36}-\\frac{(y+1)^2}{9}=1"}],"asymptotes":[{"kind":"oblique","expr":"0.5*x-1.5","label":"y=\\tfrac{1}{2}(x-1)-1"},{"kind":"oblique","expr":"-0.5*x-0.5","label":"y=-\\tfrac{1}{2}(x-1)-1"}],"points":[{"x":7,"y":-1,"label":"(7,\\ -1)","kind":"point"},{"x":-5,"y":-1,"label":"(-5,\\ -1)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc214001-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- parabola y=(x^2+x-2)/3
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-5,4],"y_range":[-1.5,7],"curves":[{"expr":"(x^2+x-2)/3","domain":[-5,4],"label":"y=\\dfrac{x^2+x-2}{3}"}],"points":[{"x":-0.5,"y":-0.75,"label":"(-\\tfrac{1}{2},\\ -\\tfrac{3}{4})","kind":"min"},{"x":-2,"y":0,"label":"(-2,\\ 0)","kind":"intercept"},{"x":1,"y":0,"label":"(1,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc214001-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- ellipse (x+2)^2/4+(y-1)^2=1, centre (-2,1)
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-5,1],"y_range":[-0.5,2.5],"curves":[{"x_expr":"-2+2*cos(t)","y_expr":"1+sin(t)","domain":[0,6.283185307179586],"label":"\\frac{(x+2)^2}{4}+(y-1)^2=1"}],"points":[{"x":0,"y":1,"label":"(0,\\ 1)","kind":"point"},{"x":-4,"y":1,"label":"(-4,\\ 1)","kind":"point"},{"x":-2,"y":2,"label":"(-2,\\ 2)","kind":"point"},{"x":-2,"y":0,"label":"(-2,\\ 0)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc214001-0000-0000-0000-000000000000' AND parts->3->>'label' = 'd';

-- hyperbola 36y^2-4x^2=1 (opens up/down), vertices (0,+-1/6)
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${"x_range":[-3,3],"y_range":[-1.2,1.2],"curves":[{"expr":"sqrt(4*x^2+1)/6","domain":[-3,3],"label":"36y^2=4x^2+1"},{"expr":"-sqrt(4*x^2+1)/6","domain":[-3,3]}],"asymptotes":[{"kind":"oblique","expr":"x/3","label":"y=\\tfrac{x}{3}"},{"kind":"oblique","expr":"-x/3","label":"y=-\\tfrac{x}{3}"}],"points":[{"x":0,"y":0.16666666666666666,"label":"(0,\\ \\tfrac{1}{6})","kind":"point"},{"x":0,"y":-0.16666666666666666,"label":"(0,\\ -\\tfrac{1}{6})","kind":"point"}]}$$::jsonb)
WHERE id = 'cc214001-0000-0000-0000-000000000000' AND parts->4->>'label' = 'e';

-- y=x^2-x+15, min (0.5,14.75)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-5,6],"y_range":[0,46],"curves":[{"expr":"x^2-x+15","domain":[-5,6],"label":"y=x^2-x+15"}],"points":[{"x":0.5,"y":14.75,"label":"(0.5,\\ 14.75)","kind":"min"},{"x":0,"y":15,"label":"(0,\\ 15)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc211004-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- y=2x^3-5x^2+x-2
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-1,3.2],"y_range":[-11,15],"curves":[{"expr":"2*x^3-5*x^2+x-2","domain":[-1,3],"label":"y=2x^3-5x^2+x-2"}],"points":[{"x":0,"y":-2,"label":"(0,\\ -2)","kind":"intercept"},{"x":2.46,"y":0,"label":"(2.46,\\ 0)","kind":"intercept"},{"x":0.107,"y":-1.95,"label":"(0.107,\\ -1.95)","kind":"max"},{"x":1.56,"y":-5.02,"label":"(1.56,\\ -5.02)","kind":"min"}]}$$::jsonb)
WHERE id = 'cc211004-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';

-- y=4x^2 e^x, max (-2,2.17), asymptote y=0
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-6,1.2],"y_range":[-0.5,12],"curves":[{"expr":"4*x^2*e^x","domain":[-6,1.1],"label":"y=4x^2e^x"}],"asymptotes":[{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":0,"y":0,"label":"(0,\\ 0)","kind":"min"},{"x":-2,"y":2.17,"label":"(-2,\\ 2.17)","kind":"max"}]}$$::jsonb)
WHERE id = 'cc211004-0000-0000-0000-000000000000' AND parts->2->>'label' = 'c';

-- y=5cos2x/x, asymptotes x=0,y=0; many x-intercepts
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-7,7],"y_range":[-15,15],"curves":[{"expr":"5*cos(2*x)/x","domain":[-7,-0.35],"label":"y=\\dfrac{5\\cos 2x}{x}"},{"expr":"5*cos(2*x)/x","domain":[0.35,7]}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"},{"kind":"horizontal","expr":"0","label":"y=0"}],"points":[{"x":0.7853981633974483,"y":0,"label":"(\\tfrac{\\pi}{4},0)","kind":"intercept"},{"x":-0.7853981633974483,"y":0,"label":"(-\\tfrac{\\pi}{4},0)","kind":"intercept"},{"x":2.356194490192345,"y":0,"label":"(\\tfrac{3\\pi}{4},0)","kind":"intercept"},{"x":-2.356194490192345,"y":0,"label":"(-\\tfrac{3\\pi}{4},0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc211004-0000-0000-0000-000000000000' AND parts->3->>'label' = 'd';

-- y=ln x/(2x), max (2.72,0.184), asymptote x=0, intercept (1,0)
UPDATE questions
SET parts = jsonb_set(parts, '{4,solution_graph}', $${"x_range":[0,10],"y_range":[-2.2,0.5],"curves":[{"expr":"log(x)/(2*x)","domain":[0.32,10],"label":"y=\\dfrac{\\ln x}{2x}"}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"}],"points":[{"x":1,"y":0,"label":"(1,\\ 0)","kind":"intercept"},{"x":2.718281828459045,"y":0.18393972058572117,"label":"(e,\\ \\tfrac{1}{2e})","kind":"max"}]}$$::jsonb)
WHERE id = 'cc211004-0000-0000-0000-000000000000' AND parts->4->>'label' = 'e';

-- Q6(ii) y=x^2/(x-2): VA x=2, oblique y=x+2, max (0,0), min (4,8)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-6,12],"y_range":[-12,20],"curves":[{"expr":"x^2/(x-2)","domain":[-6,1.9],"label":"y=\\dfrac{x^2}{x-2}"},{"expr":"x^2/(x-2)","domain":[2.1,12]}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2"},{"kind":"oblique","expr":"x+2","label":"y=x+2"}],"points":[{"x":0,"y":0,"label":"(0,\\ 0)","kind":"max"},{"x":4,"y":8,"label":"(4,\\ 8)","kind":"min"}]}$$::jsonb)
WHERE id = 'cc211006-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q7(iii) y=(x^2+9x+16)/(x+2): VA x=-2, oblique y=x+7
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-10,4],"y_range":[-6,16],"curves":[{"expr":"(x^2+9*x+16)/(x+2)","domain":[-10,-2.1],"label":"y=\\dfrac{x^2+9x+16}{x+2}"},{"expr":"(x^2+9*x+16)/(x+2)","domain":[-1.9,4]}],"asymptotes":[{"kind":"vertical","x":-2,"label":"x=-2"},{"kind":"oblique","expr":"x+7","label":"y=x+7"}],"points":[{"x":-0.586,"y":7.83,"label":"(-0.586,\\ 7.83)","kind":"min"},{"x":-3.414,"y":2.17,"label":"(-3.41,\\ 2.17)","kind":"max"},{"x":0,"y":8,"label":"(0,\\ 8)","kind":"intercept"},{"x":-6.56,"y":0,"label":"(-6.56,\\ 0)","kind":"intercept"},{"x":-2.44,"y":0,"label":"(-2.44,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc211007-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

-- Q8(iv) y=(x^2-4x+4)/(x+1): VA x=-1, oblique y=x-5, max (-4,-12), min (2,0)
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-12,10],"y_range":[-16,10],"curves":[{"expr":"(x^2-4*x+4)/(x+1)","domain":[-12,-1.1],"label":"y=\\dfrac{x^2-4x+4}{x+1}"},{"expr":"(x^2-4*x+4)/(x+1)","domain":[-0.9,10]}],"asymptotes":[{"kind":"vertical","x":-1,"label":"x=-1"},{"kind":"oblique","expr":"x-5","label":"y=x-5"}],"points":[{"x":-4,"y":-12,"label":"(-4,\\ -12)","kind":"max"},{"x":2,"y":0,"label":"(2,\\ 0)","kind":"min"},{"x":0,"y":4,"label":"(0,\\ 4)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc211008-0000-0000-0000-000000000000' AND parts->3->>'label' = 'iv';

-- Q9(ii) a=-3: y=(2x^2-3x-9)/(x-2): VA x=2, oblique y=2x+1, no stationary pts
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-8,10],"y_range":[-22,26],"curves":[{"expr":"(2*x^2-3*x-9)/(x-2)","domain":[-8,1.9],"label":"y=\\dfrac{2x^2-3x-9}{x-2}"},{"expr":"(2*x^2-3*x-9)/(x-2)","domain":[2.1,10]}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2"},{"kind":"oblique","expr":"2*x+1","label":"y=2x+1"}],"points":[{"x":0,"y":4.5,"label":"(0,\\ 4.5)","kind":"intercept"},{"x":3,"y":0,"label":"(3,\\ 0)","kind":"intercept"},{"x":-1.5,"y":0,"label":"(-1.5,\\ 0)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc211009-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q2(i) f=(x-4)^2+1, x>4: right half parabola, vertex (4,1) excluded
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[0,10],"y_range":[0,20],"curves":[{"expr":"(x-4)^2+1","domain":[4,8],"label":"y=f(x)"}],"points":[{"x":4,"y":1,"label":"(4,\\ 1)","kind":"point","open":true}]}$$::jsonb)
WHERE id = 'cc212002-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q2(iii) f^{-1}=4+sqrt(x-1), x>1, with y=x reflection line
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[0,18],"y_range":[0,12],"curves":[{"expr":"4+sqrt(x-1)","domain":[1.02,17],"label":"y=f^{-1}(x)"}],"segments":[{"from":[0,0],"to":[12,12],"style":"dashed","label":"y=x"}],"points":[{"x":1,"y":4,"label":"(1,\\ 4)","kind":"point","open":true}]}$$::jsonb)
WHERE id = 'cc212002-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

-- Q5(ii) piecewise periodic g on -2<x<=8 (period 4). Jumps 1->3 at x=0 and x=4.
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-2.5,8.5],"y_range":[0,4],"curves":[],"segments":[{"from":[-2,3],"to":[0,1],"style":"solid"},{"from":[0,3],"to":[2,3],"style":"solid"},{"from":[2,3],"to":[4,1],"style":"solid"},{"from":[4,3],"to":[6,3],"style":"solid"},{"from":[6,3],"to":[8,1],"style":"solid"}],"points":[{"x":0,"y":1,"label":"","kind":"point"},{"x":0,"y":3,"label":"","kind":"point","open":true},{"x":4,"y":1,"label":"","kind":"point"},{"x":4,"y":3,"label":"","kind":"point","open":true}]}$$::jsonb)
WHERE id = 'cc212005-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q6(i) income-tax piecewise-linear, continuous, increasing; range [0,inf)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[0,11],"y_range":[0,70],"curves":[],"segments":[{"from":[0,0],"to":[2,0],"style":"solid"},{"from":[2,0],"to":[3,2],"style":"solid"},{"from":[3,2],"to":[4,6],"style":"solid"},{"from":[4,6],"to":[8,34],"style":"solid"},{"from":[8,34],"to":[11,67],"style":"solid"}],"points":[{"x":2,"y":0,"label":"(2,0)","kind":"point"},{"x":4,"y":6,"label":"(4,6)","kind":"point"},{"x":8,"y":34,"label":"(8,34)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc212006-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q5(iv) base y=(2x-x^2)/(x^2-2x-3): VA x=-1,x=3, HA y=-1
UPDATE questions
SET parts = jsonb_set(parts, '{3,solution_graph}', $${"x_range":[-8,8],"y_range":[-8,6],"curves":[{"expr":"(2*x-x^2)/(x^2-2*x-3)","domain":[-8,-1.1],"label":"y=\\dfrac{2x-x^2}{x^2-2x-3}"},{"expr":"(2*x-x^2)/(x^2-2*x-3)","domain":[-0.9,2.9]},{"expr":"(2*x-x^2)/(x^2-2*x-3)","domain":[3.1,8]}],"asymptotes":[{"kind":"vertical","x":-1,"label":"x=-1"},{"kind":"vertical","x":3,"label":"x=3"},{"kind":"horizontal","expr":"-1","label":"y=-1"}],"points":[{"x":0,"y":0,"label":"(0,\\ 0)","kind":"intercept"},{"x":2,"y":0,"label":"(2,\\ 0)","kind":"intercept"},{"x":1,"y":-0.25,"label":"\\left(1,-\\tfrac{1}{4}\\right)","kind":"max"}]}$$::jsonb)
WHERE id = 'cc213005-0000-0000-0000-000000000000' AND parts->3->>'label' = 'iv';

-- Q7(iii) f=(x-9)^2/((x-3)(x+3)): VA x=-3,x=3, HA y=1
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-12,15],"y_range":[-12,14],"curves":[{"expr":"(x-9)^2/((x-3)*(x+3))","domain":[-12,-3.1],"label":"y=f(x)"},{"expr":"(x-9)^2/((x-3)*(x+3))","domain":[-2.9,2.9]},{"expr":"(x-9)^2/((x-3)*(x+3))","domain":[3.1,15]}],"asymptotes":[{"kind":"vertical","x":-3,"label":"x=-3"},{"kind":"vertical","x":3,"label":"x=3"},{"kind":"horizontal","expr":"1","label":"y=1"}],"points":[{"x":9,"y":0,"label":"(9,\\ 0)","kind":"intercept"},{"x":0,"y":-9,"label":"(0,\\ -9)","kind":"intercept"}]}$$::jsonb)
WHERE id = 'cc213007-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

-- Q9(ii) piecewise f on [-1,4]: 0 on [-1,0), 1 on [0,1], (1/4)(x-3)^2 on (1,3], 0 on (3,4]
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-1.5,4.5],"y_range":[-0.5,2],"curves":[{"expr":"0.25*(x-3)^2","domain":[1,3],"label":"y=f(x)"}],"segments":[{"from":[-1,0],"to":[0,0],"style":"solid"},{"from":[0,1],"to":[1,1],"style":"solid"},{"from":[3,0],"to":[4,0],"style":"solid"}],"points":[{"x":0,"y":0,"label":"","kind":"point","open":true},{"x":0,"y":1,"label":"(0,\\ 1)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213009-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q9(iii) y=1+f(x/2) on [-1,4]: 1 on [-1,0), 2 on [0,2], 1+(1/4)(x/2-3)^2 on (2,4]
UPDATE questions
SET parts = jsonb_set(parts, '{2,solution_graph}', $${"x_range":[-1.5,4.5],"y_range":[0,3],"curves":[{"expr":"1+0.25*(x/2-3)^2","domain":[2,4],"label":"y=1+f\\left(\\tfrac{x}{2}\\right)"}],"segments":[{"from":[-1,1],"to":[0,1],"style":"solid"},{"from":[0,2],"to":[2,2],"style":"solid"}],"points":[{"x":0,"y":1,"label":"","kind":"point","open":true},{"x":0,"y":2,"label":"(0,\\ 2)","kind":"point"}]}$$::jsonb)
WHERE id = 'cc213009-0000-0000-0000-000000000000' AND parts->2->>'label' = 'iii';

