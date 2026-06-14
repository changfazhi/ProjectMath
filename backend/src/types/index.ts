export type MathLevel = 'H1' | 'H2';
export type Difficulty = 1 | 2 | 3;
export type AnswerType = 'exact' | 'mcq' | 'range';
export type AttemptStatus = 'not_attempted' | 'attempted' | 'correct';

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
  solution_latex: string;
  marks: number;
  source: string | null;
  created_at: string;
}

// Question shape returned to client — solution is omitted until after attempt
export type QuestionPublic = Omit<Question, 'correct_answer' | 'solution_latex'>;

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
  answer_given: string;
  time_taken_s?: number;
}

export interface SubmitAttemptResponse {
  attempt_id: string;
  is_correct: boolean;
  correct_answer: string;
  solution_latex: string;
}

export interface TopicProgress {
  topic_id: string;
  correct: number;
  total: number;
}
