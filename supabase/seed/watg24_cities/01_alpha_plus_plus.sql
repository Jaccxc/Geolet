-- ============================================
-- ALPHA++ CITIES (2 cities)
-- ============================================

-- Create Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
(
  'GB:London',
  'city'::region_level_enum,
  'London',
  'GB',
  'pin'::location_type_enum,
  ARRAY[-0.1276, 51.5074]
),
(
  'US:New_York',
  'city'::region_level_enum,
  'New York',
  'US',
  'pin'::location_type_enum,
  ARRAY[-74.0060, 40.7128]
);

-- Skill Tags
-- London (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:london',
  'city'::skill_family_enum,
  'GB',
  'London',
  'Capital and largest city of the United Kingdom, located in southeastern England on the River Thames. One of the world''s leading financial centers alongside New York, hosting major stock exchanges and international banking headquarters.',
  array[]::text[]
);

-- New York (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:new_york',
  'city'::skill_family_enum,
  'US',
  'New York',
  'Largest city in the United States, located on the Atlantic coast where the Hudson River meets the harbor. Global center for finance, media, and culture with Wall Street as the world''s premier financial district.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'London',
  'Alpha++ tier global city',
  array['city:london'],
  '2',
  (select id from regions where key = 'GB:London')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'New York',
  'Alpha++ tier global city',
  array['city:new_york'],
  '2',
  (select id from regions where key = 'US:New_York')
);

