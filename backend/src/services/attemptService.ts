import { evaluate } from 'mathjs';
import { supabase } from '../db/supabase.js';
import { getQuestionWithSolution } from './questionService.js';
import { upsertSRCard } from './spacedRepetitionService.js';
import type { Attempt, QuestionPart, SubmitAttemptBody, SubmitAttemptResponse } from '../types/index.js';

function normalizeLaTeX(s: string): string {
  return s
    .replace(/\s+/g, '')
    .replace(/\\,/g, '')
    .replace(/\\ /g, '')
    .replace(/\\;/g, '')
    .replace(/\\:/g, '')
    .replace(/\\!/g, '')
    .replace(/\\quad/g, '')
    .replace(/\\qquad/g, '')
    .replace(/\\mleft/g, '\\left')
    .replace(/\\mright/g, '\\right')
    // Expand compact MathLive fractions: \frac13 → \frac{1}{3}
    .replace(/\\frac([^{\\])([^{\\])/g, '\\frac{$1}{$2}')
    .replace(/\\frac([^{\\])\{/g, '\\frac{$1}{')
    .replace(/\\frac\{([^}]+)\}([^{\\])/g, '\\frac{$1}{$2}')
    .toLowerCase()
    .replace(/\\text\{or\}/g, 'or')
    .replace(/\\text\{and\}/g, 'and')
    .replace(/\\lor\b/g, 'or')
    .replace(/\\land\b/g, 'and')
    .replace(/\\operatorname\{or\}/g, 'or')
    .replace(/\\operatorname\{and\}/g, 'and');
}

function latexToMathExpr(normalized: string): string {
  return normalized
    .replace(/\\frac\{([^}]+)\}\{([^}]+)\}/g, '($1)/($2)')
    .replace(/\\sqrt\{([^}]+)\}/g, 'sqrt($1)')
    .replace(/\\pi/g, 'pi')
    .replace(/\\ln\b/g, 'log')    // mathjs log() = natural log
    .replace(/\\log\b/g, 'log10') // \log = base-10 in SG H2
    .replace(/\\cdot/g, '*')
    .replace(/\\times/g, '*')
    .replace(/\\left[\(\[]/g, '(')
    .replace(/\\right[\)\]]/g, ')')
    .replace(/\{/g, '(')
    .replace(/\}/g, ')')
    .replace(/\\/g, '');
}

function tryNumericEval(raw: string): number | null {
  try {
    const result = evaluate(latexToMathExpr(normalizeLaTeX(raw))) as unknown;
    if (typeof result === 'number' && isFinite(result)) return result;
    return null;
  } catch {
    return null;
  }
}

// Multi-point symbolic evaluation: substitute random values for variables and check
// if both expressions agree. Handles commutativity and algebraic equivalences.
function trySymbolicEval(given: string, correct: string): boolean {
  const givenExpr = latexToMathExpr(normalizeLaTeX(given));
  const correctExpr = latexToMathExpr(normalizeLaTeX(correct));

  // Extract single-letter variables, skipping mathjs constants e and i
  const varRe = /\b([a-df-hj-z])\b/g;
  const vars = new Set([
    ...[...givenExpr.matchAll(varRe)].map((m) => m[1]),
    ...[...correctExpr.matchAll(varRe)].map((m) => m[1]),
  ]);
  if (vars.size === 0) return false;

  const primes = [2, 3, 5, 7, 11, 13, 17, 19];
  const scope1: Record<string, number> = {};
  const scope2: Record<string, number> = {};
  let idx = 0;
  for (const v of vars) {
    scope1[v] = primes[idx % primes.length];
    scope2[v] = primes[(idx + 4) % primes.length];
    idx++;
  }

  try {
    const g1 = evaluate(givenExpr, scope1) as unknown;
    const c1 = evaluate(correctExpr, scope1) as unknown;
    if (typeof g1 !== 'number' || typeof c1 !== 'number' || !isFinite(g1) || !isFinite(c1)) return false;
    if (Math.abs(g1 - c1) > 1e-9 * (Math.abs(c1) + 1)) return false;

    const g2 = evaluate(givenExpr, scope2) as unknown;
    const c2 = evaluate(correctExpr, scope2) as unknown;
    if (typeof g2 !== 'number' || typeof c2 !== 'number' || !isFinite(g2) || !isFinite(c2)) return false;
    return Math.abs(g2 - c2) <= 1e-9 * (Math.abs(c2) + 1);
  } catch {
    return false;
  }
}

function checkAnswer(
  answerType: string,
  correctAnswer: string,
  givenAnswer: string,
  tolerance: number | null,
): boolean {
  switch (answerType) {
    case 'exact':
    case 'mcq': {
      if (normalizeLaTeX(givenAnswer) === normalizeLaTeX(correctAnswer)) return true;
      const given = tryNumericEval(givenAnswer);
      const correct = tryNumericEval(correctAnswer);
      if (given !== null && correct !== null) return Math.abs(given - correct) < 1e-9;
      return trySymbolicEval(givenAnswer, correctAnswer);
    }

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

export async function submitAttempt(userId: string, body: SubmitAttemptBody): Promise<SubmitAttemptResponse> {
  const question = await getQuestionWithSolution(body.question_id);
  if (!question) throw new Error(`Question ${body.question_id} not found`);

  let isCorrect: boolean;
  let correctAnswer: string;

  if (body.part_label) {
    // Multi-part: find the specific part
    const part = question.parts?.find((p: QuestionPart) => p.label === body.part_label);
    if (!part) throw new Error(`Part "${body.part_label}" not found on question ${body.question_id}`);

    if (part.answers && part.answers.length > 0) {
      // Multi-box part: grade each field independently; correct only if all match.
      const submitted = new Map((body.field_answers ?? []).map((f) => [f.key, f.value]));
      isCorrect = part.answers.every((field) => {
        const given = submitted.get(field.key);
        if (given === undefined) return false;
        return checkAnswer(field.answer_type, field.correct_answer, given, field.tolerance);
      });
      correctAnswer = part.answers.map((field) => `${field.label} = ${field.correct_answer}`).join(',\\ ');
    } else {
      if (!part.correct_answer || !part.answer_type) {
        throw new Error(`Part "${body.part_label}" is a show-that part and cannot be submitted`);
      }
      isCorrect = checkAnswer(part.answer_type, part.correct_answer, body.answer_given, part.tolerance);
      correctAnswer = part.correct_answer;
    }
  } else {
    // Single-answer question
    if (!question.answer_type) {
      // Show-that question: auto-correct, no grading needed
      isCorrect = true;
    } else {
      isCorrect = checkAnswer(
        question.answer_type,
        question.correct_answer,
        body.answer_given,
        question.tolerance,
      );
    }
    correctAnswer = question.correct_answer;
  }

  const { data, error } = await supabase
    .from('attempts')
    .insert({
      session_id: userId,
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
      .eq('session_id', userId)
      .eq('question_id', body.question_id)
      .not('part_label', 'is', null);

    const submittedLabels = new Set((existingAttempts ?? []).map((a: { part_label: string }) => a.part_label));
    const allDone = [...gradedLabels].every((lbl) => submittedLabels.has(lbl));
    if (allDone) solutionLatex = question.solution_latex;
  }

  // Update SM-2 spaced-repetition card when the question is complete (solution revealed).
  // Fire-and-forget — never blocks the attempt response.
  if (solutionLatex !== null) {
    upsertSRCard(userId, body.question_id, question.topic_id, isCorrect).catch(() => {
      // Non-critical; SR state will self-correct on next attempt.
    });
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
    .select('*, questions(name)')
    .eq('session_id', sessionId)
    .order('attempted_at', { ascending: false });

  if (questionId) {
    query = query.eq('question_id', questionId);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);

  // Flatten the embedded question name onto each attempt row.
  return (data ?? []).map((row) => {
    const { questions, ...rest } = row as Record<string, unknown> & {
      questions: { name: string | null } | { name: string | null }[] | null;
    };
    const q = Array.isArray(questions) ? questions[0] : questions;
    return { ...rest, question_name: q?.name ?? null } as Attempt;
  });
}
