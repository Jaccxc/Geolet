'use client';

import { FormEvent, useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { toast } from '@/components/ui/use-toast';
import type { ActionResponse } from '@/types/action-response';

type ProfileCompletionDialogProps = {
  initialName?: string | null;
  updateFullName: (name: string) => Promise<ActionResponse>;
};

export function ProfileCompletionDialog({ initialName, updateFullName }: ProfileCompletionDialogProps) {
  const [name, setName] = useState(initialName ?? '');
  const [pending, setPending] = useState(false);
  const [visible, setVisible] = useState(!initialName);
  const router = useRouter();

  useEffect(() => {
    setName(initialName ?? '');
    setVisible(!initialName);
  }, [initialName]);

  if (!visible) {
    return null;
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const trimmed = name.trim();

    if (!trimmed) {
      toast({
        variant: 'destructive',
        description: 'Please enter your name.',
      });
      return;
    }

    setPending(true);
    const response = await updateFullName(trimmed);
    setPending(false);

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: response.error.message ?? 'Something went wrong while saving your name. Please try again.',
      });
      return;
    }

    toast({
      description: 'Name updated—welcome to Geolet!',
    });

    setVisible(false);
    router.refresh();
  }

  return (
    <div className='fixed inset-0 z-50 flex items-center justify-center bg-black/70 px-4 py-8'>
      <Card className='w-full max-w-md border-border bg-card shadow-2xl'>
        <CardHeader className='space-y-2 text-center'>
          <CardTitle className='text-2xl font-bold'>Hi there! What should we call you?</CardTitle>
          <CardDescription>Tell us your display name so we can personalize your training stats.</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className='space-y-4'>
            <div className='space-y-2'>
              <label htmlFor='display-name' className='text-sm font-medium'>
                Display name
              </label>
              <Input
                id='display-name'
                name='display-name'
                placeholder='e.g. Geolet Pro'
                value={name}
                onChange={(event) => setName(event.target.value)}
                autoFocus
              />
            </div>
            <Button type='submit' className='w-full' disabled={pending}>
              {pending ? 'Saving…' : 'Save and start training'}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}

