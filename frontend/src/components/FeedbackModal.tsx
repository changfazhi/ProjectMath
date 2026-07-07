import { useEffect, useRef, useState } from 'react'
import { api } from '../lib/api'
import type { FeedbackCategory } from '../types/api'

const BRICOLAGE = "'Bricolage Grotesque', sans-serif"

const CATEGORIES: { value: FeedbackCategory; label: string }[] = [
  { value: 'bug', label: '🐞 Bug' },
  { value: 'idea', label: '💡 Idea' },
  { value: 'question', label: '❓ Question' },
  { value: 'other', label: 'Other' },
]

const MAX_LENGTH = 2000

interface Props {
  onClose: () => void
}

export function FeedbackModal({ onClose }: Props) {
  const [message, setMessage] = useState('')
  const [category, setCategory] = useState<FeedbackCategory | null>(null)
  const [sending, setSending] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [sent, setSent] = useState(false)
  const closeTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => {
    return () => {
      if (closeTimer.current) clearTimeout(closeTimer.current)
    }
  }, [])

  async function handleSubmit() {
    if (sending || !message.trim()) return
    setSending(true)
    setError(null)
    try {
      await api.feedback.send({
        message: message.trim(),
        category: category ?? undefined,
        page: window.location.pathname,
      })
      setSent(true)
      closeTimer.current = setTimeout(onClose, 1500)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Something went wrong. Please try again.')
      setSending(false)
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

        {sent ? (
          <div className="py-10 text-center">
            <div className="text-4xl mb-3">✓</div>
            <h2 className="text-2xl font-extrabold text-white" style={{ fontFamily: BRICOLAGE }}>
              Thanks — feedback sent!
            </h2>
          </div>
        ) : (
          <>
            <div className="text-center mb-6">
              <div className="text-3xl mb-3">💬</div>
              <h2 className="text-2xl font-extrabold text-white" style={{ fontFamily: BRICOLAGE }}>
                Send feedback
              </h2>
              <p className="mt-2 text-sm text-[#aab0d6]">
                Spotted a bug or have an idea? It goes straight to us.
              </p>
            </div>

            {/* Category picker (optional) */}
            <div
              className="flex rounded-xl p-1 mb-4"
              style={{ background: 'rgba(255,255,255,0.05)' }}
            >
              {CATEGORIES.map(c => (
                <button
                  key={c.value}
                  onClick={() => { setCategory(c.value); setError(null) }}
                  className="flex-1 rounded-lg py-2 text-sm font-semibold transition-all"
                  style={
                    category === c.value
                      ? { background: '#4f46e5', color: '#fff' }
                      : { color: '#aab0d6' }
                  }
                >
                  {c.label}
                </button>
              ))}
            </div>

            <textarea
              value={message}
              onChange={e => { setMessage(e.target.value); setError(null) }}
              rows={5}
              maxLength={MAX_LENGTH}
              placeholder="What's on your mind?"
              className="w-full rounded-xl px-4 py-3 text-sm text-white placeholder:text-[#6b7280] resize-none focus:outline-none transition-colors"
              style={{ background: 'rgba(255,255,255,0.05)', border: '1px solid #2a2f5a' }}
              onFocus={e => { e.currentTarget.style.borderColor = '#4f46e5' }}
              onBlur={e => { e.currentTarget.style.borderColor = '#2a2f5a' }}
            />
            <p
              className="mt-1 text-right text-xs"
              style={{ color: message.length > 1800 ? '#f59e0b' : '#6b7280' }}
            >
              {message.length}/{MAX_LENGTH}
            </p>

            <button
              onClick={handleSubmit}
              disabled={sending || !message.trim()}
              className="mt-4 w-full py-3 rounded-[11px] text-sm font-bold text-white transition-transform hover:-translate-y-0.5 disabled:opacity-50 disabled:hover:translate-y-0"
              style={{ background: '#4f46e5', boxShadow: '0 8px 18px -6px #4f46e5' }}
            >
              {sending ? 'Sending…' : 'Send feedback'}
            </button>

            {error && (
              <p className="mt-4 text-center text-sm text-red-400">{error}</p>
            )}
          </>
        )}
      </div>
    </div>
  )
}
