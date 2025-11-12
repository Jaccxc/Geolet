-- ============================================
-- INDIAN LANGUAGES - LONG FORM CARDS
-- ============================================
-- Date: 2025-11-12
-- Count: 156 cards (12 per script × 13 scripts)
-- Format: 2-3 sentence passages
-- Difficulty: Intermediate (more context available)
-- ============================================

-- ============================================
-- HINDI (DEVANAGARI) - 12 CARDS
-- Region: IN:Uttar_Pradesh
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'मैं आज सुबह बाजार गया था। वहाँ बहुत भीड़ थी। मैंने कुछ फल और सब्जियाँ खरीदीं।', 'maiṁ āj subah bāzār gayā thā. vahā̃ bahut bhīṛ thī. maiṁne kuch phal aur sabjiyā̃ kharīdīṁ. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'स्कूल में आज वार्षिक समारोह है। सभी बच्चे बहुत उत्साहित हैं। वे नृत्य और गीत प्रस्तुत करेंगे।', 'skūl meṁ āj vārṣik samāroh hai. sabhī bacce bahut utsāhit haiṁ. ve nṛtya aur gīt prastut kareṅge. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'रमेश एक अच्छा विद्यार्थी है। वह रोज पुस्तकालय जाता है। उसे विज्ञान और गणित पसंद है।', 'rameś ek acchā vidyārthī hai. vah roj pustakālay jātā hai. use vijñān aur gaṇit pasand hai. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'हमारे घर के पास एक बड़ा पार्क है। शाम को बहुत लोग वहाँ टहलने आते हैं। बच्चे वहाँ खेलते हैं।', 'hamāre ghar ke pās ek baṛā pārk hai. śām ko bahut log vahā̃ ṭahalane āte haiṁ. bacce vahā̃ khelate haiṁ. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'डॉक्टर ने मुझे दवाई दी है। मुझे दिन में तीन बार खानी है। मैं जल्द ही ठीक हो जाऊंगा।', 'ḍokṭar ne mujhe davāī dī hai. mujhe din meṁ tīn bār khānī hai. maiṁ jald hī ṭhīk ho jāūṅgā. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'गर्मी की छुट्टियों में हम पहाड़ों पर गए थे। वहाँ का मौसम बहुत सुहावना था। हमने बहुत सारी तस्वीरें खींचीं।', 'garmī kī chuṭṭiyoṁ meṁ ham pahāṛoṁ par gae the. vahā̃ kā mausam bahut suhāvanā thā. hamane bahut sārī tasvīreṁ khīṁcīṁ. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'रेलगाड़ी समय पर आ गई। सभी यात्री उतरने लगे। मैंने अपना सामान उठाया और बाहर आ गया।', 'relgāṛī samay par ā gaī. sabhī yātrī utarne lage. maiṁne apanā sāmān uṭhāyā aur bāhar ā gayā. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'आज रविवार है और सभी दुकानें बंद हैं। हम घर पर ही रहेंगे। शाम को हम फिल्म देखेंगे।', 'āj ravivār hai aur sabhī dukāneṁ band haiṁ. ham ghar par hī raheṅge. śām ko ham film dekheṅge. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'किसान खेत में काम कर रहा है। वह गेहूं की फसल काट रहा है। इस साल फसल अच्छी हुई है।', 'kisān khet meṁ kām kar rahā hai. vah gehūṁ kī phasal kāṭ rahā hai. is sāl phasal acchī huī hai. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'मेरी बहन शिक्षिका है। वह एक प्राथमिक विद्यालय में पढ़ाती है। बच्चे उसे बहुत पसंद करते हैं।', 'merī bahan śikṣikā hai. vah ek prāthmik vidyālay meṁ paṛhātī hai. bacce use bahut pasand karte haiṁ. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'शहर में एक नया अस्पताल बन रहा है। यह बहुत बड़ा और आधुनिक होगा। अगले साल यह खुल जाएगा।', 'śahar meṁ ek nayā aspatāl ban rahā hai. yah bahut baṛā aur ādhunik hogā. agale sāl yah khul jāegā. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'बच्चे पार्क में खेल रहे हैं। कुछ झूले पर झूल रहे हैं। कुछ फुटबॉल खेल रहे हैं।', 'bacce pārk meṁ khel rahe haiṁ. kuch jhūle par jhūl rahe haiṁ. kuch phuṭabŏl khel rahe haiṁ. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:devanagari:hindi'], '1', (select id from regions where key = 'IN:Uttar_Pradesh'));

