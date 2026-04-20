# Doomsday Drills — Implementation Plan

**Created:** 2026-04-20  
**Author:** Jacc Peng (via Claude Code)  
**Status:** Proposed — awaiting approval before any code execution

---

## 1. Feature Overview

Add 7 new topics to Geolet implementing the Doomsday algorithm as progressive drills:

| #   | Topic Key             | Title                                                   | Cards      | Mode |
| --- | --------------------- | ------------------------------------------------------- | ---------- | ---- |
| 1   | `doomsday-drill-1`    | Doomsday Drill 1 — Month Codes                          | 12 static  | Pick |
| 2   | `doomsday-drill-2`    | Doomsday Drill 2 — Year Code Basic (2000–2030)          | 1 template | Pick |
| 3   | `doomsday-drill-2-1`  | Doomsday Drill 2.1 — Year Code 21st Century (2000–2099) | 1 template | Pick |
| 4   | `doomsday-drill-2-5`  | Doomsday Drill 2.5 — Year Code 19th Century (1900–1999) | 1 template | Pick |
| 5   | `doomsday-drill-2-99` | Doomsday Drill 2.99 — Year Code All (1582–2099)         | 1 template | Pick |
| 6   | `doomsday-drill-3`    | Doomsday Drill 3 — Anchor Date Proximity                | 1 template | Pick |
| 7   | `doomsday-drill-4`    | Doomsday Drill 4 — Full Chain                           | 1 template | Pick |

All drills are **pick mode only** — no map mode. Answers are computed values, not geographic regions.

---

## 2. The Core Problem: `answer_region_id NOT NULL`

### Current Constraint

```sql
-- supabase/migrations/20251112180204_fresh_schema.sql:190
answer_region_id uuid NOT NULL references regions(id) on delete restrict,
```

`fact_cards.answer_region_id` is a **non-nullable foreign key**. Every card must point to a geographic region. For Doomsday, the "answer" is a computed value (day name, anchor date, offset) — not a region.

### Option A: Sentinel Region (Rejected)

Create a special fake region `key = 'DOOMSDAY:SENTINEL'`. When `answer_region_id` points to it, route to the doomsday validator.

**Why rejected:** The answer itself (e.g., "Tuesday" or "April 4") has no natural home — it would have to be shoehorned into `hint` or a new JSON column. Pick options generation would still break (it queries regions by level). Deeply hacky.

### Option B: Nullable FK + `card_type` column (Chosen)

Make `answer_region_id` nullable. Add two new columns:

- `card_type text NOT NULL DEFAULT 'geo'` — discriminator (`'geo'` | `'doomsday_month'` | `'doomsday_year_template'` | `'doomsday_anchor_template'` | `'doomsday_full_template'`)
- `card_params jsonb` — stores question parameters for doomsday cards (e.g., `{"month": 3}` or `{"year_range": [2000, 2030]}`)

**Why chosen:** Explicit, queryable, backwards compatible (all existing `'geo'` cards are unaffected since they always have `answer_region_id`). Template cards use `card_params` to generate random instances at queue time; static cards use `card_params` to store the fixed fact.

---

## 3. Doomsday Algorithm Reference

The algorithm is implemented in a pure-function model module. All server-side computation, no client trust needed for static cards.

### Month Anchor Dates (Drill 1)

The dates in each month that always fall on Doomsday:

| Month | Anchor Date(s)           | Mnemonic        |
| ----- | ------------------------ | --------------- |
| Jan   | 3 (non-leap), 4 (leap)   | —               |
| Feb   | 28 (non-leap), 29 (leap) | Last day of Feb |
| Mar   | 7, 14, 21, 28            | Every 7 days    |
| Apr   | 4                        | 4/4             |
| May   | 9                        | 9-5 at 7-Eleven |
| Jun   | 6                        | 6/6             |
| Jul   | 11                       | 7-Eleven        |
| Aug   | 8                        | 8/8             |
| Sep   | 5                        | 9/5             |
| Oct   | 10                       | 10/10           |
| Nov   | 7                        | 11/7            |
| Dec   | 12                       | 12/12           |

### Century Anchors (used in Drill 2)

```
century = floor(year / 100)
anchor = (5 * (century % 4) + 2) % 7
```

