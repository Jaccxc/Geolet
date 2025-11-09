# Step 4: Core Data Models & TypeScript Types

**Timeline:** 4-5 hours
**Priority:** High (Required before API development)

## Overview
Create TypeScript types, Zod schemas, and data access patterns for Geolet's domain models. This establishes type safety and validation across the codebase.

## Prerequisites
- Step 2 completed (database schema)
- Step 3 completed (seed data loaded)
- Familiarity with Zod validation library

## Detailed Tasks

### 4.1 Generate Supabase Types

Update existing type generation:
```bash
bunx supabase gen types typescript --linked > src/libs/supabase/database.types.ts
```

This generates types for all tables including the new Geolet schema.

### 4.2 Create Feature Directory Structure

```
/src/features/
  ├── flash/
  │   ├── types.ts
  │   ├── models/
  │   │   ├── skill-tag.ts
  │   │   ├── region.ts
  │   │   ├── fact-card.ts
  │   │   └── game-session.ts
  │   ├── controllers/
  │   └── components/
  ├── insight/
  │   ├── types.ts
  │   ├── models/
  │   └── controllers/
  └── srs/
      ├── types.ts
      ├── models/
      └── controllers/
```

### 4.3 Define Domain Types

#### A. `/src/features/flash/types.ts`

```typescript
import { z } from 'zod';

// Skill Tag Types
export const skillFamilySchema = z.enum(['script', 'phone', 'city']);
export type SkillFamily = z.infer<typeof skillFamilySchema>;

export const skillTagMetaSchema = z.object({
  display: z.string(),
  notes: z.string().optional(),
  examples: z.array(z.string()).optional(),
});

export const skillTagSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  family: skillFamilySchema,
  country: z.string().nullable(),
  meta: skillTagMetaSchema,
});

export type SkillTag = z.infer<typeof skillTagSchema>;

// Region Types
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
  centroid_lonlat: z.tuple([z.number(), z.number()]),
  bbox: z.tuple([z.number(), z.number(), z.number(), z.number()]),
  meta: z.record(z.any()),
});

export type Region = z.infer<typeof regionSchema>;

// Fact Card Types
export const factTypeSchema = z.enum(['language_snippet', 'phone_number', 'city_locate']);
export type FactType = z.infer<typeof factTypeSchema>;

export const factPayloadSchema = z.union([
  z.object({ text: z.string(), romanization: z.string().optional() }), // language
  z.object({ number: z.string(), masked: z.string().optional() }), // phone
  z.object({ city: z.string(), country_hint: z.string().optional() }), // city
]);

export const answerContractSchema = z.union([
  z.object({
    kind: z.literal('region'),
    select: z.object({
      by: z.literal('key'),
      keys: z.array(z.string()),
    }),
  }),
  z.object({
    kind: z.literal('tag'),
    select: z.object({
      by: z.literal('skill_key'),
      keys: z.array(z.string()),
    }),
    map_equivalents: z.object({
      regions: z.array(z.string()),
    }),
  }),
]);

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

// Game Session Types
export const gameModeSchema = z.enum([
  'language-choice',
  'language-map',
  'phone-choice',
  'phone-map',
  'city-map',
]);
export type GameMode = z.infer<typeof gameModeSchema>;

export const sessionSummarySchema = z.object({
  accuracy: z.number(),
  avg_ms: z.number(),
  total_cards: z.number(),
  correct_count: z.number(),
  tag_breakdown: z.record(z.object({
    seen: z.number(),
    correct: z.number(),
  })),
});

export type SessionSummary = z.infer<typeof sessionSummarySchema>;
```

#### B. `/src/features/srs/types.ts`

```typescript
import { z } from 'zod';

export const srsQualitySchema = z.number().int().min(0).max(5);
export type SRSQuality = z.infer<typeof srsQualitySchema>;

export const userFactStatSchema = z.object({
  user_id: z.string().uuid(),
  fact_id: z.string().uuid(),
  seen: z.number().int(),
  correct: z.number().int(),
  ease: z.number(),
  last_seen_at: z.date().nullable(),
  due_at: z.date().nullable(),
});

export type UserFactStat = z.infer<typeof userFactStatSchema>;

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
```

#### C. `/src/features/insight/types.ts`

```typescript
import { z } from 'zod';

export const insightRoundSchema = z.object({
  id: z.number().int(),
  user_id: z.string().uuid(),
  played_at: z.date().nullable(),
  country: z.string().nullable(),
  target_country: z.string().nullable(),
  distance_m: z.number().nullable(),
  time_ms: z.number().int().nullable(),
  meta: z.record(z.any()),
});

export type InsightRound = z.infer<typeof insightRoundSchema>;

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
}
```

### 4.4 Create Data Access Controllers

