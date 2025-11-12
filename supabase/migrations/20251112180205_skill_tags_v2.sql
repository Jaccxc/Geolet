-- ============================================
-- SKILL_TAGS SEED DATA
-- ============================================
-- Generated from: supabase/seed/skill_tags.json.deprecated
-- Count: 55 skill tags
-- Date: 2025-11-12T10:18:40.188Z
-- ============================================

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:latin',
  'script'::skill_family_enum,
  null,
  'Latin',
  'Most widely used alphabet. Common in Europe, Americas, parts of Africa and Asia.',
  array['Hotel', 'Restaurant', 'Police']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:devanagari:hindi',
  'script'::skill_family_enum,
  'IN',
  'Hindi (Devanagari)',
  'Most common language in India, found in central and northern regions. Distinctive horizontal line (shirorekha) through the top of each word with straight vertical lines.',
  array['होटल', 'रेस्तरां', 'स्कूल']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:devanagari:marathi',
  'script'::skill_family_enum,
  'IN',
  'Marathi (Devanagari)',
  'Found in Maharashtra. Uses Devanagari script but sometimes includes the letter ळ which is not found in Hindi.',
  array['हॉटेल', 'रेस्टॉरंट', 'शाळा', 'ळ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:gurmukhi:punjabi',
  'script'::skill_family_enum,
  'IN',
  'Punjabi (Gurmukhi)',
  'Found in Punjab (northwestern India). Softer letter shapes than Hindi, horizontal bar broken over certain letters. Distinct characters: ਨ, ਲ, ਅ and soft curve diacritic beneath letters.',
  array['ਹੋਟਲ', 'ਰੈਸਟੋਰੈਂਟ', 'ਸਕੂਲ', 'ਨ', 'ਲ', 'ਅ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:gujarati',
  'script'::skill_family_enum,
  'IN',
  'Gujarati',
  'Found in Gujarat. Similar to Hindi but notably lacks the horizontal line at the top of every word.',
  array['હોટલ', 'રેસ્ટોરન્ટ', 'શાળા']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:bengali',
  'script'::skill_family_enum,
  'IN',
  'Bengali',
  'Found in northeastern India (West Bengal) and Bangladesh. Similar look to Devanagari but recognizable by many letters featuring left-facing triangular shapes.',
  array['হোটেল', 'রেস্তোরাঁ', 'স্কুল']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:bengali:assamese',
  'script'::skill_family_enum,
  'IN',
  'Assamese (Bengali script)',
  'Found in Assam. Uses Bengali script with additional characters, most notably ৰ and ৱ.',
  array['হোটেল', 'ৰেস্তোৰাঁ', 'স্কুল', 'ৰ', 'ৱ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:kannada',
  'script'::skill_family_enum,
  'IN',
  'Kannada',
  'Found in Karnataka. Smooth curves and small circles. Many characters feature a distinct squiggly tail in the top right corner, less common in Telugu.',
  array['ಹೋಟೆಲ್', 'ರೆಸ್ಟೋರೆಂಟ್', 'ಶಾಲೆ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:telugu',
  'script'::skill_family_enum,
  'IN',
  'Telugu',
  'Found in Telangana and Andhra Pradesh. Very similar to Kannada but often has diacritics resembling checkmarks at the top of letters.',
  array['హోటల్', 'రెస్టారెంట్', 'పాఠశాల']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:tamil',
  'script'::skill_family_enum,
  'IN',
  'Tamil',
  'Found in Tamil Nadu (India) and Sri Lanka. Distinct combination of curves, straight lines and 90° angles. Some letters have dot-shaped diacritics.',
  array['ஹோட்டல்', 'உணவகம்', 'பள்ளி']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:odia',
  'script'::skill_family_enum,
  'IN',
  'Odia (Oriya)',
  'Found in Odisha. Curvy look with many letters having wide semi-circles covering the top. Distinct wide curve diacritic above letters. Resembles a skull emoji shape.',
  array['ହୋଟେଲ', 'ରେଷ୍ଟୁରାଣ୍ଟ', 'ବିଦ୍ୟାଳୟ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:malayalam',
  'script'::skill_family_enum,
  'IN',
  'Malayalam',
  'Found in Kerala. Somewhat simple-looking curvy letters, often containing upside-down U-shapes.',
  array['ഹോട്ടല്‍', 'റസ്റ്റോറന്റ്', 'സ്കൂള്‍']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:meitei:manipuri',
  'script'::skill_family_enum,
  'IN',
  'Manipuri (Meitei script)',
  'Official language of Manipur. Written using Meitei script, recognizable by its many vertical lines and right angles.',
  array['ꯍꯣꯇꯦꯜ', 'ꯔꯦꯁ꯭ꯇꯣꯔꯦꯟꯇ', 'ꯁ꯭ꯀꯨꯜ']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:cyrillic',
  'script'::skill_family_enum,
  'RU',
  'Cyrillic',
  'Used in Russia, Ukraine, Bulgaria, Serbia, and other Slavic countries.',
  array['Гостиница', 'Ресторан', 'Школа']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:arabic',
  'script'::skill_family_enum,
  null,
  'Arabic',
  'Used in Middle East and North Africa. Written right-to-left, connected cursive style.',
  array['فندق', 'مطعم', 'مدرسة']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:chinese:simplified',
  'script'::skill_family_enum,
  'CN',
  'Simplified Chinese',
  'Used in mainland China and Singapore. Simplified form of Chinese characters.',
  array['酒店', '餐厅', '学校']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:chinese:traditional',
  'script'::skill_family_enum,
  'TW',
  'Traditional Chinese',
  'Used in Taiwan, Hong Kong, and Macau. Traditional form of Chinese characters with more strokes.',
  array['酒店', '餐廳', '學校']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:japanese:hiragana',
  'script'::skill_family_enum,
  'JP',
  'Hiragana',
  'Japanese syllabary with curved, flowing characters. Used for native Japanese words.',
  array['ホテル', 'レストラン', 'がっこう']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:japanese:katakana',
  'script'::skill_family_enum,
  'JP',
  'Katakana',
  'Japanese syllabary with angular characters. Used for foreign words and emphasis.',
  array['ホテル', 'レストラン', 'スクール']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:korean:hangul',
  'script'::skill_family_enum,
  'KR',
  'Hangul',
  'Korean alphabet with distinctive circular and linear shapes arranged in syllable blocks.',
  array['호텔', '레스토랑', '학교']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:greek',
  'script'::skill_family_enum,
  'GR',
  'Greek',
  'Used in Greece and Cyprus. Distinctive letters like Ω, Δ, Π, Σ.',
  array['Ξενοδοχείο', 'Εστιατόριο', 'Σχολείο']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:hebrew',
  'script'::skill_family_enum,
  'IL',
  'Hebrew',
  'Used in Israel. Written right-to-left, squared block letters.',
  array['מלון', 'מסעדה', 'בית ספר']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:thai',
  'script'::skill_family_enum,
  'TH',
  'Thai',
  'Used in Thailand. Rounded characters with loops and circles, no spaces between words.',
  array['โรงแรม', 'ร้านอาหาร', 'โรงเรียน']
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+1',
  'phone'::skill_family_enum,
  'US',
  '+1',
  'United States and Canada (NANP)',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+7',
  'phone'::skill_family_enum,
  'RU',
  '+7',
  'Russia and Kazakhstan',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+27',
  'phone'::skill_family_enum,
  'ZA',
  '+27',
  'South Africa',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+27:15',
  'phone'::skill_family_enum,
  'ZA',
  '+27 15',
  'South Africa - Northern areas (Limpopo, Mpumalanga)',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+27:21',
  'phone'::skill_family_enum,
  'ZA',
  '+27 21',
  'South Africa - Cape Town area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+33',
  'phone'::skill_family_enum,
  'FR',
  '+33',
  'France',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+34',
  'phone'::skill_family_enum,
  'ES',
  '+34',
  'Spain',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+39',
  'phone'::skill_family_enum,
  'IT',
  '+39',
  'Italy',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+44',
  'phone'::skill_family_enum,
  'GB',
  '+44',
  'United Kingdom',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+49',
  'phone'::skill_family_enum,
  'DE',
  '+49',
  'Germany',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+52',
  'phone'::skill_family_enum,
  'MX',
  '+52',
  'Mexico',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+55',
  'phone'::skill_family_enum,
  'BR',
  '+55',
  'Brazil',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+61',
  'phone'::skill_family_enum,
  'AU',
  '+61',
  'Australia',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+81',
  'phone'::skill_family_enum,
  'JP',
  '+81',
  'Japan',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+82',
  'phone'::skill_family_enum,
  'KR',
  '+82',
  'South Korea',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+86',
  'phone'::skill_family_enum,
  'CN',
  '+86',
  'China',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91',
  'phone'::skill_family_enum,
  'IN',
  '+91',
  'India',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91:11',
  'phone'::skill_family_enum,
  'IN',
  '+91 11',
  'India - Delhi NCR area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91:22',
  'phone'::skill_family_enum,
  'IN',
  '+91 22',
  'India - Mumbai area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91:33',
  'phone'::skill_family_enum,
  'IN',
  '+91 33',
  'India - Kolkata area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91:44',
  'phone'::skill_family_enum,
  'IN',
  '+91 44',
  'India - Chennai area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+91:80',
  'phone'::skill_family_enum,
  'IN',
  '+91 80',
  'India - Bangalore area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+886',
  'phone'::skill_family_enum,
  'TW',
  '+886',
  'Taiwan',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+886:2',
  'phone'::skill_family_enum,
  'TW',
  '+886 2',
  'Taiwan - Taipei area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'phone:+886:7',
  'phone'::skill_family_enum,
  'TW',
  '+886 7',
  'Taiwan - Kaohsiung area',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:IN:tier1',
  'city'::skill_family_enum,
  'IN',
  'Major Indian Cities',
  'Tier 1 cities in India',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:FR:tier1',
  'city'::skill_family_enum,
  'FR',
  'Major French Cities',
  'Tier 1 cities in France',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:US:tier1',
  'city'::skill_family_enum,
  'US',
  'Major US Cities',
  'Tier 1 cities in United States',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:TW:tier1',
  'city'::skill_family_enum,
  'TW',
  'Major Taiwan Cities',
  'Tier 1 cities in Taiwan',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:CN:tier1',
  'city'::skill_family_enum,
  'CN',
  'Major Chinese Cities',
  'Tier 1 cities in China',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:JP:tier1',
  'city'::skill_family_enum,
  'JP',
  'Major Japanese Cities',
  'Tier 1 cities in Japan',
  array[]::text[]
);

insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:global:tier1',
  'city'::skill_family_enum,
  null,
  'Global Major Cities',
  'Tier 1 cities worldwide',
  array[]::text[]
);