import { NextRequest, NextResponse } from 'next/server';

import { getTopics } from '@/features/rapid/controllers/get-topics';

export async function GET(req: NextRequest) {
  try {
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
