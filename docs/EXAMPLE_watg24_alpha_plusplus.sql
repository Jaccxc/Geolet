-- ============================================
-- WATG24 CITIES - ALPHA++ TIER (EXAMPLE)
-- ============================================
-- This is a COMPLETED EXAMPLE showing how to fill in city data
-- Use this as a reference when filling the template
-- ============================================

-- --------------------------------------------
-- 1. CREATE CARD GROUPS (run once for all tiers)
-- --------------------------------------------

insert into card_groups (name) values
  ('cities_watg24_alpha_plus_plus');

-- --------------------------------------------
-- 2. CREATE PIN REGIONS FOR CITIES
-- --------------------------------------------

insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
-- London
(
  'GB:London',
  'city'::region_level_enum,
  'London',
  'GB',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-0.1276, 51.5074), 4326)  -- Near Big Ben
),

-- New York
(
  'US:New_York',
  'city'::region_level_enum,
  'New York',
  'US',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-74.0060, 40.7128), 4326)  -- Manhattan
);

-- --------------------------------------------
-- 3. CREATE SKILL TAGS
-- --------------------------------------------

-- London (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:london',
  'city'::skill_family_enum,
  'GB',
  'London',
  'Capital of the United Kingdom, located in southeastern England on the River Thames. One of the world''s leading financial centers alongside New York, hosting major stock exchanges and banking institutions. Known for iconic landmarks including Big Ben, Tower Bridge, Buckingham Palace, and the British Museum.',
  array[]::text[]
);

-- New York (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:new_york',
  'city'::skill_family_enum,
  'US',
  'New York',
  'Largest city in the United States, located on the Atlantic coast where the Hudson River meets the sea. Global center for finance, media, art, fashion, technology, and entertainment. Home to Wall Street, the United Nations headquarters, and iconic landmarks like the Statue of Liberty, Times Square, and Central Park.',
  array[]::text[]
);

-- --------------------------------------------
-- 4. CREATE FACT CARDS
-- --------------------------------------------

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
-- London
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'London',
  'Alpha++ tier global city - Capital of the United Kingdom, major financial center on the Thames River',
  array['city:london'],
  '2',
  (select id from regions where key = 'GB:London')
),

-- New York
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'New York',
  'Alpha++ tier global city - Largest US city, Wall Street financial hub, home to UN headquarters',
  array['city:new_york'],
  '2',
  (select id from regions where key = 'US:New_York')
);

-- --------------------------------------------
-- VERIFICATION
-- --------------------------------------------

do $$
declare
  london_region uuid;
  ny_region uuid;
  london_skill text;
  ny_skill text;
  card_count int;
begin
  -- Check regions
  select id into london_region from regions where key = 'GB:London';
  select id into ny_region from regions where key = 'US:New_York';

  -- Check skill tags
  select key into london_skill from skill_tags where key = 'city:london';
  select key into ny_skill from skill_tags where key = 'city:new_york';

  -- Check cards
  select count(*) into card_count
  from fact_cards
  where card_group_id = (select id from card_groups where name = 'cities_watg24_alpha_plus_plus');

  raise notice '✅ Alpha++ Cities Setup Complete!';
  raise notice '';
  raise notice 'Regions Created:';
  raise notice '  - London: %', (london_region is not null);
  raise notice '  - New York: %', (ny_region is not null);
  raise notice '';
  raise notice 'Skill Tags Created:';
  raise notice '  - %', london_skill;
  raise notice '  - %', ny_skill;
  raise notice '';
  raise notice 'Fact Cards: % created', card_count;
  raise notice '';
  raise notice '📋 Next: Create Alpha+ cities (8 cities)';
end $$;
