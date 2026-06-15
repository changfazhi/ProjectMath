import { supabase } from '../db/supabase.js';
import type { AttemptStatus, Difficulty, Question, QuestionPublic, QuestionWithStatus } from '../types/index.js';

function stripSolution(q: Question): QuestionPublic {
  const { correct_answer: _ca, solution_latex: _sl, parts, ...pub } = q;
  return {
    ...pub,
    parts: parts?.map(({ correct_answer: _pca, ...rest }) => rest) ?? null,
  };
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
    .select('question_id, part_label, is_correct')
    .eq('session_id', sessionId)
    .in('question_id', questionIds);

  // Group attempts by question_id → { part_label | null → is_correct (best result) }
  type PartKey = string | null;
  const attemptMap = new Map<string, Map<PartKey, boolean>>();
  for (const a of attempts ?? []) {
    if (!attemptMap.has(a.question_id)) attemptMap.set(a.question_id, new Map());
    const partMap = attemptMap.get(a.question_id)!;
    const key: PartKey = a.part_label ?? null;
    partMap.set(key, (partMap.get(key) ?? false) || a.is_correct);
  }

  return questions.map((q) => {
    const question = q as Question;
    const pub = stripSolution(question);
    const partMap = attemptMap.get(q.id);

    let status: AttemptStatus = 'not_attempted';
    if (partMap && partMap.size > 0) {
      const gradedParts = question.parts?.filter((p) => p.correct_answer !== null) ?? null;
      if (gradedParts && gradedParts.length > 0) {
        // Multi-part: correct only if every graded part has a correct attempt
        const allCorrect = gradedParts.every((p) => partMap.get(p.label) === true);
        status = allCorrect ? 'correct' : 'attempted';
      } else {
        // Single-answer: correct if the null-key attempt is correct
        status = partMap.get(null) === true ? 'correct' : 'attempted';
      }
    }
    return { ...pub, status };
  });
}
