import { supabase } from '../db/supabase.js';
import type { AttemptStatus, Difficulty, Question, QuestionPublic, QuestionWithStatus } from '../types/index.js';

function stripSolution(q: Question): QuestionPublic {
  const { correct_answer: _ca, solution_latex: _sl, ...pub } = q;
  return pub;
}

export async function getNextQuestion(
  topicId: string,
  sessionId: string,
  difficulty?: Difficulty,
): Promise<QuestionPublic | null> {
  let query = supabase
    .from('questions')
    .select('*')
    .eq('topic_id', topicId);

  if (difficulty) {
    query = query.eq('difficulty', difficulty);
  }

  const { data: questions, error } = await query;
  if (error) throw new Error(error.message);
  if (!questions || questions.length === 0) return null;

  const { data: correctAttempts } = await supabase
    .from('attempts')
    .select('question_id')
    .eq('session_id', sessionId)
    .eq('is_correct', true)
    .in('question_id', questions.map((q) => q.id));

  const answeredCorrectly = new Set((correctAttempts ?? []).map((a) => a.question_id));

  const pool = questions.filter((q) => !answeredCorrectly.has(q.id));
  const candidates = pool.length > 0 ? pool : questions;

  const picked = candidates[Math.floor(Math.random() * candidates.length)] as Question;
  return stripSolution(picked);
}

export async function getQuestionById(id: string): Promise<QuestionPublic | null> {
  const { data, error } = await supabase
    .from('questions')
    .select('*')
    .eq('id', id)
    .single();

  if (error) {
    if (error.code === 'PGRST116') return null;
    throw new Error(error.message);
  }
  return stripSolution(data as Question);
}

// Only called after a confirmed attempt — returns the full question including solution
export async function getQuestionWithSolution(id: string): Promise<Question | null> {
  const { data, error } = await supabase
    .from('questions')
    .select('*')
    .eq('id', id)
    .single();

  if (error) {
    if (error.code === 'PGRST116') return null;
    throw new Error(error.message);
  }
  return data as Question;
}

export async function getQuestionsByTopicWithStatus(
  topicId: string,
  sessionId: string,
): Promise<QuestionWithStatus[]> {
  const { data: questions, error } = await supabase
    .from('questions')
    .select('*')
    .eq('topic_id', topicId)
    .order('difficulty')
    .order('created_at');

  if (error) throw new Error(error.message);
  if (!questions || questions.length === 0) return [];

  const questionIds = questions.map((q) => q.id);

  const { data: attempts } = await supabase
    .from('attempts')
    .select('question_id, is_correct')
    .eq('session_id', sessionId)
    .in('question_id', questionIds);

  // Per question: track if any attempt exists and if any is correct
  const anyAttempt = new Set<string>();
  const anyCorrect = new Set<string>();
  for (const a of attempts ?? []) {
    anyAttempt.add(a.question_id);
    if (a.is_correct) anyCorrect.add(a.question_id);
  }

  return questions.map((q) => {
    const pub = stripSolution(q as Question);
    let status: AttemptStatus = 'not_attempted';
    if (anyCorrect.has(q.id)) status = 'correct';
    else if (anyAttempt.has(q.id)) status = 'attempted';
    return { ...pub, status };
  });
}
