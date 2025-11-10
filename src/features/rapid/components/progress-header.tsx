'use client';

import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';

interface ProgressHeaderProps {
  current: number;
  total: number;
  correct: number;
  timeElapsed: number;
}

export function ProgressHeader({ current, total, correct, timeElapsed }: ProgressHeaderProps) {
  const accuracy = current > 0 ? Math.round((correct / current) * 100) : 0;
  const minutes = Math.floor(timeElapsed / 60);
  const seconds = timeElapsed % 60;

  return (
    <div className='mb-6 space-y-3'>
      <div className='flex items-center justify-between'>
        <div className='text-sm font-medium text-foreground'>
          Question {current} of {total}
        </div>
        <div className='flex gap-2'>
          <Badge variant='secondary' className='font-mono'>
            {accuracy}% accurate
          </Badge>
          <Badge variant='outline' className='font-mono'>
            {minutes}:{seconds.toString().padStart(2, '0')}
          </Badge>
        </div>
      </div>
      <Progress value={(current / total) * 100} className='h-2' />
    </div>
  );
}
