import { useTopics } from '../hooks/useTopics'
import { RoadmapGraph } from '../components/topic/RoadmapGraph'
import { Spinner } from '../components/ui/Spinner'
import { ErrorMessage } from '../components/ui/ErrorMessage'

export function HomePage() {
  const { topics, loading, error } = useTopics()

  return (
    <div className="max-w-5xl mx-auto px-4 py-10 flex flex-col gap-8">
      <div>
        <h1 className="text-3xl font-bold text-slate-900 dark:text-slate-100 tracking-tight">
          ProjectMath
        </h1>
        <p className="mt-2 text-slate-500 dark:text-slate-400">
          Singapore H1/H2 A-Level Mathematics — follow the roadmap and start practising.
        </p>
      </div>

      {loading && (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      )}
      {error && <ErrorMessage message={error} />}
      {!loading && !error && <RoadmapGraph topics={topics} />}
    </div>
  )
}
