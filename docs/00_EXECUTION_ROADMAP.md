# Geolet MVP - Execution Roadmap

**Last Updated:** 2025-11-09
**Total Estimated Timeline:** 6-8 weeks (solo developer) | 3-4 weeks (2-3 developers)

## Project Overview

Transform the next-supabase-stripe-starter into **Geolet**, a GeoGuessr training platform with:
- **Flash Minigames**: Language scripts, phone codes, and major cities
- **Dual Modes**: Multiple choice and pin-drop map interaction
- **Insight Analytics**: Import game history, visualize strengths/weaknesses
- **Smart Prescriptions**: AI-recommended training based on performance
- **Spaced Repetition**: Long-term retention via SM-2 algorithm

## Current State Analysis

### What We Have (Starter Template)
✅ Next.js 15 + React + TypeScript
✅ Supabase (PostgreSQL + Auth)
✅ Stripe (Payments + Subscriptions)
✅ Shadcn/ui components
✅ Tailwind CSS
✅ Migration system
✅ Feature-based file structure
✅ Webhook integration (Stripe → Supabase)

### What We Need to Build
🔨 Database schema (6 new tables)
🔨 Seed data (100+ fact cards, regions, skill tags)
🔨 Flash game engine (queue, grade, SRS)
🔨 MapLibre integration (pin-drop validation)
🔨 Insight analytics (import, aggregation, visualization)
🔨 Prescription system (weakness → training)

## Execution Plan (12 Steps)

| Step | Description | Priority | Timeline | Dependencies |
|------|-------------|----------|----------|--------------|
| 01 | [Project Setup & Cleanup](01_project_setup_cleanup_20251109.md) | High | 2-3h | None |
| 02 | [Database Schema Migration](02_database_schema_migration_20251109.md) | Critical | 4-6h | Step 1 |
| 03 | [Seed Data Preparation](03_seed_data_preparation_20251109.md) | High | 6-8h | Step 2 |
| 04 | [Core Data Models & Types](04_core_data_models_types_20251109.md) | High | 4-5h | Steps 2-3 |
| 05 | [Flash API - Queue & Grade](05_flash_api_queue_grade_20251109.md) | Critical | 6-8h | Step 4 |
| 06 | [Flash UI - Choice Mode](06_flash_ui_choice_mode_20251109.md) | High | 8-10h | Step 5 |
| 07 | [MapLibre Integration](07_maplibre_integration_20251109.md) | High | 6-8h | Step 4 |
| 08 | [Flash UI - Map Mode](08_flash_ui_map_mode_20251109.md) | High | 5-6h | Steps 6-7 |
| 09 | [Insight - Import](09_insight_import_20251109.md) | Medium | 5-6h | Step 4 |
| 10 | [Insight - Analytics](10_insight_analytics_20251109.md) | Medium | 6-8h | Step 9 |
| 11 | [Insight - Prescription](11_insight_prescription_20251109.md) | Medium | 4-5h | Steps 5, 10 |
| 12 | [MVP Integration & Polish](12_mvp_integration_polish_20251109.md) | High | 6-8h | All previous |

**Total Estimated Time:** 62-81 hours

## Recommended Execution Order

### Phase 1: Foundation (Week 1)
**Goal:** Clean start + working database

1. **Day 1-2:** Steps 1-2 (Setup + Schema)
   - Remove starter branding
   - Create Geolet database schema
   - Run migrations

2. **Day 3-5:** Step 3 (Seed Data)
   - Research and collect geographic data
   - Create skill_tags, regions, fact_cards
   - Validate and load seed data

### Phase 2: Core Flash (Week 2-3)
**Goal:** Working Flash minigames (choice mode)

3. **Day 6-7:** Step 4 (Data Models)
   - Generate Supabase types
   - Create Zod schemas
   - Build controller functions

4. **Day 8-10:** Step 5 (Flash API)
   - Implement SRS logic
   - Build queue algorithm
   - Create grade endpoint

5. **Day 11-13:** Step 6 (Flash UI Choice)
   - Session builder
   - Game screen components
   - Recap view

**Milestone 1:** Can play 20-card language-choice session ✅

### Phase 3: Map Mode (Week 3-4)
**Goal:** Pin-drop map interaction

6. **Day 14-16:** Step 7 (MapLibre)
   - Integrate MapLibre GL JS
   - Implement Turf.js validation
   - Update API for map modes

7. **Day 17-18:** Step 8 (Map UI)
   - Map card component
   - Pin-drop feedback
   - Integration with game flow

**Milestone 2:** Can play map-based sessions with visual feedback ✅

### Phase 4: Insight (Week 4-5)
**Goal:** Analytics and prescriptions

8. **Day 19-21:** Step 9 (Import)
   - CSV/JSON parser
   - Import wizard UI
   - API endpoint

