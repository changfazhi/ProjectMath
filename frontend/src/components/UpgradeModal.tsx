interface Props {
  onClose: () => void
}

export function UpgradeModal({ onClose }: Props) {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
      <div className="bg-white dark:bg-slate-900 rounded-2xl shadow-xl w-full max-w-sm p-6">
        <div className="text-center space-y-3">
          <div className="text-3xl">✨</div>
          <h2 className="text-xl font-bold text-slate-900 dark:text-slate-100">
            Premium Feature
          </h2>
          <p className="text-sm text-slate-600 dark:text-slate-400">
            This feature requires a subscription. Premium plans are coming soon!
          </p>
        </div>
        <button
          onClick={onClose}
          className="mt-6 w-full px-4 py-2 rounded-lg bg-blue-600 text-white font-medium hover:bg-blue-700 transition-colors"
        >
          Got it
        </button>
      </div>
    </div>
  )
}
