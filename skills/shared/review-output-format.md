# Review Output Format

Use this format for all review skill outputs: `pr-review`, `branch-review`, and `base-code-review`.

## Report Structure

### Summary

Render as a blockquote so it stands out visually:

```
**Review Summary**

> - Skill: [pr-review | branch-review | base-code-review]
> - Target: [PR #NNN | branch-name vs main | /path/to/scope]
> - Detected Stack: [Python | Node.js+Express | NestJS | Unknown]
> - Score: [🔴 0–5 | 🟡 6–7 | 🟢 8–10] X/10
> - Verdict: [APPROVED | MANUAL REVIEW REQUIRED | REJECTED]
```

---

## 🔴 Critical Issues

`src/path/to/file.ts:line` CRITICAL — [short title ≤10 words]
[One sentence explanation.]

**Fix:** [one line of code or one sentence.]

## 🔴 High Severity

`src/path/to/file.ts:line` HIGH — [short title]
[One sentence explanation.]

**Fix:** [one line of code or one sentence.]

## 🟡 Medium Severity

`src/path/to/file.ts:line` MEDIUM — [short title]
[One sentence explanation.]

**Fix:** [one line of code or one sentence.]

## 🟢 Low Severity

`src/path/to/file.ts:line` LOW — [short title]
[One sentence explanation.]

**Fix:** [one line of code or one sentence.]

---

## Scoring Breakdown
[2–3 sentences max explaining the score. Reference the most significant factors.]

If a severity bucket has no findings, omit that section entirely.

## Scoring Rules (0–10)

| Score | Verdict | Condition |
|-------|---------|-----------|
| 8–10  | **APPROVED** | No critical issues, ≤1 high severity, few medium/low |
| 6–8   | **MANUAL REVIEW REQUIRED** | Some high severities, moderate complexity, or unclear scope |
| 0–6   | **REJECTED** | Multiple high/critical issues, or serious security findings |

### Hard Overrides (score is irrelevant)

- **Any CRITICAL issue** → verdict is `MANUAL REVIEW REQUIRED` at minimum. Never output `APPROVED` when a critical issue exists, regardless of score.
- **Too large/complex to fully analyze** → verdict is `MANUAL REVIEW REQUIRED`. Explicitly state: "This [PR/diff/codebase] exceeds the complexity threshold for automated full review (>30 changed files or extremely large diff)."

Scoring is **subjective** — based on severity distribution, risk level, change complexity, and context. Do not use a fixed formula.

## Conciseness Rules

Every finding must follow this structure exactly:

```
`src/path/to/file.ts:line` SEVERITY — Title (≤10 words)
One sentence explanation.

**Fix:** one line of code or one sentence.
```

Examples:

`src/auth/login.ts:42` CRITICAL — JWT algorithm not validated before verification
jwt.verify() accepts any algorithm including "none".

**Fix:** add `{ algorithms: ["HS256"] }` as the third argument.

---

`controllers/user.ts:88` HIGH — User record fetched without ownership check
Any authenticated user can access any other user's data.

**Fix:** add `req.user.id === record.userId` check before returning.

---

`utils/helpers.js:15` LOW — Boolean variable missing "is" prefix
Variable `active` does not follow the `isX` naming convention.

**Fix:** rename to `isActive`.

If the user asks for more detail on a specific finding, they will follow up. Do not over-explain upfront.
