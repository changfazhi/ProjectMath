import { useCallback, useReducer, useRef } from 'react'
import { api } from '../lib/api'
import type { Difficulty, GradeResponse, QuestionPublic, SubmitAttemptResponse } from '../types/api'

type PracticePhase = 'loading' | 'answering' | 'submitted' | 'revealed' | 'complete' | 'error'

export interface PartState {
  phase: 'idle' | 'submitting' | 'done'
  isCorrect?: boolean
  correctAnswer?: string
}

interface PracticeState {
  phase: PracticePhase
  question: QuestionPublic | null
  result: SubmitAttemptResponse | null
  gradingResult: GradeResponse | null
  gradingError: string | null
  partStates: Record<string, PartState>
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
  | { type: 'GRADE_START' }
  | { type: 'GRADE_SUCCESS'; grading: GradeResponse }
  | { type: 'GRADE_REJECTED'; message: string }
  | { type: 'PART_SUBMIT_START'; partLabel: string }
  | { type: 'PART_SUBMIT_DONE'; partLabel: string; isCorrect: boolean; correctAnswer: string; solutionLatex: string | null }
  | { type: 'ERROR'; message: string }
  | { type: 'RESET' }
  | { type: 'RETRY' }

function reducer(state: PracticeState, action: Action): PracticeState {
  switch (action.type) {
    case 'LOAD_START':
      return { ...state, phase: 'loading', question: null, result: null, gradingResult: null, gradingError: null, partStates: {}, error: null }

    case 'LOAD_SUCCESS': {
      const partStates: Record<string, PartState> = {}
      if (action.question.parts) {
        for (const p of action.question.parts) {
          partStates[p.label] = { phase: 'idle' }
        }
      }
      return { ...state, phase: 'answering', question: action.question, partStates, questionStartTime: Date.now() }
    }

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

    case 'GRADE_START':
      return { ...state, phase: 'submitted', gradingError: null }

    case 'GRADE_REJECTED':
      // Soft, non-penalising error — keep the student on the question to retake the photo.
      return { ...state, phase: 'answering', gradingError: action.message }

    case 'GRADE_SUCCESS': {
      const correct = action.grading.is_correct
      return {
        ...state,
        phase: 'revealed',
        gradingResult: action.grading,
        result: {
          attempt_id: '',
          is_correct: correct,
          correct_answer: '',
          solution_latex: action.grading.solution_latex,
        },
        sessionCorrect: state.sessionCorrect + (correct ? 1 : 0),
        sessionTotal: state.sessionTotal + 1,
        streak: correct ? state.streak + 1 : 0,
      }
    }

    case 'PART_SUBMIT_START':
      return {
        ...state,
        partStates: {
          ...state.partStates,
          [action.partLabel]: { phase: 'submitting' },
        },
      }

    case 'PART_SUBMIT_DONE': {
      const updatedPartStates = {
        ...state.partStates,
        [action.partLabel]: {
          phase: 'done' as const,
          isCorrect: action.isCorrect,
          correctAnswer: action.correctAnswer,
        },
      }

      if (action.solutionLatex !== null) {
        // All graded parts submitted — transition to revealed
        const gradedParts = state.question?.parts?.filter((p) => p.answer_type !== null) ?? []
        const allCorrect = gradedParts.every((p) => {
          if (p.label === action.partLabel) return action.isCorrect
          return updatedPartStates[p.label]?.isCorrect === true
        })
        return {
          ...state,
          phase: 'revealed',
          partStates: updatedPartStates,
          result: {
            attempt_id: '',
            is_correct: allCorrect,
            correct_answer: '',
            solution_latex: action.solutionLatex,
          },
          sessionCorrect: state.sessionCorrect + (allCorrect ? 1 : 0),
          sessionTotal: state.sessionTotal + 1,
          streak: allCorrect ? state.streak + 1 : 0,
        }
      }

      return { ...state, partStates: updatedPartStates }
    }

    case 'ERROR':
      return { ...state, phase: 'error', error: action.message }

    case 'RESET':
      return { ...initialState }

    case 'RETRY': {
      const retryPartStates: Record<string, PartState> = {}
      if (state.question?.parts) {
        for (const p of state.question.parts) {
          retryPartStates[p.label] = { phase: 'idle' }
        }
      }
      return {
        ...state,
        phase: 'answering',
        result: null,
        gradingResult: null,
        gradingError: null,
        partStates: retryPartStates,
        questionStartTime: Date.now(),
      }
    }

    default:
      return state
  }
}

const initialState: PracticeState = {
  phase: 'loading',
  question: null,
  result: null,
  gradingResult: null,
  gradingError: null,
  partStates: {},
  error: null,
  sessionCorrect: 0,
  sessionTotal: 0,
  streak: 0,
  questionStartTime: null,
}

export function usePracticeSession(topicId: string, difficulty?: Difficulty) {
  const [state, dispatch] = useReducer(reducer, initialState)
  const difficultyRef = useRef(difficulty)
  difficultyRef.current = difficulty

  const loadNext = useCallback(async (diff?: Difficulty) => {
    dispatch({ type: 'LOAD_START' })
    try {
      const question = await api.questions.next(
        topicId,
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
  }, [topicId])

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
          question_id: state.question.id,
          answer_given: answerGiven,
          time_taken_s: timeTaken,
        })
        dispatch({ type: 'SUBMIT_SUCCESS', result })
      } catch (err) {
        dispatch({ type: 'ERROR', message: (err as Error).message })
      }
    },
    [state.question, state.questionStartTime],
  )

  const submitPart = useCallback(
    async (partLabel: string, answerGiven: string) => {
      if (!state.question) return
      dispatch({ type: 'PART_SUBMIT_START', partLabel })
      const timeTaken = state.questionStartTime
        ? Math.max(1, Math.round((Date.now() - state.questionStartTime) / 1000))
        : undefined
      try {
        const result = await api.attempts.submit({
          question_id: state.question.id,
          part_label: partLabel,
          answer_given: answerGiven,
          time_taken_s: timeTaken,
        })
        dispatch({
          type: 'PART_SUBMIT_DONE',
          partLabel,
          isCorrect: result.is_correct,
          correctAnswer: result.correct_answer,
          solutionLatex: result.solution_latex,
        })
      } catch (err) {
        dispatch({ type: 'ERROR', message: (err as Error).message })
      }
    },
    [state.question, state.questionStartTime],
  )

  const submitPhotos = useCallback(
    async (images: File[]) => {
      if (!state.question || images.length === 0) return
      dispatch({ type: 'GRADE_START' })
      const timeTaken = state.questionStartTime
        ? Math.max(1, Math.round((Date.now() - state.questionStartTime) / 1000))
        : undefined
      try {
        const grading = await api.grade.submit(state.question.id, images, timeTaken)
        dispatch({ type: 'GRADE_SUCCESS', grading })
      } catch (err) {
        // Photo failures (irrelevant/blank photo, transient errors) are recoverable — keep the
        // student on the question to retake rather than dropping to the global error screen.
        dispatch({ type: 'GRADE_REJECTED', message: (err as Error).message })
      }
    },
    [state.question, state.questionStartTime],
  )

  // Grading driven by an external channel (the "upload via phone" socket flow). These reuse
  // the same actions as a local photo upload so the result lands in the same `revealed` state.
  const beginExternalGrading = useCallback(() => {
    dispatch({ type: 'GRADE_START' })
  }, [])

  const receiveGrading = useCallback((grading: GradeResponse) => {
    dispatch({ type: 'GRADE_SUCCESS', grading })
  }, [])

  const rejectExternalGrading = useCallback((message: string) => {
    dispatch({ type: 'GRADE_REJECTED', message })
  }, [])

  const nextQuestion = useCallback(() => {
    loadNext()
  }, [loadNext])

  const retryQuestion = useCallback(() => {
    dispatch({ type: 'RETRY' })
  }, [])

  const reset = useCallback((diff?: Difficulty) => {
    dispatch({ type: 'RESET' })
    loadNext(diff)
  }, [loadNext])

  return {
    ...state,
    loadNext,
    loadSpecific,
    submitAnswer,
    submitPart,
    submitPhotos,
    beginExternalGrading,
    receiveGrading,
    rejectExternalGrading,
    nextQuestion,
    retryQuestion,
    reset,
  }
}
