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
  ('cities_watg24_high_sufficiency');

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
    (select id from card_groups where name = 'cities_watg24_high_sufficiency')
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
  'Alpha++ tier city',
  array['city:london'],
  '2',
  (select id from regions where key = 'GB:London')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'New York',
  'Alpha++ tier city',
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
  'Alpha tier city',
  array['city:seoul'],
  '2',
  (select id from regions where key = 'KR:Seoul')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Milan',
  'Alpha tier city',
  array['city:milan'],
  '2',
  (select id from regions where key = 'IT:Milan')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Toronto',
  'Alpha tier city',
  array['city:toronto'],
  '2',
  (select id from regions where key = 'CA:Toronto')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Frankfurt',
  'Alpha tier city',
  array['city:frankfurt'],
  '2',
  (select id from regions where key = 'DE:Frankfurt')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Chicago',
  'Alpha tier city',
  array['city:chicago'],
  '2',
  (select id from regions where key = 'US:Chicago')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Jakarta',
  'Alpha tier city',
  array['city:jakarta'],
  '2',
  (select id from regions where key = 'ID:Jakarta')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Sao Paulo',
  'Alpha tier city',
  array['city:sao_paulo'],
  '2',
  (select id from regions where key = 'BR:Sao_Paulo')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Mexico City',
  'Alpha tier city',
  array['city:mexico_city'],
  '2',
  (select id from regions where key = 'MX:Mexico_City')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Mumbai',
  'Alpha tier city',
  array['city:mumbai'],
  '2',
  (select id from regions where key = 'IN:Mumbai')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Madrid',
  'Alpha tier city',
  array['city:madrid'],
  '2',
  (select id from regions where key = 'ES:Madrid')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Warsaw',
  'Alpha tier city',
  array['city:warsaw'],
  '2',
  (select id from regions where key = 'PL:Warsaw')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Guangzhou',
  'Alpha tier city',
  array['city:guangzhou'],
  '2',
  (select id from regions where key = 'CN:Guangzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Istanbul',
  'Alpha tier city',
  array['city:istanbul'],
  '2',
  (select id from regions where key = 'TR:Istanbul')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Amsterdam',
  'Alpha tier city',
  array['city:amsterdam'],
  '2',
  (select id from regions where key = 'NL:Amsterdam')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Bangkok',
  'Alpha tier city',
  array['city:bangkok'],
  '2',
  (select id from regions where key = 'TH:Bangkok')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Los Angeles',
  'Alpha tier city',
  array['city:los_angeles'],
  '2',
  (select id from regions where key = 'US:Los_Angeles')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha'),
  'Kuala Lumpur',
  'Alpha tier city',
  array['city:kuala_lumpur'],
  '2',
  (select id from regions where key = 'MY:Kuala_Lumpur')
);



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
  'Alpha- tier city',
  array['city:luxembourg'],
  '2',
  (select id from regions where key = 'LU:Luxembourg')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Taipei',
  'Alpha- tier city',
  array['city:taipei'],
  '2',
  (select id from regions where key = 'TW:Taipei')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Shenzhen',
  'Alpha- tier city',
  array['city:shenzhen'],
  '2',
  (select id from regions where key = 'CN:Shenzhen')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Brussels',
  'Alpha- tier city',
  array['city:brussels'],
  '2',
  (select id from regions where key = 'BE:Brussels')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Zurich',
  'Alpha- tier city',
  array['city:zurich'],
  '2',
  (select id from regions where key = 'CH:Zurich')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Buenos Aires',
  'Alpha- tier city',
  array['city:buenos_aires'],
  '2',
  (select id from regions where key = 'AR:Buenos_Aires')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Melbourne',
  'Alpha- tier city',
  array['city:melbourne'],
  '2',
  (select id from regions where key = 'AU:Melbourne')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'San Francisco',
  'Alpha- tier city',
  array['city:san_francisco'],
  '2',
  (select id from regions where key = 'US:San_Francisco')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Riyadh',
  'Alpha- tier city',
  array['city:riyadh'],
  '2',
  (select id from regions where key = 'SA:Riyadh')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Santiago',
  'Alpha- tier city',
  array['city:santiago'],
  '2',
  (select id from regions where key = 'CL:Santiago')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Düsseldorf',
  'Alpha- tier city',
  array['city:dsseldorf'],
  '2',
  (select id from regions where key = 'DE:Dusseldorf')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Stockholm',
  'Alpha- tier city',
  array['city:stockholm'],
  '2',
  (select id from regions where key = 'SE:Stockholm')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Washington DC',
  'Alpha- tier city',
  array['city:washington_dc'],
  '2',
  (select id from regions where key = 'US:Washington_DC')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Vienna',
  'Alpha- tier city',
  array['city:vienna'],
  '2',
  (select id from regions where key = 'AT:Vienna')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Lisbon',
  'Alpha- tier city',
  array['city:lisbon'],
  '2',
  (select id from regions where key = 'PT:Lisbon')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Munich',
  'Alpha- tier city',
  array['city:munich'],
  '2',
  (select id from regions where key = 'DE:Munich')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Dublin',
  'Alpha- tier city',
  array['city:dublin'],
  '2',
  (select id from regions where key = 'IE:Dublin')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Houston',
  'Alpha- tier city',
  array['city:houston'],
  '2',
  (select id from regions where key = 'US:Houston')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Berlin',
  'Alpha- tier city',
  array['city:berlin'],
  '2',
  (select id from regions where key = 'DE:Berlin')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Johannesburg',
  'Alpha- tier city',
  array['city:johannesburg'],
  '2',
  (select id from regions where key = 'ZA:Johannesburg')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'Boston',
  'Alpha- tier city',
  array['city:boston'],
  '2',
  (select id from regions where key = 'US:Boston')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_minus'),
  'New Delhi',
  'Alpha- tier city',
  array['city:new_delhi'],
  '2',
  (select id from regions where key = 'IN:New_Delhi')
);