| Century | Anchor | Day       |
| ------- | ------ | --------- |
| 1800s   | 5      | Friday    |
| 1900s   | 3      | Wednesday |
| 2000s   | 2      | Tuesday   |
| 2100s   | 0      | Sunday    |

### Year Code (within century, Drill 2)

```
y = year % 100
a = floor(y / 12)
b = y % 12
c = floor(b / 4)
year_code = (a + b + c) % 7
```

### Full Doomsday Calculation (Drill 4)

```
doomsday_for_year = (century_anchor + year_code) % 7
nearest_anchor = find nearest doomsday anchor date in same month
offset = target_day - nearest_anchor_day
day_of_week = (doomsday_for_year + offset + 700) % 7  // +700 ensures positive
```

Days: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday.

---

## 4. Architecture Decisions

### 4.1 Static vs Template Cards

| Card Behavior | Used For                        | SRS Tracking                                                |
| ------------- | ------------------------------- | ----------------------------------------------------------- |
| **Static**    | Drill 1 (12 month anchor cards) | Per-month card ID                                           |
| **Template**  | Drills 2–4                      | Per-template card ID (tracks skill level at the range/type) |

Template cards generate a **random instance** at queue time. The generated prompt + expected answer travel to the client as part of the queue item. The grade endpoint trusts the `question_params` echoed back from the client to re-derive the correct answer (acceptable for a self-improvement app — users only cheat themselves).

### 4.2 New Game Mode: `'doomsday'`

Rather than shoehorning doomsday into the existing `'pick'` mode path (which would require threading doomsday detection through multiple controllers), we add a clean parallel path:

- Queue: `mode: 'doomsday'` → new `buildDoomsdayQueue` controller → returns `DoomsdayQueueItem[]`
- Grade: `mode: 'doomsday'` → new grading branch → uses `validateDoomsdayAnswer()`

Existing `'pick'` and `'map'` paths are completely untouched.

### 4.3 Answer Representation

For doomsday, "options" are numeric day codes (0–6) or specific dates, not region UUIDs. A new type `DoomsdayOption` replaces `PickOption` for this mode:

```ts
interface DoomsdayOption {
  value: string; // e.g., "0" for Sunday, "4" for April 4
  label: string; // "Sunday", "April 4", "Wednesday", etc.
  correct: boolean;
}
```

---

## 5. Compatibility Checklist

| File/Component                                | Compatibility Issue                                  | Resolution                                                                                          |
| --------------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `fact_cards.answer_region_id`                 | NOT NULL, FK to regions                              | Migrate to nullable                                                                                 |
| `factCardSchema` (types.ts:101)               | `z.string().uuid()`                                  | Change to `z.string().uuid().nullable()`                                                            |
| `FactCard.answer_region` in `getFactCardById` | JOIN fails if null FK                                | Supabase handles nullable FK joins returning null — OK, but update TypeScript type                  |
| `generatePickOptions` (line 19)               | Uses `card.answer_region_id` directly                | Add early return: if `card.card_type !== 'geo'` throw or skip — but doomsday queue never calls this |
| `getAnswerRegion` (line 14)                   | Crashes if `answer_region_id` null                   | Add guard — but doomsday queue never calls this either                                              |
| `validatePickAnswer` (answer-validator.ts:9)  | Compares two UUIDs                                   | Not called for doomsday — new path uses `validateDoomsdayAnswer`                                    |
| `/api/rapid/queue` route                      | Calls `generatePickOptions(card)` for all pick cards | New `mode: 'doomsday'` branch routes to `buildDoomsdayQueue` before existing logic                  |
| `/api/rapid/grade` route                      | `requestSchema` only accepts `pick\|map`             | Extend schema; add `doomsday` branch before existing grade logic                                    |
| `PickCard` component                          | Expects `region_id` key per option                   | Not reused for doomsday — new `DoomsdayPickCard` component                                          |
| `GameScreen` component                        | Handles `PickQueueItem\|MapQueueItem`                | Add `DoomsdayQueueItem` handling                                                                    |
| `topics.ts` config                            | Hardcoded topic list                                 | Add 7 doomsday entries                                                                              |
| `skill_family_enum` (Postgres)                | No `'doomsday'` value                                | No change needed — `primary_skill_tags` is `text[]`, not tied to enum                               |

