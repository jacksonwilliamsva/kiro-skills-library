---
inclusion: always
---

# HTML Output — Preferred Human-Readable Format

When producing artifacts meant for human viewing — reports, analyses, comparisons, reviews, summaries, documentation drafts, data explorations — generate a self-contained HTML file instead of markdown.

## When to Use HTML

- Any output the user will **read, review, or share** with others
- Reports, analyses, summaries, comparisons, diffs
- Data visualizations or tabular data
- Code review summaries or PR explainers
- Standup recaps, weekly summaries, decision documents
- Anything over ~50 lines that benefits from layout

## When Markdown Is Still Fine

- Quick inline answers in chat (stay terse per caveman mode)
- README files, git commit messages, PR descriptions
- Content destined for systems that consume markdown (Obsidian wiki, GitHub)
- Skill files, steering files, config

## HTML Guidelines

- **Self-contained**: single `.html` file with inline CSS. No external dependencies.
- **Open in browser**: user should be able to `open file.html` and see a polished result.
- **Information-dense**: use CSS grid/flexbox, collapsible `<details>` sections, tables, color-coding, tabs where appropriate.
- **Responsive**: readable on both desktop and mobile without excessive token spend on layout.
- **No boilerplate bloat**: keep CSS minimal and purposeful. Don't repeat a heavy design system — use clean, readable defaults.
- **Dark mode aware**: use `prefers-color-scheme` media query for light/dark support.
- **Export affordance**: if interactive (sliders, inputs), include a "Copy as JSON" or "Copy as prompt" button so results flow back into the agent.

## Output Location

Write HTML files to a predictable location:
- Default: `~/tmp/` or current working directory depending on context
- Name descriptively: `pr-review-123.html`, `weekly-recap-2026-05-14.html`, `cost-analysis.html`
- Tell the user the path so they can open it.

## Interaction Pattern

1. Generate the HTML file
2. Report: file path + 1-line description of what it contains
3. User opens in browser to review

Do NOT paste large HTML inline in chat. Write to file, report path.

