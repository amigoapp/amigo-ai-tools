---
name: base-code-review
description: Audits an existing codebase for security vulnerabilities and code quality issues. Use when the user wants to find pre-existing problems, says "audit the codebase", "review the code", or "security audit" without referencing a PR or branch.
allowed-tools: Read Bash(find:*) Bash(grep:*)
disable-model-invocation: true
---

## Workflow

### Step 1 — Define Scope

Use the path provided by the user. Default to `src/` if it exists, otherwise the project root. Ask if still ambiguous.

### Step 2 — Detect Stack

Check the target directory for:

- `pyproject.toml` or `requirements.txt` → **Python**
- `nest-cli.json` or `@nestjs/` in `package.json` → **NestJS**
- `package.json` with `"express"` → **Node.js+Express**
- Otherwise → **Unknown**

### Step 3 — Sample Files

Do **not** read all files. Use this strategy:

1. **Entry point**: `main.ts`, `app.ts`, `index.js`, `app.py`, or `main.py`
2. **2–3 files per category** (pick the most relevant):
   - Controllers or route handlers
   - Services or business logic
   - Models or schemas
   - Utilities or helpers
3. **Prioritize** files that handle auth, external input, or DB queries — highest risk

Use `find` to list candidates, then `Read` to load selected files.

### Step 4 — Run Review

Read [security-rules.md](references/security-rules.md) and [review-criteria.md](references/review-criteria.md) and apply all rules to the sampled files.

### Step 5 — Output Report

Read [review-output-format.md](references/review-output-format.md) and produce the structured report. Group findings by file, then by severity within each file. Include the sampled scope note:

```
- Scope: Sampled audit (not exhaustive) — N files reviewed
```

## References

- **[references/security-rules.md](references/security-rules.md)** — OWASP Top 10 and common vulnerability patterns; read during Step 4
- **[references/review-criteria.md](references/review-criteria.md)** — Code quality rules for error handling, naming, structure; read during Step 4
- **[references/review-output-format.md](references/review-output-format.md)** — Report structure, scoring (0–10), hard overrides, conciseness rules; read during Step 5