9. **Day 22-24:** Step 10 (Analytics)
   - Skill map calculation
   - Confusion matrix
   - Visualization components

10. **Day 25-26:** Step 11 (Prescription)
    - Weakness detection
    - Prescription generation
    - Flash integration

**Milestone 3:** End-to-end Insight → Prescription → Flash flow ✅

### Phase 5: Polish & Launch (Week 5-6)
**Goal:** Production-ready MVP

11. **Day 27-30:** Step 12 (Integration & Polish)
    - End-to-end testing
    - Error handling
    - Mobile responsiveness
    - Performance optimization
    - Documentation

12. **Day 31-35:** Beta Testing & Fixes
    - User testing
    - Bug fixes
    - Final optimizations

**Milestone 4:** MVP ready for public launch ✅

## Critical Path

```
Setup → Schema → Seed Data → Data Models
                                    ↓
                            Flash API ← (Map Integration in parallel)
                                    ↓
                            Flash UI Choice → Flash UI Map
                                                    ↓
Insight Import → Insight Analytics → Prescription ←┘
                                           ↓
                                    Integration & Polish
```

**Longest path:** Setup → Schema → Seed → Models → Flash API → Flash UI → Map Integration → Map UI → Integration (40-50 hours)

## Parallel Work Opportunities

If working with multiple developers:

### Developer 1: Backend + Data
- Steps 1-5 (Setup through Flash API)
- Step 7 (MapLibre integration)
- Steps 9-11 (Insight backend)

### Developer 2: Frontend + UI
- Step 6 (Flash UI Choice)
- Step 8 (Flash UI Map)
- Insight visualization components

### Developer 3: Content + QA
- Step 3 (Seed data research and preparation)
- Step 12 (Testing and polish)
- Documentation

## Key Decision Points

### Before Starting
- [ ] Confirm Supabase project is ready
- [ ] Confirm Stripe account configured
- [ ] Decide on tile provider for MapLibre (OpenStreetMap vs Maptiler)
- [ ] Define MVP scope (stick to plan or cut features?)

### During Development
- **After Step 3:** Validate seed data quality (accuracy is critical)
- **After Step 6:** User test choice mode before moving to map
- **After Step 10:** Decide if analytics are sufficient or need more depth

## Risk Mitigation

### Technical Risks
1. **MapLibre bundle size** → Lazy load, dynamic import
2. **Seed data accuracy** → Manual verification, multiple sources
3. **SRS algorithm complexity** → Start simple (SM-2 lite), iterate
4. **Mobile map interaction** → Test early, fallback to choice mode

### Scope Risks
1. **Feature creep** → Stick to MVP, track V2 features separately
2. **Perfect data syndrome** → Ship with 100 cards, expand later
3. **Over-engineering** → No PostGIS, no microservices, keep it simple

## Success Criteria

### MVP Launch Checklist
- [ ] User can sign up and log in
- [ ] 5 game modes working (3 choice + 2 map)
- [ ] At least 100 fact cards with accurate data
- [ ] SRS updates user progress correctly
- [ ] Import works with sample GeoGuessr CSV
- [ ] Analytics show skill map and confusions
- [ ] Prescription generates and links to Flash
- [ ] Mobile responsive (375px+)
- [ ] No critical bugs
- [ ] Lighthouse score >85

### Metrics to Track Post-Launch
- Session completion rate
- Average session length
- Import adoption rate
- Prescription click-through rate
- User retention (D1, D7, D30)

## Post-MVP Roadmap (V1.1+)

### V1.1 (Week 7-8)
- Daily streak tracking
- Due cards system (full SRS)
- Hard mode (free-type answers)
- Improved distractors (confusion-based)

### V1.2 (Week 9-12)
- Community content submission
- More comprehensive seed data (1000+ cards)
- Per-region drill-down
- Export/share results

### V2.0 (Month 4+)
- Live multiplayer "Rush" mode
- Google Street View integration
- Advanced analytics (by time, map type)
- Mobile app (React Native)

## Resources & Tools

### Development
- **IDE:** VS Code with TypeScript/Tailwind extensions
- **Database:** Supabase dashboard
- **API Testing:** Postman or Bruno
- **Geo Data:** Natural Earth Data, OSM Nominatim

### Design
- **Components:** Shadcn/ui docs
- **Icons:** Lucide React
- **Colors:** Tailwind default palette

### Testing
- **Browser:** Chrome DevTools + Lighthouse
- **Mobile:** iOS Simulator, Chrome Device Mode
- **Load Testing:** k6 (if needed)

## Contact & Questions

For questions about this plan:
1. Review the detailed step files (`01_*.md` through `12_*.md`)
2. Check the original requirements in `plan1.txt`
3. Consult the starter README for Supabase/Stripe setup

---

**Let's build Geolet!** 🌍🎯
