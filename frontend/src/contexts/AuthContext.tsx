import { createContext, useContext, useEffect, useState } from 'react'
import {
  type User,
  GoogleAuthProvider,
  signInWithPopup,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  sendEmailVerification,
  onAuthStateChanged,
  signOut as firebaseSignOut,
} from 'firebase/auth'
import { auth } from '../lib/firebase'
import { api, setApiCallbacks } from '../lib/api'
import { LoginModal, type AuthMode } from '../components/LoginModal'
import { UpgradeModal } from '../components/UpgradeModal'
import { FeedbackModal } from '../components/FeedbackModal'

type Tier = 'free' | 'paid'

interface AuthContextValue {
  user: User | null
  tier: Tier | null
  accessExpiresAt: Date | null
  loading: boolean
  signInWithGoogle: () => Promise<void>
  signInWithEmail: (email: string, password: string) => Promise<void>
  signUp: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
  // `mode` seeds the modal's signin/signup state from the caller's intent — a marketing
  // CTA means "signup", an expired session means "signin". Defaults to 'signin'.
  openLoginModal: (options?: { mode?: AuthMode; message?: string }) => void
  openUpgradeModal: () => void
  openFeedbackModal: () => void
  // Re-reads the server's tier and returns it, so callers can poll until a
  // webhook-granted upgrade lands.
  refreshTier: () => Promise<Tier | null>
}

const AuthContext = createContext<AuthContextValue | null>(null)

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider')
  return ctx
}

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [tier, setTier] = useState<Tier | null>(null)
  const [accessExpiresAt, setAccessExpiresAt] = useState<Date | null>(null)
  const [loading, setLoading] = useState(true)
  const [loginMessage, setLoginMessage] = useState<string | undefined>()
  const [loginMode, setLoginMode] = useState<AuthMode>('signin')
  const [showLogin, setShowLogin] = useState(false)
  const [showUpgrade, setShowUpgrade] = useState(false)
  const [showFeedback, setShowFeedback] = useState(false)

  // First paint only. The Firebase claim is baked into an ID token that lives up to an hour, so
  // it can be an hour out of date — a just-cancelled user's token still says `paid`. It's read
  // here purely so the header doesn't flash "Free" while /api/me is in flight; the server's
  // answer overwrites it moments later and is the only value anything may act on. See issue #54.
  function applyStaleClaims(result: { claims: Record<string, unknown> }) {
    setTier(result.claims['tier'] === 'paid' ? 'paid' : 'free')
    const expiresAtRaw = result.claims['expires_at']
    setAccessExpiresAt(typeof expiresAtRaw === 'string' ? new Date(expiresAtRaw) : null)
  }

  // The server derives tier from the `users` row, so this reflects a cancellation or an upgrade
  // immediately rather than whenever the ID token next refreshes.
  const fetchTier = async (): Promise<Tier | null> => {
    const me = await api.me.get()
    setTier(me.tier)
    setAccessExpiresAt(me.accessExpiresAt ? new Date(me.accessExpiresAt) : null)
    return me.tier
  }

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      setUser(u)
      if (u) {
        applyStaleClaims(await u.getIdTokenResult())
        // A failed fetch leaves the optimistic claim in place. The server still enforces the real
        // tier on every request, so the worst case is Premium chrome over a 402/429.
        await fetchTier().catch(() => {})
      } else {
        setTier(null)
        setAccessExpiresAt(null)
      }
      setLoading(false)
    })
    return unsub
  }, [])

  const openLoginModal = (options?: { mode?: AuthMode; message?: string }) => {
    setLoginMessage(options?.message)
    setLoginMode(options?.mode ?? 'signin')
    setShowLogin(true)
  }
  const openUpgradeModal = () => setShowUpgrade(true)
  const openFeedbackModal = () => setShowFeedback(true)

  const refreshTier = async (): Promise<Tier | null> => {
    if (!auth.currentUser) return null
    return fetchTier()
  }

  useEffect(() => {
    setApiCallbacks({
      onUnauthorized: () => openLoginModal(),
      onPaymentRequired: openUpgradeModal,
    })
  }, [])

  const signInWithGoogle = async () => {
    const provider = new GoogleAuthProvider()
    await signInWithPopup(auth, provider)
    setShowLogin(false)
  }

  const signInWithEmail = async (email: string, password: string) => {
    await signInWithEmailAndPassword(auth, email, password)
    setShowLogin(false)
  }

  const signUp = async (email: string, password: string) => {
    const cred = await createUserWithEmailAndPassword(auth, email, password)
    await sendEmailVerification(cred.user)
    setShowLogin(false)
  }

  const signOut = async () => {
    await firebaseSignOut(auth)
  }

  return (
    <AuthContext.Provider
      value={{ user, tier, accessExpiresAt, loading, signInWithGoogle, signInWithEmail, signUp, signOut, openLoginModal, openUpgradeModal, openFeedbackModal, refreshTier }}
    >
      {children}
      {showLogin && (
        <LoginModal
          onClose={() => setShowLogin(false)}
          onGoogleSignIn={signInWithGoogle}
          onEmailSignIn={signInWithEmail}
          onSignUp={signUp}
          initialMode={loginMode}
          message={loginMessage}
        />
      )}
      {showUpgrade && <UpgradeModal onClose={() => setShowUpgrade(false)} />}
      {showFeedback && <FeedbackModal onClose={() => setShowFeedback(false)} />}
    </AuthContext.Provider>
  )
}
