# Implementation Plan: use_country_region for Topics

## Problem
City-level fact cards are unplayable in pick mode because the answer is revealed in the prompt:
- Prompt: "London"
- Options: [London ✓, Paris, Tokyo, ...]
- The correct answer is literally visible!

## Solution
Add `use_country_region` boolean to `topics` table. When true, pick mode will:
1. Get the answer region (e.g., "GB:London")
2. Extract its `country` field (e.g., "GB")
3. Fetch the country region by `key = country`
4. Use the country's name for display options (e.g., "United Kingdom")

## Implementation Steps

### 1. Database Migration ✅ DONE
File: `supabase/migrations/20251113000000_add_use_country_region.sql`

```sql
alter table topics
add column use_country_region boolean not null default false;
```

### 2. Update TypeScript Types

**File:** `src/features/rapid/types.ts`

```typescript
export const topicSchema = z.object({
  id: z.string().uuid(),
  key: z.string(),
  title: z.string(),
  description: z.string().nullable(),
  icon: z.string().nullable(),
  pick_mode_active: z.boolean(),
  map_mode_active: z.boolean(),
  difficulty: topicDifficultySchema.nullable(),
  target_card_group_ids: z.array(z.string().uuid()),
  use_country_region: z.boolean(),  // ADD THIS
  created_at: z.string(),
});
```

### 3. Pass Topic to generatePickOptions

**File:** `src/app/api/rapid/queue/route.ts`

Current:
```typescript
const cards = await buildQueue(user.id, {
  topicKey,
  cardGroupIds,
  maxCards,
});

// Pick Mode: Generate choice options
const queueItems: PickQueueItem[] = await Promise.all(
  cards.map(async (card) => ({
    fact_id: card.id,
    card_group_id: card.card_group_id,
    prompt: card.prompt,
    hint: card.hint,
    difficulty: card.difficulty,
    options: await generatePickOptions(card),  // NO TOPIC INFO!
  }))
);
```

Updated:
```typescript
const cards = await buildQueue(user.id, {
  topicKey,
  cardGroupIds,
  maxCards,
});

// Fetch topic if topicKey provided
let topic: Topic | null = null;
if (topicKey) {
  const { data } = await supabase
    .from('topics')
    .select('*')
    .eq('key', topicKey)
    .single();
  topic = data;
}

// Pick Mode: Generate choice options
const queueItems: PickQueueItem[] = await Promise.all(
  cards.map(async (card) => ({
    fact_id: card.id,
    card_group_id: card.card_group_id,
    prompt: card.prompt,
    hint: card.hint,
    difficulty: card.difficulty,
    options: await generatePickOptions(card, topic),  // PASS TOPIC
  }))
);
```

### 4. Update generatePickOptions Function

**File:** `src/features/rapid/controllers/generate-pick-options.ts`

```typescript
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, PickOption, Topic } from '../types';

/**
 * Generate multiple-choice options for Pick mode
 * Returns 1 correct answer + 5 distractors (shuffled)
 *
 * If topic.use_country_region is true, will display country regions
 * instead of the answer region (useful for city-level cards)
 */
export async function generatePickOptions(
  card: FactCard,
  topic: Topic | null = null
): Promise<PickOption[]> {
  const supabase = await createSupabaseServerClient();

  // Get the correct answer region
  const { data: correctRegion, error } = await supabase
    .from('regions')
    .select('*')
    .eq('id', card.answer_region_id)
    .single();

  if (error || !correctRegion) {
    throw new Error(`Answer region not found: ${card.answer_region_id}`);
  }

  // Determine which region to use for display
  let displayRegion = correctRegion;

  if (topic?.use_country_region && correctRegion.country) {
    // Fetch the country region using the country code
    const { data: countryRegion } = await supabase
      .from('regions')
      .select('*')
      .eq('key', correctRegion.country)
      .single();

    if (countryRegion) {
      displayRegion = countryRegion;
    }
  }

  // Get distractor regions (same level as display region)
  const { data: allRegions } = await supabase
    .from('regions')
    .select('*')
    .eq('level', displayRegion.level)
    .neq('id', displayRegion.id)
    .limit(50);

  if (!allRegions || allRegions.length < 5) {
    throw new Error(`Not enough distractor regions for level: ${displayRegion.level}`);
  }

  // Randomly select 5 distractors
  const distractors = shuffleArray(allRegions).slice(0, 5);

  // Build options using displayRegion for labels
  // BUT keep correctRegion.id for validation!
  const options: PickOption[] = [
    {
      region_id: correctRegion.id,  // IMPORTANT: Still use original for grading!
      label: displayRegion.name,
      correct: true,
    },
    ...distractors.map((r) => ({
      region_id: r.id,
      label: r.name,
      correct: false,
    })),
  ];

  return shuffleArray(options);
}

function shuffleArray<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
```

