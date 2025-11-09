# Step 2: Database Schema Migration

**Timeline:** 4-6 hours
**Priority:** Critical (Blocks all feature work)

## Overview
Implement the complete Geolet database schema in Supabase using migrations. This creates the foundation for all game mechanics, content, and user progress tracking.

## Prerequisites
- Step 1 completed
- Existing migration: `20240115041359_init.sql` (creates users, customers, subscriptions tables)
- Supabase CLI configured and linked

## Detailed Tasks

### 2.1 Create New Migration File
```bash
bun run migration:new add_geolet_schema
```

### 2.2 Implement Core Tables

#### A. skill_tags (Skill Taxonomy)
```sql
create table skill_tags (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  family text not null check (family in ('script','phone','city')),
  country text,
  meta jsonb not null default '{}'
);
alter table skill_tags enable row level security;
create policy "rt skill_tags" on skill_tags for select using (true);
```

**Fields:**
- `key`: e.g., 'script:devanagari', 'phone:+91', 'city:IN:tier1'
- `family`: categorizes skill type
- `meta`: {display, notes, examples}

#### B. regions (Geographic Data)
```sql
create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,
  kind text not null check (kind in ('country','region','city')),
  name text not null,
  country text,
  geometry jsonb,
  centroid_lonlat double precision[] not null,
  bbox double precision[] not null,
  meta jsonb not null default '{}'
);
alter table regions enable row level security;
create policy "rt regions" on regions for select using (true);
create index regions_kind_idx on regions (kind);
create index regions_country_idx on regions (country);
```

**Fields:**
- `key`: e.g., 'IN', 'IN-DL', 'TW:Taipei'
- `geometry`: GeoJSON Polygon/MultiPolygon/Point (nullable initially)
- `centroid_lonlat`: [longitude, latitude]
- `bbox`: [minLon, minLat, maxLon, maxLat]

#### C. fact_cards (Game Content)
```sql
create table fact_cards (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('language_snippet','phone_number','city_locate')),
  payload jsonb not null,
  primary_tags text[] not null,
  difficulty int not null default 1,
  answer jsonb not null
);
alter table fact_cards enable row level security;
create policy "rt fact_cards" on fact_cards for select using (true);
create index fact_cards_type_idx on fact_cards (type);
create index fact_cards_tags_gin on fact_cards using gin (primary_tags);
```

**Answer Contract Examples:**
```jsonb
-- Region-based
{"kind":"region", "select":{"by":"key","keys":["IN"]}}

-- Tag with map equivalents
{"kind":"tag", "select":{"by":"skill_key","keys":["script:devanagari"]},
 "map_equivalents":{"regions":["IN","NP"]}}
```

#### D. user_fact_stats (Spaced Repetition)
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
alter table user_fact_stats enable row level security;
create policy "own ufs" on user_fact_stats
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index ufs_due_idx on user_fact_stats (user_id, due_at) where due_at is not null;
```

#### E. game_sessions (Progress Tracking)
```sql
create table game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  mode text not null,
  created_at timestamptz not null default now(),
  summary jsonb not null default '{}'
);
alter table game_sessions enable row level security;
create policy "own sessions" on game_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index game_sessions_user_time on game_sessions (user_id, created_at desc);
```

**Modes:** 'language-choice', 'language-map', 'phone-choice', 'phone-map', 'city-map'

#### F. insight_rounds (Imported GeoGuessr Data)
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
alter table insight_rounds enable row level security;
create policy "own insight" on insight_rounds
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index insight_user_time on insight_rounds (user_id, played_at);
create index insight_user_target on insight_rounds (user_id, target_country);
```

### 2.3 Run Migration
```bash
bun run migration:up
```

### 2.4 Verify Schema
- [ ] Check Supabase dashboard → Database → Tables
- [ ] Verify all 6 new tables exist
- [ ] Verify RLS policies are enabled
- [ ] Verify indexes are created

## Files to Create/Modify

### Created:
- `/supabase/migrations/[timestamp]_add_geolet_schema.sql`

### Modified:
- None (pure database migration)

## Acceptance Criteria
- ✅ Migration runs successfully without errors
- ✅ All 6 tables (skill_tags, regions, fact_cards, user_fact_stats, game_sessions, insight_rounds) exist
- ✅ Row Level Security enabled on all tables
- ✅ Indexes created for performance
- ✅ Foreign key constraints working
- ✅ Can query tables from Supabase dashboard

## Notes & Considerations
- **No PostGIS**: Using JSONB for geometries + client-side validation (Turf.js)
- **Read-only content**: skill_tags, regions, fact_cards are public read-only
- **User-scoped data**: All user tables use RLS with auth.uid()
- **GIN index**: Critical for `primary_tags` array queries
- **Answer contract**: Flexible JSONB allows both region and tag-based answers

## Schema Design Decisions
1. **Why JSONB for geometry?** - Avoids PostGIS complexity, sufficient for MVP
2. **Why arrays for primary_tags?** - Enables multi-tag queries with GIN index
3. **Why separate user_fact_stats?** - Keeps user progress independent of content
4. **Why bigserial for insight_rounds?** - Expect large volume of imported data

## Dependencies
- Step 1 (Project Setup)

## Blocks
- Step 3 (Seed Data)
- Step 4 (Data Models)
- All subsequent feature development
