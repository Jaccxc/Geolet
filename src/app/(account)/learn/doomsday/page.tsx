import Link from 'next/link';
import { ArrowLeft } from 'lucide-react';

export default function LearnDoomsdayPage() {
  return (
    <div className='container mx-auto max-w-3xl px-4 py-10'>
      <Link
        href='/rapid'
        className='mb-8 flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground transition-colors'
      >
        <ArrowLeft className='h-4 w-4' />
        Back to Rapid Mode
      </Link>

      <h1 className='mb-2 text-4xl font-bold'>The Doomsday Method</h1>
      <p className='mb-10 text-lg text-muted-foreground'>
        A mental algorithm by John Conway to calculate the day of the week for any date — instantly.
      </p>

      {/* Overview */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>The Big Idea</h2>
        <p className='text-muted-foreground'>
          Every year has a <strong className='text-foreground'>Doomsday</strong> — a day of the week that a
          specific set of easy-to-remember dates always falls on. Once you know the Doomsday for a year, you can
          quickly figure out the day for any date by counting the offset from the nearest anchor.
        </p>
      </section>

      {/* Step 1: Month anchors */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>Step 1 — Month Anchors</h2>
        <p className='mb-4 text-muted-foreground'>
          These dates always fall on the year&apos;s Doomsday. Memorise the one that&apos;s easiest for each month.
        </p>
        <div className='overflow-hidden rounded-lg border border-border'>
          <table className='w-full text-sm'>
            <thead className='bg-muted/50'>
              <tr>
                <th className='px-4 py-2 text-left font-medium'>Month</th>
                <th className='px-4 py-2 text-left font-medium'>Anchor Date(s)</th>
                <th className='px-4 py-2 text-left font-medium'>Mnemonic</th>
              </tr>
            </thead>
            <tbody className='divide-y divide-border'>
              {[
                ['January', '3 (non-leap) / 4 (leap)', '—'],
                ['February', '28 (non-leap) / 29 (leap)', 'Last day of February'],
                ['March', '7, 14, 21, 28', 'Every 7th day from the 7th'],
                ['April', '4', '4/4'],
                ['May', '9', '"9-to-5 at the 7-Eleven"'],
                ['June', '6', '6/6'],
                ['July', '11', '"7-Eleven"'],
                ['August', '8', '8/8'],
                ['September', '5', '"9-to-5"'],
                ['October', '10', '10/10'],
                ['November', '7', '"11/7"'],
                ['December', '12', '12/12'],
              ].map(([month, anchors, mnemonic]) => (
                <tr key={month} className='hover:bg-muted/30'>
                  <td className='px-4 py-2 font-medium'>{month}</td>
                  <td className='px-4 py-2 text-muted-foreground'>{anchors}</td>
                  <td className='px-4 py-2 text-muted-foreground'>{mnemonic}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className='mt-3 text-sm text-muted-foreground'>
          Tip: all even-numbered months have an anchor equal to their month number (4/4, 6/6, 8/8, 10/10,
          12/12). May 9 and September 5 share the &ldquo;9-to-5&rdquo; mnemonic. July 11 and November 7 share the &ldquo;7-Eleven&rdquo; one.
        </p>
      </section>

      {/* Step 2: Century anchor */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>Step 2 — Century Anchor</h2>
        <p className='mb-4 text-muted-foreground'>
          Each century has a fixed anchor day. For the current era, just memorise these four:
        </p>
        <div className='grid grid-cols-2 gap-3 sm:grid-cols-4'>
          {[
            { century: '1800s', day: 'Friday', code: 5 },
            { century: '1900s', day: 'Wednesday', code: 3 },
            { century: '2000s', day: 'Tuesday', code: 2 },
            { century: '2100s', day: 'Sunday', code: 0 },
          ].map(({ century, day, code }) => (
            <div key={century} className='rounded-lg border border-border bg-card p-4 text-center'>
              <div className='text-xs text-muted-foreground'>{century}</div>
              <div className='mt-1 text-lg font-bold'>{day}</div>
              <div className='text-sm text-muted-foreground'>({code})</div>
            </div>
          ))}
        </div>
        <p className='mt-3 text-sm text-muted-foreground'>
          Formula for any century:{' '}
          <code className='rounded bg-muted px-1 py-0.5 font-mono'>
            (5 × (century % 4) + 2) % 7
          </code>
          , where century = floor(year / 100).
        </p>
      </section>

      {/* Step 3: Year code */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>Step 3 — Year Code</h2>
        <p className='mb-4 text-muted-foreground'>
          Use the last two digits of the year (<code className='rounded bg-muted px-1 py-0.5 font-mono'>y</code>):
        </p>
        <div className='rounded-lg border border-border bg-muted/30 p-5 font-mono text-sm leading-7'>
          <div>a = floor(y / 12)</div>
          <div>b = y % 12</div>
          <div>c = floor(b / 4)</div>
          <div className='mt-2 font-semibold'>year_code = (a + b + c) % 7</div>
        </div>
        <p className='mt-3 text-muted-foreground'>
          <strong>Doomsday for the year</strong> = (century anchor + year code) % 7
        </p>
        <p className='mt-1 text-sm text-muted-foreground'>
          Example — 2026: y = 26, a = 2, b = 2, c = 0 → year_code = 4. Century anchor = 2 (Tuesday).
          Doomsday = (2 + 4) % 7 = 6 → <strong>Saturday</strong>.
        </p>
      </section>

      {/* Step 4: Final offset */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>Step 4 — Final Offset</h2>
        <p className='text-muted-foreground'>
          Once you know the year&apos;s Doomsday, find the nearest anchor date in the target month and count the
          offset. Add it (mod 7) to the Doomsday.
        </p>
        <div className='mt-4 rounded-lg border border-border bg-muted/30 p-5 text-sm leading-7'>
          <p className='font-semibold'>Example: What day is April 19, 2026?</p>
          <ol className='mt-2 list-inside list-decimal space-y-1 text-muted-foreground'>
            <li>2026 Doomsday = Saturday (6)</li>
            <li>April anchor = April 4 (4/4)</li>
            <li>Offset = 19 − 4 = +15 = +1 (mod 7)</li>
            <li>Day = (6 + 1) % 7 = 0 → <strong className='text-foreground'>Sunday</strong> ✓</li>
          </ol>
        </div>
      </section>

      {/* Drill structure */}
      <section className='mb-10'>
        <h2 className='mb-3 text-2xl font-semibold'>How the Drills Work</h2>
        <div className='space-y-3'>
          {[
            { label: 'Drill 1 — Month Codes', desc: 'Build instant recall of anchor dates for each month.' },
            { label: 'Drill 2 — Year Code (2000–2030)', desc: 'Practice the year-code arithmetic starting with the easiest century.' },
            { label: 'Drill 2.1 / 2.5 / 2.99', desc: 'Extend to the full 21st century, 20th century, then all centuries.' },
            { label: 'Drill 3 — Anchor Date Proximity', desc: 'Given a date, instantly find its offset from the nearest anchor.' },
            { label: 'Drill 4 — Full Chain', desc: 'Chain all three steps to name the day of week for any date.' },
          ].map(({ label, desc }) => (
            <div key={label} className='rounded-lg border border-border p-4'>
              <div className='font-semibold'>{label}</div>
              <div className='text-sm text-muted-foreground'>{desc}</div>
            </div>
          ))}
        </div>
      </section>

      <div className='flex justify-center'>
        <Link
          href='/rapid'
          className='rounded-lg bg-primary px-6 py-3 text-sm font-medium text-primary-foreground hover:bg-primary/90 transition-colors'
        >
          Start Drilling →
        </Link>
      </div>
    </div>
  );
}
