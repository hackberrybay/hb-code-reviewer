# hb-code-reviewer

Claude Code plugin for TypeScript teams. Code quality review, OWASP security review, PR review, and a self-improving rule system.

Built for the Hackberry stack (NestJS, React Native/Expo) but applicable to any TypeScript project.

---

## Quick Start

This plugin is a **global standard** — installed once per developer, available in every project.

### Install (one-time per developer)

```
/plugin install https://raw.githubusercontent.com/hackberry/hb-code-reviewer/main/.claude-plugin/marketplace.json
```

After this, all skills (`/review-pr`, `/review-file`, etc.) are available in every project without any `--plugin-dir` flag.

### Update

When the plugin is updated, each developer runs:

```
/plugin update hb-code-reviewer
```

Bump the `version` in `plugin.json` with every meaningful change so it's clear an update is available.

---

## Skills

| Command | Model | What it does |
|---|---|---|
| `/review-pr [base]` | Sonnet | Reviews all changed files vs base branch (default: `main`). Gives verdict: APPROVE / REQUEST CHANGES / NEEDS DISCUSSION |
| `/review-file <file>` | Sonnet | Reviews a single file for quality and best practices |
| `/review-security [path]` | **Opus** | OWASP-focused security review of a file or directory |
| `/improve-rules` | Sonnet | Promotes recurring issues (3+ occurrences) into permanent rule files |
| `/pr-description` | Haiku | Generates a PR title and description from the current branch diff |

---

## Model Guide

The plugin uses different models for different tasks to balance quality and cost:

| Task | Model | Why |
|---|---|---|
| Code quality review | Sonnet | Good quality at reasonable cost |
| Security review | Opus | High-stakes — worth the cost for thorough analysis |
| PR descriptions, rule promotion | Haiku / Sonnet | Low complexity, Haiku is sufficient |

To override for a session:
```bash
claude --model opus   # force Opus everywhere for this session
```

---

## Self-Improvement Loop

The plugin gets smarter over time without manual rule writing.

### How it works

1. `/review-pr` reviews your branch and, at the end, checks if any issue class appeared 3+ times in this run.
   If so, it appends the pattern to `rules/recurring-issues.md`.

2. Every sprint or two, a team member runs `/improve-rules`.
   Any issue with 3+ total occurrences across sessions gets promoted into the permanent rule files (`rules/typescript.md` or `rules/security.md`).

3. On the next review, the promoted rule is applied automatically.

### Editing rules directly

`rules/typescript.md` and `rules/security.md` are plain markdown — edit them directly and commit.
Rule changes go through normal PR review, so the team stays aligned on what standards are actually enforced.

`rules/recurring-issues.md` is auto-managed. Do not edit it manually.

---

## Team Marketplace

This plugin uses a [team marketplace](https://code.claude.com/docs/en/plugin-marketplaces) — a `marketplace.json` hosted in this repo's `main` branch. It is the source of truth for the team install.

### Why this approach

- One install per developer, works across all projects — no per-project configuration
- The plugin lives in its own dedicated repo (`hackberry/hb-code-reviewer`), independent of any specific project
- Rule changes are PRs to this repo — the whole team reviews and agrees before they take effect

### Maintaining the plugin

1. Make changes to rules or skills, open a PR to `main`
2. After merge, bump `version` in `plugin.json`
3. Announce to the team to run `/plugin update hb-code-reviewer`

### Self-improvement caveat

`rules/recurring-issues.md` is written locally by the issue-logger agent (in each developer's plugin cache). To feed improvements back to the team:
- Periodically collect promoted rules from developers who ran `/improve-rules`
- Add them to `rules/typescript.md` or `rules/security.md` in this repo via PR
- Merge and bump the version

---

## Hooks

After writing or editing a `.ts`, `.tsx`, `.js`, or `.jsx` file, Claude will remind you to run `/review-file` on the changed file. These are non-blocking suggestions — you can ignore them.

---

## Customizing Rules

Add rules directly to `rules/typescript.md` or `rules/security.md` under the appropriate section. Commit the change. The next review will pick it up.

The `## Auto-promoted` section at the bottom of each rule file is managed by `/improve-rules` — don't edit it manually.

---

## File Structure

```
hb-code-reviewer/
├── .claude-plugin/
│   └── plugin.json           # plugin manifest
├── agents/
│   ├── code-reviewer.md      # general TS/JS quality reviewer (Sonnet)
│   ├── security-reviewer.md  # OWASP security reviewer (Opus)
│   └── issue-logger.md       # self-improvement agent
├── skills/
│   ├── review-pr/SKILL.md
│   ├── review-file/SKILL.md
│   ├── review-security/SKILL.md
│   ├── improve-rules/SKILL.md
│   └── pr-description/SKILL.md
├── hooks/
│   └── hooks.json
├── rules/
│   ├── typescript.md         # editable by team
│   ├── security.md           # editable by team
│   └── recurring-issues.md  # auto-managed, do not edit
│   └── marketplace.json      # team marketplace config
```
