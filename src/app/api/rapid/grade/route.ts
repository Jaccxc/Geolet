import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';

import { getAnswerRegion } from '@/features/rapid/controllers/generate-map-regions';
import { getFactCardById } from '@/features/rapid/controllers/get-fact-cards';
import { validateDoomsdayAnswer, validateMapAnswer, validatePickAnswer } from '@/features/rapid/models/answer-validator';
import type { DoomsdayGradeItem, GradeResult, GradeSummary, MapGradeItem, PickGradeItem } from '@/features/rapid/types';
import { updateUserFactStat } from '@/features/srs/controllers/update-user-fact-stat';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

const pickGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_region_id: z.string().uuid(),
  time_ms: z.number().int(),
});

const mapGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  clicked_point: z.tuple([z.number(), z.number()]),
  time_ms: z.number().int(),
});

const doomsdayGradeItemSchema = z.object({
  fact_id: z.string().uuid(),
  selected_value: z.string(),
  question_params: z.record(z.unknown()),
  time_ms: z.number().int(),
});

const requestSchema = z.object({
  mode: z.enum(['pick', 'map', 'doomsday']),
  items: z.array(z.union([pickGradeItemSchema, mapGradeItemSchema, doomsdayGradeItemSchema])),
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
    const { mode, items } = requestSchema.parse(body);

    // Grade each item and update SRS
    const results: GradeResult[] = await Promise.all(
      items.map(async (item) => {
        // Get fact card with answer region
        const card = await getFactCardById(item.fact_id);

        if (!card) {
          throw new Error(`Card not found: ${item.fact_id}`);
        }

        // Validate answer based on mode
        let correct: boolean;
        let distance: number | undefined;

        if (mode === 'doomsday') {
          const doomsdayItem = item as DoomsdayGradeItem;
          correct = validateDoomsdayAnswer(
            card.card_type,
            doomsdayItem.question_params,
            doomsdayItem.selected_value
          );
        } else if (mode === 'pick') {
          const pickItem = item as PickGradeItem;
          correct = validatePickAnswer(card.answer_region_id!, pickItem.selected_region_id);
        } else {
          const mapItem = item as MapGradeItem;
          const answerRegion = await getAnswerRegion(card);
          const result = validateMapAnswer(answerRegion, mapItem.clicked_point);
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
      accuracy: results.length > 0 ? results.filter((r) => r.correct).length / results.length : 0,
      avg_time_ms: results.length > 0 ? results.reduce((sum, r) => sum + r.time_ms, 0) / results.length : 0,
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
