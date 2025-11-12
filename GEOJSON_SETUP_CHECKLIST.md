# GeoJSON Setup Checklist

Quick reference for setting up GeoJSON integration.

## File Placement

### 1. Create directories
```bash
mkdir -p public/geojson/regions
```

### 2. Place GeoJSON files

**Your countries.json (600KB):**
```bash
# Copy your simplified countries GeoJSON here:
public/geojson/countries.json
```

**Your IN.json (Indian states):**
```bash
# Copy your Indian states GeoJSON here:
public/geojson/regions/IN.json
```

### 3. Verify structure

Your `public/geojson/` folder should look like:
```
public/
└── geojson/
    ├── countries.json          # ✓ 600KB
    └── regions/
        └── IN.json             # ✓ Your Indian states file
```

## Migration Steps

### 1. Apply migrations in order:

```bash
# Migration 1: Make geometry nullable
supabase db push
# or manually: supabase/migrations/20251109170000_make_geometry_nullable.sql

# Migration 2: Add GeoJSON references
supabase db push
# or manually: supabase/migrations/20251110041500_add_geojson_references.sql

# Migration 3: Load seed data
supabase db push
# or manually: supabase/migrations/20251110040930_seed_initial_data.sql
```

### 2. Verify migrations:

```sql
-- Check GeoJSON columns exist
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'regions'
  AND column_name LIKE 'geojson%';

-- Should return:
-- geojson_file, text
-- geojson_id_property, text
-- geojson_feature_id, text
```

### 3. Verify GeoJSON references:

```sql
-- Check countries have GeoJSON references
SELECT key, geojson_file, geojson_id_property, geojson_feature_id
FROM regions
WHERE kind = 'country'
LIMIT 5;

-- Should return rows like:
-- IN, /geojson/countries.json, iso_a2, IN
-- US, /geojson/countries.json, iso_a2, US

-- Check Indian states have GeoJSON references
SELECT key, geojson_file, geojson_id_property, geojson_feature_id
FROM regions
WHERE country = 'IN' AND kind = 'region'
LIMIT 5;

-- Should return rows like:
-- IN-MH, /geojson/regions/IN.json, NAME_1, Maharashtra
-- IN-PB, /geojson/regions/IN.json, NAME_1, Punjab
```

## Testing

### 1. Test file accessibility

```bash
# Start dev server
npm run dev

# Open browser console and test:
```

```javascript
// Test countries.json loads
fetch('/geojson/countries.json')
  .then(r => r.json())
  .then(d => {
    console.log('Countries loaded:', d.features.length);
    console.log('Sample:', d.features[0].properties);
  });

// Test regions/IN.json loads
fetch('/geojson/regions/IN.json')
  .then(r => r.json())
  .then(d => {
    console.log('Indian states loaded:', d.features.length);
    console.log('Sample:', d.features[0].properties);
  });
```

### 2. Verify data integrity

```sql
-- Count records
SELECT
  COUNT(*) FILTER (WHERE kind = 'country') as countries,
  COUNT(*) FILTER (WHERE kind = 'region') as regions,
  COUNT(*) FILTER (WHERE kind = 'city') as cities
FROM regions;

-- Should return:
-- countries: 24, regions: 18, cities: 22

-- Check skill tags
SELECT COUNT(*) FROM skill_tags;
-- Should return: 55

-- Check fact cards
SELECT COUNT(*) FROM fact_cards;
-- Should return: 72
```

## Quick Reference

### Database → GeoJSON Mapping

**Countries:**
- DB key: `IN` → GeoJSON property: `iso_a2: "IN"`
- DB key: `US` → GeoJSON property: `iso_a2: "US"`

**Indian States:**
- DB key: `IN-MH` → GeoJSON property: `NAME_1: "Maharashtra"`
- DB key: `IN-PB` → GeoJSON property: `NAME_1: "Punjab"`
- DB key: `IN-DL` → GeoJSON property: `NAME_1: "NCT of Delhi"`

**Cities (no GeoJSON):**
- Use `centroid_lonlat` + 50km tolerance

### File Sizes

| File | Size | Load Time (3G) | Load Time (WiFi) |
|------|------|----------------|------------------|
| countries.json | 600KB | ~1.5s | ~100ms |
| regions/IN.json | ~500KB | ~1.2s | ~80ms |

## Common Issues

### Issue: "GeoJSON file not found"
**Fix:** Check file is in `public/geojson/` (not `src/` or other folder)

### Issue: "Feature not found in GeoJSON"
**Fix:** Check `geojson_feature_id` in database matches property value in GeoJSON

### Issue: "Polygon validation always fails"
**Fix:** Ensure coordinates are [longitude, latitude], not [lat, lng]

### Issue: "Files too large"
**Fix:** Simplify GeoJSON using https://mapshaper.org
- Try "Simplify" → "10%" or "dp 0.01"

## Next Steps After Setup

1. ✅ GeoJSON files placed
2. ✅ Migrations applied
3. ✅ Files accessible
4. ✅ Data verified
5. → Implement frontend validation (see GEOJSON_INTEGRATION_GUIDE.md)
6. → Test with Manipuri → Manipur drill
7. → Test with Hindi → multiple states drill

---

**All set!** Your GeoJSON integration is ready to use.
