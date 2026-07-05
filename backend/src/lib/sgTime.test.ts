import { describe, it, expect } from 'vitest';
import { cooldownEndsAt, DAY_MS, nextSgtMidnightUtc, sgtDateStr, sgtDayStartUtc } from './sgTime.js';

// SGT midnight = 16:00 UTC of the previous day.
describe('sgtDayStartUtc / sgtDateStr', () => {
  it('maps an instant just before SGT midnight to the current SGT day', () => {
    const now = new Date('2026-07-05T15:59:59Z'); // 23:59:59 SGT on 2026-07-05
    expect(sgtDateStr(now)).toBe('2026-07-05');
    expect(sgtDayStartUtc(now).toISOString()).toBe('2026-07-04T16:00:00.000Z');
  });

  it('rolls to the next SGT day exactly at 16:00 UTC', () => {
    const now = new Date('2026-07-05T16:00:00Z'); // 00:00 SGT on 2026-07-06
    expect(sgtDateStr(now)).toBe('2026-07-06');
    expect(sgtDayStartUtc(now).toISOString()).toBe('2026-07-05T16:00:00.000Z');
  });

  it('handles a UTC-morning instant (mid-afternoon SGT)', () => {
    const now = new Date('2026-07-05T04:30:00Z'); // 12:30 SGT
    expect(sgtDateStr(now)).toBe('2026-07-05');
    expect(sgtDayStartUtc(now).toISOString()).toBe('2026-07-04T16:00:00.000Z');
  });
});

describe('nextSgtMidnightUtc', () => {
  it('is exactly one day after the SGT day start', () => {
    const now = new Date('2026-07-05T04:30:00Z');
    expect(nextSgtMidnightUtc(now).getTime() - sgtDayStartUtc(now).getTime()).toBe(DAY_MS);
    expect(nextSgtMidnightUtc(now).toISOString()).toBe('2026-07-05T16:00:00.000Z');
  });
});

describe('cooldownEndsAt', () => {
  it('nextSgtDay: generating at 23:50 SGT unlocks 10 minutes later at midnight', () => {
    const generated = new Date('2026-07-05T15:50:00Z'); // 23:50 SGT
    const ends = cooldownEndsAt(generated, { kind: 'nextSgtDay' });
    expect(ends.toISOString()).toBe('2026-07-05T16:00:00.000Z');
  });

  it('nextSgtDay: generating just after midnight locks for almost a full day', () => {
    const generated = new Date('2026-07-05T16:00:01Z'); // 00:00:01 SGT on 07-06
    const ends = cooldownEndsAt(generated, { kind: 'nextSgtDay' });
    expect(ends.toISOString()).toBe('2026-07-06T16:00:00.000Z');
  });

  it('rollingDays: exactly N * 24h after generation', () => {
    const generated = new Date('2026-07-05T03:00:00Z');
    const ends = cooldownEndsAt(generated, { kind: 'rollingDays', days: 7 });
    expect(ends.getTime()).toBe(generated.getTime() + 7 * DAY_MS);
  });
});
