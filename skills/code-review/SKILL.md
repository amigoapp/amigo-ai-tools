---
name: code-review
description: Reviews code for security vulnerabilities and quality issues. Use when the user says "review the code", "audit the codebase", "review my branch", "check my changes", "diff review", or provides a PR number/URL for review.
allowed-tools: Read Bash(find:*) Bash(grep:*) Bash(git:*)
disable-model-invocation: true
---

## Workflow

### Step 1 — Determine Review Mode

Based on user input, select ONE mode:

- **PR Mode**: User provided a PR number (`#123`) or GitHub PR URL → fetch via GitHub MCP tools
- **Branch Mode**: User said "review my branch", "my changes", "check my diff", or mentioned a branch name → use `git diff`
- **Codebase Mode**: No PR or branch reference → scan files on disk

If ambiguous, ask the user once.

---

#### PR Mode — Get PR Details

Extract repo owner, repo name, and PR number. If ambiguous, ask before proceeding.
Use GitHub MCP tools to fetch PR info and diff.

#### Branch Mode — Capture the Diff

Use the base branch provided by user, defaulting to `main`:

```bash
git diff <base>..<HEAD> --stat
git diff <base>..<HEAD>
git diff --cached
git diff
```

#### Codebase Mode — Define Scope

Use the path provided. Default to `src/` if it exists, otherwise project root.

---

### Step 2 — Check Complexity (skip for Codebase Mode)

If **more than 60 changed files** or an extremely large diff, stop and output:

```
## Review Summary
- Skill: code-review
- Target: <target>
- Verdict: MANUAL REVIEW REQUIRED
- Reason: Exceeds complexity threshold (>60 changed files).
```

For Codebase Mode: do not read all files. Sample strategically (see Step 3).

### Step 3 — Detect Stack

Check files/diff for:
- `pyproject.toml` or `requirements.txt` → **Python**
- `nest-cli.json` or `@nestjs/` in `package.json` → **NestJS**
- `package.json` with `"express"` → **Node.js+Express**
- Otherwise → **Unknown**

### Step 4 — Sample Files (Codebase Mode only)

Do **not** read all files. Use this strategy:

1. **Entry point**: `main.ts`, `app.ts`, `index.js`, `app.py`, or `main.py`
2. **2–3 files per category** (pick the most relevant):
   - Controllers or route handlers
   - Services or business logic
   - Models or schemas
   - Utilities or helpers
3. **Prioritize** files that handle auth, external input, or DB queries — highest risk

Use `find` to list candidates, then `Read` to load selected files.

### Step 5 — Run Review

Read [security-rules.md](references/security-rules.md) and [review-criteria.md](references/review-criteria.md) and apply all rules.

### Step 6 — Output Report

Read [review-output-format.md](references/review-output-format.md) and produce the structured report. For Codebase Mode, include:

```
- Scope: Sampled audit (not exhaustive) — N files reviewed
```

## References

- **[references/security-rules.md](references/security-rules.md)** — OWASP Top 10 and common vulnerability patterns; read during Step 5
- **[references/review-criteria.md](references/review-criteria.md)** — Code quality rules for error handling, naming, structure; read during Step 5
- **[references/review-output-format.md](references/review-output-format.md)** — Report structure, scoring (0–10), hard overrides, conciseness rules; read during Step 6
