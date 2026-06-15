import { supabase } from '../db/supabase.js';
import { getQuestionWithSolution } from './questionService.js';
import type { Attempt, QuestionPart, SubmitAttemptBody, SubmitAttemptResponse } from '../types/index.js';

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

  let isCorrect: boolean;
  let correctAnswer: string;

  if (body.part_label) {
    // Multi-part: find the specific part
    const part = question.parts?.find((p: QuestionPart) => p.label === body.part_label);
    if (!part) throw new Error(`Part "${body.part_label}" not found on question ${body.question_id}`);
    if (!part.correct_answer || !part.answer_type) {
      throw new Error(`Part "${body.part_label}" is a show-that part and cannot be submitted`);
    }
    isCorrect = checkAnswer(part.answer_type, part.correct_answer, body.answer_given, part.tolerance);
    correctAnswer = part.correct_answer;
  } else {
    // Single-answer question
    isCorrect = checkAnswer(
      question.answer_type,
      question.correct_answer,
      body.answer_given,
      question.tolerance,
    );
    correctAnswer = question.correct_answer;
  }

  const { data, error } = await supabase
    .from('attempts')
    .insert({
      session_id: body.session_id,
      question_id: body.question_id,
      part_label: body.part_label ?? null,
      answer_given: body.answer_given,
      is_correct: isCorrect,
      time_taken_s: body.time_taken_s ?? null,
    })
    .select('id')
    .single();

  if (error) throw new Error(error.message);

  // Determine whether to reveal solution
  let solutionLatex: string | null = null;

  if (!body.part_label) {
    // Single-answer: always reveal
    solutionLatex = question.solution_latex;
  } else {
    // Multi-part: reveal when all graded parts have been submitted
    const gradedParts = (question.parts ?? []).filter((p: QuestionPart) => p.correct_answer !== null);
    const gradedLabels = new Set(gradedParts.map((p: QuestionPart) => p.label));

    const { data: existingAttempts } = await supabase
      .from('attempts')
      .select('part_label')
      .eq('session_id', body.session_id)
      .eq('question_id', body.question_id)
      .not('part_label', 'is', null);

    const submittedLabels = new Set((existingAttempts ?? []).map((a: { part_label: string }) => a.part_label));
    const allDone = [...gradedLabels].every((lbl) => submittedLabels.has(lbl));
    if (allDone) solutionLatex = question.solution_latex;
  }

  return {
    attempt_id: (data as Attempt).id,
    is_correct: isCorrect,
    correct_answer: correctAnswer,
    solution_latex: solutionLatex,
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
