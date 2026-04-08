# hb-code-reviewer

Claude Code plugin for code quality review, best practices enforcement, and self-improving rules. Covers TypeScript, NestJS, and React Native/Expo.

## What this plugin provides

- **Skills** — `/review-pr`, `/review-file`, `/review-security`, `/pr-description`, `/improve-rules`
- **Agents** — `code-reviewer`, `security-reviewer`, `issue-logger`
- **Rules** — `rules/typescript.md`, `rules/security.md`, `rules/recurring-issues.md`
- **Hook** — prompts to run `/review-file` after any `.ts/.tsx/.js/.jsx` file is written or edited

## Coding conventions

- TypeScript strict mode. No `any` — use `unknown` and narrow it.
- Explicit return types on all exported functions and methods.
- Named exports. Default exports only for React components and route/page files.
- `async`/`await` only — no `.then()`/`.catch()` chains.
- Functions must be small and single-purpose. If it needs a comment, split it.
- No premature abstractions. Solve the problem at hand.
- Import order: external packages → internal packages → relative imports.

## Working with rules

- `rules/typescript.md` and `rules/security.md` are the source of truth for review decisions.
- `rules/recurring-issues.md` is auto-updated by the `/improve-rules` skill — do not edit manually.
- To change a rule, edit the relevant file directly and commit via PR.

## Communication style

- Terse and direct. No preamble or filler.
- No emojis.
- Reference file paths and line numbers when citing issues: `path/to/file.ts:42`.
- Lead review output with critical issues. Skip info-level items unless critical and warning counts are zero.
