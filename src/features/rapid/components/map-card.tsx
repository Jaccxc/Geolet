'use client';

import { useEffect, useState } from 'react';
import { CheckCircle2, MapPin, XCircle } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import { validateMapAnswer } from '../models/answer-validator';
import type { Region, SkillTag } from '../types';

import { MapViewer } from './map-viewer';
import { SkillCard } from './skill-card';

interface MapCardProps {
  prompt: string;
  hint: string | null;
  answerRegion: Region;
  onAnswer: (pinDrop: [number, number], timeMs: number, correct: boolean) => void;
  skillTags?: SkillTag[];
}

export function MapCard({ prompt, hint, answerRegion, onAnswer, skillTags }: MapCardProps) {
  const [pinLocation, setPinLocation] = useState<[number, number] | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState<{ correct: boolean; distance?: number } | null>(null);
  const [startTime] = useState(Date.now());

  const handlePinDrop = (lng: number, lat: number) => {
    if (submitted) return;
    setPinLocation([lng, lat]);
  };

  const handleSubmit = () => {
    if (!pinLocation || submitted) return;

    setSubmitted(true);

    // Client-side validation (for immediate feedback)
    const validation = validateMapAnswer(answerRegion, pinLocation);
    setResult(validation);
  };

  const handleContinue = () => {
    if (!pinLocation || !submitted || !result) return;

    const timeMs = Date.now() - startTime;
    onAnswer(pinLocation, timeMs, result.correct);
  };

  // Keyboard shortcut for submit/continue (Enter or Space)
  useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === 'Enter' || e.key === ' ' || e.key === 'Spacebar') {
        e.preventDefault(); // Prevent page scroll on space
        if (!submitted && pinLocation) {
          handleSubmit();
        } else if (submitted && pinLocation) {
          handleContinue();
        }
      }
    };

    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [pinLocation, submitted]);

  return (
    <div className='space-y-6'>
      <Card className='mx-auto'>
        <CardHeader className='space-y-4 text-center'>
        {/* Prompt */}
        <div>
          <div className='mb-2 text-lg font-medium text-muted-foreground'>Where is this located?</div>
          <div className='text-4xl font-bold'>{prompt}</div>
          {hint && <div className='mt-1 text-sm text-muted-foreground'>{hint}</div>}
        </div>

        {/* Result Feedback */}
        {result && submitted && (
          <div
            className={`flex items-center justify-center gap-2 rounded-lg p-3 ${
              result.correct
                ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100'
                : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-100'
            }`}
          >
            {result.correct ? (
              <>
                <CheckCircle2 className='h-5 w-5' />
                <span className='font-medium'>Correct!</span>
                {result.distance && <span className='text-sm'>({result.distance.toFixed(0)} km away)</span>}
              </>
            ) : (
              <>
                <XCircle className='h-5 w-5' />
                <span className='font-medium'>Not quite!</span>
                {result.distance && <span className='text-sm'>({result.distance.toFixed(0)} km from answer)</span>}
              </>
            )}
          </div>
        )}
      </CardHeader>

      <CardContent className='space-y-4'>
        {/* Map */}
        <MapViewer regions={[answerRegion]} onPinDrop={handlePinDrop} disabled={submitted} showAnswer={submitted} />

        {/* Action Button */}
        {!submitted ? (
          <Button size='lg' className='w-full' onClick={handleSubmit} disabled={!pinLocation}>
            {pinLocation ? (
              <>
                Submit Answer <span className='ml-2 text-xs opacity-70'>(or press Space)</span>
              </>
            ) : (
              'Place pin to continue'
            )}
          </Button>
        ) : (
          <Button size='lg' className='w-full' onClick={handleContinue} variant='default'>
            Continue <span className='ml-2 text-xs opacity-70'>(or press Space)</span>
          </Button>
        )}
        </CardContent>
      </Card>

      {/* Show skill card when answer is revealed */}
      {submitted && skillTags && skillTags.length > 0 && (
        <div className='mx-auto max-w-3xl'>
          <SkillCard skillTags={skillTags} />
        </div>
      )}
    </div>
  );
}
