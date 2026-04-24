---
description: Write a memory note to MemPalace — tagged, indexed, queryable in future sessions via /mxm-recall.
---

# /mxm-remember

## Usage
- Claude Code: `/mxm-remember [context to store]`
- Claude CLI: `claude "/mxm-remember important decision about auth architecture"`
- Claude Desktop: type `/mxm-remember` in chat

Stores important context in MemPalace with automatic office routing. Also writes to `.claude-sessions-memory/` for file-based persistence.

## Behavior

### Step 1 — Parse the context
1. Read the user's input — what should be remembered
2. Detect the relevant Maxim office from content signals:
   - Architecture, tech stack, code → CTO
   - Strategy, finance, investors → CEO
   - Brand, content, SEO, campaigns → CMO
   - Security, compliance, threats → CSO
   - Product, UX, features, roadmap → CPO
   - Sprints, delivery, ops → COO
   - R&D, emerging tech, innovation → CINO
   - Cross-office or ambiguous → maxim (meta wing)
3. Detect the relevant room within that office (see `.claude/skills/memory-palace/SKILL.md` mapping)

### Step 2 — Store in MemPalace (if available)
1. Check if MemPalace MCP is connected
2. If YES: store the fact with wing, room, project ID, and date tags
3. If NO: skip MemPalace, proceed to file storage

### Step 3 — Store in session memory files
1. Append to `.claude-sessions-memory/decision-log.md` if it's a decision
2. Update `.claude-sessions-memory/project_current_state.md` if it's a state change
3. For all types: append to `.claude-sessions-memory/session-[YYYY-MM-DD].md`

### Step 4 — Confirm
Output:
```
Remembered: [one-line summary]
  Office : [office name]
  Wing   : [mempalace wing]
  Room   : [mempalace room]
  Files  : [which .claude-sessions-memory/ files updated]
  Project: [project.id]
```

### Tag output: 🟢 HIGH
