import type {
  Attempt,
  ChatMessage,
  ChatSendResponse,
  CreatePairResponse,
  DiagnosisResult,
  Difficulty,
  Grading,
  GradeResponse,
  MathLevel,
  PairContext,
  QuestionPublic,
  QuestionWithStatus,
  ReviewItem,
  StarredQuestionRow,
  StarToggleResponse,
  StreakStats,
  StudyPlanResponse,
  SubmitAttemptResponse,
  Topic,
  TopicAccuracy,
  TopicConcept,
  TopicProgress,
} from '../types/api'
import { auth } from './firebase'

interface ApiCallbacks {
  onUnauthorized: () => void
  onPaymentRequired: () => void
}

let _callbacks: ApiCallbacks = {
  onUnauthorized: () => {},
  onPaymentRequired: () => {},
}

export function setApiCallbacks(cb: ApiCallbacks): void {
  _callbacks = cb
}

async function getAuthHeader(): Promise<Record<string, string>> {
  const token = await auth.currentUser?.getIdToken()
  return token ? { Authorization: `Bearer ${token}` } : {}
}

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(path, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...authHeaders,
    },
  })
  if (res.status === 401) {
    _callbacks.onUnauthorized()
    throw new Error('Sign in to continue')
  }
  if (res.status === 402) {
    _callbacks.onPaymentRequired()
    throw new Error('Subscription required')
  }
  if (!res.ok) {
    const body = await res.json().catch(() => ({ error: res.statusText }))
    throw new Error((body as { error?: string }).error ?? res.statusText)
  }
  return res.json() as Promise<T>
}

async function requestFormData<T>(path: string, formData: FormData): Promise<T> {
  const authHeaders = await getAuthHeader()
  const res = await fetch(path, { method: 'POST', headers: authHeaders, body: formData })
  if (res.status === 401) {
    _callbacks.onUnauthorized()
    throw new Error('Sign in to continue')
  }
  if (res.status === 402) {
    _callbacks.onPaymentRequired()
    throw new Error('Subscription required')
  }
  if (!res.ok) {
    const body = await res.json().catch(() => ({ error: res.statusText }))
    throw new Error((body as { error?: string }).error ?? res.statusText)
  }
  return res.json() as Promise<T>
}

export const api = {
  topics: {
    list: (level?: MathLevel) =>
      request<Topic[]>(`/api/topics${level ? `?level=${level}` : ''}`),

    get: (id: string) => request<Topic>(`/api/topics/${id}`),

    questions: (topicId: string) =>
      request<QuestionWithStatus[]>(`/api/topics/${topicId}/questions`),

    concepts: (topicId: string) =>
      request<TopicConcept[]>(`/api/topics/${topicId}/concepts`),

    progress: () => request<TopicProgress[]>('/api/topics/progress'),

    accuracy: () => request<TopicAccuracy[]>('/api/topics/accuracy'),
  },

  questions: {
    next: (topicId: string, difficulty?: Difficulty) => {
      const params = new URLSearchParams()
      if (difficulty !== undefined) params.set('difficulty', String(difficulty))
      const qs = params.toString()
      return request<QuestionPublic>(`/api/topics/${topicId}/next${qs ? `?${qs}` : ''}`)
    },

    get: (id: string) => request<QuestionPublic>(`/api/questions/${id}`),

    solution: (id: string) =>
      request<{ solution_latex: string | null }>(`/api/questions/${id}/solution`),
  },

  attempts: {
    submit: (body: {
      question_id: string
      part_label?: string
      answer_given: string
      field_answers?: { key: string; value: string }[]
      time_taken_s?: number
    }) =>
      request<SubmitAttemptResponse>('/api/attempts', {
        method: 'POST',
        body: JSON.stringify(body),
      }),

    list: (questionId?: string) => {
      const params = new URLSearchParams()
      if (questionId) params.set('question_id', questionId)
      const qs = params.toString()
      return request<Attempt[]>(`/api/attempts${qs ? `?${qs}` : ''}`)
    },
  },

  stars: {
    toggle: (questionId: string) =>
      request<StarToggleResponse>('/api/stars', {
        method: 'POST',
        body: JSON.stringify({ question_id: questionId }),
      }),

    list: (topicId: string) =>
      request<string[]>(`/api/stars?topic_id=${topicId}`),

    listAll: () => request<StarredQuestionRow[]>('/api/stars/all'),
  },

  streaks: {
    get: () => request<StreakStats>('/api/streaks'),
  },

  chat: {
    history: (questionId: string) =>
      request<ChatMessage[]>(`/api/chat?question_id=${questionId}`),

    send: (questionId: string, message: string) =>
      request<ChatSendResponse>('/api/chat', {
        method: 'POST',
        body: JSON.stringify({ question_id: questionId, message }),
      }),
  },

  grade: {
    submit: (questionId: string, images: File[], timeTakenS?: number) => {
      const fd = new FormData()
      fd.append('question_id', questionId)
      if (timeTakenS !== undefined) fd.append('time_taken_s', String(timeTakenS))
      for (const img of images) fd.append('images', img)
      return requestFormData<GradeResponse>('/api/grade', fd)
    },

    // Re-grade the student's corrected LaTeX transcription (no photos).
    regradeText: (questionId: string, transcriptionLatex: string, timeTakenS?: number) =>
      request<GradeResponse>('/api/grade/text', {
        method: 'POST',
        body: JSON.stringify({
          question_id: questionId,
          transcription_latex: transcriptionLatex,
          time_taken_s: timeTakenS,
        }),
      }),

    history: (questionId: string) =>
      request<Grading[]>(`/api/grade?question_id=${questionId}`),
  },

  pair: {
    create: (questionId: string) =>
      request<CreatePairResponse>('/api/pair', {
        method: 'POST',
        body: JSON.stringify({ question_id: questionId }),
      }),

    context: (token: string) => request<PairContext>(`/api/pair/${token}`),

    uploadPhoto: (token: string, image: File) => {
      const fd = new FormData()
      fd.append('image', image)
      return requestFormData<{ count: number }>(`/api/pair/${token}/photo`, fd)
    },

    done: (token: string) =>
      request<{ ok: boolean }>(`/api/pair/${token}/done`, { method: 'POST' }),
  },

  review: {
    corrections: () => request<{ items: ReviewItem[] }>('/api/review/corrections'),
    weakTopics: () => request<{ items: ReviewItem[] }>('/api/review/weak-topics'),
    speedDrills: () => request<{ items: ReviewItem[] }>('/api/review/speed-drills'),
    spaced: () => request<{ items: ReviewItem[] }>('/api/review/spaced'),
    random: () => request<{ items: ReviewItem[] }>('/api/review/random'),
    diagnosis: () => request<DiagnosisResult>('/api/review/diagnosis'),
    studyPlan: () => request<StudyPlanResponse>('/api/review/study-plan'),
  },

  billing: {
    checkout: (plan: 'monthly' | 'annual', method: 'card' | 'paynow' = 'card') =>
      request<{ url: string }>('/api/billing/checkout', {
        method: 'POST',
        body: JSON.stringify({ plan, method }),
      }),

    portal: () =>
      request<{ url: string }>('/api/billing/portal', { method: 'POST' }),
  },
}
