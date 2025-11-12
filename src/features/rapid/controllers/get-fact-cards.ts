import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, FactCardWithAnswer, Region } from '../types';
import { factCardSchema } from '../types';

/**
 * Get fact cards with optional filters
 * NEW: Supports filtering by card_group_ids and topics
 */
export async function getFactCards(options?: {
  cardGroupIds?: string[];
  skillTags?: string[];
  limit?: number;
}): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase.from('fact_cards').select('*');

  if (options?.cardGroupIds && options.cardGroupIds.length > 0) {
    query = query.in('card_group_id', options.cardGroupIds);
  }

  if (options?.skillTags && options.skillTags.length > 0) {
    query = query.overlaps('primary_skill_tags', options.skillTags);
  }

  if (options?.limit) {
    query = query.limit(options.limit);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => factCardSchema.parse(row));
}

/**
 * Get fact card by ID with answer region populated
 */
export async function getFactCardById(id: string): Promise<FactCardWithAnswer | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase
    .from('fact_cards')
    .select(
      `
      *,
      answer_region:regions!answer_region_id (*)
    `
    )
    .eq('id', id)
    .single();

  if (error) return null;

  return {
    ...factCardSchema.parse(data),
    answer_region: data.answer_region as Region,
  };
}

/**
 * Get fact cards by topic key
 * NEW: Fetches cards from all card groups associated with a topic
 */
export async function getFactCardsByTopic(topicKey: string, limit?: number): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();

  // First, get the topic
  const { data: topic, error: topicError } = await supabase
    .from('topics')
    .select('target_card_group_ids')
    .eq('key', topicKey)
    .single();

  if (topicError || !topic?.target_card_group_ids) {
    throw new Error(`Topic not found: ${topicKey}`);
  }

  // Then, get fact cards from those card groups
  return getFactCards({
    cardGroupIds: topic.target_card_group_ids,
    limit,
  });
}
