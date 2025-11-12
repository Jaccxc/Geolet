# Seed Data Generation

This directory contains scripts to generate seed data for the fresh database migration.

## Structure

```
supabase/seed/
├── scripts/
│   ├── generate-seeds-fresh.ts   # Main generation script
│   ├── package.json               # Node dependencies
│   └── tsconfig.json              # TypeScript config
├── 01_skill_tags.sql              # Generated: skill tags
├── 02_countries.sql               # Generated: all countries with GeoJSON
├── 03_india_states.sql            # Generated: Indian states/UTs
├── skill_tags.json.deprecated     # Source data (old format)
└── README.md                      # This file
```

## Quick Start

### 1. Generate Seed SQL Files

```bash
# From project root
cd supabase/seed/scripts

# Install dependencies
npm install

# Generate all seed files
npm run generate
```

This will create three SQL files in `supabase/seed/`:
- `01_skill_tags.sql` (~40 skill tags)
- `02_countries.sql` (~195 countries with GeoJSON polygons)
- `03_india_states.sql` (~36 Indian states/UTs with GeoJSON polygons)

### 2. Apply Migration & Seeds

```bash
# From project root

# 1. Apply fresh schema migration
supabase db reset
# OR manually:
# psql $DATABASE_URL -f supabase/migrations/20251112180204_fresh_schema.sql

# 2. Apply seed data in order
psql $DATABASE_URL -f supabase/seed/01_skill_tags.sql
psql $DATABASE_URL -f supabase/seed/02_countries.sql
psql $DATABASE_URL -f supabase/seed/03_india_states.sql
```

### 3. Verify

```bash
# Check counts
psql $DATABASE_URL -c "select count(*) from skill_tags;"
psql $DATABASE_URL -c "select count(*) from regions where level = 'country';"
psql $DATABASE_URL -c "select count(*) from regions where level = 'province' and country = 'IN';"

# Sample data
psql $DATABASE_URL -c "select key, name, level, location_type from regions limit 10;"
```

## Data Sources

### skill_tags
- **Source:** `supabase/seed/skill_tags.json.deprecated`
- **Transform:** Extract `display`, `note`, `examples` from `meta` JSON → plain columns
- **Count:** ~40 skill tags
- **Families:** `script`, `phone`, `city`

### Countries
- **Source:** `public/geojson/countries.json`
- **Extract:** ISO country codes + GeoJSON polygons
- **Count:** ~195 countries
- **Format:** All use `location_type='polygon'` (NO centroid_lonlat)
- **Key format:** ISO 3166-1 alpha-2 (e.g., "IN", "US", "TW")

### India States/UTs
- **Source:** `public/geojson/regions/IN.json`
- **Extract:** Indian states/union territories + GeoJSON polygons
- **Count:** ~36 states/UTs
- **Format:** All use `location_type='polygon'` (NO centroid_lonlat)
- **Key format:** `IN:State_Name` (e.g., "IN:Maharashtra", "IN:Kerala")

## Important Notes

### Location Type Logic

**Polygon regions (countries, states):**
- `location_type = 'polygon'`
- `geometry` contains GeoJSON polygon
- `centroid_lonlat` is NULL (not needed for polygon validation)

**Pin regions (future cities):**
- `location_type = 'pin'`
- `centroid_lonlat` contains [lng, lat]
- `geometry` is NULL

**Current seed data:** All regions are polygon type (no centroids).

### Key Naming Convention

- **Countries:** ISO 3166-1 alpha-2 code (e.g., `IN`, `US`, `CN`)
- **Provinces/States:** `CountryCode:State_Name` (e.g., `IN:Andhra_Pradesh`)
- **Cities (future):** `CountryCode:City_Name` (e.g., `IN:Mumbai`, `TW:Taipei`)

Examples of India state keys:
```
Andaman and Nicobar    → IN:Andaman_and_Nicobar
Andhra Pradesh         → IN:Andhra_Pradesh
NCT of Delhi           → IN:NCT_of_Delhi
Jammu and Kashmir      → IN:Jammu_and_Kashmir
```

## Schema Overview

### Enums Created

```sql
region_level_enum      → 'country', 'province', 'city'
location_type_enum     → 'pin', 'polygon'
skill_family_enum      → 'script', 'phone', 'city'
difficulty_enum        → 'beginner', 'intermediate', 'advanced'
fact_difficulty_enum   → '1', '2', '3'
```

### Tables Created

1. **card_groups** - Logical groupings (e.g., "India Scripts")
2. **topics** - Game topics with mode flags
3. **regions** - Geographic regions with GeoJSON
4. **skill_tags** - Skills/tags for fact cards
5. **fact_cards** - Quiz/game cards
6. **user_fact_stats** - User progress (SRS system)
7. **game_sessions** - Game session history
8. **insight_rounds** - GeoGuessr-style rounds

### Populated Tables

After running seeds, these tables will have data:
- ✅ **skill_tags** (~40 rows)
- ✅ **regions** (~231 rows: 195 countries + 36 India states)

These tables are empty (defer manual population):
- ⏸️ **card_groups**
- ⏸️ **topics**
- ⏸️ **fact_cards**

## Troubleshooting

### "File not found" error
- Make sure you're running from `supabase/seed/scripts/` directory
- Check that source files exist:
  - `../skill_tags.json.deprecated`
  - `../../../public/geojson/countries.json`
  - `../../../public/geojson/regions/IN.json`

### TypeScript errors
```bash
cd supabase/seed/scripts
rm -rf node_modules package-lock.json
npm install
npm run generate
```

### PostgreSQL errors
- Ensure migration ran successfully first
- Check enum types exist: `\dT` in psql
- Check table exists: `\dt` in psql

## Next Steps

After populating skill_tags and regions:

1. **Create card_groups** (manual)
   ```sql
   insert into card_groups (name) values
     ('India Scripts'),
     ('East Asian Scripts'),
     ('Global Phone Codes');
   ```

2. **Create topics** (manual)
   ```sql
   insert into topics (key, title, description, icon, difficulty, target_card_group_ids)
   values (
     'india-languages',
     'India Languages',
     'Identify regional scripts across Indian states',
     'Languages',
     'intermediate',
     array[(select id from card_groups where name = 'India Scripts')]
   );
   ```

3. **Create fact_cards** (manual, careful curation needed)

## References

- Migration file: `supabase/migrations/20251112180204_fresh_schema.sql`
- Documentation: `docs/15_database_fresh_migration_plan_20251112_174624.md`
- GeoJSON sources: `public/geojson/`
