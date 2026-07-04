export type MathLevel = 'H1' | 'H2';
export type Difficulty = 1 | 2 | 3;
export type AnswerType = 'exact' | 'mcq' | 'range';
export type AttemptStatus = 'not_attempted' | 'attempted' | 'correct';

// One graded input box. A part with several of these renders multiple boxes
// (e.g. "find a, b and c") that are graded independently.
export interface PartAnswerField {
  key: string;          // stable identifier used to match the submitted value
  label: string;        // shown beside the box, e.g. "a", "|p|", "arg(p)"
  correct_answer: string;
  answer_type: AnswerType;
  tolerance: number | null;
}

export type PartAnswerFieldPublic = Omit<PartAnswerField, 'correct_answer'>;

// --- Model sketch for graph questions ---------------------------------------
// Authored spec stored in parts[].solution_graph. `expr` is mathjs syntax and is
// evaluated ONLY on the server (compiled to polylines before reaching a client).

export interface GraphCurve {
  expr: string;
  domain: [number, number];
  label?: string | null;
}

export interface GraphAsymptote {
  kind: 'vertical' | 'horizontal' | 'oblique';
  x?: number; // vertical only
  expr?: string; // horizontal/oblique only, e.g. "x" or "8"
  label?: string | null;
}

export interface GraphPoint {
  x: number;
  y: number;
  label?: string | null;
  kind?: 'min' | 'max' | 'intercept' | 'inflection' | 'point' | null;
}

export interface SolutionGraphSpec {
  x_range: [number, number];
  y_range: [number, number];
  curves: GraphCurve[];
  asymptotes?: GraphAsymptote[] | null;
  points?: GraphPoint[] | null;
}

// Compiled, expression-free render data sent to the client after reveal.
export interface RenderedAsymptote {
  kind: 'vertical' | 'horizontal' | 'oblique';
  x?: number;
  points?: [number, number][];
  label?: string | null;
}

export interface SolutionGraphRender {
  part_label: string;
  x_range: [number, number];
  y_range: [number, number];
  curves: { segments: [number, number][][]; label?: string | null }[];
  asymptotes: RenderedAsymptote[];
  points: GraphPoint[];
}

export interface QuestionPart {
  label: string;
  prompt_latex: string;
  correct_answer: string | null;
  answer_type: AnswerType | null;
  tolerance: number | null;
  marks?: number | null;
  // When present, this part renders one box per field instead of a single box.
  // The part-level answer_type/correct_answer stay non-null sentinels so the
  // existing "graded part" / "reveal when all done" logic still counts it.
  answers?: PartAnswerField[] | null;
  // Model sketch for sketch parts — part of the solution, stripped from the
  // public question payload and served compiled via the solution endpoint.
  solution_graph?: SolutionGraphSpec | null;
}

export type QuestionPartPublic = Omit<QuestionPart, 'correct_answer' | 'answers' | 'solution_graph'> & {
  answers?: PartAnswerFieldPublic[] | null;
};

export interface Topic {
  id: string;
  name: string;
  level: MathLevel;
  parent_topic_id: string | null;
  created_at: string;
}

export interface Question {
  id: string;
  topic_id: string;
  difficulty: Difficulty;
  name: string | null;
  prompt_latex: string;
  answer_type: AnswerType;
  correct_answer: string;
  tolerance: number | null;
  mcq_options: string[] | null;
  parts: QuestionPart[] | null;
  solution_latex: string;
  marks: number;
  source: string | null;
  created_at: string;
}

// Question shape returned to client — solution and answers omitted until after attempt
export type QuestionPublic = Omit<Question, 'correct_answer' | 'solution_latex' | 'parts'> & {
  parts: QuestionPartPublic[] | null;
};

// Question with per-session attempt status, returned from the topic question list endpoint
export interface QuestionWithStatus extends QuestionPublic {
  status: AttemptStatus;
}

export interface TopicConcept {
  id: string;
  topic_id: string;
  concept: string;
  sort_order: number;
  created_at: string;
}

export interface StarredQuestion {
  id: string;
  session_id: string;
  question_id: string;
  starred_at: string;
}

export interface Attempt {
  id: string;
  session_id: string;
  question_id: string;
  question_name: string | null;
  answer_given: string;
  is_correct: boolean;
  time_taken_s: number | null;
  attempted_at: string;
}

