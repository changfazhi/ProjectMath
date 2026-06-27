import { useEffect, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useStudyPlan } from '../../hooks/useStudyPlan'
import { QuestItem } from '../sidebar/QuestItem'
import { Button } from '../ui/Button'
import { ProgressBar } from '../ui/ProgressBar'
import { Spinner } from '../ui/Spinner'
import { cn } from '../../lib/utils'
import type { Quest } from '../../hooks/useStudyPlan'

export function StudyPlanSidebar() {
  const [isOpen, setIsOpen] = useState(false)
  const navigate = useNavigate()
  const { quests, correctCount, total, loading, error, isStale } = useStudyPlan(isOpen)

  const triggerRef = useRef<HTMLButtonElement>(null)
  const closeRef = useRef<HTMLButtonElement>(null)
  // Prevents returning focus to the trigger before the panel has ever been opened,
  // which would steal keyboard focus from the page content on mount.
  const hasOpenedRef = useRef(false)

  useEffect(() => {
    if (isOpen) {
      hasOpenedRef.current = true
      closeRef.current?.focus()
    } else if (hasOpenedRef.current) {
      triggerRef.current?.focus()
    }
  }, [isOpen])

  // Escape key closes the panel
  useEffect(() => {
    if (!isOpen) return
    function onKey(e: KeyboardEvent) {
      if (e.key === 'Escape') setIsOpen(false)
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [isOpen])

  function handleQuestSelect(quest: Quest) {
    navigate(`/practice/${quest.topic_id}?question_id=${quest.question_id}`)
  }

  const showProgress = !loading && !error && !isStale && total > 0
  const isEmpty = !loading && !error && total === 0

  return (
    <>
      {/* Trigger tab */}
      <button
        ref={triggerRef}
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
            ref={closeRef}
            onClick={() => setIsOpen(false)}
            aria-label="Close study plan"
            className="p-1.5 rounded-lg text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-blue-500"
          >
            <svg className="w-5 h-5" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M4 4l12 12M16 4L4 16" strokeLinecap="round" />
            </svg>
          </button>
        </div>

        {/* Progress summary — State 2 (active) only */}
        {showProgress && (
          <div className="px-4 py-3 border-b border-slate-200 dark:border-slate-800 flex-shrink-0">
            <p className="text-base font-semibold text-slate-800 dark:text-slate-100 mb-2">
              {correctCount} / {total} complete
            </p>
            <ProgressBar correct={correctCount} total={total} fillClass="bg-blue-500" size="sm" />
          </div>
        )}

        {/* Scrollable body */}
        <div className="flex-1 overflow-y-auto px-4 py-2">
          {/* State 4: Loading */}
          {loading && (
            <div className="flex items-center justify-center h-full py-8">
              <Spinner size="sm" />
            </div>
          )}

          {/* State 5: Error */}
          {!loading && error && (
            <p className="text-sm text-red-500 py-4">
              Couldn&apos;t load your plan — refresh to try again.
            </p>
          )}

          {/* State 1: Empty */}
          {isEmpty && (
            <div className="flex flex-col items-center gap-3 py-8 text-center">
              <svg className="w-10 h-10 text-slate-300 dark:text-slate-600" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                <rect x="3" y="4" width="18" height="18" rx="2" />
                <path d="M3 9h18M9 3v3m6-3v3" strokeLinecap="round" />
              </svg>
              <p className="text-sm font-semibold text-slate-500 dark:text-slate-400">No plan yet</p>
              <p className="text-sm text-slate-400 dark:text-slate-500">
                Generate a study plan to track your daily practice goals.
              </p>
              <Button variant="primary" size="md" className="w-full justify-center" onClick={() => navigate('/review')}>
                Generate plan
              </Button>
            </div>
          )}

          {/* State 2: Active, State 3: Stale */}
          {!loading && !error && total > 0 && (
            <div className={cn(isStale && 'opacity-40')}>
              {quests.map(quest => (
                <QuestItem key={quest.question_id} quest={quest} onSelect={handleQuestSelect} />
              ))}
            </div>
          )}
        </div>

        {/* Footer — stale-day banner (State 3) or empty */}
        <div className="px-4 py-4 border-t border-slate-200 dark:border-slate-800 flex-shrink-0">
          {isStale && !loading && !error && total > 0 && (
            <div className="bg-amber-50 dark:bg-amber-900/20 border border-amber-200 dark:border-amber-800 rounded-xl p-3 flex flex-col gap-2">
              <p className="text-sm font-semibold text-amber-800 dark:text-amber-300">New day</p>
              <p className="text-xs text-amber-700 dark:text-amber-400">
                Generate today&apos;s plan to continue your streak.
              </p>
              <Button variant="secondary" size="sm" className="w-full justify-center" onClick={() => navigate('/review')}>
                Generate plan
              </Button>
            </div>
          )}
        </div>
      </div>
    </>
  )
}
