# WATG24 Cities - Split by Tier

This directory contains WATG24 city data split into separate files for easier maintenance.

## File Structure

**Completed Tiers (216/335 cities - 64.5%):**
- ✅ `00_setup.sql` - Card groups and topics setup
- ✅ `01_alpha_plus_plus.sql` - Alpha++ tier (2 cities)
- ✅ `02_alpha_plus.sql` - Alpha+ tier (8 cities)
- ✅ `03_alpha.sql` - Alpha tier (17 cities)
- ✅ `04_alpha_minus.sql` - Alpha- tier (22 cities)
- ✅ `05_beta_plus.sql` - Beta+ tier (20 cities)
- ✅ `06_beta.sql` - Beta tier (23 cities)
- ✅ `07_beta_minus.sql` - Beta- tier (28 cities)
- ✅ `08_gamma_plus.sql` - Gamma+ tier (20 cities)
- ✅ `09_gamma.sql` - Gamma tier (25 cities)
- ✅ `10_gamma_minus.sql` - Gamma- tier (25 cities)
- ✅ `11_high_sufficiency.sql` - High Sufficiency tier (26 cities)

**Pending Tiers (119/335 cities - 35.5%):**
- ⏳ `12_sufficiency.sql` - Sufficiency tier (119 cities) - NEXT

## Usage

When creating migrations, you can now include only the specific tier files you need:

```bash
# Create migration for setup (run once)
bun run migration:new add_watg24_setup

# Create migration for a specific tier
bun run migration:new add_watg24_alpha_plus_plus
```

Then copy the relevant SQL file content into your migration.

## File Format

Each tier file contains:
1. **Pin Regions** - Geographic coordinates for each city
2. **Skill Tags** - City descriptions and metadata
3. **Fact Cards** - Quiz cards mapped to regions

## Notes

- All completed tiers (Alpha++ through Alpha-) have been manually edited
- All skill tags have 2-sentence maximum descriptions
- All fact card hints contain only the tier name (e.g., "Alpha tier global city")
- Pending tiers contain TODO placeholders that need to be filled in
