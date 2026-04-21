'use client';

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { CheckCircle2, HelpCircle, XCircle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import type { DoomsdayOption } from '../types';

interface DoomsdayPickCardProps {
  cardType: string;
  prompt: string;
  hint: string | null;
  options: DoomsdayOption[];
  onAnswer: (selectedValue: string, timeMs: number) => void;
}

export function DoomsdayPickCard({ cardType, prompt, hint, options, onAnswer }: DoomsdayPickCardProps) {
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [startTime, setStartTime] = useState(Date.now());
  const promptRef = useRef(prompt);

  useEffect(() => {
    if (promptRef.current !== prompt) {
      promptRef.current = prompt;
      setSelected(null);
      setShowFeedback(false);
      setStartTime(Date.now());
    }
  }, [prompt]);

  const handleSelect = (value: string) => {
    if (selected) return;
    setSelected(value);
    setShowFeedback(true);
    const timeMs = Date.now() - startTime;
    setTimeout(() => {
      onAnswer(value, timeMs);
    }, 1500);
  };

  // 7 options (day names / offsets) → 4-column grid; 6 options (dates) → 2-column grid
  const gridCols = options.length === 7 ? 'grid-cols-4' : 'grid-cols-2';

  const optionButtons = (
    <div className={`grid ${gridCols} gap-3`}>
      {options.map((option) => {
        const isSelected = selected === option.value;
        const showCorrect = showFeedback && option.correct;
        const showWrong = showFeedback && isSelected && !option.correct;
        // Only disable "other" options after answering. Keep the correct answer
        // and the user's selected wrong answer visually enabled so they don't
        // get the button's base `disabled:opacity-50` overlay on top of the
        // highlight variant.
        const isHighlighted = showCorrect || showWrong;
        const isDisabled = showFeedback && !isHighlighted;

        return (
          <Button
            key={option.value}
            variant={showCorrect ? 'default' : showWrong ? 'destructive' : isSelected ? 'secondary' : 'outline'}
            size='lg'
            className='relative min-h-14 h-auto px-3 py-3 text-sm sm:px-8 sm:text-base font-medium whitespace-normal leading-snug'
            onClick={() => handleSelect(option.value)}
            disabled={isDisabled}
          >
            {option.shortLabel ? (
              <>
                <span className='sm:hidden'>{option.shortLabel}</span>
                <span className='hidden sm:inline'>{option.label}</span>
              </>
            ) : (
              <span>{option.label}</span>
            )}
            {showCorrect && <CheckCircle2 className='absolute right-2 top-2 h-4 w-4 shrink-0' />}
            {showWrong && <XCircle className='absolute right-2 top-2 h-4 w-4 shrink-0' />}
          </Button>
        );
      })}
    </div>
  );

  const learnLink = (
    <div className='flex justify-center pt-2'>
      <Link
        href='/learn/doomsday'
        className='flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors'
      >
        <HelpCircle className='h-4 w-4' />
        What is the Doomsday method?
      </Link>
    </div>
  );

  // ── Drill 1: Month Codes ────────────────────────────────────────────────────
  // prompt = "YYYY.MM.DD" — highlight the month number, dim year and day
  if (cardType === 'doomsday_month') {
    const [year, mm, day] = prompt.split('.');

    return (
      <Card className='mx-auto max-w-3xl border-border bg-card'>
        <CardHeader className='pb-6 text-center'>
          <div className='mb-1 font-mono text-5xl font-bold tracking-wider'>
            <span className='text-muted-foreground/50'>{year}.</span>
            <span className='text-primary'>{mm}</span>
            <span className='text-muted-foreground/50'>.{day}</span>
          </div>
          <p className='mt-1 text-base font-medium text-foreground'>
            Which date in the same month always falls on Doomsday?
          </p>
          {hint && <p className='mt-1 text-sm text-muted-foreground'>{hint}</p>}
        </CardHeader>

        <CardContent className='space-y-4'>
          {optionButtons}
          {learnLink}
        </CardContent>
      </Card>
    );
  }

  // ── All other drills ────────────────────────────────────────────────────────
  return (
    <Card className='mx-auto max-w-3xl border-border bg-card'>
      <CardHeader className='pb-6 text-center'>
        <div className='mb-2 text-xl font-semibold leading-snug'>{prompt}</div>
        {hint && <div className='text-sm text-muted-foreground'>{hint}</div>}
      </CardHeader>

      <CardContent className='space-y-4'>
        {optionButtons}
        {learnLink}
      </CardContent>
    </Card>
  );
}
