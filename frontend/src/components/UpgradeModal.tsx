import { useState } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../contexts/AuthContext'

const BRICOLAGE = "'Bricolage Grotesque', sans-serif"

const BENEFITS = [
  'Unlimited AI scans of handwritten solutions',
  'Unlimited AI tutor hints (free: 3/day each)',
  'Daily weakness diagnosis (free: weekly)',
  'Fresh study plan every day (free: weekly)',
]

type Method = 'card' | 'paynow'

interface PlanCardProps {
  label: string
  price: string
  subtext: string
  badge?: string
  note?: string
  plan: 'monthly' | 'semesterly'
  loading: boolean
  onClick: (plan: 'monthly' | 'semesterly') => void
}

function PlanCard({ label, price, subtext, badge, note, plan, loading, onClick }: PlanCardProps) {
  return (
    <button
      onClick={() => onClick(plan)}
      disabled={loading}
      className="relative flex flex-col items-start w-full rounded-2xl border p-6 text-left transition-all focus:outline-none"
      style={{
        background: 'rgba(79,70,229,0.08)',
        borderColor: loading ? '#4f46e5' : '#2a2f5a',
        cursor: loading ? 'wait' : 'pointer',
      }}
      onMouseEnter={e => { if (!loading) (e.currentTarget as HTMLElement).style.borderColor = '#7c83ff' }}
      onMouseLeave={e => { if (!loading) (e.currentTarget as HTMLElement).style.borderColor = '#2a2f5a' }}
    >
      {badge && (
        <span
          className="absolute top-4 right-4 rounded-full px-2.5 py-0.5 text-[11px] font-bold uppercase tracking-wide"
          style={{ background: 'linear-gradient(135deg,#f59e0b,#d97706)', color: '#fff' }}
        >
          {badge}
        </span>
      )}

      <span className="text-sm font-bold uppercase tracking-widest" style={{ color: '#7c83ff' }}>
        {label}
      </span>

      <ul className="mt-4 space-y-2 flex-1">
        {BENEFITS.map(b => (
          <li key={b} className="flex items-start gap-2 text-sm text-[#c7cbff]">
            <span className="mt-0.5 shrink-0 text-[#7c83ff]">✓</span>
            {b}
          </li>
        ))}
      </ul>

      <div className="mt-6 border-t pt-4 w-full" style={{ borderColor: '#2a2f5a' }}>
        <span className="text-3xl font-extrabold text-white" style={{ fontFamily: BRICOLAGE }}>
          {price}
        </span>
        <span className="ml-1 text-sm text-[#aab0d6]">{subtext}</span>
        {note && <p className="mt-1 text-[11px] text-[#6b7280]">{note}</p>}
      </div>

      {loading && (
        <div
          className="absolute inset-0 flex items-center justify-center rounded-2xl"
          style={{ background: 'rgba(11,14,32,0.6)' }}
        >
          <span className="text-[#7c83ff] text-sm font-semibold animate-pulse">Redirecting…</span>
        </div>
      )}
    </button>
  )
}

interface Props {
  onClose: () => void
}

