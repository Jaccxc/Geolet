-- ============================================
-- INDIAN LANGUAGES - SHORT FORM CARDS
-- ============================================
-- Date: 2025-11-13
-- Count: 156 cards (12 per script × 13 scripts)
-- Format: Single vocabulary words (not too short)
-- Difficulty: Advanced (less context available)
-- ============================================

-- ============================================
-- HINDI (DEVANAGARI) - 12 CARDS
-- Region: IN:Uttar_Pradesh
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'पुस्तकालय', 'pustakālay (library)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'विद्यालय', 'vidyālay (school)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'अस्पताल', 'aspatāl (hospital)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'रेलगाड़ी', 'relgāṛī (train)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'समाचार', 'samācār (news)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'सरकार', 'sarkār (government)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'परिवार', 'parivār (family)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'प्रधानमंत्री', 'pradhānmantrī (prime minister)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'विश्वविद्यालय', 'viśvavidyālay (university)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'कार्यालय', 'kāryālay (office)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'चिकित्सक', 'cikitsak (doctor)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'अध्यापक', 'adhyāpak (teacher)', array['script:devanagari:hindi'], '2', (select id from regions where key = 'IN:Uttar_Pradesh'));

-- ============================================
-- MARATHI (DEVANAGARI) - 12 CARDS
-- Region: IN:Maharashtra
-- Note: Contains distinctive ळ character
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'वाचनालय', 'vācanālay (library)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'शाळा', 'śāḷā (school)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'रुग्णालय', 'rugṇālay (hospital)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'रेल्वेगाडी', 'relvegāḍī (train)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'बातम्या', 'bātamyā (news)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'सरकार', 'sarkār (government)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'कुटुंब', 'kuṭumb (family)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'मुख्यमंत्री', 'mukhyamantrī (chief minister)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'विद्यापीठ', 'vidyāpīṭh (university)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'कार्यालय', 'kāryālay (office)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'डॉक्टर', 'ḍokṭar (doctor)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'शिक्षक', 'śikṣak (teacher)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra'));

-- ============================================
-- TAMIL - 12 CARDS
-- Region: IN:Tamil_Nadu
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'நூலகம்', 'nūlakam (library)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'பள்ளி', 'paḷḷi (school)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'மருத்துவமனை', 'maruttuvamaṉai (hospital)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ரயில்', 'rayil (train)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'செய்தி', 'seyti (news)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'அரசாங்கம்', 'arasāṅkam (government)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'குடும்பம்', 'kuṭumpam (family)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'முதலமைச்சர்', 'mutalamaiccaṟ (chief minister)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'பல்கலைக்கழகம்', 'palkalaikkkaḻakam (university)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'அலுவலகம்', 'aluvalakam (office)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'மருத்துவர்', 'maruttuvaṟ (doctor)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ஆசிரியர்', 'āciriyaṟ (teacher)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu'));

-- ============================================
-- TELUGU - 12 CARDS
-- Region: IN:Telangana
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'గ్రంథాలయం', 'granthālayaṁ (library)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'పాఠశాల', 'pāṭhaśāla (school)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ఆసుపత్రి', 'āsupatri (hospital)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'రైలు', 'railu (train)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'వార్తలు', 'vārtalu (news)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ప్రభుత్వం', 'prabhutvam (government)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'కుటుంబం', 'kuṭuṁbaṁ (family)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ముఖ్యమంత్రి', 'mukhyamantri (chief minister)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'విశ్వవిద్యాలయం', 'viśvavidyālayaṁ (university)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'కార్యాలయం', 'kāryālayaṁ (office)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'వైద్యుడు', 'vaidyuḍu (doctor)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ఉపాధ్యాయుడు', 'upādhyāyuḍu (teacher)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana'));

