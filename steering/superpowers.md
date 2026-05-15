---
inclusion: always
---

# Superpowers — Skill-Driven Workflow

Skills at `~/.kiro/skills/*/SKILL.md`. Always read current version — never guess from memory.

**Check skills BEFORE acting.** Even 1% chance → read it. Wrong for the situation? Don't use it.

## Flow

1. Could a skill apply? → Read it
2. Announce: "Using [skill] to [purpose]"
3. If checklist → create todo per item. Follow exactly.

## Available Skills

| Skill | Trigger |
|-------|---------|
| brainstorming | Before creative work — features, components, behavior changes |
| using-git-worktrees | Feature work needing isolation |
| writing-plans | Breaking designs into tasks |
| executing-plans | Executing plans with checkpoints |
| subagent-driven-development | Fast iteration with two-stage review |
| dispatching-parallel-agents | 2+ independent tasks, no shared state |
| test-driven-development | During implementation — RED-GREEN-REFACTOR |
| requesting-code-review | Between tasks or before merge |
| receiving-code-review | Before implementing review feedback |
| finishing-a-development-branch | Tasks complete — merge/PR/cleanup |
| grill-me | Stress-testing a plan or decision |
| verification-phase | After all tasks, before merge — multi-expert |
| systematic-debugging | Any bug, test failure, unexpected behavior |
| verification-before-completion | Before claiming work is done |
| writing-skills | Creating or editing skills |

## Priority

1. Process skills first (brainstorming, debugging) — determine approach
2. Implementation skills second — guide execution

**Rigid** (TDD, debugging): follow exactly. **Flexible** (patterns): adapt to context.

## Instruction Priority

1. User's explicit instructions — highest
2. Skills — override defaults where they conflict
3. System prompt — lowest
