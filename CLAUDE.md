# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Geolet** is a GeoGuessr training platform built with Next.js 15 (App Router). It features flash minigames, a spaced repetition system (SM-2), analytics (Insight), and Stripe subscriptions. The database is Supabase (PostgreSQL).

## Commands

```bash
# Development
npm run dev           # Start dev server with Turbopack on port 3000
npm run build         # Production build
npm run lint          # ESLint

# Email templates
npm run email:dev     # Dev server for React Email templates on port 3001

# Supabase / Database
npm run migration:new <name>   # Create a new migration file
npm run migration:up           # Apply migrations and regenerate TypeScript types
npm run generate-types         # Regenerate src/libs/supabase/types.ts from remote schema

# Stripe (local webhook forwarding)
npm run stripe:listen
```

Local Supabase ports: API `54321`, DB `54322`, Studio `54323`, Inbucket email `54324`.

## Architecture

### Directory Layout

```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/             # Public auth pages + actions
│   ├── (account)/          # Protected pages (rapid game, account, subscription)
│   ├── api/                # API routes (rapid/queue, rapid/grade, rapid/topics, webhooks)
│   └── page.tsx            # Landing (unauthenticated) / Dashboard (authenticated)
├── features/               # Feature modules — business logic lives here
│   ├── rapid/              # Flash minigame (components, controllers, config, models)
│   ├── srs/                # Spaced repetition system
│   ├── account/            # Session, user, subscription controllers
│   ├── pricing/            # Stripe product controllers
│   ├── insight/            # Analytics / import game history
│   └── emails/             # React Email templates
├── libs/
│   ├── supabase/           # DB client factories + generated types.ts
│   ├── stripe/             # Stripe client
│   └── resend/             # Email client
└── components/             # Shared UI (Shadcn/ui in components/ui/, dashboard, tabs)
```

### Key Patterns

- **Controllers** (`features/*/controllers/`) — server-side async functions that interact with Supabase or external APIs. Called from API routes or Server Components.
- **Models** (`features/*/models/`) — pure domain logic (answer validation, SRS calculation).
- **`@/` path alias** maps to `./src/`.
- API routes return `ActionResponse<T>` (see `src/types/action-response.ts`).

### Game Flow (Rapid Minigame)

1. `/api/rapid/queue` — builds a prioritized list of up to 20 `fact_cards`, joining with `user_fact_stats` to surface due SRS cards first.
2. Client renders questions in `features/rapid/components/game-screen.tsx`. Questions are either **pick mode** (multiple choice) or **map mode** (click on a map via MapLibre GL).
3. `/api/rapid/grade` — validates the answer (`features/rapid/models/answer-validator.ts`), updates `user_fact_stats`, and recalculates `due_at` using the SM-2 algorithm (`features/srs/`).

### Database Schema (key tables)

| Table | Purpose |
|---|---|
| `regions` | Countries, provinces, cities with GeoJSON (`pin` or `polygon` location_type) |
| `fact_cards` | Quiz questions with answers and difficulty |
| `card_groups` | Logical groupings of fact_cards (e.g. `cities_watg24_alpha`) |
| `topics` | Game topics linking to card groups, with `pick_active`/`map_active` flags |
| `skill_tags` | Language scripts, phone codes, etc. |
| `user_fact_stats` | Per-user SRS state: `due_at`, `interval`, `ease_factor`, counts |
| `user_subscriptions` | Stripe subscription state |

RLS is enabled. GeoJSON stored as JSONB. PostgreSQL ENUMs enforce domain constraints.

### Auth

Supabase Auth. `src/middleware.ts` refreshes sessions. Protected routes live under `(account)/`. The root layout checks session to decide between landing page and dashboard.

### Payments

Stripe. Webhooks at `/api/webhooks` update `user_subscriptions`. Local testing via `npm run stripe:listen`.

## Environment Variables

Copy `.env.local.example` to `.env.local`:

```
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_DB_PASSWORD
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY
STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET
RESEND_API_KEY
NEXT_PUBLIC_SITE_URL
```
