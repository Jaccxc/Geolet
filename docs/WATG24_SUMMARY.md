# WATG24 Cities Implementation - Summary

## What Was Created

### 1. Generator Script
**Location:** `supabase/seed/scripts/generate-watg24-cities.ts`

**What it does:**
- Parses `public/WATG24.csv` containing 335 cities
- Generates 12 card groups (one per tier)
- Creates 2 topics:
  - **Global Major Cities** (Alpha++ and Alpha+ only)
  - **Cities-500** (all tiers)
- Generates skill tag templates for all cities
- Generates fact card templates for all cities
- Produces a tracking JSON file

**How to run:**
```bash
npx tsx supabase/seed/scripts/generate-watg24-cities.ts
```

### 2. Generated Template
**Location:** `supabase/seed/watg24_cities_template.sql`

**Size:** ~100KB, 335 cities

**What it contains:**
- 12 card groups (cities_watg24_alpha_plus_plus through cities_watg24_sufficiency)
- 2 topic definitions
- 335 skill tag templates with TODOs:
  - Country code placeholder
  - Geographic note placeholder
- 335 fact card templates with TODOs:
  - Region mapping placeholder

**Structure per tier:**
```sql
-- ============================================
-- [TIER NAME] (N cities)
-- ============================================

-- Skill Tags
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:london',
  'city'::skill_family_enum,
  null,  -- TODO: Add country code
  'London',
  'TODO: Add geographic/cultural info about London...',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'London',
  'Alpha++ tier global city',
  array['city:london'],
  '2',
  null  -- TODO: Map to region
);
```

### 3. City Reference List
**Location:** `supabase/seed/watg24_cities_list.json`

**What it contains:**
- JSON array of all 335 cities
- Each city has:
  - name
  - tier
  - skillKey
  - regionKey (placeholder)
  - countryCode (placeholder)
  - coordinates (placeholder)
  - note (placeholder)

**Use for:**
- Tracking completion progress
- Quick reference lookup
- Programmatic filling if desired

### 4. Documentation
**Created files:**

1. **`docs/WATG24_CITIES_WORKFLOW.md`**
   - Complete step-by-step guide
   - How to fill in each city
   - Research tips
   - Batch processing strategy
   - Quality guidelines

2. **`docs/EXAMPLE_watg24_alpha_plusplus.sql`**
   - Fully completed example
   - Shows London and New York filled in
   - Use as reference template

3. **`docs/WATG24_SUMMARY.md`** (this file)
   - Overview of what was created
   - Quick start guide

---

## Quick Start Guide

### Phase 1: Setup (One-time)

1. **Run the generator** (already done):
   ```bash
   npx tsx supabase/seed/scripts/generate-watg24-cities.ts
   ```

2. **Review generated files:**
   - Template: `supabase/seed/watg24_cities_template.sql`
   - Reference: `supabase/seed/watg24_cities_list.json`
   - Example: `docs/EXAMPLE_watg24_alpha_plusplus.sql`

### Phase 2: Implement Alpha++ (2 cities)

**Step 1: Create pin regions**
```bash
bun run migration:new add_watg24_city_pins_alpha_plusplus
```

Add to migration file:
```sql
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
('GB:London', 'city'::region_level_enum, 'London', 'GB', 'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-0.1276, 51.5074), 4326)),
('US:New_York', 'city'::region_level_enum, 'New York', 'US', 'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-74.0060, 40.7128), 4326));
```

Apply:
```bash
bun run migration:up
```

**Step 2: Create card groups and topics**
```bash
bun run migration:new add_watg24_setup
```

Copy from template:
- Card groups section (all 12 groups)
- Topics section (both topics)

Apply:
```bash
bun run migration:up
```

**Step 3: Fill in Alpha++ city data**

Open `supabase/seed/watg24_cities_template.sql`

Find Alpha++ section, fill in:
- Country codes: GB, US
- Geographic notes (see example file)
- Region mappings: 'GB:London', 'US:New_York'

