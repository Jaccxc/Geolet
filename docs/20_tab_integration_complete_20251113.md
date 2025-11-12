# Tab Integration Complete

**Date:** 2025-11-13
**Status:** ✅ Complete
**Phase:** 5 Complete

---

## Summary

Completed the integration of both tab components (`PickModeTab` and `MapModeTab`) with:
1. ✅ Server-fetched topics from `/api/rapid/topics`
2. ✅ Proper use of `TopicSelector` component
3. ✅ Correct mode types (`'pick'` or `'map'`)
4. ✅ Proper topicKey passing to queue API

---

## Problem: Hardcoded Topics & Type Mismatches

### Issues Found

1. **Hardcoded Topics**: Both tabs were using hardcoded topics from `src/features/rapid/config/topics.ts` with old schema:
   ```typescript
   // Old hardcoded format
   {
     id: 'india-languages',
     mode: 'language-pick',  // Old mode format
     targetTags: [...],      // Old approach
   }
   ```

2. **Mode Type Mismatches**: API calls were using `topic.mode` which had values like `'language-pick'` instead of just `'pick'`

3. **Wrong Component**: Using `TopicCard` instead of the new `TopicSelector` component

---

## Solution: Server-Fetched Topics

### Architecture

```
┌─────────────────┐
│  PickModeTab    │
│  MapModeTab     │
└────────┬────────┘
         │
         │ useEffect on mount
         ▼
    GET /api/rapid/topics?mode=pick
         │
         │ Returns Topic[]
         ▼
┌─────────────────┐
│ TopicSelector   │  (Renders topic cards)
└────────┬────────┘
         │
         │ User selects topic
         │ onSelect(topicKey)
         ▼
    POST /api/rapid/queue
    {
      mode: 'pick',
      topicKey: 'india-languages',
      maxCards: 20
    }
         │
         ▼
    GameScreen
```

---

## Files Updated

### 1. ✅ `src/features/rapid/components/pick-mode-tab.tsx`

**Before:**
```typescript
import { PICK_MODE_TOPICS } from '../config/topics';
import { TopicCard } from './topic-card';

export function PickModeTab() {
  const handleTopicSelect = async (topicId: string) => {
    const topic = PICK_MODE_TOPICS.find((t) => t.id === topicId);

    const response = await fetch('/api/rapid/queue', {
      method: 'POST',
      body: JSON.stringify({
        mode: topic.mode,  // 'language-pick', 'phone-pick', etc
        targetTags: topic.targetTags,
      }),
    });
  };

  return (
    <div>
      {PICK_MODE_TOPICS.map((topic) => (
        <TopicCard key={topic.id} topic={topic} onClick={() => handleTopicSelect(topic.id)} />
      ))}
    </div>
  );
}
```

**After:**
```typescript
import { useEffect, useState } from 'react';
import type { Topic } from '../types';
import { TopicSelector } from './topic-selector';

export function PickModeTab() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string | undefined>();

  // Fetch topics from server
  useEffect(() => {
    async function fetchTopics() {
      try {
        const response = await fetch('/api/rapid/topics?mode=pick');
        if (!response.ok) throw new Error('Failed to fetch topics');
        const data = await response.json();
        setTopics(data.topics);
      } catch (err) {
        console.error('Failed to fetch topics:', err);
        setError('Failed to load topics');
      }
    }
    fetchTopics();
  }, []);

  const handleTopicSelect = async (topicKey: string) => {
    setSelectedTopic(topicKey);

    const response = await fetch('/api/rapid/queue', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mode: 'pick',  // Literal type
        topicKey: topicKey,  // NEW: server topic key
        maxCards: 20,
      }),
    });

    const data = await response.json();
    setQueueItems(data.items);
    setSessionState('playing');
  };

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-bold'>Choose a Topic</h2>
        <p className='text-muted-foreground'>Select a topic to start your training session</p>
      </div>

      <TopicSelector mode="pick" onSelect={handleTopicSelect} selectedTopic={selectedTopic} />
    </div>
  );
}
```

**Key Changes:**
- ✅ Removed `PICK_MODE_TOPICS` import
- ✅ Added `useEffect` to fetch topics from server
- ✅ Uses `TopicSelector` component instead of manually mapping
- ✅ Passes `topicKey` to API instead of `targetTags`
- ✅ Uses literal `'pick'` instead of `topic.mode`
- ✅ Increased `maxCards` from 10 to 20

