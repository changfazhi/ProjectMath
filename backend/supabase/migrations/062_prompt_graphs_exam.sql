-- 062_prompt_graphs_exam.sql
-- Adds the GIVEN diagram (question-level `prompt_graph`, added in 061) to exam
-- questions whose prompt says "the diagram shows ..." but shipped no image, so
-- the question was previously impossible to attempt. Same authored spec format as
-- solution_graph (compiled by graphService.compileGraph; every spec validated
-- through it, labelled min/max/intercept points verified on-curve).
--
-- Abstract-f diagrams reuse the exact stand-in already used by that question's
-- solution sketch so the given curve matches the model answer:
--   EJC Q4  -> f(u)=2*((u-4)/u)^2 from migration 060  => y=f(2x)=2*((x-2)/x)^2
--   RI  Q5  -> features from migration 027 (through (1,0),(3,0); TPs (1,0),(4,4))
--   YIJC Q6 -> stand-in f(x)=-1-x-4/x^2 from migration 032
-- Concrete diagrams (RI 10bi, YIJC 12) use the equation already in the prompt.
-- DHS 10 / HCI 5 are non-coordinate figures drawn with the pipeline's segment +
-- parametric support (inscribed Riemann discs / circular-track schematic).

-- EJC P1 Q4 (Transformation): given y=f(2x), TP (2,0), asymptotes x=0, y=k.
UPDATE questions SET prompt_graph = $${"x_range":[-1,10],"y_range":[-1,10],"curves":[{"expr":"2*((x-2)/x)^2","domain":[0.16,10],"label":"y=f(2x)"}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"},{"kind":"horizontal","expr":"2","label":"y=k"}],"points":[{"x":2,"y":0,"label":"(2,\\ 0)","kind":"min"}]}$$::jsonb
WHERE id = '90250004-0000-0000-0000-000000000000';

-- EJC P1 Q5 (Definite Integral): given y=1/x on [1,2] with n rectangles under the curve.
UPDATE questions SET prompt_graph = $${"x_range":[0,2.6],"y_range":[0,1.6],"curves":[{"expr":"1/x","domain":[0.8,2.4],"label":"y=\\dfrac{1}{x}"}],"segments":[{"from":[1,0],"to":[1,0.8]},{"from":[1,0.8],"to":[1.25,0.8]},{"from":[1.25,0],"to":[1.25,0.8]},{"from":[1.25,0],"to":[1.25,0.6666666666666666]},{"from":[1.25,0.6666666666666666],"to":[1.5,0.6666666666666666]},{"from":[1.5,0],"to":[1.5,0.6666666666666666]},{"from":[1.5,0],"to":[1.5,0.5714285714285714]},{"from":[1.5,0.5714285714285714],"to":[1.75,0.5714285714285714]},{"from":[1.75,0],"to":[1.75,0.5714285714285714]},{"from":[1.75,0],"to":[1.75,0.5]},{"from":[1.75,0.5],"to":[2,0.5]},{"from":[2,0],"to":[2,0.5]}],"points":[{"x":1,"y":1,"label":"(1,\\ 1)","kind":"point"},{"x":2,"y":0.5,"label":"(2,\\ \\tfrac{1}{2})","kind":"point"}]}$$::jsonb
WHERE id = '90250005-0000-0000-0000-000000000000';

-- RI P1 Q5 (Graphing): given y=f(x), through (1,0),(3,0), TPs (1,0),(4,4), asy x=0,x=2,y=2.
UPDATE questions SET prompt_graph = $${"x_range":[-6,10],"y_range":[-2,8],"curves":[{"expr":"2+2/x^2","domain":[-6,-0.12]},{"expr":"(x-1)^2/(x*(2-x))","domain":[0.06,1.94]},{"expr":"2+6/(x-2)-8/(x-2)^3","domain":[2.06,10],"label":"y=f(x)"}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"},{"kind":"vertical","x":2,"label":"x=2"},{"kind":"horizontal","expr":"2","label":"y=2"}],"points":[{"x":1,"y":0,"label":"(1,\\ 0)","kind":"min"},{"x":3,"y":0,"label":"(3,\\ 0)","kind":"intercept"},{"x":4,"y":4,"label":"(4,\\ 4)","kind":"max"}]}$$::jsonb
WHERE id = 'e0250005-0000-0000-0000-000000000000';

-- RI P1 Q10(b)(i) (Definite Integral): given y=2-x/sqrt(2x-1), asy x=1/2, TP (1,1), x-int 4±2√3.
UPDATE questions SET prompt_graph = $${"x_range":[0,9],"y_range":[-3,2],"curves":[{"expr":"2 - x/sqrt(2*x-1)","domain":[0.515,9],"label":"y=2-\\dfrac{x}{\\sqrt{2x-1}}"}],"asymptotes":[{"kind":"vertical","x":0.5,"label":"x=\\tfrac{1}{2}"}],"points":[{"x":1,"y":1,"label":"(1,\\ 1)","kind":"max"},{"x":0.535898,"y":0,"label":"(4-2\\sqrt3,\\ 0)","kind":"intercept"},{"x":7.464102,"y":0,"label":"(4+2\\sqrt3,\\ 0)","kind":"intercept"}]}$$::jsonb
WHERE id = 'e0250010-0000-0000-0000-000000000000';

-- YIJC P1 Q6 (Transformation): given y=f(x), oblique asy y=a+bx, VA x=0, x-int (c,0), TP (d,e).
UPDATE questions SET prompt_graph = $${"x_range":[-8,8],"y_range":[-12,10],"curves":[{"expr":"-1-x-4/x^2","domain":[-8,-0.62]},{"expr":"-1-x-4/x^2","domain":[0.62,8],"label":"y=f(x)"}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"},{"kind":"oblique","expr":"-1-x","label":"y=a+bx"}],"points":[{"x":-2,"y":0,"label":"(c,\\ 0)","kind":"intercept"},{"x":2,"y":-4,"label":"(d,\\ e)","kind":"max"}]}$$::jsonb
WHERE id = 'f0250006-0000-0000-0000-000000000000';

-- YIJC P2 Q12 (Definite Integral): region R bounded by ellipse 4x^2+(y-2)^2=4 and line y=2x.
UPDATE questions SET prompt_graph = $${"x_range":[-1.5,1.8],"y_range":[-0.5,4.5],"curves":[{"x_expr":"cos(t)","y_expr":"2+2*sin(t)","domain":[0,6.2831853],"label":"4x^2+(y-2)^2=4"},{"expr":"2*x","domain":[-0.2,1.35],"label":"y=2x"}],"points":[{"x":0,"y":0,"label":"O","kind":"point"},{"x":1,"y":2,"label":"(1,\\ 2)","kind":"point"},{"x":0.55,"y":0.8,"label":"R","kind":"point"}]}$$::jsonb
WHERE id = 'f0250012-0000-0000-0000-000000000000';

-- DHS P1 Q10 (Definite Integral): y=f(x)=x^2/sqrt(1+e^x) with n inscribed discs
-- (left-endpoint Riemann rectangles under an increasing curve — V1 < V).
UPDATE questions SET prompt_graph = $${"x_range":[0,4],"y_range":[0,2.4],"curves":[{"expr":"x^2/sqrt(1+e^x)","domain":[0.3,3.6],"label":"y=f(x)"}],"segments":[{"from":[1,0],"to":[1,0.5185956241330958]},{"from":[1,0.5185956241330958],"to":[1.5,0.5185956241330958]},{"from":[1.5,0],"to":[1.5,0.5185956241330958]},{"from":[1.5,0],"to":[1.5,0.9610042738040654]},{"from":[1.5,0.9610042738040654],"to":[2,0.9610042738040654]},{"from":[2,0],"to":[2,0.9610042738040654]},{"from":[2,0],"to":[2,1.3810310468464786]},{"from":[2,1.3810310468464786],"to":[2.5,1.3810310468464786]},{"from":[2.5,0],"to":[2.5,1.3810310468464786]},{"from":[2.5,0],"to":[2.5,1.7213977335525414]},{"from":[2.5,1.7213977335525414],"to":[3,1.7213977335525414]},{"from":[3,0],"to":[3,1.7213977335525414]}]}$$::jsonb
WHERE id = 'd025000a-0000-0000-0000-000000000000';

-- HCI P1 Q5 (App. of Differentiation): tram schematic — circular path centre O,
-- arc A->B (angle AOB=theta), then straight B->C.
UPDATE questions SET prompt_graph = $${"x_range":[-5,7],"y_range":[-5,6],"curves":[{"x_expr":"4*cos(t)","y_expr":"4*sin(t)","domain":[0,6.2831853],"label":"radius\\ 450\\text{ m}"}],"segments":[{"from":[0,0],"to":[0,4]},{"from":[0,0],"to":[3.064177772475912,2.571150438746157]},{"from":[3.064177772475912,2.571150438746157],"to":[6,1]}],"points":[{"x":0,"y":0,"label":"O","kind":"point"},{"x":0,"y":4,"label":"A","kind":"point"},{"x":3.064177772475912,"y":2.571150438746157,"label":"B","kind":"point"},{"x":6,"y":1,"label":"C","kind":"point"}]}$$::jsonb
WHERE id = 'c0250005-0000-0000-0000-000000000000';
