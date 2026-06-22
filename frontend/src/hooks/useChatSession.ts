import { useCallback, useEffect, useState } from 'react'
import type { ChatMessage } from '../types/api'
import { api } from '../lib/api'
import { getSessionId } from '../lib/session'

export interface ChatSession {
  messages: ChatMessage[]
  loading: boolean
  error: string | null
  send: (text: string) => Promise<void>
}

export function useChatSession(questionId: string | undefined): ChatSession {
  const sessionId = getSessionId()
  const [messages, setMessages] = useState<ChatMessage[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  // Rehydrate persisted history whenever the question changes.
  useEffect(() => {
    if (!questionId) {
      setMessages([])
      return
    }
    let cancelled = false
    setError(null)
    api.chat
      .history(sessionId, questionId)
      .then((history) => {
        if (!cancelled) setMessages(history)
      })
      .catch((e: Error) => {
        if (!cancelled) setError(e.message)
      })
    return () => {
      cancelled = true
    }
  }, [questionId, sessionId])

  const send = useCallback(
    async (text: string) => {
      const trimmed = text.trim()
      if (!trimmed || !questionId || loading) return

      // Optimistically append the user's message.
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
        const res = await api.chat.send(sessionId, questionId, trimmed)
        setMessages(res.history)
      } catch (e) {
        setMessages(snapshot) // roll back on failure
        setError((e as Error).message)
      } finally {
        setLoading(false)
      }
    },
    [questionId, sessionId, messages, loading],
  )

  return { messages, loading, error, send }
}
