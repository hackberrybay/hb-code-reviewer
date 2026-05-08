#!/usr/bin/env bash
# Install Hackberry AI toolkit pieces into local config dirs.
#
# Usage:
#   ./scripts/install.sh claude    # symlink claude/ content into ~/.claude/
#   ./scripts/install.sh cursor    # symlink cursor/ rules into ~/.cursor/rules/
#   ./scripts/install.sh all
#
# Prefer the Claude Code plugin marketplace for claude/ — see README.
# This script is for manual/symlink installs and non-plugin tools.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$1"
  local dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "skip: $dest exists and is not a symlink"
    return
  fi
  ln -sfn "$src" "$dest"
  echo "linked: $dest -> $src"
}

install_claude() {
  local target="$HOME/.claude"
  link "$REPO_ROOT/claude/skills" "$target/skills/hb-ai-toolkit"
  link "$REPO_ROOT/claude/agents" "$target/agents/hb-ai-toolkit"
  link "$REPO_ROOT/claude/rules"  "$target/rules/hb-ai-toolkit"
  echo "claude: done. settings/ snippets must be merged into ~/.claude/settings.json manually."
}

install_cursor() {
  local target="$HOME/.cursor/rules"
  link "$REPO_ROOT/cursor" "$target/hb-ai-toolkit"
  echo "cursor: done."
}

case "${1:-}" in
  claude) install_claude ;;
  cursor) install_cursor ;;
  all)    install_claude; install_cursor ;;
  *)
    echo "Usage: $0 {claude|cursor|all}"
    exit 1
    ;;
esac
