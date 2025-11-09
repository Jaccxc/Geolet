# Step 11: Insight Prescription System

**Timeline:** 4-5 hours
**Priority:** Medium (Connects Insight → Flash)

## Overview
Build the prescription system that analyzes user weaknesses from Insight and generates recommended Flash training sessions.

## Prerequisites
- Step 10 completed (Analytics available)
- Step 5 completed (Flash queue API)

## Detailed Tasks

### 11.1 Create Prescription Logic

#### `/src/features/insight/controllers/generate-prescription.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import type { Prescription } from '../types';
import { calculateSkillMap } from './calculate-skill-map';

export async function generatePrescription(userId: string): Promise<Prescription[]> {
  const supabase = await createClient();

  // Get skill map (countries by accuracy)
  const skillMap = await calculateSkillMap(userId);

  if (skillMap.length === 0) {
    return [];
  }

  // Find weakest countries (accuracy < 60% and at least 5 rounds)
  const weakCountries = skillMap
    .filter(cell => cell.accuracy < 0.6 && cell.count >= 5)
    .sort((a, b) => a.accuracy - b.accuracy)
    .slice(0, 5);

  const prescriptions: Prescription[] = [];

  for (const country of weakCountries) {
    // Map country to relevant skill tags
    const tags = await getSkillTagsForCountry(country.country);

    if (tags.length > 0) {
      prescriptions.push({
        skill_tags: tags,
        reason: `Low accuracy (${Math.round(country.accuracy * 100)}%) in ${country.country}`,
        priority: 1 - country.accuracy, // Lower accuracy = higher priority
      });
    }
  }

  // Sort by priority (descending)
  prescriptions.sort((a, b) => b.priority - a.priority);

  return prescriptions;
}

async function getSkillTagsForCountry(countryCode: string): Promise<string[]> {
  const supabase = await createClient();

  // Get skill tags associated with this country
  const { data } = await supabase
    .from('skill_tags')
    .select('key')
    .eq('country', countryCode);

  return data ? data.map(row => row.key) : [];
}
```

### 11.2 Create Prescription API Route

#### `/src/app/api/insight/prescribe/route.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { generatePrescription } from '@/features/insight/controllers/generate-prescription';

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const prescriptions = await generatePrescription(user.id);

    return NextResponse.json({
      prescriptions,
      count: prescriptions.length,
    });
  } catch (error) {
    console.error('Prescription error:', error);
    return NextResponse.json(
      { error: 'Failed to generate prescription' },
      { status: 500 }
    );
  }
}
```

### 11.3 Create Prescription UI Component

#### `/src/features/insight/components/prescription-panel.tsx`

```typescript
'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Lightbulb, Play } from 'lucide-react';
import type { Prescription } from '../types';

export function PrescriptionPanel() {
  const [prescriptions, setPrescriptions] = useState<Prescription[]>([]);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    async function fetchPrescriptions() {
      const response = await fetch('/api/insight/prescribe');
      const data = await response.json();
      setPrescriptions(data.prescriptions || []);
      setLoading(false);
    }

    fetchPrescriptions();
  }, []);

  const handleStartTraining = (tags: string[]) => {
    // Redirect to Flash with pre-configured session
    const params = new URLSearchParams({
      mode: 'language-choice', // Default to language
      tags: tags.join(','),
      source: 'insight',
    });

    router.push(`/flash?${params.toString()}`);
  };

  if (loading) {
    return <div className="text-center py-4">Loading recommendations...</div>;
  }

  if (prescriptions.length === 0) {
    return (
      <Card>
        <CardContent className="text-center py-8">
          <p className="text-muted-foreground">
            Keep playing to unlock personalized training recommendations!
          </p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Lightbulb className="w-5 h-5 text-yellow-500" />
          Recommended Training
        </CardTitle>
        <CardDescription>
          Based on your recent performance, here's what you should practice
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        {prescriptions.slice(0, 3).map((prescription, i) => (
          <div
            key={i}
            className="flex items-center gap-3 p-4 border rounded-lg hover:bg-muted/50 transition"
          >
            <div className="flex-1">
              <div className="font-medium mb-1">{prescription.reason}</div>
              <div className="flex flex-wrap gap-1">
                {prescription.skill_tags.slice(0, 3).map(tag => (
                  <Badge key={tag} variant="secondary" className="text-xs">
                    {tag}
                  </Badge>
                ))}
                {prescription.skill_tags.length > 3 && (
                  <Badge variant="outline" className="text-xs">
                    +{prescription.skill_tags.length - 3} more
                  </Badge>
                )}
              </div>
            </div>

            <Button
              size="sm"
              onClick={() => handleStartTraining(prescription.skill_tags)}
              className="gap-2"
            >
              <Play className="w-4 h-4" />
              Train
            </Button>
          </div>
        ))}
      </CardContent>
    </Card>
  );
}
```

### 11.4 Update Overview Dashboard

Modify `/src/features/insight/components/overview-dashboard.tsx`:

```typescript
import { PrescriptionPanel } from './prescription-panel';

