# /mxm-recall

## Usage
- Claude Code: `/mxm-recall [topic or question]`
- Claude CLI: `claude "/mxm-recall what did we decide about auth?"`
- Claude Desktop: type `/mxm-recall` in chat

Retrieves context from MemPalace by topic, project, or office. Falls back to file-based search when MemPalace is unavailable.

## Behavior

### Step 1 — Parse the query
1. Read the user's topic or question
2. Detect search scope:
   - Specific office mentioned → search that wing only
   - Project name/ID mentioned → filter by project tag
   - Time range mentioned → apply temporal filter
   - No scope → search all wings, most recent first

### Step 2 — Search MemPalace (if available)
1. Check if MemPalace MCP is connected
2. If YES:
   - Run semantic search across relevant wings
   - Filter by project ID if in a project context
   - Return top 5 results with temporal validity
3. If NO: proceed to file-based search

### Step 3 — Search session memory files (always)
1. Search `.claude-sessions-memory/decision-log.md` for matching entries
2. Search `.claude-sessions-memory/project_current_state.md` for relevant state
3. Search `.claude-sessions-memory/session-*.md` files for historical context
4. Search `.claude-sessions-memory/feedback_debugging_playbook.md` for known issues

### Step 4 — Merge and present results
1. Combine MemPalace results with file-based results
2. Deduplicate (same fact from both sources → show once)
3. Sort by relevance, then recency
4. Output:

```
Recall: [query summary]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Source: [MemPalace / Files / Both]

1. [date] [office] — [fact or decision]
   Project: [project.id] | Status: [valid/expired]

2. [date] [office] — [fact or decision]
   Project: [project.id] | Status: [valid/expired]

[...up to 5 results]

Total: [N] memories found across [sources]
```

### Mode: By Office
`/mxm-recall --office cto` → search CTO wing only

### Mode: By Project
`/mxm-recall --project mxm-simplification` → search all wings for that project

### Mode: By Time
`/mxm-recall --since 7d` → last 7 days only

### Tag output: 🟢 HIGH
