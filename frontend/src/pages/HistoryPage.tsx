import { getSessionId } from '../lib/session'
import { useAttemptHistory } from '../hooks/useAttemptHistory'
import { AttemptRow } from '../components/progress/AttemptRow'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'

export function HistoryPage() {
  const sessionId = getSessionId()
  const { attempts, loading, error, refetch } = useAttemptHistory(sessionId)

  const total = attempts.length
  const correct = attempts.filter((a) => a.is_correct).length
  const pct = total > 0 ? Math.round((correct / total) * 100) : 0

  return (
    <div className="max-w-4xl mx-auto px-4 py-10 flex flex-col gap-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100 tracking-tight">
          Practice History
        </h1>
        <p className="mt-1 text-xs text-slate-400 dark:text-slate-500 font-mono">
          Session: {sessionId.slice(0, 8)}…
        </p>
      </div>

      {!loading && !error && total > 0 && (
        <div className="flex gap-6 flex-wrap">
          <div className="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-5 py-3">
            <p className="text-xs text-slate-500 dark:text-slate-400">Attempted</p>
            <p className="text-2xl font-bold text-slate-900 dark:text-slate-100">{total}</p>
          </div>
          <div className="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-5 py-3">
            <p className="text-xs text-slate-500 dark:text-slate-400">Correct</p>
            <p className="text-2xl font-bold text-green-600 dark:text-green-400">{correct}</p>
          </div>
          <div className="rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 px-5 py-3">
            <p className="text-xs text-slate-500 dark:text-slate-400">Accuracy</p>
            <p className="text-2xl font-bold text-blue-600 dark:text-blue-400">{pct}%</p>
          </div>
        </div>
      )}

      {loading && (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      )}
      {error && <ErrorMessage message={error} onRetry={refetch} />}

      {!loading && !error && attempts.length === 0 && (
        <p className="text-slate-500 dark:text-slate-400 text-center py-12">
          No attempts yet. Start practising to see your history here.
        </p>
      )}

      {!loading && !error && attempts.length > 0 && (
        <div className="rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 overflow-hidden">
          <table className="w-full text-left">
            <thead className="bg-slate-50 dark:bg-slate-800/60 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3 px-4">Date</th>
                <th className="py-3 px-4">Question</th>
                <th className="py-3 px-4">Your Answer</th>
                <th className="py-3 px-4">Result</th>
                <th className="py-3 px-4">Time</th>
              </tr>
            </thead>
            <tbody>
              {attempts.map((a) => (
                <AttemptRow key={a.id} attempt={a} />
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  )
}
