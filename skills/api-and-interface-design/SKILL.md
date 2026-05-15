---
name: api-and-interface-design
description: Use when designing or modifying any public interface — REST APIs, GraphQL schemas, module boundaries, Terraform provider schemas, CLI commands, or component contracts
---

# API and Interface Design

Design stable interfaces that are hard to misuse. Applies to REST, GraphQL, module exports, Terraform providers, and CLIs.

## Core Principles

### Hyrum's Law

> With sufficient users, all observable behaviors become depended on — regardless of your contract.

Don't leak implementation details. Plan deprecation at design time (see `deprecation-and-migration`).

### Contract First

Define the interface before implementing. Types, schemas, HCL attributes, CLI flags — the contract is the spec. Implementation follows.

### Consistent Error Semantics

Pick one error strategy. Use it everywhere across the same surface.

| Surface | Strategy |
|---------|----------|
| REST | HTTP status codes + `{ error: { code, message } }` |
| GraphQL | `errors[]` with extensions |
| Module | Typed error/result types or consistent exceptions |
| Terraform | `diag.Diagnostics` with summary + detail |
| CLI | stderr for errors, stdout for data, exit codes |

### One-Version Rule

Don't force consumers to choose between versions. Diamond dependencies arise when different consumers need different versions. Extend rather than fork.

## Design Rules

1. **Validate at boundaries** — API handlers, CLI arg parsing, provider schema, third-party responses. Trust internal code.
2. **Prefer addition over modification** — new optional fields/subcommands/attributes. Never change types or remove fields.
3. **Predictable naming** — plural nouns for REST resources, no verbs in URLs, consistent casing, `is/has/can` for booleans.
4. **Paginate from day one** — every list endpoint/query.
5. **Separate input from output** — what callers provide vs what the system returns.

## Anti-Rationalization Table

| Rationalization | Reality |
|---|---|
| "We'll document it later" | Types/schemas ARE the documentation. Define first. |
| "Don't need pagination yet" | You will at 100+ items. Add from the start. |
| "Nobody uses that behavior" | Hyrum's Law: if observable, someone depends on it. |
| "We can maintain two versions" | Multiple versions multiply cost. One-Version Rule. |
| "Internal APIs don't need contracts" | Internal consumers are still consumers. |
| "We'll version when we need to" | Breaking changes without versioning break consumers. |

## Red Flags — STOP and Redesign

- Different response shapes depending on conditions
- Inconsistent error formats across the same surface
- Validation scattered in internal code instead of boundaries
- Breaking changes to existing fields
- List operations without pagination
- Verbs in REST URLs (`/api/createTask`)
- Third-party responses used without validation
- CLI mixing data and status messages on stdout

## Verification

- [ ] Every operation has typed/documented input and output
- [ ] Errors follow a single consistent format
- [ ] Validation at boundaries only
- [ ] Lists paginated
- [ ] Changes are additive and backward-compatible
- [ ] Naming consistent across all operations
- [ ] Deprecation path exists for removals (see `deprecation-and-migration`)
