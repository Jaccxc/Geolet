import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { buildQueue } from '@/features/rapid/controllers/build-queue';
import { generateMapRegions } from '@/features/rapid/controllers/generate-map-regions';
import { generatePickOptions } from '@/features/rapid/controllers/generate-pick-options';
import type { GameMode, MapQueueItem, PickQueueItem, Region } from '@/features/rapid/types';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const requestSchema = z.object({
  mode: z.enum(['language-pick', 'language-map', 'phone-pick', 'phone-map', 'city-pick', 'city-map']),
  targetTags: z.array(z.string()).optional(),
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
        cards.map(async (card) => {
          const regions = await generateMapRegions(card);
          const bbox = calculateMergedBbox(regions);

          return {
            fact_id: card.id,
            type: card.type,
            payload: card.payload,
            difficulty: card.difficulty,
            regions,
            bbox,
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

/**
 * Calculate a merged bounding box for multiple regions
 */
function calculateMergedBbox(regions: Region[]): [number, number, number, number] {
  if (regions.length === 0) return [-180, -90, 180, 90];

  let minLng = Infinity,
    minLat = Infinity;
  let maxLng = -Infinity,
    maxLat = -Infinity;

  for (const region of regions) {
    if (region.bbox) {
      const [bMinLng, bMinLat, bMaxLng, bMaxLat] = region.bbox;
      minLng = Math.min(minLng, bMinLng);
      minLat = Math.min(minLat, bMinLat);
      maxLng = Math.max(maxLng, bMaxLng);
      maxLat = Math.max(maxLat, bMaxLat);
    }
  }

  // Fallback to world bbox if no valid bboxes found
  if (minLng === Infinity) return [-180, -90, 180, 90];

  return [minLng, minLat, maxLng, maxLat];
}
