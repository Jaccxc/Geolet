# Database Structure Optimization Analysis & Migration Plan (REVISED)

**Created:** 2025-11-12 17:07:42
**Status:** Analysis & Proposal (Revised)
**Purpose:** Comprehensive analysis of current /rapid gamemode data architecture and proposed optimization plan

**Revision Notes:**
- Introduced `card_groups` table instead of topics-based card organization
- Simplified `fact_cards` to use generic `prompt` and `hint` fields
- Changed answer structure to single `answer_region_id` foreign key
- Updated `topics` table to support both pick/map modes with boolean flags
- Removed unnecessary `meta` and `bbox` columns

---

## Table of Contents

1. [Current Architecture Analysis](#1-current-architecture-analysis)
2. [Data Flow & Game Mechanics](#2-data-flow--game-mechanics)
3. [Identified Problems](#3-identified-problems)
4. [Proposed Optimized Schema (REVISED)](#4-proposed-optimized-schema-revised)
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
  // ...
];
```

**Issues:**
- Topics not stored in database
- No foreign key relationship between fact_cards and card groups
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
         * Province: 200km tolerance
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

**Issue:** Type is essentially a proxy for "card category". This is redundant if we have proper card_groups.

**Proposed:** Remove `type`, use `card_group_id` foreign key instead.

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
- Overly complex for what is essentially "which region is the answer?"
- Two different answer types (tag-based vs region-based) create confusion

**Proposed:** Simplify to single `answer_region_id` foreign key.

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

**Rationale:** Always use `:` as delimiter, never `-` for our custom keys.

---

#### Problem 6: Ambiguous "kind" field name
**Current:** `regions.kind` in ('country', 'region', 'city')

**Issue:** "kind" is vague. "region" is overloaded (both table name and a type).

**Proposed:** Rename to `level` with clear values:
- `"country"`
- `"province"` (state, region, territory)
- `"city"`

---

#### Problem 7: No location_type distinction
**Current:** `regions` table has both `geometry` and `centroid_lonlat`

**Issue:** No clear indication of primary location representation.

**Proposed:** Add `location_type` enum:
- `"pin"`: Only `centroid_lonlat` is authoritative
- `"polygon"`: Only `geometry` is authoritative

---

#### Problem 8: Unnecessary meta and bbox columns
**Current:** `regions.meta` stores misc. data, `regions.bbox` stores bounding boxes

**Issue:**
- `meta` is rarely used and adds complexity
- `bbox` can be computed from geometry when needed
- Both add maintenance burden

**Proposed:** Remove both columns.

---

### 3.4 skill_tags Issues

#### Problem 9: meta.notes trapped in JSON
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

### 3.5 Missing Card Groups & Topics Structure

#### Problem 10: No database representation of card groups
**Current:** Cards are grouped implicitly by `type` field

**Issues:**
- Cannot organize cards into logical groups (e.g., "India Scripts", "East Asian Scripts")
- No way to have multiple card groups per topic
- Cannot add metadata to card groups

**Proposed:** Create `card_groups` table.

---

#### Problem 11: Topics not flexible enough for dual modes
**Current:** Separate PICK_MODE_TOPICS and MAP_MODE_TOPICS arrays

**Issues:**
- Same topic duplicated across both modes
- Cannot enable/disable modes independently per topic
- Hard to query "which topics support map mode?"

**Proposed:** Single `topics` table with `pick_mode_active` and `map_mode_active` boolean flags.

---

## 4. Proposed Optimized Schema (REVISED)

### 4.1 New card_groups Table

```sql
create table card_groups (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,  -- e.g., "India Scripts", "East Asian Scripts", "Global Phone Codes"
  created_at timestamptz default now()
);

create index card_groups_name_idx on card_groups (name);

alter table card_groups enable row level security;
create policy "rt card_groups" on card_groups for select using (true);

-- Example data
insert into card_groups (name) values
  ('India Scripts'),
  ('East Asian Scripts'),
  ('Southeast Asian Scripts'),
  ('European Scripts'),
  ('Middle Eastern Scripts'),
  ('Global Phone Codes'),
  ('Major World Cities'),
  ('Indian Cities');
```

**Purpose:** Logical grouping of fact cards (replaces implicit `type` field).

---

### 4.2 Revised topics Table

```sql
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- e.g., "india-languages", "global-phone"
  title text not null,  -- e.g., "India Languages"
  description text,
  icon text,  -- lucide icon name, e.g., "Languages", "Phone"

  -- Mode activation flags
  pick_mode_active boolean not null default true,
  map_mode_active boolean not null default true,

  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),

  -- Link to card groups instead of tags
  target_card_group_ids uuid[],  -- Optional filter for which card groups to include

  created_at timestamptz default now()
);

create index topics_pick_mode_idx on topics (pick_mode_active) where pick_mode_active = true;
create index topics_map_mode_idx on topics (map_mode_active) where map_mode_active = true;
create index topics_card_groups_gin on topics using gin (target_card_group_ids);

alter table topics enable row level security;
create policy "rt topics" on topics for select using (true);

-- Example data
insert into topics (key, title, description, icon, pick_mode_active, map_mode_active, difficulty, target_card_group_ids) values
  (
    'india-languages',
    'India Languages',
    'Identify regional scripts across Indian states - from Devanagari to Telugu',
    'Languages',
    true,
    true,
    'intermediate',
    array[(select id from card_groups where name = 'India Scripts')]
  ),
  (
    'global-languages',
    'Global Languages',
    'Recognize language scripts from around the world',
    'Globe',
    true,
    true,
    'advanced',
    null  -- No filter, includes all language card groups
  ),
  (
    'global-phone',
    'Global Phone Numbers',
    'Match country codes to countries',
    'Phone',
    true,
    true,
    'beginner',
    array[(select id from card_groups where name = 'Global Phone Codes')]
  ),
  (
    'major-cities',
    'Major Cities',
    'Locate major cities on the world map',
    'MapPin',
    false,  -- Pick mode disabled for city location
    true,   -- Only map mode makes sense
    'beginner',
    array[(select id from card_groups where name = 'Major World Cities')]
  );
```

**Key Changes:**
1. ✅ Removed `mode_type` → replaced with `pick_mode_active` and `map_mode_active` booleans
2. ✅ Removed `target_tags` → replaced with `target_card_group_ids` array
3. ✅ Removed `meta` column (not needed)

---

### 4.3 Simplified fact_cards Table

```sql
create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  card_group_id uuid not null references card_groups(id) on delete cascade,

  -- Generic display fields (works for all card types)
  prompt text not null,  -- The main content: script text, phone number, or city name
  hint text,  -- Optional hint: romanization, area code hint, country hint, etc.

  primary_skill_tags text[] not null,  -- Renamed from primary_tags
  difficulty int not null default 1,

  -- Simplified answer: just a region ID
  answer_region_id uuid not null references regions(id) on delete restrict,

  created_at timestamptz default now()
);

