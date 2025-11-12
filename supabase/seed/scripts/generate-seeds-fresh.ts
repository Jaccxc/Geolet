/**
 * Generate seed SQL files for fresh database migration
 *
 * Generates:
 * 1. skill_tags from old JSON (transform meta → columns)
 * 2. countries from GeoJSON (NO centroids for polygon type)
 * 3. India states from GeoJSON (NO centroids for polygon type)
 */

import fs from 'fs';
import path from 'path';

// ============================================
// TYPES
// ============================================

interface OldSkillTag {
  key: string;
  family: string;
  country?: string;
  meta?: {
    display?: string;
    notes?: string;
    examples?: string[];
    regions?: string[];
  };
}

interface GeoJSONFeature {
  type: 'Feature';
  properties: Record<string, any>;
  geometry: any;
}

interface GeoJSONFeatureCollection {
  type: 'FeatureCollection';
  features: GeoJSONFeature[];
}

// ============================================
// UTILITIES
// ============================================

function sqlEscape(str: string): string {
  return str.replace(/'/g, "''");
}

function sqlArray(arr: string[]): string {
  if (arr.length === 0) return 'array[]::text[]';
  return `array[${arr.map(s => `'${sqlEscape(s)}'`).join(', ')}]`;
}

function sanitizeForKey(name: string): string {
  return name
    .replace(/\s+/g, '_')
    .replace(/[^a-zA-Z0-9_]/g, '')
    .replace(/_+/g, '_')
    .replace(/^_|_$/g, '');  // Remove leading/trailing underscores
}

// ============================================
// 1. GENERATE SKILL_TAGS SQL
// ============================================

function generateSkillTagsSQL(): string {
  const seedPath = path.join(__dirname, '../skill_tags.json.deprecated');

  if (!fs.existsSync(seedPath)) {
    throw new Error(`File not found: ${seedPath}`);
  }

  const oldData: OldSkillTag[] = JSON.parse(fs.readFileSync(seedPath, 'utf-8'));

  const inserts = oldData.map((tag) => {
    const key = tag.key;
    const family = tag.family;
    const country = tag.country || null;
    const display = tag.meta?.display || tag.key;
    const note = tag.meta?.notes || null;
    const examples = tag.meta?.examples || [];

    return `insert into skill_tags (key, family, country, display, note, examples)
values (
  '${key}',
  '${family}'::skill_family_enum,
  ${country ? `'${country}'` : 'null'},
  '${sqlEscape(display)}',
  ${note ? `'${sqlEscape(note)}'` : 'null'},
  ${sqlArray(examples)}
);`;
  });

  const header = `-- ============================================
-- SKILL_TAGS SEED DATA
-- ============================================
-- Generated from: supabase/seed/skill_tags.json.deprecated
-- Count: ${inserts.length} skill tags
-- Date: ${new Date().toISOString()}
-- ============================================

`;

  return header + inserts.join('\n\n');
}

// ============================================
// 2. GENERATE COUNTRIES SQL
// ============================================

function generateCountriesSQL(): string {
  const geojsonPath = path.join(__dirname, '../../../public/geojson/countries.json');

  if (!fs.existsSync(geojsonPath)) {
    throw new Error(`File not found: ${geojsonPath}`);
  }

  const geojson: GeoJSONFeatureCollection = JSON.parse(fs.readFileSync(geojsonPath, 'utf-8'));

  const inserts = geojson.features
    .filter((feature) => feature.properties.iso_a2)  // Skip features without ISO code
    .map((feature) => {
      const iso2 = feature.properties.iso_a2;
      const name = feature.properties.name || feature.properties.name_long;
      const geometry = feature.geometry;

      // Escape for SQL
      const safeName = sqlEscape(name);
      const geometryJSON = sqlEscape(JSON.stringify(geometry));

      // NO centroid_lonlat for polygon type
      return `insert into regions (key, level, name, country, location_type, geometry)
values (
  '${iso2}',
  'country'::region_level_enum,
  '${safeName}',
  null,
  'polygon'::location_type_enum,
  '${geometryJSON}'::jsonb
);`;
    });

  const header = `-- ============================================
-- COUNTRIES SEED DATA
-- ============================================
-- Generated from: public/geojson/countries.json
-- Count: ${inserts.length} countries
-- Date: ${new Date().toISOString()}
-- ============================================
-- Note: No centroid_lonlat for polygon type regions
-- ============================================

`;

  return header + inserts.join('\n\n');
}

// ============================================
// 3. GENERATE INDIA STATES SQL
// ============================================

function generateIndiaStatesSQL(): string {
  const geojsonPath = path.join(__dirname, '../../../public/geojson/regions/IN.json');

  if (!fs.existsSync(geojsonPath)) {
    throw new Error(`File not found: ${geojsonPath}`);
  }

  const geojson: GeoJSONFeatureCollection = JSON.parse(fs.readFileSync(geojsonPath, 'utf-8'));

  const inserts = geojson.features.map((feature) => {
    const name = feature.properties.NAME_1;
    const typeStr = feature.properties.TYPE_1 || 'State';
    const geometry = feature.geometry;

    // Generate key: IN:State_Name
    const key = `IN:${sanitizeForKey(name)}`;

    // Escape for SQL
    const safeName = sqlEscape(name);
    const geometryJSON = sqlEscape(JSON.stringify(geometry));
    const note = typeStr !== 'State' ? typeStr : null;

    // NO centroid_lonlat for polygon type
    return `insert into regions (key, level, name, country, location_type, geometry, note)
values (
  '${key}',
  'province'::region_level_enum,
  '${safeName}',
  'IN',
  'polygon'::location_type_enum,
  '${geometryJSON}'::jsonb,
  ${note ? `'${note}'` : 'null'}
);`;
  });

  const header = `-- ============================================
-- INDIA STATES/UTs SEED DATA
-- ============================================
-- Generated from: public/geojson/regions/IN.json
-- Count: ${inserts.length} states/union territories
-- Date: ${new Date().toISOString()}
-- ============================================
-- Note: No centroid_lonlat for polygon type regions
-- ============================================

`;

  return header + inserts.join('\n\n');
}

// ============================================
// MAIN: GENERATE ALL SEEDS
// ============================================

function main() {
  const outputDir = path.join(__dirname, '..');

  console.log('🚀 Generating fresh seed data...\n');

  try {
    // 1. skill_tags
    console.log('📝 [1/3] Transforming skill_tags...');
    const skillTagsSQL = generateSkillTagsSQL();
    const skillTagsPath = path.join(outputDir, '01_skill_tags.sql');
    fs.writeFileSync(skillTagsPath, skillTagsSQL);
    console.log(`   ✅ Written to: ${path.relative(process.cwd(), skillTagsPath)}`);

    // 2. Countries
    console.log('\n🌍 [2/3] Extracting countries from GeoJSON...');
    const countriesSQL = generateCountriesSQL();
    const countriesPath = path.join(outputDir, '02_countries.sql');
    fs.writeFileSync(countriesPath, countriesSQL);
    console.log(`   ✅ Written to: ${path.relative(process.cwd(), countriesPath)}`);

    // 3. India states
    console.log('\n🇮🇳 [3/3] Extracting India states from GeoJSON...');
    const indiaSQL = generateIndiaStatesSQL();
    const indiaPath = path.join(outputDir, '03_india_states.sql');
    fs.writeFileSync(indiaPath, indiaSQL);
    console.log(`   ✅ Written to: ${path.relative(process.cwd(), indiaPath)}`);

    console.log('\n✨ Seed generation complete!');
    console.log('\n📋 Next steps:');
    console.log('   1. Review generated SQL files in supabase/seed/');
    console.log('   2. Apply migration: supabase db reset');
    console.log('   3. Run seeds in order:');
    console.log('      psql $DB_URL -f supabase/seed/01_skill_tags.sql');
    console.log('      psql $DB_URL -f supabase/seed/02_countries.sql');
    console.log('      psql $DB_URL -f supabase/seed/03_india_states.sql\n');

  } catch (error) {
    console.error('\n❌ Error generating seeds:', error);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

export { generateSkillTagsSQL, generateCountriesSQL, generateIndiaStatesSQL };
