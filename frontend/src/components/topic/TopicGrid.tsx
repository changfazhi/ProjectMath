import type { Topic } from '../../types/api'
import { TopicCard } from './TopicCard'

interface Props {
  topics: Topic[]
}

export function TopicGrid({ topics }: Props) {
  if (topics.length === 0) {
    return (
      <p className="text-slate-500 dark:text-slate-400 text-center py-12">
        No topics found.
      </p>
    )
  }
  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
      {topics.map((t) => (
        <TopicCard key={t.id} topic={t} />
      ))}
    </div>
  )
}
