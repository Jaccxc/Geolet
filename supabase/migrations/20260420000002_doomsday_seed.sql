-- ============================================
-- DOOMSDAY DRILLS — SEED DATA
-- Date: 2026-04-20
-- Topics: 7  |  Card Groups: 7  |  Cards: 14 static + 6 templates = 20
-- ============================================

-- ============================================
-- PART 1: CARD GROUPS
-- ============================================

INSERT INTO card_groups (name) VALUES
  ('Doomsday Drill 1 - Month Codes'),
  ('Doomsday Drill 2 - Year Code Basic'),
  ('Doomsday Drill 2.1 - Year Code 21st Century'),
  ('Doomsday Drill 2.5 - Year Code 19th Century'),
  ('Doomsday Drill 2.99 - Year Code All'),
  ('Doomsday Drill 3 - Anchor Date Proximity'),
  ('Doomsday Drill 4 - Full Chain');

-- ============================================
-- PART 2: TOPICS
-- ============================================

INSERT INTO topics (key, title, description, icon, pick_mode_active, map_mode_active, difficulty, queue_mode, target_card_group_ids)
VALUES
  (
    'doomsday-drill-1',
    'Doomsday Drill 1 — Month Codes',
    'Master the anchor date for each month. Given a month, instantly name a date that always falls on Doomsday.',
    'Calendar',
    true, false, 'beginner', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes')]
  ),
  (
    'doomsday-drill-2',
    'Doomsday Drill 2 — Year Code Basic',
    'Calculate the Doomsday for years 2000–2030. Uses the 21st century anchor: Tuesday.',
    'CalendarClock',
    true, false, 'beginner', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2 - Year Code Basic')]
  ),
  (
    'doomsday-drill-2-1',
    'Doomsday Drill 2.1 — Year Code 21st Century',
    'Extend your year-code speed to any year from 2000 to 2099.',
    'CalendarClock',
    true, false, 'intermediate', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.1 - Year Code 21st Century')]
  ),
  (
    'doomsday-drill-2-5',
    'Doomsday Drill 2.5 — Year Code 19th Century',
    'Year codes for 1900–1999. Uses the 20th century anchor: Wednesday.',
    'CalendarClock',
    true, false, 'intermediate', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.5 - Year Code 19th Century')]
  ),
  (
    'doomsday-drill-2-99',
    'Doomsday Drill 2.99 — Year Code All Centuries',
    'Full year code drill across any century from 1582 to 2099. Century anchor calculation included.',
    'CalendarRange',
    true, false, 'advanced', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.99 - Year Code All')]
  ),
  (
    'doomsday-drill-3',
    'Doomsday Drill 3 — Anchor Date Proximity',
    'Given a date, calculate how many days away it is from the nearest Doomsday anchor. Builds the last-mile reflex.',
    'Crosshair',
    true, false, 'intermediate', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 3 - Anchor Date Proximity')]
  ),
  (
    'doomsday-drill-4',
    'Doomsday Drill 4 — Full Chain',
    'End-to-end: given any date, calculate the exact day of the week. Chain all three steps at speed.',
    'Link',
    true, false, 'advanced', 'doomsday',
    ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 4 - Full Chain')]
  );

-- ============================================
-- PART 3: FACT CARDS — DRILL 1 (Month Codes)
-- 14 cards: 12 regular months + Jan Leap + Feb Leap
-- card_type: 'doomsday_month'
-- answer_region_id: NULL (doomsday card)
-- card_params: {"month": N, "canonical_anchor": D, "is_leap": bool}
-- The queue builder picks one valid Doomsday date per session (anchor ± 7n).
-- ============================================

