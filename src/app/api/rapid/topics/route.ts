import { NextRequest, NextResponse } from 'next/server';

import { getTopics } from '@/features/rapid/controllers/get-topics';
import { createSupabaseServerClient } from '@/libs/supabase/supabase-server-client';

export async function GET(req: NextRequest) {
  try {
    const supabase = await createSupabaseServerClient();
    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const { searchParams } = new URL(req.url);
    const mode = searchParams.get('mode');

    const topics = await getTopics({
      pickModeActive: mode === 'pick' ? true : undefined,
      mapModeActive: mode === 'map' ? true : undefined,
    });

    return NextResponse.json({ topics });
  } catch (error) {
    console.error('Topics error:', error);
    return NextResponse.json(
      {
        error: 'Failed to fetch topics',
        details: error instanceof Error ? error.message : String(error),
      },
      { status: 500 }
    );
  }
}
