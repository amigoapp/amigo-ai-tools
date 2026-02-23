---
name: pr-review
description: Reviews a GitHub Pull Request for security and code quality issues. Use when the user provides a PR number or URL and wants a code review, quality check, or security audit of a pull request.
disable-model-invocation: true
---

## Workflow

### Step 1 — Get PR Details

Extract the repository owner, repo name, and PR number from the user's input (URL or plain number with repo context). If ambiguous, ask before proceeding.

Use GitHub MCP tools to fetch the PR information.

### Step 2 — Check Complexity

Count the changed files. If **more than 60 files** or an extremely large diff, output this and stop:

```
## Review Summary
- Skill: pr-review
- Target: PR #<number>
- Verdict: MANUAL REVIEW REQUIRED
- Reason: This PR exceeds the complexity threshold (>10 changed files or extremely large diff).
```

### Step 3 — Detect Stack

Examine the changed files list and diff:

- `pyproject.toml`, `requirements.txt`, or `.py` files → **Python**
- `nest-cli.json` or `@nestjs/` in `package.json` → **NestJS**
- `package.json` with `"express"` → **Node.js+Express**
- Otherwise → **Unknown**

### Step 4 — Run Review

Read [security-rules.md](references/security-rules.md) and [review-criteria.md](references/review-criteria.md) and apply all rules to the PR diff.

### Step 5 — Output Report

Read [review-output-format.md](references/review-output-format.md) and produce the structured report. Be concise.

## References

- **[references/security-rules.md](references/security-rules.md)** — OWASP Top 10 and common vulnerability patterns; read during Step 4
- **[references/review-criteria.md](references/review-criteria.md)** — Code quality rules for error handling, naming, structure; read during Step 4
- **[references/review-output-format.md](references/review-output-format.md)** — Report structure, scoring (0–10), hard overrides, conciseness rules; read during Step 5
