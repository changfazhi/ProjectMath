-- 077_prompt_graphs_vector_planes.sql
-- Adds the GIVEN diagram (question-level `prompt_graph`, added in 061) to the two
-- diagram-dependent 3-D vector/plane questions from the newest papers (NJC 074,
-- JPJC 068) — both reference a figure ("A model of a triangular canopy … is shown
-- in Figure 1", "an inclined roof … as shown in the diagram below") that shipped
-- no image.
--
-- The graph engine is strictly 2-D, so each 3-D scene is drawn as the exam's flat
-- OBLIQUE PROJECTION. The projection for each was MEASURED off the original PDF
-- figures (2025/NJC, 2025/JPJC) so the reproduction matches the paper:
--   NJC : i=(1.30, 0.325)  [ground recedes up-right], j=(-0.28, 0.96) [depth up-left,
--         steep], k=(0,1).  -> reproduces Figure 2 (canopy ABC + streamer quad ECFG).
--   JPJC: i=(1.32,-0.19) [right, slightly down], j=(1.07, 0.24) [depth recedes right],
--         k=(0,1).  -> wall OABC + inclined roof slab + ground + support strut from P.
-- Every 3-D point (x,y,z) maps to screen (x*i + y*j + z*k). Edges are `segments`
-- (ground/hidden edges dashed), vertices are labelled `points` (kind "min" places a
-- ground-vertex label below the dot), the i/j/k triad + JPJC's Wall/Roof/Ground/
-- dimension captions are drawn with `segments` (arrows / zero-length label anchors).
-- Compiled by graphService.compileGraph; a malformed spec drops to null in stripSolution.

-- NJC P1 Q12 (7025000c): triangular canopy ABC held by vertical columns OA, DB, EC
-- over ground ODE; streamer quadrilateral ECFG (F on AB, G on OD) — the paper's Figure 2.
UPDATE questions SET prompt_graph = $${"x_range":[-2,15],"y_range":[-0.5,9.5],"x_label":null,"y_label":null,"segments":[{"from":[0,0],"to":[0,3]},{"from":[13,3.25],"to":[13,7.25]},{"from":[6.68,5.79],"to":[6.68,7.79]},{"from":[2.6,0.65],"to":[2.6,3.85]},{"from":[0,3],"to":[13,7.25]},{"from":[13,7.25],"to":[6.68,7.79]},{"from":[6.68,7.79],"to":[0,3]},{"from":[0,0],"to":[13,3.25],"style":"dashed"},{"from":[13,3.25],"to":[6.68,5.79],"style":"dashed"},{"from":[6.68,5.79],"to":[0,0],"style":"dashed"},{"from":[6.68,7.79],"to":[2.6,3.85]},{"from":[2.6,0.65],"to":[6.68,5.79]},{"from":[0,0],"to":[2.86,0.715],"arrow":true,"label":"\\mathbf{i}"},{"from":[0,0],"to":[-0.504,1.728],"arrow":true,"label":"\\mathbf{j}"},{"from":[0,0],"to":[0,1.8],"arrow":true,"label":"\\mathbf{k}"}],"points":[{"x":0,"y":0,"label":"O","kind":"min"},{"x":0,"y":3,"label":"A","kind":"point"},{"x":13,"y":7.25,"label":"B","kind":"point"},{"x":6.68,"y":7.79,"label":"C","kind":"point"},{"x":13,"y":3.25,"label":"D","kind":"min"},{"x":6.68,"y":5.79,"label":"E","kind":"min"},{"x":2.6,"y":3.85,"label":"F","kind":"point"},{"x":2.6,"y":0.65,"label":"G","kind":"min"}]}$$::jsonb
WHERE id = '7025000c-0000-0000-0000-000000000000';

-- JPJC P1 Q12 (8025000c): vertical rectangular wall OABC, inclined roof attached along
-- AB (drawn as a slab up to a ridge), horizontal ground, and a support strut from P up
-- to its foot on the roof. Captions Wall/Roof/Ground/3 m/5 m as in the paper's diagram.
UPDATE questions SET prompt_graph = $${"x_range":[-1.5,15],"y_range":[-2,10],"x_label":null,"y_label":null,"segments":[{"from":[0,0],"to":[8.58,-1.235],"style":"dashed"},{"from":[8.58,-1.235],"to":[13.93,-0.035],"style":"dashed"},{"from":[13.93,-0.035],"to":[5.35,1.2],"style":"dashed"},{"from":[0,0],"to":[0,3]},{"from":[0,3],"to":[5.35,4.2]},{"from":[5.35,4.2],"to":[5.35,1.2]},{"from":[5.35,1.2],"to":[0,0]},{"from":[0,3],"to":[3.1,8.4]},{"from":[3.1,8.4],"to":[12,8.1]},{"from":[12,8.1],"to":[5.35,4.2]},{"from":[8.49,-0.04],"to":[6.15,5.94]},{"from":[0,0],"to":[2.904,-0.418],"arrow":true,"label":"\\mathbf{i}"},{"from":[0,0],"to":[2.354,0.528],"arrow":true,"label":"\\mathbf{j}"},{"from":[0,0],"to":[0,1.8],"arrow":true,"label":"\\mathbf{k}"},{"from":[-0.8,1],"to":[-0.8,1],"label":"3\\,\\text{m}"},{"from":[2.3,3.4],"to":[2.3,3.4],"label":"5\\,\\text{m}"},{"from":[2.4,1.7],"to":[2.4,1.7],"label":"\\text{Wall}"},{"from":[5.2,5],"to":[5.2,5],"label":"\\text{Roof}"},{"from":[7.6,0.2],"to":[7.6,0.2],"label":"\\text{Ground}"}],"points":[{"x":0,"y":0,"label":"O","kind":"min"},{"x":0,"y":3,"label":"A","kind":"point"},{"x":5.35,"y":4.2,"label":"B","kind":"point"},{"x":5.35,"y":1.2,"label":"C","kind":"point"},{"x":8.49,"y":-0.04,"label":"P","kind":"min"},{"x":6.15,"y":5.94,"label":null,"kind":"point"}]}$$::jsonb
WHERE id = '8025000c-0000-0000-0000-000000000000';
