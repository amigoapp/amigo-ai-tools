---
name: branch-review
description: Reviews the current git branch changes against a base branch for security and code quality. Use when the user wants to review their local changes before opening a PR, or says "review my branch", "check my changes", or "diff review".
allowed-tools: Bash(git:*) Read
disable-model-invocation: true
---

## Workflow

### Step 1 — Determine Base Branch

Use the base branch provided by the user. Default to `main` if not specified. Ask once if ambiguous.

### Step 2 — Capture the Diff

Run all three to get the full review scope:

```bash
git diff <base>..<HEAD> --stat   # file count + summary
git diff <base>..<HEAD>          # committed changes
git diff --cached                # staged uncommitted changes
git diff                         # unstaged uncommitted changes
```

### Step 3 — Check Complexity

If **more than 60 changed files** or an extremely large diff, output this and stop:

```
## Review Summary
- Skill: branch-review
- Target: <current-branch> vs <base>
- Verdict: MANUAL REVIEW REQUIRED
- Reason: This diff exceeds the complexity threshold (>10 changed files or extremely large diff).
```

### Step 4 — Detect Stack

Examine the diff for stack indicators:

- `pyproject.toml`, `requirements.txt`, or `.py` files → **Python**
- `nest-cli.json` or `@nestjs/` in `package.json` → **NestJS**
- `package.json` with `"express"` → **Node.js+Express**
- Otherwise → **Unknown**

### Step 5 — Run Review

Read [security-rules.md](references/security-rules.md) and [review-criteria.md](references/review-criteria.md) and apply all rules to the combined diff.

### Step 6 — Output Report

Read [review-output-format.md](references/review-output-format.md) and produce the structured report. Be concise.

## References

- **[references/security-rules.md](references/security-rules.md)** — OWASP Top 10 and common vulnerability patterns; read during Step 5
- **[references/review-criteria.md](references/review-criteria.md)** — Code quality rules for error handling, naming, structure; read during Step 5
- **[references/review-output-format.md](references/review-output-format.md)** — Report structure, scoring (0–10), hard overrides, conciseness rules; read during Step 6
