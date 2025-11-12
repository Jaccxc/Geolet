# Database Fresh Migration Plan - Drop & Recreate

**Created:** 2025-11-12 17:46:24
**Status:** Implementation Plan
**Purpose:** Complete database rebuild with optimized schema using existing GeoJSON data

**Migration Type:** DROP existing tables + CREATE new schema (Alpha stage - acceptable)

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Tables to Drop](#2-tables-to-drop)
3. [New Schema with Enums](#3-new-schema-with-enums)
4. [GeoJSON Data Integration Strategy](#4-geojson-data-integration-strategy)
5. [Seed Data Population Plan](#5-seed-data-population-plan)
6. [Migration Scripts](#6-migration-scripts)

---

## 1. Executive Summary

### Migration Strategy

**Approach:** Fresh start with drop and recreate
- Drop only Geolet-specific tables (preserve user/auth tables)
- Create new optimized schema with PostgreSQL enums
- Populate regions from existing GeoJSON files
- Reuse existing skill_tags seed data
- Defer topics, card_groups, and fact_cards for later

### Key Decisions

1. ✅ Use PostgreSQL `ENUM` types for all enumerable fields
2. ✅ Integrate GeoJSON data from `/public/geojson/`
3. ✅ Keep user/customer/auth tables untouched
4. ✅ Populate regions first (all countries + India states)
5. ✅ Reuse skill_tags from existing seed data
6. ✅ Defer topic/card_group/fact_card population

---

## 2. Tables to Drop

### 2.1 Geolet-Specific Tables to DROP

```sql
-- Drop in dependency order (child tables first)

-- Drop dependent tables
drop table if exists game_sessions cascade;
drop table if exists user_fact_stats cascade;
drop table if exists insight_rounds cascade;

-- Drop main content tables
drop table if exists fact_cards cascade;
drop table if exists regions cascade;
drop table if exists skill_tags cascade;

-- Note: DO NOT drop auth.users or any other Supabase auth/user tables
```

### 2.2 Tables to PRESERVE

**Keep these tables untouched:**
- `auth.users` (Supabase authentication)
- `auth.sessions`
- `auth.refresh_tokens`
- Any custom user/customer tables
- `storage.*` tables (if using Supabase storage)

---

## 3. New Schema with Enums

### 3.1 Create Enum Types

```sql
-- Create all enum types first

create type region_level_enum as enum ('country', 'province', 'city');

create type location_type_enum as enum ('pin', 'polygon');

create type skill_family_enum as enum ('script', 'phone', 'city');

create type difficulty_enum as enum ('beginner', 'intermediate', 'advanced');

create type fact_difficulty_enum as enum ('1', '2', '3');  -- Card difficulty levels
```

### 3.2 Create card_groups Table

```sql
create table card_groups (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz not null default now()
);

create index card_groups_name_idx on card_groups (name);

alter table card_groups enable row level security;
create policy "rt card_groups" on card_groups for select using (true);

comment on table card_groups is 'Logical groupings of fact cards (e.g., India Scripts, Global Phone Codes)';
```

### 3.3 Create topics Table

```sql
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  title text not null,
  description text,
  icon text,  -- Lucide icon name

  pick_mode_active boolean not null default true,
  map_mode_active boolean not null default true,

  difficulty difficulty_enum,
  target_card_group_ids uuid[],  -- Array of card_group IDs

  created_at timestamptz not null default now()
);

create index topics_key_idx on topics (key);
create index topics_pick_mode_idx on topics (pick_mode_active) where pick_mode_active = true;
create index topics_map_mode_idx on topics (map_mode_active) where map_mode_active = true;
create index topics_card_groups_gin on topics using gin (target_card_group_ids);

alter table topics enable row level security;
create policy "rt topics" on topics for select using (true);

comment on table topics is 'Game topics with mode flags and card group references';
```

### 3.4 Create regions Table

```sql
create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- Format: "IN", "IN:Maharashtra", "TW:Taipei"
  level region_level_enum not null,
  name text not null,
  country text,  -- ISO 3166-1 alpha-2 code (null for countries themselves)

  -- Geospatial data
  location_type location_type_enum not null,
  centroid_lonlat double precision[],  -- [lng, lat]
  geometry jsonb,  -- GeoJSON geometry object

  note text,

  created_at timestamptz not null default now()
);

create index regions_key_idx on regions (key);
create index regions_level_idx on regions (level);
create index regions_country_idx on regions (country);
create index regions_location_type_idx on regions (location_type);

alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);

comment on table regions is 'Geographic regions (countries, provinces, cities) with GeoJSON data';

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

### 3.5 Create skill_tags Table

```sql
create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  family skill_family_enum not null,
  country text,  -- ISO 3166-1 alpha-2 code

  display text not null,
  note text,
  examples text[],

  created_at timestamptz not null default now()
);

create index skill_tags_key_idx on skill_tags (key);
create index skill_tags_family_idx on skill_tags (family);
create index skill_tags_country_idx on skill_tags (country);

alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);

comment on table skill_tags is 'Skills/tags for fact cards (scripts, phone codes, etc.)';
```

### 3.6 Create fact_cards Table

```sql
create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  card_group_id uuid not null references card_groups(id) on delete cascade,

  prompt text not null,  -- Main content (script text, phone number, city name)
  hint text,  -- Auxiliary info (romanization, area code, country hint)

  primary_skill_tags text[] not null,
  difficulty fact_difficulty_enum not null default '1',

  answer_region_id uuid not null references regions(id) on delete restrict,

  created_at timestamptz not null default now()
);

create index fact_cards_card_group_idx on fact_cards (card_group_id);
create index fact_cards_skill_tags_gin on fact_cards using gin (primary_skill_tags);
create index fact_cards_answer_region_idx on fact_cards (answer_region_id);
create index fact_cards_difficulty_idx on fact_cards (difficulty);

alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);

comment on table fact_cards is 'Quiz/game cards with prompts and answers';
```

### 3.7 Create user_fact_stats Table (SRS system)

```sql
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

create index ufs_user_idx on user_fact_stats (user_id);
create index ufs_due_idx on user_fact_stats (user_id, due_at) where due_at is not null;

alter table user_fact_stats enable row level security;
create policy "own ufs" on user_fact_stats
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

comment on table user_fact_stats is 'User progress tracking with SRS (Spaced Repetition System)';
```

### 3.8 Create game_sessions Table

```sql
create table game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null,  -- e.g., "language-pick", "phone-map"
  created_at timestamptz not null default now(),
  summary jsonb not null default '{}'
);

