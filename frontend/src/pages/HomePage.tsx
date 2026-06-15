import { useState } from 'react'
import type { Topic } from '../types/api'
import { useTopics } from '../hooks/useTopics'
import { useVisitedTopics } from '../hooks/useVisitedTopics'
import { useTopicsProgress } from '../hooks/useTopicsProgress'
import { RoadmapGraph } from '../components/topic/RoadmapGraph'
import { TopicDrawer } from '../components/topic/TopicDrawer'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'

export function HomePage() {
  const { topics, loading, error } = useTopics()
  const { visited, markVisited } = useVisitedTopics()
  const progress = useTopicsProgress()
  const [selectedTopic, setSelectedTopic] = useState<Topic | null>(null)

  function handleTopicClick(topic: Topic) {
    markVisited(topic.id)
    setSelectedTopic(topic)
  }

  return (
    <div className="flex flex-col h-full">
      {/* Title bar */}
      <div className="max-w-5xl mx-auto px-4 pt-8 pb-5 w-full shrink-0">
        <h1 className="text-3xl font-bold text-slate-900 dark:text-slate-100 tracking-tight">
          ProjectMath
        </h1>
        <p className="mt-2 text-slate-500 dark:text-slate-400">
          Singapore H1/H2 A-Level Mathematics — follow the roadmap and start practising.
        </p>
      </div>

      {/* Roadmap — fills all remaining height, no scrollbars */}
      <div className="flex-1 min-h-0">
        {loading && (
          <div className="flex justify-center py-16">
            <Spinner size="lg" />
          </div>
        )}
        {error && <ErrorMessage message={error} />}
        {!loading && !error && (
          <RoadmapGraph
            topics={topics}
            visited={visited}
            progress={progress}
            onTopicClick={handleTopicClick}
          />
        )}
      </div>

      <TopicDrawer
        topic={selectedTopic}
        onClose={() => setSelectedTopic(null)}
      />
    </div>
  )
}
