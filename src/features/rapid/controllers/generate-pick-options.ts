import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, PickOption } from '../types';

/**
 * Generate multiple-choice options for Pick mode
 * Returns 1 correct answer + 5 distractors (shuffled)
 */
export async function generatePickOptions(card: FactCard): Promise<PickOption[]> {
  const supabase = await createSupabaseServerClient();
  const answer = card.answer;

  if (answer.kind === 'tag') {
    // Get correct tag(s)
    const { data: correctTags } = await supabase.from('skill_tags').select('*').in('key', answer.select.keys);

    if (!correctTags || correctTags.length === 0) {
      throw new Error(`Correct tags not found: ${answer.select.keys.join(', ')}`);
    }

    // Get distractor tags (same family, different keys)
    const family = correctTags[0]?.family;
    const { data: allTags } = await supabase.from('skill_tags').select('*').eq('family', family).limit(30);

    // Build options
    const distractors = (allTags || [])
      .filter((t) => !answer.select.keys.includes(t.key))
      .sort(() => Math.random() - 0.5)
      .slice(0, 5);

    const options: PickOption[] = [
      ...correctTags.map((t) => ({
        key: t.key,
        label: (t.meta as { display: string })?.display || t.key,
        correct: true,
      })),
      ...distractors.map((t) => ({
        key: t.key,
        label: (t.meta as { display: string })?.display || t.key,
        correct: false,
      })),
    ];

    return shuffleArray(options);
  }

  if (answer.kind === 'region') {
    // Get correct region(s)
    const { data: correctRegions } = await supabase.from('regions').select('*').in('key', answer.select.keys);

    if (!correctRegions || correctRegions.length === 0) {
      throw new Error(`Correct regions not found: ${answer.select.keys.join(', ')}`);
    }

    // Get distractor regions (same kind, different keys)
    const kind = correctRegions[0]?.kind;
    const { data: allRegions } = await supabase.from('regions').select('*').eq('kind', kind).limit(30);

    const distractors = (allRegions || [])
      .filter((r) => !answer.select.keys.includes(r.key))
      .sort(() => Math.random() - 0.5)
      .slice(0, 5);

    const options: PickOption[] = [
      ...correctRegions.map((r) => ({
        key: r.key,
        label: r.name,
        correct: true,
      })),
      ...distractors.map((r) => ({
        key: r.key,
        label: r.name,
        correct: false,
      })),
    ];

    return shuffleArray(options);
  }

  throw new Error('Invalid answer kind');
}

function shuffleArray<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
