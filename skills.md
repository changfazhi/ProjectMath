# Skill: Extract Exam Questions from PDF and Write Migration

This guide covers the end-to-end workflow for reading a Singapore H2 Math exam paper from Google Drive, extracting questions into structured data, and writing a Supabase migration to populate the database.

---

## 1. Access the PDF from Google Drive

Use the `mcp__claude_ai_Google_Drive__search_files` and `mcp__claude_ai_Google_Drive__read_file_content` tools.

```
search_files(query: "ASRJC Prelim 2025")          # find the file ID
read_file_content(file_id: "<id>", mime_type: "text/plain")
```

Exam papers typically come in two files: **questions** and **solutions/marking scheme**. Read both. The solutions file is essential for:
- Correct answers (especially for multi-step questions)
- Tolerances on numerical answers
- Identifying "show that" vs. "find" parts

---

## 2. Assign Question IDs

Follow the existing UUID convention for this project:

| Paper | Pattern | Example |
|---|---|---|
| Paper 1 | `cafe00NN-0000-0000-0000-000000000000` | `cafe0001-...` |
| Paper 2 | `cafe10NN-0000-0000-0000-000000000000` | `cafe1001-...` |

`NN` is the question number (01, 02, ...). If there are already questions in the DB from a previous migration, check the highest existing NN and continue from there.

Topic UUIDs follow `aaaa000N-...` (Pure Math) and `bbbb000N-...` (Statistics). Full mapping is in `CLAUDE.md`.

---

## 3. Classify Each Question and Its Parts

For each question, decide:

### Is it single-answer or multi-part?

- **Single-answer**: the entire question has one numerical/algebraic answer (e.g. "Find the area"). Keep `parts = NULL` and set `correct_answer` directly on the question row.
- **Multi-part**: the question has labelled parts (a), (b), (c)... or (a)(i), (a)(ii)... Use the `parts` JSONB column.

### Preamble vs. per-part split

For multi-part questions:
- `prompt_latex` on the question row → **shared preamble only** (definitions, given context, diagrams description that all parts share)
- Each element of `parts` → one sub-question with its own `prompt_latex`

If there is no shared context (parts are independent), set `prompt_latex = ''`.

### Answer type for each part — classify by the COMMAND WORD, not by surface keywords

> ⚠️ **The #1 historical mistake:** flagging a part as `null` (no submission) just because its text contains "show that" or "sketch", when the part *also* asks the student to compute something. Migration 021 had to retro-fix ~120 such parts. **Read the whole part and classify by what the student must produce.**

| The part asks the student to… | `answer_type` | Notes |
|---|---|---|
| **find, determine, calculate, evaluate, compute, solve, express, deduce \[a value], write down, give, state \[a value]** | `"exact"` or `"range"` | **A typed box is expected.** Pull the answer from `solution_latex`. |
| Only **prove / show that / verify \[an identity]** (no value asked afterwards) | `null` | True proof — no box. |
| Only **sketch / draw / plot / construct** | `null` | Diagram — no box, **but it MUST get a `solution_graph`** (see §12). |
| Only **describe / explain / comment / justify / interpret** | `null` | Prose — exact-match can't grade it. |

Decide `"exact"` vs `"range"`: exact LaTeX/algebraic answer → `"exact"`; a decimal rounded to s.f./d.p. → `"range"` with a tolerance.

**Tolerance guidelines for `"range"` answers:**

| Type | Suggested tolerance |
|---|---|
| Probability (3 s.f.) | `0.002` |
| Small probability < 0.05 | `0.0002` |
| Integer answer (nearest integer) | `1` |
| Length/area (2 d.p.) | `0.005` |
| Coefficient/constant (3 s.f.) | `0.005` |

### Mixed parts: "show that X, hence find Y"

A part can contain *both* a show-that step and a real ask. **Grade on the computed result.** Set the part's `answer_type`/`correct_answer` to **Y** (the value the student must find); the show-that step is just working and isn't separately graded. Do **not** make the whole part `null` — that hides the answer box the student needs.

Likewise "find the cartesian equation … hence sketch" → grade the equation; "state the value of h and explain …" → grade h.

### Parts asking for SEVERAL values → multi-box `answers[]`

