'use client';

import { FormEvent, useState } from 'react';
import Image from 'next/image';
import { useRouter } from 'next/navigation';

import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { PasswordInput } from '@/components/ui/password-input';
import { PasswordStrengthIndicator } from '@/components/ui/password-strength-indicator';
import { toast } from '@/components/ui/use-toast';
import { createSupabaseBrowserClient } from '@/libs/supabase/supabase-browser-client';

export default function ResetPasswordPage() {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [pending, setPending] = useState(false);
  const router = useRouter();

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setPending(true);

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

    try {
      const supabase = createSupabaseBrowserClient();
      const { error } = await supabase.auth.updateUser({ password });

      if (error) {
        console.error('Error updating password:', error);
        toast({
          variant: 'destructive',
          description: error.message || 'Failed to reset password. Please try again.',
        });
      } else {
        toast({
          description: 'Password successfully updated! Redirecting to login...',
        });
        
        // Sign out and redirect to login
        await supabase.auth.signOut();
        setTimeout(() => {
          router.push('/login');
        }, 2000);
      }
    } catch (error) {
      console.error('Unexpected error:', error);
      toast({
        variant: 'destructive',
        description: 'An unexpected error occurred. Please try again.',
      });
    }

    setPending(false);
  }

  return (
    <div className='container mx-auto px-4'>
      <div className='flex min-h-[calc(100vh-140px)] items-center justify-center py-12'>
        <Card className='w-full max-w-md border-border bg-card'>
          <CardHeader className='space-y-1 text-center'>
            <div className='mb-4 flex justify-center'>
              <Image src='/logo.png' width={64} height={64} alt='Geolet Logo' className='rounded-lg' />
            </div>
            <CardTitle className='text-2xl font-bold'>Reset Your Password</CardTitle>
            <CardDescription className='text-base'>
              Enter your new password below
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className='space-y-4'>
              <div className='space-y-2'>
                <label htmlFor='password' className='text-sm font-medium'>
                  New Password
                </label>
                <PasswordInput
                  id='password'
                  name='password'
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  placeholder='Enter your new password'
                  required
                  autoComplete='new-password'
                  className='h-11'
                />
                <PasswordStrengthIndicator password={password} />
              </div>

              <div className='space-y-2'>
                <label htmlFor='confirmPassword' className='text-sm font-medium'>
                  Confirm New Password
                </label>
                <PasswordInput
                  id='confirmPassword'
                  name='confirmPassword'
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder='Confirm your new password'
                  required
                  autoComplete='new-password'
                  className='h-11'
                />
              </div>

              <Button type='submit' className='h-12 w-full text-base font-medium' disabled={pending}>
                {pending ? 'Resetting...' : 'Reset Password'}
              </Button>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

