import { useEffect, useRef, useState } from 'react'
import type { ChatSession } from '../../hooks/useChatSession'
import { renderLatex } from '../../lib/renderLatex'
import { cn } from '../../lib/utils'
import { Spinner } from '../ui/Spinner'

interface Props {
  chat: ChatSession
  className?: string
  /** e.g. "7/10 free messages left today" — rendered above the input for free users. */
  quotaNote?: string | null
  /** Disable sending (daily quota exhausted); pair with onUpgrade for the CTA. */
  sendDisabled?: boolean
  onUpgrade?: () => void
}

// Live seconds remaining until an ISO timestamp — drives the cooldown countdown.
function useCountdown(resetAt?: string): number {
  const [remaining, setRemaining] = useState(0)
  useEffect(() => {
    if (!resetAt) {
      setRemaining(0)
      return
    }
    const target = new Date(resetAt).getTime()
    const tick = () => setRemaining(Math.max(0, Math.ceil((target - Date.now()) / 1000)))
    tick()
    const id = setInterval(tick, 500)
    return () => clearInterval(id)
  }, [resetAt])
  return remaining
}

export function ChatPanel({ chat, className, quotaNote, sendDisabled, onUpgrade }: Props) {
  const { messages, loading, error, send } = chat
  const [input, setInput] = useState('')
  const scrollRef = useRef<HTMLDivElement>(null)

  const isCooldown = error?.code === 'AI_COOLDOWN'
  const cooldownS = useCountdown(isCooldown ? error?.resetAt : undefined)

  // After a few seconds of waiting, reassure the user (the request may be queued
  // behind other students during busy periods).
  const [slowLoad, setSlowLoad] = useState(false)
  useEffect(() => {
    if (!loading) {
      setSlowLoad(false)
      return
    }
    const id = setTimeout(() => setSlowLoad(true), 4000)
    return () => clearTimeout(id)
  }, [loading])

  // Keep the latest message in view.
  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: 'smooth' })
  }, [messages, loading])

  function handleSend() {
    const text = input.trim()
    if (!text || loading || sendDisabled) return
    setInput('')
    void send(text)
  }

  function handleKeyDown(e: React.KeyboardEvent<HTMLTextAreaElement>) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSend()
    }
  }

  return (
    <div
      className={cn(
        'flex flex-col rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 overflow-hidden',
        className,
      )}
    >
      {/* Header */}
      <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-800 flex items-center gap-2.5">
        <span
          className="flex-none flex items-center justify-center rounded-[9px] text-white text-[15px]"
          style={{ width: 30, height: 30, background: 'linear-gradient(135deg,#4f46e5,#7c3aed)' }}
        >
          ✦
        </span>
        <h3 className="font-semibold text-slate-900 dark:text-slate-100">AI Tutor</h3>
      </div>

      {/* Messages */}
      <div ref={scrollRef} className="flex-1 overflow-y-auto p-4 flex flex-col gap-3 min-h-[16rem]">
        {messages.length === 0 && !loading && (
          <div className="flex-1 flex flex-col items-center justify-center text-center text-sm text-slate-400 dark:text-slate-500 py-8">
            <p>Stuck? I'll guide you step by step — I won't give the final answer.</p>
            <p className="text-xs mt-1">e.g. "How do I start part (a)?"</p>
          </div>
        )}

        {messages.map((m) => (
          <div
            key={m.id}
            className={cn(
              'max-w-[85%] px-3 py-2 text-sm leading-relaxed',
              m.role === 'user'
                ? 'self-end rounded-2xl rounded-br-sm bg-indigo-600 text-white'
                : 'self-start rounded-2xl rounded-bl-sm bg-slate-100 dark:bg-slate-800 text-slate-800 dark:text-slate-100',
            )}
          >
            {m.role === 'model' ? (
              <div className="[&_.katex-display]:my-1 whitespace-pre-wrap">
                {renderLatex(m.content)}
              </div>
            ) : (
              <span className="whitespace-pre-wrap">{m.content}</span>
            )}
          </div>
        ))}

        {loading && (
          <div className="self-start rounded-2xl rounded-bl-sm bg-slate-100 dark:bg-slate-800 px-3 py-2 flex items-center gap-2">
            <Spinner size="sm" />
            {slowLoad && (
              <span className="text-xs text-slate-500 dark:text-slate-400">
                AI is thinking — busy period, hang tight…
              </span>
            )}
          </div>
        )}
      </div>

      {/* Error — cooldowns get a live countdown that clears itself at zero. */}
      {error &&
        (isCooldown ? (
          cooldownS > 0 && (
            <p className="px-4 pb-2 text-xs text-amber-600 dark:text-amber-400">
              AI is on cooldown — try again in {cooldownS} second{cooldownS === 1 ? '' : 's'}.
            </p>
          )
        ) : (
          <p className="px-4 pb-2 text-xs text-red-500">{error.message}</p>
        ))}

      {/* Daily quota */}
      {sendDisabled ? (
        <p className="px-4 pb-2 text-xs text-amber-600 dark:text-amber-400">
          You've used all your free hints for today — resets at midnight.{' '}
          {onUpgrade && (
            <button onClick={onUpgrade} className="underline underline-offset-2 font-semibold">
              Upgrade for unlimited
            </button>
          )}
        </p>
      ) : (
        quotaNote && <p className="px-4 pb-2 text-xs text-slate-400 dark:text-slate-500">{quotaNote}</p>
      )}

      {/* Input */}
      <div className="border-t border-slate-200 dark:border-slate-800 p-3 flex items-end gap-2">
        <textarea
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={handleKeyDown}
          rows={1}
          placeholder="Ask a follow-up…"
          className="flex-1 resize-none rounded-xl border border-slate-300 dark:border-slate-700 bg-transparent px-3 py-2 text-sm text-slate-900 dark:text-slate-100 placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 max-h-32"
        />
        <button
          onClick={handleSend}
          disabled={loading || !input.trim() || sendDisabled}
          className="shrink-0 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 text-sm font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Send
        </button>
      </div>
    </div>
  )
}
