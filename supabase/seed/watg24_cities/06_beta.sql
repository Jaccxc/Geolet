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
