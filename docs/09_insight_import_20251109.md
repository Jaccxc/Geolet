# Step 9: Insight - Import Functionality

**Timeline:** 5-6 hours
**Priority:** Medium (Enables analytics features)

## Overview
Build the Insight import system to allow users to upload their GeoGuessr game history (CSV/JSON) for analysis.

## Prerequisites
- Step 4 completed (Insight types defined)
- Understanding of CSV/JSON parsing
- Familiarity with file upload patterns

## Detailed Tasks

### 9.1 Install Dependencies

```bash
bun add papaparse
bun add -D @types/papaparse
bunx shadcn-ui@latest add input
bunx shadcn-ui@latest add table
bunx shadcn-ui@latest add alert
```

### 9.2 Create Import Parser Utilities

#### `/src/features/insight/controllers/parse-geoguessr-data.ts`

```typescript
import Papa from 'papaparse';
import type { InsightRound } from '../types';

export interface ParseResult {
  rounds: Omit<InsightRound, 'id' | 'user_id'>[];
  errors: string[];
  total: number;
}

export async function parseGeoGuessrCSV(file: File): Promise<ParseResult> {
  return new Promise((resolve) => {
    const rounds: any[] = [];
    const errors: string[] = [];

    Papa.parse(file, {
      header: true,
      skipEmptyLines: true,
      complete: (results) => {
        for (let i = 0; i < results.data.length; i++) {
          const row: any = results.data[i];

          try {
            const round = parseRow(row, i);
            if (round) rounds.push(round);
          } catch (error) {
            errors.push(`Row ${i + 2}: ${error}`);
          }
        }

        resolve({
          rounds,
          errors,
          total: results.data.length,
        });
      },
      error: (error) => {
        resolve({
          rounds: [],
          errors: [error.message],
          total: 0,
        });
      },
    });
  });
}

export async function parseGeoGuessrJSON(file: File): Promise<ParseResult> {
  try {
    const text = await file.text();
    const data = JSON.parse(text);

    const rounds: any[] = [];
    const errors: string[] = [];

    // Support different JSON structures
    const items = Array.isArray(data) ? data : data.rounds || data.items || [];

    for (let i = 0; i < items.length; i++) {
      try {
        const round = parseJSONItem(items[i], i);
        if (round) rounds.push(round);
      } catch (error) {
        errors.push(`Item ${i + 1}: ${error}`);
      }
    }

    return {
      rounds,
      errors,
      total: items.length,
    };
  } catch (error) {
    return {
      rounds: [],
      errors: [(error as Error).message],
      total: 0,
    };
  }
}

function parseRow(row: any, index: number): any {
  // Expected columns: played_at, country, target_country, distance_m, time_ms
  // Or variations: date, guess, answer, distance, time

  const played_at = parseDate(
    row.played_at || row.date || row.timestamp
  );

  const country = parseCountryCode(
    row.country || row.guess || row.guessed_country
  );

  const target_country = parseCountryCode(
    row.target_country || row.answer || row.actual_country
  );

  const distance_m = parseFloat(
    row.distance_m || row.distance || row.distance_meters || '0'
  );

  const time_ms = parseInt(
    row.time_ms || row.time || row.time_seconds ? row.time_seconds * 1000 : '0',
    10
  );

  return {
    played_at,
    country,
    target_country,
    distance_m,
    time_ms,
    meta: {},
  };
}

function parseJSONItem(item: any, index: number): any {
  return {
    played_at: parseDate(item.played_at || item.date || item.timestamp),
    country: parseCountryCode(item.country || item.guess),
    target_country: parseCountryCode(item.target_country || item.answer),
    distance_m: item.distance_m || item.distance || 0,
    time_ms: item.time_ms || item.time || 0,
    meta: item.meta || {},
  };
}

function parseDate(dateStr: any): Date | null {
  if (!dateStr) return null;
  const date = new Date(dateStr);
  return isNaN(date.getTime()) ? null : date;
}

function parseCountryCode(code: any): string | null {
  if (!code) return null;
  const str = String(code).toUpperCase().trim();
  // Basic validation: 2-letter ISO code
  return /^[A-Z]{2}$/.test(str) ? str : null;
}
```

### 9.3 Create Import API Route

#### `/src/app/api/insight/import/route.ts`