// ... in render
return (
  <div className="space-y-6">
    {/* Stats Overview */}
    {/* ... existing stats cards ... */}

    {/* Prescription Panel */}
    <PrescriptionPanel />

    {/* Skill Heatmap */}
    <SkillHeatmap data={data.skill_map} />

    {/* Confusion Matrix */}
    <ConfusionMatrix data={data.confusions} />
  </div>
);
```

### 11.5 Update Flash Page to Accept Query Params

Modify `/src/app/(account)/flash/page.tsx`:

```typescript
'use client';

import { useEffect, useState } from 'react';
import { useSearchParams } from 'next/navigation';
// ... existing imports

export default function FlashPage() {
  const searchParams = useSearchParams();
  // ... existing state

  useEffect(() => {
    // Auto-start session from Insight prescription
    const mode = searchParams.get('mode');
    const tags = searchParams.get('tags');
    const source = searchParams.get('source');

    if (mode && tags && source === 'insight') {
      handleStartSession({
        mode: mode as any,
        targetTags: tags.split(','),
        maxCards: 20,
      });
    }
  }, [searchParams]);

  // ... rest of component
}
```

### 11.6 Add "Train Weak Spots" Quick Action

Create `/src/features/insight/components/quick-train-button.tsx`:

```typescript
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Zap } from 'lucide-react';

export function QuickTrainButton() {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);

    // Get prescription
    const response = await fetch('/api/insight/prescribe');
    const data = await response.json();

    if (data.prescriptions && data.prescriptions.length > 0) {
      const topPrescription = data.prescriptions[0];
      const params = new URLSearchParams({
        mode: 'language-choice',
        tags: topPrescription.skill_tags.join(','),
        source: 'insight',
      });

      window.location.href = `/flash?${params.toString()}`;
    } else {
      alert('No weak spots found! Keep playing to unlock recommendations.');
      setLoading(false);
    }
  };

  return (
    <Button
      onClick={handleClick}
      disabled={loading}
      size="lg"
      className="gap-2"
    >
      <Zap className="w-5 h-5" />
      {loading ? 'Loading...' : 'Train My Weak Spots'}
    </Button>
  );
}
```

Add to overview dashboard as prominent CTA.

## Files to Create/Modify

### Created:
- `/src/features/insight/controllers/generate-prescription.ts`
- `/src/features/insight/components/prescription-panel.tsx`
- `/src/features/insight/components/quick-train-button.tsx`
- `/src/app/api/insight/prescribe/route.ts`

### Modified:
- `/src/features/insight/components/overview-dashboard.tsx` (add prescription panel)
- `/src/app/(account)/flash/page.tsx` (accept query params)

## Acceptance Criteria
- ✅ Prescription API identifies weak countries/tags
- ✅ Prescription panel displays top 3 recommendations
- ✅ "Train" button redirects to Flash with pre-configured session
- ✅ Flash page auto-starts session from URL params
- ✅ "Train My Weak Spots" quick action works
- ✅ Empty state when no prescriptions available

## Notes & Considerations

### Prescription Logic
- **Threshold**: Accuracy < 60% and ≥5 rounds
- **Limit**: Top 5 weakest countries
- **Priority**: Based on accuracy (lower = higher priority)

### Tag Mapping
- For MVP: Map country codes to skill_tags by country field
- Future: More sophisticated mapping (confusions → related tags)

### UX Flow
1. User views Insight dashboard
2. Sees "Low accuracy in India" recommendation
3. Clicks "Train" button
4. Redirected to Flash with Indian language tags
5. Starts adaptive session immediately

### Future Enhancements
- Multi-family prescriptions (scripts + phones)
- Spaced repetition scheduling
- "Drill of the day" notification
- Progress tracking per prescription

## Dependencies
- Step 10 (Analytics)
- Step 5 (Flash Queue API)

## Blocks
- None (completes Insight → Flash integration)
