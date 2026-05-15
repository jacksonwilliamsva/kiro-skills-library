---
name: source-driven-development
description: Use when writing framework-specific code, building boilerplate, or implementing patterns where correctness depends on a specific library version — grounds every decision in official documentation, not training data
---

# Source-Driven Development

Every framework-specific decision must be backed by official documentation. Training data goes stale, APIs get deprecated. Verify, cite, show sources.

**Skip when:** pure logic, version-independent changes, or user wants speed over verification.

## Process: DETECT → FETCH → IMPLEMENT → CITE

### 1. Detect Stack and Versions

Read the dependency file (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, etc.). State what you found:

```
STACK: React 19.1.0, Vite 6.2.0 (from package.json)
→ Fetching official docs for relevant patterns.
```

If versions are ambiguous, **ask** — the version determines correct patterns.

### 2. Fetch Official Documentation

**Primary — Context7 MCP tools:**
1. `resolve-library-id` — resolve library name to Context7 ID
2. `query-docs` — fetch specific docs for the pattern needed

**Fallback:** `ctx_fetch_and_index(url, source)` + `ctx_search(queries)` for docs not in Context7.

| Priority | Source |
|----------|--------|
| 1 | Official docs (Context7 or direct fetch) |
| 2 | Official blog / changelog |
| 3 | Web standards (MDN, web.dev) |
| 4 | Compatibility tables (caniuse.com) |

**Never cite as primary:** Stack Overflow, blog posts, tutorials, training data.

### 3. Implement from Docs

- Use API signatures from docs, not memory
- Use modern patterns; skip deprecated APIs
- Flag anything unverified
- **When docs conflict with project code**, surface the conflict — don't silently pick one

### 4. Cite Sources

```typescript
// React 19 form handling — Source: https://react.dev/reference/react/useActionState#usage
const [state, formAction, isPending] = useActionState(submitOrder, initialState);
```

- Full URLs with anchors
- Quote passages for non-obvious decisions
- No docs found? Say so: `UNVERIFIED: No official documentation found.`

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "I'm confident about this API" | Confidence is not evidence. Verify. |
| "Fetching docs wastes tokens" | Hallucinating an API wastes more — one fetch prevents hours of rework. |
| "The docs won't have what I need" | If docs don't cover it, the pattern may not be recommended. |
| "I'll just mention it might be outdated" | A disclaimer doesn't help. Verify and cite, or flag as unverified. |
| "This is a simple task" | Simple tasks with wrong patterns become templates copied everywhere. |

## Red Flags

- Writing framework code without checking docs for that version
- Using "I believe" or "I think" about an API instead of citing
- Implementing a pattern without knowing which version it applies to
- Citing blog posts instead of official documentation
- Not reading dependency files before implementing
- Delivering code without source citations
