# WATG24 Cities Implementation Workflow

This guide explains how to implement the WATG24 global cities classification system with 335+ cities across 12 tiers.

## Overview

**What is WATG24?**
The Globalization and World Cities (GaWC) classification ranks cities by their global economic and cultural influence. Cities are classified into tiers from Alpha++ (most influential) to Sufficiency (emerging global presence).

**Topics to Create:**
1. **Global Major Cities** - Alpha++ and Alpha+ cities only (10 cities)
2. **Cities-500** - All WATG24 tiers (335 cities)

**Cities by Tier:**
- Alpha++ (2): London, New York - *Dominant global cities*
- Alpha+ (8): Hong Kong, Beijing, Singapore, Paris, etc. - *Major global cities*
- Alpha (17): Seoul, Toronto, Mumbai, Los Angeles, etc.
- Alpha- (22): Luxembourg, Brussels, San Francisco, etc.
- Beta+ (20): Bogota, Tel Aviv, Cairo, etc.
- Beta (23): Chongqing, Hanoi, Copenhagen, etc.
- Beta- (28): Qingdao, Lagos, Belgrade, etc.
- Gamma+ (20): Tunis, Guatemala City, Cape Town, etc.
- Gamma (25): Monterrey, Fuzhou, Hyderabad, etc.
- Gamma- (25): Poznan, Labuan, Tbilisi, etc.
- High Sufficiency (26): Izmir, Harare, Charlotte, etc.
- Sufficiency (119): Strasbourg, Columbus, Ankara, etc.

---

## Generated Files

The generator script has created:

1. **`supabase/seed/watg24_cities_template.sql`** (Large file ~100KB)
   - Card groups for all 12 tiers
   - Topics (Global Major Cities, Cities-500)
   - Skill tag templates with TODOs
   - Fact card templates with TODOs

2. **`supabase/seed/watg24_cities_list.json`** (Reference file)
   - JSON array of all cities
   - Used for tracking progress
   - Can be used to fill in data programmatically

---

## Implementation Strategy

### Phase 1: Alpha++ Cities (2 cities)
Start with the most important cities for immediate testing.

**Cities:** London, New York

**For each city:**
1. Add country code
2. Write geographic note (2-3 sentences)
3. Map to region (or create pin region if needed)

### Phase 2: Alpha+ Cities (8 cities)
**Cities:** Hong Kong, Beijing, Singapore, Shanghai, Paris, Dubai, Tokyo, Sydney

### Phase 3: Alpha Cities (17 cities)
**Cities:** Seoul, Milan, Toronto, Frankfurt, Chicago, Jakarta, Sao Paulo, Mexico City, Mumbai, Madrid, Warsaw, Guangzhou, Istanbul, Amsterdam, Bangkok, Los Angeles, Kuala Lumpur

### Phase 4: Remaining Tiers (308 cities)
Complete incrementally by tier.

---

## Step-by-Step: Filling In City Data

### Step 1: Open the Template

```bash
# Template location
supabase/seed/watg24_cities_template.sql
```

### Step 2: Find a City Section

Each city has two parts:

**Part 1: Skill Tag**
```sql
-- London (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:london',
  'city'::skill_family_enum,
  null,  -- TODO: Add 2-letter country code (e.g., 'US', 'GB', 'CN')
  'London',
  'TODO: Add geographic/cultural info about London. Example: Major financial hub in [region], known for [feature], located [geographic position].',
  array[]::text[]
);
```

**Part 2: Fact Card** (at end of tier section)
```sql
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'London',
  'Alpha++ tier global city',
  array['city:london'],
  '2',
  null  -- TODO: Map to region key, e.g., (select id from regions where key = 'GB:London')
)
```

### Step 3: Fill in Country Code

```sql
-- BEFORE
'city'::skill_family_enum,
null,  -- TODO: Add 2-letter country code

-- AFTER
'city'::skill_family_enum,
'GB',  -- United Kingdom
```

**Common Country Codes:**
- US - United States
- GB - United Kingdom
- CN - China
- JP - Japan
- FR - France
- DE - Germany
- IN - India
- AU - Australia
- CA - Canada
- BR - Brazil

### Step 4: Write Geographic Note

Write 2-3 sentences covering:
- Geographic location
- Special characteristics
- Economic/cultural significance

**Examples:**

```sql
-- London
'Capital of the United Kingdom, located in southeastern England on the River Thames. Major global financial center and one of the world''s most visited cities. Known for landmarks like Big Ben, Tower Bridge, and Buckingham Palace.'

-- New York
'Largest city in the United States, located on the Atlantic coast at the mouth of the Hudson River. Global center for finance, media, art, fashion, and entertainment. Home to iconic landmarks like the Statue of Liberty, Times Square, and Central Park.'

-- Tokyo
'Capital of Japan, located on the eastern coast of Honshu island in the Kanto region. World''s most populous metropolitan area and a major global economic hub. Known for blending traditional culture with cutting-edge technology and innovation.'
```

