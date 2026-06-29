import { useState } from 'react'
import { Button } from '../ui/Button'
import { renderLatex } from '../../lib/renderLatex'

interface Props {
  // The LaTeX the AI read from the handwriting — seeds the editable textarea.
  initialLatex: string
  // Re-grade the (possibly edited) transcription. Rejects on failure so we can show it inline.
  onRegrade: (latex: string) => Promise<void>
}

// Shows the AI's transcription of the student's handwritten working as editable LaTeX, with a live
// preview. If the handwriting was mis-scanned the student fixes the text and re-grades that text.
export function TranscriptionEditor({ initialLatex, onRegrade }: Props) {
  const [text, setText] = useState(initialLatex)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const unchanged = text.trim() === initialLatex.trim()
  const empty = text.trim().length === 0

  async function handleRegrade() {
    if (empty || unchanged || loading) return
    setLoading(true)
    setError(null)
    try {
      await onRegrade(text)
    } catch (err) {
      setError((err as Error).message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="rounded-xl border border-blue-200 dark:border-blue-900 bg-blue-50/60 dark:bg-blue-950/30 p-4 flex flex-col gap-3">
      <div>
        <p className="font-semibold text-sm text-slate-800 dark:text-slate-100">
          What the AI read from your handwriting
        </p>
        <p className="text-xs text-slate-500 dark:text-slate-400 mt-0.5">
          Scanned wrong? Edit the LaTeX below and re-grade the corrected version.
        </p>
      </div>

      <textarea
        value={text}
        onChange={(e) => setText(e.target.value)}
        disabled={loading}
        rows={8}
        spellCheck={false}
        className="w-full rounded-lg border border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 p-3 font-mono text-sm text-slate-800 dark:text-slate-100 resize-y focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 disabled:opacity-60"
      />

      <div>
        <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-1">
          Preview
        </p>
        <div className="rounded-lg border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 p-3 text-sm text-slate-700 dark:text-slate-300 leading-relaxed min-h-[2.5rem]">
          {text.trim() ? renderLatex(text) : <span className="text-slate-400">Nothing to preview</span>}
        </div>
      </div>

      {error && <p className="text-sm text-red-500">{error}</p>}

      <div className="flex items-center gap-3">
        <Button onClick={handleRegrade} disabled={empty || unchanged} loading={loading}>
          Re-grade with corrections
        </Button>
        {unchanged && !empty && (
          <span className="text-xs text-slate-400">Edit the transcription to re-grade</span>
        )}
      </div>
    </div>
  )
}
