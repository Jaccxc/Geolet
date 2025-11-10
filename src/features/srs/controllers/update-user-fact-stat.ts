import { createClient } from '@/libs/supabase/supabase-server-client';
import { calculateNextInterval, addDays } from './calculate-next-interval';
import type { SRSUpdateInput, SRSUpdateResult } from '../types';

export async function updateUserFactStat(
  userId: string,
  input: SRSUpdateInput
): Promise<SRSUpdateResult> {
  const supabase = await createClient();

  // Determine if answer was correct and calculate quality
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
  await supabase.from('user_fact_stats').upsert({
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
