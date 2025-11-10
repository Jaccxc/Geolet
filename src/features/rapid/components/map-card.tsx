'use client';

import { useState } from 'react';
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

  const handlePinDrop = (lng: number, lat: number) => {
    if (submitted) return;
    setPinLocation([lng, lat]);
  };

  const handleSubmit = async () => {
    if (!pinLocation || submitted) return;

    setSubmitted(true);
    const timeMs = Date.now() - startTime;

    // Client-side validation (for immediate feedback)
    const validation = validateMapAnswer(
      { kind: 'region', select: { by: 'key', keys: answerRegions.map(r => r.key) } },
      pinLocation,
      answerRegions
    );
    setResult(validation);

    // Wait for feedback animation
    setTimeout(() => {
      onAnswer(pinLocation, timeMs);
    }, 2500);
  };

  return (
    <Card className="max-w-4xl mx-auto">
      <CardHeader className="text-center space-y-4">
        {/* Prompt */}
        <div>
          <div className="text-lg font-medium text-muted-foreground mb-2">
            {getPromptLabel(payload)}
          </div>
          <div className="text-4xl font-bold">
            {'text' in payload ? payload.text :
             'number' in payload ? payload.number :
             'city' in payload ? payload.city : ''}
          </div>
          {'romanization' in payload && payload.romanization && (
            <div className="text-sm text-muted-foreground mt-1">
              {payload.romanization}
            </div>
          )}
        </div>

        {/* Instructions */}
        {!pinLocation && (
          <Badge variant="outline" className="inline-flex items-center gap-2">
            <MapPin className="w-4 h-4" />
            Click on the map to place your answer
          </Badge>
        )}

        {/* Result Feedback */}
        {result && (
          <div className={`flex items-center justify-center gap-2 p-3 rounded-lg ${
            result.correct ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-100' : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-100'
          }`}>
            {result.correct ? (
              <>
                <CheckCircle2 className="w-5 h-5" />
                <span className="font-medium">Correct!</span>
                {result.distance && (
                  <span className="text-sm">({result.distance.toFixed(0)} km away)</span>
                )}
              </>
            ) : (
              <>
                <XCircle className="w-5 h-5" />
                <span className="font-medium">Not quite!</span>
              </>
            )}
          </div>
        )}
      </CardHeader>

      <CardContent className="space-y-4">
        {/* Map */}
        <MapViewer
          regions={answerRegions}
          bbox={bbox}
          onPinDrop={handlePinDrop}
          disabled={submitted}
          showAnswer={submitted}
        />

        {/* Submit Button */}
        <Button
          size="lg"
          className="w-full"
          onClick={handleSubmit}
          disabled={!pinLocation || submitted}
        >
          {pinLocation ? 'Submit Answer' : 'Place pin to continue'}
        </Button>
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
