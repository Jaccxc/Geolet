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

