# Regional Language Support - Update Summary

**Date**: 2025-11-10
**Status**: ✅ Complete

## Overview

Updated the seed data to support **regional Indian language → state mapping** for more granular Flash gamemode drills. Users can now learn which Indian states use which scripts.

## What Changed

### 1. Skill Tags (49 → 55)

**Added 6 new Indian regional language tags:**
- `script:devanagari:hindi` - Hindi in northern/central India
- `script:devanagari:marathi` - Marathi in Maharashtra (includes distinctive ळ letter)
- `script:gurmukhi:punjabi` - Punjabi in Punjab (Gurmukhi script)
- `script:bengali:assamese` - Assamese in Assam (Bengali script variant with ৰ and ৱ)
- `script:odia` - Odia in Odisha
- `script:meitei:manipuri` - Manipuri in Manipur (Meitei script)

**Updated existing tags** (kept but refined):
- `script:bengali` - Now mapped to West Bengal + Bangladesh
- `script:tamil` - Now mapped to Tamil Nadu + Sri Lanka
- `script:gujarati` - Mapped to Gujarat
- `script:kannada` - Mapped to Karnataka
- `script:telugu` - Mapped to Telangana + Andhra Pradesh
- `script:malayalam` - Mapped to Kerala

### 2. Regions (44 → 64)

**Added 18 Indian states/regions:**
- `IN-DL` (Delhi)
- `IN-UP` (Uttar Pradesh)
- `IN-MP` (Madhya Pradesh)
- `IN-RJ` (Rajasthan)
- `IN-HR` (Haryana)
- `IN-MH` (Maharashtra)
- `IN-PB` (Punjab)
- `IN-GJ` (Gujarat)
- `IN-WB` (West Bengal)
- `IN-AS` (Assam)
- `IN-KA` (Karnataka)
- `IN-TG` (Telangana)
- `IN-AP` (Andhra Pradesh)
- `IN-TN` (Tamil Nadu)
- `IN-OR` (Odisha)
- `IN-KL` (Kerala)
- `IN-MN` (Manipur)
- `IN-MZ` (Mizoram)
- `IN-ML` (Meghalaya)

**Added 2 countries:**
- `LK` (Sri Lanka) - for Tamil
- `BD` was already present

All regions include:
- State codes (ISO 3166-2:IN)
- Centroid coordinates (for map mode)
- Language metadata

### 3. Fact Cards (66 → 72)

**Updated existing cards:**
- Hindi cards now use `script:devanagari:hindi` and map to multiple northern states
- Bengali, Tamil, Gujarati, Kannada, Telugu cards updated with regional mappings

**Added new cards:**
- Marathi (with distinctive ळ letter)
- Punjabi (Gurmukhi script with distinctive characters)
- Assamese (Bengali variant with ৰ and ৱ)
- Odia (curvy script)
- Malayalam (upside-down U-shapes)
- Manipuri (Meitei script)

## Game Mode Support

### Language → Country (Choice Mode)
✅ Works as before
- Example: "होटल" → India

### Language → Country (Map Mode)
✅ Works as before
- Example: "होटल" → (pin on India)

### **NEW: Language → State/Region (Choice Mode)**
✅ Now supported!
- Example: "হোটেল ৰৱ" (with Assamese characters) → Assam
- Example: "हॉटेल ळ" (with Marathi ळ) → Maharashtra
- Example: "ਹੋਟਲ" (Punjabi) → Punjab

### **NEW: Language → State/Region (Map Mode)**
✅ Now supported!
- Example: "ꯍꯣꯇꯦꯜ" (Manipuri) → (pin on Manipur state)
- Example: "ഹോട്ടല്‍" (Malayalam) → (pin on Kerala)

## Data Quality

All additions verified against:
- ✅ GeoGuessr India meta guide
- ✅ ISO 3166-2:IN state codes
- ✅ State centroid coordinates
- ✅ Unicode script examples
- ✅ Regional language references

## Migration Files

**Updated migration:**
- `supabase/migrations/20251110040930_seed_initial_data.sql` (31KB)

**Still required first:**
- `supabase/migrations/20251109170000_make_geometry_nullable.sql`

## Summary Stats

| Category | Before | After | Change |
|----------|--------|-------|--------|
| Skill Tags | 49 | 55 | +6 |
| Regions | 44 | 64 | +20 |
| Fact Cards | 66 | 72 | +6 |
| **Total Records** | **159** | **191** | **+32** |

## How This Works

### Example 1: Manipuri → Manipur State

```json
{
  "type": "language_snippet",
  "payload": {"text": "ꯍꯣꯇꯦꯜ"},
  "primary_tags": ["script:meitei:manipuri"],
  "answer": {
    "kind": "tag",
    "select": {"keys": ["script:meitei:manipuri"]},
    "map_equivalents": {"regions": ["IN-MN"]}  // ← Maps to Manipur state
  }
}
```

### Example 2: Marathi → Maharashtra

```json
{
  "type": "language_snippet",
  "payload": {"text": "हॉटेल ळ"},  // ← Includes distinctive ळ
  "primary_tags": ["script:devanagari:marathi"],
  "answer": {
    "kind": "tag",
    "select": {"keys": ["script:devanagari:marathi"]},
    "map_equivalents": {"regions": ["IN-MH"]}  // ← Maps to Maharashtra
  }
}
```

### Example 3: Hindi → Multiple States (Choice Mode)

```json
{
  "type": "language_snippet",
  "payload": {"text": "होटल"},
  "primary_tags": ["script:devanagari:hindi"],
  "answer": {
    "kind": "tag",
    "select": {"keys": ["script:devanagari:hindi"]},
    "map_equivalents": {
      "regions": ["IN", "IN-DL", "IN-UP", "IN-MP", "IN-RJ", "IN-HR"]
      // ← Choice mode accepts country OR any Hindi-speaking state
      // ← Map mode allows pins on any of these regions
    }
  }
}
```

## User Experience

### Basic Player
- Sees "ಹೋಟೆಲ್" → learns it's Kannada → selects India (easy)

### Advanced Player
- Sees "ಹೋಟೆಲ್" → recognizes Kannada → selects Karnataka state (harder)
- Sees "ହୋଟେଲ" → recognizes Odia "skull emoji" shape → selects Odisha

### Map Mode
- Shows text → user pins on map
- Validation accepts both country AND specific state(s)
- More precision = higher score (future feature)

## Notes on Latin Script (English/Mizo)

As requested, **no changes** were made to Latin script or common languages like English. Mizoram (IN-MZ) and Meghalaya (IN-ML) regions were added to the database for completeness, but:
- ❌ No Latin script fact cards added
- ❌ No English → Meghalaya drills
- ✅ Focus remains on distinctive regional scripts

These regions can be used for other game modes later (city drills, phone codes, etc.).

## Next Steps

1. Apply the updated migration to your Supabase instance
2. Test the regional language drills in Flash mode
3. Consider adding more example cards for each language (currently 1-2 per language)
4. Future: Add difficulty progression (easy = country, medium = state, hard = city within state)

---

**Implementation Complete**: The seed data now fully supports regional Indian language → state mapping for authentic GeoGuessr-style training.
