import { useRef, useState } from 'react'

export type AuthMode = 'signin' | 'signup'

interface Props {
  onClose: () => void
  onGoogleSignIn: () => Promise<void>
  onEmailSignIn: (email: string, password: string) => Promise<void>
  onSignUp: (email: string, password: string) => Promise<void>
  initialMode?: AuthMode
  message?: string
}

// An error plus, optionally, the one-click way out of it.
interface AuthError {
  text: string
  cta?: { label: string; onClick: () => void }
}

const COPY = {
  signin: {
    title: 'Sign in',
    subtitle: 'Pick up where you left off.',
    google: 'Continue with Google',
    submit: 'Sign in',
    toggle: "Don't have an account? Sign up",
  },
  signup: {
    title: 'Create your account',
    subtitle: 'Save your progress across devices.',
    google: 'Sign up with Google',
    submit: 'Create account',
    toggle: 'Already have an account? Sign in',
  },
} as const

function codeOf(e: unknown): string {
  return typeof e === 'object' && e !== null && 'code' in e ? String((e as { code: unknown }).code) : ''
}

// Firebase messages arrive as `Firebase: Some text (auth/some-code).` — readable enough
// to keep as a fallback, but only once the wrapper is peeled off.
function fallbackMessage(e: unknown): string {
  const raw = e instanceof Error ? e.message : String(e)
  const stripped = raw.replace(/^Firebase:\s*/, '').replace(/\s*\(auth\/[\w-]+\)\.?$/, '')
  return stripped || 'Something went wrong. Please try again.'
}

