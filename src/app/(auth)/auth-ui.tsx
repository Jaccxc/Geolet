'use client';

import { FormEvent, useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { IoLogoGoogle } from 'react-icons/io5';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { PasswordInput } from '@/components/ui/password-input';
import { PasswordStrengthIndicator } from '@/components/ui/password-strength-indicator';
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
  signUp,
  signInWithPassword,
  resendConfirmationEmail,
  requestPasswordReset,
}: {
  mode: 'login' | 'signup';
  signInWithOAuth: (provider: 'github' | 'google') => Promise<ActionResponse>;
  signUp: (email: string, password: string) => Promise<ActionResponse>;
  signInWithPassword: (email: string, password: string) => Promise<ActionResponse>;
  resendConfirmationEmail: (email: string) => Promise<ActionResponse>;
  requestPasswordReset: (email: string) => Promise<ActionResponse>;
}) {
  const [pending, setPending] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showForgotPassword, setShowForgotPassword] = useState(false);
  const [showResendConfirmation, setShowResendConfirmation] = useState(false);

  async function handlePasswordSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setPending(true);

    if (mode === 'signup') {
      // Validate password match
      if (password !== confirmPassword) {
        toast({
          variant: 'destructive',
          description: 'Passwords do not match. Please try again.',
        });
        setPending(false);
        return;
      }

      // Validate password requirements
      if (password.length < 8) {
        toast({
          variant: 'destructive',
          description: 'Password must be at least 8 characters long.',
        });
        setPending(false);
        return;
      }

      if (!/[a-zA-Z]/.test(password) || !/\d/.test(password)) {
        toast({
          variant: 'destructive',
          description: 'Password must contain both letters and numbers.',
        });
        setPending(false);
        return;
      }

      const response = await signUp(email, password);

      if (response?.error) {
        toast({
          variant: 'destructive',
          description: response.error.message || 'An error occurred while signing up. Please try again.',
        });
      } else {
        toast({
          description: `Success! Please check your email at ${email} and click the confirmation link to complete your registration.`,
        });
        setEmail('');
        setPassword('');
        setConfirmPassword('');
      }
    } else {
      // Login mode
      const response = await signInWithPassword(email, password);

      if (response?.error) {
        const errorMessage = response.error.message || '';
        
        if (errorMessage.includes('Email not confirmed') || errorMessage.includes('confirm your email')) {
          setShowResendConfirmation(true);
          toast({
            variant: 'destructive',
            description: 'Please confirm your email address before signing in.',
          });
        } else {
          toast({
            variant: 'destructive',
            description: 'Invalid email or password. Please try again.',
          });
        }
      } else {
        toast({
          description: 'Successfully signed in!',
        });
        // The redirect will be handled by the server action
      }
    }

    setPending(false);
  }

  async function handleResendConfirmation() {
    if (!email) {
      toast({
        variant: 'destructive',
        description: 'Please enter your email address.',
      });
      return;
    }

    setPending(true);
    const response = await resendConfirmationEmail(email);

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: 'Failed to resend confirmation email. Please try again.',
      });
    } else {
      toast({
        description: `Confirmation email sent to ${email}. Please check your inbox.`,
      });
      setShowResendConfirmation(false);
    }

    setPending(false);
  }

  async function handleForgotPassword() {
    if (!email) {
      toast({
        variant: 'destructive',
        description: 'Please enter your email address.',
      });
      return;
    }

    setPending(true);
    const response = await requestPasswordReset(email);

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: 'Failed to send password reset email. Please try again.',
      });
    } else {
      toast({
        description: `Password reset email sent to ${email}. Please check your inbox.`,
      });
      setShowForgotPassword(false);
    }

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

          {/* Email/Password Form */}
          <form onSubmit={handlePasswordSubmit} className='space-y-4'>
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
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                autoComplete='email'
              />
            </div>

            <div className='space-y-2'>
              <label htmlFor='password' className='text-sm font-medium'>
                Password
              </label>
              <PasswordInput
                id='password'
                name='password'
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder='Enter your password'
                required
                autoComplete={mode === 'signup' ? 'new-password' : 'current-password'}
                className='h-11'
              />
              {mode === 'signup' && <PasswordStrengthIndicator password={password} />}
            </div>

            {mode === 'signup' && (
              <div className='space-y-2'>
                <label htmlFor='confirmPassword' className='text-sm font-medium'>
                  Confirm Password
                </label>
                <PasswordInput
                  id='confirmPassword'
                  name='confirmPassword'
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder='Confirm your password'
                  required
                  autoComplete='new-password'
                  className='h-11'
                />
              </div>
            )}

            {mode === 'login' && (
              <div className='flex items-center justify-between'>
                <button
                  type='button'
                  onClick={() => setShowForgotPassword(true)}
                  className='text-sm text-primary hover:underline'
                  disabled={pending}
                >
                  Forgot password?
                </button>
              </div>
            )}

            {showResendConfirmation && mode === 'login' && (
              <div className='rounded-lg border border-yellow-500/20 bg-yellow-500/10 p-3'>
                <p className='mb-2 text-sm text-yellow-600 dark:text-yellow-400'>
                  Email not confirmed yet?
                </p>
                <Button
                  type='button'
                  variant='outline'
                  size='sm'
                  onClick={handleResendConfirmation}
                  disabled={pending}
                  className='w-full'
                >
                  Resend Confirmation Email
                </Button>
              </div>
            )}

            {showForgotPassword && mode === 'login' && (
              <div className='rounded-lg border border-blue-500/20 bg-blue-500/10 p-3'>
                <p className='mb-2 text-sm text-blue-600 dark:text-blue-400'>
                  We&apos;ll send a password reset link to {email || 'your email'}
                </p>
                <div className='flex gap-2'>
                  <Button
                    type='button'
                    variant='outline'
                    size='sm'
                    onClick={() => setShowForgotPassword(false)}
                    disabled={pending}
                    className='flex-1'
                  >
                    Cancel
                  </Button>
                  <Button
                    type='button'
                    size='sm'
                    onClick={handleForgotPassword}
                    disabled={pending}
                    className='flex-1'
                  >
                    Send Reset Link
                  </Button>
                </div>
              </div>
            )}

            <Button type='submit' className='h-12 w-full text-base font-medium' disabled={pending}>
              {pending ? 'Please wait...' : mode === 'signup' ? 'Create Account' : 'Sign In'}
            </Button>
          </form>

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
