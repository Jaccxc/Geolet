-- ============================================
-- ALPHA+ CITIES (8 cities)
-- ============================================

-- Create Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
(
  'HK:Hong_Kong',
  'city'::region_level_enum,
  'Hong Kong',
  'HK',
  'pin'::location_type_enum,
  ARRAY[114.1694, 22.3193]
),
(
  'CN:Beijing',
  'city'::region_level_enum,
  'Beijing',
  'CN',
  'pin'::location_type_enum,
  ARRAY[116.4074, 39.9042]
),
(
  'SG:Singapore',
  'city'::region_level_enum,
  'Singapore',
  'SG',
  'pin'::location_type_enum,
  ARRAY[103.8198, 1.3521]
),
(
  'CN:Shanghai',
  'city'::region_level_enum,
  'Shanghai',
  'CN',
  'pin'::location_type_enum,
  ARRAY[121.4737, 31.2304]
),
(
  'FR:Paris',
  'city'::region_level_enum,
  'Paris',
  'FR',
  'pin'::location_type_enum,
  ARRAY[2.3522, 48.8566]
),
(
  'AE:Dubai',
  'city'::region_level_enum,
  'Dubai',
  'AE',
  'pin'::location_type_enum,
  ARRAY[55.2708, 25.2048]
),
(
  'JP:Tokyo',
  'city'::region_level_enum,
  'Tokyo',
  'JP',
  'pin'::location_type_enum,
  ARRAY[139.6917, 35.6895]
),
(
  'AU:Sydney',
  'city'::region_level_enum,
  'Sydney',
  'AU',
  'pin'::location_type_enum,
  ARRAY[151.2093, -33.8688]
);

-- Skill Tags
-- Hong Kong (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hong_kong',
  'city'::skill_family_enum,
  'HK',
  'Hong Kong',
  'Special Administrative Region of China located on the southern coast at the Pearl River Delta. Major international financial center and one of the world''s busiest container ports.',
  array[]::text[]
);

-- Beijing (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:beijing',
  'city'::skill_family_enum,
  'CN',
  'Beijing',
  'Capital of China, located in the northeastern part of the country near the Bohai Sea. Ancient city with over 3,000 years of history, serving as the political and cultural center of China.',
  array[]::text[]
);

-- Singapore (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:singapore',
  'city'::skill_family_enum,
  'SG',
  'Singapore',
  'Island city-state located at the southern tip of the Malay Peninsula in Southeast Asia. Global financial hub and one of the world''s busiest ports with a highly developed free-market economy.',
  array[]::text[]
);

-- Shanghai (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shanghai',
  'city'::skill_family_enum,
  'CN',
  'Shanghai',
  'Largest city in China by population, located on the Yangtze River Delta on the eastern coast. Major global financial center and the world''s busiest container port.',
  array[]::text[]
);

-- Paris (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:paris',
  'city'::skill_family_enum,
  'FR',
  'Paris',
  'Capital and largest city of France, located on the Seine River in northern France. Global center for art, fashion, gastronomy, and culture with world-renowned museums and architecture.',
  array[]::text[]
);

-- Dubai (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dubai',
  'city'::skill_family_enum,
  'AE',
  'Dubai',
  'Largest city in the United Arab Emirates, located on the southeast coast of the Persian Gulf. Transformed from a small fishing village to a global business and tourism hub in just decades.',
  array[]::text[]
);

-- Tokyo (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tokyo',
  'city'::skill_family_enum,
  'JP',
  'Tokyo',
  'Capital of Japan, located on the eastern coast of Honshu island in the Kanto region. World''s most populous metropolitan area and a major economic powerhouse combining traditional culture with cutting-edge technology.',
  array[]::text[]
);

-- Sydney (Alpha+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sydney',
  'city'::skill_family_enum,
  'AU',
  'Sydney',
  'Largest city in Australia, located on the southeastern coast around a stunning natural harbor. Major financial center of the Asia-Pacific region with a strong services-based economy.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Hong Kong',
  'Alpha+ tier city',
  array['city:hong_kong'],
  '2',
  (select id from regions where key = 'HK:Hong_Kong')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Beijing',
  'Alpha+ tier city',
  array['city:beijing'],
  '2',
  (select id from regions where key = 'CN:Beijing')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Singapore',
  'Alpha+ tier city',
  array['city:singapore'],
  '2',
  (select id from regions where key = 'SG:Singapore')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Shanghai',
  'Alpha+ tier city',
  array['city:shanghai'],
  '2',
  (select id from regions where key = 'CN:Shanghai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Paris',
  'Alpha+ tier city',
  array['city:paris'],
  '2',
  (select id from regions where key = 'FR:Paris')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Dubai',
  'Alpha+ tier city',
  array['city:dubai'],
  '2',
  (select id from regions where key = 'AE:Dubai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Tokyo',
  'Alpha+ tier city',
  array['city:tokyo'],
  '2',
  (select id from regions where key = 'JP:Tokyo')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Sydney',
  'Alpha+ tier city',
  array['city:sydney'],
  '2',
  (select id from regions where key = 'AU:Sydney')
);

