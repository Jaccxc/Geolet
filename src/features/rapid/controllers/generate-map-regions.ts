import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import * as turf from '@turf/turf';

import type { FactCard, Region } from '../types';

/**
 * Get the answer region for Map mode
 * NEW: Simply fetches the answer_region by FK
 */
export async function getAnswerRegion(card: FactCard): Promise<Region> {
  const supabase = await createSupabaseServerClient();

  const { data: region, error } = await supabase
    .from('regions')
    .select('*')
    .eq('id', card.answer_region_id)
    .single();

  if (error || !region) {
    throw new Error(`Answer region not found: ${card.answer_region_id}`);
  }

  return region as Region;
}

/**
 * Calculate bounding box from region geometry
 */
export function calculateBbox(region: Region): [number, number, number, number] {
  if (region.location_type === 'pin' && region.centroid_lonlat) {
    const [lng, lat] = region.centroid_lonlat;
    // Add small buffer around pin (0.5 degrees)
    return [lng - 0.5, lat - 0.5, lng + 0.5, lat + 0.5];
  }

  if (region.location_type === 'polygon' && region.geometry) {
    try {
      // Use turf.js to calculate bbox from geometry
      const bbox = turf.bbox(region.geometry as any);
      return bbox as [number, number, number, number];
    } catch (error) {
      console.error('Error calculating bbox:', error);
    }
  }

  // Fallback: world bbox
  return [-180, -90, 180, 90];
}
