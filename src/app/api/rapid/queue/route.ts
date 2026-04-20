import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { buildDoomsdayQueueItem } from '@/features/rapid/controllers/build-doomsday-queue';
import { buildQueue } from '@/features/rapid/controllers/build-queue';
import { getAnswerRegion } from '@/features/rapid/controllers/generate-map-regions';
import { generatePickOptions } from '@/features/rapid/controllers/generate-pick-options';
import type { DoomsdayQueueItem, MapQueueItem, PickQueueItem } from '@/features/rapid/types';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const requestSchema = z.object({
  mode: z.enum(['pick', 'map', 'doomsday']),
  topicKey: z.string().optional(),
  cardGroupIds: z.array(z.string().uuid()).optional(),
  maxCards: z.number().int().min(1).max(50).optional(),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, topicKey, cardGroupIds, maxCards } = requestSchema.parse(body);

    // Build queue
    const cards = await buildQueue(user.id, {
      topicKey,
      cardGroupIds,
      maxCards,
    });

    // Doomsday mode: programmatic cards — no region lookups
    if (mode === 'doomsday') {
      const queueItems: DoomsdayQueueItem[] = cards.map(buildDoomsdayQueueItem);
      return NextResponse.json({ mode, items: queueItems, total: queueItems.length });
    }

    // Generate appropriate queue items
    if (mode === 'pick') {
      // Pick Mode: Generate choice options
      const queueItems: PickQueueItem[] = await Promise.all(
        cards.map(async (card) => ({
          fact_id: card.id,
          card_group_id: card.card_group_id,
          prompt: card.prompt,
          hint: card.hint,
          difficulty: card.difficulty,
          options: await generatePickOptions(card),
        }))
      );

      return NextResponse.json({
        mode,
        items: queueItems,
        total: queueItems.length,
      });
    } else {
      // Map Mode: Get answer region
      const queueItems: MapQueueItem[] = await Promise.all(
        cards.map(async (card) => {
          const answerRegion = await getAnswerRegion(card);

          return {
            fact_id: card.id,
            card_group_id: card.card_group_id,
            prompt: card.prompt,
            hint: card.hint,
            difficulty: card.difficulty,
            answer_region: answerRegion,
          };
        })
      );

      return NextResponse.json({
        mode,
        items: queueItems,
        total: queueItems.length,
      });
    }
  } catch (error) {
    console.error('Queue error:', error);
    return NextResponse.json(
      {
        error: 'Failed to build queue',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
