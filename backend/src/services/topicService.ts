import { supabase } from '../db/supabase.js';
import type { MathLevel, Topic } from '../types/index.js';

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
