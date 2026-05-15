---
inclusion: always
---

# context-mode — MCP Routing Rules

Protects context window from flooding. A single unrouted command can dump 56 KB into context.

## BLOCKED — never use shell for these

**HTTP/fetch (curl, wget, fetch(), requests.*, http.get/request):** Use `ctx_fetch_and_index(url)` or `ctx_execute(language, code)` sandbox instead. Shell attempts will be intercepted.

## Routing rules

| Scenario | DON'T | DO |
|----------|-------|----|
| Shell output >20 lines | `shell` | `ctx_batch_execute` or `ctx_execute(shell, ...)` |
| Read file for analysis | `read` | `ctx_execute_file(path, lang, code)` |
| Large grep/search | `grep` | `ctx_execute(shell, "grep ...")` |
| Read file for editing | — | `read` is correct |

## Tool hierarchy

1. **GATHER**: `ctx_batch_execute(commands, queries)` — runs commands + searches in ONE call
2. **FOLLOW-UP**: `ctx_search(queries: [...])` — query indexed content
3. **PROCESSING**: `ctx_execute` / `ctx_execute_file` — sandbox, only stdout enters context
4. **WEB**: `ctx_fetch_and_index(url)` → `ctx_search(queries)`
5. **INDEX**: `ctx_index(content, source)` — store for later search

## Output constraints

- Responses under 500 words.
- Write artifacts to FILES, not inline. Return: path + 1-line description.
- Use descriptive source labels when indexing.

## Why This Matters

Without these rules, a single `git log` or `terraform plan` can consume 30%+ of your context window in one call. The routing ensures only summaries and relevant extracts enter context, while full data stays in the sandbox for programmatic access.
