import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../../contexts/AuthContext'

export function AccountMenu() {
  const { signOut } = useAuth()
  const navigate = useNavigate()
  const [open, setOpen] = useState(false)
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (!open) return
    function onPointerDown(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false)
    }
    function onKeyDown(e: KeyboardEvent) {
      if (e.key === 'Escape') setOpen(false)
    }
    document.addEventListener('mousedown', onPointerDown)
    document.addEventListener('keydown', onKeyDown)
    return () => {
      document.removeEventListener('mousedown', onPointerDown)
      document.removeEventListener('keydown', onKeyDown)
    }
  }, [open])

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => setOpen(o => !o)}
        aria-expanded={open}
        className="px-3 py-1.5 rounded-lg text-sm font-semibold text-[#aab0d6] hover:text-white transition-colors"
      >
        Your Account
      </button>

      {open && (
        <div
          className="absolute right-0 top-full mt-2 w-44 rounded-xl py-1.5 z-40"
          style={{ background: '#0d1030', border: '1px solid #1c2140', boxShadow: '0 12px 32px -8px rgba(0,0,0,0.6)' }}
        >
          <button
            onClick={() => { setOpen(false); navigate('/profile') }}
            className="w-full text-left px-4 py-2 text-sm font-semibold text-[#c7cbff] hover:text-white hover:bg-white/5 transition-colors"
          >
            Profile
          </button>
          <button
            onClick={() => { setOpen(false); signOut().then(() => navigate('/')) }}
            className="w-full text-left px-4 py-2 text-sm font-semibold text-[#c7cbff] hover:text-white hover:bg-white/5 transition-colors"
          >
            Sign out
          </button>
        </div>
      )}
    </div>
  )
}
