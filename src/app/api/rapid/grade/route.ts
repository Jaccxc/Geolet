import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { updateUserFactStat } from '@/features/srs/controllers/update-user-fact-stat';
import { getFactCardById } from '@/features/rapid/controllers/get-fact-cards';
import { generateMapRegions } from '@/features/rapid/controllers/generate-map-regions';
import { validatePickAnswer, validateMapAnswer } from '@/features/rapid/models/answer-validator';
import { z } from 'zod';
import type { PickGradeItem, MapGradeItem, GradeResult, GradeSummary } from '@/features/rapid/types';

const pickGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_key: z.string(),
  time_ms: z.number().int(),
});

const mapGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  clicked_point: z.tuple([z.number(), z.number()]), // [lng, lat]
  time_ms: z.number().int(),
});

const requestSchema = z.object({
  mode: z.string(),
  items: z.array(z.union([pickGradeItemSchema, mapGradeItemSchema])),
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
    const { mode, items } = requestSchema.parse(body);

    const isPickMode = mode.endsWith('-pick');

    // Grade each item and update SRS
    const results: GradeResult[] = await Promise.all(
      items.map(async (item) => {
        // Get fact card to check answer
        const card = await getFactCardById(item.fact_id);

        if (!card) {
          throw new Error(`Card not found: ${item.fact_id}`);
        }

        // Validate answer based on mode
        let correct: boolean;
        let distance: number | undefined;

        if (isPickMode) {
          const pickItem = item as PickGradeItem;
          correct = validatePickAnswer(card.answer, pickItem.selected_key);
        } else {
          const mapItem = item as MapGradeItem;
          const regions = await generateMapRegions(card);
          const result = validateMapAnswer(
            card.answer,
            mapItem.clicked_point,
            regions
          );
          correct = result.correct;
          distance = result.distance;
        }

        // Determine quality for SRS
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
          distance,
          srs: {
            new_ease: srsResult.new_ease,
            due_at: srsResult.due_at.toISOString(),
            interval_days: srsResult.interval_days,
          },
        };
      })
    );

    // Calculate summary
    const summary: GradeSummary = {
      total: results.length,
      correct: results.filter((r) => r.correct).length,
      accuracy:
        results.length > 0
          ? results.filter((r) => r.correct).length / results.length
          : 0,
      avg_time_ms:
        results.length > 0
          ? results.reduce((sum, r) => sum + r.time_ms, 0) / results.length
          : 0,
    };

    // Save session
    await supabase.from('game_sessions').insert({
      user_id: user.id,
      mode,
      summary: summary as any,
    });

    return NextResponse.json({
      results,
      summary,
    });
  } catch (error) {
    console.error('Grade error:', error);
    return NextResponse.json(
      {
        error: 'Failed to grade session',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
