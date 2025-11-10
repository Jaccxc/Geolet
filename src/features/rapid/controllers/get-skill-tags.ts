import { createClient } from '@/libs/supabase/supabase-server-client';
import { skillTagSchema } from '../types';
import type { SkillTag, SkillFamily } from '../types';

export async function getSkillTags(family?: SkillFamily): Promise<SkillTag[]> {
  const supabase = await createClient();

  let query = supabase.from('skill_tags').select('*');

  if (family) {
    query = query.eq('family', family);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => skillTagSchema.parse(row));
}

export async function getSkillTagByKey(key: string): Promise<SkillTag | null> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('skill_tags')
    .select('*')
    .eq('key', key)
    .single();

  if (error) return null;

  return skillTagSchema.parse(data);
}

export async function getSkillTagsByKeys(keys: string[]): Promise<SkillTag[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('skill_tags')
    .select('*')
    .in('key', keys);

  if (error) throw error;

  return data.map((row) => skillTagSchema.parse(row));
}