create index game_sessions_user_idx on game_sessions (user_id);
create index game_sessions_user_time on game_sessions (user_id, created_at desc);

alter table game_sessions enable row level security;
create policy "own sessions" on game_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

comment on table game_sessions is 'Completed game session history';
```

### 3.9 Create insight_rounds Table (keep existing structure)

```sql
create table insight_rounds (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  played_at timestamptz,
  country text,
  target_country text,
  distance_m float,
  time_ms int,
  meta jsonb
);

create index insight_user_time on insight_rounds (user_id, played_at);
create index insight_user_target on insight_rounds (user_id, target_country);

alter table insight_rounds enable row level security;
create policy "own insight" on insight_rounds
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

comment on table insight_rounds is 'GeoGuessr-style game rounds (separate feature)';
```

---

## 4. GeoJSON Data Integration Strategy

### 4.1 Existing GeoJSON Files

```
/public/geojson/
├── countries.json         (582 KB) - All countries with polygons
└── regions/
    └── IN.json           (125 KB) - Indian states/UTs
```

### 4.2 countries.json Structure

**Format:** GeoJSON FeatureCollection

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "iso_a2": "AF",
        "iso_a3": "AFG",
        "name": "Afghanistan",
        "name_long": "Afghanistan",
        "continent": "Asia",
        "region_un": "Asia",
        "subregion": "Southern Asia",
        "pop_est": 28400000,
        // ... many other properties
      },
      "geometry": {
        "type": "Polygon",  // or MultiPolygon
        "coordinates": [[[ lng, lat ], ...]]
      }
    },
    // ... ~200 countries
  ]
}
```

**Key fields to extract:**
- `properties.iso_a2` → `regions.key`
- `properties.name` → `regions.name`
- `geometry` → `regions.geometry` (full GeoJSON Geometry object)

