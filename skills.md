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

### Answer type for each part

| Situation | `answer_type` | `correct_answer` | `tolerance` |
|---|---|---|---|
| "Show that", proof, sketch, text | `null` | `null` | `null` |
| Exact algebraic/LaTeX answer | `"exact"` | LaTeX string | `null` |
| Decimal/numerical within a range | `"range"` | decimal string | number |

**Tolerance guidelines for `"range"` answers:**

| Type | Suggested tolerance |
|---|---|
| Probability (3 s.f.) | `0.002` |
| Small probability < 0.05 | `0.0002` |
| Integer answer (nearest integer) | `1` |
| Length/area (2 d.p.) | `0.005` |
| Coefficient/constant (3 s.f.) | `0.005` |

### Parts with multiple sub-outputs

If a part asks "find x AND y" or "state a and b":
- If both outputs form one natural answer string (e.g. `p = 2^{1/3}, q = 2^{2/3}`), use `"exact"` and accept the combined form.
- If the outputs are conceptually different and one is textual, make the whole part `null`.
- Never try to grade a "show that" component, even if the part also has a "find" component — make the whole part `null`.

### Indefinite integrals

Always `null` — there are infinitely many equivalent antiderivative forms that the exact-match normaliser cannot handle.

---

## 4. Write the Schema Migration (if needed)

If `parts` or `part_label` columns don't yet exist, write `NNN_schema.sql` first:

```sql
ALTER TABLE questions ADD COLUMN IF NOT EXISTS parts JSONB;
ALTER TABLE attempts  ADD COLUMN IF NOT EXISTS part_label TEXT;
GRANT ALL ON TABLE public.questions TO anon, authenticated, service_role;
GRANT ALL ON TABLE public.attempts  TO anon, authenticated, service_role;
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
pattern = re.compile(r'parts = \$\$(\[.*?\])\$\$::jsonb', re.DOTALL)
matches = pattern.findall(content)
print(f'Found {len(matches)} parts blocks')
for i, block in enumerate(matches):
    try:
        parsed = json.loads(block)
        print(f'  Block {i+1}: OK — {len(parsed)} parts: {[p["label"] for p in parsed]}')
    except json.JSONDecodeError as e:
        print(f'  Block {i+1}: ERROR — {e}')
```

Also check for unescaped single quotes if any string literals use single-quoting (rare since we use `$$`).

---

## 10. Run in Supabase

Open the **Supabase SQL Editor** and run each migration file in order. After each `CREATE TABLE`, grant permissions:

```sql
GRANT ALL ON TABLE public.<table> TO anon, authenticated, service_role;
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

## 12. Common Pitfalls

| Problem | Fix |
|---|---|
| `ERROR: syntax error at or near "\"` in Supabase | Unescaped `'` inside single-quoted string — use `$$...$$` instead |
| JSON validation fails | Missing `\\` before LaTeX backslash inside JSON string |
| `\\` in `\begin{cases}` not working | Need `\\\\` in JSON for a LaTeX `\\` |
| Part answer not grading | Check `answer_type` is set (not null) and `correct_answer` is non-null |
| Solution not revealing after last part | `part_label` column may be missing — run schema migration first |
| Marks shown twice in the UI, e.g. `[2] [2]` | The mark count belongs **only** in the part's `prompt_latex` as `\\([N]\\)`. Do **not** also add a `"marks": N` field to the part — the frontend renders both. Omit `marks` entirely (house style; matches ASRJC/DHS). |
| `null value in column "answer_type" violates not-null constraint` | Question-level `answer_type` is `NOT NULL`. For an ungraded single-task question, wrap it as a multi-part question with **one `null` part** and give the question row a non-null fallback (`'exact', ''`). Only **per-part** `answer_type` may be `null`. |
| MathLive outputs `\frac34` not `\frac{3}{4}` | `normalizeLaTeX()` in `attemptService.ts` handles this expansion automatically |
| "no questions found" error | Topic UUID may be wrong — check `CLAUDE.md` for the full mapping |