-- BETA+ CITIES (20 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('CO:Bogota', 'city'::region_level_enum, 'Bogota', 'CO', 'pin'::location_type_enum, ARRAY[-74.0721, 4.7110]),
('VN:Ho_Chi_Minh_City', 'city'::region_level_enum, 'Ho Chi Minh City', 'VN', 'pin'::location_type_enum, ARRAY[106.6297, 10.8231]),
('IT:Rome', 'city'::region_level_enum, 'Rome', 'IT', 'pin'::location_type_enum, ARRAY[12.4964, 41.9028]),
('IN:Bangalore', 'city'::region_level_enum, 'Bangalore', 'IN', 'pin'::location_type_enum, ARRAY[77.5946, 12.9716]),
('HU:Budapest', 'city'::region_level_enum, 'Budapest', 'HU', 'pin'::location_type_enum, ARRAY[19.0402, 47.4979]),
('GR:Athens', 'city'::region_level_enum, 'Athens', 'GR', 'pin'::location_type_enum, ARRAY[23.7275, 37.9838]),
('DE:Hamburg', 'city'::region_level_enum, 'Hamburg', 'DE', 'pin'::location_type_enum, ARRAY[9.9937, 53.5511]),
('QA:Doha', 'city'::region_level_enum, 'Doha', 'QA', 'pin'::location_type_enum, ARRAY[51.5310, 25.2854]),
('CN:Chengdu', 'city'::region_level_enum, 'Chengdu', 'CN', 'pin'::location_type_enum, ARRAY[104.0668, 30.5728]),
('US:Miami', 'city'::region_level_enum, 'Miami', 'US', 'pin'::location_type_enum, ARRAY[-80.1918, 25.7617]),
('CN:Tianjin', 'city'::region_level_enum, 'Tianjin', 'CN', 'pin'::location_type_enum, ARRAY[117.3616, 39.3434]),
('US:Dallas', 'city'::region_level_enum, 'Dallas', 'US', 'pin'::location_type_enum, ARRAY[-96.7970, 32.7767]),
('US:Atlanta', 'city'::region_level_enum, 'Atlanta', 'US', 'pin'::location_type_enum, ARRAY[-84.3880, 33.7490]),
('NZ:Auckland', 'city'::region_level_enum, 'Auckland', 'NZ', 'pin'::location_type_enum, ARRAY[174.7633, -36.8485]),
('ES:Barcelona', 'city'::region_level_enum, 'Barcelona', 'ES', 'pin'::location_type_enum, ARRAY[2.1734, 41.3851]),
('CN:Hangzhou', 'city'::region_level_enum, 'Hangzhou', 'CN', 'pin'::location_type_enum, ARRAY[120.1551, 30.2741]),
('RO:Bucharest', 'city'::region_level_enum, 'Bucharest', 'RO', 'pin'::location_type_enum, ARRAY[26.1025, 44.4268]),
('PE:Lima', 'city'::region_level_enum, 'Lima', 'PE', 'pin'::location_type_enum, ARRAY[-77.0428, -12.0464]),
('CA:Montreal', 'city'::region_level_enum, 'Montreal', 'CA', 'pin'::location_type_enum, ARRAY[-73.5673, 45.5017]),
('CZ:Prague', 'city'::region_level_enum, 'Prague', 'CZ', 'pin'::location_type_enum, ARRAY[14.4378, 50.0755]);

-- Skill Tags
-- Bogota (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bogota',
  'city'::skill_family_enum,
  'CO',
  'Bogota',
  'Capital and largest city of Colombia, located in the center of the country on a high plateau in the Andes at 2,640 meters elevation. Major economic and cultural center of Colombia, serving as the political and administrative hub.',
  array[]::text[]
);

-- Ho Chi Minh City (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ho_chi_minh_city',
  'city'::skill_family_enum,
  'VN',
  'Ho Chi Minh City',
  'Largest city in Vietnam, located in the southeast region on the Saigon River. Economic powerhouse of Vietnam and major commercial center, formerly known as Saigon.',
  array[]::text[]
);

-- Rome (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rome',
  'city'::skill_family_enum,
  'IT',
  'Rome',
  'Capital of Italy, located in the central-western portion of the Italian Peninsula along the Tiber River. Historic center of the Roman Empire and home to Vatican City, showcasing over 2,500 years of history.',
  array[]::text[]
);

-- Bangalore (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bangalore',
  'city'::skill_family_enum,
  'IN',
  'Bangalore',
  'Third-largest city in India and capital of Karnataka state, located on the Deccan Plateau in southern India. Known as the "Silicon Valley of India" for its thriving IT industry and tech startups.',
  array[]::text[]
);

-- Budapest (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:budapest',
  'city'::skill_family_enum,
  'HU',
  'Budapest',
  'Capital and largest city of Hungary, located in north-central Hungary along the Danube River. Formed by the unification of Buda and Pest across the river, known for thermal baths and historic architecture.',
  array[]::text[]
);

-- Athens (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:athens',
  'city'::skill_family_enum,
  'GR',
  'Athens',
  'Capital and largest city of Greece, located in the Attica region in southeastern Greece. Cradle of Western civilization and birthplace of democracy, home to ancient landmarks like the Acropolis and Parthenon.',
  array[]::text[]
);

-- Hamburg (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hamburg',
  'city'::skill_family_enum,
  'DE',
  'Hamburg',
  'Second-largest city in Germany, located in northern Germany on the Elbe River near the North Sea. Major port city and important center for trade, media, and logistics in northern Europe.',
  array[]::text[]
);

-- Doha (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:doha',
  'city'::skill_family_enum,
  'QA',
  'Doha',
  'Capital and largest city of Qatar, located on the coast of the Persian Gulf. Rapidly developing economic and cultural center, enriched by Qatar''s oil and natural gas reserves.',
  array[]::text[]
);

-- Chengdu (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chengdu',
  'city'::skill_family_enum,
  'CN',
  'Chengdu',
  'Capital of Sichuan Province in southwest China, located in the fertile Sichuan Basin. Major economic center and transportation hub, famous for being home to giant pandas and spicy Sichuan cuisine.',
  array[]::text[]
);

-- Miami (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:miami',
  'city'::skill_family_enum,
  'US',
  'Miami',
  'Major city in southeastern Florida, located on the Atlantic coast at the southern tip of the Florida peninsula. International business and cultural center with strong Latin American connections, known for beaches and vibrant nightlife.',
  array[]::text[]
);

-- Tianjin (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tianjin',
  'city'::skill_family_enum,
  'CN',
  'Tianjin',
  'Major port city in northeastern China, located on the coast of the Bohai Sea about 120 km from Beijing. Important industrial and commercial center, serving as a gateway to the Chinese capital.',
  array[]::text[]
);

-- Dallas (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dallas',
  'city'::skill_family_enum,
  'US',
  'Dallas',
  'Major city in northern Texas, located in the Dallas-Fort Worth metropolitan area. Major business and commercial center, particularly for telecommunications, banking, and energy industries.',
  array[]::text[]
);

-- Atlanta (GA) (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:atlanta_ga',
  'city'::skill_family_enum,
  'US',
  'Atlanta (GA)',
  'Capital and largest city of Georgia, located in the southeastern United States in the foothills of the Appalachian Mountains. Major transportation hub and economic center of the American South, home to Hartsfield-Jackson Atlanta International Airport.',
  array[]::text[]
);

-- Auckland (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:auckland',
  'city'::skill_family_enum,
  'NZ',
  'Auckland',
  'Largest city in New Zealand, located on the North Island between two harbors on a narrow isthmus. Economic and cultural center of New Zealand, known for its diverse population and sailing culture.',
  array[]::text[]
);

-- Barcelona (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:barcelona',
  'city'::skill_family_enum,
  'ES',
  'Barcelona',
  'Second-largest city in Spain and capital of Catalonia, located on the northeastern Mediterranean coast. Major cultural and economic center, renowned for Gaudí''s architectural works and Mediterranean lifestyle.',
  array[]::text[]
);

-- Hangzhou (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hangzhou',
  'city'::skill_family_enum,
  'CN',
  'Hangzhou',
  'Capital of Zhejiang Province in eastern China, located at the southern end of the Grand Canal near the East China Sea. Major technology and e-commerce hub, home to Alibaba Group and renowned for scenic West Lake.',
  array[]::text[]
);

-- Bucharest (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bucharest',
  'city'::skill_family_enum,
  'RO',
  'Bucharest',
  'Capital and largest city of Romania, located in the southern part of the country along the Dâmbovița River. Economic and cultural center of Romania, known for its wide tree-lined boulevards and historic architecture.',
  array[]::text[]
);

-- Lima (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lima',
  'city'::skill_family_enum,
  'PE',
  'Lima',
  'Capital and largest city of Peru, located on the arid Pacific coast in the valleys of three rivers. Political, cultural, and financial center of Peru, home to about one-third of the country''s population.',
  array[]::text[]
);

-- Montreal (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:montreal',
  'city'::skill_family_enum,
  'CA',
  'Montreal',
  'Second-largest city in Canada and largest city in Quebec, located on an island in the Saint Lawrence River. Major French-speaking metropolis, known for its bilingual culture, festivals, and historic Old Montreal.',
  array[]::text[]
);

-- Prague (Beta+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:prague',
  'city'::skill_family_enum,
  'CZ',
  'Prague',
  'Capital and largest city of the Czech Republic, located in the center of the country on the Vltava River. Historic city known for its well-preserved medieval architecture, Charles Bridge, and Prague Castle.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bogota',
  'Beta+ tier city',
  array['city:bogota'],
  '2',
  (select id from regions where key = 'CO:Bogota')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Ho Chi Minh City',
  'Beta+ tier city',
  array['city:ho_chi_minh_city'],
  '2',
  (select id from regions where key = 'VN:Ho_Chi_Minh_City')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Rome',
  'Beta+ tier city',
  array['city:rome'],
  '2',
  (select id from regions where key = 'IT:Rome')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bangalore',
  'Beta+ tier city',
  array['city:bangalore'],
  '2',
  (select id from regions where key = 'IN:Bangalore')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Budapest',
  'Beta+ tier city',
  array['city:budapest'],
  '2',
  (select id from regions where key = 'HU:Budapest')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Athens',
  'Beta+ tier city',
  array['city:athens'],
  '2',
  (select id from regions where key = 'GR:Athens')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hamburg',
  'Beta+ tier city',
  array['city:hamburg'],
  '2',
  (select id from regions where key = 'DE:Hamburg')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Doha',
  'Beta+ tier city',
  array['city:doha'],
  '2',
  (select id from regions where key = 'QA:Doha')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Chengdu',
  'Beta+ tier city',
  array['city:chengdu'],
  '2',
  (select id from regions where key = 'CN:Chengdu')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Miami',
  'Beta+ tier city',
  array['city:miami'],
  '2',
  (select id from regions where key = 'US:Miami')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Tianjin',
  'Beta+ tier city',
  array['city:tianjin'],
  '2',
  (select id from regions where key = 'CN:Tianjin')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Dallas',
  'Beta+ tier city',
  array['city:dallas'],
  '2',
  (select id from regions where key = 'US:Dallas')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Atlanta (GA)',
  'Beta+ tier city',
  array['city:atlanta_ga'],
  '2',
  (select id from regions where key = 'US:Atlanta')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Auckland',
  'Beta+ tier city',
  array['city:auckland'],
  '2',
  (select id from regions where key = 'NZ:Auckland')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Barcelona',
  'Beta+ tier city',
  array['city:barcelona'],
  '2',
  (select id from regions where key = 'ES:Barcelona')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hangzhou',
  'Beta+ tier city',
  array['city:hangzhou'],
  '2',
  (select id from regions where key = 'CN:Hangzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bucharest',
  'Beta+ tier city',
  array['city:bucharest'],
  '2',
  (select id from regions where key = 'RO:Bucharest')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Lima',
  'Beta+ tier city',
  array['city:lima'],
  '2',
  (select id from regions where key = 'PE:Lima')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Montreal',
  'Beta+ tier city',
  array['city:montreal'],
  '2',
  (select id from regions where key = 'CA:Montreal')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Prague',
  'Beta+ tier city',
  array['city:prague'],
  '2',
  (select id from regions where key = 'CZ:Prague')
);

-- ============================================


-- BETA CITIES (23 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('CN:Chongqing', 'city'::region_level_enum, 'Chongqing', 'CN', 'pin'::location_type_enum, ARRAY[106.5516, 29.5630]),
('IL:Tel_Aviv', 'city'::region_level_enum, 'Tel Aviv', 'IL', 'pin'::location_type_enum, ARRAY[34.7818, 32.0853]),
('AU:Brisbane', 'city'::region_level_enum, 'Brisbane', 'AU', 'pin'::location_type_enum, ARRAY[153.0281, -27.4705]),
('EG:Cairo', 'city'::region_level_enum, 'Cairo', 'EG', 'pin'::location_type_enum, ARRAY[31.2357, 30.0444]),
('VN:Hanoi', 'city'::region_level_enum, 'Hanoi', 'VN', 'pin'::location_type_enum, ARRAY[105.8342, 21.0285]),
('CN:Nanjing', 'city'::region_level_enum, 'Nanjing', 'CN', 'pin'::location_type_enum, ARRAY[118.7969, 32.0603]),
('NO:Oslo', 'city'::region_level_enum, 'Oslo', 'NO', 'pin'::location_type_enum, ARRAY[10.7522, 59.9139]),
('AU:Perth', 'city'::region_level_enum, 'Perth', 'AU', 'pin'::location_type_enum, ARRAY[115.8605, -31.9505]),
('AE:Abu_Dhabi', 'city'::region_level_enum, 'Abu Dhabi', 'AE', 'pin'::location_type_enum, ARRAY[54.3773, 24.4539]),
('DK:Copenhagen', 'city'::region_level_enum, 'Copenhagen', 'DK', 'pin'::location_type_enum, ARRAY[12.5683, 55.6761]),
('BH:Manama', 'city'::region_level_enum, 'Manama', 'BH', 'pin'::location_type_enum, ARRAY[50.5860, 26.2285]),
('CN:Wuhan', 'city'::region_level_enum, 'Wuhan', 'CN', 'pin'::location_type_enum, ARRAY[114.3055, 30.5928]),
('PH:Manila', 'city'::region_level_enum, 'Manila', 'PH', 'pin'::location_type_enum, ARRAY[120.9842, 14.5995]),
('CN:Xiamen', 'city'::region_level_enum, 'Xiamen', 'CN', 'pin'::location_type_enum, ARRAY[118.1025, 24.4798]),
('KE:Nairobi', 'city'::region_level_enum, 'Nairobi', 'KE', 'pin'::location_type_enum, ARRAY[36.8219, -1.2864]),
('UA:Kiev', 'city'::region_level_enum, 'Kiev', 'UA', 'pin'::location_type_enum, ARRAY[30.5234, 50.4501]),
('CH:Geneva', 'city'::region_level_enum, 'Geneva', 'CH', 'pin'::location_type_enum, ARRAY[6.1432, 46.2044]),
('CN:Jinan', 'city'::region_level_enum, 'Jinan', 'CN', 'pin'::location_type_enum, ARRAY[117.0208, 36.6512]),
('CA:Calgary', 'city'::region_level_enum, 'Calgary', 'CA', 'pin'::location_type_enum, ARRAY[-114.0719, 51.0447]),
('CN:Zhengzhou', 'city'::region_level_enum, 'Zhengzhou', 'CN', 'pin'::location_type_enum, ARRAY[113.6254, 34.7466]),
('CN:Shenyang', 'city'::region_level_enum, 'Shenyang', 'CN', 'pin'::location_type_enum, ARRAY[123.4328, 41.8057]),
('CN:Dalian', 'city'::region_level_enum, 'Dalian', 'CN', 'pin'::location_type_enum, ARRAY[121.6147, 38.9140]),
('CN:Suzhou', 'city'::region_level_enum, 'Suzhou', 'CN', 'pin'::location_type_enum, ARRAY[120.5954, 31.2989]);

-- Skill Tags
-- Chongqing (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chongqing',
  'city'::skill_family_enum,
  'CN',
  'Chongqing',
  'Major city in southwest China, located at the confluence of the Yangtze and Jialing Rivers in the mountainous Sichuan Basin. One of China''s four direct-controlled municipalities and a major inland port, known for its hilly terrain and spicy hotpot cuisine.',
  array[]::text[]
);

-- Tel Aviv (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tel_aviv',
  'city'::skill_family_enum,
  'IL',
  'Tel Aviv',
  'Second-most populous city in Israel, located on the Mediterranean coast in central Israel. Economic and technological center of Israel, known for its modern architecture, vibrant nightlife, and startup ecosystem.',
  array[]::text[]
);

-- Brisbane (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:brisbane',
  'city'::skill_family_enum,
  'AU',
  'Brisbane',
  'Third-largest city in Australia and capital of Queensland, located on the Brisbane River in southeastern Queensland. Major business and tourism center, known for its subtropical climate and proximity to beaches and rainforests.',
  array[]::text[]
);

-- Cairo (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cairo',
  'city'::skill_family_enum,
  'EG',
  'Cairo',
  'Capital and largest city of Egypt, located on the Nile River in northeastern Egypt. Ancient metropolis and cultural center of the Arab world, home to the nearby Giza Pyramids and historic Islamic Cairo.',
  array[]::text[]
);

-- Hanoi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hanoi',
  'city'::skill_family_enum,
  'VN',
  'Hanoi',
  'Capital of Vietnam, located in the northern part of the country on the Red River delta. Political and cultural center with over 1,000 years of history, known for French colonial architecture and traditional Vietnamese culture.',
  array[]::text[]
);

-- Nanjing (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nanjing',
  'city'::skill_family_enum,
  'CN',
  'Nanjing',
  'Capital of Jiangsu Province in eastern China, located on the lower Yangtze River in the Yangtze River Delta region. Historic city that served as China''s capital during several dynasties, major center for education, research, and transportation.',
  array[]::text[]
);

-- Oslo (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:oslo',
  'city'::skill_family_enum,
  'NO',
  'Oslo',
  'Capital and largest city of Norway, located at the head of the Oslofjord in southern Norway. Economic and governmental center, known for its green spaces, museums, and modern architecture alongside historic buildings.',
  array[]::text[]
);

-- Perth (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:perth',
  'city'::skill_family_enum,
  'AU',
  'Perth',
  'Fourth-largest city in Australia and capital of Western Australia, located on the Swan River along the southwestern coast. Most isolated major city in the world, serving as a gateway to Western Australia''s mining industry and natural attractions.',
  array[]::text[]
);

-- Abu Dhabi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:abu_dhabi',
  'city'::skill_family_enum,
  'AE',
  'Abu Dhabi',
  'Capital and second-most populous city of the United Arab Emirates, located on an island in the Persian Gulf. Political and industrial center of the UAE, enriched by oil reserves and home to the federal government.',
  array[]::text[]
);

-- Copenhagen (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:copenhagen',
  'city'::skill_family_enum,
  'DK',
  'Copenhagen',
  'Capital and largest city of Denmark, located on the eastern coast of Zealand island. Major Nordic economic and cultural hub, known for sustainable urban design, cycling culture, and historic waterfront.',
  array[]::text[]
);

-- Manama (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manama',
  'city'::skill_family_enum,
  'BH',
  'Manama',
  'Capital and largest city of Bahrain, located on the northeastern tip of Bahrain Island in the Persian Gulf. Major financial center in the Middle East and home to numerous multinational firms, known for its modern skyline and commercial activity.',
  array[]::text[]
);

-- Wuhan (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wuhan',
  'city'::skill_family_enum,
  'CN',
  'Wuhan',
  'Capital of Hubei Province in central China, located at the confluence of the Yangtze and Han Rivers. Major transportation hub and industrial center, often called the "Chicago of China" for its strategic location and economic importance.',
  array[]::text[]
);

-- Manila (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manila',
  'city'::skill_family_enum,
  'PH',
  'Manila',
  'Capital of the Philippines, located on the eastern shore of Manila Bay on the island of Luzon. Densely populated economic and cultural center of the country, known for its mix of Spanish colonial heritage and modern development.',
  array[]::text[]
);

-- Xiamen (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:xiamen',
  'city'::skill_family_enum,
  'CN',
  'Xiamen',
  'Major coastal city in Fujian Province in southeastern China, located on the Taiwan Strait opposite Taiwan. Important port city and Special Economic Zone, known for its subtropical climate and the historic island of Gulangyu.',
  array[]::text[]
);

-- Nairobi (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nairobi',
  'city'::skill_family_enum,
  'KE',
  'Nairobi',
  'Capital and largest city of Kenya, located in the south-central part of the country in the East African highlands. Major economic and political hub for East Africa, known for its national parks, wildlife, and as a center for business and diplomacy.',
  array[]::text[]
);

-- Kiev (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kiev',
  'city'::skill_family_enum,
  'UA',
  'Kiev',
  'Capital and largest city of Ukraine, located in north-central Ukraine along the Dnieper River. Historic city and economic center, one of the oldest cities in Eastern Europe with over 1,500 years of history.',
  array[]::text[]
);

-- Geneva (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:geneva',
  'city'::skill_family_enum,
  'CH',
  'Geneva',
  'Second-most populous city in Switzerland, located at the southern tip of Lake Geneva in western Switzerland. Global center for diplomacy and banking, home to numerous international organizations including the United Nations and Red Cross.',
  array[]::text[]
);

-- Jinan (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jinan',
  'city'::skill_family_enum,
  'CN',
  'Jinan',
  'Capital of Shandong Province in eastern China, located in the northwest part of the province along the Yellow River. Known as the "City of Springs" for its numerous artesian springs, serving as a major economic and cultural center.',
  array[]::text[]
);

-- Calgary (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:calgary',
  'city'::skill_family_enum,
  'CA',
  'Calgary',
  'Largest city in Alberta, Canada, located in the southern part of the province in the foothills of the Canadian Rockies. Major center for the oil and gas industry, known for the Calgary Stampede and proximity to mountain recreation.',
  array[]::text[]
);

-- Zhengzhou (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zhengzhou',
  'city'::skill_family_enum,
  'CN',
  'Zhengzhou',
  'Capital of Henan Province in central China, located on the southern bank of the Yellow River. Major transportation hub at the crossroads of China''s railway network, rapidly growing industrial and commercial center.',
  array[]::text[]
);

-- Shenyang (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shenyang',
  'city'::skill_family_enum,
  'CN',
  'Shenyang',
  'Capital of Liaoning Province in northeastern China, located in the southern part of the Northeast China Plain. Historic city and major industrial center, former capital of the Qing Dynasty before Beijing.',
  array[]::text[]
);

-- Dalian (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dalian',
  'city'::skill_family_enum,
  'CN',
  'Dalian',
  'Major coastal city in Liaoning Province in northeastern China, located on the Liaodong Peninsula between the Bohai Sea and Yellow Sea. Important port city and naval base, known for its beaches, temperate climate, and economic development zones.',
  array[]::text[]
);

-- Suzhou (Beta)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:suzhou',
  'city'::skill_family_enum,
  'CN',
  'Suzhou',
  'Major city in Jiangsu Province in eastern China, located on the lower Yangtze River delta near Shanghai. Ancient city known for its classical Chinese gardens, canals, and silk production, now a major industrial and technology center.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Chongqing',
  'Beta tier city',
  array['city:chongqing'],
  '2',
  (select id from regions where key = 'CN:Chongqing')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Tel Aviv',
  'Beta tier city',
  array['city:tel_aviv'],
  '2',
  (select id from regions where key = 'IL:Tel_Aviv')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Brisbane',
  'Beta tier city',
  array['city:brisbane'],
  '2',
  (select id from regions where key = 'AU:Brisbane')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Cairo',
  'Beta tier city',
  array['city:cairo'],
  '2',
  (select id from regions where key = 'EG:Cairo')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Hanoi',
  'Beta tier city',
  array['city:hanoi'],
  '2',
  (select id from regions where key = 'VN:Hanoi')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Nanjing',
  'Beta tier city',
  array['city:nanjing'],
  '2',
  (select id from regions where key = 'CN:Nanjing')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Oslo',
  'Beta tier city',
  array['city:oslo'],
  '2',
  (select id from regions where key = 'NO:Oslo')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Perth',
  'Beta tier city',
  array['city:perth'],
  '2',
  (select id from regions where key = 'AU:Perth')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Abu Dhabi',
  'Beta tier city',
  array['city:abu_dhabi'],
  '2',
  (select id from regions where key = 'AE:Abu_Dhabi')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Copenhagen',
  'Beta tier city',
  array['city:copenhagen'],
  '2',
  (select id from regions where key = 'DK:Copenhagen')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Manama',
  'Beta tier city',
  array['city:manama'],
  '2',
  (select id from regions where key = 'BH:Manama')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Wuhan',
  'Beta tier city',
  array['city:wuhan'],
  '2',
  (select id from regions where key = 'CN:Wuhan')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Manila',
  'Beta tier city',
  array['city:manila'],
  '2',
  (select id from regions where key = 'PH:Manila')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Xiamen',
  'Beta tier city',
  array['city:xiamen'],
  '2',
  (select id from regions where key = 'CN:Xiamen')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Nairobi',
  'Beta tier city',
  array['city:nairobi'],
  '2',
  (select id from regions where key = 'KE:Nairobi')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Kiev',
  'Beta tier city',
  array['city:kiev'],
  '2',
  (select id from regions where key = 'UA:Kiev')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Geneva',
  'Beta tier city',
  array['city:geneva'],
  '2',
  (select id from regions where key = 'CH:Geneva')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Jinan',
  'Beta tier city',
  array['city:jinan'],
  '2',
  (select id from regions where key = 'CN:Jinan')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Calgary',
  'Beta tier city',
  array['city:calgary'],
  '2',
  (select id from regions where key = 'CA:Calgary')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Zhengzhou',
  'Beta tier city',
  array['city:zhengzhou'],
  '2',
  (select id from regions where key = 'CN:Zhengzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Shenyang',
  'Beta tier city',
  array['city:shenyang'],
  '2',
  (select id from regions where key = 'CN:Shenyang')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Dalian',
  'Beta tier city',
  array['city:dalian'],
  '2',
  (select id from regions where key = 'CN:Dalian')
),

(
  (select id from card_groups where name = 'cities_watg24_beta'),
  'Suzhou',
  'Beta tier city',
  array['city:suzhou'],
  '2',
  (select id from regions where key = 'CN:Suzhou')
);

-- ============================================


-- BETA- CITIES (28 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('CN:Qingdao', 'city'::region_level_enum, 'Qingdao', 'CN', 'pin'::location_type_enum, ARRAY[120.3826, 36.0671]),
('MA:Casablanca', 'city'::region_level_enum, 'Casablanca', 'MA', 'pin'::location_type_enum, ARRAY[-7.5898, 33.5731]),
('CN:Changsha', 'city'::region_level_enum, 'Changsha', 'CN', 'pin'::location_type_enum, ARRAY[112.9388, 28.2282]),
('LB:Beirut', 'city'::region_level_enum, 'Beirut', 'LB', 'pin'::location_type_enum, ARRAY[35.4953, 33.8886]),
('MU:Port_Louis', 'city'::region_level_enum, 'Port Louis', 'MU', 'pin'::location_type_enum, ARRAY[57.5012, -20.1609]),
('US:Denver', 'city'::region_level_enum, 'Denver', 'US', 'pin'::location_type_enum, ARRAY[-104.9903, 39.7392]),
('NG:Lagos', 'city'::region_level_enum, 'Lagos', 'NG', 'pin'::location_type_enum, ARRAY[3.3792, 6.5244]),
('RS:Belgrade', 'city'::region_level_enum, 'Belgrade', 'RS', 'pin'::location_type_enum, ARRAY[20.4489, 44.7866]),
('UY:Montevideo', 'city'::region_level_enum, 'Montevideo', 'UY', 'pin'::location_type_enum, ARRAY[-56.1645, -34.9011]),
('CA:Vancouver', 'city'::region_level_enum, 'Vancouver', 'CA', 'pin'::location_type_enum, ARRAY[-123.1207, 49.2827]),
('US:Seattle', 'city'::region_level_enum, 'Seattle', 'US', 'pin'::location_type_enum, ARRAY[-122.3321, 47.6062]),
('GB:Manchester', 'city'::region_level_enum, 'Manchester', 'GB', 'pin'::location_type_enum, ARRAY[-2.2426, 53.4808]),
('BG:Sofia', 'city'::region_level_enum, 'Sofia', 'BG', 'pin'::location_type_enum, ARRAY[23.3219, 42.6977]),
('SK:Bratislava', 'city'::region_level_enum, 'Bratislava', 'SK', 'pin'::location_type_enum, ARRAY[17.1077, 48.1486]),
('BR:Rio_de_Janeiro', 'city'::region_level_enum, 'Rio de Janeiro', 'BR', 'pin'::location_type_enum, ARRAY[-43.1729, -22.9068]),
('FR:Lyon', 'city'::region_level_enum, 'Lyon', 'FR', 'pin'::location_type_enum, ARRAY[4.8357, 45.7640]),
('CN:Xian', 'city'::region_level_enum, 'Xi''an', 'CN', 'pin'::location_type_enum, ARRAY[108.9398, 34.3416]),
('FI:Helsinki', 'city'::region_level_enum, 'Helsinki', 'FI', 'pin'::location_type_enum, ARRAY[24.9384, 60.1695]),
('CN:Kunming', 'city'::region_level_enum, 'Kunming', 'CN', 'pin'::location_type_enum, ARRAY[102.8329, 25.0406]),
('HR:Zagreb', 'city'::region_level_enum, 'Zagreb', 'HR', 'pin'::location_type_enum, ARRAY[15.9819, 45.8150]),
('CY:Nicosia', 'city'::region_level_enum, 'Nicosia', 'CY', 'pin'::location_type_enum, ARRAY[33.3823, 35.1856]),
('PK:Karachi', 'city'::region_level_enum, 'Karachi', 'PK', 'pin'::location_type_enum, ARRAY[67.0099, 24.8607]),
('VE:Caracas', 'city'::region_level_enum, 'Caracas', 'VE', 'pin'::location_type_enum, ARRAY[-66.9036, 10.4806]),
('CN:Hefei', 'city'::region_level_enum, 'Hefei', 'CN', 'pin'::location_type_enum, ARRAY[117.2272, 31.8206]),
('DE:Stuttgart', 'city'::region_level_enum, 'Stuttgart', 'DE', 'pin'::location_type_enum, ARRAY[9.1829, 48.7758]),
('PA:Panama_City', 'city'::region_level_enum, 'Panama City', 'PA', 'pin'::location_type_enum, ARRAY[-79.5199, 8.9824]),
('IN:Chennai', 'city'::region_level_enum, 'Chennai', 'IN', 'pin'::location_type_enum, ARRAY[80.2707, 13.0827]),
('US:Philadelphia', 'city'::region_level_enum, 'Philadelphia', 'US', 'pin'::location_type_enum, ARRAY[-75.1652, 39.9526]);

-- Skill Tags
-- Qingdao (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:qingdao',
  'city'::skill_family_enum,
  'CN',
  'Qingdao',
  'Major coastal city in Shandong Province in eastern China, located on the southern coast of the Shandong Peninsula on the Yellow Sea. Important port city and manufacturing center, famous for Tsingtao beer and hosting sailing events at the 2008 Olympics.',
  array[]::text[]
);

-- Casablanca (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:casablanca',
  'city'::skill_family_enum,
  'MA',
  'Casablanca',
  'Largest city in Morocco, located on the Atlantic coast in the central-western part of the country. Major port and commercial center of Morocco, known for its modern business district and the Hassan II Mosque.',
  array[]::text[]
);

-- Changsha (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:changsha',
  'city'::skill_family_enum,
  'CN',
  'Changsha',
  'Capital of Hunan Province in south-central China, located on the Xiang River. Historic city and important cultural center, known for its connection to Mao Zedong and spicy Hunan cuisine.',
  array[]::text[]
);

-- Beirut (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:beirut',
  'city'::skill_family_enum,
  'LB',
  'Beirut',
  'Capital and largest city of Lebanon, located on the Mediterranean coast in the Levant region. Historic city known as the "Paris of the Middle East," serving as a cultural and financial center despite recent challenges.',
  array[]::text[]
);

-- Port Louis (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:port_louis',
  'city'::skill_family_enum,
  'MU',
  'Port Louis',
  'Capital and largest city of Mauritius, located on the northwest coast of the island nation in the Indian Ocean. Economic and administrative center, serving as the main port and commercial hub of Mauritius.',
  array[]::text[]
);

-- Denver (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:denver',
  'city'::skill_family_enum,
  'US',
  'Denver',
  'Capital of Colorado, located in the western United States at the eastern edge of the Rocky Mountains on the High Plains. Known as the "Mile High City" for its elevation, serving as a major center for the American West.',
  array[]::text[]
);

-- Lagos (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lagos',
  'city'::skill_family_enum,
  'NG',
  'Lagos',
  'Largest city in Nigeria and one of the most populous cities in Africa, located on the Atlantic coast in southwestern Nigeria. Major financial center and economic hub of Nigeria, known for its vibrant culture and Nollywood film industry.',
  array[]::text[]
);

-- Belgrade (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:belgrade',
  'city'::skill_family_enum,
  'RS',
  'Belgrade',
  'Capital and largest city of Serbia, located at the confluence of the Sava and Danube Rivers in southeastern Europe. Historic city with over 7,000 years of settlement, serving as a major political and cultural center of the Balkans.',
  array[]::text[]
);

-- Montevideo (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:montevideo',
  'city'::skill_family_enum,
  'UY',
  'Montevideo',
  'Capital and largest city of Uruguay, located on the southern coast along the Río de la Plata estuary. Economic and cultural center of Uruguay, known for its high quality of life and historic Ciudad Vieja district.',
  array[]::text[]
);

-- Vancouver (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vancouver',
  'city'::skill_family_enum,
  'CA',
  'Vancouver',
  'Major city in British Columbia, Canada, located on the western coast at the mouth of the Fraser River. Coastal city known for its natural beauty, multicultural population, and as a major Pacific port.',
  array[]::text[]
);

-- Seattle (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:seattle',
  'city'::skill_family_enum,
  'US',
  'Seattle',
  'Largest city in Washington state, located on the northwestern coast of the United States on Puget Sound. Major technology and aerospace hub, home to Microsoft, Amazon, and Boeing, known for coffee culture and the Space Needle.',
  array[]::text[]
);

-- Manchester (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:manchester',
  'city'::skill_family_enum,
  'GB',
  'Manchester',
  'Major city in northwestern England, located in the Greater Manchester metropolitan area. Former industrial powerhouse and birthplace of the Industrial Revolution, now a major cultural and economic center.',
  array[]::text[]
);

-- Sofia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:sofia',
  'city'::skill_family_enum,
  'BG',
  'Sofia',
  'Capital and largest city of Bulgaria, located in western Bulgaria at the foot of Mount Vitosha. Ancient city with over 2,000 years of history, serving as the political, cultural, and economic center of Bulgaria.',
  array[]::text[]
);

-- Bratislava (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bratislava',
  'city'::skill_family_enum,
  'SK',
  'Bratislava',
  'Capital and largest city of Slovakia, located in southwestern Slovakia along the Danube River near the borders of Austria and Hungary. Political and cultural center, known for its medieval old town and Bratislava Castle.',
  array[]::text[]
);

-- Rio de Janeiro (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rio_de_janeiro',
  'city'::skill_family_enum,
  'BR',
  'Rio de Janeiro',
  'Second-largest city in Brazil, located on the southeastern coast along the Atlantic Ocean. Famous for its beaches like Copacabana and Ipanema, Christ the Redeemer statue, and annual Carnival celebration.',
  array[]::text[]
);

-- Lyon (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lyon',
  'city'::skill_family_enum,
  'FR',
  'Lyon',
  'Third-largest city in France, located in east-central France at the confluence of the Rhône and Saône Rivers. Historic city known for its gastronomy, silk industry, and well-preserved Renaissance architecture.',
  array[]::text[]
);

-- Xi'an (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:xian',
  'city'::skill_family_enum,
  'CN',
  'Xi''an',
  'Capital of Shaanxi Province in central China, located in the Guanzhong Plain. Ancient capital of China and starting point of the Silk Road, famous for the Terracotta Army and city walls.',
  array[]::text[]
);

