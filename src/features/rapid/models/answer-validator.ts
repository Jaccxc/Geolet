import * as turf from '@turf/turf';

import type { Region } from '../types';

import { getDayOfWeek, getDoomsdayForYear } from './doomsday-calculator';

/**
 * Validate a Pick mode answer
 * NEW: Validates by region_id instead of generic key
 */
export function validatePickAnswer(correctRegionId: string, selectedRegionId: string): boolean {
  return correctRegionId === selectedRegionId;
}

/**
 * Validate a Map mode answer (pin drop on map)
 */
export function validateMapAnswer(
  answerRegion: Region,
  clickedPoint: [number, number] // [lng, lat]
): { correct: boolean; distance?: number } {
  const [lng, lat] = clickedPoint;
  const point = turf.point([lng, lat]);

  // Strategy 1: Check polygon if available
  if (answerRegion.location_type === 'polygon' && answerRegion.geometry) {
    try {
      const isInside = turf.booleanPointInPolygon(point, answerRegion.geometry as any);
      if (isInside) {
        return { correct: true };
      }
    } catch (error) {
      console.error('Polygon validation error:', error);
      // Fall through to centroid strategy
    }
  }

  // Strategy 2: Fallback to centroid + tolerance
  if (answerRegion.centroid_lonlat) {
    const [centerLng, centerLat] = answerRegion.centroid_lonlat;
    const center = turf.point([centerLng, centerLat]);
    const distance = turf.distance(point, center, { units: 'kilometers' });

    // Tolerance based on region level
    let tolerance: number;
    if (answerRegion.level === 'country') {
      tolerance = 500; // 500km for countries
    } else if (answerRegion.level === 'province') {
      tolerance = 200; // 200km for provinces
    } else {
      tolerance = 50; // 50km for cities
    }

    if (distance <= tolerance) {
      return { correct: true, distance };
    }
  }

  return { correct: false };
}

/**
 * Validate a Doomsday drill answer.
 * The server re-derives the expected answer from question_params — does not trust selected_value alone.
 */
export function validateDoomsdayAnswer(
  cardType: string,
  questionParams: Record<string, unknown>,
  selectedValue: string
): boolean {
  const selected = parseInt(selectedValue, 10);
  if (isNaN(selected)) return false;

  switch (cardType) {
    case 'doomsday_month': {
      const correctDate = questionParams.correct_date as number;
      return selected === correctDate;
    }
    case 'doomsday_year_template': {
      const year = questionParams.year as number;
      return selected === getDoomsdayForYear(year);
    }
    case 'doomsday_anchor_template': {
      const offset = questionParams.offset as number;
      return selected === offset;
    }
    case 'doomsday_full_template': {
      const { year, month, day } = questionParams as { year: number; month: number; day: number };
      return selected === getDayOfWeek(year, month, day);
    }
    default:
      return false;
  }
}
