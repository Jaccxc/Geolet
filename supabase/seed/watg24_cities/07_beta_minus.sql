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
  'Beta- tier global city',
  array['city:qingdao'],
  '2',
  (select id from regions where key = 'CN:Qingdao')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Casablanca',
  'Beta- tier global city',
  array['city:casablanca'],
  '2',
  (select id from regions where key = 'MA:Casablanca')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Changsha',
  'Beta- tier global city',
  array['city:changsha'],
  '2',
  (select id from regions where key = 'CN:Changsha')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Beirut',
  'Beta- tier global city',
  array['city:beirut'],
  '2',
  (select id from regions where key = 'LB:Beirut')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Port Louis',
  'Beta- tier global city',
  array['city:port_louis'],
  '2',
  (select id from regions where key = 'MU:Port_Louis')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Denver',
  'Beta- tier global city',
  array['city:denver'],
  '2',
  (select id from regions where key = 'US:Denver')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lagos',
  'Beta- tier global city',
  array['city:lagos'],
  '2',
  (select id from regions where key = 'NG:Lagos')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Belgrade',
  'Beta- tier global city',
  array['city:belgrade'],
  '2',
  (select id from regions where key = 'RS:Belgrade')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Montevideo',
  'Beta- tier global city',
  array['city:montevideo'],
  '2',
  (select id from regions where key = 'UY:Montevideo')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Vancouver',
  'Beta- tier global city',
  array['city:vancouver'],
  '2',
  (select id from regions where key = 'CA:Vancouver')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Seattle',
  'Beta- tier global city',
  array['city:seattle'],
  '2',
  (select id from regions where key = 'US:Seattle')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Manchester',
  'Beta- tier global city',
  array['city:manchester'],
  '2',
  (select id from regions where key = 'GB:Manchester')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Sofia',
  'Beta- tier global city',
  array['city:sofia'],
  '2',
  (select id from regions where key = 'BG:Sofia')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Bratislava',
  'Beta- tier global city',
  array['city:bratislava'],
  '2',
  (select id from regions where key = 'SK:Bratislava')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Rio de Janeiro',
  'Beta- tier global city',
  array['city:rio_de_janeiro'],
  '2',
  (select id from regions where key = 'BR:Rio_de_Janeiro')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Lyon',
  'Beta- tier global city',
  array['city:lyon'],
  '2',
  (select id from regions where key = 'FR:Lyon')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Xi’an',
  'Beta- tier global city',
  array['city:xian'],
  '2',
  (select id from regions where key = 'CN:Xian')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Helsinki',
  'Beta- tier global city',
  array['city:helsinki'],
  '2',
  (select id from regions where key = 'FI:Helsinki')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Kunming',
  'Beta- tier global city',
  array['city:kunming'],
  '2',
  (select id from regions where key = 'CN:Kunming')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Zagreb',
  'Beta- tier global city',
  array['city:zagreb'],
  '2',
  (select id from regions where key = 'HR:Zagreb')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Nicosia',
  'Beta- tier global city',
  array['city:nicosia'],
  '2',
  (select id from regions where key = 'CY:Nicosia')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Karachi',
  'Beta- tier global city',
  array['city:karachi'],
  '2',
  (select id from regions where key = 'PK:Karachi')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Caracas',
  'Beta- tier global city',
  array['city:caracas'],
  '2',
  (select id from regions where key = 'VE:Caracas')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Hefei',
  'Beta- tier global city',
  array['city:hefei'],
  '2',
  (select id from regions where key = 'CN:Hefei')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Stuttgart',
  'Beta- tier global city',
  array['city:stuttgart'],
  '2',
  (select id from regions where key = 'DE:Stuttgart')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Panama City',
  'Beta- tier global city',
  array['city:panama_city'],
  '2',
  (select id from regions where key = 'PA:Panama_City')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Chennai',
  'Beta- tier global city',
  array['city:chennai'],
  '2',
  (select id from regions where key = 'IN:Chennai')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_minus'),
  'Philadelphia',
  'Beta- tier global city',
  array['city:philadelphia'],
  '2',
  (select id from regions where key = 'US:Philadelphia')
);

-- ============================================