### 4.3 regions/IN.json Structure

**Format:** GeoJSON FeatureCollection

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "ID_1": 1,
        "NAME_1": "Andaman and Nicobar",
        "VARNAME_1": "Andaman & Nicobar Islands|...",
        "TYPE_1": "Union Territory",
        "ENGTYPE_1": "Union Territory"
      },
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [[[[lng, lat], ...]]]
      }
    },
    // ... ~36 Indian states/UTs
  ]
}
```

**Key fields to extract:**
- Generate `key` as `"IN:" + sanitized(NAME_1)` (e.g., "IN:Andhra_Pradesh")
- `properties.NAME_1` → `regions.name`
- `properties.TYPE_1` → determine `regions.level` (Union Territory → province)
- `geometry` → `regions.geometry`

### 4.4 Centroid Calculation Strategy

**Option 1: Use Turf.js (Recommended)**
```javascript
import * as turf from '@turf/turf';

const feature = {
  type: 'Feature',
  geometry: { ... }
};

const centroid = turf.centroid(feature);
const [lng, lat] = centroid.geometry.coordinates;
```

**Option 2: PostGIS (if available)**
```sql
update regions
set centroid_lonlat = array[
  ST_X(ST_Centroid(ST_GeomFromGeoJSON(geometry))),
  ST_Y(ST_Centroid(ST_GeomFromGeoJSON(geometry)))
]
where centroid_lonlat is null and geometry is not null;
```

**For MVP:** Pre-compute centroids with Turf.js during seed script.

---

## 5. Seed Data Population Plan

### 5.1 Population Order

```
1. skill_tags       (reuse existing seed data)
2. regions          (from GeoJSON: countries + India states)
3. card_groups      (defer - manual creation later)
4. topics           (defer - manual creation later)
5. fact_cards       (defer - manual creation later)
```

### 5.2 Phase 1: Populate skill_tags

**Source:** Existing `supabase/seed/skill_tags.json`

**Migration:** Extract `display`, `note`, `examples` from `meta` → plain columns

**Script:** `supabase/seed/01_populate_skill_tags.sql`

```sql
-- Example transformation from existing data:
insert into skill_tags (key, family, country, display, note, examples)
values
  (
    'script:malayalam',
    'script',
    'IN',
    'Malayalam',
    'Found in Kerala. Curvy letters with upside-down U-shapes.',
    array['ഹോട്ടല്‍', 'റസ്റ്റോറന്റ്', 'സ്കൂള്‍']
  ),
  -- ... all other skill tags
;
```

**Action:** Write Node.js/TypeScript script to read existing JSON and transform to SQL.

### 5.3 Phase 2: Populate regions (Countries)

**Source:** `/public/geojson/countries.json`

**Target:** ~195 countries

**Script:** `supabase/seed/02_populate_countries.ts`

```typescript
import fs from 'fs';
import * as turf from '@turf/turf';

const countriesGeoJSON = JSON.parse(
  fs.readFileSync('./public/geojson/countries.json', 'utf-8')
);

const countries = countriesGeoJSON.features.map((feature: any) => {
  const iso2 = feature.properties.iso_a2;
  const name = feature.properties.name;
  const geometry = feature.geometry;

  // Calculate centroid
  const centroid = turf.centroid(feature);
  const [lng, lat] = centroid.geometry.coordinates;

  return {
    key: iso2,  // "IN", "US", etc.
    level: 'country',
    name: name,
    country: null,  // Countries have no parent
    location_type: 'polygon',
    centroid_lonlat: [lng, lat],
    geometry: geometry,  // Store full geometry
    note: null
  };
});

// Generate SQL or use Supabase client to insert
const sql = countries.map(c => `
  insert into regions (key, level, name, country, location_type, centroid_lonlat, geometry)
  values (
    '${c.key}',
    '${c.level}',
    '${c.name.replace(/'/g, "''")}',
    null,
    '${c.location_type}',
    array[${c.centroid_lonlat[0]}, ${c.centroid_lonlat[1]}],
    '${JSON.stringify(c.geometry)}'::jsonb
  );
`).join('\n');

