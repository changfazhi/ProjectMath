import { evaluate } from 'mathjs';

export function normalizeLaTeX(s: string): string {
  return s
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
    // Expand compact MathLive fractions: \frac13 → \frac{1}{3}
    .replace(/\\frac([^{\\])([^{\\])/g, '\\frac{$1}{$2}')
    .replace(/\\frac([^{\\])\{/g, '\\frac{$1}{')
    .replace(/\\frac\{([^}]+)\}([^{\\])/g, '\\frac{$1}{$2}')
    .toLowerCase()
    .replace(/\\text\{or\}/g, 'or')
    .replace(/\\text\{and\}/g, 'and')
    // No \b here: whitespace is already stripped above, so `\lor x` arrives as `\lorx`
    .replace(/\\lor/g, 'or')
    .replace(/\\land/g, 'and')
    .replace(/\\operatorname\{or\}/g, 'or')
    .replace(/\\operatorname\{and\}/g, 'and');
}

function latexToMathExpr(normalized: string): string {
  return normalized
    .replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '($1)/($2)')
    .replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)')
    .replace(/\\pi/g, 'pi')
    .replace(/\\ln\b/g, 'log')    // mathjs log() = natural log
    .replace(/\\log\b/g, 'log10') // \log = base-10 in SG H2
    .replace(/\\cdot/g, '*')
    .replace(/\\times/g, '*')
    .replace(/\\left[\(\[]/g, '(')
    .replace(/\\right[\)\]]/g, ')')
    .replace(/\{/g, '(')
    .replace(/\}/g, ')')
    .replace(/\\/g, '')
    // mathjs parses `x(x+1)` as a function call — make the multiplication explicit.
    // Lookbehind keeps function names like sqrt( / log( intact.
    .replace(/(?<![a-z0-9])([a-df-hj-z])\(/g, '$1*(');
}

function tryNumericEval(raw: string): number | null {
  try {
    const result = evaluate(latexToMathExpr(normalizeLaTeX(raw))) as unknown;
    if (typeof result === 'number' && isFinite(result)) return result;
    return null;
  } catch {
    return null;
  }
}

// Multi-point symbolic evaluation: substitute random values for variables and check
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
    const g1 = evaluate(givenExpr, scope1) as unknown;
    const c1 = evaluate(correctExpr, scope1) as unknown;
    if (typeof g1 !== 'number' || typeof c1 !== 'number' || !isFinite(g1) || !isFinite(c1)) return false;
    if (Math.abs(g1 - c1) > 1e-9 * (Math.abs(c1) + 1)) return false;

    const g2 = evaluate(givenExpr, scope2) as unknown;
    const c2 = evaluate(correctExpr, scope2) as unknown;
    if (typeof g2 !== 'number' || typeof c2 !== 'number' || !isFinite(g2) || !isFinite(c2)) return false;
    return Math.abs(g2 - c2) <= 1e-9 * (Math.abs(c2) + 1);
  } catch {
    return false;
  }
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
      const given = tryNumericEval(givenAnswer);
      const correct = tryNumericEval(correctAnswer);
      if (given !== null && correct !== null) return Math.abs(given - correct) < 1e-9;
      return trySymbolicEval(givenAnswer, correctAnswer);
    }

    case 'range': {
      const givenNum = parseFloat(givenAnswer.trim());
      const correctNum = parseFloat(correctAnswer.trim());
      if (isNaN(givenNum) || isNaN(correctNum)) return false;
      return Math.abs(givenNum - correctNum) <= (tolerance ?? 0.01);
    }

    default:
      return false;
  }
}
