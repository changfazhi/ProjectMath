-- 061_prompt_graph_column.sql
-- Adds a question-level `prompt_graph` column: a GIVEN diagram shown in the
-- question PROMPT (before any attempt), for questions that say "the diagram
-- below shows ...". Unlike `parts[].solution_graph` (secret, revealed only after
-- an attempt), `prompt_graph` is compiled into the PUBLIC question payload —
-- it is given information the student needs to read to solve the question.
--
-- Same authored spec format as solution_graph (see migration 024/027 headers):
-- compiled server-side by graphService.compileGraph before it reaches the client.
-- Column-level change — table GRANTs already exist, none needed here.

ALTER TABLE public.questions ADD COLUMN IF NOT EXISTS prompt_graph JSONB;
