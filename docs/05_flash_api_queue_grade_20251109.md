# Step 5: Flash API - Queue & Grade (Choice Mode)

**Timeline:** 6-8 hours
**Priority:** Critical (Core game loop)

## Overview
Implement the backend API for Flash minigames, starting with choice mode only. This includes queue generation (with adaptive selection) and answer grading with SRS updates.

## Prerequisites
- Step 4 completed (types and controllers available)
- Understanding of SM-2 spaced repetition algorithm
- Familiarity with Next.js API routes

## Detailed Tasks

### 5.1 Implement SRS Logic

#### A. `/src/features/srs/controllers/calculate-next-interval.ts`

```typescript
import type { SRSQuality } from '../types';

export interface SRSState {
  ease: number;
  interval_days: number;
}

/**
 * SM-2-lite algorithm
 * quality: 5 (perfect), 4 (correct), 2 (wrong)
 */
export function calculateNextInterval(
  currentEase: number,
  currentInterval: number,
  seen: number,
  quality: SRSQuality
): SRSState {
  // Update ease factor
  let newEase = currentEase + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  newEase = Math.max(1.3, newEase);

  // Calculate interval
  let interval: number;

  if (quality < 3) {
    // Wrong answer → review tomorrow
    interval = 1;
  } else if (seen === 0) {
    // First time → 1 day
    interval = 1;
  } else if (seen === 1) {
    // Second time → 6 days
    interval = 6;
  } else {
    // Subsequent reviews → multiply by ease
    interval = Math.round(currentInterval * newEase);
  }

  return {
    ease: newEase,
    interval_days: interval,
  };
}

export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}
```

#### B. `/src/features/srs/controllers/update-user-fact-stat.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import { calculateNextInterval, addDays } from './calculate-next-interval';
import type { SRSUpdateInput, SRSUpdateResult } from '../types';

export async function updateUserFactStat(
  userId: string,
  input: SRSUpdateInput
): Promise<SRSUpdateResult> {
  const supabase = await createClient();

  // Determine quality from time
  const correct = input.quality >= 3;
  const fast = input.time_ms < 5000;
  const quality = correct ? (fast ? 5 : 4) : 2;

  // Get or create current stat
  const { data: current } = await supabase
    .from('user_fact_stats')
    .select('*')
    .eq('user_id', userId)
    .eq('fact_id', input.fact_id)
    .single();

  const currentEase = current?.ease ?? 2.5;
  const currentInterval = current?.seen ?? 0;
  const seen = (current?.seen ?? 0) + 1;
  const correctCount = (current?.correct ?? 0) + (correct ? 1 : 0);

  // Calculate new SRS state
  const { ease: newEase, interval_days } = calculateNextInterval(
    currentEase,
    currentInterval,
    seen,
    quality
  );

  const now = new Date();
  const dueAt = addDays(now, interval_days);

  // Upsert user_fact_stats
  await supabase
    .from('user_fact_stats')
    .upsert({
      user_id: userId,
      fact_id: input.fact_id,
      seen,
      correct: correctCount,
      ease: newEase,
      last_seen_at: now.toISOString(),
      due_at: dueAt.toISOString(),
    });

  return {
    fact_id: input.fact_id,
    correct,
    new_ease: newEase,
    due_at: dueAt,
    interval_days,
  };
}
```

### 5.2 Implement Queue Builder

#### `/src/features/flash/controllers/build-queue.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard, GameMode } from '../types';

export interface QueueOptions {
  mode: GameMode;
  targetTags?: string[];
  maxCards?: number;
  prioritizeDue?: boolean;
}

