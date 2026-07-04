import { useState, useEffect } from 'react'
import { useAuth } from '../contexts/AuthContext'

const STORAGE_KEY = 'premium_expiry_banner_dismissed'

function getTodaySGT(): string {
  return new Date().toLocaleDateString('en-SG', { timeZone: 'Asia/Singapore' })
}

interface Props {
  onRenew: () => void
}

export function PremiumExpiryBanner({ onRenew }: Props) {
  const { accessExpiresAt, tier } = useAuth()
  const [visible, setVisible] = useState(false)

  useEffect(() => {
    if (!accessExpiresAt || tier !== 'paid') return
    const msLeft = accessExpiresAt.getTime() - Date.now()
    const daysLeft = Math.ceil(msLeft / (1000 * 60 * 60 * 24))
    if (daysLeft > 3 || daysLeft <= 0) return

    const today = getTodaySGT()
    if (localStorage.getItem(STORAGE_KEY) === today) return

    setVisible(true)
  }, [accessExpiresAt, tier])

  if (!visible || !accessExpiresAt) return null

  const daysLeft = Math.ceil((accessExpiresAt.getTime() - Date.now()) / (1000 * 60 * 60 * 24))

  function dismiss() {
    localStorage.setItem(STORAGE_KEY, getTodaySGT())
    setVisible(false)
  }

  return (
    <div
      className="flex items-center justify-between gap-4 px-6 py-2 text-sm font-medium"
      style={{ background: '#78350f', color: '#fef3c7' }}
    >
      <span>
        Your Premium access expires in{' '}
        <strong>{daysLeft} {daysLeft === 1 ? 'day' : 'days'}</strong>.{' '}
        <button
          onClick={() => { onRenew(); dismiss() }}
          className="underline font-bold hover:text-white transition-colors"
        >
          Renew now
        </button>
      </span>
      <button
        onClick={dismiss}
        className="shrink-0 text-amber-300 hover:text-white transition-colors text-lg leading-none"
        aria-label="Dismiss"
      >
        ×
      </button>
    </div>
  )
}
