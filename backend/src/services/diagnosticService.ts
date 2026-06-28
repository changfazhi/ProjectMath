import { Type } from '@google/genai';
import { supabase } from '../db/supabase.js';
import { getGemini, GEMINI_MODEL } from '../db/gemini.js';

export interface TopicDiagnosis {
  topic_id: string;
  topic_name: string;
  accuracy: number;
  questions_attempted: number;
  strength_level: 'strong' | 'moderate' | 'weak';
  ai_insight: string;
}

export interface DiagnosisResult {
  weak_topics: TopicDiagnosis[];
  moderate_topics: TopicDiagnosis[];
  strong_topics: TopicDiagnosis[];
  overall_summary: string;
  generated_at: string;
}

export interface StudyPlanItem {
  question_id: string;
  topic_id: string;
  topic_name: string;
  question_name: string | null;
}

export interface StudyPlanResponse {
  items: StudyPlanItem[];
  reasoning: string;
}

const diagnosisSchema = {
  type: Type.OBJECT,
  properties: {
    topics: {
      type: Type.ARRAY,
      items: {
        type: Type.OBJECT,
        properties: {
          topic_id: { type: Type.STRING },
          strength_level: { type: Type.STRING, enum: ['weak', 'moderate', 'strong'] },
          ai_insight: { type: Type.STRING },
        },
        required: ['topic_id', 'strength_level', 'ai_insight'],
      },
    },
    overall_summary: { type: Type.STRING },
  },
  required: ['topics', 'overall_summary'],
};

interface TopicStat {
  topic_id: string;
  topic_name: string;
  accuracy: number;
  questions_attempted: number;
}

async function buildTopicStats(userId: string): Promise<TopicStat[]> {
  const [topicsRes, questionsRes, attemptsRes] = await Promise.all([
    supabase.from('topics').select('id, name').order('name'),
    supabase.from('questions').select('id, topic_id'),
    supabase.from('attempts').select('question_id, is_correct').eq('session_id', userId),
  ]);

  if (topicsRes.error) throw new Error(topicsRes.error.message);
  if (questionsRes.error) throw new Error(questionsRes.error.message);
  if (attemptsRes.error) throw new Error(attemptsRes.error.message);

  const topics = topicsRes.data as { id: string; name: string }[];
  const questions = questionsRes.data as { id: string; topic_id: string }[];
  const attempts = attemptsRes.data as { question_id: string; is_correct: boolean }[];

  const uniqueQuestionsAttempted = new Set(attempts.map(a => a.question_id)).size;
  if (uniqueQuestionsAttempted < 5) {
    throw new Error('Attempt at least 5 unique questions to unlock the Weakness Diagnostic.');
  }

  const qTopicMap = new Map<string, string>();
  for (const q of questions) qTopicMap.set(q.id, q.topic_id);

  const topicNameMap = new Map<string, string>();
  for (const t of topics) topicNameMap.set(t.id, t.name);

  const statsByTopic = new Map<string, { correct: number; attempted: Set<string> }>();
  for (const a of attempts) {
    const topicId = qTopicMap.get(a.question_id);
    if (!topicId) continue;
    const s = statsByTopic.get(topicId) ?? { correct: 0, attempted: new Set<string>() };
    s.attempted.add(a.question_id);
    if (a.is_correct) s.correct++;
    statsByTopic.set(topicId, s);
  }

  return [...statsByTopic.entries()]
    .map(([topicId, s]) => ({
      topic_id: topicId,
      topic_name: topicNameMap.get(topicId) ?? topicId,
      accuracy: s.attempted.size > 0 ? s.correct / s.attempted.size : 0,
      questions_attempted: s.attempted.size,
    }))
    .filter(s => s.questions_attempted > 0)
    .sort((a, b) => a.accuracy - b.accuracy);
}

