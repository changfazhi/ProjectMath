export type MathLevel = 'H1' | 'H2'
export type Difficulty = 1 | 2 | 3
export type AnswerType = 'exact' | 'mcq' | 'range'
export type AttemptStatus = 'not_attempted' | 'attempted' | 'correct'

export interface QuestionPart {
  label: string
  prompt_latex: string
  answer_type: AnswerType | null
  tolerance: number | null
  marks?: number | null
}

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
  name: string | null
  prompt_latex: string
  answer_type: AnswerType | null
  tolerance: number | null
  mcq_options: string[] | null
  parts: QuestionPart[] | null
  marks: number
  source: string | null
  created_at: string
}

export interface QuestionWithStatus extends QuestionPublic {
  status: AttemptStatus
}

export interface TopicConcept {
  id: string
  topic_id: string
  concept: string
  sort_order: number
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
  solution_latex: string | null
}

export interface StarToggleResponse {
  starred: boolean
}

export interface TopicProgress {
  topic_id: string
  correct: number
  total: number
}

export interface TopicAccuracy {
  topic_id: string
  topic_name: string
  questions_solved: number
  questions_total: number
  correct_attempts: number
  total_attempts: number
}

export interface ApiError {
  error: string
  details?: unknown
}

export interface StarredQuestionRow {
  question_id: string
  question_name: string | null
  topic_id: string
  topic_name: string
  starred_at: string
  latest_attempt: {
    attempted_at: string
    is_correct: boolean
    time_taken_s: number | null
  } | null
}

export interface DailyActivity {
  date: string
  correctCount: number
  attemptCount: number
}

export interface StreakStats {
  currentStreak: number
  bestStreak: number
  totalAttempts: number
  totalSolved: number
  totalQuestions: number
  dailyActivity: DailyActivity[]
}

export type ChatRole = 'user' | 'model'

export interface ChatMessage {
  id: string
  role: ChatRole
  content: string
  created_at: string
}

export interface ChatSendResponse {
  reply: ChatMessage
  history: ChatMessage[]
}

// ── Photo-based AI grading ──────────────────────────────────────────────

export type GradingVerdict = 'correct' | 'partial' | 'incorrect'

export interface GradingError {
  step: string
  description: string
}

export interface GradingPartResult {
  label: string
  verdict: GradingVerdict
  marks_awarded: number
  marks_total: number
  errors: GradingError[]
  hints: string[]
  summary: string
}

export interface GradingIgnoredImage {
  index: number
  reason: string
}

export interface GradeResponse {
  grading_id: string
  parts: GradingPartResult[]
  marks_awarded: number
  marks_total: number
  is_correct: boolean
  overall_feedback: string | null
  ignored_images: GradingIgnoredImage[]
  solution_latex: string
  created_at: string
}

export interface Grading {
  id: string
  session_id: string
  question_id: string
  image_paths: string[]
  marks_awarded: number
  marks_total: number
  is_correct: boolean
  parts: GradingPartResult[]
  overall_feedback: string | null
  created_at: string
}

// ── "Upload via phone" QR pairing ───────────────────────────────────────

export interface CreatePairResponse {
  token: string
  mobile_path: string
  expires_at: number
}

export interface PairContext {
  valid: boolean
  question_id: string
  question_name: string | null
}

// ── Spaced-repetition review queue ──────────────────────────────────────────

export type ReviewMode = 'corrections' | 'weak-topics' | 'speed-drills' | 'spaced' | 'random'

export interface ReviewItem {
  question_id: string
  topic_id: string
}

// ── Weakness Diagnostic ──────────────────────────────────────────────────────

export interface TopicDiagnosis {
  topic_id: string
  topic_name: string
  accuracy: number
  questions_attempted: number
  strength_level: 'strong' | 'moderate' | 'weak'
  ai_insight: string
}

export interface DiagnosisResult {
  weak_topics: TopicDiagnosis[]
  moderate_topics: TopicDiagnosis[]
  strong_topics: TopicDiagnosis[]
  overall_summary: string
  generated_at: string
}

export interface StudyPlanItem {
  question_id: string
  topic_id: string
  topic_name: string
  question_name: string | null
}

export interface StudyPlanResponse {
  items: StudyPlanItem[]
  reasoning: string
}
