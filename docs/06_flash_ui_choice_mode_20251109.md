# Step 6: Flash UI - Choice Mode

**Timeline:** 8-10 hours
**Priority:** High (User-facing core feature)

## Overview
Build the Flash game UI using Shadcn components, focusing on choice mode first. This includes the session builder, game screen, and recap views.

## Prerequisites
- Step 5 completed (Flash API endpoints working)
- Familiarity with Shadcn/ui components
- Understanding of React state management

## Detailed Tasks

### 6.1 Install Required Shadcn Components

```bash
bunx shadcn@latest add button
bunx shadcn@latest add card
bunx shadcn@latest add progress
bunx shadcn@latest add badge
bunx shadcn@latest add separator
bunx shadcn@latest add dialog
bunx shadcn@latest add tabs
bunx shadcn@latest add select
```

### 6.2 Create Flash Feature Directory Structure

```
/src/features/flash/
  ├── components/
  │   ├── session-builder.tsx
  │   ├── game-screen.tsx
  │   ├── choice-card.tsx
  │   ├── session-recap.tsx
  │   ├── progress-header.tsx
  │   └── timer.tsx
  ├── actions/
  │   ├── start-session-action.ts
  │   └── submit-session-action.ts
  └── hooks/
      └── use-flash-session.ts
```

### 6.3 Create Session Builder Component

#### `/src/features/flash/components/session-builder.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { Badge } from '@/components/ui/badge';
import type { GameMode, SkillFamily } from '../types';

interface SessionBuilderProps {
  onStart: (config: SessionConfig) => void;
}

export interface SessionConfig {
  mode: GameMode;
  targetTags?: string[];
  maxCards: number;
}

export function SessionBuilder({ onStart }: SessionBuilderProps) {
  const [mode, setMode] = useState<GameMode>('language-choice');
  const [maxCards, setMaxCards] = useState(20);
  const [selectedTags, setSelectedTags] = useState<string[]>([]);

  const handleStart = () => {
    onStart({
      mode,
      targetTags: selectedTags.length > 0 ? selectedTags : undefined,
      maxCards,
    });
  };

  return (
    <Card className="max-w-2xl mx-auto">
      <CardHeader>
        <CardTitle>Start a Flash Session</CardTitle>
        <CardDescription>
          Choose your training mode and preferences
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Mode Selection */}
        <div className="space-y-2">
          <label className="text-sm font-medium">Game Mode</label>
          <div className="grid grid-cols-2 gap-3">
            <Button
              variant={mode === 'language-choice' ? 'default' : 'outline'}
              onClick={() => setMode('language-choice')}
              className="h-auto py-4"
            >
              <div className="text-left">
                <div className="font-semibold">Language Scripts</div>
                <div className="text-xs opacity-80">Choice mode</div>
              </div>
            </Button>
            <Button
              variant={mode === 'phone-choice' ? 'default' : 'outline'}
              onClick={() => setMode('phone-choice')}
              className="h-auto py-4"
            >
              <div className="text-left">
                <div className="font-semibold">Phone Codes</div>
                <div className="text-xs opacity-80">Choice mode</div>
              </div>
            </Button>
          </div>
        </div>

        {/* Card Count */}
        <div className="space-y-2">
          <label className="text-sm font-medium">Number of Cards</label>
          <Select value={maxCards.toString()} onValueChange={(v) => setMaxCards(parseInt(v))}>
            <SelectTrigger>
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="10">10 cards (Quick)</SelectItem>
              <SelectItem value="20">20 cards (Standard)</SelectItem>
              <SelectItem value="30">30 cards (Extended)</SelectItem>
            </SelectContent>
          </Select>
        </div>

        {/* Start Button */}
        <Button onClick={handleStart} className="w-full" size="lg">
          Start Session
        </Button>
      </CardContent>
    </Card>
  );
}
```

### 6.4 Create Game Screen Components

#### A. `/src/features/flash/components/choice-card.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader } from '@/components/ui/card';
import { CheckCircle2, XCircle } from 'lucide-react';

export interface ChoiceOption {
  key: string;
  label: string;
  correct: boolean;
}

interface ChoiceCardProps {
  payload: any;
  options: ChoiceOption[];
  onAnswer: (selectedKey: string, timeMs: number) => void;
}