create index fact_cards_card_group_idx on fact_cards (card_group_id);
create index fact_cards_skill_tags_gin on fact_cards using gin (primary_skill_tags);
create index fact_cards_answer_region_idx on fact_cards (answer_region_id);
create index fact_cards_difficulty_idx on fact_cards (difficulty);

alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);
```

**Key Changes:**
1. ✅ Removed `type` → replaced with `card_group_id` foreign key
2. ✅ Removed `payload` JSON → replaced with `prompt` (main content) and `hint` (auxiliary info)
3. ✅ Renamed `primary_tags` → `primary_skill_tags` for clarity
4. ✅ Removed complex `answer` JSON → replaced with single `answer_region_id` foreign key
5. ✅ Added `created_at` timestamp

**Examples:**

**Language snippet card:**
```sql
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'India Scripts'),
  'ഹോട്ടല്‍',  -- prompt: the script text
  'hōṭṭal (hotel)',  -- hint: romanization + optional translation
  array['script:malayalam'],
  1,
  (select id from regions where key = 'IN:Kerala')
);
```

**Phone number card:**
```sql
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Global Phone Codes'),
  '+91 22 2345 6789',  -- prompt: full phone number
  'Mumbai area code',  -- hint: area code context
  array['phone:+91', 'phone:+91:22'],
  2,
  (select id from regions where key = 'IN:Mumbai')
);
```

**City locate card:**
```sql
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Major World Cities'),
  'Taipei',  -- prompt: city name
  'Capital of Taiwan',  -- hint: additional context
  array['city:TW:tier1', 'city:global:tier1'],
  1,
  (select id from regions where key = 'TW:Taipei')
);
```

---

### 4.4 Optimized regions Table

```sql
create type location_type_enum as enum ('pin', 'polygon');

create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- Format: "IN", "IN:Kerala", "TW:Taipei"
  level text not null check (level in ('country', 'province', 'city')),
  name text not null,
  country text,  -- ISO country code (null for countries themselves)

  -- Geospatial data
  location_type location_type_enum not null,
  centroid_lonlat double precision[],  -- [lng, lat] - required for 'pin', optional for 'polygon'
  geometry jsonb,  -- GeoJSON polygon - required for 'polygon'

  note text,  -- Human-readable notes (extracted from old meta)

  created_at timestamptz default now()
);

create index regions_level_idx on regions (level);
create index regions_country_idx on regions (country);
create index regions_location_type_idx on regions (location_type);
create index regions_key_idx on regions (key);

alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);

-- Add validation trigger
create or replace function validate_region_location_type()
returns trigger as $$
begin
  if new.location_type = 'pin' and new.centroid_lonlat is null then
    raise exception 'centroid_lonlat required for location_type=pin';
  end if;

  if new.location_type = 'polygon' and new.geometry is null then
    raise exception 'geometry required for location_type=polygon';
  end if;

  return new;
