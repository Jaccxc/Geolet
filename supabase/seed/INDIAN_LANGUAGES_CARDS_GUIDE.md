# Indian Languages Fact Cards Generation Guide

**Purpose:** Create 150+ cards each for Long Form and Short Form Indian language recognition

## Overview

### Card Groups & Topics

1. **Indian Languages - Long Form** (Intermediate)
   - 2-3 sentence passages
   - More context = easier identification
   - Target: 150+ cards (12-13 per script × 12 scripts)

2. **Indian Languages - Short Form** (Advanced)
   - Single vocabulary words
   - Minimal context = harder challenge
   - Target: 150+ cards (12-13 per script × 12 scripts)

### Indian Scripts Covered

| Script | Key | Region | Difficulty |
|--------|-----|--------|------------|
| Hindi (Devanagari) | `script:devanagari:hindi` | Uttar Pradesh | 1 |
| Marathi (Devanagari) | `script:devanagari:marathi` | Maharashtra | 2 |
| Punjabi (Gurmukhi) | `script:gurmukhi:punjabi` | Punjab | 2 |
| Gujarati | `script:gujarati` | Gujarat | 2 |
| Bengali | `script:bengali` | West Bengal | 2 |
| Assamese | `script:bengali:assamese` | Assam | 3 |
| Kannada | `script:kannada` | Karnataka | 2 |
| Telugu | `script:telugu` | Telangana | 2 |
| Tamil | `script:tamil` | Tamil Nadu | 2 |
| Odia | `script:odia` | Odisha | 2 |
| Malayalam | `script:malayalam` | Kerala | 2 |
| Manipuri (Meitei) | `script:meitei:manipuri` | Manipur | 3 |

## Implementation Strategy

Due to the large volume (300+ cards) and need for authentic native text, I recommend:

### Option A: Use AI Generation (Recommended)
Use the provided TypeScript script which generates SQL structure, then:
1. Use GPT-4 or Claude to generate authentic native text
2. Paste script-by-script into the SQL template
3. Verify with native speakers if possible

### Option B: Crowdsource Content
1. Use existing parallel corpora (news sites, Wikipedia)
2. Extract and adapt real passages
3. Create vocabulary lists from common dictionaries

### Option C: Start Small, Expand Later
1. Create 5-10 high-quality cards per script (60-120 total)
2. Launch with smaller dataset
3. Expand based on user feedback

## Quick Start (Recommended Path)

### Step 1: Apply Setup

```bash
psql $DATABASE_URL -f supabase/seed/04_indian_languages_setup.sql
```

This creates:
- Card groups
- Topics

### Step 2: Generate Card Templates

```bash
cd supabase/seed/scripts
npm install
npx tsx generate-indian-language-cards.ts
```

This creates:
- `05_indian_languages_long_cards.sql` (template with placeholders)
- `06_indian_languages_short_cards.sql` (template with placeholders)

### Step 3: Fill in Native Text

**For each script**, replace placeholders with actual content.

#### Long Form Example Template:

```sql
-- HINDI LONG FORM CARD
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Long Form'),
  'मैं आज सुबह बाजार गया था। वहाँ बहुत भीड़ थी। मैंने कुछ फल और सब्जियाँ खरीदीं।',
  'maiṁ āj subah bāzār gayā thā. vahā̃ bahut bhīṛ thī. maiṁne kuch phal aur sabjiyā̃ kharīdīṁ. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)',
  array['script:devanagari:hindi'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);
```

#### Short Form Example Template:

```sql
-- HINDI SHORT FORM CARD
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Short Form'),
  'पानी',
  'pānī (water)',
  array['script:devanagari:hindi'],
  '3'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);
```

## Content Sources

### Long Form (2-3 sentences)
- **News snippets:** Local news websites in each language
- **Wikipedia:** First paragraphs of articles
- **Children's stories:** Simple, clear language
- **Common scenarios:** Market, school, hospital, travel
- **Daily life:** Weather, food, family, festivals

