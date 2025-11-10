import { z } from 'zod';

// ============================================================================
// SRS Quality (SM-2 Algorithm)
// ============================================================================

// Quality scale:
// 5 = Perfect (correct + fast)
// 4 = Correct (correct + slow)
// 3 = Hesitant (barely correct)
// 2 = Wrong
// 1 = Complete blackout
// 0 = Complete blackout
export const srsQualitySchema = z.number().int().min(0).max(5);
export type SRSQuality = z.infer<typeof srsQualitySchema>;

// ============================================================================
// User Fact Stats
// ============================================================================

export const userFactStatSchema = z.object({
  user_id: z.string().uuid(),
  fact_id: z.string().uuid(),
  seen: z.number().int(),
  correct: z.number().int(),
  ease: z.number(),
  last_seen_at: z.string().nullable(),
  due_at: z.string().nullable(),
});

export type UserFactStat = z.infer<typeof userFactStatSchema>;

// ============================================================================
// SRS Update Types
// ============================================================================

export interface SRSUpdateInput {
  fact_id: string;
  quality: SRSQuality;
  time_ms: number;
}

export interface SRSUpdateResult {
  fact_id: string;
  correct: boolean;
  new_ease: number;
  due_at: Date;
  interval_days: number;
}

export interface SRSState {
  ease: number;
  interval_days: number;
}
