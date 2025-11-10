'use client';

import { useState } from 'react';
import { CheckCircle2, XCircle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import type { PickOption } from '../types';

interface PickCardProps {
  payload: any;
  options: PickOption[];
  onAnswer: (selectedKey: string, timeMs: number) => void;
}

export function PickCard({ payload, options, onAnswer }: PickCardProps) {
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [startTime] = useState(Date.now());

  const handleSelect = (key: string) => {
    if (selected) return; // Already answered

    setSelected(key);
    setShowFeedback(true);

    const timeMs = Date.now() - startTime;

    // Wait 1.5s for feedback, then submit
    setTimeout(() => {
      onAnswer(key, timeMs);
    }, 1500);
  };

  // Display the prompt based on payload type
  const renderPrompt = () => {
    if (payload.text) {
      // Language snippet
      return (
        <>
          <div className='mb-4 font-sans text-6xl font-bold'>{payload.text}</div>
          {payload.romanization && <div className='text-sm text-muted-foreground'>{payload.romanization}</div>}
        </>
      );
    } else if (payload.number) {
      // Phone number
      return <div className='font-mono text-5xl font-bold'>{payload.number}</div>;
    } else if (payload.city) {
      // City name
      return <div className='text-5xl font-bold'>{payload.city}</div>;
    }
    return null;
  };

  return (
    <Card className='mx-auto max-w-3xl border-border bg-card'>
      <CardHeader className='pb-8 text-center'>{renderPrompt()}</CardHeader>
      <CardContent>
        <div className='grid grid-cols-2 gap-3'>
          {options.map((option) => {
            const isSelected = selected === option.key;
            const isCorrect = option.correct;
            const showCorrect = showFeedback && isCorrect;
            const showWrong = showFeedback && isSelected && !isCorrect;

            return (
              <Button
                key={option.key}
                variant={showCorrect ? 'default' : showWrong ? 'destructive' : isSelected ? 'secondary' : 'outline'}
                size='lg'
                className='relative h-20 text-base font-medium'
                onClick={() => handleSelect(option.key)}
                disabled={!!selected}
              >
                {option.label}
                {showCorrect && <CheckCircle2 className='absolute right-2 top-2 h-5 w-5' />}
                {showWrong && <XCircle className='absolute right-2 top-2 h-5 w-5' />}
              </Button>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
