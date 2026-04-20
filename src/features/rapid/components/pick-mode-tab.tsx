'use client';

import { useEffect, useState } from 'react';
import { Loader2 } from 'lucide-react';

import { useRapidGuestContext } from '../context/rapid-guest-context';
import type { Topic } from '../types';

import { GameScreen } from './game-screen';
import { GuestLimitDialog } from './guest-limit-dialog';
import { TopicSelector } from './topic-selector';

interface PickModeTabProps {
  isAuthenticated: boolean;
}

export function PickModeTab({ isAuthenticated }: PickModeTabProps) {
  const [sessionState, setSessionState] = useState<'topics' | 'playing'>('topics');
  const [queueItems, setQueueItems] = useState<any[]>([]);
  const [topics, setTopics] = useState<Topic[]>([]);
  const [selectedTopic, setSelectedTopic] = useState<string | undefined>();
  const [activeQueueMode, setActiveQueueMode] = useState<'pick' | 'map' | 'doomsday'>('pick');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [limitDialogOpen, setLimitDialogOpen] = useState(false);
  const { guestSessions, guestLimit, incrementGuestSession } = useRapidGuestContext();
  const remainingSessions = Math.max(guestLimit - guestSessions, 0);

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

  // Reset session state when auth changes
  useEffect(() => {
    setSessionState('topics');
    setQueueItems([]);
    setSelectedTopic(undefined);
    setError(null);
    setLimitDialogOpen(false);
  }, [isAuthenticated]);

  const handleTopicSelect = async (topicKey: string, queueMode = 'pick') => {
    if (!isAuthenticated && guestSessions >= guestLimit) {
      setLimitDialogOpen(true);
      return;
    }

    setSelectedTopic(topicKey);
    setActiveQueueMode(queueMode as 'pick' | 'map' | 'doomsday');
    setLoading(true);
    setError(null);

    try {
      const response = await fetch('/api/rapid/queue', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mode: queueMode,
          topicKey: topicKey,
          maxCards: 8,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to fetch queue');
      }

      const data = await response.json();

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
      await fetch('/api/rapid/grade', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          mode: activeQueueMode,
          items: results,
        }),
      });
    } catch (err) {
      console.error('Failed to submit grades:', err);
    } finally {
      if (!isAuthenticated) {
        const nextCount = incrementGuestSession();
        if (nextCount >= guestLimit) {
          setLimitDialogOpen(true);
        }
      }
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
    return <GameScreen queueItems={queueItems} mode={activeQueueMode} onComplete={handleSessionComplete} onNewSession={handleNewSession} />;
  }

  return (
    <div className='space-y-6'>
      <div>
        <h2 className='mb-2 text-2xl font-bold'>Choose a Topic</h2>
        <p className='text-muted-foreground'>Select a topic to start your training session</p>
      </div>

      {!isAuthenticated && (
        <div className='rounded-lg border border-yellow-500/30 bg-yellow-500/10 p-3 text-sm text-yellow-200'>
          You can play{' '}
          <span className='font-semibold'>{remainingSessions > 0 ? remainingSessions : 0}</span> more session
          {remainingSessions === 1 ? '' : 's'} as a guest. Log in to unlock unlimited runs and tracked progress.
        </div>
      )}

      <TopicSelector mode="pick" onSelect={handleTopicSelect} selectedTopic={selectedTopic} />

      <GuestLimitDialog
        open={limitDialogOpen}
        onOpenChange={setLimitDialogOpen}
        remainingSessions={remainingSessions}
        limit={guestLimit}
      />
    </div>
  );
}