---

## 6. File Changes Map

### New Files

```
src/features/rapid/models/doomsday-calculator.ts        # Pure algorithm functions
src/features/rapid/controllers/build-doomsday-queue.ts  # Queue builder for doomsday cards
src/features/rapid/components/doomsday-pick-card.tsx     # UI: doomsday multiple choice
supabase/migrations/20260420000001_doomsday_schema.sql  # DB: nullable FK + new columns
supabase/migrations/20260420000002_doomsday_seed.sql    # DB: card groups, topics, cards
plans/doomsday-drills-plan-20260420.md                   # This document
```

### Modified Files

```
src/features/rapid/types.ts                    # New types + relax answer_region_id nullable
src/app/api/rapid/queue/route.ts               # Add doomsday mode branch
src/app/api/rapid/grade/route.ts               # Add doomsday mode branch
src/features/rapid/models/answer-validator.ts  # Add validateDoomsdayAnswer()
src/features/rapid/components/game-screen.tsx  # Handle DoomsdayQueueItem
src/features/rapid/config/topics.ts            # Add 7 doomsday topics
```

---

## 7. Detailed Implementation Steps

### Step 1 — DB Migration: Schema

**File:** `supabase/migrations/20260420000001_doomsday_schema.sql`

```sql
-- 1. Make answer_region_id nullable (drop NOT NULL, keep FK)
ALTER TABLE fact_cards
  ALTER COLUMN answer_region_id DROP NOT NULL;

-- 2. Add card_type discriminator
ALTER TABLE fact_cards
  ADD COLUMN card_type text NOT NULL DEFAULT 'geo';

-- 3. Add card_params for doomsday metadata
ALTER TABLE fact_cards
  ADD COLUMN card_params jsonb;

-- 4. Add check constraint: geo cards must have answer_region_id
ALTER TABLE fact_cards
  ADD CONSTRAINT fact_cards_geo_requires_region
  CHECK (
    card_type != 'geo' OR answer_region_id IS NOT NULL
  );

-- 5. Index for fast filtering by card_type
CREATE INDEX fact_cards_card_type_idx ON fact_cards (card_type);

COMMENT ON COLUMN fact_cards.card_type IS
  'geo | doomsday_month | doomsday_year_template | doomsday_anchor_template | doomsday_full_template';

COMMENT ON COLUMN fact_cards.card_params IS
  'For doomsday_month: {"month": 1..12}. For templates: {"year_range": [lo, hi]}, {"date_range": [lo, hi]}';
```

> **Note on check constraint:** The `CHECK` constraint enforces that existing geo cards still require `answer_region_id`. New doomsday cards with `card_type != 'geo'` are allowed null.

---

### Step 2 — DB Migration: Seed Data

**File:** `supabase/migrations/20260420000002_doomsday_seed.sql`

#### 2a. Card Groups (7 new)

```sql
INSERT INTO card_groups (name) VALUES
  ('Doomsday Drill 1 - Month Codes'),
  ('Doomsday Drill 2 - Year Code Basic'),
  ('Doomsday Drill 2.1 - Year Code 21st Century'),
  ('Doomsday Drill 2.5 - Year Code 19th Century'),
  ('Doomsday Drill 2.99 - Year Code All'),
  ('Doomsday Drill 3 - Anchor Date Proximity'),
  ('Doomsday Drill 4 - Full Chain');
```

#### 2b. Topics (7 new, pick only)

