import { beforeEach, describe, expect, it } from 'vitest';
import { AiUnavailableError } from './aiErrors.js';
import { assertAndStampCooldown, clearCooldown, resetAllCooldowns } from './cooldownService.js';

// Defaults: chat 5s, grade 60s (AI_LIMITS).
const T0 = 1_750_000_000_000;

function expectCooldown(fn: () => void): AiUnavailableError {
  try {
    fn();
  } catch (err) {
    expect(err).toBeInstanceOf(AiUnavailableError);
    const e = err as AiUnavailableError;
    expect(e.code).toBe('AI_COOLDOWN');
    expect(e.httpStatus).toBe(429);
    return e;
  }
  throw new Error('expected AiUnavailableError to be thrown');
}

describe('cooldownService', () => {
  beforeEach(() => resetAllCooldowns());

  it('allows the first request and blocks a second inside the window', () => {
    assertAndStampCooldown('u1', 'chat', T0);
    const err = expectCooldown(() => assertAndStampCooldown('u1', 'chat', T0 + 2000));
    expect(err.message).toBe('AI is on cooldown — try again in 3 seconds.');
    expect(err.resetAt).toBe(new Date(T0 + 5000).toISOString());
  });

  it('uses singular wording for a 1-second wait', () => {
    assertAndStampCooldown('u1', 'chat', T0);
    const err = expectCooldown(() => assertAndStampCooldown('u1', 'chat', T0 + 4500));
    expect(err.message).toBe('AI is on cooldown — try again in 1 second.');
  });

  it('allows again once the window has passed', () => {
    assertAndStampCooldown('u1', 'chat', T0);
    expect(() => assertAndStampCooldown('u1', 'chat', T0 + 5000)).not.toThrow();
  });

  it('a blocked attempt does not extend the cooldown', () => {
    assertAndStampCooldown('u1', 'chat', T0);
    expectCooldown(() => assertAndStampCooldown('u1', 'chat', T0 + 4000));
    expect(() => assertAndStampCooldown('u1', 'chat', T0 + 5000)).not.toThrow();
  });

  it('grade uses its own (60s) window, independent of chat', () => {
    assertAndStampCooldown('u1', 'grade', T0);
    expect(() => assertAndStampCooldown('u1', 'chat', T0 + 1)).not.toThrow();
    expectCooldown(() => assertAndStampCooldown('u1', 'grade', T0 + 59_000));
    expect(() => assertAndStampCooldown('u1', 'grade', T0 + 60_000)).not.toThrow();
  });

  it('users are independent', () => {
    assertAndStampCooldown('u1', 'chat', T0);
    expect(() => assertAndStampCooldown('u2', 'chat', T0 + 1)).not.toThrow();
  });

  it('clearCooldown lets the user retry immediately (failed AI call)', () => {
    assertAndStampCooldown('u1', 'grade', T0);
    clearCooldown('u1', 'grade');
    expect(() => assertAndStampCooldown('u1', 'grade', T0 + 1)).not.toThrow();
  });
});
