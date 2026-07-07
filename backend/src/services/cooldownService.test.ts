import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { AiUnavailableError } from './aiErrors.js';
import {
  acquireGradeSlot,
  assertAndStampCooldown,
  clearCooldown,
  refundGradeSlot,
  reserveGradeSlot,
  resetAllCooldowns,
} from './cooldownService.js';

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

  describe('chat (reject inside the window)', () => {
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

    it('users are independent', () => {
      assertAndStampCooldown('u1', 'chat', T0);
      expect(() => assertAndStampCooldown('u2', 'chat', T0 + 1)).not.toThrow();
    });

    it('clearCooldown lets the user retry immediately (failed AI call)', () => {
      assertAndStampCooldown('u1', 'chat', T0);
      clearCooldown('u1', 'chat');
      expect(() => assertAndStampCooldown('u1', 'chat', T0 + 1)).not.toThrow();
    });
  });

  describe('grade slot (hold inside the window)', () => {
    it('runs the first request immediately', () => {
      expect(reserveGradeSlot('u1', T0)).toEqual({ waitMs: 0 });
    });

    it('a second request inside the window becomes the waiter, chaining the window', () => {
      reserveGradeSlot('u1', T0);
      expect(reserveGradeSlot('u1', T0 + 10_000)).toEqual({ waitMs: 50_000 });
    });

    it('a third request while one waits is rejected with the chained resetAt', () => {
      reserveGradeSlot('u1', T0);
      reserveGradeSlot('u1', T0 + 10_000); // waiter runs at T0+60s, chains to T0+120s
      const err = expectCooldown(() => reserveGradeSlot('u1', T0 + 20_000));
      expect(err.message).toBe(
        'You already have a grading in progress — wait for it to finish before submitting again.',
      );
      expect(err.resetAt).toBe(new Date(T0 + 120_000).toISOString());
    });

    it('frees the slot once the window has passed', () => {
      reserveGradeSlot('u1', T0);
      expect(reserveGradeSlot('u1', T0 + 60_000)).toEqual({ waitMs: 0 });
    });

    it('users are independent', () => {
      reserveGradeSlot('u1', T0);
      expect(reserveGradeSlot('u2', T0 + 1)).toEqual({ waitMs: 0 });
    });

    it('refund with no waiter lets the user retry immediately (failed grading)', () => {
      reserveGradeSlot('u1', T0);
      refundGradeSlot('u1');
      expect(reserveGradeSlot('u1', T0 + 1)).toEqual({ waitMs: 0 });
    });

    it("refund keeps a queued waiter's reservation (runner failed while one waits)", () => {
      reserveGradeSlot('u1', T0);
      reserveGradeSlot('u1', T0 + 10_000); // waiter
      refundGradeSlot('u1'); // runner's grading failed — must not evict the waiter
      expectCooldown(() => reserveGradeSlot('u1', T0 + 20_000));
    });

    describe('acquireGradeSlot (held request)', () => {
      beforeEach(() => vi.useFakeTimers());
      afterEach(() => vi.useRealTimers());

      it('holds the second request until the slot frees, then frees the wait position', async () => {
        await acquireGradeSlot('u1'); // immediate
        let resolved = false;
        const held = acquireGradeSlot('u1').then(() => {
          resolved = true;
        });

        await vi.advanceTimersByTimeAsync(59_000);
        expect(resolved).toBe(false);
        await vi.advanceTimersByTimeAsync(1_100);
        await held;
        expect(resolved).toBe(true);

        // The waiter became the runner — the next request may wait, not be rejected.
        expect(reserveGradeSlot('u1').waitMs).toBeGreaterThan(0);
      });
    });
  });
});
