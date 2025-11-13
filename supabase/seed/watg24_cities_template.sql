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
  ('cities_watg24_sufficiency');

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
    (select id from card_groups where name = 'cities_watg24_sufficiency')
  ]
);

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
  'Alpha+ tier global city',
  array['city:hong_kong'],
  '2',
  (select id from regions where key = 'HK:Hong_Kong')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Beijing',
  'Alpha+ tier global city',
  array['city:beijing'],
  '2',
  (select id from regions where key = 'CN:Beijing')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Singapore',
  'Alpha+ tier global city',
  array['city:singapore'],
  '2',
  (select id from regions where key = 'SG:Singapore')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Shanghai',
  'Alpha+ tier global city',
  array['city:shanghai'],
  '2',
  (select id from regions where key = 'CN:Shanghai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Paris',
  'Alpha+ tier global city',
  array['city:paris'],
  '2',
  (select id from regions where key = 'FR:Paris')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Dubai',
  'Alpha+ tier global city',
  array['city:dubai'],
  '2',
  (select id from regions where key = 'AE:Dubai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Tokyo',
  'Alpha+ tier global city',
  array['city:tokyo'],
  '2',
  (select id from regions where key = 'JP:Tokyo')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus'),
  'Sydney',
  'Alpha+ tier global city',
  array['city:sydney'],
  '2',
  (select id from regions where key = 'AU:Sydney')
);

-- ============================================
-- ALPHA CITIES (17 cities)
-- ============================================

-- Create Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
(
  'KR:Seoul',
  'city'::region_level_enum,
  'Seoul',
  'KR',
  'pin'::location_type_enum,
  ARRAY[126.9780, 37.5665]
),
(
  'IT:Milan',
  'city'::region_level_enum,
  'Milan',
  'IT',
  'pin'::location_type_enum,
  ARRAY[9.1900, 45.4642]
),
(
  'CA:Toronto',
  'city'::region_level_enum,
  'Toronto',
  'CA',
  'pin'::location_type_enum,
  ARRAY[-79.3832, 43.6532]
),
(
  'DE:Frankfurt',
  'city'::region_level_enum,
  'Frankfurt',
  'DE',
  'pin'::location_type_enum,
  ARRAY[8.6821, 50.1109]
),
(
  'US:Chicago',
  'city'::region_level_enum,
  'Chicago',
  'US',
  'pin'::location_type_enum,
  ARRAY[-87.6298, 41.8781]
),
(
  'ID:Jakarta',
  'city'::region_level_enum,
  'Jakarta',
  'ID',
  'pin'::location_type_enum,
  ARRAY[106.8456, -6.2088]
),
(
  'BR:Sao_Paulo',
  'city'::region_level_enum,
  'Sao Paulo',
  'BR',
  'pin'::location_type_enum,
  ARRAY[-46.6333, -23.5505]
),
(
  'MX:Mexico_City',
  'city'::region_level_enum,
  'Mexico City',
  'MX',
  'pin'::location_type_enum,
  ARRAY[-99.1332, 19.4326]
),
(
  'IN:Mumbai',
  'city'::region_level_enum,
  'Mumbai',
  'IN',
  'pin'::location_type_enum,
  ARRAY[72.8777, 19.0760]
),
(
  'ES:Madrid',
  'city'::region_level_enum,
  'Madrid',
  'ES',
  'pin'::location_type_enum,
  ARRAY[-3.7038, 40.4168]
),
(
  'PL:Warsaw',
  'city'::region_level_enum,
  'Warsaw',
  'PL',
  'pin'::location_type_enum,
  ARRAY[21.0122, 52.2297]
),
(
  'CN:Guangzhou',
  'city'::region_level_enum,
  'Guangzhou',
  'CN',
  'pin'::location_type_enum,
  ARRAY[113.2644, 23.1291]
),
(
  'TR:Istanbul',
  'city'::region_level_enum,
  'Istanbul',
  'TR',
  'pin'::location_type_enum,
  ARRAY[28.9784, 41.0082]
),
(
  'NL:Amsterdam',
  'city'::region_level_enum,
  'Amsterdam',
  'NL',
  'pin'::location_type_enum,
  ARRAY[4.9041, 52.3676]
),
(
  'TH:Bangkok',
  'city'::region_level_enum,
  'Bangkok',
  'TH',
  'pin'::location_type_enum,
  ARRAY[100.5018, 13.7563]
),
(
  'US:Los_Angeles',
  'city'::region_level_enum,
  'Los Angeles',
  'US',
  'pin'::location_type_enum,
  ARRAY[-118.2437, 34.0522]
),
(
  'MY:Kuala_Lumpur',
  'city'::region_level_enum,
  'Kuala Lumpur',
  'MY',
  'pin'::location_type_enum,
  ARRAY[101.6869, 3.1390]
);

-- Skill Tags
-- Seoul (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:seoul',
  'city'::skill_family_enum,
  'KR',
  'Seoul',
  'Capital and largest city of South Korea, located in the northwestern part of the country along the Han River. Major global technology and economic hub, home to companies like Samsung and Hyundai.',
  array[]::text[]
);

-- Milan (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:milan',
  'city'::skill_family_enum,
  'IT',
  'Milan',
  'Second-largest city in Italy, located in the northern Lombardy region near the Alps. Global capital of fashion and design, hosting Milan Fashion Week and the Salone del Mobile furniture fair.',
  array[]::text[]
);

-- Toronto (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:toronto',
  'city'::skill_family_enum,
  'CA',
  'Toronto',
  'Largest city in Canada and capital of Ontario province, located on the northwestern shore of Lake Ontario. Major financial and business center with the Toronto Stock Exchange.',
  array[]::text[]
);

-- Frankfurt (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:frankfurt',
  'city'::skill_family_enum,
  'DE',
  'Frankfurt',
  'Major financial center in central Germany, located on the Main River in the state of Hesse.',
  array[]::text[]
);

-- Chicago (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chicago',
  'city'::skill_family_enum,
  'US',
  'Chicago',
  'Third-largest city in the United States, located on Lake Michigan in Illinois. Major center for finance, commerce, and transportation with the Chicago Board of Trade and Mercantile Exchange.',
  array[]::text[]
);

-- Jakarta (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jakarta',
  'city'::skill_family_enum,
  'ID',
  'Jakarta',
  'Capital and largest city of Indonesia, located on the northwest coast of Java island. Most populous city in Southeast Asia and major economic hub of the region.',
  array[]::text[]
);

-- Sao Paulo (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sao_paulo',
  'city'::skill_family_enum,
  'BR',
  'Sao Paulo',
  'Largest city in Brazil and the Southern Hemisphere, located in southeastern Brazil on a plateau. Major financial center and economic powerhouse of Latin America with thriving business districts.',
  array[]::text[]
);

-- Mexico City (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:mexico_city',
  'city'::skill_family_enum,
  'MX',
  'Mexico City',
  'Capital and largest city of Mexico, located in the Valley of Mexico at high altitude (2,240m). One of the most populous metropolitan areas in the world, built on the site of the ancient Aztec capital Tenochtitlan.',
  array[]::text[]
);

-- Mumbai (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:mumbai',
  'city'::skill_family_enum,
  'IN',
  'Mumbai',
  'Largest city in India and capital of Maharashtra state, located on the west coast along the Arabian Sea. Financial capital of India, home to Bollywood film industry and major stock exchanges.',
  array[]::text[]
);

-- Madrid (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:madrid',
  'city'::skill_family_enum,
  'ES',
  'Madrid',
  'Capital and largest city of Spain, located in the center of the country on the Iberian Peninsula. Political, economic, and cultural center of Spain at high elevation (650m).',
  array[]::text[]
);

-- Warsaw (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:warsaw',
  'city'::skill_family_enum,
  'PL',
  'Warsaw',
  'Capital and largest city of Poland, located on the Vistula River in east-central Poland. Rebuilt after near-total destruction in World War II, now a major economic hub of Central Europe.',
  array[]::text[]
);

-- Guangzhou (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guangzhou',
  'city'::skill_family_enum,
  'CN',
  'Guangzhou',
  'Major city in southern China and capital of Guangdong province, located on the Pearl River. Important port and trading hub for over 2,000 years, gateway to southern China.',
  array[]::text[]
);

-- Istanbul (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:istanbul',
  'city'::skill_family_enum,
  'TR',
  'Istanbul',
  'Largest city in Turkey, uniquely located on both sides of the Bosphorus strait straddling Europe and Asia. Former capital of the Byzantine and Ottoman Empires, rich in historical significance.',
  array[]::text[]
);

-- Amsterdam (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:amsterdam',
  'city'::skill_family_enum,
  'NL',
  'Amsterdam',
  'Capital and largest city of the Netherlands, located in the western part below sea level with elaborate canal system. Major financial and business center with a historic trading legacy.',
  array[]::text[]
);

-- Bangkok (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bangkok',
  'city'::skill_family_enum,
  'TH',
  'Bangkok',
  'Capital and largest city of Thailand, located on the Chao Phraya River delta in central Thailand. Major economic and cultural center of Southeast Asia with vibrant street life.',
  array[]::text[]
);

-- Los Angeles (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:los_angeles',
  'city'::skill_family_enum,
  'US',
  'Los Angeles',
  'Second-largest city in the United States, located on the Pacific coast in Southern California. Global center for entertainment, film, and television production with Hollywood.',
  array[]::text[]
);

-- Kuala Lumpur (Alpha)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kuala_lumpur',
  'city'::skill_family_enum,
  'MY',
  'Kuala Lumpur',
  'Capital and largest city of Malaysia, located in the west-central part of Peninsular Malaysia. Major financial and economic center of Southeast Asia with modern skyline.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Seoul',
  'Alpha tier global city',
  array['city:seoul'],
  '2',
  (select id from regions where key = 'KR:Seoul')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Milan',
  'Alpha tier global city',
  array['city:milan'],
  '2',
  (select id from regions where key = 'IT:Milan')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Toronto',
  'Alpha tier global city',
  array['city:toronto'],
  '2',
  (select id from regions where key = 'CA:Toronto')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Frankfurt',
  'Alpha tier global city',
  array['city:frankfurt'],
  '2',
  (select id from regions where key = 'DE:Frankfurt')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Chicago',
  'Alpha tier global city',
  array['city:chicago'],
  '2',
  (select id from regions where key = 'US:Chicago')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Jakarta',
  'Alpha tier global city',
  array['city:jakarta'],
  '2',
  (select id from regions where key = 'ID:Jakarta')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Sao Paulo',
  'Alpha tier global city',
  array['city:sao_paulo'],
  '2',
  (select id from regions where key = 'BR:Sao_Paulo')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Mexico City',
  'Alpha tier global city',
  array['city:mexico_city'],
  '2',
  (select id from regions where key = 'MX:Mexico_City')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Mumbai',
  'Alpha tier global city',
  array['city:mumbai'],
  '2',
  (select id from regions where key = 'IN:Mumbai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Madrid',
  'Alpha tier global city',
  array['city:madrid'],
  '2',
  (select id from regions where key = 'ES:Madrid')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Warsaw',
  'Alpha tier global city',
  array['city:warsaw'],
  '2',
  (select id from regions where key = 'PL:Warsaw')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Guangzhou',
  'Alpha tier global city',
  array['city:guangzhou'],
  '2',
  (select id from regions where key = 'CN:Guangzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Istanbul',
  'Alpha tier global city',
  array['city:istanbul'],
  '2',
  (select id from regions where key = 'TR:Istanbul')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Amsterdam',
  'Alpha tier global city',
  array['city:amsterdam'],
  '2',
  (select id from regions where key = 'NL:Amsterdam')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Bangkok',
  'Alpha tier global city',
  array['city:bangkok'],
  '2',
  (select id from regions where key = 'TH:Bangkok')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Los Angeles',
  'Alpha tier global city',
  array['city:los_angeles'],
  '2',
  (select id from regions where key = 'US:Los_Angeles')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Kuala Lumpur',
  'Alpha tier global city',
  array['city:kuala_lumpur'],
  '2',
  (select id from regions where key = 'MY:Kuala_Lumpur')
);

-- ============================================
-- ALPHA- CITIES (22 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('LU:Luxembourg', 'city'::region_level_enum, 'Luxembourg', 'LU', 'pin'::location_type_enum, ARRAY[6.1296, 49.6116]),
('TW:Taipei', 'city'::region_level_enum, 'Taipei', 'TW', 'pin'::location_type_enum, ARRAY[121.5654, 25.0330]),
('CN:Shenzhen', 'city'::region_level_enum, 'Shenzhen', 'CN', 'pin'::location_type_enum, ARRAY[114.0579, 22.5431]),
('BE:Brussels', 'city'::region_level_enum, 'Brussels', 'BE', 'pin'::location_type_enum, ARRAY[4.3517, 50.8503]),
('CH:Zurich', 'city'::region_level_enum, 'Zurich', 'CH', 'pin'::location_type_enum, ARRAY[8.5417, 47.3769]),
('AR:Buenos_Aires', 'city'::region_level_enum, 'Buenos Aires', 'AR', 'pin'::location_type_enum, ARRAY[-58.3816, -34.6037]),
('AU:Melbourne', 'city'::region_level_enum, 'Melbourne', 'AU', 'pin'::location_type_enum, ARRAY[144.9631, -37.8136]),
('US:San_Francisco', 'city'::region_level_enum, 'San Francisco', 'US', 'pin'::location_type_enum, ARRAY[-122.4194, 37.7749]),
('SA:Riyadh', 'city'::region_level_enum, 'Riyadh', 'SA', 'pin'::location_type_enum, ARRAY[46.6753, 24.7136]),
('CL:Santiago', 'city'::region_level_enum, 'Santiago', 'CL', 'pin'::location_type_enum, ARRAY[-70.6693, -33.4489]),
('DE:Dusseldorf', 'city'::region_level_enum, 'Düsseldorf', 'DE', 'pin'::location_type_enum, ARRAY[6.7735, 51.2277]),
('SE:Stockholm', 'city'::region_level_enum, 'Stockholm', 'SE', 'pin'::location_type_enum, ARRAY[18.0686, 59.3293]),
('US:Washington_DC', 'city'::region_level_enum, 'Washington DC', 'US', 'pin'::location_type_enum, ARRAY[-77.0369, 38.9072]),
('AT:Vienna', 'city'::region_level_enum, 'Vienna', 'AT', 'pin'::location_type_enum, ARRAY[16.3738, 48.2082]),
('PT:Lisbon', 'city'::region_level_enum, 'Lisbon', 'PT', 'pin'::location_type_enum, ARRAY[-9.1393, 38.7223]),
('DE:Munich', 'city'::region_level_enum, 'Munich', 'DE', 'pin'::location_type_enum, ARRAY[11.5820, 48.1351]),
('IE:Dublin', 'city'::region_level_enum, 'Dublin', 'IE', 'pin'::location_type_enum, ARRAY[-6.2603, 53.3498]),
('US:Houston', 'city'::region_level_enum, 'Houston', 'US', 'pin'::location_type_enum, ARRAY[-95.3698, 29.7604]),
('DE:Berlin', 'city'::region_level_enum, 'Berlin', 'DE', 'pin'::location_type_enum, ARRAY[13.4050, 52.5200]),
('ZA:Johannesburg', 'city'::region_level_enum, 'Johannesburg', 'ZA', 'pin'::location_type_enum, ARRAY[28.0473, -26.2041]),
('US:Boston', 'city'::region_level_enum, 'Boston', 'US', 'pin'::location_type_enum, ARRAY[-71.0589, 42.3601]),
('IN:New_Delhi', 'city'::region_level_enum, 'New Delhi', 'IN', 'pin'::location_type_enum, ARRAY[77.2090, 28.6139]);

-- Skill Tags
-- Luxembourg (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:luxembourg',
  'city'::skill_family_enum,
  'LU',
  'Luxembourg',
  'Capital city of the Grand Duchy of Luxembourg, located in western Europe at the convergence of Belgium, France, and Germany. One of the world''s wealthiest cities per capita and a major European financial center, hosting numerous EU institutions and international banking operations.',
  array[]::text[]
);

-- Taipei (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:taipei',
  'city'::skill_family_enum,
  'TW',
  'Taipei',
  'Capital and largest city of Taiwan, located in northern Taiwan in the Taipei Basin surrounded by mountains. A global technology hub and major economic center in East Asia, home to numerous tech companies and the Taiwan Stock Exchange.',
  array[]::text[]
);

-- Shenzhen (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shenzhen',
  'city'::skill_family_enum,
  'CN',
  'Shenzhen',
  'Major metropolis in southern China''s Guangdong Province, located immediately north of Hong Kong bordering the South China Sea. Transformed from a small fishing village into China''s first Special Economic Zone and a global technology manufacturing powerhouse, often called the "Silicon Valley of China".',
  array[]::text[]
);

-- Brussels (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:brussels',
  'city'::skill_family_enum,
  'BE',
  'Brussels',
  'Capital of Belgium and de facto capital of the European Union, located in central Belgium at the junction of French and Flemish-speaking regions. Houses major EU institutions including the European Commission and European Parliament, making it a global political and diplomatic center.',
  array[]::text[]
);

-- Zurich (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zurich',
  'city'::skill_family_enum,
  'CH',
  'Zurich',
  'Largest city in Switzerland, located in north-central Switzerland at the northwestern tip of Lake Zurich where the Limmat River flows from the lake. Global financial center and banking capital, hosting the Swiss Stock Exchange and headquarters of major international banks and insurance companies.',
  array[]::text[]
);

-- Buenos Aires (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:buenos_aires',
  'city'::skill_family_enum,
  'AR',
  'Buenos Aires',
  'Capital and largest city of Argentina, located on the western shore of the Río de la Plata estuary on the southeastern coast of South America. Economic and cultural powerhouse of Argentina and major Latin American metropolis, known as the "Paris of South America" for its European architectural influence.',
  array[]::text[]
);

-- Melbourne (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:melbourne',
  'city'::skill_family_enum,
  'AU',
  'Melbourne',
  'Second-largest city in Australia and capital of Victoria state, located on Port Phillip Bay at the southeastern tip of the Australian mainland. Cultural and sporting capital of Australia, known for its diverse multicultural population, coffee culture, street art, and Victorian-era architecture.',
  array[]::text[]
);

-- San Francisco (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_francisco',
  'city'::skill_family_enum,
  'US',
  'San Francisco',
  'Major city in northern California, located on a peninsula between the Pacific Ocean and San Francisco Bay with iconic hilly terrain. Global center of technology and innovation, anchoring Silicon Valley and hosting numerous tech startups and venture capital firms.',
  array[]::text[]
);

-- Riyadh (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:riyadh',
  'city'::skill_family_enum,
  'SA',
  'Riyadh',
  'Capital and largest city of Saudi Arabia, located in the center of the Arabian Peninsula on a large plateau in the Najd region. Political and administrative heart of Saudi Arabia and major financial center in the Middle East, experiencing rapid modernization under Vision 2030 development plan.',
  array[]::text[]
);

-- Santiago (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:santiago',
  'city'::skill_family_enum,
  'CL',
  'Santiago',
  'Capital and largest city of Chile, located in central Chile in a valley surrounded by the Andes mountains to the east and the Chilean Coastal Range to the west. Economic and cultural center of Chile, hosting most of the country''s major corporations and financial institutions.',
  array[]::text[]
);

-- Düsseldorf (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dsseldorf',
  'city'::skill_family_enum,
  'DE',
  'Düsseldorf',
  'Major city in western Germany and capital of North Rhine-Westphalia state, located on the Rhine River near its confluence with the Ruhr industrial region. International business and financial center, particularly for fashion, trade fairs, and telecommunications, hosting numerous corporate headquarters.',
  array[]::text[]
);

-- Stockholm (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:stockholm',
  'city'::skill_family_enum,
  'SE',
  'Stockholm',
  'Capital and largest city of Sweden, built on 14 islands where Lake Mälaren meets the Baltic Sea in eastern Sweden, connected by over 50 bridges. Major European economic center and hub for Scandinavian finance, technology startups, and innovation, home to companies like Spotify and Ericsson.',
  array[]::text[]
);

-- Washington DC (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:washington_dc',
  'city'::skill_family_enum,
  'US',
  'Washington DC',
  'Capital of the United States, located on the Potomac River between Maryland and Virginia in the mid-Atlantic region. Political center of the United States, housing all three branches of the federal government including the White House, Capitol, and Supreme Court.',
  array[]::text[]
);

-- Vienna (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vienna',
  'city'::skill_family_enum,
  'AT',
  'Vienna',
  'Capital and largest city of Austria, located in northeastern Austria on the Danube River near the borders with Czech Republic, Slovakia, and Hungary. Former capital of the Austro-Hungarian Empire and major cultural center of Europe.',
  array[]::text[]
);

-- Lisbon (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lisbon',
  'city'::skill_family_enum,
  'PT',
  'Lisbon',
  'Capital and largest city of Portugal, located on seven hills at the point where the Tagus River meets the Atlantic Ocean on the western Iberian Peninsula. Historic maritime hub from the Age of Exploration and modern European cultural center, experiencing a tech startup boom in recent years.',
  array[]::text[]
);

-- Munich (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:munich',
  'city'::skill_family_enum,
  'DE',
  'Munich',
  'Third-largest city in Germany and capital of Bavaria state, located in southern Germany on the Isar River near the Bavarian Alps. Major center for technology, automotive industry, and finance, home to BMW, Siemens, and numerous other multinational corporations.',
  array[]::text[]
);

-- Dublin (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dublin',
  'city'::skill_family_enum,
  'IE',
  'Dublin',
  'Capital and largest city of Ireland, located on the east coast at the mouth of the River Liffey on Dublin Bay. Major European tech hub, hosting European headquarters for Google, Facebook, Apple, and other tech giants due to favorable business environment.',
  array[]::text[]
);

-- Houston (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:houston',
  'city'::skill_family_enum,
  'US',
  'Houston',
  'Fourth-largest city in the United States and largest in Texas, located in southeast Texas near the Gulf of Mexico coast. Global center for energy industry and oil and gas exploration, home to NASA''s Johnson Space Center and a major international port.',
  array[]::text[]
);

-- Berlin (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:berlin',
  'city'::skill_family_enum,
  'DE',
  'Berlin',
  'Capital and largest city of Germany, located in northeastern Germany on the Spree and Havel rivers. Reunified capital following the fall of the Berlin Wall in 1989, now a major center for politics, culture, media, and science in Europe.',
  array[]::text[]
);

-- Johannesburg (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:johannesburg',
  'city'::skill_family_enum,
  'ZA',
  'Johannesburg',
  'Largest city in South Africa, located on the Highveld plateau in Gauteng Province at an elevation of 1,753 meters. Economic powerhouse of South Africa and the continent, home to the Johannesburg Stock Exchange and headquarters of most major South African companies.',
  array[]::text[]
);

-- Boston (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:boston',
  'city'::skill_family_enum,
  'US',
  'Boston',
  'Capital and largest city of Massachusetts, located in northeastern United States on Massachusetts Bay. Historic center of American Revolution and intellectual capital, home to prestigious universities including Harvard and MIT in the greater metro area.',
  array[]::text[]
);

-- New Delhi (Alpha-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:new_delhi',
  'city'::skill_family_enum,
  'IN',
  'New Delhi',
  'Capital of India and part of the larger National Capital Territory of Delhi, located in northern India on the banks of the Yamuna River. Political center of the world''s largest democracy, housing the Parliament, Supreme Court, and presidential palace, built as the capital during British rule.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Luxembourg',
  'Alpha- tier global city',
  array['city:luxembourg'],
  '2',
  (select id from regions where key = 'LU:Luxembourg')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Taipei',
  'Alpha- tier global city',
  array['city:taipei'],
  '2',
  (select id from regions where key = 'TW:Taipei')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Shenzhen',
  'Alpha- tier global city',
  array['city:shenzhen'],
  '2',
  (select id from regions where key = 'CN:Shenzhen')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Brussels',
  'Alpha- tier global city',
  array['city:brussels'],
  '2',
  (select id from regions where key = 'BE:Brussels')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Zurich',
  'Alpha- tier global city',
  array['city:zurich'],
  '2',
  (select id from regions where key = 'CH:Zurich')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Buenos Aires',
  'Alpha- tier global city',
  array['city:buenos_aires'],
  '2',
  (select id from regions where key = 'AR:Buenos_Aires')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Melbourne',
  'Alpha- tier global city',
  array['city:melbourne'],
  '2',
  (select id from regions where key = 'AU:Melbourne')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'San Francisco',
  'Alpha- tier global city',
  array['city:san_francisco'],
  '2',
  (select id from regions where key = 'US:San_Francisco')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Riyadh',
  'Alpha- tier global city',
  array['city:riyadh'],
  '2',
  (select id from regions where key = 'SA:Riyadh')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Santiago',
  'Alpha- tier global city',
  array['city:santiago'],
  '2',
  (select id from regions where key = 'CL:Santiago')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Düsseldorf',
  'Alpha- tier global city',
  array['city:dsseldorf'],
  '2',
  (select id from regions where key = 'DE:Dusseldorf')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Stockholm',
  'Alpha- tier global city',
  array['city:stockholm'],
  '2',
  (select id from regions where key = 'SE:Stockholm')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Washington DC',
  'Alpha- tier global city',
  array['city:washington_dc'],
  '2',
  (select id from regions where key = 'US:Washington_DC')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Vienna',
  'Alpha- tier global city',
  array['city:vienna'],
  '2',
  (select id from regions where key = 'AT:Vienna')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Lisbon',
  'Alpha- tier global city',
  array['city:lisbon'],
  '2',
  (select id from regions where key = 'PT:Lisbon')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Munich',
  'Alpha- tier global city',
  array['city:munich'],
  '2',
  (select id from regions where key = 'DE:Munich')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Dublin',
  'Alpha- tier global city',
  array['city:dublin'],
  '2',
  (select id from regions where key = 'IE:Dublin')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Houston',
  'Alpha- tier global city',
  array['city:houston'],
  '2',
  (select id from regions where key = 'US:Houston')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Berlin',
  'Alpha- tier global city',
  array['city:berlin'],
  '2',
  (select id from regions where key = 'DE:Berlin')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Johannesburg',
  'Alpha- tier global city',
  array['city:johannesburg'],
  '2',
  (select id from regions where key = 'ZA:Johannesburg')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Boston',
  'Alpha- tier global city',
  array['city:boston'],
  '2',
  (select id from regions where key = 'US:Boston')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'New Delhi',
  'Alpha- tier global city',
  array['city:new_delhi'],
  '2',
  (select id from regions where key = 'IN:New_Delhi')
);

-- ============================================
-- BETA+ CITIES (20 cities)
-- ============================================

-- Skill Tags
-- Bogota (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bogota',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bogota',
  'TODO: Add geographic/cultural info about Bogota. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ho Chi Minh City (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ho_chi_minh_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ho Chi Minh City',
  'TODO: Add geographic/cultural info about Ho Chi Minh City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Rome (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rome',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Rome',
  'TODO: Add geographic/cultural info about Rome. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bangalore (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bangalore',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bangalore',
  'TODO: Add geographic/cultural info about Bangalore. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Budapest (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:budapest',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Budapest',
  'TODO: Add geographic/cultural info about Budapest. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Athens (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:athens',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Athens',
  'TODO: Add geographic/cultural info about Athens. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hamburg (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hamburg',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hamburg',
  'TODO: Add geographic/cultural info about Hamburg. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Doha (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:doha',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Doha',
  'TODO: Add geographic/cultural info about Doha. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Chengdu (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chengdu',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Chengdu',
  'TODO: Add geographic/cultural info about Chengdu. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Miami (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:miami',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Miami',
  'TODO: Add geographic/cultural info about Miami. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tianjin (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tianjin',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tianjin',
  'TODO: Add geographic/cultural info about Tianjin. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dallas (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dallas',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dallas',
  'TODO: Add geographic/cultural info about Dallas. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Atlanta (GA) (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:atlanta_ga',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Atlanta (GA)',
  'TODO: Add geographic/cultural info about Atlanta (GA). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Auckland (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:auckland',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Auckland',
  'TODO: Add geographic/cultural info about Auckland. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Barcelona (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:barcelona',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Barcelona',
  'TODO: Add geographic/cultural info about Barcelona. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hangzhou (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hangzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hangzhou',
  'TODO: Add geographic/cultural info about Hangzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bucharest (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bucharest',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bucharest',
  'TODO: Add geographic/cultural info about Bucharest. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lima (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lima',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lima',
  'TODO: Add geographic/cultural info about Lima. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Montreal (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:montreal',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Montreal',
  'TODO: Add geographic/cultural info about Montreal. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Prague (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:prague',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Prague',
  'TODO: Add geographic/cultural info about Prague. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bogota',
  'Beta+ tier global city',
  array['city:bogota'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Ho Chi Minh City',
  'Beta+ tier global city',
  array['city:ho_chi_minh_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Rome',
  'Beta+ tier global city',
  array['city:rome'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bangalore',
  'Beta+ tier global city',
  array['city:bangalore'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Budapest',
  'Beta+ tier global city',
  array['city:budapest'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Athens',
  'Beta+ tier global city',
  array['city:athens'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hamburg',
  'Beta+ tier global city',
  array['city:hamburg'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Doha',
  'Beta+ tier global city',
  array['city:doha'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Chengdu',
  'Beta+ tier global city',
  array['city:chengdu'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Miami',
  'Beta+ tier global city',
  array['city:miami'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Tianjin',
  'Beta+ tier global city',
  array['city:tianjin'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Dallas',
  'Beta+ tier global city',
  array['city:dallas'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Atlanta (GA)',
  'Beta+ tier global city',
  array['city:atlanta_ga'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Auckland',
  'Beta+ tier global city',
  array['city:auckland'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Barcelona',
  'Beta+ tier global city',
  array['city:barcelona'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hangzhou',
  'Beta+ tier global city',
  array['city:hangzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bucharest',
  'Beta+ tier global city',
  array['city:bucharest'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Lima',
  'Beta+ tier global city',
  array['city:lima'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Montreal',
  'Beta+ tier global city',
  array['city:montreal'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Prague',
  'Beta+ tier global city',
  array['city:prague'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- BETA CITIES (23 cities)
-- ============================================

-- Skill Tags
-- Chongqing (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chongqing',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Chongqing',
  'TODO: Add geographic/cultural info about Chongqing. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tel Aviv (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tel_aviv',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tel Aviv',
  'TODO: Add geographic/cultural info about Tel Aviv. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Brisbane (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:brisbane',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Brisbane',
  'TODO: Add geographic/cultural info about Brisbane. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cairo (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cairo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cairo',
  'TODO: Add geographic/cultural info about Cairo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hanoi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hanoi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hanoi',
  'TODO: Add geographic/cultural info about Hanoi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nanjing (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nanjing',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nanjing',
  'TODO: Add geographic/cultural info about Nanjing. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Oslo (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:oslo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Oslo',
  'TODO: Add geographic/cultural info about Oslo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Perth (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:perth',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Perth',
  'TODO: Add geographic/cultural info about Perth. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Abu Dhabi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:abu_dhabi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Abu Dhabi',
  'TODO: Add geographic/cultural info about Abu Dhabi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Copenhagen (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:copenhagen',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Copenhagen',
  'TODO: Add geographic/cultural info about Copenhagen. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Manama (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manama',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Manama',
  'TODO: Add geographic/cultural info about Manama. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Wuhan (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wuhan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Wuhan',
  'TODO: Add geographic/cultural info about Wuhan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Manila (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manila',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Manila',
  'TODO: Add geographic/cultural info about Manila. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Xiamen (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:xiamen',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Xiamen',
  'TODO: Add geographic/cultural info about Xiamen. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nairobi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nairobi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nairobi',
  'TODO: Add geographic/cultural info about Nairobi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kiev (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kiev',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kiev',
  'TODO: Add geographic/cultural info about Kiev. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Geneva (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:geneva',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Geneva',
  'TODO: Add geographic/cultural info about Geneva. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Jinan (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jinan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Jinan',
  'TODO: Add geographic/cultural info about Jinan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Calgary (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:calgary',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Calgary',
  'TODO: Add geographic/cultural info about Calgary. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Zhengzhou (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zhengzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Zhengzhou',
  'TODO: Add geographic/cultural info about Zhengzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Shenyang (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shenyang',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Shenyang',
  'TODO: Add geographic/cultural info about Shenyang. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dalian (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dalian',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dalian',
  'TODO: Add geographic/cultural info about Dalian. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Suzhou (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:suzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Suzhou',
  'TODO: Add geographic/cultural info about Suzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Chongqing',
  'Beta tier global city',
  array['city:chongqing'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Tel Aviv',
  'Beta tier global city',
  array['city:tel_aviv'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Brisbane',
  'Beta tier global city',
  array['city:brisbane'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Cairo',
  'Beta tier global city',
  array['city:cairo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Hanoi',
  'Beta tier global city',
  array['city:hanoi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Nanjing',
  'Beta tier global city',
  array['city:nanjing'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Oslo',
  'Beta tier global city',
  array['city:oslo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Perth',
  'Beta tier global city',
  array['city:perth'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Abu Dhabi',
  'Beta tier global city',
  array['city:abu_dhabi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Copenhagen',
  'Beta tier global city',
  array['city:copenhagen'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Manama',
  'Beta tier global city',
  array['city:manama'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Wuhan',
  'Beta tier global city',
  array['city:wuhan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Manila',
  'Beta tier global city',
  array['city:manila'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Xiamen',
  'Beta tier global city',
  array['city:xiamen'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Nairobi',
  'Beta tier global city',
  array['city:nairobi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Kiev',
  'Beta tier global city',
  array['city:kiev'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Geneva',
  'Beta tier global city',
  array['city:geneva'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Jinan',
  'Beta tier global city',
  array['city:jinan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Calgary',
  'Beta tier global city',
  array['city:calgary'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Zhengzhou',
  'Beta tier global city',
  array['city:zhengzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Shenyang',
  'Beta tier global city',
  array['city:shenyang'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Dalian',
  'Beta tier global city',
  array['city:dalian'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Suzhou',
  'Beta tier global city',
  array['city:suzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- BETA- CITIES (28 cities)
-- ============================================

-- Skill Tags
-- Qingdao (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:qingdao',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Qingdao',
  'TODO: Add geographic/cultural info about Qingdao. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Casablanca (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:casablanca',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Casablanca',
  'TODO: Add geographic/cultural info about Casablanca. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Changsha (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:changsha',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Changsha',
  'TODO: Add geographic/cultural info about Changsha. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Beirut (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:beirut',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Beirut',
  'TODO: Add geographic/cultural info about Beirut. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Port Louis (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:port_louis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Port Louis',
  'TODO: Add geographic/cultural info about Port Louis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Denver (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:denver',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Denver',
  'TODO: Add geographic/cultural info about Denver. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lagos (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lagos',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lagos',
  'TODO: Add geographic/cultural info about Lagos. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Belgrade (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:belgrade',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Belgrade',
  'TODO: Add geographic/cultural info about Belgrade. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Montevideo (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:montevideo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Montevideo',
  'TODO: Add geographic/cultural info about Montevideo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Vancouver (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vancouver',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Vancouver',
  'TODO: Add geographic/cultural info about Vancouver. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Seattle (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:seattle',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Seattle',
  'TODO: Add geographic/cultural info about Seattle. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Manchester (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manchester',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Manchester',
  'TODO: Add geographic/cultural info about Manchester. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Sofia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sofia',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Sofia',
  'TODO: Add geographic/cultural info about Sofia. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bratislava (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bratislava',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bratislava',
  'TODO: Add geographic/cultural info about Bratislava. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Rio de Janeiro (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rio_de_janeiro',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Rio de Janeiro',
  'TODO: Add geographic/cultural info about Rio de Janeiro. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lyon (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lyon',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lyon',
  'TODO: Add geographic/cultural info about Lyon. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Xi’an (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:xian',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Xi’an',
  'TODO: Add geographic/cultural info about Xi’an. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Helsinki (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:helsinki',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Helsinki',
  'TODO: Add geographic/cultural info about Helsinki. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kunming (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kunming',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kunming',
  'TODO: Add geographic/cultural info about Kunming. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Zagreb (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zagreb',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Zagreb',
  'TODO: Add geographic/cultural info about Zagreb. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nicosia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nicosia',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nicosia',
  'TODO: Add geographic/cultural info about Nicosia. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Karachi (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:karachi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Karachi',
  'TODO: Add geographic/cultural info about Karachi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Caracas (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:caracas',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Caracas',
  'TODO: Add geographic/cultural info about Caracas. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hefei (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hefei',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hefei',
  'TODO: Add geographic/cultural info about Hefei. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Stuttgart (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:stuttgart',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Stuttgart',
  'TODO: Add geographic/cultural info about Stuttgart. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Panama City (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:panama_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Panama City',
  'TODO: Add geographic/cultural info about Panama City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Chennai (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chennai',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Chennai',
  'TODO: Add geographic/cultural info about Chennai. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Philadelphia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:philadelphia',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Philadelphia',
  'TODO: Add geographic/cultural info about Philadelphia. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Qingdao',
  'Beta- tier global city',
  array['city:qingdao'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Casablanca',
  'Beta- tier global city',
  array['city:casablanca'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Changsha',
  'Beta- tier global city',
  array['city:changsha'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Beirut',
  'Beta- tier global city',
  array['city:beirut'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Port Louis',
  'Beta- tier global city',
  array['city:port_louis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Denver',
  'Beta- tier global city',
  array['city:denver'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lagos',
  'Beta- tier global city',
  array['city:lagos'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Belgrade',
  'Beta- tier global city',
  array['city:belgrade'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Montevideo',
  'Beta- tier global city',
  array['city:montevideo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Vancouver',
  'Beta- tier global city',
  array['city:vancouver'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Seattle',
  'Beta- tier global city',
  array['city:seattle'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Manchester',
  'Beta- tier global city',
  array['city:manchester'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Sofia',
  'Beta- tier global city',
  array['city:sofia'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Bratislava',
  'Beta- tier global city',
  array['city:bratislava'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Rio de Janeiro',
  'Beta- tier global city',
  array['city:rio_de_janeiro'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lyon',
  'Beta- tier global city',
  array['city:lyon'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Xi’an',
  'Beta- tier global city',
  array['city:xian'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Helsinki',
  'Beta- tier global city',
  array['city:helsinki'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Kunming',
  'Beta- tier global city',
  array['city:kunming'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Zagreb',
  'Beta- tier global city',
  array['city:zagreb'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Nicosia',
  'Beta- tier global city',
  array['city:nicosia'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Karachi',
  'Beta- tier global city',
  array['city:karachi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Caracas',
  'Beta- tier global city',
  array['city:caracas'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Hefei',
  'Beta- tier global city',
  array['city:hefei'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Stuttgart',
  'Beta- tier global city',
  array['city:stuttgart'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Panama City',
  'Beta- tier global city',
  array['city:panama_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Chennai',
  'Beta- tier global city',
  array['city:chennai'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Philadelphia',
  'Beta- tier global city',
  array['city:philadelphia'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- GAMMA+ CITIES (20 cities)
-- ============================================

-- Skill Tags
-- Tunis (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tunis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tunis',
  'TODO: Add geographic/cultural info about Tunis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fuzhou (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:fuzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Fuzhou',
  'TODO: Add geographic/cultural info about Fuzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Guatemala City (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guatemala_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Guatemala City',
  'TODO: Add geographic/cultural info about Guatemala City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hyderabad (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hyderabad',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hyderabad',
  'TODO: Add geographic/cultural info about Hyderabad. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cape Town (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cape_town',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cape Town',
  'TODO: Add geographic/cultural info about Cape Town. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dhaka (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dhaka',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dhaka',
  'TODO: Add geographic/cultural info about Dhaka. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Porto (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:porto',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Porto',
  'TODO: Add geographic/cultural info about Porto. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Austin (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:austin',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Austin',
  'TODO: Add geographic/cultural info about Austin. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Diego (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_diego',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Diego',
  'TODO: Add geographic/cultural info about San Diego. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Minneapolis (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:minneapolis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Minneapolis',
  'TODO: Add geographic/cultural info about Minneapolis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Antwerp (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:antwerp',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Antwerp',
  'TODO: Add geographic/cultural info about Antwerp. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Almaty (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:almaty',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Almaty',
  'TODO: Add geographic/cultural info about Almaty. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Amman (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:amman',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Amman',
  'TODO: Add geographic/cultural info about Amman. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Santo Domingo (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:santo_domingo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Santo Domingo',
  'TODO: Add geographic/cultural info about Santo Domingo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Rotterdam (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rotterdam',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Rotterdam',
  'TODO: Add geographic/cultural info about Rotterdam. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Adelaide (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:adelaide',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Adelaide',
  'TODO: Add geographic/cultural info about Adelaide. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lahore (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lahore',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lahore',
  'TODO: Add geographic/cultural info about Lahore. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Colombo (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:colombo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Colombo',
  'TODO: Add geographic/cultural info about Colombo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Taiyuan (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:taiyuan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Taiyuan',
  'TODO: Add geographic/cultural info about Taiyuan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kuwait City (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kuwait_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kuwait City',
  'TODO: Add geographic/cultural info about Kuwait City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Tunis',
  'Gamma+ tier global city',
  array['city:tunis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Fuzhou',
  'Gamma+ tier global city',
  array['city:fuzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Guatemala City',
  'Gamma+ tier global city',
  array['city:guatemala_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Hyderabad',
  'Gamma+ tier global city',
  array['city:hyderabad'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Cape Town',
  'Gamma+ tier global city',
  array['city:cape_town'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Dhaka',
  'Gamma+ tier global city',
  array['city:dhaka'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Porto',
  'Gamma+ tier global city',
  array['city:porto'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Austin',
  'Gamma+ tier global city',
  array['city:austin'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'San Diego',
  'Gamma+ tier global city',
  array['city:san_diego'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Minneapolis',
  'Gamma+ tier global city',
  array['city:minneapolis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Antwerp',
  'Gamma+ tier global city',
  array['city:antwerp'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Almaty',
  'Gamma+ tier global city',
  array['city:almaty'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Amman',
  'Gamma+ tier global city',
  array['city:amman'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Santo Domingo',
  'Gamma+ tier global city',
  array['city:santo_domingo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Rotterdam',
  'Gamma+ tier global city',
  array['city:rotterdam'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Adelaide',
  'Gamma+ tier global city',
  array['city:adelaide'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Lahore',
  'Gamma+ tier global city',
  array['city:lahore'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Colombo',
  'Gamma+ tier global city',
  array['city:colombo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Taiyuan',
  'Gamma+ tier global city',
  array['city:taiyuan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Kuwait City',
  'Gamma+ tier global city',
  array['city:kuwait_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- GAMMA CITIES (25 cities)
-- ============================================

-- Skill Tags
-- Monterrey (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:monterrey',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Monterrey',
  'TODO: Add geographic/cultural info about Monterrey. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Osaka (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:osaka',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Osaka',
  'TODO: Add geographic/cultural info about Osaka. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Haikou (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:haikou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Haikou',
  'TODO: Add geographic/cultural info about Haikou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tbilisi (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tbilisi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tbilisi',
  'TODO: Add geographic/cultural info about Tbilisi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tampa (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tampa',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tampa',
  'TODO: Add geographic/cultural info about Tampa. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tirana (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tirana',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tirana',
  'TODO: Add geographic/cultural info about Tirana. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Quito (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:quito',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Quito',
  'TODO: Add geographic/cultural info about Quito. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nashville (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nashville',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nashville',
  'TODO: Add geographic/cultural info about Nashville. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Islamabad (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:islamabad',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Islamabad',
  'TODO: Add geographic/cultural info about Islamabad. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kampala (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kampala',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kampala',
  'TODO: Add geographic/cultural info about Kampala. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Salvador (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_salvador',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Salvador',
  'TODO: Add geographic/cultural info about San Salvador. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Muscat (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:muscat',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Muscat',
  'TODO: Add geographic/cultural info about Muscat. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Phnom Penh (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:phnom_penh',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Phnom Penh',
  'TODO: Add geographic/cultural info about Phnom Penh. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Birmingham (UK) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:birmingham_uk',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Birmingham (UK)',
  'TODO: Add geographic/cultural info about Birmingham (UK). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Pune (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:pune',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Pune',
  'TODO: Add geographic/cultural info about Pune. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ningbo (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ningbo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ningbo',
  'TODO: Add geographic/cultural info about Ningbo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Harbin (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:harbin',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Harbin',
  'TODO: Add geographic/cultural info about Harbin. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Jose (CA) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_jose_ca',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Jose (CA)',
  'TODO: Add geographic/cultural info about San Jose (CA). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bologna (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bologna',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bologna',
  'TODO: Add geographic/cultural info about Bologna. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San José (Costa Rica) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_jos_costa_rica',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San José (Costa Rica)',
  'TODO: Add geographic/cultural info about San José (Costa Rica). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ahmedabad (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ahmedabad',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ahmedabad',
  'TODO: Add geographic/cultural info about Ahmedabad. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bristol (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bristol',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bristol',
  'TODO: Add geographic/cultural info about Bristol. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tegucigalpa (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tegucigalpa',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tegucigalpa',
  'TODO: Add geographic/cultural info about Tegucigalpa. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Riga (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:riga',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Riga',
  'TODO: Add geographic/cultural info about Riga. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Detroit (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:detroit',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Detroit',
  'TODO: Add geographic/cultural info about Detroit. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Monterrey',
  'Gamma tier global city',
  array['city:monterrey'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Osaka',
  'Gamma tier global city',
  array['city:osaka'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Haikou',
  'Gamma tier global city',
  array['city:haikou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tbilisi',
  'Gamma tier global city',
  array['city:tbilisi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tampa',
  'Gamma tier global city',
  array['city:tampa'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tirana',
  'Gamma tier global city',
  array['city:tirana'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Quito',
  'Gamma tier global city',
  array['city:quito'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Nashville',
  'Gamma tier global city',
  array['city:nashville'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Islamabad',
  'Gamma tier global city',
  array['city:islamabad'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Kampala',
  'Gamma tier global city',
  array['city:kampala'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San Salvador',
  'Gamma tier global city',
  array['city:san_salvador'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Muscat',
  'Gamma tier global city',
  array['city:muscat'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Phnom Penh',
  'Gamma tier global city',
  array['city:phnom_penh'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Birmingham (UK)',
  'Gamma tier global city',
  array['city:birmingham_uk'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Pune',
  'Gamma tier global city',
  array['city:pune'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Ningbo',
  'Gamma tier global city',
  array['city:ningbo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Harbin',
  'Gamma tier global city',
  array['city:harbin'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San Jose (CA)',
  'Gamma tier global city',
  array['city:san_jose_ca'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Bologna',
  'Gamma tier global city',
  array['city:bologna'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San José (Costa Rica)',
  'Gamma tier global city',
  array['city:san_jos_costa_rica'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Ahmedabad',
  'Gamma tier global city',
  array['city:ahmedabad'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Bristol',
  'Gamma tier global city',
  array['city:bristol'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tegucigalpa',
  'Gamma tier global city',
  array['city:tegucigalpa'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Riga',
  'Gamma tier global city',
  array['city:riga'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Detroit',
  'Gamma tier global city',
  array['city:detroit'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- GAMMA- CITIES (25 cities)
-- ============================================

-- Skill Tags
-- Poznan (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:poznan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Poznan',
  'TODO: Add geographic/cultural info about Poznan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Labuan (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:labuan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Labuan',
  'TODO: Add geographic/cultural info about Labuan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Charlotte (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:charlotte',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Charlotte',
  'TODO: Add geographic/cultural info about Charlotte. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Pittsburgh (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:pittsburgh',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Pittsburgh',
  'TODO: Add geographic/cultural info about Pittsburgh. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Valencia (Spain) (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:valencia_spain',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Valencia (Spain)',
  'TODO: Add geographic/cultural info about Valencia (Spain). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Edinburgh (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:edinburgh',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Edinburgh',
  'TODO: Add geographic/cultural info about Edinburgh. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Jeddah (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jeddah',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Jeddah',
  'TODO: Add geographic/cultural info about Jeddah. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Turin (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:turin',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Turin',
  'TODO: Add geographic/cultural info about Turin. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Katowice (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:katowice',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Katowice',
  'TODO: Add geographic/cultural info about Katowice. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Baku (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:baku',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Baku',
  'TODO: Add geographic/cultural info about Baku. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Penang (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:penang',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Penang',
  'TODO: Add geographic/cultural info about Penang. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dar es Salaam (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dar_es_salaam',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dar es Salaam',
  'TODO: Add geographic/cultural info about Dar es Salaam. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Wellington (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wellington',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Wellington',
  'TODO: Add geographic/cultural info about Wellington. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Managua (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:managua',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Managua',
  'TODO: Add geographic/cultural info about Managua. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cleveland (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cleveland',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cleveland',
  'TODO: Add geographic/cultural info about Cleveland. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nanchang (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nanchang',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nanchang',
  'TODO: Add geographic/cultural info about Nanchang. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Changchun (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:changchun',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Changchun',
  'TODO: Add geographic/cultural info about Changchun. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cali (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cali',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cali',
  'TODO: Add geographic/cultural info about Cali. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- St Louis (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:st_louis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'St Louis',
  'TODO: Add geographic/cultural info about St Louis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ljubljana (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ljubljana',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ljubljana',
  'TODO: Add geographic/cultural info about Ljubljana. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Baltimore (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:baltimore',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Baltimore',
  'TODO: Add geographic/cultural info about Baltimore. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bilbao (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bilbao',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bilbao',
  'TODO: Add geographic/cultural info about Bilbao. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Marseille (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:marseille',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Marseille',
  'TODO: Add geographic/cultural info about Marseille. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Surabaya (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:surabaya',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Surabaya',
  'TODO: Add geographic/cultural info about Surabaya. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Accra (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:accra',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Accra',
  'TODO: Add geographic/cultural info about Accra. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Poznan',
  'Gamma- tier global city',
  array['city:poznan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Labuan',
  'Gamma- tier global city',
  array['city:labuan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Charlotte',
  'Gamma- tier global city',
  array['city:charlotte'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Pittsburgh',
  'Gamma- tier global city',
  array['city:pittsburgh'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Valencia (Spain)',
  'Gamma- tier global city',
  array['city:valencia_spain'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Edinburgh',
  'Gamma- tier global city',
  array['city:edinburgh'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Jeddah',
  'Gamma- tier global city',
  array['city:jeddah'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Turin',
  'Gamma- tier global city',
  array['city:turin'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Katowice',
  'Gamma- tier global city',
  array['city:katowice'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baku',
  'Gamma- tier global city',
  array['city:baku'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Penang',
  'Gamma- tier global city',
  array['city:penang'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Dar es Salaam',
  'Gamma- tier global city',
  array['city:dar_es_salaam'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Wellington',
  'Gamma- tier global city',
  array['city:wellington'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Managua',
  'Gamma- tier global city',
  array['city:managua'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cleveland',
  'Gamma- tier global city',
  array['city:cleveland'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Nanchang',
  'Gamma- tier global city',
  array['city:nanchang'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Changchun',
  'Gamma- tier global city',
  array['city:changchun'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cali',
  'Gamma- tier global city',
  array['city:cali'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'St Louis',
  'Gamma- tier global city',
  array['city:st_louis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Ljubljana',
  'Gamma- tier global city',
  array['city:ljubljana'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baltimore',
  'Gamma- tier global city',
  array['city:baltimore'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Bilbao',
  'Gamma- tier global city',
  array['city:bilbao'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Marseille',
  'Gamma- tier global city',
  array['city:marseille'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Surabaya',
  'Gamma- tier global city',
  array['city:surabaya'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Accra',
  'Gamma- tier global city',
  array['city:accra'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- HIGH SUFFICIENCY CITIES (26 cities)
-- ============================================

-- Skill Tags
-- Izmir (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:izmir',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Izmir',
  'TODO: Add geographic/cultural info about Izmir. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Harare (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:harare',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Harare',
  'TODO: Add geographic/cultural info about Harare. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Maputo (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:maputo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Maputo',
  'TODO: Add geographic/cultural info about Maputo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Vilnius (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vilnius',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Vilnius',
  'TODO: Add geographic/cultural info about Vilnius. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Macao (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:macao',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Macao',
  'TODO: Add geographic/cultural info about Macao. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Gothenburg (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:gothenburg',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Gothenburg',
  'TODO: Add geographic/cultural info about Gothenburg. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Raleigh (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:raleigh',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Raleigh',
  'TODO: Add geographic/cultural info about Raleigh. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Queretaro (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:queretaro',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Queretaro',
  'TODO: Add geographic/cultural info about Queretaro. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Glasgow (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:glasgow',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Glasgow',
  'TODO: Add geographic/cultural info about Glasgow. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Zhuhai (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zhuhai',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Zhuhai',
  'TODO: Add geographic/cultural info about Zhuhai. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Phoenix (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:phoenix',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Phoenix',
  'TODO: Add geographic/cultural info about Phoenix. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dakar (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dakar',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dakar',
  'TODO: Add geographic/cultural info about Dakar. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cincinnati (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cincinnati',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cincinnati',
  'TODO: Add geographic/cultural info about Cincinnati. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Skopje (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:skopje',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Skopje',
  'TODO: Add geographic/cultural info about Skopje. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kansas City (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kansas_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kansas City',
  'TODO: Add geographic/cultural info about Kansas City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Limassol (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:limassol',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Limassol',
  'TODO: Add geographic/cultural info about Limassol. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- La Paz (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:la_paz',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'La Paz',
  'TODO: Add geographic/cultural info about La Paz. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Leeds (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:leeds',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Leeds',
  'TODO: Add geographic/cultural info about Leeds. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Guayaquil (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guayaquil',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Guayaquil',
  'TODO: Add geographic/cultural info about Guayaquil. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hartford (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hartford',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hartford',
  'TODO: Add geographic/cultural info about Hartford. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Belfast (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:belfast',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Belfast',
  'TODO: Add geographic/cultural info about Belfast. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Indianapolis (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:indianapolis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Indianapolis',
  'TODO: Add geographic/cultural info about Indianapolis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Algiers (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:algiers',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Algiers',
  'TODO: Add geographic/cultural info about Algiers. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Shijiazhuang (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shijiazhuang',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Shijiazhuang',
  'TODO: Add geographic/cultural info about Shijiazhuang. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lusaka (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lusaka',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lusaka',
  'TODO: Add geographic/cultural info about Lusaka. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Guadalajara (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guadalajara',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Guadalajara',
  'TODO: Add geographic/cultural info about Guadalajara. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Izmir',
  'High sufficiency tier global city',
  array['city:izmir'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Harare',
  'High sufficiency tier global city',
  array['city:harare'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Maputo',
  'High sufficiency tier global city',
  array['city:maputo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Vilnius',
  'High sufficiency tier global city',
  array['city:vilnius'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Macao',
  'High sufficiency tier global city',
  array['city:macao'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Gothenburg',
  'High sufficiency tier global city',
  array['city:gothenburg'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Raleigh',
  'High sufficiency tier global city',
  array['city:raleigh'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Queretaro',
  'High sufficiency tier global city',
  array['city:queretaro'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Glasgow',
  'High sufficiency tier global city',
  array['city:glasgow'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Zhuhai',
  'High sufficiency tier global city',
  array['city:zhuhai'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Phoenix',
  'High sufficiency tier global city',
  array['city:phoenix'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Dakar',
  'High sufficiency tier global city',
  array['city:dakar'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Cincinnati',
  'High sufficiency tier global city',
  array['city:cincinnati'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Skopje',
  'High sufficiency tier global city',
  array['city:skopje'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Kansas City',
  'High sufficiency tier global city',
  array['city:kansas_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Limassol',
  'High sufficiency tier global city',
  array['city:limassol'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'La Paz',
  'High sufficiency tier global city',
  array['city:la_paz'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Leeds',
  'High sufficiency tier global city',
  array['city:leeds'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guayaquil',
  'High sufficiency tier global city',
  array['city:guayaquil'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Hartford',
  'High sufficiency tier global city',
  array['city:hartford'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Belfast',
  'High sufficiency tier global city',
  array['city:belfast'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Indianapolis',
  'High sufficiency tier global city',
  array['city:indianapolis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Algiers',
  'High sufficiency tier global city',
  array['city:algiers'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Shijiazhuang',
  'High sufficiency tier global city',
  array['city:shijiazhuang'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Lusaka',
  'High sufficiency tier global city',
  array['city:lusaka'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guadalajara',
  'High sufficiency tier global city',
  array['city:guadalajara'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- SUFFICIENCY CITIES (119 cities)
-- ============================================

-- Skill Tags
-- Strasbourg (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:strasbourg',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Strasbourg',
  'TODO: Add geographic/cultural info about Strasbourg. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Columbus (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:columbus',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Columbus',
  'TODO: Add geographic/cultural info about Columbus. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ankara (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ankara',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ankara',
  'TODO: Add geographic/cultural info about Ankara. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Johor Bahru (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:johor_bahru',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Johor Bahru',
  'TODO: Add geographic/cultural info about Johor Bahru. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ottawa (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ottawa',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ottawa',
  'TODO: Add geographic/cultural info about Ottawa. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Wroclaw (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wroclaw',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Wroclaw',
  'TODO: Add geographic/cultural info about Wroclaw. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Urumqi (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:urumqi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Urumqi',
  'TODO: Add geographic/cultural info about Urumqi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Christchurch (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:christchurch',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Christchurch',
  'TODO: Add geographic/cultural info about Christchurch. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Douala (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:douala',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Douala',
  'TODO: Add geographic/cultural info about Douala. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tashkent (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tashkent',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tashkent',
  'TODO: Add geographic/cultural info about Tashkent. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lausanne (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lausanne',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lausanne',
  'TODO: Add geographic/cultural info about Lausanne. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Málaga (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:mlaga',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Málaga',
  'TODO: Add geographic/cultural info about Málaga. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Wuxi (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wuxi',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Wuxi',
  'TODO: Add geographic/cultural info about Wuxi. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- George Town (Cayman Islands) (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:george_town_cayman_islands',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'George Town (Cayman Islands)',
  'TODO: Add geographic/cultural info about George Town (Cayman Islands). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Salt Lake City (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:salt_lake_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Salt Lake City',
  'TODO: Add geographic/cultural info about Salt Lake City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tallinn (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tallinn',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tallinn',
  'TODO: Add geographic/cultural info about Tallinn. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nantes (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nantes',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nantes',
  'TODO: Add geographic/cultural info about Nantes. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Medellin (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:medellin',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Medellin',
  'TODO: Add geographic/cultural info about Medellin. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Edmonton (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:edmonton',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Edmonton',
  'TODO: Add geographic/cultural info about Edmonton. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Utrecht (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:utrecht',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Utrecht',
  'TODO: Add geographic/cultural info about Utrecht. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Taichung (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:taichung',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Taichung',
  'TODO: Add geographic/cultural info about Taichung. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Campinas (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:campinas',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Campinas',
  'TODO: Add geographic/cultural info about Campinas. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lille (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lille',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lille',
  'TODO: Add geographic/cultural info about Lille. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Abuja (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:abuja',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Abuja',
  'TODO: Add geographic/cultural info about Abuja. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Yangon (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:yangon',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Yangon',
  'TODO: Add geographic/cultural info about Yangon. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Krakow (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:krakow',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Krakow',
  'TODO: Add geographic/cultural info about Krakow. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Jacksonville (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jacksonville',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Jacksonville',
  'TODO: Add geographic/cultural info about Jacksonville. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Southampton (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:southampton',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Southampton',
  'TODO: Add geographic/cultural info about Southampton. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Antonio (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_antonio',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Antonio',
  'TODO: Add geographic/cultural info about San Antonio. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Belo Horizonte (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:belo_horizonte',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Belo Horizonte',
  'TODO: Add geographic/cultural info about Belo Horizonte. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Leipzig (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:leipzig',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Leipzig',
  'TODO: Add geographic/cultural info about Leipzig. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Newcastle (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:newcastle',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Newcastle',
  'TODO: Add geographic/cultural info about Newcastle. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Naples (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:naples',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Naples',
  'TODO: Add geographic/cultural info about Naples. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Curitiba (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:curitiba',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Curitiba',
  'TODO: Add geographic/cultural info about Curitiba. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Luanda (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:luanda',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Luanda',
  'TODO: Add geographic/cultural info about Luanda. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Abidjan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:abidjan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Abidjan',
  'TODO: Add geographic/cultural info about Abidjan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Milwaukee (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:milwaukee',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Milwaukee',
  'TODO: Add geographic/cultural info about Milwaukee. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nassau (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nassau',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nassau',
  'TODO: Add geographic/cultural info about Nassau. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Gaborone (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:gaborone',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Gaborone',
  'TODO: Add geographic/cultural info about Gaborone. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Puebla (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:puebla',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Puebla',
  'TODO: Add geographic/cultural info about Puebla. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Toulouse (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:toulouse',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Toulouse',
  'TODO: Add geographic/cultural info about Toulouse. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Brasilia (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:brasilia',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Brasilia',
  'TODO: Add geographic/cultural info about Brasilia. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Podgorica (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:podgorica',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Podgorica',
  'TODO: Add geographic/cultural info about Podgorica. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Kaohsiung (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kaohsiung',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Kaohsiung',
  'TODO: Add geographic/cultural info about Kaohsiung. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bern (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bern',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bern',
  'TODO: Add geographic/cultural info about Bern. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Porto Alegre (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:porto_alegre',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Porto Alegre',
  'TODO: Add geographic/cultural info about Porto Alegre. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Malmö (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:malm',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Malmö',
  'TODO: Add geographic/cultural info about Malmö. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Des Moines (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:des_moines',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Des Moines',
  'TODO: Add geographic/cultural info about Des Moines. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Guiyang (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guiyang',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Guiyang',
  'TODO: Add geographic/cultural info about Guiyang. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nice (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nice',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nice',
  'TODO: Add geographic/cultural info about Nice. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tijuana (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tijuana',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tijuana',
  'TODO: Add geographic/cultural info about Tijuana. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nanning (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nanning',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nanning',
  'TODO: Add geographic/cultural info about Nanning. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Canberra (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:canberra',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Canberra',
  'TODO: Add geographic/cultural info about Canberra. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nürnberg (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nrnberg',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nürnberg',
  'TODO: Add geographic/cultural info about Nürnberg. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Port of Spain (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:port_of_spain',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Port of Spain',
  'TODO: Add geographic/cultural info about Port of Spain. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cordoba (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cordoba',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cordoba',
  'TODO: Add geographic/cultural info about Cordoba. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Sarajevo (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sarajevo',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Sarajevo',
  'TODO: Add geographic/cultural info about Sarajevo. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Foshan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:foshan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Foshan',
  'TODO: Add geographic/cultural info about Foshan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bordeaux (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bordeaux',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bordeaux',
  'TODO: Add geographic/cultural info about Bordeaux. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Florence (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:florence',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Florence',
  'TODO: Add geographic/cultural info about Florence. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Oklahoma City (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:oklahoma_city',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Oklahoma City',
  'TODO: Add geographic/cultural info about Oklahoma City. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Astana (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:astana',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Astana',
  'TODO: Add geographic/cultural info about Astana. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Genoa (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:genoa',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Genoa',
  'TODO: Add geographic/cultural info about Genoa. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nagoya (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nagoya',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nagoya',
  'TODO: Add geographic/cultural info about Nagoya. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lanzhou (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lanzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lanzhou',
  'TODO: Add geographic/cultural info about Lanzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Durban (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:durban',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Durban',
  'TODO: Add geographic/cultural info about Durban. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dongguan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dongguan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dongguan',
  'TODO: Add geographic/cultural info about Dongguan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Portland (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:portland',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Portland',
  'TODO: Add geographic/cultural info about Portland. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Juan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_juan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Juan',
  'TODO: Add geographic/cultural info about San Juan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Bergen (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bergen',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Bergen',
  'TODO: Add geographic/cultural info about Bergen. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Yerevan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:yerevan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Yerevan',
  'TODO: Add geographic/cultural info about Yerevan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Richmond (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:richmond',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Richmond',
  'TODO: Add geographic/cultural info about Richmond. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Santa Cruz (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:santa_cruz',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Santa Cruz',
  'TODO: Add geographic/cultural info about Santa Cruz. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Asuncion (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:asuncion',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Asuncion',
  'TODO: Add geographic/cultural info about Asuncion. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Sacramento (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sacramento',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Sacramento',
  'TODO: Add geographic/cultural info about Sacramento. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cebu (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cebu',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cebu',
  'TODO: Add geographic/cultural info about Cebu. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hohhot (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hohhot',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hohhot',
  'TODO: Add geographic/cultural info about Hohhot. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Cologne (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cologne',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Cologne',
  'TODO: Add geographic/cultural info about Cologne. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- The Hague (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:the_hague',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'The Hague',
  'TODO: Add geographic/cultural info about The Hague. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Birmingham (AL) (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:birmingham_al',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Birmingham (AL)',
  'TODO: Add geographic/cultural info about Birmingham (AL). Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Las Vegas (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:las_vegas',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Las Vegas',
  'TODO: Add geographic/cultural info about Las Vegas. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ciudad Juarez (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ciudad_juarez',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ciudad Juarez',
  'TODO: Add geographic/cultural info about Ciudad Juarez. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Winnipeg (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:winnipeg',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Winnipeg',
  'TODO: Add geographic/cultural info about Winnipeg. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Orlando (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:orlando',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Orlando',
  'TODO: Add geographic/cultural info about Orlando. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Windhoek (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:windhoek',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Windhoek',
  'TODO: Add geographic/cultural info about Windhoek. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hannover (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hannover',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hannover',
  'TODO: Add geographic/cultural info about Hannover. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Louisville (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:louisville',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Louisville',
  'TODO: Add geographic/cultural info about Louisville. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Aberdeen (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:aberdeen',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Aberdeen',
  'TODO: Add geographic/cultural info about Aberdeen. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Liege (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:liege',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Liege',
  'TODO: Add geographic/cultural info about Liege. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Liverpool (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:liverpool',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Liverpool',
  'TODO: Add geographic/cultural info about Liverpool. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Basel (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:basel',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Basel',
  'TODO: Add geographic/cultural info about Basel. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tulsa (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tulsa',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tulsa',
  'TODO: Add geographic/cultural info about Tulsa. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Mannheim (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:mannheim',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Mannheim',
  'TODO: Add geographic/cultural info about Mannheim. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Palo Alto (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:palo_alto',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Palo Alto',
  'TODO: Add geographic/cultural info about Palo Alto. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Pedro Sula (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_pedro_sula',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Pedro Sula',
  'TODO: Add geographic/cultural info about San Pedro Sula. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Seville (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:seville',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Seville',
  'TODO: Add geographic/cultural info about Seville. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Recife (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:recife',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Recife',
  'TODO: Add geographic/cultural info about Recife. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Alexandria (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:alexandria',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Alexandria',
  'TODO: Add geographic/cultural info about Alexandria. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Moscow (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:moscow',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Moscow',
  'TODO: Add geographic/cultural info about Moscow. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Vientiane (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vientiane',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Vientiane',
  'TODO: Add geographic/cultural info about Vientiane. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Tangshan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tangshan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Tangshan',
  'TODO: Add geographic/cultural info about Tangshan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Ulan Bator (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ulan_bator',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Ulan Bator',
  'TODO: Add geographic/cultural info about Ulan Bator. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Salvador (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:salvador',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Salvador',
  'TODO: Add geographic/cultural info about Salvador. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Memphis (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:memphis',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Memphis',
  'TODO: Add geographic/cultural info about Memphis. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Yinchuan (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:yinchuan',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Yinchuan',
  'TODO: Add geographic/cultural info about Yinchuan. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Linz (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:linz',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Linz',
  'TODO: Add geographic/cultural info about Linz. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Calcutta (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:calcutta',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Calcutta',
  'TODO: Add geographic/cultural info about Calcutta. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Halifax (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:halifax',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Halifax',
  'TODO: Add geographic/cultural info about Halifax. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- San Luis Potosí (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_luis_potos',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'San Luis Potosí',
  'TODO: Add geographic/cultural info about San Luis Potosí. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Barranquilla (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:barranquilla',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Barranquilla',
  'TODO: Add geographic/cultural info about Barranquilla. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Libreville (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:libreville',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Libreville',
  'TODO: Add geographic/cultural info about Libreville. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Lodz (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lodz',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Lodz',
  'TODO: Add geographic/cultural info about Lodz. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Hamilton (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hamilton',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Hamilton',
  'TODO: Add geographic/cultural info about Hamilton. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Dresden (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dresden',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Dresden',
  'TODO: Add geographic/cultural info about Dresden. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Arhus (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:arhus',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Arhus',
  'TODO: Add geographic/cultural info about Arhus. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Baoding (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:baoding',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Baoding',
  'TODO: Add geographic/cultural info about Baoding. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Wenzhou (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wenzhou',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Wenzhou',
  'TODO: Add geographic/cultural info about Wenzhou. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Blantyre (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:blantyre',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Blantyre',
  'TODO: Add geographic/cultural info about Blantyre. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Nottingham (Sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nottingham',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'Nottingham',
  'TODO: Add geographic/cultural info about Nottingham. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Strasbourg',
  'Sufficiency tier global city',
  array['city:strasbourg'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Columbus',
  'Sufficiency tier global city',
  array['city:columbus'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Ankara',
  'Sufficiency tier global city',
  array['city:ankara'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Johor Bahru',
  'Sufficiency tier global city',
  array['city:johor_bahru'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Ottawa',
  'Sufficiency tier global city',
  array['city:ottawa'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Wroclaw',
  'Sufficiency tier global city',
  array['city:wroclaw'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Urumqi',
  'Sufficiency tier global city',
  array['city:urumqi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Christchurch',
  'Sufficiency tier global city',
  array['city:christchurch'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Douala',
  'Sufficiency tier global city',
  array['city:douala'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Tashkent',
  'Sufficiency tier global city',
  array['city:tashkent'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Lausanne',
  'Sufficiency tier global city',
  array['city:lausanne'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Málaga',
  'Sufficiency tier global city',
  array['city:mlaga'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Wuxi',
  'Sufficiency tier global city',
  array['city:wuxi'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'George Town (Cayman Islands)',
  'Sufficiency tier global city',
  array['city:george_town_cayman_islands'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Salt Lake City',
  'Sufficiency tier global city',
  array['city:salt_lake_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Tallinn',
  'Sufficiency tier global city',
  array['city:tallinn'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nantes',
  'Sufficiency tier global city',
  array['city:nantes'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Medellin',
  'Sufficiency tier global city',
  array['city:medellin'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Edmonton',
  'Sufficiency tier global city',
  array['city:edmonton'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Utrecht',
  'Sufficiency tier global city',
  array['city:utrecht'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Taichung',
  'Sufficiency tier global city',
  array['city:taichung'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Campinas',
  'Sufficiency tier global city',
  array['city:campinas'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Lille',
  'Sufficiency tier global city',
  array['city:lille'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Abuja',
  'Sufficiency tier global city',
  array['city:abuja'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Yangon',
  'Sufficiency tier global city',
  array['city:yangon'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Krakow',
  'Sufficiency tier global city',
  array['city:krakow'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Jacksonville',
  'Sufficiency tier global city',
  array['city:jacksonville'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Southampton',
  'Sufficiency tier global city',
  array['city:southampton'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'San Antonio',
  'Sufficiency tier global city',
  array['city:san_antonio'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Belo Horizonte',
  'Sufficiency tier global city',
  array['city:belo_horizonte'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Leipzig',
  'Sufficiency tier global city',
  array['city:leipzig'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Newcastle',
  'Sufficiency tier global city',
  array['city:newcastle'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Naples',
  'Sufficiency tier global city',
  array['city:naples'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Curitiba',
  'Sufficiency tier global city',
  array['city:curitiba'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Luanda',
  'Sufficiency tier global city',
  array['city:luanda'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Abidjan',
  'Sufficiency tier global city',
  array['city:abidjan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Milwaukee',
  'Sufficiency tier global city',
  array['city:milwaukee'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nassau',
  'Sufficiency tier global city',
  array['city:nassau'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Gaborone',
  'Sufficiency tier global city',
  array['city:gaborone'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Puebla',
  'Sufficiency tier global city',
  array['city:puebla'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Toulouse',
  'Sufficiency tier global city',
  array['city:toulouse'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Brasilia',
  'Sufficiency tier global city',
  array['city:brasilia'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Podgorica',
  'Sufficiency tier global city',
  array['city:podgorica'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Kaohsiung',
  'Sufficiency tier global city',
  array['city:kaohsiung'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Bern',
  'Sufficiency tier global city',
  array['city:bern'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Porto Alegre',
  'Sufficiency tier global city',
  array['city:porto_alegre'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Malmö',
  'Sufficiency tier global city',
  array['city:malm'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Des Moines',
  'Sufficiency tier global city',
  array['city:des_moines'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Guiyang',
  'Sufficiency tier global city',
  array['city:guiyang'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nice',
  'Sufficiency tier global city',
  array['city:nice'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Tijuana',
  'Sufficiency tier global city',
  array['city:tijuana'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nanning',
  'Sufficiency tier global city',
  array['city:nanning'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Canberra',
  'Sufficiency tier global city',
  array['city:canberra'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nürnberg',
  'Sufficiency tier global city',
  array['city:nrnberg'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Port of Spain',
  'Sufficiency tier global city',
  array['city:port_of_spain'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Cordoba',
  'Sufficiency tier global city',
  array['city:cordoba'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Sarajevo',
  'Sufficiency tier global city',
  array['city:sarajevo'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Foshan',
  'Sufficiency tier global city',
  array['city:foshan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Bordeaux',
  'Sufficiency tier global city',
  array['city:bordeaux'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Florence',
  'Sufficiency tier global city',
  array['city:florence'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Oklahoma City',
  'Sufficiency tier global city',
  array['city:oklahoma_city'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Astana',
  'Sufficiency tier global city',
  array['city:astana'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Genoa',
  'Sufficiency tier global city',
  array['city:genoa'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nagoya',
  'Sufficiency tier global city',
  array['city:nagoya'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Lanzhou',
  'Sufficiency tier global city',
  array['city:lanzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Durban',
  'Sufficiency tier global city',
  array['city:durban'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Dongguan',
  'Sufficiency tier global city',
  array['city:dongguan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Portland',
  'Sufficiency tier global city',
  array['city:portland'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'San Juan',
  'Sufficiency tier global city',
  array['city:san_juan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Bergen',
  'Sufficiency tier global city',
  array['city:bergen'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Yerevan',
  'Sufficiency tier global city',
  array['city:yerevan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Richmond',
  'Sufficiency tier global city',
  array['city:richmond'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Santa Cruz',
  'Sufficiency tier global city',
  array['city:santa_cruz'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Asuncion',
  'Sufficiency tier global city',
  array['city:asuncion'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Sacramento',
  'Sufficiency tier global city',
  array['city:sacramento'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Cebu',
  'Sufficiency tier global city',
  array['city:cebu'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Hohhot',
  'Sufficiency tier global city',
  array['city:hohhot'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Cologne',
  'Sufficiency tier global city',
  array['city:cologne'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'The Hague',
  'Sufficiency tier global city',
  array['city:the_hague'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Birmingham (AL)',
  'Sufficiency tier global city',
  array['city:birmingham_al'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Las Vegas',
  'Sufficiency tier global city',
  array['city:las_vegas'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Ciudad Juarez',
  'Sufficiency tier global city',
  array['city:ciudad_juarez'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Winnipeg',
  'Sufficiency tier global city',
  array['city:winnipeg'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Orlando',
  'Sufficiency tier global city',
  array['city:orlando'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Windhoek',
  'Sufficiency tier global city',
  array['city:windhoek'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Hannover',
  'Sufficiency tier global city',
  array['city:hannover'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Louisville',
  'Sufficiency tier global city',
  array['city:louisville'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Aberdeen',
  'Sufficiency tier global city',
  array['city:aberdeen'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Liege',
  'Sufficiency tier global city',
  array['city:liege'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Liverpool',
  'Sufficiency tier global city',
  array['city:liverpool'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Basel',
  'Sufficiency tier global city',
  array['city:basel'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Tulsa',
  'Sufficiency tier global city',
  array['city:tulsa'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Mannheim',
  'Sufficiency tier global city',
  array['city:mannheim'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Palo Alto',
  'Sufficiency tier global city',
  array['city:palo_alto'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'San Pedro Sula',
  'Sufficiency tier global city',
  array['city:san_pedro_sula'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Seville',
  'Sufficiency tier global city',
  array['city:seville'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Recife',
  'Sufficiency tier global city',
  array['city:recife'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Alexandria',
  'Sufficiency tier global city',
  array['city:alexandria'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Moscow',
  'Sufficiency tier global city',
  array['city:moscow'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Vientiane',
  'Sufficiency tier global city',
  array['city:vientiane'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Tangshan',
  'Sufficiency tier global city',
  array['city:tangshan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Ulan Bator',
  'Sufficiency tier global city',
  array['city:ulan_bator'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Salvador',
  'Sufficiency tier global city',
  array['city:salvador'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Memphis',
  'Sufficiency tier global city',
  array['city:memphis'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Yinchuan',
  'Sufficiency tier global city',
  array['city:yinchuan'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Linz',
  'Sufficiency tier global city',
  array['city:linz'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Calcutta',
  'Sufficiency tier global city',
  array['city:calcutta'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Halifax',
  'Sufficiency tier global city',
  array['city:halifax'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'San Luis Potosí',
  'Sufficiency tier global city',
  array['city:san_luis_potos'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Barranquilla',
  'Sufficiency tier global city',
  array['city:barranquilla'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Libreville',
  'Sufficiency tier global city',
  array['city:libreville'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Lodz',
  'Sufficiency tier global city',
  array['city:lodz'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Hamilton',
  'Sufficiency tier global city',
  array['city:hamilton'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Dresden',
  'Sufficiency tier global city',
  array['city:dresden'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Arhus',
  'Sufficiency tier global city',
  array['city:arhus'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Baoding',
  'Sufficiency tier global city',
  array['city:baoding'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Wenzhou',
  'Sufficiency tier global city',
  array['city:wenzhou'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Blantyre',
  'Sufficiency tier global city',
  array['city:blantyre'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
),

(
  (select id from card_groups where name = 'cities_watg24_sufficiency'),
  'Nottingham',
  'Sufficiency tier global city',
  array['city:nottingham'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'US:New_York')
);

-- ============================================
-- STATISTICS
-- ============================================

do $$
declare
  total_skill_tags int;
  total_fact_cards int;
  total_card_groups int;
begin
  select count(*) into total_skill_tags from skill_tags where key like 'city:%';
  select count(*) into total_fact_cards from fact_cards
    where card_group_id in (
      select id from card_groups where name like 'cities_watg24_%'
    );
  select count(*) into total_card_groups from card_groups where name like 'cities_watg24_%';

  raise notice '✅ WATG24 Cities Setup Complete!';
  raise notice '';
  raise notice 'Statistics:';
  raise notice '  - Card Groups: %', total_card_groups;
  raise notice '  - City Skill Tags: %', total_skill_tags;
  raise notice '  - Fact Cards: %', total_fact_cards;
  raise notice '';
  raise notice '⚠️  TODO Items Remaining:';
  raise notice '  - Fill in country codes';
  raise notice '  - Write geographic notes for cities';
  raise notice '  - Map cities to region keys';
  raise notice '  - Create missing city regions';
end $$;
