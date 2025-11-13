# WATG24 Cities - Quick Start

## What This Is

A complete system for adding 335 global cities (from the GaWC World Alpha/Beta/Gamma Cities classification) to Geolet as quiz content.

**Two Topics:**
1. **Global Major Cities** - 10 most influential cities (Alpha++ and Alpha+)
2. **Cities-500** - All 335 cities across 12 tiers

## Files Created

```
Geolet/
├── supabase/seed/
│   ├── watg24_cities_template.sql          # 335 cities with TODOs
│   ├── watg24_cities_list.json             # Reference/tracking file
│   └── scripts/
│       ├── generate-watg24-cities.ts       # Generator script
│       └── verify-watg24-progress.ts       # Progress checker
│
├── docs/
│   ├── WATG24_SUMMARY.md                   # Overview (start here!)
│   ├── WATG24_CITIES_WORKFLOW.md           # Detailed workflow guide
│   └── EXAMPLE_watg24_alpha_plusplus.sql   # Completed example
│
└── public/
    └── WATG24.csv                           # Source data (335 cities)
```

## Quick Start (5 minutes)

### 1. Review What Was Generated

```bash
# See statistics
npx tsx supabase/seed/scripts/verify-watg24-progress.ts

# Review template
code supabase/seed/watg24_cities_template.sql

# Review example
code docs/EXAMPLE_watg24_alpha_plusplus.sql
```

### 2. Read Documentation

**Start here:** [`docs/WATG24_SUMMARY.md`](docs/WATG24_SUMMARY.md)

Then read: [`docs/WATG24_CITIES_WORKFLOW.md`](docs/WATG24_CITIES_WORKFLOW.md)

### 3. Implement First 2 Cities (Alpha++)

Follow the example in `docs/EXAMPLE_watg24_alpha_plusplus.sql`:

**Step 1: Create pin regions**
```bash
bun run migration:new add_watg24_city_pins_alpha_plusplus
```

Add London and New York pins (see example file for coordinates).

```bash
bun run migration:up
```

**Step 2: Create card groups and topics**
```bash
bun run migration:new add_watg24_setup
```

Copy card groups and topics from template.

```bash
bun run migration:up
```

**Step 3: Add city data**
```bash
bun run migration:new add_watg24_cities_alpha_plusplus
```

Fill in London and New York data from template (country codes, notes, region mappings).

```bash
bun run migration:up
```

**Step 4: Test in app**
- Open Geolet
- Navigate to Topics
- Find "Global Major Cities"
- Test London and New York cards

### 4. Continue with Remaining Cities

Repeat the process for each tier:
- Alpha+ (8 cities)
- Alpha (17 cities)
- ... continue through all tiers

Use the verification script to track progress:
```bash
npx tsx supabase/seed/scripts/verify-watg24-progress.ts
```

## Key Concepts

### For Each City, You Need:

1. **Country Code** (e.g., 'GB', 'US')
2. **Geographic Note** (2-3 sentences describing the city)
3. **Pin Region** (coordinates: longitude, latitude)
4. **Region Mapping** (link fact card to region)

### Template Structure

The template has **TODOs** you need to fill:

```sql
-- TODO #1: Country code
null,  -- TODO: Add 2-letter country code

-- TODO #2: Geographic note
'TODO: Add geographic/cultural info about London...',

-- TODO #3: Region mapping
null  -- TODO: Map to region key
```

After filling:

```sql
-- ✅ Country code
'GB',

-- ✅ Geographic note
'Capital of the United Kingdom, located in southeastern England...',

-- ✅ Region mapping
(select id from regions where key = 'GB:London')
```

## Tools

### Generate Template (already done)
```bash
npx tsx supabase/seed/scripts/generate-watg24-cities.ts
```

### Check Progress
```bash
npx tsx supabase/seed/scripts/verify-watg24-progress.ts
```

### Create Migration
```bash
bun run migration:new <name>
```

### Apply Migration
```bash
bun run migration:up
```

## Resources

### Documentation
- **📖 Complete Guide:** [`docs/WATG24_CITIES_WORKFLOW.md`](docs/WATG24_CITIES_WORKFLOW.md)
- **📊 Summary:** [`docs/WATG24_SUMMARY.md`](docs/WATG24_SUMMARY.md)
- **✅ Example:** [`docs/EXAMPLE_watg24_alpha_plusplus.sql`](docs/EXAMPLE_watg24_alpha_plusplus.sql)
- **🛠️ General Content Guide:** [`docs/ADDING_NEW_CONTENT.md`](docs/ADDING_NEW_CONTENT.md)

### Research Tools
- **Coordinates:** https://www.latlong.net/ or Google Maps
- **City Info:** Wikipedia, Britannica
- **Country Codes:** ISO 3166-1 alpha-2

### SQL Verification Queries

```sql
-- Check card groups
select name from card_groups where name like 'cities_watg24_%';

-- Count cards per tier
select cg.name, count(fc.id)
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
where cg.name like 'cities_watg24_%'
group by cg.name;

-- Find cards without regions
select fc.prompt
from fact_cards fc
where fc.answer_region_id is null
and fc.card_group_id in (
  select id from card_groups where name like 'cities_watg24_%'
);
```

## Statistics

- **Total Cities:** 335
- **Card Groups:** 12 (one per tier)
- **Topics:** 2 (Global Major Cities, Cities-500)
- **Tiers:** Alpha++ (2), Alpha+ (8), Alpha (17), Alpha- (22), Beta+ (20), Beta (23), Beta- (28), Gamma+ (20), Gamma (25), Gamma- (25), High Sufficiency (26), Sufficiency (119)

## Estimated Time

- **Per city:** 5-10 minutes (research + fill)
- **Total:** 28-56 hours
- **Recommended:** Work in batches over several weeks

## Status

✅ Template generated (335 cities)
✅ Documentation complete
✅ Example provided
✅ Progress checker created
⏳ **Ready to start filling in data!**

Start with Alpha++ cities (London, New York) to validate the workflow.

---

**Questions?** See [`docs/WATG24_CITIES_WORKFLOW.md`](docs/WATG24_CITIES_WORKFLOW.md) for detailed instructions.

**Need help?** Check the example at [`docs/EXAMPLE_watg24_alpha_plusplus.sql`](docs/EXAMPLE_watg24_alpha_plusplus.sql)

**Good luck! 🌍✨**
