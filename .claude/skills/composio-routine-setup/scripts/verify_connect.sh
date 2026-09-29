#!/bin/bash
# composio-routine-setup / verify_connect.sh — read-only end-to-end check of
# Composio Connect from the CURRENT session: key present, host reachable, MCP
# handshake, tools listed, one read-only Drive "about" call as <account>.
# The key is sent only in its header and never printed (only its first 3 chars).
#
# Usage: verify_connect.sh [<drive-account-alias>]   (default: eugene-googledrive)
set -uo pipefail
ACCOUNT="${1:-eugene-googledrive}"
URL="https://connect.composio.dev/mcp"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
pass(){ echo "PASS  $*"; }; fail(){ echo "FAIL  $*"; echo "RESULT: FAIL at: $1"; exit 2; }

[ -n "${COMPOSIO_API_KEY:-}" ] || fail "key" "COMPOSIO_API_KEY not set in this session — add it to the environment's variables and start a NEW session"
P="${COMPOSIO_API_KEY:0:3}"
[ "$P" = "ck_" ] && pass "key: set (${P}… consumer key)" || fail "key" "COMPOSIO_API_KEY starts '${P}', expected 'ck_' (Composio Connect takes consumer keys from Sessions & API Key)"

code=$(curl -sS -o /dev/null -w '%{http_code}' --max-time 20 "$URL" 2>"$TMP/err") || true
case "$code" in
  401|405|406|400) pass "reach: $URL answers (HTTP $code without key — expected)";;
  *) fail "reach" "HTTP '$code' $(head -c 200 "$TMP/err") — if 'Proxy refused … 403', allow connect.composio.dev in the environment's Network access";;
esac

H=(-H "x-consumer-api-key: ${COMPOSIO_API_KEY}" -H "Content-Type: application/json" -H "Accept: application/json, text/event-stream")
body(){ sed 's/^data: //' "$1" | grep '^{' | tail -1; }
code=$(curl -sS --max-time 30 -D "$TMP/h" -o "$TMP/b1" -w '%{http_code}' "${H[@]}" -X POST "$URL" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"verify_connect","version":"1"}}}')
[ "$code" = "200" ] || fail "handshake" "initialize HTTP $code (401 = key rejected; regenerated ck_ keys can 401 — ComposioHQ/composio#3485)"
SID=$(grep -i '^mcp-session-id:' "$TMP/h" | cut -d' ' -f2 | tr -d '\r')
pass "handshake: initialize 200$([ -n "$SID" ] && echo ', session opened')"
S=(); [ -n "$SID" ] && S=(-H "mcp-session-id: $SID")
curl -sS --max-time 30 -o /dev/null "${H[@]}" "${S[@]}" -X POST "$URL" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' || true

curl -sS --max-time 60 -o "$TMP/b2" "${H[@]}" "${S[@]}" -X POST "$URL" -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
N=$(body "$TMP/b2" | jq '.result.tools | length' 2>/dev/null || echo 0)
[ "${N:-0}" -gt 0 ] && pass "tools: $N offered ($(body "$TMP/b2" | jq -r '[.result.tools[].name][0:3]|join(", ")'), …)" || fail "tools" "tools/list returned none"

REQ=$(jq -nc --arg a "$ACCOUNT" '{jsonrpc:"2.0",id:3,method:"tools/call",params:{name:"COMPOSIO_MULTI_EXECUTE_TOOL",arguments:{tools:[{tool_slug:"GOOGLEDRIVE_GET_ABOUT",arguments:{fields:"user"},account:$a}],thought:"Read-only connectivity check.",sync_response_to_workbench:false,current_step:"VERIFYING_CONNECTION"}}}')
curl -sS --max-time 120 -o "$TMP/b3" "${H[@]}" "${S[@]}" -X POST "$URL" -d "$REQ"
EMAIL=$(body "$TMP/b3" | jq -r '.result.content[0].text' 2>/dev/null | jq -r '.data.results[0].response.data.user.emailAddress // empty' 2>/dev/null)
[ -n "$EMAIL" ] && pass "drive read as '$ACCOUNT': $EMAIL" || fail "drive-read" "no user returned for account '$ACCOUNT' — check the alias exists (composio connections list) and is ACTIVE"
echo "RESULT: PASS — Composio Connect works in this session; Drive via '$ACCOUNT' = $EMAIL"
