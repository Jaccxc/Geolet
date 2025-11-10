import { z } from 'zod';

// ============================================================================
// Skill Tag Types
// ============================================================================

export const skillFamilySchema = z.enum(['script', 'phone', 'city']);
export type SkillFamily = z.infer<typeof skillFamilySchema>;

export const skillTagMetaSchema = z.object({
  display: z.string(),
  notes: z.string().optional(),
  examples: z.array(z.string()).optional(),
  regions: z.array(z.string()).optional(),
  coverage: z.array(z.string()).optional(),
  region: z.string().optional(),
});

export const skillTagSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  family: skillFamilySchema,
  country: z.string().nullable(),
  meta: skillTagMetaSchema,
});

export type SkillTag = z.infer<typeof skillTagSchema>;

// ============================================================================
// Region Types
// ============================================================================

export const regionKindSchema = z.enum(['country', 'region', 'city']);
export type RegionKind = z.infer<typeof regionKindSchema>;

export const geoJsonGeometrySchema = z.object({
  type: z.enum(['Point', 'Polygon', 'MultiPolygon']),
  coordinates: z.array(z.any()), // Simplified for MVP
});

export const regionSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  kind: regionKindSchema,
  name: z.string(),
  country: z.string().nullable(),
  geometry: geoJsonGeometrySchema.nullable(),
  centroid_lonlat: z.tuple([z.number(), z.number()]).nullable(),
  bbox: z.tuple([z.number(), z.number(), z.number(), z.number()]).nullable(),
  geojson_file: z.string().nullable(),
  geojson_id_property: z.string().nullable(),
  geojson_feature_id: z.string().nullable(),
  meta: z.record(z.any()),
});

export type Region = z.infer<typeof regionSchema>;

// ============================================================================
// Fact Card Types
// ============================================================================

export const factTypeSchema = z.enum(['language_snippet', 'phone_number', 'city_locate']);
export type FactType = z.infer<typeof factTypeSchema>;

export const languagePayloadSchema = z.object({
  text: z.string(),
  romanization: z.string().optional(),
});

export const phonePayloadSchema = z.object({
  number: z.string(),
  masked: z.string().optional(),
});

export const cityPayloadSchema = z.object({
  city: z.string(),
  country_hint: z.string().optional(),
});

export const factPayloadSchema = z.union([
  languagePayloadSchema,
  phonePayloadSchema,
  cityPayloadSchema,
]);

export type FactPayload = z.infer<typeof factPayloadSchema>;

// Answer Contract Types
export const regionAnswerSchema = z.object({
  kind: z.literal('region'),
  select: z.object({
    by: z.literal('key'),
    keys: z.array(z.string()),
  }),
});

export const tagAnswerSchema = z.object({
  kind: z.literal('tag'),
  select: z.object({
    by: z.literal('skill_key'),
    keys: z.array(z.string()),
  }),
  map_equivalents: z.object({
    regions: z.array(z.string()),
  }),
});

export const answerContractSchema = z.union([regionAnswerSchema, tagAnswerSchema]);
export type AnswerContract = z.infer<typeof answerContractSchema>;

export const factCardSchema = z.object({
  id: z.string().uuid(),
  type: factTypeSchema,
  payload: factPayloadSchema,
  primary_tags: z.array(z.string()),
  difficulty: z.number().int().min(1).max(5),
  answer: answerContractSchema,
});

export type FactCard = z.infer<typeof factCardSchema>;

// ============================================================================
// Game Mode Types
// ============================================================================

// Mode format: {content}-{interaction}
// content: language, phone, city
// interaction: pick, map
export const gameModeSchema = z.enum([
  'language-pick',
  'language-map',
  'phone-pick',
  'phone-map',
  'city-pick',
  'city-map',
]);
export type GameMode = z.infer<typeof gameModeSchema>;

export const rapidModeSchema = z.enum(['pick', 'map']);
export type RapidMode = z.infer<typeof rapidModeSchema>;

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
  mode: GameMode;
  targetTags?: string[];
  maxCards?: number;
  prioritizeDue?: boolean;
}

// Pick Mode - Choice options
export interface PickOption {
  key: string;
  label: string;
  correct: boolean;
}

export interface PickQueueItem {
  fact_id: string;
  type: FactType;
  payload: FactPayload;
  difficulty: number;
  options: PickOption[];
}

// Map Mode - Region data for map interaction
export interface MapQueueItem {
  fact_id: string;
  type: FactType;
  payload: FactPayload;
  difficulty: number;
  regions: Region[]; // Regions user can pin on
}

export type QueueItem = PickQueueItem | MapQueueItem;

// ============================================================================
// Grading Types
// ============================================================================

export interface PickGradeItem {
  fact_id: string;
  selected_key: string;
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
  distance?: number; // For map mode
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
