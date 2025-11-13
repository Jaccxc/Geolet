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
  'Beta+ tier global city',
  array['city:bogota'],
  '2',
  (select id from regions where key = 'CO:Bogota')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Ho Chi Minh City',
  'Beta+ tier global city',
  array['city:ho_chi_minh_city'],
  '2',
  (select id from regions where key = 'VN:Ho_Chi_Minh_City')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Rome',
  'Beta+ tier global city',
  array['city:rome'],
  '2',
  (select id from regions where key = 'IT:Rome')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bangalore',
  'Beta+ tier global city',
  array['city:bangalore'],
  '2',
  (select id from regions where key = 'IN:Bangalore')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Budapest',
  'Beta+ tier global city',
  array['city:budapest'],
  '2',
  (select id from regions where key = 'HU:Budapest')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Athens',
  'Beta+ tier global city',
  array['city:athens'],
  '2',
  (select id from regions where key = 'GR:Athens')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hamburg',
  'Beta+ tier global city',
  array['city:hamburg'],
  '2',
  (select id from regions where key = 'DE:Hamburg')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Doha',
  'Beta+ tier global city',
  array['city:doha'],
  '2',
  (select id from regions where key = 'QA:Doha')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Chengdu',
  'Beta+ tier global city',
  array['city:chengdu'],
  '2',
  (select id from regions where key = 'CN:Chengdu')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Miami',
  'Beta+ tier global city',
  array['city:miami'],
  '2',
  (select id from regions where key = 'US:Miami')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Tianjin',
  'Beta+ tier global city',
  array['city:tianjin'],
  '2',
  (select id from regions where key = 'CN:Tianjin')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Dallas',
  'Beta+ tier global city',
  array['city:dallas'],
  '2',
  (select id from regions where key = 'US:Dallas')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Atlanta (GA)',
  'Beta+ tier global city',
  array['city:atlanta_ga'],
  '2',
  (select id from regions where key = 'US:Atlanta')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Auckland',
  'Beta+ tier global city',
  array['city:auckland'],
  '2',
  (select id from regions where key = 'NZ:Auckland')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Barcelona',
  'Beta+ tier global city',
  array['city:barcelona'],
  '2',
  (select id from regions where key = 'ES:Barcelona')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Hangzhou',
  'Beta+ tier global city',
  array['city:hangzhou'],
  '2',
  (select id from regions where key = 'CN:Hangzhou')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Bucharest',
  'Beta+ tier global city',
  array['city:bucharest'],
  '2',
  (select id from regions where key = 'RO:Bucharest')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Lima',
  'Beta+ tier global city',
  array['city:lima'],
  '2',
  (select id from regions where key = 'PE:Lima')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Montreal',
  'Beta+ tier global city',
  array['city:montreal'],
  '2',
  (select id from regions where key = 'CA:Montreal')
),

(
  (select id from card_groups where name = 'cities_watg24_beta_plus'),
  'Prague',
  'Beta+ tier global city',
  array['city:prague'],
  '2',
  (select id from regions where key = 'CZ:Prague')
);

-- ============================================
