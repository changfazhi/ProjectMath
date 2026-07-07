import { QRCodeSVG } from 'qrcode.react'
import { Button } from '../ui/Button'
import { Spinner } from '../ui/Spinner'
import { useSlowLoad } from '../../hooks/useCountdown'
import type { PairSocketState } from '../../hooks/usePairSocket'

interface Props {
  mobilePath: string
  pair: PairSocketState
  onClose: () => void
}

export function QrPairModal({ mobilePath, pair, onClose }: Props) {
  const url = `${window.location.origin}${mobilePath}`

  // Grading may be held through the per-user cooldown server-side — reassure after a while.
  const slowGrading = useSlowLoad(pair.grading)

  let status: string
  if (pair.error) status = pair.error
  else if (pair.grading)
    status = slowGrading ? 'AI is thinking — busy period, hang tight…' : 'Grading your solution…'
  else if (pair.images.length > 0)
    status = `${pair.images.length} photo${pair.images.length > 1 ? 's' : ''} received — tap Done on your phone when finished.`
  else if (pair.phoneConnected) status = 'Phone connected — take your photos.'
  else status = 'Scan the QR code with your phone to begin.'

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4" onClick={onClose}>
      <div
        className="w-full max-w-md rounded-2xl bg-white dark:bg-slate-900 p-6 shadow-xl flex flex-col items-center gap-5"
        onClick={(e) => e.stopPropagation()}
      >
        <div className="text-center">
          <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-100">Upload via phone</h2>
          <p className="text-sm text-slate-500 dark:text-slate-400 mt-1">
            Scan this code, snap your handwritten working, and it appears here automatically.
          </p>
        </div>

        {/* QR stays visible so the student can add more photos until they finish */}
        <div className="rounded-xl bg-white p-4 border border-slate-200">
          <QRCodeSVG value={url} size={196} />
        </div>

        <div className="flex items-center gap-2 text-sm text-center min-h-[1.5rem]">
          {pair.grading && <Spinner size="sm" />}
          <span className={pair.error ? 'text-red-500' : 'text-slate-600 dark:text-slate-300'}>{status}</span>
        </div>

        {pair.images.length > 0 && (
          <div className="grid grid-cols-4 gap-2 w-full">
            {pair.images.map((src, i) => (
              <img
                key={i}
                src={src}
                alt={`Received photo ${i + 1}`}
                className="w-full h-16 object-cover rounded-lg border border-slate-200 dark:border-slate-700"
              />
            ))}
          </div>
        )}

        <Button variant="secondary" onClick={onClose} className="w-full">
          {pair.grading ? 'Hide' : 'Cancel'}
        </Button>
      </div>
    </div>
  )
}
