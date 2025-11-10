'use client';

import { useEffect, useRef, useState } from 'react';
import { CheckCircle2, MapPin, XCircle } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

import { validateMapAnswer } from '../models/answer-validator';
import type { FactPayload, Region } from '../types';

import { MapViewer } from './map-viewer';

interface MapCardProps {
  payload: FactPayload;
  answerRegions: Region[];
  bbox: [number, number, number, number];
  onAnswer: (pinDrop: [number, number], timeMs: number) => void;
}

export function MapCard({ payload, answerRegions, bbox, onAnswer }: MapCardProps) {
  const [pinLocation, setPinLocation] = useState<[number, number] | null>(null);
  const [submitted, setSubmitted] = useState(false);
  const [result, setResult] = useState<{ correct: boolean; distance?: number } | null>(null);
  const [startTime] = useState(Date.now());
  const timeoutRef = useRef<NodeJS.Timeout | null>(null);

  const handlePinDrop = (lng: number, lat: number) => {
    if (submitted) return;
    setPinLocation([lng, lat]);
  };

  const handleSubmit = () => {
    if (!pinLocation || submitted) return;

    setSubmitted(true);
    const timeMs = Date.now() - startTime;

    // Client-side validation (for immediate feedback)
    const validation = validateMapAnswer(
      { kind: 'region', select: { by: 'key', keys: answerRegions.map((r) => r.key) } },
      pinLocation,
      answerRegions
    );
    setResult(validation);

    // Auto-advance after delay, but allow immediate continue via button
    timeoutRef.current = setTimeout(() => {
      onAnswer(pinLocation, timeMs);
    }, 2000);
  };

  const handleContinue = () => {
    if (!pinLocation || !submitted) return;

    // Clear auto-advance timeout
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current);
      timeoutRef.current = null;
    }

    const timeMs = Date.now() - startTime;
    onAnswer(pinLocation, timeMs);
  };

  // Cleanup on unmount
  useEffect(() => {
    return () => {
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current);
      }
    };
  }, []);

  // Keyboard shortcut for submit/continue
  useEffect(() => {
    const handleKeyPress = (e: KeyboardEvent) => {
      if (e.key === 'Enter') {
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
    <Card className='mx-auto max-w-4xl'>
      <CardHeader className='space-y-4 text-center'>
        {/* Prompt */}
        <div>
          <div className='mb-2 text-lg font-medium text-muted-foreground'>{getPromptLabel(payload)}</div>
          <div className='text-4xl font-bold'>
            {'text' in payload ? payload.text : 'number' in payload ? payload.number : 'city' in payload ? payload.city : ''}
          </div>
          {'romanization' in payload && payload.romanization && (
            <div className='mt-1 text-sm text-muted-foreground'>{payload.romanization}</div>
          )}
        </div>

        {/* Instructions */}
        {!pinLocation && !submitted && (
          <Badge variant='outline' className='inline-flex items-center gap-2'>
            <MapPin className='h-4 w-4' />
            Click on the map to place your answer
          </Badge>
        )}

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
        <MapViewer
          regions={answerRegions}
          bbox={bbox}
          onPinDrop={handlePinDrop}
          disabled={submitted}
          showAnswer={submitted}
        />

        {/* Action Button */}
        {!submitted ? (
          <Button size='lg' className='w-full' onClick={handleSubmit} disabled={!pinLocation}>
            {pinLocation ? 'Submit Answer' : 'Place pin to continue'}
          </Button>
        ) : (
          <Button size='lg' className='w-full' onClick={handleContinue} variant='default'>
            Continue
          </Button>
        )}
      </CardContent>
    </Card>
  );
}

function getPromptLabel(payload: FactPayload): string {
  if ('text' in payload) return 'Where is this script used?';
  if ('number' in payload) return 'Where is this phone number from?';
  if ('city' in payload) return 'Where is this city located?';
  return 'Click on the map';
}
