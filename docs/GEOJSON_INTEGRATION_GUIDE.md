# GeoJSON Integration Guide

**Date**: 2025-11-10
**Status**: Ready for implementation

## Overview

This guide explains how to integrate GeoJSON files for map-based validation in Geolet Flash gamemode.

## File Structure

```
Geolet/
├── public/
│   └── geojson/
│       ├── countries.json              # 600KB - All country borders
│       └── regions/
│           └── IN.json                 # Indian states with boundaries
│
├── supabase/
│   ├── seed/
│   │   └── geojson_mappings.json      # Mapping between DB keys and GeoJSON IDs
│   └── migrations/
│       └── 20251110041500_add_geojson_references.sql
```

## GeoJSON File Formats

### Countries (countries.json)

**Your current format:**
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "iso_a2": "IN",         // ← We match against this
        "name": "India",
        "iso_a3": "IND"
        // ... other properties
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [[...]]
      }
    }
  ]
}
```

**Database mapping:**
- `regions.key` = "IN"
- `regions.geojson_file` = "/geojson/countries.json"
- `regions.geojson_id_property` = "iso_a2"
- `regions.geojson_feature_id` = "IN"

**Frontend lookup:**
```typescript
// Load countries.json
const geojson = await fetch('/geojson/countries.json').then(r => r.json());

// Find India feature
const indiaFeature = geojson.features.find(
  f => f.properties.iso_a2 === 'IN'
);

// Validate user pin is inside India polygon
const isInside = turf.booleanPointInPolygon(userPin, indiaFeature.geometry);
```

### Indian States (regions/IN.json)

**Your current format:**
```json
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {
        "NAME_1": "Maharashtra",    // ← We match against this
        "ID_1": 20,
        "ISO": "IND"
      },
      "geometry": {
        "type": "MultiPolygon",
        "coordinates": [[[[...]]]]
      }
    }
  ]
}
```

**Database mapping:**
- `regions.key` = "IN-MH"
- `regions.geojson_file` = "/geojson/regions/IN.json"
- `regions.geojson_id_property` = "NAME_1"
- `regions.geojson_feature_id` = "Maharashtra"

**Frontend lookup:**
```typescript
// Load regions/IN.json
const geojson = await fetch('/geojson/regions/IN.json').then(r => r.json());

// Find Maharashtra feature
const maharashtraFeature = geojson.features.find(
  f => f.properties.NAME_1 === 'Maharashtra'
);

// Validate user pin is inside Maharashtra polygon
const isInside = turf.booleanPointInPolygon(userPin, maharashtraFeature.geometry);
```

## Database Schema

After migration, `regions` table has these columns:

| Column | Type | Description | Example |
|--------|------|-------------|---------|
| `key` | text | Our internal key | "IN", "IN-MH" |
| `geojson_file` | text | Path to GeoJSON file | "/geojson/countries.json" |
| `geojson_id_property` | text | Property name to match | "iso_a2", "NAME_1" |
| `geojson_feature_id` | text | Value to match | "IN", "Maharashtra" |
| `centroid_lonlat` | float[] | Center point for cities | [77.2090, 28.6139] |

## How Frontend Uses This

### Step 1: User Answers Question

```typescript
// User sees Marathi text: "हॉटेल ळ"
// Answer says: map to "IN-MH" (Maharashtra)

// Query region data
const region = await supabase
  .from('regions')
  .select('*')
  .eq('key', 'IN-MH')
  .single();

// Result:
// {
//   key: "IN-MH",
//   geojson_file: "/geojson/regions/IN.json",
//   geojson_id_property: "NAME_1",
//   geojson_feature_id: "Maharashtra",
//   centroid_lonlat: [75.7139, 19.7515]
// }
```

### Step 2: Load GeoJSON File (with caching)

```typescript
// Simple cache
const geojsonCache = new Map();

