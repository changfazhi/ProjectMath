import { describe, expect, it, vi } from 'vitest';

// payNowExpiryReminder.ts imports the real supabase client at module load, which throws
// without SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY — CI's test env doesn't set them.
const calls: Array<[string, ...unknown[]]> = [];

vi.mock('../db/supabase.js', () => {
  // Records the filters the reminder query applies, then resolves with no rows.
  const builder: Record<string, unknown> = {};
  for (const method of ['select', 'eq', 'is', 'not', 'gt', 'lte']) {
    builder[method] = (...args: unknown[]) => {
      calls.push([method, ...args]);
      return builder;
    };
  }
  builder['or'] = (...args: unknown[]) => {
    calls.push(['or', ...args]);
    return Promise.resolve({ data: [], error: null });
  };
  return { supabase: { from: () => builder } };
});

const { daysUntil, runPayNowExpiryReminders } = await import('./payNowExpiryReminder.js');

// Issue #57: a card subscription bought on top of PayNow keeps `access_expires_at` on the row and
// trials until it, so the expiry alone no longer identifies a PayNow user. Without the
// subscription-id filter these people get "your access ends in 3 days" on the eve of their first
// charge — their access isn't ending, the card is taking over.
describe('runPayNowExpiryReminders — who it selects', () => {
  it('excludes anyone holding a live card subscription', async () => {
    calls.length = 0;

    await runPayNowExpiryReminders();

    expect(calls).toContainEqual(['is', 'stripe_subscription_id', null]);
    expect(calls).toContainEqual(['eq', 'subscription_status', 'active']);
  });
});

describe('daysUntil', () => {
  const from = new Date('2026-07-08T00:00:00Z');

  it('rounds up a partial day to the next whole day', () => {
    expect(daysUntil('2026-07-10T12:00:00Z', from)).toBe(3);
  });

  it('returns 1 on the expiry day itself', () => {
    expect(daysUntil('2026-07-08T06:00:00Z', from)).toBe(1);
  });

  it('never returns less than 1, even if already past expiry', () => {
    expect(daysUntil('2026-07-01T00:00:00Z', from)).toBe(1);
  });

  it('matches an exact whole-day boundary', () => {
    expect(daysUntil('2026-07-11T00:00:00Z', from)).toBe(3);
  });
});
