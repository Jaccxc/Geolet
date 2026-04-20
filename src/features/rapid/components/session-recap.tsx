'use client';

import { Clock, Target, TrendingUp, Trophy } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

interface SessionRecapProps {
  results: any[];
  mode: string;
  totalTimeMs: number;
  onNewSession?: () => void;
  onPlayAgain?: () => void;
}

export function SessionRecap({ results, mode, totalTimeMs, onNewSession, onPlayAgain }: SessionRecapProps) {
  const correct = results.filter((r) => r.correct).length;
  const accuracy = Math.round((correct / results.length) * 100);
  const avgTimeMs = results.reduce((sum, r) => sum + r.time_ms, 0) / results.length;
  const avgTimeSec = (avgTimeMs / 1000).toFixed(1);

  const getMessage = () => {
    if (accuracy >= 90) return 'Excellent! 🎯';
    if (accuracy >= 70) return 'Great job! 👏';
    if (accuracy >= 50) return 'Good effort! 💪';
    return 'Keep practicing! 📚';
  };

  return (
    <div className='mx-auto max-w-2xl space-y-6'>
      <Card className='border-border bg-card'>
        <CardHeader>
          <CardTitle className='text-center text-3xl font-bold'>{getMessage()}</CardTitle>
          <p className='mt-2 text-center text-muted-foreground'>Session Complete</p>
        </CardHeader>
        <CardContent className='space-y-6'>
          {/* Stats Grid */}
          <div className='grid grid-cols-2 gap-4'>
            <div className='flex items-center gap-3 rounded-lg border border-border bg-card p-4'>
              <Trophy className='h-8 w-8 text-yellow-500' />
              <div>
                <div className='text-2xl font-bold'>{accuracy}%</div>
                <div className='text-sm text-muted-foreground'>Accuracy</div>
              </div>
            </div>

            <div className='flex items-center gap-3 rounded-lg border border-border bg-card p-4'>
              <Target className='h-8 w-8 text-green-500' />
              <div>
                <div className='text-2xl font-bold'>
                  {correct}/{results.length}
                </div>
                <div className='text-sm text-muted-foreground'>Correct</div>
              </div>
            </div>

            <div className='flex items-center gap-3 rounded-lg border border-border bg-card p-4'>
              <Clock className='h-8 w-8 text-blue-500' />
              <div>
                <div className='text-2xl font-bold'>{avgTimeSec}s</div>
                <div className='text-sm text-muted-foreground'>Avg Time</div>
              </div>
            </div>

            <div className='flex items-center gap-3 rounded-lg border border-border bg-card p-4'>
              <TrendingUp className='h-8 w-8 text-purple-500' />
              <div>
                <div className='text-2xl font-bold'>{results.length}</div>
                <div className='text-sm text-muted-foreground'>Cards</div>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className='flex gap-3'>
            {onPlayAgain && (
              <Button className='flex-1' onClick={onPlayAgain}>
                Play Again
              </Button>
            )}
            <Button
              variant={onPlayAgain ? 'outline' : 'default'}
              className='flex-1'
              onClick={() => {
                if (onNewSession) {
                  onNewSession();
                } else {
                  window.location.href = '/rapid';
                }
              }}
            >
              Back to Topics
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
