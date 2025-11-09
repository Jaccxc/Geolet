# Step 10: Insight Analytics & Visualization

**Timeline:** 6-8 hours
**Priority:** Medium (Completes Insight feature)

## Overview
Build analytics dashboards that visualize user strengths/weaknesses by analyzing imported GeoGuessr data. Includes skill heatmaps and confusion matrices.

## Prerequisites
- Step 9 completed (Import functionality working)
- Familiarity with data aggregation
- Basic understanding of data visualization

## Detailed Tasks

### 10.1 Install Visualization Dependencies

```bash
bun add recharts
bunx shadcn-ui@latest add tabs
bunx shadcn-ui@latest add hover-card
```

### 10.2 Create Analytics Controllers

#### `/src/features/insight/controllers/calculate-skill-map.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import type { SkillMapCell } from '../types';

export async function calculateSkillMap(userId: string): Promise<SkillMapCell[]> {
  const supabase = await createClient();

  // Aggregate by target_country
  const { data, error } = await supabase
    .from('insight_rounds')
    .select('target_country, country, distance_m, time_ms')
    .eq('user_id', userId);

  if (error || !data) return [];

  // Group by target_country
  const grouped = data.reduce((acc, round) => {
    const target = round.target_country || 'Unknown';

    if (!acc[target]) {
      acc[target] = {
        total: 0,
        correct: 0,
        totalTime: 0,
      };
    }

    acc[target].total++;

    // Consider correct if distance < 1000km or country matches
    const isCorrect =
      round.country === round.target_country ||
      (round.distance_m && round.distance_m < 1000000);

    if (isCorrect) {
      acc[target].correct++;
    }

    if (round.time_ms) {
      acc[target].totalTime += round.time_ms;
    }

    return acc;
  }, {} as Record<string, any>);

  // Map to SkillMapCell format
  return Object.entries(grouped).map(([country, stats]) => ({
    family: 'country', // Could be extended to script/phone families
    country,
    accuracy: stats.correct / stats.total,
    count: stats.total,
    avg_time_ms: stats.totalTime / stats.total,
  }));
}
```

#### `/src/features/insight/controllers/calculate-confusions.ts`

```typescript
import { createClient } from '@/libs/supabase/supabase-server-client';
import type { ConfusionPair } from '../types';

export async function calculateConfusions(userId: string): Promise<ConfusionPair[]> {
  const supabase = await createClient();

  // Get all rounds where guess != answer
  const { data, error } = await supabase
    .from('insight_rounds')
    .select('country, target_country')
    .eq('user_id', userId)
    .neq('country', 'target_country');

  if (error || !data) return [];

  // Group by (from, to) pairs
  const grouped = data.reduce((acc, round) => {
    const from = round.country || 'Unknown';
    const to = round.target_country || 'Unknown';
    const key = `${from}→${to}`;

    if (!acc[key]) {
      acc[key] = {
        from_country: from,
        to_country: to,
        count: 0,
      };
    }

    acc[key].count++;

    return acc;
  }, {} as Record<string, any>);

  // Sort by count (descending)
  return Object.values(grouped)
    .sort((a, b) => b.count - a.count)
    .slice(0, 20); // Top 20 confusions
}
```

### 10.3 Create Analytics API Routes

#### `/src/app/api/insight/overview/route.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';
import { calculateSkillMap } from '@/features/insight/controllers/calculate-skill-map';
import { calculateConfusions } from '@/features/insight/controllers/calculate-confusions';

export async function GET(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    // Get total rounds
    const { count } = await supabase
      .from('insight_rounds')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', user.id);

    // Calculate skill map and confusions
    const [skillMap, confusions] = await Promise.all([
      calculateSkillMap(user.id),
      calculateConfusions(user.id),
    ]);

    return NextResponse.json({
      total_rounds: count || 0,
      skill_map: skillMap,
      confusions,
    });
  } catch (error) {
    console.error('Overview error:', error);
    return NextResponse.json(
      { error: 'Failed to calculate overview' },
      { status: 500 }
    );
  }
}
```

### 10.4 Create Visualization Components

#### `/src/features/insight/components/skill-heatmap.tsx`

```typescript
'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import type { SkillMapCell } from '../types';

interface SkillHeatmapProps {
  data: SkillMapCell[];
}

