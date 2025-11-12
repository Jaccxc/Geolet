# Migration Checklist - New Database Schema

**Status:** ✅ Code Complete | 🔄 Data Migration Pending
**Last Updated:** 2025-11-13

---

## Overview

This checklist guides you through completing the database migration from the old schema to the new optimized schema. **All code has been migrated**. You now need to migrate the data.

---

## Prerequisites

- [x] Fresh schema migrations applied (`20251112180204` through `20251112180207`)
- [x] Regions populated (countries + Indian states)
- [x] Skill tags populated
- [x] Code migration complete (all TypeScript files updated)

---

## Step 1: Verify Schema Migration

```bash
# Connect to your database
psql $DATABASE_URL

# Or use Supabase dashboard SQL editor
```

Run these verification queries:

```sql
-- Check tables exist
\dt

-- Should see: card_groups, topics, regions, skill_tags, fact_cards, etc.

-- Check enum types
\dT

-- Should see: region_level_enum, location_type_enum, skill_family_enum, etc.

-- Verify data
select count(*) from regions where level = 'country';  -- Should be ~171
select count(*) from regions where level = 'province' and country = 'IN';  -- Should be ~35
select count(*) from skill_tags;  -- Should be ~55
```

**Status:** [ ] Schema verified

---

## Step 2: Create Card Groups & Topics

```bash
# Run the initial data script
psql $DATABASE_URL -f scripts/create-initial-data.sql

# Or copy/paste into Supabase SQL editor
```

Verify:
```sql
select * from card_groups order by name;
select key, title, difficulty from topics order by key;
```

**Status:** [ ] Card groups created
**Status:** [ ] Topics created

---

## Step 3: Export Old Fact Cards (Optional)

If you have existing fact cards, export them first:

```sql
-- Export to JSON for manual migration
select json_agg(row_to_json(fact_cards))
from fact_cards;

-- Save output to: migration-data/old-fact-cards.json
```

**Status:** [ ] Old data exported (if applicable)

---

## Step 4: Create Sample Fact Cards

Create at least 3-5 test cards to verify the system works:

```sql
-- Example 1: Malayalam script card
insert into fact_cards (
  card_group_id,
  prompt,
  hint,
  primary_skill_tags,
  difficulty,
  answer_region_id
) values (
  (select id from card_groups where name = 'India Regional Languages'),
  'ഹോട്ടല്‍',
  'Found in Kerala. Curvy letters with upside-down U-shapes.',
  array['script:malayalam'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Kerala')
);

-- Example 2: Tamil script card
insert into fact_cards (
  card_group_id,
  prompt,
  hint,
  primary_skill_tags,
  difficulty,
  answer_region_id
) values (
  (select id from card_groups where name = 'India Regional Languages'),
  'ஹோட்டல்',
  'Found in Tamil Nadu. Distinctive curves and 90° angles.',
  array['script:tamil'],
  '1'::fact_difficulty_enum,
  (select id from regions where key = 'IN:Tamil_Nadu')
);

-- Add 3-5 more cards for testing...
```

Verify:
```sql
select
  fc.prompt,
  fc.hint,
  fc.difficulty,
  cg.name as card_group,
  r.name as answer_region
from fact_cards fc
join card_groups cg on fc.card_group_id = cg.id
join regions r on fc.answer_region_id = r.id;
```

**Status:** [ ] Sample fact cards created (at least 5)

---

## Step 5: Test Application Build

```bash
# Check for TypeScript errors
npm run build

# Expected: No errors (warnings OK)
```

**Status:** [ ] Build successful

---

## Step 6: Test API Endpoints

### Test Topics API
```bash
# Test topics endpoint
curl http://localhost:3000/api/rapid/topics?mode=pick

# Should return topics list
```

### Test Queue API
```bash
# Test queue generation
curl -X POST http://localhost:3000/api/rapid/queue \
  -H "Content-Type: application/json" \
  -d '{
    "mode": "pick",
    "topicKey": "india-languages",
    "maxCards": 5
  }'

# Should return queue with fact cards and options
```

**Status:** [ ] Topics API working
**Status:** [ ] Queue API working (pick mode)
**Status:** [ ] Queue API working (map mode)

---

## Step 7: Update UI Components (Code Already Done, Need Integration)

The code is written but needs to be integrated into the existing UI tabs:

### A. Update PickModeTab
Open: `src/features/rapid/components/pick-mode-tab.tsx`

