# hb-ai-toolkit

Hackberry's shared AI tooling. General-use Claude Code skills, agents, hooks, and rules — plus space for Cursor rules and tool-agnostic prompts. One install per developer, available in every project.

Built for the Hackberry stack (NestJS, React Native/Expo) but applicable to any TypeScript project.

---

## What's included today

- **Code review** — `/review-pr`, `/review-file`
- **Security review** — `/review-security` (Opus-backed, OWASP-focused)
- **PR descriptions** — `/pr-description`
- **Self-improving rules** — `/improve-rules` promotes recurring issues into permanent rule files

Future additions live alongside: Cursor rules under `cursor/`, tool-agnostic prompts under `shared/`.

---

## Install

### Claude Code (recommended: plugin marketplace)

Claude Code clones plugins via SSH. If you have SSH keys configured for GitHub, no extra setup is needed.

If you don't have SSH keys set up and get a `Permission denied (publickey)` error during install, run this once to fall back to HTTPS:

```
git config --global url."https://github.com/".insteadOf "git@github.com:"
```

Note: this redirects all GitHub git operations on your machine to HTTPS. Skip it if you use SSH keys.

Then install:

```
/plugin marketplace add https://raw.githubusercontent.com/hackberrybay/hb-ai-toolkit/main/.claude-plugin/marketplace.json
```

```
/plugin install hb-ai-toolkit@hb-marketplace
```

After this, all skills (`/review-pr`, `/review-file`, etc.) are available in every project without any `--plugin-dir` flag.

### Updates

To enable auto-updates (recommended), do this once after installing:

```
/plugin
```

Go to **Marketplaces** → select `hb-marketplace` → enable auto-update. Claude Code will then update the plugin automatically on startup.

To update manually:

```
/plugin update hb-ai-toolkit
```

Bump the `version` in `.claude-plugin/plugin.json` with every meaningful change so it's clear an update is available.

### Claude Code (manual: symlink)

If you want to edit and iterate locally without going through the plugin system:

```
git clone git@github.com:hackberrybay/hb-ai-toolkit.git
cd hb-ai-toolkit
./scripts/install.sh claude
```

Skills/agents/rules are symlinked into `~/.claude/`. `claude/settings/` snippets are not auto-merged — copy what you want into `~/.claude/settings.json`.

### Cursor

```
./scripts/install.sh cursor
```

### Shared

`shared/` is reference material — copy what you need into a project, or read it directly.

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

The review skills get smarter over time without manual rule writing.

### How it works

1. `/review-pr` reviews your branch and, at the end, checks if any issue class appeared 3+ times in this run.
   If so, it appends the pattern to `claude/rules/recurring-issues.md`.

2. Every sprint or two, a team member runs `/improve-rules`.
   Any issue with 3+ total occurrences across sessions gets promoted into the permanent rule files (`claude/rules/typescript.md` or `claude/rules/security.md`).

3. On the next review, the promoted rule is applied automatically.

### Editing rules directly

`claude/rules/typescript.md` and `claude/rules/security.md` are plain markdown — edit them directly and commit.
Rule changes go through normal PR review, so the team stays aligned on what standards are actually enforced.

`claude/rules/recurring-issues.md` is auto-managed. Do not edit it manually.

---

## Team Marketplace

This toolkit uses a [team marketplace](https://code.claude.com/docs/en/plugin-marketplaces) — a `marketplace.json` hosted in this repo's `main` branch. It is the source of truth for the team install.

### Why this approach

- One install per developer, works across all projects — no per-project configuration
- The toolkit lives in its own dedicated repo (`hackberry/hb-ai-toolkit`), independent of any specific project
- Rule changes are PRs to this repo — the whole team reviews and agrees before they take effect

### Maintaining the toolkit

1. Make changes to skills/agents/rules, open a PR to `main`
2. After merge, bump `version` in `.claude-plugin/plugin.json`
3. Announce to the team to run `/plugin update hb-ai-toolkit`

### Self-improvement caveat

`claude/rules/recurring-issues.md` is written locally by the issue-logger agent (in each developer's plugin cache). To feed improvements back to the team:
- Periodically collect promoted rules from developers who ran `/improve-rules`
- Add them to `claude/rules/typescript.md` or `claude/rules/security.md` in this repo via PR
- Merge and bump the version

---

## Hooks

After writing or editing a `.ts`, `.tsx`, `.js`, or `.jsx` file, Claude will remind you to run `/review-file` on the changed file. These are non-blocking suggestions — you can ignore them.

---

## Customizing Rules

Add rules directly to `claude/rules/typescript.md` or `claude/rules/security.md` under the appropriate section. Commit the change. The next review will pick it up.

The `## Auto-promoted` section at the bottom of each rule file is managed by `/improve-rules` — don't edit it manually.

---

## File Structure

```
hb-ai-toolkit/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── claude/
│   ├── skills/
│   │   ├── review-pr/SKILL.md
│   │   ├── review-file/SKILL.md
│   │   ├── review-security/SKILL.md
│   │   ├── improve-rules/SKILL.md
│   │   └── pr-description/SKILL.md
│   ├── agents/
│   │   ├── code-reviewer.md
│   │   ├── security-reviewer.md
│   │   └── issue-logger.md
│   ├── hooks/hooks.json
│   ├── rules/
│   │   ├── typescript.md           # editable by team
│   │   ├── security.md             # editable by team
│   │   └── recurring-issues.md     # auto-managed
│   └── settings/                   # snippets to merge into ~/.claude/settings.json
├── cursor/                         # Cursor rules (.mdc / .cursorrules)
├── shared/                         # tool-agnostic prompts and style guides
├── scripts/install.sh              # symlink installer
└── README.md
```
