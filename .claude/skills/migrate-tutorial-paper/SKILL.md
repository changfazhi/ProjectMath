---
name: migrate-tutorial-paper
description: "Migrate H2 Math lecture-note TUTORIAL papers (DISCUSSION questions only, provenance stripped) into the Supabase question bank, incl. deferred solution_graph sketches. Use when the user points at a folder of tutorial teacher PDFs + solution PDFs (not exam papers) and wants the discussion questions loaded."
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
---

# Migrate a Tutorial Paper into the Database

Loads the **DISCUSSION** questions from H2 Math *lecture-note tutorials* (teacher PDFs
with a `DISCUSSION` section followed by `REVIEW PROBLEMS`) into the question bank. This
is the non-exam sibling of the exam-extraction workflow in **`skills.md`** — read that
first for the shared rules (part classification §3, LaTeX-in-JSON escaping §7, JSON
validation §9, `solution_graph` authoring §12). This skill only documents what differs
for tutorials. Reference implementation: migrations `034`–`042` (the CJC 2021 `cc21` set).

## What makes a "tutorial paper" different from an exam paper

| | Exam paper (skills.md) | Tutorial paper (this skill) |
|---|---|---|
| Structure | Whole paper is questions | One `DISCUSSION` block, then `REVIEW PROBLEMS` (**exclude** the latter) |
| Scope | All questions | DISCUSSION only |
| Provenance | Kept (`'<School> H2 Math Prelim 2025'`) | **Stripped** — generic source, inline exam tags removed |
| Difficulty | Author's judgement | Often labelled `BASIC` / `INTERMEDIATE` / `ADVANCED` sub-headers |
| Marks | `[N]` per part | Usually none → omit `marks` in part prompts |
| Content | Balanced | Very graph-heavy → many `null` sketch parts |

## Step 1 — Locate the PDFs and the DISCUSSION range

The source is usually two sibling folders (teacher papers + solutions), one PDF per topic:

```bash
find "<TUTORIAL_DIR>" -type f -name '*.pdf'
# For each teacher PDF, find the DISCUSSION → REVIEW PROBLEMS page range:
for p in $(seq 1 $NP); do t=$(pdftotext -f $p -l $p "$PDF" - 2>/dev/null); \
  echo "$t" | grep -qE "^DISCUSSION|REVIEW PROBLEMS|^Answers:" && echo "p$p: ..."; done
```

Extract **only** the pages from `DISCUSSION` up to (not including) `REVIEW PROBLEMS`.
The typed "Answers:" list usually sits at the end of the DISCUSSION block — grab it too.

## Step 2 — Render pages and read them visually (non-negotiable)

`pdftotext` collapses superscripts/fractions/limits — never transcribe LaTeX from it.
Render each DISCUSSION page (and its worked-solution page) to PNG and Read the image:

```bash
pdftoppm -f <start> -l <end> -r 150 -png "<teacher.pdf>" <scratchpad>/t
pdftoppm -f <start> -l <end> -r 150 -png "<solution.pdf>" <scratchpad>/sol
```

Re-derive every non-trivial numeric answer yourself (systems, areas, counts) rather than
trusting the OCR of the answer key.

## Step 3 — ID scheme & provenance stripping

- **New hex-valid prefix per tutorial set** (e.g. `cc21` = CJC 2021). Number =
  `<topic-index><3-digit Q#>`, where topic-index is the tutorial file number.
  Full UUID `<prefix>NNNN-0000-0000-0000-000000000000`. Example: Parametric (file 6)
  Q1 → `cc216001`. Confirm the prefix doesn't collide with existing sets (see CLAUDE.md).
- **`source` = generic `'H2 Math Tutorial (<Topic>)'`** — no school, year, or level.
- **Remove inline exam-reference tags** from every `prompt_latex`
  (`[2008/CJC/JC1/MYE/2]`, `[2017 CJC MYE/I/4]`, `[N2016/P1/3]`, …).
- Difficulty: `BASIC`→1, `INTERMEDIATE`→2, `ADVANCED`→3; header-less topics default 2.
- Omit per-part `[N]` marks; set a nominal question-level `marks`.
- Topic UUID from the tutorial's topic (CLAUDE.md → Topic UUIDs).

If an earlier cut was already loaded with provenance, ship a small `NNNb` migration that
`UPDATE`s `source` (via `replace(...)`) and strips the tags — idempotent, `WHERE`-guarded.
(The frontend renders `question.source` verbatim in `QuestionHeader.tsx`, so DB rows must be fixed, not just the migration file.)

## Step 4 — Classify parts & choose what to grade

Follow **skills.md §3** (classify by command word). Tutorial-specific grading policy
(matches the reference set):

- **Sketch / draw** → `null` part; gets a deferred `solution_graph` (Step 6).
- **Prove / show / describe / "state whether …" / odd-even / symmetry** → `null`.
- **Clean scalar / y=f(x) expression / inverse rule / partial-fraction constants /
  count** → graded (`exact`/`range`).
- **Cartesian/asymptote/line equations** → gradable but brittle → enable **with a
  `-- FLAG:` comment** and a canonical form.
