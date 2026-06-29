import { useState } from 'react'
import { Link } from 'react-router-dom'
import type { Topic } from '../types/api'
import { useTopics } from '../hooks/useTopics'
import { useVisitedTopics } from '../hooks/useVisitedTopics'
import { useTopicsProgress } from '../hooks/useTopicsProgress'
import { RoadmapGraph } from '../components/topic/RoadmapGraph'
import { TopicDrawer } from '../components/topic/TopicDrawer'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'

const BRICOLAGE = "'Bricolage Grotesque', sans-serif"

function LegendDot({ color, label }: { color: string; label: string }) {
  return (
    <div className="flex items-center gap-2 text-[13px] text-[#aab0d6]">
      <span className="w-[10px] h-[10px] rounded-full" style={{ background: color }} />
      {label}
    </div>
  )
}

export function HomePage() {
  const { topics, loading, error } = useTopics()
  const { markVisited } = useVisitedTopics()
  const progress = useTopicsProgress()
  const [selectedTopic, setSelectedTopic] = useState<Topic | null>(null)

  function handleTopicClick(topic: Topic) {
    markVisited(topic.id)
    setSelectedTopic(topic)
  }

  return (
    <div className="flex flex-col h-full bg-[#0b0e20]">
      {/* Title bar */}
      <div className="max-w-5xl mx-auto px-6 pt-9 pb-5 w-full shrink-0">
        <div className="text-[13px] font-bold uppercase tracking-[0.1em] text-[#a5abe0]">
          Your roadmap
        </div>
        <h1
          className="mt-3 text-4xl font-extrabold tracking-tight text-white"
          style={{ fontFamily: BRICOLAGE }}
        >
          <Link to="/" className="hover:text-[#c7cbff] transition-colors">
            Project<span className="text-[#7c83ff]">Math</span>
          </Link>
        </h1>
        <p className="mt-3 text-[#aab0d6] max-w-2xl">
          A clear path through the whole syllabus — follow the nodes, unlock topics as you go,
          and watch the map fill in.
        </p>
        <div className="mt-5 flex flex-wrap items-center gap-x-6 gap-y-2">
          <LegendDot color="#38bdf8" label="Pure Mathematics" />
          <LegendDot color="#34d399" label="Statistics" />
          <LegendDot color="#3a4170" label="Up next" />
        </div>
      </div>

      {/* Roadmap — fills all remaining height, no scrollbars */}
      <div className="relative flex-1 min-h-0">
        {/* Soft fade blends the dark header into the grid/glow canvas */}
        <div
          className="pointer-events-none absolute inset-x-0 top-0 z-10 h-20"
          style={{ background: 'linear-gradient(to bottom, #0b0e20, transparent)' }}
        />
        {loading && (
          <div className="flex justify-center py-16">
            <Spinner size="lg" />
          </div>
        )}
        {error && <ErrorMessage message={error} />}
        {!loading && !error && (
          <RoadmapGraph
            topics={topics}
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
