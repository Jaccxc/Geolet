import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, PickOption, Topic } from '../types';

/**
 * Generate multiple-choice options for Pick mode
 * Returns 1 correct answer + 5 distractors (shuffled)
 *
 * If topic.use_country_region is true, will display country regions
 * instead of the answer region (useful for city-level cards)
 */
export async function generatePickOptions(
  card: FactCard,
  topic: Topic | null = null
): Promise<PickOption[]> {
  const supabase = await createSupabaseServerClient();

  // Get the correct answer region
  const { data: correctRegion, error } = await supabase
    .from('regions')
    .select('*')
    .eq('id', card.answer_region_id)
    .single();

  if (error || !correctRegion) {
    throw new Error(`Answer region not found: ${card.answer_region_id}`);
  }

  // Determine which region to use for display
  let displayRegion = correctRegion;

  if (topic?.use_country_region && correctRegion.country) {
    // Fetch the country region using the country code
    const { data: countryRegion } = await supabase
      .from('regions')
      .select('*')
      .eq('key', correctRegion.country)
      .single();

    if (countryRegion) {
      displayRegion = countryRegion;
    }
  }

  // Get distractor regions (same level as display region)
  const { data: allRegions } = await supabase
    .from('regions')
    .select('*')
    .eq('level', displayRegion.level)
    .neq('id', displayRegion.id)
    .limit(50);

  if (!allRegions || allRegions.length < 5) {
    throw new Error(`Not enough distractor regions for level: ${displayRegion.level}`);
  }

  // Randomly select 5 distractors
  const distractors = shuffleArray(allRegions).slice(0, 5);

  // Build options using displayRegion for labels
  // BUT keep correctRegion.id for validation!
  const options: PickOption[] = [
    {
      region_id: correctRegion.id, // IMPORTANT: Still use original for grading!
      label: displayRegion.name,
      correct: true,
    },
    ...distractors.map((r) => ({
      region_id: r.id,
      label: r.name,
      correct: false,
    })),
  ];

  return shuffleArray(options);
}

function shuffleArray<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
