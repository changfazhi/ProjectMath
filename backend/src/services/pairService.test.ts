import { afterEach, describe, expect, it, vi } from 'vitest';
import { closePair, createPair, getValidPair, peekPairOwner } from './pairService.js';

const QUESTION = '11111111-1111-1111-1111-111111111111';
const TTL_MS = 10 * 60_000; // PAIR_TTL_MIN default

describe('peekPairOwner', () => {
  afterEach(() => {
    vi.useRealTimers();
  });

  it('returns the account that created the pairing', () => {
    const pair = createPair('owner-1', QUESTION, 'free');
    try {
      expect(peekPairOwner(pair.token)).toBe('owner-1');
    } finally {
      closePair(pair.token);
    }
  });

  it('returns null for an unknown token', () => {
    expect(peekPairOwner('not-a-real-token')).toBeNull();
  });

  it('returns null once the pairing is closed', () => {
    const pair = createPair('owner-1', QUESTION, 'free');
    closePair(pair.token);

    expect(peekPairOwner(pair.token)).toBeNull();
  });

  it('returns null once the TTL has lapsed', () => {
    vi.useFakeTimers();
    const pair = createPair('owner-1', QUESTION, 'free');
    vi.advanceTimersByTime(TTL_MS + 1);

    expect(peekPairOwner(pair.token)).toBeNull();
  });

  // It runs inside a rate limiter's key generator, on requests that may be rejected before any
  // handler sees them — so unlike getValidPair it must not mutate the map.
  it('does not evict, so a later getValidPair still sees the pairing', () => {
    const pair = createPair('owner-1', QUESTION, 'free');
    try {
      expect(peekPairOwner(pair.token)).toBe('owner-1');
      expect(getValidPair(pair.token)?.userId).toBe('owner-1');
    } finally {
      closePair(pair.token);
    }
  });
});
