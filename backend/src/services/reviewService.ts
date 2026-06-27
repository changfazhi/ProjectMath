import { supabase } from '../db/supabase.js';
import { getSpacedDueItems } from './spacedRepetitionService.js';

export interface ReviewItem {
  question_id: string;
  topic_id: string;
}

const INTERVALS_DAYS = [1, 3, 7, 14, 30];
const MS_PER_DAY = 86_400_000;

async function fetchQuestionMap(): Promise<Map<string, string>> {
  const { data, error } = await supabase.from('questions').select('id, topic_id');
  if (error) throw new Error(error.message);
  const map = new Map<string, string>();
  for (const q of (data ?? [])) {
    map.set(q.id as string, q.topic_id as string);
  }
  return map;
}

// Questions attempted at least once but never correctly.
export async function getCorrectionsItems(userId: string): Promise<ReviewItem[]> {
  const [attemptsRes, qMapResult] = await Promise.all([
    supabase.from('attempts').select('question_id, is_correct').eq('session_id', userId),
    fetchQuestionMap(),
  ]);
  if (attemptsRes.error) throw new Error(attemptsRes.error.message);

  const incorrectSet = new Set<string>();
  const correctSet = new Set<string>();
  for (const a of (attemptsRes.data ?? [])) {
    if (a.is_correct) correctSet.add(a.question_id as string);
    else incorrectSet.add(a.question_id as string);
  }

  const ids = [...incorrectSet].filter(id => !correctSet.has(id));
  return ids
    .filter(id => qMapResult.has(id))
    .map(id => ({ question_id: id, topic_id: qMapResult.get(id)! }));
}

// All questions from the bottom 25% of topics by accuracy.
export async function getWeakTopicsItems(userId: string): Promise<ReviewItem[]> {
  const [attemptsRes, qMap] = await Promise.all([
    supabase.from('attempts').select('question_id, is_correct').eq('session_id', userId),
    fetchQuestionMap(),
  ]);
  if (attemptsRes.error) throw new Error(attemptsRes.error.message);

  const attempts = attemptsRes.data ?? [];
  if (attempts.length === 0) return [];

  const topicStats = new Map<string, { correct: number; total: number }>();
  for (const a of attempts) {
    const topicId = qMap.get(a.question_id as string);
    if (!topicId) continue;
    const s = topicStats.get(topicId) ?? { correct: 0, total: 0 };
    s.total++;
    if (a.is_correct) s.correct++;
    topicStats.set(topicId, s);
  }

  const sortedTopics = [...topicStats.entries()]
    .filter(([_, s]) => s.total > 0)
    .sort((a, b) => (a[1].correct / a[1].total) - (b[1].correct / b[1].total));

  if (sortedTopics.length === 0) return [];

  const take = Math.max(1, Math.ceil(sortedTopics.length * 0.25));
  const weakTopicIds = new Set(sortedTopics.slice(0, take).map(([id]) => id));

  return [...qMap.entries()]
    .filter(([_, topicId]) => weakTopicIds.has(topicId))
    .map(([id, topicId]) => ({ question_id: id, topic_id: topicId }));
}

// Solved questions with the slowest average correct-attempt time (bottom 20%).
export async function getSpeedDrillItems(userId: string): Promise<ReviewItem[]> {
  const [attemptsRes, qMap] = await Promise.all([
    supabase
      .from('attempts')
      .select('question_id, time_taken_s')
      .eq('session_id', userId)
      .eq('is_correct', true)
      .not('time_taken_s', 'is', null),
    fetchQuestionMap(),
  ]);
  if (attemptsRes.error) throw new Error(attemptsRes.error.message);

  const timeMap = new Map<string, { total: number; count: number }>();
  for (const a of (attemptsRes.data ?? [])) {
    if (a.time_taken_s === null) continue;
    const s = timeMap.get(a.question_id as string) ?? { total: 0, count: 0 };
    s.total += a.time_taken_s as number;
    s.count++;
    timeMap.set(a.question_id as string, s);
  }

  if (timeMap.size === 0) return [];

  const sorted = [...timeMap.entries()]
    .map(([id, s]) => ({ id, avg: s.total / s.count }))
    .sort((a, b) => b.avg - a.avg);

  const take = Math.max(5, Math.ceil(sorted.length * 0.2));
  const slowIds = sorted.slice(0, take).map(s => s.id);

  return slowIds
    .filter(id => qMap.has(id))
    .map(id => ({ question_id: id, topic_id: qMap.get(id)! }));
}

// Questions due for review per Wozniak SM-2 schedule (see spacedRepetitionService.ts).
export async function getSpacedItems(userId: string): Promise<ReviewItem[]> {
  return getSpacedDueItems(userId);
}

// All questions — no session context needed.
export async function getRandomItems(): Promise<ReviewItem[]> {
  const qMap = await fetchQuestionMap();
  return [...qMap.entries()].map(([id, topicId]) => ({ question_id: id, topic_id: topicId }));
}