fs.writeFileSync('./supabase/seed/02_countries.sql', sql);
```

### 5.4 Phase 3: Populate regions (India States)

**Source:** `/public/geojson/regions/IN.json`

**Target:** ~36 Indian states/UTs

**Script:** `supabase/seed/03_populate_india_states.ts`

```typescript
import fs from 'fs';
import * as turf from '@turf/turf';

const indiaRegionsGeoJSON = JSON.parse(
  fs.readFileSync('./public/geojson/regions/IN.json', 'utf-8')
);

// Helper: Sanitize name for key generation
function sanitizeForKey(name: string): string {
  return name
    .replace(/\s+/g, '_')  // Spaces to underscores
    .replace(/[^a-zA-Z0-9_]/g, '')  // Remove special chars
    .replace(/_+/g, '_');  // Collapse multiple underscores
}

const indiaStates = indiaRegionsGeoJSON.features.map((feature: any) => {
  const name = feature.properties.NAME_1;
  const typeStr = feature.properties.TYPE_1 || 'State';
  const geometry = feature.geometry;

  // Generate key: IN:State_Name
  const key = `IN:${sanitizeForKey(name)}`;

  // Calculate centroid
  const centroid = turf.centroid(feature);
  const [lng, lat] = centroid.geometry.coordinates;

  return {
    key: key,  // "IN:Andhra_Pradesh", "IN:Maharashtra", etc.
    level: 'province',  // All Indian states/UTs are provinces
    name: name,  // "Andhra Pradesh", "Maharashtra"
    country: 'IN',
    location_type: 'polygon',
    centroid_lonlat: [lng, lat],
    geometry: geometry,
    note: typeStr !== 'State' ? `${typeStr}` : null  // "Union Territory" for UTs
  };
});

// Generate SQL
const sql = indiaStates.map(s => `
  insert into regions (key, level, name, country, location_type, centroid_lonlat, geometry, note)
  values (
    '${s.key}',
    '${s.level}',
    '${s.name.replace(/'/g, "''")}',
    '${s.country}',
    '${s.location_type}',
    array[${s.centroid_lonlat[0]}, ${s.centroid_lonlat[1]}],
    '${JSON.stringify(s.geometry)}'::jsonb,
    ${s.note ? `'${s.note}'` : 'null'}
  );
`).join('\n');

fs.writeFileSync('./supabase/seed/03_india_states.sql', sql);
```

**Key Naming Examples:**
```
"Andaman and Nicobar"    → "IN:Andaman_and_Nicobar"
"Andhra Pradesh"         → "IN:Andhra_Pradesh"
"NCT of Delhi"           → "IN:NCT_of_Delhi"
"Jammu and Kashmir"      → "IN:Jammu_and_Kashmir"
```

### 5.5 Phase 4: Defer Topics, Card Groups, Fact Cards

**Reason:** These require careful manual curation

**Action:**
- Create empty placeholder migrations
- Document structure for manual population later
- Focus on getting regions + skill_tags working first

---

## 6. Migration Scripts

### 6.1 Complete Migration SQL

**File:** `supabase/migrations/20251112174624_fresh_schema.sql`

```sql
-- ============================================
-- FRESH DATABASE MIGRATION
-- Date: 2025-11-12
-- Purpose: Drop old tables and create optimized schema
-- ============================================

-- ============================================
-- PART 1: DROP OLD TABLES
-- ============================================

-- Drop in dependency order (child tables first)
drop table if exists game_sessions cascade;
drop table if exists user_fact_stats cascade;
drop table if exists insight_rounds cascade;
drop table if exists fact_cards cascade;
drop table if exists regions cascade;
drop table if exists skill_tags cascade;

-- Drop old types if they exist
drop type if exists location_type_enum cascade;
drop type if exists region_level_enum cascade;
drop type if exists skill_family_enum cascade;
drop type if exists difficulty_enum cascade;
drop type if exists fact_difficulty_enum cascade;

-- ============================================
-- PART 2: CREATE ENUM TYPES
-- ============================================

create type region_level_enum as enum ('country', 'province', 'city');
create type location_type_enum as enum ('pin', 'polygon');
create type skill_family_enum as enum ('script', 'phone', 'city');
create type difficulty_enum as enum ('beginner', 'intermediate', 'advanced');
create type fact_difficulty_enum as enum ('1', '2', '3');

