import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { api } from '../lib/api'
import { Badge } from '../components/ui/Badge'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'
import { formatTime } from '../lib/utils'
import type { StarredQuestionRow } from '../types/api'

function StarIcon({ filled }: { filled: boolean }) {
  return (
    <svg
      className="w-5 h-5"
      viewBox="0 0 24 24"
      fill={filled ? 'currentColor' : 'none'}
      stroke="currentColor"
      strokeWidth={1.8}
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M11.48 3.499a.562.562 0 011.04 0l2.125 5.111a.563.563 0 00.475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 00-.182.557l1.285 5.385a.562.562 0 01-.84.61l-4.725-2.885a.563.563 0 00-.586 0L6.982 20.54a.562.562 0 01-.84-.61l1.285-5.386a.562.562 0 00-.182-.557l-4.204-3.602a.562.562 0 01.321-.988l5.518-.442a.563.563 0 00.475-.345L11.48 3.5z"
      />
    </svg>
  )
}

export function StarredPage() {
  const navigate = useNavigate()

  const [rows, setRows] = useState<StarredQuestionRow[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [unstarred, setUnstarred] = useState<Set<string>>(new Set())

  useEffect(() => {
    api.stars
      .listAll()
      .then(setRows)
      .catch((e: Error) => setError(e.message))
      .finally(() => setLoading(false))
  }, [])

  function handleUnstar(questionId: string) {
    setUnstarred((prev) => new Set(prev).add(questionId))
    api.stars.toggle(questionId).catch(() => {
      // revert visual if the call fails
      setUnstarred((prev) => {
        const next = new Set(prev)
        next.delete(questionId)
        return next
      })
    })
  }

  function handleRowClick(topicId: string, questionId: string) {
    navigate(`/practice/${topicId}?question_id=${questionId}`)
  }

  return (
    <div className="max-w-4xl mx-auto px-4 py-10 flex flex-col gap-6">
      <h1 className="text-2xl font-bold text-slate-900 dark:text-slate-100 tracking-tight">
        Starred Questions
      </h1>

      {loading && (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      )}

      {error && <ErrorMessage message={error} onRetry={() => window.location.reload()} />}

      {!loading && !error && rows.length === 0 && (
        <p className="text-slate-500 dark:text-slate-400 text-center py-12">
          No starred questions yet.
        </p>
      )}

      {!loading && !error && rows.length > 0 && (
        <div className="rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 overflow-hidden">
          <table className="w-full text-left">
            <thead className="bg-slate-50 dark:bg-slate-800/60 text-xs uppercase tracking-wider text-slate-500 dark:text-slate-400">
              <tr>
                <th className="py-3 px-4 w-10"></th>
                <th className="py-3 px-4">Question</th>
                <th className="py-3 px-4">Topic</th>
                <th className="py-3 px-4">Latest Attempt</th>
                <th className="py-3 px-4">Result</th>
                <th className="py-3 px-4">Time</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row) => {
                const isUnstarred = unstarred.has(row.question_id)
                const attempt = row.latest_attempt
                const date = attempt ? new Date(attempt.attempted_at) : null

                return (
                  <tr
                    key={row.question_id}
                    className="border-b border-slate-100 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors cursor-pointer"
                  >
                    {/* Star toggle — stops row click propagation */}
                    <td
                      className="py-3 px-4"
                      onClick={(e) => e.stopPropagation()}
                    >
                      <button
                        onClick={() => handleUnstar(row.question_id)}
                        disabled={isUnstarred}
                        className={`transition-colors ${
                          isUnstarred
                            ? 'text-slate-300 dark:text-slate-600 cursor-default'
                            : 'text-amber-400 hover:text-amber-500'
                        }`}
                        aria-label={isUnstarred ? 'Unstarred' : 'Unstar question'}
                      >
                        <StarIcon filled={!isUnstarred} />
                      </button>
                    </td>

                    {/* Question name — clicking navigates */}
                    <td
                      className="py-3 px-4 text-sm font-medium text-slate-800 dark:text-slate-200 max-w-[200px] truncate"
                      onClick={() => handleRowClick(row.topic_id, row.question_id)}
                    >
                      {row.question_name ?? row.question_id.slice(0, 8) + '…'}
                    </td>

                    <td
                      className="py-3 px-4 text-sm text-slate-600 dark:text-slate-400"
                      onClick={() => handleRowClick(row.topic_id, row.question_id)}
                    >
                      {row.topic_name}
                    </td>

                    <td
                      className="py-3 px-4 text-sm text-slate-600 dark:text-slate-400 whitespace-nowrap"
                      onClick={() => handleRowClick(row.topic_id, row.question_id)}
                    >
                      {date
                        ? `${date.toLocaleDateString()} ${date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`
                        : '—'}
                    </td>

                    <td
                      className="py-3 px-4"
                      onClick={() => handleRowClick(row.topic_id, row.question_id)}
                    >
                      {attempt ? (
                        <Badge variant={attempt.is_correct ? 'success' : 'danger'}>
                          {attempt.is_correct ? 'Correct' : 'Incorrect'}
                        </Badge>
                      ) : (
                        <span className="text-sm text-slate-400">—</span>
                      )}
                    </td>

                    <td
                      className="py-3 px-4 text-sm text-slate-500 dark:text-slate-400"
                      onClick={() => handleRowClick(row.topic_id, row.question_id)}
                    >
                      {attempt?.time_taken_s != null ? formatTime(attempt.time_taken_s) : '—'}
                    </td>
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}

      {!loading && !error && (
        <p className="text-sm text-slate-400 dark:text-slate-500 text-center">
          Star questions to come back and review later
        </p>
      )}
    </div>
  )
}
