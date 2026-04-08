---
name: improve-rules
description: Reads the recurring-issues log and promotes issues that have appeared 3+ times into the permanent rule files (typescript.md or security.md). Run periodically after multiple review cycles — typically once per sprint.
model: sonnet
user-invocable: true
allowed-tools: Read Write
---

Promote recurring issues into the permanent rule files.

## Steps

1. Read `${CLAUDE_PLUGIN_ROOT}/rules/recurring-issues.md`.
2. If the file has no entries below the `<!-- entries appended below this line -->` comment, output:
   `No recurring issues have been logged yet. Run /review-pr on a few branches first.`
   Then stop.
3. Otherwise, invoke `${CLAUDE_PLUGIN_ROOT}/agents/issue-logger.md` in **Mode 2** (Promote).

The issue-logger agent will:
- Identify entries with `Occurrences >= 3` that have not yet been promoted
- Append them as new rules under `## Auto-promoted` in the correct rule file
- Mark them as promoted in `recurring-issues.md`
- Output the promotion report

After the agent completes, display the promotion report to the user.
