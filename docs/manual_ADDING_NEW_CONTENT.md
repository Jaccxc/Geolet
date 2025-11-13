# Adding New Content to Geolet

This guide explains how to add new educational content and geographic regions to Geolet.

## Table of Contents

1. [Overview](#overview)
2. [Migration Workflow](#migration-workflow)
3. [Adding New Topics with Existing Regions](#adding-new-topics-with-existing-regions)
4. [Adding New Regions](#adding-new-regions)
5. [Best Practices](#best-practices)

---

## Overview

Geolet's content architecture has four main layers:

```
skill_tags (what skills to test)
    ↓
card_groups (collections of related cards)
    ↓
topics (user-facing learning modules)
    ↓
fact_cards (individual quiz items)
```

Additionally, `regions` define geographic areas that cards can reference as answers.

---

## Migration Workflow

**IMPORTANT:** All SQL migrations must be created and applied using the project's CLI commands.

### Creating a New Migration

Use the CLI to generate a properly timestamped migration file:

```bash
bun run migration:new <migration_name>
```

**Example:**

```bash
# Creates a new migration file with timestamp
bun run migration:new african_languages_setup

# Output: supabase/migrations/20251113140523_african_languages_setup.sql
```

This command will:
- Generate a timestamped filename automatically
- Create an empty SQL file in `supabase/migrations/`
- Ensure proper naming convention

### Applying Migrations

After writing your SQL migration, apply it using:

```bash
bun run migration:up
```

This command will:
- Apply all pending migrations in order
- Update the migration tracking table
- Show which migrations were applied

### Complete Workflow

```bash
# 1. Create new migration file
bun run migration:new add_phone_number_topic

# 2. Edit the generated file with your SQL
# Add your INSERT statements, CREATE statements, etc.

# 3. Apply the migration
bun run migration:up

# 4. Verify in your application
# Test that cards, topics, and regions appear correctly
```

**Important Notes:**
- Do NOT manually create migration files with custom timestamps
- Do NOT use `supabase db reset` or `psql` commands for applying migrations
- ALWAYS use `bun run migration:new` to create migration files
- ALWAYS use `bun run migration:up` to apply migrations
- This ensures proper migration tracking and prevents conflicts

---

## Adding New Topics with Existing Regions

### Step 1: Define Skill Tags (if needed)

Skill tags categorize what knowledge a card tests. Check if appropriate tags exist in `supabase/migrations/20251112180205_skill_tags_v2.sql`.

**Example:** Adding a new script skill tag

```sql
insert into skill_tags (key, family, country, display, note, examples)
values (
  'script:mizo',
  'script'::skill_family_enum,
  'IN',
  'Mizo',
  'Uses Latin alphabet with Tibeto-Burman vocabulary. Look for particles: "chuan", "chu", "tak"',
  array['chuan', 'chu', 'tak', 'ang', 'thin', 'hle']
);
```

**Skill families available:**
- `script` - Writing systems and alphabets
- `phone` - Phone number patterns
- `city` - City/urban area knowledge

**Key structure:**
- Format: `family:detail:subdetail`
- Examples: `script:devanagari:hindi`, `phone:+91:11`, `city:IN:tier1`

### Step 2: Create Card Groups

Card groups organize cards by difficulty or format.

**Example:** Creating card groups for a new topic

```sql
insert into card_groups (name) values
  ('Indian Languages - Long Form'),   -- Intermediate: 2-3 sentence passages
  ('Indian Languages - Short Form');  -- Advanced: Single vocabulary words
```

**Naming convention:** `[Topic] - [Difficulty/Format]`

### Step 3: Create Topics

Topics are what users see and select. Each topic references one or more card groups.

**Example:** Creating topics

```sql
-- Topic 1: Long Form (Intermediate)
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values (
  'indian-languages-long',
  'Indian Languages - Reading',
  'Identify regional scripts from longer text passages (2-3 sentences). More context makes it easier!',
  'BookOpen',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[(select id from card_groups where name = 'Indian Languages - Long Form')]
);

-- Topic 2: Short Form (Advanced)
insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values (
  'indian-languages-short',
  'Indian Languages - Vocabulary',
  'Identify regional scripts from only a single word.',
  'Languages',
  true,
  true,
  'advanced'::difficulty_enum,
  array[(select id from card_groups where name = 'Indian Languages - Short Form')]
);
```

**Topic parameters:**
- `key` - Unique identifier (kebab-case)
- `title` - Display name shown to users
- `description` - Explains what the topic teaches
- `icon` - Icon name from your icon library (e.g., 'BookOpen', 'Languages', 'Globe')
- `pick_mode_active` - Enable multiple choice mode
- `map_mode_active` - Enable map selection mode
- `difficulty` - `'beginner'`, `'intermediate'`, or `'advanced'`
- `target_card_group_ids` - Array of card group IDs

### Step 4: Create Fact Cards

Fact cards are the actual quiz items. Each card must reference:
1. A card group (determines which topic it appears in)
2. Skill tags (what knowledge it tests)
3. A region (the correct answer)

**Example:** Creating fact cards

```sql
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
-- Card 1
(
  (select id from card_groups where name = 'Indian Languages - Long Form'),
  'मैं आज सुबह बाजार गया था। वहाँ बहुत भीड़ थी। मैंने कुछ फल और सब्जियाँ खरीदीं।',
  'maiṁ āj subah bāzār gayā thā. (I went to the market this morning. There was a lot of crowd.)',
  array['script:devanagari:hindi'],
  '1',
  (select id from regions where key = 'IN:Uttar_Pradesh')
),

-- Card 2
(
  (select id from card_groups where name = 'Indian Languages - Long Form'),
  'स्कूल में आज वार्षिक समारोह है। सभी बच्चे बहुत उत्साहित हैं।',
  'skūl meṁ āj vārṣik samāroh hai. (Today there is an annual function at school.)',
  array['script:devanagari:hindi'],
  '1',
  (select id from regions where key = 'IN:Uttar_Pradesh')
);
```

**Card parameters:**
- `card_group_id` - Which group this card belongs to (use subquery)
- `prompt` - The question/content shown to the user
- `hint` - Transliteration, translation, or helpful context
- `primary_skill_tags` - Array of skill tag keys being tested
- `difficulty` - String '1', '2', '3' (used for internal sorting)
- `answer_region_id` - The correct region (use subquery)

**Important:** Always use subqueries to reference IDs:
```sql
(select id from card_groups where name = 'Your Card Group Name')
(select id from regions where key = 'REGION_KEY')
```

### Step 5: Create Migration File

Use the CLI to create a new migration file:

```bash
# Use the migration CLI command
bun run migration:new african_languages_setup

# This creates: supabase/migrations/[timestamp]_african_languages_setup.sql
```

**Template structure:**

```sql
-- ============================================
-- [TOPIC NAME] SETUP
-- ============================================
-- Date: YYYY-MM-DD
-- Purpose: [Brief description]
-- ============================================

-- --------------------------------------------
-- 1. CREATE CARD GROUPS
-- --------------------------------------------

insert into card_groups (name) values
  ('[Topic] - [Format 1]'),
  ('[Topic] - [Format 2]');

-- --------------------------------------------
-- 2. CREATE SKILL TAGS (if new ones needed)
-- --------------------------------------------

insert into skill_tags (key, family, country, display, note, examples) values
  ('your:tag:key', 'script'::skill_family_enum, 'XX', 'Display Name', 'Description', array['example1', 'example2']);

-- --------------------------------------------
-- 3. CREATE TOPICS
-- --------------------------------------------

insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values (
  'your-topic-key',
  'Your Topic Title',
  'Description of what users will learn',
  'IconName',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[(select id from card_groups where name = '[Topic] - [Format 1]')]
);

-- --------------------------------------------
-- 4. CREATE FACT CARDS
-- --------------------------------------------

insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
(
  (select id from card_groups where name = '[Topic] - [Format 1]'),
  'Your prompt text here',
  'Helpful hint or translation',
  array['your:tag:key'],
  '1',
  (select id from regions where key = 'REGION_KEY')
),
-- Add more cards...
;

-- --------------------------------------------
-- 5. VERIFICATION (optional but recommended)
-- --------------------------------------------

do $$
declare
  group_id uuid;
  topic_id uuid;
begin
  select id into group_id from card_groups where name = '[Topic] - [Format 1]';
  select id into topic_id from topics where key = 'your-topic-key';

  raise notice '✅ Setup complete!';
  raise notice 'Card Group ID: %', group_id;
  raise notice 'Topic ID: %', topic_id;
end $$;
```

### Step 6: Apply Migration

```bash
# Apply all pending migrations using the CLI
bun run migration:up

# This will:
# - Apply your new migration
# - Track which migrations have been run
# - Show success/error messages
```

---

## Adding New Regions

Regions define geographic areas (countries, provinces, cities) that can be used as answers in fact cards.

### Region Types

Geolet supports two location types:

1. **Polygon** - Area boundaries (countries, states, provinces)
   - Uses GeoJSON geometry
   - No `centroid_lonlat` needed (calculated from geometry)

2. **Pin** - Point locations (cities, landmarks)
   - Requires `centroid_lonlat` point
   - No `geometry` needed

### Region Levels

```sql
-- Available levels
'country'     -- National borders (e.g., 'US', 'IN', 'FR')
'province'    -- States, provinces, regions (e.g., 'IN:Karnataka', 'US:California')
'city'        -- Cities and towns (e.g., 'IN:Bangalore', 'US:New_York')
```

### Adding Polygon Regions (from GeoJSON)

#### Step 1: Prepare GeoJSON File

Place your GeoJSON file in `public/geojson/` or `public/geojson/regions/`:

```
public/
  geojson/
    countries.json          # World countries
    regions/
      IN.json              # India states/territories
      US.json              # US states
      your_country.json    # Your new regions
```

**GeoJSON structure:**

```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "name": "Region Name",
        "iso_a2": "XX",
        "custom_field": "value"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[[lon, lat], [lon, lat], ...]]
      }
    }
  ]
}
```

#### Step 2: Create SQL Generation Script

Create a TypeScript script in `supabase/seed/scripts/`:

**Example:** `generate-african-regions.ts`

```typescript
import fs from 'fs';
import path from 'path';

interface GeoJSONFeature {
  type: 'Feature';
  properties: Record<string, any>;
  geometry: any;
}

interface GeoJSONFeatureCollection {
  type: 'FeatureCollection';
  features: GeoJSONFeature[];
}

function sqlEscape(str: string): string {
  return str.replace(/'/g, "''");
}

function sanitizeForKey(name: string): string {
  return name
    .replace(/\s+/g, '_')
    .replace(/[^a-zA-Z0-9_]/g, '')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '');
}

function generateAfricanRegionsSQL(): string {
  const geojsonPath = path.join(__dirname, '../../../public/geojson/regions/africa.json');

  if (!fs.existsSync(geojsonPath)) {
    throw new Error(`File not found: ${geojsonPath}`);
  }

  const geojson: GeoJSONFeatureCollection = JSON.parse(fs.readFileSync(geojsonPath, 'utf-8'));

  const inserts = geojson.features.map((feature) => {
    const name = feature.properties.name;
    const country = feature.properties.country_code;  // e.g., 'NG', 'KE', 'ZA'
    const geometry = feature.geometry;

    // Generate key: CountryCode:Region_Name
    const key = `${country}:${sanitizeForKey(name)}`;

    // Escape for SQL
    const safeName = sqlEscape(name);
    const geometryJSON = sqlEscape(JSON.stringify(geometry));

    // NO centroid_lonlat for polygon type - it's calculated automatically
    return `insert into regions (key, level, name, country, location_type, geometry)
values (
  '${key}',
  'province'::region_level_enum,
  '${safeName}',
  '${country}',
  'polygon'::location_type_enum,
  '${geometryJSON}'::jsonb
);`;
  });

  const header = `-- ============================================
-- AFRICAN REGIONS SEED DATA
-- ============================================
-- Generated from: public/geojson/regions/africa.json
-- Count: ${inserts.length} regions
-- Date: ${new Date().toISOString()}
-- ============================================
-- Note: No centroid_lonlat for polygon type regions
-- ============================================

`;

  return header + inserts.join('\n\n');
}

// Run script
function main() {
  const outputDir = path.join(__dirname, '..');
  const outputPath = path.join(outputDir, '04_african_regions.sql');

  console.log('🌍 Generating African regions SQL...');

  try {
    const sql = generateAfricanRegionsSQL();
    fs.writeFileSync(outputPath, sql);
    console.log(`✅ Written to: ${path.relative(process.cwd(), outputPath)}`);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

export { generateAfricanRegionsSQL };
```

#### Step 3: Run Generator Script

```bash
# Run the generator
npx tsx supabase/seed/scripts/generate-african-regions.ts

# Output will be in supabase/seed/04_african_regions.sql
```

#### Step 4: Create Migration and Apply

```bash
# 1. Create a new migration file
bun run migration:new add_african_regions

# 2. Copy the generated SQL into the migration file
# The generator creates supabase/seed/04_african_regions.sql
# Copy its contents to the new migration file

# 3. Apply the migration
bun run migration:up
```

**Example generated SQL:**

```sql
-- Example of what the generator produces
insert into regions (key, level, name, country, location_type, geometry)
values (
  'NG:Lagos',
  'province'::region_level_enum,
  'Lagos',
  'NG',
  'polygon'::location_type_enum,
  '{"type":"Polygon","coordinates":[[[3.2,6.4],[3.3,6.5],...]]}'::jsonb
);
```

### Adding Pin Regions (Cities/Points)

For point locations, you need to provide coordinates directly.

**Step 1:** Create a migration file:

```bash
bun run migration:new add_african_cities
```

**Step 2:** Add SQL to the generated migration file:

```sql
-- Add this content to the migration file

insert into regions (key, level, name, country, location_type, centroid_lonlat)
values
-- Nigeria
(
  'NG:Lagos_City',
  'city'::region_level_enum,
  'Lagos',
  'NG',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(3.3792, 6.5244), 4326)  -- longitude, latitude
),
(
  'NG:Abuja',
  'city'::region_level_enum,
  'Abuja',
  'NG',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(7.4951, 9.0579), 4326)
),

-- Kenya
(
  'KE:Nairobi',
  'city'::region_level_enum,
  'Nairobi',
  'KE',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(36.8219, -1.2921), 4326)
),

-- South Africa
(
  'ZA:Cape_Town',
  'city'::region_level_enum,
  'Cape Town',
  'ZA',
  'pin'::location_type_enum,
  ST_SetSRID(ST_MakePoint(18.4241, -33.9249), 4326)
);
```

**Step 3:** Apply the migration:

```bash
bun run migration:up
```

**Pin parameters:**
- `key` - Unique identifier: `CountryCode:City_Name`
- `level` - Use `'city'::region_level_enum`
- `name` - Display name
- `country` - Two-letter country code
- `location_type` - Must be `'pin'::location_type_enum`
- `centroid_lonlat` - PostGIS point: `ST_SetSRID(ST_MakePoint(longitude, latitude), 4326)`
- `geometry` - Leave NULL for pin type

**Important:** For pin type:
- MUST provide `centroid_lonlat`
- Do NOT provide `geometry`
- Format: `ST_SetSRID(ST_MakePoint(lon, lat), 4326)`
- SRID 4326 = WGS84 (standard lat/long)

### Region Key Naming Convention

```
Format: [CountryCode]:[Sanitized_Name]

Examples:
  IN:Uttar_Pradesh
  US:California
  NG:Lagos
  KE:Nairobi
  ZA:Cape_Town

Sanitization rules:
  - Replace spaces with underscores
  - Remove special characters
  - Keep only alphanumeric and underscores
  - Remove leading/trailing underscores
```

---

## Best Practices

### 1. Content Organization

- **One migration per topic** - Keep related content together
- **Separate region migrations** - Geography data separate from content
- **Incremental additions** - Add content in batches for easier review

### 2. Difficulty Progression

```
Beginner:
  - More context (longer text)
  - Obvious distinctive features
  - Major/popular regions

Intermediate:
  - Moderate context (2-3 sentences)
  - Mix of distinctive and subtle features
  - Mix of major and minor regions

Advanced:
  - Minimal context (single words)
  - Subtle differences
  - Challenging similar-looking scripts/regions
```

### 3. Card Quality

**Good prompts:**
- Use authentic, natural language
- Include distinctive features of the script/region
- Vary vocabulary and topics
- Avoid ambiguity

**Good hints:**
- Provide transliteration for non-Latin scripts
- Add translation for context
- Include key identifying features
- Keep hints informative but not giving away the answer

**Example:**
```sql
prompt: 'ಹೋಟೆಲ್ ರೆಸ್ಟೋರೆಂಟ್'
hint: 'hōṭel resṭōrenṭ (Hotel Restaurant) - Notice the squiggly tail in top right corner of characters'
```

### 4. Testing Regions

Before creating cards, verify regions exist:

```sql
-- Check if region exists
select key, name, level, country, location_type
from regions
where key = 'IN:Karnataka';

-- List all regions for a country
select key, name, level
from regions
where country = 'IN'
order by level, name;

-- Check polygon regions
select key, name, ST_AsGeoJSON(geometry)
from regions
where location_type = 'polygon';

-- Check pin regions
select key, name, ST_AsText(centroid_lonlat)
from regions
where location_type = 'pin';
```

### 5. Verification Queries

After creating content:

```sql
-- Count cards per group
select cg.name, count(fc.id) as card_count
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
group by cg.id, cg.name
order by cg.name;

-- Check topic configuration
select
  t.key,
  t.title,
  t.difficulty,
  array_agg(cg.name) as card_groups
from topics t
join unnest(t.target_card_group_ids) as group_id on true
join card_groups cg on cg.id = group_id
group by t.id, t.key, t.title, t.difficulty
order by t.key;

-- Verify all cards have valid regions
select fc.id, fc.prompt, r.key as region_key, r.name as region_name
from fact_cards fc
left join regions r on r.id = fc.answer_region_id
where r.id is null;  -- Should return no rows

-- Check skill tag usage
select
  unnest(fc.primary_skill_tags) as skill_tag,
  count(*) as usage_count
from fact_cards fc
group by skill_tag
order by usage_count desc;
```

### 6. Migration File Organization

Recommended file naming and order:

```
01_skill_tags.sql              # Base skill definitions
02_countries.sql               # Country polygons
03_india_states.sql            # Regional subdivisions
04_african_regions.sql         # More regional subdivisions
05_major_cities.sql            # City pins
06_indian_languages_setup.sql  # Topic setup
07_indian_languages_cards.sql  # Fact cards
08_african_scripts_setup.sql   # Another topic
09_african_scripts_cards.sql   # More fact cards
```

### 7. Git Workflow

```bash
# 1. Create feature branch
git checkout -b feature/african-languages

# 2. Generate regions SQL (if needed)
npx tsx supabase/seed/scripts/generate-african-regions.ts

# 3. Create migration files using CLI
bun run migration:new add_african_regions
bun run migration:new african_languages_setup
bun run migration:new african_languages_cards

# 4. Edit the generated migration files with your SQL

# 5. Test locally by applying migrations
bun run migration:up
# Verify in app

# 6. Commit and push
git add supabase/migrations/*.sql
git commit -m "feat: Add African languages topic with 156 cards"
git push origin feature/african-languages
```

---

## Complete Example: Adding Phone Number Recognition

Let's walk through a complete example of adding a new topic from scratch.

### 1. Create GeoJSON for Countries (if needed)

```json
// public/geojson/regions/european_countries.json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "iso_a2": "FR",
        "name": "France"
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[...]]
      }
    },
    // ... more countries
  ]
}
```

### 2. Generate Region SQL

```typescript
// supabase/seed/scripts/generate-european-countries.ts
// (Similar to generate-seeds-freshv2.ts example above)
```

Run: `npx tsx supabase/seed/scripts/generate-european-countries.ts`

### 3. Create Migration: Setup

```bash
# Create migration file
bun run migration:new phone_numbers_setup
```

Add this SQL to the generated file:

```sql
-- Add to the generated migration file

-- ============================================
-- PHONE NUMBER RECOGNITION SETUP
-- ============================================

-- --------------------------------------------
-- 1. CREATE CARD GROUPS
-- --------------------------------------------

insert into card_groups (name) values
  ('Phone Numbers - Country Codes'),
  ('Phone Numbers - Regional Codes');

-- --------------------------------------------
-- 2. SKILL TAGS (already exist in skill_tags_v2.sql)
-- --------------------------------------------
-- phone:+33 (France)
-- phone:+49 (Germany)
-- phone:+91:11 (India - Delhi)
-- etc.

-- --------------------------------------------
-- 3. CREATE TOPICS
-- --------------------------------------------

insert into topics (
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids
)
values
(
  'phone-country-codes',
  'Phone Country Codes',
  'Identify which country a phone number belongs to based on its country code.',
  'Phone',
  true,
  true,
  'beginner'::difficulty_enum,
  array[(select id from card_groups where name = 'Phone Numbers - Country Codes')]
),
(
  'phone-regional-codes',
  'Phone Regional Codes',
  'Identify specific regions within countries from area codes.',
  'Phone',
  true,
  true,
  'advanced'::difficulty_enum,
  array[(select id from card_groups where name = 'Phone Numbers - Regional Codes')]
);
```

### 4. Create Migration: Cards

```bash
# Create migration file for cards
bun run migration:new phone_numbers_cards
```

Add this SQL to the generated file:

```sql
-- Add to the generated migration file

-- ============================================
-- PHONE NUMBER CARDS
-- ============================================

-- Country Code Cards (Beginner)
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values
-- France
(
  (select id from card_groups where name = 'Phone Numbers - Country Codes'),
  '+33 1 42 86 82 00',
  'Country code +33',
  array['phone:+33'],
  '1',
  (select id from regions where key = 'FR')
),
(
  (select id from card_groups where name = 'Phone Numbers - Country Codes'),
  '+33 4 91 13 89 00',
  'Country code +33',
  array['phone:+33'],
  '1',
  (select id from regions where key = 'FR')
),

-- Germany
(
  (select id from card_groups where name = 'Phone Numbers - Country Codes'),
  '+49 30 12345678',
  'Country code +49',
  array['phone:+49'],
  '1',
  (select id from regions where key = 'DE')
),

-- Regional Code Cards (Advanced) - India example
(
  (select id from card_groups where name = 'Phone Numbers - Regional Codes'),
  '+91 11 2301 4567',
  'Area code 11 (Delhi NCR)',
  array['phone:+91:11'],
  '3',
  (select id from regions where key = 'IN:Delhi')
),
(
  (select id from card_groups where name = 'Phone Numbers - Regional Codes'),
  '+91 22 2288 1234',
  'Area code 22 (Mumbai)',
  array['phone:+91:22'],
  '3',
  (select id from regions where key = 'IN:Maharashtra')
);
```

### 5. Apply and Test

```bash
# Apply all pending migrations
bun run migration:up

# Verify in your application that:
# - Topics appear in the topic list
# - Cards are playable
# - Regions are correctly mapped
```

### 6. Verify

```sql
-- Check card counts
select cg.name, count(fc.id)
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
where cg.name like 'Phone Numbers%'
group by cg.name;

-- Check topics
select key, title, difficulty
from topics
where key like 'phone-%';
```

---

## Troubleshooting

### Cards Not Appearing

1. **Check card group exists:**
   ```sql
   select * from card_groups where name = 'Your Card Group Name';
   ```

2. **Check topic references correct group:**
   ```sql
   select t.key, unnest(t.target_card_group_ids) as group_id
   from topics t
   where t.key = 'your-topic-key';
   ```

3. **Check cards reference correct group:**
   ```sql
   select count(*)
   from fact_cards
   where card_group_id = (select id from card_groups where name = 'Your Card Group Name');
   ```

### Region Not Found

1. **Check region exists:**
   ```sql
   select * from regions where key = 'YOUR:REGION_KEY';
   ```

2. **Check region type matches data:**
   ```sql
   select key, location_type,
          geometry is not null as has_geometry,
          centroid_lonlat is not null as has_centroid
   from regions
   where key = 'YOUR:REGION_KEY';
   ```

### Geometry Issues

1. **Validate GeoJSON:**
   - Use [geojson.io](http://geojson.io/) to visualize
   - Ensure coordinates are [longitude, latitude]

2. **Check PostGIS:**
   ```sql
   select key, ST_IsValid(geometry) as is_valid
   from regions
   where geometry is not null;
   ```

---

## Resources

- **Example migrations:** `supabase/migrations/2025111218*_fact_card_indian_setup*.sql`
- **Region generator:** `supabase/seed/scripts/generate-seeds-freshv2.ts`
- **GeoJSON validation:** http://geojson.io/
- **PostGIS docs:** https://postgis.net/docs/
- **Coordinate reference:** SRID 4326 (WGS84) - standard lat/long

---

## Summary Checklist

### Adding a New Topic:
- [ ] Define or identify existing skill tags
- [ ] Create card group(s)
- [ ] Create topic(s) referencing card groups
- [ ] Create fact cards with prompts, hints, skill tags, and region IDs
- [ ] Create migration file using `bun run migration:new <name>`
- [ ] Write SQL into the generated migration file
- [ ] Apply migration using `bun run migration:up`
- [ ] Verify card counts and region references

### Adding New Regions:
- [ ] Decide region type (polygon or pin)
- [ ] For polygon: Prepare GeoJSON file
- [ ] For polygon: Create/run SQL generator script
- [ ] For pin: Get coordinates (lon, lat)
- [ ] Create migration using `bun run migration:new <name>`
- [ ] Add INSERT statements to the generated file
- [ ] Apply migration using `bun run migration:up`
- [ ] Verify regions with test queries

---

**Happy content creation! 🌍📚**