export interface SubmitAttemptBody {
  question_id: string;
  part_label?: string;
  answer_given: string;
  // For multi-box parts: the per-field values keyed by PartAnswerField.key.
  field_answers?: { key: string; value: string }[];
  time_taken_s?: number;
}

export interface SubmitAttemptResponse {
  attempt_id: string;
  is_correct: boolean;
  correct_answer: string;
  solution_latex: string | null;
}

export interface TopicProgress {
  topic_id: string;
  correct: number;
  attempted: number;
  total: number;
}

export interface TopicAccuracy {
  topic_id: string;
  topic_name: string;
  questions_solved: number;
  questions_total: number;
  correct_attempts: number;
  total_attempts: number;
}

export type ChatRole = 'user' | 'model';

export interface ChatMessage {
  id: string;
  session_id: string;
  question_id: string;
  role: ChatRole;
  content: string;
  created_at: string;
}

// Chat message shape returned to client (no session_id/question_id needed)
export type ChatMessagePublic = Pick<ChatMessage, 'id' | 'role' | 'content' | 'created_at'>;

export interface ChatSendResponse {
  reply: ChatMessagePublic;
  history: ChatMessagePublic[];
}

// ── Photo-based AI grading ──────────────────────────────────────────────

export type GradingVerdict = 'correct' | 'partial' | 'incorrect';

export interface GradingError {
  step: string;        // where the mistake happened, e.g. "Line 3, integration by parts"
  description: string; // what went wrong
}

export interface GradingPartResult {
  label: string;       // detected part label, or "whole" for single-part questions
  verdict: GradingVerdict;
  marks_awarded: number;
  marks_total: number;
  errors: GradingError[];
  hints: string[];
  summary: string;
}

// A photo the grader discarded as irrelevant (blank page, unrelated object, wrong question).
export interface GradingIgnoredImage {
  index: number; // 1-based photo number
  reason: string;
}

// Structured grade returned by Gemini (before totals/persistence are computed).
export interface GradingAiOutput {
  gradable: boolean; // false → no photo contains meaningful working for this question
  rejection_reason: string; // student-facing reason when not gradable (empty otherwise)
  ignored_images: GradingIgnoredImage[];
  parts: GradingPartResult[];
  overall_feedback: string;
  // Faithful LaTeX transcription of the student's handwritten working + answer, so the
  // student can review/correct mis-scans and re-grade. Mixed text+math with \( \) / \[ \].
  transcription_latex: string;
}

export interface Grading {
  id: string;
  session_id: string;
  question_id: string;
  image_paths: string[];
  marks_awarded: number;
  marks_total: number;
  is_correct: boolean;
  parts: GradingPartResult[];
  overall_feedback: string | null;
  transcription_latex: string | null; // null for rows graded before this feature existed
  created_at: string;
}

export interface GradeImage {
  mimeType: string;
  buffer: Buffer;
}

export interface GradeSolutionParams {
  userId: string;
  question_id: string;
  images: GradeImage[];
  time_taken_s?: number;
}

// Re-grade from the student's (edited) typed LaTeX instead of photos.
export interface GradeTranscriptionParams {
  userId: string;
  question_id: string;
  transcription_latex: string;
  time_taken_s?: number;
}

export interface GradeResponse {
  grading_id: string;
  parts: GradingPartResult[];
  marks_awarded: number;
  marks_total: number;
  is_correct: boolean;
  overall_feedback: string | null;
  ignored_images: GradingIgnoredImage[];
  solution_latex: string;
  transcription_latex: string;
  created_at: string;
}

// ── "Upload via phone" QR pairing ───────────────────────────────────────

// Ephemeral pairing handshake — held in memory only, never persisted.
export interface PairSession {
  token: string;
  userId: string;
  question_id: string;
  images: GradeImage[];
  created_at: number; // epoch ms
  expires_at: number; // epoch ms
}

export interface CreatePairResponse {
  token: string;
  mobile_path: string; // e.g. "/m/<token>" — desktop prefixes its own origin for the QR
  expires_at: number;
}

// Minimal, secret-free context the mobile page fetches to render itself.
export interface PairContext {
  valid: boolean;
  question_id: string;
  question_name: string | null;
}
