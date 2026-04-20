'use client';

import { useEffect, useRef, useState } from 'react';
import { CheckCircle2, XCircle } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import type { PickOption, SkillTag } from '../types';

import { SkillCard } from './skill-card';

interface PickCardProps {
  prompt: string;
  hint: string | null;
  options: PickOption[];
  onAnswer: (selectedRegionId: string, timeMs: number) => void;
  skillTags?: SkillTag[];
}

export function PickCard({ prompt, hint, options, onAnswer, skillTags }: PickCardProps) {
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
  };

  const handleContinue = () => {
    if (!selected) return;
    const timeMs = Date.now() - startTime;
    onAnswer(selected, timeMs);
  };

  // Handle keyboard shortcuts for continue (Space or any click)
  useEffect(() => {
    if (!showFeedback) return;

    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === ' ' || e.key === 'Spacebar') {
        e.preventDefault();
        handleContinue();
      }
    };

    const handleClick = () => {
      handleContinue();
    };

    window.addEventListener('keydown', handleKeyPress);
    // Add click listener to the card content area
    document.addEventListener('click', handleClick);

    return () => {
      window.removeEventListener('keydown', handleKeyPress);
      document.removeEventListener('click', handleClick);
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [showFeedback, selected]);

  return (
    <div className='space-y-6'>
      <Card className='mx-auto max-w-3xl border-border bg-card'>
        <CardHeader className='pb-8 text-center'>
          <div className='mb-4 font-sans text-6xl font-bold'>{prompt}</div>
          {hint && <div className='text-sm text-muted-foreground'>{hint}</div>}
        </CardHeader>
        <CardContent>
          {/* Continue hint */}
          {showFeedback && (
            <div className='mb-4 text-center text-sm text-muted-foreground'>
              Press <kbd className='rounded border border-border bg-muted px-1.5 py-0.5 text-xs font-semibold'>Space</kbd> or click anywhere to continue
            </div>
          )}

          <div className='grid grid-cols-2 gap-3'>
          {options.map((option) => {
            const isSelected = selected === option.region_id;
            const isCorrect = option.correct;
            const showCorrect = showFeedback && isCorrect;
            const showWrong = showFeedback && isSelected && !isCorrect;

            // Determine button variant and styles
            let variant: 'default' | 'destructive' | 'secondary' | 'outline' = 'outline';
            let customClassName = '';

            if (showFeedback) {
              if (showCorrect) {
                // Correct answer: green and enabled-looking
                variant = 'default';
                customClassName = 'bg-green-600 hover:bg-green-600 text-white border-green-600';
              } else if (showWrong) {
                // Wrong answer selected: red and enabled-looking
                variant = 'destructive';
                customClassName = 'bg-red-600 hover:bg-red-600 text-white border-red-600';
              } else {
                // Other options: keep enabled appearance but subtle
                variant = 'outline';
                customClassName = 'opacity-100 border-border';
              }
            } else if (isSelected) {
              variant = 'secondary';
            }

            return (
              <Button
                key={option.region_id}
                variant={variant}
                size='lg'
                className={`relative h-20 text-base font-medium ${customClassName}`}
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

      {/* Show skill card when answer is revealed */}
      {showFeedback && skillTags && skillTags.length > 0 && (
        <div className='mx-auto max-w-3xl'>
          <SkillCard skillTags={skillTags} />
        </div>
      )}
    </div>
  );
}
