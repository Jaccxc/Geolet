# Rapid Mode System - Technical Documentation

**Last Updated**: 2025-11-13
**System Version**: v2.0 (Post-Migration)

---

## Overview

The Rapid Mode system is Geolet's core learning engine that delivers geography fact cards to users through two distinct game modes: **Pick Mode** (multiple choice) and **Map Mode** (pin on map). The system integrates a Spaced Repetition System (SRS) for optimized learning and tracks user progress across multiple skill domains.

---

## Architecture

### Data Model Hierarchy

```
Topic
  ├─ target_card_group_ids: uuid[]
  ├─ use_country_region: boolean
  └─ pick_mode_active / map_mode_active: boolean

CardGroup
  └─ id: uuid

FactCard
  ├─ card_group_id: uuid (FK → CardGroup)
  ├─ prompt: text
  ├─ hint: text
  ├─ primary_skill_tags: text[]
  ├─ difficulty: '1' | '2' | '3'
  └─ answer_region_id: uuid (FK → Region)

Region
  ├─ id: uuid
  ├─ key: text (hierarchical: "GB", "IN:Maharashtra", "GB:London")
  ├─ level: 'country' | 'province' | 'city'
  ├─ name: text
  ├─ country: text (ISO code for non-country regions)
  ├─ location_type: 'pin' | 'polygon'
  ├─ centroid_lonlat: [lng, lat]
  └─ geometry: GeoJSON
```

### Region Hierarchy

Regions are organized hierarchically using a **key format**:

| Level | Key Format | Example | Country Field |
|-------|-----------|---------|---------------|
| Country | `{ISO2}` | `"GB"` | `null` |
| Province | `{ISO2}:{Name}` | `"IN:Maharashtra"` | `"IN"` |
| City | `{ISO2}:{Province}:{Name}` | `"GB:England:London"` | `"GB"` |

**Key Properties:**
- Unique identifier for each region
- Hierarchical structure enables parent lookups
- Used for answer validation and region relationships

---

## Game Modes

### Pick Mode (Multiple Choice)

**Flow:**
1. User requests queue: `POST /api/rapid/queue { mode: 'pick', topicKey: 'cities' }`
2. System builds card queue via SRS
3. For each card, generates 6 options (1 correct + 5 distractors)
4. Returns `PickQueueItem[]` with shuffled options

**Option Generation Logic:**

```typescript
// Standard behavior (use_country_region = false)
Card: { prompt: "नमस्ते", answer_region_id: "IN:Uttar_Pradesh" }
Options: ["Uttar Pradesh", "Maharashtra", "Tamil Nadu", ...] // Same level

// Country region mode (use_country_region = true)
Card: { prompt: "London", answer_region_id: "GB:England:London" }
Options: ["United Kingdom", "France", "Germany", ...] // Countries instead!
```

**Critical Feature: `use_country_region`**

When `topic.use_country_region = true`:
1. Fetch the answer region (e.g., "GB:England:London")
2. Extract `region.country` field → `"GB"`
3. Fetch country region where `key = "GB"`
4. Use country name for display options
5. **BUT** keep city `region_id` for grading validation

This solves the city card problem where the prompt would reveal the answer.

### Map Mode (Pin on Map)

**Flow:**
1. User requests queue: `POST /api/rapid/queue { mode: 'map', topicKey: 'cities' }`
2. System returns `MapQueueItem[]` with full answer region data
3. User clicks on map → `[lng, lat]` coordinates
4. System validates using:
   - **Polygon regions**: Point-in-polygon check (Turf.js)
   - **Pin regions**: Distance from centroid with tolerance

**Note:** Map mode is **not affected** by `use_country_region`. Always validates against the answer region directly.

---

## Topics System

### Topic Configuration