-- ============================================
-- MARATHI (DEVANAGARI) - 12 CARDS
-- Region: IN:Maharashtra
-- Note: Contains distinctive ळ character
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'मी आज सकाळी बाजारात गेलो होतो। तिथे खूप गर्दी होती। मी काही फळे आणि भाज्या विकत घेतल्या।', 'mī āj sakāḷī bājārāt gelo hoto. tithe khūp gardī hotī. mī kāhī phaḷe āṇi bhājyā vikat ghetlyā. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'शाळेत आज वार्षिक सोहळा आहे। सर्व मुले खूप उत्साहित आहेत। ते नृत्य आणि गाणी सादर करणार आहेत।', 'śāḷet āj vārṣik sohaḷā āhe. sarva mule khūp utsāhit āhet. te nṛtya āṇi gāṇī sādar karaṇār āhet. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'रमेश एक चांगला विद्यार्थी आहे। तो रोज वाचनालयात जातो। त्याला विज्ञान आणि गणित आवडते।', 'rameś ek cāṅgalā vidyārthī āhe. to roj vācanālayāt jāto. tyālā vijñān āṇi gaṇit āvaḍate. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'आमच्या घराजवळ एक मोठे उद्यान आहे। संध्याकाळी खूप लोक तिथे फिरायला येतात। मुले तिथे खेळतात।', 'āmacyā gharājawaḷa ek moṭhe udyān āhe. sandhyākāḷī khūp lok tithe phirāyalā yetāt. mule tithe kheḷatāt. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'डॉक्टरांनी मला औषध दिले आहे। मला दिवसातून तीन वेळा घ्यायचे आहे। मी लवकरच बरा होईन।', 'ḍokṭarānnī malā auṣadh dile āhe. malā divasātūn tīn veḷā ghyāyace āhe. mī lavakarac barā hoīn. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'उन्हाळ्याच्या सुट्ट्यांमध्ये आम्ही डोंगरावर गेलो होतो। तिथले हवामान खूप छान होते। आम्ही खूप फोटो काढले।', 'unhāḷyācyā suṭṭyānmadhye āmhī ḍongarāvar gelo hoto. tithale havāmān khūp chān hote. āmhī khūp phoṭo kāḍhale. (We went to the mountains during summer vacation. The weather there was very nice. We took many photos.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'रेल्वेगाडी वेळेवर आली। सर्व प्रवासी उतरू लागले। मी माझे सामान उचलले आणि बाहेर आलो।', 'relvegāḍī veḷevar ālī. sarva pravāsī utarū lāgale. mī mājhe sāmān ucalale āṇi bāher ālo. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'आज रविवार आहे आणि सर्व दुकाने बंद आहेत। आम्ही घरीच राहू। संध्याकाळी आम्ही चित्रपट पाहू।', 'āj ravivār āhe āṇi sarva dukāne band āhet. āmhī gharīc rāhū. sandhyākāḷī āmhī citrapaṭ pāhū. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'शेतकरी शेतात काम करत आहे। तो गहूच्या पिकाची कापणी करत आहे। यावर्षी पीक चांगले झाले आहे।', 'śetakarī śetāt kām karat āhe. to gahūcyā pikācī kāpaṇī karat āhe. yāvarṣī pīk cāṅgale jhāle āhe. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'माझी बहीण शिक्षिका आहे। ती एका प्राथमिक शाळेत शिकवते। मुले तिला खूप आवडतात।', 'mājhī bahīṇ śikṣikā āhe. tī ekā prāthamik śāḷet śikavate. mule tilā khūp āvaḍatāt. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'शहरात एक नवीन रुग्णालय बांधले जात आहे। ते खूप मोठे आणि आधुनिक असेल। पुढील वर्षी ते उघडेल।', 'śaharāt ek navīn rugṇālay bāndhale jāt āhe. te khūp moṭhe āṇi ādhunik asel. puḍhīl varṣī te ughaḍel. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'मुळे उद्यानात खेळत आहेत। काही झोक्यावर झुलत आहेत। काही फुटबॉल खेळत आहेत।', 'muḷe udyānāt kheḷat āhet. kāhī jhokyāvar jhulat āhet. kāhī phuṭabŏl kheḷat āhet. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:devanagari:marathi'], '2', (select id from regions where key = 'IN:Maharashtra'));

-- ============================================
-- TAMIL - 12 CARDS
-- Region: IN:Tamil_Nadu
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'நான் இன்று காலையில் சந்தைக்கு சென்றேன். அங்கே நிறைய கூட்டம் இருந்தது। நான் சில பழங்கள் மற்றும் காய்கறிகள் வாங்கினேன்.', 'nāṉ iṉṟu kālaiyil cantaikkு ceṉṟēṉ. aṅkē niṟaiya kூṭṭam iruntatu. nāṉ cila paḻaṅkaḷ maṟṟum kāykaṟikaḷ vāṅkiṉēṉ. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'பள்ளியில் இன்று ஆண்டு விழா உள்ளது। எல்லா குழந்தைகளும் மிகவும் உற்சாகமாக உள்ளனர். அவர்கள் நடனம் மற்றும் பாடல்களை வழங்குவார்கள்.', 'paḷḷiyil iṉṟu āṇṭu viḻā uḷḷatu. ellā kuḻantaikaḷum mikavum uṟcākamāka uḷḷaṉar. avarkaḷ naṭaṉam maṟṟum pāṭalkaḷai vaḻaṅkuvārkaḷ. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ரமேஷ் ஒரு நல்ல மாணவன். அவன் தினமும் நூலகத்திற்கு செல்கிறான். அவனுக்கு அறிவியல் மற்றும் கணிதம் பிடிக்கும்.', 'ramēṣ oru nalla māṇavaṉ. avaṉ tiṉamum nūlakattiṟku celkirāṉ. avaṉukku aṟiviyal maṟṟum kaṇitam piṭikkum. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'எங்கள் வீட்டிற்கு அருகில் ஒரு பெரிய பூங்கா உள்ளது। மாலையில் பல மக்கள் அங்கு நடக்க வருகிறார்கள். குழந்தைகள் அங்கு விளையாடுகிறார்கள்.', 'eṅkaḷ vīṭṭiṟku arukil oru periya pūṅkā uḷḷatu. mālaiyil pala makkaḷ aṅku naṭakka varukiṟārkaḷ. kuḻantaikaḷ aṅku viḷaiyāṭukirārkaḷ. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'மருத்துவர் எனக்கு மருந்து கொடுத்துள்ளார். நான் நாளைக்கு மூன்று முறை எடுக்க வேண்டும். நான் விரைவில் குணமாகிவிடுவேன்.', 'maruttuvar eṉakku maruntu koṭuttuḷḷār. nāṉ nāḷaikku mūṉṟu muṟai eṭukka vēṇṭum. nāṉ viraivil kuṇamākiviṭuvēṉ. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'கோடை விடுமுறையில் நாங்கள் மலைகளுக்கு சென்றோம். அங்குள்ள வானிலை மிகவும் இனிமையாக இருந்தது। நாங்கள் நிறைய புகைப்படங்களை எடுத்தோம்.', 'kōṭai viṭumuṟaiyil nāṅkaḷ malaikaḷukku ceṉṟōm. aṅkuḷḷa vāṉilai mikavum iṉimayāka iruntatu. nāṅkaḷ niṟaiya pukaippaṭaṅkaḷai eṭuttōm. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ரயில் சரியான நேரத்தில் வந்தது. எல்லா பயணிகளும் இறங்க ஆரம்பித்தனர். நான் என் சாமான்களை எடுத்துக்கொண்டு வெளியே வந்தேன்.', 'rayil cariyāṉa nērattil vantatu. ellā payaṇikaḷum iṟaṅka ārampittaṉar. nāṉ eṉ cāmāṉkaḷai eṭuttukoṇṭு veḷiyē vantēṉ. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'இன்று ஞாயிற்றுக்கிழமை மற்றும் எல்லா கடைகளும் மூடியுள்ளன. நாங்கள் வீட்டிலேயே இருப்போம். மாலையில் நாங்கள் திரைப்படம் பார்ப்போம்.', 'iṉṟu ñāyiṟṟukkiḻamai maṟṟum ellā kaṭaikaḷum mūṭiyuḷḷaṉa. nāṅkaḷ vīṭṭilēyē iruppōm. mālaiyil nāṅkaḷ tiraippaṭam pārppōm. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'விவசாயி வயலில் வேலை செய்து கொண்டிருக்கிறார். அவர் கோதுமை பயிரை அறுவடை செய்து கொண்டிருக்கிறார். இந்த ஆண்டு பயிர் நன்றாக உள்ளது.', 'vivasāyi vayalil vēlai ceytu koṇṭirukkiṟār. avar kōtumai payirai aṟuvaṭai ceytu koṇṭirukkiṟār. inta āṇṭu payir naṉṟāka uḷḷatu. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'என் சகோதரி ஆசிரியை. அவள் ஒரு தொடக்கப் பள்ளியில் கற்பிக்கிறாள். குழந்தைகள் அவளை மிகவும் விரும்புகிறார்கள்.', 'eṉ cakōtari āciriyai. avaḷ oru toṭakkap paḷḷiyil kaṟpikkiṟāḷ. kuḻantaikaḷ avaḷai mikavum virumpukirārkaḷ. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'நகரத்தில் ஒரு புதிய மருத்துவமனை கட்டப்பட்டு வருகிறது. இது மிகவும் பெரியதாகவும் நவீனமாகவும் இருக்கும். அடுத்த ஆண்டு இது திறக்கப்படும்.', 'nakarattil oru putiya maruttuvamaṉai kaṭṭappaṭṭu varukiṟatu. itu mikavum periyatākavum navīṉamākavum irukkum. aṭutta āṇṭu itu tiṟakkappaṭum. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'குழந்தைகள் பூங்காவில் விளையாடுகிறார்கள். சிலர் ஊஞ்சலில் ஆடுகிறார்கள். சிலர் கால்பந்து விளையாடுகிறார்கள்.', 'kuḻantaikaḷ pūṅkāvil viḷaiyāṭukirārkaḷ. cilar ūñcalil āṭukirārkaḷ. cilar kālpantu viḷaiyāṭukirārkaḷ. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:tamil'], '2', (select id from regions where key = 'IN:Tamil_Nadu'));

-- ============================================
-- TELUGU - 12 CARDS
-- Region: IN:Telangana
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'నేను ఈరోజు ఉదయం మార్కెట్‌కు వెళ్ళాను. అక్కడ చాలా రద్దీ ఉంది. నేను కొన్ని పండ్లు మరియు కూరగాయలు కొన్నాను.', 'nēnu īrōju udayaṁ mārkeṭku veḷḷānu. akkaḍa cālā raddī undi. nēnu konni paṇḍlu mariyu kūragāyalu konnānu. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'పాఠశాలలో ఈరోజు వార్షికోత్సవం ఉంది. పిల్లలంతా చాలా ఉత్సాహంగా ఉన్నారు. వారు నృత్యాలు మరియు పాటలు ప్రదర్శిస్తారు.', 'pāṭhaśālalō īrōju vārṣikōtsavaṁ undi. pillalantā cālā utsāhaṁgā unnāru. vāru nṛtyālu mariyu pāṭalu pradarśistāru. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'రమేష్ మంచి విద్యార్థి. అతను ప్రతిరోజు గ్రంథాలయానికి వెళ్తాడు. అతనికి సైన్స్ మరియు గణితం ఇష్టం.', 'ramēś mañci vidyārthi. atanu pratirōju granthālayāniku veḷtāḍu. ataniki sains mariyu gaṇitaṁ iṣṭaṁ. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'మా ఇంటి దగ్గర ఒక పెద్ద పార్క్ ఉంది. సాయంత్రం చాలా మంది అక్కడ నడవడానికి వస్తారు. పిల్లలు అక్కడ ఆడుకుంటారు.', 'mā iṇṭi daggara oka pedda pārk undi. sāyantram cālā mandi akkaḍa naḍavaḍāniku vastāru. pillalu akkaḍa āḍukuṇṭāru. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'డాక్టర్ నాకు మందు ఇచ్చారు. నేను రోజుకు మూడు సార్లు తీసుకోవాలి. నేను త్వరలో కోలుకుంటాను.', 'ḍākṭar nāku mandu iccāru. nēnu rōjuku mūḍu sārlu tīsukōvāli. nēnu tvaralo kōlukuṇṭānu. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'వేసవి సెలవులలో మేము కొండలకు వెళ్ళాము. అక్కడ వాతావరణం చాలా ఆహ్లాదకరంగా ఉంది. మేము చాలా ఫోటోలు తీశాము.', 'vēsavi selavulalō mēmu koṇḍalaku veḷḷāmu. akkaḍa vātāvaraṇaṁ cālā āhlādakaraṅgā undi. mēmu cālā phōṭōlu tīśāmu. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'రైలు సమయానికి వచ్చింది. ప్రయాణికులంతా దిగడం మొదలుపెట్టారు. నేను నా సామానును తీసుకొని బయటకు వచ్చాను.', 'railu samayāniku vaccindi. prayāṇikulantā digaḍaṁ modalupeṭṭāru. nēnu nā sāmānunu tīsukoni bayaṭaku vaccānu. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ఈరోజు ఆదివారం మరియు అన్ని దుకాణాలు మూసి ఉన్నాయి. మేము ఇంట్లోనే ఉంటాము. సాయంత్రం మేము సినిమా చూస్తాము.', 'īrōju ādivāraṁ mariyu anni dukāṇālu mūsi unnāyi. mēmu iṇṭlōnē uṇṭāmu. sāyantram mēmu sinimā cūstāmu. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'రైతు పొలంలో పని చేస్తున్నాడు. అతను గోధుమ పంటను కోస్తున్నాడు. ఈ సంవత్సరం పంట బాగుంది.', 'raitu polaṁlō pani cēstunnāḍu. atanu gōdhuma paṇṭanu kōstunnāḍu. ī sanvatsaraṁ paṇṭa bāgundi. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'నా సోదరి ఉపాధ్యాయురాలు. ఆమె ఒక ప్రాథమిక పాఠశాలలో బోధిస్తుంది. పిల్లలు ఆమెను చాలా ఇష్టపడతారు.', 'nā sōdari upādhyāyurālu. āme oka prāthamika pāṭhaśālalō bōdhistundi. pillalu āmenu cālā iṣṭapaḍatāru. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'నగరంలో ఒక కొత్త ఆసుపత్రి నిర్మించబడుతోంది. ఇది చాలా పెద్దదిగా మరియు ఆధునికంగా ఉంటుంది. వచ్చే సంవత్సరం ఇది తెరవబడుతుంది.', 'nagaraṁlō oka kotta āsupatri nirmiñcabaḍutōndi. idi cālā peddadigā mariyu ādunikaṁgā uṇṭundi. vaccē sanvatsaraṁ idi teravabaḍutundi. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'పిల్లలు పార్కులో ఆడుకుంటున్నారు. కొందరు ఊయలలో ఊగుతున్నారు. కొందరు ఫుట్‌బాల్ ఆడుతున్నారు.', 'pillalu pārkulō āḍukuṇṭunnāru. kondaru ūyalalō ūgutunnāru. kondaru phuṭbāl āḍutunnāru. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:telugu'], '2', (select id from regions where key = 'IN:Telangana'));

