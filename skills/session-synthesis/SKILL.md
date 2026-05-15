---
name: session-synthesis
description: |
  Process queued Kiro sessions into wiki content. Produces weekly digests
  and updates self/ profile pages. Trigger: "run session synthesis",
  "process my sessions", "weekly synthesis", or "session digest".
---

# Session Synthesis Skill

Process completed Kiro CLI sessions into the wiki second brain.

## Trigger

Invoke when the user says any of:
- "run session synthesis"
- "process my sessions"
- "weekly synthesis"
- "session digest"
- "bulk ingest sessions"
- "bootstrap second brain"

## Prerequisites

- Queue file: `~/.kiro/session-capture-queue.txt`
- Processed file: `~/.kiro/session-capture-processed.txt`
- Sessions dir: `~/.kiro/sessions/cli/`
- Wiki self/ pages: `~/wiki/self/`
- Wiki insights/: `~/wiki/insights/`

## Privacy Rules (HARD — never override)

Before extracting ANY content from sessions, apply these filters:

**NEVER include in wiki output:**
- AWS credentials, access keys, secret keys, session tokens
- API keys, bearer tokens, OAuth tokens
- Passwords, connection strings with embedded credentials
- PII: client names, account numbers, email addresses, phone numbers
- Any string matching: `AKIA[A-Z0-9]{16}`, `[A-Za-z0-9/+=]{40}`, `Bearer [A-Za-z0-9._-]+`

**OK to include:**
- Project names, repo names, service names, tool names
- Architecture decisions, technical approaches
- Working dynamics, professional opinions
- Error messages (with PII stripped)
- Internal business context

## Process

### 1. Read Queue

```bash
cat ~/.kiro/session-capture-queue.txt
```

Subtract IDs already in `~/.kiro/session-capture-processed.txt`. If nothing to process, report "No new sessions to process" and stop.

For **bulk ingest mode**: list ALL `~/.kiro/sessions/cli/*.jsonl` files, subtract already-processed, process all remaining.

### 2. Load Sessions

For each unprocessed session ID, read `~/.kiro/sessions/cli/<id>.jsonl`.

Parse JSONL — each line is a JSON object:
```json
{"version":"v1","kind":"Prompt","data":{"message_id":"uuid","content":[{"kind":"text","data":"user message text"}],"meta":{"timestamp":1777432077}}}
```

Extract only lines where `kind` is `"Prompt"` (user messages). The text is at `data.content[].data`. The timestamp is at `data.meta.timestamp`.

Skip `kind: "AssistantMessage"` — we want the user's voice, not the assistant's.

### 3. Extract Signals (use subagents for batches)

For each batch of sessions, dispatch a subagent to extract:
- **Decisions made** — architectural choices, tool selections, approach changes
- **Topics worked on** — projects, features, bugs, infrastructure
- **Tools & techniques** — new tools adopted, techniques tried
- **Frustrations** — complaints, repeated issues, things that wasted time
- **Learnings** — "aha" moments, things discovered, corrections received
- **Goals mentioned** — explicit goals, progress updates, aspirations
- **Voice patterns** — how the user communicates (terse? detailed? emotional?)
- **Values signals** — what the user prioritises, rejects, or insists on

Subagent prompt should include the privacy rules and instruct: "Extract ONLY from user prompts. Do not include any credentials, tokens, API keys, or PII."

### 4. Produce Weekly Digest

Group sessions by ISO week (use timestamp from first prompt in each session). For each week with new sessions, create or update:

`~/wiki/insights/YYYY-WNN-synthesis.md`

Format:
```markdown
---
title: "Week NN, YYYY — Session Synthesis"
type: insight
created: YYYY-MM-DD
week: YYYY-WNN
sessions_processed: N
---

# Week NN, YYYY

## What I Worked On
- [bullet points with [[wikilinks]] to project pages where relevant]

## Decisions Made
- [link to wiki/decisions/ pages if formal ADRs exist]

## New Tools & Techniques
- [tools discovered or adopted]

## Frustrations
- [recurring pain points, wasted time]

## Progress Toward Goals
- [movement on stated goals]

## Patterns & Shifts
- [emerging patterns, interest shifts, behaviour changes]
```

### 5. Update Self Pages

Read current `wiki/self/*.md` pages. For each page:
1. Add new entries under `## Evolution Log` with the week header (`### YYYY-WNN`)
2. Rewrite `## Current Understanding` to reflect the latest synthesised state
3. Update `updated:` date in frontmatter

Do NOT delete existing evolution log entries — only append.

### 6. Update Session Log

Append to `wiki/insights/session-log.md` table:

```markdown
| YYYY-MM-DD | <session-id-short> | One-line summary |
```

Use first 8 chars of session ID for readability.

### 7. Mark Processed

Append all processed session IDs to `~/.kiro/session-capture-processed.txt` (one per line).

### 8. Update Wiki Metadata

- Add new insight pages to `wiki/index.md` under `## Insights`
- Append operation to `wiki/log.md`:
  ```
  | YYYY-MM-DD | session-synthesis | Processed N sessions, created/updated M insight pages |
  ```

## Bulk Ingest Mode

When triggered by "bulk ingest sessions" or "bootstrap second brain":

1. List ALL `~/.kiro/sessions/cli/*.jsonl` files
2. Subtract already-processed IDs
3. Sort chronologically (by file mtime or first prompt timestamp)
4. Process in batches of 20-30 sessions per subagent
5. Produce weekly digests for all historical weeks
6. Build comprehensive initial `self/` pages from the full corpus
7. Report progress after each batch: "Processed batch N/M (sessions X-Y)"

This will take significant time for large corpora. Be patient and report progress.

## Subagent Strategy

- One subagent per batch of 10-20 sessions (keeps context focused)
- Each subagent returns structured extraction (decisions, topics, tools, frustrations, learnings, goals, voice, values)
- Main agent merges extractions and writes wiki pages
- Process in chronological order so patterns emerge naturally
- Use `dispatching-parallel-agents` skill if processing multiple independent weeks

## Example Invocation

User: "run session synthesis"

Agent:
1. Reads queue → finds 5 unprocessed sessions
2. Loads JSONL files, extracts user prompts
3. Dispatches subagent with prompts for extraction
4. Receives structured signals
5. Groups by week → all in 2026-W18
6. Creates `wiki/insights/2026-W18-synthesis.md`
7. Updates `wiki/self/` pages with new patterns
8. Appends to session-log.md
9. Marks 5 sessions as processed
10. Reports: "Synthesised 5 sessions into Week 18 digest. Updated voice.md, interests.md."
