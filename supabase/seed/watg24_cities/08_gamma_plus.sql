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
  'Capital and largest city of Tunisia, located on the Mediterranean coast in northern Tunisia. Ancient city with over 2,000 years of history, known for its medina and proximity to the ruins of Carthage.'
  array[]::text[]
);

-- Fuzhou (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:fuzhou',
  'city'::skill_family_enum,
  'CN',
  'Fuzhou',
  'Capital of Fujian Province in southeastern China, located on the Min River near the East China Sea. Historic port city and gateway to Taiwan, known for its hot springs and as the origin of many overseas Chinese.'
  array[]::text[]
);

-- Guatemala City (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:guatemala_city',
  'city'::skill_family_enum,
  'GT',
  'Guatemala City',
  'Capital and largest city of Guatemala, located in the south-central part of the country in the Valley of the Ermita. Political and economic center of Central America's most populous country, surrounded by volcanoes.'
  array[]::text[]
);

-- Hyderabad (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:hyderabad',
  'city'::skill_family_enum,
  'IN',
  'Hyderabad',
  'Fourth-largest city in India and capital of Telangana state, located on the Deccan Plateau in southern India. Major IT and pharmaceutical hub, known as "Cyberabad" for its booming technology industry and historic sites like Charminar.'
  array[]::text[]
);

-- Cape Town (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:cape_town',
  'city'::skill_family_enum,
  'ZA',
  'Cape Town',
  'Legislative capital of South Africa and second-largest city, located on the southwestern coast at the foot of Table Mountain. Known for its harbor, natural beauty, and as one of the most diverse cities in Africa.'
  array[]::text[]
);

-- Dhaka (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:dhaka',
  'city'::skill_family_enum,
  'BD',
  'Dhaka',
  'Capital and largest city of Bangladesh, located in the central part of the country on the Buriganga River. One of the world's most densely populated cities, serving as Bangladesh's economic and cultural center.'
  array[]::text[]
);

-- Porto (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:porto',
  'city'::skill_family_enum,
  'PT',
  'Porto',
  'Second-largest city in Portugal, located in the northwest along the Douro River estuary on the Atlantic coast. Historic city known for port wine production, baroque architecture, and its UNESCO World Heritage historic center.'
  array[]::text[]
);

-- Austin (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:austin',
  'city'::skill_family_enum,
  'US',
  'Austin',
  'Capital of Texas, located in the central part of the state along the Colorado River. Known as the "Live Music Capital of the World" and major center for technology companies, with a vibrant cultural scene.'
  array[]::text[]
);

-- San Diego (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:san_diego',
  'city'::skill_family_enum,
  'US',
  'San Diego',
  'Second-largest city in California, located on the Pacific coast in the southwestern corner of the United States near the Mexican border. Major military and defense center, known for beaches, mild climate, and maritime heritage.'
  array[]::text[]
);

-- Minneapolis (Gamma+)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:minneapolis',
  'city'::skill_family_enum,
  'US',
  'Minneapolis',
  'Largest city in Minnesota, located in the north-central United States along both banks of the Mississippi River. Part of the Twin Cities with St. Paul, known for lakes, parks, and cultural institutions.'
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
  'Capital and largest city of Jordan, located in the northwest of the country on a hilly area in northwestern Jordan. Ancient city built on seven hills, serving as Jordan'''s political, cultural, and commercial center.',
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
  'Second-largest city in the Netherlands, located in South Holland province at the mouth of the Nieuwe Maas channel. Home to Europe'''s largest seaport, known for modern architecture after World War II reconstruction.',
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
  'Capital and largest city of Kuwait, located on Kuwait Bay in the Persian Gulf. Modern city enriched by oil wealth, serving as Kuwait'''s political and economic center with a major port.',
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
  (select id from regions where key = 'TN:Tunis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Fuzhou',
  'Gamma+ tier global city',
  array['city:fuzhou'],
  '2',
  (select id from regions where key = 'CN:Fuzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Guatemala City',
  'Gamma+ tier global city',
  array['city:guatemala_city'],
  '2',
  (select id from regions where key = 'GT:Guatemala_City')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Hyderabad',
  'Gamma+ tier global city',
  array['city:hyderabad'],
  '2',
  (select id from regions where key = 'IN:Hyderabad')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Cape Town',
  'Gamma+ tier global city',
  array['city:cape_town'],
  '2',
  (select id from regions where key = 'ZA:Cape_Town')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Dhaka',
  'Gamma+ tier global city',
  array['city:dhaka'],
  '2',
  (select id from regions where key = 'BD:Dhaka')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Porto',
  'Gamma+ tier global city',
  array['city:porto'],
  '2',
  (select id from regions where key = 'PT:Porto')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Austin',
  'Gamma+ tier global city',
  array['city:austin'],
  '2',
  (select id from regions where key = 'US:Austin')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'San Diego',
  'Gamma+ tier global city',
  array['city:san_diego'],
  '2',
  (select id from regions where key = 'US:San_Diego')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Minneapolis',
  'Gamma+ tier global city',
  array['city:minneapolis'],
  '2',
  (select id from regions where key = 'US:Minneapolis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Antwerp',
  'Gamma+ tier global city',
  array['city:antwerp'],
  '2',
  (select id from regions where key = 'BE:Antwerp')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Almaty',
  'Gamma+ tier global city',
  array['city:almaty'],
  '2',
  (select id from regions where key = 'KZ:Almaty')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Amman',
  'Gamma+ tier global city',
  array['city:amman'],
  '2',
  (select id from regions where key = 'JO:Amman')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Santo Domingo',
  'Gamma+ tier global city',
  array['city:santo_domingo'],
  '2',
  (select id from regions where key = 'DO:Santo_Domingo')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Rotterdam',
  'Gamma+ tier global city',
  array['city:rotterdam'],
  '2',
  (select id from regions where key = 'NL:Rotterdam')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Adelaide',
  'Gamma+ tier global city',
  array['city:adelaide'],
  '2',
  (select id from regions where key = 'AU:Adelaide')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Lahore',
  'Gamma+ tier global city',
  array['city:lahore'],
  '2',
  (select id from regions where key = 'PK:Lahore')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Colombo',
  'Gamma+ tier global city',
  array['city:colombo'],
  '2',
  (select id from regions where key = 'LK:Colombo')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Taiyuan',
  'Gamma+ tier global city',
  array['city:taiyuan'],
  '2',
  (select id from regions where key = 'CN:Taiyuan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_plus'),
  'Kuwait City',
  'Gamma+ tier global city',
  array['city:kuwait_city'],
  '2',
  (select id from regions where key = 'KW:Kuwait_City')
);

-- ============================================