-- ============================================
-- PART 3: CREATE NEW TABLES
-- ============================================

-- 3.1: card_groups
create table card_groups (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz not null default now()
);

create index card_groups_name_idx on card_groups (name);
alter table card_groups enable row level security;
create policy "rt card_groups" on card_groups for select using (true);
comment on table card_groups is 'Logical groupings of fact cards';

-- 3.2: topics
create table topics (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  title text not null,
  description text,
  icon text,
  pick_mode_active boolean not null default true,
  map_mode_active boolean not null default true,
  difficulty difficulty_enum,
  target_card_group_ids uuid[],
  created_at timestamptz not null default now()
);

create index topics_key_idx on topics (key);
create index topics_pick_mode_idx on topics (pick_mode_active) where pick_mode_active = true;
create index topics_map_mode_idx on topics (map_mode_active) where map_mode_active = true;
create index topics_card_groups_gin on topics using gin (target_card_group_ids);
alter table topics enable row level security;
create policy "rt topics" on topics for select using (true);
comment on table topics is 'Game topics with mode flags';

-- 3.3: regions
create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  level region_level_enum not null,
  name text not null,
  country text,
  location_type location_type_enum not null,
  centroid_lonlat double precision[],
  geometry jsonb,
  note text,
  created_at timestamptz not null default now()
);

create index regions_key_idx on regions (key);
create index regions_level_idx on regions (level);
create index regions_country_idx on regions (country);
create index regions_location_type_idx on regions (location_type);
alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);
comment on table regions is 'Geographic regions with GeoJSON';

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

-- 3.4: skill_tags
create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  family skill_family_enum not null,
  country text,
  display text not null,
  note text,
  examples text[],
  created_at timestamptz not null default now()
);

create index skill_tags_key_idx on skill_tags (key);
create index skill_tags_family_idx on skill_tags (family);
create index skill_tags_country_idx on skill_tags (country);
alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);
comment on table skill_tags is 'Skills/tags for fact cards';

-- 3.5: fact_cards
create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  card_group_id uuid not null references card_groups(id) on delete cascade,
  prompt text not null,
  hint text,
  primary_skill_tags text[] not null,
  difficulty fact_difficulty_enum not null default '1',
  answer_region_id uuid not null references regions(id) on delete restrict,
  created_at timestamptz not null default now()
);

create index fact_cards_card_group_idx on fact_cards (card_group_id);
create index fact_cards_skill_tags_gin on fact_cards using gin (primary_skill_tags);
create index fact_cards_answer_region_idx on fact_cards (answer_region_id);
create index fact_cards_difficulty_idx on fact_cards (difficulty);
alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);
comment on table fact_cards is 'Quiz/game cards';

-- 3.6: user_fact_stats
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

create index ufs_user_idx on user_fact_stats (user_id);
create index ufs_due_idx on user_fact_stats (user_id, due_at) where due_at is not null;
alter table user_fact_stats enable row level security;
create policy "own ufs" on user_fact_stats
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
comment on table user_fact_stats is 'User progress (SRS system)';

-- 3.7: game_sessions
create table game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null,
  created_at timestamptz not null default now(),
  summary jsonb not null default '{}'
);

create index game_sessions_user_idx on game_sessions (user_id);
create index game_sessions_user_time on game_sessions (user_id, created_at desc);
alter table game_sessions enable row level security;
create policy "own sessions" on game_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
comment on table game_sessions is 'Game session history';

-- 3.8: insight_rounds
create table insight_rounds (
  id bigserial primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  played_at timestamptz,
  country text,
  target_country text,
  distance_m float,
  time_ms int,
  meta jsonb
);

create index insight_user_time on insight_rounds (user_id, played_at);
create index insight_user_target on insight_rounds (user_id, target_country);
alter table insight_rounds enable row level security;
create policy "own insight" on insight_rounds
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
comment on table insight_rounds is 'GeoGuessr-style game rounds';
```

### 6.2 Seed Data Scripts Structure

```
supabase/seed/
├── scripts/
│   ├── transform_skill_tags.ts      # Transform old JSON to new format
│   ├── populate_countries.ts         # Extract from countries.json
│   └── populate_india_states.ts      # Extract from regions/IN.json
├── generated/
│   ├── 01_skill_tags.sql             # Generated from script
│   ├── 02_countries.sql              # Generated from script
│   └── 03_india_states.sql           # Generated from script
└── manual/
    ├── 04_card_groups.sql            # Manual creation (defer)
    ├── 05_topics.sql                 # Manual creation (defer)
    └── 06_fact_cards.sql             # Manual creation (defer)
