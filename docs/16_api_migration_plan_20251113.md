# API & Application Migration Plan - New Database Schema

**Created:** 2025-11-13
**Status:** Implementation Blueprint
**Purpose:** Comprehensive plan to migrate APIs, types, controllers, and UI to work with the new optimized database schema

**Related Documents:**
- [Database Fresh Migration Plan](./15_database_fresh_migration_plan_20251112_174624.md)
- Schema Migrations: `supabase/migrations/20251112180204_fresh_schema.sql` and following

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Schema Comparison & Breaking Changes](#2-schema-comparison--breaking-changes)
3. [Migration Strategy](#3-migration-strategy)
4. [Type System Updates](#4-type-system-updates)
5. [Controller Layer Migration](#5-controller-layer-migration)
6. [API Routes Migration](#6-api-routes-migration)
7. [UI Components Migration](#7-ui-components-migration)
8. [Data Migration Scripts](#8-data-migration-scripts)
9. [Testing Strategy](#9-testing-strategy)
10. [Rollout Plan](#10-rollout-plan)
11. [Appendix](#11-appendix)

---

## 1. Executive Summary

### 1.1 Current State

The application currently uses a **flexible but complex** schema:
- `fact_cards` with JSONB `payload` and `answer` contract
- `skill_tags` with JSONB `meta` field
- `regions` with external GeoJSON references
- No concept of `card_groups` or `topics`

### 1.2 Target State

The new schema is **normalized and type-safe**:
- `fact_cards` with direct FK relationships (`card_group_id`, `answer_region_id`)
- Flattened `skill_tags` with typed columns
- `regions` with inline GeoJSON storage and PostgreSQL ENUMs
- New `card_groups` and `topics` tables for organization

### 1.3 Migration Scope

**Must Update:**
1. Database types (`database.types.ts`)
2. Application types (`features/rapid/types.ts`)
3. Controllers (all 6 controller files)
4. API routes (queue and grade endpoints)
5. UI components (PickModeTab, MapModeTab)
6. Answer validation logic
7. Data migration scripts for existing fact_cards

**Estimated Effort:** 2-3 days for full migration + testing

---

## 2. Schema Comparison & Breaking Changes

### 2.1 `fact_cards` Table - MAJOR BREAKING CHANGE

#### Old Schema
```typescript
{
  id: string;
  type: 'language_snippet' | 'phone_number' | 'city_locate';  // String enum
  payload: {
    // JSONB - varies by type
    text?: string;
    romanization?: string;
    number?: string;
    masked?: string;
    city?: string;
    country_hint?: string;
  };
  primary_tags: string[];  // Array of skill tag keys
  difficulty: 1 | 2 | 3 | 4 | 5;  // Number 1-5
  answer: {
    // JSONB contract - complex
    kind: 'tag' | 'region';
    select: {
      by: 'key' | 'skill_key';
      keys: string[];
    };
    map_equivalents?: {
      regions: string[];
    };
  };
}
```

#### New Schema
```typescript
{
  id: string;
  card_group_id: string;  // FK to card_groups - NEW
  prompt: string;  // Main content (replaces payload)
  hint: string | null;  // Auxiliary info (replaces payload)
  primary_skill_tags: string[];  // Same as old primary_tags
  difficulty: '1' | '2' | '3';  // ENUM strings (not number)
  answer_region_id: string;  // FK to regions - REPLACES answer contract
  created_at: string;
}
```

**Breaking Changes:**
1. ❌ `type` field removed → card type inferred from `card_group`
2. ❌ `payload` JSONB removed → flattened to `prompt` + `hint`
3. ❌ `answer` JSONB contract removed → replaced with direct `answer_region_id` FK
4. ❌ `difficulty` changed from number to ENUM string
5. ✅ NEW `card_group_id` FK required
6. 🔄 `primary_tags` renamed to `primary_skill_tags`

**Impact:** 🔴 **CRITICAL** - Core data model changed, requires full rewrite of controllers and validation logic

---

### 2.2 `skill_tags` Table - MODERATE BREAKING CHANGE

#### Old Schema
```typescript
{
  id: string;
  key: string;
  family: 'script' | 'phone' | 'city';  // String
  country: string | null;
  meta: {
    // JSONB
    display: string;
    notes?: string;
    examples?: string[];
    regions?: string[];
    coverage?: string[];
    region?: string;
  };
}
```

#### New Schema
```typescript
{
  id: string;
  key: string;
  family: 'script' | 'phone' | 'city';  // ENUM
  country: string | null;
  display: string;  // Extracted from meta
  note: string | null;  // Extracted from meta.notes
  examples: string[];  // Extracted from meta.examples
  created_at: string;
}
```

**Breaking Changes:**
1. ❌ `meta` JSONB removed → flattened to typed columns
2. 🔄 `family` changed from string to ENUM (same values)
3. ✅ `display`, `note`, `examples` are now top-level columns

**Impact:** 🟡 **MODERATE** - Data structure changed but fields mostly mapped 1:1

---

### 2.3 `regions` Table - MODERATE BREAKING CHANGE

#### Old Schema
```typescript
{
  id: string;
  key: string;
  kind: 'country' | 'region' | 'city';  // String
  name: string;
  country: string | null;
  geometry: GeoJSON.Geometry | null;  // JSONB
  centroid_lonlat: [number, number] | null;
  bbox: [number, number, number, number] | null;
  geojson_file: string | null;  // External reference
  geojson_id_property: string | null;  // External reference
  geojson_feature_id: string | null;  // External reference
  meta: Record<string, any>;  // JSONB
}
```

#### New Schema
```typescript
{
  id: string;
  key: string;
  level: 'country' | 'province' | 'city';  // ENUM (note: 'province' not 'region')
  name: string;
  country: string | null;
  location_type: 'pin' | 'polygon';  // ENUM - NEW
  centroid_lonlat: [number, number] | null;  // For 'pin' type
  geometry: GeoJSON.Geometry | null;  // For 'polygon' type - JSONB
  note: string | null;  // Replaces meta
  created_at: string;
}
```

**Breaking Changes:**
1. ❌ `kind` renamed to `level`, value changed from `'region'` → `'province'`
2. ❌ `meta` JSONB removed → replaced with `note` text field
3. ✅ NEW `location_type` ENUM distinguishes pin vs polygon
4. ❌ `bbox` removed (can be calculated from geometry)
5. ❌ External GeoJSON references removed (`geojson_file`, etc.)
6. ✅ `geometry` now stores data inline (no external files)

**Impact:** 🟡 **MODERATE** - Field names changed, geometry handling simplified

---

### 2.4 NEW Tables

#### `card_groups` (NEW)
```typescript
{
  id: string;
  name: string;  // Unique
  created_at: string;
}
```

**Purpose:** Logical groupings of fact cards (e.g., "India Scripts", "Global Phone Codes")

**Examples:**
- `"India Regional Languages"`
- `"Indian Phone Codes"`
- `"Global Phone Codes"`
- `"Major Cities - India"`

---

#### `topics` (NEW)
```typescript
{
  id: string;
  key: string;  // Unique
  title: string;
  description: string | null;
  icon: string | null;  // Lucide icon name
  pick_mode_active: boolean;
  map_mode_active: boolean;
  difficulty: 'beginner' | 'intermediate' | 'advanced' | null;
  target_card_group_ids: string[];  // Array of card_group IDs
  created_at: string;
}
```

**Purpose:** Game topics that define which card groups are used and which modes are active

**Examples:**
```json
{
  "key": "india-languages",
  "title": "Indian Languages",
  "description": "Identify Indian regional scripts",
  "icon": "Languages",
  "pick_mode_active": true,
  "map_mode_active": true,
  "difficulty": "intermediate",
  "target_card_group_ids": ["<uuid-of-india-scripts-card-group>"]
}
```

---

## 3. Migration Strategy

### 3.1 Phased Approach

**Phase 1: Types & Schema (Day 1 Morning)**
1. Regenerate `database.types.ts` from new schema
2. Update `features/rapid/types.ts` to match new schema
3. Create new type definitions for `CardGroup` and `Topic`
4. Update Zod schemas

**Phase 2: Controllers (Day 1 Afternoon)**
1. Update `get-fact-cards.ts` for new fact_cards structure
2. Rewrite `build-queue.ts` to work with topics and card_groups
3. Update `generate-pick-options.ts` for new answer model
4. Rewrite `generate-map-regions.ts` for new regions structure
5. Update `answer-validator.ts` for direct FK validation

**Phase 3: API Routes (Day 2 Morning)**
1. Update `/api/rapid/queue` endpoint
2. Update `/api/rapid/grade` endpoint
3. Add new endpoints for topics listing (optional)

**Phase 4: UI & Components (Day 2 Afternoon)**
1. Update `PickModeTab` component
2. Update `MapModeTab` component
3. Update game session components
4. Test end-to-end flow

**Phase 5: Data Migration (Day 3)**
1. Write scripts to convert existing fact_cards to new format
2. Create initial card_groups
3. Create initial topics
4. Migrate and test

### 3.2 Backwards Compatibility Strategy

**NOT POSSIBLE** - The schema changes are too fundamental. We must:
1. Backup existing data
2. Perform clean migration
3. Test thoroughly in staging
4. Deploy with downtime window

---

## 4. Type System Updates

### 4.1 Update `database.types.ts`

**Action:** Regenerate from Supabase CLI

```bash
# Generate new types
npx supabase gen types typescript --project-id <project-id> > src/libs/supabase/database.types.ts
```

**Expected Changes:**
- `fact_cards` table definition updated
- `skill_tags` table definition updated
- `regions` table definition updated
- New `card_groups` table added
- New `topics` table added
- New ENUMs added: `region_level_enum`, `location_type_enum`, `skill_family_enum`, `difficulty_enum`, `fact_difficulty_enum`

---

### 4.2 Update `features/rapid/types.ts`

#### Remove Old Types
```typescript
// ❌ REMOVE
export const factTypeSchema = z.enum(['language_snippet', 'phone_number', 'city_locate']);
export type FactType = z.infer<typeof factTypeSchema>;

export const languagePayloadSchema = z.object({ ... });
export const phonePayloadSchema = z.object({ ... });
export const cityPayloadSchema = z.object({ ... });
export const factPayloadSchema = z.union([...]);

export const regionKindSchema = z.enum(['country', 'region', 'city']);
export type RegionKind = z.infer<typeof regionKindSchema>;

// Complex answer contract - REMOVE
export const regionAnswerSchema = z.object({ ... });
export const tagAnswerSchema = z.object({ ... });
export const answerContractSchema = z.union([...]);
```

#### Add New Types
```typescript
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

export const regionSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  level: regionLevelSchema,  // Changed from 'kind'
  name: z.string(),
  country: z.string().nullable(),
  location_type: locationTypeSchema,  // NEW
  centroid_lonlat: z.tuple([z.number(), z.number()]).nullable(),
  geometry: z.any().nullable(),  // GeoJSON Geometry
  note: z.string().nullable(),  // Changed from 'meta'
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
  display: z.string(),  // Extracted from meta
  note: z.string().nullable(),  // Extracted from meta.notes
  examples: z.array(z.string()),  // Extracted from meta.examples
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
  card_group_id: z.string().uuid(),  // NEW
  prompt: z.string(),  // Replaces 'payload'
  hint: z.string().nullable(),  // Replaces 'payload'
  primary_skill_tags: z.array(z.string()),  // Renamed from 'primary_tags'
  difficulty: factDifficultySchema,  // Changed to string enum
  answer_region_id: z.string().uuid(),  // NEW - replaces 'answer' contract
  created_at: z.string(),
});

export type FactCard = z.infer<typeof factCardSchema>;

// ============================================================================
// Queue Types - UPDATED
// ============================================================================

export interface QueueOptions {
  topicKey?: string;  // NEW - filter by topic
  cardGroupIds?: string[];  // NEW - filter by card groups
  maxCards?: number;
  prioritizeDue?: boolean;
}

// Pick Mode options - UPDATED
export interface PickOption {
  region_id: string;  // Changed from 'key'
  label: string;
  correct: boolean;
}

export interface PickQueueItem {
  fact_id: string;
  card_group_id: string;  // NEW
  prompt: string;  // Changed from 'payload'
  hint: string | null;  // Changed from 'payload'
  difficulty: FactDifficulty;
  options: PickOption[];
}

// Map Mode - UPDATED
export interface MapQueueItem {
  fact_id: string;
  card_group_id: string;  // NEW
  prompt: string;  // Changed from 'payload'
  hint: string | null;  // Changed from 'payload'
  difficulty: FactDifficulty;
  answer_region: Region;  // Changed - single region instead of array
  bbox: [number, number, number, number];  // Calculated from answer_region
}

// ============================================================================
// Grading Types - UPDATED
// ============================================================================

export interface PickGradeItem {
  fact_id: string;
  selected_region_id: string;  // Changed from 'selected_key'
  time_ms: number;
}

export interface MapGradeItem {
  fact_id: string;
  clicked_point: [number, number];  // [lng, lat]
  time_ms: number;
}

// GradeResult stays the same
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
```

---

## 5. Controller Layer Migration

### 5.1 `get-fact-cards.ts` - REWRITE

**File:** `src/features/rapid/controllers/get-fact-cards.ts`

#### New Implementation
```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard } from '../types';
import { factCardSchema } from '../types';

/**
 * Get fact cards with optional filters
 * NEW: Supports filtering by card_group_ids and topics
 */
export async function getFactCards(options?: {
  cardGroupIds?: string[];
  skillTags?: string[];
  limit?: number;
}): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase
    .from('fact_cards')
    .select('*');

  if (options?.cardGroupIds && options.cardGroupIds.length > 0) {
    query = query.in('card_group_id', options.cardGroupIds);
  }

  if (options?.skillTags && options.skillTags.length > 0) {
    query = query.overlaps('primary_skill_tags', options.skillTags);
  }

  if (options?.limit) {
    query = query.limit(options.limit);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => factCardSchema.parse(row));
}

/**
 * Get fact card by ID with answer region populated
 */
export async function getFactCardById(id: string): Promise<
  (FactCard & { answer_region: Region }) | null
> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase
    .from('fact_cards')
    .select(`
      *,
      answer_region:regions!answer_region_id (*)
    `)
    .eq('id', id)
    .single();

  if (error) return null;

  return {
    ...factCardSchema.parse(data),
    answer_region: data.answer_region,
  };
}

/**
 * Get fact cards by topic key
 * NEW: Fetches cards from all card groups associated with a topic
 */
export async function getFactCardsByTopic(topicKey: string, limit?: number): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();

  // First, get the topic
  const { data: topic, error: topicError } = await supabase
    .from('topics')
    .select('target_card_group_ids')
    .eq('key', topicKey)
    .single();

  if (topicError || !topic?.target_card_group_ids) {
    throw new Error(`Topic not found: ${topicKey}`);
  }

  // Then, get fact cards from those card groups
  return getFactCards({
    cardGroupIds: topic.target_card_group_ids,
    limit,
  });
}
```

**Breaking Changes:**
- ❌ `getFactCards(type, tags, limit)` → `getFactCards({ cardGroupIds, skillTags, limit })`
- ✅ NEW `getFactCardsByTopic(topicKey, limit)`
- ✅ `getFactCardById` now returns populated `answer_region`

---

### 5.2 `build-queue.ts` - REWRITE

**File:** `src/features/rapid/controllers/build-queue.ts`

#### New Implementation
```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard, QueueOptions } from '../types';
import { getFactCards, getFactCardsByTopic } from './get-fact-cards';

export async function buildQueue(userId: string, options: QueueOptions): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();
  const maxCards = options.maxCards ?? 20;

  let cards: FactCard[];

  // Strategy 1: Build queue from topic
  if (options.topicKey) {
    cards = await getFactCardsByTopic(options.topicKey);
  }
  // Strategy 2: Build queue from card group IDs
  else if (options.cardGroupIds && options.cardGroupIds.length > 0) {
    cards = await getFactCards({ cardGroupIds: options.cardGroupIds });
  }
  // Strategy 3: Get all cards (fallback)
  else {
    cards = await getFactCards();
  }

  // Join with user_fact_stats
  const cardIds = cards.map((c) => c.id);
  const { data: stats } = await supabase
    .from('user_fact_stats')
    .select('*')
    .eq('user_id', userId)
    .in('fact_id', cardIds);

  const statsMap = new Map(stats?.map((s) => [s.fact_id, s]) || []);

  // Score and prioritize cards
  const scored = cards.map((card) => {
    const stat = statsMap.get(card.id);
    let score = 0;

    // Prioritize due cards (highest priority)
    if (stat?.due_at && new Date(stat.due_at) <= new Date()) {
      score += 1000;
    }

    // Prioritize unseen cards (high priority)
    if (!stat || stat.seen === 0) {
      score += 500;
    }

    // Prioritize cards with low accuracy (medium priority)
    if (stat && stat.seen > 0) {
      const accuracy = stat.correct / stat.seen;
      score += (1 - accuracy) * 100;
    }

    // Add randomness for variety
    score += Math.random() * 10;

    return { card, score };
  });

  // Sort by score (descending) and take maxCards
  scored.sort((a, b) => b.score - a.score);

  return scored.slice(0, maxCards).map(({ card }) => card);
}
```

**Breaking Changes:**
- ❌ No more `mode` parameter (mode is now derived from topic/card_group)
- ✅ NEW `topicKey` option
- ✅ NEW `cardGroupIds` option

---

### 5.3 `generate-pick-options.ts` - MAJOR REWRITE

**File:** `src/features/rapid/controllers/generate-pick-options.ts`

#### New Implementation
```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard, PickOption, Region } from '../types';

/**
 * Generate multiple-choice options for Pick mode
 * Returns 1 correct answer + 5 distractors (shuffled)
 *
 * NEW: Works with answer_region_id FK instead of answer contract
 */
export async function generatePickOptions(card: FactCard): Promise<PickOption[]> {
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

  // Get distractor regions (same level, different keys)
  const { data: allRegions } = await supabase
    .from('regions')
    .select('*')
    .eq('level', correctRegion.level)
    .neq('id', correctRegion.id)
    .limit(50);

  if (!allRegions || allRegions.length < 5) {
    throw new Error(`Not enough distractor regions for level: ${correctRegion.level}`);
  }

  // Randomly select 5 distractors
  const distractors = shuffleArray(allRegions).slice(0, 5);

  // Build options
  const options: PickOption[] = [
    {
      region_id: correctRegion.id,
      label: correctRegion.name,
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
```

**Breaking Changes:**
- ❌ No more complex `answer.kind` logic
- ❌ No more tag-based answers
- ✅ Simpler FK-based approach
- ✅ Options now use `region_id` instead of generic `key`

---

### 5.4 `generate-map-regions.ts` - MAJOR REWRITE

**File:** `src/features/rapid/controllers/generate-map-regions.ts`

#### New Implementation
```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
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

  return region;
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
    // Use turf.js to calculate bbox from geometry
    const turf = require('@turf/turf');
    const bbox = turf.bbox(region.geometry);
    return bbox as [number, number, number, number];
  }

  // Fallback: world bbox
  return [-180, -90, 180, 90];
}
```

**Breaking Changes:**
- ❌ No more `generateMapRegions` returning array
- ✅ NEW `getAnswerRegion` returns single region
- ✅ NEW `calculateBbox` helper

---

### 5.5 `answer-validator.ts` - REWRITE

**File:** `src/features/rapid/models/answer-validator.ts`

#### New Implementation
```typescript
import * as turf from '@turf/turf';
import type { Region } from '../types';

/**
 * Validate a Pick mode answer
 * NEW: Validates by region_id instead of generic key
 */
export function validatePickAnswer(
  correctRegionId: string,
  selectedRegionId: string
): boolean {
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
```

**Breaking Changes:**
- ❌ `validatePickAnswer(answer, selectedKey)` → `validatePickAnswer(correctRegionId, selectedRegionId)`
- ❌ `validateMapAnswer(answer, clickedPoint, regions)` → `validateMapAnswer(answerRegion, clickedPoint)`
- ✅ Simplified - no more answer contract parsing

---

### 5.6 NEW: `get-topics.ts`

**File:** `src/features/rapid/controllers/get-topics.ts` (NEW)

```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import type { Topic } from '../types';
import { topicSchema } from '../types';

/**
 * Get all topics with optional mode filter
 */
export async function getTopics(options?: {
  pickModeActive?: boolean;
  mapModeActive?: boolean;
}): Promise<Topic[]> {
  const supabase = await createSupabaseServerClient();

  let query = supabase.from('topics').select('*');

  if (options?.pickModeActive) {
    query = query.eq('pick_mode_active', true);
  }

  if (options?.mapModeActive) {
    query = query.eq('map_mode_active', true);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map((row) => topicSchema.parse(row));
}

/**
 * Get topic by key
 */
export async function getTopicByKey(key: string): Promise<Topic | null> {
  const supabase = await createSupabaseServerClient();

  const { data, error } = await supabase
    .from('topics')
    .select('*')
    .eq('key', key)
    .single();

  if (error) return null;

  return topicSchema.parse(data);
}
```

---

## 6. API Routes Migration

### 6.1 `/api/rapid/queue` - UPDATE

**File:** `src/app/api/rapid/queue/route.ts`

#### Updated Implementation
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { buildQueue } from '@/features/rapid/controllers/build-queue';
import { getAnswerRegion, calculateBbox } from '@/features/rapid/controllers/generate-map-regions';
import { generatePickOptions } from '@/features/rapid/controllers/generate-pick-options';
import type { MapQueueItem, PickQueueItem } from '@/features/rapid/types';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const requestSchema = z.object({
  mode: z.enum(['pick', 'map']),  // Simplified - just pick or map
  topicKey: z.string().optional(),
  cardGroupIds: z.array(z.string().uuid()).optional(),
  maxCards: z.number().int().min(1).max(50).optional(),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, topicKey, cardGroupIds, maxCards } = requestSchema.parse(body);

    // Build queue
    const cards = await buildQueue(user.id, {
      topicKey,
      cardGroupIds,
      maxCards,
    });

    // Generate appropriate queue items
    if (mode === 'pick') {
      // Pick Mode: Generate choice options
      const queueItems: PickQueueItem[] = await Promise.all(
        cards.map(async (card) => ({
          fact_id: card.id,
          card_group_id: card.card_group_id,
          prompt: card.prompt,
          hint: card.hint,
          difficulty: card.difficulty,
          options: await generatePickOptions(card),
        }))
      );

      return NextResponse.json({
        mode,
        items: queueItems,
        total: queueItems.length,
      });
    } else {
      // Map Mode: Get answer region
      const queueItems: MapQueueItem[] = await Promise.all(
        cards.map(async (card) => {
          const answerRegion = await getAnswerRegion(card);
          const bbox = calculateBbox(answerRegion);

          return {
            fact_id: card.id,
            card_group_id: card.card_group_id,
            prompt: card.prompt,
            hint: card.hint,
            difficulty: card.difficulty,
            answer_region: answerRegion,
            bbox,
          };
        })
      );

      return NextResponse.json({
        mode,
        items: queueItems,
        total: queueItems.length,
      });
    }
  } catch (error) {
    console.error('Queue error:', error);
    return NextResponse.json(
      {
        error: 'Failed to build queue',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
```

**Breaking Changes:**
- ❌ `mode` enum simplified from `'language-pick'` → `'pick'` (content type from topic)
- ✅ NEW `topicKey` parameter
- ✅ NEW `cardGroupIds` parameter
- ❌ Removed `targetTags` parameter

---

### 6.2 `/api/rapid/grade` - UPDATE

**File:** `src/app/api/rapid/grade/route.ts`

#### Updated Implementation
```typescript
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { getAnswerRegion } from '@/features/rapid/controllers/generate-map-regions';
import { getFactCardById } from '@/features/rapid/controllers/get-fact-cards';
import { validateMapAnswer, validatePickAnswer } from '@/features/rapid/models/answer-validator';
import type { GradeResult, GradeSummary, MapGradeItem, PickGradeItem } from '@/features/rapid/types';
import { updateUserFactStat } from '@/features/srs/controllers/update-user-fact-stat';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const pickGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_region_id: z.string().uuid(),  // Changed from selected_key
  time_ms: z.number().int(),
});

const mapGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  clicked_point: z.tuple([z.number(), z.number()]),
  time_ms: z.number().int(),
});

const requestSchema = z.object({
  mode: z.enum(['pick', 'map']),  // Simplified
  items: z.array(z.union([pickGradeItemSchema, mapGradeItemSchema])),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, items } = requestSchema.parse(body);

    // Grade each item and update SRS
    const results: GradeResult[] = await Promise.all(
      items.map(async (item) => {
        // Get fact card with answer region
        const card = await getFactCardById(item.fact_id);

        if (!card) {
          throw new Error(`Card not found: ${item.fact_id}`);
        }

        // Validate answer based on mode
        let correct: boolean;
        let distance: number | undefined;

        if (mode === 'pick') {
          const pickItem = item as PickGradeItem;
          correct = validatePickAnswer(card.answer_region_id, pickItem.selected_region_id);
        } else {
          const mapItem = item as MapGradeItem;
          const answerRegion = await getAnswerRegion(card);
          const result = validateMapAnswer(answerRegion, mapItem.clicked_point);
          correct = result.correct;
          distance = result.distance;
        }

        // Determine quality for SRS
        const quality = correct ? (item.time_ms < 5000 ? 5 : 4) : 2;

        // Update SRS
        const srsResult = await updateUserFactStat(user.id, {
          fact_id: item.fact_id,
          quality,
          time_ms: item.time_ms,
        });

        return {
          fact_id: item.fact_id,
          correct,
          time_ms: item.time_ms,
          distance,
          srs: {
            new_ease: srsResult.new_ease,
            due_at: srsResult.due_at.toISOString(),
            interval_days: srsResult.interval_days,
          },
        };
      })
    );

    // Calculate summary
    const summary: GradeSummary = {
      total: results.length,
      correct: results.filter((r) => r.correct).length,
      accuracy: results.length > 0 ? results.filter((r) => r.correct).length / results.length : 0,
      avg_time_ms: results.length > 0 ? results.reduce((sum, r) => sum + r.time_ms, 0) / results.length : 0,
    };

    // Save session
    await supabase.from('game_sessions').insert({
      user_id: user.id,
      mode,
      summary: summary as any,
    });

    return NextResponse.json({
      results,
      summary,
    });
  } catch (error) {
    console.error('Grade error:', error);
    return NextResponse.json(
      {
        error: 'Failed to grade session',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
```

**Breaking Changes:**
- ❌ `mode` simplified
- ❌ `selected_key` → `selected_region_id`
- ✅ Simpler validation logic

---

### 6.3 NEW: `/api/rapid/topics` (Optional)

**File:** `src/app/api/rapid/topics/route.ts` (NEW)

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { getTopics } from '@/features/rapid/controllers/get-topics';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const requestSchema = z.object({
  mode: z.enum(['pick', 'map']).optional(),
});

export async function GET(req: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { searchParams } = new URL(req.url);
    const mode = searchParams.get('mode');

    const topics = await getTopics({
      pickModeActive: mode === 'pick' ? true : undefined,
      mapModeActive: mode === 'map' ? true : undefined,
    });

    return NextResponse.json({ topics });
  } catch (error) {
    console.error('Topics error:', error);
    return NextResponse.json(
      {
        error: 'Failed to fetch topics',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
```

---

## 7. UI Components Migration

### 7.1 PickModeTab Component

**File:** `src/features/rapid/components/pick-mode-tab.tsx`

**Changes Needed:**
1. Update fetch call to new API format:
   ```typescript
   // OLD
   fetch('/api/rapid/queue', {
     method: 'POST',
     body: JSON.stringify({
       mode: 'language-pick',
       targetTags: ['script:malayalam'],
       maxCards: 20,
     }),
   });

   // NEW
   fetch('/api/rapid/queue', {
     method: 'POST',
     body: JSON.stringify({
       mode: 'pick',
       topicKey: 'india-languages',
       maxCards: 20,
     }),
   });
   ```

2. Update queue item handling:
   ```typescript
   // OLD
   interface PickQueueItem {
     fact_id: string;
     type: 'language_snippet' | 'phone_number' | 'city_locate';
     payload: { text: string; romanization?: string };
     options: { key: string; label: string; correct: boolean }[];
   }

   // NEW
   interface PickQueueItem {
     fact_id: string;
     card_group_id: string;
     prompt: string;
     hint: string | null;
     difficulty: '1' | '2' | '3';
     options: { region_id: string; label: string; correct: boolean }[];
   }
   ```

3. Update grade submission:
   ```typescript
   // OLD
   {
     fact_id: item.fact_id,
     selected_key: selectedOption.key,
     time_ms: elapsedTime,
   }

   // NEW
   {
     fact_id: item.fact_id,
     selected_region_id: selectedOption.region_id,
     time_ms: elapsedTime,
   }
   ```

---

### 7.2 MapModeTab Component

**File:** `src/features/rapid/components/map-mode-tab.tsx`

**Changes Needed:**
1. Update fetch call:
   ```typescript
   // NEW
   fetch('/api/rapid/queue', {
     method: 'POST',
     body: JSON.stringify({
       mode: 'map',
       topicKey: 'india-languages',
       maxCards: 20,
     }),
   });
   ```

2. Update queue item handling:
   ```typescript
   // OLD
   interface MapQueueItem {
     fact_id: string;
     type: 'language_snippet';
     payload: { text: string };
     regions: Region[];
     bbox: [number, number, number, number];
   }

   // NEW
   interface MapQueueItem {
     fact_id: string;
     card_group_id: string;
     prompt: string;
     hint: string | null;
     difficulty: '1' | '2' | '3';
     answer_region: Region;  // Single region
     bbox: [number, number, number, number];
   }
   ```

3. Update map rendering:
   ```typescript
   // OLD - render multiple regions
   regions.forEach(region => {
     if (region.geometry) {
       map.addSource(`region-${region.id}`, {
         type: 'geojson',
         data: region.geometry,
       });
     }
   });

   // NEW - render single answer region
   if (item.answer_region.geometry) {
     map.addSource('answer-region', {
       type: 'geojson',
       data: item.answer_region.geometry,
     });
   }
   ```

---

### 7.3 NEW: Topic Selector Component

**File:** `src/features/rapid/components/topic-selector.tsx` (NEW)

```typescript
'use client';

import { useEffect, useState } from 'react';
import type { Topic } from '../types';

interface TopicSelectorProps {
  mode: 'pick' | 'map';
  onSelect: (topicKey: string) => void;
  selectedTopic?: string;
}

export function TopicSelector({ mode, onSelect, selectedTopic }: TopicSelectorProps) {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchTopics() {
      try {
        const res = await fetch(`/api/rapid/topics?mode=${mode}`);
        const data = await res.json();
        setTopics(data.topics);
      } catch (error) {
        console.error('Failed to fetch topics:', error);
      } finally {
        setLoading(false);
      }
    }

    fetchTopics();
  }, [mode]);

  if (loading) return <div>Loading topics...</div>;

  return (
    <div className="grid grid-cols-2 gap-4">
      {topics.map((topic) => (
        <button
          key={topic.key}
          onClick={() => onSelect(topic.key)}
          className={`p-4 rounded-lg border-2 ${
            selectedTopic === topic.key
              ? 'border-primary bg-primary/10'
              : 'border-gray-300 hover:border-primary/50'
          }`}
        >
          <div className="text-lg font-semibold">{topic.title}</div>
          {topic.description && (
            <div className="text-sm text-muted-foreground">{topic.description}</div>
          )}
          {topic.difficulty && (
            <div className="text-xs mt-2 text-muted-foreground">
              Difficulty: {topic.difficulty}
            </div>
          )}
        </button>
      ))}
    </div>
  );
}
```

---

## 8. Data Migration Scripts

### 8.1 Migrate Existing Fact Cards

**Challenge:** Convert old fact_cards format to new format

**Script:** `scripts/migrate-fact-cards.ts`

```typescript
/**
 * MANUAL SCRIPT: Migrate fact cards from old to new schema
 *
 * This CANNOT be automated because:
 * 1. Old cards have complex answer contracts that don't map 1:1
 * 2. Need to create card_groups manually
 * 3. Need to map answer contracts to answer_region_id
 *
 * Approach: Export old cards to JSON, manually curate, re-import
 */

import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';

const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_ANON_KEY!);

async function exportOldCards() {
  const { data: oldCards } = await supabase.from('fact_cards').select('*');

  fs.writeFileSync(
    './migration-data/old-fact-cards.json',
    JSON.stringify(oldCards, null, 2)
  );

  console.log(`Exported ${oldCards?.length} old fact cards`);
}

async function analyzeAnswerPatterns() {
  const { data: oldCards } = await supabase.from('fact_cards').select('*');

  const patterns = new Map<string, any[]>();

  oldCards?.forEach(card => {
    const answerKind = (card.answer as any).kind;
    if (!patterns.has(answerKind)) {
      patterns.set(answerKind, []);
    }
    patterns.get(answerKind)!.push(card);
  });

  console.log('Answer patterns:');
  patterns.forEach((cards, kind) => {
    console.log(`  ${kind}: ${cards.length} cards`);
  });
}

exportOldCards();
analyzeAnswerPatterns();
```

**Manual Steps:**
1. Export old fact_cards to JSON
2. Analyze answer patterns
3. Create card_groups for each content type
4. Manually map each card's answer contract to a region
5. Create new fact cards with:
   - `prompt` = extracted from payload
   - `hint` = extracted from payload
   - `answer_region_id` = resolved from answer contract
   - `card_group_id` = assigned card group

---

### 8.2 Create Initial Card Groups

**Script:** `scripts/create-card-groups.sql`

```sql
-- Insert initial card groups
insert into card_groups (name) values
  ('India Regional Languages'),
  ('Indian Phone Codes'),
  ('Global Phone Codes'),
  ('Major Cities - India'),
  ('Major Cities - Global')
on conflict (name) do nothing;
```

---

### 8.3 Create Initial Topics

**Script:** `scripts/create-topics.sql`

```sql
-- Get card group IDs (replace with actual UUIDs after creation)
-- This is a template - must be customized after card_groups are created

insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
) values
  (
    'india-languages',
    'Indian Languages',
    'Identify regional scripts from across India',
    'Languages',
    true,
    true,
    'intermediate',
    array['<uuid-of-india-languages-card-group>']::uuid[]
  ),
  (
    'india-phone',
    'Indian Phone Codes',
    'Learn area codes from Indian cities',
    'Phone',
    true,
    false,
    'beginner',
    array['<uuid-of-indian-phone-codes-card-group>']::uuid[]
  ),
  (
    'global-phone',
    'Global Phone Codes',
    'Master international dialing codes',
    'Globe',
    true,
    false,
    'advanced',
    array['<uuid-of-global-phone-codes-card-group>']::uuid[]
  );
```

---

## 9. Testing Strategy

### 9.1 Unit Tests

**Test Files to Update:**
1. `features/rapid/controllers/*.test.ts`
2. `features/rapid/models/*.test.ts`

**Key Test Cases:**
- ✅ `getFactCards` with card group filters
- ✅ `buildQueue` with topics
- ✅ `generatePickOptions` with new FK model
- ✅ `validatePickAnswer` with region IDs
- ✅ `validateMapAnswer` with new regions

---

### 9.2 Integration Tests

**Test Scenarios:**
1. **Queue Generation:**
   - POST `/api/rapid/queue` with `topicKey`
   - POST `/api/rapid/queue` with `cardGroupIds`
   - Verify correct fact cards returned
   - Verify pick options generated
   - Verify answer regions populated

2. **Grading:**
   - POST `/api/rapid/grade` with pick answers
   - POST `/api/rapid/grade` with map answers
   - Verify SRS updates
   - Verify session saved

3. **Topics:**
   - GET `/api/rapid/topics?mode=pick`
   - GET `/api/rapid/topics?mode=map`
   - Verify filtering works

---

### 9.3 End-to-End Tests

**User Flows:**
1. ✅ Select topic → Start pick mode → Answer questions → See results
2. ✅ Select topic → Start map mode → Click on map → See results
3. ✅ View past sessions
4. ✅ See SRS statistics

---

## 10. Rollout Plan

### 10.1 Pre-Migration Checklist

- [ ] Backup production database
- [ ] Export existing fact_cards to JSON
- [ ] Document all custom answer contracts
- [ ] Prepare downtime announcement
- [ ] Test migration in staging

---

### 10.2 Migration Day Steps

**Hour 1: Database Migration**
1. ✅ Put app in maintenance mode
2. ✅ Run `supabase db reset` (or manually apply migrations)
3. ✅ Verify new schema created
4. ✅ Run seed scripts (skill_tags, countries, indian states)
5. ✅ Verify data populated

**Hour 2: Data Migration**
1. ✅ Create card_groups
2. ✅ Create topics
3. ✅ Migrate fact_cards (manual process)
4. ✅ Verify fact_cards created correctly

**Hour 3: Application Deployment**
1. ✅ Deploy new application code
2. ✅ Regenerate database types
3. ✅ Smoke test APIs
4. ✅ Test UI flows

**Hour 4: Verification & Launch**
1. ✅ Run integration tests
2. ✅ Test with real user account
3. ✅ Monitor error logs
4. ✅ Take app out of maintenance mode

---

### 10.3 Post-Migration Monitoring

**Week 1:**
- Monitor error rates
- Track API response times
- Gather user feedback
- Fix critical bugs

**Week 2-4:**
- Optimize slow queries
- Add missing topics/card groups
- Expand fact card library
- Improve UI based on feedback

---

## 11. Appendix

### 11.1 Breaking Changes Summary

| Area | Old | New | Impact |
|------|-----|-----|--------|
| fact_cards.type | String enum | Removed | 🔴 Critical |
| fact_cards.payload | JSONB | prompt + hint | 🔴 Critical |
| fact_cards.answer | JSONB contract | answer_region_id FK | 🔴 Critical |
| fact_cards.difficulty | Number 1-5 | ENUM '1'/'2'/'3' | 🟡 Moderate |
| skill_tags.meta | JSONB | Flattened columns | 🟡 Moderate |
| regions.kind | String | level (ENUM) | 🟡 Moderate |
| regions.meta | JSONB | note (text) | 🟡 Moderate |
| card_groups | N/A | NEW table | ✅ New feature |
| topics | N/A | NEW table | ✅ New feature |

---

### 11.2 File Checklist

**Types:**
- [x] `src/libs/supabase/database.types.ts` - Regenerate
- [x] `src/features/rapid/types.ts` - Major rewrite

**Controllers:**
- [x] `src/features/rapid/controllers/get-fact-cards.ts` - Rewrite
- [x] `src/features/rapid/controllers/build-queue.ts` - Rewrite
- [x] `src/features/rapid/controllers/generate-pick-options.ts` - Major rewrite
- [x] `src/features/rapid/controllers/generate-map-regions.ts` - Major rewrite
- [x] `src/features/rapid/controllers/get-topics.ts` - NEW
- [x] `src/features/rapid/controllers/get-skill-tags.ts` - Minor updates
- [x] `src/features/rapid/controllers/get-regions.ts` - Minor updates

**Models:**
- [x] `src/features/rapid/models/answer-validator.ts` - Rewrite

**API Routes:**
- [x] `src/app/api/rapid/queue/route.ts` - Update
- [x] `src/app/api/rapid/grade/route.ts` - Update
- [x] `src/app/api/rapid/topics/route.ts` - NEW

**UI Components:**
- [x] `src/features/rapid/components/pick-mode-tab.tsx` - Update
- [x] `src/features/rapid/components/map-mode-tab.tsx` - Update
- [x] `src/features/rapid/components/topic-selector.tsx` - NEW

**Scripts:**
- [x] `scripts/migrate-fact-cards.ts` - NEW
- [x] `scripts/create-card-groups.sql` - NEW
- [x] `scripts/create-topics.sql` - NEW

---

### 11.3 Estimated Timeline

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| Types & Schema | 2 hours | Updated types, regenerated database types |
| Controllers | 4 hours | All controllers rewritten and tested |
| API Routes | 2 hours | Updated API endpoints |
| UI Components | 3 hours | Updated React components |
| Data Migration | 4 hours | Card groups, topics, migrated fact cards |
| Testing | 3 hours | Unit, integration, E2E tests |
| Deployment | 2 hours | Deploy to staging and production |
| **Total** | **20 hours** | **~2.5 days** |

---

### 11.4 Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Data loss during migration | Full database backup before migration |
| Complex answer contracts can't be migrated | Manual curation process with JSON export |
| Breaking changes affect users | Maintenance mode during migration |
| Performance regression | Load testing before launch |
| Missing fact cards after migration | Keep old data backup for reference |

---

## Conclusion

This migration represents a **significant improvement** in data modeling:
- ✅ Type-safe with PostgreSQL ENUMs
- ✅ Normalized relationships with FKs
- ✅ Simpler, more maintainable code
- ✅ Better performance (no JSONB parsing)
- ✅ New features (topics, card groups)

**Next Steps:**
1. Review and approve this plan
2. Set migration date
3. Backup production data
4. Execute migration in staging
5. Deploy to production

**Questions? Contact:** [Your Name]

---

**End of Document**