end;
$$ language plpgsql;

create trigger validate_region_location_type_trigger
  before insert or update on regions
  for each row
  execute function validate_region_location_type();
```

**Key Changes:**
1. ✅ Standardized `key` format: always use `:` delimiter (never `-`)
2. ✅ Renamed `kind` → `level` for clarity
3. ✅ Changed `location_type` to PostgreSQL enum type (better performance)
4. ✅ Removed `meta` column (not needed)
5. ✅ Removed `bbox` column (can be computed from geometry if needed)
6. ✅ Extracted `note` from old meta JSON
7. ✅ Made `centroid_lonlat` nullable (only required for pin type)
8. ✅ Made `geometry` nullable (only required for polygon type)
9. ✅ Added trigger to validate location_type constraints
10. ✅ Added `created_at` timestamp

---

### 4.5 Optimized skill_tags Table

```sql
create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- e.g., "script:devanagari:hindi"
  family text not null check (family in ('script', 'phone', 'city')),
  country text,  -- ISO country code (nullable)

  display text not null,  -- Extracted from meta.display
  note text,  -- Extracted from meta.notes
  examples text[],  -- Extracted from meta.examples (now typed array)

  created_at timestamptz default now()
);

create index skill_tags_family_idx on skill_tags (family);
create index skill_tags_country_idx on skill_tags (country);
create index skill_tags_key_idx on skill_tags (key);

alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);
```

**Key Changes:**
1. ✅ Extracted `display` from `meta` → top-level column (NOT NULL)
2. ✅ Extracted `note` from `meta` → top-level column (nullable)
3. ✅ Extracted `examples` from `meta` → typed text array
4. ✅ Removed `meta` column entirely (all data extracted)
5. ✅ Added `created_at` timestamp

---

### 4.6 No Changes to Other Tables

**user_fact_stats:** No changes needed (still references fact_cards.id)
**game_sessions:** No changes needed (still stores mode string)
**insight_rounds:** No changes needed (different feature)

---

### 4.7 Updated Schema Diagram

```
                            ┌─────────────────┐
                            │  card_groups    │
                            │─────────────────│
                            │ id (PK)         │
                            │ name (unique)   │
                            │ created_at      │
                            └─────────────────┘
                                    ↑
                                    │
                                    │ (card_group_id FK)
                                    │
┌─────────────────────────────┐     │     ┌──────────────────────┐
│  fact_cards                 │     │     │  regions             │
│─────────────────────────────│     │     │──────────────────────│
│ id (PK)                     │     │     │ id (PK)              │
│ card_group_id (FK) ───────────────┘     │ key (unique)         │
│ prompt                      │           │ level                │
│ hint                        │           │ name                 │
│ primary_skill_tags          │           │ country              │
│ difficulty                  │           │ location_type (enum) │
│ answer_region_id (FK) ──────────────────→ centroid_lonlat      │
│ created_at                  │           │ geometry             │
└─────────────────────────────┘           │ note                 │
                                          │ created_at           │
                                          └──────────────────────┘

┌─────────────────────────────┐
│  topics                     │
│─────────────────────────────│
│ id (PK)                     │
│ key (unique)                │
│ title                       │
│ description                 │
│ icon                        │
│ pick_mode_active            │
│ map_mode_active             │
│ difficulty                  │
│ target_card_group_ids[]     │───┐
│ created_at                  │   │
└─────────────────────────────┘   │
                                  │ (references card_groups.id[])
                                  ↓
                          ┌─────────────────┐
                          │  card_groups    │
                          └─────────────────┘

┌─────────────────────────────┐
│  skill_tags                 │
│─────────────────────────────│
│ id (PK)                     │
│ key (unique)                │
│ family                      │
│ country                     │
│ display                     │
│ note                        │
│ examples[]                  │
│ created_at                  │
└─────────────────────────────┘
        ↑
        │ (referenced by primary_skill_tags[])
        │
┌───────────────────┐
│  fact_cards       │
│ primary_skill_tags│
└───────────────────┘
```

---

## 5. Migration Strategy

### 5.1 Migration Phases

**Phase 1: Create New Schema (Non-Breaking)**
1. Create enum type `location_type_enum`
2. Create `card_groups` table
3. Create `topics` table
4. Alter `fact_cards` table (add new columns, keep old ones)
5. Alter `regions` table (add new columns, keep old ones)
6. Alter `skill_tags` table (add new columns, keep old ones)

**Phase 2: Data Migration**
1. Populate `card_groups` table
2. Populate `topics` table
3. Migrate fact_cards:
   - Set `card_group_id` based on old `type`
   - Flatten `payload` → `prompt` and `hint`
   - Extract answer region and set `answer_region_id`
4. Update regions:
   - Rename keys (IN-DL → IN:Delhi_NCT)
   - Set `level` from `kind`
   - Set `location_type` to 'polygon' for all
   - Extract `note` from `meta`
5. Migrate skill_tags:
   - Extract `display`, `note`, `examples` from `meta`

**Phase 3: Update Application Code**
1. Update API routes to use new columns
2. Update controllers to use new schema
3. Update Pick/Map mode logic
4. Update seed scripts to use new format
5. Add data validation

**Phase 4: Remove Old Columns (Breaking)**
1. Drop old fact_cards columns: `type`, `payload`, `answer`, `primary_tags`
2. Drop old regions columns: `kind`, `bbox`, `meta`
3. Drop old skill_tags columns: `meta`
4. Remove old region keys with `-` delimiter

---

### 5.2 Detailed Migration SQL

```sql
-- ============================================
-- PHASE 1: CREATE NEW SCHEMA
-- ============================================