```typescript
import { NextRequest, NextResponse } from 'next/server';
import { createClient } from '@/libs/supabase/supabase-server-client';

export async function POST(req: NextRequest) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    const { rounds } = body;

    if (!Array.isArray(rounds) || rounds.length === 0) {
      return NextResponse.json(
        { error: 'No rounds provided' },
        { status: 400 }
      );
    }

    // Add user_id to each round
    const roundsWithUser = rounds.map(r => ({
      ...r,
      user_id: user.id,
    }));

    // Batch insert
    const { data, error } = await supabase
      .from('insight_rounds')
      .insert(roundsWithUser)
      .select();

    if (error) {
      console.error('Insert error:', error);
      return NextResponse.json(
        { error: 'Failed to import rounds' },
        { status: 500 }
      );
    }

    return NextResponse.json({
      imported: data.length,
      total: rounds.length,
    });
  } catch (error) {
    console.error('Import error:', error);
    return NextResponse.json(
      { error: 'Failed to process import' },
      { status: 500 }
    );
  }
}
```

### 9.4 Create Import UI Components

#### `/src/features/insight/components/import-wizard.tsx`

```typescript
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Alert, AlertDescription } from '@/components/ui/alert';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Upload, FileText, CheckCircle2, AlertCircle } from 'lucide-react';
import { parseGeoGuessrCSV, parseGeoGuessrJSON } from '../controllers/parse-geoguessr-data';

type Step = 'upload' | 'preview' | 'importing' | 'complete';

export function ImportWizard() {
  const [step, setStep] = useState<Step>('upload');
  const [file, setFile] = useState<File | null>(null);
  const [parsedData, setParsedData] = useState<any>(null);
  const [importResult, setImportResult] = useState<any>(null);

  const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0];
    if (!selectedFile) return;

    setFile(selectedFile);

    // Parse file
    const ext = selectedFile.name.split('.').pop()?.toLowerCase();
    let result;

    if (ext === 'csv') {
      result = await parseGeoGuessrCSV(selectedFile);
    } else if (ext === 'json') {
      result = await parseGeoGuessrJSON(selectedFile);
    } else {
      alert('Unsupported file format. Please use CSV or JSON.');
      return;
    }

    setParsedData(result);
    setStep('preview');
  };

  const handleImport = async () => {
    if (!parsedData) return;

    setStep('importing');

    try {
      const response = await fetch('/api/insight/import', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ rounds: parsedData.rounds }),
      });

      const data = await response.json();
      setImportResult(data);
      setStep('complete');
    } catch (error) {
      alert('Import failed. Please try again.');
      setStep('preview');
    }
  };

  return (
    <Card className="max-w-3xl mx-auto">
      <CardHeader>
        <CardTitle>Import GeoGuessr Data</CardTitle>
        <CardDescription>
          Upload your game history to unlock personalized insights
        </CardDescription>
      </CardHeader>
      <CardContent>
        {step === 'upload' && (
          <div className="space-y-4">
            <div className="border-2 border-dashed rounded-lg p-12 text-center">
              <Upload className="w-12 h-12 mx-auto mb-4 text-muted-foreground" />
              <p className="text-sm text-muted-foreground mb-4">
                Upload a CSV or JSON file with your GeoGuessr game history
              </p>
              <Input
                type="file"
                accept=".csv,.json"
                onChange={handleFileSelect}
                className="max-w-xs mx-auto"
              />
            </div>

            <Alert>
              <FileText className="h-4 w-4" />
              <AlertDescription>
                <strong>Expected format:</strong> Each row should include played_at, country, target_country, distance_m, and time_ms.
              </AlertDescription>
            </Alert>
          </div>
        )}

        {step === 'preview' && parsedData && (
          <div className="space-y-4">
            {/* Stats */}
            <div className="grid grid-cols-3 gap-4">
              <div className="text-center p-4 border rounded">
                <div className="text-2xl font-bold">{parsedData.total}</div>
                <div className="text-sm text-muted-foreground">Total Rows</div>
              </div>
              <div className="text-center p-4 border rounded">
                <div className="text-2xl font-bold text-green-600">{parsedData.rounds.length}</div>
                <div className="text-sm text-muted-foreground">Valid</div>
              </div>
              <div className="text-center p-4 border rounded">
                <div className="text-2xl font-bold text-red-600">{parsedData.errors.length}</div>
                <div className="text-sm text-muted-foreground">Errors</div>
              </div>
            </div>

            {/* Errors */}
            {parsedData.errors.length > 0 && (
              <Alert variant="destructive">
                <AlertCircle className="h-4 w-4" />
                <AlertDescription>
                  <strong>{parsedData.errors.length} errors found:</strong>
                  <ul className="mt-2 list-disc list-inside text-sm">
                    {parsedData.errors.slice(0, 5).map((err: string, i: number) => (
                      <li key={i}>{err}</li>
                    ))}
                  </ul>
                </AlertDescription>
              </Alert>
            )}

            {/* Preview */}
            <div className="border rounded-lg overflow-hidden">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Date</TableHead>
                    <TableHead>Guess</TableHead>
                    <TableHead>Answer</TableHead>
                    <TableHead>Distance</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {parsedData.rounds.slice(0, 5).map((round: any, i: number) => (
                    <TableRow key={i}>
                      <TableCell>{round.played_at?.toLocaleDateString() || 'N/A'}</TableCell>
                      <TableCell>{round.country || 'N/A'}</TableCell>
                      <TableCell>{round.target_country || 'N/A'}</TableCell>
                      <TableCell>{round.distance_m ? `${(round.distance_m / 1000).toFixed(1)} km` : 'N/A'}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>

            {/* Actions */}
            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setStep('upload')}>
                Cancel
              </Button>
              <Button
                className="flex-1"
                onClick={handleImport}
                disabled={parsedData.rounds.length === 0}
              >
                Import {parsedData.rounds.length} Rounds
              </Button>
            </div>
          </div>
        )}

        {step === 'importing' && (
          <div className="text-center py-12">
            <div className="animate-spin w-12 h-12 border-4 border-primary border-t-transparent rounded-full mx-auto mb-4" />
            <p className="text-muted-foreground">Importing your data...</p>
          </div>
        )}

        {step === 'complete' && importResult && (
          <div className="text-center py-12 space-y-4">
            <CheckCircle2 className="w-16 h-16 text-green-500 mx-auto" />
            <div>
              <h3 className="text-2xl font-bold">Import Complete!</h3>
              <p className="text-muted-foreground mt-2">
                Successfully imported {importResult.imported} rounds
              </p>
            </div>
            <Button onClick={() => window.location.href = '/insight'}>
              View Insights
            </Button>
          </div>
        )}
      </CardContent>
    </Card>
  );
}
```

