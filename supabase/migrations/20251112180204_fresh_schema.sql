-- ============================================
-- FRESH DATABASE MIGRATION
-- Date: 2025-11-12 18:02:04
-- Purpose: Drop old tables and create optimized schema with ENUMs
-- ============================================
-- IMPORTANT: This drops Geolet tables only, preserves auth.users
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

-- Drop card_groups and topics if they exist from previous attempts
drop table if exists topics cascade;
drop table if exists card_groups cascade;

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

comment on type region_level_enum is 'Geographic hierarchy levels';
comment on type location_type_enum is 'Region location representation type';
comment on type skill_family_enum is 'Skill tag categories';
comment on type difficulty_enum is 'Topic difficulty levels';
comment on type fact_difficulty_enum is 'Fact card difficulty levels (1=easy, 3=hard)';

-- ============================================
-- PART 3: CREATE NEW TABLES
-- ============================================

-- --------------------------------------------
-- 3.1: card_groups
-- --------------------------------------------
create table card_groups (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  created_at timestamptz not null default now()
);

create index card_groups_name_idx on card_groups (name);

alter table card_groups enable row level security;
create policy "rt card_groups" on card_groups for select using (true);

comment on table card_groups is 'Logical groupings of fact cards (e.g., India Scripts, Global Phone Codes)';

-- --------------------------------------------
-- 3.2: topics
-- --------------------------------------------
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

-- --------------------------------------------
-- 3.3: regions
-- --------------------------------------------
create table regions (
  id uuid primary key default gen_random_uuid(),
  key text unique not null,  -- Format: "IN", "IN:Maharashtra", "TW:Taipei"
  level region_level_enum not null,
  name text not null,
  country text,  -- ISO 3166-1 alpha-2 code (null for countries themselves)

  -- Geospatial data
  location_type location_type_enum not null,
  centroid_lonlat double precision[],  -- [lng, lat] - ONLY for location_type='pin'
  geometry jsonb,  -- GeoJSON geometry object - ONLY for location_type='polygon'

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
comment on column regions.centroid_lonlat is 'Required for location_type=pin, not used for polygon';
comment on column regions.geometry is 'Required for location_type=polygon, not used for pin';

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

comment on function validate_region_location_type() is 'Ensures location_type has required data (pin needs centroid, polygon needs geometry)';

-- --------------------------------------------
-- 3.4: skill_tags
-- --------------------------------------------
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

-- --------------------------------------------
-- 3.5: fact_cards
-- --------------------------------------------
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
comment on column fact_cards.prompt is 'Main content displayed to user';
comment on column fact_cards.hint is 'Optional hint (romanization, translation, etc.)';

-- --------------------------------------------
-- 3.6: user_fact_stats (SRS system)
-- --------------------------------------------
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

-- --------------------------------------------
-- 3.7: game_sessions
-- --------------------------------------------
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

-- --------------------------------------------
-- 3.8: insight_rounds (keep existing structure)
-- --------------------------------------------
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

-- ============================================
-- PART 4: SUCCESS MESSAGE
-- ============================================

do $$
begin
  raise notice '✅ Fresh schema migration complete!';
  raise notice '   - All old Geolet tables dropped';
  raise notice '   - New optimized schema created with ENUMs';
  raise notice '   - Ready for seed data population';
  raise notice '';
  raise notice '📋 Next steps:';
  raise notice '   1. Run: cd supabase/seed/scripts && npm install';
  raise notice '   2. Run: npm run generate';
  raise notice '   3. Apply: psql $DB_URL -f supabase/seed/01_skill_tags.sql';
  raise notice '   4. Apply: psql $DB_URL -f supabase/seed/02_countries.sql';
  raise notice '   5. Apply: psql $DB_URL -f supabase/seed/03_india_states.sql';
end $$;
