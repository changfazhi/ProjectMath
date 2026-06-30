import { useEffect, useRef, useState } from 'react'
import type { ChatSession } from '../../hooks/useChatSession'
import { renderLatex } from '../../lib/renderLatex'
import { cn } from '../../lib/utils'
import { Spinner } from '../ui/Spinner'

interface Props {
  chat: ChatSession
  className?: string
}

export function ChatPanel({ chat, className }: Props) {
  const { messages, loading, error, send } = chat
  const [input, setInput] = useState('')
  const scrollRef = useRef<HTMLDivElement>(null)

  // Keep the latest message in view.
  useEffect(() => {
    scrollRef.current?.scrollTo({ top: scrollRef.current.scrollHeight, behavior: 'smooth' })
  }, [messages, loading])

  function handleSend() {
    const text = input.trim()
    if (!text || loading) return
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
          <div className="self-start rounded-2xl rounded-bl-sm bg-slate-100 dark:bg-slate-800 px-3 py-2">
            <Spinner size="sm" />
          </div>
        )}
      </div>

      {/* Error */}
      {error && (
        <p className="px-4 pb-2 text-xs text-red-500">{error}</p>
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
          disabled={loading || !input.trim()}
          className="shrink-0 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 text-sm font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Send
        </button>
      </div>
    </div>
  )
}
