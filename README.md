# Amigo AI Tools

Shareable AI agent skills for automated code review. Install them into Claude Code, Cursor, or any compatible agent to get structured PR reviews, branch reviews, and codebase audits.

## Skills

| Skill | Trigger | What it does |
|---|---|---|
| `pr-review` | "review PR #123" | Fetches a GitHub PR via MCP, scores it, reports findings |
| `branch-review` | "review my branch" / "check my changes" | Diffs current branch vs base, scores and reports |
| `base-code-review` | "audit the codebase" / "security audit" | Samples key files, reports security and quality issues |

All three skills produce the same structured report: a score (0–10), a verdict (`APPROVED` / `MANUAL REVIEW REQUIRED` / `REJECTED`), and color-coded findings grouped by severity.

## Installation

```bash
yarn run install:skills
```

Runs an interactive installer — you choose which agents to install to. Supported agents: Claude Code, Cursor, and any agent supported by [vercel-labs/skills](https://github.com/vercel-labs/skills).

## Project Structure

```
amigo-ai-tools/
├── skills/
│   ├── shared/                        # Source of truth for all rules — edit here
│   │   ├── security-rules.md          # OWASP Top 10 + common vulnerability patterns
│   │   ├── review-criteria.md         # Code quality rules (error handling, naming, etc.)
│   │   └── review-output-format.md    # Report format, scoring, and verdict logic
│   │
│   ├── pr-review/SKILL.md             # Reviews a GitHub PR via GitHub MCP
│   ├── branch-review/SKILL.md         # Reviews local git branch changes
│   └── base-code-review/SKILL.md      # Audits an existing codebase (sampled)
│
├── scripts/
│   └── install-skills.sh              # Sync shared rules + run skills installer
└── package.json
```

## Updating Rules

All review logic lives in `skills/shared/`. Editing a file there propagates to all three skills on the next `npm run install:skills`.

| File | What to change |
|---|---|
| `security-rules.md` | Security checks (injection, auth, crypto, access control...) |
| `review-criteria.md` | Code quality rules (error handling, naming, structure...) |
| `review-output-format.md` | Report layout, scoring thresholds, output style |

## Adding a New Skill

See [AGENTS.md](AGENTS.md).

## Roadmap

- `shared/python-rules.md` — Python-specific rules
- `shared/node-express-rules.md` — Node.js/Express rules
- `shared/nestjs-rules.md` — NestJS rules (DTOs, guards, decorators)
- `skills/migration-review/` — Database migration file review
- `scripts/install-skills.sh` — Smart copy: parse each skill's `## References` section and copy only the files actually linked, instead of all files from `shared/`