```sql
INSERT INTO topics (key, title, description, icon, pick_mode_active, map_mode_active, difficulty, target_card_group_ids)
VALUES
  ('doomsday-drill-1',
   'Doomsday Drill 1 — Month Codes',
   'Memorize the anchor date for each month. Given a month, instantly recall which date always falls on Doomsday.',
   'Calendar',
   true, false, 'beginner',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes')]),

  ('doomsday-drill-2',
   'Doomsday Drill 2 — Year Code Basic (2000–2030)',
   'Calculate the Doomsday for years 2000–2030 using the 21st century anchor (Tuesday).',
   'CalendarClock',
   true, false, 'beginner',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2 - Year Code Basic')]),

  ('doomsday-drill-2-1',
   'Doomsday Drill 2.1 — Year Code 21st Century',
   'Extend your year-code speed to any year in the 2000s.',
   'CalendarClock',
   true, false, 'intermediate',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.1 - Year Code 21st Century')]),

  ('doomsday-drill-2-5',
   'Doomsday Drill 2.5 — Year Code 19th Century',
   'Year codes for 1900–1999 using the 20th century anchor (Wednesday).',
   'CalendarClock',
   true, false, 'intermediate',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.5 - Year Code 19th Century')]),

  ('doomsday-drill-2-99',
   'Doomsday Drill 2.99 — Year Code All Centuries',
   'Full year code calculation from 1582 to 2099 — any century, any year.',
   'CalendarRange',
   true, false, 'advanced',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2.99 - Year Code All')]),

  ('doomsday-drill-3',
   'Doomsday Drill 3 — Anchor Date Proximity',
   'Given a date, identify the nearest Doomsday anchor in that month.',
   'Crosshair',
   true, false, 'intermediate',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 3 - Anchor Date Proximity')]),

  ('doomsday-drill-4',
   'Doomsday Drill 4 — Full Chain',
   'End-to-end: given any date, calculate the exact day of the week.',
   'Link',
   true, false, 'advanced',
   ARRAY[(SELECT id FROM card_groups WHERE name = 'Doomsday Drill 4 - Full Chain')]);
```

#### 2c. Fact Cards

**Drill 1 — 12 static month-anchor cards:**

```sql
-- The prompt asks which date in that month is a Doomsday anchor.
-- card_params stores the canonical anchor date (or multiple if month has several).
-- answer_region_id is NULL (permitted since card_type != 'geo').

INSERT INTO fact_cards (card_group_id, card_type, card_params, prompt, hint, primary_skill_tags, difficulty)
VALUES
  ((SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
   'doomsday_month', '{"month": 1, "anchor": 3, "anchor_leap": 4}',
   'January',
   'Hint: The 3rd day is the anchor (4th in a leap year)',
   ARRAY['doomsday:month'], '1'),

  ((SELECT id FROM card_groups WHERE name = 'Doomsday Drill 1 - Month Codes'),
   'doomsday_month', '{"month": 2, "anchor": 28, "anchor_leap": 29}',
   'February',
   'Hint: The last day of February is always a Doomsday',
   ARRAY['doomsday:month'], '1'),

  -- March through December similarly:
  ((SELECT id ...), 'doomsday_month', '{"month": 3, "anchor": 7}',
   'March', 'Hint: Every 7th day from the 7th (7, 14, 21, 28)', ARRAY['doomsday:month'], '1'),

  ((SELECT id ...), 'doomsday_month', '{"month": 4, "anchor": 4}',
   'April', 'Hint: 4/4 — even month, same date', ARRAY['doomsday:month'], '1'),

  ((SELECT id ...), 'doomsday_month', '{"month": 5, "anchor": 9}',
   'May', 'Hint: "I work 9-to-5 at the 7-Eleven" — May 9', ARRAY['doomsday:month'], '2'),

  ((SELECT id ...), 'doomsday_month', '{"month": 6, "anchor": 6}',
   'June', 'Hint: 6/6 — even month, same date', ARRAY['doomsday:month'], '1'),

  ((SELECT id ...), 'doomsday_month', '{"month": 7, "anchor": 11}',
   'July', 'Hint: "7-Eleven" — July 11', ARRAY['doomsday:month'], '2'),

  ((SELECT id ...), 'doomsday_month', '{"month": 8, "anchor": 8}',
   'August', 'Hint: 8/8 — even month, same date', ARRAY['doomsday:month'], '1'),

  ((SELECT id ...), 'doomsday_month', '{"month": 9, "anchor": 5}',
   'September', 'Hint: "9-to-5" — September 5', ARRAY['doomsday:month'], '2'),

  ((SELECT id ...), 'doomsday_month', '{"month": 10, "anchor": 10}',
   'October', 'Hint: 10/10 — even month, same date', ARRAY['doomsday:month'], '1'),

  ((SELECT id ...), 'doomsday_month', '{"month": 11, "anchor": 7}',
   'November', 'Hint: "7-Eleven" — November 7', ARRAY['doomsday:month'], '2'),

  ((SELECT id ...), 'doomsday_month', '{"month": 12, "anchor": 12}',
   'December', 'Hint: 12/12 — even month, same date', ARRAY['doomsday:month'], '1');
```

