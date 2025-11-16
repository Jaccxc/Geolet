// ref: https://github.com/vercel/next.js/blob/canary/examples/with-supabase/app/auth/callback/route.ts

import type { NextRequest } from 'next/server';
import { NextResponse } from 'next/server';

import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';
import { getURL } from '@/utils/get-url';

const siteUrl = getURL();

export async function GET(request: NextRequest) {
  const requestUrl = new URL(request.url);
  const code = requestUrl.searchParams.get('code');
  const error = requestUrl.searchParams.get('error');
  const errorDescription = requestUrl.searchParams.get('error_description');

  // Handle errors from Supabase
  if (error) {
    console.error('Auth callback error:', error, errorDescription);
    return NextResponse.redirect(`${siteUrl}/login?error=${encodeURIComponent(errorDescription || error)}`);
  }

  if (code) {
    const supabase = await createSupabaseServerClient();
    
    // Exchange code for session
    const { error: exchangeError } = await supabase.auth.exchangeCodeForSession(code);

    if (exchangeError) {
      console.error('Error exchanging code for session:', exchangeError);
      return NextResponse.redirect(`${siteUrl}/login?error=${encodeURIComponent('Authentication failed')}`);
    }

    const {
      data: { user },
      error: userError,
    } = await supabase.auth.getUser();

    if (userError || !user?.id) {
      console.error('Error getting user:', userError);
      return NextResponse.redirect(`${siteUrl}/login?error=${encodeURIComponent('Failed to get user data')}`);
    }

    // Check if user is subscribed, if not redirect to pricing page
    const { data: userSubscription, error: subscriptionError } = await supabase
      .from('subscriptions')
      .select('*, prices(*, products(*))')
      .in('status', ['trialing', 'active'])
      .maybeSingle();

    if (subscriptionError) {
      console.error('Error checking subscription:', subscriptionError);
      // Continue anyway, will redirect to pricing if no subscription
    }

    if (!userSubscription) {
      return NextResponse.redirect(`${siteUrl}/pricing`);
    } else {
      return NextResponse.redirect(`${siteUrl}`);
    }
  }

  // No code provided, redirect to home
  return NextResponse.redirect(siteUrl);
}