export async function buildQueue(
  userId: string,
  options: QueueOptions
): Promise<FactCard[]> {
  const supabase = await createClient();
  const maxCards = options.maxCards ?? 20;

  // Determine fact type from mode
  const factType = modeToFactType(options.mode);

  // Build query
  let query = supabase
    .from('fact_cards')
    .select(`
      *,
      user_fact_stats!left (
        seen,
        correct,
        due_at
      )
    `)
    .eq('type', factType);

  // Filter by tags if specified
  if (options.targetTags && options.targetTags.length > 0) {
    query = query.overlaps('primary_tags', options.targetTags);
  }

  const { data, error } = await query;
  if (error) throw error;

  // Score and prioritize cards
  const scored = data.map(card => {
    const stat = card.user_fact_stats?.[0];
    let score = 0;

    // Prioritize due cards
    if (stat?.due_at && new Date(stat.due_at) <= new Date()) {
      score += 1000;
    }

    // Prioritize unseen cards
    if (!stat || stat.seen === 0) {
      score += 500;
    }

    // Prioritize cards with low accuracy
    if (stat && stat.seen > 0) {
      const accuracy = stat.correct / stat.seen;
      score += (1 - accuracy) * 100;
    }

    // Add randomness
    score += Math.random() * 10;

    return { card, score };
  });

  // Sort by score (descending) and take maxCards
  scored.sort((a, b) => b.score - a.score);

  return scored
    .slice(0, maxCards)
    .map(({ card }) => {
      // Remove user_fact_stats from result
      const { user_fact_stats, ...factCard } = card;
      return factCard as FactCard;
    });
}

function modeToFactType(mode: GameMode): string {
  if (mode.startsWith('language')) return 'language_snippet';
  if (mode.startsWith('phone')) return 'phone_number';
  if (mode.startsWith('city')) return 'city_locate';
  throw new Error(`Unknown mode: ${mode}`);
}
```

### 5.3 Implement Choice Option Generator

#### `/src/features/flash/controllers/generate-choice-options.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard, SkillTag, Region } from '../types';

export interface ChoiceOption {
  key: string;
  label: string;
  correct: boolean;
}

export async function generateChoiceOptions(
  card: FactCard
): Promise<ChoiceOption[]> {
  const supabase = await createClient();
  const answer = card.answer;

  if (answer.kind === 'tag') {
    // Get correct tag(s)
    const { data: correctTags } = await supabase
      .from('skill_tags')
      .select('*')
      .in('key', answer.select.keys);

    // Get distractor tags (same family)
    const family = correctTags?.[0]?.family;
    const { data: allTags } = await supabase
      .from('skill_tags')
      .select('*')
      .eq('family', family)
      .limit(20);

    // Build options
    const distractors = (allTags || [])
      .filter(t => !answer.select.keys.includes(t.key))
      .sort(() => Math.random() - 0.5)
      .slice(0, 5);

    const options: ChoiceOption[] = [
      ...correctTags!.map(t => ({
        key: t.key,
        label: t.meta.display || t.key,
        correct: true,
      })),
      ...distractors.map(t => ({
        key: t.key,
        label: t.meta.display || t.key,
        correct: false,
      })),
    ];

    return shuffleArray(options);
  }

  if (answer.kind === 'region') {
    // Get correct region(s)
    const { data: correctRegions } = await supabase
      .from('regions')
      .select('*')
      .in('key', answer.select.keys);

    // Get distractor regions (same kind)
    const kind = correctRegions?.[0]?.kind;
    const { data: allRegions } = await supabase
      .from('regions')
      .select('*')
      .eq('kind', kind)
      .limit(20);

    const distractors = (allRegions || [])
      .filter(r => !answer.select.keys.includes(r.key))
      .sort(() => Math.random() - 0.5)
      .slice(0, 5);

    const options: ChoiceOption[] = [
      ...correctRegions!.map(r => ({
        key: r.key,
        label: r.name,
        correct: true,
      })),
      ...distractors.map(r => ({
        key: r.key,
        label: r.name,
        correct: false,
      })),
    ];

    return shuffleArray(options);
  }

  throw new Error('Invalid answer kind');
}

function shuffleArray<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}
```

### 5.4 Create API Routes

#### A. `POST /api/flash/queue`

`/src/app/api/flash/queue/route.ts`:

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { buildQueue } from '@/features/flash/controllers/build-queue';
import { generateChoiceOptions } from '@/features/flash/controllers/generate-choice-options';
import { z } from 'zod';

const requestSchema = z.object({
  mode: z.enum(['language-choice', 'phone-choice']),
  targetTags: z.array(z.string()).optional(),
  maxCards: z.number().int().min(1).max(50).optional(),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, targetTags, maxCards } = requestSchema.parse(body);

    // Build queue
    const cards = await buildQueue(user.id, {
      mode,
      targetTags,
      maxCards,
    });

    // Generate choice options for each card
    const queueItems = await Promise.all(
      cards.map(async (card) => ({
        fact_id: card.id,
        type: card.type,
        payload: card.payload,
        difficulty: card.difficulty,
        options: await generateChoiceOptions(card),
      }))
    );

    return NextResponse.json({
      mode,
      items: queueItems,
      total: queueItems.length,
    });
  } catch (error) {
    console.error('Queue error:', error);
    return NextResponse.json(
      { error: 'Failed to build queue' },
      { status: 500 }
    );
  }
}
```