```

### 6.3 TypeScript Seed Generation Script

**File:** `supabase/seed/scripts/generate_all_seeds.ts`

```typescript
import fs from 'fs';
import path from 'path';
import * as turf from '@turf/turf';

// ============================================
// 1. Transform skill_tags
// ============================================
function generateSkillTagsSQL(): string {
  const oldData = JSON.parse(
    fs.readFileSync('./supabase/seed/skill_tags.json', 'utf-8')
  );

  const inserts = oldData.map((tag: any) => {
    const key = tag.key;
    const family = tag.family;
    const country = tag.country || null;
    const display = tag.meta?.display || tag.key;
    const note = tag.meta?.notes || null;
    const examples = tag.meta?.examples || [];

    return `insert into skill_tags (key, family, country, display, note, examples) values (
  '${key}',
  '${family}',
  ${country ? `'${country}'` : 'null'},
  '${display.replace(/'/g, "''")}',
  ${note ? `'${note.replace(/'/g, "''")}'` : 'null'},
  array[${examples.map((e: string) => `'${e.replace(/'/g, "''")}'`).join(', ')}]
);`;
  });

  return `-- Generated skill_tags seed data\n-- Source: supabase/seed/skill_tags.json\n\n${inserts.join('\n\n')}`;
}

// ============================================
// 2. Extract countries from GeoJSON
// ============================================
function generateCountriesSQL(): string {
  const geojson = JSON.parse(
    fs.readFileSync('./public/geojson/countries.json', 'utf-8')
  );

  const inserts = geojson.features
    .filter((f: any) => f.properties.iso_a2)  // Skip features without ISO code
    .map((feature: any) => {
      const iso2 = feature.properties.iso_a2;
      const name = feature.properties.name || feature.properties.name_long;
      const geometry = feature.geometry;

      // Calculate centroid
      const centroid = turf.centroid(feature);
      const [lng, lat] = centroid.geometry.coordinates;

      // Escape single quotes in name and JSON
      const safeName = name.replace(/'/g, "''");
      const geometryJSON = JSON.stringify(geometry).replace(/'/g, "''");

      return `insert into regions (key, level, name, country, location_type, centroid_lonlat, geometry) values (
  '${iso2}',
  'country',
  '${safeName}',
  null,
  'polygon',
  array[${lng}, ${lat}],
  '${geometryJSON}'::jsonb
);`;
    });

  return `-- Generated countries seed data\n-- Source: public/geojson/countries.json\n-- Count: ${inserts.length} countries\n\n${inserts.join('\n\n')}`;
}

// ============================================
// 3. Extract India states from GeoJSON
// ============================================
function generateIndiaStatesSQL(): string {
  const geojson = JSON.parse(
    fs.readFileSync('./public/geojson/regions/IN.json', 'utf-8')
  );

  function sanitizeForKey(name: string): string {
    return name
      .replace(/\s+/g, '_')
      .replace(/[^a-zA-Z0-9_]/g, '')
      .replace(/_+/g, '_');
  }

  const inserts = geojson.features.map((feature: any) => {
    const name = feature.properties.NAME_1;
    const typeStr = feature.properties.TYPE_1 || 'State';
    const geometry = feature.geometry;

    const key = `IN:${sanitizeForKey(name)}`;

    // Calculate centroid
    const centroid = turf.centroid(feature);
    const [lng, lat] = centroid.geometry.coordinates;

    const safeName = name.replace(/'/g, "''");
    const geometryJSON = JSON.stringify(geometry).replace(/'/g, "''");
    const note = typeStr !== 'State' ? typeStr : null;

    return `insert into regions (key, level, name, country, location_type, centroid_lonlat, geometry, note) values (
  '${key}',
  'province',
  '${safeName}',
  'IN',
  'polygon',
  array[${lng}, ${lat}],
  '${geometryJSON}'::jsonb,
  ${note ? `'${note}'` : 'null'}
);`;
  });

  return `-- Generated India states/UTs seed data\n-- Source: public/geojson/regions/IN.json\n-- Count: ${inserts.length} states/UTs\n\n${inserts.join('\n\n')}`;
}

// ============================================
// Main: Generate all seeds
// ============================================
function main() {
  const outputDir = './supabase/seed/generated';

  // Create output directory
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  console.log('Generating seed data...');

  // 1. skill_tags
  console.log('  - Transforming skill_tags...');
  const skillTagsSQL = generateSkillTagsSQL();
  fs.writeFileSync(path.join(outputDir, '01_skill_tags.sql'), skillTagsSQL);

  // 2. Countries
  console.log('  - Extracting countries from GeoJSON...');
  const countriesSQL = generateCountriesSQL();
  fs.writeFileSync(path.join(outputDir, '02_countries.sql'), countriesSQL);

  // 3. India states
  console.log('  - Extracting India states from GeoJSON...');
  const indiaSQL = generateIndiaStatesSQL();
  fs.writeFileSync(path.join(outputDir, '03_india_states.sql'), indiaSQL);

  console.log('✅ Seed generation complete!');
  console.log(`   Files written to ${outputDir}/`);
}

main();
```

