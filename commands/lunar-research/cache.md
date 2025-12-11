---
name: cache
description: List cached research entries from the knowledge base
allowed-tools: Read, Glob
argument-hint: [--detailed]
---

# Research Cache

List entries in the research knowledge base cache.

**Arguments:** $ARGUMENTS

## Instructions

1. Read the cache index: `${CLAUDE_PLUGIN_ROOT}/cache/index.json`

2. If index is empty or missing, output:
   ```
   No cached research found.
   ```

3. Sort entries by timestamp (newest first)

4. **Summary view (default):**

   Output a table:
   ```
   Research Cache (N entries)

   Query                          Date        Confidence  Tags
   ─────────────────────────────────────────────────────────────
   query-name                     YYYY-MM-DD  0.XX        tag1, tag2
   ```

5. **Detailed view (when `--detailed` flag present in arguments):**

   For each entry, read the report files in `${CLAUDE_PLUGIN_ROOT}/cache/[normalizedQuery]/`:
   - `github-report.json`
   - `tavily-report.json`
   - `deepwiki-report.json`
   - `exa-report.json`

   Count sources from each report. Mark as failed if file missing or confidence=0.

   Output expanded cards:
   ```
   Research Cache (N entries)

   ┌─ query-name ─────────────────────────────────────────────────┐
   │ Date: YYYY-MM-DD   Confidence: 0.XX                          │
   │ Tags: tag1, tag2                                             │
   │                                                              │
   │ Researchers:                                                 │
   │   ✓ github    (N sources)    ✓ deepwiki  (N sources)         │
   │   ✓ tavily    (N sources)    ✗ exa       (failed)            │
   └──────────────────────────────────────────────────────────────┘
   ```

## Notes

- Use ✓ for successful researchers (file exists, confidence > 0)
- Use ✗ for failed researchers (file missing or confidence = 0)
- Date format: YYYY-MM-DD (extracted from timestamp)
- Truncate long query names to fit table width
- Cache location: `${CLAUDE_PLUGIN_ROOT}/cache/`