export function SkillHeatmap({ data }: SkillHeatmapProps) {
  // Sort by accuracy (ascending) to show weakest first
  const sorted = [...data].sort((a, b) => a.accuracy - b.accuracy);

  return (
    <Card>
      <CardHeader>
        <CardTitle>Skill Map</CardTitle>
        <CardDescription>
          Your accuracy by country (weakest to strongest)
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {sorted.map((cell) => {
            const percentage = Math.round(cell.accuracy * 100);
            const color = getAccuracyColor(cell.accuracy);

            return (
              <div
                key={cell.country}
                className="flex items-center gap-3 p-3 border rounded-lg hover:bg-muted/50 transition"
              >
                <div className="flex-1">
                  <div className="font-medium">{cell.country}</div>
                  <div className="text-sm text-muted-foreground">
                    {cell.count} rounds • {(cell.avg_time_ms / 1000).toFixed(1)}s avg
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <div className="w-24 h-2 bg-muted rounded-full overflow-hidden">
                    <div
                      className="h-full transition-all"
                      style={{
                        width: `${percentage}%`,
                        backgroundColor: color,
                      }}
                    />
                  </div>
                  <Badge
                    variant="secondary"
                    className="w-16 justify-center"
                    style={{ backgroundColor: `${color}20`, color }}
                  >
                    {percentage}%
                  </Badge>
                </div>
              </div>
            );
          })}

          {sorted.length === 0 && (
            <div className="text-center py-8 text-muted-foreground">
              No data yet. Import your game history to see insights!
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}

function getAccuracyColor(accuracy: number): string {
  if (accuracy >= 0.8) return '#10b981'; // green
  if (accuracy >= 0.6) return '#f59e0b'; // amber
  return '#ef4444'; // red
}
```

#### `/src/features/insight/components/confusion-matrix.tsx`

```typescript
'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { ArrowRight } from 'lucide-react';
import type { ConfusionPair } from '../types';

interface ConfusionMatrixProps {
  data: ConfusionPair[];
}

export function ConfusionMatrix({ data }: ConfusionMatrixProps) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>Common Mistakes</CardTitle>
        <CardDescription>
          Countries you frequently confuse with each other
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-2">
          {data.slice(0, 10).map((pair, i) => (
            <div
              key={i}
              className="flex items-center gap-3 p-3 border rounded-lg"
            >
              <div className="flex-1 flex items-center gap-2">
                <span className="font-medium">{pair.from_country}</span>
                <ArrowRight className="w-4 h-4 text-muted-foreground" />
                <span className="font-medium">{pair.to_country}</span>
              </div>
              <div className="text-sm text-muted-foreground">
                {pair.count} times
              </div>
            </div>
          ))}

          {data.length === 0 && (
            <div className="text-center py-8 text-muted-foreground">
              No confusion patterns detected yet.
            </div>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
```

#### `/src/features/insight/components/overview-dashboard.tsx`

```typescript
'use client';

import { useEffect, useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { SkillHeatmap } from './skill-heatmap';
import { ConfusionMatrix } from './confusion-matrix';
import { Trophy, Target, TrendingDown } from 'lucide-react';

export function OverviewDashboard() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchOverview() {
      const response = await fetch('/api/insight/overview');
      const result = await response.json();
      setData(result);
      setLoading(false);
    }

    fetchOverview();
  }, []);

  if (loading) {
    return <div className="text-center py-12">Loading insights...</div>;
  }

  if (!data || data.total_rounds === 0) {
    return (
      <Card>
        <CardContent className="text-center py-12">
          <p className="text-muted-foreground">
            Import your game history to unlock personalized insights!
          </p>
        </CardContent>
      </Card>
    );
  }

  // Calculate stats
  const avgAccuracy = data.skill_map.length > 0
    ? data.skill_map.reduce((sum: number, cell: any) => sum + cell.accuracy, 0) / data.skill_map.length
    : 0;

  const weakestCountries = data.skill_map
    .sort((a: any, b: any) => a.accuracy - b.accuracy)
    .slice(0, 3)
    .map((cell: any) => cell.country);

  return (
    <div className="space-y-6">
      {/* Stats Overview */}
      <div className="grid grid-cols-3 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Rounds</CardTitle>
            <Trophy className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{data.total_rounds}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Avg Accuracy</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{Math.round(avgAccuracy * 100)}%</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Countries Played</CardTitle>
            <TrendingDown className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{data.skill_map.length}</div>
          </CardContent>
        </Card>
      </div>

      {/* Skill Heatmap */}
      <SkillHeatmap data={data.skill_map} />

      {/* Confusion Matrix */}
      <ConfusionMatrix data={data.confusions} />
    </div>
  );
}
```

### 10.5 Update Insight Page

Modify `/src/app/(account)/insight/page.tsx`:

```typescript
'use client';

import { useState } from 'react';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { ImportWizard } from '@/features/insight/components/import-wizard';
import { OverviewDashboard } from '@/features/insight/components/overview-dashboard';

export default function InsightPage() {
  return (
    <div className="container py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">Insight</h1>
        <p className="text-muted-foreground mt-2">
          Analyze your GeoGuessr performance and find areas to improve
        </p>
      </div>

      <Tabs defaultValue="overview">
        <TabsList>
          <TabsTrigger value="overview">Overview</TabsTrigger>
          <TabsTrigger value="import">Import Data</TabsTrigger>
        </TabsList>

        <TabsContent value="overview" className="mt-6">
          <OverviewDashboard />
        </TabsContent>

        <TabsContent value="import" className="mt-6">
          <ImportWizard />
        </TabsContent>
      </Tabs>
    </div>
  );
}
```

## Files to Create/Modify

### Created:
- `/src/features/insight/controllers/calculate-skill-map.ts`
- `/src/features/insight/controllers/calculate-confusions.ts`
- `/src/features/insight/components/skill-heatmap.tsx`
- `/src/features/insight/components/confusion-matrix.tsx`
- `/src/features/insight/components/overview-dashboard.tsx`
- `/src/app/api/insight/overview/route.ts`

### Modified:
- `/src/app/(account)/insight/page.tsx` (add tabs and dashboard)

## Acceptance Criteria
- ✅ Overview tab shows total rounds, avg accuracy, countries played
- ✅ Skill heatmap displays countries sorted by accuracy
- ✅ Heatmap uses color coding (red/amber/green)
- ✅ Confusion matrix shows top 10 country pairs
- ✅ Empty state when no data imported
- ✅ API aggregates data correctly
- ✅ Responsive layout on mobile

## Notes & Considerations

### Accuracy Calculation
- **Correct**: Country match OR distance < 1000km
- **Percentage**: (correct / total) * 100

### Visualization Design
- **Color scale**: Red (<60%), Amber (60-80%), Green (>80%)
- **Sort order**: Weakest first (helps identify training targets)
- **Hover states**: Show detailed stats

### Performance
- Cache overview API response client-side
- Consider pagination for large datasets
- Server-side aggregation (don't fetch all rows)

### Future Enhancements
- Filter by date range
- Breakdown by map type (country, world, etc.)
- Detailed per-country drill-down
- Export reports as PDF

## Dependencies
- Step 9 (Import functionality)

## Blocks
- Step 11 (Prescription system)
