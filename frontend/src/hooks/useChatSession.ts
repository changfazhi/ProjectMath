import { useCallback, useEffect, useRef, useState } from 'react'
import type { ChatMessage } from '../types/api'
import { api, ApiError } from '../lib/api'

// Mirrors the backend's default AI_CHAT_COOLDOWN_S — used only for the instant local
// pre-check; the server remains the enforcer.
const CHAT_COOLDOWN_S = 5

export interface ChatError {
  message: string
  code?: string
  /** ISO timestamp — when the user may try again (AI_COOLDOWN / AI_DAILY_LIMIT). */
  resetAt?: string
}

export interface ChatSession {
  messages: ChatMessage[]
  loading: boolean
  error: ChatError | null
  send: (text: string) => Promise<void>
}

export function useChatSession(questionId: string | undefined): ChatSession {
  const [messages, setMessages] = useState<ChatMessage[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<ChatError | null>(null)
  // Set only on a successful send — a failed request clears the server-side cooldown,
  // so it shouldn't arm the local one either.
  const lastSentOkAt = useRef(0)
  // Current conversation scope — reminted every time this effect runs (mount, question
  // change, refresh, new tab/device), so the hint chat always starts empty. Nothing is
  // deleted server-side: past messages still count toward the daily quota and the
  // per-question hint cap, they just aren't shown or fed back to the AI as context.
  const threadId = useRef<string | null>(null)

  useEffect(() => {
    threadId.current = null
    if (!questionId) {
      setMessages([])
      return
    }
    let cancelled = false
    setError(null)
    setMessages([])
    api.chat
      .startThread(questionId)
      .then(({ thread_id }) => {
        if (!cancelled) threadId.current = thread_id
      })
      .catch((e: Error) => {
        if (!cancelled) setError({ message: e.message })
      })
    return () => {
      cancelled = true
    }
  }, [questionId])

  const send = useCallback(
    async (text: string) => {
      const trimmed = text.trim()
      if (!trimmed || !questionId || !threadId.current || loading) return

      // Instant local cooldown check — saves a round-trip; server enforces regardless.
      const sinceLast = (Date.now() - lastSentOkAt.current) / 1000
      if (sinceLast < CHAT_COOLDOWN_S) {
        const waitS = Math.ceil(CHAT_COOLDOWN_S - sinceLast)
        setError({
          message: `AI is on cooldown — try again in ${waitS} second${waitS === 1 ? '' : 's'}.`,
          code: 'AI_COOLDOWN',
          resetAt: new Date(lastSentOkAt.current + CHAT_COOLDOWN_S * 1000).toISOString(),
        })
        return
      }

      const optimistic: ChatMessage = {
        id: `temp-${Date.now()}`,
        role: 'user',
        content: trimmed,
        created_at: new Date().toISOString(),
      }
      const snapshot = messages
      setMessages([...messages, optimistic])
      setLoading(true)
      setError(null)

      try {
        const res = await api.chat.send(questionId, threadId.current, trimmed)
        lastSentOkAt.current = Date.now()
        setMessages(res.history)
      } catch (e) {
        setMessages(snapshot)
        if (e instanceof ApiError) {
          setError({ message: e.message, code: e.code, resetAt: e.resetAt })
        } else {
          setError({ message: (e as Error).message })
        }
      } finally {
        setLoading(false)
      }
    },
    [questionId, messages, loading],
  )

  return { messages, loading, error, send }
}