-- Helsinki (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:helsinki',
  'city'::skill_family_enum,
  'FI',
  'Helsinki',
  'Capital and largest city of Finland, located on the southern coast along the Gulf of Finland in the Baltic Sea. Modern Nordic city known for design, architecture, and as a major cultural and political center.',
  array[]::text[]
);

-- Kunming (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kunming',
  'city'::skill_family_enum,
  'CN',
  'Kunming',
  'Capital of Yunnan Province in southwestern China, located on the northern shore of Lake Dian on the Yunnan-Guizhou Plateau. Known as the "City of Eternal Spring" for its mild year-round climate, serving as a gateway to Southeast Asia.',
  array[]::text[]
);

-- Zagreb (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zagreb',
  'city'::skill_family_enum,
  'HR',
  'Zagreb',
  'Capital and largest city of Croatia, located in northwestern Croatia along the Sava River. Historic city and economic center, known for its Austro-Hungarian architecture and vibrant cultural scene.',
  array[]::text[]
);

-- Nicosia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nicosia',
  'city'::skill_family_enum,
  'CY',
  'Nicosia',
  'Capital and largest city of Cyprus, located in the center of the island in the eastern Mediterranean. Only divided capital in the world, split between the Republic of Cyprus and Northern Cyprus since 1974.',
  array[]::text[]
);