If a part asks for **two or more named values** ("find a, b and c", "find \|p\| and arg(p)", "find the mean and variance", "find the values of x₁₀ and x₁₁"), render **one box per value** using a per-part `answers[]` array. The part is correct only when **every** field matches.

```json
{
  "label": "b",
  "prompt_latex": "…find the exact values of a, b and c…",
  "answer_type": "exact",                  // NON-NULL sentinel — keeps existing "graded part" logic working
  "correct_answer": "a=2/3, b=5/2, c=23/6", // display fallback (stripped before client)
  "tolerance": null,
  "answers": [
    { "key": "a", "label": "a", "correct_answer": "\\frac{2}{3}",  "answer_type": "exact", "tolerance": null },
    { "key": "b", "label": "b", "correct_answer": "\\frac{5}{2}",  "answer_type": "exact", "tolerance": null },
    { "key": "c", "label": "c", "correct_answer": "\\frac{23}{6}", "answer_type": "exact", "tolerance": null }
  ]
}
```

Rules:
- Each field has its own `key` (unique within the part), `label` (rendered beside the box, e.g. `"a"`, `"|u|"`, `"\\text{mean}"`), `correct_answer`, `answer_type` (`"exact"` or `"range"`), and `tolerance`.
- Keep the **part-level** `answer_type` and `correct_answer` as **non-null sentinels** (e.g. `"exact"` + a human-readable joined string). This is required so the existing "graded part" / "reveal when all parts done" logic still counts the part. Both the part-level and per-field `correct_answer`s are stripped before reaching the client.
- Backend type: `PartAnswerField` in `backend/src/types/index.ts`; rendering: `MultiFieldInput` in `MultiPartQuestion.tsx`. See **CLAUDE.md → Multi-Part Questions** for the full contract.

Do **not** cram several values into one box (e.g. `"a=2/3, b=5/2"`) — exact-match is order/format sensitive and will reject correct work.

### Answers exact-match can't grade reliably — choose deliberately

The grader is a normalised string / numeric / multi-point-symbolic match. It is **brittle** for: ranges & inequalities (`1<x<5/3`), equations of lines/planes, general solutions with arbitrary constants, vectors / coordinates, complex numbers, and **indefinite integrals** (`+C` and infinitely many equivalent forms). Options, in order of preference:
1. If the part has a *clean* scalar result, grade that and leave the messy form as working.
2. If you must enable a box for a messy answer, do it — but add an inline SQL comment `-- FLAG: <reason>` so it can be reviewed, and prefer the form a MathLive keyboard actually outputs (braced surds `\sqrt{3}`, etc.).
3. If nothing is cleanly gradable (pure prose, a distribution table, a "describe" answer), keep the part `null`.

(Project convention had been "indefinite integrals are always `null`"; if you override that, treat it as option 2 and FLAG it.)

---

## 4. Write the Schema Migration (if needed)

If `parts` or `part_label` columns don't yet exist, write `NNN_schema.sql` first:

```sql
ALTER TABLE questions ADD COLUMN IF NOT EXISTS parts JSONB;
ALTER TABLE attempts  ADD COLUMN IF NOT EXISTS part_label TEXT;
GRANT ALL ON TABLE public.questions TO service_role;
GRANT ALL ON TABLE public.attempts  TO service_role;
```

---

## 5. Write the INSERT Migration for New Questions

File: `NNN_<exam_name>.sql`

### Single-answer question template

```sql
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cafe0001-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',  -- topic UUID
  2,                                        -- difficulty: 1=Easy, 2=Medium, 3=Hard
  'Short descriptive name',
  $$Full question text with \(inline math\) and \[display math\].$$,
  'exact',                                  -- or 'range' or null
  'x^2 + 1',                               -- correct answer as LaTeX
  NULL,                                     -- tolerance (NULL for exact)
  $$Solution text with \(math\).$$,
  4,                                        -- mark count
  'ASRJC H2 Math Prelim 2025'
);
```

### Multi-part question template