export function LoginModal({ onClose, onGoogleSignIn, onEmailSignIn, onSignUp, initialMode = 'signin', message }: Props) {
  const [tab, setTab] = useState<'google' | 'email'>('google')
  const [mode, setMode] = useState<AuthMode>(initialMode)
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<AuthError | null>(null)
  const passwordRef = useRef<HTMLInputElement>(null)

  const copy = COPY[mode]

  function switchMode(next: AuthMode) {
    setMode(next)
    setError(null)
  }

  function handleGoogleError(e: unknown) {
    const code = codeOf(e)
    // The user dismissing the popup isn't an error worth shouting about.
    if (code === 'auth/popup-closed-by-user' || code === 'auth/cancelled-popup-request') return
    if (code === 'auth/popup-blocked') {
      setError({ text: 'Your browser blocked the sign-in popup. Allow popups for this site and try again.' })
      return
    }
    if (code === 'auth/account-exists-with-different-credential') {
      setError({
        text: 'You already have an account with this email, created with a password rather than Google.',
        cta: { label: 'Sign in with email', onClick: () => { setTab('email'); switchMode('signin') } },
      })
      return
    }
    if (code === 'auth/network-request-failed') {
      setError({ text: 'Network error. Check your connection and try again.' })
      return
    }
    setError({ text: fallbackMessage(e) })
  }

  function handleEmailError(e: unknown) {
    const code = codeOf(e)

    // Signing up with an email that already exists: the user is a returning one who
    // picked the wrong mode. Move them across, keep the email, ask for the password.
    if (code === 'auth/email-already-in-use') {
      setMode('signin')
      setPassword('')
      setError({ text: 'You already have an account with this email — enter your password to sign in.' })
      requestAnimationFrame(() => passwordRef.current?.focus())
      return
    }

    // Email enumeration protection collapses "no such user" and "wrong password" into
    // one code, so we genuinely cannot tell which it was. Say so, and offer both exits.
    if (code === 'auth/invalid-credential' || code === 'auth/wrong-password' || code === 'auth/user-not-found') {
      setError({
        text: "That password doesn't match — or you don't have an account yet.",
        cta: { label: 'Create an account', onClick: () => switchMode('signup') },
      })
      return
    }

    if (code === 'auth/weak-password') {
      setError({ text: 'Password must be at least 6 characters.' })
      return
    }
    if (code === 'auth/invalid-email') {
      setError({ text: "That doesn't look like a valid email address." })
      return
    }
    if (code === 'auth/too-many-requests') {
      setError({ text: 'Too many attempts. Wait a few minutes before trying again.' })
      return
    }
    if (code === 'auth/network-request-failed') {
      setError({ text: 'Network error. Check your connection and try again.' })
      return
    }
    setError({ text: fallbackMessage(e) })
  }

  async function handleGoogle() {
    setLoading(true)
    setError(null)
    try {
      await onGoogleSignIn()
    } catch (e) {
      handleGoogleError(e)
    } finally {
      setLoading(false)
    }
  }

  async function handleEmail(e: React.FormEvent) {
    e.preventDefault()
    setLoading(true)
    setError(null)
    try {
      if (mode === 'signin') {
        await onEmailSignIn(email, password)
      } else {
        await onSignUp(email, password)
      }
    } catch (err) {
      handleEmailError(err)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-xl w-full max-w-sm">
        <div className="p-6 pb-4">
          <div className="flex items-center justify-between mb-1">
            <h2 className="text-xl font-bold text-slate-900 dark:text-slate-100">{copy.title}</h2>
            <button
              onClick={onClose}
              className="p-1 rounded-lg text-slate-400 hover:text-slate-600 dark:hover:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors"
              aria-label="Close"
            >
              <svg className="w-5 h-5" fill="none" stroke="currentColor" strokeWidth={2} viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <p className="text-sm text-slate-500 dark:text-slate-400 mb-4">{message ?? copy.subtitle}</p>

          {/* Tab switcher */}
          <div className="flex rounded-lg bg-slate-100 dark:bg-slate-800 p-1 mb-5">
            {(['google', 'email'] as const).map((t) => (
              <button
                key={t}
                onClick={() => setTab(t)}
                className={`flex-1 py-1.5 rounded-md text-sm font-medium transition-colors ${
                  tab === t
                    ? 'bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 shadow-sm'
                    : 'text-slate-500 dark:text-slate-400 hover:text-slate-700 dark:hover:text-slate-300'
                }`}
              >
                {t === 'google' ? 'Google' : 'Email'}
              </button>
            ))}
          </div>

          {tab === 'google' && (
            <button
              onClick={handleGoogle}
              disabled={loading}
              className="w-full flex items-center justify-center gap-3 px-4 py-2.5 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-800 dark:text-slate-200 font-medium hover:bg-slate-50 dark:hover:bg-slate-700 transition-colors disabled:opacity-50"
            >
              <svg className="w-5 h-5" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
              {loading ? 'Signing in…' : copy.google}
            </button>
          )}

          {tab === 'email' && (
            <form onSubmit={handleEmail} className="space-y-3">
              <input
                type="email"
                placeholder="Email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="w-full px-3 py-2 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <input
                ref={passwordRef}
                type="password"
                placeholder="Password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                minLength={6}
                autoComplete={mode === 'signin' ? 'current-password' : 'new-password'}
                className="w-full px-3 py-2 rounded-lg border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-slate-900 dark:text-slate-100 text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
              <button
                type="submit"
                disabled={loading}
                className="w-full py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition-colors disabled:opacity-50"
              >
                {loading ? '…' : copy.submit}
              </button>
              <button
                type="button"
                onClick={() => switchMode(mode === 'signin' ? 'signup' : 'signin')}
                className="w-full text-sm text-slate-500 dark:text-slate-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
              >
                {copy.toggle}
              </button>
              {mode === 'signup' && (
                <p className="text-xs text-slate-400 dark:text-slate-500 text-center">
                  A verification email will be sent to confirm your address.
                </p>
              )}
            </form>
          )}

          {error && (
            <p className="mt-3 text-sm text-red-600 dark:text-red-400">
              {error.text}
              {error.cta && (
                <>
                  {' '}
                  <button
                    type="button"
                    onClick={error.cta.onClick}
                    className="font-semibold underline underline-offset-2 hover:no-underline"
                  >
                    {error.cta.label}
                  </button>
                </>
              )}
            </p>
          )}
        </div>
      </div>
    </div>
  )
}