**Tips for Writing Notes:**
- Use present tense
- Be factual and concise
- Include distinctive geographic features
- Mention what the city is known for
- Escape single quotes with '' (two single quotes)

### Step 5: Map to Region

Check if a region exists for this city:

```sql
-- Check existing regions
select key, name, level, location_type
from regions
where name ilike '%London%' or key like '%London%';
```

**Option A: Region Exists**
```sql
-- BEFORE
null  -- TODO: Map to region key

-- AFTER
(select id from regions where key = 'GB:London')
```

**Option B: Create New Pin Region**

If the city doesn't have a region, create one first:

```bash
# 1. Create a separate migration for city pins
bun run migration:new add_watg24_city_pins_batch1

# 2. Add pin regions (example for London)
```

```sql
-- In the new migration file
insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
(
  'GB:London',
  'city'::region_level_enum,
  'London',
  'GB',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-0.1276, 51.5074), 4326)  -- lon, lat
),
(
  'US:New_York',
  'city'::region_level_enum,
  'New York',
  'US',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(-74.0060, 40.7128), 4326)
);
```

**Finding Coordinates:**
- Use Google Maps: Right-click → "What's here?" → Copy coordinates
- Format: ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)
- Order: LONGITUDE first, then LATITUDE

### Step 6: Example of Completed City

```sql
-- ============================================
-- ALPHA++ CITIES (2 cities)
-- ============================================

-- Skill Tags

-- London (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:london',
  'city'::skill_family_enum,
  'GB',
  'London',
  'Capital of the United Kingdom, located in southeastern England on the River Thames. Major global financial center and one of the world''s most visited cities. Known for landmarks like Big Ben, Tower Bridge, and Buckingham Palace.',
  array[]::text[]
);

-- New York (Alpha++)
insert into skill_tags (key, family, country, display, note, examples)
values (
  'city:new_york',
  'city'::skill_family_enum,
  'US',
  'New York',
  'Largest city in the United States, located on the Atlantic coast at the mouth of the Hudson River. Global center for finance, media, art, fashion, and entertainment. Home to iconic landmarks like the Statue of Liberty, Times Square, and Central Park.',
  array[]::text[]
);

-- Fact Cards
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'London',
  'Alpha++ tier global city - UK capital and financial center',
  array['city:london'],
  '2',
  (select id from regions where key = 'GB:London')
),

(
  (select id from card_groups where name = 'cities_watg24_alpha_plus_plus'),
  'New York',
  'Alpha++ tier global city - US''s largest city and financial hub',
  array['city:new_york'],
  '2',
  (select id from regions where key = 'US:New_York')
);
```

---

## Workflow for Each Batch

### 1. Create Pin Regions (if needed)

```bash
# Create migration for city pins
bun run migration:new add_watg24_city_pins_alpha_plus_plus

# Add SQL for all cities in this batch
# Apply migration
bun run migration:up
```

### 2. Fill Template Section

Edit `supabase/seed/watg24_cities_template.sql`:
- Find the tier section (e.g., "ALPHA++ CITIES")
- Fill in country codes
- Write geographic notes
- Map to region keys

### 3. Create Migration with Filled Data

```bash
# Create migration
bun run migration:new add_watg24_cities_alpha_plus_plus

# Copy the completed section from template to migration file
# Apply migration
bun run migration:up
```

### 4. Verify

```sql
-- Check skill tags created
select key, display, country, note
from skill_tags
where key like 'city:london' or key like 'city:new_york';

-- Check fact cards created
select fc.prompt, fc.hint, r.name as region_name
from fact_cards fc
join regions r on r.id = fc.answer_region_id
where fc.card_group_id = (select id from card_groups where name = 'cities_watg24_alpha_plus_plus');

-- Check topics
select key, title, difficulty
from topics
where key in ('global-major-cities', 'cities-500');
```

---

## Tracking Progress

Use the JSON file to track which cities have been completed:

```bash
# View cities list
cat supabase/seed/watg24_cities_list.json | grep "TODO" | wc -l
# Shows number of cities remaining
```

Create a tracking file:

```bash
# Create progress tracker
cp supabase/seed/watg24_cities_list.json supabase/seed/watg24_progress.json

# Mark completed cities by replacing "TODO" with actual data
```

---

## City Research Resources