```sql
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cafe0002-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  2,
  'Short descriptive name',
  $$Shared preamble: \(x^3 + y^3 = 3axy\), where \(a \neq 0\).$$,  -- preamble only
  'range',          -- overall question answer_type (used as fallback; set to the last graded part)
  '8.46',           -- overall correct_answer (fallback)
  0.005,            -- overall tolerance (fallback)
  $$Full solution covering all parts.$$,
  9,
  'ASRJC H2 Math Prelim 2025',
  $$[
    {
      "label": "a",
      "prompt_latex": "Show that the area equals \\(\\int_b^a 4\\cos^2\\theta\\,d\\theta - c\\). \\([6]\\)",
      "correct_answer": null,
      "answer_type": null,
      "tolerance": null
    },
    {
      "label": "b",
      "prompt_latex": "Find the volume of revolution to 2 decimal places. \\([3]\\)",
      "correct_answer": "8.46",
      "answer_type": "range",
      "tolerance": 0.005
    }
  ]$$::jsonb
);
```

---

## 6. Write the UPDATE Migration for Existing Questions

If questions were originally inserted as single-answer and now need to be split into parts, write a separate `NNN_parts_data.sql`:

```sql
UPDATE questions SET
  prompt_latex = $$Shared preamble only.$$,
  parts = $$[
    {"label":"a","prompt_latex":"Part a text. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Part b text. \\([3]\\)","correct_answer":"\\frac{x}{5}","answer_type":"exact","tolerance":null}
  ]$$::jsonb
WHERE id = 'cafe0002-0000-0000-0000-000000000000';
```

---

## 7. Critical: LaTeX Escaping in JSON

The `parts` column is JSONB. The JSON strings live inside PostgreSQL **dollar-quoted** strings (`$$...$$`). Rules:

| Context | Backslash rule |
|---|---|
| In dollar-quoted PostgreSQL string (prompt_latex) | Write `\(`, `\frac` etc. as-is — no escaping needed |
| In JSON string **inside** a dollar-quoted block | Every LaTeX `\` must be written as `\\` |

### Examples

```sql
-- prompt_latex (dollar-quoted, no JSON): write LaTeX directly
prompt_latex = $$Show that \(\cos 3\theta = 4\cos^3\theta\). \([3]\)$$

-- parts JSON (dollar-quoted): double every backslash
parts = $$[
  {
    "label": "a",
    "prompt_latex": "Show that \\(\\cos 3\\theta = 4\\cos^3\\theta\\). \\([3]\\)",
    "correct_answer": "\\frac{3\\sqrt{3}}{10} - \\frac{2}{5}",
    "answer_type": "exact",
    "tolerance": null
  }
]$$::jsonb
```

### Special cases in JSON LaTeX

| LaTeX | In JSON |
|---|---|
| `\frac{a}{b}` | `\\frac{a}{b}` |
| `\(` / `\)` | `\\(` / `\\)` |
| `\[` / `\]` | `\\[` / `\\]` |
| `\\` (LaTeX line break, e.g. in `cases`) | `\\\\` |
| `\begin{cases}` | `\\begin{cases}` |
| `\text{or}` | `\\text{or}` |

### `cases` environment example

```json
"f(x) = \\begin{cases} x^2 & x > 0 \\\\ 0 & x \\leq 0 \\end{cases}"
```

---

## 8. Part Label Conventions

| Structure | Labels to use |
|---|---|
| Single-level (a), (b), (c) | `"a"`, `"b"`, `"c"` |
| Two-level (a)(i), (a)(ii) | `"ai"`, `"aii"` |
| Two-level (b)(i), (b)(ii) | `"bi"`, `"bii"` |
| Three-level | `"aiii"`, `"biii"` etc. |

These render in the UI as `(ai)`, `(aii)` etc. inside the MultiPartQuestion component.

---

## 9. Validate JSON Before Running

Run this Python snippet to catch JSON errors before hitting Supabase:

```python
import re, json

