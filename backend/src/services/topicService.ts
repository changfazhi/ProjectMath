import { supabase } from '../db/supabase.js';
import type { MathLevel, QuestionPart, Topic, TopicAccuracy, TopicProgress } from '../types/index.js';

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

export async function getTopicsProgress(userId: string): Promise<TopicProgress[]> {
  const [questionsResult, attemptsResult] = await Promise.all([
    supabase.from('questions').select('id, topic_id, parts'),
    supabase.from('attempts').select('question_id, part_label, is_correct').eq('session_id', userId),
  ]);

  if (questionsResult.error) throw new Error(questionsResult.error.message);
  if (attemptsResult.error) throw new Error(attemptsResult.error.message);

  const questions = questionsResult.data as {
    id: string;
    topic_id: string;
    parts: QuestionPart[] | null;
  }[];
  const attempts = attemptsResult.data as {
    question_id: string;
    part_label: string | null;
    is_correct: boolean;
  }[];

  const attemptedIds = new Set(attempts.map((a) => a.question_id));
  // Which parts of each question have a correct attempt (part_label = null for single-answer).
  const correctParts = new Map<string, Set<string | null>>();
  for (const a of attempts) {
    if (!a.is_correct) continue;
    if (!correctParts.has(a.question_id)) correctParts.set(a.question_id, new Set());
    correctParts.get(a.question_id)!.add(a.part_label);
  }

  // A question counts as correct only when EVERY graded part has a correct attempt
  // (single-answer questions: the one null-part attempt). Matches the roadmap ✓ rule.
  function isQuestionCorrect(id: string, parts: QuestionPart[] | null): boolean {
    const labels = correctParts.get(id);
    if (!labels) return false;
    const graded = (parts ?? []).filter((p) => p.correct_answer !== null);
    if (graded.length > 0) return graded.every((p) => labels.has(p.label));
    return labels.has(null);
  }

  const map = new Map<string, { correct: number; attempted: number; total: number }>();
  for (const q of questions) {
    if (!map.has(q.topic_id)) map.set(q.topic_id, { correct: 0, attempted: 0, total: 0 });
    const entry = map.get(q.topic_id)!;
    entry.total++;
    if (attemptedIds.has(q.id)) entry.attempted++;
    if (isQuestionCorrect(q.id, q.parts)) entry.correct++;
  }

  return Array.from(map.entries()).map(([topic_id, { correct, attempted, total }]) => ({
    topic_id,
    correct,
    attempted,
    total,
  }));
}

export async function getTopicsAccuracy(userId: string): Promise<TopicAccuracy[]> {
  const [topicsResult, questionsResult, attemptsResult] = await Promise.all([
    supabase.from('topics').select('id, name').order('name'),
    supabase.from('questions').select('id, topic_id'),
    supabase
      .from('attempts')
      .select('question_id, is_correct')
      .eq('session_id', userId),
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
