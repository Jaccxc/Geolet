-- ============================================
-- ADD use_country_region TO TOPICS
-- ============================================
-- Date: 2025-11-13
-- Purpose: Allow topics to configure pick mode to use country-level regions
--          instead of the answer region for city/province cards
-- ============================================

-- Add the use_country_region column
alter table topics
add column use_country_region boolean not null default false;

-- Add comment explaining the feature
comment on column topics.use_country_region is
'When true, pick mode will display the country of the answer region instead of the answer region itself.
Useful for city-level cards where the prompt is the city name - prevents answer from being revealed.
Example: For a card with answer_region "GB:London", pick mode will show "United Kingdom" as the option.';

-- ============================================
-- VERIFICATION
-- ============================================

do $$
begin
  raise notice '✅ Added use_country_region to topics table';
  raise notice '';
  raise notice 'Usage:';
  raise notice '  - Set use_country_region = true for topics with city/province cards';
  raise notice '  - Pick mode will fetch region.country, then find the country region by key';
  raise notice '  - Answer validation still uses the original answer_region_id';
  raise notice '';
  raise notice 'Example:';
  raise notice '  UPDATE topics SET use_country_region = true WHERE key = ''watg24-cities'';';
end $$;
