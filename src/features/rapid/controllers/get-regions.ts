import { createClient } from '@/libs/supabase/supabase-server-client';
import { regionSchema } from '../types';
import type { Region, RegionKind } from '../types';

export async function getRegions(kind?: RegionKind): Promise<Region[]> {
  const supabase = await createClient();

  let query = supabase.from('regions').select('*');

  if (kind) {
    query = query.eq('kind', kind);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => regionSchema.parse(row));
}

export async function getRegionsByKeys(keys: string[]): Promise<Region[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('regions')
    .select('*')
    .in('key', keys);

  if (error) throw error;

  return data.map((row) => regionSchema.parse(row));
}

export async function getRegionByKey(key: string): Promise<Region | null> {
  const supabase = await createClient();

  const { data, error} = await supabase
    .from('regions')
    .select('*')
    .eq('key', key)
    .single();

  if (error) return null;

  return regionSchema.parse(data);
}
