'use client';

import { FormEvent, useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { IoLogoGoogle, IoMail } from 'react-icons/io5';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from '@/components/ui/collapsible';
import { Input } from '@/components/ui/input';
import { Separator } from '@/components/ui/separator';
import { toast } from '@/components/ui/use-toast';
import { ActionResponse } from '@/types/action-response';

const titleMap = {
  login: 'Welcome back',
  signup: 'Create your account',
} as const;

const descriptionMap = {
  login: 'Sign in to continue your GeoGuessr training',
  signup: 'Start your journey to mastering GeoGuessr',
} as const;

export function AuthUI({
  mode,
  signInWithOAuth,
  signInWithEmail,
}: {
  mode: 'login' | 'signup';
  signInWithOAuth: (provider: 'github' | 'google') => Promise<ActionResponse>;
  signInWithEmail: (email: string) => Promise<ActionResponse>;
}) {
  const [pending, setPending] = useState(false);
  const [emailFormOpen, setEmailFormOpen] = useState(false);

  async function handleEmailSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setPending(true);
    const form = event.target as HTMLFormElement;
    const email = form['email'].value;
    const response = await signInWithEmail(email);

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: 'An error occurred while authenticating. Please try again.',
      });
    } else {
      toast({
        description: `To continue, click the link in the email sent to: ${email}`,
      });
    }

    form.reset();
    setPending(false);
  }

  async function handleOAuthClick(provider: 'google' | 'github') {
    setPending(true);
    const response = await signInWithOAuth(provider);

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: 'An error occurred while authenticating. Please try again.',
      });
      setPending(false);
    }
  }

  return (
    <div className='flex min-h-[calc(100vh-140px)] items-center justify-center py-12'>
      <Card className='w-full max-w-md border-border bg-card'>
        <CardHeader className='space-y-1 text-center'>
          <div className='mb-4 flex justify-center'>
            <Image src='/logo.png' width={64} height={64} alt='Geolet Logo' className='rounded-lg' />
          </div>
          <CardTitle className='text-2xl font-bold'>{titleMap[mode]}</CardTitle>
          <CardDescription className='text-base'>{descriptionMap[mode]}</CardDescription>
        </CardHeader>
        <CardContent className='space-y-4'>
          {/* Google OAuth */}
          <Button
            variant='outline'
            className='h-12 w-full border-white/10 text-base font-medium hover:bg-white/5'
            onClick={() => handleOAuthClick('google')}
            disabled={pending}
          >
            <IoLogoGoogle className='mr-2 h-5 w-5' />
            Continue with Google
          </Button>

          {/* Divider */}
          <div className='relative'>
            <div className='absolute inset-0 flex items-center'>
              <Separator className='w-full' />
            </div>
            <div className='relative flex justify-center text-xs uppercase'>
              <span className='bg-card px-2 text-muted-foreground'>Or</span>
            </div>
          </div>

          {/* Email Form */}
          <Collapsible open={emailFormOpen} onOpenChange={setEmailFormOpen}>
            <CollapsibleTrigger asChild>
              <Button
                variant='outline'
                className='h-12 w-full border-white/10 text-base font-medium hover:bg-white/5'
                disabled={pending}
              >
                <IoMail className='mr-2 h-5 w-5' />
                Continue with Email
              </Button>
            </CollapsibleTrigger>
            <CollapsibleContent>
              <div className='mt-4 rounded-lg border border-white/10 bg-white/5 p-6'>
                <form onSubmit={handleEmailSubmit} className='space-y-4'>
                  <div className='space-y-2'>
                    <label htmlFor='email' className='text-sm font-medium'>
                      Email address
                    </label>
                    <Input
                      type='email'
                      id='email'
                      name='email'
                      placeholder='your@email.com'
                      className='h-11'
                      autoFocus
                      required
                    />
                    <p className='text-xs text-muted-foreground'>We&apos;ll send you a magic link to sign in</p>
                  </div>
                  <div className='flex gap-3'>
                    <Button type='button' variant='outline' className='flex-1' onClick={() => setEmailFormOpen(false)}>
                      Cancel
                    </Button>
                    <Button type='submit' className='flex-1' disabled={pending}>
                      Send Link
                    </Button>
                  </div>
                </form>
              </div>
            </CollapsibleContent>
          </Collapsible>

          {/* Terms and Privacy */}
          {mode === 'signup' && (
            <p className='px-4 text-center text-xs text-muted-foreground'>
              By continuing, you agree to our{' '}
              <Link href='/terms' className='underline hover:text-foreground'>
                Terms of Service
              </Link>{' '}
              and{' '}
              <Link href='/privacy' className='underline hover:text-foreground'>
                Privacy Policy
              </Link>
            </p>
          )}

          {/* Switch between login/signup */}
          <div className='text-center text-sm'>
            {mode === 'signup' ? (
              <p className='text-muted-foreground'>
                Already have an account?{' '}
                <Link href='/login' className='text-primary hover:underline'>
                  Sign in
                </Link>
              </p>
            ) : (
              <p className='text-muted-foreground'>
                Don&apos;t have an account?{' '}
                <Link href='/signup' className='text-primary hover:underline'>
                  Sign up
                </Link>
              </p>
            )}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
