import type {
  Attempt,
  BillingStatus,
  ChatSendResponse,
  ChatThreadResponse,
  CreatePairResponse,
  DiagnosisStatus,
  Difficulty,
  FeedbackRequest,
  Grading,
  GradeResponse,
  MathLevel,
  PairContext,
  QuestionPublic,
  SolutionGraphRender,
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
  UsageSummary,
} from '../types/api'
import { auth } from './firebase'

// Typed API error — carries the structured quota fields from 429 QUOTA_EXCEEDED
// responses so call sites can show a countdown / upgrade CTA. Extends Error, so
// existing `.message` consumers keep working.
export class ApiError extends Error {
  readonly status: number
  readonly code?: string
  readonly quota?: string
  readonly resetAt?: string
  readonly upgradeable?: boolean

  constructor(
    message: string,
    status: number,
    code?: string,
    quota?: string,
    resetAt?: string,
    upgradeable?: boolean,
  ) {
    super(message)
    this.name = 'ApiError'
    this.status = status
    this.code = code
    this.quota = quota
    this.resetAt = resetAt
    this.upgradeable = upgradeable
  }
}

interface ErrorBody {
  error?: string
  code?: string
  quota?: string
  reset_at?: string
  upgradeable?: boolean
}

async function throwApiError(res: Response): Promise<never> {
  const body = (await res.json().catch(() => ({ error: res.statusText }))) as ErrorBody
  throw new ApiError(
    body.error ?? res.statusText,
    res.status,
    body.code,
    body.quota,
    body.reset_at,
    body.upgradeable,
  )
}

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
    await throwApiError(res)
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
    await throwApiError(res)
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
      request<{ solution_latex: string | null; graphs?: SolutionGraphRender[] }>(
        `/api/questions/${id}/solution`,
      ),
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
    // Starts a fresh conversation scope — never returns past messages (the hint chat
    // resets on every open: refresh, reopen, new tab, new device).
    startThread: (questionId: string) =>
      request<ChatThreadResponse>(`/api/chat?question_id=${questionId}`),

    send: (questionId: string, threadId: string, message: string) =>
      request<ChatSendResponse>('/api/chat', {
        method: 'POST',
        body: JSON.stringify({ question_id: questionId, thread_id: threadId, message }),
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
    diagnosis: () => request<DiagnosisStatus>('/api/review/diagnosis'),
    generateDiagnosis: () =>
      request<DiagnosisStatus>('/api/review/diagnosis', { method: 'POST' }),
    studyPlan: () => request<StudyPlanResponse>('/api/review/study-plan'),
  },

  usage: {
    get: () => request<UsageSummary>('/api/usage'),
  },

  billing: {
    checkout: (plan: 'monthly' | 'semesterly', method: 'card' | 'paynow' = 'card') =>
      request<{ url: string }>('/api/billing/checkout', {
        method: 'POST',
        body: JSON.stringify({ plan, method }),
      }),

    portal: () =>
      request<{ url: string }>('/api/billing/portal', { method: 'POST' }),

    status: () => request<BillingStatus>('/api/billing/status'),
  },

  feedback: {
    send: (body: FeedbackRequest) =>
      request<{ ok: boolean }>('/api/feedback', {
        method: 'POST',
        body: JSON.stringify(body),
      }),
  },
}
