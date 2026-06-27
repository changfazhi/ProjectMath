import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useStudyPlan } from '../../hooks/useStudyPlan'
import { QuestItem } from '../sidebar/QuestItem'
import { ProgressBar } from '../ui/ProgressBar'
import { Spinner } from '../ui/Spinner'
import { cn } from '../../lib/utils'
import type { Quest } from '../../hooks/useStudyPlan'

export function StudyPlanSidebar() {
  const [isOpen, setIsOpen] = useState(false)
  const navigate = useNavigate()
  const { quests, correctCount, total, loading } = useStudyPlan(isOpen)

  function handleQuestSelect(quest: Quest) {
    navigate(`/practice/${quest.topic_id}?question_id=${quest.question_id}`)
  }

  return (
    <>
      {/* Trigger tab */}
      <button
        onClick={() => setIsOpen(o => !o)}
        aria-label={isOpen ? 'Close study plan' : 'Open study plan'}
        aria-expanded={isOpen}
        className="fixed left-0 top-1/2 -translate-y-1/2 z-50 w-10 h-20 rounded-r-2xl bg-blue-600 dark:bg-blue-500 hover:bg-blue-700 dark:hover:bg-blue-400 flex items-center justify-center focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500 transition-colors"
      >
        {isOpen ? (
          <svg className="w-5 h-5 text-white" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M12 4l-6 6 6 6" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        ) : (
          <svg className="w-5 h-5 text-white" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
            <rect x="3" y="4" width="14" height="14" rx="2" />
            <path d="M3 8h14M7 2v4m6-4v4" strokeLinecap="round" />
          </svg>
        )}
      </button>

      {/* Backdrop */}
      <div
        onClick={() => setIsOpen(false)}
        className={cn(
          'fixed inset-0 z-30 bg-black/30 backdrop-blur-sm transition-opacity duration-300',
          isOpen ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none',
        )}
      />

      {/* Panel */}
      <div
        role="complementary"
        aria-label="Study plan"
        className={cn(
          'fixed left-0 top-0 h-full z-40 w-[280px] bg-white dark:bg-slate-900 shadow-2xl flex flex-col transition-transform duration-300 ease-out',
          isOpen ? 'translate-x-0' : '-translate-x-full',
        )}
      >
        {/* Header */}
        <div className="px-4 py-5 border-b border-slate-200 dark:border-slate-800 flex items-center justify-between flex-shrink-0">
          <h2 className="text-lg font-bold text-slate-900 dark:text-slate-100">Today's Plan</h2>
          <button
            onClick={() => setIsOpen(false)}
            aria-label="Close study plan"
            className="p-1.5 rounded-lg text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
          >
            <svg className="w-5 h-5" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M4 4l12 12M16 4L4 16" strokeLinecap="round" />
            </svg>
          </button>
        </div>

        {/* Progress summary */}
        <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-800 flex-shrink-0">
          <p className="text-base font-semibold text-slate-800 dark:text-slate-100 mb-2">
            {correctCount} / {total} complete
          </p>
          <ProgressBar correct={correctCount} total={total} fillClass="bg-blue-500" size="sm" />
        </div>

        {/* Scrollable quest list */}
        <div className="flex-1 overflow-y-auto px-4 py-2">
          {loading ? (
            <div className="flex items-center justify-center h-full py-8">
              <Spinner size="sm" />
            </div>
          ) : (
            quests.map(quest => (
              <QuestItem key={quest.question_id} quest={quest} onSelect={handleQuestSelect} />
            ))
          )}
        </div>

        {/* Footer */}
        <div className="px-4 py-4 border-t border-slate-200 dark:border-slate-800 flex-shrink-0" />
      </div>
    </>
  )
}
