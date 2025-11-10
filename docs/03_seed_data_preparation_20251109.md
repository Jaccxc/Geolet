# Step 3: Seed Data Preparation

**Timeline:** 6-8 hours
**Priority:** High (Blocks testing of all features)

## Overview
Create initial content for Geolet's minigames. Focus on high-quality, minimal dataset covering core use cases mentioned in the plan (Indian languages, European scripts, phone codes, major cities).

## Prerequisites
- Step 2 completed (database schema exists)
- Understanding of GeoJSON format
- Access to geographic data sources

## Detailed Tasks

### 3.1 Create Seed Data Directory Structure
```
/supabase/seed/
  ├── skill_tags.json
  ├── regions.json
  ├── fact_cards.json
  └── seed.sql (migration to load all data)
```

### 3.2 Prepare skill_tags Data

#### Target Content (MVP):
**Scripts (20-30 tags):**
- `script:devanagari` - India, Nepal
- `script:bengali` - India (West Bengal), Bangladesh
- `script:tamil` - India (Tamil Nadu), Sri Lanka
- `script:cyrillic` - Russia, Ukraine, Bulgaria, etc.
- `script:latin` - Most of Europe, Americas
- `script:arabic` - Middle East, North Africa
- `script:chinese:simplified` - China
- `script:chinese:traditional` - Taiwan
- `script:japanese:hiragana`, `script:japanese:katakana`, `script:japanese:kanji`
- `script:korean:hangul`
- `script:greek`, `script:hebrew`, `script:thai`, etc.

**Phone Codes (30-40 tags):**
- `phone:+91` - India
- `phone:+44` - UK
- `phone:+33` - France
- `phone:+1` - US/Canada
- `phone:+49` - Germany
- `phone:+91:11` - Delhi area code
- `phone:+91:22` - Mumbai area code
- etc.

**Cities (40-50 tags):**
- `city:IN:tier1` - Delhi, Mumbai, Bangalore, etc.
- `city:FR:tier1` - Paris, Lyon, Marseille
- `city:US:tier1` - NYC, LA, Chicago
- By country + tier level

**JSON Structure:**
```json
{
  "key": "script:devanagari",
  "family": "script",
  "country": "IN",
  "meta": {
    "display": "Devanagari",
    "notes": "Used for Hindi, Marathi, Nepali. Distinctive horizontal line above characters.",
    "examples": ["होटल", "रेस्तरां", "स्कूल"]
  }
}
```

### 3.3 Prepare regions Data

#### Required Regions (Start Small):

**Countries (~20):**
- IN, US, FR, DE, GB, IT, ES, CN, JP, KR, TW, RU, BR, AU, CA, MX, AR, NP, BD, PK

**Cities (~30-50):**
Focus on tier-1 cities mentioned:
- India: Delhi, Mumbai, Bangalore, Chennai, Kolkata
- France: Paris, Lyon, Marseille
- US: NYC, LA, Chicago, Houston, Phoenix
- Taiwan: Taipei, Kaohsiung, Taichung
- etc.

**GeoJSON Requirements:**
- Countries: Need polygons (can get from Natural Earth Data)
- Cities: Start with `centroid_lonlat + bbox` (points), polygons optional

