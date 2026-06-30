import type { Attempt } from '../../types/api'
import { Badge } from '../ui/Badge'
import { Latex } from '../math/Latex'
import { formatTime } from '../../lib/utils'

interface Props {
  attempt: Attempt
}

export function AttemptRow({ attempt }: Props) {
  const date = new Date(attempt.attempted_at)
  return (
    <tr className="border-b border-slate-100 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-800/50 transition-colors">
      <td className="py-3 px-4 text-sm text-slate-600 dark:text-slate-400 whitespace-nowrap">
        {date.toLocaleDateString()} {date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
      </td>
      <td className="py-3 px-4 text-sm text-slate-700 dark:text-slate-300 max-w-[220px] truncate">
        {attempt.question_name ?? `${attempt.question_id.slice(0, 8)}…`}
      </td>
      <td className="py-3 px-4 text-sm text-slate-700 dark:text-slate-300">
        {attempt.answer_given ? <Latex>{attempt.answer_given}</Latex> : '—'}
      </td>
      <td className="py-3 px-4">
        <Badge variant={attempt.is_correct ? 'success' : 'danger'}>
          {attempt.is_correct ? 'Correct' : 'Incorrect'}
        </Badge>
      </td>
      <td className="py-3 px-4 text-sm text-slate-500 dark:text-slate-400">
        {attempt.time_taken_s != null ? formatTime(attempt.time_taken_s) : '—'}
      </td>
    </tr>
  )
}