-- Karachi (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:karachi',
  'city'::skill_family_enum,
  'PK',
  'Karachi',
  'Largest city in Pakistan, located on the Arabian Sea coast in southern Pakistan. Major port city and economic center, serving as Pakistan''s financial and industrial hub.',
  array[]::text[]
);

-- Caracas (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:caracas',
  'city'::skill_family_enum,
  'VE',
  'Caracas',
  'Capital and largest city of Venezuela, located in the northern part of the country in a valley of the Venezuelan Coastal Range. Political and cultural center, founded in 1567 during Spanish colonial period.',
  array[]::text[]
);

-- Hefei (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hefei',
  'city'::skill_family_enum,
  'CN',
  'Hefei',
  'Capital of Anhui Province in eastern China, located in the central part of the province between the Yangtze and Huai Rivers. Rapidly growing city and emerging center for technology and innovation in China.',
  array[]::text[]
);

-- Stuttgart (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:stuttgart',
  'city'::skill_family_enum,
  'DE',
  'Stuttgart',
  'Sixth-largest city in Germany and capital of Baden-Württemberg state, located in southwestern Germany in a valley surrounded by hills. Major center for automotive industry, home to Mercedes-Benz and Porsche headquarters.',
  array[]::text[]
);

-- Panama City (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:panama_city',
  'city'::skill_family_enum,
  'PA',
  'Panama City',
  'Capital and largest city of Panama, located on the Pacific coast at the southern entrance of the Panama Canal. Major financial center and hub for international banking, known for its modern skyline and historic Casco Viejo district.',
  array[]::text[]
);

-- Chennai (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:chennai',
  'city'::skill_family_enum,
  'IN',
  'Chennai',
  'Fourth-largest city in India and capital of Tamil Nadu state, located on the Coromandel Coast along the Bay of Bengal. Major cultural and economic center of South India, formerly known as Madras.',
  array[]::text[]
);

-- Philadelphia (Beta-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:philadelphia',
  'city'::skill_family_enum,
  'US',
  'Philadelphia',
  'Largest city in Pennsylvania and sixth-largest city in the United States, located in the northeastern United States along the Delaware River. Historic city where the Declaration of Independence and Constitution were signed, known as the birthplace of American democracy.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Qingdao',
  'Beta- tier city',
  array['city:qingdao'],
  '2',
  (select id from regions where key = 'CN:Qingdao')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Casablanca',
  'Beta- tier city',
  array['city:casablanca'],
  '2',
  (select id from regions where key = 'MA:Casablanca')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Changsha',
  'Beta- tier city',
  array['city:changsha'],
  '2',
  (select id from regions where key = 'CN:Changsha')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Beirut',
  'Beta- tier city',
  array['city:beirut'],
  '2',
  (select id from regions where key = 'LB:Beirut')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Port Louis',
  'Beta- tier city',
  array['city:port_louis'],
  '2',
  (select id from regions where key = 'MU:Port_Louis')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Denver',
  'Beta- tier city',
  array['city:denver'],
  '2',
  (select id from regions where key = 'US:Denver')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lagos',
  'Beta- tier city',
  array['city:lagos'],
  '2',
  (select id from regions where key = 'NG:Lagos')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Belgrade',
  'Beta- tier city',
  array['city:belgrade'],
  '2',
  (select id from regions where key = 'RS:Belgrade')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Montevideo',
  'Beta- tier city',
  array['city:montevideo'],
  '2',
  (select id from regions where key = 'UY:Montevideo')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Vancouver',
  'Beta- tier city',
  array['city:vancouver'],
  '2',
  (select id from regions where key = 'CA:Vancouver')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Seattle',
  'Beta- tier city',
  array['city:seattle'],
  '2',
  (select id from regions where key = 'US:Seattle')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Manchester',
  'Beta- tier city',
  array['city:manchester'],
  '2',
  (select id from regions where key = 'GB:Manchester')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Sofia',
  'Beta- tier city',
  array['city:sofia'],
  '2',
  (select id from regions where key = 'BG:Sofia')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Bratislava',
  'Beta- tier city',
  array['city:bratislava'],
  '2',
  (select id from regions where key = 'SK:Bratislava')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Rio de Janeiro',
  'Beta- tier city',
  array['city:rio_de_janeiro'],
  '2',
  (select id from regions where key = 'BR:Rio_de_Janeiro')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lyon',
  'Beta- tier city',
  array['city:lyon'],
  '2',
  (select id from regions where key = 'FR:Lyon')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Xi’an',
  'Beta- tier city',
  array['city:xian'],
  '2',
  (select id from regions where key = 'CN:Xian')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Helsinki',
  'Beta- tier city',
  array['city:helsinki'],
  '2',
  (select id from regions where key = 'FI:Helsinki')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Kunming',
  'Beta- tier city',
  array['city:kunming'],
  '2',
  (select id from regions where key = 'CN:Kunming')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Zagreb',
  'Beta- tier city',
  array['city:zagreb'],
  '2',
  (select id from regions where key = 'HR:Zagreb')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Nicosia',
  'Beta- tier city',
  array['city:nicosia'],
  '2',
  (select id from regions where key = 'CY:Nicosia')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Karachi',
  'Beta- tier city',
  array['city:karachi'],
  '2',
  (select id from regions where key = 'PK:Karachi')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Caracas',
  'Beta- tier city',
  array['city:caracas'],
  '2',
  (select id from regions where key = 'VE:Caracas')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Hefei',
  'Beta- tier city',
  array['city:hefei'],
  '2',
  (select id from regions where key = 'CN:Hefei')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Stuttgart',
  'Beta- tier city',
  array['city:stuttgart'],
  '2',
  (select id from regions where key = 'DE:Stuttgart')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Panama City',
  'Beta- tier city',
  array['city:panama_city'],
  '2',
  (select id from regions where key = 'PA:Panama_City')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Chennai',
  'Beta- tier city',
  array['city:chennai'],
  '2',
  (select id from regions where key = 'IN:Chennai')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Philadelphia',
  'Beta- tier city',
  array['city:philadelphia'],
  '2',
  (select id from regions where key = 'US:Philadelphia')
);

-- ============================================