> Note: The SQL above is illustrative. The full migration will use a single INSERT...VALUES block with all card group ID subqueries.

**Drills 2–4 — Template cards (1 each):**

```sql
-- Drill 2 Basic: year range 2000-2030
INSERT INTO fact_cards (card_group_id, card_type, card_params, prompt, hint, primary_skill_tags, difficulty)
VALUES
  ((SELECT id FROM card_groups WHERE name = 'Doomsday Drill 2 - Year Code Basic'),
   'doomsday_year_template',
   '{"year_range": [2000, 2030], "century": 2000}',
   'TEMPLATE: Year Code 2000-2030',
   'Century anchor for 2000s: Tuesday (2)',
   ARRAY['doomsday:year'], '1');

-- Drill 2.1: 2000-2099
INSERT INTO fact_cards ... '{"year_range": [2000, 2099], "century": 2000}' ...

-- Drill 2.5: 1900-1999
INSERT INTO fact_cards ... '{"year_range": [1900, 1999], "century": 1900}' ...

-- Drill 2.99: all centuries 1582-2099
INSERT INTO fact_cards ... '{"year_range": [1582, 2099]}' ...

-- Drill 3: Anchor proximity
INSERT INTO fact_cards ... 'doomsday_anchor_template', '{}' ...

-- Drill 4: Full chain
INSERT INTO fact_cards ... 'doomsday_full_template', '{"year_range": [1900, 2099]}' ...
```

---

### Step 3 — New File: `doomsday-calculator.ts`

**File:** `src/features/rapid/models/doomsday-calculator.ts`

```ts
// Days: 0=Sun, 1=Mon, 2=Tue, 3=Wed, 4=Thu, 5=Fri, 6=Sat
export const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

// Month anchor dates (1-indexed months)
export const MONTH_ANCHORS: Record<number, number> = {
  1: 3, // Jan (non-leap; 4 in leap)
  2: 28, // Feb (non-leap; 29 in leap)
  3: 7,
  4: 4,
  5: 9,
  6: 6,
  7: 11,
  8: 8,
  9: 5,
  10: 10,
  11: 7,
  12: 12,
};

export function isLeapYear(year: number): boolean {
  return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
}

export function getMonthAnchor(month: number, year: number): number {
  if (month === 1) return isLeapYear(year) ? 4 : 3;
  if (month === 2) return isLeapYear(year) ? 29 : 28;
  return MONTH_ANCHORS[month];
}

export function getCenturyAnchor(year: number): number {
  const c = Math.floor(year / 100);
  return (5 * (c % 4) + 2) % 7;
}

export function getYearCode(year: number): number {
  const y = year % 100;
  const a = Math.floor(y / 12);
  const b = y % 12;
  const c = Math.floor(b / 4);
  return (a + b + c) % 7;
}

export function getDoomsdayForYear(year: number): number {
  return (getCenturyAnchor(year) + getYearCode(year)) % 7;
}

export function getDayOfWeek(year: number, month: number, day: number): number {
  const anchor = getMonthAnchor(month, year);
  const doomsday = getDoomsdayForYear(year);
  return (((doomsday + (day - anchor)) % 7) + 7) % 7;
}

export function getNearestMonthAnchor(month: number, day: number, year: number): number {
  // For months with multiple anchors (March: 7,14,21,28), find nearest
  const anchors = getMonthAnchors(month, year);
  return anchors.reduce((best, a) => (Math.abs(a - day) < Math.abs(best - day) ? a : best));
}

function getMonthAnchors(month: number, year: number): number[] {
  if (month === 3) return [7, 14, 21, 28];
  return [getMonthAnchor(month, year)];
}

// Generate random year in range (inclusive)
export function randomYear(lo: number, hi: number): number {
  return lo + Math.floor(Math.random() * (hi - lo + 1));
}

// Generate a random date in range
export function randomDate(yearLo: number, yearHi: number): { year: number; month: number; day: number } {
  const year = randomYear(yearLo, yearHi);
  const month = 1 + Math.floor(Math.random() * 12);
  const daysInMonth = new Date(year, month, 0).getDate();
  const day = 1 + Math.floor(Math.random() * daysInMonth);
  return { year, month, day };
}
```

