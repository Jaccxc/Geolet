# Geolet

**GeoGuessr Training Platform** - Master GeoGuessr with focused minigames and personalized analytics.

## Overview

Geolet helps GeoGuessr players improve specific skills through targeted training:

- **Flash Minigames**: Train languages, phone codes, and major cities with choice-based or map-based questions
- **Dual Answer Modes**: Multiple choice or pin-drop on interactive maps
- **Insight Analytics**: Import your game history to visualize strengths and weaknesses
- **Smart Prescriptions**: AI-powered training recommendations based on your performance
- **Spaced Repetition**: SM-2 algorithm for long-term knowledge retention

## Features

### Flash Training
- **Language Scripts**: Identify writing systems (Devanagari, Cyrillic, Arabic, etc.)
- **Phone Meta**: Recognize phone number patterns and country codes
- **Major Cities**: Locate cities on a map by name or description
- **Two Modes**: Multiple choice (6 options) or pin-drop on map

### Insight Analytics
- Import CSV/JSON game history from GeoGuessr
- Skill heatmap showing accuracy by country
- Confusion matrix identifying common mistakes
- Personalized prescriptions for focused training

### Smart Features
- Adaptive queue prioritizes weak spots and due cards
- Real-time feedback with explanations
- Session history and progress tracking
- Mobile-responsive design

## Tech Stack

- **Frontend**: Next.js 15, React 19, TypeScript
- **Backend**: Supabase (PostgreSQL + Auth)
- **Payments**: Stripe (subscriptions + customer portal)
- **Maps**: MapLibre GL JS
- **UI**: Shadcn/ui + Tailwind CSS
- **Validation**: Turf.js (geospatial)

## Getting Started

### Prerequisites

- Node.js 18+ or Bun
- Supabase account
- Stripe account (for payments)
- Resend account (for emails)

### 1. Setup Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. Reset database password (Settings → Database)
3. Save the password (you'll need it later)

### 2. Setup Stripe

1. Create an account at [stripe.com](https://stripe.com)
2. Activate the [Customer Portal](https://dashboard.stripe.com/test/settings/billing/portal)

### 3. Setup Resend

1. Create an account at [resend.com](https://resend.com)
2. Get your [API Key](https://resend.com/api-keys)
3. Add the [Supabase integration](https://supabase.com/partners/integrations/resend)

### 4. Clone and Install

```bash
git clone <your-repo-url>
cd Geolet
bun install
```

### 5. Environment Variables

Copy `.env.local.example` to `.env.local` and fill in your values:

```bash
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
SUPABASE_DB_PASSWORD=your_db_password

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=your_stripe_pk
STRIPE_SECRET_KEY=your_stripe_sk
STRIPE_WEBHOOK_SECRET=your_webhook_secret

# Resend
RESEND_API_KEY=your_resend_key
```

### 6. Database Setup

```bash
# Link to your Supabase project
bun run supabase:link

# Run migrations
bun run migration:up
```

### 7. Stripe Setup

Install Stripe CLI:
```bash
brew install stripe/stripe-cli/stripe
```

Load products:
```bash
stripe fixtures ./stripe-fixtures.json --api-key YOUR_STRIPE_SK
```

### 8. Run Development Server

```bash
bun run dev
```

Open [http://localhost:3000](http://localhost:3000)

## Development

### File Structure

```
src/
├── app/                 # Next.js app directory
│   ├── (auth)/         # Auth pages (login, signup)
│   ├── (account)/      # Protected pages (flash, insight, account)
│   └── api/            # API routes
├── features/           # Feature modules
│   ├── flash/          # Flash game logic
│   ├── insight/        # Analytics and import
│   ├── srs/            # Spaced repetition system
│   ├── pricing/        # Stripe integration
│   └── account/        # User management
├── components/         # Reusable UI components
├── libs/              # Third-party integrations
└── utils/             # Helper functions
```

### Database Migrations

Create a new migration:
```bash
bun run migration:new your_migration_name
```

Apply migrations:
```bash
bun run migration:up
```

### Managing Products

Products are defined in `stripe-fixtures.json`. To update:

1. Delete test data in [Stripe Dashboard](https://dashboard.stripe.com/test/developers)
2. Edit `stripe-fixtures.json`
3. Run: `stripe fixtures ./stripe-fixtures.json --api-key YOUR_SK`

Product metadata fields:
- `price_card_variant`: "free" | "pro"
- `daily_sessions`: Number of sessions per day
- `content_families`: Comma-separated list ("script,phone,city")
- `support_level`: "community" | "email" | "priority"

## Deployment

### Deploy to Vercel

1. Push to GitHub
2. Import project in [Vercel](https://vercel.com)
3. Add environment variables
4. Deploy

### Setup Stripe Webhook

1. Get your Vercel URL
2. In Stripe Dashboard → Developers → Webhooks
3. Add endpoint: `https://your-domain.vercel.app/api/webhooks`
4. Select all events
5. Copy webhook secret to Vercel environment variables

### Going Live

1. Switch Stripe to live mode
2. Create live webhook
3. Update Vercel env vars with live keys
4. Redeploy
5. Run fixtures with live Stripe key

## Project Roadmap

### MVP (Current)
- [x] Flash minigames (choice + map modes)
- [x] Insight import and analytics
- [x] Prescription system
- [x] Basic SRS implementation

### V1.1 (Planned)
- [ ] Daily streaks and goals
- [ ] Full SRS with due cards
- [ ] Hard mode (free-type answers)
- [ ] Improved distractor generation

### V2.0 (Future)
- [ ] Community content submission
- [ ] Live multiplayer "Rush" mode
- [ ] Street View integration
- [ ] Mobile app

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

- Documentation: See `/docs` directory for detailed development plans
- Issues: [GitHub Issues](https://github.com/yourusername/geolet/issues)

## License

MIT License - see LICENSE file for details

---

Built with ❤️ for the GeoGuessr community.

Jacc.