-- ============================================
-- KANNADA - 12 CARDS
-- Region: IN:Karnataka
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'ನಾನು ಇಂದು ಬೆಳಿಗ್ಗೆ ಮಾರುಕಟ್ಟೆಗೆ ಹೋಗಿದ್ದೆ. ಅಲ್ಲಿ ತುಂಬಾ ಜನಸಂದಣಿ ಇತ್ತು. ನಾನು ಕೆಲವು ಹಣ್ಣುಗಳು ಮತ್ತು ತರಕಾರಿಗಳನ್ನು ಖರೀದಿಸಿದೆ.', 'nānu indu beḷigge mārkaṭṭege hōgidde. alli tumbā janasandaṇi ittu. nānu kelavu haṇṇugaḷu mattu tarakārigaḷannu kharīdisade. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ಶಾಲೆಯಲ್ಲಿ ಇಂದು ವಾರ್ಷಿಕೋತ್ಸವವಿದೆ. ಎಲ್ಲಾ ಮಕ್ಕಳು ತುಂಬಾ ಉತ್ಸಾಹದಿಂದ ಇದ್ದಾರೆ. ಅವರು ನೃತ್ಯ ಮತ್ತು ಹಾಡುಗಳನ್ನು ಪ್ರಸ್ತುತಪಡಿಸುತ್ತಾರೆ.', 'śālēyalli indu vārṣikōtsavavide. ellā makkaḷu tumbā utsāhadinda iddāre. avaru nṛtya mattu hāḍugaḷannu prastutapaḍisuttāre. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ರಮೇಶ್ ಒಬ್ಬ ಒಳ್ಳೆಯ ವಿದ್ಯಾರ್ಥಿ. ಅವನು ಪ್ರತಿದಿನ ಗ್ರಂಥಾಲಯಕ್ಕೆ ಹೋಗುತ್ತಾನೆ. ಅವನಿಗೆ ವಿಜ್ಞಾನ ಮತ್ತು ಗಣಿತ ಇಷ್ಟ.', 'ramēś obba oḷḷeya vidyārthi. avanu pratidina granthālayakke hōguttāne. avanige vijñāna mattu gaṇita iṣṭa. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ನಮ್ಮ ಮನೆಯ ಹತ್ತಿರ ಒಂದು ದೊಡ್ಡ ಉದ್ಯಾನವನವಿದೆ. ಸಂಜೆ ಅನೇಕ ಜನರು ಅಲ್ಲಿ ನಡೆಯಲು ಬರುತ್ತಾರೆ. ಮಕ್ಕಳು ಅಲ್ಲಿ ಆಡುತ್ತಾರೆ.', 'nam''ma maneya hattira ondu doḍḍa udyānavanavide. sanje anēka janaru alli naḍeyalu baruttāre. makkaḷu alli āḍuttāre. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ವೈದ್ಯರು ನನಗೆ ಔಷಧಿ ಕೊಟ್ಟಿದ್ದಾರೆ. ನಾನು ದಿನಕ್ಕೆ ಮೂರು ಬಾರಿ ತೆಗೆದುಕೊಳ್ಳಬೇಕು. ನಾನು ಶೀಘ್ರದಲ್ಲಿ ಗುಣಮುಖನಾಗುತ್ತೇನೆ.', 'vaidyaru nanage auṣadhi koṭṭiddāre. nānu dinakke mūru bāri tegedukoḷḷabēku. nānu śīghradalli guṇamukhanāguttēne. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ಬೇಸಿಗೆ ರಜೆಯಲ್ಲಿ ನಾವು ಬೆಟ್ಟಗಳಿಗೆ ಹೋಗಿದ್ದೆವು. ಅಲ್ಲಿಯ ಹವಾಮಾನ ತುಂಬಾ ಆನಂದದಾಯಕವಾಗಿತ್ತು. ನಾವು ಅನೇಕ ಫೋಟೋಗಳನ್ನು ತೆಗೆದುಕೊಂಡೆವು.', 'bēsige rajeyalli nāvu beṭṭagaḷige hōgiddevu. alliya havāmāna tumbā ānandadāyakavāgittu. nāvu anēka phōṭōgaḷannu tegedukoṇḍevu. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ರೈಲು ಸಮಯಕ್ಕೆ ಬಂತು. ಎಲ್ಲಾ ಪ್ರಯಾಣಿಕರು ಇಳಿಯಲು ಪ್ರಾರಂಭಿಸಿದರು. ನಾನು ನನ್ನ ಸಾಮಾನುಗಳನ್ನು ತೆಗೆದುಕೊಂಡು ಹೊರಗೆ ಬಂದೆ.', 'railu samayakke bantu. ellā prayāṇikaru iḷiyalu prārambhisidaru. nānu nanna sāmānugaḷannu tegedukoṇḍu horage bande. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ಇಂದು ಭಾನುವಾರ ಮತ್ತು ಎಲ್ಲಾ ಅಂಗಡಿಗಳು ಮುಚ್ಚಿವೆ. ನಾವು ಮನೆಯಲ್ಲಿಯೇ ಇರುತ್ತೇವೆ. ಸಂಜೆ ನಾವು ಚಲನಚಿತ್ರ ನೋಡುತ್ತೇವೆ.', 'indu bhānuvāra mattu ellā aṅgaḍigaḷu muccive. nāvu maneyalliyē iruttēve. sanje nāvu calanapitra nōḍuttēve. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ರೈತ ಹೊಲದಲ್ಲಿ ಕೆಲಸ ಮಾಡುತ್ತಿದ್ದಾನೆ. ಅವನು ಗೋಧಿ ಬೆಳೆಯನ್ನು ಕೊಯ್ಲು ಮಾಡುತ್ತಿದ್ದಾನೆ. ಈ ವರ್ಷ ಬೆಳೆ ಚೆನ್ನಾಗಿದೆ.', 'raita holadalli kelasa māḍuttiddāne. avanu gōdhi beḷeyannu koylu māḍuttiddāne. ī varṣa beḷe cennāgide. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ನನ್ನ ಸಹೋದರಿ ಶಿಕ್ಷಕಿ. ಅವಳು ಪ್ರಾಥಮಿಕ ಶಾಲೆಯೊಂದರಲ್ಲಿ ಕಲಿಸುತ್ತಾಳೆ. ಮಕ್ಕಳು ಅವಳನ್ನು ತುಂಬಾ ಇಷ್ಟಪಡುತ್ತಾರೆ.', 'nanna sahōdari śikṣaki. avaḷu prāthamika śālēyondaralli kalisuttāḷe. makkaḷu avaḷannu tumbā iṣṭapaḍuttāre. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ನಗರದಲ್ಲಿ ಒಂದು ಹೊಸ ಆಸ್ಪತ್ರೆ ನಿರ್ಮಾಣವಾಗುತ್ತಿದೆ. ಇದು ತುಂಬಾ ದೊಡ್ಡದಾಗಿ ಮತ್ತು ಆಧುನಿಕವಾಗಿರುತ್ತದೆ. ಮುಂದಿನ ವರ್ಷ ಇದು ತೆರೆಯಲ್ಪಡುತ್ತದೆ.', 'nagaradalli ondu hosa āspatre nirmāṇavāguttide. idu tumbā doḍḍadāgi mattu ādunikavāgirutttade. mundina varṣa idu tereyalpaḍuttade. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ಮಕ್ಕಳು ಉದ್ಯಾನವನದಲ್ಲಿ ಆಡುತ್ತಿದ್ದಾರೆ. ಕೆಲವರು ಉಯ್ಯಾಲೆಯಲ್ಲಿ ಆಡುತ್ತಿದ್ದಾರೆ. ಕೆಲವರು ಫುಟ್‌ಬಾಲ್ ಆಡುತ್ತಿದ್ದಾರೆ.', 'makkaḷu udyānawanadalli āḍuttiddāre. kelavaru uyyālēyalli āḍuttiddāre. kelavaru phuṭbāl āḍuttiddāre. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:kannada'], '2', (select id from regions where key = 'IN:Karnataka'));

