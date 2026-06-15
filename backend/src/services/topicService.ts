import { supabase } from '../db/supabase.js';
import type { MathLevel, Topic, TopicProgress } from '../types/index.js';

export async function getAllTopics(level?: MathLevel): Promise<Topic[]> {
  let query = supabase
    .from('topics')
    .select('*')
    .order('name');

  if (level) {
    query = query.eq('level', level);
  }

  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return data as Topic[];
}

export async function getTopicsProgress(sessionId: string): Promise<TopicProgress[]> {
  const [questionsResult, attemptsResult] = await Promise.all([
    supabase.from('questions').select('id, topic_id'),
    supabase
      .from('attempts')
      .select('question_id')
      .eq('session_id', sessionId)
      .eq('is_correct', true),
  ]);

  if (questionsResult.error) throw new Error(questionsResult.error.message);
  if (attemptsResult.error) throw new Error(attemptsResult.error.message);

  const questions = questionsResult.data as { id: string; topic_id: string }[];
  const correctIds = new Set(
    (attemptsResult.data as { question_id: string }[]).map((a) => a.question_id),
  );

  const map = new Map<string, { correct: number; total: number }>();
  for (const q of questions) {
    if (!map.has(q.topic_id)) map.set(q.topic_id, { correct: 0, total: 0 });
    const entry = map.get(q.topic_id)!;
    entry.total++;
    if (correctIds.has(q.id)) entry.correct++;
  }

  return Array.from(map.entries()).map(([topic_id, { correct, total }]) => ({
    topic_id,
    correct,
    total,
  }));
}

export async function getTopicById(id: string): Promise<Topic | null> {
  const { data, error } = await supabase
    .from('topics')
    .select('*')
    .eq('id', id)
    .single();

  if (error) {
    if (error.code === 'PGRST116') return null; // row not found
    throw new Error(error.message);
  }
  return data as Topic;
}
