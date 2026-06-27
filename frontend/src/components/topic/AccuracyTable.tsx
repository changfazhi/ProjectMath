import { useEffect, useState } from 'react'
import { api } from '../../lib/api'
import { ProgressBar } from '../ui/ProgressBar'
import { Spinner } from '../ui/Spinner'
import type { TopicAccuracy } from '../../types/api'

type SortKey = 'solved' | 'accuracy'
type SortDir = 'asc' | 'desc'

function SortIcon({ active, dir }: { active: boolean; dir: SortDir }) {
  return (
    <span className={`ml-1 inline-flex flex-col leading-none text-[10px] select-none ${active ? 'text-blue-500' : 'text-slate-400 dark:text-slate-500'}`}>
      <span className={active && dir === 'asc' ? 'text-blue-500' : ''}>▲</span>
      <span className={active && dir === 'desc' ? 'text-blue-500' : ''}>▼</span>
    </span>
  )
}

function sortRows(rows: TopicAccuracy[], key: SortKey | null, dir: SortDir): TopicAccuracy[] {
  if (!key) return rows

  return [...rows].sort((a, b) => {
    // Rows with no attempts always go to the bottom
    if (key === 'accuracy') {
      const aUnattempted = a.total_attempts === 0
      const bUnattempted = b.total_attempts === 0
      if (aUnattempted && bUnattempted) return 0
      if (aUnattempted) return 1
      if (bUnattempted) return -1
      const aAcc = a.correct_attempts / a.total_attempts
      const bAcc = b.correct_attempts / b.total_attempts
      return dir === 'asc' ? aAcc - bAcc : bAcc - aAcc
    }

    // solved: sort by questions_solved count; rows with 0 solved go to bottom
    const aUnsolved = a.questions_solved === 0
    const bUnsolved = b.questions_solved === 0
    if (aUnsolved && bUnsolved) return 0
    if (aUnsolved) return 1
    if (bUnsolved) return -1
    return dir === 'asc'
      ? a.questions_solved - b.questions_solved
      : b.questions_solved - a.questions_solved
  })
}

export function AccuracyTable() {
  const [rows, setRows] = useState<TopicAccuracy[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [sortKey, setSortKey] = useState<SortKey | null>(null)
  const [sortDir, setSortDir] = useState<SortDir>('desc')

  useEffect(() => {
    api.topics
      .accuracy()
      .then(setRows)
      .catch((e) => setError((e as Error).message))
      .finally(() => setLoading(false))
  }, [])

  function handleSort(key: SortKey) {
    if (sortKey === key) {
      setSortDir((d) => (d === 'desc' ? 'asc' : 'desc'))
    } else {
      setSortKey(key)
      setSortDir('desc')
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center py-8">
        <Spinner size="lg" />
      </div>
    )
  }

  if (error) {
    return <p className="text-sm text-red-500">{error}</p>
  }

  const sorted = sortRows(rows, sortKey, sortDir)

  return (
    <div>
      <h2 className="text-lg font-semibold text-slate-900 dark:text-slate-100 mb-3">
        Accuracy by Topic
      </h2>
      <div className="overflow-x-auto rounded-xl border border-slate-200 dark:border-slate-800">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-slate-200 dark:border-slate-800 bg-slate-50 dark:bg-slate-800/60">
              <th className="px-4 py-3 text-left font-semibold text-slate-700 dark:text-slate-300 w-1/3">
                Topic
              </th>
              <th className="px-4 py-3 text-left font-semibold text-slate-700 dark:text-slate-300 w-1/2">
                <button
                  onClick={() => handleSort('solved')}
                  className="inline-flex items-center gap-0.5 hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
                >
                  Questions Solved
                  <SortIcon active={sortKey === 'solved'} dir={sortDir} />
                </button>
              </th>
              <th className="px-4 py-3 text-right font-semibold text-slate-700 dark:text-slate-300 w-[120px]">
                <button
                  onClick={() => handleSort('accuracy')}
                  className="inline-flex items-center gap-0.5 hover:text-blue-600 dark:hover:text-blue-400 transition-colors ml-auto"
                >
                  Accuracy
                  <SortIcon active={sortKey === 'accuracy'} dir={sortDir} />
                </button>
              </th>
            </tr>
          </thead>
          <tbody>
            {sorted.map((row, i) => {
              const accuracy =
                row.total_attempts === 0
                  ? null
                  : (row.correct_attempts / row.total_attempts) * 100

              return (
                <tr
                  key={row.topic_id}
                  className={`border-b border-slate-100 dark:border-slate-800 last:border-0 ${
                    i % 2 === 0
                      ? 'bg-white dark:bg-slate-900'
                      : 'bg-slate-50/60 dark:bg-slate-800/30'
                  }`}
                >
                  <td className="px-4 py-3 text-slate-800 dark:text-slate-200 font-medium">
                    {row.topic_name}
                  </td>
                  <td className="px-4 py-3">
                    <div className="flex items-center gap-3">
                      <div className="flex-1 min-w-0">
                        <ProgressBar
                          correct={row.questions_solved}
                          total={row.questions_total}
                          fillClass="bg-blue-500"
                          size="sm"
                        />
                      </div>
                      <span className="text-xs text-slate-500 dark:text-slate-400 shrink-0 tabular-nums">
                        {row.questions_solved} / {row.questions_total}
                      </span>
                    </div>
                  </td>
                  <td className="px-4 py-3 text-right tabular-nums">
                    {accuracy === null ? (
                      <span className="text-slate-400 dark:text-slate-500">—</span>
                    ) : (
                      <span className={accuracy >= 70 ? 'text-green-600 dark:text-green-400' : accuracy >= 40 ? 'text-amber-600 dark:text-amber-400' : 'text-red-500 dark:text-red-400'}>
                        {accuracy.toFixed(1)}%
                      </span>
                    )}
                  </td>
                </tr>
              )
            })}
          </tbody>
        </table>
      </div>
    </div>
  )
}
