import { supabase } from '../db/supabase.js';

export interface StarredQuestionRow {
  question_id: string;
  question_name: string | null;
  topic_id: string;
  topic_name: string;
  starred_at: string;
  latest_attempt: {
    attempted_at: string;
    is_correct: boolean;
    time_taken_s: number | null;
  } | null;
}

export async function toggleStar(
  userId: string,
  questionId: string,
): Promise<{ starred: boolean }> {
  // Check if already starred
  const { data: existing } = await supabase
    .from('starred_questions')
    .select('id')
    .eq('session_id', userId)
    .eq('question_id', questionId)
    .maybeSingle();

  if (existing) {
    await supabase
      .from('starred_questions')
      .delete()
      .eq('session_id', userId)
      .eq('question_id', questionId);
    return { starred: false };
  }

  await supabase.from('starred_questions').insert({ session_id: userId, question_id: questionId });
  return { starred: true };
}

export async function getStarredQuestions(userId: string): Promise<StarredQuestionRow[]> {
  const { data: starred, error: starError } = await supabase
    .from('starred_questions')
    .select('question_id, starred_at')
    .eq('session_id', userId)
    .order('starred_at', { ascending: false });

  if (starError) throw new Error(starError.message);
  if (!starred || starred.length === 0) return [];

  const questionIds = starred.map((s) => s.question_id as string);

  const [questionsResult, attemptsResult] = await Promise.all([
    supabase
      .from('questions')
      .select('id, name, topic_id, topics:topics(id, name)')
      .in('id', questionIds),
    supabase
      .from('attempts')
      .select('question_id, is_correct, time_taken_s, attempted_at')
      .eq('session_id', userId)
      .in('question_id', questionIds)
      .order('attempted_at', { ascending: false }),
  ]);

  if (questionsResult.error) throw new Error(questionsResult.error.message);
  if (attemptsResult.error) throw new Error(attemptsResult.error.message);

  // Latest attempt per question (already ordered newest-first)
  const latestAttempt = new Map<string, { attempted_at: string; is_correct: boolean; time_taken_s: number | null }>();
  for (const a of attemptsResult.data ?? []) {
    if (!latestAttempt.has(a.question_id as string)) {
      latestAttempt.set(a.question_id as string, {
        attempted_at: a.attempted_at as string,
        is_correct: a.is_correct as boolean,
        time_taken_s: a.time_taken_s as number | null,
      });
    }
  }

  const questionMap = new Map(
    (questionsResult.data ?? []).map((q) => [q.id as string, q]),
  );

  return starred.map((s) => {
    const q = questionMap.get(s.question_id as string);
    const topicsRaw = q?.topics;
    const topic = (Array.isArray(topicsRaw) ? topicsRaw[0] : topicsRaw) as { id: string; name: string } | null | undefined;
    return {
      question_id: s.question_id as string,
      question_name: (q?.name as string | null) ?? null,
      topic_id: topic?.id ?? '',
      topic_name: topic?.name ?? '',
      starred_at: s.starred_at as string,
      latest_attempt: latestAttempt.get(s.question_id as string) ?? null,
    };
  });
}

export async function getStarredIds(
  userId: string,
  questionIds: string[],
): Promise<string[]> {
  if (questionIds.length === 0) return [];

  const { data, error } = await supabase
    .from('starred_questions')
    .select('question_id')
    .eq('session_id', userId)
    .in('question_id', questionIds);

  if (error) throw new Error(error.message);
  return (data ?? []).map((r) => r.question_id as string);
}