-- ============================================
-- KANNADA - 12 CARDS
-- Region: IN:Karnataka
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಗ್ರಂಥಾಲಯ', 'granthālaya (library)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಶಾಲೆ', 'śāle (school)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಆಸ್ಪತ್ರೆ', 'āspatre (hospital)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ರೈಲು', 'railu (train)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಸುದ್ದಿ', 'suddi (news)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಸರ್ಕಾರ', 'sarkāra (government)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಕುಟುಂಬ', 'kuṭumba (family)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಮುಖ್ಯಮಂತ್ರಿ', 'mukhyamantri (chief minister)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ವಿಶ್ವವಿದ್ಯಾಲಯ', 'viśvavidyālaya (university)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಕಚೇರಿ', 'kacēri (office)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ವೈದ್ಯರು', 'vaidyaru (doctor)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ಶಿಕ್ಷಕರು', 'śikṣakaru (teacher)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka'));

-- ============================================
-- MALAYALAM - 12 CARDS
-- Region: IN:Kerala
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'ലൈബ്രറി', 'laibrēri (library)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'സ്കൂൾ', 'skūḷ (school)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ആശുപത്രി', 'āśupatri (hospital)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ട്രെയിൻ', 'ṭreyin (train)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'വാർത്ത', 'vārtta (news)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'സർക്കാർ', 'sarkkār (government)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'കുടുംബം', 'kuṭumbaṁ (family)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'മുഖ്യമന്ത്രി', 'mukhyamantri (chief minister)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'സർവകലാശാല', 'sarvakalāśāla (university)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ഓഫീസ്', 'ōphīs (office)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ഡോക്ടർ', 'ḍōkṭar (doctor)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'അധ്യാപകൻ', 'adhyāpakaṉ (teacher)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala'));

-- ============================================
-- BENGALI - 12 CARDS
-- Region: IN:West_Bengal
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'লাইব্রেরি', 'lāibrerri (library)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'বিদ্যালয়', 'bidyālôy (school)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'হাসপাতাল', 'hāspatāl (hospital)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ট্রেন', 'ṭren (train)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'সংবাদ', 'sôṅbād (news)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'সরকার', 'sôrkār (government)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'পরিবার', 'pôribār (family)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'মুখ্যমন্ত্রী', 'mukkhômôntrī (chief minister)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'বিশ্ববিদ্যালয়', 'biśbôbidyālôy (university)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'অফিস', 'ôphis (office)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ডাক্তার', 'ḍāktār (doctor)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'শিক্ষক', 'śikṣôk (teacher)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal'));

-- ============================================
-- ASSAMESE - 12 CARDS
-- Region: IN:Assam
-- Note: Uses Bengali script with some distinctions
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'পুথিভঁৰাল', 'puthibhãrāl (library)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'বিদ্যালয়', 'bidyāloy (school)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'চিকিৎসালয়', 'cikitsāloy (hospital)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ৰেলগাড়ী', 'relgāṛī (train)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'বাতৰি', 'bātori (news)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'চৰকাৰ', 'corokār (government)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'পৰিয়াল', 'poriyāl (family)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'মুখ্যমন্ত্ৰী', 'mukhyamontrī (chief minister)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'বিশ্ববিদ্যালয়', 'biśbobidyāloy (university)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'কাৰ্যালয়', 'kāryāloy (office)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'চিকিৎসক', 'cikitsok (doctor)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'শিক্ষক', 'śikṣok (teacher)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam'));

-- ============================================
-- GUJARATI - 12 CARDS
-- Region: IN:Gujarat
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'પુસ્તકાલય', 'pustakālay (library)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'શાળા', 'śāḷā (school)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'હોસ્પિટલ', 'hospiṭal (hospital)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ટ્રેન', 'ṭren (train)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'સમાચાર', 'samācār (news)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'સરકાર', 'sarkār (government)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'કુટુંબ', 'kuṭumb (family)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'મુખ્યમંત્રી', 'mukhyamantarī (chief minister)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'યુનિવર્સિટી', 'yunivarsiṭī (university)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'કચેરી', 'kacērī (office)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ડૉક્ટર', 'ḍo̐kṭar (doctor)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'શિક્ષક', 'śikṣak (teacher)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat'));

