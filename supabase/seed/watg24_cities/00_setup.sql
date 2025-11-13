-- ============================================
-- WATG24 CITIES SETUP (TEMPLATE)
-- ============================================
-- Generated from: public/WATG24.csv
-- Date: 2025-11-13T08:52:04.104Z
-- Total Cities: 335
-- ============================================
--
-- TODO INSTRUCTIONS:
-- 1. Fill in country codes for each skill_tag
-- 2. Write geographic/cultural notes for each city
-- 3. Map each city to its region key (or create pin region first)
-- 4. For cities without regions, create them in a separate migration
--    using: bun run migration:new add_watg24_city_regions
--
-- ============================================

-- --------------------------------------------
-- 1. CREATE CARD GROUPS
-- --------------------------------------------

insert into card_groups (name) values
  ('cities_watg24_alpha_plus_plus'),
  ('cities_watg24_alpha_plus'),
  ('cities_watg24_alpha'),
  ('cities_watg24_alpha_minus'),
  ('cities_watg24_beta_plus'),
  ('cities_watg24_beta'),
  ('cities_watg24_beta_minus'),
  ('cities_watg24_gamma_plus'),
  ('cities_watg24_gamma'),
  ('cities_watg24_gamma_minus'),
  ('cities_watg24_high_sufficiency'),

-- --------------------------------------------
-- 2. CREATE TOPICS
-- --------------------------------------------

-- Topic 1: Global Major Cities (Alpha++ and Alpha+)
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
  'global-major-cities',
  'Global Major Cities',
  'Identify the world''s most influential cities - Alpha++ and Alpha+ tier global cities with significant economic and cultural impact.',
  'Building',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[
    (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
    (select id from card_groups where name = 'cities_watg24_alpha_plus')
  ]
);

-- Topic 2: Cities-500 (All WATG24 tiers)
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
  'cities-500',
  'Cities-500',
  'Test your knowledge of 500+ major cities worldwide across all tiers of global city classification.',
  'MapPin',
  true,
  true,
  'advanced'::difficulty_enum,
  array[
    (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
    (select id from card_groups where name = 'cities_watg24_alpha_plus'),
    (select id from card_groups where name = 'cities_watg24_alpha'),
    (select id from card_groups where name = 'cities_watg24_alpha_minus'),
    (select id from card_groups where name = 'cities_watg24_beta_plus'),
    (select id from card_groups where name = 'cities_watg24_beta'),
    (select id from card_groups where name = 'cities_watg24_beta_minus'),
    (select id from card_groups where name = 'cities_watg24_gamma_plus'),
    (select id from card_groups where name = 'cities_watg24_gamma'),
    (select id from card_groups where name = 'cities_watg24_gamma_minus'),
    (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  ]
);
