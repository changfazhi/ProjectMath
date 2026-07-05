import { useAuth } from '../contexts/AuthContext'

// Mirror of backend/src/config/featureTiers.ts — all AI features are free-accessible;
// free-tier usage is metered per day/week server-side (see GET /api/usage).
const FEATURE_TIERS: Record<string, 'free' | 'paid'> = {
  practice:     'free',
  aiHints:      'free',
  photoGrading: 'free',
  pairUpload:   'free',
  review:       'free',
}

export function useFeature(feature: string): boolean {
  const { tier } = useAuth()
  const required = FEATURE_TIERS[feature] ?? 'paid'
  if (required === 'free') return tier !== null
  return tier === 'paid'
}
