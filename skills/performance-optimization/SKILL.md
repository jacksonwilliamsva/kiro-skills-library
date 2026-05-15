---
name: performance-optimization
description: Use when performance requirements exist, users report slowness, metrics breach SLAs, Core Web Vitals need improvement, or you suspect a change introduced a regression
---

# Performance Optimization

## Overview

Measure before optimizing. Performance work without measurement is guessing. Profile first, identify the actual bottleneck, fix it, measure again.

## The Workflow

```
MEASURE  → Establish baseline with real numbers
IDENTIFY → Find the actual bottleneck (use systematic-debugging skill)
FIX      → Address the specific bottleneck
VERIFY   → Measure again, confirm improvement with numbers
GUARD    → Add monitoring/tests/budgets to prevent regression
```

### Measure

Pick the right tool for the layer:

| Layer | Tools |
|-------|-------|
| **Frontend** | Lighthouse, DevTools Performance, web-vitals (RUM), CrUX |
| **Backend** | APM traces, query logs with timing, `time` commands, p95/p99 latency |
| **Infra** | CPU/memory/disk metrics, connection pool stats, GC logs |

### Identify

Use the **systematic-debugging** skill for investigation. Start from the symptom:

- **Slow page load** → bundle size? TTFB? render-blocking resources?
- **Sluggish interaction** → long main-thread tasks? excessive re-renders?
- **Slow API** → N+1 queries? missing indexes? no caching?
- **Intermittent slowness** → lock contention? GC pauses? external deps?

### Fix

Address the specific measured bottleneck. Common fixes:

- **N+1 queries** → batch/join/include
- **Unbounded fetches** → pagination with limits
- **Large bundles** → code splitting, lazy loading
- **Missing caching** → HTTP cache headers, application-level TTL cache
- **Images** → dimensions, lazy loading, responsive sizes, modern formats
- **CPU-bound work** → offload to worker/background job

### Verify

Before/after numbers are mandatory. No "it feels faster."

### Guard

- Performance budgets in CI (bundle size, Lighthouse score, response time)
- Alerting on p95 latency, error rate, Core Web Vitals
- Load tests for critical paths

## Core Web Vitals Targets

| Metric | Good | Poor |
|--------|------|------|
| LCP | ≤ 2.5s | > 4.0s |
| INP | ≤ 200ms | > 500ms |
| CLS | ≤ 0.1 | > 0.25 |

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We'll optimize later" | Performance debt compounds. Fix anti-patterns now. |
| "It's fast on my machine" | Profile on representative hardware and networks. |
| "This optimization is obvious" | If you didn't measure, you don't know. |
| "Users won't notice 100ms" | 100ms delays impact conversion rates. |
| "The framework handles it" | Frameworks can't fix N+1 queries or oversized bundles. |

## Red Flags

- Optimization without profiling data to justify it
- N+1 query patterns in data fetching
- List endpoints without pagination
- Images without dimensions or lazy loading
- Bundle size growing without review
- No performance monitoring in production
- Memoization everywhere (overuse is as bad as underuse)

## Verification Checklist

- [ ] Before/after measurements exist (specific numbers)
- [ ] Specific bottleneck identified and addressed
- [ ] Performance budgets pass
- [ ] Existing tests still pass
