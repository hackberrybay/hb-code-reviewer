---
name: pr-description
description: Generates a pull request title and description from the current branch diff. Reads commit messages and changed files to produce a consistent, structured PR description ready to paste into GitHub.
model: haiku
user-invocable: true
allowed-tools: Bash Read
---

Generate a pull request title and description for the current branch.

## Steps

1. Run:
   ```bash
   git log main...HEAD --oneline
   ```
   Read the commit messages to understand the change intent.

2. Run:
   ```bash
   git diff main...HEAD --stat
   ```
   Get the list of changed files and rough scope.

3. Run:
   ```bash
   git diff main...HEAD
   ```
   Read the actual diff to understand what changed.

4. Produce the PR description in this format:

```
## Title
{Concise imperative title, max 72 chars. E.g. "Add pagination to shifts endpoint"}

## Description

### What
{1-3 bullet points describing what was changed and why}

### How
{1-3 bullet points describing the approach, if non-obvious}

### Testing
{Bulleted checklist of how to verify this works:
- [ ] {test case 1}
- [ ] {test case 2}
}

### Notes
{Optional: migration steps, breaking changes, follow-up tickets, or deployment notes. Omit section if nothing to add.}
```

Keep the description factual and concise. Do not pad. If the change is a one-liner, the description should be too.
