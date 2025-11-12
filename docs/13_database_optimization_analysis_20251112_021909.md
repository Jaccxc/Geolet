# Database Structure Optimization Analysis & Migration Plan

**Created:** 2025-11-12 02:19:09
**Status:** Analysis & Proposal
**Purpose:** Comprehensive analysis of current /rapid gamemode data architecture and proposed optimization plan

---

## Executive Summary

This document analyzes the current data architecture for the `/rapid` gamemode, identifies structural issues, and proposes a normalized database schema that:
- Eliminates unnecessary JSON blob columns in favor of plain columns
- Introduces a `topics` table to formalize game topics
- Standardizes region naming conventions
- Improves data consistency and query performance
- Maintains backward compatibility with existing features

---

## Table of Contents

1. [Current Architecture Analysis](#1-current-architecture-analysis)
2. [Data Flow & Game Mechanics](#2-data-flow--game-mechanics)
3. [Identified Problems](#3-identified-problems)
4. [Proposed Optimized Schema](#4-proposed-optimized-schema)
5. [Migration Strategy](#5-migration-strategy)
6. [Impact Analysis](#6-impact-analysis)

---

## 1. Current Architecture Analysis

### 1.1 Current Database Schema

```sql
-- Current schema (20251109161427_add_geolet_schema.sql)

create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  family text not null check (family in ('script','phone','city')),
  country text,
  meta jsonb not null default '{}'  -- Contains: display, notes, examples, regions
);

create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- Example: "IN", "IN-DL", "IN:Delhi"
  kind text not null check (kind in ('country','region','city')),
  name text not null,
  country text,
  geometry jsonb,  -- GeoJSON polygon
  centroid_lonlat double precision[] not null,
  bbox double precision[] not null,
  meta jsonb not null default '{}'  -- Contains: note, tier, population, etc.
);

create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('language_snippet','phone_number','city_locate')),
  payload jsonb not null,  -- Contains: text/romanization, number/masked, city/country_hint
  primary_tags text[] not null,
  difficulty int not null default 1,
  answer jsonb not null  -- Contains: kind, select{by, keys}, map_equivalents{regions}
);

create table user_fact_stats (
  user_id uuid not null references auth.users(id) on delete cascade,
  fact_id uuid not null references fact_cards(id) on delete cascade,
  seen int not null default 0,
  correct int not null default 0,
  ease real not null default 2.5,
  last_seen_at timestamptz,
  due_at timestamptz,
  primary key (user_id, fact_id)
);

create table game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null,  -- e.g., "language-pick", "phone-map"
  created_at timestamptz not null default now(),
  summary jsonb not null default '{}'
);
```

### 1.2 Current Data Samples

#### skill_tags.json (557 lines, ~40 records)
```json
{
  "key": "script:devanagari:hindi",
  "family": "script",
  "country": "IN",
  "meta": {
    "display": "Hindi (Devanagari)",
    "notes": "Most common language in India...",
    "examples": ["होटल", "रेस्तरां", "स्कूल"],
    "regions": ["IN-DL", "IN-UP", "IN-MP"]
  }
}
```

#### regions.json (767 lines, ~100 records)
```json
// Countries
{
  "key": "IN",
  "kind": "country",
  "name": "India",
  "country": null,
  "geometry": null,
  "centroid_lonlat": null,
  "bbox": null,
  "meta": {"note": "Geometry to be populated later"}
}

// Regions (ISO 3166-2 format)
{
  "key": "IN-DL",
  "kind": "region",
  "name": "NCT of Delhi",
  "country": "IN",
  "geometry": {...},
  "centroid_lonlat": [77.2090, 28.6139],
  "bbox": [...],
  "meta": {}
}

// Cities (custom format)
{
  "key": "IN:Delhi",
  "kind": "city",
  "name": "Delhi",
  "country": "IN",
  "centroid_lonlat": [77.2090, 28.6139],
  "bbox": null,
  "meta": {"tier": 1, "population": 32900000}
}
```

#### fact_cards.json (1250 lines, ~200 records)
```json
// Language snippet card
{
  "type": "language_snippet",
  "payload": {
    "text": "होटल",
    "romanization": "hotel"  // ISSUE: Often translation, not romanization
  },
  "primary_tags": ["script:devanagari:hindi"],
  "difficulty": 1,
  "answer": {
    "kind": "tag",
    "select": {
      "by": "skill_key",
      "keys": ["script:devanagari:hindi"]
    },
    "map_equivalents": {
      "regions": ["IN", "IN-DL", "IN-UP", "IN-MP", "IN-RJ", "IN-HR"]
    }
  }
}

// Phone number card
{
  "type": "phone_number",
  "payload": {
    "number": "+91 22 2345 6789",
    "masked": "+91 22..."
  },
  "primary_tags": ["phone:+91", "phone:+91:22"],
  "difficulty": 2,
  "answer": {
    "kind": "region",
    "select": {
      "by": "key",
      "keys": ["IN:Mumbai"]
    }
  }
}

// City locate card
{
  "type": "city_locate",
  "payload": {
    "city": "Taipei",
    "country_hint": "TW"
  },
  "primary_tags": ["city:TW:tier1", "city:global:tier1"],
  "difficulty": 1,
  "answer": {
    "kind": "region",
    "select": {
      "by": "key",
      "keys": ["TW:Taipei"]
    }
  }
}
```

### 1.3 Current Topics System

Topics are hardcoded in TypeScript configuration (`src/features/rapid/config/topics.ts`):

```typescript
export const PICK_MODE_TOPICS: TopicCardConfig[] = [
  {
    id: 'india-languages',
    title: 'India Languages',
    description: 'Identify regional scripts across Indian states...',
    icon: Languages,
    mode: 'language-pick',
    difficulty: 'intermediate',
    estimatedCards: 15,
    targetTags: [
      'script:devanagari:hindi',
      'script:gurmukhi:punjabi',
      // ...
    ],
  },
  {
    id: 'global-languages',
    title: 'Global Languages',
    mode: 'language-pick',
    // No targetTags - includes all language scripts
  },
  // ...
];
```

**Issues:**
- Topics not stored in database
- No foreign key relationship between fact_cards and topics
- Topic configuration scattered across code
- Difficult to add new topics without code changes

---

## 2. Data Flow & Game Mechanics

### 2.1 Pick Mode Flow

```
User selects topic (e.g., "India Languages - Pick Mode")
    ↓
[Client] POST /api/rapid/queue
    - mode: "language-pick"
    - targetTags: ["script:devanagari:hindi", "script:tamil", ...]
    ↓
[Server] buildQueue()
    1. Query fact_cards WHERE type = 'language_snippet' AND primary_tags overlaps targetTags
    2. Join with user_fact_stats for SRS scoring
    3. Prioritize: due cards > unseen cards > low accuracy cards
    4. Return top 10 cards
    ↓
[Server] For each card: generatePickOptions()
    1. Extract answer.select.keys (correct answer)
    2. Query skill_tags WHERE key IN (correct answer keys)
    3. Query skill_tags WHERE family = (same family) for distractors
    4. Shuffle 1 correct + 5 distractors
    ↓
[Client] User plays game, selects answers
    ↓
[Client] POST /api/rapid/grade
    - items: [{fact_id, selected_key, time_ms}, ...]
    ↓
[Server] Grade each item:
    1. getFactCardById(fact_id)
    2. validatePickAnswer(card.answer, selected_key)
    3. updateUserFactStat(user_id, fact_id, quality)
    4. Save game_session with summary
```

### 2.2 Map Mode Flow

```
User selects topic (e.g., "India Languages - Map Mode")
    ↓
[Client] POST /api/rapid/queue
    - mode: "language-map"
    - targetTags: [...]
    ↓
[Server] buildQueue() (same as Pick Mode)
    ↓
[Server] For each card: generateMapRegions()
    1. If answer.kind = 'tag': use answer.map_equivalents.regions
    2. If answer.kind = 'region': use answer.select.keys
    3. Query regions WHERE key IN (region keys)
    4. Return regions with geometry/centroid_lonlat
    ↓
[Client] Displays map with MapLibre GL
    - Loads OpenStreetMap tiles
    - Optionally overlays region polygons (if geometry available)
    ↓
[Client] User clicks point on map
    ↓
[Client] POST /api/rapid/grade
    - items: [{fact_id, clicked_point: [lng, lat], time_ms}, ...]
    ↓
[Server] Grade each item:
    1. getFactCardById(fact_id)
    2. generateMapRegions(card) → get region polygons/centroids
    3. validateMapAnswer():
       - Strategy 1: If region.geometry exists → check point-in-polygon (Turf.js)
       - Strategy 2: Fallback → check distance from centroid with tolerance
         * Country: 500km tolerance
         * Region: 200km tolerance
         * City: 50km tolerance
    4. updateUserFactStat()
    5. Save game_session
```

### 2.3 Map Mode Validation Logic

**File:** `src/features/rapid/models/answer-validator.ts`

```typescript
export function validateMapAnswer(
  answer: AnswerContract,
  clickedPoint: [number, number], // [lng, lat]
  regions: Region[]
): { correct: boolean; distance?: number } {
  const point = turf.point(clickedPoint);

  for (const region of regions) {
    // Strategy 1: Polygon check (if geometry available)
    if (region.geometry) {
      const isInside = turf.booleanPointInPolygon(point, region.geometry);
      if (isInside) return { correct: true };
    }

    // Strategy 2: Centroid + tolerance
    if (region.centroid_lonlat) {
      const center = turf.point(region.centroid_lonlat);
      const distance = turf.distance(point, center, { units: 'kilometers' });

      let tolerance = region.kind === 'country' ? 500 :
                     region.kind === 'region' ? 200 : 50;

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
```

**Key Points:**
- Map mode primarily uses GeoJSON polygons for accuracy
- Falls back to centroid + radius for regions without geometry
- Currently supports both `geometry` (polygon) and `centroid_lonlat` (pin)
- Uses Turf.js for geospatial calculations

---

## 3. Identified Problems

### 3.1 Data Quality Issues

#### Problem 1: Incorrect "romanization" field
**Example:** Malayalam fact card
```json
{
  "text": "ഹോട്ടല്‍",
  "romanization": "hotel"  // ❌ This is translation, not romanization
}
```
**Expected:**
```json
{
  "text": "ഹോട്ടല്‍",
  "romanization": "hōṭṭal",  // ✓ Actual pronunciation
  "translation": "hotel"     // ✓ English meaning
}
```

**Impact:** Users learning scripts cannot practice pronunciation correctly.

---

### 3.2 Schema Design Issues

#### Problem 2: Excessive JSON blobs instead of columns
**Current:** `fact_cards.payload` stores different structures per type
```json
// language_snippet payload
{"text": "...", "romanization": "..."}

// phone_number payload
{"number": "...", "masked": "..."}

// city_locate payload
{"city": "...", "country_hint": "..."}
```

**Issues:**
- Cannot query/index individual fields efficiently
- No type safety or validation at DB level
- Difficult to analyze data (e.g., "find all cards with text containing X")

---

#### Problem 3: Redundant "type" field in fact_cards
**Current:** `fact_cards.type` is used to filter cards by game mode
```sql
SELECT * FROM fact_cards WHERE type = 'language_snippet';
SELECT * FROM fact_cards WHERE type = 'phone_number';
SELECT * FROM fact_cards WHERE type = 'city_locate';
```

**Issue:** Type is essentially a proxy for "topic category". This is redundant if we have a proper topics table with foreign keys.

**Proposed:** Remove `type`, use `topic_id` foreign key instead.

---

#### Problem 4: Complex nested answer JSON
**Current:** `fact_cards.answer` is deeply nested
```json
{
  "kind": "tag",
  "select": {
    "by": "skill_key",
    "keys": ["script:devanagari:hindi"]
  },
  "map_equivalents": {
    "regions": ["IN", "IN-DL"]
  }
}
```

**Issues:**
- Hard to query (e.g., "find all cards where answer includes region IN-DL")
- `select.by` field is always "skill_key" or "key" (redundant)
- `map_equivalents` is only used for tag-based answers in map mode

**Proposed:** Flatten to multiple columns:
- `answer_kind` (tag | region)
- `answer_keys` (text array)
- `answer_region_keys` (text array, for map mode)

---

### 3.3 Regions Table Issues

#### Problem 5: Inconsistent region key naming
**Current mixed conventions:**
- Countries: `"IN"`, `"US"`, `"TW"` (ISO 3166-1 alpha-2) ✓
- Regions: `"IN-DL"`, `"IN-UP"` (ISO 3166-2) ✓
- Cities: `"IN:Delhi"`, `"TW:Taipei"` (custom format) ⚠️

**Issue:** Mixing `:` and `-` delimiters is confusing.

**Proposed standard:**
- Countries: `"IN"`, `"TW"` (ISO 3166-1)
- Regions: `"IN:Delhi_NCT"`, `"IN:Maharashtra"` (CountryCode:RegionName)
- Cities: `"IN:Delhi"`, `"TW:Taipei"` (CountryCode:CityName)
- Neighborhoods: `"TW:Taipei:Ximending"` (CountryCode:City:Area)

**Rationale:** Always use `:` as delimiter, never `-` for our custom keys.

---

#### Problem 6: Ambiguous "kind" field name
**Current:** `regions.kind` in ('country', 'region', 'city')

**Issue:** "kind" is vague. "region" is overloaded (both table name and a type).

**Proposed:** Rename to `level` with clear values:
- `"country"`
- `"province"` (state, region, territory)
- `"city"`
- `"neighborhood"` (optional, for future expansion)

---

#### Problem 7: No location_type distinction
**Current:** `regions` table has both `geometry` and `centroid_lonlat`

**Issue:** No clear indication of primary location representation:
- Some regions have only centroid (pin location)
- Some have full polygon geometry
- Current validation has to check both

**Proposed:** Add `location_type` enum:
- `"pin"`: Only `centroid_lonlat` is authoritative
- `"polygon"`: Only `geometry` is authoritative (centroid is computed)

**For MVP:** All current seed data uses `"polygon"` type (even if geometry is null for now).

---

### 3.4 skill_tags Issues

#### Problem 8: meta.notes trapped in JSON
**Current:** `skill_tags.meta` contains various fields
```json
{
  "display": "Hindi (Devanagari)",
  "notes": "Most common language in India...",
  "examples": ["होटल", "रेस्तरां"],
  "regions": ["IN-DL", "IN-UP"]
}
```

**Issue:** `notes` field is useful for educational tooltips but buried in JSON.

**Proposed:** Extract to top-level column `note` (nullable text).

---

### 3.5 Missing Topics Table

#### Problem 9: No database representation of topics
**Current:** Topics defined in TypeScript config file

**Issues:**
- Cannot dynamically add topics without code deployment
- No foreign key relationship: fact_cards → topics
- Cannot query "all cards in a topic" efficiently
- Cannot store topic metadata (icon, difficulty, description) in DB
- Topics are duplicated between Pick and Map modes

**Proposed:** Create `topics` table (see Section 4).

---

## 4. Proposed Optimized Schema

### 4.1 New Topics Table

```sql
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- e.g., "india-languages", "global-phone"
  title text not null,  -- e.g., "India Languages"
  description text,
  icon text,  -- lucide icon name, e.g., "Languages", "Phone"
  mode_type text not null check (mode_type in ('language', 'phone', 'city')),
  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),
  target_tags text[],  -- Optional filter for fact cards
  meta jsonb default '{}'  -- For future extension (e.g., color, order)
);

create index topics_mode_type_idx on topics (mode_type);

-- Example data
insert into topics (key, title, description, icon, mode_type, difficulty, target_tags) values
  (
    'indian-languages',
    'Indian Languages',
    'Identify regional scripts across Indian states - from Devanagari to Telugu',
    'Languages',
    'language',
    'intermediate',
    array['script:devanagari:hindi', 'script:tamil', 'script:malayalam']
  ),
  (
    'global-languages',
    'Global Languages',
    'Recognize language scripts from around the world',
    'Globe',
    'language',
    'advanced',
    null  -- No filter, includes all language cards
  ),
  (
    'global-phone',
    'Global Phone Numbers',
    'Match country codes to countries',
    'Phone',
    'phone',
    'beginner',
    null
  ),
  (
    'major-cities',
    'Major Cities',
    'Locate major cities on the world map',
    'MapPin',
    'city',
    'beginner',
    null
  );
```

**Note:** Topics table is mode-agnostic. Pick/Map distinction is in the game_mode selection, not in topics.

---

### 4.2 Optimized fact_cards Table

```sql
create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  topic_id uuid not null references topics(id) on delete cascade,

  -- Flattened payload fields (from previous payload JSON)
  -- For language_snippet:
  text text,  -- Native script text
  romanization text,  -- Pronunciation
  translation text,  -- English meaning (NEW)

  -- For phone_number:
  phone_number text,  -- Full number
  phone_masked text,  -- Masked display

  -- For city_locate:
  city_name text,
  country_hint text,  -- ISO country code

  primary_tags text[] not null,
  difficulty int not null default 1,

  -- Flattened answer fields (from previous answer JSON)
  answer_kind text not null check (answer_kind in ('tag', 'region')),
  answer_keys text[] not null,  -- Correct answer keys
  answer_region_keys text[],  -- For map mode (nullable)

  created_at timestamptz default now()
);

create index fact_cards_topic_idx on fact_cards (topic_id);
create index fact_cards_tags_gin on fact_cards using gin (primary_tags);
create index fact_cards_answer_keys_gin on fact_cards using gin (answer_keys);
create index fact_cards_answer_region_keys_gin on fact_cards using gin (answer_region_keys);

-- Row-level security
alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);
```

**Key Changes:**
1. ✅ Removed `type` field → replaced with `topic_id` foreign key
2. ✅ Flattened `payload` JSON → plain columns based on card type
3. ✅ Added `translation` field for language cards
4. ✅ Flattened `answer` JSON → `answer_kind`, `answer_keys`, `answer_region_keys`
5. ✅ Added GIN indexes for array columns (faster queries)
6. ✅ Added `created_at` timestamp

**Handling Mixed Field Usage:**
- Language cards use: `text`, `romanization`, `translation`
- Phone cards use: `phone_number`, `phone_masked`
- City cards use: `city_name`, `country_hint`
- Other fields are NULL for inapplicable card types

**Alternative Approach (Polymorphic):**
If mixing NULL fields feels messy, we could create separate tables:
- `fact_cards_language`
- `fact_cards_phone`
- `fact_cards_city`

**Decision:** For MVP, keep single table with nullable fields for simplicity. Re-evaluate if we add 10+ card types.

---

### 4.3 Optimized regions Table

```sql
create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- Format: "IN", "IN:Maharashtra", "TW:Taipei"
  level text not null check (level in ('country', 'province', 'city', 'neighborhood')),
  name text not null,
  country text,  -- ISO country code (null for countries themselves)

  -- Geospatial data
  location_type text not null check (location_type in ('pin', 'polygon')),
  centroid_lonlat double precision[],  -- [lng, lat]
  geometry jsonb,  -- GeoJSON polygon
  bbox double precision[],  -- [minLng, minLat, maxLng, maxLat]

  note text,  -- Human-readable notes (extracted from meta)
  meta jsonb default '{}'  -- Remaining metadata (tier, population, etc.)
);

create index regions_level_idx on regions (level);
create index regions_country_idx on regions (country);
create index regions_location_type_idx on regions (location_type);

alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);
```

**Key Changes:**
1. ✅ Standardized `key` format: always use `:` delimiter (never `-`)
2. ✅ Renamed `kind` → `level` for clarity
3. ✅ Added `location_type` to distinguish pin vs polygon
4. ✅ Extracted `note` from `meta` JSON
5. ✅ Made `centroid_lonlat` nullable (only required for `location_type = 'pin'`)
6. ✅ Made `geometry` nullable (only required for `location_type = 'polygon'`)

**Validation Rules:**
- If `location_type = 'pin'`: `centroid_lonlat` must be NOT NULL
- If `location_type = 'polygon'`: `geometry` must be NOT NULL
- Can enforce with triggers or application-level validation

---

### 4.4 Optimized skill_tags Table

```sql
create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- e.g., "script:devanagari:hindi"
  family text not null check (family in ('script', 'phone', 'city')),
  country text,  -- ISO country code (nullable)

  display text not null,  -- Extracted from meta.display
  note text,  -- Extracted from meta.notes
  examples text[],  -- Extracted from meta.examples (now typed array)

  meta jsonb default '{}'  -- Remaining metadata (regions, etc.)
);

create index skill_tags_family_idx on skill_tags (family);
create index skill_tags_country_idx on skill_tags (country);

alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);
```

**Key Changes:**
1. ✅ Extracted `display` from `meta` → top-level column (NOT NULL)
2. ✅ Extracted `note` from `meta` → top-level column (nullable)
3. ✅ Extracted `examples` from `meta` → typed text array
4. ✅ Remaining metadata stays in `meta` (e.g., `regions`)

---

### 4.5 No Changes to Other Tables

**user_fact_stats:** No changes needed (still references fact_cards.id)
**game_sessions:** No changes needed (still stores mode string)
**insight_rounds:** No changes needed (different feature)

---

## 5. Migration Strategy

### 5.1 Migration Phases

**Phase 1: Create New Schema (Non-Breaking)**
1. Create `topics` table
2. Alter `fact_cards` table (add new columns, keep old ones)
3. Alter `regions` table (add new columns, keep old ones)
4. Alter `skill_tags` table (add new columns, keep old ones)

**Phase 2: Data Migration**
1. Migrate topics from TypeScript config → `topics` table
2. Migrate fact_cards payload JSON → plain columns
3. Migrate fact_cards answer JSON → plain columns
4. Update regions keys (rename `IN-DL` → `IN:Delhi_NCT`)
5. Migrate skill_tags meta → plain columns

**Phase 3: Update Application Code**
1. Update API routes to use new columns
2. Update controllers to use new topics table
3. Update seed scripts to use new format
4. Add data validation (e.g., location_type checks)

**Phase 4: Remove Old Columns (Breaking)**
1. Drop `fact_cards.type`, `fact_cards.payload`, `fact_cards.answer`
2. Drop `skill_tags.meta.display/notes/examples` (keep trimmed meta)
3. Remove old region keys with `-` delimiter

---

### 5.2 Detailed Migration SQL

```sql
-- ============================================
-- PHASE 1: CREATE NEW SCHEMA
-- ============================================

-- Step 1: Create topics table
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  title text not null,
  description text,
  icon text,
  mode_type text not null check (mode_type in ('language', 'phone', 'city')),
  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),
  target_tags text[],
  meta jsonb default '{}'
);
create index topics_mode_type_idx on topics (mode_type);
alter table topics enable row level security;
create policy "rt topics" on topics for select using (true);

-- Step 2: Add new columns to fact_cards
alter table fact_cards add column topic_id uuid references topics(id) on delete cascade;
alter table fact_cards add column text text;
alter table fact_cards add column romanization text;
alter table fact_cards add column translation text;
alter table fact_cards add column phone_number text;
alter table fact_cards add column phone_masked text;
alter table fact_cards add column city_name text;
alter table fact_cards add column country_hint text;
alter table fact_cards add column answer_kind text check (answer_kind in ('tag', 'region'));
alter table fact_cards add column answer_keys text[];
alter table fact_cards add column answer_region_keys text[];
alter table fact_cards add column created_at timestamptz default now();

-- Step 3: Add new columns to regions
alter table regions add column level text check (level in ('country', 'province', 'city', 'neighborhood'));
alter table regions add column location_type text check (location_type in ('pin', 'polygon'));
alter table regions add column note text;

-- Step 4: Add new columns to skill_tags
alter table skill_tags add column display text;
alter table skill_tags add column note text;
alter table skill_tags add column examples text[];

-- ============================================
-- PHASE 2: DATA MIGRATION
-- ============================================

-- Step 5: Insert topics from config
insert into topics (key, title, description, icon, mode_type, difficulty, target_tags) values
  (
    'india-languages',
    'India Languages',
    'Identify regional scripts across Indian states - from Devanagari to Telugu',
    'Languages',
    'language',
    'intermediate',
    array['script:devanagari:hindi', 'script:devanagari:marathi', 'script:gurmukhi:punjabi',
          'script:gujarati', 'script:bengali', 'script:bengali:assamese', 'script:kannada',
          'script:telugu', 'script:tamil', 'script:odia', 'script:malayalam', 'script:meitei:manipuri']
  ),
  (
    'global-languages',
    'Global Languages',
    'Recognize language scripts from around the world',
    'Globe',
    'language',
    'advanced',
    null
  ),
  (
    'global-phone',
    'Global Phone Numbers',
    'Match country codes to countries (+886 for Taiwan, +91 for India)',
    'Phone',
    'phone',
    'beginner',
    null
  ),
  (
    'major-cities',
    'Major Cities',
    'Locate major cities on the world map by name',
    'MapPin',
    'city',
    'beginner',
    null
  );

-- Step 6: Migrate fact_cards type → topic_id
update fact_cards set topic_id = (
  select id from topics where key =
    case
      when fact_cards.type = 'language_snippet' then 'global-languages'
      when fact_cards.type = 'phone_number' then 'global-phone'
      when fact_cards.type = 'city_locate' then 'major-cities'
    end
);

-- Step 7: Migrate fact_cards payload → columns
update fact_cards set
  text = payload->>'text',
  romanization = payload->>'romanization',
  phone_number = payload->>'number',
  phone_masked = payload->>'masked',
  city_name = payload->>'city',
  country_hint = payload->>'country_hint';

-- Step 8: Migrate fact_cards answer → columns
update fact_cards set
  answer_kind = answer->>'kind',
  answer_keys = array(select jsonb_array_elements_text(answer->'select'->'keys')),
  answer_region_keys = array(select jsonb_array_elements_text(answer->'map_equivalents'->'regions'));

-- Step 9: Migrate regions kind → level
update regions set level =
  case kind
    when 'country' then 'country'
    when 'region' then 'province'
    when 'city' then 'city'
  end;

-- Step 10: Set regions location_type (for MVP, all are polygon)
update regions set location_type = 'polygon';

-- Step 11: Extract regions note
update regions set note = meta->>'note';

-- Step 12: Migrate skill_tags meta → columns
update skill_tags set
  display = meta->>'display',
  note = meta->>'notes',
  examples = array(select jsonb_array_elements_text(meta->'examples'));

-- Step 13: Update region keys (rename to new convention)
-- This is complex and needs careful mapping. Example:
-- "IN-DL" → "IN:Delhi_NCT"
-- "TW:Taipei" → "TW:Taipei" (no change)
-- Manual script recommended (see migration script below)

-- ============================================
-- PHASE 3: ADD CONSTRAINTS & INDEXES
-- ============================================

-- Make topic_id required after migration
alter table fact_cards alter column topic_id set not null;
alter table fact_cards alter column answer_kind set not null;
alter table regions alter column level set not null;
alter table regions alter column location_type set not null;
alter table skill_tags alter column display set not null;

-- Add new indexes
create index fact_cards_topic_idx on fact_cards (topic_id);
create index fact_cards_answer_keys_gin on fact_cards using gin (answer_keys);
create index fact_cards_answer_region_keys_gin on fact_cards using gin (answer_region_keys);
create index regions_level_idx on regions (level);
create index regions_location_type_idx on regions (location_type);

-- ============================================
-- PHASE 4: CLEANUP (After verifying app works)
-- ============================================

-- Drop old columns
alter table fact_cards drop column type;
alter table fact_cards drop column payload;
alter table fact_cards drop column answer;
alter table regions drop column kind;

-- Trim skill_tags.meta (remove migrated fields)
update skill_tags set meta = meta - 'display' - 'notes' - 'examples';
```

---

### 5.3 Region Key Renaming Script

**Current → Proposed Mapping:**

```
Countries (no change):
  IN → IN
  TW → TW
  US → US

Provinces/States (ISO 3166-2 → Custom):
  IN-DL → IN:Delhi_NCT
  IN-UP → IN:Uttar_Pradesh
  IN-MH → IN:Maharashtra
  IN-KL → IN:Kerala
  ... (36 regions)

Cities (already custom, but standardize):
  IN:Delhi → IN:Delhi
  TW:Taipei → TW:Taipei
  US:NewYork → US:New_York
  ... (50+ cities)
```

**Migration approach:**
1. Create mapping table with old_key → new_key
2. Update `regions.key` using mapping
3. Update `fact_cards.answer_region_keys` using mapping
4. Update `skill_tags.meta->regions` using mapping (if needed)

**SQL Example:**
```sql
-- Create temp mapping table
create temp table region_key_migrations (
  old_key text,
  new_key text
);

insert into region_key_migrations (old_key, new_key) values
  ('IN-DL', 'IN:Delhi_NCT'),
  ('IN-UP', 'IN:Uttar_Pradesh'),
  ('IN-MH', 'IN:Maharashtra'),
  -- ... (full mapping)
;

-- Update regions table
update regions r
set key = m.new_key
from region_key_migrations m
where r.key = m.old_key;

-- Update fact_cards answer_region_keys (array replacement)
update fact_cards
set answer_region_keys = array(
  select coalesce(m.new_key, ark)
  from unnest(answer_region_keys) ark
  left join region_key_migrations m on m.old_key = ark
);

-- Clean up
drop table region_key_migrations;
```

---

### 5.4 Seed Data Format Changes

#### Before: fact_cards.json
```json
{
  "type": "language_snippet",
  "payload": {
    "text": "ഹോട്ടല്‍",
    "romanization": "hotel"
  },
  "primary_tags": ["script:malayalam"],
  "difficulty": 1,
  "answer": {
    "kind": "tag",
    "select": {
      "by": "skill_key",
      "keys": ["script:malayalam"]
    },
    "map_equivalents": {
      "regions": ["IN:Kerala"]
    }
  }
}
```

#### After: fact_cards.json
```json
{
  "topic_key": "india-languages",
  "text": "ഹോട്ടല്‍",
  "romanization": "hōṭṭal",
  "translation": "hotel",
  "primary_tags": ["script:malayalam"],
  "difficulty": 1,
  "answer_kind": "tag",
  "answer_keys": ["script:malayalam"],
  "answer_region_keys": ["IN:Kerala"]
}
```

#### Before: regions.json
```json
{
  "key": "IN-KL",
  "kind": "region",
  "name": "Kerala",
  "country": "IN",
  "geometry": {...},
  "centroid_lonlat": [76.2711, 10.8505],
  "bbox": [...],
  "meta": {}
}
```

#### After: regions.json
```json
{
  "key": "IN:Kerala",
  "level": "province",
  "name": "Kerala",
  "country": "IN",
  "location_type": "polygon",
  "geometry": {...},
  "centroid_lonlat": [76.2711, 10.8505],
  "bbox": [...],
  "note": null,
  "meta": {}
}
```

#### Before: skill_tags.json
```json
{
  "key": "script:malayalam",
  "family": "script",
  "country": "IN",
  "meta": {
    "display": "Malayalam",
    "notes": "Found in Kerala. Curvy letters with upside-down U-shapes.",
    "examples": ["ഹോട്ടല്‍", "റസ്റ്റോറന്റ്", "സ്കൂള്‍"],
    "regions": ["IN:Kerala"]
  }
}
```

#### After: skill_tags.json
```json
{
  "key": "script:malayalam",
  "family": "script",
  "country": "IN",
  "display": "Malayalam",
  "note": "Found in Kerala. Curvy letters with upside-down U-shapes.",
  "examples": ["ഹോട്ടല്‍", "റസ്റ്റോറന്റ്", "സ്കൂള്‍"],
  "meta": {
    "regions": ["IN:Kerala"]
  }
}
```

---

## 6. Impact Analysis

### 6.1 Benefits

**Performance:**
- ✅ Faster queries with proper indexes on answer_keys, topic_id
- ✅ Reduced JSON parsing overhead
- ✅ Better query planner statistics for optimizer

**Maintainability:**
- ✅ Clear column names vs nested JSON paths
- ✅ Type safety at database level
- ✅ Easier to write queries for analytics/reporting

**Extensibility:**
- ✅ Topics in database → can add new topics dynamically
- ✅ Foreign key constraints ensure referential integrity
- ✅ Standardized region naming → easier to join/reference

**Data Quality:**
- ✅ Separate romanization vs translation fields
- ✅ location_type clarifies pin vs polygon intent
- ✅ Extracted note field improves discoverability

---

### 6.2 Breaking Changes

**Database:**
- ❌ Old columns dropped (type, payload, answer, kind)
- ❌ Region keys changed (IN-DL → IN:Delhi_NCT)
- ⚠️ Requires full data migration

**Application Code:**
- ❌ All controllers/models referencing old columns must be updated
- ❌ TypeScript types must be updated
- ❌ Seed scripts must be rewritten

**API:**
- ✅ No breaking changes to API contract (internal changes only)
- ✅ /api/rapid/queue still returns same structure
- ✅ /api/rapid/grade still accepts same structure

**Timeline Estimate:**
- Schema migration: 2 hours
- Data migration: 4 hours (including testing)
- Code updates: 8 hours
- Testing: 4 hours
- **Total: 2-3 days**

---

### 6.3 Rollback Strategy

**If migration fails:**
1. Keep old columns during Phase 1-3
2. Run app on old columns while testing new ones
3. If issues found, revert migration
4. Only drop old columns after 1 week of stable operation

**Backup plan:**
- Export current database to SQL dump before migration
- Keep backup for 2 weeks
- Test migration on staging environment first

---

## 7. Action Items

### 7.1 Immediate (Before Migration)

- [ ] Review and approve schema design
- [ ] Audit all fact_cards for romanization vs translation issues
- [ ] Create complete region key mapping (old → new)
- [ ] Write migration scripts with rollback capability
- [ ] Set up staging database for testing

### 7.2 Migration (Day 1-2)

- [ ] Backup production database
- [ ] Run Phase 1 migration (create new schema)
- [ ] Run Phase 2 migration (migrate data)
- [ ] Verify data integrity (row counts, foreign keys)
- [ ] Test basic queries on new schema

### 7.3 Code Updates (Day 2-3)

- [ ] Update TypeScript types
- [ ] Update controllers (buildQueue, generatePickOptions, etc.)
- [ ] Update API routes
- [ ] Update seed scripts
- [ ] Update validation logic
- [ ] Run test suite

### 7.4 Cleanup (After 1 week)

- [ ] Monitor for issues
- [ ] Drop old columns (Phase 4)
- [ ] Update documentation
- [ ] Remove backup if no issues

---

## 8. Appendix

### 8.1 Full TypeScript Type Definitions

```typescript
// New types after migration

export type Topic = {
  id: string;
  key: string;
  title: string;
  description: string | null;
  icon: string | null;
  mode_type: 'language' | 'phone' | 'city';
  difficulty: 'beginner' | 'intermediate' | 'advanced' | null;
  target_tags: string[] | null;
  meta: Record<string, any>;
};

export type FactCard = {
  id: string;
  topic_id: string;

  // Language snippet fields
  text: string | null;
  romanization: string | null;
  translation: string | null;

  // Phone number fields
  phone_number: string | null;
  phone_masked: string | null;

  // City locate fields
  city_name: string | null;
  country_hint: string | null;

  primary_tags: string[];
  difficulty: number;

  // Flattened answer
  answer_kind: 'tag' | 'region';
  answer_keys: string[];
  answer_region_keys: string[] | null;

  created_at: string;
};

export type Region = {
  id: string;
  key: string;  // Format: "IN", "IN:Kerala", "TW:Taipei"
  level: 'country' | 'province' | 'city' | 'neighborhood';
  name: string;
  country: string | null;
  location_type: 'pin' | 'polygon';
  centroid_lonlat: [number, number] | null;
  geometry: GeoJSON.Geometry | null;
  bbox: [number, number, number, number] | null;
  note: string | null;
  meta: Record<string, any>;
};

export type SkillTag = {
  id: string;
  key: string;
  family: 'script' | 'phone' | 'city';
  country: string | null;
  display: string;
  note: string | null;
  examples: string[];
  meta: Record<string, any>;
};
```

---

### 8.2 Example Queries After Migration

**Get all cards for a topic:**
```sql
select fc.*, t.title as topic_title
from fact_cards fc
join topics t on t.id = fc.topic_id
where t.key = 'india-languages'
order by fc.difficulty, random()
limit 10;
```

**Get cards due for review:**
```sql
select fc.*, ufs.due_at
from fact_cards fc
join user_fact_stats ufs on ufs.fact_id = fc.id
where ufs.user_id = 'user-uuid'
  and ufs.due_at <= now()
order by ufs.due_at
limit 20;
```

**Find all cards with a specific answer region:**
```sql
select fc.*
from fact_cards fc
where 'IN:Kerala' = any(fc.answer_region_keys);
```

**Get topic statistics:**
```sql
select
  t.title,
  count(fc.id) as total_cards,
  avg(fc.difficulty) as avg_difficulty
from topics t
left join fact_cards fc on fc.topic_id = t.id
group by t.id, t.title;
```

---

### 8.3 References

- Current schema: `supabase/migrations/20251109161427_add_geolet_schema.sql`
- Seed data: `supabase/seed/*.json`
- Topics config: `src/features/rapid/config/topics.ts`
- Queue builder: `src/features/rapid/controllers/build-queue.ts`
- Answer validator: `src/features/rapid/models/answer-validator.ts`

---

**End of Document**
