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
