import { beforeEach, describe, expect, it, vi } from 'vitest';

// Chainable supabase stub whose count is configurable per-test.
const state = { count: 0, queries: 0 };

vi.mock('../db/supabase.js', () => {
  const builder = () => {
    const b = {
      select: () => {
        state.queries += 1;
        return b;
      },
      eq: () => b,
      gte: () => Promise.resolve({ count: state.count, error: null }),
    };
    return b;
  };
  return { supabase: { from: () => builder() } };
});

const { assertChatQuota, assertScanQuota, getUsageSummary, isOverLimit, QuotaExceededError } =
  await import('./usageService.js');

beforeEach(() => {
  state.count = 0;
  state.queries = 0;
});

describe('isOverLimit', () => {
  it('never over when limit is null (unlimited)', () => {
    expect(isOverLimit(999_999, null)).toBe(false);
  });
  it('over at exactly the limit, not below', () => {
    expect(isOverLimit(9, 10)).toBe(false);
    expect(isOverLimit(10, 10)).toBe(true);
    expect(isOverLimit(11, 10)).toBe(true);
  });
});

describe('assertScanQuota', () => {
  it('passes for free tier below the limit', async () => {
    state.count = 9;
    await expect(assertScanQuota('user-1', 'free')).resolves.toBeUndefined();
  });

  it('throws QuotaExceededError at the limit with payload fields', async () => {
    state.count = 10;
    const err = await assertScanQuota('user-1', 'free').catch((e: unknown) => e);
    expect(err).toBeInstanceOf(QuotaExceededError);
    const q = err as InstanceType<typeof QuotaExceededError>;
    expect(q.quota).toBe('scans');
    expect(q.limit).toBe(10);
    expect(new Date(q.resetAt).getTime()).toBeGreaterThan(Date.now());
  });

  it('never queries the database for paid tier', async () => {
    state.count = 1_000;
    await expect(assertScanQuota('user-1', 'paid')).resolves.toBeUndefined();
    expect(state.queries).toBe(0);
  });
});

describe('assertChatQuota', () => {
  it('throws at the free limit', async () => {
    state.count = 10;
    await expect(assertChatQuota('user-1', 'free')).rejects.toBeInstanceOf(QuotaExceededError);
  });

  it('no-op for paid', async () => {
    state.count = 500;
    await expect(assertChatQuota('user-1', 'paid')).resolves.toBeUndefined();
    expect(state.queries).toBe(0);
  });
});

describe('getUsageSummary', () => {
  it('reports used/limit/remaining for free tier', async () => {
    state.count = 4;
    const summary = await getUsageSummary('user-1', 'free');
    expect(summary.scans).toEqual({ used: 4, limit: 10, remaining: 6 });
    expect(summary.chat).toEqual({ used: 4, limit: 10, remaining: 6 });
    expect(new Date(summary.resets_at).getTime()).toBeGreaterThan(Date.now());
  });

  it('remaining clamps at 0 when over-consumed', async () => {
    state.count = 12;
    const summary = await getUsageSummary('user-1', 'free');
    expect(summary.scans.remaining).toBe(0);
  });

  it('null limits for paid tier', async () => {
    state.count = 42;
    const summary = await getUsageSummary('user-1', 'paid');
    expect(summary.scans).toEqual({ used: 42, limit: null, remaining: null });
  });
});
