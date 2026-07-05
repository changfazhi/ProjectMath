import { readdirSync, readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { checkAnswer, normalizeLaTeX } from './answerChecker.js';

describe('normalizeLaTeX', () => {
  it('strips whitespace and LaTeX spacing commands', () => {
    expect(normalizeLaTeX('x + 2')).toBe('x+2');
    expect(normalizeLaTeX('x\\,+\\;2\\quad y')).toBe('x+2y');
  });

  it('expands compact MathLive fractions', () => {
    expect(normalizeLaTeX('\\frac34')).toBe('\\frac{3}{4}');
    expect(normalizeLaTeX('\\frac3{x+1}')).toBe('\\frac{3}{x+1}');
    expect(normalizeLaTeX('\\frac{x+1}3')).toBe('\\frac{x+1}{3}');
  });

  it('converts MathLive \\mleft/\\mright to \\left/\\right', () => {
    expect(normalizeLaTeX('\\mleft(x\\mright)')).toBe('\\left(x\\right)');
  });

  it('lowercases and normalizes logical connectives', () => {
    expect(normalizeLaTeX('X = 2 \\text{or} X = 3')).toBe('x=2orx=3');
    expect(normalizeLaTeX('x<1 \\lor x>5')).toBe('x<1orx>5');
    expect(normalizeLaTeX('\\operatorname{and}')).toBe('and');
  });
});

describe('checkAnswer — exact', () => {
  it('accepts an identical answer', () => {
    expect(checkAnswer('exact', '\\frac{2}{3}', '\\frac{2}{3}', null)).toBe(true);
  });

  it('accepts the same answer with different spacing/notation', () => {
    expect(checkAnswer('exact', '\\frac{3}{4}', '\\frac34', null)).toBe(true);
    expect(checkAnswer('exact', 'x + 2', 'x+2', null)).toBe(true);
  });

  it('accepts numerically equivalent forms', () => {
    expect(checkAnswer('exact', '\\frac{1}{2}', '0.5', null)).toBe(true);
    expect(checkAnswer('exact', '4', '\\sqrt{16}', null)).toBe(true);
    expect(checkAnswer('exact', '6', '2\\times3', null)).toBe(true);
  });

  it('accepts algebraically equivalent expressions (symbolic eval)', () => {
    expect(checkAnswer('exact', '2x+3', '3+2x', null)).toBe(true);
    expect(checkAnswer('exact', 'x^2+x', 'x(x+1)', null)).toBe(true);
    expect(checkAnswer('exact', '\\frac{x}{2}', '0.5x', null)).toBe(true);
  });

  it('rejects wrong answers', () => {
    expect(checkAnswer('exact', '\\frac{2}{3}', '\\frac{3}{2}', null)).toBe(false);
    expect(checkAnswer('exact', '2x+3', '2x-3', null)).toBe(false);
    expect(checkAnswer('exact', '4', '5', null)).toBe(false);
  });

  it('rejects garbage input without throwing', () => {
    expect(checkAnswer('exact', '\\frac{2}{3}', '\\frac{', null)).toBe(false);
    expect(checkAnswer('exact', '2x+3', '', null)).toBe(false);
  });

  it('grades mcq the same way as exact', () => {
    expect(checkAnswer('mcq', 'B', 'b', null)).toBe(true);
    expect(checkAnswer('mcq', 'B', 'c', null)).toBe(false);
  });
});

describe('checkAnswer — range', () => {
  it('accepts values within the given tolerance', () => {
    expect(checkAnswer('range', '3.14159', '3.14', 0.01)).toBe(true);
    expect(checkAnswer('range', '100', '99.5', 0.5)).toBe(true);
  });

  it('rejects values outside the tolerance', () => {
    expect(checkAnswer('range', '3.14159', '3.2', 0.01)).toBe(false);
  });

  it('falls back to a 0.01 tolerance when none is set', () => {
    expect(checkAnswer('range', '2.505', '2.5', null)).toBe(true);
    expect(checkAnswer('range', '2.52', '2.5', null)).toBe(false);
  });

  it('rejects non-numeric input', () => {
    expect(checkAnswer('range', '3.14', 'abc', 0.01)).toBe(false);
    expect(checkAnswer('range', 'abc', '3.14', 0.01)).toBe(false);
  });
});

describe('checkAnswer — unknown answer type', () => {
  it('never marks correct', () => {
    expect(checkAnswer('essay', 'x', 'x', null)).toBe(false);
  });
});

// ---------------------------------------------------------------------------
// Equivalent-representation acceptance. Each pair is (stored answer, student
// input) that is mathematically identical but written differently.
// ---------------------------------------------------------------------------

describe('checkAnswer — surds and nested fractions', () => {
  it('accepts rationalized vs unrationalized surds', () => {
    expect(checkAnswer('exact', '\\frac{3}{2\\sqrt{2}}', '\\frac{3\\sqrt{2}}{4}', null)).toBe(true);
    expect(checkAnswer('exact', '\\frac{7}{\\sqrt{26}}', '\\frac{7\\sqrt{26}}{26}', null)).toBe(true);
  });

  it('accepts k√n vs √(k²n)', () => {
    expect(checkAnswer('exact', '2\\sqrt{3}', '\\sqrt{12}', null)).toBe(true);
  });

  it('accepts compact \\sqrt2 and nth roots', () => {
    expect(checkAnswer('exact', '\\sqrt2', '\\sqrt{2}', null)).toBe(true);
    expect(checkAnswer('exact', '\\sqrt[3]{8}', '2', null)).toBe(true);
  });

  it('accepts surds nested inside roots (with variables)', () => {
    expect(
      checkAnswer('exact', '\\sqrt{\\frac{x-1}{2}}', '\\frac{\\sqrt{x-1}}{\\sqrt{2}}', null),
    ).toBe(true);
  });

  it('accepts multi-level fractions', () => {
    expect(checkAnswer('exact', '\\frac{1}{\\frac{2}{3}}', '1.5', null)).toBe(true);
    expect(checkAnswer('exact', '\\frac{11-4\\sqrt{5}}{3}', '\\frac{11}{3}-\\frac{4\\sqrt{5}}{3}', null)).toBe(true);
  });

  it('rejects different surd values', () => {
    expect(checkAnswer('exact', '\\frac{3}{2\\sqrt{2}}', '\\frac{3}{2}', null)).toBe(false);
    expect(checkAnswer('exact', '\\frac{3}{2\\sqrt{2}}', '\\frac{2}{3\\sqrt{2}}', null)).toBe(false);
    expect(checkAnswer('exact', '2\\sqrt{3}', '3\\sqrt{2}', null)).toBe(false);
  });
});

describe('checkAnswer — MathLive artifacts and LaTeX variants', () => {
  it('normalizes \\dfrac, \\mathrm, \\operatorname wrappers', () => {
    expect(checkAnswer('exact', '\\dfrac{1}{2}', '0.5', null)).toBe(true);
    expect(checkAnswer('exact', '\\mathrm{e}^{-\\frac{1}{4}}', 'e^{-0.25}', null)).toBe(true);
  });

  it('handles absolute values', () => {
    expect(checkAnswer('exact', '\\left|-3\\right|', '3', null)).toBe(true);
    expect(checkAnswer('exact', '\\left|x\\right|', '\\left|x\\right|', null)).toBe(true);
  });

  it('unwraps filled placeholders and rejects empty ones without throwing', () => {
    expect(checkAnswer('exact', '\\frac{1}{2}', '\\frac{\\placeholder{1}}{\\placeholder{2}}', null)).toBe(true);
    expect(checkAnswer('exact', '\\frac{1}{2}', '\\frac{\\placeholder{}}{2}', null)).toBe(false);
  });
});

describe('checkAnswer — trig and function arguments', () => {
  it('accepts unparenthesized function arguments', () => {
    expect(checkAnswer('exact', '\\sin x', '\\sin(x)', null)).toBe(true);
    expect(checkAnswer('exact', '\\sin 2x', '\\sin(2x)', null)).toBe(true);
    expect(checkAnswer('exact', '\\ln x', '\\ln(x)', null)).toBe(true);
  });

  it('accepts inverse-trig synonyms', () => {
    expect(checkAnswer('exact', '\\tan^{-1}(2)', '\\arctan(2)', null)).toBe(true);
  });

  it('accepts trig identities via symbolic evaluation', () => {
    expect(checkAnswer('exact', '2\\sin x\\cos x', '\\sin(2x)', null)).toBe(true);
  });

  it('rejects different functions', () => {
    expect(checkAnswer('exact', '\\sin x', '\\cos x', null)).toBe(false);
    expect(checkAnswer('exact', '\\sin(2x)', '\\sin(3x)', null)).toBe(false);
  });
});

describe('checkAnswer — complex numbers', () => {
  it('accepts reordered complex forms', () => {
    expect(checkAnswer('exact', '-1+8\\mathrm{i}', '8i-1', null)).toBe(true);
    expect(checkAnswer('exact', '\\frac{2-\\mathrm{i}}{5}', '0.4-0.2i', null)).toBe(true);
  });

  it('rejects the conjugate', () => {
    expect(checkAnswer('exact', '-1+8i', '-1-8i', null)).toBe(false);
  });
});

describe('checkAnswer — ± two-value answers', () => {
  it('accepts a matching ± form and both explicit values in either order', () => {
    const pm = '\\frac{1\\pm\\sqrt{5}}{2}';
    expect(checkAnswer('exact', pm, '\\frac{1\\pm\\sqrt{5}}{2}', null)).toBe(true);
    expect(checkAnswer('exact', pm, '\\frac{1+\\sqrt{5}}{2}, \\frac{1-\\sqrt{5}}{2}', null)).toBe(true);
    expect(checkAnswer('exact', pm, '\\frac{1-\\sqrt{5}}{2}, \\frac{1+\\sqrt{5}}{2}', null)).toBe(true);
    expect(checkAnswer('exact', '\\pm\\frac{\\pi}{2}', '\\frac{\\pi}{2}, -\\frac{\\pi}{2}', null)).toBe(true);
  });

  it('rejects a single branch or a wrong pair', () => {
    expect(checkAnswer('exact', '\\frac{1\\pm\\sqrt{5}}{2}', '\\frac{1+\\sqrt{5}}{2}', null)).toBe(false);
    expect(checkAnswer('exact', '\\pm2', '2, 3', null)).toBe(false);
  });
});

describe('checkAnswer — inequalities and or-clauses', () => {
  it('accepts reordered or-clauses', () => {
    expect(
      checkAnswer('exact', 'x<-2\\text{ or }x>2', 'x>2 \\text{ or } x<-2', null),
    ).toBe(true);
    expect(
      checkAnswer('exact', 'h\\le1842\\text{ or }h\\ge2008', 'h\\ge2008 \\text{ or } h\\le1842', null),
    ).toBe(true);
  });

  it('compares chain sides as expressions, not strings', () => {
    expect(checkAnswer('exact', '1<x<\\frac{5}{3}', '1<x<5/3', null)).toBe(true);
  });

  it('canonicalizes direction (x>2 ≡ 2<x)', () => {
    expect(checkAnswer('exact', 'x>2', '2<x', null)).toBe(true);
  });

  it('keeps strict vs inclusive distinct and rejects wrong bounds', () => {
    expect(checkAnswer('exact', 'x\\le2', 'x<2', null)).toBe(false);
    expect(checkAnswer('exact', 'x<2', 'x<3', null)).toBe(false);
    expect(checkAnswer('exact', 'x<-2\\text{ or }x>2', 'x<-2', null)).toBe(false);
  });
});

describe('checkAnswer — range with non-decimal input', () => {
  it('evaluates fractions instead of parseFloat truncation', () => {
    expect(checkAnswer('range', '0.5', '1/2', 0.01)).toBe(true);
    expect(checkAnswer('range', '0.5', '\\frac{1}{2}', 0.01)).toBe(true);
    // parseFloat('1/3') used to partial-parse to 1 and wrongly accept
    expect(checkAnswer('range', '1', '1/3', 0.01)).toBe(false);
  });
});

// ---------------------------------------------------------------------------
// Never-stricter guard: every correct_answer stored in the migrations must
// accept itself. Reads the SQL at test time so the fixture can't go stale.
// ---------------------------------------------------------------------------

describe('stored-answer self-acceptance sweep', () => {
  const migrationsDir = join(dirname(fileURLToPath(import.meta.url)), '../../supabase/migrations');

  const storedAnswers = (): string[] => {
    const seen = new Set<string>();
    for (const file of readdirSync(migrationsDir).filter((f) => f.endsWith('.sql'))) {
      const text = readFileSync(join(migrationsDir, file), 'utf8');
      const re = /"correct_answer":\s*"((?:[^"\\]|\\.)*)"/g;
      let m: RegExpExecArray | null;
      while ((m = re.exec(text)) !== null) {
        try {
          seen.add(JSON.parse(`"${m[1]}"`) as string);
        } catch {
          // skip malformed captures
        }
      }
    }
    return [...seen].filter((s) => s.length > 0);
  };

  it('every stored correct_answer accepts itself', () => {
    const answers = storedAnswers();
    expect(answers.length).toBeGreaterThan(300);
    const rejected = answers.filter((a) => {
      try {
        return !checkAnswer('exact', a, a, null);
      } catch {
        return true;
      }
    });
    expect(rejected).toEqual([]);
  });
});