export function UpgradeModal({ onClose }: Props) {
  const { tier, accessExpiresAt } = useAuth()
  const [method, setMethod] = useState<Method>('card')
  const [loadingPlan, setLoadingPlan] = useState<'monthly' | 'semesterly' | null>(null)
  const [loadingPortal, setLoadingPortal] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const isPaid = tier === 'paid'

  async function handleSelect(plan: 'monthly' | 'semesterly') {
    if (loadingPlan) return
    setLoadingPlan(plan)
    setError(null)
    try {
      const { url } = await api.billing.checkout(plan, method)
      window.location.href = url
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
      setLoadingPlan(null)
    }
  }

  async function handleManagePortal() {
    if (loadingPortal) return
    setLoadingPortal(true)
    setError(null)
    try {
      const { url } = await api.billing.portal()
      window.location.href = url
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Could not open billing portal. Please try again.')
      setLoadingPortal(false)
    }
  }

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ background: 'rgba(0,0,0,0.7)', backdropFilter: 'blur(4px)' }}
      onClick={e => { if (e.target === e.currentTarget) onClose() }}
    >
      <div
        className="relative w-full max-w-xl rounded-3xl p-8"
        style={{ background: '#0d1030', border: '1px solid #1c2140', boxShadow: '0 24px 64px -12px rgba(0,0,0,0.8)' }}
      >
        <button
          onClick={onClose}
          className="absolute top-5 right-5 text-[#aab0d6] hover:text-white transition-colors text-xl leading-none"
        >
          ×
        </button>

        <div className="text-center mb-6">
          <div className="text-3xl mb-3">✦</div>
          <h2 className="text-2xl font-extrabold text-white" style={{ fontFamily: BRICOLAGE }}>
            {isPaid ? 'Manage Premium' : 'Upgrade to Premium'}
          </h2>
          <p className="mt-2 text-sm text-[#aab0d6]">
            Unlock AI-powered tools to practise smarter. Switch between Card and PayNow anytime — your access carries over.
          </p>
        </div>

        {isPaid && (
          <div
            className="mb-6 rounded-xl px-4 py-3 text-sm text-[#c7cbff]"
            style={{ background: 'rgba(79,70,229,0.12)', border: '1px solid #2a2f5a' }}
          >
            {accessExpiresAt ? (
              <>
                You're on <strong>PayNow</strong>, active until{' '}
                <strong>{accessExpiresAt.toLocaleDateString(undefined, { day: 'numeric', month: 'long', year: 'numeric' })}</strong>.
                Buy another period below to extend it, or switch to Card — billing only starts once this period ends.
              </>
            ) : (
              <>
                You have an active <strong>Card</strong> subscription. Buy a PayNow period below to switch —
                your card will stop billing at the end of the current period.
              </>
            )}
          </div>
        )}

        {/* Payment method toggle */}
        <div
          className="flex rounded-xl p-1 mb-6"
          style={{ background: 'rgba(255,255,255,0.05)' }}
        >
          {(['card', 'paynow'] as Method[]).map(m => (
            <button
              key={m}
              onClick={() => { setMethod(m); setError(null) }}
              className="flex-1 rounded-lg py-2 text-sm font-semibold transition-all"
              style={
                method === m
                  ? { background: '#4f46e5', color: '#fff' }
                  : { color: '#aab0d6' }
              }
            >
              {m === 'card' ? '💳  Card' : 'PayNow'}
            </button>
          ))}
        </div>

        {/* Plan cards */}
        <div className="grid grid-cols-2 gap-4">
          <PlanCard
            label="Monthly"
            price="S$5"
            subtext={method === 'card' ? '/ month' : 'one-time'}
            plan="monthly"
            loading={loadingPlan === 'monthly'}
            onClick={handleSelect}
          />
          <PlanCard
            label="Semesterly"
            price="S$25"
            subtext={method === 'card' ? '/ 6 months' : 'one-time'}
            badge="Save 17%"
            note={method === 'card' ? undefined : 'S$4.17 / month equivalent'}
            plan="semesterly"
            loading={loadingPlan === 'semesterly'}
            onClick={handleSelect}
          />
        </div>

        {/* Footer note */}
        <p className="mt-4 text-center text-xs text-[#6b7280]">
          {method === 'card'
            ? 'Card payments auto-renew each period. You can cancel anytime from the billing portal — no questions asked.'
            : 'PayNow is a one-time payment with no auto-renewal. Access is granted for the selected period. Rollover your current plan at any time by adding on another period — it stacks on top of your remaining access.'}
        </p>

        {isPaid && (
          <p className="mt-4 text-center text-xs">
            <button
              onClick={handleManagePortal}
              disabled={loadingPortal}
              className="text-[#aab0d6] hover:text-white underline transition-colors disabled:opacity-50"
            >
              {loadingPortal ? 'Opening billing portal…' : 'Manage or cancel current subscription'}
            </button>
          </p>
        )}

        {error && (
          <p className="mt-4 text-center text-sm text-red-400">{error}</p>
        )}
      </div>
    </div>
  )
}
