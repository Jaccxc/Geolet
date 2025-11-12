-- ============================================
-- INDIAN LANGUAGES SETUP
-- ============================================
-- Date: 2025-11-12 21:49:48
-- Purpose: Create card groups and topics for Indian languages
-- ============================================

-- --------------------------------------------
-- 1. CREATE CARD GROUPS
-- --------------------------------------------

insert into card_groups (name) values
  ('Indian Languages - Long Form'),  -- Intermediate: 2-3 sentence passages
  ('Indian Languages - Short Form'); -- Advanced: Single vocabulary words

-- --------------------------------------------
-- 2. CREATE SKILL TAGS
-- --------------------------------------------

insert into skill_tags (key, family, country, display, note, examples) values
  ('script:mizo', 'script'::skill_family_enum, 'IN', 'Mizo', 'Uses Latin alphabet with Tibeto-Burman vocabulary. Look for particles: "chuan" (then), "chu" (that), "tak" (very), "ang" (will), "thin" (habitually), "hle" (very), and word endings -ah, -na, -tu', array['chuan', 'chu', 'tak', 'ang', 'thin', 'hle', 'awm', 'ni', 'kan', 'kal']);

-- --------------------------------------------
-- 3. CREATE TOPICS
-- --------------------------------------------

-- Topic 1: Indian Languages (Long Form) - Intermediate
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values (
  'indian-languages-long',
  'Indian Languages - Reading',
  'Identify regional scripts from longer text passages (2-3 sentences). More context makes it easier!',
  'BookOpen',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[(select id from card_groups where name = 'Indian Languages - Long Form')]
);

-- Topic 2: Indian Languages (Short Form) - Advanced
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values (
  'indian-languages-short',
  'Indian Languages - Vocabulary',
  'Identify regional scripts from only a single word.',
  'Languages',
  true,
  true,
  'advanced'::difficulty_enum,
  array[(select id from card_groups where name = 'Indian Languages - Short Form')]
);

-- ============================================
-- VERIFICATION
-- ============================================

do $$
declare
  long_group_id uuid;
  short_group_id uuid;
  long_topic_id uuid;
  short_topic_id uuid;
begin
  select id into long_group_id from card_groups where name = 'Indian Languages - Long Form';
  select id into short_group_id from card_groups where name = 'Indian Languages - Short Form';
  select id into long_topic_id from topics where key = 'indian-languages-long';
  select id into short_topic_id from topics where key = 'indian-languages-short';

  raise notice '✅ Indian Languages setup complete!';
  raise notice '';
  raise notice 'Card Groups:';
  raise notice '  - Long Form (ID: %)', long_group_id;
  raise notice '  - Short Form (ID: %)', short_group_id;
  raise notice '';
  raise notice 'Topics:';
  raise notice '  - indian-languages-long (ID: %)', long_topic_id;
  raise notice '  - indian-languages-short (ID: %)', short_topic_id;
  raise notice '';
  raise notice '📋 Next: Apply fact card seeds';
  raise notice '   - 05_indian_languages_long_cards.sql';
  raise notice '   - 06_indian_languages_short_cards.sql';
end $$;
