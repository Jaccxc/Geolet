import { createClient } from '@/libs/supabase/supabase-server-client';
import type { FactCard, GameMode, QueueOptions } from '../types';

export async function buildQueue(
  userId: string,
  options: QueueOptions
): Promise<FactCard[]> {
  const supabase = await createClient();
  const maxCards = options.maxCards ?? 20;

  // Determine fact type from mode
  const factType = modeToFactType(options.mode);

  // Build query with left join to get user stats
  let query = supabase
    .from('fact_cards')
    .select(
      `
      *,
      user_fact_stats!left (
        seen,
        correct,
        due_at
      )
    `
    )
    .eq('type', factType);

  // Filter by tags if specified
  if (options.targetTags && options.targetTags.length > 0) {
    query = query.overlaps('primary_tags', options.targetTags);
  }

  const { data, error } = await query;
  if (error) throw error;

  // Score and prioritize cards
  const scored = data.map((card) => {
    const stat = card.user_fact_stats?.[0];
    let score = 0;

    // Prioritize due cards (highest priority)
    if (stat?.due_at && new Date(stat.due_at) <= new Date()) {
      score += 1000;
    }

    // Prioritize unseen cards (high priority)
    if (!stat || stat.seen === 0) {
      score += 500;
    }

    // Prioritize cards with low accuracy (medium priority)
    if (stat && stat.seen > 0) {
      const accuracy = stat.correct / stat.seen;
      score += (1 - accuracy) * 100;
    }

    // Add randomness for variety
    score += Math.random() * 10;

    return { card, score };
  });

  // Sort by score (descending) and take maxCards
  scored.sort((a, b) => b.score - a.score);

  return scored.slice(0, maxCards).map(({ card }) => {
    // Remove user_fact_stats from result to avoid leaking answers
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
