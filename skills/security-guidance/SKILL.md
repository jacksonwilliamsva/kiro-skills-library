---
name: security-guidance
description: Security pattern awareness for code edits. Use when writing or reviewing code that touches security-sensitive patterns — shell commands, eval, innerHTML, GitHub Actions workflows, deserialization, or user-controlled input. Automatically checks for common vulnerability patterns and suggests safer alternatives.
---

When writing or reviewing code, check for these security patterns and apply the corresponding guidance. Flag issues inline as you encounter them — do not wait until the end.

## Security Patterns

### GitHub Actions Workflows

When editing `.github/workflows/*.yml` or `*.yaml`:

- **Command injection**: Never use untrusted input directly in `run:` commands
- Use environment variables instead of inline expressions:
  ```yaml
  # UNSAFE
  run: echo "${{ github.event.issue.title }}"

  # SAFE
  env:
    TITLE: ${{ github.event.issue.title }}
  run: echo "$TITLE"
  ```
- Risky inputs: `github.event.issue.body`, `github.event.pull_request.title`, `github.event.pull_request.body`, `github.event.comment.body`, `github.event.review.body`, `github.event.commits.*.message`, `github.event.head_commit.message`, `github.head_ref`

### Shell Command Injection

When code uses `child_process.exec`, `exec()`, `execSync()`, `os.system`, or `subprocess.call(shell=True)`:

- Prefer `execFile` / `subprocess.run([...])` with argument arrays over shell string interpolation
- Never interpolate user input into shell strings
- If shell features are truly needed, validate and escape all inputs

### Code Evaluation

When code uses `eval()`, `new Function()`, or equivalent:

- `eval()` executes arbitrary code — use `JSON.parse()` for data parsing
- `new Function()` with dynamic strings enables code injection
- Only use these if you truly need dynamic code evaluation and input is guaranteed safe

### XSS Vectors

When code uses `dangerouslySetInnerHTML`, `.innerHTML =`, or `document.write()`:

- `dangerouslySetInnerHTML`: sanitize with DOMPurify or equivalent before rendering
- `.innerHTML`: use `textContent` for plain text, or sanitize HTML content
- `document.write()`: use `createElement()` / `appendChild()` instead

### Deserialization

When code uses `pickle`, `yaml.load()` (without SafeLoader), or `Marshal.load`:

- `pickle` with untrusted data enables arbitrary code execution — use JSON or safe serialization
- Use `yaml.safe_load()` instead of `yaml.load()`
- Only use unsafe deserialization when the source is fully trusted

## Behaviour

- When you encounter any of these patterns while writing or editing code, pause and note the security concern inline
- Suggest the safer alternative
- If the unsafe pattern is genuinely needed, add a comment explaining why it's safe in this context
- Do not block work — flag, suggest, and move on

## Anti-Rationalization Table

When you hear (or think) any of these, push back:

| Rationalization | Reality |
|---|---|
| "It's an internal tool" | Internal tools get compromised. Attackers move laterally. |
| "We'll add security later" | Security debt compounds. Retrofitting auth is 10x harder than building it in. |
| "The input is trusted" | All input is untrusted until validated. Trust boundaries shift. |
| "It's behind a VPN" | VPNs get breached. Defense in depth means every layer validates. |
| "Nobody would exploit this" | Automated scanners don't care about your threat model. Secure by default. |
| "The framework handles it" | Frameworks provide tools, not guarantees. Verify the framework's security is configured correctly. |
