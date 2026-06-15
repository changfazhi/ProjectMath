import { supabase } from '../db/supabase.js';
import { getQuestionWithSolution } from './questionService.js';
import type { Attempt, SubmitAttemptBody, SubmitAttemptResponse } from '../types/index.js';

function normalizeLaTeX(s: string): string {
  return s
    .replace(/\s+/g, '')
    .replace(/\\mleft/g, '\\left')
    .replace(/\\mright/g, '\\right')
    // Expand compact MathLive fractions: \frac13 → \frac{1}{3}
    .replace(/\\frac([^{\\])([^{\\])/g, '\\frac{$1}{$2}')
    .replace(/\\frac([^{\\])\{/g, '\\frac{$1}{')
    .replace(/\\frac\{([^}]+)\}([^{\\])/g, '\\frac{$1}{$2}')
    .toLowerCase();
}

function checkAnswer(
  answerType: string,
  correctAnswer: string,
  givenAnswer: string,
  tolerance: number | null,
): boolean {
  switch (answerType) {
    case 'exact':
    case 'mcq':
      return normalizeLaTeX(givenAnswer) === normalizeLaTeX(correctAnswer);

    case 'range': {
      const givenNum = parseFloat(givenAnswer.trim());
      const correctNum = parseFloat(correctAnswer.trim());
      if (isNaN(givenNum) || isNaN(correctNum)) return false;
      return Math.abs(givenNum - correctNum) <= (tolerance ?? 0.01);
    }

    default:
      return false;
  }
}

export async function submitAttempt(body: SubmitAttemptBody): Promise<SubmitAttemptResponse> {
  const question = await getQuestionWithSolution(body.question_id);
  if (!question) throw new Error(`Question ${body.question_id} not found`);

  const isCorrect = checkAnswer(
    question.answer_type,
    question.correct_answer,
    body.answer_given,
    question.tolerance,
  );

  const { data, error } = await supabase
    .from('attempts')
    .insert({
      session_id: body.session_id,
      question_id: body.question_id,
      answer_given: body.answer_given,
      is_correct: isCorrect,
      time_taken_s: body.time_taken_s ?? null,
    })
    .select('id')
    .single();

  if (error) throw new Error(error.message);

  return {
    attempt_id: (data as Attempt).id,
    is_correct: isCorrect,
    correct_answer: question.correct_answer,
    solution_latex: question.solution_latex,
  };
}

export async function getAttemptsBySession(
  sessionId: string,
  questionId?: string,
): Promise<Attempt[]> {
  let query = supabase
    .from('attempts')
    .select('*')
    .eq('session_id', sessionId)
    .order('attempted_at', { ascending: false });

  if (questionId) {
    query = query.eq('question_id', questionId);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return data as Attempt[];
}
