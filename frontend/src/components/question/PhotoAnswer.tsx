import { useEffect, useRef, useState } from 'react'
import { Button } from '../ui/Button'
import { cn } from '../../lib/utils'

interface Props {
  onSubmit: (images: File[]) => void
  disabled: boolean
  loading: boolean
  maxImages?: number
}

interface Preview {
  file: File
  url: string
}

export function PhotoAnswer({ onSubmit, disabled, loading, maxImages = 5 }: Props) {
  const [previews, setPreviews] = useState<Preview[]>([])
  const [localError, setLocalError] = useState<string | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  // Revoke object URLs on unmount to avoid leaks.
  useEffect(() => {
    return () => previews.forEach((p) => URL.revokeObjectURL(p.url))
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  function addFiles(files: FileList | null) {
    if (!files || files.length === 0) return
    setLocalError(null)
    const incoming = Array.from(files).filter((f) => f.type.startsWith('image/'))
    setPreviews((prev) => {
      const room = maxImages - prev.length
      if (room <= 0) {
        setLocalError(`You can attach at most ${maxImages} photos.`)
        return prev
      }
      const next = incoming.slice(0, room).map((file) => ({ file, url: URL.createObjectURL(file) }))
      if (incoming.length > room) setLocalError(`Only the first ${maxImages} photos were added.`)
      return [...prev, ...next]
    })
  }

  function removeAt(idx: number) {
    setPreviews((prev) => {
      const target = prev[idx]
      if (target) URL.revokeObjectURL(target.url)
      return prev.filter((_, i) => i !== idx)
    })
  }

  function handleSubmit() {
    if (previews.length === 0) {
      setLocalError('Add at least one photo of your handwritten solution.')
      return
    }
    onSubmit(previews.map((p) => p.file))
  }

  return (
    <div className="flex flex-col gap-4">
      <div
        onDragOver={(e) => e.preventDefault()}
        onDrop={(e) => {
          e.preventDefault()
          if (!disabled) addFiles(e.dataTransfer.files)
        }}
        className={cn(
          'rounded-2xl border-2 border-dashed p-6 text-center transition-colors',
          'border-slate-300 dark:border-slate-700 bg-slate-50 dark:bg-slate-800/40',
        )}
      >
        <p className="text-sm text-slate-600 dark:text-slate-300 mb-3">
          Snap or upload a photo of your handwritten working — the AI will mark it against the model
          solution.
        </p>
        <div className="flex gap-2 justify-center flex-wrap">
          {/* Mobile: capture opens the camera. Desktop: file picker. */}
          <input
            ref={inputRef}
            type="file"
            accept="image/*"
            capture="environment"
            multiple
            className="hidden"
            onChange={(e) => {
              addFiles(e.target.files)
              e.target.value = ''
            }}
          />
          <Button
            type="button"
            variant="secondary"
            onClick={() => inputRef.current?.click()}
            disabled={disabled || previews.length >= maxImages}
          >
            + Add photo
          </Button>
        </div>
      </div>

      {previews.length > 0 && (
        <div className="grid grid-cols-3 sm:grid-cols-4 gap-3">
          {previews.map((p, i) => (
            <div key={p.url} className="relative group">
              <img
                src={p.url}
                alt={`Solution photo ${i + 1}`}
                className="w-full h-24 object-cover rounded-lg border border-slate-200 dark:border-slate-700"
              />
              {!disabled && (
                <button
                  type="button"
                  onClick={() => removeAt(i)}
                  className="absolute -top-2 -right-2 w-6 h-6 rounded-full bg-slate-800 text-white text-xs flex items-center justify-center shadow hover:bg-red-600"
                  aria-label="Remove photo"
                >
                  ✕
                </button>
              )}
            </div>
          ))}
        </div>
      )}

      {localError && <p className="text-sm text-red-500">{localError}</p>}

      <div>
        <Button onClick={handleSubmit} loading={loading} disabled={disabled || previews.length === 0} size="lg">
          {loading ? 'Grading…' : 'Submit for grading'}
        </Button>
      </div>
    </div>
  )
}