async function loadGeoJSON(filePath: string) {
  if (!geojsonCache.has(filePath)) {
    const data = await fetch(filePath).then(r => r.json());
    geojsonCache.set(filePath, data);
  }
  return geojsonCache.get(filePath);
}

// Load the file
const geojson = await loadGeoJSON('/geojson/regions/IN.json');
```

### Step 3: Find Feature

```typescript
function findFeature(geojson, idProperty, featureId) {
  return geojson.features.find(
    f => f.properties[idProperty] === featureId
  );
}

const feature = findFeature(
  geojson,
  'NAME_1',      // from region.geojson_id_property
  'Maharashtra'  // from region.geojson_feature_id
);
```

### Step 4: Validate User Pin

```typescript
import * as turf from '@turf/turf';

function validatePin(userLngLat: [number, number], feature) {
  const point = turf.point(userLngLat);
  return turf.booleanPointInPolygon(point, feature.geometry);
}

const userPin = [75.8, 19.5]; // User clicked here
const isCorrect = validatePin(userPin, feature);
```

## Complete Frontend Flow

```typescript
// src/lib/map-validation.ts

import * as turf from '@turf/turf';
import { supabase } from './supabase';

const geojsonCache = new Map<string, any>();

export async function validateMapAnswer(
  regionKey: string,
  userLngLat: [number, number]
): Promise<{ correct: boolean; distance?: number }> {

  // 1. Get region metadata
  const { data: region } = await supabase
    .from('regions')
    .select('*')
    .eq('key', regionKey)
    .single();

  if (!region) {
    throw new Error(`Region ${regionKey} not found`);
  }

  // 2. Handle cities (no GeoJSON, use distance from centroid)
  if (!region.geojson_file && region.centroid_lonlat) {
    const distance = turf.distance(
      turf.point(userLngLat),
      turf.point(region.centroid_lonlat),
      { units: 'kilometers' }
    );

    // Cities: accept within 50km
    const tolerance = 50;
    return {
      correct: distance <= tolerance,
      distance
    };
  }

  // 3. Handle countries/states (use GeoJSON polygons)
  if (!geojsonCache.has(region.geojson_file)) {
    const data = await fetch(region.geojson_file).then(r => r.json());
    geojsonCache.set(region.geojson_file, data);
  }

  const geojson = geojsonCache.get(region.geojson_file);

  // 4. Find the specific feature
  const feature = geojson.features.find(
    f => f.properties[region.geojson_id_property] === region.geojson_feature_id
  );

  if (!feature) {
    console.error(`Feature not found: ${region.geojson_feature_id}`);
    return { correct: false };
  }

  // 5. Validate point-in-polygon
  const point = turf.point(userLngLat);
  const correct = turf.booleanPointInPolygon(point, feature.geometry);

  return { correct };
}
```

## Migration Order

Apply migrations in this order:

1. `20251109170000_make_geometry_nullable.sql` - Makes geometry columns nullable
2. `20251110041500_add_geojson_references.sql` - Adds GeoJSON reference columns
3. `20251110040930_seed_initial_data.sql` - Loads all seed data

## File Placement

### Where to put GeoJSON files:

```bash
# Create directories
mkdir -p public/geojson/regions

# Place your files
# public/geojson/countries.json      ← Your 600KB file
# public/geojson/regions/IN.json     ← Your Indian states file
```

### Verify file accessibility

After placing files, test:
```bash
# Start dev server
npm run dev

# Test in browser console:
fetch('/geojson/countries.json')
  .then(r => r.json())
  .then(d => console.log('Countries:', d.features.length));

fetch('/geojson/regions/IN.json')
  .then(r => r.json())
  .then(d => console.log('Indian states:', d.features.length));