INSERT INTO fact_cards (card_group_id, card_type, card_params, prompt, hint, primary_skill_tags, difficulty)
VALUES
  -- January (non-leap): anchor = 3. Valid dates: 3, 10, 17, 24, 31
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 1, "canonical_anchor": 3, "is_leap": false}',
    'January',
    'The anchor is January 3rd (non-leap years). Doomsday falls every 7 days from there.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- January (leap): anchor = 4. Valid dates: 4, 11, 18, 25
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 1, "canonical_anchor": 4, "is_leap": true}',
    'January (Leap Year)',
    'In a leap year, the January anchor shifts to the 4th. Doomsday falls every 7 days from there.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- February (non-leap): anchor = 28. Valid dates: 7, 14, 21, 28
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 2, "canonical_anchor": 28, "is_leap": false}',
    'February',
    'The last day of February is always a Doomsday. Doomsday falls every 7 days from the 28th backwards.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- February (leap): anchor = 29. Valid dates: 1, 8, 15, 22, 29
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 2, "canonical_anchor": 29, "is_leap": true}',
    'February (Leap Year)',
    'In a leap year, February 29th is the Doomsday anchor. Doomsday falls every 7 days from there.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- March: anchor = 7. Valid dates: 7, 14, 21, 28
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 3, "canonical_anchor": 7, "is_leap": false}',
    'March',
    'March 7th is the anchor — every 7th day in March is a Doomsday (7, 14, 21, 28).',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- April: anchor = 4. Valid dates: 4, 11, 18, 25
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 4, "canonical_anchor": 4, "is_leap": false}',
    'April',
    '4/4 — April 4th is a Doomsday. Even months share their date with their month number.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- May: anchor = 9. Valid dates: 2, 9, 16, 23, 30
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 5, "canonical_anchor": 9, "is_leap": false}',
    'May',
    '"I work 9-to-5 at the 7-Eleven" — May 9th is a Doomsday.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- June: anchor = 6. Valid dates: 6, 13, 20, 27
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 6, "canonical_anchor": 6, "is_leap": false}',
    'June',
    '6/6 — June 6th is a Doomsday.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- July: anchor = 11. Valid dates: 4, 11, 18, 25
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 7, "canonical_anchor": 11, "is_leap": false}',
    'July',
    '"7-Eleven" — July 11th is a Doomsday.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- August: anchor = 8. Valid dates: 1, 8, 15, 22, 29
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 8, "canonical_anchor": 8, "is_leap": false}',
    'August',
    '8/8 — August 8th is a Doomsday.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- September: anchor = 5. Valid dates: 5, 12, 19, 26
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 9, "canonical_anchor": 5, "is_leap": false}',
    'September',
    '"9-to-5" — September 5th is a Doomsday.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- October: anchor = 10. Valid dates: 3, 10, 17, 24, 31
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 10, "canonical_anchor": 10, "is_leap": false}',
    'October',
    '10/10 — October 10th is a Doomsday.',
    ARRAY['doomsday:month'],
    '1'
  ),
  -- November: anchor = 7. Valid dates: 7, 14, 21, 28
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 11, "canonical_anchor": 7, "is_leap": false}',
    'November',
    '"11/7" — November 7th is a Doomsday.',
    ARRAY['doomsday:month'],
    '2'
  ),
  -- December: anchor = 12. Valid dates: 5, 12, 19, 26
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
    'doomsday_month',
    '{"month": 12, "canonical_anchor": 12, "is_leap": false}',
    'December',
    '12/12 — December 12th is a Doomsday.',
    ARRAY['doomsday:month'],
    '1'
  );

-- ============================================
-- PART 4: FACT CARDS — DRILLS 2–4 (Templates)
-- One template card per drill. Queue builder generates a random instance each session.
-- card_type: 'doomsday_year_template' | 'doomsday_anchor_template' | 'doomsday_full_template'
-- answer_region_id: NULL
-- ============================================

INSERT INTO fact_cards (card_group_id, card_type, card_params, prompt, hint, primary_skill_tags, difficulty)
VALUES
  -- Drill 2 Basic: years 2000-2030
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2 - Year Code Basic'),
    'doomsday_year_template',
    '{"year_range": [2000, 2030]}',
    'TEMPLATE: Year Code 2000-2030',
    'Century anchor for 2000s = Tuesday (2). Formula: y=last2digits, a=y÷12, b=y mod 12, c=b÷4, code=(a+b+c) mod 7.',
    ARRAY['doomsday:year'],
    '1'
  ),
  -- Drill 2.1: full 21st century
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.1 - Year Code 21st Century'),
    'doomsday_year_template',
    '{"year_range": [2000, 2099]}',
    'TEMPLATE: Year Code 2000-2099',
    'Century anchor for 2000s = Tuesday (2). Full range — includes harder year offsets.',
    ARRAY['doomsday:year'],
    '2'
  ),
  -- Drill 2.5: 20th century
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.5 - Year Code 19th Century'),
    'doomsday_year_template',
    '{"year_range": [1900, 1999]}',
    'TEMPLATE: Year Code 1900-1999',
    'Century anchor for 1900s = Wednesday (3). Same formula, different starting point.',
    ARRAY['doomsday:year'],
    '2'
  ),
  -- Drill 2.99: all centuries
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.99 - Year Code All'),
    'doomsday_year_template',
    '{"year_range": [1582, 2099]}',
    'TEMPLATE: Year Code Any Century',
    'Must also compute the century anchor: anchor = (5 × (century mod 4) + 2) mod 7.',
    ARRAY['doomsday:year'],
    '3'
  ),
  -- Drill 3: anchor date proximity (offset)
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 3 - Anchor Date Proximity'),
    'doomsday_anchor_template',
    '{"year_range": [1900, 2099]}',
    'TEMPLATE: Anchor Date Proximity',
    'Find the nearest Doomsday anchor in the month, then count the offset (−3 to +3).',
    ARRAY['doomsday:anchor'],
    '2'
  ),
  -- Drill 4: full chain
  (
    (SELECT id FROM card_groups WHERE name = 'Doomsday Drill 4 - Full Chain'),
    'doomsday_full_template',
    '{"year_range": [1900, 2099]}',
    'TEMPLATE: Full Chain',
    'Chain: century anchor → year code → month anchor → offset → day of week.',
    ARRAY['doomsday:full'],
    '3'
  );

-- ============================================
-- DONE
-- ============================================

DO $$
BEGIN
  RAISE NOTICE '✅ Doomsday seed migration complete!';
  RAISE NOTICE '   - 7 card groups created';
  RAISE NOTICE '   - 7 topics created (pick mode only, queue_mode = doomsday)';
  RAISE NOTICE '   - 14 static Drill 1 month cards created';
  RAISE NOTICE '   - 6 template cards created (Drills 2-4)';
  RAISE NOTICE '';
  RAISE NOTICE '📋 Next: run npm run migration:up to regenerate TypeScript types';
END $$;
