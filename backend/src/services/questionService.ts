import { supabase } from '../db/supabase.js';
import type { Difficulty, Question, QuestionPublic } from '../types/index.js';

function stripSolution(q: Question): QuestionPublic {
  const { correct_answer: _ca, solution_latex: _sl, ...pub } = q;
  return pub;
}

export async function getNextQuestion(
  topicId: string,
  sessionId: string,
  difficulty?: Difficulty,
): Promise<QuestionPublic | null> {
  // Fetch all questions for this topic (optionally filtered by difficulty)
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

  // Get IDs already answered correctly by this session
  const { data: correctAttempts } = await supabase
    .from('attempts')
    .select('question_id')
    .eq('session_id', sessionId)
    .eq('is_correct', true)
    .in('question_id', questions.map((q) => q.id));

  const answeredCorrectly = new Set((correctAttempts ?? []).map((a) => a.question_id));

  // Prefer unanswered questions; fall back to all if every question is done
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