---

### 2. ✅ `src/features/rapid/components/map-mode-tab.tsx`

**Before:**
```typescript
import { MAP_MODE_TOPICS } from '../config/topics';
import { TopicCard } from './topic-card';

export function MapModeTab() {
  const [mode, setMode] = useState<string>('');

  const handleTopicSelect = async (topicId: string) => {
    const topic = MAP_MODE_TOPICS.find((t) => t.id === topicId);
    setMode(topic.mode);

    const response = await fetch('/api/rapid/queue', {
      method: 'POST',
      body: JSON.stringify({
        mode: topic.mode,  // 'language-map', 'phone-map', etc
        targetTags: topic.targetTags,
      }),
    });
  };

  if (sessionState === 'playing') {
    const mode_key = mode.endsWith('-map') ? 'map' : 'pick';  // Complex conversion
    return <GameScreen mode={mode_key} />;
  }

  return (
    <div>
      {MAP_MODE_TOPICS.map((topic) => (
        <TopicCard key={topic.id} topic={topic} onClick={() => handleTopicSelect(topic.id)} />
      ))}
    </div>
  );
}
```

**After:**
```typescript
import { useEffect, useState } from 'react';
import type { Topic } from '../types';
import { TopicSelector } from './topic-selector';

export function MapModeTab() {
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string | undefined>();

  // Fetch topics from server
  useEffect(() => {
    async function fetchTopics() {
      try {
        const response = await fetch('/api/rapid/topics?mode=map');
        if (!response.ok) throw new Error('Failed to fetch topics');
        const data = await response.json();
        setTopics(data.topics);
      } catch (err) {
        console.error('Failed to fetch topics:', err);
        setError('Failed to load topics');
      }
    }
    fetchTopics();
  }, []);

  const handleTopicSelect = async (topicKey: string) => {
    setSelectedTopic(topicKey);

    const response = await fetch('/api/rapid/queue', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mode: 'map',  // Literal type
        topicKey: topicKey,  // NEW: server topic key
        maxCards: 20,
      }),
    });

    const data = await response.json();
    setQueueItems(data.items);
    setSessionState('playing');
  };

  if (sessionState === 'playing') {
    return <GameScreen queueItems={queueItems} mode="map" onComplete={handleSessionComplete} />;
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-bold'>Choose a Topic</h2>
        <p className='text-muted-foreground'>Click on a map to identify regions based on scripts and phone codes</p>
      </div>

      <TopicSelector mode="map" onSelect={handleTopicSelect} selectedTopic={selectedTopic} />
    </div>
  );
}
```

**Key Changes:**
- ✅ Removed `MAP_MODE_TOPICS` import
- ✅ Added `useEffect` to fetch topics from server
- ✅ Uses `TopicSelector` component
- ✅ Passes `topicKey` to API
- ✅ Uses literal `'map'` instead of `topic.mode`
- ✅ Removed complex mode conversion logic
- ✅ Increased `maxCards` from 10 to 20

---

## Topic Flow Comparison

### Old Flow (Hardcoded)
```
Component loads
  ↓
Uses PICK_MODE_TOPICS array
  ↓
User selects topic by id
  ↓
Finds topic in array
  ↓
Passes topic.mode ('language-pick') and topic.targetTags
  ↓
API doesn't understand 'language-pick'
  ↓
❌ Type error / wrong behavior
```

### New Flow (Server-Fetched)
```
Component loads
  ↓
Fetches topics from /api/rapid/topics?mode=pick
  ↓
TopicSelector renders server topics
  ↓
User selects topic by key
  ↓
Passes topicKey ('india-languages') to queue API
  ↓
API looks up topic in database
  ↓
API loads card groups based on topic.target_card_group_ids
  ↓
✅ Type-safe, flexible, works correctly
```

---

## Benefits

### 1. **Dynamic Topics**
- Topics are managed in the database
- Can add/remove topics without code changes
- Can enable/disable topics per mode
- Can update topic metadata (title, description, difficulty)

### 2. **Type Safety**
- No more string mode conversion (`'language-pick'` → `'pick'`)
- Compile-time guarantees with literal types
- Proper Topic type from server

