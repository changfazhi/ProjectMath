import { useEffect, useState } from 'react'
import { api } from '../lib/api'
import { useAuth } from '../contexts/AuthContext'
import { useUsage } from '../hooks/useUsage'
import { Spinner } from '../components/ui/Spinner'
import { AccuracyTable } from '../components/topic/AccuracyTable'
import type { BillingStatus, DailyActivity, StreakStats } from '../types/api'

// ── Date helpers ──────────────────────────────────────────────────────────────

function addDays(dateStr: string, days: number): string {
  const d = new Date(dateStr + 'T00:00:00Z')
  d.setUTCDate(d.getUTCDate() + days)
  return d.toISOString().slice(0, 10)
}

function getTodayActivityDate(): string {
  return new Date(Date.now() - 16 * 60 * 60 * 1000).toISOString().slice(0, 10)
}

function getTimeUntilReset(): string {
  const now = new Date()
  const next = new Date()
  next.setUTCHours(16, 0, 0, 0)
  if (next.getTime() <= now.getTime()) next.setUTCDate(next.getUTCDate() + 1)
  const diff = next.getTime() - now.getTime()
  const h = Math.floor(diff / 3600000)
  const m = Math.floor((diff % 3600000) / 60000)
  const s = Math.floor((diff % 60000) / 1000)
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
}

function daysLeft(date: Date): number {
  return Math.ceil((date.getTime() - Date.now()) / (1000 * 60 * 60 * 24))
}

function formatDate(date: Date): string {
  return date.toLocaleDateString(undefined, { day: 'numeric', month: 'long', year: 'numeric' })
}

// ── Heatmap grid builder ───────────────────────────────────────────────────────

interface HeatCell {
  date: string
  correctCount: number
  isPadding: boolean
}

function buildGrid(dailyActivity: DailyActivity[]): HeatCell[][] {
  if (dailyActivity.length === 0) return []

  const activityMap = new Map(dailyActivity.map(d => [d.date, d.correctCount]))
  const firstDate = dailyActivity[0].date
  const today = getTodayActivityDate()

  // Pad start back to Monday of the week containing firstDate
  const startRaw = new Date(firstDate + 'T00:00:00Z')
  const startDow = startRaw.getUTCDay() // 0=Sun
  const paddedStart = addDays(firstDate, -(startDow === 0 ? 6 : startDow - 1))

  // Pad end forward to Sunday of the week containing today
  const endRaw = new Date(today + 'T00:00:00Z')
  const endDow = endRaw.getUTCDay() // 0=Sun
  const paddedEnd = addDays(today, endDow === 0 ? 0 : 7 - endDow)

  const cells: HeatCell[] = []
  let current = paddedStart
  while (current <= paddedEnd) {
    const inRange = current >= firstDate && current <= today
    cells.push({
      date: current,
      correctCount: inRange ? (activityMap.get(current) ?? 0) : 0,
      isPadding: !inRange,
    })
    current = addDays(current, 1)
  }

  const weeks: HeatCell[][] = []
  for (let i = 0; i < cells.length; i += 7) {
    weeks.push(cells.slice(i, i + 7))
  }
  return weeks
}

// ── Color scale ────────────────────────────────────────────────────────────────

function cellClass(correctCount: number, isPadding: boolean): string {
  if (isPadding) return 'opacity-0'
  if (correctCount === 0) return 'bg-slate-200 dark:bg-slate-700'
  if (correctCount === 1) return 'bg-green-200'
  if (correctCount <= 3) return 'bg-green-400'
  if (correctCount <= 6) return 'bg-green-500'
  return 'bg-green-600'
}

// ── Constants ─────────────────────────────────────────────────────────────────

const MONTHS = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
const DAY_LABELS = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']

function monthOf(dateStr: string): string {
  return MONTHS[parseInt(dateStr.slice(5, 7), 10) - 1]
}

function formatDaysCount(n: number): string {
  return `${n} ${n === 1 ? 'day' : 'days'}`
}

