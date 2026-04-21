'use client';

import { useState } from 'react';
import { X } from 'lucide-react';

import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { Progress } from '@/components/ui/progress';

interface ProgressHeaderProps {
  current: number;
  total: number;
  correct: number;
  timeElapsed: number;
  // Called after the user confirms they want to abort the in-progress session.
  // When omitted, the quit control is hidden.
  onQuit?: () => void;
}

export function ProgressHeader({ current, total, correct, timeElapsed, onQuit }: ProgressHeaderProps) {
  const [confirmOpen, setConfirmOpen] = useState(false);
  const accuracy = current > 1 ? Math.round((correct / (current - 1)) * 100) : 100;
  const minutes = Math.floor(timeElapsed / 60);
  const seconds = timeElapsed % 60;

  // Skip the confirmation prompt if the user hasn't answered anything yet —
  // there's no progress to lose, so asking would be pure friction.
  const hasProgress = current > 1;

  const handleQuitClick = () => {
    if (!onQuit) return;
    if (hasProgress) {
      setConfirmOpen(true);
    } else {
      onQuit();
    }
  };

  const handleConfirmQuit = () => {
    setConfirmOpen(false);
    onQuit?.();
  };

  return (
    <div className='mb-6 space-y-3'>
      <div className='flex items-center justify-between gap-3'>
        <div className='text-sm font-medium text-foreground'>
          Question {current} of {total}
        </div>
        <div className='flex items-center gap-2'>
          <Badge variant='secondary' className='font-mono'>
            {accuracy}% accurate
          </Badge>
          <Badge variant='outline' className='font-mono'>
            {minutes}:{seconds.toString().padStart(2, '0')}
          </Badge>
          {onQuit && (
            <Button
              variant='ghost'
              size='icon'
              className='h-8 w-8 text-muted-foreground hover:text-foreground'
              onClick={handleQuitClick}
              aria-label='Quit session and return to topics'
              title='Quit session'
            >
              <X className='h-4 w-4' />
            </Button>
          )}
        </div>
      </div>
      <Progress value={((current - 1) / total) * 100} className='h-2' />

      <Dialog open={confirmOpen} onOpenChange={setConfirmOpen}>
        <DialogContent className='sm:max-w-md'>
          <DialogHeader>
            <DialogTitle>Quit this session?</DialogTitle>
            <DialogDescription>
              Your progress on the current {total}-question run will be discarded and not graded.
            </DialogDescription>
          </DialogHeader>
          <DialogFooter className='gap-2 sm:gap-2'>
            <Button variant='outline' onClick={() => setConfirmOpen(false)}>
              Keep playing
            </Button>
            <Button variant='destructive' onClick={handleConfirmQuit}>
              Quit session
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
