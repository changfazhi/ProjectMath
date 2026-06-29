import { useMemo, useRef, useState } from 'react'
import { Button } from '../ui/Button'
import { MathField, type MathFieldHandle } from '../math/MathField'
import { MathKeyboard } from '../math/MathKeyboard'
import { cn } from '../../lib/utils'

interface Props {
  // The LaTeX the AI read from the handwriting — seeds the editable line fields.
  initialLatex: string
  // Re-grade the (possibly edited) transcription. Rejects on failure so we can show it inline.
  onRegrade: (latex: string) => Promise<void>
}

// Split the AI transcription into individual working steps. New gradings arrive as pure math-mode
// LaTeX with `\\` between steps (see buildGradingInstruction); this also unwraps any delimiters or
// array/aligned environment a reloaded/older transcription might carry, so every step becomes a plain
// math string we can drop into its own MathField (top-level math, where fractions edit cleanly —
// editing a fraction *inside* a math environment triggers MathLive's white edit box).
function toLines(initialLatex: string): string[] {
  const stripped = initialLatex
    .replace(/\\\[/g, '')
    .replace(/\\\]/g, '')
    .replace(/\\\(/g, '')
    .replace(/\\\)/g, '')
    .replace(/\\begin\{array\}\{[^}]*\}/g, '')
    .replace(/\\begin\{[^}]*\}/g, '')
    .replace(/\\end\{[^}]*\}/g, '')
    .trim()
  const lines = stripped
    .split(/\s*(?:\\\\|\n)+\s*/)
    .map((l) => l.trim())
    .filter(Boolean)
  return lines.length > 0 ? lines : ['']
}

interface Line {
  id: number
  seed: string // initial LaTeX, used to seed the MathField once
  value: string // current LaTeX (updated on edit, for change/empty detection)
}

export function TranscriptionEditor({ initialLatex, onRegrade }: Props) {
  const seedLines = useMemo(() => toLines(initialLatex), [initialLatex])
  const seedJoined = useMemo(() => seedLines.join('\n').trim(), [seedLines])

  const [lines, setLines] = useState<Line[]>(() =>
    seedLines.map((seed, i) => ({ id: i, seed, value: seed })),
  )
  const nextId = useRef(seedLines.length)
  const refs = useRef<Record<number, MathFieldHandle | null>>({})
  const [activeId, setActiveId] = useState<number | null>(seedLines.length > 0 ? 0 : null)

  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [showSymbols, setShowSymbols] = useState(false)

  // Authoritative current LaTeX, read straight from the fields.
  function readLatex(): string {
    return lines
      .map((l) => (refs.current[l.id]?.getValue() ?? l.value).trim())
      .filter(Boolean)
      .join(' \\\\ ')
  }

  const currentJoined = lines.map((l) => l.value.trim()).filter(Boolean).join('\n').trim()
  const unchanged = currentJoined === seedJoined
  const empty = currentJoined.length === 0

  function setValue(id: number, value: string) {
    setLines((prev) => prev.map((l) => (l.id === id ? { ...l, value } : l)))
  }

  function addLine() {
    const id = nextId.current++
    setLines((prev) => [...prev, { id, seed: '', value: '' }])
    setActiveId(id)
    setTimeout(() => refs.current[id]?.focus(), 50)
  }

  function removeLine(id: number) {
    setLines((prev) => (prev.length <= 1 ? prev : prev.filter((l) => l.id !== id)))
    delete refs.current[id]
  }

  async function handleRegrade() {
    const value = readLatex()
    if (!value || unchanged || loading) return
    setLoading(true)
    setError(null)
    try {
      await onRegrade(value)
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
          Scanned wrong? Fix any line below — one step per line, like working on paper — and re-grade.
        </p>
      </div>

      <div className="flex flex-col gap-2">
        {lines.map((line, i) => (
          <div key={line.id} className="flex items-center gap-2" onFocus={() => setActiveId(line.id)}>
            <span className="w-5 shrink-0 text-right text-xs text-slate-400 dark:text-slate-500">
              {i + 1}
            </span>
            <MathField
              ref={(h) => {
                refs.current[line.id] = h
              }}
              initialValue={line.seed}
              onChange={(v) => setValue(line.id, v)}
              disabled={loading}
              className={cn(
                'flex-1 border-slate-300 dark:border-slate-700 bg-white dark:bg-slate-900 text-slate-900 dark:text-slate-100',
                activeId === line.id && 'ring-2 ring-blue-500',
              )}
            />
            <button
              type="button"
              title="Remove line"
              onClick={() => removeLine(line.id)}
              disabled={loading || lines.length <= 1}
              className="shrink-0 w-7 h-7 inline-flex items-center justify-center rounded-lg border border-slate-300 dark:border-slate-700 text-slate-400 hover:text-red-500 hover:border-red-400 disabled:opacity-40 disabled:cursor-not-allowed"
            >
              ×
            </button>
          </div>
        ))}
      </div>

      <div className="flex flex-wrap items-center gap-3">
        <button
          type="button"
          onClick={addLine}
          disabled={loading}
          className="text-xs font-semibold text-blue-700 dark:text-blue-300 hover:text-blue-900 dark:hover:text-blue-100 disabled:opacity-50"
        >
          + Add line
        </button>
        <button
          type="button"
          onClick={() => {
            setShowSymbols((v) => !v)
            if (!showSymbols && activeId !== null) setTimeout(() => refs.current[activeId]?.focus(), 50)
          }}
          disabled={loading}
          className="inline-flex items-center gap-1.5 text-xs font-semibold text-blue-700 dark:text-blue-300 hover:text-blue-900 dark:hover:text-blue-100 disabled:opacity-50"
        >
          <span className="text-sm leading-none">∑</span>
          Math symbols
          <span className="text-[10px]">{showSymbols ? '▲' : '▼'}</span>
        </button>
      </div>

      {showSymbols && !loading && (
        <MathKeyboard onInsert={(latex) => activeId !== null && refs.current[activeId]?.insert(latex)} />
      )}

      {error && <p className="text-sm text-red-500">{error}</p>}

      <div className="flex items-center gap-3">
        <Button onClick={handleRegrade} disabled={empty || unchanged} loading={loading}>
          Re-grade with corrections
        </Button>
        {unchanged && !empty && (
          <span className="text-xs text-slate-400">Edit a line to re-grade</span>
        )}
      </div>
    </div>
  )
}
