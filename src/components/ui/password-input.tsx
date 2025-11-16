'use client';

import { useState } from 'react';
import { Eye, EyeOff } from 'lucide-react';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

interface PasswordInputProps {
  id: string;
  name: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  required?: boolean;
  autoComplete?: string;
  className?: string;
}

export function PasswordInput({
  id,
  name,
  value,
  onChange,
  placeholder = 'Password',
  required = true,
  autoComplete = 'current-password',
  className = '',
}: PasswordInputProps) {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className='relative'>
      <Input
        type={showPassword ? 'text' : 'password'}
        id={id}
        name={name}
        value={value}
        onChange={onChange}
        placeholder={placeholder}
        required={required}
        autoComplete={autoComplete}
        className={`pr-10 ${className}`}
      />
      <Button
        type='button'
        variant='ghost'
        size='sm'
        className='absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent'
        onClick={() => setShowPassword(!showPassword)}
        tabIndex={-1}
      >
        {showPassword ? (
          <EyeOff className='h-4 w-4 text-muted-foreground' />
        ) : (
          <Eye className='h-4 w-4 text-muted-foreground' />
        )}
        <span className='sr-only'>{showPassword ? 'Hide password' : 'Show password'}</span>
      </Button>
    </div>
  );
}

