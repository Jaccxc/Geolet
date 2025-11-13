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
  'High sufficiency tier global city',
  array['city:izmir'],
  '2',
  (select id from regions where key = 'TR:Izmir')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Harare',
  'High sufficiency tier global city',
  array['city:harare'],
  '2',
  (select id from regions where key = 'ZW:Harare')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Maputo',
  'High sufficiency tier global city',
  array['city:maputo'],
  '2',
  (select id from regions where key = 'MZ:Maputo')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Vilnius',
  'High sufficiency tier global city',
  array['city:vilnius'],
  '2',
  (select id from regions where key = 'LT:Vilnius')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Macao',
  'High sufficiency tier global city',
  array['city:macao'],
  '2',
  (select id from regions where key = 'MO:Macao')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Gothenburg',
  'High sufficiency tier global city',
  array['city:gothenburg'],
  '2',
  (select id from regions where key = 'SE:Gothenburg')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Raleigh',
  'High sufficiency tier global city',
  array['city:raleigh'],
  '2',
  (select id from regions where key = 'US:Raleigh')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Queretaro',
  'High sufficiency tier global city',
  array['city:queretaro'],
  '2',
  (select id from regions where key = 'MX:Queretaro')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Glasgow',
  'High sufficiency tier global city',
  array['city:glasgow'],
  '2',
  (select id from regions where key = 'GB:Glasgow')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Zhuhai',
  'High sufficiency tier global city',
  array['city:zhuhai'],
  '2',
  (select id from regions where key = 'CN:Zhuhai')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Phoenix',
  'High sufficiency tier global city',
  array['city:phoenix'],
  '2',
  (select id from regions where key = 'US:Phoenix')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Dakar',
  'High sufficiency tier global city',
  array['city:dakar'],
  '2',
  (select id from regions where key = 'SN:Dakar')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Cincinnati',
  'High sufficiency tier global city',
  array['city:cincinnati'],
  '2',
  (select id from regions where key = 'US:Cincinnati')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Skopje',
  'High sufficiency tier global city',
  array['city:skopje'],
  '2',
  (select id from regions where key = 'MK:Skopje')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Kansas City',
  'High sufficiency tier global city',
  array['city:kansas_city'],
  '2',
  (select id from regions where key = 'US:Kansas_City')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Limassol',
  'High sufficiency tier global city',
  array['city:limassol'],
  '2',
  (select id from regions where key = 'CY:Limassol')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'La Paz',
  'High sufficiency tier global city',
  array['city:la_paz'],
  '2',
  (select id from regions where key = 'BO:La_Paz')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Leeds',
  'High sufficiency tier global city',
  array['city:leeds'],
  '2',
  (select id from regions where key = 'GB:Leeds')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guayaquil',
  'High sufficiency tier global city',
  array['city:guayaquil'],
  '2',
  (select id from regions where key = 'EC:Guayaquil')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Hartford',
  'High sufficiency tier global city',
  array['city:hartford'],
  '2',
  (select id from regions where key = 'US:Hartford')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Belfast',
  'High sufficiency tier global city',
  array['city:belfast'],
  '2',
  (select id from regions where key = 'GB:Belfast')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Indianapolis',
  'High sufficiency tier global city',
  array['city:indianapolis'],
  '2',
  (select id from regions where key = 'US:Indianapolis')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Algiers',
  'High sufficiency tier global city',
  array['city:algiers'],
  '2',
  (select id from regions where key = 'DZ:Algiers')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Shijiazhuang',
  'High sufficiency tier global city',
  array['city:shijiazhuang'],
  '2',
  (select id from regions where key = 'CN:Shijiazhuang')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Lusaka',
  'High sufficiency tier global city',
  array['city:lusaka'],
  '2',
  (select id from regions where key = 'ZM:Lusaka')
),

(
  (select id from card_groups where name = 'cities_watg24_high_sufficiency'),
  'Guadalajara',
  'High sufficiency tier global city',
  array['city:guadalajara'],
  '2',
  (select id from regions where key = 'MX:Guadalajara')
);

-- ============================================
