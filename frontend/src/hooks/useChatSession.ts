import { useCallback, useEffect, useState } from 'react'
import type { ChatMessage } from '../types/api'
import { api } from '../lib/api'

export interface ChatSession {
  messages: ChatMessage[]
  loading: boolean
  error: string | null
  send: (text: string) => Promise<void>
}

export function useChatSession(questionId: string | undefined): ChatSession {
  const [messages, setMessages] = useState<ChatMessage[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    if (!questionId) {
      setMessages([])
      return
    }
    let cancelled = false
    setError(null)
    api.chat
      .history(questionId)
      .then((history) => {
        if (!cancelled) setMessages(history)
      })
      .catch((e: Error) => {
        if (!cancelled) setError(e.message)
      })
    return () => {
      cancelled = true
    }
  }, [questionId])

  const send = useCallback(
    async (text: string) => {
      const trimmed = text.trim()
      if (!trimmed || !questionId || loading) return

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
        const res = await api.chat.send(questionId, trimmed)
        setMessages(res.history)
      } catch (e) {
        setMessages(snapshot)
        setError((e as Error).message)
      } finally {
        setLoading(false)
      }
    },
    [questionId, messages, loading],
  )

  return { messages, loading, error, send }
}
