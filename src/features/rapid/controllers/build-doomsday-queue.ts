import {
  DAY_NAMES,
  daysInMonth,
  getAllDoomsdaysInMonth,
  getDayOfWeek,
  getDoomsdayForYear,
  getOffsetFromNearestAnchor,
  MONTH_NAMES,
  randomDate,
  randomYear,
} from '../models/doomsday-calculator';
import type { DoomsdayOption, DoomsdayQueueItem, FactCard } from '../types';

export function buildDoomsdayQueueItem(card: FactCard): DoomsdayQueueItem {
  const params = (card.card_params ?? {}) as Record<string, unknown>;

  switch (card.card_type) {
    case 'doomsday_month':
      return buildMonthCard(card, params);
    case 'doomsday_year_template':
      return buildYearCard(card, params);
    case 'doomsday_anchor_template':
      return buildAnchorCard(card, params);
    case 'doomsday_full_template':
      return buildFullChainCard(card, params);
    default:
      throw new Error(`Unknown doomsday card type: ${card.card_type}`);
  }
}

// ---------------------------------------------------------------------------
// Drill 1 — Month Codes
// Prompt: a random date in YYYY.MM.DD format (month highlighted in UI).
// Question: "Which date in the same month always falls on Doomsday?"
// Randomly picks ONE valid Doomsday date as correct answer.
// Generates 5 date distractors (non-Doomsday dates in same month).
// Display date is intentionally a NON-Doomsday day to avoid giving the answer away.
// ---------------------------------------------------------------------------
function buildMonthCard(card: FactCard, params: Record<string, unknown>): DoomsdayQueueItem {
  const month = params.month as number;
  const isLeap = (params.is_leap as boolean) ?? false;

  // Pick a random year in 1990–2030 that matches the leap requirement.
  const year = pickMatchingYear(isLeap);

  const doomsdays = getAllDoomsdaysInMonth(month, year);
  const doomsdaySet = new Set(doomsdays);

  // Pick one random valid Doomsday date as the correct answer.
  const correctDate = doomsdays[Math.floor(Math.random() * doomsdays.length)];

  // Build distractor pool: dates NOT in the Doomsday set.
  const maxDay = daysInMonth(month, year);
  const distractors: number[] = [];
  for (let d = 1; d <= maxDay; d++) {
    if (!doomsdaySet.has(d)) distractors.push(d);
  }
  const pickedDistractors = shuffle(distractors).slice(0, 5);

  // Pick a non-Doomsday day as the display date so the answer isn't telegraphed.
  const displayDay = shuffle(distractors)[0] ?? 1;
  const mm = String(month).padStart(2, '0');
  const dd = String(displayDay).padStart(2, '0');
  const displayDate = `${year}.${mm}.${dd}`;

  const options: DoomsdayOption[] = shuffle([
    { value: String(correctDate), label: String(correctDate), correct: true },
    ...pickedDistractors.map((d) => ({ value: String(d), label: String(d), correct: false })),
  ]);

  return {
    fact_id: card.id,
    card_type: card.card_type,
    prompt: displayDate,
    hint: card.hint,
    difficulty: card.difficulty,
    question_params: { month, is_leap: isLeap, correct_date: correctDate },
    options,
  };
}

// Returns a random year in 1990–2030 matching the leap/non-leap requirement.
// For months 3–12 isLeap is always false (leap doesn't affect their anchors),
// so any year is fine — no filtering applied.
function pickMatchingYear(isLeap: boolean): number {
  if (!isLeap) {
    // For months 3–12 or non-leap Jan/Feb: pick any non-leap year in range.
    const nonLeapYears: number[] = [];
    for (let y = 1990; y <= 2030; y++) {
      if (!isLeapYear(y)) nonLeapYears.push(y);
    }
    return nonLeapYears[Math.floor(Math.random() * nonLeapYears.length)];
  }
  // Leap Jan/Feb: must be a leap year.
  const leapYears: number[] = [];
  for (let y = 1990; y <= 2030; y++) {
    if (isLeapYear(y)) leapYears.push(y);
  }
  return leapYears[Math.floor(Math.random() * leapYears.length)];
}

function isLeapYear(y: number): boolean {
  return (y % 4 === 0 && y % 100 !== 0) || y % 400 === 0;
}

// ---------------------------------------------------------------------------
// Drills 2, 2.1, 2.5, 2.99 — Year Code
// Question: "What day of the week is Doomsday for [Year]?"
// Options: all 7 days (Sunday–Saturday).
// ---------------------------------------------------------------------------
function buildYearCard(card: FactCard, params: Record<string, unknown>): DoomsdayQueueItem {
  const [lo, hi] = params.year_range as [number, number];
  const year = randomYear(lo, hi);
  const correctDay = getDoomsdayForYear(year);

  const options: DoomsdayOption[] = DAY_NAMES.map((name, i) => ({
    value: String(i),
    label: name,
    correct: i === correctDay,
  }));

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

// ---------------------------------------------------------------------------
// Drill 3 — Anchor Date Proximity (offset)
// Question: "How many days is [Month Day, Year] from the nearest Doomsday anchor?"
// Options: offset values -3 to +3 (7 options).
// ---------------------------------------------------------------------------
function buildAnchorCard(card: FactCard, params: Record<string, unknown>): DoomsdayQueueItem {
  const [lo, hi] = (params.year_range as [number, number]) ?? [1900, 2099];
  const { year, month, day } = randomDate(lo, hi);
  const offset = getOffsetFromNearestAnchor(month, year, day);

  const options: DoomsdayOption[] = [-3, -2, -1, 0, 1, 2, 3].map((o) => ({
    value: String(o),
    label: o === 0 ? '0 (it IS a Doomsday)' : o > 0 ? `+${o}` : String(o),
    correct: o === offset,
  }));

  return {
    fact_id: card.id,
    card_type: card.card_type,
    prompt: `How many days is ${MONTH_NAMES[month]} ${day}, ${year} from the nearest Doomsday anchor?`,
    hint: card.hint,
    difficulty: card.difficulty,
    question_params: { year, month, day, offset },
    options,
  };
}

// ---------------------------------------------------------------------------
// Drill 4 — Full Chain
// Question: "What day of the week is [Month Day, Year]?"
// Options: all 7 days (Sunday–Saturday).
// ---------------------------------------------------------------------------
function buildFullChainCard(card: FactCard, params: Record<string, unknown>): DoomsdayQueueItem {
  const [lo, hi] = (params.year_range as [number, number]) ?? [1900, 2099];
  const { year, month, day } = randomDate(lo, hi);
  const correctDay = getDayOfWeek(year, month, day);

  const options: DoomsdayOption[] = DAY_NAMES.map((name, i) => ({
    value: String(i),
    label: name,
    correct: i === correctDay,
  }));

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

function shuffle<T>(arr: T[]): T[] {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
