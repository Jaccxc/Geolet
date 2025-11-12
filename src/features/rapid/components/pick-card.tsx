'use client';

import { useEffect, useRef, useState } from 'react';
import { CheckCircle2, XCircle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import type { PickOption } from '../types';

interface PickCardProps {
  prompt: string;
  hint: string | null;
  options: PickOption[];
  onAnswer: (selectedRegionId: string, timeMs: number) => void;
}

export function PickCard({ prompt, hint, options, onAnswer }: PickCardProps) {
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [startTime, setStartTime] = useState(Date.now());
  const promptRef = useRef(prompt);

  // Reset state when card changes
  useEffect(() => {
    if (promptRef.current !== prompt) {
      promptRef.current = prompt;
      setSelected(null);
      setShowFeedback(false);
      setStartTime(Date.now());
    }
  }, [prompt]);

  const handleSelect = (regionId: string) => {
    if (selected) return; // Already answered

    setSelected(regionId);
    setShowFeedback(true);

    const timeMs = Date.now() - startTime;

    // Wait 1.5s for feedback, then submit
    setTimeout(() => {
      onAnswer(regionId, timeMs);
    }, 1500);
  };

  return (
    <Card className='mx-auto max-w-3xl border-border bg-card'>
      <CardHeader className='pb-8 text-center'>
        <div className='mb-4 font-sans text-6xl font-bold'>{prompt}</div>
        {hint && <div className='text-sm text-muted-foreground'>{hint}</div>}
      </CardHeader>
      <CardContent>
        <div className='grid grid-cols-2 gap-3'>
          {options.map((option) => {
            const isSelected = selected === option.region_id;
            const isCorrect = option.correct;
            const showCorrect = showFeedback && isCorrect;
            const showWrong = showFeedback && isSelected && !isCorrect;

            return (
              <Button
                key={option.region_id}
                variant={showCorrect ? 'default' : showWrong ? 'destructive' : isSelected ? 'secondary' : 'outline'}
                size='lg'
                className='relative h-20 text-base font-medium'
                onClick={() => handleSelect(option.region_id)}
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
