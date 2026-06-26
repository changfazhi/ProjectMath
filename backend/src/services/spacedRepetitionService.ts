import { supabase } from '../db/supabase.js';

export interface SRReviewItem {
  question_id: string;
  topic_id: string;
}

// Wozniak SM-2 update. quality: correct=4, incorrect=1.
function sm2(
  ef: number,
  intervalDays: number,
  repetitions: number,
  isCorrect: boolean,
): { ef: number; intervalDays: number; repetitions: number } {
  const q = isCorrect ? 4 : 1;

  if (q < 3) {
    return {
      ef: Math.max(1.3, ef - 0.2),
      intervalDays: 1,
      repetitions: 0,
    };
  }

  let next: number;
  if (repetitions === 0) next = 1;
  else if (repetitions === 1) next = 6;
  else next = Math.round(intervalDays * ef);

  // EF' = EF + 0.1 – (5–q)(0.08 + (5–q)·0.02)
  const newEf = Math.max(
    1.3,
    ef + 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02),
  );

  return { ef: newEf, intervalDays: next, repetitions: repetitions + 1 };
}

// Create or update an SM-2 card after a question is answered.
// Called as fire-and-forget from attemptService when the solution is revealed.
export async function upsertSRCard(
  userId: string,
  questionId: string,
  topicId: string,
  isCorrect: boolean,
): Promise<void> {
  const { data: existing } = await supabase
    .from('spaced_repetition_cards')
    .select('ef, interval_days, repetitions')
    .eq('session_id', userId)
    .eq('question_id', questionId)
    .maybeSingle();

  const row = existing as { ef: number; interval_days: number; repetitions: number } | null;
  const { ef, intervalDays, repetitions } = sm2(
    row?.ef ?? 2.5,
    row?.interval_days ?? 1,
    row?.repetitions ?? 0,
    isCorrect,
  );

  const dueAt = new Date(Date.now() + intervalDays * 24 * 60 * 60 * 1000).toISOString();

  await supabase
    .from('spaced_repetition_cards')
    .upsert(
      {
        session_id: userId,
        question_id: questionId,
        topic_id: topicId,
        ef,
        interval_days: intervalDays,
        repetitions,
        due_at: dueAt,
        last_reviewed_at: new Date().toISOString(),
      },
      { onConflict: 'session_id,question_id' },
    );
}

// Returns all SR cards currently due for this session.
export async function getSpacedDueItems(userId: string): Promise<SRReviewItem[]> {
  const now = new Date().toISOString();
  const { data, error } = await supabase
    .from('spaced_repetition_cards')
    .select('question_id, topic_id')
    .eq('session_id', userId)
    .lte('due_at', now);

  if (error) throw new Error(error.message);
  return (data ?? []).map((r: { question_id: string; topic_id: string }) => ({
    question_id: r.question_id,
    topic_id: r.topic_id,
  }));
}
