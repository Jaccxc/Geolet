import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { Region, RegionLevel } from '../types';
import { regionSchema } from '../types';

export async function getRegions(level?: RegionLevel): Promise<Region[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase.from('regions').select('*');

  if (level) {
    query = query.eq('level', level);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => regionSchema.parse(row));
}

export async function getRegionsByKeys(keys: string[]): Promise<Region[]> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.from('regions').select('*').in('key', keys);

  if (error) throw error;

  return data.map((row) => regionSchema.parse(row));
}

export async function getRegionByKey(key: string): Promise<Region | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase.from('regions').select('*').eq('key', key).single();

  if (error) return null;

  return regionSchema.parse(data);
}
