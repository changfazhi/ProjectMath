// Day-boundary math for Asia/Singapore (UTC+8, no DST — a fixed offset is safe, no tz lib needed).
// All quota windows and cooldowns in the app reset at SGT midnight.

const SGT_OFFSET_MS = 8 * 3_600_000;
export const DAY_MS = 86_400_000;

/** UTC instant of the most recent midnight in Asia/Singapore. */
export function sgtDayStartUtc(now: Date = new Date()): Date {
  const shifted = now.getTime() + SGT_OFFSET_MS;
  return new Date(Math.floor(shifted / DAY_MS) * DAY_MS - SGT_OFFSET_MS);
}

/** UTC instant of the next SGT midnight — when daily quotas reset. */
export function nextSgtMidnightUtc(now: Date = new Date()): Date {
  return new Date(sgtDayStartUtc(now).getTime() + DAY_MS);
}

/** YYYY-MM-DD of "today" in SGT. */
export function sgtDateStr(now: Date = new Date()): string {
  return new Date(now.getTime() + SGT_OFFSET_MS).toISOString().slice(0, 10);
}

export type CooldownRule = { kind: 'nextSgtDay' } | { kind: 'rollingDays'; days: number };

/** UTC instant at which a generation cooldown ends. */
export function cooldownEndsAt(generatedAt: Date, rule: CooldownRule): Date {
  return rule.kind === 'nextSgtDay'
    ? nextSgtMidnightUtc(generatedAt)
    : new Date(generatedAt.getTime() + rule.days * DAY_MS);
}
