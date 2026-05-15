---
name: code-simplification
description: Use when refactoring code for clarity without changing behavior, when code works but is harder to read or maintain than it should be, or when reviewing code that has accumulated unnecessary complexity
---

# Code Simplification

Reduce complexity while preserving exact behavior. Not fewer lines — code a new team member understands faster.

## Five Principles

### 1. Preserve Behavior Exactly
Don't change what code does — only how it's expressed. Inputs, outputs, side effects, error behavior, and edge cases must remain identical. If unsure, don't make the change.

### 2. Follow Project Conventions
Simplification means consistency with the codebase, not imposing preferences. Study neighboring code for naming, error handling, and idioms. Simplification that breaks project consistency is churn.

### 3. Prefer Clarity Over Cleverness
Explicit beats compact when the compact version requires a mental pause. Early returns over deep nesting. Named functions over inline lambdas. Readable mappings over chained ternaries.

### 4. Chesterton's Fence
Before changing or removing anything, understand why it exists. Check git blame. If you can't explain the original reason, you're not ready to simplify.

### 5. Scope to What Changed
Default to simplifying recently modified code. Avoid drive-by refactors of unrelated code unless explicitly asked. Unscoped simplification creates noisy diffs and risks regressions.

## Simplification Workflow

1. **Understand first** — What does it do? What calls it? What are the edge cases? Why was it written this way?
2. **Identify opportunities** — Deep nesting, long functions, generic names, duplicated logic, dead code, over-engineered patterns
3. **Apply incrementally** — One simplification at a time. Run tests after each. Separate refactoring commits from feature/bugfix commits.
4. **Verify** — Use the verification-before-completion skill. All existing tests must pass without modification. Build succeeds. Linter passes. Diff is clean.

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "It's working, no need to touch it" | Hard-to-read code is hard to fix when it breaks |
| "Fewer lines is always simpler" | A 1-line nested ternary is not simpler than a 5-line if/else |
| "I'll simplify this unrelated code too" | Unscoped simplification creates noisy diffs and risks regressions |
| "This abstraction might be useful later" | Speculative abstractions are complexity without value — remove and re-add when needed |
| "The original author must have had a reason" | Apply Chesterton's Fence — but accumulated complexity often has no reason |
| "I'll refactor while adding this feature" | Separate refactoring from feature work. Mixed changes are harder to review and revert |

## Red Flags — STOP If You See

- Simplification that requires modifying tests to pass (you changed behavior)
- "Simplified" code that is longer or harder to follow than the original
- Renaming to match your preferences rather than project conventions
- Removing error handling because "it makes the code cleaner"
- Simplifying code you don't fully understand
- Batching many simplifications into one large commit
- Refactoring code outside the current task's scope without being asked
