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
import { setApiCallbacks } from '../lib/api'
import { LoginModal } from '../components/LoginModal'
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
  openLoginModal: (message?: string) => void
  openUpgradeModal: () => void
  openFeedbackModal: () => void
  // Force-refreshes the Firebase token and returns the fresh tier, so callers
  // can poll until a webhook-granted upgrade lands.
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
  const [showLogin, setShowLogin] = useState(false)
  const [showUpgrade, setShowUpgrade] = useState(false)
  const [showFeedback, setShowFeedback] = useState(false)

  function applyTokenResult(result: { claims: Record<string, unknown> }) {
    setTier(result.claims['tier'] === 'paid' ? 'paid' : 'free')
    const expiresAtRaw = result.claims['expires_at']
    setAccessExpiresAt(typeof expiresAtRaw === 'string' ? new Date(expiresAtRaw) : null)
  }

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      setUser(u)
      if (u) {
        const result = await u.getIdTokenResult()
        applyTokenResult(result)
      } else {
        setTier(null)
        setAccessExpiresAt(null)
      }
      setLoading(false)
    })
    return unsub
  }, [])

  const openLoginModal = (message?: string) => {
    setLoginMessage(message)
    setShowLogin(true)
  }
  const openUpgradeModal = () => setShowUpgrade(true)
  const openFeedbackModal = () => setShowFeedback(true)

  const refreshTier = async (): Promise<Tier | null> => {
    if (!auth.currentUser) return null
    const result = await auth.currentUser.getIdTokenResult(true)
    applyTokenResult(result)
    return result.claims['tier'] === 'paid' ? 'paid' : 'free'
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
          message={loginMessage}
        />
      )}
      {showUpgrade && <UpgradeModal onClose={() => setShowUpgrade(false)} />}
      {showFeedback && <FeedbackModal onClose={() => setShowFeedback(false)} />}
    </AuthContext.Provider>
  )
}