// ── Account & plan section ──────────────────────────────────────────────────────

function AccountSection() {
  const { user, tier, accessExpiresAt, openUpgradeModal } = useAuth()
  const [billing, setBilling] = useState<BillingStatus | null>(null)
  const [loadingPortal, setLoadingPortal] = useState(false)
  const [portalError, setPortalError] = useState<string | null>(null)

  useEffect(() => {
    if (tier !== 'paid') return
    api.billing.status().then(setBilling).catch(() => {})
  }, [tier])

  async function handleManagePortal() {
    if (loadingPortal) return
    setLoadingPortal(true)
    setPortalError(null)
    try {
      const { url } = await api.billing.portal()
      window.location.href = url
    } catch (err) {
      setPortalError(err instanceof Error ? err.message : 'Could not open billing portal. Please try again.')
      setLoadingPortal(false)
    }
  }

  const memberSince = user?.metadata.creationTime ? formatDate(new Date(user.metadata.creationTime)) : null

  let planDetail: string | null = null
  if (tier === 'paid') {
    if (accessExpiresAt) {
      planDetail = `Access expires in ${formatDaysCount(daysLeft(accessExpiresAt))} (${formatDate(accessExpiresAt)})`
    } else if (billing?.renewsAt) {
      const renewsAt = new Date(billing.renewsAt)
      planDetail = `Renews in ${formatDaysCount(daysLeft(renewsAt))} (${formatDate(renewsAt)})`
    }
  }

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-2">
        <span className="text-xs text-slate-500 dark:text-slate-400">Account</span>
        <span className="text-sm font-semibold text-slate-900 dark:text-slate-100 truncate">{user?.email}</span>
        {memberSince && (
          <span className="text-xs text-slate-500 dark:text-slate-400">Member since {memberSince}</span>
        )}
      </div>

      <div className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-2">
        <span className="text-xs text-slate-500 dark:text-slate-400">Plan</span>
        <span
          className="text-sm font-semibold truncate"
          style={tier === 'paid' ? { color: '#d97706' } : undefined}
        >
          {tier === 'paid' ? '✦ Premium' : 'Free'}
        </span>
        {planDetail && (
          <span className="text-xs text-slate-500 dark:text-slate-400">{planDetail}</span>
        )}
        {tier === 'paid' ? (
          <button
            onClick={handleManagePortal}
            disabled={loadingPortal}
            className="mt-1 self-start text-xs font-semibold text-indigo-600 dark:text-indigo-400 hover:underline disabled:opacity-50"
          >
            {loadingPortal ? 'Opening billing portal…' : 'Manage subscription'}
          </button>
        ) : (
          <button
            onClick={openUpgradeModal}
            className="mt-1 self-start text-xs font-semibold text-indigo-600 dark:text-indigo-400 hover:underline"
          >
            Upgrade to Premium
          </button>
        )}
        {portalError && <span className="text-xs text-red-500">{portalError}</span>}
      </div>
    </div>
  )
}

function UsageSection() {
  const { usage } = useUsage()
  if (!usage) return null

  const rows = [
    { label: 'AI Scans Today', bucket: usage.scans },
    { label: 'AI Tutor Hints Today', bucket: usage.chat },
  ]

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
      {rows.map(({ label, bucket }) => (
        <div
          key={label}
          className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-1"
        >
          <span className="text-xs text-slate-500 dark:text-slate-400">{label}</span>
          <span className="text-xl font-bold text-slate-900 dark:text-slate-100">
            {bucket.used}{bucket.limit !== null ? ` / ${bucket.limit}` : ' (unlimited)'}
          </span>
        </div>
      ))}
    </div>
  )
}

// ── Component ─────────────────────────────────────────────────────────────────