**Step 4: Create migration with filled data**
```bash
bun run migration:new add_watg24_cities_alpha_plusplus
```

Copy filled Alpha++ section to migration file.

Apply:
```bash
bun run migration:up
```

**Step 5: Test**
- Open app
- Navigate to Topics
- Find "Global Major Cities"
- Play cards for London and New York
- Verify map pins appear correctly

### Phase 3: Continue with Remaining Tiers

Follow the same pattern for each tier:
1. Create pin regions (batch)
2. Fill template data
3. Create migration
4. Apply and test

**Recommended order:**
1. Alpha++ (2) ✓
2. Alpha+ (8)
3. Alpha (17)
4. Alpha- (22)
5. Beta+ (20)
6. Beta (23)
7. Beta- (28)
8. Gamma+ (20)
9. Gamma (25)
10. Gamma- (25)
11. High Sufficiency (26)
12. Sufficiency (119)

---

## City Tiers Breakdown

### Alpha++ (2 cities) - Global Dominance
London, New York

*The two most globally influential cities, dominant in finance, culture, and international connectivity.*

### Alpha+ (8 cities) - Major Global Hubs
Hong Kong, Beijing, Singapore, Shanghai, Paris, Dubai, Tokyo, Sydney

*Major international centers with significant global economic and cultural influence.*

### Alpha (17 cities) - Important Global Cities
Seoul, Milan, Toronto, Frankfurt, Chicago, Jakarta, Sao Paulo, Mexico City, Mumbai, Madrid, Warsaw, Guangzhou, Istanbul, Amsterdam, Bangkok, Los Angeles, Kuala Lumpur

*Well-established global cities with strong international connectivity.*

### Alpha- (22 cities)
Luxembourg, Taipei, Shenzhen, Brussels, Zurich, Buenos Aires, Melbourne, San Francisco, Riyadh, Santiago, Düsseldorf, Stockholm, Washington DC, Vienna, Lisbon, Munich, Dublin, Houston, Berlin, Johannesburg, Boston, New Delhi

*Significant cities with developing global influence.*

### Beta+ (20 cities)
Bogota, Tel Aviv, Cairo, Chengdu, Copenhagen, Hanoi, Miami, Oslo, Calgary, Geneva, Manila, Kiev, Perth, Brisbane, Abu Dhabi, Kunming, Wuhan, Doha, Manama, Jinan

*Regional centers beginning to develop wider international roles.*

### Beta (23 cities)
Chongqing, Casablanca, Lagos, Denver, Montevideo, Beirut, Dhaka, Belgrade, Vancouver, Seattle, Almaty, Rotterdam, Adelaide, Lahore, Zagreb, Antwerp, Xiamen, Nicosia, Nanjing, Helsinki, Tianjin, Port Louis, Bratislava

*Important regional cities with some international connections.*

### Beta- (28 cities)
Qingdao, Tunis, Fuzhou, Cape Town, Hyderabad, Muscat, Tirana, Accra, Portland, Ningbo, Harbin, San Jose (CA), Cleveland, The Hague, Cologne, Tbilisi, Quito, Phnom Penh, Porto, Birmingham (UK), Cali, Amman, Santo Domingo, Pune, Dar es Salaam, San Salvador, Austin, San Diego

*Cities with emerging international characteristics.*

### Gamma+ (20 cities)
Monterrey, Guatemala City, Kampala, Islamabad, Edinburgh, Baku, Wellington, Dallas, Jeddah, Katowice, Minneapolis, San Salvador, Penang, Birmingham (UK), Nashville, Changchun, Sofia, San Jose (Costa Rica), Managua, La Paz

*Cities linking smaller regions into the world economy.*

### Gamma (25 cities)
Poznan, Fuzhou, Osaka, Haikou, Tampa, Nanchang, Changsha, Pittsburgh, Phoenix, San Diego, Tegucigalpa, Cincinnati, Bilbao, Riga, Surabaya, Algiers, Shijiazhuang, Charlotte, Valencia (Spain), Zhuhai, Bologna, Raleigh, Kansas City, Leeds, Ljubljana

