import { supabase } from '../db/supabase.js';

export async function toggleStar(
  sessionId: string,
  questionId: string,
): Promise<{ starred: boolean }> {
  // Check if already starred
  const { data: existing } = await supabase
    .from('starred_questions')
    .select('id')
    .eq('session_id', sessionId)
    .eq('question_id', questionId)
    .maybeSingle();

  if (existing) {
    await supabase
      .from('starred_questions')
      .delete()
      .eq('session_id', sessionId)
      .eq('question_id', questionId);
    return { starred: false };
  }

  await supabase.from('starred_questions').insert({ session_id: sessionId, question_id: questionId });
  return { starred: true };
}

export async function getStarredIds(
  sessionId: string,
  questionIds: string[],
): Promise<string[]> {
  if (questionIds.length === 0) return [];

  const { data, error } = await supabase
    .from('starred_questions')
    .select('question_id')
    .eq('session_id', sessionId)
    .in('question_id', questionIds);

  if (error) throw new Error(error.message);
  return (data ?? []).map((r) => r.question_id as string);
}
