import * as turf from '@turf/turf';
import type { AnswerContract, Region } from '../types';

/**
 * Validate a Pick mode answer (multiple choice)
 */
export function validatePickAnswer(
  answer: AnswerContract,
  selectedKey: string
): boolean {
  if (answer.kind === 'tag') {
    return answer.select.keys.includes(selectedKey);
  }

  if (answer.kind === 'region') {
    return answer.select.keys.includes(selectedKey);
  }

  return false;
}

/**
 * Validate a Map mode answer (pin drop on map)
 * Returns whether correct and optionally the distance from centroid
 */
export function validateMapAnswer(
  answer: AnswerContract,
  clickedPoint: [number, number], // [lng, lat]
  regions: Region[]
): { correct: boolean; distance?: number } {
  const [lng, lat] = clickedPoint;
  const point = turf.point([lng, lat]);

  for (const region of regions) {
    // Strategy 1: Check polygon if available
    if (region.geometry) {
      try {
        const isInside = turf.booleanPointInPolygon(point, region.geometry as any);
        if (isInside) {
          return { correct: true };
        }
      } catch (error) {
        console.error('Polygon validation error:', error);
        // Fall through to centroid strategy
      }
    }

    // Strategy 2: Fallback to centroid + tolerance
    if (region.centroid_lonlat) {
      const [centerLng, centerLat] = region.centroid_lonlat;
      const center = turf.point([centerLng, centerLat]);
      const distance = turf.distance(point, center, { units: 'kilometers' });

      // Tolerance based on region kind
      let tolerance: number;
      if (region.kind === 'country') {
        tolerance = 500; // 500km for countries
      } else if (region.kind === 'region') {
        tolerance = 200; // 200km for states/provinces
      } else {
        tolerance = 50; // 50km for cities
      }

      // Check meta for custom tolerance
      if (region.meta?.tolerance_km) {
        tolerance = region.meta.tolerance_km;
      }

      if (distance <= tolerance) {
        return { correct: true, distance };
      }
    }
  }

  return { correct: false };
}
