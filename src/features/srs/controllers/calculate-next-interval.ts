import type { SRSQuality, SRSState } from '../types';

/**
 * SM-2-lite algorithm for spaced repetition
 *
 * Quality scale:
 * - 5: Perfect (correct + fast < 5s)
 * - 4: Correct (correct + slow >= 5s)
 * - 3: Hesitant (barely correct)
 * - 2: Wrong
 * - 1-0: Complete blackout
 */
export function calculateNextInterval(
  currentEase: number,
  currentInterval: number,
  seen: number,
  quality: SRSQuality
): SRSState {
  // Update ease factor using SM-2 formula
  let newEase =
    currentEase + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  newEase = Math.max(1.3, newEase); // Minimum ease factor

  // Calculate interval
  let interval: number;

  if (quality < 3) {
    // Wrong answer → review tomorrow
    interval = 1;
  } else if (seen === 0) {
    // First time correct → 1 day
    interval = 1;
  } else if (seen === 1) {
    // Second time correct → 6 days
    interval = 6;
  } else {
    // Subsequent reviews → multiply by ease
    interval = Math.round(currentInterval * newEase);
  }

  return {
    ease: newEase,
    interval_days: interval,
  };
}

export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}