-- Step 1: Create enum type for location_type
create type location_type_enum as enum ('pin', 'polygon');

-- Step 2: Create card_groups table
create table card_groups (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz default now()
);
create index card_groups_name_idx on card_groups (name);
alter table card_groups enable row level security;
create policy "rt card_groups" on card_groups for select using (true);

-- Step 3: Create topics table
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  title text not null,
  description text,
  icon text,
  pick_mode_active boolean not null default true,
  map_mode_active boolean not null default true,
  difficulty text check (difficulty in ('beginner', 'intermediate', 'advanced')),
  target_card_group_ids uuid[],
  created_at timestamptz default now()
);
create index topics_pick_mode_idx on topics (pick_mode_active) where pick_mode_active = true;
create index topics_map_mode_idx on topics (map_mode_active) where map_mode_active = true;
create index topics_card_groups_gin on topics using gin (target_card_group_ids);
alter table topics enable row level security;
create policy "rt topics" on topics for select using (true);

-- Step 4: Add new columns to fact_cards
alter table fact_cards add column card_group_id uuid references card_groups(id) on delete cascade;
alter table fact_cards add column prompt text;
alter table fact_cards add column hint text;
alter table fact_cards add column primary_skill_tags text[];
alter table fact_cards add column answer_region_id uuid references regions(id) on delete restrict;
alter table fact_cards add column created_at timestamptz default now();

-- Step 5: Add new columns to regions
alter table regions add column level text check (level in ('country', 'province', 'city'));
alter table regions add column location_type location_type_enum;
alter table regions add column note text;
alter table regions add column created_at timestamptz default now();
alter table regions alter column centroid_lonlat drop not null;
alter table regions alter column bbox drop not null;

-- Step 6: Add new columns to skill_tags
alter table skill_tags add column display text;
alter table skill_tags add column note text;
alter table skill_tags add column examples text[];
alter table skill_tags add column created_at timestamptz default now();

-- ============================================
-- PHASE 2: DATA MIGRATION
-- ============================================

-- Step 7: Populate card_groups
insert into card_groups (name) values
  ('India Scripts'),
  ('East Asian Scripts'),
  ('Southeast Asian Scripts'),
  ('European Scripts'),
  ('Middle Eastern Scripts'),
  ('Global Phone Codes'),
  ('Major World Cities'),
  ('Indian Cities');

-- Step 8: Populate topics
insert into topics (key, title, description, icon, pick_mode_active, map_mode_active, difficulty, target_card_group_ids)
values
  (
    'india-languages',
    'India Languages',
    'Identify regional scripts across Indian states - from Devanagari to Telugu',
    'Languages',
    true,
    true,
    'intermediate',
    array[(select id from card_groups where name = 'India Scripts')]
  ),
  (
    'global-languages',
    'Global Languages',
    'Recognize language scripts from around the world',
    'Globe',
    true,
    true,
    'advanced',
    null
  ),
  (
    'global-phone',
    'Global Phone Numbers',
    'Match country codes to countries (+886 for Taiwan, +91 for India)',
    'Phone',
    true,
    true,
    'beginner',
    array[(select id from card_groups where name = 'Global Phone Codes')]
  ),
  (
    'major-cities',
    'Major Cities',
    'Locate major cities on the world map by name',
    'MapPin',
    false,
    true,
    'beginner',
    array[(select id from card_groups where name = 'Major World Cities')]
  );

-- Step 9: Migrate fact_cards - set card_group_id based on type
update fact_cards set card_group_id = (
  select id from card_groups where name =
    case
      when fact_cards.type = 'language_snippet' then 'India Scripts'  -- Default to India Scripts
      when fact_cards.type = 'phone_number' then 'Global Phone Codes'
      when fact_cards.type = 'city_locate' then 'Major World Cities'
    end
);

-- Step 10: Migrate fact_cards - set prompt based on payload
update fact_cards set
  prompt = case
    when type = 'language_snippet' then payload->>'text'
    when type = 'phone_number' then payload->>'number'
    when type = 'city_locate' then payload->>'city'
  end;

