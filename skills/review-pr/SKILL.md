---
name: review-pr
description: Reviews all files changed in the current branch vs a base branch. Auto-routes each file to the right reviewer, runs PR-level checks, logs recurring patterns, and outputs a verdict. Run before pushing or opening a PR.
argument-hint: "[base-branch]"
model: sonnet
user-invocable: true
allowed-tools: Bash Read Grep Glob
---

Review all files changed in this branch compared to `$ARGUMENTS` (default: `main`).

## Steps

### 1. Determine diff range

Base branch: use `$ARGUMENTS` if provided, otherwise `main`.

```bash
git log <base>...HEAD --oneline
```

Read commit messages to understand the change intent.

```bash
git diff <base>...HEAD --name-only
```

Get the list of changed files. Skip deleted files and binary files.

### 2. Classify change intent

From the commit messages:
- **Bug fix** — corrects existing behaviour
- **Feature** — adds new capability
- **Refactor** — restructures without changing behaviour
- **Chore** — dependencies, config, tooling, docs

This shapes the review: bug fixes should have a regression test; refactors must not change observable behaviour; features must follow existing patterns.

### 3. Review each changed file

For each changed file, read its content plus the diff:
```bash
git diff <base>...HEAD -- <file>
```

Apply `${CLAUDE_PLUGIN_ROOT}/agents/code-reviewer.md` to every file.

Weight findings toward changed lines — don't flag pre-existing issues unless they are directly relevant to the change.

### 4. PR-level checks

**For bug fixes:**
- Is there a new or updated test covering the fixed case? If not, flag as `warning`.
- Does the fix touch only the code needed, or does it include unrelated changes?

**For refactors:**
- Do the changed files have tests? If not, flag — behaviour-preserving claims are unverifiable without tests.
- Did any exported function signatures or public types change? Flag as `warning` — these are breaking changes.

**For features:**
- Does new code follow the same patterns as adjacent existing code?
- Are new endpoints or operations protected appropriately?

**For all change types:**
- Flag any `console.log` / `console.error` left in non-test production code.
- Flag any `TODO` / `FIXME` comments added in this diff.
- Flag hardcoded values that belong in config or env variables.

### 5. Log recurring patterns

After reviewing all files, pass the full review output to `${CLAUDE_PLUGIN_ROOT}/agents/issue-logger.md` in Mode 1.
This will update `rules/recurring-issues.md` if any issue class appeared 3+ times in this run.

### 6. Output

```
## PR Review

**Base:** <base>...HEAD
**Change type:** {Bug fix | Feature | Refactor | Chore}
**Files reviewed:** {n}

---

{Individual review for each file using the code-reviewer output format}

---

## PR-Level Notes

### Must fix
- {critical cross-cutting issues}

### Suggestions
- {warnings spanning multiple files}

---

## Verdict
{APPROVE | REQUEST CHANGES | NEEDS DISCUSSION}

**Rationale:** {one or two sentences}
```

**Verdict guide:**
- `APPROVE` — no critical issues; warnings are minor or already acknowledged
- `REQUEST CHANGES` — one or more critical issues, or a missing regression test on a bug fix
- `NEEDS DISCUSSION` — the approach is questionable but you're uncertain — flag for team conversation