*Cities with basic international connections.*

### Gamma- (25 cities)
Izmir, Labuan, Macao, Glasgow, Tashkent, Queretaro, Wuxi, Johor Bahru, Málaga, George Town (Cayman Islands), Salt Lake City, Lausanne, Limassol, Nantes, Douala, Dakar, Skopje, Wroclaw, Christchurch, Urumqi, Vilnius, Ottawa, Ankara, Columbus, Strasbourg

*Cities with some evidence of global city formation.*

### High Sufficiency (26 cities)
Harare, Charlotte, Maputo, Tunis, Vilnius, Gothenburg, Macao, Ottawa, Jeddah, Raleigh, Urumqi, Nashville, Queretaro, Zhuhai, Tashkent, Glasgow, Izmir, Douala, Dakar, Skopje, Wroclaw, Christchurch, Ankara, Columbus, Strasbourg, Valencia (Spain)

*Smaller cities with adequate services for their regional networks.*

### Sufficiency (119 cities)
Strasbourg, Columbus, Ankara, Johor Bahru, Ottawa, Wroclaw, Gothenburg, Queretaro, Christchurch, Urumqi... [and 109 more]

*Cities with sufficient services and integration into global networks.*

---

## Statistics

- **Total Cities:** 335
- **Total Card Groups:** 12
- **Total Topics:** 2
- **Estimated Time:**
  - Per city (research + fill): ~5-10 minutes
  - Total: ~28-56 hours
  - Recommended: Do in batches over several weeks

---

## Tools & Resources

### For Coordinates
- **Google Maps:** Right-click → "What's here?" → Copy coordinates
- **GeoNames:** https://www.geonames.org/
- **LatLong.net:** https://www.latlong.net/

### For Geographic Information
- **Wikipedia:** Reliable source for city basics
- **Official city websites:** Current information
- **Britannica:** Concise encyclopedia entries
- **CIA World Factbook:** Country-level data

### For Verification
```sql
-- Check progress
select
  cg.name,
  count(fc.id) as completed_cards
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
where cg.name like 'cities_watg24_%'
group by cg.name
order by completed_cards desc;

-- Check missing regions
select fc.prompt
from fact_cards fc
where fc.card_group_id in (
  select id from card_groups where name like 'cities_watg24_%'
)
and fc.answer_region_id is null;
```

---

## Tips for Success

1. **Start Small:** Complete Alpha++ first to validate the entire workflow
2. **Batch Process:** Group cities by tier for efficient processing
3. **Create Regions First:** Always create pin regions before city data
4. **Test Frequently:** Apply migrations and test in app after each batch
5. **Track Progress:** Mark completed cities in JSON file
6. **Quality > Speed:** Accurate geographic notes are more valuable than rushing
7. **Use Examples:** Reference the completed example file frequently
8. **Ask for Help:** Complex cities may require additional research

---

## Next Steps

1. ✅ Generator script created
2. ✅ Template generated (335 cities)
3. ✅ Documentation written
4. ⏳ **YOU ARE HERE:** Ready to start filling in city data
5. ⏳ Implement Alpha++ cities (2 cities)
6. ⏳ Implement Alpha+ cities (8 cities)
7. ⏳ Continue with remaining tiers
8. ⏳ Final testing and verification

---

## Questions?

Refer to:
- **Workflow Guide:** `docs/WATG24_CITIES_WORKFLOW.md` (detailed step-by-step)
- **Example Migration:** `docs/EXAMPLE_watg24_alpha_plusplus.sql` (completed reference)
- **Main Documentation:** `docs/ADDING_NEW_CONTENT.md` (general content guide)

---

**Ready to start? Begin with Alpha++ cities (London & New York) to test the complete workflow!** 🚀🌍
