import type { Tier } from './featureTiers.js';
import type { CooldownRule } from '../lib/sgTime.js';

// Per-tier usage quotas. featureTiers.ts decides WHO may use a feature; this file decides
// HOW MUCH of it they get. `null` = unlimited.
export interface TierLimits {
  scansPerDay: number | null;
  chatMessagesPerDay: number | null;
  diagnosisCooldown: CooldownRule;
  studyPlanCadence: CooldownRule;
}

export const TIER_LIMITS: Record<Tier, TierLimits> = {
  free: {
    scansPerDay: 3,
    chatMessagesPerDay: 3,
    diagnosisCooldown: { kind: 'rollingDays', days: 7 },
    studyPlanCadence: { kind: 'rollingDays', days: 7 },
  },
  paid: {
    scansPerDay: null,
    chatMessagesPerDay: null,
    diagnosisCooldown: { kind: 'nextSgtDay' },
    studyPlanCadence: { kind: 'nextSgtDay' },
  },
};