#### B. `POST /api/flash/grade`

`/src/app/api/flash/grade/route.ts`:

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { updateUserFactStat } from '@/features/srs/controllers/update-user-fact-stat';
import { z } from 'zod';

const gradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_key: z.string(),
  time_ms: z.number().int(),
});

const requestSchema = z.object({
  mode: z.string(),
  items: z.array(gradeItemSchema),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, items } = requestSchema.parse(body);

    // Grade each item and update SRS
    const results = await Promise.all(
      items.map(async (item) => {
        // Get fact card to check answer
        const { data: card } = await supabase
          .from('fact_cards')
          .select('*')
          .eq('id', item.fact_id)
          .single();

        if (!card) {
          return { fact_id: item.fact_id, error: 'Card not found' };
        }

        // Validate answer
        const correct = isCorrectAnswer(card.answer, item.selected_key);
        const quality = correct ? (item.time_ms < 5000 ? 5 : 4) : 2;

        // Update SRS
        const srsResult = await updateUserFactStat(user.id, {
          fact_id: item.fact_id,
          quality,
          time_ms: item.time_ms,
        });

        return {
          fact_id: item.fact_id,
          correct,
          time_ms: item.time_ms,
          srs: srsResult,
        };
      })
    );

    // Calculate summary
    const summary = {
      total: results.length,
      correct: results.filter(r => r.correct).length,
      accuracy: results.filter(r => r.correct).length / results.length,
      avg_time_ms: results.reduce((sum, r) => sum + (r.time_ms || 0), 0) / results.length,
    };

    // Save session
    await supabase
      .from('game_sessions')
      .insert({
        user_id: user.id,
        mode,
        summary,
      });

    return NextResponse.json({
      results,
      summary,
    });
  } catch (error) {
    console.error('Grade error:', error);
    return NextResponse.json(
      { error: 'Failed to grade session' },
      { status: 500 }
    );
  }
}

function isCorrectAnswer(answer: any, selectedKey: string): boolean {
  if (answer.kind === 'tag') {
    return answer.select.keys.includes(selectedKey);
  }
  if (answer.kind === 'region') {
    return answer.select.keys.includes(selectedKey);
  }
  return false;
}
```

## Files to Create/Modify

### Created:
- `/src/features/srs/controllers/calculate-next-interval.ts`
- `/src/features/srs/controllers/update-user-fact-stat.ts`
- `/src/features/flash/controllers/build-queue.ts`
- `/src/features/flash/controllers/generate-choice-options.ts`
- `/src/app/api/flash/queue/route.ts`
- `/src/app/api/flash/grade/route.ts`

## Acceptance Criteria
- ✅ POST `/api/flash/queue` returns 20 cards with choice options
- ✅ Queue prioritizes due cards and weak skills
- ✅ Choice options include 1 correct + 5 distractors
- ✅ POST `/api/flash/grade` validates answers correctly
- ✅ SRS updates user_fact_stats with proper intervals
- ✅ Session summary saved to game_sessions table
- ✅ API returns appropriate errors for unauthorized users
- ✅ Can test endpoints with Postman/curl

## Notes & Considerations

### Performance
- Keep queue build under 50ms
- Use indexes (GIN on primary_tags)
- Limit distractor queries to reasonable size

### SRS Quality Mapping
- Quality 5: Correct + fast (< 5s)
- Quality 4: Correct + slow
- Quality 2: Wrong

### Future Enhancements (not MVP)
- Better distractor generation using confusion matrix
- Hard mode (no options, type answer)
- Streak tracking

## Dependencies
- Step 4 (Data Models & Types)

## Blocks
- Step 6 (Flash UI - Choice Mode)
