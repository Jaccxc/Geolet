'use client';

import { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';

import type { MapQueueItem, PickQueueItem } from '../types';

import { MapLoading } from './map-loading';
import { PickCard } from './pick-card';
import { ProgressHeader } from './progress-header';
import { SessionRecap } from './session-recap';

// Lazy load MapCard to reduce initial bundle size
const MapCard = dynamic(() => import('./map-card').then((mod) => ({ default: mod.MapCard })), {
  loading: () => <MapLoading />,
  ssr: false,
});

interface GameScreenProps {
  queueItems: (PickQueueItem | MapQueueItem)[];
  mode: 'pick' | 'map';
  onComplete: (results: any) => void;
}

export function GameScreen({ queueItems, mode, onComplete }: GameScreenProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [results, setResults] = useState<any[]>([]);
  const [startTime] = useState(Date.now());
  const [timeElapsed, setTimeElapsed] = useState(0);
  const [isComplete, setIsComplete] = useState(false);

  const isMapMode = mode === 'map';

  // Timer
  useEffect(() => {
    const interval = setInterval(() => {
      setTimeElapsed(Math.floor((Date.now() - startTime) / 1000));
    }, 1000);
    return () => clearInterval(interval);
  }, [startTime]);

  const handleAnswer = (
    selectedRegionIdOrPin: string | [number, number],
    timeMs: number,
    correctOverride?: boolean
  ) => {
    const item = queueItems[currentIndex];

    let newResult: any;
    if (typeof selectedRegionIdOrPin === 'string') {
      // Pick mode - NEW: using region_id instead of key
      newResult = {
        fact_id: item.fact_id,
        selected_region_id: selectedRegionIdOrPin,
        time_ms: timeMs,
        correct:
          'options' in item ? item.options.find((o) => o.region_id === selectedRegionIdOrPin)?.correct || false : false,
      };
    } else {
      // Map mode
      newResult = {
        fact_id: item.fact_id,
        clicked_point: selectedRegionIdOrPin,
        time_ms: timeMs,
        correct: correctOverride ?? false, // Use validation from MapCard
      };
    }

    const newResults = [...results, newResult];
    setResults(newResults);

    // Move to next card or show recap
    if (currentIndex < queueItems.length - 1) {
      setTimeout(() => {
        setCurrentIndex(currentIndex + 1);
      }, 200);
    } else {
      // Session complete
      setTimeout(() => {
        setIsComplete(true);
        onComplete(newResults);
      }, 200);
    }
  };

  const correctCount = results.filter((r) => r.correct).length;

  if (isComplete) {
    return <SessionRecap results={results} mode={mode} totalTimeMs={Date.now() - startTime} />;
  }

  const currentItem = queueItems[currentIndex];

  // Safety check: if no items or current item is undefined
  if (!currentItem) {
    return (
      <div className='mx-auto w-full max-w-5xl py-20 text-center'>
        <p className='text-destructive'>No cards available. Please try a different topic.</p>
      </div>
    );
  }

  return (
    <div className='mx-auto w-full max-w-5xl'>
      <ProgressHeader
        current={currentIndex + 1}
        total={queueItems.length}
        correct={correctCount}
        timeElapsed={timeElapsed}
      />

      {isMapMode && 'answer_region' in currentItem ? (
        <MapCard
          key={currentItem.fact_id}
          prompt={currentItem.prompt}
          hint={currentItem.hint}
          answerRegion={currentItem.answer_region}
          onAnswer={(pin, time, correct) => handleAnswer(pin, time, correct)}
        />
      ) : 'options' in currentItem ? (
        <PickCard
          key={currentItem.fact_id}
          prompt={currentItem.prompt}
          hint={currentItem.hint}
          options={currentItem.options}
          onAnswer={handleAnswer}
        />
      ) : null}
    </div>
  );
}
