'use client';

import { Check, X } from 'lucide-react';

import { Progress } from '@/components/ui/progress';

interface PasswordStrengthIndicatorProps {
  password: string;
}

export function PasswordStrengthIndicator({ password }: PasswordStrengthIndicatorProps) {
  const checks = {
    length: password.length >= 8,
    hasLetters: /[a-zA-Z]/.test(password),
    hasDigits: /\d/.test(password),
  };

  const strength = Object.values(checks).filter(Boolean).length;
  const strengthPercent = (strength / 3) * 100;

  const strengthLabel = strength <= 1 ? 'Weak' : strength === 2 ? 'Medium' : 'Strong';

  const strengthColor =
    strength <= 1 ? 'bg-red-500' : strength === 2 ? 'bg-yellow-500' : 'bg-green-500';

  if (password.length === 0) {
    return null;
  }

  return (
    <div className='space-y-2'>
      <div className='flex items-center justify-between text-sm'>
        <span className='text-muted-foreground'>Password strength:</span>
        <span className={`font-medium ${strengthColor.replace('bg-', 'text-')}`}>{strengthLabel}</span>
      </div>
      <Progress value={strengthPercent} className={strengthColor} />
      <div className='space-y-1 text-xs text-muted-foreground'>
        <div className='flex items-center gap-2'>
          {checks.length ? (
            <Check className='h-3 w-3 text-green-500' />
          ) : (
            <X className='h-3 w-3 text-red-500' />
          )}
          <span>At least 8 characters</span>
        </div>
        <div className='flex items-center gap-2'>
          {checks.hasLetters ? (
            <Check className='h-3 w-3 text-green-500' />
          ) : (
            <X className='h-3 w-3 text-red-500' />
          )}
          <span>Contains letters</span>
        </div>
        <div className='flex items-center gap-2'>
          {checks.hasDigits ? (
            <Check className='h-3 w-3 text-green-500' />
          ) : (
            <X className='h-3 w-3 text-red-500' />
          )}
          <span>Contains numbers</span>
        </div>
      </div>
    </div>
  );
}