**Run with:**
```bash
cd supabase/seed/scripts
npm install @turf/turf
npx tsx generate_all_seeds.ts
```

### 6.4 Apply Migration Steps

```bash
# 1. Run fresh migration
supabase db reset  # Drops all tables and reapplies migrations

# OR manually:
psql $DATABASE_URL -f supabase/migrations/20251112174624_fresh_schema.sql

# 2. Generate seed data
cd supabase/seed/scripts
npx tsx generate_all_seeds.ts

# 3. Apply seed data
psql $DATABASE_URL -f supabase/seed/generated/01_skill_tags.sql
psql $DATABASE_URL -f supabase/seed/generated/02_countries.sql
psql $DATABASE_URL -f supabase/seed/generated/03_india_states.sql

# 4. Verify
psql $DATABASE_URL -c "select count(*) from skill_tags;"
psql $DATABASE_URL -c "select count(*) from regions where level = 'country';"
psql $DATABASE_URL -c "select count(*) from regions where level = 'province';"
```

---

## 7. Verification Queries

### 7.1 Check Table Counts

```sql
-- Should have ~40 skill tags
select count(*) as skill_tags_count from skill_tags;

-- Should have ~195 countries
select count(*) as country_count from regions where level = 'country';

-- Should have ~36 India states/UTs
select count(*) as india_states_count from regions where level = 'province' and country = 'IN';

-- Total regions
select count(*) as total_regions from regions;
```

### 7.2 Sample Region Data

```sql
-- Sample countries
select key, name, location_type,
       centroid_lonlat[1] as lng,
       centroid_lonlat[2] as lat
from regions
where level = 'country'
limit 5;

-- Sample India states
select key, name, note
from regions
where country = 'IN' and level = 'province'
order by name
limit 10;
```

### 7.3 Validate GeoJSON Structure

```sql
-- Check geometry is valid JSON
select key, name,
       jsonb_typeof(geometry) as geometry_type,
       geometry->>'type' as geom_shape
from regions
where geometry is not null
limit 5;
```

---

## 8. Next Steps After Migration

### 8.1 Immediate (Day 1)

- [ ] Run fresh migration SQL
- [ ] Generate seed scripts for skill_tags, countries, India states
- [ ] Apply seed data
- [ ] Verify table counts and sample data
- [ ] Test basic queries

### 8.2 Short Term (Week 1)

- [ ] Create placeholder card_groups (manually)
- [ ] Create placeholder topics (manually)
- [ ] Update application code to use new schema
- [ ] Update API routes (buildQueue, generatePickOptions, etc.)
- [ ] Update TypeScript types

### 8.3 Medium Term (Week 2-3)

- [ ] Populate fact_cards (manually curated)
- [ ] Test Pick mode with new schema
- [ ] Test Map mode with new schema
- [ ] Validate GeoJSON rendering on map
- [ ] Performance testing

