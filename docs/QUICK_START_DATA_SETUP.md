# Quick Start: Minimal Data Setup

**Purpose:** Get the application running with minimal test data

---

## The Error You're Seeing

**Error:** `TypeError: right-hand side of 'in' should be an object, got undefined`

**Root Cause:** No data in database yet! The queue API is returning an empty array because:
1. No topics exist in the `topics` table
2. No card groups exist in the `card_groups` table
3. No fact cards exist in the `fact_cards` table

**Status:** ✅ **FIXED** - Added better error handling to show helpful messages

---

## Minimal Test Data Setup

To test the application, you need **at minimum**:
1. One region (for answer)
2. One card group
3. One topic
4. One fact card

### Step 1: Check if Regions Exist

```sql
SELECT COUNT(*) FROM regions;
```

If you have regions (from your seed data), great! Pick one:

```sql
SELECT id, key, name, level FROM regions LIMIT 5;
```

Note down a region UUID (e.g., for Maharashtra or any state).

### Step 2: Create a Card Group

```sql
INSERT INTO card_groups (id, name, created_at)
VALUES (
  gen_random_uuid(),
  'Test - India Languages',
  NOW()
)
RETURNING id, name;
```

**Save the UUID returned!** You'll need it for the next steps.

### Step 3: Create a Topic

Replace `<card-group-uuid>` with the UUID from Step 2:

```sql
INSERT INTO topics (
  id,
  key,
  title,
  description,
  icon,
  pick_mode_active,
  map_mode_active,
  difficulty,
  target_card_group_ids,
  created_at
)
VALUES (
  gen_random_uuid(),
  'test-india-languages',
  'Test: India Languages',
  'Test topic for Indian regional scripts',
  'languages',
  true,
  true,
  'beginner',
  ARRAY['<card-group-uuid>']::uuid[],
  NOW()
)
RETURNING id, key, title;
```

### Step 4: Create Test Fact Cards

Replace:
- `<card-group-uuid>` with UUID from Step 2
- `<region-uuid>` with a region UUID from Step 1

```sql
-- Fact Card 1: Devanagari
INSERT INTO fact_cards (
  id,
  card_group_id,
  prompt,
  hint,
  primary_skill_tags,
  difficulty,
  answer_region_id,
  created_at
)
VALUES (
  gen_random_uuid(),
  '<card-group-uuid>',
  'क्या',
  'Devanagari script - Hindi/Marathi',
  ARRAY['script:devanagari:hindi'],
  '2',
  '<region-uuid>',
  NOW()
);

-- Fact Card 2: Another example
INSERT INTO fact_cards (
  id,
  card_group_id,
  prompt,
  hint,
  primary_skill_tags,
  difficulty,
  answer_region_id,
  created_at
)
VALUES (
  gen_random_uuid(),
  '<card-group-uuid>',
  'નમસ્તે',
  'Gujarati script',
  ARRAY['script:gujarati'],
  '2',
  '<region-uuid>',
  NOW()
);

-- Add more cards as needed (recommend at least 5-10 for testing)
```

### Step 5: Verify Data

```sql
-- Check topics
SELECT key, title, pick_mode_active, map_mode_active,
       array_length(target_card_group_ids, 1) as num_card_groups
FROM topics;

-- Check card groups and their fact cards
SELECT cg.name,
       COUNT(fc.id) as card_count
FROM card_groups cg
LEFT JOIN fact_cards fc ON fc.card_group_id = cg.id
GROUP BY cg.id, cg.name;

-- Check fact cards
SELECT fc.prompt,
       fc.hint,
       r.name as answer_region
FROM fact_cards fc
JOIN regions r ON r.id = fc.answer_region_id
LIMIT 10;
```

**Expected Results:**
- 1 topic with 1 card group
- 1 card group with 2+ fact cards
- All fact cards have valid answer regions

---

## Testing the Application

1. **Refresh the app** (hard refresh: Ctrl+Shift+R or Cmd+Shift+R)

2. **Go to Pick Mode or Map Mode**
   - You should see your topic: "Test: India Languages"

3. **Click on the topic**
   - If successful: Game should start with your fact cards
   - If error: Check the error message and verify your data setup

4. **Play a round**
   - Pick mode: Select the correct region
   - Map mode: Click on the map to place your answer

---

## Full Production Data Setup

Once testing works, follow the full data migration guide:

### See: `scripts/create-initial-data.sql`