-- Step 11: Migrate fact_cards - set hint based on payload
update fact_cards set
  hint = case
    when type = 'language_snippet' then payload->>'romanization'
    when type = 'phone_number' then payload->>'masked'
    when type = 'city_locate' then payload->>'country_hint'
  end;

-- Step 12: Migrate fact_cards - rename primary_tags → primary_skill_tags
update fact_cards set primary_skill_tags = primary_tags;

-- Step 13: Migrate fact_cards - set answer_region_id
-- This is complex because we need to:
-- 1. Extract region keys from answer JSON
-- 2. Look up region ID by key
-- For now, use a helper function:

create or replace function migrate_fact_card_answer_region(fc fact_cards)
returns uuid as $$
declare
  answer_kind text;
  region_keys text[];
  region_key text;
  region_id uuid;
begin
  answer_kind := fc.answer->>'kind';

  if answer_kind = 'region' then
    -- For region-based answers, use select.keys
    region_keys := array(select jsonb_array_elements_text(fc.answer->'select'->'keys'));
  elsif answer_kind = 'tag' then
    -- For tag-based answers, use map_equivalents.regions
    region_keys := array(select jsonb_array_elements_text(fc.answer->'map_equivalents'->'regions'));
  end if;

  if array_length(region_keys, 1) > 0 then
    region_key := region_keys[1];  -- Take first region as answer
    select id into region_id from regions where key = region_key;
    return region_id;
  end if;

  return null;
end;
$$ language plpgsql;

-- Run migration
update fact_cards set answer_region_id = migrate_fact_card_answer_region(fact_cards);

-- Clean up helper function
drop function migrate_fact_card_answer_region;

-- Step 14: Migrate regions - set level from kind
update regions set level =
  case kind
    when 'country' then 'country'
    when 'region' then 'province'
    when 'city' then 'city'
  end;

-- Step 15: Migrate regions - set location_type (all polygon for MVP)
update regions set location_type = 'polygon';

-- Step 16: Migrate regions - extract note from meta
update regions set note = meta->>'note';

-- Step 17: Update region keys (rename to new convention)
-- Create temp mapping table
create temp table region_key_migrations (
  old_key text,
  new_key text
);

-- Populate with mappings (example - full list needed)
insert into region_key_migrations (old_key, new_key) values
  ('IN-DL', 'IN:Delhi_NCT'),
  ('IN-UP', 'IN:Uttar_Pradesh'),
  ('IN-MH', 'IN:Maharashtra'),
  ('IN-KL', 'IN:Kerala'),
  ('IN-KA', 'IN:Karnataka'),
  ('IN-TN', 'IN:Tamil_Nadu'),
  ('IN-WB', 'IN:West_Bengal'),
  ('IN-GJ', 'IN:Gujarat'),
  ('IN-RJ', 'IN:Rajasthan'),
  ('IN-PB', 'IN:Punjab'),
  ('IN-HR', 'IN:Haryana'),
  ('IN-MP', 'IN:Madhya_Pradesh'),
  ('IN-AS', 'IN:Assam'),
  ('IN-TG', 'IN:Telangana'),
  ('IN-AP', 'IN:Andhra_Pradesh'),
  ('IN-OD', 'IN:Odisha')
  -- ... add all mappings
;

-- Update regions table
update regions r
set key = m.new_key
from region_key_migrations m
where r.key = m.old_key;

-- Note: This will fail due to FK constraint from fact_cards.answer_region_id
-- Need to temporarily disable constraint or update in transaction

-- Clean up
drop table region_key_migrations;

-- Step 18: Migrate skill_tags - extract from meta
update skill_tags set
  display = meta->>'display',
  note = meta->>'notes',
  examples = array(select jsonb_array_elements_text(meta->'examples'));

-- ============================================
-- PHASE 3: ADD CONSTRAINTS & INDEXES
-- ============================================

-- Make new columns required after migration
alter table fact_cards alter column card_group_id set not null;
alter table fact_cards alter column prompt set not null;
alter table fact_cards alter column primary_skill_tags set not null;
alter table fact_cards alter column answer_region_id set not null;

alter table regions alter column level set not null;
alter table regions alter column location_type set not null;

alter table skill_tags alter column display set not null;

-- Add new indexes
create index fact_cards_card_group_idx on fact_cards (card_group_id);
create index fact_cards_skill_tags_gin on fact_cards using gin (primary_skill_tags);
create index fact_cards_answer_region_idx on fact_cards (answer_region_id);
create index fact_cards_difficulty_idx on fact_cards (difficulty);

create index regions_level_idx on regions (level);
create index regions_location_type_idx on regions (location_type);
create index regions_key_idx on regions (key);

create index skill_tags_key_idx on skill_tags (key);

-- Add validation trigger for regions
create or replace function validate_region_location_type()
returns trigger as $$
begin
  if new.location_type = 'pin' and new.centroid_lonlat is null then
    raise exception 'centroid_lonlat required for location_type=pin';
  end if;

  if new.location_type = 'polygon' and new.geometry is null then
    raise exception 'geometry required for location_type=polygon';
  end if;

  return new;
