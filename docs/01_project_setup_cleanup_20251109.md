# Step 1: Project Setup & Cleanup

**Timeline:** 2-3 hours
**Priority:** High (Must complete first)

## Overview
Clean up the starter template branding and prepare the project structure for Geolet. This step ensures we have a clean foundation before adding new features.

## Prerequisites
- None (this is the first step)
- Current state: Next.js 15 + Supabase + Stripe starter template

## Detailed Tasks

### 1.1 Remove Starter-Specific Content
- [ ] Delete `/delete-me` directory (contains demo banner images)
- [ ] Update `README.md` to describe Geolet instead of the starter
- [ ] Search and remove all `UPDATE_THIS` placeholders in code
- [ ] Review and update comments that reference the starter template

### 1.2 Update Branding & Metadata
- [ ] Update `package.json`:
  - name: "geolet"
  - description: "GeoGuessr training platform with minigames and analytics"
  - Update repository, author, etc.
- [ ] Update `src/app/layout.tsx`:
  - Site title: "Geolet"
  - Description for meta tags
- [ ] Replace `favicon.ico` with Geolet branding (or keep placeholder for now)

### 1.3 Clean Up Stripe Fixtures
- [ ] Review `stripe-fixtures.json`
- [ ] Plan product tiers for Geolet (Free, Pro)
- [ ] Update product metadata schema in `src/features/pricing/models/product-metadata.ts`
- [ ] Define features for each tier (e.g., daily_sessions, content_families)

### 1.4 Update Navigation Structure
- [ ] Modify `src/app/navigation.tsx` to include:
  - Flash (main minigames)
  - Insight (analytics)
  - Pricing
  - Account
- [ ] Remove or update demo/starter-specific nav items

### 1.5 Environment Variables Audit
- [ ] Review `.env.local` for required variables
- [ ] Document any additional env vars needed for MapLibre
- [ ] Ensure all Supabase and Stripe keys are properly configured

## Files to Create/Modify

### Modified:
- `/README.md`
- `/package.json`
- `/src/app/layout.tsx`
- `/src/app/navigation.tsx`
- `/src/features/pricing/models/product-metadata.ts`
- `/stripe-fixtures.json`

### Deleted:
- `/delete-me/` (entire directory)

## Acceptance Criteria
- ✅ No references to "next-supabase-stripe-starter" in code
- ✅ Navigation shows Flash and Insight sections
- ✅ Package.json reflects Geolet branding
- ✅ App runs without errors: `bun run dev`
- ✅ All `UPDATE_THIS` placeholders resolved

## Notes & Considerations
- Keep all existing Supabase/Stripe/auth functionality intact
- Don't modify database migrations yet (that's Step 2)
- This is primarily a cosmetic/organizational cleanup
- The pricing model should support free tier + one paid tier initially

## Dependencies
- None

## Blocks
- Step 2 (Database Schema)
