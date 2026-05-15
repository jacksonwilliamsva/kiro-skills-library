---
name: code-review
description: Automated code review for pull requests using parallel analysis with confidence-based scoring to filter false positives. Use when the user asks to review a PR, review code changes, or run a code review.
---

Perform automated code review on a pull request using multiple independent review passes with confidence scoring.

## Workflow

Follow these steps precisely:

### 1. Pre-flight Check

Check if review should be skipped:
- PR is closed or draft
- PR is trivial (e.g. automated, single-line typo fix that is obviously correct)
- Already reviewed by you (check `gh pr view <PR> --comments`)

If any condition is true, stop. Still review AI-generated PRs.

### 2. Gather Context

- Collect all steering files (`.kiro/steering/`, `CLAUDE.md`, `AGENTS.md`) from the repo root and from directories containing modified files
- Get the PR title, description, and diff via `gh pr view` and `gh pr diff`
- Summarize the changes

### 3. Parallel Review (4 passes)

Run these independently. Each pass returns a list of issues with description and category:

**Pass 1 & 2 — Steering/guideline compliance:**
Audit changes against project steering files and coding guidelines. Only consider guidelines scoped to the modified files' directories.

**Pass 3 — Bug scan (diff only):**
Scan for obvious bugs in the diff without reading extra context. Flag only significant bugs. Do not flag issues you cannot validate from the diff alone.

**Pass 4 — Introduced defects:**
Look for security issues, incorrect logic, and defects in the new code only.

**CRITICAL: HIGH SIGNAL ONLY.** Flag issues where:
- Code will fail to compile or parse (syntax errors, type errors, missing imports)
- Code will definitely produce wrong results regardless of inputs
- Clear, unambiguous guideline violations where you can quote the exact rule

Do NOT flag:
- Code style or quality concerns
- Potential issues that depend on specific inputs or state
- Subjective suggestions or improvements
- Issues a linter would catch
- Pre-existing issues not introduced in this PR

### 4. Validate

For each issue from passes 3 and 4, verify it is real:
- Check the actual code to confirm the issue exists
- For guideline violations, verify the rule is scoped to the file and actually violated
- Discard anything you cannot confirm with high confidence

### 5. Score

Score each validated issue 0–100:
- **0**: Not confident, likely false positive
- **25**: Somewhat confident
- **50**: Moderately confident, real but minor
- **75**: Highly confident, real and important
- **100**: Certain

Discard issues below **80**.

### 6. Output

Print a summary to the terminal:
- If issues found: list each with brief description and link to the code
- If none: "No issues found. Checked for bugs and project guideline compliance."

If `--comment` was requested, post results as a PR comment via `gh pr comment`. For individual issues, post inline comments linking to the exact code with full SHA and line ranges.

**Format code links as:**
`https://github.com/OWNER/REPO/blob/FULL_SHA/path/to/file.ext#L10-L15`

### False Positive Checklist

Never flag:
- Pre-existing issues not introduced in the PR
- Code that looks wrong but is actually correct
- Pedantic nitpicks a senior engineer would ignore
- General quality concerns unless explicitly required by project guidelines
- Issues silenced by lint-ignore comments

## Anti-Rationalization Table

Before skipping or rushing a review, check your excuse against reality:

| Rationalization | Reality |
|---|---|
| "It's a small change" | Small changes cause production outages. The 8192 token limit bug was a 'small change'. |
| "I wrote it, I know it's correct" | Authors have blind spots. Review catches what familiarity hides. |
| "We're in a hurry" | Shipping a bug is slower than reviewing for 15 minutes. |
| "The tests pass" | Tests verify expected behavior. Review catches unexpected behavior, security holes, and design issues. |
| "It's just config/docs" | Config errors cause outages. Doc errors cause confusion. Review everything. |
