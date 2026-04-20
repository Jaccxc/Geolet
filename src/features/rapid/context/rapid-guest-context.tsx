'use client';

import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';

interface RapidGuestContextValue {
  isAuthenticated: boolean;
  guestSessions: number;
  guestLimit: number;
  incrementGuestSession: () => number;
  resetGuestSessions: () => void;
}

const RapidGuestContext = createContext<RapidGuestContextValue | null>(null);

const STORAGE_KEY = 'rapid_guest_sessions';
const DEFAULT_LIMIT = 3;

export function RapidGuestProvider({
  isAuthenticated,
  children,
}: {
  isAuthenticated: boolean;
  children: React.ReactNode;
}) {
  const [guestSessions, setGuestSessions] = useState(() => {
    if (isAuthenticated || typeof window === 'undefined') {
      return 0;
    }

    const stored = Number(window.localStorage.getItem(STORAGE_KEY) ?? '0');
    return Number.isFinite(stored) ? stored : 0;
  });

  useEffect(() => {
    if (isAuthenticated) {
      setGuestSessions(0);
      return;
    }

    if (typeof window === 'undefined') return;

    const stored = Number(window.localStorage.getItem(STORAGE_KEY) ?? '0');
    setGuestSessions(Number.isFinite(stored) ? stored : 0);
  }, [isAuthenticated]);

  const incrementGuestSession = useCallback(() => {
    if (isAuthenticated) return 0;

    const nextValue = guestSessions + 1;
    setGuestSessions(nextValue);

    if (typeof window !== 'undefined') {
      window.localStorage.setItem(STORAGE_KEY, nextValue.toString());
    }
    return nextValue;
  }, [guestSessions, isAuthenticated]);

  const resetGuestSessions = useCallback(() => {
    setGuestSessions(0);
    if (typeof window !== 'undefined') {
      window.localStorage.removeItem(STORAGE_KEY);
    }
  }, []);

  const value = useMemo<RapidGuestContextValue>(
    () => ({
      isAuthenticated,
      guestSessions,
      guestLimit: DEFAULT_LIMIT,
      incrementGuestSession,
      resetGuestSessions,
    }),
    [guestSessions, incrementGuestSession, isAuthenticated, resetGuestSessions]
  );

  return <RapidGuestContext.Provider value={value}>{children}</RapidGuestContext.Provider>;
}

export function useRapidGuestContext() {
  const context = useContext(RapidGuestContext);

  if (!context) {
    throw new Error('useRapidGuestContext must be used within a RapidGuestProvider');
  }

  return context;
}

