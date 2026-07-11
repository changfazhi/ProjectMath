-- Migration 058: scatter solution_graphs for CJC 2022 Correlation tutorial (migration 057).
-- Points-only scatter diagrams for the concrete data-table "draw scatter diagram" parts; Q9 also
-- draws Abi's line y=35-x/3. Abstract "possible/expected" sketches (Q1, Q4a) are left sketch-only.
-- Each spec compiled through graphService.compileGraph; every point lies inside its x/y range.

-- Q2 aggregate x vs monthly income y (8 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[40,75],"y_range":[2600,4600],"curves":[],"points":[{"x":72,"y":4400,"kind":"point"},{"x":55,"y":3550,"kind":"point"},{"x":65,"y":4000,"kind":"point"},{"x":45,"y":3000,"kind":"point"},{"x":60,"y":3800,"kind":"point"},{"x":50,"y":3200,"kind":"point"},{"x":42,"y":2850,"kind":"point"},{"x":62,"y":3950,"kind":"point"}],"x_label":"x\\ (\\text{aggregate})","y_label":"y\\ (\\$)"}$$::jsonb)
WHERE id = 'cc228002-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q3 traffic flow x vs pollution y (8 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[1700,2900],"y_range":[0,6],"curves":[],"points":[{"x":1796,"y":1,"kind":"point"},{"x":1918,"y":2.2,"kind":"point"},{"x":2120,"y":3.5,"kind":"point"},{"x":2315,"y":4.2,"kind":"point"},{"x":2368,"y":4.3,"kind":"point"},{"x":2420,"y":4.5,"kind":"point"},{"x":2588,"y":4.9,"kind":"point"},{"x":2850,"y":5.5,"kind":"point"}],"x_label":"x","y_label":"y"}$$::jsonb)
WHERE id = 'cc228003-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q5 year x vs record time t (8 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[1925,2005],"y_range":[0,45],"curves":[],"points":[{"x":1930,"y":40.4,"kind":"point"},{"x":1940,"y":36.4,"kind":"point"},{"x":1950,"y":31.3,"kind":"point"},{"x":1960,"y":24.5,"kind":"point"},{"x":1970,"y":21.1,"kind":"point"},{"x":1980,"y":19,"kind":"point"},{"x":1990,"y":16.3,"kind":"point"},{"x":2000,"y":13.1,"kind":"point"}],"x_label":"x\\ (\\text{year})","y_label":"t"}$$::jsonb)
WHERE id = 'cc228005-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q6 wind speed v vs drag force F (10 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[0,40],"y_range":[0,36],"curves":[],"points":[{"x":0,"y":0,"kind":"point"},{"x":4,"y":2.5,"kind":"point"},{"x":8,"y":5.1,"kind":"point"},{"x":12,"y":8.8,"kind":"point"},{"x":16,"y":11.2,"kind":"point"},{"x":20,"y":13.6,"kind":"point"},{"x":24,"y":17.6,"kind":"point"},{"x":28,"y":22,"kind":"point"},{"x":32,"y":27.8,"kind":"point"},{"x":36,"y":33.9,"kind":"point"}],"x_label":"v","y_label":"F"}$$::jsonb)
WHERE id = 'cc228006-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q7 power x vs efficiency y (outlier at (3,87.4)) (11 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[0,52],"y_range":[70,95],"curves":[],"points":[{"x":1,"y":72.5,"kind":"point"},{"x":1.5,"y":82.5,"kind":"point"},{"x":2,"y":84,"kind":"point"},{"x":3,"y":87.4,"kind":"point"},{"x":5,"y":87.5,"kind":"point"},{"x":7.5,"y":88.5,"kind":"point"},{"x":10,"y":89.5,"kind":"point"},{"x":20,"y":90.2,"kind":"point"},{"x":30,"y":91,"kind":"point"},{"x":40,"y":91.7,"kind":"point"},{"x":50,"y":92.4,"kind":"point"}],"x_label":"x","y_label":"y\\,\\%"}$$::jsonb)
WHERE id = 'cc228007-0000-0000-0000-000000000000' AND parts->0->>'label' = 'i';

-- Q8 housing index x vs food index y (7 known pairs; 2011 x missing) (7 points)
UPDATE questions
SET parts = jsonb_set(parts, '{1,solution_graph}', $${"x_range":[95,152],"y_range":[95,126],"curves":[],"points":[{"x":100,"y":100,"kind":"point"},{"x":100.7,"y":101.6,"kind":"point"},{"x":102.3,"y":104.6,"kind":"point"},{"x":116.8,"y":112.6,"kind":"point"},{"x":123.1,"y":115.2,"kind":"point"},{"x":124.3,"y":116.8,"kind":"point"},{"x":148,"y":123.1,"kind":"point"}],"x_label":"x","y_label":"y"}$$::jsonb)
WHERE id = 'cc228008-0000-0000-0000-000000000000' AND parts->1->>'label' = 'ii';

-- Q9 speed x vs consumption y, with Abi's line y=35-x/3 (5 points)
UPDATE questions
SET parts = jsonb_set(parts, '{0,solution_graph}', $${"x_range":[35,65],"y_range":[12,25],"curves":[],"points":[{"x":40,"y":22,"kind":"point"},{"x":45,"y":20,"kind":"point"},{"x":50,"y":18,"kind":"point"},{"x":55,"y":17,"kind":"point"},{"x":60,"y":16,"kind":"point"}],"segments":[{"from":[36,23],"to":[64,13.666666666666668],"label":"y=35-\\tfrac13 x"}],"x_label":"x","y_label":"y"}$$::jsonb)
WHERE id = 'cc228009-0000-0000-0000-000000000000' AND parts->0->>'label' = 'ia';

