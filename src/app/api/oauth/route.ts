import { NextRequest } from 'next/server';

import { getEnvVar } from '@/utils/get-env-var';

export const runtime = 'nodejs';

const SUPABASE_BASE_URL = getEnvVar(process.env.NEXT_PUBLIC_SUPABASE_URL, 'NEXT_PUBLIC_SUPABASE_URL');
const OAUTH_CALLBACK_PATH = '/auth/v1/callback';

async function proxyToSupabase(request: NextRequest) {
  const targetUrl = new URL(OAUTH_CALLBACK_PATH, SUPABASE_BASE_URL);
  targetUrl.search = request.nextUrl.search;

  const outgoingHeaders = new Headers(request.headers);
  outgoingHeaders.delete('host');
  outgoingHeaders.delete('connection');
  outgoingHeaders.delete('content-length');
  outgoingHeaders.delete('accept-encoding');

  const method = request.method.toUpperCase();
  const body = method === 'GET' || method === 'HEAD' ? undefined : (request as any).body;

  const upstreamResponse = await fetch(targetUrl.toString(), {
    method,
    headers: outgoingHeaders,
    body,
    // Preserve 3xx redirects from Supabase to the client
    redirect: 'manual',
  });

  const responseHeaders = new Headers(upstreamResponse.headers);
  return new Response(upstreamResponse.body, {
    status: upstreamResponse.status,
    statusText: upstreamResponse.statusText,
    headers: responseHeaders,
  });
}

export async function GET(request: NextRequest) {
  return proxyToSupabase(request);
}

export async function POST(request: NextRequest) {
  return proxyToSupabase(request);
}

export async function HEAD(request: NextRequest) {
  return proxyToSupabase(request);
}

export async function OPTIONS(request: NextRequest) {
  return proxyToSupabase(request);
}