-- ============================================
-- MALAYALAM - 12 CARDS
-- Region: IN:Kerala
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'ഞാൻ ഇന്ന് രാവിലെ മാർക്കറ്റിലേക്ക് പോയി. അവിടെ ഒരുപാട് തിരക്കായിരുന്നു. ഞാൻ കുറച്ച് പഴങ്ങളും പച്ചക്കറികളും വാങ്ങി.', 'ñān innu rāvile mārkkaṟṟilēkku pōyi. aviṭe orupāṭu tirakkāyirunnu. ñān kuṟaccu paḻaṅṅaḷuṁ paccakkaṟikaḷuṁ vāṅṅi. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'സ്കൂളിൽ ഇന്ന് വാർഷികോത്സവമുണ്ട്. എല്ലാ കുട്ടികളും വളരെ ആവേശത്തിലാണ്. അവർ നൃത്തങ്ങളും പാട്ടുകളും അവതരിപ്പിക്കും.', 'skūḷil innu vārṣikōtsavammuṇṭu. ellā kuṭṭikaḷuṁ vaḷare āvēśattilāṇu. avar nṛttaṅṅaḷuṁ pāṭṭukaḷuṁ avatarippikkuṁ. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'രമേഷ് നല്ല വിദ്യാർത്ഥിയാണ്. അവൻ എല്ലാ ദിവസവും ലൈബ്രറിയിലേക്ക് പോകുന്നു. അവന് സയൻസും ഗണിതവും ഇഷ്ടമാണ്.', 'ramēṣ nalla vidyārththiyāṇu. avaṉ ellā divasvuṁ laibrēriyilēkku pōkunnu. avanu sayansuṁ gaṇitavuṁ iṣṭamāṇu. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ഞങ്ങളുടെ വീടിന് സമീപം ഒരു വലിയ പാർക്കുണ്ട്. വൈകുന്നേരം ഒരുപാട് ആളുകൾ അവിടെ നടക്കാൻ വരുന്നു. കുട്ടികൾ അവിടെ കളിക്കുന്നു.', 'ñaṅṅaḷuṭe vīṭinu samīpaṁ oru valiya pārkkuṇṭu. vaikunnēraṁ orupāṭu āḷukaḷ aviṭe naṭakkān varunnu. kuṭṭikaḷ aviṭe kaḷikkunnu. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ഡോക്ടർ എനിക്ക് മരുന്ന് തന്നു. ഞാൻ ദിവസവും മൂന്ന് പ്രാവശ്യം എടുക്കണം. ഞാൻ പെട്ടെന്ന് സുഖമാകും.', 'ḍōkṭar enikku marunnu tannu. ñān divasavuṁ mūnnu prāvaśyaṁ eṭukkaṇaṁ. ñān peṭṭennu sukhamākuṁ. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'വേനൽ അവധിയിൽ ഞങ്ങൾ മലകളിലേക്ക് പോയി. അവിടെ കാലാവസ്ഥ വളരെ സുഖകരമായിരുന്നു. ഞങ്ങൾ ഒരുപാട് ഫോട്ടോകൾ എടുത്തു.', 'vēnal avadhiyil ñaṅṅaḷ malakalilēkku pōyi. aviṭe kālāvastha vaḷare sukhakaramāyirunnu. ñaṅṅaḷ orupāṭ phōṭṭōkaḷ eṭuttu. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ട്രെയിൻ സമയത്ത് വന്നു. എല്ലാ യാത്രക്കാരും ഇറങ്ങാൻ തുടങ്ങി. ഞാൻ എന്റെ സാധനങ്ങൾ എടുത്ത് പുറത്തേക്ക് വന്നു.', 'ṭreyin samayattu vannu. ellā yātrakkāruṁ iṟaṅṅān tuṭaṅṅi. ñān enṟe sādhanaṅṅaḷ eṭuttu puṟattēkku vannu. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ഇന്ന് ഞായറാഴ്ചയാണ്, എല്ലാ കടകളും അടച്ചിരിക്കുന്നു. ഞങ്ങൾ വീട്ടിൽ തന്നെ ഇരിക്കും. വൈകുന്നേരം ഞങ്ങൾ സിനിമ കാണും.', 'innu ñāyarāḻcayāṇu, ellā kaṭakaḷuṁ aṭaccirikkunnu. ñaṅṅaḷ vīṭṭil tanne irikku. vaikunnēraṁ ñaṅṅaḷ sinima kāṇuṁ. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'കർഷകൻ വയലിൽ ജോലി ചെയ്യുന്നു. അവൻ ഗോതമ്പ് വിളവെടുക്കുന്നു. ഈ വർഷം വിള നന്നായി.', 'karṣakaṉ vayalil jōli ceyyunnu. avaṉ gōtamp viḷaveṭukkunnu. ī varṣaṁ viḷa nannāyi. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'എന്റെ സഹോദരി അധ്യാപികയാണ്. അവൾ ഒരു പ്രാഥമിക വിദ്യാലയത്തിൽ പഠിപ്പിക്കുന്നു. കുട്ടികൾ അവളെ വളരെ ഇഷ്ടപ്പെടുന്നു.', 'enṟe sahōdari adhyāpikayāṇu. avaḷ oru prāthamika vidyālayattil paṭhippikkunnu. kuṭṭikaḷ avaḷe vaḷare iṣṭappeṭunnu. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'നഗരത്തിൽ ഒരു പുതിയ ആശുപത്രി നിർമ്മിച്ചുകൊണ്ടിരിക്കുന്നു. അത് വളരെ വലുതും ആധുനികവുമായിരിക്കും. അടുത്ത വർഷം അത് തുറക്കും.', 'nagarattil oru putiya āśupatri nirmmiccukoṇṭirikkunnu. atu vaḷare valuttuṁ ādhunikavumāyirikku. aṭutta varṣaṁ atu tuṟakkuṁ. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'കുട്ടികൾ പാർക്കിൽ കളിക്കുന്നു. ചിലർ ഊഞ്ഞാലിൽ ആടുന്നു. ചിലർ ഫുട്ബോൾ കളിക്കുന്നു.', 'kuṭṭikaḷ pārkkil kaḷikkunnu. cilar ūññālil āṭunnu. cilar phuṭbōḷ kaḷikkunnu. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:malayalam'], '2', (select id from regions where key = 'IN:Kerala'));

-- ============================================
-- BENGALI - 12 CARDS
-- Region: IN:West_Bengal
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'আমি আজ সকালে বাজারে গিয়েছিলাম। সেখানে অনেক ভিড় ছিল। আমি কিছু ফল এবং সবজি কিনেছিলাম।', 'āmi āj sakāle bājāre giẏechilām. sekhāne anek bhiṛ chila. āmi kichu phal ebam sabaji kinechilām. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'স্কুলে আজ বার্ষিক অনুষ্ঠান আছে। সব বাচ্চারা খুব উৎসাহিত। তারা নৃত্য এবং গান পরিবেশন করবে।', 'skule āj bārṣik anuṣṭhān āche. sab bācchārā khub utsāhita. tārā nr̥tya ebam gān paribeśan karbe. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'রমেশ একজন ভালো ছাত্র। সে প্রতিদিন লাইব্রেরিতে যায়। তার বিজ্ঞান এবং গণিত পছন্দ।', 'rameś ekjan bhālo chātra. se pratidin lāibrerrite yāẏ. tār bijñān ebam gaṇit pachanda. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'আমাদের বাড়ির কাছে একটি বড় পার্ক আছে। সন্ধ্যায় অনেক লোক সেখানে হাঁটতে আসে। বাচ্চারা সেখানে খেলে।', 'āmāder bāṛir kāche ekṭi baṛ pārk āche. sandhyāẏ anek lok sekhāne hām̐ṭate āse. bācchārā sekhāne khele. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ডাক্তার আমাকে ওষুধ দিয়েছেন। আমি দিনে তিনবার খেতে হবে। আমি শীঘ্রই সুস্থ হয়ে যাব।', 'ḍāktār āmāke oṣudh diẏechen. āmi dine tinbār khete habe. āmi śīghrai sustha haẏe yāb. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'গ্রীষ্মের ছুটিতে আমরা পাহাড়ে গিয়েছিলাম। সেখানকার আবহাওয়া খুব মনোরম ছিল। আমরা অনেক ছবি তুলেছিলাম।', 'grīṣmer chuṭite āmrā pāhāṛe giẏechilām. sekhānkār ābahāoẏā khub manoram chila. āmrā anek chabi tulechilām. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ট্রেন সময়মতো এসেছে। সব যাত্রীরা নামতে শুরু করল। আমি আমার মালপত্র নিয়ে বাইরে এলাম।', 'ṭren samaẏamato esēche. sab yātrīrā nāmate śuru karal. āmi āmār mālpatra niẏe bāire elām. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'আজ রবিবার এবং সব দোকান বন্ধ। আমরা বাড়িতেই থাকব। সন্ধ্যায় আমরা সিনেমা দেখব।', 'āj rabibār ebam sab dokān bandha. āmrā bāṛitei thākab. sandhyāẏ āmrā sinemā dekhab. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'কৃষক মাঠে কাজ করছে। সে গমের ফসল কাটছে। এই বছর ফসল ভালো হয়েছে।', 'kr̥ṣak māṭhe kāj karachhe. se gamer phasal kāṭachhe. ei bachhar phasal bhālo haẏeche. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'আমার বোন শিক্ষিকা। তিনি একটি প্রাথমিক বিদ্যালয়ে পড়ান। বাচ্চারা তাকে খুব পছন্দ করে।', 'āmār bon śikṣikā. tini ekaṭi prāthamik bidyālaẏe paṛān. bācchārā tāke khub pachanda kare. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'শহরে একটি নতুন হাসপাতাল তৈরি হচ্ছে। এটি খুব বড় এবং আধুনিক হবে। আগামী বছর এটি খুলবে।', 'śahare ekaṭi natun hāspātāl tairi hachche. eṭi khub baṛ ebam ādhunik habe. āgāmī bachhar eṭi khulbe. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'বাচ্চারা পার্কে খেলছে। কেউ দোলনায় দুলছে। কেউ ফুটবল খেলছে।', 'bācchārā pārke khelchhe. keu dolanāẏ dulchhe. keu phuṭabal khelchhe. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:bengali'], '2', (select id from regions where key = 'IN:West_Bengal'));

