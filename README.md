# Kiro Skills Library

A collection of battle-tested [Kiro CLI](https://kiro.dev) skills and steering files for engineering workflows. Built from daily production use as a Principal DevOps Engineer managing AWS infrastructure, Python applications, and Terraform at scale.

## What's Here

### Skills (`skills/`)

Reusable skill files that teach Kiro structured workflows. Drop them into `~/.kiro/skills/` and they activate automatically based on context.

| Category | Skills | Purpose |
|----------|--------|---------|
| **Process** | brainstorming, writing-plans, executing-plans | Structured ideation → planning → execution |
| **Implementation** | test-driven-development, subagent-driven-development, dispatching-parallel-agents | Disciplined coding workflows |
| **Quality** | code-review, verification-phase, verification-before-completion, grill-me | Multi-layer quality gates |
| **Git** | using-git-worktrees, finishing-a-development-branch | Safe branching and merge workflows |
| **Review** | requesting-code-review, receiving-code-review | PR workflow discipline |
| **Meta** | context-engineering, session-synthesis, writing-skills | Improving Kiro itself |
| **Engineering** | systematic-debugging, code-simplification, api-and-interface-design | Technical excellence patterns |
| **Operations** | ci-cd-and-automation, shipping-and-launch, performance-optimization | DevOps workflows |
| **Security** | security-guidance | Secure coding pattern awareness |

### Steering Files (`steering/`)

Context files that shape Kiro's behavior across all sessions. These go in `~/.kiro/steering/`.

- **workflow-principles.md** — Workflow tiers, execution standards, hard rules
- **context-mode-routing.md** — MCP routing rules to protect your context window
- **superpowers.md** — Skill discovery and invocation framework
- **html-output.md** — Self-contained HTML output for reports, analyses, and human-readable artifacts

### MCP Integration Guides (`guides/`)

Patterns for connecting Kiro to external tools via MCP.

## Philosophy

These skills encode a specific engineering philosophy:

1. **Process before code** — Brainstorm and plan before touching files
2. **Verification is non-negotiable** — Never claim done without proving it
3. **Subagents for isolation** — Keep main context clean, delegate focused work
4. **Self-correction over repetition** — When mistakes happen, add rules so they don't recur
5. **Simplicity first** — No speculative abstractions, no over-engineering

## Installation

```bash
# Clone the repo
git clone https://github.com/jacksonwilliamsva/kiro-skills-library.git

# Symlink individual skills
ln -s /path/to/kiro-skills-library/skills/verification-phase ~/.kiro/skills/verification-phase

# Or copy steering files
cp kiro-skills-library/steering/workflow-principles.md ~/.kiro/steering/
```

## Usage with Kiro CLI

Skills activate automatically when their trigger conditions are met. For example:

- Start any creative work → `brainstorming` activates
- Hit a bug → `systematic-debugging` activates
- About to create a PR → `code-review` activates
- Claim work is done → `verification-before-completion` activates

The steering files shape every interaction — workflow tiers match ceremony to change size, and hard rules prevent common mistakes.

## Context

These skills were developed over 2+ months of daily production use across:
- Building an LLM-powered document validation engine (4,200+ tests, Python, AWS Bedrock)
- Managing multi-account AWS infrastructure via Terraform + Digger CI
- Automating production log triage with OpenSearch + Jira integration
- Onboarding 14 engineers to Kiro with overwhelmingly positive adoption

## Contributing

Issues and PRs welcome. If you've built skills that complement these workflows, I'd love to see them.

## License

MIT