end;
$$ language plpgsql;

create trigger validate_region_location_type_trigger
  before insert or update on regions
  for each row
  execute function validate_region_location_type();

-- ============================================
-- PHASE 4: CLEANUP (After verifying app works)
-- ============================================

-- Drop old columns from fact_cards
alter table fact_cards drop column type;
alter table fact_cards drop column payload;
alter table fact_cards drop column answer;
alter table fact_cards drop column primary_tags;

-- Drop old columns from regions
alter table regions drop column kind;
alter table regions drop column bbox;
alter table regions drop column meta;

-- Drop old columns from skill_tags
alter table skill_tags drop column meta;
```

---

### 5.3 Seed Data Format Changes

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
  "card_group_name": "India Scripts",
  "prompt": "ഹോട്ടല്‍",
  "hint": "hōṭṭal (hotel)",
  "primary_skill_tags": ["script:malayalam"],
  "difficulty": 1,
  "answer_region_key": "IN:Kerala"
}
```

---

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
  "note": null
}
```

---

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
  "examples": ["ഹോട്ടല്‍", "റസ്റ്റോറന്റ്", "സ്കൂള്‍"]
}
```

---

#### New: card_groups.json
```json
[
  {"name": "India Scripts"},
  {"name": "East Asian Scripts"},
  {"name": "Southeast Asian Scripts"},
  {"name": "European Scripts"},
  {"name": "Middle Eastern Scripts"},
  {"name": "Global Phone Codes"},
  {"name": "Major World Cities"},
  {"name": "Indian Cities"}
]
```

---

#### New: topics.json
```json
[
  {
    "key": "india-languages",
    "title": "India Languages",
    "description": "Identify regional scripts across Indian states - from Devanagari to Telugu",
    "icon": "Languages",
    "pick_mode_active": true,
    "map_mode_active": true,
    "difficulty": "intermediate",
    "target_card_group_names": ["India Scripts"]
  },
  {
    "key": "global-languages",
    "title": "Global Languages",
    "description": "Recognize language scripts from around the world",
    "icon": "Globe",
    "pick_mode_active": true,
    "map_mode_active": true,
    "difficulty": "advanced",
    "target_card_group_names": null
  },
  {
    "key": "global-phone",
    "title": "Global Phone Numbers",
    "description": "Match country codes to countries",
    "icon": "Phone",
    "pick_mode_active": true,
    "map_mode_active": true,
    "difficulty": "beginner",
    "target_card_group_names": ["Global Phone Codes"]
  },
  {
    "key": "major-cities",
    "title": "Major Cities",
    "description": "Locate major cities on the world map",
    "icon": "MapPin",
    "pick_mode_active": false,
    "map_mode_active": true,
    "difficulty": "beginner",
    "target_card_group_names": ["Major World Cities"]
  }
]
```

---

## 6. Impact Analysis

### 6.1 Benefits

**Simplicity:**
- ✅ Much simpler fact_cards structure (just `prompt` + `hint`)
- ✅ Single answer field (`answer_region_id`) vs complex JSON
- ✅ Clear separation of concerns (card_groups, topics, cards)

**Performance:**
- ✅ Direct foreign key joins instead of JSON array lookups
- ✅ Proper indexes on all foreign keys
- ✅ Enum type for location_type (more efficient than text)

**Maintainability:**
- ✅ No more meta/payload JSON blobs
- ✅ Clear column names
- ✅ Database-level referential integrity
- ✅ Can query across relationships easily

**Flexibility:**
- ✅ Topics can enable/disable Pick vs Map modes independently
- ✅ Card groups are reusable across multiple topics
- ✅ Easy to add new card groups without code changes

**Data Quality:**
- ✅ Location type validation enforced by trigger
- ✅ Foreign key constraints prevent orphaned data
- ✅ Cleaner separation of romanization/translation in hint field

---

### 6.2 Breaking Changes

**Database:**
- ❌ Major schema restructure
- ❌ All JSON columns replaced with plain columns
- ❌ Region keys renamed (IN-DL → IN:Kerala)
- ❌ Answer structure completely changed
- ⚠️ Requires full data migration

**Application Code:**
- ❌ All controllers must be rewritten
- ❌ Pick mode logic must use card_groups instead of type
- ❌ Map mode validation simplified (always uses answer_region_id)
- ❌ TypeScript types completely changed
- ❌ Seed scripts must be rewritten

**API:**
- ⚠️ Internal changes only, but significant
- ✅ Can maintain same API contract with adapters

**Timeline Estimate:**
- Schema design review: 4 hours
- Migration script writing: 8 hours
- Data migration testing: 8 hours
- Code updates: 16 hours
- Integration testing: 8 hours
- **Total: 5-6 days**

---

### 6.3 Rollback Strategy

