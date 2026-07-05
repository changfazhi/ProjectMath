export type Tier = 'free' | 'paid'

// All AI features are free-accessible; free-tier usage is metered per day/week
// by TIER_LIMITS in config/limits.ts (enforced in the services, not here).
export const FEATURE_TIERS: Record<string, Tier> = {
  practice:     'free',
  aiHints:      'free',
  photoGrading: 'free',
  pairUpload:   'free',
  review:       'free',
}