### Geographic Information
- **Wikipedia** - Reliable basic facts
- **GeoNames** - Coordinates and geographic data
- **Google Maps** - Coordinates, location verification
- **Official city websites** - Current information

### Quick Research Template

For each city, gather:
1. **Location**: Country, region/state, geographic features
2. **Population rank**: Largest/major city in...
3. **Known for**: Economic role, industries, landmarks
4. **Geographic position**: Coastal, inland, river, etc.
5. **Climate**: If distinctive (tropical, desert, arctic, etc.)

### Example Research Notes

**London:**
- Location: SE England, River Thames
- Rank: Capital, largest city in UK
- Known for: Finance (City of London), tourism, culture
- Position: Inland but connected to North Sea
- Landmarks: Big Ben, Tower Bridge, Buckingham Palace

---

## Testing Strategy

### Phase Testing
After completing each phase:

1. **Apply Migration**
   ```bash
   bun run migration:up
   ```

2. **Test in App**
   - Navigate to Topics
   - Select "Global Major Cities" or "Cities-500"
   - Play through several cards
   - Verify map pins appear correctly
   - Check hints are helpful

3. **SQL Verification**
   ```sql
   -- Count completed cities per tier
   select
     cg.name as card_group,
     count(fc.id) as card_count
   from card_groups cg
   left join fact_cards fc on fc.card_group_id = cg.id
   where cg.name like 'cities_watg24_%'
   group by cg.name
   order by card_count desc;
   ```

---

## Batch Recommendations

### Recommended Batch Sizes

- **Alpha++ to Alpha**: Do individually (high importance, 27 cities total)
- **Beta tiers**: Batches of 20-25 cities
- **Gamma tiers**: Batches of 25-30 cities
- **Sufficiency**: Batches of 30-40 cities

### Migration Organization

```
20251113_01_add_watg24_city_pins_alpha_plusplus.sql   (2 pins)
20251113_02_add_watg24_cities_alpha_plusplus.sql       (2 cities data)
20251113_03_add_watg24_city_pins_alpha_plus.sql        (8 pins)
20251113_04_add_watg24_cities_alpha_plus.sql           (8 cities data)
...
```

---

## Common Issues & Solutions

### Issue: Region Not Found

**Error:**
```sql
ERROR: null value in column "answer_region_id" violates not-null constraint
```

**Solution:**
Create the pin region first before adding the fact card.

### Issue: Duplicate Skill Tag

**Error:**
```sql
ERROR: duplicate key value violates unique constraint "skill_tags_key_key"
```

**Solution:**
Check if the city was already added in a previous migration.

### Issue: Wrong Coordinates

**Problem:** City pin appears in ocean/wrong location

**Solution:**
- Verify coordinate order (longitude, latitude)
- Check sign (- for West/South, + for East/North)
- Use decimal degrees, not DMS format

---

## Quality Guidelines

### Geographic Notes Quality

**Good:**
> "Tokyo is the capital of Japan, located on the eastern coast of Honshu island in the Kanto region. World's most populous metropolitan area and a major global economic hub. Known for blending traditional culture with cutting-edge technology."

**Avoid:**
> "Tokyo is a city in Japan. It's very big." ❌

### Hints Quality

Keep hints informative but not too revealing:

**Good:**
> "Alpha++ tier global city - UK capital and financial center"

**Too revealing:**
> "Alpha++ tier global city - It's London!" ❌

**Too vague:**
> "A city" ❌

---

## Summary Checklist

### For Each City:
- [ ] Add country code to skill tag
- [ ] Write 2-3 sentence geographic note
- [ ] Check if region exists
- [ ] Create pin region if needed (separate migration)
- [ ] Map fact card to region key
- [ ] Update hint to be informative
- [ ] Test in application

### For Each Batch:
- [ ] Create pin regions migration (if needed)
- [ ] Apply pin regions: `bun run migration:up`
- [ ] Fill template data for batch
- [ ] Create cities data migration
- [ ] Copy filled data to migration
- [ ] Apply migration: `bun run migration:up`
- [ ] Verify with SQL queries
- [ ] Test in app
- [ ] Mark progress in JSON tracker

---

## Next Steps

1. **Start with Alpha++ Cities**
   - Complete London and New York first
   - Test end-to-end workflow
   - Adjust process as needed

2. **Continue with Alpha+ Cities**
   - Build momentum with 8 cities
   - Refine research process
   - Create reusable note templates

3. **Batch Process Remaining Tiers**
   - Use established workflow
   - Consider delegation if team available
   - Focus on accuracy over speed

---

**Good luck! 335 cities is a lot, but with a systematic approach, it's manageable. Start small, test often, and build momentum!** 🌍🎯
