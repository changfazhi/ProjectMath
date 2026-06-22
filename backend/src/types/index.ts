export type MathLevel = 'H1' | 'H2';
export type Difficulty = 1 | 2 | 3;
export type AnswerType = 'exact' | 'mcq' | 'range';
export type AttemptStatus = 'not_attempted' | 'attempted' | 'correct';

export interface QuestionPart {
  label: string;
  prompt_latex: string;
  correct_answer: string | null;
  answer_type: AnswerType | null;
  tolerance: number | null;
}

export type QuestionPartPublic = Omit<QuestionPart, 'correct_answer'>;

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
  answer_given: string;
  is_correct: boolean;
  time_taken_s: number | null;
  attempted_at: string;
}

export interface SubmitAttemptBody {
  session_id: string;
  question_id: string;
  part_label?: string;
  answer_given: string;
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
  total: number;
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