- **Inequality / range solution sets** → the crux for the Inequalities topic:
  - single clean interval (`-1/8 ≤ x ≤ 19/4`, `-5<k<3`) → FLAG-enable one box;
  - compound (`x<-9 or x>3/2`), unions, surds, isolated points, empty set → **`null`**
    (the revealed `solution_latex` is the answer key). Do not ship boxes exact-match
    will reject on correct work.
- **Several named values in one ask** (`a,b,c` / `W,M,D` / asymptote pair) →
  multi-box `answers[]` in a single part, part-level `answer_type`/`correct_answer` kept
  as non-null sentinels (skills.md §3). The part label still renders as `(a)`.
- **Diagram-dependent questions** (traffic networks, tunnel cross-sections): the diagram
  won't survive as an image — **describe it faithfully in prose** in `prompt_latex` so the
  question is self-contained, and verify your description reproduces the answer.

Question-level `answer_type` is `NOT NULL`: for an all-sketch/prose question use a
one-or-more-`null`-part wrapper with a `'exact', ''` row fallback (CLAUDE.md pitfall).

## Step 5 — Write & validate the question migrations

- **One migration file per topic**, next free numbers (e.g. `034`–`040`). Match the exact
  column order and `$$…$$` dollar-quoting of `031_yijc_prelim_2025.sql`.
- Escaping: `prompt_latex`/`solution_latex` are dollar-quoted (single `\`); inside
  `parts` JSON double every backslash, `\\` line-break → `\\\\` (skills.md §7).
- Validate JSON in every file before handing off (regex matches INSERT-style blocks too):

```bash
python3 - "$FILE" <<'PY'
import re, json, sys
c = open(sys.argv[1]).read()
for i, b in enumerate(re.findall(r'\$\$(\[.*?\])\$\$::jsonb', c, re.DOTALL)):
    p = json.loads(b)   # raises on malformed
    for part in p:
        assert {'label','answer_type','correct_answer'} <= part.keys()
        for f in part.get('answers') or []:
            assert f.get('key') and f.get('label') and f.get('answer_type') and 'correct_answer' in f
    print(f'block {i+1}: OK {[x["label"] for x in p]}')
PY
```

## Step 6 — Deferred `solution_graph` sketches (split concrete vs abstract)

Author graphs **after** the questions land (mirrors how the repo shipped `031`→`032`).
Follow **skills.md §12**, but split into two migrations by confidence:

- **Concrete curves** (parametric/conic/rational/piecewise/log — fully determined by the
  equation + answer-key turning points): high confidence.
- **Abstract-`f` stand-ins** (transformations of an unknown graph, reciprocals of hand-drawn
  curves): construct a concrete function that passes through **every** labelled feature. The
  reference trick: for a curve with max `(-1,2)`, asymptote `y=-2`, through `(0,0)`, use
  `f(x)=-2+4/((x+1)^2+1)` and derive each transform in closed form. Keep point labels
  **symbolic** where a parameter is abstract (`(a, 1/b)`, `x=b`); note the representative
  value in a comment. **If no clean stand-in can match all of {VA, HA, several intercepts,
  two turning points} at once, leave that part sketch-only (no graph) — never ship a
  misleading diagram.**

Build with a throwaway TS harness (like migration 027) so every spec is compiled through the
real `compileGraph` and points are checked on-curve, then generate the SQL:

```ts
// backend/gen0NN.ts  →  npx tsx gen0NN.ts > out.sql   (delete the script after)
import { compileGraph } from './src/services/graphService.js';
import type { SolutionGraphSpec } from './src/types/index.js';
const entries = [ /* {id, idx, label, note, spec} ... */ ];
for (const e of entries) {
  const r = compileGraph(e.label, e.spec);        // must not throw
  // assert: every curve has ≥1 non-empty segment; every min/max/intercept point
  // sits within ~0.02 of a rendered polyline vertex; all points inside x/y range.
}
// emit: UPDATE questions SET parts = jsonb_set(parts,'{IDX,solution_graph}',
//       $$${JSON.stringify(spec)}$$::jsonb)
//       WHERE id='...' AND parts->IDX->>'label'='LABEL';   -- label-guarded (§12 step 2)
```

`JSON.stringify(spec)` handles the backslash doubling. Spec fields: `x_expr`/`y_expr` over a
t-interval for parametric/conic curves, `expr` over x for explicit; split explicit curves at
each vertical asymptote; `points[].kind` `min|max|intercept` are on-curve-validated (`point`
is free-floating); `open:true` for excluded endpoints; `segments` for straight/piecewise lines.

## Step 7 — Docs & ship

- Update **CLAUDE.md**: add the new prefix to *Topic UUIDs* (a `**Tutorial … prefix cc21**`
  paragraph) and a bullet to the *Database Setup* migration list; note the graph split.
- Branch off `origin/main` (not whatever feature branch is checked out), stage only the
  migrations + CLAUDE.md (**not** the large source PDFs), commit with the standard trailer,
  push, and open a PR against `main`.

## Verify end-to-end

1. Per file: the JSON validator above; for graphs, the `compileGraph` harness (all render,
   points on-curve).
2. User runs migrations in Supabase in numeric order (`…b` before the rest of its number's
   siblings; graphs last).
3. In-app (skills.md §11/§12 step 6): open the topic, confirm questions/preamble/per-part
   boxes render, a graded part submits ✓/✗, the full solution reveals after the last graded
   part, and revealed sketches show dots on curves with asymptotes/open-circles/labels.
