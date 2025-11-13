/**
 * WATG24 Cities Progress Verification
 *
 * This script helps verify the implementation progress of WATG24 cities.
 * Run this after applying migrations to check for issues.
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

interface CityReference {
  name: string;
  tier: string;
  skillKey: string;
  regionKey: string;
  countryCode: string;
}

interface ProgressReport {
  totalCities: number;
  citiesWithSkillTags: number;
  citiesWithRegions: number;
  citiesWithCards: number;
  missingSkillTags: string[];
  missingRegions: string[];
  missingCards: string[];
  incompleteNotes: string[];
  percentComplete: number;
}

// ANSI color codes for terminal output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m',
};

function loadCityList(): CityReference[] {
  const jsonPath = path.join(__dirname, '../watg24_cities_list.json');
  if (!fs.existsSync(jsonPath)) {
    console.error(`${colors.red}❌ City list not found: ${jsonPath}${colors.reset}`);
    process.exit(1);
  }

  return JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
}

function analyzeTemplate(): {
  citiesWithTODOs: string[];
  citiesWithNotes: string[];
  citiesWithRegions: string[];
} {
  const templatePath = path.join(__dirname, '../watg24_cities_template.sql');

  if (!fs.existsSync(templatePath)) {
    console.error(`${colors.red}❌ Template not found: ${templatePath}${colors.reset}`);
    return {
      citiesWithTODOs: [],
      citiesWithNotes: [],
      citiesWithRegions: [],
    };
  }

  const template = fs.readFileSync(templatePath, 'utf-8');

  // Count TODO occurrences
  const todoMatches = template.match(/TODO:/g);
  const totalTODOs = todoMatches ? todoMatches.length : 0;

  // Extract cities with completed notes (those without TODO in note field)
  const notePattern = /insert into skill_tags[^;]*?'([^']+)'\s*,\s*'city'::skill_family_enum\s*,\s*(?:'([A-Z]{2})'|null)\s*,\s*'([^']+)'\s*,\s*'([^']+)'/g;
  const citiesWithNotes: string[] = [];
  const citiesWithTODOs: string[] = [];

  let match;
  while ((match = notePattern.exec(template)) !== null) {
    const [, skillKey, countryCode, displayName, note] = match;
    if (note && !note.includes('TODO')) {
      citiesWithNotes.push(displayName);
    } else {
      citiesWithTODOs.push(displayName);
    }
  }

  // Extract cities with region mappings
  const regionPattern = /\(select id from regions where key = '([^']+)'\)/g;
  const citiesWithRegions: string[] = [];
  while ((match = regionPattern.exec(template)) !== null) {
    citiesWithRegions.push(match[1]);
  }

  return {
    citiesWithTODOs,
    citiesWithNotes,
    citiesWithRegions,
  };
}

function generateProgressReport(): ProgressReport {
  const cities = loadCityList();
  const templateAnalysis = analyzeTemplate();

  const report: ProgressReport = {
    totalCities: cities.length,
    citiesWithSkillTags: templateAnalysis.citiesWithNotes.length,
    citiesWithRegions: templateAnalysis.citiesWithRegions.length,
    citiesWithCards: 0, // Would need DB connection to check
    missingSkillTags: templateAnalysis.citiesWithTODOs,
    missingRegions: cities.filter(c => c.regionKey === 'TODO:' + c.name.toLowerCase().replace(/\s+/g, '_')).map(c => c.name),
    missingCards: [],
    incompleteNotes: templateAnalysis.citiesWithTODOs,
    percentComplete: 0,
  };

  // Calculate percentage based on notes completed
  report.percentComplete = Math.round(
    (report.citiesWithSkillTags / report.totalCities) * 100
  );

  return report;
}

function displayProgressReport(report: ProgressReport) {
  console.log('\n' + '='.repeat(60));
  console.log(`${colors.cyan}📊 WATG24 Cities Implementation Progress${colors.reset}`);
  console.log('='.repeat(60) + '\n');

  // Overall progress
  console.log(`${colors.blue}Overall Progress:${colors.reset}`);
  console.log(`  Total Cities: ${report.totalCities}`);
  console.log(`  Completion: ${getProgressBar(report.percentComplete)} ${report.percentComplete}%\n`);

  // Detailed stats
  console.log(`${colors.blue}Detailed Statistics:${colors.reset}`);
  console.log(`  ✅ Cities with geographic notes: ${colors.green}${report.citiesWithSkillTags}${colors.reset} / ${report.totalCities}`);
  console.log(`  ✅ Cities with region mappings: ${colors.green}${report.citiesWithRegions}${colors.reset} / ${report.totalCities}`);
  console.log(`  ⏳ Cities with incomplete notes: ${colors.yellow}${report.incompleteNotes.length}${colors.reset}`);
  console.log('');

  // Tier breakdown
  console.log(`${colors.blue}Progress by Tier:${colors.reset}`);
  displayTierBreakdown();
  console.log('');

  // Next steps
  if (report.percentComplete < 100) {
    console.log(`${colors.blue}📋 Next Steps:${colors.reset}`);
    if (report.incompleteNotes.length > 0) {
      console.log(`  1. Complete geographic notes for ${report.incompleteNotes.length} cities`);
      console.log(`  2. Create pin regions for cities without regions`);
      console.log(`  3. Map fact cards to region keys`);
      console.log(`  4. Create and apply migrations`);
    }
    console.log('');
  } else {
    console.log(`${colors.green}🎉 All cities completed! Ready to create migrations.${colors.reset}\n`);
  }

  // Show sample of incomplete cities
  if (report.incompleteNotes.length > 0) {
    console.log(`${colors.yellow}📝 Sample of Cities Needing Attention (first 10):${colors.reset}`);
    const sample = report.incompleteNotes.slice(0, 10);
    sample.forEach((city, idx) => {
      console.log(`  ${idx + 1}. ${city}`);
    });
    if (report.incompleteNotes.length > 10) {
      console.log(`  ... and ${report.incompleteNotes.length - 10} more`);
    }
    console.log('');
  }
}

function getProgressBar(percent: number, width: number = 30): string {
  const filled = Math.round((percent / 100) * width);
  const empty = width - filled;
  const bar = '█'.repeat(filled) + '░'.repeat(empty);
  return `[${bar}]`;
}

function displayTierBreakdown() {
  const tiers = [
    { name: 'Alpha++', count: 2 },
    { name: 'Alpha+', count: 8 },
    { name: 'Alpha', count: 17 },
    { name: 'Alpha-', count: 22 },
    { name: 'Beta+', count: 20 },
    { name: 'Beta', count: 23 },
    { name: 'Beta-', count: 28 },
    { name: 'Gamma+', count: 20 },
    { name: 'Gamma', count: 25 },
    { name: 'Gamma-', count: 25 },
    { name: 'High Suff.', count: 26 },
    { name: 'Sufficiency', count: 119 },
  ];

  tiers.forEach(tier => {
    const label = tier.name.padEnd(12);
    const countStr = `${tier.count} cities`.padEnd(12);
    // In a real implementation, we'd check actual completion per tier
    // For now, just show the counts
    console.log(`  ${label} : ${countStr}`);
  });
}

function displaySQLQueries() {
  console.log('\n' + '='.repeat(60));
  console.log(`${colors.cyan}🔍 Useful Verification Queries${colors.reset}`);
  console.log('='.repeat(60) + '\n');

  console.log(`${colors.blue}1. Check Card Groups Created:${colors.reset}`);
  console.log(`${colors.green}select name from card_groups where name like 'cities_watg24_%' order by name;${colors.reset}\n`);

  console.log(`${colors.blue}2. Count Cards Per Tier:${colors.reset}`);
  console.log(`${colors.green}select
  cg.name,
  count(fc.id) as card_count
from card_groups cg
left join fact_cards fc on fc.card_group_id = cg.id
where cg.name like 'cities_watg24_%'
group by cg.name
order by card_count desc;${colors.reset}\n`);

  console.log(`${colors.blue}3. Find Cards Without Regions:${colors.reset}`);
  console.log(`${colors.green}select fc.prompt, cg.name
from fact_cards fc
join card_groups cg on cg.id = fc.card_group_id
where cg.name like 'cities_watg24_%'
and fc.answer_region_id is null;${colors.reset}\n`);

  console.log(`${colors.blue}4. Verify Skill Tags:${colors.reset}`);
  console.log(`${colors.green}select key, display, country, length(note) as note_length
from skill_tags
where key like 'city:%'
and note like '%TODO%';${colors.reset}\n`);

  console.log(`${colors.blue}5. Check Topics Created:${colors.reset}`);
  console.log(`${colors.green}select key, title, difficulty
from topics
where key in ('global-major-cities', 'cities-500');${colors.reset}\n`);
}

function main() {
  console.log(`\n${colors.cyan}🌍 WATG24 Cities Progress Checker${colors.reset}\n`);

  try {
    const report = generateProgressReport();
    displayProgressReport(report);
    displaySQLQueries();

    console.log('='.repeat(60));
    console.log(`${colors.cyan}💡 Tip:${colors.reset} Run this script after each batch to track progress!`);
    console.log('='.repeat(60) + '\n');

  } catch (error) {
    console.error(`${colors.red}❌ Error:${colors.reset}`, error);
    process.exit(1);
  }
}

// Run main
main();

export { generateProgressReport, displayProgressReport };
