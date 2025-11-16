'use client';

import { useState } from 'react';
import Image from 'next/image';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import { IoPersonCircleOutline } from 'react-icons/io5';

import {
  DropdownMenu,
  DropdownMenuArrow,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { ActionResponse } from '@/types/action-response';

import { useToast } from './ui/use-toast';

interface AccountMenuProps {
  signOut: () => Promise<ActionResponse>;
  displayName?: string | null;
  avatarUrl?: string | null;
}

export function AccountMenu({ signOut, displayName, avatarUrl }: AccountMenuProps) {
  const router = useRouter();
  const { toast } = useToast();
  const [avatarFailed, setAvatarFailed] = useState(false);

  async function handleLogoutClick() {
    const response = await signOut();

    if (response?.error) {
      toast({
        variant: 'destructive',
        description: 'An error occurred while logging out. Please try again or contact support.',
      });
    } else {
      router.refresh();

      toast({
        description: 'You have been logged out.',
      });
    }
  }

  const showInitials = !avatarUrl || avatarFailed;
  const avatarInitial = displayName?.trim().charAt(0).toUpperCase() ?? null;

  return (
    <DropdownMenu>
      <DropdownMenuTrigger className='rounded-full focus:outline-none'>
        {showInitials ? (
          <div className='flex h-10 w-10 items-center justify-center rounded-full bg-white/10 text-sm font-semibold uppercase text-white'>
            {avatarInitial ? avatarInitial : <IoPersonCircleOutline size={24} />}
          </div>
        ) : (
          <Image
            src={avatarUrl!}
            alt={displayName ?? 'User avatar'}
            width={40}
            height={40}
            className='h-10 w-10 rounded-full object-cover'
            onError={() => setAvatarFailed(true)}
          />
        )}
      </DropdownMenuTrigger>
      <DropdownMenuContent className='me-4 w-48'>
        <div className='px-2 py-1 text-xs uppercase text-muted-foreground'>Signed in</div>
        <div className='px-2 pb-2 text-sm font-medium text-white'>{displayName ?? 'Name not set'}</div>
        <DropdownMenuSeparator />
        <DropdownMenuItem asChild>
          <Link href='/rapid'>Rapid</Link>
        </DropdownMenuItem>
        <DropdownMenuItem asChild>
          <Link href='/insight'>Insight</Link>
        </DropdownMenuItem>
        <DropdownMenuItem asChild>
          <Link href='/account'>Account</Link>
        </DropdownMenuItem>
        <DropdownMenuItem onClick={handleLogoutClick}>Log Out</DropdownMenuItem>
        <DropdownMenuArrow className='me-4 fill-white' />
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
