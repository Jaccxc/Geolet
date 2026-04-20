'use client';

import { useEffect, useRef, useState } from 'react';
import Link from 'next/link';
import { CheckCircle2, HelpCircle, XCircle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import type { DoomsdayOption } from '../types';

interface DoomsdayPickCardProps {
  prompt: string;
  hint: string | null;
  options: DoomsdayOption[];
  onAnswer: (selectedValue: string, timeMs: number) => void;
}

export function DoomsdayPickCard({ prompt, hint, options, onAnswer }: DoomsdayPickCardProps) {
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

  return (
    <Card className='mx-auto max-w-3xl border-border bg-card'>
      <CardHeader className='pb-6 text-center'>
        <div className='mb-2 text-xl font-semibold leading-snug'>{prompt}</div>
        {hint && <div className='text-sm text-muted-foreground'>{hint}</div>}
      </CardHeader>

      <CardContent className='space-y-4'>
        <div className={`grid ${gridCols} gap-3`}>
          {options.map((option) => {
            const isSelected = selected === option.value;
            const isCorrect = option.correct;
            const showCorrect = showFeedback && isCorrect;
            const showWrong = showFeedback && isSelected && !isCorrect;

            return (
              <Button
                key={option.value}
                variant={showCorrect ? 'default' : showWrong ? 'destructive' : isSelected ? 'secondary' : 'outline'}
                size='lg'
                className='relative h-16 text-base font-medium'
                onClick={() => handleSelect(option.value)}
                disabled={!!selected}
              >
                {option.label}
                {showCorrect && <CheckCircle2 className='absolute right-2 top-2 h-4 w-4' />}
                {showWrong && <XCircle className='absolute right-2 top-2 h-4 w-4' />}
              </Button>
            );
          })}
        </div>

        <div className='flex justify-center pt-2'>
          <Link
            href='/learn/doomsday'
            className='flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground transition-colors'
          >
            <HelpCircle className='h-4 w-4' />
            What is the Doomsday method?
          </Link>
        </div>
      </CardContent>
    </Card>
  );
}
