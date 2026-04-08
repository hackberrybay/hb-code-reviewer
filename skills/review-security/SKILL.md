---
name: review-security
description: OWASP-focused security review of a file or directory. Checks for injection, auth gaps, sensitive data exposure, input validation failures, and misconfigurations. Uses Opus for thorough analysis. Run before major releases or on security-critical code.
argument-hint: "[file-or-directory]"
model: opus
user-invocable: true
allowed-tools: Read Grep Glob Bash
---

Run a security-focused review on `$ARGUMENTS`.

If `$ARGUMENTS` is empty, review the current working directory.

## Steps

### If reviewing a single file

1. Read the file.
2. Apply `${CLAUDE_PLUGIN_ROOT}/agents/security-reviewer.md` in full.
3. Output the security review.

### If reviewing a directory

1. Use Glob to find all `.ts`, `.tsx`, `.js`, `.jsx` files under the path (exclude `node_modules`, `dist`, `build`, `.next`).
2. For each file, apply `${CLAUDE_PLUGIN_ROOT}/agents/security-reviewer.md`.
3. Aggregate all findings.
4. Output:

```
## Security Review: {path}

**Files scanned:** {n}
**Overall risk:** {LOW | MEDIUM | HIGH | CRITICAL}

---

{Per-file findings, only for files with issues. Files with no findings are omitted.}

---

## Summary

### Critical issues ({n})
- `{file}:{line}` — {issue}

### Warnings ({n})
- `{file}:{line}` — {issue}

### Recommendation
{One paragraph: what to fix before this code ships}
```