-- ============================================
-- ASSAMESE - 12 CARDS
-- Region: IN:Assam
-- Note: Uses Bengali script with some distinctions
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'মই আজি পুৱা বজাৰলৈ গৈছিলোঁ। তাত বহুত ভিৰ আছিল। মই কিছু ফল আৰু পাচলি কিনিলোঁ।', 'moi āji puwā bajāralai gaisilo̐. tāt bahut bhir āsil. moi kisu phal āru pācali kinilo̐. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'বিদ্যালয়ত আজি বাৰ্ষিক অনুষ্ঠান আছে। সকলো ল''ৰা-ছোৱালী বহুত উৎসাহিত। তেওঁলোকে নৃত্য আৰু গীত পৰিবেশন কৰিব।', 'bidyālaẏat āji bārṣik anuṣṭhān āche. sakalo l''rā-sowālī bahut utsāhit. teo̐loke nr̥tya āru gīt paribeśan karib. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ৰমেশ এজন ভাল ছাত্ৰ। তেওঁ প্ৰতিদিনে পুথিভঁৰাললৈ যায়। তেওঁৰ বিজ্ঞান আৰু গণিত ভাল লাগে।', 'rameś ejan bhāl chātr. teo̐ pratidine puthibha̐rālalai yāy. teo̐r bijñān āru gaṇit bhāl lāge. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'আমাৰ ঘৰৰ ওচৰত এখন ডাঙৰ উদ্যান আছে। গধূলি বহুত মানুহ তালৈ ফুৰিবলৈ আহে। ল''ৰা-ছোৱালীয়ে তাত খেলে।', 'āmār gharar osarat ekhan dāṅar udyān āche. gadhūli bahut mānuh tālai phuribali āhe. l''rā-sowālīye tāt khele. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'চিকিৎসকে মোক ঔষধ দিছে। মই দিনত তিনিবাৰ খাব লাগিব। মই শীঘ্ৰে সুস্থ হৈ যাম।', 'cikitsake mok aușadh diche. moi dinat tinibār khāb lāgib. moi śīghre susth hai yām. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'গ্ৰীষ্মৰ বন্ধত আমি পাহাৰলৈ গৈছিলোঁ। তাৰ বতৰ বহুত সুন্দৰ আছিল। আমি বহুত ফটো তুলিলোঁ।', 'grīṣmar bandhat āmi pāhāralai gaisilo̐. tār batar bahut sundar āsil. āmi bahut phoṭo tulilo̐. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ৰেলগাড়ী সময়মতে আহিল। সকলো যাত্ৰীয়ে নামিবলৈ আৰম্ভ কৰিলে। মই মোৰ বস্তুবোৰ লৈ বাহিৰলৈ আহিলোঁ।', 'relgāṛī samaẏamate āhil. sakalo yātrīye nāmibali ārambh karile. moi mor bastubor lai bāhiralai āhilo̐. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'আজি দেওবাৰ আৰু সকলো দোকান বন্ধ। আমি ঘৰতে থাকিম। গধূলি আমি চিনেমা চাম।', 'āji deobār āru sakalo dokān bandh. āmi gharte thākim. gadhūli āmi sinemā cām. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'কৃষকে পথাৰত কাম কৰি আছে। তেওঁ ঘেঁহুৰ শস্য দাই আছে। এইবাৰ শস্য ভাল হৈছে।', 'kr̥ṣake pathārat kām kari āche. teo̐ ghe̐hur śasya dāi āche. eibār śasya bhāl haise. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'মোৰ ভনীয়েক শিক্ষয়িত্ৰী। তেওঁ এখন প্ৰাথমিক বিদ্যালয়ত পঢ়ায়। ল''ৰা-ছোৱালীয়ে তেওঁক বহুত ভাল পায়।', 'mor bhanīẏek śikṣaẏitrī. teo̐ ekhan prāthamik bidyālaẏat paṛhaẏ. l''rā-sowālīye teo̐k bahut bhāl pāẏ. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'চহৰত এখন নতুন চিকিৎসালয় নিৰ্মাণ হৈ আছে। এইখন বহুত ডাঙৰ আৰু আধুনিক হ''ব। পিছৰ বছৰ এইখন খোলিব।', 'caharat ekhan natun cikitsālaẏ nirmāṇ hai āche. eikhan bahut dāṅar āru ādhunik h''b. pishar bachhar eikhan kholib. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ল''ৰা-ছোৱালীয়ে উদ্যানত খেলি আছে। কিছুমানে দোলত দুলি আছে। কিছুমানে ফুটবল খেলি আছে।', 'l''rā-sowālīye udyānat kheli āche. kisumāne dolat duli āche. kisumāne phuṭabal kheli āche. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:assamese'], '2', (select id from regions where key = 'IN:Assam'));

-- ============================================
-- GUJARATI - 12 CARDS
-- Region: IN:Gujarat
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'હું આજે સવારે બજારમાં ગયો હતો. ત્યાં ઘણી ભીડ હતી. મેં કેટલાક ફળો અને શાકભાજી ખરીદી.', 'hu̐ āje savāre bajāramā̐ gayo hato. tyā̐ ghaṇī bhīḍ hatī. me̐ keṭalāk phaḷo ane śākabhājī kharīdī. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'શાળામાં આજે વાર્ષિક સમારોહ છે. બધા બાળકો ખૂબ ઉત્સાહિત છે. તેઓ નૃત્ય અને ગીતો રજૂ કરશે.', 'śāḷāmā̐ āje vārṣik samāroh che. badhā bāḷako khūb utsāhit che. teo nr̥tya ane gīto rajū karaśe. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'રમેશ એક સારો વિદ્યાર્થી છે. તે રોજ પુસ્તકાલયમાં જાય છે. તેને વિજ્ઞાન અને ગણિત ગમે છે.', 'rameś ek sāro vidyārthī che. te roj pustakālayamā̐ jāy che. tene vijñān ane gaṇit game che. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'અમારા ઘરની નજીક એક મોટો બગીચો છે. સાંજે ઘણા લોકો ત્યાં ફરવા આવે છે. બાળકો ત્યાં રમે છે.', 'amārā gharanī najīk ek moṭo bagīco che. sā̐je ghaṇā loko tyā̐ pharavā āve che. bāḷako tyā̐ rame che. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ડૉક્ટરે મને દવા આપી છે. મારે દિવસમાં ત્રણ વખત લેવી છે. હું જલદી સાજો થઈ જઈશ.', 'ḍo̐kṭare mane davā āpī che. māre divasamā̐ traṇ vakhat levī che. hu̐ jaladī sājo thaī jaīś. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ઉનાળાની રજાઓમાં અમે પહાડો પર ગયા હતા. ત્યાંનું હવામાન ખૂબ સુખદ હતું. અમે ઘણા ફોટા પાડ્યા.', 'unāḷānī rajāomā̐ ame pahāḍo par gayā hatā. tyā̐nu̐ havāmān khūb sukhad hatu̐. ame ghaṇā phoṭā pāḍyā. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ટ્રેન સમયસર આવી. બધા પ્રવાસીઓ ઉતરવા લાગ્યા. મેં મારો સામાન ઉપાડ્યો અને બહાર આવ્યો.', 'ṭren samayasar āvī. badhā pravāsīo utaravā lāgyā. me̐ māro sāmān upāḍyo ane bahār āvyo. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'આજે રવિવાર છે અને બધી દુકાનો બંધ છે. અમે ઘરમાં જ રહીશું. સાંજે અમે ફિલ્મ જોઈશું.', 'āje ravivār che ane badhī dukāno bandh che. ame gharamā̐ ja rahīśu̐. sā̐je ame philm joīśu̐. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ખેડૂત ખેતરમાં કામ કરી રહ્યો છે. તે ઘઉંનો પાક કાપી રહ્યો છે. આ વર્ષે પાક સારો થયો છે.', 'kheḍūt khetaramā̐ kām karī rahyo che. te ghau̐no pāk kāpī rahyo che. ā varṣe pāk sāro thayo che. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'મારી બહેન શિક્ષિકા છે. તે એક પ્રાથમિક શાળામાં ભણાવે છે. બાળકો તેને ખૂબ પસંદ કરે છે.', 'mārī bahen śikṣikā che. te ek prāthamik śāḷāmā̐ bhaṇāve che. bāḷako tene khūb pasand kare che. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'શહેરમાં એક નવી હોસ્પિટલ બની રહી છે. તે ખૂબ મોટી અને આધુનિક હશે. આગામી વર્ષે તે ખુલશે.', 'śaheramā̐ ek navī hospiṭal banī rahī che. te khūb moṭī ane ādhunik haśe. āgāmī varṣe te khulaśe. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'બાળકો બગીચામાં રમી રહ્યા છે. કેટલાક ઝૂલા પર ઝૂલી રહ્યા છે. કેટલાક ફૂટબોલ રમી રહ્યા છે.', 'bāḷako bagīcāmā̐ ramī rahyā che. keṭalāk jhūlā par jhūlī rahyā che. keṭalāk phūṭabol ramī rahyā che. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:gujarati'], '2', (select id from regions where key = 'IN:Gujarat'));

