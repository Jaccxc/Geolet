import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, FactType } from '../types';
import { factCardSchema } from '../types';

export async function getFactCards(type?: FactType, tags?: string[], limit?: number): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase.from('fact_cards').select('*');

  if (type) {
    query = query.eq('type', type);
  }

  if (tags && tags.length > 0) {
    query = query.overlaps('primary_tags', tags);
  }

  if (limit) {
    query = query.limit(limit);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => factCardSchema.parse(row));
}

export async function getFactCardById(id: string): Promise<FactCard | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.from('fact_cards').select('*').eq('id', id).single();

  if (error) return null;

  return factCardSchema.parse(data);
}