---

### Step 4 — New File: `build-doomsday-queue.ts`

**File:** `src/features/rapid/controllers/build-doomsday-queue.ts`

```ts
import type { FactCard } from '../types';
import type { DoomsdayQueueItem } from '../types';
import {
  DAY_NAMES,
  getDoomsdayForYear,
  getDayOfWeek,
  getMonthAnchor,
  getNearestMonthAnchor,
  randomYear,
  randomDate,
} from '../models/doomsday-calculator';

export function buildDoomsdayQueueItem(card: FactCard): DoomsdayQueueItem {
  const params = card.card_params as Record<string, any>;

  switch (card.card_type) {
    case 'doomsday_month': {
      // Static: which date in this month is a Doomsday anchor?
      const month = params.month as number;
      const anchor = params.anchor as number;
      const MONTH_NAMES = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      // Options: anchor date + 5 plausible distractors
      const distractors = generateDateDistractors(anchor, month);
      const options = shuffle([
        { value: String(anchor), label: String(anchor), correct: true },
        ...distractors.map((d) => ({ value: String(d), label: String(d), correct: false })),
      ]);
      return {
        fact_id: card.id,
        card_type: card.card_type,
        prompt: `Which date in ${MONTH_NAMES[month]} always falls on Doomsday?`,
        hint: card.hint,
        difficulty: card.difficulty,
        question_params: { month, anchor },
        options,
      };
    }

    case 'doomsday_year_template': {
      // Dynamic: what day is the Doomsday for year X?
      const [lo, hi] = params.year_range as [number, number];
      const year = randomYear(lo, hi);
      const correctDay = getDoomsdayForYear(year);
      const options = buildDayOptions(correctDay);
      return {
        fact_id: card.id,
        card_type: card.card_type,
        prompt: `What day of the week is Doomsday for the year ${year}?`,
        hint: card.hint,
        difficulty: card.difficulty,
        question_params: { year },
        options,
      };
    }

    case 'doomsday_anchor_template': {
      // Dynamic: given a date, what is the nearest Doomsday anchor?
      const { year, month, day } = randomDate(1900, 2099);
      const nearestAnchor = getNearestMonthAnchor(month, day, year);
      const MONTH_NAMES = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      const distractors = generateDateDistractors(nearestAnchor, month);
      const options = shuffle([
        { value: String(nearestAnchor), label: `${MONTH_NAMES[month]} ${nearestAnchor}`, correct: true },
        ...distractors.map((d) => ({
          value: String(d),
          label: `${MONTH_NAMES[month]} ${d}`,
          correct: false,
        })),
      ]);
      return {
        fact_id: card.id,
        card_type: card.card_type,
        prompt: `Nearest Doomsday anchor to ${MONTH_NAMES[month]} ${day}, ${year}?`,
        hint: card.hint,
        difficulty: card.difficulty,
        question_params: { year, month, day, nearestAnchor },
        options,
      };
    }

    case 'doomsday_full_template': {
      // Dynamic: full chain — what day of week is this date?
      const [lo, hi] = (params.year_range as [number, number]) ?? [1900, 2099];
      const { year, month, day } = randomDate(lo, hi);
      const correctDay = getDayOfWeek(year, month, day);
      const MONTH_NAMES = [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      const options = buildDayOptions(correctDay);
      return {
        fact_id: card.id,
        card_type: card.card_type,
        prompt: `What day of the week is ${MONTH_NAMES[month]} ${day}, ${year}?`,
        hint: card.hint,
        difficulty: card.difficulty,
        question_params: { year, month, day },
        options,
      };
    }

    default:
      throw new Error(`Unknown doomsday card type: ${card.card_type}`);
  }
}

function buildDayOptions(correctDay: number): DoomsdayOption[] {
  return shuffle(DAY_NAMES.map((name, i) => ({ value: String(i), label: name, correct: i === correctDay })));
}

function generateDateDistractors(anchor: number, month: number): number[] {
  // Generate 5 plausible date distractors within 1-28 range
  const candidates: number[] = [];
  for (let d = 1; d <= 28; d++) {
    if (d !== anchor) candidates.push(d);
  }
  return shuffle(candidates).slice(0, 5);
}

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
```

---

### Step 5 — Type Updates

