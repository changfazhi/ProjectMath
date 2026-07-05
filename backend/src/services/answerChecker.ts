import { evaluate } from 'mathjs';

// Grading pipeline for 'exact'/'mcq' answers, in order:
//   1. normalized-string equality (the original gate — must stay first and untouched)
//   2. exprEquals: mathjs numeric evaluation (real or complex)
//   3. trySymbolicEval: 2-point substitution for expressions with variables
//   4. pmSetEquals: ± answers compared as a two-value set
//   5. relationalEquals: inequality chains / or-clauses, order-insensitive
// Every step after 1 is an additional acceptance path — the checker can only get
// more permissive, never stricter.

/** A real or complex evaluation result. */
type NumLike = number | { re: number; im: number };

// Unify LaTeX variants that MathLive / different authors produce for the same
// math. Symmetric (applied to both sides), so string equality is preserved.
function preClean(s: string): string {
  let out = s
    .replace(/\\dfrac/g, '\\frac')
    .replace(/\\tfrac/g, '\\frac')
    .replace(/\\cfrac/g, '\\frac')
    .replace(/\\displaystyle/g, '')
    .replace(/\\left\./g, '')
    .replace(/\\right\./g, '')
    .replace(/\\leq(?![a-zA-Z])/g, '\\le')
    .replace(/\\geq(?![a-zA-Z])/g, '\\ge')
    .replace(/\\lt(?![a-zA-Z])/g, '<')
    .replace(/\\gt(?![a-zA-Z])/g, '>')
    .replace(/\\neq(?![a-zA-Z])/g, '\\ne');

  // \mathrm{e} → e, \operatorname{f} → f, \placeholder{x} → x — loop so nested
  // occurrences unwrap outward one level per pass.
  let prev: string;
  do {
    prev = out;
    out = out
      .replace(/\\mathrm\{([^{}]*)\}/g, '$1')
      .replace(/\\operatorname\{([^{}]*)\}/g, '$1')
      .replace(/\\placeholder\{([^{}]*)\}/g, '$1');
  } while (out !== prev);
  return out;
}

