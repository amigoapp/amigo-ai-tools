# AGENTS.md

Instructions for AI agents (Claude Code, Cursor, etc.) working in this repository.

## What this project is

`amigo-ai-tools` is a collection of shareable AI agent skills for automated code review, built with the [vercel-labs/skills](https://github.com/vercel-labs/skills) standard. Skills are installed into user agent directories (`~/.claude/skills/`, `~/.cursor/skills/`, etc.) via `npm run install:skills`.

## Architecture

### Thin skills, thick shared logic

- `skills/shared/` is the **single source of truth** for all review rules. Always edit rules here — never in the installed copies.
- Each skill (`pr-review`, `branch-review`, `base-code-review`) is a thin orchestrator: it defines how to get the code, then delegates review and output to the shared references.
- The install script copies `shared/` into each skill's `references/` before installation. Skills are fully self-contained once installed.

### Shared files

| File | Purpose |
|---|---|
| `skills/shared/security-rules.md` | OWASP Top 10 + common vulnerability patterns (v1: universal; v2 will add per-language files) |
| `skills/shared/review-criteria.md` | Code quality rules: error handling, naming, structure, debug artifacts, testing |
| `skills/shared/review-output-format.md` | Report structure, scoring (0–10), verdict logic, hard overrides, conciseness rules |

## Creating a New Skill

1. Create `skills/<skill-name>/SKILL.md`
2. Add the skill name to the `SKILLS` array in `scripts/install-skills.sh`
3. Follow the SKILL.md conventions below

### SKILL.md conventions

- Use YAML frontmatter with `name` and `description` only (plus `allowed-tools` and `disable-model-invocation` if needed — no other fields)
- Write **everything in English** — skill name, description, body, and all reference content
- Write the body in **imperative/infinitive form**
- Do **not** use `---` as horizontal rule separators
- Keep the body **under 500 lines**
- Do **not** create README.md, CHANGELOG.md, or any auxiliary files inside skill directories
- Load references inline at the step where they're used — not all upfront

### SKILL.md template

```markdown
---
name: skill-name
description: What it does. Use when [specific triggers and contexts].
allowed-tools: [tools]
---

## Workflow

### Step 1 — ...

### Step N — Run Review

Read [security-rules.md](references/security-rules.md) and [review-criteria.md](references/review-criteria.md) and apply all rules.

### Step N+1 — Output Report

Read [review-output-format.md](references/review-output-format.md) and produce the structured report.

## References

- **[references/security-rules.md](references/security-rules.md)** — OWASP Top 10 and common vulnerability patterns; read during Step N
- **[references/review-criteria.md](references/review-criteria.md)** — Code quality rules for error handling, naming, structure; read during Step N
- **[references/review-output-format.md](references/review-output-format.md)** — Report structure, scoring (0–10), hard overrides, conciseness rules; read during Step N+1
```

## Shared Conventions

| Convention | Value |
|---|---|
| Complexity threshold | Flag as `MANUAL REVIEW REQUIRED` when >10 changed files or extremely large diff |
| Stack detection | `pyproject.toml` / `.py` → Python · `nest-cli.json` / `@nestjs/` → NestJS · `package.json` with `express` → Node.js+Express |
| References path | Always `references/` (relative to SKILL.md) — populated at install time from `skills/shared/` |
| Finding format | `[file:line] SEVERITY — title` + explanation line + `Fix:` line |
| Score circles | 🔴 0–5 · 🟡 6–7 · 🟢 8–10 |

## Install Workflow

`npm run install:skills` runs `scripts/install-skills.sh`:

1. Copies `skills/shared/*.md` → `skills/<each-skill>/references/`
2. Runs `npx skills add . --copy -a claude-code -a cursor` (interactive agent selection)
3. Cleans up the temporary `references/` copies via `trap cleanup EXIT`

The `references/` directories inside skill source folders are **always temporary** — never commit them.

## Updating Shared Rules

Edit files in `skills/shared/`. Re-run `npm run install:skills` to propagate changes to all installed skills.