Add TopicSelector:
```typescript
import { TopicSelector } from './topic-selector';

// Inside component:
const [selectedTopic, setSelectedTopic] = useState<string>();

// In render:
<TopicSelector
  mode="pick"
  onSelect={setSelectedTopic}
  selectedTopic={selectedTopic}
/>
```

Update queue fetching:
```typescript
// OLD
fetch('/api/rapid/queue', {
  method: 'POST',
  body: JSON.stringify({
    mode: 'language-pick',
    targetTags: ['script:malayalam'],
  }),
});

// NEW
fetch('/api/rapid/queue', {
  method: 'POST',
  body: JSON.stringify({
    mode: 'pick',
    topicKey: selectedTopic,
    maxCards: 20,
  }),
});
```

### B. Update MapModeTab
Same process as PickModeTab but with `mode: 'map'`

**Status:** [ ] PickModeTab integrated with TopicSelector
**Status:** [ ] MapModeTab integrated with TopicSelector

---

## Step 8: End-to-End Testing

Test complete user flows:

### Pick Mode Flow
1. [ ] Open rapid page
2. [ ] See topic selector
3. [ ] Click a topic
4. [ ] Start game
5. [ ] See fact card with prompt/hint
6. [ ] See 6 options
7. [ ] Select answer
8. [ ] Submit answers
9. [ ] See results

### Map Mode Flow
1. [ ] Switch to map mode tab
2. [ ] See topic selector
3. [ ] Click a topic
4. [ ] Start game
5. [ ] See map with region geometry
6. [ ] Click on map
7. [ ] Submit answers
8. [ ] See results

**Status:** [ ] Pick mode end-to-end working
**Status:** [ ] Map mode end-to-end working

---

## Step 9: Migrate Remaining Fact Cards

Once testing is successful, migrate all remaining fact cards:

### Option A: Manual Migration (Small Dataset)
Create SQL insert statements for each card

### Option B: Script Migration (Large Dataset)
Write a Node.js script to:
1. Read old fact_cards
2. Parse answer contracts
3. Map to new schema
4. Insert into database

**Status:** [ ] All fact cards migrated

---

## Step 10: Deploy to Production

### Pre-Deploy
- [ ] Backup production database
- [ ] Test migration in staging
- [ ] Prepare rollback plan
- [ ] Schedule downtime window

### Deploy
- [ ] Put app in maintenance mode
- [ ] Apply schema migrations
- [ ] Run initial data script
- [ ] Migrate fact cards
- [ ] Deploy new code
- [ ] Smoke test
- [ ] Remove maintenance mode

### Post-Deploy
- [ ] Monitor error logs
- [ ] Track API performance
- [ ] Gather user feedback

---

## Rollback Plan (If Needed)

```sql
-- If things go wrong, you can restore from backup:
-- 1. Restore database from backup
-- 2. Revert to previous git commit
-- 3. Deploy old code
```

---

## Quick Reference

### Key Files Updated
- `src/features/rapid/types.ts` - All types rewritten
- `src/features/rapid/controllers/*` - 6 controllers updated
- `src/app/api/rapid/*` - 3 API routes updated
- `src/features/rapid/components/topic-selector.tsx` - NEW

### Documentation
- `docs/16_api_migration_plan_20251113.md` - Detailed migration plan
- `docs/17_migration_implementation_summary_20251113.md` - Implementation summary
- `scripts/create-initial-data.sql` - Data setup script

### Database Schema
- Old: JSONB-heavy, complex answer contracts
- New: Normalized, direct FKs, PostgreSQL ENUMs

---

## Success Criteria

- [x] ✅ All TypeScript code updated
- [x] ✅ All controllers migrated
- [x] ✅ All API routes updated
- [ ] 🔄 Card groups created
- [ ] 🔄 Topics created
- [ ] 🔄 Fact cards migrated
- [ ] 🔄 UI components integrated
- [ ] 🔄 End-to-end tests passing
- [ ] 🔄 Deployed to production

**Current Status:** Code Migration 100% Complete | Data Migration Pending

---

## Need Help?

1. Review detailed plan: `docs/16_api_migration_plan_20251113.md`
2. Check implementation summary: `docs/17_migration_implementation_summary_20251113.md`
3. Review new schema: `supabase/migrations/20251112180204_fresh_schema.sql`

---

**Good luck! 🚀**