-- ============================================
-- PUNJABI (GURMUKHI) - 12 CARDS
-- Region: IN:Punjab
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਮੈਂ ਅੱਜ ਸਵੇਰੇ ਬਜ਼ਾਰ ਗਿਆ ਸੀ। ਉੱਥੇ ਬਹੁਤ ਭੀੜ ਸੀ। ਮੈਂ ਕੁਝ ਫਲ ਅਤੇ ਸਬਜ਼ੀਆਂ ਖਰੀਦੀਆਂ।', 'maiṁ ajj savere bazār giā sī. utthe bahut bhīṛ sī. maiṁ kujh phal ate sabzīāṁ kharīdīāṁ. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਸਕੂਲ ਵਿਚ ਅੱਜ ਸਾਲਾਨਾ ਸਮਾਗਮ ਹੈ। ਸਾਰੇ ਬੱਚੇ ਬਹੁਤ ਉਤਸ਼ਾਹਿਤ ਹਨ। ਉਹ ਨਾਚ ਅਤੇ ਗੀਤ ਪੇਸ਼ ਕਰਨਗੇ।', 'sakūl vic ajj salānā samāgam hai. sāre bacce bahut utsāhit han. uh nāc ate gīt peś karange. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਰਮੇਸ਼ ਇਕ ਚੰਗਾ ਵਿਦਿਆਰਥੀ ਹੈ। ਉਹ ਰੋਜ਼ ਲਾਇਬ੍ਰੇਰੀ ਜਾਂਦਾ ਹੈ। ਉਸਨੂੰ ਵਿਗਿਆਨ ਅਤੇ ਗਣਿਤ ਪਸੰਦ ਹੈ।', 'rameś ik caṅgā vidiārthī hai. uh roz lāibrerī jāṁdā hai. usanūṁ vigiān ate gaṇit pasand hai. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਸਾਡੇ ਘਰ ਦੇ ਨੇੜੇ ਇਕ ਵੱਡਾ ਪਾਰਕ ਹੈ। ਸ਼ਾਮ ਨੂੰ ਬਹੁਤ ਸਾਰੇ ਲੋਕ ਉੱਥੇ ਸੈਰ ਕਰਨ ਆਉਂਦੇ ਹਨ। ਬੱਚੇ ਉੱਥੇ ਖੇਡਦੇ ਹਨ।', 'sāḍe ghar de neṛe ik vaḍḍā pārak hai. śām nūṁ bahut sāre lok utthe sair karan auṁde han. bacce utthe kheḍde han. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਡਾਕਟਰ ਨੇ ਮੈਨੂੰ ਦਵਾਈ ਦਿੱਤੀ ਹੈ। ਮੈਨੂੰ ਦਿਨ ਵਿਚ ਤਿੰਨ ਵਾਰ ਲੈਣੀ ਹੈ। ਮੈਂ ਜਲਦੀ ਹੀ ਠੀਕ ਹੋ ਜਾਵਾਂਗਾ।', 'ḍākṭar ne mainūṁ davāī dittī hai. mainūṁ din vic tinn vār laiṇī hai. maiṁ jaladī hī ṭhīk ho jāvāṅgā. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਗਰਮੀਆਂ ਦੀਆਂ ਛੁੱਟੀਆਂ ਵਿਚ ਅਸੀਂ ਪਹਾੜਾਂ ਉੱਤੇ ਗਏ ਸੀ। ਉੱਥੇ ਦਾ ਮੌਸਮ ਬਹੁਤ ਸੁਹਾਵਣਾ ਸੀ। ਅਸੀਂ ਬਹੁਤ ਸਾਰੀਆਂ ਤਸਵੀਰਾਂ ਖਿੱਚੀਆਂ।', 'garamīāṁ dīāṁ chuṭṭīāṁ vic asīṁ pahāṛāṁ utte gae sī. utthe dā mausam bahut suhāvaṇā sī. asīṁ bahut sārīāṁ tasvīrāṁ khiccīāṁ. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਰੇਲਗੱਡੀ ਸਮੇਂ ਸਿਰ ਆ ਗਈ। ਸਾਰੇ ਯਾਤਰੀ ਉਤਰਨ ਲੱਗੇ। ਮੈਂ ਆਪਣਾ ਸਮਾਨ ਚੁੱਕਿਆ ਅਤੇ ਬਾਹਰ ਆ ਗਿਆ।', 'relgaḍḍī samēṁ sir ā gaī. sāre yātarī utaran lagge. maiṁ āpaṇā samān cukiā ate bāhar ā giā. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਅੱਜ ਐਤਵਾਰ ਹੈ ਅਤੇ ਸਾਰੀਆਂ ਦੁਕਾਨਾਂ ਬੰਦ ਹਨ। ਅਸੀਂ ਘਰ ਵਿਚ ਹੀ ਰਹਾਂਗੇ। ਸ਼ਾਮ ਨੂੰ ਅਸੀਂ ਫ਼ਿਲਮ ਦੇਖਾਂਗੇ।', 'ajj aitavār hai ate sārīāṁ dukānāṁ band han. asīṁ ghar vic hī rahāṅge. śām nūṁ asīṁ film dekhāṅge. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਕਿਸਾਨ ਖੇਤ ਵਿਚ ਕੰਮ ਕਰ ਰਿਹਾ ਹੈ। ਉਹ ਕਣਕ ਦੀ ਫ਼ਸਲ ਵੱਢ ਰਿਹਾ ਹੈ। ਇਸ ਸਾਲ ਫ਼ਸਲ ਚੰਗੀ ਹੋਈ ਹੈ।', 'kisān khet vic kamm kar rihā hai. uh kaṇak dī fasal vaḍḍh rihā hai. is sāl fasal caṅgī hoī hai. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਮੇਰੀ ਭੈਣ ਅਧਿਆਪਿਕਾ ਹੈ। ਉਹ ਇਕ ਪ੍ਰਾਇਮਰੀ ਸਕੂਲ ਵਿਚ ਪੜ੍ਹਾਉਂਦੀ ਹੈ। ਬੱਚੇ ਉਸਨੂੰ ਬਹੁਤ ਪਸੰਦ ਕਰਦੇ ਹਨ।', 'merī bhaiṇ adhiāpikā hai. uh ik prāimarī sakūl vic paṛhāuṁdī hai. bacce usanūṁ bahut pasand karde han. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਸ਼ਹਿਰ ਵਿਚ ਇਕ ਨਵਾਂ ਹਸਪਤਾਲ ਬਣ ਰਿਹਾ ਹੈ। ਇਹ ਬਹੁਤ ਵੱਡਾ ਅਤੇ ਆਧੁਨਿਕ ਹੋਵੇਗਾ। ਅਗਲੇ ਸਾਲ ਇਹ ਖੁੱਲ੍ਹੇਗਾ।', 'śahir vic ik navāṁ haspatāl baṇ rihā hai. ih bahut vaḍḍā ate ādhunik hovegā. agale sāl ih khulhegā. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ਬੱਚੇ ਪਾਰਕ ਵਿਚ ਖੇਡ ਰਹੇ ਹਨ। ਕੁਝ ਝੂਲੇ ਤੇ ਝੂਲ ਰਹੇ ਹਨ। ਕੁਝ ਫੁੱਟਬਾਲ ਖੇਡ ਰਹੇ ਹਨ।', 'bacce pārak vic kheḍ rahe han. kujh jhūle te jhūl rahe han. kujh fuṭṭabāl kheḍ rahe han. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:gurmukhi:punjabi'], '2', (select id from regions where key = 'IN:Punjab'));