-- GAMMA+ CITIES (20 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('TN:Tunis', 'city'::region_level_enum, 'Tunis', 'TN', 'pin'::location_type_enum, ARRAY[10.1815, 36.8065]),
('CN:Fuzhou', 'city'::region_level_enum, 'Fuzhou', 'CN', 'pin'::location_type_enum, ARRAY[119.2965, 26.0745]),
('GT:Guatemala_City', 'city'::region_level_enum, 'Guatemala City', 'GT', 'pin'::location_type_enum, ARRAY[-90.5069, 14.6349]),
('IN:Hyderabad', 'city'::region_level_enum, 'Hyderabad', 'IN', 'pin'::location_type_enum, ARRAY[78.4867, 17.3850]),
('ZA:Cape_Town', 'city'::region_level_enum, 'Cape Town', 'ZA', 'pin'::location_type_enum, ARRAY[18.4241, -33.9249]),
('BD:Dhaka', 'city'::region_level_enum, 'Dhaka', 'BD', 'pin'::location_type_enum, ARRAY[90.4125, 23.8103]),
('PT:Porto', 'city'::region_level_enum, 'Porto', 'PT', 'pin'::location_type_enum, ARRAY[-8.6291, 41.1579]),
('US:Austin', 'city'::region_level_enum, 'Austin', 'US', 'pin'::location_type_enum, ARRAY[-97.7431, 30.2672]),
('US:San_Diego', 'city'::region_level_enum, 'San Diego', 'US', 'pin'::location_type_enum, ARRAY[-117.1611, 32.7157]),
('US:Minneapolis', 'city'::region_level_enum, 'Minneapolis', 'US', 'pin'::location_type_enum, ARRAY[-93.2650, 44.9778]),
('BE:Antwerp', 'city'::region_level_enum, 'Antwerp', 'BE', 'pin'::location_type_enum, ARRAY[4.4025, 51.2194]),
('KZ:Almaty', 'city'::region_level_enum, 'Almaty', 'KZ', 'pin'::location_type_enum, ARRAY[76.8512, 43.2220]),
('JO:Amman', 'city'::region_level_enum, 'Amman', 'JO', 'pin'::location_type_enum, ARRAY[35.9239, 31.9454]),
('DO:Santo_Domingo', 'city'::region_level_enum, 'Santo Domingo', 'DO', 'pin'::location_type_enum, ARRAY[-69.9312, 18.4861]),
('NL:Rotterdam', 'city'::region_level_enum, 'Rotterdam', 'NL', 'pin'::location_type_enum, ARRAY[4.4777, 51.9225]),
('AU:Adelaide', 'city'::region_level_enum, 'Adelaide', 'AU', 'pin'::location_type_enum, ARRAY[138.6007, -34.9285]),
('PK:Lahore', 'city'::region_level_enum, 'Lahore', 'PK', 'pin'::location_type_enum, ARRAY[74.3587, 31.5497]),
('LK:Colombo', 'city'::region_level_enum, 'Colombo', 'LK', 'pin'::location_type_enum, ARRAY[79.8612, 6.9271]),
('CN:Taiyuan', 'city'::region_level_enum, 'Taiyuan', 'CN', 'pin'::location_type_enum, ARRAY[112.5489, 37.8706]),
('KW:Kuwait_City', 'city'::region_level_enum, 'Kuwait City', 'KW', 'pin'::location_type_enum, ARRAY[47.9774, 29.3759]);

-- Skill Tags
-- Tunis (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tunis',
  'city'::skill_family_enum,
  'TN',
  'Tunis',
  'Capital and largest city of Tunisia, located on the Mediterranean coast in northern Tunisia. Ancient city with over 2,000 years of history, known for its medina and proximity to the ruins of Carthage.',
  array[]::text[]
);

-- Fuzhou (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:fuzhou',
  'city'::skill_family_enum,
  'CN',
  'Fuzhou',
  'Capital of Fujian Province in southeastern China, located on the Min River near the East China Sea. Historic port city and gateway to Taiwan, known for its hot springs and as the origin of many overseas Chinese.',
  array[]::text[]
);

-- Guatemala City (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guatemala_city',
  'city'::skill_family_enum,
  'GT',
  'Guatemala City',
  'Capital and largest city of Guatemala, located in the south-central part of the country in the Valley of the Ermita. Political and economic center of Central America''s most populous country, surrounded by volcanoes.',
  array[]::text[]
);

-- Hyderabad (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hyderabad',
  'city'::skill_family_enum,
  'IN',
  'Hyderabad',
  'Fourth-largest city in India and capital of Telangana state, located on the Deccan Plateau in southern India. Major IT and pharmaceutical hub, known as "Cyberabad" for its booming technology industry and historic sites like Charminar.',
  array[]::text[]
);

-- Cape Town (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cape_town',
  'city'::skill_family_enum,
  'ZA',
  'Cape Town',
  'Legislative capital of South Africa and second-largest city, located on the southwestern coast at the foot of Table Mountain. Known for its harbor, natural beauty, and as one of the most diverse cities in Africa.',
  array[]::text[]
);

-- Dhaka (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dhaka',
  'city'::skill_family_enum,
  'BD',
  'Dhaka',
  'Capital and largest city of Bangladesh, located in the central part of the country on the Buriganga River. One of the world''s most densely populated cities, serving as Bangladesh''s economic and cultural center.',
  array[]::text[]
);

-- Porto (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:porto',
  'city'::skill_family_enum,
  'PT',
  'Porto',
  'Second-largest city in Portugal, located in the northwest along the Douro River estuary on the Atlantic coast. Historic city known for port wine production, baroque architecture, and its UNESCO World Heritage historic center.',
  array[]::text[]
);

-- Austin (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:austin',
  'city'::skill_family_enum,
  'US',
  'Austin',
  'Capital of Texas, located in the central part of the state along the Colorado River. Known as the "Live Music Capital of the World" and major center for technology companies, with a vibrant cultural scene.',
  array[]::text[]
);

-- San Diego (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_diego',
  'city'::skill_family_enum,
  'US',
  'San Diego',
  'Second-largest city in California, located on the Pacific coast in the southwestern corner of the United States near the Mexican border. Major military and defense center, known for beaches, mild climate, and maritime heritage.',
  array[]::text[]
);

-- Minneapolis (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:minneapolis',
  'city'::skill_family_enum,
  'US',
  'Minneapolis',
  'Largest city in Minnesota, located in the north-central United States along both banks of the Mississippi River. Part of the Twin Cities with St. Paul, known for lakes, parks, and cultural institutions.',
  array[]::text[]
);

-- Antwerp (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:antwerp',
  'city'::skill_family_enum,
  'BE',
  'Antwerp',
  'Second-largest city in Belgium, located in the Flemish Region along the Scheldt River. Major European port city and global center for diamond trade, known for fashion and baroque architecture.',
  array[]::text[]
);

-- Almaty (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:almaty',
  'city'::skill_family_enum,
  'KZ',
  'Almaty',
  'Largest city in Kazakhstan, located in the southeastern part of the country near the border with Kyrgyzstan at the foot of the Tian Shan mountains. Former capital and still the cultural and commercial center of Kazakhstan.',
  array[]::text[]
);

-- Amman (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:amman',
  'city'::skill_family_enum,
  'JO',
  'Amman',
  'Capital and largest city of Jordan, located in the northwest of the country on a hilly area in northwestern Jordan. Ancient city built on seven hills, serving as Jordan''s political, cultural, and commercial center.',
  array[]::text[]
);

-- Santo Domingo (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:santo_domingo',
  'city'::skill_family_enum,
  'DO',
  'Santo Domingo',
  'Capital and largest city of the Dominican Republic, located on the southern coast of Hispaniola island in the Caribbean. Oldest continuously inhabited European settlement in the Americas, founded in 1496.',
  array[]::text[]
);

-- Rotterdam (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:rotterdam',
  'city'::skill_family_enum,
  'NL',
  'Rotterdam',
  'Second-largest city in the Netherlands, located in South Holland province at the mouth of the Nieuwe Maas channel. Home to Europe''s largest seaport, known for modern architecture after World War II reconstruction.',
  array[]::text[]
);

-- Adelaide (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:adelaide',
  'city'::skill_family_enum,
  'AU',
  'Adelaide',
  'Fifth-largest city in Australia and capital of South Australia, located on the Adelaide Plains between the Gulf St Vincent and the Mount Lofty Ranges. Known for wine regions, festivals, and planned grid layout.',
  array[]::text[]
);

-- Lahore (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lahore',
  'city'::skill_family_enum,
  'PK',
  'Lahore',
  'Second-largest city in Pakistan and capital of Punjab province, located near the border with India along the Ravi River. Historic cultural center known for Mughal architecture, gardens, and as the heart of Pakistani arts and cuisine.',
  array[]::text[]
);

-- Colombo (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:colombo',
  'city'::skill_family_enum,
  'LK',
  'Colombo',
  'Commercial capital and largest city of Sri Lanka, located on the western coast of the island. Major port city and financial center, known for colonial architecture and as the gateway to Sri Lanka.',
  array[]::text[]
);

-- Taiyuan (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:taiyuan',
  'city'::skill_family_enum,
  'CN',
  'Taiyuan',
  'Capital of Shanxi Province in northern China, located in the Taiyuan Basin of the central Shanxi Province. Industrial city and coal mining center, with over 2,500 years of history as a northern Chinese stronghold.',
  array[]::text[]
);

-- Kuwait City (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kuwait_city',
  'city'::skill_family_enum,
  'KW',
  'Kuwait City',
  'Capital and largest city of Kuwait, located on Kuwait Bay in the Persian Gulf. Modern city enriched by oil wealth, serving as Kuwait''s political and economic center with a major port.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Tunis',
  'Gamma+ tier city',
  array['city:tunis'],
  '2',
  (select id from regions where key = 'TN:Tunis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Fuzhou',
  'Gamma+ tier city',
  array['city:fuzhou'],
  '2',
  (select id from regions where key = 'CN:Fuzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Guatemala City',
  'Gamma+ tier city',
  array['city:guatemala_city'],
  '2',
  (select id from regions where key = 'GT:Guatemala_City')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Hyderabad',
  'Gamma+ tier city',
  array['city:hyderabad'],
  '2',
  (select id from regions where key = 'IN:Hyderabad')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Cape Town',
  'Gamma+ tier city',
  array['city:cape_town'],
  '2',
  (select id from regions where key = 'ZA:Cape_Town')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Dhaka',
  'Gamma+ tier city',
  array['city:dhaka'],
  '2',
  (select id from regions where key = 'BD:Dhaka')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Porto',
  'Gamma+ tier city',
  array['city:porto'],
  '2',
  (select id from regions where key = 'PT:Porto')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Austin',
  'Gamma+ tier city',
  array['city:austin'],
  '2',
  (select id from regions where key = 'US:Austin')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'San Diego',
  'Gamma+ tier city',
  array['city:san_diego'],
  '2',
  (select id from regions where key = 'US:San_Diego')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Minneapolis',
  'Gamma+ tier city',
  array['city:minneapolis'],
  '2',
  (select id from regions where key = 'US:Minneapolis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Antwerp',
  'Gamma+ tier city',
  array['city:antwerp'],
  '2',
  (select id from regions where key = 'BE:Antwerp')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Almaty',
  'Gamma+ tier city',
  array['city:almaty'],
  '2',
  (select id from regions where key = 'KZ:Almaty')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Amman',
  'Gamma+ tier city',
  array['city:amman'],
  '2',
  (select id from regions where key = 'JO:Amman')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Santo Domingo',
  'Gamma+ tier city',
  array['city:santo_domingo'],
  '2',
  (select id from regions where key = 'DO:Santo_Domingo')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Rotterdam',
  'Gamma+ tier city',
  array['city:rotterdam'],
  '2',
  (select id from regions where key = 'NL:Rotterdam')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Adelaide',
  'Gamma+ tier city',
  array['city:adelaide'],
  '2',
  (select id from regions where key = 'AU:Adelaide')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Lahore',
  'Gamma+ tier city',
  array['city:lahore'],
  '2',
  (select id from regions where key = 'PK:Lahore')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Colombo',
  'Gamma+ tier city',
  array['city:colombo'],
  '2',
  (select id from regions where key = 'LK:Colombo')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Taiyuan',
  'Gamma+ tier city',
  array['city:taiyuan'],
  '2',
  (select id from regions where key = 'CN:Taiyuan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Kuwait City',
  'Gamma+ tier city',
  array['city:kuwait_city'],
  '2',
  (select id from regions where key = 'KW:Kuwait_City')
);

-- ============================================


-- GAMMA CITIES (25 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('MX:Monterrey', 'city'::region_level_enum, 'Monterrey', 'MX', 'pin'::location_type_enum, ARRAY[-100.3161, 25.6866]),
('JP:Osaka', 'city'::region_level_enum, 'Osaka', 'JP', 'pin'::location_type_enum, ARRAY[135.5022, 34.6937]),
('CN:Haikou', 'city'::region_level_enum, 'Haikou', 'CN', 'pin'::location_type_enum, ARRAY[110.3312, 20.0458]),
('GE:Tbilisi', 'city'::region_level_enum, 'Tbilisi', 'GE', 'pin'::location_type_enum, ARRAY[44.8337, 41.7151]),
('US:Tampa', 'city'::region_level_enum, 'Tampa', 'US', 'pin'::location_type_enum, ARRAY[-82.4572, 27.9506]),
('AL:Tirana', 'city'::region_level_enum, 'Tirana', 'AL', 'pin'::location_type_enum, ARRAY[19.8187, 41.3275]),
('EC:Quito', 'city'::region_level_enum, 'Quito', 'EC', 'pin'::location_type_enum, ARRAY[-78.4678, -0.1807]),
('US:Nashville', 'city'::region_level_enum, 'Nashville', 'US', 'pin'::location_type_enum, ARRAY[-86.7816, 36.1627]),
('PK:Islamabad', 'city'::region_level_enum, 'Islamabad', 'PK', 'pin'::location_type_enum, ARRAY[73.0479, 33.6844]),
('UG:Kampala', 'city'::region_level_enum, 'Kampala', 'UG', 'pin'::location_type_enum, ARRAY[32.5825, 0.3476]),
('SV:San_Salvador', 'city'::region_level_enum, 'San Salvador', 'SV', 'pin'::location_type_enum, ARRAY[-89.2182, 13.6929]),
('OM:Muscat', 'city'::region_level_enum, 'Muscat', 'OM', 'pin'::location_type_enum, ARRAY[58.4059, 23.5880]),
('KH:Phnom_Penh', 'city'::region_level_enum, 'Phnom Penh', 'KH', 'pin'::location_type_enum, ARRAY[104.9160, 11.5564]),
('GB:Birmingham_UK', 'city'::region_level_enum, 'Birmingham (UK)', 'GB', 'pin'::location_type_enum, ARRAY[-1.8904, 52.4862]),
('IN:Pune', 'city'::region_level_enum, 'Pune', 'IN', 'pin'::location_type_enum, ARRAY[73.8567, 18.5204]),
('CN:Ningbo', 'city'::region_level_enum, 'Ningbo', 'CN', 'pin'::location_type_enum, ARRAY[121.5440, 29.8683]),
('CN:Harbin', 'city'::region_level_enum, 'Harbin', 'CN', 'pin'::location_type_enum, ARRAY[126.6433, 45.8038]),
('US:San_Jose_CA', 'city'::region_level_enum, 'San Jose (CA)', 'US', 'pin'::location_type_enum, ARRAY[-121.8863, 37.3382]),
('IT:Bologna', 'city'::region_level_enum, 'Bologna', 'IT', 'pin'::location_type_enum, ARRAY[11.3426, 44.4949]),
('CR:San_Jose_CR', 'city'::region_level_enum, 'San José (Costa Rica)', 'CR', 'pin'::location_type_enum, ARRAY[-84.0907, 9.9281]),
('IN:Ahmedabad', 'city'::region_level_enum, 'Ahmedabad', 'IN', 'pin'::location_type_enum, ARRAY[72.5714, 23.0225]),
('GB:Bristol', 'city'::region_level_enum, 'Bristol', 'GB', 'pin'::location_type_enum, ARRAY[-2.5879, 51.4545]),
('HN:Tegucigalpa', 'city'::region_level_enum, 'Tegucigalpa', 'HN', 'pin'::location_type_enum, ARRAY[-87.2068, 14.0723]),
('LV:Riga', 'city'::region_level_enum, 'Riga', 'LV', 'pin'::location_type_enum, ARRAY[24.1052, 56.9496]),
('US:Detroit', 'city'::region_level_enum, 'Detroit', 'US', 'pin'::location_type_enum, ARRAY[-83.0458, 42.3314]);

-- Skill Tags
-- Monterrey (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:monterrey',
  'city'::skill_family_enum,
  'MX',
  'Monterrey',
  'Third-largest city in Mexico, located in the northeastern part of the country near the U.S. border. Major industrial and business center, known for its strong economy and mountain backdrop.',
  array[]::text[]
);

-- Osaka (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:osaka',
  'city'::skill_family_enum,
  'JP',
  'Osaka',
  'Second-largest metropolitan area in Japan, located in the Kansai region on the island of Honshu. Major commercial center known for business culture, street food, and historic Osaka Castle.',
  array[]::text[]
);

-- Haikou (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:haikou',
  'city'::skill_family_enum,
  'CN',
  'Haikou',
  'Capital of Hainan Province in southern China, located on the northern coast of Hainan Island in the South China Sea. Tropical port city and gateway to China''s largest special economic zone on Hainan Island.',
  array[]::text[]
);

-- Tbilisi (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tbilisi',
  'city'::skill_family_enum,
  'GE',
  'Tbilisi',
  'Capital and largest city of Georgia, located on the banks of the Kura River in the South Caucasus. Ancient city at the crossroads of Europe and Asia, known for sulfur baths and diverse architecture.',
  array[]::text[]
);

-- Tampa (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tampa',
  'city'::skill_family_enum,
  'US',
  'Tampa',
  'Major city on the west coast of Florida, located on Tampa Bay along the Gulf of Mexico. Known for its tourism industry, cigar heritage, and as a major business center in Florida.',
  array[]::text[]
);

-- Tirana (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tirana',
  'city'::skill_family_enum,
  'AL',
  'Tirana',
  'Capital and largest city of Albania, located in central Albania surrounded by hills and mountains. Colorful city known for its transformation since the fall of communism, with vibrant culture and Ottoman heritage.',
  array[]::text[]
);

-- Quito (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:quito',
  'city'::skill_family_enum,
  'EC',
  'Quito',
  'Capital of Ecuador, located in the Guayllabamba river basin high in the Andean foothills at 2,850 meters elevation. Highest official capital city in the world, known for well-preserved colonial center and equatorial location.',
  array[]::text[]
);

-- Nashville (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nashville',
  'city'::skill_family_enum,
  'US',
  'Nashville',
  'Capital of Tennessee, located in the north-central part of the state along the Cumberland River. Known as "Music City" for its country music industry, home to the Grand Ole Opry and vibrant entertainment scene.',
  array[]::text[]
);

-- Islamabad (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:islamabad',
  'city'::skill_family_enum,
  'PK',
  'Islamabad',
  'Capital of Pakistan, located in the northern part of the country in the Pothohar Plateau. Planned city built in the 1960s, serving as Pakistan political center with modern infrastructure.',
  array[]::text[]
);

-- Kampala (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kampala',
  'city'::skill_family_enum,
  'UG',
  'Kampala',
  'Capital and largest city of Uganda, located in the south-central part of the country near Lake Victoria. Economic and administrative center, built across several hills in the historic Buganda kingdom.',
  array[]::text[]
);

-- San Salvador (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_salvador',
  'city'::skill_family_enum,
  'SV',
  'San Salvador',
  'Capital and largest city of El Salvador, located in the central part of the country in the Valley of the Hammocks. Political and economic center, rebuilt multiple times due to earthquakes and volcanic activity.',
  array[]::text[]
);

-- Muscat (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:muscat',
  'city'::skill_family_enum,
  'OM',
  'Muscat',
  'Capital and largest city of Oman, located on the Gulf of Oman along the Arabian Sea coast. Port city surrounded by mountains and desert, known for traditional architecture and incense trade heritage.',
  array[]::text[]
);

-- Phnom Penh (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:phnom_penh',
  'city'::skill_family_enum,
  'KH',
  'Phnom Penh',
  'Capital and largest city of Cambodia, located at the confluence of the Tonle Sap, Mekong, and Bassac Rivers. Known as the "Pearl of Asia," serving as Cambodia economic and cultural center with French colonial architecture.',
  array[]::text[]
);

-- Birmingham (UK) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:birmingham_uk',
  'city'::skill_family_enum,
  'GB',
  'Birmingham (UK)',
  'Second-largest city in the United Kingdom, located in the West Midlands of England. Major industrial city known as the birthplace of the Industrial Revolution, now a diverse cultural and commercial hub.',
  array[]::text[]
);

-- Pune (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:pune',
  'city'::skill_family_enum,
  'IN',
  'Pune',
  'Seventh-largest city in India, located in the state of Maharashtra in western India on the Deccan Plateau. Major educational and IT center, known as the "Oxford of the East" for its universities.',
  array[]::text[]
);

-- Ningbo (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ningbo',
  'city'::skill_family_enum,
  'CN',
  'Ningbo',
  'Major port city in Zhejiang Province in eastern China, located south of the Yangtze River Delta on the East China Sea. Important trading port with over 7,000 years of history, known for its deep-water port and manufacturing.',
  array[]::text[]
);

-- Harbin (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:harbin',
  'city'::skill_family_enum,
  'CN',
  'Harbin',
  'Capital of Heilongjiang Province in northeastern China, located on the southern bank of the Songhua River. Known as "Ice City" for its harsh winters and famous International Ice and Snow Sculpture Festival.',
  array[]::text[]
);

-- San Jose (CA) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_jose_ca',
  'city'::skill_family_enum,
  'US',
  'San Jose (CA)',
  'Third-largest city in California, located in the southern part of the San Francisco Bay Area. Heart of Silicon Valley, global center for technology and innovation, headquarters of numerous tech companies.',
  array[]::text[]
);

-- Bologna (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bologna',
  'city'::skill_family_enum,
  'IT',
  'Bologna',
  'Seventh-largest city in Italy and capital of Emilia-Romagna region, located between the Po River and the Apennine Mountains. Historic university city known for medieval towers, arcades, and renowned cuisine.',
  array[]::text[]
);

-- San José (Costa Rica) (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_jos_costa_rica',
  'city'::skill_family_enum,
  'CR',
  'San José (Costa Rica)',
  'Capital and largest city of Costa Rica, located in the Central Valley in the central highlands. Political and economic center, known for museums, parks, and as gateway to Costa Rica ecotourism destinations.',
  array[]::text[]
);

-- Ahmedabad (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ahmedabad',
  'city'::skill_family_enum,
  'IN',
  'Ahmedabad',
  'Largest city in Gujarat state in western India, located on the banks of the Sabarmati River. Major economic and industrial center, known for textile industry and as the former home of Mahatma Gandhi.',
  array[]::text[]
);

-- Bristol (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bristol',
  'city'::skill_family_enum,
  'GB',
  'Bristol',
  'Major city in southwestern England, located on the River Avon near the Bristol Channel. Historic port city and center of culture, known for maritime heritage, Clifton Suspension Bridge, and vibrant arts scene.',
  array[]::text[]
);

-- Tegucigalpa (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:tegucigalpa',
  'city'::skill_family_enum,
  'HN',
  'Tegucigalpa',
  'Capital and largest city of Honduras, located in the southern-central highlands in a valley surrounded by mountains. Political and administrative center, founded as a silver mining center in the 16th century.',
  array[]::text[]
);

-- Riga (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:riga',
  'city'::skill_family_enum,
  'LV',
  'Riga',
  'Capital and largest city of Latvia, located on the Gulf of Riga at the mouth of the Daugava River on the Baltic Sea. Historic city known for Art Nouveau architecture and as a major cultural center of the Baltic region.',
  array[]::text[]
);

-- Detroit (Gamma)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:detroit',
  'city'::skill_family_enum,
  'US',
  'Detroit',
  'Largest city in Michigan, located in the Midwestern United States along the Detroit River on the Canadian border. Historic center of the American automobile industry, known as "Motor City" and for Motown music heritage.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Monterrey',
  'Gamma tier city',
  array['city:monterrey'],
  '2',
  (select id from regions where key = 'MX:Monterrey')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Osaka',
  'Gamma tier city',
  array['city:osaka'],
  '2',
  (select id from regions where key = 'JP:Osaka')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Haikou',
  'Gamma tier city',
  array['city:haikou'],
  '2',
  (select id from regions where key = 'CN:Haikou')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tbilisi',
  'Gamma tier city',
  array['city:tbilisi'],
  '2',
  (select id from regions where key = 'GE:Tbilisi')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tampa',
  'Gamma tier city',
  array['city:tampa'],
  '2',
  (select id from regions where key = 'US:Tampa')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tirana',
  'Gamma tier city',
  array['city:tirana'],
  '2',
  (select id from regions where key = 'AL:Tirana')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Quito',
  'Gamma tier city',
  array['city:quito'],
  '2',
  (select id from regions where key = 'EC:Quito')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Nashville',
  'Gamma tier city',
  array['city:nashville'],
  '2',
  (select id from regions where key = 'US:Nashville')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Islamabad',
  'Gamma tier city',
  array['city:islamabad'],
  '2',
  (select id from regions where key = 'PK:Islamabad')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Kampala',
  'Gamma tier city',
  array['city:kampala'],
  '2',
  (select id from regions where key = 'UG:Kampala')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San Salvador',
  'Gamma tier city',
  array['city:san_salvador'],
  '2',
  (select id from regions where key = 'SV:San_Salvador')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Muscat',
  'Gamma tier city',
  array['city:muscat'],
  '2',
  (select id from regions where key = 'OM:Muscat')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Phnom Penh',
  'Gamma tier city',
  array['city:phnom_penh'],
  '2',
  (select id from regions where key = 'KH:Phnom_Penh')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Birmingham (UK)',
  'Gamma tier city',
  array['city:birmingham_uk'],
  '2',
  (select id from regions where key = 'GB:Birmingham_UK')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Pune',
  'Gamma tier city',
  array['city:pune'],
  '2',
  (select id from regions where key = 'IN:Pune')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Ningbo',
  'Gamma tier city',
  array['city:ningbo'],
  '2',
  (select id from regions where key = 'CN:Ningbo')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Harbin',
  'Gamma tier city',
  array['city:harbin'],
  '2',
  (select id from regions where key = 'CN:Harbin')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San Jose (CA)',
  'Gamma tier city',
  array['city:san_jose_ca'],
  '2',
  (select id from regions where key = 'US:San_Jose_CA')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Bologna',
  'Gamma tier city',
  array['city:bologna'],
  '2',
  (select id from regions where key = 'IT:Bologna')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'San José (Costa Rica)',
  'Gamma tier city',
  array['city:san_jos_costa_rica'],
  '2',
  (select id from regions where key = 'CR:San_Jose_CR')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Ahmedabad',
  'Gamma tier city',
  array['city:ahmedabad'],
  '2',
  (select id from regions where key = 'IN:Ahmedabad')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Bristol',
  'Gamma tier city',
  array['city:bristol'],
  '2',
  (select id from regions where key = 'GB:Bristol')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Tegucigalpa',
  'Gamma tier city',
  array['city:tegucigalpa'],
  '2',
  (select id from regions where key = 'HN:Tegucigalpa')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Riga',
  'Gamma tier city',
  array['city:riga'],
  '2',
  (select id from regions where key = 'LV:Riga')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma'),
  'Detroit',
  'Gamma tier city',
  array['city:detroit'],
  '2',
  (select id from regions where key = 'US:Detroit')
);

-- ============================================




-- GAMMA- CITIES (25 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('PL:Poznan', 'city'::region_level_enum, 'Poznan', 'PL', 'pin'::location_type_enum, ARRAY[16.9252, 52.4064]),
('MY:Labuan', 'city'::region_level_enum, 'Labuan', 'MY', 'pin'::location_type_enum, ARRAY[115.2308, 5.2831]),
('US:Charlotte', 'city'::region_level_enum, 'Charlotte', 'US', 'pin'::location_type_enum, ARRAY[-80.8431, 35.2271]),
('US:Pittsburgh', 'city'::region_level_enum, 'Pittsburgh', 'US', 'pin'::location_type_enum, ARRAY[-79.9959, 40.4406]),
('ES:Valencia', 'city'::region_level_enum, 'Valencia (Spain)', 'ES', 'pin'::location_type_enum, ARRAY[-0.3763, 39.4699]),
('GB:Edinburgh', 'city'::region_level_enum, 'Edinburgh', 'GB', 'pin'::location_type_enum, ARRAY[-3.1883, 55.9533]),
('SA:Jeddah', 'city'::region_level_enum, 'Jeddah', 'SA', 'pin'::location_type_enum, ARRAY[39.1925, 21.5433]),
('IT:Turin', 'city'::region_level_enum, 'Turin', 'IT', 'pin'::location_type_enum, ARRAY[7.6869, 45.0703]),
('PL:Katowice', 'city'::region_level_enum, 'Katowice', 'PL', 'pin'::location_type_enum, ARRAY[19.0238, 50.2649]),
('AZ:Baku', 'city'::region_level_enum, 'Baku', 'AZ', 'pin'::location_type_enum, ARRAY[49.8671, 40.4093]),
('MY:Penang', 'city'::region_level_enum, 'Penang', 'MY', 'pin'::location_type_enum, ARRAY[100.3327, 5.4164]),
('TZ:Dar_es_Salaam', 'city'::region_level_enum, 'Dar es Salaam', 'TZ', 'pin'::location_type_enum, ARRAY[39.2083, -6.7924]),
('NZ:Wellington', 'city'::region_level_enum, 'Wellington', 'NZ', 'pin'::location_type_enum, ARRAY[174.7762, -41.2865]),
('NI:Managua', 'city'::region_level_enum, 'Managua', 'NI', 'pin'::location_type_enum, ARRAY[-86.2362, 12.1150]),
('US:Cleveland', 'city'::region_level_enum, 'Cleveland', 'US', 'pin'::location_type_enum, ARRAY[-81.6944, 41.4993]),
('CN:Nanchang', 'city'::region_level_enum, 'Nanchang', 'CN', 'pin'::location_type_enum, ARRAY[115.8581, 28.6832]),
('CN:Changchun', 'city'::region_level_enum, 'Changchun', 'CN', 'pin'::location_type_enum, ARRAY[125.3245, 43.8871]),
('CO:Cali', 'city'::region_level_enum, 'Cali', 'CO', 'pin'::location_type_enum, ARRAY[-76.5225, 3.4516]),
('US:St_Louis', 'city'::region_level_enum, 'St Louis', 'US', 'pin'::location_type_enum, ARRAY[-90.1994, 38.6270]),
('SI:Ljubljana', 'city'::region_level_enum, 'Ljubljana', 'SI', 'pin'::location_type_enum, ARRAY[14.5058, 46.0569]),
('US:Baltimore', 'city'::region_level_enum, 'Baltimore', 'US', 'pin'::location_type_enum, ARRAY[-76.6122, 39.2904]),
('ES:Bilbao', 'city'::region_level_enum, 'Bilbao', 'ES', 'pin'::location_type_enum, ARRAY[-2.9350, 43.2630]),
('FR:Marseille', 'city'::region_level_enum, 'Marseille', 'FR', 'pin'::location_type_enum, ARRAY[5.3698, 43.2965]),
('ID:Surabaya', 'city'::region_level_enum, 'Surabaya', 'ID', 'pin'::location_type_enum, ARRAY[112.7521, -7.2575]),
('GH:Accra', 'city'::region_level_enum, 'Accra', 'GH', 'pin'::location_type_enum, ARRAY[-0.1870, 5.6037]);

-- Skill Tags
-- Poznan (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:poznan',
  'city'::skill_family_enum,
  'PL',
  'Poznan',
  'Fifth-largest city in Poland, located on the Warta River in west-central Poland. Historic trade and educational center, known for its colorful Old Market Square and Renaissance town hall.',
  array[]::text[]
);

-- Labuan (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:labuan',
  'city'::skill_family_enum,
  'MY',
  'Labuan',
  'Federal territory of Malaysia, consisting of the island of Labuan and six smaller islands off the coast of Borneo. Duty-free island and international offshore financial center.',
  array[]::text[]
);

-- Charlotte (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:charlotte',
  'city'::skill_family_enum,
  'US',
  'Charlotte',
  'Largest city in North Carolina, located in the Piedmont region of the southeastern United States. Major financial center, second-largest banking hub in the U.S. after New York City.',
  array[]::text[]
);

-- Pittsburgh (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:pittsburgh',
  'city'::skill_family_enum,
  'US',
  'Pittsburgh',
  'Second-largest city in Pennsylvania, located at the confluence of the Allegheny, Monongahela, and Ohio Rivers. Former steel industry center, now known for healthcare, education, and technology.',
  array[]::text[]
);

-- Valencia (Spain) (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:valencia_spain',
  'city'::skill_family_enum,
  'ES',
  'Valencia (Spain)',
  'Third-largest city in Spain, located on the eastern coast along the Mediterranean Sea. Known for the futuristic City of Arts and Sciences, paella cuisine, and Las Fallas festival.',
  array[]::text[]
);

-- Edinburgh (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:edinburgh',
  'city'::skill_family_enum,
  'GB',
  'Edinburgh',
  'Capital of Scotland and second-most populous city in Scotland, located in southeastern Scotland on the southern shore of the Firth of Forth. Historic city known for Edinburgh Castle, annual festivals, and as a center of education and culture.',
  array[]::text[]
);

-- Jeddah (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:jeddah',
  'city'::skill_family_enum,
  'SA',
  'Jeddah',
  'Second-largest city in Saudi Arabia, located on the Red Sea coast in the Hejaz region. Major commercial hub and gateway for Muslim pilgrims traveling to Mecca and Medina.',
  array[]::text[]
);

-- Turin (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:turin',
  'city'::skill_family_enum,
  'IT',
  'Turin',
  'Fourth-largest city in Italy, located in northwestern Italy at the foot of the western Alps. Former capital of Italy and major automotive center, home to Fiat and known for baroque architecture.',
  array[]::text[]
);

-- Katowice (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:katowice',
  'city'::skill_family_enum,
  'PL',
  'Katowice',
  'Central city of the Silesian Metropolis in southern Poland, located in the Upper Silesian Industrial Region. Major industrial and mining center, now transforming into a business and cultural hub.',
  array[]::text[]
);

-- Baku (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:baku',
  'city'::skill_family_enum,
  'AZ',
  'Baku',
  'Capital and largest city of Azerbaijan, located on the western shore of the Caspian Sea. Ancient city enriched by oil industry, known for the medieval walled Old City and modern Flame Towers.',
  array[]::text[]
);

-- Penang (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:penang',
  'city'::skill_family_enum,
  'MY',
  'Penang',
  'State in northwest Malaysia consisting of Penang Island and a strip of mainland, located on the northwest coast. Known as the "Pearl of the Orient," famous for George Town heritage city and diverse cuisine.',
  array[]::text[]
);

-- Dar es Salaam (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dar_es_salaam',
  'city'::skill_family_enum,
  'TZ',
  'Dar es Salaam',
  'Largest city and former capital of Tanzania, located on the Swahili coast along the Indian Ocean. Major port and commercial center, serving as Tanzania economic hub.',
  array[]::text[]
);

-- Wellington (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:wellington',
  'city'::skill_family_enum,
  'NZ',
  'Wellington',
  'Capital of New Zealand, located at the southwestern tip of the North Island on Cook Strait. Compact city known for government institutions, vibrant arts scene, and being the windiest city in the world.',
  array[]::text[]
);

-- Managua (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:managua',
  'city'::skill_family_enum,
  'NI',
  'Managua',
  'Capital and largest city of Nicaragua, located on the southwestern shore of Lake Managua. Political and economic center, rebuilt multiple times after earthquakes.',
  array[]::text[]
);

-- Cleveland (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cleveland',
  'city'::skill_family_enum,
  'US',
  'Cleveland',
  'Major city in Ohio, located on the southern shore of Lake Erie in the northeastern part of the state. Historic manufacturing center known for the Rock and Roll Hall of Fame and healthcare institutions.',
  array[]::text[]
);

-- Nanchang (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:nanchang',
  'city'::skill_family_enum,
  'CN',
  'Nanchang',
  'Capital of Jiangxi Province in southeastern China, located in the north-central part of the province on the Gan River. Historic city and revolutionary site, known for manufacturing and as a transportation hub.',
  array[]::text[]
);

-- Changchun (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:changchun',
  'city'::skill_family_enum,
  'CN',
  'Changchun',
  'Capital of Jilin Province in northeastern China, located in the center of the Songliao Plain. Known as China automotive industry center, home to major car manufacturers.',
  array[]::text[]
);

-- Cali (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cali',
  'city'::skill_family_enum,
  'CO',
  'Cali',
  'Third-largest city in Colombia, located in southwestern Colombia in the Cauca River valley. Known as the "Salsa Capital of the World," major economic and cultural center of southwestern Colombia.',
  array[]::text[]
);

-- St Louis (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:st_louis',
  'city'::skill_family_enum,
  'US',
  'St Louis',
  'Major city in Missouri, located on the western bank of the Mississippi River on the border with Illinois. Historic gateway to the American West, known for the Gateway Arch and brewing heritage.',
  array[]::text[]
);

-- Ljubljana (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:ljubljana',
  'city'::skill_family_enum,
  'SI',
  'Ljubljana',
  'Capital and largest city of Slovenia, located in central Slovenia along the Ljubljanica River. Green city known for its university, baroque and Art Nouveau architecture, and medieval Ljubljana Castle.',
  array[]::text[]
);

-- Baltimore (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:baltimore',
  'city'::skill_family_enum,
  'US',
  'Baltimore',
  'Largest city in Maryland, located in the north-central part of the state near the Chesapeake Bay. Historic port city known for its Inner Harbor, maritime heritage, and medical institutions like Johns Hopkins.',
  array[]::text[]
);

-- Bilbao (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:bilbao',
  'city'::skill_family_enum,
  'ES',
  'Bilbao',
  'Largest city in the Basque Country in northern Spain, located along the Nervion River near the Bay of Biscay. Industrial city transformed by the Guggenheim Museum Bilbao, now a major cultural and economic center.',
  array[]::text[]
);

-- Marseille (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:marseille',
  'city'::skill_family_enum,
  'FR',
  'Marseille',
  'Second-largest city in France, located on the Mediterranean coast in southern France. France oldest city and largest port, known for its multicultural character, old port, and bouillabaisse.',
  array[]::text[]
);

-- Surabaya (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:surabaya',
  'city'::skill_family_enum,
  'ID',
  'Surabaya',
  'Second-largest city in Indonesia and capital of East Java, located on the northeastern coast of Java island. Major port and industrial center, known as the "City of Heroes" for its role in Indonesian independence.',
  array[]::text[]
);

-- Accra (Gamma-)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:accra',
  'city'::skill_family_enum,
  'GH',
  'Accra',
  'Capital and largest city of Ghana, located on the Gulf of Guinea on the Atlantic coast of West Africa. Economic and administrative center, known for its vibrant culture, colonial architecture, and as a major African hub.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Poznan',
  'Gamma- tier city',
  array['city:poznan'],
  '2',
  (select id from regions where key = 'PL:Poznan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Labuan',
  'Gamma- tier city',
  array['city:labuan'],
  '2',
  (select id from regions where key = 'MY:Labuan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Charlotte',
  'Gamma- tier city',
  array['city:charlotte'],
  '2',
  (select id from regions where key = 'US:Charlotte')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Pittsburgh',
  'Gamma- tier city',
  array['city:pittsburgh'],
  '2',
  (select id from regions where key = 'US:Pittsburgh')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Valencia (Spain)',
  'Gamma- tier city',
  array['city:valencia_spain'],
  '2',
  (select id from regions where key = 'ES:Valencia')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Edinburgh',
  'Gamma- tier city',
  array['city:edinburgh'],
  '2',
  (select id from regions where key = 'GB:Edinburgh')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Jeddah',
  'Gamma- tier city',
  array['city:jeddah'],
  '2',
  (select id from regions where key = 'SA:Jeddah')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Turin',
  'Gamma- tier city',
  array['city:turin'],
  '2',
  (select id from regions where key = 'IT:Turin')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Katowice',
  'Gamma- tier city',
  array['city:katowice'],
  '2',
  (select id from regions where key = 'PL:Katowice')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baku',
  'Gamma- tier city',
  array['city:baku'],
  '2',
  (select id from regions where key = 'AZ:Baku')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Penang',
  'Gamma- tier city',
  array['city:penang'],
  '2',
  (select id from regions where key = 'MY:Penang')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Dar es Salaam',
  'Gamma- tier city',
  array['city:dar_es_salaam'],
  '2',
  (select id from regions where key = 'TZ:Dar_es_Salaam')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Wellington',
  'Gamma- tier city',
  array['city:wellington'],
  '2',
  (select id from regions where key = 'NZ:Wellington')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Managua',
  'Gamma- tier city',
  array['city:managua'],
  '2',
  (select id from regions where key = 'NI:Managua')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cleveland',
  'Gamma- tier city',
  array['city:cleveland'],
  '2',
  (select id from regions where key = 'US:Cleveland')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Nanchang',
  'Gamma- tier city',
  array['city:nanchang'],
  '2',
  (select id from regions where key = 'CN:Nanchang')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Changchun',
  'Gamma- tier city',
  array['city:changchun'],
  '2',
  (select id from regions where key = 'CN:Changchun')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cali',
  'Gamma- tier city',
  array['city:cali'],
  '2',
  (select id from regions where key = 'CO:Cali')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'St Louis',
  'Gamma- tier city',
  array['city:st_louis'],
  '2',
  (select id from regions where key = 'US:St_Louis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Ljubljana',
  'Gamma- tier city',
  array['city:ljubljana'],
  '2',
  (select id from regions where key = 'SI:Ljubljana')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baltimore',
  'Gamma- tier city',
  array['city:baltimore'],
  '2',
  (select id from regions where key = 'US:Baltimore')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Bilbao',
  'Gamma- tier city',
  array['city:bilbao'],
  '2',
  (select id from regions where key = 'ES:Bilbao')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Marseille',
  'Gamma- tier city',
  array['city:marseille'],
  '2',
  (select id from regions where key = 'FR:Marseille')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Surabaya',
  'Gamma- tier city',
  array['city:surabaya'],
  '2',
  (select id from regions where key = 'ID:Surabaya')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Accra',
  'Gamma- tier city',
  array['city:accra'],
  '2',
  (select id from regions where key = 'GH:Accra')
);

-- ============================================

-- HIGH SUFFICIENCY CITIES (26 cities)
-- ============================================

-- Pin Regions
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('TR:Izmir', 'city'::region_level_enum, 'Izmir', 'TR', 'pin'::location_type_enum, ARRAY[27.1428, 38.4237]),
('ZW:Harare', 'city'::region_level_enum, 'Harare', 'ZW', 'pin'::location_type_enum, ARRAY[31.0492, -17.8292]),
('MZ:Maputo', 'city'::region_level_enum, 'Maputo', 'MZ', 'pin'::location_type_enum, ARRAY[32.5892, -25.9655]),
('LT:Vilnius', 'city'::region_level_enum, 'Vilnius', 'LT', 'pin'::location_type_enum, ARRAY[25.2797, 54.6872]),
('MO:Macao', 'city'::region_level_enum, 'Macao', 'MO', 'pin'::location_type_enum, ARRAY[113.5439, 22.1987]),
('SE:Gothenburg', 'city'::region_level_enum, 'Gothenburg', 'SE', 'pin'::location_type_enum, ARRAY[11.9746, 57.7089]),
('US:Raleigh', 'city'::region_level_enum, 'Raleigh', 'US', 'pin'::location_type_enum, ARRAY[-78.6382, 35.7796]),
('MX:Queretaro', 'city'::region_level_enum, 'Queretaro', 'MX', 'pin'::location_type_enum, ARRAY[-100.3899, 20.5888]),
('GB:Glasgow', 'city'::region_level_enum, 'Glasgow', 'GB', 'pin'::location_type_enum, ARRAY[-4.2518, 55.8642]),
('CN:Zhuhai', 'city'::region_level_enum, 'Zhuhai', 'CN', 'pin'::location_type_enum, ARRAY[113.5767, 22.2769]),
('US:Phoenix', 'city'::region_level_enum, 'Phoenix', 'US', 'pin'::location_type_enum, ARRAY[-112.0740, 33.4484]),
('SN:Dakar', 'city'::region_level_enum, 'Dakar', 'SN', 'pin'::location_type_enum, ARRAY[-17.4677, 14.7167]),
('US:Cincinnati', 'city'::region_level_enum, 'Cincinnati', 'US', 'pin'::location_type_enum, ARRAY[-84.5120, 39.1031]),
('MK:Skopje', 'city'::region_level_enum, 'Skopje', 'MK', 'pin'::location_type_enum, ARRAY[21.4254, 41.9973]),
('US:Kansas_City', 'city'::region_level_enum, 'Kansas City', 'US', 'pin'::location_type_enum, ARRAY[-94.5786, 39.0997]),
('CY:Limassol', 'city'::region_level_enum, 'Limassol', 'CY', 'pin'::location_type_enum, ARRAY[33.0333, 34.6841]),
('BO:La_Paz', 'city'::region_level_enum, 'La Paz', 'BO', 'pin'::location_type_enum, ARRAY[-68.1193, -16.4897]),
('GB:Leeds', 'city'::region_level_enum, 'Leeds', 'GB', 'pin'::location_type_enum, ARRAY[-1.5491, 53.8008]),
('EC:Guayaquil', 'city'::region_level_enum, 'Guayaquil', 'EC', 'pin'::location_type_enum, ARRAY[-79.8971, -2.1894]),
('US:Hartford', 'city'::region_level_enum, 'Hartford', 'US', 'pin'::location_type_enum, ARRAY[-72.6851, 41.7658]),
('GB:Belfast', 'city'::region_level_enum, 'Belfast', 'GB', 'pin'::location_type_enum, ARRAY[-5.9301, 54.5973]),
('US:Indianapolis', 'city'::region_level_enum, 'Indianapolis', 'US', 'pin'::location_type_enum, ARRAY[-86.1581, 39.7684]),
('DZ:Algiers', 'city'::region_level_enum, 'Algiers', 'DZ', 'pin'::location_type_enum, ARRAY[3.0588, 36.7538]),
('CN:Shijiazhuang', 'city'::region_level_enum, 'Shijiazhuang', 'CN', 'pin'::location_type_enum, ARRAY[114.4995, 38.0428]),
('ZM:Lusaka', 'city'::region_level_enum, 'Lusaka', 'ZM', 'pin'::location_type_enum, ARRAY[28.2871, -15.4167]),
('MX:Guadalajara', 'city'::region_level_enum, 'Guadalajara', 'MX', 'pin'::location_type_enum, ARRAY[-103.3496, 20.6597]);

-- Skill Tags
-- Izmir (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:izmir',
  'city'::skill_family_enum,
  'TR',
  'Izmir',
  'Third largest city in Turkey and major port city on the Aegean Sea coast. Important economic and cultural center with a rich history dating back to ancient times as Smyrna.',
  array[]::text[]
);

-- Harare (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:harare',
  'city'::skill_family_enum,
  'ZW',
  'Harare',
  'Capital and largest city of Zimbabwe, located in the northeast of the country. Major commercial and financial center serving as the countrys administrative and economic hub.',
  array[]::text[]
);

-- Maputo (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:maputo',
  'city'::skill_family_enum,
  'MZ',
  'Maputo',
  'Capital and largest city of Mozambique, situated on Maputo Bay on the Indian Ocean. Major port city and economic center of southern Mozambique with a diverse cultural heritage.',
  array[]::text[]
);

-- Vilnius (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:vilnius',
  'city'::skill_family_enum,
  'LT',
  'Vilnius',
  'Capital and largest city of Lithuania, located in the southeastern part of the country. Historic city with a well-preserved medieval old town and growing modern business district.',
  array[]::text[]
);

-- Macao (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:macao',
  'city'::skill_family_enum,
  'MO',
  'Macao',
  'Special Administrative Region of China on the southern coast, known as the gambling capital of Asia. Former Portuguese colony with unique blend of Chinese and Portuguese cultural influences.',
  array[]::text[]
);

-- Gothenburg (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:gothenburg',
  'city'::skill_family_enum,
  'SE',
  'Gothenburg',
  'Second largest city in Sweden, located on the west coast at the mouth of the Gota River. Major Scandinavian port and industrial center with a strong maritime heritage.',
  array[]::text[]
);

-- Raleigh (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:raleigh',
  'city'::skill_family_enum,
  'US',
  'Raleigh',
  'Capital of North Carolina and anchor of the Research Triangle metropolitan region. Growing technology and research hub known for its universities and quality of life.',
  array[]::text[]
);

-- Queretaro (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:queretaro',
  'city'::skill_family_enum,
  'MX',
  'Queretaro',
  'City in central Mexico, capital of Queretaro state, located northwest of Mexico City. Growing industrial and aerospace manufacturing hub with well-preserved colonial architecture.',
  array[]::text[]
);

-- Glasgow (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:glasgow',
  'city'::skill_family_enum,
  'GB',
  'Glasgow',
  'Largest city in Scotland, located on the River Clyde in the countrys west central lowlands. Former industrial powerhouse transformed into a major cultural and commercial center.',
  array[]::text[]
);

-- Zhuhai (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:zhuhai',
  'city'::skill_family_enum,
  'CN',
  'Zhuhai',
  'Coastal city in Guangdong Province, southern China, located at the mouth of the Pearl River. Special Economic Zone with modern development, directly bordering Macao.',
  array[]::text[]
);

-- Phoenix (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:phoenix',
  'city'::skill_family_enum,
  'US',
  'Phoenix',
  'Capital and largest city of Arizona, located in the Salt River Valley in the Sonoran Desert. Rapidly growing metropolis and major center for technology, manufacturing, and winter tourism.',
  array[]::text[]
);

-- Dakar (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dakar',
  'city'::skill_family_enum,
  'SN',
  'Dakar',
  'Capital and largest city of Senegal, located on the Cap-Vert peninsula on the Atlantic coast. Major West African port and economic center, the westernmost city on the African mainland.',
  array[]::text[]
);

-- Cincinnati (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cincinnati',
  'city'::skill_family_enum,
  'US',
  'Cincinnati',
  'City in southwestern Ohio located on the Ohio River at the border with Kentucky. Historic manufacturing center with a diverse economy including Fortune 500 headquarters.',
  array[]::text[]
);

-- Skopje (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:skopje',
  'city'::skill_family_enum,
  'MK',
  'Skopje',
  'Capital and largest city of North Macedonia, located in the Skopje Valley on the Vardar River. Political, economic, and cultural center of the country, rebuilt after a devastating 1963 earthquake.',
  array[]::text[]
);

-- Kansas City (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:kansas_city',
  'city'::skill_family_enum,
  'US',
  'Kansas City',
  'Major city in Missouri, located at the confluence of the Kansas and Missouri rivers. Historic center of commerce and transportation, straddling the Missouri-Kansas border.',
  array[]::text[]
);

-- Limassol (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:limassol',
  'city'::skill_family_enum,
  'CY',
  'Limassol',
  'Second largest city in Cyprus, located on the southern coast on Akrotiri Bay. Major port and resort city, important business and financial center of Cyprus.',
  array[]::text[]
);

-- La Paz (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:la_paz',
  'city'::skill_family_enum,
  'BO',
  'La Paz',
  'Administrative capital of Bolivia, located in west-central Bolivia at approximately 3,650 meters elevation. Highest administrative capital in the world, major economic and cultural center of Bolivia.',
  array[]::text[]
);

-- Leeds (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:leeds',
  'city'::skill_family_enum,
  'GB',
  'Leeds',
  'Major city in West Yorkshire, England, located on the River Aire in the eastern Pennine foothills. Important center for business, finance, retail, and culture in northern England.',
  array[]::text[]
);

-- Guayaquil (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guayaquil',
  'city'::skill_family_enum,
  'EC',
  'Guayaquil',
  'Largest and most populous city of Ecuador, located on the Guayas River on the Pacific coast. Main port and commercial center of Ecuador, driving much of the countrys economy.',
  array[]::text[]
);

-- Hartford (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hartford',
  'city'::skill_family_enum,
  'US',
  'Hartford',
  'Capital of Connecticut, located in the north-central part of the state on the Connecticut River. Historic center of the American insurance industry with a rich colonial history.',
  array[]::text[]
);

-- Belfast (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:belfast',
  'city'::skill_family_enum,
  'GB',
  'Belfast',
  'Capital and largest city of Northern Ireland, located on the River Lagan on the northeast coast. Industrial city with a complex history, undergoing significant regeneration and economic development.',
  array[]::text[]
);

-- Indianapolis (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:indianapolis',
  'city'::skill_family_enum,
  'US',
  'Indianapolis',
  'Capital and largest city of Indiana, located in the central part of the state. Major center for business, education, and culture, famous for hosting the Indianapolis 500 race.',
  array[]::text[]
);

-- Algiers (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:algiers',
  'city'::skill_family_enum,
  'DZ',
  'Algiers',
  'Capital and largest city of Algeria, located on the Mediterranean Sea on the north-central coast. Major North African port and economic center with a historic Casbah district.',
  array[]::text[]
);

-- Shijiazhuang (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:shijiazhuang',
  'city'::skill_family_enum,
  'CN',
  'Shijiazhuang',
  'Capital of Hebei Province in north China, located southwest of Beijing in the North China Plain. Major pharmaceutical manufacturing center and transportation hub in northern China.',
  array[]::text[]
);

-- Lusaka (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:lusaka',
  'city'::skill_family_enum,
  'ZM',
  'Lusaka',
  'Capital and largest city of Zambia, located in the south-central part of the country. Fast-growing commercial and financial center, serving as the political heart of Zambia.',
  array[]::text[]
);

-- Guadalajara (High sufficiency)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guadalajara',
  'city'::skill_family_enum,
  'MX',
  'Guadalajara',
  'Second largest city in Mexico, located in the state of Jalisco in western Mexico. Important cultural center known as the birthplace of mariachi music and tequila production.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Izmir',
  'High sufficiency tier city',
  array['city:izmir'],
  '2',
  (select id from regions where key = 'TR:Izmir')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Harare',
  'High sufficiency tier city',
  array['city:harare'],
  '2',
  (select id from regions where key = 'ZW:Harare')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Maputo',
  'High sufficiency tier city',
  array['city:maputo'],
  '2',
  (select id from regions where key = 'MZ:Maputo')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Vilnius',
  'High sufficiency tier city',
  array['city:vilnius'],
  '2',
  (select id from regions where key = 'LT:Vilnius')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Macao',
  'High sufficiency tier city',
  array['city:macao'],
  '2',
  (select id from regions where key = 'MO:Macao')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Gothenburg',
  'High sufficiency tier city',
  array['city:gothenburg'],
  '2',
  (select id from regions where key = 'SE:Gothenburg')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Raleigh',
  'High sufficiency tier city',
  array['city:raleigh'],
  '2',
  (select id from regions where key = 'US:Raleigh')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Queretaro',
  'High sufficiency tier city',
  array['city:queretaro'],
  '2',
  (select id from regions where key = 'MX:Queretaro')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Glasgow',
  'High sufficiency tier city',
  array['city:glasgow'],
  '2',
  (select id from regions where key = 'GB:Glasgow')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Zhuhai',
  'High sufficiency tier city',
  array['city:zhuhai'],
  '2',
  (select id from regions where key = 'CN:Zhuhai')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Phoenix',
  'High sufficiency tier city',
  array['city:phoenix'],
  '2',
  (select id from regions where key = 'US:Phoenix')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Dakar',
  'High sufficiency tier city',
  array['city:dakar'],
  '2',
  (select id from regions where key = 'SN:Dakar')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Cincinnati',
  'High sufficiency tier city',
  array['city:cincinnati'],
  '2',
  (select id from regions where key = 'US:Cincinnati')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Skopje',
  'High sufficiency tier city',
  array['city:skopje'],
  '2',
  (select id from regions where key = 'MK:Skopje')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Kansas City',
  'High sufficiency tier city',
  array['city:kansas_city'],
  '2',
  (select id from regions where key = 'US:Kansas_City')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Limassol',
  'High sufficiency tier city',
  array['city:limassol'],
  '2',
  (select id from regions where key = 'CY:Limassol')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'La Paz',
  'High sufficiency tier city',
  array['city:la_paz'],
  '2',
  (select id from regions where key = 'BO:La_Paz')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Leeds',
  'High sufficiency tier city',
  array['city:leeds'],
  '2',
  (select id from regions where key = 'GB:Leeds')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guayaquil',
  'High sufficiency tier city',
  array['city:guayaquil'],
  '2',
  (select id from regions where key = 'EC:Guayaquil')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Hartford',
  'High sufficiency tier city',
  array['city:hartford'],
  '2',
  (select id from regions where key = 'US:Hartford')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Belfast',
  'High sufficiency tier city',
  array['city:belfast'],
  '2',
  (select id from regions where key = 'GB:Belfast')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Indianapolis',
  'High sufficiency tier city',
  array['city:indianapolis'],
  '2',
  (select id from regions where key = 'US:Indianapolis')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Algiers',
  'High sufficiency tier city',
  array['city:algiers'],
  '2',
  (select id from regions where key = 'DZ:Algiers')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Shijiazhuang',
  'High sufficiency tier city',
  array['city:shijiazhuang'],
  '2',
  (select id from regions where key = 'CN:Shijiazhuang')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Lusaka',
  'High sufficiency tier city',
  array['city:lusaka'],
  '2',
  (select id from regions where key = 'ZM:Lusaka')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guadalajara',
  'High sufficiency tier city',
  array['city:guadalajara'],
  '2',
  (select id from regions where key = 'MX:Guadalajara')
);

-- ============================================
