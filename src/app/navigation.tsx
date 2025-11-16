import Link from 'next/link';
import { IoMenu } from 'react-icons/io5';

import { AccountMenu } from '@/components/account-menu';
import { Logo } from '@/components/logo';
import { Button } from '@/components/ui/button';
import { Sheet, SheetContent, SheetDescription, SheetHeader, SheetTrigger } from '@/components/ui/sheet';
import type { Tables } from '@/libs/supabase/types';

import { signOut } from './(auth)/auth-actions';

interface NavigationProps {
  isAuthenticated: boolean;
  user: Tables<'users'> | null;
}

export function Navigation({ isAuthenticated, user }: NavigationProps) {
  return (
    <div className='relative flex items-center gap-6'>
      {isAuthenticated ? (
        <div className='flex items-center gap-3'>
          <span className='hidden text-sm font-medium text-white/90 sm:inline-flex'>
            {user?.full_name ?? 'Set your name'}
          </span>
          <AccountMenu signOut={signOut} displayName={user?.full_name} avatarUrl={user?.avatar_url} />
        </div>
      ) : (
        <>
          <Button variant='default' className='hidden flex-shrink-0 lg:flex' asChild>
            <Link href='/signup'>Get started for free</Link>
          </Button>
          <Sheet>
            <SheetTrigger className='block lg:hidden'>
              <IoMenu size={28} />
            </SheetTrigger>
            <SheetContent className='w-full bg-black'>
              <SheetHeader>
                <Logo />
                <SheetDescription className='py-8'>
                  <Button variant='default' className='flex-shrink-0' asChild>
                    <Link href='/signup'>Get started for free</Link>
                  </Button>
                </SheetDescription>
              </SheetHeader>
            </SheetContent>
          </Sheet>
        </>
      )}
    </div>
  );
}