#### A. `/src/features/flash/controllers/get-skill-tags.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import { skillTagSchema } from '../types';
import type { SkillTag, SkillFamily } from '../types';

export async function getSkillTags(family?: SkillFamily): Promise<SkillTag[]> {
  const supabase = await createClient();

  let query = supabase
    .from('skill_tags')
    .select('*');

  if (family) {
    query = query.eq('family', family);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map(row => skillTagSchema.parse(row));
}

export async function getSkillTagByKey(key: string): Promise<SkillTag | null> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('skill_tags')
    .select('*')
    .eq('key', key)
    .single();

  if (error) return null;

  return skillTagSchema.parse(data);
}
```

#### B. `/src/features/flash/controllers/get-regions.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import { regionSchema } from '../types';
import type { Region, RegionKind } from '../types';

export async function getRegions(kind?: RegionKind): Promise<Region[]> {
  const supabase = await createClient();

  let query = supabase
    .from('regions')
    .select('*');

  if (kind) {
    query = query.eq('kind', kind);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map(row => regionSchema.parse(row));
}

export async function getRegionsByKeys(keys: string[]): Promise<Region[]> {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('regions')
    .select('*')
    .in('key', keys);

  if (error) throw error;

  return data.map(row => regionSchema.parse(row));
}
```

#### C. `/src/features/flash/controllers/get-fact-cards.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import { factCardSchema } from '../types';
import type { FactCard, FactType } from '../types';

export async function getFactCards(
  type?: FactType,
  tags?: string[],
  limit?: number
): Promise<FactCard[]> {
  const supabase = await createClient();

  let query = supabase
    .from('fact_cards')
    .select('*');

  if (type) {
    query = query.eq('type', type);
  }

  if (tags && tags.length > 0) {
    query = query.overlaps('primary_tags', tags);
  }

  if (limit) {
    query = query.limit(limit);
  }

  const { data, error } = await query;

  if (error) throw error;

  return data.map(row => factCardSchema.parse(row));
}
```

### 4.5 Create Utility Helpers

#### `/src/features/flash/models/answer-validator.ts`

```typescript
import type { AnswerContract, Region } from '../types';
import * as turf from '@turf/turf';

export function validateChoiceAnswer(
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

export function validateMapAnswer(
  answer: AnswerContract,
  clickedPoint: [number, number],
  regions: Region[]
): { correct: boolean; distance?: number } {
  const [lng, lat] = clickedPoint;
  const point = turf.point([lng, lat]);

  for (const region of regions) {
    // Check polygon if available
    if (region.geometry) {
      const polygon = turf.geometry(region.geometry.type, region.geometry.coordinates);
      if (turf.booleanPointInPolygon(point, polygon)) {
        return { correct: true };
      }
    } else {
      // Fallback to centroid + tolerance
      const [centerLng, centerLat] = region.centroid_lonlat;
      const center = turf.point([centerLng, centerLat]);
      const distance = turf.distance(point, center, { units: 'kilometers' });
      const tolerance = region.meta.tolerance_km || 50; // default 50km

      if (distance <= tolerance) {
        return { correct: true, distance };
      }
    }
  }

  return { correct: false };
}
```

## Files to Create/Modify

### Created:
- `/src/libs/supabase/database.types.ts` (regenerated)
- `/src/features/flash/types.ts`
- `/src/features/flash/controllers/get-skill-tags.ts`
- `/src/features/flash/controllers/get-regions.ts`
- `/src/features/flash/controllers/get-fact-cards.ts`
- `/src/features/flash/models/answer-validator.ts`
- `/src/features/srs/types.ts`
- `/src/features/insight/types.ts`

### Modified:
- None

## Acceptance Criteria
- ✅ All Supabase types regenerated successfully
- ✅ Zod schemas defined for all domain models
- ✅ Type-safe controller functions for data access
- ✅ No TypeScript errors in new files
- ✅ Can import and use types across features
- ✅ Validation helpers work with test data

## Notes & Considerations

### Why Zod?
- Runtime validation + type inference
- Already used in starter for product metadata
- Catches data inconsistencies early

### Controller Pattern
- Follows existing starter pattern (`/features/*/controllers/`)
- Server-side only (uses `supabase-server-client`)
- Throws errors for data issues
- Returns null for not-found (where appropriate)

### Type Safety Benefits
- Prevents invalid answer contracts
- Ensures payload matches fact type
- Catches schema changes at compile time

### Dependencies
Install additional packages:
```bash
bun add @turf/turf @turf/helpers
bun add -D @types/turf
```

## Dependencies
- Step 2 (Database Schema)
- Step 3 (Seed Data)

## Blocks
- Step 5 (Flash API)
- Step 6 (Flash UI)
