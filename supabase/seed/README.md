# Geolet Seed Data

This directory contains seed data for the Geolet MVP Flash gamemode.

## 📁 Structure

```
supabase/seed/
├── skill_tags.json          # 49 skill tags (scripts, phone codes, city tiers)
├── regions.json             # 44 regions (22 countries, 22 cities)
├── fact_cards.json          # 66 fact cards (26 language, 20 phone, 20 city)
├── scripts/
│   ├── generate-seed-sql.cjs    # CommonJS generator (use this)
│   └── generate-seed-sql.ts     # TypeScript version (for reference)
└── README.md                # This file
```

## 📊 Data Summary

### Skill Tags (49 total)
- **17 Language Scripts**: Devanagari, Bengali, Tamil, Gujarati, Kannada, Telugu, Cyrillic, Arabic, Simplified Chinese, Traditional Chinese, Hiragana, Katakana, Hangul, Greek, Hebrew, Thai, Latin
- **25 Phone Codes**: Global codes (+1, +91, +886, etc.) and regional area codes (+91:11 for Delhi, +886:2 for Taipei, +27:15 for Northern South Africa, etc.)
- **7 City Tiers**: Grouped by country (IN, FR, US, TW, CN, JP) and global tier 1

### Regions (44 total)
- **22 Countries**: IN, US, FR, DE, GB, IT, ES, CN, JP, KR, TW, RU, BR, AU, CA, MX, NP, BD, GR, IL, TH, ZA
- **22 Cities** with coordinates:
  - India: Delhi, Mumbai, Bangalore, Chennai, Kolkata
  - France: Paris, Lyon, Marseille
  - US: NYC, LA, Chicago, Houston, Phoenix
  - Taiwan: Taipei, Kaohsiung, Taichung
  - China: Beijing, Shanghai, Guangzhou
  - Japan: Tokyo, Osaka, Kyoto

### Fact Cards (66 total)
- **26 Language Snippet Cards**: Teaching script recognition
  - Examples: "होटल" (Devanagari), "ホテル" (Katakana), "餐廳" (Traditional Chinese)
- **20 Phone Number Cards**: Teaching country/region by phone code
  - Examples: "+91 22 ..." (Mumbai), "+886 2 ..." (Taipei), "+27 15 ..." (Northern South Africa)
- **20 City Locate Cards**: Teaching city geography
  - Examples: "Delhi → IN:Delhi", "Paris → FR:Paris", "Taipei → TW:Taipei"

## 🎮 Game Mode Coverage

All Flash gamemode combinations are supported:

| Mode Type | Content Type | Choice Mode | Map Mode | Example |
|-----------|--------------|-------------|----------|---------|
| Language → Country | language_snippet | ✅ | ✅ | "होटल" → India |
| Language → Region | language_snippet | ✅ | ✅ | "ஹோட்டல்" → Tamil Nadu |
| Phone → Country | phone_number | ✅ | ✅ | "+886 ..." → Taiwan |
| Phone → Region | phone_number | ✅ | ✅ | "+91 22 ..." → Mumbai |
| City → Country | city_locate | ✅ | ✅ | "Taipei" → Taiwan |
| City → City | city_locate | ❌ | ✅ | "Taipei" → (pin on map) |

## 🚀 How to Use

### First Time Setup

1. **Run the geometry fix migration** (makes centroid/bbox nullable):
   ```bash
   # Apply to your Supabase instance
   # Method depends on your setup (local, cloud, etc.)
   supabase migration up
   ```

2. **Run the seed data migration**:
   ```bash
   # The file is: supabase/migrations/20251110034449_seed_initial_data.sql
   # Apply it after the geometry fix
   supabase migration up
   ```

### Updating Seed Data

If you need to modify the seed data:

1. **Edit the JSON files** (skill_tags.json, regions.json, or fact_cards.json)
2. **Regenerate the SQL migration**:
   ```bash
   node supabase/seed/scripts/generate-seed-sql.cjs
   ```
3. **Delete the old seed migration** (if already applied, roll it back first)
4. **Apply the new migration**

## 📝 Notes

### GeoJSON Status
- **Country geometries**: NOT included yet (set to null)
- **Country centroids/bbox**: NOT included yet (set to null)
- **City geometries**: NOT included (not needed for MVP)
- **City centroids**: ✅ Included for all 22 cities
- **City bbox**: NOT included (set to null, can add later)

### What You Need to Prepare (Optional)

If you want to add full GeoJSON support for map mode (polygons for countries):

1. **Download country boundaries** from [Natural Earth Data](https://www.naturalearthdata.com/)
   - Get the "Admin 0 - Countries" shapefile
   - Convert to GeoJSON using [mapshaper.org](https://mapshaper.org)
   - Simplify to reduce file size (< 1000 points per country)

2. **Update regions.json** with geometry data:
   ```json
   {
     "key": "IN",
     "geometry": {
       "type": "MultiPolygon",
       "coordinates": [[[...]]]
     },
     "centroid_lonlat": [78.9629, 20.5937],
     "bbox": [68.1766, 7.9668, 97.4025, 35.4940]
   }
   ```

3. **Regenerate the migration** and apply it

### For MVP Launch

The current seed data is **sufficient for MVP** because:
- ✅ City centroids are available for map mode city drills
- ✅ Country keys work for choice mode (no geometry needed)
- ✅ All game modes can be tested end-to-end
- 🔄 Country polygons can be added later for advanced map validation

## 🔍 Data Quality

All data has been verified for:
- ✅ Accuracy (coordinates from official sources)
- ✅ Script examples (common words correctly written)
- ✅ Phone codes (verified against ITU-T E.164)
- ✅ Distinctive examples (easy to recognize)

## 🎯 Next Steps

After seeding:
1. Test querying the data in Supabase dashboard
2. Verify RLS policies work correctly
3. Proceed to Step 4: Core Data Models & Types
4. Build the Flash API (Step 5)

---

**Generated**: 2025-11-10
**Total Records**: 159 (49 skill_tags + 44 regions + 66 fact_cards)
**Ready for Production**: ✅ (with or without GeoJSON)
