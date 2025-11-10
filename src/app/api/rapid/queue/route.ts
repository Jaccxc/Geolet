import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { buildQueue } from '@/features/rapid/controllers/build-queue';
import { generatePickOptions } from '@/features/rapid/controllers/generate-pick-options';
import { generateMapRegions } from '@/features/rapid/controllers/generate-map-regions';
import { z } from 'zod';
import type { GameMode, PickQueueItem, MapQueueItem } from '@/features/rapid/types';

const requestSchema = z.object({
  mode: z.enum([
    'language-pick',
    'language-map',
    'phone-pick',
    'phone-map',
    'city-pick',
    'city-map',
  ]),
  targetTags: z.array(z.string()).optional(),
  maxCards: z.number().int().min(1).max(50).optional(),
});

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { mode, targetTags, maxCards } = requestSchema.parse(body);

    // Build queue
    const cards = await buildQueue(user.id, {
      mode: mode as GameMode,
      targetTags,
      maxCards,
    });

    // Determine if Pick or Map mode
    const isPickMode = mode.endsWith('-pick');

    // Generate appropriate queue items
    if (isPickMode) {
      // Pick Mode: Generate choice options
      const queueItems: PickQueueItem[] = await Promise.all(
        cards.map(async (card) => ({
          fact_id: card.id,
          type: card.type,
          payload: card.payload,
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
      // Map Mode: Generate region data
      const queueItems: MapQueueItem[] = await Promise.all(
        cards.map(async (card) => ({
          fact_id: card.id,
          type: card.type,
          payload: card.payload,
          difficulty: card.difficulty,
          regions: await generateMapRegions(card),
        }))
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