This script includes:
- Multiple card groups (India Languages, Global Languages, Phone Numbers, Cities)
- Multiple topics for pick and map modes
- Template fact cards

### Steps:
1. Create all card groups
2. Create all topics with proper `target_card_group_ids`
3. Create fact cards for each card group
4. Verify integrity with the SQL queries above

---

## Troubleshooting

### "Topic not found" Error
**Cause:** Topic doesn't exist or `key` doesn't match
**Fix:** Check `topics` table: `SELECT key, title FROM topics;`

### "No cards available for this topic"
**Cause:**
1. Topic exists but `target_card_group_ids` is empty
2. Card groups exist but have no fact cards
3. Fact cards exist but `answer_region_id` is invalid

**Fix:**
```sql
-- Check topic's card groups
SELECT t.key, t.title, t.target_card_group_ids
FROM topics t
WHERE t.key = 'your-topic-key';

-- Check card groups have cards
SELECT cg.id, cg.name, COUNT(fc.id) as card_count
FROM card_groups cg
LEFT JOIN fact_cards fc ON fc.card_group_id = cg.id
WHERE cg.id = ANY(ARRAY['<uuid1>', '<uuid2>']::uuid[])
GROUP BY cg.id, cg.name;

-- Check fact cards have valid regions
SELECT fc.id, fc.prompt, fc.answer_region_id, r.name
FROM fact_cards fc
LEFT JOIN regions r ON r.id = fc.answer_region_id
WHERE fc.card_group_id = '<card-group-uuid>'
LIMIT 10;
```

### Empty Queue Even with Data
**Cause:** TypeScript/cache issue
**Fix:**
1. Restart Next.js dev server
2. Clear browser cache
3. Check browser console for errors

---

## Quick Copy-Paste Setup (Example)

**Assumes you have region UUID: `550e8400-e29b-41d4-a716-446655440000` (Maharashtra)**

```sql
-- Step 1: Create card group
INSERT INTO card_groups (id, name, created_at)
VALUES (
  '650e8400-e29b-41d4-a716-446655440000',
  'Test - India Languages',
  NOW()
);

-- Step 2: Create topic
INSERT INTO topics (
  id, key, title, description, icon,
  pick_mode_active, map_mode_active, difficulty,
  target_card_group_ids, created_at
)
VALUES (
  '750e8400-e29b-41d4-a716-446655440000',
  'test-india-languages',
  'Test: India Languages',
  'Test topic for Indian regional scripts',
  'languages',
  true, true, 'beginner',
  ARRAY['650e8400-e29b-41d4-a716-446655440000']::uuid[],
  NOW()
);

-- Step 3: Create fact cards
INSERT INTO fact_cards (id, card_group_id, prompt, hint, primary_skill_tags, difficulty, answer_region_id, created_at)
VALUES
  (gen_random_uuid(), '650e8400-e29b-41d4-a716-446655440000', 'क्या', 'Devanagari', ARRAY['script:devanagari:hindi'], '2', '550e8400-e29b-41d4-a716-446655440000', NOW()),
  (gen_random_uuid(), '650e8400-e29b-41d4-a716-446655440000', 'નમસ્તે', 'Gujarati', ARRAY['script:gujarati'], '2', '550e8400-e29b-41d4-a716-446655440000', NOW()),
  (gen_random_uuid(), '650e8400-e29b-41d4-a716-446655440000', 'வணக்கம்', 'Tamil', ARRAY['script:tamil'], '2', '550e8400-e29b-41d4-a716-446655440000', NOW()),
  (gen_random_uuid(), '650e8400-e29b-41d4-a716-446655440000', 'ನಮಸ್ಕಾರ', 'Kannada', ARRAY['script:kannada'], '2', '550e8400-e29b-41d4-a716-446655440000', NOW()),
  (gen_random_uuid(), '650e8400-e29b-41d4-a716-446655440000', 'నమస్కారం', 'Telugu', ARRAY['script:telugu'], '2', '550e8400-e29b-41d4-a716-446655440000', NOW());

-- Verify
SELECT 'Topics:', COUNT(*) FROM topics;
SELECT 'Card Groups:', COUNT(*) FROM card_groups;
SELECT 'Fact Cards:', COUNT(*) FROM fact_cards;
```

---

## Next Steps After Testing

1. ✅ Verify game play works (pick and map modes)
2. ✅ Verify answer validation works
3. ✅ Verify grading and SRS updates work
4. Create full production data
5. Deploy to production

---

**Good luck! 🚀**
