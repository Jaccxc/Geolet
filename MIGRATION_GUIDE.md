# Database Fresh Migration Guide

**Date:** 2025-11-12
**Type:** Drop & Recreate (Alpha stage)

This guide walks you through the complete database migration to the new optimized schema.

---

## ⚠️ Before You Start

**This migration will:**
- ✅ Drop all Geolet tables (fact_cards, regions, skill_tags, etc.)
- ✅ Preserve auth.users and all authentication tables
- ✅ Create new optimized schema with PostgreSQL ENUMs
- ✅ Populate with GeoJSON data from `public/geojson/`

**Backup recommended** (optional, since alpha stage):
```bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql
```

---

## 🚀 Migration Steps

### Step 1: Apply Fresh Schema Migration

```bash
# Option A: Using Supabase CLI (recommended)
supabase db reset

# Option B: Manual PostgreSQL
psql $DATABASE_URL -f supabase/migrations/20251112180204_fresh_schema.sql
```

**Expected output:**
```
✅ Fresh schema migration complete!
   - All old Geolet tables dropped
   - New optimized schema created with ENUMs
   - Ready for seed data population
```

### Step 2: Generate Seed Data

```bash
# Navigate to seed scripts
cd supabase/seed/scripts

# Install dependencies (first time only)
npm install

# Generate SQL files
npm run generate
```

**Expected output:**
```
🚀 Generating fresh seed data...

📝 [1/3] Transforming skill_tags...
   ✅ Written to: supabase/seed/01_skill_tags.sql

🌍 [2/3] Extracting countries from GeoJSON...
   ✅ Written to: supabase/seed/02_countries.sql

🇮🇳 [3/3] Extracting India states from GeoJSON...
   ✅ Written to: supabase/seed/03_india_states.sql

✨ Seed generation complete!
```

### Step 3: Apply Seed Data

```bash
# Return to project root
cd ../../..

# Apply seeds in order
psql $DATABASE_URL -f supabase/seed/01_skill_tags.sql
psql $DATABASE_URL -f supabase/seed/02_countries.sql
psql $DATABASE_URL -f supabase/seed/03_india_states.sql
```

### Step 4: Verify Migration

```bash
# Check table counts
psql $DATABASE_URL <<EOF
select 'skill_tags' as table_name, count(*) as count from skill_tags
union all
select 'countries', count(*) from regions where level = 'country'
union all
select 'india_states', count(*) from regions where level = 'province' and country = 'IN'
union all
select 'total_regions', count(*) from regions;
EOF
```

**Expected counts:**
```
   table_name   | count
----------------+-------
 skill_tags     |    40
 countries      |   195
 india_states   |    36
 total_regions  |   231
```

---

## 📋 Schema Changes

### New Enum Types

```sql
region_level_enum      → 'country', 'province', 'city'
location_type_enum     → 'pin', 'polygon'
skill_family_enum      → 'script', 'phone', 'city'
difficulty_enum        → 'beginner', 'intermediate', 'advanced'
fact_difficulty_enum   → '1', '2', '3'
```

### Key Improvements

**Before:**
```sql
-- Old schema
type text check (type in ('language_snippet', 'phone_number', 'city_locate'))
payload jsonb not null
answer jsonb not null
primary_tags text[]
meta jsonb
bbox double precision[]
```

**After:**
```sql
-- New schema
card_group_id uuid not null references card_groups(id)
prompt text not null
hint text
primary_skill_tags text[]
answer_region_id uuid not null references regions(id)
difficulty fact_difficulty_enum not null default '1'
-- NO meta, NO bbox, NO complex JSON!
```

### Location Type Logic

**Polygon regions (countries, states):**
- `location_type = 'polygon'::location_type_enum`
- `geometry` contains full GeoJSON polygon
- `centroid_lonlat` is NULL (not used)

**Pin regions (future cities):**
- `location_type = 'pin'::location_type_enum`
- `centroid_lonlat` contains [lng, lat]
- `geometry` is NULL

**Current data:** All regions use `polygon` type.

---

## 🔍 Sample Queries

### Inspect Regions