### 9.5 Create Insight Page

#### `/src/app/(account)/insight/page.tsx`

```typescript
import { ImportWizard } from '@/features/insight/components/import-wizard';

export default function InsightPage() {
  return (
    <div className="container py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold">Insight</h1>
        <p className="text-muted-foreground mt-2">
          Import your GeoGuessr history to unlock personalized analytics
        </p>
      </div>

      <ImportWizard />
    </div>
  );
}
```

### 9.6 Update Navigation

Add Insight link to `/src/app/navigation.tsx`:

```typescript
<NavigationLink href="/insight">Insight</NavigationLink>
```

## Files to Create/Modify

### Created:
- `/src/features/insight/controllers/parse-geoguessr-data.ts`
- `/src/features/insight/components/import-wizard.tsx`
- `/src/app/api/insight/import/route.ts`
- `/src/app/(account)/insight/page.tsx`

### Modified:
- `/src/app/navigation.tsx` (add Insight link)

## Acceptance Criteria
- ✅ Can navigate to /insight page
- ✅ File upload accepts CSV and JSON
- ✅ Parser handles various CSV/JSON formats
- ✅ Preview shows valid rows and errors
- ✅ Import API inserts rounds into database
- ✅ Success message shows imported count
- ✅ Error handling for malformed data
- ✅ RLS policies prevent cross-user access

## Notes & Considerations

### Supported Formats
- **CSV**: Headers + data rows
- **JSON**: Array of objects or `{rounds: [...]}`

### Data Validation
- Country codes: 2-letter ISO (e.g., "US", "FR")
- Dates: ISO 8601 or common formats
- Numbers: Distance in meters, time in milliseconds

### Performance
- Batch insert (max 1000 rows per request)
- Consider chunking for very large files
- Client-side parsing (avoid server memory issues)

### Future Enhancements
- Auto-detect format from content
- Support for Plonkit exports
- Duplicate detection
- Export functionality

## Dependencies
- Step 4 (Insight types defined)
- Step 2 (Database schema with insight_rounds table)

## Blocks
- Step 10 (Insight Analytics)
