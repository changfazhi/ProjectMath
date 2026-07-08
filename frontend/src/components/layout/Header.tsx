import { Link, NavLink } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'
import { AccountMenu } from './AccountMenu'

const BRICOLAGE = "'Bricolage Grotesque', sans-serif"

const NAV_ITEMS: { to: string; label: string; end?: boolean }[] = [
  { to: '/roadmap', label: 'Topics', end: true },
  { to: '/history', label: 'History' },
  { to: '/starred', label: 'Starred' },
  { to: '/review', label: 'Review' },
]

export function Header() {
  const { user, tier, openLoginModal, openUpgradeModal, openFeedbackModal } = useAuth()

  return (
    <header
      className="sticky top-0 z-30 border-b backdrop-blur"
      style={{ background: 'rgba(11,14,32,.82)', borderColor: '#1c2140' }}
    >
      <div className="max-w-5xl mx-auto px-6 h-14 flex items-center gap-6">
        {/* Logo — matches the landing-page wordmark */}
        <Link to="/" className="flex items-center gap-2.5 shrink-0">
          <div
            className="flex items-center justify-center rounded-[10px] text-white"
            style={{
              width: 32,
              height: 32,
              fontSize: 18,
              fontWeight: 800,
              fontFamily: BRICOLAGE,
              background: 'linear-gradient(135deg,#4f46e5,#7c3aed)',
            }}
          >
            π
          </div>
          <span
            className="text-lg font-extrabold tracking-tight text-white"
            style={{ fontFamily: BRICOLAGE }}
          >
            Project<span style={{ color: '#7c83ff' }}>Math</span>
          </span>
        </Link>

        <nav className="flex items-center gap-1">
          {NAV_ITEMS.map((item) => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.end}
              className={({ isActive }) =>
                `px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors ${
                  isActive
                    ? 'text-white bg-white/10'
                    : 'text-[#aab0d6] hover:text-white'
                }`
              }
            >
              {item.label}
            </NavLink>
          ))}
        </nav>

        <div className="ml-auto flex items-center gap-2">
          <button
            onClick={() => (user ? openFeedbackModal() : openLoginModal('Sign in to send feedback'))}
            className="px-3 py-1.5 rounded-lg text-sm font-semibold text-[#aab0d6] hover:text-white transition-colors"
          >
            Feedback
          </button>

          {user && tier === 'free' && (
            <button
              onClick={openUpgradeModal}
              className="px-4 py-2 rounded-[11px] text-sm font-bold text-white transition-transform hover:-translate-y-0.5"
              style={{ background: 'linear-gradient(135deg,#f59e0b,#d97706)', boxShadow: '0 8px 18px -6px rgba(245,158,11,0.5)' }}
            >
              ✦ Get Premium
            </button>
          )}

          {user && tier === 'paid' && (
            <button
              onClick={openUpgradeModal}
              className="px-3 py-1.5 rounded-lg text-sm font-semibold transition-colors"
              style={{ color: '#f59e0b' }}
              title="Extend, switch, or manage your subscription"
            >
              ✦ Premium
            </button>
          )}

          {user ? (
            <AccountMenu />
          ) : (
            <button
              onClick={() => openLoginModal()}
              className="px-4 py-2 rounded-[11px] text-sm font-bold text-white transition-transform hover:-translate-y-0.5"
              style={{ background: '#4f46e5', boxShadow: '0 8px 18px -6px #4f46e5' }}
            >
              Sign in
            </button>
          )}
        </div>
      </div>
    </header>
  )
}
