'use client';

import Link from 'next/link';

import { Button } from '@/components/ui/button';
import { Dialog, DialogContent, DialogDescription, DialogHeader, DialogTitle } from '@/components/ui/dialog';

interface GuestLimitDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  remainingSessions: number;
  limit: number;
}

export function GuestLimitDialog({ open, onOpenChange, remainingSessions, limit }: GuestLimitDialogProps) {
  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Log in for unlimited Rapid Mode</DialogTitle>
          <DialogDescription>
            You have completed {Math.max(limit - remainingSessions, 0)} / {limit} guest sessions. Log in or sign up for free to
            unlock unlimited plays, synced progress, and full history.
          </DialogDescription>
        </DialogHeader>
        <div className='flex flex-col gap-2 sm:flex-row'>
          <Button asChild className='flex-1'>
            <Link href='/login'>Log in</Link>
          </Button>
          <Button asChild variant='outline' className='flex-1'>
            <Link href='/signup'>Sign up for free</Link>
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}