-- ============================================
-- PUNJABI (GURMUKHI) - 12 CARDS
-- Region: IN:Punjab
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਲਾਇਬ੍ਰੇਰੀ', 'lāibrerī (library)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਸਕੂਲ', 'sakūl (school)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਹਸਪਤਾਲ', 'haspatāl (hospital)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਰੇਲਗੱਡੀ', 'relgaḍḍī (train)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਖ਼ਬਰਾਂ', 'xabarāṁ (news)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਸਰਕਾਰ', 'sarkār (government)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਪਰਿਵਾਰ', 'parivār (family)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਮੁੱਖ ਮੰਤਰੀ', 'mukkh mantarī (chief minister)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਯੂਨੀਵਰਸਿਟੀ', 'yūnīvarasiṭī (university)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਦਫ਼ਤਰ', 'daftar (office)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਡਾਕਟਰ', 'ḍākṭar (doctor)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ਅਧਿਆਪਕ', 'adhiāpak (teacher)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab'));

-- ============================================
-- ODIA - 12 CARDS
-- Region: IN:Odisha
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'ପୁସ୍ତକାଳୟ', 'pustakāḷaya (library)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ବିଦ୍ୟାଳୟ', 'bidyāḷaya (school)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ଡାକ୍ତରଖାନା', 'ḍāktarakhānā (hospital)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ଟ୍ରେନ୍', 'ṭren (train)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ସମ୍ବାଦ', 'sambāda (news)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ସରକାର', 'sarakāra (government)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ପରିବାର', 'paribāra (family)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ମୁଖ୍ୟମନ୍ତ୍ରୀ', 'mukhyamantrī (chief minister)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ବିଶ୍ୱବିଦ୍ୟାଳୟ', 'biśbabidyāḷaya (university)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'କାର୍ଯ୍ୟାଳୟ', 'kāryāḷaya (office)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ଡାକ୍ତର', 'ḍāktara (doctor)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ଶିକ୍ଷକ', 'śikṣaka (teacher)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha'));

-- ============================================
-- MANIPURI (MEITEI MAYEK) - 12 CARDS
-- Region: IN:Manipur
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯂꯥꯏꯕ꯭ꯔꯦꯔꯤ', 'library (library)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯁꯥꯟꯅꯄꯣꯠ', 'sanna-pot (school)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯍꯣꯁ꯭ꯄꯤꯇꯦꯜ', 'hospital (hospital)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯔꯦꯜ', 'rel (train)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯄꯥꯎꯖꯦꯜ', 'paujel (news)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯁꯔꯀꯥꯔ', 'sarkar (government)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯏꯃꯨꯡ', 'imung (family)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯃꯨꯈꯤꯕ ꯃꯤꯅꯤꯁ꯭ꯇꯔ', 'mukhiba minister (chief minister)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯌꯨꯅꯤꯚꯔꯁꯤꯇꯤ', 'university (university)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯑꯣꯐꯤꯁ', 'office (office)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯗꯣꯛꯇꯔ', 'doctor (doctor)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'ꯑꯣꯖꯥ', 'oja (teacher)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur'));

-- ============================================
-- MIZO - 12 CARDS
-- Region: IN:Mizoram
-- Note: Uses Latin script with diacritics
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Short Form'), 'lehkhabu dahna', 'lehkhabu dahna (library)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'sikul', 'sikul (school)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'damdawi in', 'damdawi in (hospital)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'leng', 'leng (train)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'thuthang', 'thuthang (news)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'sorkar', 'sorkar (government)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'chhungkaw', 'chhungkaw (family)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'Chief Minister', 'Chief Minister (chief minister)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'university', 'university (university)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'office', 'office (office)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'doctor', 'doctor (doctor)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Short Form'), 'zirtirtu', 'zirtirtu (teacher)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram'));
