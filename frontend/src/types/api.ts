export type MathLevel = 'H1' | 'H2'
export type Difficulty = 1 | 2 | 3
export type AnswerType = 'exact' | 'mcq' | 'range'
export type AttemptStatus = 'not_attempted' | 'attempted' | 'correct'

export interface PartAnswerField {
  key: string
  label: string
  answer_type: AnswerType
  tolerance: number | null
}

export interface QuestionPart {
  label: string
  prompt_latex: string
  answer_type: AnswerType | null
  tolerance: number | null
  marks?: number | null
  // When present, render one box per field (e.g. "find a, b and c").
  answers?: PartAnswerField[] | null
}

// Compiled model sketch for a sketch part, served by the solution endpoint.
// Expression-free: the backend samples curves into polylines (mirrors the
// backend's SolutionGraphRender).
export interface GraphPoint {
  x: number
  y: number
  label?: string | null
  kind?: 'min' | 'max' | 'intercept' | 'inflection' | 'point' | null
  open?: boolean
}

export interface RenderedAsymptote {
  kind: 'vertical' | 'horizontal' | 'oblique'
  x?: number
  points?: [number, number][]
  label?: string | null
}

export interface GraphSegment {
  from: [number, number]
  to: [number, number]
  label?: string | null
  style?: 'solid' | 'dashed' | null
  arrow?: boolean
}

export interface SolutionGraphRender {
  part_label: string
  x_range: [number, number]
  y_range: [number, number]
  curves: { segments: [number, number][][]; label?: string | null }[]
  asymptotes: RenderedAsymptote[]
  points: GraphPoint[]
  segments: GraphSegment[]
  shade: { polygon: [number, number][]; label?: string | null }[]
  x_label?: string | null
  y_label?: string | null
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
  question_name: string | null
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
  attempted: number
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
  uniqueQuestionsAttempted: number
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

// Returned by GET /api/chat — a fresh conversation scope, never past history.
export interface ChatThreadResponse {
  thread_id: string
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
  transcription_latex: string // Gemini's transcription of the working — editable for re-grade
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
  transcription_latex: string | null
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

// Persisted diagnosis + regeneration cooldown (daily for paid, weekly for free).
export interface DiagnosisStatus {
  diagnosis: DiagnosisResult | null
  generated_at: string | null
  can_generate: boolean
  next_allowed_at: string | null
}

export type QuestStatus = 'correct' | 'attempted' | 'pending'

export interface StudyPlanItem {
  question_id: string
  topic_id: string
  topic_name: string
  question_name: string | null
}

export interface StudyPlanResponse {
  items: StudyPlanItem[]
  reasoning: string
  date: string        // SGT date the plan was generated (YYYY-MM-DD)
  valid_until: string // first SGT date the plan is stale (paid: next day; free: +7 days)
}

// ── Daily usage quotas (GET /api/usage) ──────────────────────────────────────

export interface UsageBucket {
  used: number
  limit: number | null // null = unlimited (paid)
  remaining: number | null
}

export interface UsageSummary {
  tier: 'free' | 'paid'
  resets_at: string // next SGT midnight, ISO
  scans: UsageBucket
  chat: UsageBucket
}

// ── Billing status (GET /api/billing/status) ──────────────────────────────────

export interface BillingStatus {
  subscriptionStatus: string | null
  accessExpiresAt: string | null // PayNow: stored expiry, no auto-renewal
  renewsAt: string | null // Card: live current_period_end, auto-renews
}

// ── Feedback (POST /api/feedback) ─────────────────────────────────────────────

export type FeedbackCategory = 'bug' | 'idea' | 'question' | 'other'

export interface FeedbackRequest {
  message: string
  category?: FeedbackCategory
  page?: string
}
