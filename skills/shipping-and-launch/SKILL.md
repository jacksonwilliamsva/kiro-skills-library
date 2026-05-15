---
name: shipping-and-launch
description: Use when preparing to deploy to production, when you need a pre-launch checklist, when setting up monitoring, when planning a staged rollout, or when you need a rollback strategy
---

# Shipping and Launch

Every launch must be reversible, observable, incremental.

For git/PR workflow, use **finishing-a-development-branch**. This skill covers what happens after code is ready.

## Pre-Launch Checklist

**Code Quality:** Tests pass · build clean · lint/types pass · code reviewed · no unresolved TODOs · error handling complete

**Security:** No secrets in VCS · dependency audit clean · input validation · auth/authz in place · rate limiting · CORS not wildcarded

**Performance:** No N+1 queries · images optimized · bundle in budget · DB indexed · caching configured

**Accessibility:** Keyboard nav · screen reader compatible · WCAG AA contrast · focus management for dynamic content

**Infrastructure:** Env vars set · migrations ready · SSL/DNS configured · logging configured · health check exists

**Documentation:** README updated · API docs current · ADRs written · changelog updated

## Feature Flag Strategy

Decouple deployment from release:

1. **DEPLOY** flag OFF — code in prod, inactive
2. **ENABLE** for team — internal testing in prod
3. **GRADUAL ROLLOUT** — 5% → 25% → 50% → 100%
4. **MONITOR** each stage — errors, performance, feedback
5. **CLEAN UP** — remove flag within 2 weeks of full rollout

Rules: every flag has owner and expiration. Don't nest flags. Test both states in CI.

## Rollout Decision Thresholds

| Metric | Advance | Hold | Roll back |
|--------|---------|------|-----------|
| Error rate | Within 10% baseline | 10–100% above | >2× baseline |
| P95 latency | Within 20% baseline | 20–50% above | >50% above |
| Client JS errors | No new types | New <0.1% sessions | New >0.1% |
| Business metrics | Neutral/positive | Decline <5% | Decline >5% |

## Rollback Plan

Document before deploy:

- **Triggers** — error rate >2× baseline, latency >50%, user reports spike, data/security issues
- **Steps** — disable flag (<1 min) OR redeploy previous (<5 min) OR DB rollback (<15 min)
- **Verify** — health check, error monitoring, notify team

## Post-Deploy Monitoring

Verify in first hour:

1. Health endpoint returns 200
2. No new error types
3. No latency regression
4. Critical user flow works
5. Logs flowing
6. Rollback verified

## Anti-Rationalizations

| Rationalization | Reality |
|---|---|
| "It works in staging" | Production has different data and traffic patterns. |
| "Don't need feature flags" | Every feature benefits from a kill switch. |
| "We'll add monitoring later" | Can't debug what you can't see. |
| "Rolling back is failure" | Shipping broken is the failure. |
| "It's Friday afternoon, let's ship it" | No. |

## Red Flags

- Deploying without a rollback plan
- No monitoring in production
- Big-bang releases with no staging
- Feature flags with no expiration or owner
- No one watching the deploy for the first hour
