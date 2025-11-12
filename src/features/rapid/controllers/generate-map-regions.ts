import type { FactCard, Region } from '../types';

import { getRegionsByKeys } from './get-regions';

/**
 * Generate region data for Map mode
 * Returns regions that the user can pin on
 */
export async function generateMapRegions(card: FactCard): Promise<Region[]> {
  const answer = card.answer;
  let regionKeys: string[] = [];

  if (answer.kind === 'tag') {
    // For tag-based answers, use map_equivalents
    regionKeys = answer.map_equivalents?.regions || [];
  } else if (answer.kind === 'region') {
    // For region-based answers, use select.keys directly
    regionKeys = answer.select.keys;
  }

  if (regionKeys.length === 0) {
    throw new Error(`No regions found for card ${card.id}`);
  }

  // Fetch region data with GeoJSON references
  const regions = await getRegionsByKeys(regionKeys);

  if (regions.length === 0) {
    throw new Error(`Regions not found in database: ${regionKeys.join(', ')}`);
  }

  return regions;
}

/**
 * Helper to extract region keys from a fact card's answer
 */
export function getAnswerRegionKeys(card: FactCard): string[] {
  if (card.answer.kind === 'tag') {
    return card.answer.map_equivalents?.regions || [];
  }
  return card.answer.select.keys;
}