### Short Form (vocabulary)
**Core categories** (aim for variety):
1. **Basic nouns** (20%): water, food, house, road, tree, book
2. **Family terms** (15%): mother, father, brother, sister, son
3. **Verbs** (20%): eat, drink, sleep, walk, run, read, write
4. **Adjectives** (15%): big, small, good, bad, hot, cold, new
5. **Numbers** (10%): one, two, three, ten, hundred
6. **Time words** (10%): today, tomorrow, morning, evening, day
7. **Places** (10%): school, hospital, market, station, hotel

## Quality Guidelines

### Long Form Cards
- ✅ Use complete, grammatically correct sentences
- ✅ Cover everyday topics (market, school, weather, travel)
- ✅ Ensure 2-3 sentences minimum
- ✅ Include romanization AND English translation in hint
- ✅ Vary sentence structure and vocabulary

### Short Form Cards
- ✅ Use common, high-frequency words
- ✅ Mix nouns, verbs, adjectives
- ✅ Include romanization AND English meaning in hint
- ✅ Avoid proper nouns or rare technical terms
- ✅ Test that words are distinguishable across scripts

## Example Full Sets

### Hindi (Devanagari) - Long Form (13 cards)

```sql
-- Card 1: Market scene
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Long Form'),
  'मैं आज सुबह बाजार गया था। वहाँ बहुत भीड़ थी। मैंने कुछ फल और सब्जियाँ खरीदीं।',
  'maiṁ āj subah bāzār gayā thā. vahā̃ bahut bhīṛ thī. maiṁne kuch phal aur sabjiyā̃ kharīdīṁ. (I went to the market this morning. There was a lot of crowd. I bought some fruits and vegetables.)',
  array['script:devanagari:hindi'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);

-- Card 2: School function
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Long Form'),
  'स्कूल में आज वार्षिक समारोह है। सभी बच्चे बहुत उत्साहित हैं। वे नृत्य और गीत प्रस्तुत करेंगे।',
  'skūl meṁ āj vārṣik samāroh hai. sabhī bacce bahut utsāhit haiṁ. ve nṛtya aur gīt prastut kareṅge. (Today there is an annual function at school. All children are very excited. They will present dances and songs.)',
  array['script:devanagari:hindi'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);

-- ... continue for 11 more cards
```

### Hindi (Devanagari) - Short Form (13 cards)

```sql
-- Card 1
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Short Form'),
  'पानी',
  'pānī (water)',
  array['script:devanagari:hindi'],
  '3'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);

-- Card 2
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'Indian Languages - Short Form'),
  'खाना',
  'khānā (food)',
  array['script:devanagari:hindi'],
  '3'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Uttar_Pradesh')
);

-- ... continue for 11 more cards
```

## Verification Checklist

Before applying seeds:

- [ ] Each script has 12-13 long form cards
- [ ] Each script has 12-13 short form cards
- [ ] Total: 150-156 cards per category
- [ ] All prompts use authentic native script
- [ ] All hints include romanization + English
- [ ] All region keys match database (e.g., `IN:Uttar_Pradesh`)
- [ ] Difficulty levels are consistent
- [ ] SQL syntax is valid (test on small batch first)

## Apply Seeds

```bash
# After filling in content
psql $DATABASE_URL -f supabase/seed/05_indian_languages_long_cards.sql
psql $DATABASE_URL -f supabase/seed/06_indian_languages_short_cards.sql

# Verify counts
psql $DATABASE_URL -c "
select
  cg.name,
  count(*) as card_count
from fact_cards fc
join card_groups cg on cg.id = fc.card_group_id
where cg.name like 'Indian Languages%'
group by cg.name;
"
```

Expected output:
```
             name                  | card_count
-----------------------------------+------------
 Indian Languages - Long Form     |        150
 Indian Languages - Short Form    |        150
```

## Next Steps

1. **Start small:** Create 5 high-quality cards per script (60 total) to test
2. **Use AI assistance:** Claude/GPT-4 can generate native text if you provide good prompts
3. **Crowdsource:** Ask native speakers to contribute/verify
4. **Iterate:** Launch with what you have, expand based on usage data

## Need Help?

The generator script creates the SQL structure. The hard part is getting authentic native text for 300+ cards. Consider:
- Using translation APIs + manual verification
- Extracting from parallel corpora
- Starting with fewer cards per script and expanding gradually
