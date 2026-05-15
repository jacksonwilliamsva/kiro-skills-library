---
name: ci-cd-and-automation
description: Use when setting up or modifying CI/CD pipelines, adding quality gates, configuring deployment strategies, or debugging CI failures — any work that touches automated build, test, or deploy workflows
---

# CI/CD and Automation

## Core Principles

**Shift Left:** Lint before tests, tests before staging, staging before production. A bug caught in linting costs minutes; in production, hours.

**No Gate Skipping:** Lint fails → fix lint, not disable the rule. Test fails → fix the code, not skip the test.

**Faster is Safer:** Smaller batches reduce risk. 3 changes are easier to debug than 30.

## The Quality Gate Pipeline

Every change passes these gates before merge:

```
PR Opened → Lint → Type Check → Unit Tests → Build → Integration Tests → E2E (optional) → Security Audit → Ready for Review
```

## Key Patterns

**GitHub Actions (primary):** Use `actions/checkout@v4`, `actions/setup-node@v4` with `cache` option. Run `npm ci` (not `npm install`). Split lint/typecheck/test/build into parallel jobs when pipeline exceeds 10 minutes.

**Terraform:** NEVER run `terraform apply` from the shell. All applies go through Digger CI. This is non-negotiable — plan locally, apply via CI only.

**CI security:** Defer to the `security-guidance` skill for workflow security patterns (secret injection, `pull_request_target` risks, pinned action versions). Store secrets in GitHub Secrets or a vault — never in code or CI config.

**Environment secrets:** `.env.example` committed (template), `.env` NOT committed, CI secrets in GitHub Secrets/vault, production secrets in deployment platform/vault.

## Deployment Strategy

1. **Preview deploys** on every PR for manual verification
2. **Staged rollouts:** PR → staging (auto) → production (manual trigger)
3. **Rollback plan:** every deployment must be reversible
4. **Feature flags:** ship behind flags, enable when ready, set cleanup dates

## CI Optimization (when pipeline > 10 min)

1. Cache dependencies
2. Parallelize jobs (lint, typecheck, test, build)
3. Path filters — skip unrelated jobs (e.g., skip E2E for docs-only PRs)
4. Shard test suites with matrix builds
5. Move slow tests to scheduled runs

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "CI is too slow" | Optimize the pipeline, don't skip it. 5 min prevents hours of debugging. |
| "This change is trivial, skip CI" | Trivial changes break builds. CI is fast for trivial changes anyway. |
| "The test is flaky, just re-run" | Flaky tests mask real bugs. Fix the flakiness. |
| "We'll add CI later" | Projects without CI accumulate broken states. Set it up on day one. |
| "Manual testing is enough" | Manual testing doesn't scale and isn't repeatable. |

## Verification Checklist

- [ ] All quality gates present (lint, types, tests, build, audit)
- [ ] Pipeline runs on every PR and push to main
- [ ] Failures block merge (branch protection configured)
- [ ] Secrets in secrets manager, not in code
- [ ] Deployment has a rollback mechanism
- [ ] Pipeline runs under 10 minutes
- [ ] Terraform applies go through Digger CI, not shell