```typescript
Topic {
  key: string                    // Unique identifier (e.g., "watg24-cities")
  title: string                  // Display name
  description: string            // User-facing description
  icon: string                   // Lucide icon name
  pick_mode_active: boolean      // Enable pick mode for this topic
  map_mode_active: boolean       // Enable map mode for this topic
  difficulty: 'beginner' | 'intermediate' | 'advanced'
  target_card_group_ids: uuid[]  // Which card groups to include
  use_country_region: boolean    // Pick mode shows countries instead of answer regions
}
```

### When to Use `use_country_region`

**Enable when:**
- Cards have city or province level answer regions
- Prompt contains the location name itself
- Example: City name cards, province capital cards

**Keep disabled when:**
- Prompt differs from answer (scripts, phone codes, flags)
- Answer regions are already countries
- Example: Language script cards, country flag cards

**Examples:**

| Topic | Prompt Example | Answer Region | use_country_region | Options Display |
|-------|---------------|---------------|-------------------|-----------------|
| WATG24 Cities | "London" | GB:England:London | `true` | Countries |
| Indian Scripts | "नमस्ते" | IN:Uttar_Pradesh | `false` | Provinces |
| Country Flags | 🇫🇷 | FR | `false` | Countries |

---

## Card Groups

Card groups organize related fact cards into collections.

```typescript
CardGroup {
  id: uuid
  name: string
}
```

**Purpose:**
- Logical grouping of cards (e.g., "WATG24 - European Cities", "Indian Languages - Long Form")
- Topics reference multiple card groups via `target_card_group_ids`
- Allows reusing cards across different topics

**Examples:**
- `"Indian Languages - Long Form"` → 156 cards (2-3 sentence passages)
- `"Indian Languages - Short Form"` → 156 cards (single vocabulary words)

---

## Fact Cards

### Schema

```typescript
FactCard {
  id: uuid
  card_group_id: uuid              // FK → CardGroup
  prompt: text                     // What user sees (city name, script text, etc.)
  hint: text | null                // Optional hint (romanization, translation)
  primary_skill_tags: text[]       // ['script:tamil', 'script:bengali']
  difficulty: '1' | '2' | '3'      // Card difficulty
  answer_region_id: uuid           // FK → Region (THE answer)
}
```

### Card Types

**1. Script Cards**
```
Prompt: "நகரம்" (Tamil script)
Hint: "nakaram (city)"
Answer: IN:Tamil_Nadu
```

**2. City Cards**
```
Prompt: "London"
Hint: "Capital of the United Kingdom"
Answer: GB:England:London
```

**3. Phone Code Cards**
```
Prompt: "+91"
Hint: "Country calling code"
Answer: IN
```

---

## Skill Tags

Skill tags categorize cards by learning domain and enable focused practice.

```typescript
SkillTag {
  key: string                      // Unique ID (e.g., "script:tamil")
  family: 'script' | 'phone' | 'city'
  country: string | null           // ISO2 code
  display: string                  // User-facing name
  note: string                     // Learning hints
  examples: string[]               // Example words/patterns
}
```

**Example: Mizo Language**
```typescript
{
  key: "script:mizo",
  family: "script",
  country: "IN",
  display: "Mizo",
  note: "Uses Latin alphabet with Tibeto-Burman vocabulary. Look for particles: 'chuan' (then), 'chu' (that), 'tak' (very), 'ang' (will), 'thin' (habitually), 'hle' (very), and word endings -ah, -na, -tu",
  examples: ["chuan", "chu", "tak", "ang", "thin", "hle", "awm", "ni", "kan", "kal"]
}
```

**Usage:**
- Filtering cards by skill family
- Showing progress per skill
- Analytics and insights

---

## API Endpoints

### 1. Queue Generation

**Endpoint:** `POST /api/rapid/queue`

**Request:**
```json
{
  "mode": "pick" | "map",
  "topicKey": "watg24-cities",      // Optional
  "cardGroupIds": ["uuid1", "uuid2"], // Optional
  "maxCards": 20                      // Optional, default 20
}
```

