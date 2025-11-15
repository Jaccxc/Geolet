import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { buildQueue } from '@/features/rapid/controllers/build-queue';
import { getAnswerRegion } from '@/features/rapid/controllers/generate-map-regions';
import { generatePickOptions } from '@/features/rapid/controllers/generate-pick-options';
import type { MapQueueItem, PickQueueItem } from '@/features/rapid/types';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const requestSchema = z.object({
  mode: z.enum(['pick', 'map']),
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

    // Fetch topic if topicKey provided (needed for use_country_region)
    let topic = null;
    if (topicKey) {
      const { data } = await supabase.from('topics').select('*').eq('key', topicKey).single();
      topic = data;
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
          options: await generatePickOptions(card, topic),
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
