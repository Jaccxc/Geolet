// src/middleware.ts or src/libs/supabase/supabase-middleware-client.ts
import { NextRequest, NextResponse } from 'next/server';

import { getEnvVar } from '@/utils/get-env-var';
import { createServerClient } from '@supabase/ssr';

export async function updateSession(request: NextRequest) {
  // Always start with a NextResponse referencing the current request
  let response = NextResponse.next({ request });

  const supabase = createServerClient(
    getEnvVar(process.env.NEXT_PUBLIC_SUPABASE_URL, 'NEXT_PUBLIC_SUPABASE_URL'),
    getEnvVar(process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY, 'NEXT_PUBLIC_SUPABASE_ANON_KEY'),
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) => {
            // write to both request + response to keep them in sync
            request.cookies.set(name, value);
            response.cookies.set(name, value, options);
          });
        },
      },
    }
  );

  // ⚠️ Required once per request to keep Supabase session refreshed
  const {
    data: { user },
  } = await supabase.auth.getUser();

  // 🔐 Optional route guard example
  // if (!user && request.nextUrl.pathname.startsWith('/dashboard')) {
  //   const url = request.nextUrl.clone()
  //   url.pathname = '/login'
  //   return NextResponse.redirect(url)
  // }

  // Return the response object that carries updated cookies
  return response;
}