**Response (Pick Mode):**
```json
{
  "mode": "pick",
  "items": [
    {
      "fact_id": "uuid",
      "card_group_id": "uuid",
      "prompt": "London",
      "hint": "Capital of the United Kingdom",
      "difficulty": "2",
      "options": [
        { "region_id": "gb-london-uuid", "label": "United Kingdom", "correct": true },
        { "region_id": "fr-uuid", "label": "France", "correct": false },
        { "region_id": "de-uuid", "label": "Germany", "correct": false },
        { "region_id": "it-uuid", "label": "Italy", "correct": false },
        { "region_id": "es-uuid", "label": "Spain", "correct": false },
        { "region_id": "pl-uuid", "label": "Poland", "correct": false }
      ]
    }
  ],
  "total": 20
}
```

**Response (Map Mode):**
```json
{
  "mode": "map",
  "items": [
    {
      "fact_id": "uuid",
      "card_group_id": "uuid",
      "prompt": "London",
      "hint": "Capital of the United Kingdom",
      "difficulty": "2",
      "answer_region": {
        "id": "uuid",
        "key": "GB:England:London",
        "level": "city",
        "name": "London",
        "country": "GB",
        "location_type": "pin",
        "centroid_lonlat": [-0.1278, 51.5074],
        "geometry": null
      }
    }
  ],
  "total": 20
}
```

### 2. Answer Grading

**Endpoint:** `POST /api/rapid/grade`

**Pick Mode Request:**
```json
{
  "mode": "pick",
  "answers": [
    {
      "fact_id": "uuid",
      "selected_region_id": "gb-london-uuid", // The city ID!
      "time_ms": 3500
    }
  ]
}
```

**Map Mode Request:**
```json
{
  "mode": "map",
  "answers": [
    {
      "fact_id": "uuid",
      "clicked_point": [-0.1278, 51.5074],
      "time_ms": 5000
    }
  ]
}
```

**Response:**
```json
{
  "results": [
    {
      "fact_id": "uuid",
      "correct": true,
      "time_ms": 3500,
      "distance": null,
      "srs": {
        "new_ease": 2.5,
        "due_at": "2025-11-15T10:00:00Z",
        "interval_days": 3
      }
    }
  ],
  "summary": {
    "total": 1,
    "correct": 1,
    "accuracy": 1.0,
    "avg_time_ms": 3500
  }
}
```

---

## Spaced Repetition System (SRS)

### How It Works

The SRS algorithm schedules cards based on user performance:

1. **New Cards**: Shown immediately (due_at = now)
2. **Correct Answers**: Interval increases (1 day → 3 days → 7 days → ...)
3. **Wrong Answers**: Interval resets (back to 1 day)
4. **Ease Factor**: Adjusts based on accuracy (easier if consistently correct)

### Database Tracking

```typescript
user_fact_stats {
  user_id: uuid
  fact_id: uuid
  accuracy: float              // 0.0 to 1.0
  total_seen: int
  ease_factor: float           // SRS multiplier
  interval_days: int           // Days until next review
  last_seen_at: timestamp
  due_at: timestamp            // When to show again
}
```

### Queue Building Strategy

Cards are selected based on:
1. **Due cards** (due_at <= now) - highest priority
2. **Unseen cards** (never shown)
3. **Low accuracy cards** (accuracy < 0.5) - need practice

---

## Pick Mode: Country Region Feature

### Problem Solved

City-level fact cards were unplayable in pick mode because the answer was revealed:

```
❌ BEFORE (Broken)
Question: "London"
Options: [London ✓, Paris, Tokyo, Berlin, Madrid, Sydney]
         ↑ Answer is in the prompt!
```

### Solution: `use_country_region`

When a topic has `use_country_region = true`:

```
✅ AFTER (Fixed)
Question: "London"
Options: [United Kingdom ✓, France, Japan, Germany, Spain, Poland]
         ↑ User must know London is in UK!
```

### Implementation Details

**Step 1: Fetch Answer Region**
```sql
SELECT * FROM regions WHERE id = card.answer_region_id;
-- Result: { key: "GB:England:London", country: "GB", ... }
```