### 5. Update City Topics

**Example SQL:**
```sql
-- For WATG24 cities topic
UPDATE topics
SET use_country_region = true
WHERE key = 'watg24-cities';
```

## How It Works

### Before (Broken):
```
Card: { prompt: "London", answer_region_id: "uuid-for-GB:London" }
Topic: { use_country_region: false }

generatePickOptions() →
  1. Fetch region "GB:London" (level: city)
  2. Get distractors: other cities
  3. Options: ["London" ✓, "Paris", "Tokyo", ...]

PROBLEM: Answer is in the prompt!
```

### After (Fixed):
```
Card: { prompt: "London", answer_region_id: "uuid-for-GB:London" }
Topic: { use_country_region: true }

generatePickOptions() →
  1. Fetch region "GB:London" (level: city)
  2. topic.use_country_region = true, so:
     a. Get country: "GB"
     b. Fetch region where key = "GB" (level: country)
     c. displayRegion = "United Kingdom"
  3. Get distractors: other countries (same level as displayRegion)
  4. Options: ["United Kingdom" ✓, "France", "Japan", ...]

✅ Fixed! User must know London is in UK
```

## Testing

### Test Case 1: City Card with use_country_region = true
```
Input:
  - Card prompt: "London"
  - answer_region_id: GB:London (city)
  - Topic: { use_country_region: true }

Expected:
  - Options show countries: ["United Kingdom" ✓, "France", ...]
  - Grading validates against GB:London
```

### Test Case 2: Province Card with use_country_region = true
```
Input:
  - Card prompt: "Maharashtra"
  - answer_region_id: IN:Maharashtra (province)
  - Topic: { use_country_region: true }

Expected:
  - Options show countries: ["India" ✓, "China", ...]
  - Grading validates against IN:Maharashtra
```

### Test Case 3: Regular Card with use_country_region = false
```
Input:
  - Card prompt: "नमस्ते"
  - answer_region_id: IN:Uttar_Pradesh (province)
  - Topic: { use_country_region: false }

Expected:
  - Options show provinces: ["Uttar Pradesh" ✓, "Maharashtra", ...]
  - Normal behavior unchanged
```

## Files to Modify

1. ✅ `supabase/migrations/20251113000000_add_use_country_region.sql` - DONE
2. ⏸️ `src/features/rapid/types.ts` - Add use_country_region to topicSchema
3. ⏸️ `src/app/api/rapid/queue/route.ts` - Fetch topic and pass to generatePickOptions
4. ⏸️ `src/features/rapid/controllers/generate-pick-options.ts` - Implement country region logic
5. ⏸️ SQL to update existing city topics

## Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Breaking existing topics | Default `use_country_region = false` preserves current behavior |
| Region has no country field | Check `correctRegion.country` exists before fetching |
| Country region not found | Fallback to original region if country fetch fails |
| Performance (extra query) | Minimal - only 1 extra query per card when enabled |

## Rollback Plan

If issues occur:
```sql
-- Remove the column
ALTER TABLE topics DROP COLUMN use_country_region;

-- Revert code changes via git
git revert <commit-hash>
```

## Next Steps

1. Apply migration
2. Update TypeScript types
3. Modify route.ts to fetch and pass topic
4. Update generatePickOptions logic
5. Test with WATG24 cities
6. Update city topics in production
