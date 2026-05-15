---
name: context-engineering
description: Use when agent output quality degrades, when starting a new session or project, when switching tasks, or when configuring steering files and context for Kiro
---

# Context Engineering

Feed the agent the right information at the right time. Context is the single biggest lever for output quality — too little and the agent hallucinates, too much and it loses focus.

## The Context Hierarchy

Structure context from most persistent to most transient:

```
┌─────────────────────────────────────┐
│  1. Steering Files (.kiro/*.md)     │ ← Always loaded, project-wide
├─────────────────────────────────────┤
│  2. Skills (~/.kiro/skills/)        │ ← Loaded when triggered
├─────────────────────────────────────┤
│  3. Knowledge Bases (indexed)       │ ← Searched on demand via ctx_search
├─────────────────────────────────────┤
│  4. Relevant Source Files           │ ← Loaded per task
├─────────────────────────────────────┤
│  5. Error Output / Test Results     │ ← Loaded per iteration
├─────────────────────────────────────┤
│  6. Conversation History            │ ← Accumulates, compacts
└─────────────────────────────────────┘
```

### Level 1: Steering Files

Always-included markdown in `.kiro/`. Highest-leverage context. Cover: tech stack, commands, conventions, boundaries, patterns.

### Level 2: Skills

Reusable techniques at `~/.kiro/skills/*/SKILL.md`. Triggered by description match — not always loaded.

### Level 3: Knowledge Bases

Use `ctx_index` or `ctx_fetch_and_index` to persist docs, specs, and references. Query with `ctx_search`. Content stays out of context until needed.

### Level 4–6: Task Context

Load only what's relevant. Use `ctx_execute_file` to analyze without flooding context. Use `ctx_batch_execute` to gather and search in one call.

## Context Packing Strategies

**Selective Include** — only load files relevant to the current task. One example of the pattern to follow beats five files of background.

**Hierarchical Summary** — maintain a project map in a steering file. Load only the relevant section.

**Knowledge Base Offload** — index large docs once, search on demand. Raw content never enters context.

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "The agent should figure out conventions" | Write a steering file — 10 min saves hours |
| "I'll correct it when it goes wrong" | Prevention beats correction. Upfront context prevents drift |
| "More context is always better" | Performance degrades with excess instructions. Be selective |
| "The context window is huge, use it all" | Window size ≠ attention budget. Focused context wins |

## Red Flags — Refresh Context When:

- Output doesn't match project conventions
- Agent invents APIs or imports that don't exist
- Agent re-implements utilities already in the codebase
- Quality degrades as conversation lengthens
- No steering file exists in the project

## Quick Reference

| Action | Tool |
|--------|------|
| Always-on project rules | `.kiro/*.md` steering files |
| Reusable techniques | `~/.kiro/skills/*/SKILL.md` |
| Index docs/specs | `ctx_index` or `ctx_fetch_and_index` |
| Search indexed content | `ctx_search` |
| Analyze files without flooding | `ctx_execute_file` |
| Batch gather + search | `ctx_batch_execute` |
| Fresh session | Start new chat when context drifts |