**File:** `src/features/rapid/types.ts`

```ts
// Relax answer_region_id to nullable
export const factCardSchema = z.object({
  // ... existing fields ...
  answer_region_id: z.string().uuid().nullable(), // was: z.string().uuid()
  card_type: z.string().default('geo'), // NEW
  card_params: z.record(z.any()).nullable().optional(), // NEW
});

// NEW: Doomsday option (replaces PickOption for doomsday mode)
export interface DoomsdayOption {
  value: string;
  label: string;
  correct: boolean;
}

// NEW: Doomsday queue item
export interface DoomsdayQueueItem {
  fact_id: string;
  card_type: string;
  prompt: string;
  hint: string | null;
  difficulty: FactDifficulty;
  question_params: Record<string, unknown>; // echoed back on grade
  options: DoomsdayOption[];
}

// NEW: Doomsday grade item
export interface DoomsdayGradeItem {
  fact_id: string;
  selected_value: string; // the option value user picked
  question_params: Record<string, unknown>; // echoed from queue item
  time_ms: number;
}
```

---

### Step 6 — Answer Validator Extension

**File:** `src/features/rapid/models/answer-validator.ts`

Add:

```ts
import { getDoomsdayForYear, getDayOfWeek, getMonthAnchor, getNearestMonthAnchor } from './doomsday-calculator';

export function validateDoomsdayAnswer(
  cardType: string,
  questionParams: Record<string, unknown>,
  selectedValue: string
): boolean {
  const selected = parseInt(selectedValue, 10);

  switch (cardType) {
    case 'doomsday_month': {
      const { anchor } = questionParams as { anchor: number };
      return selected === anchor;
    }
    case 'doomsday_year_template': {
      const { year } = questionParams as { year: number };
      return selected === getDoomsdayForYear(year);
    }
    case 'doomsday_anchor_template': {
      const { nearestAnchor } = questionParams as { nearestAnchor: number };
      return selected === nearestAnchor;
    }
    case 'doomsday_full_template': {
      const { year, month, day } = questionParams as { year: number; month: number; day: number };
      return selected === getDayOfWeek(year, month, day);
    }
    default:
      return false;
  }
}
```

---

### Step 7 — API Route: Queue

**File:** `src/app/api/rapid/queue/route.ts`

Extend `requestSchema`:

```ts
const requestSchema = z.object({
  mode: z.enum(['pick', 'map', 'doomsday']), // add 'doomsday'
  // ...
});
```

Add doomsday branch before existing pick/map logic:

```ts
if (mode === 'doomsday') {
  const cards = await buildQueue(user.id, { topicKey, cardGroupIds, maxCards });
  const queueItems: DoomsdayQueueItem[] = cards.map(buildDoomsdayQueueItem);
  return NextResponse.json({ mode, items: queueItems, total: queueItems.length });
}
```

---

### Step 8 — API Route: Grade

**File:** `src/app/api/rapid/grade/route.ts`

Extend `requestSchema`:

```ts
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
```

Add doomsday grading branch:

```ts
if (mode === 'doomsday') {
  // ...
  const doomsdayItem = item as DoomsdayGradeItem;
  correct = validateDoomsdayAnswer(card.card_type, doomsdayItem.question_params, doomsdayItem.selected_value);
}
```

---

### Step 9 — New UI Component

**File:** `src/features/rapid/components/doomsday-pick-card.tsx`

Similar structure to `PickCard` but:

- Accepts `options: DoomsdayOption[]` (value: string, label: string, correct: boolean)
- `onAnswer(selectedValue: string, timeMs: number)` callback
- Options displayed in a 2×3 or 2×4 grid depending on count (7 day options for Drills 2/4, 6 date options for Drills 1/3)
- Prompt and hint display identical to existing `PickCard`

---

### Step 10 — GameScreen Update

**File:** `src/features/rapid/components/game-screen.tsx`

- Accept `mode: 'pick' | 'map' | 'doomsday'` prop
- When `mode === 'doomsday'`, render `DoomsdayPickCard` instead of `PickCard`
- Pass `question_params` along with the answer on submission

---

### Step 11 — Topics Config Update

**File:** `src/features/rapid/config/topics.ts`

Add 7 entries to `PICK_MODE_TOPICS` (or a new `DOOMSDAY_TOPICS` export):

