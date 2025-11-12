import { z } from 'zod';

// ============================================================================
// NEW: Card Groups
// ============================================================================

export const cardGroupSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),
  created_at: z.string(),
});

export type CardGroup = z.infer<typeof cardGroupSchema>;

// ============================================================================
// NEW: Topics
// ============================================================================

export const topicDifficultySchema = z.enum(['beginner', 'intermediate', 'advanced']);
export type TopicDifficulty = z.infer<typeof topicDifficultySchema>;

export const topicSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  title: z.string(),
  description: z.string().nullable(),
  icon: z.string().nullable(),
  pick_mode_active: z.boolean(),
  map_mode_active: z.boolean(),
  difficulty: topicDifficultySchema.nullable(),
  target_card_group_ids: z.array(z.string().uuid()),
  created_at: z.string(),
});

export type Topic = z.infer<typeof topicSchema>;

// ============================================================================
// UPDATED: Regions
// ============================================================================

export const regionLevelSchema = z.enum(['country', 'province', 'city']);
export type RegionLevel = z.infer<typeof regionLevelSchema>;

export const locationTypeSchema = z.enum(['pin', 'polygon']);
export type LocationType = z.infer<typeof locationTypeSchema>;

export const geoJsonGeometrySchema = z.object({
  type: z.enum(['Point', 'Polygon', 'MultiPolygon']),
  coordinates: z.array(z.any()), // Simplified for MVP
});

export const regionSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  level: regionLevelSchema,
  name: z.string(),
  country: z.string().nullable(),
  location_type: locationTypeSchema,
  centroid_lonlat: z.tuple([z.number(), z.number()]).nullable(),
  geometry: geoJsonGeometrySchema.nullable(),
  note: z.string().nullable(),
  created_at: z.string(),
});

export type Region = z.infer<typeof regionSchema>;

// ============================================================================
// UPDATED: Skill Tags
// ============================================================================

export const skillFamilySchema = z.enum(['script', 'phone', 'city']);
export type SkillFamily = z.infer<typeof skillFamilySchema>;

export const skillTagSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  family: skillFamilySchema,
  country: z.string().nullable(),
  display: z.string(),
  note: z.string().nullable(),
  examples: z.array(z.string()),
  created_at: z.string(),
});

export type SkillTag = z.infer<typeof skillTagSchema>;

// ============================================================================
// UPDATED: Fact Cards
// ============================================================================

export const factDifficultySchema = z.enum(['1', '2', '3']);
export type FactDifficulty = z.infer<typeof factDifficultySchema>;

export const factCardSchema = z.object({
  id: z.string().uuid(),
  card_group_id: z.string().uuid(),
  prompt: z.string(),
  hint: z.string().nullable(),
  primary_skill_tags: z.array(z.string()),
  difficulty: factDifficultySchema,
  answer_region_id: z.string().uuid(),
  created_at: z.string(),
});

export type FactCard = z.infer<typeof factCardSchema>;

// Extended fact card with populated answer region
export type FactCardWithAnswer = FactCard & {
  answer_region: Region;
};

// ============================================================================
// Game Mode Types
// ============================================================================

export const gameModeSchema = z.enum(['pick', 'map']);
export type GameMode = z.infer<typeof gameModeSchema>;

// ============================================================================
// Session Types
// ============================================================================

export const sessionSummarySchema = z.object({
  accuracy: z.number(),
  avg_time_ms: z.number(),
  total_cards: z.number(),
  correct_count: z.number(),
  tag_breakdown: z.record(
    z.object({
      seen: z.number(),
      correct: z.number(),
    })
  ),
});

export type SessionSummary = z.infer<typeof sessionSummarySchema>;

export const gameSessionSchema = z.object({
  id: z.string().uuid(),
  user_id: z.string().uuid(),
  mode: z.string(),
  created_at: z.string(),
  summary: sessionSummarySchema,
});

export type GameSession = z.infer<typeof gameSessionSchema>;

// ============================================================================
// Queue Types
// ============================================================================

export interface QueueOptions {
  topicKey?: string;
  cardGroupIds?: string[];
  maxCards?: number;
  prioritizeDue?: boolean;
}

// Pick Mode options
export interface PickOption {
  region_id: string;
  label: string;
  correct: boolean;
}

export interface PickQueueItem {
  fact_id: string;
  card_group_id: string;
  prompt: string;
  hint: string | null;
  difficulty: FactDifficulty;
  options: PickOption[];
}

// Map Mode
export interface MapQueueItem {
  fact_id: string;
  card_group_id: string;
  prompt: string;
  hint: string | null;
  difficulty: FactDifficulty;
  answer_region: Region;
  bbox: [number, number, number, number];
}

export type QueueItem = PickQueueItem | MapQueueItem;

// ============================================================================
// Grading Types
// ============================================================================

export interface PickGradeItem {
  fact_id: string;
  selected_region_id: string;
  time_ms: number;
}

export interface MapGradeItem {
  fact_id: string;
  clicked_point: [number, number]; // [lng, lat]
  time_ms: number;
}

export interface GradeResult {
  fact_id: string;
  correct: boolean;
  time_ms: number;
  distance?: number;
  srs: {
    new_ease: number;
    due_at: string;
    interval_days: number;
  };
}

export interface GradeSummary {
  total: number;
  correct: number;
  accuracy: number;
  avg_time_ms: number;
}
