# Seed Data Structure Reference

Quick reference for understanding the seed data format.

## Skill Tags Structure

```json
{
  "key": "script:devanagari",      // Unique identifier
  "family": "script",               // Type: script | phone | city
  "country": "IN",                  // ISO country code (null for multi-country)
  "meta": {
    "display": "Devanagari",        // Human-readable name
    "notes": "Used for Hindi...",   // Description
    "examples": ["होटल", "रेस्तरां"] // Visual examples
  }
}
```

### Key Patterns
- Scripts: `script:devanagari`, `script:cyrillic`, `script:chinese:traditional`
- Phone codes: `phone:+886`, `phone:+91:22` (country + optional area code)
- Cities: `city:IN:tier1`, `city:global:tier1`

## Regions Structure

```json
{
  "key": "IN:Delhi",                    // Unique identifier (country:city or country code)
  "kind": "city",                       // Type: country | region | city
  "name": "Delhi",                      // Display name
  "country": "IN",                      // Parent country (null for countries)
  "geometry": null,                     // GeoJSON (optional, null for MVP)
  "centroid_lonlat": [77.2090, 28.6139], // [lon, lat] for city center
  "bbox": null,                         // [minLon, minLat, maxLon, maxLat] (optional)
  "meta": {
    "tier": 1,                          // City tier
    "population": 32900000              // Additional info
  }
}
```

### Key Patterns
- Countries: `IN`, `US`, `TW`, `FR` (ISO 3166-1 alpha-2)
- Cities: `IN:Delhi`, `US:NewYork`, `TW:Taipei`
- Regions: `IN-DL` (if needed later, ISO 3166-2)

## Fact Cards Structure

### Language Snippet Card
```json
{
  "type": "language_snippet",
  "payload": {
    "text": "होटल",                      // Text in native script
    "romanization": "hotel"            // Pronunciation guide
  },
  "primary_tags": ["script:devanagari"], // Associated skills
  "difficulty": 1,                     // 1 (easy) to 3 (hard)
  "answer": {
    "kind": "tag",                     // Answer type: tag | region
    "select": {
      "by": "skill_key",               // Selection method
      "keys": ["script:devanagari"]    // Correct answer(s)
    },
    "map_equivalents": {
      "regions": ["IN", "NP"]          // For map mode: valid regions
    }
  }
}
```

### Phone Number Card
```json
{
  "type": "phone_number",
  "payload": {
    "number": "+91 22 2345 6789",      // Full phone number
    "masked": "+91 22..."              // Display version (partial)
  },
  "primary_tags": ["phone:+91", "phone:+91:22"], // Country + area code
  "difficulty": 2,
  "answer": {
    "kind": "region",                  // Answer is a region
    "select": {
      "by": "key",                     // Select by region key
      "keys": ["IN:Mumbai"]            // Correct region(s)
    }
  }
}
```

### City Locate Card
```json
{
  "type": "city_locate",
  "payload": {
    "city": "Taipei",                  // City name
    "country_hint": "TW"               // Optional country hint
  },
  "primary_tags": ["city:TW:tier1", "city:global:tier1"],
  "difficulty": 1,
  "answer": {
    "kind": "region",
    "select": {
      "by": "key",
      "keys": ["TW:Taipei"]            // City region key
    }
  }
}
```

## Answer Contract Types

### Type 1: Tag-based Answer (Choice Mode)
Used when answer is a skill tag (e.g., "Which script?")

```json
{
  "kind": "tag",
  "select": {
    "by": "skill_key",
    "keys": ["script:devanagari"]
  },
  "map_equivalents": {
    "regions": ["IN", "NP"]            // For map mode fallback
  }
}
```

### Type 2: Region-based Answer (Map/Choice Mode)
Used when answer is a location (e.g., "Which country?", "Where is this city?")

```json
{
  "kind": "region",
  "select": {
    "by": "key",
    "keys": ["TW:Taipei"]              // Can be country or city
  }
}
```

## Usage in Game Logic

### Choice Mode Flow
1. Frontend requests cards filtered by `primary_tags`
2. Backend generates distractors based on `answer.kind`:
   - If `kind: "tag"` → select other tags from same family
   - If `kind: "region"` → select other regions of same kind
3. Frontend shuffles and displays options
4. User selects answer
5. Backend validates against `answer.select.keys`

### Map Mode Flow
1. Frontend requests cards with map answers
2. For `kind: "tag"` → use `map_equivalents.regions`
3. For `kind: "region"` → use `answer.select.keys` directly
4. Frontend loads region data from `regions` table
5. User pins location on map
6. Backend validates using Turf.js (point-in-polygon or distance)

## Example Queries

### Get all Devanagari cards
```sql
SELECT * FROM fact_cards
WHERE 'script:devanagari' = ANY(primary_tags);
```

### Get cards for choice mode (difficulty 1)
```sql
SELECT fc.*, st.meta->>'display' as skill_name
FROM fact_cards fc
JOIN skill_tags st ON st.key = ANY(fc.primary_tags)
WHERE fc.difficulty = 1
ORDER BY RANDOM()
LIMIT 15;
```

### Get regions for map mode
```sql
SELECT r.*
FROM fact_cards fc
CROSS JOIN LATERAL jsonb_array_elements_text(
  CASE
    WHEN fc.answer->>'kind' = 'region'
    THEN fc.answer->'select'->'keys'
    ELSE fc.answer->'map_equivalents'->'regions'
  END
) AS region_key
JOIN regions r ON r.key = region_key::text
WHERE fc.id = 'some-uuid';
```

## Difficulty Levels

- **1 (Easy)**: Major countries, common scripts, well-known cities
- **2 (Medium)**: Regional phone codes, less common cities, similar scripts
- **3 (Hard)**: Rare scripts, small cities, confusing regions (not in MVP seed)

## Extensibility

### Adding New Languages
1. Add skill tag: `script:punjabi`
2. Add fact cards with examples in Punjabi
3. Update `map_equivalents` to include `["IN", "PK"]`
4. Regenerate migration

### Adding New Regions
1. Add country/city to `regions.json`
2. Add `centroid_lonlat` from Google Maps
3. Reference in fact cards
4. Regenerate migration

### Adding New Game Modes
The structure supports any mode via `type` field:
- `domain_suffix` (e.g., ".tw" → Taiwan)
- `license_plate` (e.g., "D-12345" → Germany)
- `landmark` (e.g., "Eiffel Tower" → Paris)

Just add new fact cards with appropriate `answer` contracts.

---

**Last Updated**: 2025-11-10
**Schema Version**: Based on `20251109161427_add_geolet_schema.sql`
