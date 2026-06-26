export type Tier = 'free' | 'paid'

export const FEATURE_TIERS: Record<string, Tier> = {
  practice:     'free',
  aiHints:      'free',
  photoGrading: 'free',
  pairUpload:   'free',
  review:       'free',
}