```

## Performance Optimization

### Caching Strategy

**Countries (600KB):**
- Loaded once on first map drill
- Cached in memory
- Reused for all country-level drills

**Indian states (~500KB):**
- Loaded when first Indian state drill appears
- Cached in memory
- Reused for all Indian state drills

**Other countries:**
- Add as needed: `public/geojson/regions/US.json`, `TW.json`, etc.
- Only load when user encounters drills from that country

### Expected Load Times

| File | Size | 3G | 4G | WiFi | Cached |
|------|------|----|----|------|--------|
| countries.json | 600KB | ~1.5s | ~600ms | ~100ms | instant |
| regions/IN.json | 500KB | ~1.2s | ~500ms | ~80ms | instant |

### Code Splitting

```typescript
// Only import Turf.js when needed
const loadMapValidation = async () => {
  const turf = await import('@turf/turf');
  const { validateMapAnswer } = await import('@/lib/map-validation');
  return { turf, validateMapAnswer };
};
```

## Multi-Region Answers

Some fact cards allow multiple correct regions:

```json
{
  "answer": {
    "map_equivalents": {
      "regions": ["IN", "IN-DL", "IN-UP", "IN-MP", "IN-RJ", "IN-HR"]
    }
  }
}
```

**Validation approach:**

```typescript
// Check if user pin is in ANY of the accepted regions
async function validateMultiRegion(
  regionKeys: string[],
  userLngLat: [number, number]
): Promise<boolean> {
  for (const key of regionKeys) {
    const result = await validateMapAnswer(key, userLngLat);
    if (result.correct) return true;
  }
  return false;
}
```

## Fallback Strategy

If GeoJSON fails to load:

```typescript
async function validateMapAnswer(regionKey, userLngLat) {
  try {
    // Try GeoJSON validation first
    return await validateWithGeoJSON(regionKey, userLngLat);
  } catch (error) {
    console.error('GeoJSON validation failed:', error);

    // Fallback to centroid + tolerance
    const { data: region } = await supabase
      .from('regions')
      .select('centroid_lonlat')
      .eq('key', regionKey)
      .single();

    if (region?.centroid_lonlat) {
      const distance = turf.distance(
        turf.point(userLngLat),
        turf.point(region.centroid_lonlat)
      );

      // Countries: 500km tolerance, States: 200km
      const tolerance = regionKey.includes('-') ? 200 : 500;
      return { correct: distance <= tolerance };
    }

    return { correct: false };
  }
}
```

## Testing Checklist

- [ ] `countries.json` placed in `public/geojson/`
- [ ] `IN.json` placed in `public/geojson/regions/`
- [ ] Files accessible via browser (fetch test)
- [ ] Migration `20251110041500_add_geojson_references.sql` applied
- [ ] Seed data migration `20251110040930_seed_initial_data.sql` applied
- [ ] Query test: `SELECT * FROM regions WHERE geojson_file IS NOT NULL`
- [ ] Frontend can load and parse GeoJSON files
- [ ] Point-in-polygon validation works for countries
- [ ] Point-in-polygon validation works for Indian states
- [ ] City validation works with centroid + tolerance
- [ ] GeoJSON caching prevents duplicate loads

## Next Steps

1. **Place GeoJSON files** in `public/geojson/`
2. **Run migrations** (in order)
3. **Implement frontend validation** using code examples above
4. **Test with Manipuri → Manipur** drill
5. **Test with Hindi → multiple states** (should accept any)
6. **Add more regional GeoJSON files** as needed (US, TW, etc.)

## Future Enhancements

### Precision Scoring
```typescript
// Award points based on accuracy
const distance = turf.distance(userPin, turf.centroid(feature));
const score = Math.max(0, 1000 - distance * 10);
```

### Visual Feedback
```typescript
// Highlight the correct region after answer
map.addLayer({
  id: 'correct-region',
  type: 'fill',
  source: {
    type: 'geojson',
    data: feature
  },
  paint: {
    'fill-color': '#00ff00',
    'fill-opacity': 0.3
  }
});
```

### Progressive Disclosure
- Show country outline first
- Zoom to state after selection
- Highlight correct state with animation

---

**Ready for implementation!** All GeoJSON mappings are in place. Just place your files and run the migrations.
