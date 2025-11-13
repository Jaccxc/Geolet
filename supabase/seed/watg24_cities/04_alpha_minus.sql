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

