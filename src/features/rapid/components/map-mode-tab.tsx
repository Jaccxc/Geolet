'use client';

import { useState } from 'react';
import { Loader2 } from 'lucide-react';

import { MAP_MODE_TOPICS } from '../config/topics';

import { GameScreen } from './game-screen';
import { TopicCard } from './topic-card';

export function MapModeTab() {
  const [sessionState, setSessionState] = useState<'topics' | 'playing'>('topics');
  const [queueItems, setQueueItems] = useState<any[]>([]);
  const [mode, setMode] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleTopicSelect = async (topicId: string) => {
    const topic = MAP_MODE_TOPICS.find((t) => t.id === topicId);
    if (!topic) return;

    setLoading(true);
    setError(null);

    try {
      // Call queue API
      const response = await fetch('/api/rapid/queue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mode: topic.mode,
          maxCards: 10, // Start with 10 cards per session
          targetTags: topic.targetTags, // Filter by specific tags if defined
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to fetch queue');
      }

      const data = await response.json();
      setQueueItems(data.items);
      setMode(topic.mode);
      setSessionState('playing');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to start session');
    } finally {
      setLoading(false);
    }
  };

  const handleSessionComplete = async (results: any[]) => {
    try {
      // Call grade API
      await fetch('/api/rapid/grade', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mode,
          items: results,
        }),
      });
    } catch (err) {
      console.error('Failed to submit grades:', err);
    }
  };

  if (loading) {
    return (
      <div className='flex items-center justify-center py-20'>
        <Loader2 className='h-8 w-8 animate-spin text-primary' />
      </div>
    );
  }

  if (error) {
    return (
      <div className='py-20 text-center'>
        <p className='mb-4 text-destructive'>{error}</p>
        <button onClick={() => setSessionState('topics')} className='text-primary hover:underline'>
          Back to topics
        </button>
      </div>
    );
  }

  if (sessionState === 'playing') {
    return <GameScreen queueItems={queueItems} mode={mode} onComplete={handleSessionComplete} />;
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-bold'>Choose a Topic</h2>
        <p className='text-muted-foreground'>Click on a map to identify regions based on scripts and phone codes</p>
      </div>

      <div className='grid grid-cols-1 gap-4 md:grid-cols-2'>
        {MAP_MODE_TOPICS.map((topic) => (
          <TopicCard key={topic.id} topic={topic} onClick={() => handleTopicSelect(topic.id)} />
        ))}
      </div>
    </div>
  );
}
