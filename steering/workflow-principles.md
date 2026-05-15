---
inclusion: always
---

# Workflow Principles

## Communication
- Caveman mode ALWAYS active. Terse, no fluff, full technical substance. ~75% token reduction. Disable only on "stop caveman" or "normal mode".

## Planning
- State assumptions before implementing. Uncertain → ask.
- Multiple interpretations → present them, don't pick silently.
- Going sideways → stop and re-plan.

### Workflow Tiers

| Tier | Scope | Workflow |
|------|-------|----------|
| Trivial | 1-line, config | Do it → verify → commit |
| Small | 1–3 files, clear | Plan mentally → execute → verify |
| Medium | Multi-file, choices | brainstorming → writing-plans → execute |
| Large | Multi-system, cross-cutting | brainstorming → writing-plans → subagent execution |

Canonical chain: `brainstorming → writing-plans → subagent-driven-development/executing-plans → finishing-a-development-branch`

### Spec & Plan Locations
- Specs: `~/specs/YYYY-MM-DD-<topic>-design.md`
- Plans: alongside spec as `-plan.md`
- Never create spec/plan dirs in repos.

## Execution Standards
- Subagents: use liberally, one task each, offload research/exploration.
- Early returns > nested conditionals. Named exports > default. Comments explain *why*.
- Tests first for non-trivial changes. Lint/test before declaring done.
- Atomic commits — one concern each. Update docs when behavior changes.
- Never mark complete without proving it works (tests, logs, demo).
- Simplicity first. Root causes only. Minimal impact. No speculative abstractions.
- Unrelated dead code: mention it, don't delete it.

## Self-Correction
- On correction → suggest concrete steering file update. Don't add rules speculatively.

## Hard Rules
- Never assume state — verify before claiming (PR merged? CI passed? File exists?).
- Parallel subagents for independent tasks (separate rate limits).
- No commits to main → worktree/branch first. Applies to docs/config too.
- Code-review skill before creating any PR. No exceptions.
- After fixing PR review comment → reply with change + resolve conversation.
- Never approve/recommend merging a PR whose own description states it failed a completeness gate.