export function ProfilePage() {
  const [stats, setStats] = useState<StreakStats | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [timeLeft, setTimeLeft] = useState(getTimeUntilReset)

  useEffect(() => {
    api.streaks.get()
      .then(setStats)
      .catch(e => setError((e as Error).message))
      .finally(() => setLoading(false))
  }, [])

  useEffect(() => {
    const id = setInterval(() => setTimeLeft(getTimeUntilReset()), 1000)
    return () => clearInterval(id)
  }, [])

  if (loading) {
    return (
      <div className="flex justify-center py-16">
        <Spinner size="lg" />
      </div>
    )
  }

  if (error) {
    return (
      <div className="max-w-4xl mx-auto px-4 py-8 text-red-500 text-sm">{error}</div>
    )
  }

  if (!stats) return null

  const weeks = buildGrid(stats.dailyActivity)

  const monthLabels: (string | null)[] = weeks.map((week, i) => {
    if (i === 0) return monthOf(week[0].date)
    return week[0].date.slice(0, 7) !== weeks[i - 1][0].date.slice(0, 7)
      ? monthOf(week[0].date)
      : null
  })

  const statCards = [
    { label: 'Total Submissions', value: String(stats.totalAttempts) },
    { label: 'Total Solved', value: `${stats.totalSolved} / ${stats.totalQuestions}` },
    { label: 'Current Streak', value: formatDaysCount(stats.currentStreak) },
    { label: 'Best Streak', value: formatDaysCount(stats.bestStreak) },
  ]

  return (
    <div className="max-w-5xl mx-auto px-4 py-8 flex flex-col gap-8">
      <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100">Profile</h1>

      <AccountSection />
      <UsageSection />

      {/* Stat cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {statCards.map(({ label, value }) => (
          <div
            key={label}
            className="bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl p-4 flex flex-col gap-1"
          >
            <span className="text-xs text-slate-500 dark:text-slate-400">{label}</span>
            <span className="text-xl font-bold text-slate-900 dark:text-slate-100 truncate">{value}</span>
          </div>
        ))}
      </div>

      {/* Countdown */}
      <p className="text-sm text-slate-500 dark:text-slate-400">
        <span className="font-mono font-semibold text-slate-700 dark:text-slate-200">{timeLeft}</span>
        {' '}left until streak resets
      </p>

      {/* Heatmap */}
      {weeks.length === 0 ? (
        <p className="text-sm text-slate-400 dark:text-slate-500">
          No activity yet — start practicing to build your streak!
        </p>
      ) : (
        <div className="overflow-x-auto pb-2">
          <div className="inline-flex flex-col gap-1 min-w-max">

            {/* Month labels row */}
            <div className="flex gap-1 ml-9">
              {weeks.map((_week, i) => (
                <div
                  key={i}
                  className="w-3 overflow-visible whitespace-nowrap text-[10px] text-slate-400 dark:text-slate-500 leading-none"
                >
                  {monthLabels[i] ?? ''}
                </div>
              ))}
            </div>

            {/* Day labels + week columns */}
            <div className="flex gap-1">
              {/* Day labels */}
              <div className="flex flex-col gap-1 mr-1 w-8">
                {DAY_LABELS.map((day, i) => (
                  <div
                    key={day}
                    className="h-3 text-[10px] text-slate-400 dark:text-slate-500 leading-3 text-right"
                  >
                    {i === 0 || i === 2 || i === 4 ? day : ''}
                  </div>
                ))}
              </div>

              {/* Week columns */}
              {weeks.map((week, wi) => (
                <div key={wi} className="flex flex-col gap-1">
                  {week.map((cell, di) => (
                    <div
                      key={di}
                      className={`w-3 h-3 rounded-sm ${cellClass(cell.correctCount, cell.isPadding)}`}
                      title={
                        cell.isPadding
                          ? undefined
                          : `${cell.date}: ${cell.correctCount} correct`
                      }
                    />
                  ))}
                </div>
              ))}
            </div>

          </div>
        </div>
      )}

      {/* Accuracy by topic */}
      <AccuracyTable />
    </div>
  )
}