export function normalizeLaTeX(s: string): string {
  return preClean(s)
    .replace(/\s+/g, '')
    .replace(/\\,/g, '')
    .replace(/\\ /g, '')
    .replace(/\\;/g, '')
    .replace(/\\:/g, '')
    .replace(/\\!/g, '')
    .replace(/\\quad/g, '')
    .replace(/\\qquad/g, '')
    .replace(/\\mleft/g, '\\left')
    .replace(/\\mright/g, '\\right')
    // Expand compact MathLive fractions: \frac13 → \frac{1}{3}. The `}`
    // exclusions stop these rules from mangling nested forms like
    // \frac{3\sqrt{2}}{4}, whose first } is the inner group's closer.
    .replace(/\\frac([^{}\\])([^{}\\])/g, '\\frac{$1}{$2}')
    .replace(/\\frac([^{}\\])\{/g, '\\frac{$1}{')
    .replace(/\\frac\{([^}]+)\}([^{}\\])/g, '\\frac{$1}{$2}')
    // Compact square roots: \sqrt2 → \sqrt{2} (leave \sqrt{..} and \sqrt[n]{..} alone)
    .replace(/\\sqrt([^{[}\\])/g, '\\sqrt{$1}')
    .toLowerCase()
    .replace(/\\text\{or\}/g, 'or')
    .replace(/\\text\{and\}/g, 'and')
    // No \b here: whitespace is already stripped above, so `\lor x` arrives as `\lorx`
    .replace(/\\lor/g, 'or')
    .replace(/\\land/g, 'and')
    .replace(/\\operatorname\{or\}/g, 'or')
    .replace(/\\operatorname\{and\}/g, 'and');
}

export function latexToMathExpr(normalized: string): string {
  let s = normalized
    // Absolute values → abs(...)
    .replace(/\\left\|/g, 'abs(')
    .replace(/\\right\|/g, ')')
    .replace(/\\lvert/g, 'abs(')
    .replace(/\\rvert/g, ')')
    .replace(/\\left[\(\[]/g, '(')
    .replace(/\\right[\)\]]/g, ')')
    .replace(/\\pi/g, 'pi')
    .replace(/\\cdot/g, '*')
    .replace(/\\times/g, '*');

  // Function names → @markers@ so the backslash strip can't mangle them and
  // unparenthesized arguments can be wrapped afterwards. Inverse forms first.
  s = s
    .replace(/\\(sin|cos|tan|sec|csc|cot)\^\{?-1\}?/g, '@a$1@')
    .replace(/\\arcsin/g, '@asin@')
    .replace(/\\arccos/g, '@acos@')
    .replace(/\\arctan/g, '@atan@')
    .replace(/\\cosec/g, '@csc@')
    .replace(/\\(sin|cos|tan|sec|csc|cot)/g, '@$1@')
    .replace(/\\ln/g, '@log@') // mathjs log() = natural log
    .replace(/\\log/g, '@log10@'); // \log = base-10 in SG H2

  // Innermost-first convergence loop: arguments must be brace-free to convert,
  // so nested constructs resolve inside-out across iterations. Handles
  // \frac{3}{2\sqrt{2}}, \frac{1}{\frac{2}{3}}, \sqrt{\frac{x-1}{2}}, e^{-\frac{1}{4}}.
  let prev: string;
  do {
    prev = s;
    s = s
      .replace(/\\frac\{([^{}]*)\}\{([^{}]*)\}/g, '(($1)/($2))')
      .replace(/\\sqrt\[([^\][]*)\]\{([^{}]*)\}/g, 'nthRoot($2,$1)')
      .replace(/\\sqrt\{([^{}]*)\}/g, 'sqrt($1)')
      .replace(/\^\{([^{}]*)\}/g, '^($1)');
  } while (s !== prev);

  s = s
    .replace(/\{/g, '(')
    .replace(/\}/g, ')')
    .replace(/\\/g, '');

  // Wrap unparenthesized function arguments: @sin@2x → sin(2x). The argument is
  // the maximal alphanumeric run (stops at operators and other markers).
  s = s.replace(/@([a-z0-9]+)@(?!\()([a-z0-9.]+)/g, '$1($2)');
  s = s.replace(/@([a-z0-9]+)@/g, '$1');

  return (
    s
      // mathjs parses `x(x+1)` as a function call — make the multiplication explicit.
      // Lookbehind keeps function names like sqrt( / log( intact.
      .replace(/(?<![a-z0-9])([a-df-hj-z])\(/g, '$1*(')
      // sin(x)cos(x), (x+1)(x+2), sqrt(2)x — explicit multiplication after `)`
      .replace(/\)(?=[a-z0-9(])/g, ')*')
      // 2sqrt(2), 3x — mathjs does not implicitly multiply digit-then-letter
      .replace(/(\d)(?=[a-z])/g, '$1*')
  );
}

function coerceNum(v: unknown): NumLike | null {
  if (typeof v === 'number') return isFinite(v) ? v : null;
  if (v !== null && typeof v === 'object' && 're' in v && 'im' in v) {
    const c = v as { re: unknown; im: unknown };
    if (typeof c.re === 'number' && typeof c.im === 'number' && isFinite(c.re) && isFinite(c.im)) {
      return { re: c.re, im: c.im };
    }
  }
  return null;
}

function numEquals(a: NumLike, b: NumLike): boolean {
  const are = typeof a === 'number' ? a : a.re;
  const aim = typeof a === 'number' ? 0 : a.im;
  const bre = typeof b === 'number' ? b : b.re;
  const bim = typeof b === 'number' ? 0 : b.im;
  return Math.hypot(are - bre, aim - bim) <= 1e-9 * (Math.hypot(bre, bim) + 1);
}

function tryEval(raw: string): NumLike | null {
  try {
    return coerceNum(evaluate(latexToMathExpr(normalizeLaTeX(raw))) as unknown);
  } catch {
    return null;
  }
}

// Multi-point symbolic evaluation: substitute fixed values for variables and check
// if both expressions agree. Handles commutativity and algebraic equivalences.
function trySymbolicEval(given: string, correct: string): boolean {
  const givenExpr = latexToMathExpr(normalizeLaTeX(given));
  const correctExpr = latexToMathExpr(normalizeLaTeX(correct));

  // Extract single-letter variables, skipping mathjs constants e and i.
  // Lookarounds instead of \b so coefficients still count: the x in `2x` has
  // no word boundary before it, but it is still a variable.
  const varRe = /(?<![a-z])([a-df-hj-z])(?![a-z0-9])/g;
  const vars = new Set([
    ...[...givenExpr.matchAll(varRe)].map((m) => m[1]),
    ...[...correctExpr.matchAll(varRe)].map((m) => m[1]),
  ]);
  if (vars.size === 0) return false;

  const primes = [2, 3, 5, 7, 11, 13, 17, 19];
  const scope1: Record<string, number> = {};
  const scope2: Record<string, number> = {};
  let idx = 0;
  for (const v of vars) {
    scope1[v] = primes[idx % primes.length];
    scope2[v] = primes[(idx + 4) % primes.length];
    idx++;
  }

  try {
    for (const scope of [scope1, scope2]) {
      const g = coerceNum(evaluate(givenExpr, scope) as unknown);
      const c = coerceNum(evaluate(correctExpr, scope) as unknown);
      if (g === null || c === null) return false;
      if (!numEquals(g, c)) return false;
    }
    return true;
  } catch {
    return false;
  }
}

// String equality on normalized forms, then numeric, then symbolic.
function exprEquals(given: string, correct: string): boolean {
  if (normalizeLaTeX(given) === normalizeLaTeX(correct)) return true;
  const g = tryEval(given);
  const c = tryEval(correct);
  if (g !== null && c !== null) return numEquals(g, c);
  return trySymbolicEval(given, correct);
}

// Split at depth 0 of {}/()/[]. `sepLen` returns the separator length at i (0 = no sep).
function splitTopLevel(s: string, sepLen: (s: string, i: number) => number): string[] {
  const parts: string[] = [];
  let depth = 0;
  let start = 0;
  for (let i = 0; i < s.length; i++) {
    const ch = s[i];
    if (ch === '{' || ch === '(' || ch === '[') depth++;
    else if (ch === '}' || ch === ')' || ch === ']') depth--;
    else if (depth === 0) {
      const len = sepLen(s, i);
      if (len > 0) {
        parts.push(s.slice(start, i));
        start = i + len;
        i += len - 1;
      }
    }
  }
  parts.push(s.slice(start));
  return parts;
}

// After whitespace stripping the separator arrives glued to its neighbours
// ("x<-2orx>2"), so alphanumeric neighbours are expected. Only skip an "or"
// that is part of a \command (e.g. \lfloor): walk back over letters and see
// if the run starts with a backslash.
function isCommandLetter(s: string, i: number): boolean {
  let k = i;
  while (k >= 0 && /[a-z]/.test(s[k])) k--;
  return s[k] === '\\';
}

function splitOnOr(s: string): string[] {
  return splitTopLevel(s, (str, i) =>
    str.startsWith('or', i) && !isCommandLetter(str, i) ? 2 : 0,
  );
}

// ± answers: the stored form has exactly one \pm (or \mp). Accept a matching ±
// form, or the two branch values listed in either order.
function pmSetEquals(given: string, correct: string): boolean {
  const c = normalizeLaTeX(correct);
  const g = normalizeLaTeX(given);
  const pmCount = (str: string): number => (str.match(/\\pm|\\mp/g) ?? []).length;
  if (pmCount(c) !== 1) return false;

  const branches = (str: string): [string, string] => [
    str.replace(/\\pm|\\mp/, '+'),
    str.replace(/\\pm|\\mp/, '-'),
  ];
  const [c1, c2] = branches(c);

  let g1: string;
  let g2: string;
  if (pmCount(g) === 1) {
    [g1, g2] = branches(g);
  } else if (pmCount(g) === 0) {
    let parts = splitTopLevel(g, (str, i) => (str[i] === ',' ? 1 : 0));
    if (parts.length !== 2) parts = splitOnOr(g);
    if (parts.length !== 2) return false;
    [g1, g2] = [parts[0], parts[1]];
  } else {
    return false;
  }

  return (
    (exprEquals(g1, c1) && exprEquals(g2, c2)) || (exprEquals(g1, c2) && exprEquals(g2, c1))
  );
}

type RelChain = { exprs: string[]; ops: string[] };

// Parse a normalized clause like "1<x<\frac{5}{3}" into expressions and operators,
// canonicalized so all comparisons point "less-than" (x>2 becomes 2<x).
function parseChain(clause: string): RelChain | null {
  const exprs: string[] = [];
  const ops: string[] = [];
  let depth = 0;
  let start = 0;
  for (let i = 0; i < clause.length; i++) {
    const ch = clause[i];
    if (ch === '{' || ch === '(' || ch === '[') depth++;
    else if (ch === '}' || ch === ')' || ch === ']') depth--;
    else if (depth === 0) {
      let op: string | null = null;
      let len = 1;
      if (ch === '<' || ch === '>') op = ch;
      else if (clause.startsWith('\\le', i) && !/[a-z]/.test(clause[i + 3] ?? '')) {
        op = '\\le';
        len = 3;
      } else if (clause.startsWith('\\ge', i) && !/[a-z]/.test(clause[i + 3] ?? '')) {
        op = '\\ge';
        len = 3;
      } else if (clause.startsWith('\\ne', i) && !/[a-z]/.test(clause[i + 3] ?? '')) {
        return null; // ≠ clauses are out of scope
      }
      if (op) {
        exprs.push(clause.slice(start, i));
        ops.push(op);
        start = i + len;
        i += len - 1;
      }
    }
  }
  exprs.push(clause.slice(start));
  if (ops.length === 0 || exprs.some((e) => e === '')) return null;

  const lt = ops.every((o) => o === '<' || o === '\\le');
  const gt = ops.every((o) => o === '>' || o === '\\ge');
  if (!lt && !gt) return null; // mixed directions — not canonicalizable
  if (gt) {
    exprs.reverse();
    ops.reverse();
    return { exprs, ops: ops.map((o) => (o === '>' ? '<' : '\\le')) };
  }
  return { exprs, ops };
}

function chainEquals(a: RelChain, b: RelChain): boolean {
  if (a.ops.length !== b.ops.length) return false;
  if (a.ops.some((o, i) => o !== b.ops[i])) return false;
  return a.exprs.every((e, i) => exprEquals(e, b.exprs[i]));
}

// Inequality / or-clause comparison: clauses match as a multiset (order-insensitive),
// sides compared as expressions so 1<x<\frac{5}{3} matches 1<x<5/3.
function relationalEquals(given: string, correct: string): boolean {
  const gClauses = splitOnOr(normalizeLaTeX(given)).map(parseChain);
  const cClauses = splitOnOr(normalizeLaTeX(correct)).map(parseChain);
  if (gClauses.some((c) => c === null) || cClauses.some((c) => c === null)) return false;
  if (gClauses.length !== cClauses.length) return false;

  const gs = gClauses as RelChain[];
  const cs = cClauses as RelChain[];
  const used = new Array<boolean>(cs.length).fill(false);
  const match = (i: number): boolean => {
    if (i === gs.length) return true;
    for (let j = 0; j < cs.length; j++) {
      if (!used[j] && chainEquals(gs[i], cs[j])) {
        used[j] = true;
        if (match(i + 1)) return true;
        used[j] = false;
      }
    }
    return false;
  };
  return match(0);
}

// Range answers may arrive as fractions or simple expressions, not just decimals.
function toNumber(s: string): number | null {
  const t = s.trim();
  if (/^[+-]?(\d+\.?\d*|\.\d+)(e[+-]?\d+)?$/i.test(t)) return parseFloat(t);
  const v = tryEval(t);
  return typeof v === 'number' ? v : null;
}

export function checkAnswer(
  answerType: string,
  correctAnswer: string,
  givenAnswer: string,
  tolerance: number | null,
): boolean {
  switch (answerType) {
    case 'exact':
    case 'mcq': {
      if (normalizeLaTeX(givenAnswer) === normalizeLaTeX(correctAnswer)) return true;
      if (exprEquals(givenAnswer, correctAnswer)) return true;
      if (pmSetEquals(givenAnswer, correctAnswer)) return true;
      return relationalEquals(givenAnswer, correctAnswer);
    }

    case 'range': {
      const givenNum = toNumber(givenAnswer);
      const correctNum = toNumber(correctAnswer);
      if (givenNum === null || correctNum === null) return false;
      return Math.abs(givenNum - correctNum) <= (tolerance ?? 0.01);
    }

    default:
      return false;
  }
}
