---
name: systematic-debugging
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes. Symptom fixes are failure.

## When to Use

Use for ANY technical issue: test failures, bugs, unexpected behavior, performance problems, build failures, integration issues.

**Use ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes without success
- You don't fully understand the issue

**Don't skip when:**
- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- Manager wants it fixed NOW (systematic is faster than thrashing)

## The Five Phases

Complete each phase before proceeding to the next.

### Phase 0: Build a Feedback Loop

Before investigating ANYTHING, build a fast, deterministic reproduction loop.

**Priority order:**
1. Existing test that fails
2. New test you write
3. Standalone script
4. REPL session
5. HITL (human-in-the-loop) bash script — see [`hitl-loop.template.sh`](./hitl-loop.template.sh)

**Treat the loop as a product:**
- Can I make it faster? Sharper signal? More deterministic?
- A 30-second flaky loop is barely better than no loop. A 2-second deterministic loop is a debugging superpower.

**Hard gate:** Do NOT proceed to Phase 1 until you have a loop you believe in.

**If you genuinely cannot build a loop:** Stop and say so. List what you tried. Ask the user for: (a) access to the reproducing environment, (b) a captured artifact (HAR file, log dump, core dump, screen recording), or (c) permission to add temporary instrumentation.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely — they often contain the exact solution
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably? What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits, new dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   Add diagnostic instrumentation BEFORE proposing fixes:
   ```
   For EACH component boundary:
     - Log what data enters/exits the component
     - Verify environment/config propagation
     - Check state at each layer

   Run once → analyze evidence → identify failing component → investigate that component
   ```

   **Example (multi-layer system):**
   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing
   security find-identity -v

   # Layer 4: Actual operation
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **Reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

   **Tag every debug log** with a unique prefix, e.g. `[DEBUG-a4f2]`. Cleanup becomes a single grep. Untagged logs survive; tagged logs die.

5. **Trace Data Flow**

   See `root-cause-tracing.md` for the complete backward tracing technique.

   Quick version: Where does the bad value originate? Trace callers upward until you find the source. Fix at source, not at symptom.

### Phase 2: Pattern Analysis

1. **Find Working Examples** — Locate similar working code in the same codebase
2. **Compare Against References** — Read reference implementations COMPLETELY, don't skim. Understand the pattern fully before applying.
3. **Identify Differences** — List every difference between working and broken, however small. Don't assume "that can't matter."
4. **Understand Dependencies** — What components, settings, config, environment, assumptions does this need?

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Research more or ask for help

### Phase 4: Implementation

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible, one-off script if no framework
   - MUST have before fixing
   - Use `superpowers:test-driven-development` for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements or bundled refactoring

3. **Verify Fix**
   - Test passes now? No other tests broken? Issue actually resolved?

4. **Post-mortem: What would have prevented this?**
   - State the correct hypothesis in the commit/PR message so the next debugger learns
   - Remove all `[DEBUG-...]` instrumentation (grep the tag prefix — designed for easy cleanup)
   - Ask: what would have prevented this bug? If the answer involves architectural change, note it but don't act on it now

5. **If Fix Doesn't Work**
   - If < 3 attempts: Return to Phase 1, re-analyze with new information
   - **If ≥ 3 attempts: STOP and question the architecture (step 6)**
   - DON'T attempt Fix #4 without architectural discussion

6. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling in a different place
   - Fixes require massive refactoring to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we persisting through sheer inertia?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes.** This is a wrong architecture, not a failed hypothesis.

## Red Flags — STOP and Return to Phase 1

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

## Human Partner Signals You're Doing It Wrong

- "Is that not happening?" — You assumed without verifying
- "Will it show us...?" — You should have added evidence gathering
- "Stop guessing" — You're proposing fixes without understanding
- "Ultrathink this" — Question fundamentals, not just symptoms

**When you see these:** STOP. Return to Phase 1.

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |
| "I think I know what's wrong" | Thinking is not evidence. Reproduce it first. |
| "The error message tells me exactly what's wrong" | Error messages describe symptoms, not root causes. |
| "I'll add logging everywhere" | Targeted logging from a hypothesis beats shotgun logging. |
| "It works on my machine" | Environment differences ARE the bug. Reproduce in the failing environment. |
| "It's probably a flaky test" | Flaky tests mask real bugs. Prove it's flaky before dismissing. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **0. Feedback Loop** | Build fast repro loop | Deterministic, fast reproduction |
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify, post-mortem | Bug resolved, tests pass |

## When Process Reveals "No Root Cause"

If investigation reveals the issue is truly environmental, timing-dependent, or external:

1. Document what you investigated
2. Implement appropriate handling (retry, timeout, error message)
3. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Supporting Techniques

Available in this directory:
- **`root-cause-tracing.md`** — Trace bugs backward through call stack to find original trigger
- **`defense-in-depth.md`** — Add validation at multiple layers after finding root cause
- **`condition-based-waiting.md`** — Replace arbitrary timeouts with condition polling

**Related skills:**
- **superpowers:test-driven-development** — Creating failing test case (Phase 4)
- **superpowers:verification-before-completion** — Verify fix before claiming success
