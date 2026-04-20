// Days of week: 0=Sunday, 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday
export const DAY_NAMES = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

export const MONTH_NAMES = [
  '',
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

// Canonical Doomsday anchor date per month (1-indexed).
// Jan/Feb vary by leap year — handled separately via getMonthCanonicalAnchor().
const CANONICAL_ANCHORS: Record<number, number> = {
  3: 7,   // Mar 7
  4: 4,   // Apr 4   (4/4)
  5: 9,   // May 9   ("9-to-5")
  6: 6,   // Jun 6   (6/6)
  7: 11,  // Jul 11  ("7-Eleven")
  8: 8,   // Aug 8   (8/8)
  9: 5,   // Sep 5   ("9-to-5")
  10: 10, // Oct 10  (10/10)
  11: 7,  // Nov 7   ("11/7")
  12: 12, // Dec 12  (12/12)
};

export function isLeapYear(year: number): boolean {
  return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
}

export function daysInMonth(month: number, year: number): number {
  return new Date(year, month, 0).getDate();
}

export function getMonthCanonicalAnchor(month: number, year: number): number {
  if (month === 1) return isLeapYear(year) ? 4 : 3;
  if (month === 2) return isLeapYear(year) ? 29 : 28;
  return CANONICAL_ANCHORS[month];
}

// All dates in the given month/year that fall on Doomsday.
// They form an arithmetic progression with step 7 from the canonical anchor.
export function getAllDoomsdaysInMonth(month: number, year: number): number[] {
  const anchor = getMonthCanonicalAnchor(month, year);
  const maxDay = daysInMonth(month, year);
  const result: number[] = [];

  // Walk down from anchor to 1
  let d = anchor;
  while (d - 7 >= 1) d -= 7;

  // Walk up to end of month
  while (d <= maxDay) {
    result.push(d);
    d += 7;
  }

  return result;
}

// Century anchor: the Doomsday for the first year of a century.
// Formula: (5 * (century % 4) + 2) % 7, where century = floor(year / 100)
export function getCenturyAnchor(year: number): number {
  const c = Math.floor(year / 100);
  return (5 * (c % 4) + 2) % 7;
}

// Year offset code for the last two digits of the year within its century.
// Formula: a = floor(y/12), b = y%12, c = floor(b/4), code = (a+b+c) % 7
export function getYearCode(year: number): number {
  const y = year % 100;
  const a = Math.floor(y / 12);
  const b = y % 12;
  const c = Math.floor(b / 4);
  return (a + b + c) % 7;
}

// The Doomsday day-of-week for the entire year.
export function getDoomsdayForYear(year: number): number {
  return (getCenturyAnchor(year) + getYearCode(year)) % 7;
}

// The day of week for an arbitrary date.
export function getDayOfWeek(year: number, month: number, day: number): number {
  const anchor = getMonthCanonicalAnchor(month, year);
  const doomsday = getDoomsdayForYear(year);
  return ((doomsday + (day - anchor)) % 7 + 7) % 7;
}

// The signed offset from the nearest Doomsday anchor date in the same month.
// Returns a value in [-3, 3].
export function getOffsetFromNearestAnchor(month: number, year: number, day: number): number {
  const doomsdays = getAllDoomsdaysInMonth(month, year);
  let bestAnchor = doomsdays[0];
  let bestDist = Math.abs(day - bestAnchor);

  for (const d of doomsdays) {
    const dist = Math.abs(day - d);
    if (dist < bestDist) {
      bestDist = dist;
      bestAnchor = d;
    }
  }

  return day - bestAnchor;
}

// Random integer in [lo, hi] inclusive.
export function randomInt(lo: number, hi: number): number {
  return lo + Math.floor(Math.random() * (hi - lo + 1));
}

// Random year in range, skipping years before the Gregorian reform.
export function randomYear(lo: number, hi: number): number {
  return randomInt(lo, hi);
}

// Random date (year/month/day) within a year range.
export function randomDate(yearLo: number, yearHi: number): { year: number; month: number; day: number } {
  const year = randomYear(yearLo, yearHi);
  const month = randomInt(1, 12);
  const day = randomInt(1, daysInMonth(month, year));
  return { year, month, day };
}
