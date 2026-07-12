-- 064_ejc_q4_negative_branch.sql
-- Correction to EJC P1 Q4 (id 90250004) graphs. The original prompt diagram (062)
-- and the (a)/(b) model sketches (060) drew only the x>0 branch of y=f(2x). The
-- actual paper's diagram shows BOTH branches of the vertical asymptote x=0 — and
-- part (c) y=-f(|x|) is precisely the trick of taking only the x>=0 branch and
-- mirroring it, which only makes sense if the given curve has a left branch too.
-- Stand-in f(u)=2*((u-4)/u)^2 (from 060) is defined for all u!=0, so the branches
-- come for free: on x<0 the curve runs monotonically from the HA y=k up to +inf at
-- the asymptote. Re-runnable UPDATEs (idempotent); part (c) is already correct.

-- Given diagram y=f(2x)=2*((x-2)/x)^2 — both branches (VA x=0, min (2,0), HA y=k).
UPDATE questions SET prompt_graph = $${"x_range":[-10,10],"y_range":[-1,10],"curves":[{"expr":"2*((x-2)/x)^2","domain":[-10,-0.16]},{"expr":"2*((x-2)/x)^2","domain":[0.16,10],"label":"y=f(2x)"}],"asymptotes":[{"kind":"vertical","x":0,"label":"x=0"},{"kind":"horizontal","expr":"2","label":"y=k"}],"points":[{"x":2,"y":0,"label":"(2,\\ 0)","kind":"min"}]}$$::jsonb
WHERE id = '90250004-0000-0000-0000-000000000000';

-- Q4(a) y=f(2x+4)=2*(x/(x+2))^2 — both branches (VA x=-2, min (0,0), HA y=k).
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[-12,8],"y_range":[-1,10],"curves":[{"expr":"2*(x/(x+2))^2","domain":[-12,-2.1]},{"expr":"2*(x/(x+2))^2","domain":[-1.9,8],"label":"y=f(2x+4)"}],"asymptotes":[{"kind":"vertical","x":-2,"label":"x=-2"},{"kind":"horizontal","expr":"2","label":"y=k"}],"points":[{"x":0,"y":0,"label":"(0,\\ 0)","kind":"min"}]}$$::jsonb)
WHERE id = '90250004-0000-0000-0000-000000000000' AND parts->0->>'label' = 'a';

-- Q4(b) y=1/f(2x)=0.5*(x/(x-2))^2 — both branches (VA x=2, HA y=1/k, hole at (0,0)).
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[-12,10],"y_range":[-1,10],"curves":[{"expr":"0.5*(x/(x-2))^2","domain":[-12,-0.001]},{"expr":"0.5*(x/(x-2))^2","domain":[0.001,1.9]},{"expr":"0.5*(x/(x-2))^2","domain":[2.1,10],"label":"y=\\dfrac{1}{f(2x)}"}],"asymptotes":[{"kind":"vertical","x":2,"label":"x=2"},{"kind":"horizontal","expr":"0.5","label":"y=\\dfrac{1}{k}"}],"points":[{"x":0,"y":0,"label":"(0,\\ 0)","kind":"point","open":true}]}$$::jsonb)
WHERE id = '90250004-0000-0000-0000-000000000000' AND parts->1->>'label' = 'b';
