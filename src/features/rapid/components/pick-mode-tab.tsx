'use client';

import { useEffect, useState } from 'react';
import { Loader2 } from 'lucide-react';

import type { Topic } from '../types';

import { GameScreen } from './game-screen';
import { TopicSelector } from './topic-selector';

export function PickModeTab() {
  const [sessionState, setSessionState] = useState<'topics' | 'playing'>('topics');
  const [queueItems, setQueueItems] = useState<any[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string | undefined>();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Fetch topics on mount
  useEffect(() => {
    async function fetchTopics() {
      try {
        const response = await fetch('/api/rapid/topics?mode=pick');
        if (!response.ok) throw new Error('Failed to fetch topics');
        const data = await response.json();
        setTopics(data.topics);
      } catch (err) {
        console.error('Failed to fetch topics:', err);
        setError('Failed to load topics');
      }
    }
    fetchTopics();
  }, []);

  const handleTopicSelect = async (topicKey: string) => {
    setSelectedTopic(topicKey);
    setLoading(true);
    setError(null);

    try {
      // Call queue API with topicKey
      const response = await fetch('/api/rapid/queue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mode: 'pick',
          topicKey: topicKey,
          maxCards: 8,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to fetch queue');
      }

      const data = await response.json();

      // Check if queue is empty
      if (!data.items || data.items.length === 0) {
        setError('No cards available for this topic. Please ensure the topic has card groups and fact cards in the database.');
        return;
      }

      setQueueItems(data.items);
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
          mode: 'pick',
          items: results,
        }),
      });
    } catch (err) {
      console.error('Failed to submit grades:', err);
    }
  };

  const handleNewSession = () => {
    setSessionState('topics');
    setQueueItems([]);
    setSelectedTopic(undefined);
    setError(null);
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
    return <GameScreen queueItems={queueItems} mode="pick" onComplete={handleSessionComplete} onNewSession={handleNewSession} />;
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-bold'>Choose a Topic</h2>
        <p className='text-muted-foreground'>Select a topic to start your training session</p>
      </div>

      <TopicSelector mode="pick" onSelect={handleTopicSelect} selectedTopic={selectedTopic} />
    </div>
  );
}
