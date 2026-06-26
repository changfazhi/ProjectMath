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

type Tier = 'free' | 'paid'

interface AuthContextValue {
  user: User | null
  tier: Tier | null
  loading: boolean
  signInWithGoogle: () => Promise<void>
  signInWithEmail: (email: string, password: string) => Promise<void>
  signUp: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
  openLoginModal: (message?: string) => void
  openUpgradeModal: () => void
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
  const [loading, setLoading] = useState(true)
  const [loginMessage, setLoginMessage] = useState<string | undefined>()
  const [showLogin, setShowLogin] = useState(false)
  const [showUpgrade, setShowUpgrade] = useState(false)

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (u) => {
      setUser(u)
      if (u) {
        const result = await u.getIdTokenResult()
        setTier(result.claims['tier'] === 'paid' ? 'paid' : 'free')
      } else {
        setTier(null)
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
      value={{ user, tier, loading, signInWithGoogle, signInWithEmail, signUp, signOut, openLoginModal, openUpgradeModal }}
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
    </AuthContext.Provider>
  )
}
