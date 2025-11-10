// src/libs/supabase/supabase-server-client.ts
import { cookies } from 'next/headers';

import { getEnvVar } from '@/utils/get-env-var';
import { createServerClient } from '@supabase/ssr';

export async function createSupabaseServerClient() {
  const cookieStore = await cookies();

  return createServerClient(
    getEnvVar(process.env.NEXT_PUBLIC_SUPABASE_URL, 'NEXT_PUBLIC_SUPABASE_URL'),
    getEnvVar(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY, 'NEXT_PUBLIC_SUPABASE_ANON_KEY'),
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) => cookieStore.set(name, value, options));
          } catch {
            // Called inside a Server Component (read-only cookies)
            // Can be safely ignored if middleware handles session refresh.
          }
        },
      },
    }
  );
}