export function ChoiceCard({ payload, options, onAnswer }: ChoiceCardProps) {
  const [selected, setSelected] = useState<string | null>(null);
  const [showFeedback, setShowFeedback] = useState(false);
  const [startTime] = useState(Date.now());

  const handleSelect = (key: string) => {
    if (selected) return; // Already answered

    setSelected(key);
    setShowFeedback(true);

    const timeMs = Date.now() - startTime;

    // Wait 1.5s for feedback, then submit
    setTimeout(() => {
      onAnswer(key, timeMs);
    }, 1500);
  };

  return (
    <Card className="max-w-2xl mx-auto">
      <CardHeader className="text-center">
        {/* Display the prompt */}
        <div className="text-5xl font-bold mb-4">
          {payload.text || payload.number || payload.city}
        </div>
        {payload.romanization && (
          <div className="text-sm text-muted-foreground">
            {payload.romanization}
          </div>
        )}
      </CardHeader>
      <CardContent>
        <div className="grid grid-cols-2 gap-3">
          {options.map((option) => {
            const isSelected = selected === option.key;
            const isCorrect = option.correct;
            const showCorrect = showFeedback && isCorrect;
            const showWrong = showFeedback && isSelected && !isCorrect;

            return (
              <Button
                key={option.key}
                variant={
                  showCorrect
                    ? 'default'
                    : showWrong
                    ? 'destructive'
                    : isSelected
                    ? 'secondary'
                    : 'outline'
                }
                size="lg"
                className="h-20 relative"
                onClick={() => handleSelect(option.key)}
                disabled={!!selected}
              >
                {option.label}
                {showCorrect && (
                  <CheckCircle2 className="absolute top-2 right-2 w-5 h-5" />
                )}
                {showWrong && (
                  <XCircle className="absolute top-2 right-2 w-5 h-5" />
                )}
              </Button>
            );
          })}
        </div>
      </CardContent>
    </Card>
  );
}
```

#### B. `/src/features/flash/components/progress-header.tsx`

```typescript
'use client';

import { Progress } from '@/components/ui/progress';
import { Badge } from '@/components/ui/badge';

interface ProgressHeaderProps {
  current: number;
  total: number;
  correct: number;
  timeElapsed: number;
}

export function ProgressHeader({ current, total, correct, timeElapsed }: ProgressHeaderProps) {
  const accuracy = current > 0 ? Math.round((correct / current) * 100) : 0;
  const minutes = Math.floor(timeElapsed / 60);
  const seconds = timeElapsed % 60;

  return (
    <div className="space-y-3 mb-6">
      <div className="flex items-center justify-between">
        <div className="text-sm font-medium">
          Question {current} of {total}
        </div>
        <div className="flex gap-2">
          <Badge variant="secondary">
            {accuracy}% accurate
          </Badge>
          <Badge variant="outline">
            {minutes}:{seconds.toString().padStart(2, '0')}
          </Badge>
        </div>
      </div>
      <Progress value={(current / total) * 100} />
    </div>
  );
}
```

#### C. `/src/features/flash/components/game-screen.tsx`

```typescript
'use client';

import { useState, useEffect } from 'react';
import { ChoiceCard } from './choice-card';
import { ProgressHeader } from './progress-header';
import { SessionRecap } from './session-recap';

interface QueueItem {
  fact_id: string;
  type: string;
  payload: any;
  difficulty: number;
  options: any[];
}

interface GameScreenProps {
  queueItems: QueueItem[];
  mode: string;
  onComplete: (results: any) => void;
}

export function GameScreen({ queueItems, mode, onComplete }: GameScreenProps) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [results, setResults] = useState<any[]>([]);
  const [startTime] = useState(Date.now());
  const [timeElapsed, setTimeElapsed] = useState(0);

  // Timer
  useEffect(() => {
    const interval = setInterval(() => {
      setTimeElapsed(Math.floor((Date.now() - startTime) / 1000));
    }, 1000);
    return () => clearInterval(interval);
  }, [startTime]);

  const handleAnswer = (selectedKey: string, timeMs: number) => {
    const item = queueItems[currentIndex];
    const newResult = {
      fact_id: item.fact_id,
      selected_key: selectedKey,
      time_ms: timeMs,
      correct: item.options.find(o => o.key === selectedKey)?.correct || false,
    };

    const newResults = [...results, newResult];
    setResults(newResults);

    // Move to next card or show recap
    if (currentIndex < queueItems.length - 1) {
      setTimeout(() => {
        setCurrentIndex(currentIndex + 1);
      }, 100);
    } else {
      // Session complete
      onComplete(newResults);
    }
  };

  const correctCount = results.filter(r => r.correct).length;

  if (currentIndex >= queueItems.length) {
    return (
      <SessionRecap
        results={results}
        mode={mode}
        totalTimeMs={(Date.now() - startTime)}
      />
    );
  }

  const currentItem = queueItems[currentIndex];

  return (
    <div className="max-w-4xl mx-auto p-6">
      <ProgressHeader
        current={currentIndex + 1}
        total={queueItems.length}
        correct={correctCount}
        timeElapsed={timeElapsed}
      />

      <ChoiceCard
        payload={currentItem.payload}
        options={currentItem.options}
        onAnswer={handleAnswer}
      />
    </div>
  );
}
```

#### D. `/src/features/flash/components/session-recap.tsx`

```typescript
'use client';

import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Trophy, Target, Clock, TrendingUp } from 'lucide-react';

interface SessionRecapProps {
  results: any[];
  mode: string;
  totalTimeMs: number;
}