```ts
export const DOOMSDAY_TOPICS: TopicCardConfig[] = [
  {
    id: 'doomsday-drill-1',
    title: 'Doomsday Drill 1 — Month Codes',
    description: 'Which date in each month always falls on Doomsday?',
    icon: Calendar,
    mode: 'doomsday',
    difficulty: 'beginner',
    estimatedCards: 12,
  },
  // ... 6 more
];
```

---

## 8. Rollout Order

Execute these phases in order. Each phase is independently runnable.

```
Phase 1: DB migration (Steps 1-2)
         → apply 20260420000001_doomsday_schema.sql
         → apply 20260420000002_doomsday_seed.sql
         → run: npm run migration:up (regenerates types.ts)

Phase 2: Core model + types (Steps 3, 5)
         → src/features/rapid/models/doomsday-calculator.ts (new)
         → src/features/rapid/types.ts (relax answer_region_id, add new types)

Phase 3: Server-side controllers (Steps 4, 6, 7, 8)
         → build-doomsday-queue.ts (new)
         → answer-validator.ts (extend)
         → queue/route.ts (extend)
         → grade/route.ts (extend)

Phase 4: Frontend (Steps 9, 10, 11)
         → doomsday-pick-card.tsx (new)
         → game-screen.tsx (extend)
         → topics.ts (extend)
```

---

## 9. Open Questions / Decisions Needed

1. **Drill 1 option count**: Month anchor cards could show 6 options (the canonical anchor + 5 distractors). For months with multiple anchors (March: 7, 14, 21, 28), do we ask "what is the _smallest_ anchor in March?" or just "what is _a_ Doomsday anchor in March?"

Answer from Jacc(author): It should be which one of these is the doomsday anchor in March? and you should display ONLY ONE CORRECT ANSWER BUT IT'S POSSIBLE TO HAVE THE ANCHOR+7n DAYS TO SHOW: e.g. April 4, April 11, April 18, April 25 should all be answer candidates but only one shows at a time with 5 distractors.

2. **Drill 3 exact formulation**: "What is the nearest Doomsday anchor to [date]?" vs "How far (in days) is [date] from the nearest Doomsday anchor?" The proximity offset question (the latter) is arguably more useful for speed calculation, but requires different options (offsets like -3, -2, -1, 0, +1, +2, +3) rather than date selection.

Answer from Jacc(author): offset is better

3. **Template card SRS granularity**: Currently one template card per drill. This means SRS tracks the drill as a whole, not per-year or per-date. Consider whether to split into sub-range cards (e.g., 10 cards for Drill 2.1, one per decade 2000-09, 2010-19, …) for finer-grained SRS scheduling.

Answer from Jacc(author): No need to adapt for SRS for now

4. **Leap year handling in Drill 1**: Jan/Feb anchors differ in leap years. The current plan asks for the non-leap anchor and notes the leap variant in the hint. Alternatively, track as two cards (one for leap, one for non-leap). Probably overkill at this stage.

Answer from Jacc(author): track as two cards, so the card should also hint as like January (Leap Year)

5. **`game-screen.tsx` coupling**: Reading the file is needed to understand exactly how to thread doomsday mode through the session controller. This is a Phase 4 risk worth investigating before implementation.

Answer from Jacc(author): well this is a good catch. currently for the UI, i want that for /rapid page, it shows the card as is, and on doomsday cards, add a What is this? button or hint, depends on the design. and when clicked on it, jump to the page where the Doomsday method and the game is explained.

but im not sure if this is the question you want to point out. if more decision is needed for me to decide. stop and ask me to get the propper decision.

6. **`TopicCardConfig.mode`** in `topics.ts`: Current modes are `'language-pick'`, `'phone-pick'`, etc. A new `'doomsday'` mode value is needed, and the component that maps mode → API parameters needs updating too.

Answer from Jacc(author): OK

---

## 10. Non-Goals (Out of Scope for This Plan)

- Progressive unlock (unlock Drill 2 only after Drill 1 reaches X% accuracy) — separate feature
- Map mode for any doomsday drill
- Timed speed scoring beyond existing `time_ms < 5000 ? 5 : 4` SRS quality logic
- Persistent server-side quiz session state (not needed for this use case)
