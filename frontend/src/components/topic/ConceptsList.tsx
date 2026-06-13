import type { TopicConcept } from '../../types/api'
import { Spinner } from '../ui/Spinner'
import { ErrorMessage } from '../ui/ErrorMessage'

interface Props {
  concepts: TopicConcept[]
  loading: boolean
  error: string | null
}

export function ConceptsList({ concepts, loading, error }: Props) {
  return (
    <div>
      <h3 className="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">
        Concepts to know
      </h3>

      {loading && <Spinner size="sm" />}
      {error && <ErrorMessage message={error} />}

      {!loading && !error && concepts.length === 0 && (
        <p className="text-sm text-slate-400 dark:text-slate-500 italic">No concepts listed yet.</p>
      )}

      {!loading && !error && concepts.length > 0 && (
        <ul className="flex flex-col gap-2">
          {concepts.map((c) => (
            <li key={c.id} className="flex items-start gap-2 text-sm text-slate-700 dark:text-slate-300">
              <span className="mt-1.5 w-1.5 h-1.5 rounded-full bg-blue-400 dark:bg-blue-500 flex-shrink-0" />
              {c.concept}
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