export function SessionRecap({ results, mode, totalTimeMs }: SessionRecapProps) {
  const correct = results.filter(r => r.correct).length;
  const accuracy = Math.round((correct / results.length) * 100);
  const avgTimeMs = results.reduce((sum, r) => sum + r.time_ms, 0) / results.length;
  const avgTimeSec = (avgTimeMs / 1000).toFixed(1);

  return (
    <div className="max-w-2xl mx-auto p-6 space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="text-center text-2xl">Session Complete!</CardTitle>
        </CardHeader>
        <CardContent className="space-y-6">
          {/* Stats Grid */}
          <div className="grid grid-cols-2 gap-4">
            <div className="flex items-center gap-3 p-4 border rounded-lg">
              <Trophy className="w-8 h-8 text-yellow-500" />
              <div>
                <div className="text-2xl font-bold">{accuracy}%</div>
                <div className="text-sm text-muted-foreground">Accuracy</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-4 border rounded-lg">
              <Target className="w-8 h-8 text-green-500" />
              <div>
                <div className="text-2xl font-bold">{correct}/{results.length}</div>
                <div className="text-sm text-muted-foreground">Correct</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-4 border rounded-lg">
              <Clock className="w-8 h-8 text-blue-500" />
              <div>
                <div className="text-2xl font-bold">{avgTimeSec}s</div>
                <div className="text-sm text-muted-foreground">Avg Time</div>
              </div>
            </div>

            <div className="flex items-center gap-3 p-4 border rounded-lg">
              <TrendingUp className="w-8 h-8 text-purple-500" />
              <div>
                <div className="text-2xl font-bold">{results.length}</div>
                <div className="text-sm text-muted-foreground">Cards Reviewed</div>
              </div>
            </div>
          </div>

          {/* Actions */}
          <div className="flex gap-3">
            <Button className="flex-1" variant="outline" onClick={() => window.location.reload()}>
              Review Mistakes
            </Button>
            <Button className="flex-1" onClick={() => window.location.href = '/flash'}>
              New Session
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
```

### 6.5 Create Flash Page

#### `/src/app/(account)/flash/page.tsx`

```typescript
'use client';

import { useState } from 'react';
import { SessionBuilder, type SessionConfig } from '@/features/flash/components/session-builder';
import { GameScreen } from '@/features/flash/components/game-screen';

export default function FlashPage() {
  const [sessionState, setSessionState] = useState<'builder' | 'playing'>('builder');
  const [queueItems, setQueueItems] = useState<any[]>([]);
  const [mode, setMode] = useState<string>('');

  const handleStartSession = async (config: SessionConfig) => {
    // Call queue API
    const response = await fetch('/api/flash/queue', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(config),
    });

    const data = await response.json();
    setQueueItems(data.items);
    setMode(config.mode);
    setSessionState('playing');
  };

  const handleSessionComplete = async (results: any[]) => {
    // Call grade API
    await fetch('/api/flash/grade', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        mode,
        items: results,
      }),
    });
  };

  return (
    <div className="container py-8">
      {sessionState === 'builder' && (
        <SessionBuilder onStart={handleStartSession} />
      )}

      {sessionState === 'playing' && (
        <GameScreen
          queueItems={queueItems}
          mode={mode}
          onComplete={handleSessionComplete}
        />
      )}
    </div>
  );
}
```

### 6.6 Update Navigation

Add Flash link to `/src/app/navigation.tsx`:

```typescript
<NavigationLink href="/flash">Flash</NavigationLink>
```

## Files to Create/Modify

### Created:
- `/src/features/flash/components/session-builder.tsx`
- `/src/features/flash/components/choice-card.tsx`
- `/src/features/flash/components/game-screen.tsx`
- `/src/features/flash/components/progress-header.tsx`
- `/src/features/flash/components/session-recap.tsx`
- `/src/app/(account)/flash/page.tsx`

### Modified:
- `/src/app/navigation.tsx` (add Flash link)

## Acceptance Criteria
- ✅ Can navigate to /flash page
- ✅ Session builder displays mode options
- ✅ Clicking "Start Session" fetches queue from API
- ✅ Cards display with 6 choice options
- ✅ Selecting answer shows visual feedback (green/red)
- ✅ Progress bar updates after each card
- ✅ Accuracy and timer display in header
- ✅ Recap shows after last card
- ✅ Results submitted to grade API
- ✅ Responsive design works on mobile

## Notes & Considerations

### UX Details
- **Feedback timing**: 1.5s delay after selection before next card
- **Visual hierarchy**: Large prompt text, clear option buttons
- **Accessibility**: Keyboard navigation, ARIA labels
- **Loading states**: Show spinner while fetching queue

### Styling with Shadcn
- Use consistent spacing (p-6, gap-3, etc.)
- Leverage variant system (outline, default, destructive)
- Responsive grid layouts (grid-cols-2)

### Performance
- Prefetch next card assets
- Debounce rapid clicks
- Client-side result caching

## Dependencies
- Step 5 (Flash API)
- Shadcn/ui components installed

## Blocks
- Step 7 (MapLibre Integration)
