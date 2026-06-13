import { supabase } from '../db/supabase.js';
import type { TopicConcept } from '../types/index.js';

export async function getConceptsByTopic(topicId: string): Promise<TopicConcept[]> {
  const { data, error } = await supabase
    .from('topic_concepts')
    .select('*')
    .eq('topic_id', topicId)
    .order('sort_order');

  if (error) throw new Error(error.message);
  return (data ?? []) as TopicConcept[];
}
