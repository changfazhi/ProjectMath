import { useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import type { Topic } from '../../types/api'
import { useConcepts } from '../../hooks/useConcepts'
import { useTopicQuestions } from '../../hooks/useTopicQuestions'
import { ConceptsList } from './ConceptsList'
import { QuestionTable } from './QuestionTable'
import { Badge } from '../ui/Badge'
import { Button } from '../ui/Button'
import { Spinner } from '../ui/Spinner'
import { ProgressBar } from '../ui/ProgressBar'

interface Props {
  topic: Topic | null
  onClose: () => void
}

export function TopicDrawer({ topic, onClose }: Props) {
  const navigate = useNavigate()
  const open = topic !== null

  const { concepts, loading: conceptsLoading, error: conceptsError } = useConcepts(topic?.id ?? null)
  const { questions, starredIds, toggleStar, loading: questionsLoading, error: questionsError } =
    useTopicQuestions(topic?.id ?? null)

  // Close on Escape key
  useEffect(() => {
    if (!open) return
    function onKey(e: KeyboardEvent) {
      if (e.key === 'Escape') onClose()
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [open, onClose])

  // Prevent body scroll when open
  useEffect(() => {
    document.body.style.overflow = open ? 'hidden' : ''
    return () => {
      document.body.style.overflow = ''
    }
  }, [open])

  function handleSelectQuestion(questionId: string) {
    if (!topic) return
    onClose()
    navigate(`/practice/${topic.id}?question_id=${questionId}`)
  }

  function handleStartPractice() {
    if (!topic) return
    onClose()
    navigate(`/practice/${topic.id}`)
  }

  return (
    <>
      {/* Backdrop */}
      <div
        onClick={onClose}
        className={`fixed inset-0 z-40 bg-black/30 backdrop-blur-sm transition-opacity duration-300 ${
          open ? 'opacity-100 pointer-events-auto' : 'opacity-0 pointer-events-none'
        }`}
      />

      {/* Drawer panel */}
      <div
        className={`fixed top-0 right-0 z-50 h-full w-full sm:w-[480px] bg-white dark:bg-slate-950 shadow-2xl flex flex-col transition-transform duration-300 ease-out ${
          open ? 'translate-x-0' : 'translate-x-full'
        }`}
      >
        {/* Header */}
        <div className="flex items-start justify-between gap-3 px-6 py-5 border-b border-slate-200 dark:border-slate-800 flex-shrink-0">
          <div className="flex flex-col gap-1.5">
            <h2 className="text-lg font-bold text-slate-900 dark:text-slate-100 leading-tight">
              {topic?.name ?? ''}
            </h2>
            {topic && (
              <Badge variant="neutral">{topic.level} Mathematics</Badge>
            )}
          </div>
          <button
            onClick={onClose}
            className="mt-0.5 p-1.5 rounded-lg text-slate-500 dark:text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 transition-colors flex-shrink-0"
            aria-label="Close panel"
          >
            <svg className="w-5 h-5" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="2">
              <path d="M4 4l12 12M16 4L4 16" strokeLinecap="round" />
            </svg>
          </button>
        </div>

        {/* Scrollable body */}
        <div className="flex-1 overflow-y-auto px-6 py-5 flex flex-col gap-6">
          {/* Concepts section */}
          <ConceptsList concepts={concepts} loading={conceptsLoading} error={conceptsError} />

          <hr className="border-slate-200 dark:border-slate-800" />

          {/* Questions section */}
          <div>
            <h3 className="text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400 mb-3">
              Questions
            </h3>
            {questionsLoading && (
              <div className="flex justify-center py-6">
                <Spinner size="sm" />
              </div>
            )}
            {questionsError && (
              <p className="text-sm text-red-500">{questionsError}</p>
            )}
            {!questionsLoading && !questionsError && (() => {
              const correct = questions.filter(q => q.status === 'correct').length
              const total = questions.length
              return (
                <>
                  <div className="flex flex-col items-center gap-2 mb-4">
                    <span className="text-sm font-semibold text-slate-700 dark:text-slate-300">
                      {correct} / {total} solved
                    </span>
                    <ProgressBar correct={correct} total={total} fillClass="bg-emerald-500" size="md" />
                  </div>
                  <QuestionTable
                    questions={questions}
                    starredIds={starredIds}
                    onToggleStar={toggleStar}
                    onSelectQuestion={handleSelectQuestion}
                  />
                </>
              )
            })()}
          </div>
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-slate-200 dark:border-slate-800 flex-shrink-0">
          <Button onClick={handleStartPractice} size="lg" className="w-full justify-center">
            Start Practice →
          </Button>
        </div>
      </div>
    </>
  )
}
