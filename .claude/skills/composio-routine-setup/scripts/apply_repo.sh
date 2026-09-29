#!/bin/bash
# composio-routine-setup / apply_repo.sh — add the Composio Connect MCP server to
# a KB repo checkout: writes .mcp.json and adds "composio" to
# enabledMcpjsonServers in .claude/settings.json. Idempotent; keeps every
# existing setting (hooks, allow/deny rules). Prints what it changed.
#
# Usage: apply_repo.sh <repo-dir> [--dry-run]
set -euo pipefail
REPO="${1:?usage: apply_repo.sh <repo-dir> [--dry-run]}"; DRY="${2:-}"
[ -d "$REPO/.git" ] || { echo "FAIL: $REPO is not a git checkout" >&2; exit 1; }
HERE="$(cd "$(dirname "$0")/.." && pwd)"
TPL="$HERE/templates/mcp.json"
MCP="$REPO/.mcp.json"; SET="$REPO/.claude/settings.json"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# .mcp.json — merge our "composio" server into any existing servers
if [ -f "$MCP" ]; then
  jq -e . "$MCP" >/dev/null || { echo "FAIL: existing $MCP is not valid JSON — fix by hand" >&2; exit 1; }
  jq --slurpfile t "$TPL" '.mcpServers = ((.mcpServers // {}) + $t[0].mcpServers)' "$MCP" > "$TMP/mcp.json"
else
  cp "$TPL" "$TMP/mcp.json"
fi

# settings.json — add "composio" to enabledMcpjsonServers, keep everything else
if [ -f "$SET" ]; then
  jq -e . "$SET" >/dev/null || { echo "FAIL: existing $SET is not valid JSON — fix by hand" >&2; exit 1; }
  jq '.enabledMcpjsonServers = (((.enabledMcpjsonServers // []) + ["composio"]) | unique)' "$SET" > "$TMP/settings.json"
else
  echo '{"enabledMcpjsonServers":["composio"]}' | jq . > "$TMP/settings.json"
fi

for pair in "mcp.json:$MCP" "settings.json:$SET"; do
  src="$TMP/${pair%%:*}"; dst="${pair#*:}"
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then echo "unchanged: ${dst#$REPO/}"; continue; fi
  echo "would write: ${dst#$REPO/}"
  if [ -f "$dst" ]; then diff -u "$dst" "$src" | sed 's/^/    /' | head -40 || true; else sed 's/^/    /' "$src"; fi
  if [ "$DRY" != "--dry-run" ]; then mkdir -p "$(dirname "$dst")"; cp "$src" "$dst"; echo "wrote: ${dst#$REPO/}"; fi
done
[ "$DRY" = "--dry-run" ] && echo "RESULT: dry run — nothing written" || echo "RESULT: done — commit .mcp.json and .claude/settings.json on a branch and open a PR"
