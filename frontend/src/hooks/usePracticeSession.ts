import { useCallback, useReducer, useRef } from 'react'
import { api } from '../lib/api'
import { getSessionId } from '../lib/session'
import type { Difficulty, QuestionPublic, SubmitAttemptResponse } from '../types/api'

type PracticePhase = 'loading' | 'answering' | 'submitted' | 'revealed' | 'complete' | 'error'

interface PracticeState {
  phase: PracticePhase
  question: QuestionPublic | null
  result: SubmitAttemptResponse | null
  error: string | null
  sessionCorrect: number
  sessionTotal: number
  streak: number
  questionStartTime: number | null
}

type Action =
  | { type: 'LOAD_START' }
  | { type: 'LOAD_SUCCESS'; question: QuestionPublic }
  | { type: 'COMPLETE' }
  | { type: 'SUBMIT_START' }
  | { type: 'SUBMIT_SUCCESS'; result: SubmitAttemptResponse }
  | { type: 'ERROR'; message: string }
  | { type: 'RESET' }

function reducer(state: PracticeState, action: Action): PracticeState {
  switch (action.type) {
    case 'LOAD_START':
      return { ...state, phase: 'loading', question: null, result: null, error: null }
    case 'LOAD_SUCCESS':
      return { ...state, phase: 'answering', question: action.question, questionStartTime: Date.now() }
    case 'COMPLETE':
      return { ...state, phase: 'complete', question: null }
    case 'SUBMIT_START':
      return { ...state, phase: 'submitted' }
    case 'SUBMIT_SUCCESS': {
      const correct = action.result.is_correct
      return {
        ...state,
        phase: 'revealed',
        result: action.result,
        sessionCorrect: state.sessionCorrect + (correct ? 1 : 0),
        sessionTotal: state.sessionTotal + 1,
        streak: correct ? state.streak + 1 : 0,
      }
    }
    case 'ERROR':
      return { ...state, phase: 'error', error: action.message }
    case 'RESET':
      return { ...initialState }
    default:
      return state
  }
}

const initialState: PracticeState = {
  phase: 'loading',
  question: null,
  result: null,
  error: null,
  sessionCorrect: 0,
  sessionTotal: 0,
  streak: 0,
  questionStartTime: null,
}

export function usePracticeSession(topicId: string, difficulty?: Difficulty) {
  const [state, dispatch] = useReducer(reducer, initialState)
  const sessionId = getSessionId()
  const difficultyRef = useRef(difficulty)
  difficultyRef.current = difficulty

  const loadNext = useCallback(async (diff?: Difficulty) => {
    dispatch({ type: 'LOAD_START' })
    try {
      const question = await api.questions.next(
        topicId,
        sessionId,
        diff !== undefined ? diff : difficultyRef.current,
      )
      dispatch({ type: 'LOAD_SUCCESS', question })
    } catch (err) {
      const msg = (err as Error).message
      if (msg.toLowerCase().includes('no questions found')) {
        dispatch({ type: 'COMPLETE' })
      } else {
        dispatch({ type: 'ERROR', message: msg })
      }
    }
  }, [topicId, sessionId])

  // Loads a specific question by ID — used when navigating from the question list
  const loadSpecific = useCallback(async (questionId: string) => {
    dispatch({ type: 'LOAD_START' })
    try {
      const question = await api.questions.get(questionId)
      dispatch({ type: 'LOAD_SUCCESS', question })
    } catch (err) {
      dispatch({ type: 'ERROR', message: (err as Error).message })
    }
  }, [])

  const submitAnswer = useCallback(
    async (answerGiven: string) => {
      if (!state.question) return
      dispatch({ type: 'SUBMIT_START' })
      const timeTaken = state.questionStartTime
        ? Math.max(1, Math.round((Date.now() - state.questionStartTime) / 1000))
        : undefined
      try {
        const result = await api.attempts.submit({
          session_id: sessionId,
          question_id: state.question.id,
          answer_given: answerGiven,
          time_taken_s: timeTaken,
        })
        dispatch({ type: 'SUBMIT_SUCCESS', result })
      } catch (err) {
        dispatch({ type: 'ERROR', message: (err as Error).message })
      }
    },
    [state.question, state.questionStartTime, sessionId],
  )

  const nextQuestion = useCallback(() => {
    loadNext()
  }, [loadNext])

  const reset = useCallback((diff?: Difficulty) => {
    dispatch({ type: 'RESET' })
    loadNext(diff)
  }, [loadNext])

  return {
    ...state,
    sessionId,
    loadNext,
    loadSpecific,
    submitAnswer,
    nextQuestion,
    reset,
  }
}