```sql
-- Sample countries
select key, name, location_type
from regions
where level = 'country'
order by name
limit 10;

-- Sample India states
select key, name, note
from regions
where country = 'IN'
order by name;

-- Check GeoJSON structure
select
  key,
  name,
  geometry->>'type' as geom_type,
  jsonb_array_length(geometry->'coordinates') as coord_arrays
from regions
where key in ('IN', 'US', 'IN:Maharashtra')
limit 5;
```

### Inspect Skill Tags

```sql
-- All script families
select family, count(*) as count
from skill_tags
group by family;

-- Sample Indian scripts
select key, display, examples[1] as example
from skill_tags
where family = 'script' and country = 'IN'
order by display;
```

---

## 🎯 Next Steps

After successful migration, you'll need to manually create:

### 1. Card Groups

```sql
insert into card_groups (name) values
  ('India Scripts'),
  ('East Asian Scripts'),
  ('Southeast Asian Scripts'),
  ('European Scripts'),
  ('Middle Eastern Scripts'),
  ('Global Phone Codes'),
  ('Major World Cities');
```

### 2. Topics

```sql
insert into topics (key, title, description, icon, pick_mode_active, map_mode_active, difficulty, target_card_group_ids)
values (
  'india-languages',
  'India Languages',
  'Identify regional scripts across Indian states - from Devanagari to Telugu',
  'Languages',
  true,
  true,
  'intermediate'::difficulty_enum,
  array[(select id from card_groups where name = 'India Scripts')]
);
```

### 3. Fact Cards

Create fact_cards manually with:
- `card_group_id` → link to card group
- `prompt` → the main content (e.g., "ഹോട്ടല്‍")
- `hint` → auxiliary info (e.g., "hōṭṭal (hotel)")
- `primary_skill_tags` → array of skill tag keys
- `difficulty` → '1', '2', or '3'
- `answer_region_id` → link to region

**Example:**
```sql
insert into fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
values (
  (select id from card_groups where name = 'India Scripts'),
  'ഹോട്ടല്‍',
  'hōṭṭal (hotel)',
  array['script:malayalam'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Kerala')
);
```

---

## 🛠️ Troubleshooting

### Migration fails with "relation already exists"
```bash
# Drop all tables manually first
psql $DATABASE_URL <<EOF
drop schema public cascade;
create schema public;
grant all on schema public to postgres;
grant all on schema public to public;
EOF

# Then re-run migration
supabase db reset
```

### Seed generation fails
```bash
# Check file paths exist
ls supabase/seed/skill_tags.json.deprecated
ls public/geojson/countries.json
ls public/geojson/regions/IN.json

# Re-install dependencies
cd supabase/seed/scripts
rm -rf node_modules package-lock.json
npm install
npm run generate
```

### Application errors after migration
- Update TypeScript types to use new schema
- Update API routes (buildQueue, generatePickOptions)
- Update controllers to use new column names
- See `docs/14_database_optimization_revised_20251112_170742.md` for details

---

## 📚 Documentation

- **Migration SQL:** `supabase/migrations/20251112180204_fresh_schema.sql`
- **Seed Scripts:** `supabase/seed/scripts/generate-seeds-fresh.ts`
- **Seed README:** `supabase/seed/README.md`
- **Full Plan:** `docs/15_database_fresh_migration_plan_20251112_174624.md`
- **Schema Design:** `docs/14_database_optimization_revised_20251112_170742.md`

---

## ✅ Success Checklist

- [ ] Backed up database (optional)
- [ ] Applied fresh schema migration
- [ ] Generated seed SQL files
- [ ] Applied all 3 seed files
- [ ] Verified table counts match expected
- [ ] Inspected sample data looks correct
- [ ] (Future) Create card_groups manually
- [ ] (Future) Create topics manually
- [ ] (Future) Create fact_cards manually
- [ ] (Future) Update application code

---

**Migration complete!** 🎉

Your database now has:
- ✅ Clean optimized schema with PostgreSQL ENUMs
- ✅ ~40 skill tags (scripts, phone codes, city tags)
- ✅ ~195 countries with full GeoJSON polygons
- ✅ ~36 Indian states/UTs with full GeoJSON polygons
- ✅ No unnecessary JSON blobs, meta fields, or bbox columns
