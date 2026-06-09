import { useNavigate } from 'react-router-dom'
import type { Topic } from '../../types/api'
import { Badge } from '../ui/Badge'

interface Props {
  topic: Topic
}

export function TopicCard({ topic }: Props) {
  const navigate = useNavigate()
  return (
    <button
      onClick={() => navigate(`/practice/${topic.id}`)}
      className="group flex flex-col gap-3 p-5 rounded-2xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-900 shadow-sm hover:shadow-md hover:border-blue-400 dark:hover:border-blue-600 transition-all duration-150 text-left focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
    >
      <div className="flex items-start justify-between gap-2">
        <h3 className="font-semibold text-slate-900 dark:text-slate-100 text-base group-hover:text-blue-600 dark:group-hover:text-blue-400 transition-colors">
          {topic.name}
        </h3>
        <Badge variant={topic.level === 'H2' ? 'info' : 'neutral'}>{topic.level}</Badge>
      </div>
      <p className="text-sm text-blue-600 dark:text-blue-400 font-medium">Practice →</p>
    </button>
  )
}
