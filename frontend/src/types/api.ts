export type MathLevel = 'H1' | 'H2'
export type Difficulty = 1 | 2 | 3
export type AnswerType = 'exact' | 'mcq' | 'range'

export interface Topic {
  id: string
  name: string
  level: MathLevel
  parent_topic_id: string | null
  created_at: string
}

export interface QuestionPublic {
  id: string
  topic_id: string
  difficulty: Difficulty
  prompt_latex: string
  answer_type: AnswerType
  tolerance: number | null
  mcq_options: string[] | null
  marks: number
  source: string | null
  created_at: string
}

export interface Attempt {
  id: string
  session_id: string
  question_id: string
  answer_given: string
  is_correct: boolean
  time_taken_s: number | null
  attempted_at: string
}

export interface SubmitAttemptResponse {
  attempt_id: string
  is_correct: boolean
  correct_answer: string
  solution_latex: string
}

export interface ApiError {
  error: string
  details?: unknown
}
