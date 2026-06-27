import { cn } from '../../lib/utils'
import type { Quest } from '../../hooks/useStudyPlan'

interface Props {
  quest: Quest
  onSelect: (quest: Quest) => void
}

export function QuestItem({ quest, onSelect }: Props) {
  return (
    <button
      onClick={() => onSelect(quest)}
      className={cn(
        'flex items-center min-h-[64px] py-3 px-2 rounded-xl w-full text-left',
        'hover:bg-slate-50 dark:hover:bg-slate-800 cursor-pointer transition-colors',
        'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500',
      )}
    >
      {/* Status zone 24×24 */}
      <div className="flex-shrink-0 w-6 h-6 flex items-center justify-center mr-2">
        {quest.status === 'correct' && (
          <svg className="w-5 h-5 text-emerald-500" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M4 10l4 4 8-8" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
        {quest.status === 'attempted' && (
          <svg className="w-5 h-5 text-amber-500" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M9 4H6a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V6a2 2 0 00-2-2h-3m-3 4l3 3-3 3" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        )}
        {quest.status === 'pending' && (
          <span className="w-6 h-6 rounded-full bg-slate-200 dark:bg-slate-700 text-xs font-semibold flex items-center justify-center text-slate-600 dark:text-slate-300">
            {quest.index + 1}
          </span>
        )}
      </div>

      {/* Text zone */}
      <div className="flex-1 min-w-0">
        <p className="text-sm line-clamp-2 text-slate-800 dark:text-slate-100">
          {quest.question_name ?? `Question ${quest.index + 1}`}
        </p>
        <p className="text-xs font-semibold text-slate-500 dark:text-slate-400 mt-0.5">
          {quest.topic_name}
        </p>
      </div>
    </button>
  )
}