-- ============================================
-- ODIA - 12 CARDS
-- Region: IN:Odisha
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'ମୁଁ ଆଜି ସକାଳେ ବଜାରକୁ ଯାଇଥିଲି। ସେଠାରେ ବହୁତ ଭିଡ଼ ଥିଲା। ମୁଁ କିଛି ଫଳ ଏବଂ ପନିପରିବା କିଣିଥିଲି।', 'muṁ āji sakāḷe bajāraku yāithili. seṭhāre bahut bhiṛa thilā. muṁ kicha phaḷa ebaṁ paniparibā kiṇithili. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ବିଦ୍ୟାଳୟରେ ଆଜି ବାର୍ଷିକ ଉତ୍ସବ ଅଛି। ସମସ୍ତ ପିଲାମାନେ ବହୁତ ଉତ୍ସାହିତ। ସେମାନେ ନୃତ୍ୟ ଓ ଗୀତ ପ୍ରଦର୍ଶନ କରିବେ।', 'bidyāḷayare āji bārṣika utsaba achi. samasta pilāmāne bahut utsāhita. semāne nr̥tya o gīta pradarśana karibe. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ରମେଶ ଜଣେ ଭଲ ଛାତ୍ର। ସେ ପ୍ରତିଦିନ ପୁସ୍ତକାଳୟକୁ ଯାଆନ୍ତି। ତାଙ୍କୁ ବିଜ୍ଞାନ ଓ ଗଣିତ ପସନ୍ଦ।', 'rameśa jaṇe bhala chātra. se pratidina pustakāḷayaku yāānti. tāṅku bijñāna o gaṇita pasanda. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ଆମ ଘର ପାଖରେ ଗୋଟିଏ ବଡ଼ ଉଦ୍ୟାନ ଅଛି। ସନ୍ଧ୍ୟାରେ ବହୁତ ଲୋକ ସେଠାକୁ ବୁଲିବାକୁ ଆସନ୍ତି। ପିଲାମାନେ ସେଠାରେ ଖେଳନ୍ତି।', 'āma ghara pākhare goṭie baṛa udyāna achi. sandhyāre bahut loka seṭhāku bulibāku āsanti. pilāmāne seṭhāre kheḷanti. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ଡାକ୍ତର ମୋତେ ଔଷଧ ଦେଇଛନ୍ତି। ମୋତେ ଦିନକୁ ତିନିଥର ଖାଇବାକୁ ହେବ। ମୁଁ ଶୀଘ୍ର ସୁସ୍ଥ ହୋଇଯିବି।', 'ḍāktar mote auṣadha deichanti. mote dinaku tinithara khāibāku heba. muṁ śīghra sustha hoiyibi. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ଗ୍ରୀଷ୍ମ ଛୁଟିରେ ଆମେ ପାହାଡ଼କୁ ଯାଇଥିଲୁ। ସେଠାର ପାଗ ବହୁତ ମନୋରମ ଥିଲା। ଆମେ ବହୁତ ଫଟୋ ଉଠାଇଥିଲୁ।', 'grīṣma chuṭire āme pāhāṛaku yāithilu. seṭhāra pāga bahut manorama thilā. āme bahut phaṭo uṭhāithilu. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ଟ୍ରେନ୍ ସମୟରେ ଆସିଲା। ସମସ୍ତ ଯାତ୍ରୀ ଓହ୍ଲାଇବାକୁ ଲାଗିଲେ। ମୁଁ ମୋର ସାମାନ ନେଇ ବାହାରକୁ ଆସିଲି।', 'ṭren samayare āsilā. samasta yātrī ohlāibāku lāgile. muṁ mora sāmāna nei bāhāraku āsili. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ଆଜି ରବିବାର ଏବଂ ସମସ୍ତ ଦୋକାନ ବନ୍ଦ। ଆମେ ଘରେ ହିଁ ରହିବୁ। ସନ୍ଧ୍ୟାରେ ଆମେ ସିନେମା ଦେଖିବୁ।', 'āji rabibāra ebaṁ samasta dokāna banda. āme ghare hiṁ rahibu. sandhyāre āme sinemā dekhibu. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'କୃଷକ କ୍ଷେତରେ କାମ କରୁଛନ୍ତି। ସେ ଗହମ ଫସଲ କାଟୁଛନ୍ତି। ଏହି ବର୍ଷ ଫସଲ ଭଲ ହୋଇଛି।', 'kr̥ṣaka kṣetare kāma karuchanti. se gahama phasala kāṭuchanti. ehi barṣa phasala bhala hoichi. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ମୋର ଭଉଣୀ ଶିକ୍ଷୟିତ୍ରୀ। ସେ ଗୋଟିଏ ପ୍ରାଥମିକ ବିଦ୍ୟାଳୟରେ ପଢ଼ାନ୍ତି। ପିଲାମାନେ ତାଙ୍କୁ ବହୁତ ପସନ୍ଦ କରନ୍ତି।', 'mora bhauṇī śikṣayitrī. se goṭie prāthamika bidyāḷayare paṛhānti. pilāmāne tāṅku bahut pasanda karanti. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ସହରରେ ଗୋଟିଏ ନୂଆ ଡାକ୍ତରଖାନା ନିର୍ମାଣ ହେଉଛି। ଏହା ବହୁତ ବଡ଼ ଓ ଆଧୁନିକ ହେବ। ଆଗାମୀ ବର୍ଷ ଏହା ଖୋଲିବ।', 'sahārare goṭie nūā ḍāktarakhānā nirmāṇa heuchi. ehā bahut baṛa o ādhunika heba. āgāmī barṣa ehā kholiba. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ପିଲାମାନେ ଉଦ୍ୟାନରେ ଖେଳୁଛନ୍ତି। କେହି ଝୁଲଣାରେ ଝୁଲୁଛନ୍ତି। କେହି ଫୁଟବଲ ଖେଳୁଛନ୍ତି।', 'pilāmāne udyānare kheḷuchanti. kehi jhuḷaṇāre jhuḷuchanti. kehi phuṭabala kheḷuchanti. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:odia'], '2', (select id from regions where key = 'IN:Odisha'));

-- ============================================
-- MANIPURI (MEITEI MAYEK) - 12 CARDS
-- Region: IN:Manipur
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯑꯩꯅ ꯉꯁꯤ ꯅꯨꯃꯤꯠꯇ ꯀꯩꯊꯦꯂꯗ ꯆꯠꯈꯤ꯫ ꯃꯐꯝ ꯑꯗꯨꯗ ꯃꯤꯌꯥꯝ ꯌꯥꯝꯅ ꯂꯩꯔꯝꯃꯤ꯫ ꯑꯩꯅ ꯃꯄꯥꯟ ꯑꯃꯁꯨꯡ ꯍꯤꯗꯥꯛ ꯀꯌꯥ ꯂꯧꯈꯤ꯫', 'eina ngasi numit-ta keithel-da chat-khi. mapham adu-da miyam yamna lei-ram-mi. eina mapan amashung hidak kaya lou-khi. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯁꯥꯟꯅꯄꯣꯠꯇ ꯉꯁꯤ ꯆꯍꯤꯒꯤ ꯊꯧꯔꯝ ꯂꯩ꯫ ꯑꯉꯥꯡꯁꯤꯡ ꯄꯨꯝꯅꯃꯛ ꯌꯥꯝꯅ ꯅꯨꯡꯉꯥꯏꯕꯥ ꯂꯩ꯫ ꯃꯈꯣꯌꯅ ꯏꯁꯩ ꯑꯃꯁꯨꯡ ꯅꯨꯡꯁꯤꯠ ꯄꯥꯡꯊꯣꯀꯄ ꯇꯧꯒꯅꯤ꯫', 'sanna-pot-ta ngasi chahi-gi thouramlamleiba lei. angashing pumnamak yamna nungaiba lei. makhoy-na ishei amashung nungshit pangthokpa tou-gani. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯔꯃꯦꯁ ꯑꯁꯤ ꯐꯖꯕ ꯃꯍꯩꯔꯣꯏ ꯑꯃꯅꯤ꯫ ꯃꯍꯥꯛ ꯅꯨꯃꯤꯠ ꯈꯨꯗꯤꯡꯗ ꯂꯥꯏꯕ꯭ꯔꯦꯔꯤꯗ ꯆꯠꯂꯤ꯫ ꯃꯍꯥꯛꯅ ꯁꯥꯏꯟꯁ ꯑꯃꯁꯨꯡ ꯃꯦꯊ ꯄꯥꯝꯃꯤ꯫', 'ramesh asi phajaba maheiroiba amani. mahak numit khudingda library-da chat-li. mahak-na science amashung math pam-mi. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯑꯩꯈꯣꯌꯒꯤ ꯌꯨꯝ ꯃꯅꯨꯡꯗ ꯑꯆꯧꯕ ꯄꯥꯔꯛ ꯑꯃꯥ ꯂꯩ꯫ ꯑꯌꯨꯛꯇ ꯃꯤꯌꯥꯝ ꯑꯌꯥꯝꯕꯅ ꯃꯐꯝ ꯑꯗꯨꯗ ꯈꯣꯡꯅꯥ ꯆꯠꯂꯤ꯫ ꯑꯉꯥꯡꯁꯤꯡꯅ ꯃꯐꯝ ꯑꯗꯨꯗ ꯁꯥꯟꯅꯩ꯫', 'eikhoi-gi yum manungda achouba park ama lei. ayuk-ta miyam ayamba-na mapham adu-da khongna chat-li. angangsing-na mapham adu-da sangnei. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯗꯣꯛꯇꯔꯅ ꯑꯩꯉꯣꯟꯗ ꯂꯥꯢ ꯄꯤꯈꯤ꯫ ꯑꯩꯅ ꯅꯨꯃꯤꯠꯇ ꯑꯍꯨꯝ ꯆꯥꯕ ꯃꯊꯧ ꯇꯥꯏ꯫ ꯑꯩꯅ ꯊꯨꯅꯥ ꯐꯒꯅꯤ꯫', 'doctor-na eibonda lai pi-khi. eina numit-ta ahum chaba mathou tai. eina thuna phagani. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯅꯨꯡꯁꯤꯠꯀꯤ ꯆꯨꯇꯤꯗ ꯑꯩꯈꯣꯌ ꯇꯨꯔꯦꯂꯗ ꯆꯠꯈꯤ꯫ ꯃꯐꯝ ꯑꯗꯨꯒꯤ ꯅꯣꯡꯖꯨ-ꯅꯨꯡꯁꯥ ꯌꯥꯝꯅ ꯐꯖꯈꯤ꯫ ꯑꯩꯈꯣꯌꯅ ꯐꯣꯇꯣ ꯑꯌꯥꯝꯕ ꯂꯧꯈꯤ꯫', 'nungshit-ki chuti-da eikhoi turel-da chat-khi. mapham adu-gi nongju-nungsha yamna phaj-khi. eikhoi-na photo ayamba lou-khi. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯔꯦꯜ ꯃꯇꯝ ꯆꯥꯅ ꯂꯥꯀꯈꯤ꯫ ꯈꯣꯡꯆꯠ ꯇꯧꯔꯤꯕꯁꯤꯡ ꯄꯨꯝꯅꯃꯛ ꯇꯣꯛꯅꯥ ꯍꯧꯈꯤ꯫ ꯑꯩꯅ ꯑꯩꯒꯤ ꯄꯣꯠꯁꯀꯁꯤꯡ ꯄꯨꯊꯣꯛꯇꯨꯅ ꯃꯄꯥꯟꯗ ꯂꯥꯀꯈꯤ꯫', 'rel matam chana lak-khi. khongchat touribasing pumnamak tokna hou-khi. eina ei-gi pot-shakshingsing puthok-tuna mapan-da lak-khi. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯉꯁꯤ ꯅꯣꯡꯃꯥꯢꯖꯤꯟ ꯑꯃꯁꯨꯡ ꯀꯩꯊꯦꯜ ꯄꯨꯝꯅꯃꯛ ꯊꯤꯡꯂꯦ꯫ ꯑꯩꯈꯣꯌ ꯌꯨꯝꯗ ꯂꯩꯒꯅꯤ꯫ ꯑꯌꯨꯛꯇ ꯁꯤꯅꯦꯃꯥ ꯌꯦꯡꯒꯅꯤ꯫', 'ngasi nongmaiching amashung keithel pumnamak thingle. eikhoi yum-da leigani. ayuk-ta cinema yenggani. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯂꯧꯃꯤꯅ ꯂꯧꯕꯨꯛꯇ ꯊꯕꯛ ꯇꯧꯔꯤ꯫ ꯃꯍꯥꯛꯅ ꯒꯍꯨꯃꯒꯤ ꯃꯔꯨ ꯊꯧꯔꯤ꯫ ꯆꯍꯤ ꯑꯁꯤꯗ ꯃꯔꯨ ꯌꯥꯝꯅ ꯐꯖꯈꯤ꯫', 'loumi-na loubuk-ta thabak touri. mahak-na gahum-gi maru thouri. chahi asi-da maru yamna phaj-khi. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯑꯩꯒꯤ ꯏꯆꯥꯟꯕꯤ ꯑꯁꯤ ꯑꯣꯖꯥ ꯑꯃꯅꯤ꯫ ꯃꯍꯥꯛ ꯄ꯭ꯔꯥꯏꯃꯔꯤ ꯁꯥꯟꯅꯄꯣꯠ ꯑꯃꯗ ꯇꯝꯕꯤꯔꯤ꯫ ꯑꯉꯥꯡꯁꯤꯡꯅ ꯃꯍꯥꯀꯄꯨ ꯌꯥꯝꯅ ꯅꯨꯡꯁꯤꯔꯤ꯫', 'ei-gi ichanbi asi oja amani. mahak primary sanna-pot ama-da tambiri. angangsing-na mahak-pu yamna nungshiri. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯁꯍꯔꯗ ꯑꯅꯧꯕ ꯍꯣꯁ꯭ꯄꯤꯇꯦꯜ ꯑꯃꯥ ꯁꯥꯔꯤ꯫ ꯃꯁꯤ ꯑꯆꯧꯕ ꯑꯃꯁꯨꯡ ꯃꯣꯗꯔꯟ ꯑꯣꯏꯒꯅꯤ꯫ ꯂꯥꯛꯀꯗꯕ ꯆꯍꯤꯗ ꯃꯁꯤ ꯍꯥꯡꯗꯣꯀꯄꯥ ꯇꯧꯒꯅꯤ꯫', 'shahar-da anowba hospital ama sari. mashi achouba amashung modern oigani. lakkadaba chahi-da mashi hangdokpa tougani. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'ꯑꯉꯥꯡꯁꯤꯡꯅ ꯄꯥꯔꯀꯇ ꯁꯥꯟꯅꯔꯤ꯫ ꯈꯔꯗꯤ ꯏꯊꯥꯢꯗ ꯏꯊꯥꯢ ꯐꯥꯑꯣꯔꯤ꯫ ꯈꯔꯗꯤ ꯐꯨꯠꯕꯣꯜ ꯁꯥꯟꯅꯔꯤ꯫', 'angangsing-na park-ta sannei. kharadi ithei-da ithei phao-ri. kharadi football sannei. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:meitei_mayek:manipuri'], '3', (select id from regions where key = 'IN:Manipur'));

