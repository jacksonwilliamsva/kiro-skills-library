# Multi-MCP Integration Patterns for Kiro CLI

How to connect Kiro to your entire stack through MCP (Model Context Protocol) servers, turning it from a code assistant into a full engineering workstation.

## Architecture Overview

```
┌─────────────────────────────────────────────────┐
│                  Kiro CLI                         │
├─────────────────────────────────────────────────┤
│  Steering Files (behavior)                       │
│  Skills (workflows)                              │
│  MCP Servers (tools)                             │
└──────┬──────┬──────┬──────┬──────┬──────────────┘
       │      │      │      │      │
       ▼      ▼      ▼      ▼      ▼
   Ogham   context  Atlassian  OpenSearch  AWS
  (memory)  -mode    Rovo      (logs)    (infra)
```

## MCP Servers I Use Daily

### 1. Ogham — Persistent Memory

**What:** Semantic + keyword hybrid search over memories that persist across sessions.

**Why:** Kiro sessions are ephemeral. Without persistent memory, you re-explain context every session. Ogham stores decisions, architecture, preferences, and lessons learned.

**Key patterns:**
- Store architectural decisions with rationale
- Remember user preferences and workflow rules
- Link related memories via graph edges
- Search before filesystem browsing (memory is faster than `find`)

**Setup:** PostgreSQL + pgvector + local embeddings (llamacpp with nomic-embed-text)

### 2. context-mode — Context Window Protection

**What:** Sandboxed command execution that keeps raw output out of context.

**Why:** A single `terraform plan` or `git log` can dump 50KB into context. context-mode runs commands in a sandbox and only returns what you search for.

**Key patterns:**
- `ctx_batch_execute` — run multiple commands + search in ONE call
- `ctx_execute_file` — analyze files without loading them into context
- `ctx_fetch_and_index` — fetch web pages, index them, search later
- Route ALL commands with >20 lines output through the sandbox

### 3. Atlassian Rovo — Jira + Confluence

**What:** Search, create, and update Jira issues and Confluence pages.

**Key patterns:**
- Cache cloudId and project keys in steering files (skip discovery calls)
- Use `maxResults: 10` / `limit: 10` to prevent context flooding
- Automate ticket creation from skill outputs (e.g., log review → Jira tickets)

### 4. OpenSearch — Log Analysis

**What:** Query production logs, analyze patterns, detect anomalies.

**Key patterns:**
- Use `IndexMappingTool` before constructing queries
- `SearchIndexTool` with DSL for precise log retrieval
- `LogPatternAnalysisTool` for automated error grouping
- Combine with skills for automated weekly log triage

## Integration Pattern: Steering File as Config Cache

Instead of making discovery API calls every session, cache static config in steering files:

```markdown
---
inclusion: always
---

# Atlassian MCP — Cached Config

- **cloudId**: `your-site.atlassian.net`
- **Jira project key**: `MYPROJECT`
- **Confluence spaceId**: `12345`
- Do NOT call `getAccessibleAtlassianResources`
```

This saves 2-3 API calls per session and keeps context clean.

## Integration Pattern: Skill + MCP Orchestration

Skills can orchestrate multiple MCP tools in sequence:

```
Weekly Log Review Skill:
1. OpenSearch MCP → query error logs (last 7 days)
2. context-mode → deduplicate in sandbox (only summary enters context)
3. Subagents → parallel RCA against source repos
4. User review → approve/reject findings
5. Atlassian MCP → create Jira tickets for confirmed issues
```

## Getting Started

1. Install MCP servers you need (Ogham, context-mode, etc.)
2. Configure in `~/.kiro/kiro.json` or equivalent
3. Create steering files to cache config and set routing rules
4. Build skills that orchestrate the MCP tools for your workflows

## Tips

- **Route aggressively** — anything that might produce large output goes through context-mode
- **Cache everything static** — project keys, account IDs, space IDs in steering files
- **Memory before filesystem** — check Ogham before browsing for context
- **One MCP per concern** — don't overload a single server with unrelated tools
