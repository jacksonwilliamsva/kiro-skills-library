---
name: deprecation-and-migration
description: Use when removing old systems, APIs, Terraform modules, or libraries. Use when migrating consumers from one implementation to another. Use when deciding whether to maintain or sunset existing code. Use when planning the lifecycle of new systems.
---

# Deprecation and Migration

## Core Principles

**Code Is a Liability.** Every line has ongoing cost — tests, docs, security patches, dependency updates, onboarding. Value is the functionality, not the code. When less complexity delivers the same result, the old code should go.

**Hyrum's Law Makes Removal Hard.** With enough consumers, every observable behavior becomes depended on — including bugs and undocumented side effects. Deprecation requires active migration, not just announcement.

**Deprecation Planning Starts at Design Time.** Ask: "How would we remove this in 3 years?" Clean interfaces, feature flags, and minimal surface area make future deprecation possible.

## Deprecation Decision Framework

Before deprecating, answer in order:

1. **Still provides unique value?** → Maintain it.
2. **How many consumers?** → Quantify migration scope.
3. **Replacement exists?** → If no, build one first. Never deprecate without an alternative.
4. **Migration cost per consumer?** → If automatable, do it. If manual, weigh against maintenance cost.
5. **Cost of NOT deprecating?** → Security risk, engineer time, opportunity cost.

## Compulsory vs Advisory Deprecation

| Type | When | Mechanism |
|------|------|-----------|
| **Advisory** | Old system stable, migration optional | Warnings, docs, nudges. Consumers migrate on own timeline. |
| **Compulsory** | Security issues, blocks progress, unsustainable maintenance | Hard deadline with migration tooling, docs, and support. |

**Default to advisory.** Compulsory requires providing migration tooling — you can't just announce a deadline.

## The Churn Rule

If you own the deprecated infrastructure, you migrate consumers — or provide backward-compatible updates requiring no migration.

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "It still works, why remove it?" | Unmaintained code accumulates security debt silently. |
| "Someone might need it later" | Rebuilding costs less than maintaining unused code. |
| "The migration is too expensive" | Compare to 2-3 years of ongoing maintenance cost. |
| "We'll deprecate after the new system" | You'll have new priorities by then. Plan now. |
| "Users will migrate on their own" | They won't. Provide tooling or do it yourself. |
| "We can maintain both indefinitely" | Two systems = double maintenance, testing, docs, and onboarding. |

## Red Flags

- Deprecated system with no replacement
- Deprecation announcement with no migration tooling
- Advisory deprecation stalled for years
- Zombie code: no owner, no commits 6+ months, active consumers, known vulns
- New features added to a deprecated system
- Removal without verifying zero active consumers

## Verification

- [ ] Replacement is production-proven and covers critical use cases
- [ ] Migration guide with concrete steps exists
- [ ] All consumers migrated (verified by metrics/logs/dependency analysis)
- [ ] Old code, tests, docs, config fully removed
- [ ] No references to deprecated system remain