content = open('backend/supabase/migrations/NNN_xxx.sql').read()
# matches both `parts = $$...$$::jsonb` (INSERT) and `SET parts = $$...$$::jsonb` (UPDATE)
pattern = re.compile(r'parts = \$\$(\[.*?\])\$\$::jsonb', re.DOTALL)
matches = pattern.findall(content)
print(f'Found {len(matches)} parts blocks')
for i, block in enumerate(matches):
    try:
        parsed = json.loads(block)
        for p in parsed:
            assert {'label', 'answer_type', 'correct_answer'} <= p.keys(), f'part {p.get("label")} missing keys'
            for f in p.get('answers') or []:          # validate multi-box fields too
                assert f.get('key') and f.get('label') and f.get('answer_type') and 'correct_answer' in f, \
                    f'bad answers[] field in part {p["label"]}'
        print(f'  Block {i+1}: OK — {len(parsed)} parts: {[p["label"] for p in parsed]}')
    except (json.JSONDecodeError, AssertionError) as e:
        print(f'  Block {i+1}: ERROR — {e}')
```

Also check for unescaped single quotes if any string literals use single-quoting (rare since we use `$$`).

---

## 10. Run in Supabase

Open the **Supabase SQL Editor** and run each migration file in order. After each `CREATE TABLE`, grant permissions **to the service role only** and lock the table down (the backend is the sole DB client; `anon`/`authenticated` must get nothing — see migration `073_enable_rls.sql`):

```sql
GRANT ALL ON TABLE public.<table> TO service_role;
ALTER TABLE public.<table> ENABLE ROW LEVEL SECURITY;
```

---

## 11. Verify End-to-End

1. Start backend: `cd backend && npm run dev`
2. Start frontend: `cd frontend && npm run dev`
3. Navigate to the topic that received new questions
4. For multi-part questions: confirm preamble shows in QuestionCard, then per-part sections appear below
5. Submit each graded part → inline ✓/✗ result appears
6. After last graded part → full solution block and "Next Question" button appear
7. For single-answer questions: existing flow unchanged

---

## 12. Model Graphs for Sketch Parts (`solution_graph`)

**Every sketch/draw part** (classified `null` in §3) must carry a `solution_graph` spec so the Solution tab renders a model graph. This covers function sketches, conics/parametric curves, scatter diagrams, normal-distribution curves, Argand diagrams, and vector diagrams. The only legitimate skips are diagrams that aren't coordinate graphs (Venn diagrams, Riemann-rectangle illustrations) — record those with a `-- FLAG:` comment.

Pipeline recap: the spec lives at `parts[i].solution_graph` (JSONB), is compiled server-side by `graphService.compileGraph()` into expression-free polylines, stripped from public payloads, and served only via `GET /api/questions/:id/solution` as `graphs[]`, rendered by `SolutionGraph.tsx`. Reference migrations: **024** (basic curves) and **027** (every feature below, 40 worked examples with notes).

**GIVEN diagrams (prompt-side) — `prompt_graph`.** When a prompt says "the diagram shows …" but ships no image, the question is impossible to attempt. Add a **question-level** `prompt_graph` (same spec format; column added in migration `061`) — it is compiled by the same `compileGraph()` but attached to the **public** payload (in `stripSolution`) and rendered **in the prompt before any attempt**, since it is given information, not a hidden answer. Reference migrations: **062** (exam papers) and **063** (CJC tutorials). Rules: (a) if the question also has a *solution* sketch built on a stand-in `f`, the given diagram **must reuse that exact stand-in** so the shown curve matches the model answer; (b) geometry/3D figures (squares, circular-track schematics, inscribed Riemann discs) are drawn with `segments[]` + parametric `curves`; (c) validate every spec through `compileGraph()` before shipping, exactly as for `solution_graph`.

### Spec format

```json
{
  "x_range": [-8, 8], "y_range": [-8, 8],
  "curves": [
    { "expr": "x + 9/(x+1)", "domain": [-1, 8], "label": "y=x+\\dfrac{9}{x+1}" },
    { "x_expr": "2*cos(t)", "y_expr": "3*sin(t)", "domain": [0, 6.2832], "label": "E" }
  ],
  "asymptotes": [
    { "kind": "vertical", "x": -1, "label": "x=-1" },
    { "kind": "oblique", "expr": "x", "label": "y=x" },
    { "kind": "horizontal", "expr": "3", "label": "y=3" }
  ],
  "points": [
    { "x": 2, "y": 5, "label": "(2,\\ 5)", "kind": "min" },
    { "x": 1, "y": 1.4142, "label": "(a,\\ \\sqrt{2}a)", "kind": "point", "open": true }
  ],
  "segments": [
    { "from": [0, 0], "to": [3, 1.5], "style": "dashed", "arrow": true, "label": "\\mathbf{a}" }
  ],
  "shade": [{ "expr": "3*x^2/((x+1)*(3*x^2+x+1))", "domain": [0, 4], "label": "R" }],
  "x_label": "t", "y_label": "\\theta"
}
```

- `expr`/`x_expr`/`y_expr` are **mathjs** syntax (`e^x`, `abs()`, `sqrt()`, `log()` = ln, `atan()`, `pi`, explicit `*` everywhere). Evaluated only on the backend.
- **Parametric** curve = give `x_expr` + `y_expr`; `domain` is then the **t-interval**. Use for ellipses/loci/rosettes, sideways parabolas, and **inverse functions**: plot f⁻¹ as `x_expr: f(t), y_expr: t`.
- `points[].kind`: `min`/`max`/`intercept` are **validated on-curve** (see below); `point` is free-floating (Argand points, axis markers, line pivots). `open: true` = hollow dot for excluded endpoints (open domains, jump discontinuities).
- `segments` = straight lines drawn as-is: Argand/vector rays (`arrow: true` for vectors), dashed construction/mean lines, `y=x`, overlay lines, and anything vertical that y = f(x) can't express.
- `shade` fills between a curve and the x-axis over an x-interval (region R, normal-probability areas).
- `curves` may be **empty/absent** for points-only sketches (scatter diagrams).
- Labels are LaTeX (KaTeX). In the SQL JSON, double every backslash as usual (§7).

### Authoring workflow

1. **Verify against the official solutions PDF, not the stored `solution_latex`.** Render the page and look at the actual model sketch:
   ```bash
   pdftoppm -f <page> -l <page> -r 100 -png "2025/<school>/<solutions>.pdf" out
   ```
   then Read the PNG. History says this step is non-negotiable: the stored text had wrong turning points (d0251001 (2,8)→(2,5); d0250005 (−2,2)→(−2,−2)), wrong constants (cafe1004 `k`/`k²` vs official `√k`; cafe1006 `2+2i` vs official `√2+√2i`), and phantom features (|f| "passing through (−3,0)"). When the DB disagrees with the PDF, **fix the DB text in the same migration** (see 026/027 for `replace()` patterns — and verify each `replace()` target substring actually exists in the live row first, or it silently no-ops).
2. **Verify the part index against the live DB** (`SELECT parts FROM questions WHERE id = ...` via a read-only script with `backend/.env`) — earlier migrations may have rewritten `parts`, so never trust the original INSERT's ordering. Always label-guard:
   ```sql
   UPDATE questions
   SET parts = jsonb_set(parts, '{<idx>,solution_graph}', $${ ... }$$::jsonb)
   WHERE id = '<uuid>' AND parts-><idx>->>'label' = '<label>';
   ```
3. **Author by category:**
   | Sketch type | Recipe |
   |---|---|
   | Known equation | Direct `expr`; declare vertical asymptotes (sampling auto-splits branches and insets at VAs) |
   | Conic / parametric / locus | `x_expr`/`y_expr` over t |
   | f and f⁻¹ on one diagram | f as `expr`; f⁻¹ parametrically as `(f(t), t)`; add `y=x` (curve entry or segment); open dots at domain endpoints |
   | Piecewise / periodic | One curve entry per piece; exact-precision breakpoints; solid/hollow dots at jumps; dashed segment for the jump if the official sketch shows one |
   | Scatter diagram | Points-only + `x_label`/`y_label`; data comes from the question prompt |
   | Normal distribution | Gaussian pdf `e^(-(x-m)^2/(2*s^2))/(s*sqrt(2*pi))`; dashed mean segments; `shade` for probability regions; label curves via on-curve points at the peaks |
   | Argand / vector diagram | `points` + `segments` (dashed rays, `arrow` for vectors) + `x_label: "\\mathrm{Re}"`, `y_label: "\\mathrm{Im}"` |
   | Abstract/unknown f | **Stand-in curve**: construct a concrete function passing exactly through every officially labelled feature (asymptote-hugging exponential tails like `x+3-3*e^((x+2)/3)`, Hermite cubics between labelled points with matched slopes). Document the construction in the SQL comment. For "in terms of b" curves, pick a representative value and note it |
4. **Precision rules:** breakpoints/points at π-multiples or surds need **full precision** (`3.14159265358979`, `1.4142` is fine for points since snapping corrects y, but domain boundaries must line up — 5-dp π caused validation failures). Point `label`s keep the human-readable exact/rounded coords; `compileGraph()` snaps the dot itself onto the curve (analytic for `expr` curves, nearest sampled vertex for parametric) and injects labelled x-values into the sample grid so extrema dots sit exactly on the polyline.
5. **Validate before shipping** — compile every spec through the real code (pattern from 027: keep specs in a JS file, generate the SQL from it so `JSON.stringify` handles backslash doubling):
   ```ts
   // npx tsx validate.ts  (from backend/)
   import { compileGraph } from './src/services/graphService.js';
   const render = compileGraph(label, spec);
   // assert: every curve produced a visible polyline;
   // every min/max/intercept point is within 1e-6 of a polyline vertex;
   // all points/segments/shade inside x_range/y_range.
   ```
   A labelled point that fails the on-curve check means either the authored coordinate or the official answer is wrong — go back to the PDF (this exact check is what exposed the (2,8) bug).
6. **Verify in the app** after running the migration: open the question, reveal the solution, and confirm the dots sit on the curves, open circles and shading render, and labels don't collide.

---

## 13. Common Pitfalls

| Problem | Fix |
|---|---|
| `ERROR: syntax error at or near "\"` in Supabase | Unescaped `'` inside single-quoted string — use `$$...$$` instead |
| JSON validation fails | Missing `\\` before LaTeX backslash inside JSON string |
| `\\` in `\begin{cases}` not working | Need `\\\\` in JSON for a LaTeX `\\` |
| **Part shows "Show that — no submission required" but it actually asks the student to find/state/determine something** | Over-flagged as `null`. Re-classify by the **command word** (see §3): set `answer_type` + `correct_answer` from `solution_latex`. For a "show that X, hence find Y" part, grade on Y. |
| Part asks for several values but only one box appears | Use the multi-box `answers[]` array (see §3), one entry per value, with non-null part-level sentinels. |
| Multi-box part still renders "no submission required" | Part-level `answer_type` is `null`. Multi-box parts must keep a **non-null** part-level `answer_type`/`correct_answer` sentinel (the real data lives in `answers[]`). |
| Part answer not grading | Check `answer_type` is set (not null) and `correct_answer` is non-null |
| Solution not revealing after last part | `part_label` column may be missing — run schema migration first |
| Marks shown twice in the UI, e.g. `[2] [2]` | The mark count belongs **only** in the part's `prompt_latex` as `\\([N]\\)`. Do **not** also add a `"marks": N` field to the part — the frontend renders both. Omit `marks` entirely (house style; matches ASRJC/DHS). |
| `null value in column "answer_type" violates not-null constraint` | Question-level `answer_type` is `NOT NULL`. For an ungraded single-task question, wrap it as a multi-part question with **one `null` part** and give the question row a non-null fallback (`'exact', ''`). Only **per-part** `answer_type` may be `null`. |
| MathLive outputs `\frac34` not `\frac{3}{4}` | `normalizeLaTeX()` in `attemptService.ts` handles this expansion automatically |
| "no questions found" error | Topic UUID may be wrong — check `CLAUDE.md` for the full mapping |
| Sketch part has no model graph in the Solution tab | Missing `solution_graph` on the part — see §12; every sketch/draw part needs one |
| Min/max dot floats off the curve in the model graph | Authored point coords don't satisfy the curve equation — the stored solution text was probably transcribed wrong; re-check the official PDF (§12 step 1) and run the on-curve validation (§12 step 5) |
| `solution_graph` UPDATE silently does nothing | Wrong part index in the `jsonb_set` path or label guard mismatch — read the **live** `parts` array first (§12 step 2) |
| Parametric curve renders jagged/incomplete | Domain must be the **t-interval**, not x; both `x_expr` and `y_expr` required; out-of-range samples are clipped, so widen `x_range`/`y_range` if branches vanish |
