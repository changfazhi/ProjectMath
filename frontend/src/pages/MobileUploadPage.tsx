import { useEffect, useRef, useState } from 'react'
import { useParams } from 'react-router-dom'
import { api } from '../lib/api'
import { Button } from '../components/ui/Button'
import { Spinner } from '../components/ui/Spinner'

type Phase = 'checking' | 'invalid' | 'ready' | 'done'

export function MobileUploadPage() {
  const { token } = useParams<{ token: string }>()
  const [phase, setPhase] = useState<Phase>('checking')
  const [questionName, setQuestionName] = useState<string | null>(null)
  const [thumbs, setThumbs] = useState<string[]>([])
  const [uploading, setUploading] = useState(false)
  const [finishing, setFinishing] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const inputRef = useRef<HTMLInputElement>(null)

  useEffect(() => {
    if (!token) {
      setPhase('invalid')
      return
    }
    let cancelled = false
    api.pair
      .context(token)
      .then((ctx) => {
        if (cancelled) return
        if (ctx.valid) {
          setQuestionName(ctx.question_name)
          setPhase('ready')
        } else {
          setPhase('invalid')
        }
      })
      .catch(() => !cancelled && setPhase('invalid'))
    return () => {
      cancelled = true
    }
  }, [token])

  async function handleFile(file: File | undefined) {
    if (!file || !token) return
    setError(null)
    setUploading(true)
    const localUrl = URL.createObjectURL(file)
    try {
      await api.pair.uploadPhoto(token, file)
      setThumbs((prev) => [...prev, localUrl])
    } catch (e) {
      URL.revokeObjectURL(localUrl)
      setError((e as Error).message)
    } finally {
      setUploading(false)
    }
  }

  async function handleDone() {
    if (!token) return
    setError(null)
    setFinishing(true)
    try {
      await api.pair.done(token)
      setPhase('done')
    } catch (e) {
      setError((e as Error).message)
      setFinishing(false)
    }
  }

  return (
    <div className="min-h-screen bg-slate-50 dark:bg-slate-950 flex flex-col items-center justify-center px-6 py-10">
      <div className="w-full max-w-sm flex flex-col items-center gap-6 text-center">
        {phase === 'checking' && <Spinner size="lg" />}

        {phase === 'invalid' && (
          <>
            <div className="text-5xl">⌛</div>
            <h1 className="text-xl font-semibold text-slate-900 dark:text-slate-100">Link expired</h1>
            <p className="text-slate-500 dark:text-slate-400 text-sm">
              This upload link is no longer valid. Go back to your computer and tap
              “Upload via phone” again for a fresh QR code.
            </p>
          </>
        )}

        {phase === 'done' && (
          <>
            <div className="text-5xl">✅</div>
            <h1 className="text-xl font-semibold text-slate-900 dark:text-slate-100">Sent!</h1>
            <p className="text-slate-500 dark:text-slate-400 text-sm">
              Your {thumbs.length} photo{thumbs.length === 1 ? '' : 's'} {thumbs.length === 1 ? 'is' : 'are'} being
              graded on your computer. You can close this page.
            </p>
          </>
        )}

        {phase === 'ready' && (
          <>
            <h1 className="text-xl font-semibold text-slate-900 dark:text-slate-100">
              Photograph your solution
            </h1>
            {questionName && (
              <p className="text-sm text-slate-500 dark:text-slate-400 -mt-3">{questionName}</p>
            )}

            <input
              ref={inputRef}
              type="file"
              accept="image/*"
              capture="environment"
              className="hidden"
              onChange={(e) => {
                handleFile(e.target.files?.[0])
                e.target.value = ''
              }}
            />

            <Button
              size="lg"
              className="w-full justify-center text-lg py-4"
              loading={uploading}
              onClick={() => inputRef.current?.click()}
            >
              {thumbs.length === 0 ? '📷 Take photo' : '📷 Add another'}
            </Button>

            {thumbs.length > 0 && (
              <div className="grid grid-cols-3 gap-2 w-full">
                {thumbs.map((src, i) => (
                  <img
                    key={i}
                    src={src}
                    alt={`Photo ${i + 1}`}
                    className="w-full h-24 object-cover rounded-lg border border-slate-200 dark:border-slate-700"
                  />
                ))}
              </div>
            )}

            {thumbs.length > 0 && (
              <Button
                variant="secondary"
                size="lg"
                className="w-full justify-center"
                loading={finishing}
                disabled={uploading}
                onClick={handleDone}
              >
                Done — grade {thumbs.length} photo{thumbs.length === 1 ? '' : 's'}
              </Button>
            )}

            {error && <p className="text-sm text-red-500">{error}</p>}
            <p className="text-xs text-slate-400 dark:text-slate-500">
              Each photo appears on your computer as you take it.
            </p>
          </>
        )}
      </div>
    </div>
  )
}