### 8.4 Long Term (Month 1+)

- [ ] Add more countries' regions (e.g., US states, China provinces)
- [ ] Add cities to regions table
- [ ] Expand fact_cards library
- [ ] Add new card_groups and topics
- [ ] Consider adding GeoJSON simplification for performance

---

## 9. Rollback Plan

### 9.1 If Migration Fails

**Backup Strategy:**
1. Export auth.users table before migration
2. Keep old migration files
3. Document current state

**Rollback Steps:**
```bash
# 1. Drop new tables
psql $DATABASE_URL -c "drop schema public cascade; create schema public;"

# 2. Restore old migrations
supabase db reset --restore-from-backup

# 3. Restore auth.users if needed
psql $DATABASE_URL -f backup/auth_users_backup.sql
```

### 9.2 Partial Rollback

If only seed data is wrong:
```bash
# Clear regions table and re-seed
psql $DATABASE_URL -c "truncate regions cascade;"
psql $DATABASE_URL -f supabase/seed/generated/02_countries.sql
psql $DATABASE_URL -f supabase/seed/generated/03_india_states.sql
```

---

## 10. Appendix

### 10.1 Updated TypeScript Types

```typescript
export type RegionLevel = 'country' | 'province' | 'city';
export type LocationType = 'pin' | 'polygon';
export type SkillFamily = 'script' | 'phone' | 'city';
export type TopicDifficulty = 'beginner' | 'intermediate' | 'advanced';
export type FactDifficulty = '1' | '2' | '3';

export type Region = {
  id: string;
  key: string;  // "IN", "IN:Maharashtra", etc.
  level: RegionLevel;
  name: string;
  country: string | null;
  location_type: LocationType;
  centroid_lonlat: [number, number] | null;
  geometry: GeoJSON.Geometry | null;
  note: string | null;
  created_at: string;
};

export type SkillTag = {
  id: string;
  key: string;
  family: SkillFamily;
  country: string | null;
  display: string;
  note: string | null;
  examples: string[];
  created_at: string;
};

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
  difficulty: TopicDifficulty | null;
  target_card_group_ids: string[] | null;
  created_at: string;
};

export type FactCard = {
  id: string;
  card_group_id: string;
  prompt: string;
  hint: string | null;
  primary_skill_tags: string[];
  difficulty: FactDifficulty;
  answer_region_id: string;
  created_at: string;
};
```

### 10.2 Example Key Mappings

**Countries (from GeoJSON iso_a2):**
```
IN  → India
US  → United States
TW  → Taiwan
CN  → China
FR  → France
```

**India States (generated keys):**
```
Andaman and Nicobar       → IN:Andaman_and_Nicobar
Andhra Pradesh            → IN:Andhra_Pradesh
Arunachal Pradesh         → IN:Arunachal_Pradesh
Assam                     → IN:Assam
Bihar                     → IN:Bihar
Chandigarh                → IN:Chandigarh
Chhattisgarh              → IN:Chhattisgarh
Dadra and Nagar Haveli    → IN:Dadra_and_Nagar_Haveli
NCT of Delhi              → IN:NCT_of_Delhi
Gujarat                   → IN:Gujarat
Haryana                   → IN:Haryana
Himachal Pradesh          → IN:Himachal_Pradesh
Jammu and Kashmir         → IN:Jammu_and_Kashmir
Jharkhand                 → IN:Jharkhand
Karnataka                 → IN:Karnataka
Kerala                    → IN:Kerala
Madhya Pradesh            → IN:Madhya_Pradesh
Maharashtra               → IN:Maharashtra
Manipur                   → IN:Manipur
Meghalaya                 → IN:Meghalaya
Mizoram                   → IN:Mizoram
Nagaland                  → IN:Nagaland
Odisha                    → IN:Odisha
Punjab                    → IN:Punjab
Rajasthan                 → IN:Rajasthan
Tamil Nadu                → IN:Tamil_Nadu
Telangana                 → IN:Telangana
Tripura                   → IN:Tripura
Uttar Pradesh             → IN:Uttar_Pradesh
Uttarakhand               → IN:Uttarakhand
West Bengal               → IN:West_Bengal
```

---

**End of Document**
