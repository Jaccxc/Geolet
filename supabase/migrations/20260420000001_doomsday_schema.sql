-- ============================================
-- DOOMSDAY DRILLS — SCHEMA EXTENSION
-- Date: 2026-04-20
-- Purpose: Support programmatic (non-geo) fact cards for Doomsday drills
-- ============================================

-- ============================================
-- PART 1: EXTEND fact_cards
-- ============================================

-- 1a. Make answer_region_id nullable
--     Existing geo cards always have a value; new doomsday cards will have NULL.
ALTER TABLE fact_cards
  ALTER COLUMN answer_region_id DROP NOT NULL;

-- 1b. Add card_type discriminator
--     Values: 'geo' (default) | 'doomsday_month' | 'doomsday_year_template'
--             | 'doomsday_anchor_template' | 'doomsday_full_template'
ALTER TABLE fact_cards
  ADD COLUMN card_type text NOT NULL DEFAULT 'geo';

-- 1c. Add card_params for doomsday metadata
--     geo cards: NULL
--     doomsday_month: {"month": 1..12, "canonical_anchor": N, "is_leap": bool}
--     doomsday_year_template: {"year_range": [lo, hi]}
--     doomsday_anchor_template: {}
--     doomsday_full_template: {"year_range": [lo, hi]}
ALTER TABLE fact_cards
  ADD COLUMN card_params jsonb;

-- 1d. Enforce: geo cards must still have answer_region_id
ALTER TABLE fact_cards
  ADD CONSTRAINT fact_cards_geo_requires_region
  CHECK (
    card_type != 'geo' OR answer_region_id IS NOT NULL
  );

-- 1e. Index for filtering by card_type
CREATE INDEX fact_cards_card_type_idx ON fact_cards (card_type);

COMMENT ON COLUMN fact_cards.card_type IS
  'geo | doomsday_month | doomsday_year_template | doomsday_anchor_template | doomsday_full_template';

COMMENT ON COLUMN fact_cards.card_params IS
  'Doomsday cards: {"month", "canonical_anchor"} for month cards; {"year_range"} for year/full templates';

-- ============================================
-- PART 2: EXTEND topics
-- ============================================

-- 2a. Add queue_mode: tells the client which API mode to use for this topic.
--     Default 'pick' preserves all existing topics.
ALTER TABLE topics
  ADD COLUMN queue_mode text NOT NULL DEFAULT 'pick';

COMMENT ON COLUMN topics.queue_mode IS
  'API mode to use when requesting queue: pick | map | doomsday';

-- ============================================
-- DONE
-- ============================================

DO $$
BEGIN
  RAISE NOTICE '✅ Doomsday schema migration complete!';
  RAISE NOTICE '   - fact_cards.answer_region_id is now nullable';
  RAISE NOTICE '   - fact_cards.card_type column added (default: geo)';
  RAISE NOTICE '   - fact_cards.card_params column added';
  RAISE NOTICE '   - topics.queue_mode column added (default: pick)';
  RAISE NOTICE '';
  RAISE NOTICE '📋 Next: apply 20260420000002_doomsday_seed.sql';
END $$;