export async function getWeaknessDiagnosis(userId: string): Promise<DiagnosisResult> {
  const statsArr = await buildTopicStats(userId);

  const promptText = `You are an expert Singapore H2 A-Level Mathematics tutor. Analyze this student's performance and provide a structured diagnosis.

STUDENT PERFORMANCE DATA:
${statsArr.map(s =>
  `- ${s.topic_name} (id: ${s.topic_id}): ${Math.round(s.accuracy * 100)}% accuracy, ${s.questions_attempted} questions attempted`
).join('\n')}

For each topic, classify as:
- "weak": accuracy below 50%
- "moderate": accuracy 50–75%
- "strong": accuracy above 75%

For each topic, write one specific, actionable ai_insight for a Singapore H2 A-Level student. Mention relevant techniques or question types where helpful.

Write overall_summary in 2–3 sentences: biggest strength, biggest weakness, and one concrete study tip.`;

  const response = await getGemini().models.generateContent({
    model: GEMINI_MODEL,
    contents: [{ role: 'user', parts: [{ text: promptText }] }],
    config: {
      responseMimeType: 'application/json',
      responseSchema: diagnosisSchema,
    },
  });

  const raw = response.text?.trim() ?? '{}';
  const parsed = JSON.parse(raw) as {
    topics: Array<{ topic_id: string; strength_level: string; ai_insight: string }>;
    overall_summary: string;
  };

  const insightMap = new Map(
    parsed.topics.map(t => [t.topic_id, { strength_level: t.strength_level, ai_insight: t.ai_insight }]),
  );

  const weak_topics: TopicDiagnosis[] = [];
  const moderate_topics: TopicDiagnosis[] = [];
  const strong_topics: TopicDiagnosis[] = [];

  for (const s of statsArr) {
    const insight = insightMap.get(s.topic_id);
    const fallback = s.accuracy < 0.5 ? 'weak' : s.accuracy < 0.75 ? 'moderate' : 'strong';
    const level = (insight?.strength_level ?? fallback) as TopicDiagnosis['strength_level'];
    const td: TopicDiagnosis = {
      topic_id: s.topic_id,
      topic_name: s.topic_name,
      accuracy: s.accuracy,
      questions_attempted: s.questions_attempted,
      strength_level: level,
      ai_insight: insight?.ai_insight ?? '',
    };
    if (level === 'weak') weak_topics.push(td);
    else if (level === 'moderate') moderate_topics.push(td);
    else strong_topics.push(td);
  }

  return {
    weak_topics,
    moderate_topics,
    strong_topics,
    overall_summary: parsed.overall_summary ?? '',
    generated_at: new Date().toISOString(),
  };
}

// Algorithmic study plan — no second Gemini call. Selects up to 10 unsolved questions
// from the weakest topics so the student has immediate, prioritised practice.
// The generated plan is persisted per (user_id, date) so it syncs across devices.
export async function getPersonalisedStudyPlan(userId: string): Promise<StudyPlanResponse> {
  const today = new Date().toLocaleDateString('en-CA'); // YYYY-MM-DD

  // Return today's saved plan if it exists — avoids regeneration on other devices.
  const { data: saved } = await supabase
    .from('study_plans')
    .select('items, reasoning')
    .eq('user_id', userId)
    .eq('date', today)
    .maybeSingle();

  if (saved) {
    return {
      items: saved.items as StudyPlanResponse['items'],
      reasoning: saved.reasoning as string,
    };
  }

  const statsArr = await buildTopicStats(userId);

  const [questionsRes, attemptsRes, topicsRes2] = await Promise.all([
    supabase.from('questions').select('id, topic_id, name'),
    supabase.from('attempts').select('question_id, is_correct').eq('session_id', userId),
    supabase.from('topics').select('id, name'),
  ]);

  if (questionsRes.error) throw new Error(questionsRes.error.message);
  if (attemptsRes.error) throw new Error(attemptsRes.error.message);
  if (topicsRes2.error) throw new Error(topicsRes2.error.message);

  const questions = questionsRes.data as { id: string; topic_id: string; name: string | null }[];
  const attempts = attemptsRes.data as { question_id: string; is_correct: boolean }[];
  const topicNames2 = new Map((topicsRes2.data as { id: string; name: string }[]).map(t => [t.id, t.name]));

  const correctSet = new Set<string>();
  for (const a of attempts) {
    if (a.is_correct) correctSet.add(a.question_id);
  }

  const qByTopic = new Map<string, { id: string; name: string | null }[]>();
  for (const q of questions) {
    const arr = qByTopic.get(q.topic_id) ?? [];
    arr.push({ id: q.id, name: q.name });
    qByTopic.set(q.topic_id, arr);
  }

  // Iterate topics from weakest to strongest; pick unsolved questions
  const items: StudyPlanResponse['items'] = [];
  const seen = new Set<string>();

  for (const t of statsArr) {
    if (items.length >= 10) break;
    const topicQs = (qByTopic.get(t.topic_id) ?? []).filter(q => !correctSet.has(q.id));
    for (const q of topicQs) {
      if (!seen.has(q.id) && items.length < 10) {
        items.push({
          question_id: q.id,
          topic_id: t.topic_id,
          topic_name: topicNames2.get(t.topic_id) ?? t.topic_name,
          question_name: q.name,
        });
        seen.add(q.id);
      }
      if (items.length >= 10) break;
    }
  }

  const topWeakNames = statsArr
    .filter(t => t.accuracy < 0.5)
    .slice(0, 3)
    .map(t => t.topic_name);

  const reasoning = topWeakNames.length > 0
    ? `Focusing on your weakest areas: ${topWeakNames.join(', ')}. These have the lowest accuracy and will benefit most from targeted practice.`
    : 'Covering topics where you have the most room to improve.';

  // Persist so other devices get the same plan today.
  await supabase
    .from('study_plans')
    .upsert({ user_id: userId, date: today, items, reasoning }, { onConflict: 'user_id,date' });

  return { items, reasoning };
}
