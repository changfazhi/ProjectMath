import type {
  Attempt,
  ChatMessage,
  ChatSendResponse,
  CreatePairResponse,
  Difficulty,
  Grading,
  GradeResponse,
  MathLevel,
  PairContext,
  QuestionPublic,
  QuestionWithStatus,
  StarredQuestionRow,
  StarToggleResponse,
  StreakStats,
  SubmitAttemptResponse,
  Topic,
  TopicConcept,
  TopicProgress,
} from '../types/api'

async function request<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(path, {
    headers: { 'Content-Type': 'application/json' },
    ...init,
  })
  if (!res.ok) {
    const body = await res.json().catch(() => ({ error: res.statusText }))
    throw new Error((body as { error?: string }).error ?? res.statusText)
  }
  return res.json() as Promise<T>
}

// For multipart uploads — no Content-Type header so the browser sets the boundary.
async function requestFormData<T>(path: string, formData: FormData): Promise<T> {
  const res = await fetch(path, { method: 'POST', body: formData })
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

    questions: (topicId: string, sessionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId })
      return request<QuestionWithStatus[]>(`/api/topics/${topicId}/questions?${params}`)
    },

    concepts: (topicId: string) =>
      request<TopicConcept[]>(`/api/topics/${topicId}/concepts`),

    progress: (sessionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId })
      return request<TopicProgress[]>(`/api/topics/progress?${params}`)
    },
  },

  questions: {
    next: (topicId: string, sessionId: string, difficulty?: Difficulty) => {
      const params = new URLSearchParams({ session_id: sessionId })
      if (difficulty !== undefined) params.set('difficulty', String(difficulty))
      return request<QuestionPublic>(`/api/topics/${topicId}/next?${params}`)
    },

    get: (id: string) => request<QuestionPublic>(`/api/questions/${id}`),

    solution: (id: string) =>
      request<{ solution_latex: string | null }>(`/api/questions/${id}/solution`),
  },

  attempts: {
    submit: (body: {
      session_id: string
      question_id: string
      part_label?: string
      answer_given: string
      time_taken_s?: number
    }) =>
      request<SubmitAttemptResponse>('/api/attempts', {
        method: 'POST',
        body: JSON.stringify(body),
      }),

    list: (sessionId: string, questionId?: string) => {
      const params = new URLSearchParams({ session_id: sessionId })
      if (questionId) params.set('question_id', questionId)
      return request<Attempt[]>(`/api/attempts?${params}`)
    },
  },

  stars: {
    toggle: (sessionId: string, questionId: string) =>
      request<StarToggleResponse>('/api/stars', {
        method: 'POST',
        body: JSON.stringify({ session_id: sessionId, question_id: questionId }),
      }),

    list: (sessionId: string, topicId: string) => {
      const params = new URLSearchParams({ session_id: sessionId, topic_id: topicId })
      return request<string[]>(`/api/stars?${params}`)
    },

    listAll: (sessionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId })
      return request<StarredQuestionRow[]>(`/api/stars/all?${params}`)
    },
  },

  streaks: {
    get: (sessionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId })
      return request<StreakStats>(`/api/streaks?${params}`)
    },
  },

  chat: {
    history: (sessionId: string, questionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId, question_id: questionId })
      return request<ChatMessage[]>(`/api/chat?${params}`)
    },

    send: (sessionId: string, questionId: string, message: string) =>
      request<ChatSendResponse>('/api/chat', {
        method: 'POST',
        body: JSON.stringify({ session_id: sessionId, question_id: questionId, message }),
      }),
  },

  grade: {
    submit: (
      sessionId: string,
      questionId: string,
      images: File[],
      timeTakenS?: number,
    ) => {
      const fd = new FormData()
      fd.append('session_id', sessionId)
      fd.append('question_id', questionId)
      if (timeTakenS !== undefined) fd.append('time_taken_s', String(timeTakenS))
      for (const img of images) fd.append('images', img)
      return requestFormData<GradeResponse>('/api/grade', fd)
    },

    history: (sessionId: string, questionId: string) => {
      const params = new URLSearchParams({ session_id: sessionId, question_id: questionId })
      return request<Grading[]>(`/api/grade?${params}`)
    },
  },

  pair: {
    create: (sessionId: string, questionId: string) =>
      request<CreatePairResponse>('/api/pair', {
        method: 'POST',
        body: JSON.stringify({ session_id: sessionId, question_id: questionId }),
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
}