**Data Sources:**
- Natural Earth Data (https://www.naturalearthdata.com/) - Country boundaries
- OpenStreetMap Nominatim API - City centroids
- Simplified GeoJSON (reduce polygon complexity)

**JSON Structure:**
```json
{
  "key": "IN",
  "kind": "country",
  "name": "India",
  "country": null,
  "geometry": {
    "type": "MultiPolygon",
    "coordinates": [...]
  },
  "centroid_lonlat": [78.9629, 20.5937],
  "bbox": [68.1766, 7.9668, 97.4025, 35.4940],
  "meta": {}
}
```

```json
{
  "key": "IN:Delhi",
  "kind": "city",
  "name": "Delhi",
  "country": "IN",
  "geometry": null,
  "centroid_lonlat": [77.2090, 28.6139],
  "bbox": [77.0, 28.4, 77.4, 28.8],
  "meta": {"tier": 1, "population": 32900000}
}
```

### 3.4 Prepare fact_cards Data

#### Language Snippet Cards (~50):
```json
{
  "type": "language_snippet",
  "payload": {"text": "होटल", "romanization": "hotel"},
  "primary_tags": ["script:devanagari"],
  "difficulty": 1,
  "answer": {
    "kind": "tag",
    "select": {"by": "skill_key", "keys": ["script:devanagari"]},
    "map_equivalents": {"regions": ["IN", "NP"]}
  }
}
```

**Content Ideas:**
- Common words: Hotel, Restaurant, School, Police, Hospital
- Numbers: 1-10 in various scripts
- Distinctive phrases

#### Phone Number Cards (~40):
```json
{
  "type": "phone_number",
  "payload": {"number": "+91 11 2345 6789", "masked": "+91 11..."},
  "primary_tags": ["phone:+91", "phone:+91:11"],
  "difficulty": 1,
  "answer": {
    "kind": "region",
    "select": {"by": "key", "keys": ["IN"]}
  }
}
```

#### City Locate Cards (~40):
```json
{
  "type": "city_locate",
  "payload": {"city": "Delhi", "country_hint": "IN"},
  "primary_tags": ["city:IN:tier1"],
  "difficulty": 1,
  "answer": {
    "kind": "region",
    "select": {"by": "key", "keys": ["IN:Delhi"]}
  }
}
```

### 3.5 Create Seed Migration

Create `/supabase/migrations/[timestamp]_seed_initial_data.sql`:

```sql
-- Load skill_tags
INSERT INTO skill_tags (key, family, country, meta) VALUES
  ('script:devanagari', 'script', 'IN', '{"display":"Devanagari","notes":"...","examples":[...]}'),
  ('script:cyrillic', 'script', 'RU', '{"display":"Cyrillic","notes":"..."}'),
  -- ... more tags
;

-- Load regions (use DO block for JSONB)
INSERT INTO regions (key, kind, name, country, geometry, centroid_lonlat, bbox, meta) VALUES
  ('IN', 'country', 'India', null, '{...}'::jsonb, '{78.9629,20.5937}', '{68.1766,7.9668,97.4025,35.4940}', '{}'),
  -- ... more regions
;

-- Load fact_cards
INSERT INTO fact_cards (type, payload, primary_tags, difficulty, answer) VALUES
  ('language_snippet', '{"text":"होटल"}'::jsonb, '{"script:devanagari"}', 1, '{"kind":"tag",...}'::jsonb),
  -- ... more facts
;
```

### 3.6 Run Seed Migration
```bash
bun run migration:up
```

### 3.7 Verify Data
```sql
SELECT COUNT(*) FROM skill_tags;  -- Should be ~100
SELECT COUNT(*) FROM regions;     -- Should be ~50-70
SELECT COUNT(*) FROM fact_cards;  -- Should be ~100-150
```

## Files to Create/Modify

### Created:
- `/supabase/seed/skill_tags.json`
- `/supabase/seed/regions.json`
- `/supabase/seed/fact_cards.json`
- `/supabase/seed/scripts/generate-seed-sql.ts` (optional helper)
- `/supabase/migrations/[timestamp]_seed_initial_data.sql`

## Acceptance Criteria
- ✅ At least 80 skill_tags covering scripts, phones, cities
- ✅ At least 50 regions (20 countries, 30 cities)
- ✅ At least 100 fact_cards (distributed across all 3 types)
- ✅ All fact_cards reference valid skill_tags and regions
- ✅ GeoJSON geometries are valid and simplified
- ✅ Seed migration runs successfully
- ✅ Can query and join across tables

## Notes & Considerations

### Data Quality Over Quantity
- Focus on high-signal content for MVP
- Ensure accuracy (wrong data = bad learning)
- Distinctive examples (easy to recognize)

### Geometry Simplification
- Keep polygon complexity low (< 1000 points per country)
- Use tools like mapshaper.org to simplify
- For MVP, city points (centroid + tolerance) are sufficient

### Content Sources
- **Scripts**: Wikipedia language articles
- **Phone codes**: Wikipedia list of country calling codes
- **Geography**: Natural Earth Data, OpenStreetMap
- **Validation**: Google Maps for verification

### Extensibility
- Design JSON structure to easily add more content later
- Keep seed files separate from migration for maintainability
- Consider script to auto-generate SQL from JSON

## Dependencies
- Step 2 (Database Schema)

## Blocks
- Step 5 (Flash API - needs content to test)
- Step 6 (Flash UI - needs content to display)
