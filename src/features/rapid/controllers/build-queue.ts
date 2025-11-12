import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

import type { FactCard, QueueOptions } from '../types';
import { getFactCards, getFactCardsByTopic } from './get-fact-cards';

export async function buildQueue(userId: string, options: QueueOptions): Promise<FactCard[]> {
  const supabase = await createSupabaseServerClient();
  const maxCards = options.maxCards ?? 20;

  let cards: FactCard[];

  // Strategy 1: Build queue from topic
  if (options.topicKey) {
    cards = await getFactCardsByTopic(options.topicKey);
  }
  // Strategy 2: Build queue from card group IDs
  else if (options.cardGroupIds && options.cardGroupIds.length > 0) {
    cards = await getFactCards({ cardGroupIds: options.cardGroupIds });
  }
  // Strategy 3: Get all cards (fallback)
  else {
    cards = await getFactCards();
  }

  // Join with user_fact_stats
  const cardIds = cards.map((c) => c.id);

  if (cardIds.length === 0) {
    return [];
  }

  const { data: stats } = await supabase
    .from('user_fact_stats')
    .select('*')
    .eq('user_id', userId)
    .in('fact_id', cardIds);

  const statsMap = new Map(stats?.map((s) => [s.fact_id, s]) || []);

  // Score and prioritize cards
  const scored = cards.map((card) => {
    const stat = statsMap.get(card.id);
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

  return scored.slice(0, maxCards).map(({ card }) => card);
}
