import { supabase } from '../db/supabase.js';
import type { MathLevel, Topic, TopicAccuracy, TopicProgress } from '../types/index.js';

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

export async function getTopicsAccuracy(sessionId: string): Promise<TopicAccuracy[]> {
  const [topicsResult, questionsResult, attemptsResult] = await Promise.all([
    supabase.from('topics').select('id, name').order('name'),
    supabase.from('questions').select('id, topic_id'),
    supabase
      .from('attempts')
      .select('question_id, is_correct')
      .eq('session_id', sessionId),
  ]);

  if (topicsResult.error) throw new Error(topicsResult.error.message);
  if (questionsResult.error) throw new Error(questionsResult.error.message);
  if (attemptsResult.error) throw new Error(attemptsResult.error.message);

  const topics = topicsResult.data as { id: string; name: string }[];
  const questions = questionsResult.data as { id: string; topic_id: string }[];
  const attempts = attemptsResult.data as { question_id: string; is_correct: boolean }[];

  // Map question_id → topic_id
  const questionTopicMap = new Map<string, string>();
  for (const q of questions) questionTopicMap.set(q.id, q.topic_id);

  // Count totals per topic
  const questionCountMap = new Map<string, number>();
  for (const q of questions) {
    questionCountMap.set(q.topic_id, (questionCountMap.get(q.topic_id) ?? 0) + 1);
  }

  // Count attempt stats and solved questions per topic
  type AccStats = { correctAttempts: number; totalAttempts: number; solvedIds: Set<string> };
  const statsMap = new Map<string, AccStats>();

  for (const a of attempts) {
    const topicId = questionTopicMap.get(a.question_id);
    if (!topicId) continue;
    if (!statsMap.has(topicId)) {
      statsMap.set(topicId, { correctAttempts: 0, totalAttempts: 0, solvedIds: new Set() });
    }
    const s = statsMap.get(topicId)!;
    s.totalAttempts++;
    if (a.is_correct) {
      s.correctAttempts++;
      s.solvedIds.add(a.question_id);
    }
  }

  return topics.map((t) => {
    const s = statsMap.get(t.id);
    return {
      topic_id: t.id,
      topic_name: t.name,
      questions_solved: s ? s.solvedIds.size : 0,
      questions_total: questionCountMap.get(t.id) ?? 0,
      correct_attempts: s ? s.correctAttempts : 0,
      total_attempts: s ? s.totalAttempts : 0,
    };
  });
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
