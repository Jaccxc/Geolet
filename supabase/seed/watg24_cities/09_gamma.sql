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
  'Capital of Hainan Province in southern China, located on the northern coast of Hainan Island in the South China Sea. Tropical port city and gateway to China'''s largest special economic zone on Hainan Island.',
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
