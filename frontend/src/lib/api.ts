import type {
  Attempt,
  Difficulty,
  MathLevel,
  QuestionPublic,
  SubmitAttemptResponse,
  Topic,
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

export const api = {
  topics: {
    list: (level?: MathLevel) =>
      request<Topic[]>(`/api/topics${level ? `?level=${level}` : ''}`),

    get: (id: string) => request<Topic>(`/api/topics/${id}`),
  },

  questions: {
    next: (topicId: string, sessionId: string, difficulty?: Difficulty) => {
      const params = new URLSearchParams({ session_id: sessionId })
      if (difficulty !== undefined) params.set('difficulty', String(difficulty))
      return request<QuestionPublic>(`/api/topics/${topicId}/next?${params}`)
    },

    get: (id: string) => request<QuestionPublic>(`/api/questions/${id}`),
  },

  attempts: {
    submit: (body: {
      session_id: string
      question_id: string
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
}
