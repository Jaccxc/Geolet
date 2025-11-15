import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { Topic } from '../types';
import { topicSchema } from '../types';

/**
 * Get all topics with optional mode filter
 */
export async function getTopics(options?: {
  pickModeActive?: boolean;
  mapModeActive?: boolean;
}): Promise<Topic[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase.from('topics').select('*');

  if (options?.pickModeActive) {
    query = query.eq('pick_mode_active', true);
  }

  if (options?.mapModeActive) {
    query = query.eq('map_mode_active', true);
  }

  // Sort by created_at in ascending order (oldest first)
  query = query.order('created_at', { ascending: true });

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => topicSchema.parse(row));
}

/**
 * Get topic by key
 */
export async function getTopicByKey(key: string): Promise<Topic | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.from('topics').select('*').eq('key', key).single();

  if (error) return null;

  return topicSchema.parse(data);
}