-- ============================================
-- MIZO - 12 CARDS
-- Region: IN:Mizoram
-- Note: Uses Latin script with diacritics
-- ============================================

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id) values
((select id from card_groups where name = 'Indian Languages - Long Form'), 'Tunah zing khan bazar ka kal ta a. Chutah chuan mi tam tak a awm. Thei leh thlai tlemte ka lei ta a.', 'Tunah zing khan bazar ka kal ta a. Chutah chuan mi tam tak a awm. Thei leh thlai tlemte ka lei ta a. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Tun ni hian sikul ah kum thar lawmna a awm. Naupang zawng zawng an hlim hle mai. An zu leh hla an siam ang.', 'Tun ni hian sikul ah kum thar lawmna a awm. Naupang zawng zawng an hlim hle mai. An zu leh hla an siam ang. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Ramesh hi zirtirtu tha tak a ni. Ni zawng ah lehkhabu dahna ah a kal thin. Science leh Math a duh.', 'Ramesh hi zirtirtu tha tak a ni. Ni zawng ah lehkhabu dahna ah a kal thin. Science leh Math a duh. (Ramesh is a good student. He goes to the library every day. He likes science and mathematics.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Kan in hnaihah park lian tak a awm. Zan dar ah mi tam tak chu an kal thin. Naupangho chuan chutah an inṭi thin.', 'Kan in hnaihah park lian tak a awm. Zan dar ah mi tam tak chu an kal thin. Naupangho chuan chutah an inṭi thin. (There is a big park near our house. Many people come there for a walk in the evening. Children play there.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Doctor chuan damdawi min pe ta a. Ni khat ah vawi thum ka in tak a ngai. Ka hrisel dawn a ni.', 'Doctor chuan damdawi min pe ta a. Ni khat ah vawi thum ka in tak a ngai. Ka hrisel dawn a ni. (The doctor has given me medicine. I have to take it three times a day. I will get well soon.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Ni lum chhutna hun ah tlangah kan kal ta a. Chumi hmun boruak a tha hle mai. Photo tam tak kan la ta a.', 'Ni lum chhutna hun ah tlangah kan kal ta a. Chumi hmun boruak a tha hle mai. Photo tam tak kan la ta a. (We went to the mountains during summer vacation. The weather there was very pleasant. We took many pictures.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Leng chu hun taka lo thleng ta a. Khualzin zawng zawng chu an tla tan mai. Ka thil awmte ka phuah a pawn ka chhuak ta a.', 'Leng chu hun taka lo thleng ta a. Khualzin zawng zawng chu an tla tan mai. Ka thil awmte ka phuah a pawn ka chhuak ta a. (The train arrived on time. All passengers started getting down. I picked up my luggage and came out.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Tun ni hi Sunday a ni a, hmu leh hmahna zawng zawng a khar vek a. Kan inah kan awm dawn a ni. Zan dar ah film kan en dawn a ni.', 'Tun ni hi Sunday a ni a, hmu leh hmahna zawng zawng a khar vek a. Kan inah kan awm dawn a ni. Zan dar ah film kan en dawn a ni. (Today is Sunday and all shops are closed. We will stay at home. We will watch a movie in the evening.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Hual neitu chuan loah a thawh mek a. Chu chu a buh a khawm mek a. Kum huna buh a tha hle mai.', 'Hual neitu chuan loah a thawh mek a. Chu chu a buh a khawm mek a. Kum huna buh a tha hle mai. (The farmer is working in the field. He is harvesting the wheat crop. The crop has been good this year.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Ka fanu hi zirtirtu a ni. Naupang zirtirna ah a zirtir thin. Naupangho chuan an lawm hle.', 'Ka fanu hi zirtirtu a ni. Naupang zirtirna ah a zirtir thin. Naupangho chuan an lawm hle. (My sister is a teacher. She teaches at a primary school. Children like her very much.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Khawpui ah damdawi in thar sak mek a ni. Chu chu a lian leh a thara sak a ni ang. Kum dawt ah an hawng dawn a ni.', 'Khawpui ah damdawi in thar sak mek a ni. Chu chu a lian leh a thara sak a ni ang. Kum dawt ah an hawng dawn a ni. (A new hospital is being built in the city. It will be very big and modern. It will open next year.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram')),

((select id from card_groups where name = 'Indian Languages - Long Form'), 'Naupangho chuan parkah an inṭi mek a. Thenkhat chuan inṭih tumah an inzu thin. Thenkhat chuan football an inṭi thin.', 'Naupangho chuan parkah an inṭi mek a. Thenkhat chuan inṭih tumah an inzu thin. Thenkhat chuan football an inṭi thin. (Children are playing in the park. Some are swinging on swings. Some are playing football.)', array['script:mizo'], '3', (select id from regions where key = 'IN:Mizoram'));