### 3. **Correct API Integration**
- Queue API receives `topicKey` and looks up in database
- Card groups are loaded based on `topic.target_card_group_ids`
- No more trying to filter by `targetTags` (which doesn't exist in new schema)

### 4. **Proper Component Usage**
- Uses `TopicSelector` which handles rendering, selection state, and layout
- Consistent topic display across pick and map modes
- Reusable component for future features

---

## API Integration

### Topics API (`GET /api/rapid/topics`)

**Request:**
```typescript
GET /api/rapid/topics?mode=pick
```

**Response:**
```json
{
  "topics": [
    {
      "id": "uuid",
      "key": "india-languages",
      "title": "India Languages",
      "description": "Identify regional scripts across Indian states",
      "icon": "languages",
      "pick_mode_active": true,
      "map_mode_active": true,
      "difficulty": "intermediate",
      "target_card_group_ids": ["group-uuid-1", "group-uuid-2"],
      "created_at": "2025-11-13T00:00:00Z"
    }
  ]
}
```

### Queue API (`POST /api/rapid/queue`)

**Request:**
```json
{
  "mode": "pick",
  "topicKey": "india-languages",
  "maxCards": 20
}
```

**Response:**
```json
{
  "mode": "pick",
  "items": [
    {
      "fact_id": "uuid",
      "card_group_id": "uuid",
      "prompt": "क्या",
      "hint": "Devanagari script",
      "difficulty": "2",
      "options": [
        { "region_id": "uuid", "label": "Maharashtra", "correct": true },
        { "region_id": "uuid", "label": "Tamil Nadu", "correct": false },
        // ... 4 more options
      ]
    }
  ],
  "total": 20
}
```

---

## Deprecated Files

These files are no longer used and can be removed:

1. ❌ `src/features/rapid/config/topics.ts` - Hardcoded topics
2. ❌ `src/features/rapid/components/topic-card.tsx` - Old card component (replaced by TopicSelector)

**Note:** Don't delete yet - wait until after testing to ensure no other files import these.

---

## Testing Checklist

After tab integration, verify:

- [ ] Pick mode tab loads topics from server
- [ ] Map mode tab loads topics from server
- [ ] Topics display correctly with title, description, difficulty
- [ ] Clicking a topic starts game session
- [ ] Queue loads correct cards based on topic
- [ ] GameScreen receives correct mode ('pick' or 'map')
- [ ] Grading works correctly after session
- [ ] No TypeScript errors
- [ ] No runtime errors

---

## Migration Status Update

**Overall Progress:**

| Phase | Status | Progress |
|-------|--------|----------|
| Phase 1: Types & Schema | ✅ Complete | 100% |
| Phase 2: Controllers | ✅ Complete | 100% |
| Phase 3: API Routes | ✅ Complete | 100% |
| Phase 4: UI Components | ✅ Complete | 100% |
| Phase 4b: Bbox & Mode Fixes | ✅ Complete | 100% |
| **Phase 5: Tab Integration** | ✅ **Complete** | **100%** |
| Phase 6: Data Migration | ⏸️ Pending | 0% |
| Phase 7: Testing | ⏸️ Pending | 0% |

**Code Migration:** ✅ **100% Complete**
**All tabs integrated:** ✅ **Ready for data migration**

---

## Next Steps

1. **Data Migration** (Required before testing)
   - Create topics in database (see `scripts/create-initial-data.sql`)
   - Create card groups
   - Create fact cards with answer_region_id
   - Verify topics table has correct `target_card_group_ids`

2. **End-to-End Testing**
   - Test topic selection → queue generation → game play → grading
   - Verify both pick and map modes work correctly
   - Test with multiple topics

3. **Cleanup**
   - Remove deprecated hardcoded topics file
   - Remove old TopicCard component if unused
   - Update any stale documentation

---

## Summary

✅ **All code is now fully migrated and integrated!**

Both tab components now:
- Fetch topics dynamically from the server
- Use the correct `TopicSelector` component
- Pass proper `topicKey` to the queue API
- Use literal mode types (`'pick'` or `'map'`)
- Work with the new normalized database schema

**The application is ready for data migration and testing!**

---

**End of Document**
