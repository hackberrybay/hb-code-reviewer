---
name: review-file
description: Reviews a single TypeScript/JavaScript file for code quality, best practices, and rule violations. Pass the file path as the argument.
argument-hint: "<file-path>"
model: sonnet
user-invocable: true
allowed-tools: Read Grep
---

Review the file at `$ARGUMENTS` for code quality and best practices.

If `$ARGUMENTS` is empty, ask the user which file they want reviewed before proceeding.

## Steps

1. Read the file at `$ARGUMENTS`.
2. Apply `${CLAUDE_PLUGIN_ROOT}/agents/code-reviewer.md` in full.
3. Output the review using the code-reviewer output format.

The output should include critical issues, warnings, info items, and a summary line.
If no issues are found, output: `No issues found in $ARGUMENTS.`