**If migration fails:**
1. Keep old columns during Phase 1-3
2. Run dual-write mode (update both old and new columns)
3. Test thoroughly on new columns
4. Only drop old columns after 2 weeks of stable operation

**Backup plan:**
- Full database dump before migration
- Keep backup for 1 month
- Test migration on staging environment multiple times
- Prepare rollback scripts

---

## 7. Action Items

### 7.1 Immediate (Before Migration)

- [ ] Review and approve revised schema design
- [ ] Create complete region key mapping (IN-DL → IN:Kerala, etc.)
- [ ] Audit fact_cards for prompt/hint content quality
- [ ] Define all card_groups in advance
- [ ] Write comprehensive migration scripts with rollback
- [ ] Set up staging database

### 7.2 Migration (Day 1-3)

- [ ] Backup production database
- [ ] Run Phase 1: Create new schema
- [ ] Run Phase 2: Populate card_groups and topics
- [ ] Run Phase 2: Migrate fact_cards data
- [ ] Run Phase 2: Migrate regions data
- [ ] Run Phase 2: Migrate skill_tags data
- [ ] Verify data integrity (counts, foreign keys, nulls)
- [ ] Test queries on new schema

### 7.3 Code Updates (Day 3-5)

- [ ] Update TypeScript types for all tables
- [ ] Rewrite buildQueue() to use card_group_id
- [ ] Simplify generatePickOptions() (still uses skill_tags)
- [ ] Simplify generateMapRegions() (just get answer_region)
- [ ] Update validateMapAnswer() to use single region
- [ ] Update all API routes
- [ ] Rewrite seed data loaders
- [ ] Update frontend to fetch topics with mode flags
- [ ] Run full test suite

### 7.4 Testing (Day 5-6)

- [ ] Test Pick mode with new schema
- [ ] Test Map mode with new schema
- [ ] Test SRS system still works
- [ ] Test topic filtering by card_groups
- [ ] Performance testing (query speed)
- [ ] Load testing

### 7.5 Cleanup (After 1 week)

- [ ] Monitor for issues
- [ ] Drop old columns (Phase 4)
- [ ] Update documentation
- [ ] Remove backup if stable

---

## 8. Appendix

### 8.1 Full TypeScript Type Definitions

```typescript
// Updated types after migration

export type CardGroup = {
  id: string;
  name: string;
  created_at: string;
};

export type Topic = {
  id: string;
  key: string;
  title: string;
  description: string | null;
  icon: string | null;
  pick_mode_active: boolean;
  map_mode_active: boolean;
  difficulty: 'beginner' | 'intermediate' | 'advanced' | null;
  target_card_group_ids: string[] | null;
  created_at: string;
};

export type FactCard = {
  id: string;
  card_group_id: string;
  prompt: string;  // The main content (script, phone, city name)
  hint: string | null;  // Auxiliary info (romanization, area code, country)
  primary_skill_tags: string[];
  difficulty: number;
  answer_region_id: string;  // Simple FK to region
  created_at: string;
};

export type Region = {
  id: string;
  key: string;  // Format: "IN", "IN:Kerala", "TW:Taipei"
  level: 'country' | 'province' | 'city';
  name: string;
  country: string | null;
  location_type: 'pin' | 'polygon';
  centroid_lonlat: [number, number] | null;
  geometry: GeoJSON.Geometry | null;
  note: string | null;
  created_at: string;
};

export type SkillTag = {
  id: string;
  key: string;
  family: 'script' | 'phone' | 'city';
  country: string | null;
  display: string;
  note: string | null;
  examples: string[];
  created_at: string;
};
```

---

### 8.2 Example Queries After Migration

**Get all topics supporting map mode:**
```sql
select *
from topics
where map_mode_active = true
order by difficulty, title;
```

**Get all cards for a topic (via card_groups):**
```sql
select fc.*, r.name as answer_region_name, cg.name as card_group_name
from topics t
join card_groups cg on cg.id = any(t.target_card_group_ids)
join fact_cards fc on fc.card_group_id = cg.id
join regions r on r.id = fc.answer_region_id
where t.key = 'india-languages'
order by fc.difficulty, random()
limit 10;
```

**Get cards due for review:**
```sql
select fc.*, ufs.due_at, r.name as answer_region
from fact_cards fc
join user_fact_stats ufs on ufs.fact_id = fc.id
join regions r on r.id = fc.answer_region_id
where ufs.user_id = 'user-uuid'
  and ufs.due_at <= now()
order by ufs.due_at
limit 20;
```

**Find all cards for a specific region:**
```sql
select fc.*, r.name as region_name
from fact_cards fc
join regions r on r.id = fc.answer_region_id
where r.key = 'IN:Kerala';
```

**Get topic statistics:**
```sql
select
  t.title,
  t.pick_mode_active,
  t.map_mode_active,
  count(fc.id) as total_cards,
  avg(fc.difficulty) as avg_difficulty
from topics t
left join card_groups cg on cg.id = any(t.target_card_group_ids)
left join fact_cards fc on fc.card_group_id = cg.id
group by t.id, t.title, t.pick_mode_active, t.map_mode_active
order by t.title;
```

