import { useAuth } from '../contexts/AuthContext'

const FEATURE_TIERS: Record<string, 'free' | 'paid'> = {
  practice:     'free',
  aiHints:      'paid',
  photoGrading: 'paid',
  pairUpload:   'paid',
  review:       'free',
}

export function useFeature(feature: string): boolean {
  const { tier } = useAuth()
  const required = FEATURE_TIERS[feature] ?? 'paid'
  if (required === 'free') return tier !== null
  return tier === 'paid'
}
