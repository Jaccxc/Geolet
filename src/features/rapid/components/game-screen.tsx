'use client';

import { useEffect, useState } from 'react';

import { PickCard } from './pick-card';
import { ProgressHeader } from './progress-header';
import { SessionRecap } from './session-recap';

interface QueueItem {
  fact_id: string;
  type: string;
  payload: any;
  difficulty: number;
  options: any[];
}

interface GameScreenProps {
  queueItems: QueueItem[];
  mode: string;
  onComplete: (results: any) => void;
}

export function GameScreen({ queueItems, mode, onComplete }: GameScreenProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [results, setResults] = useState<any[]>([]);
  const [startTime] = useState(Date.now());
  const [timeElapsed, setTimeElapsed] = useState(0);
  const [isComplete, setIsComplete] = useState(false);

  // Timer
  useEffect(() => {
    const interval = setInterval(() => {
      setTimeElapsed(Math.floor((Date.now() - startTime) / 1000));
    }, 1000);
    return () => clearInterval(interval);
  }, [startTime]);

  const handleAnswer = (selectedKey: string, timeMs: number) => {
    const item = queueItems[currentIndex];
    const newResult = {
      fact_id: item.fact_id,
      selected_key: selectedKey,
      time_ms: timeMs,
      correct: item.options.find((o) => o.key === selectedKey)?.correct || false,
    };

    const newResults = [...results, newResult];
    setResults(newResults);

    // Move to next card or show recap
    // Wait slightly longer than the feedback delay to ensure smooth transition
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

  return (
    <div className='mx-auto w-full max-w-5xl'>
      <ProgressHeader
        current={currentIndex + 1}
        total={queueItems.length}
        correct={correctCount}
        timeElapsed={timeElapsed}
      />

      <PickCard payload={currentItem.payload} options={currentItem.options} onAnswer={handleAnswer} />
    </div>
  );
}
