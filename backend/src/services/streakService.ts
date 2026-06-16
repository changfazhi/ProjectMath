import { supabase } from '../db/supabase.js';

function getActivityDate(isoString: string): string {
  return new Date(new Date(isoString).getTime() - 16 * 60 * 60 * 1000)
    .toISOString()
    .slice(0, 10);
}

function getTodayActivityDate(): string {
  return new Date(Date.now() - 16 * 60 * 60 * 1000).toISOString().slice(0, 10);
}

function addDays(dateStr: string, days: number): string {
  const d = new Date(dateStr + 'T00:00:00Z');
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

export interface DailyActivity {
  date: string;
  correctCount: number;
  attemptCount: number;
}

export interface StreakStats {
  currentStreak: number;
  bestStreak: number;
  totalAttempts: number;
  totalSolved: number;
  totalQuestions: number;
  dailyActivity: DailyActivity[];
}

export async function getStreakStats(sessionId: string): Promise<StreakStats> {
  const [attemptsResult, countResult] = await Promise.all([
    supabase
      .from('attempts')
      .select('is_correct, question_id, attempted_at')
      .eq('session_id', sessionId),
    supabase
      .from('questions')
      .select('*', { count: 'exact', head: true }),
  ]);

  if (attemptsResult.error) throw new Error(attemptsResult.error.message);
  if (countResult.error) throw new Error(countResult.error.message);

  const attempts = attemptsResult.data ?? [];
  const totalQuestions = countResult.count ?? 0;

  if (attempts.length === 0) {
    return { currentStreak: 0, bestStreak: 0, totalAttempts: 0, totalSolved: 0, totalQuestions, dailyActivity: [] };
  }

  const dailyMap = new Map<string, { correctCount: number; attemptCount: number }>();
  const solvedQuestions = new Set<string>();

  for (const attempt of attempts) {
    const date = getActivityDate(attempt.attempted_at as string);
    const entry = dailyMap.get(date) ?? { correctCount: 0, attemptCount: 0 };
    entry.attemptCount++;
    if (attempt.is_correct) {
      entry.correctCount++;
      solvedQuestions.add(attempt.question_id as string);
    }
    dailyMap.set(date, entry);
  }

  const dailyActivity: DailyActivity[] = [...dailyMap.entries()]
    .map(([date, { correctCount, attemptCount }]) => ({ date, correctCount, attemptCount }))
    .sort((a, b) => a.date.localeCompare(b.date));

  const hasCorrect = (d: string) => (dailyMap.get(d)?.correctCount ?? 0) > 0;

  // Current streak: consecutive days ending today or yesterday
  const today = getTodayActivityDate();
  const yesterday = addDays(today, -1);
  const startDate = hasCorrect(today) ? today : hasCorrect(yesterday) ? yesterday : null;

  let currentStreak = 0;
  if (startDate) {
    let checkDate = startDate;
    while (hasCorrect(checkDate)) {
      currentStreak++;
      checkDate = addDays(checkDate, -1);
    }
  }

  // Best streak: longest consecutive run across all history
  const datesWithCorrect = dailyActivity.filter(d => d.correctCount > 0).map(d => d.date);
  let bestStreak = currentStreak;
  let currentRun = 0;
  let prevDate: string | null = null;

  for (const date of datesWithCorrect) {
    if (prevDate === null || addDays(prevDate, 1) === date) {
      currentRun++;
    } else {
      bestStreak = Math.max(bestStreak, currentRun);
      currentRun = 1;
    }
    prevDate = date;
    bestStreak = Math.max(bestStreak, currentRun);
  }

  return {
    currentStreak,
    bestStreak,
    totalAttempts: attempts.length,
    totalSolved: solvedQuestions.size,
    totalQuestions,
    dailyActivity,
  };
}