**Get all card groups with card counts:**
```sql
select
  cg.name,
  count(fc.id) as card_count,
  count(distinct t.id) as used_in_topics
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
left join topics t on cg.id = any(t.target_card_group_ids)
group by cg.id, cg.name
order by card_count desc;
```

---

### 8.3 Updated Game Logic Pseudocode

#### Pick Mode (Simplified)

```typescript
async function buildQueueForPickMode(topicKey: string, userId: string): FactCard[] {
  // 1. Get topic and its card groups
  const topic = await db.topics.findOne({ key: topicKey, pick_mode_active: true });

  // 2. Query cards from target card groups (or all if null)
  let query = db.fact_cards
    .select('*', 'user_fact_stats(seen, correct, due_at)')
    .eq('user_fact_stats.user_id', userId);

  if (topic.target_card_group_ids) {
    query = query.in('card_group_id', topic.target_card_group_ids);
  }

  const cards = await query;

  // 3. Score and prioritize (same SRS logic as before)
  const scored = cards.map(card => ({
    card,
    score: calculateSRSScore(card.user_fact_stats)
  }));

  scored.sort((a, b) => b.score - a.score);
  return scored.slice(0, 10).map(s => s.card);
}

async function generatePickOptionsForCard(card: FactCard): PickOption[] {
  // Get correct answer region
  const correctRegion = await db.regions.findById(card.answer_region_id);

  // Generate distractors (same level regions)
  const distractors = await db.regions
    .select('*')
    .eq('level', correctRegion.level)
    .neq('id', correctRegion.id)
    .limit(30);

  const randomDistractors = shuffle(distractors).slice(0, 5);

  const options = [
    { key: correctRegion.id, label: correctRegion.name, correct: true },
    ...randomDistractors.map(r => ({ key: r.id, label: r.name, correct: false }))
  ];

  return shuffle(options);
}

async function gradePickMode(factId: string, selectedRegionId: string): boolean {
  const card = await db.fact_cards.findById(factId);
  return selectedRegionId === card.answer_region_id;
}
```

#### Map Mode (Greatly Simplified)

```typescript
async function buildQueueForMapMode(topicKey: string, userId: string): FactCard[] {
  // Same as Pick Mode - queue building is identical
  return buildQueueForPickMode(topicKey, userId);
}

async function getMapRegionForCard(card: FactCard): Region {
  // Much simpler - just fetch the answer region
  return await db.regions.findById(card.answer_region_id);
}

async function gradeMapMode(
  factId: string,
  clickedPoint: [number, number]
): { correct: boolean; distance?: number } {
  const card = await db.fact_cards.findById(factId);
  const region = await db.regions.findById(card.answer_region_id);

  const point = turf.point(clickedPoint);

  // Strategy 1: Polygon check
  if (region.location_type === 'polygon' && region.geometry) {
    const isInside = turf.booleanPointInPolygon(point, region.geometry);
    if (isInside) return { correct: true };
  }

  // Strategy 2: Centroid + tolerance
  if (region.centroid_lonlat) {
    const center = turf.point(region.centroid_lonlat);
    const distance = turf.distance(point, center, { units: 'kilometers' });

    const tolerance = region.level === 'country' ? 500 :
                     region.level === 'province' ? 200 : 50;

    if (distance <= tolerance) {
      return { correct: true, distance };
    }
  }

  return { correct: false };
}
```

---

### 8.4 Benefits Summary Table

| Aspect | Before | After | Improvement |
|--------|--------|-------|-------------|
| **fact_cards structure** | 3 different payload JSON structures | Universal `prompt` + `hint` | ✅ Unified, simple |
| **Answer complexity** | Nested JSON with kind/select/map_equivalents | Single `answer_region_id` FK | ✅ 80% simpler |
| **Card organization** | Implicit via `type` field | Explicit via `card_groups` table | ✅ Database-normalized |
| **Topic flexibility** | Separate Pick/Map topic arrays | Single topics table with boolean flags | ✅ Flexible, DRY |
| **Region naming** | Mixed IN-DL and IN:Delhi | Consistent IN:Delhi format | ✅ Standardized |
| **meta/bbox columns** | JSON blobs everywhere | Removed | ✅ Cleaner schema |
| **Query complexity** | JSON path queries | Direct FK joins | ✅ Faster, clearer |
| **Type safety** | JSON (no validation) | Typed columns + enums | ✅ Better integrity |

---

### 8.5 References

- Current schema: `supabase/migrations/20251109161427_add_geolet_schema.sql`
- Seed data: `supabase/seed/*.json`
- Topics config: `src/features/rapid/config/topics.ts`
- Queue builder: `src/features/rapid/controllers/build-queue.ts`
- Answer validator: `src/features/rapid/models/answer-validator.ts`

---

**End of Document**
