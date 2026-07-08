import { describe, expect, it, vi } from 'vitest';

// payNowExpiryReminder.ts imports the real supabase client at module load, which throws
// without SUPABASE_URL/SUPABASE_SERVICE_ROLE_KEY — CI's test env doesn't set them.
vi.mock('../db/supabase.js', () => ({ supabase: {} }));

const { daysUntil } = await import('./payNowExpiryReminder.js');

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
