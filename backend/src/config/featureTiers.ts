export type Tier = 'free' | 'paid'

export const FEATURE_TIERS: Record<string, Tier> = {
  practice:     'free',
  aiHints:      'paid',
  photoGrading: 'paid',
  pairUpload:   'paid',
  review:       'free',
}
