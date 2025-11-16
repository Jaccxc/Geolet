'use server';

import { revalidatePath } from 'next/cache';

import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import { ActionResponse } from '@/types/action-response';

export async function updateFullName(fullName: string): Promise<ActionResponse> {
  const supabase = await createSupabaseServerClient();
  const trimmedName = fullName.trim();

  if (!trimmedName) {
    return {
      data: null,
      error: new Error('Please enter a valid name.'),
    };
  }

  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    console.error('Unable to get authenticated user:', authError);
    return { data: null, error: authError ?? new Error('Not authenticated') };
  }

  const { error } = await supabase.from('users').update({ full_name: trimmedName }).eq('id', user.id);

  if (error) {
    console.error('Failed to update full_name:', error);
    return { data: null, error };
  }

  revalidatePath('/', 'layout');

  return {
    data: { full_name: trimmedName },
    error: null,
  };
}