**Step 2: Check Topic Config**
```typescript
if (topic.use_country_region && correctRegion.country) {
  // Extract country code from answer region
  const countryCode = correctRegion.country; // "GB"
}
```

**Step 3: Fetch Country Region**
```sql
SELECT * FROM regions WHERE key = 'GB';
-- Result: { key: "GB", level: "country", name: "United Kingdom", ... }
```

**Step 4: Generate Options**
```typescript
const options = [
  { region_id: correctRegion.id, label: countryRegion.name, correct: true },
  // Distractors are other countries...
];
```

**Step 5: Grading Still Uses City**
```typescript
// User selects "United Kingdom" → region_id is still "GB:England:London"
// Validation checks: selected_region_id === card.answer_region_id
// ✓ Correct!
```

### Critical Separation

| Aspect | Value | Purpose |
|--------|-------|---------|
| **Display** | Country name ("United Kingdom") | What user sees |
| **Validation** | City region_id (GB:England:London UUID) | What we grade against |

This separation allows showing countries while grading against cities.

---

## Database Schema

### Core Tables

**topics**
```sql
CREATE TABLE topics (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  title text NOT NULL,
  description text,
  icon text,
  pick_mode_active boolean NOT NULL DEFAULT true,
  map_mode_active boolean NOT NULL DEFAULT true,
  difficulty difficulty_enum,
  target_card_group_ids uuid[],
  use_country_region boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

**card_groups**
```sql
CREATE TABLE card_groups (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

**fact_cards**
```sql
CREATE TABLE fact_cards (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  card_group_id uuid NOT NULL REFERENCES card_groups(id),
  prompt text NOT NULL,
  hint text,
  primary_skill_tags text[] NOT NULL,
  difficulty fact_difficulty_enum NOT NULL DEFAULT '1',
  answer_region_id uuid NOT NULL REFERENCES regions(id),
  created_at timestamptz NOT NULL DEFAULT now()
);
```

**regions**
```sql
CREATE TABLE regions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  level region_level_enum NOT NULL,
  name text NOT NULL,
  country text,  -- ISO2 code for non-country regions
  location_type location_type_enum NOT NULL,
  centroid_lonlat double precision[],
  geometry jsonb,
  note text,
  created_at timestamptz NOT NULL DEFAULT now()
);
```

**skill_tags**
```sql
CREATE TABLE skill_tags (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  key text UNIQUE NOT NULL,
  family skill_family_enum NOT NULL,
  country text,
  display text NOT NULL,
  note text,
  examples text[],
  created_at timestamptz NOT NULL DEFAULT now()
);
```

**user_fact_stats**
```sql
CREATE TABLE user_fact_stats (
  user_id uuid NOT NULL REFERENCES auth.users(id),
  fact_id uuid NOT NULL REFERENCES fact_cards(id),
  accuracy float NOT NULL DEFAULT 0,
  total_seen int NOT NULL DEFAULT 0,
  ease_factor float NOT NULL DEFAULT 2.5,
  interval_days int NOT NULL DEFAULT 0,
  last_seen_at timestamptz,
  due_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, fact_id)
);
```

### Enums

```sql
CREATE TYPE region_level_enum AS ENUM ('country', 'province', 'city');
CREATE TYPE location_type_enum AS ENUM ('pin', 'polygon');
CREATE TYPE skill_family_enum AS ENUM ('script', 'phone', 'city');
CREATE TYPE difficulty_enum AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TYPE fact_difficulty_enum AS ENUM ('1', '2', '3');
```

---

## Example: Indian Languages Topic

### Setup

**Card Groups:**
```sql
INSERT INTO card_groups (name) VALUES
  ('Indian Languages - Long Form'),
  ('Indian Languages - Short Form');
```

**Topic:**
```sql
INSERT INTO topics (key, title, description, difficulty, use_country_region, target_card_group_ids)
VALUES (
  'indian-languages-long',
  'Indian Languages - Reading',
  'Identify regional scripts from longer text passages (2-3 sentences)',
  'intermediate',
  false,  -- Don't need country regions for script cards
  ARRAY[(SELECT id FROM card_groups WHERE name = 'Indian Languages - Long Form')]
);
```

**Fact Card Example (Hindi):**
```sql
INSERT INTO fact_cards (card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id)
VALUES (
  (SELECT id FROM card_groups WHERE name = 'Indian Languages - Long Form'),
  'मैं आज सुबह बाजार गया था। वहाँ बहुत भीड़ थी। मैंने कुछ फल और सब्जियाँ खरीदीं।',
  'maiṁ āj subah bāzār gayā thā... (I went to the market this morning...)',
  ARRAY['script:devanagari:hindi'],
  '1',
  (SELECT id FROM regions WHERE key = 'IN:Uttar_Pradesh')
);
```

### Pick Mode Behavior

**Request:**
```json
POST /api/rapid/queue
{
  "mode": "pick",
  "topicKey": "indian-languages-long",
  "maxCards": 10
}
```

**Generated Options:**
```
Prompt: "मैं आज सुबह बाजार गया था..."
Options: [
  "Uttar Pradesh" ✓,
  "Maharashtra",
  "Tamil Nadu",
  "Karnataka",
  "West Bengal",
  "Gujarat"
]
```

**Why it works:** Prompt is in Hindi script, options are state names (different content).

---

## Example: City Cards Topic

### Setup

**Topic:**
```sql
UPDATE topics
SET use_country_region = true
WHERE key = 'watg24-cities';
```

**Fact Card Example:**
```sql
INSERT INTO fact_cards (card_group_id, prompt, hint, answer_region_id)
VALUES (
  (SELECT id FROM card_groups WHERE name = 'WATG24 Cities'),
  'London',
  'Capital of the United Kingdom',
  (SELECT id FROM regions WHERE key = 'GB:England:London')
);
```

### Pick Mode Behavior

**Request:**
```json
POST /api/rapid/queue
{
  "mode": "pick",
  "topicKey": "watg24-cities",
  "maxCards": 10
}
```

**Generated Options:**
```
Prompt: "London"
Options: [
  "United Kingdom" ✓,  ← Country, not city!
  "France",
  "Germany",
  "Italy",
  "Spain",
  "Poland"
]
```

**Why it works:** `use_country_region = true` displays countries instead of cities.

---

## File Structure

### API Routes
```
src/app/api/rapid/
├── queue/route.ts           # Generate card queues
└── grade/route.ts           # Grade answers and update SRS
```

### Controllers
```
src/features/rapid/controllers/
├── build-queue.ts           # SRS-based queue builder
├── generate-pick-options.ts # Pick mode option generator
├── generate-map-regions.ts  # Map mode region fetcher
└── answer-validator.ts      # Answer grading logic
```

### Types
```
src/features/rapid/types.ts  # All TypeScript types
```

### Database
```
supabase/migrations/
├── 20251112180204_fresh_schema.sql
└── 20251113000000_add_use_country_region.sql

supabase/seed/
├── 01_regions_countries.sql
├── 02_regions_india_states.sql
├── 04_indian_languages_setup.sql
├── 05_indian_languages_long_cards.sql
└── 06_indian_languages_short_cards.sql
```

---

## Testing Scenarios

### 1. Script Cards (Standard Behavior)
```
Topic: indian-languages-long
use_country_region: false

Card:
  prompt: "நகரம்" (Tamil)
  answer: IN:Tamil_Nadu

Expected Options: Tamil Nadu, Karnataka, Kerala, Andhra Pradesh, ...
```

### 2. City Cards (Country Region Mode)
```
Topic: watg24-cities
use_country_region: true

Card:
  prompt: "London"
  answer: GB:England:London

Expected Options: United Kingdom, France, Germany, Italy, ...
```

### 3. Grading Validation
```
User Action:
  Selects "United Kingdom" option

Backend:
  selected_region_id = GB:England:London (city UUID, not country!)
  answer_region_id = GB:England:London

Result: ✓ Correct
```

---

## Performance Considerations

### Query Optimization

**Pick Mode with Country Regions:**
- +1 query per card (fetch country region)
- Total: ~30-40ms per card
- Acceptable for 20-card queues

**Indexes:**
```sql
CREATE INDEX regions_key_idx ON regions(key);
CREATE INDEX regions_level_idx ON regions(level);
CREATE INDEX regions_country_idx ON regions(country);
CREATE INDEX topics_use_country_region_idx ON topics(use_country_region) WHERE use_country_region = true;
```

### Caching Strategy

- Country regions rarely change → cache lookup results
- Topic configs rarely change → cache topic data
- Card queues expire after session → no cache needed

---

## Best Practices

### When Creating Topics

1. **Set `use_country_region = true`** for:
   - City name cards
   - Province/state name cards
   - Any cards where prompt = answer region name

2. **Keep `use_country_region = false`** for:
   - Script/language cards (prompt differs from answer)
   - Country flag cards (already country-level)
   - Phone code cards (prompt is numeric)

### When Creating Regions

1. **Always set `country` field** for non-country regions
2. **Use consistent key format**: `{ISO2}` or `{ISO2}:{Name}` or `{ISO2}:{Province}:{City}`
3. **Set `location_type` appropriately**:
   - `'polygon'` for regions with boundaries
   - `'pin'` for point locations

### When Creating Fact Cards

1. **Link to correct region level** (city, province, or country)
2. **Include helpful hints** (romanization, translations)
3. **Tag with appropriate skill_tags** for analytics
4. **Set difficulty accurately** ('1' = easy, '3' = hard)

---

## Common Patterns

### Multi-Script Language Learning

**Setup:** Two topics for same language set
```sql
-- Topic 1: Long passages (easier)
INSERT INTO topics (key, title, difficulty, use_country_region)
VALUES ('lang-long', 'Language Reading', 'intermediate', false);

-- Topic 2: Single words (harder)
INSERT INTO topics (key, title, difficulty, use_country_region)
VALUES ('lang-short', 'Language Vocabulary', 'advanced', false);
```

### City Learning with Country Context

**Setup:** City cards with country validation
```sql
INSERT INTO topics (key, title, use_country_region)
VALUES ('world-cities', 'World Cities', true);

INSERT INTO fact_cards (prompt, answer_region_id)
VALUES
  ('Tokyo', (SELECT id FROM regions WHERE key = 'JP:Tokyo')),
  ('Paris', (SELECT id FROM regions WHERE key = 'FR:Île-de-France:Paris'));
```

---

## Troubleshooting

### Issue: "Not enough distractor regions"

**Cause:** Not enough regions at the display level (e.g., only 3 countries in database).

**Solution:** Add more regions or reduce required distractors.

### Issue: Options show cities instead of countries

**Cause:** `use_country_region` not set on topic.

**Solution:**
```sql
UPDATE topics SET use_country_region = true WHERE key = 'your-topic-key';
```

### Issue: Grading fails after selecting correct country

**Cause:** Region ID mismatch (selected country ID instead of city ID).

**Solution:** Verify frontend sends `option.region_id`, not a derived country ID.

### Issue: Country region not found

**Cause:** Region's `country` field doesn't match any region `key`.

**Solution:** Ensure all non-country regions have valid `country` field matching a country region's `key`.

---

## Summary

The Rapid Mode system provides a flexible, SRS-powered learning platform that adapts to different content types:

✅ **Script/Language Cards**: Use province/state regions, show region names
✅ **City Cards**: Use city regions, show country names via `use_country_region`
✅ **Country Cards**: Use country regions directly
✅ **Map Mode**: Always validates against answer region (unaffected by display config)
✅ **SRS Integration**: All modes track progress and schedule reviews

The `use_country_region` feature solves the city card problem while maintaining clean separation between display (what user sees) and validation (what we grade against).
