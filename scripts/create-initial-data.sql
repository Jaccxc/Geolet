-- ============================================
-- Initial Data Setup Script
-- ============================================
-- Purpose: Create card groups and topics for testing
-- Run after: Fresh schema migration is complete
-- ============================================

-- ============================================
-- 1. Create Card Groups
-- ============================================

insert into card_groups (name) values
  ('India Regional Languages'),
  ('Indian Phone Codes'),
  ('Global Phone Codes'),
  ('Major Cities - India'),
  ('Major Cities - Global')
on conflict (name) do nothing;

-- ============================================
-- 2. Create Topics
-- ============================================

-- Helper: Get card group IDs
-- Note: Replace these with actual UUIDs after card_groups are created
-- Query to get IDs: SELECT id, name FROM card_groups;

-- Topic 1: Indian Languages
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
) values (
  'india-languages',
  'Indian Languages',
  'Identify regional scripts from across India',
  '🔤',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[(select id from card_groups where name = 'India Regional Languages')]
) on conflict (key) do nothing;

-- Topic 2: Indian Phone Codes
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
) values (
  'india-phone',
  'Indian Phone Codes',
  'Learn area codes from Indian cities',
  '📞',
  true,
  false,
  'beginner'::difficulty_enum,
  array[(select id from card_groups where name = 'Indian Phone Codes')]
) on conflict (key) do nothing;

-- Topic 3: Global Phone Codes
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
) values (
  'global-phone',
  'Global Phone Codes',
  'Master international dialing codes',
  '🌍',
  true,
  false,
  'advanced'::difficulty_enum,
  array[(select id from card_groups where name = 'Global Phone Codes')]
) on conflict (key) do nothing;

-- Topic 4: Major Indian Cities
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
) values (
  'india-cities',
  'Major Indian Cities',
  'Locate India''s most important cities on the map',
  '🏙️',
  true,
  true,
  'beginner'::difficulty_enum,
  array[(select id from card_groups where name = 'Major Cities - India')]
) on conflict (key) do nothing;

-- ============================================
-- 3. Verify Creation
-- ============================================

-- Check card groups
select 'Card Groups:' as info, count(*) as count from card_groups;
select * from card_groups order by name;

-- Check topics
select 'Topics:' as info, count(*) as count from topics;
select key, title, pick_mode_active, map_mode_active, difficulty from topics order by key;

-- ============================================
-- 4. Create Sample Fact Cards (Manual)
-- ============================================

-- NOTE: These are EXAMPLES ONLY
-- You need to:
-- 1. Get actual region IDs from the regions table
-- 2. Create fact cards manually or with a script
-- 3. Ensure answer_region_id matches actual regions

-- Example structure (DO NOT RUN - TEMPLATE ONLY):
/*
insert into fact_cards (
  card_group_id,
  prompt,
  hint,
  primary_skill_tags,
  difficulty,
  answer_region_id
) values (
  (select id from card_groups where name = 'India Regional Languages'),
  'ഹോട്ടല്‍',  -- Malayalam text
  'Found in Kerala. Curvy letters with upside-down U-shapes.',
  array['script:malayalam'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Kerala')
);
*/

-- ============================================
-- 5. Query Helpers
-- ============================================

-- Get all regions for reference
-- select key, level, name, country from regions order by level, name;

-- Get skill tags for reference
-- select key, family, display from skill_tags order by family, key;

-- Get card group IDs for fact card creation
-- select id, name from card_groups;
