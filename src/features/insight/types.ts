import { z } from 'zod';

// ============================================================================
// Insight Round (Imported GeoGuessr data)
// ============================================================================

export const insightRoundSchema = z.object({
  id: z.number().int(),
  user_id: z.string().uuid(),
  played_at: z.string().nullable(),
  country: z.string().nullable(),
  target_country: z.string().nullable(),
  distance_m: z.number().nullable(),
  time_ms: z.number().int().nullable(),
  meta: z.record(z.any()),
});

export type InsightRound = z.infer<typeof insightRoundSchema>;

// ============================================================================
// Analytics Types
// ============================================================================

export interface SkillMapCell {
  family: string;
  country: string;
  accuracy: number;
  count: number;
  avg_time_ms: number;
}

export interface ConfusionPair {
  from_country: string;
  to_country: string;
  count: number;
  accuracy: number;
}

export interface Prescription {
  skill_tags: string[];
  reason: string;
  priority: number;
  weakness_type: 'low_accuracy' | 'confusion' | 'untrained';
}

export interface WeaknessAnalysis {
  skill_tag: string;
  accuracy: number;
  count: number;
  avg_time_ms: number;
  last_seen?: string;
}
