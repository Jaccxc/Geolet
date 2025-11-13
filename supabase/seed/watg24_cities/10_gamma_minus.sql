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
  'Gamma- tier global city',
  array['city:poznan'],
  '2',
  (select id from regions where key = 'PL:Poznan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Labuan',
  'Gamma- tier global city',
  array['city:labuan'],
  '2',
  (select id from regions where key = 'MY:Labuan')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Charlotte',
  'Gamma- tier global city',
  array['city:charlotte'],
  '2',
  (select id from regions where key = 'US:Charlotte')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Pittsburgh',
  'Gamma- tier global city',
  array['city:pittsburgh'],
  '2',
  (select id from regions where key = 'US:Pittsburgh')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Valencia (Spain)',
  'Gamma- tier global city',
  array['city:valencia_spain'],
  '2',
  (select id from regions where key = 'ES:Valencia')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Edinburgh',
  'Gamma- tier global city',
  array['city:edinburgh'],
  '2',
  (select id from regions where key = 'GB:Edinburgh')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Jeddah',
  'Gamma- tier global city',
  array['city:jeddah'],
  '2',
  (select id from regions where key = 'SA:Jeddah')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Turin',
  'Gamma- tier global city',
  array['city:turin'],
  '2',
  (select id from regions where key = 'IT:Turin')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Katowice',
  'Gamma- tier global city',
  array['city:katowice'],
  '2',
  (select id from regions where key = 'PL:Katowice')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baku',
  'Gamma- tier global city',
  array['city:baku'],
  '2',
  (select id from regions where key = 'AZ:Baku')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Penang',
  'Gamma- tier global city',
  array['city:penang'],
  '2',
  (select id from regions where key = 'MY:Penang')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Dar es Salaam',
  'Gamma- tier global city',
  array['city:dar_es_salaam'],
  '2',
  (select id from regions where key = 'TZ:Dar_es_Salaam')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Wellington',
  'Gamma- tier global city',
  array['city:wellington'],
  '2',
  (select id from regions where key = 'NZ:Wellington')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Managua',
  'Gamma- tier global city',
  array['city:managua'],
  '2',
  (select id from regions where key = 'NI:Managua')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cleveland',
  'Gamma- tier global city',
  array['city:cleveland'],
  '2',
  (select id from regions where key = 'US:Cleveland')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Nanchang',
  'Gamma- tier global city',
  array['city:nanchang'],
  '2',
  (select id from regions where key = 'CN:Nanchang')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Changchun',
  'Gamma- tier global city',
  array['city:changchun'],
  '2',
  (select id from regions where key = 'CN:Changchun')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Cali',
  'Gamma- tier global city',
  array['city:cali'],
  '2',
  (select id from regions where key = 'CO:Cali')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'St Louis',
  'Gamma- tier global city',
  array['city:st_louis'],
  '2',
  (select id from regions where key = 'US:St_Louis')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Ljubljana',
  'Gamma- tier global city',
  array['city:ljubljana'],
  '2',
  (select id from regions where key = 'SI:Ljubljana')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Baltimore',
  'Gamma- tier global city',
  array['city:baltimore'],
  '2',
  (select id from regions where key = 'US:Baltimore')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Bilbao',
  'Gamma- tier global city',
  array['city:bilbao'],
  '2',
  (select id from regions where key = 'ES:Bilbao')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Marseille',
  'Gamma- tier global city',
  array['city:marseille'],
  '2',
  (select id from regions where key = 'FR:Marseille')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Surabaya',
  'Gamma- tier global city',
  array['city:surabaya'],
  '2',
  (select id from regions where key = 'ID:Surabaya')
),

(
  (select id from card_groups where name = 'cities_watg24_gamma_minus'),
  'Accra',
  'Gamma- tier global city',
  array['city:accra'],
  '2',
  (select id from regions where key = 'GH:Accra')
);

-- ============================================
