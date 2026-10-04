#!/bin/bash
# Eugene — UserPromptSubmit hook: Creative / R&D mode toggle.
#
# "Creative mode" => enter Eugene's R&D world (bolder exploration, work in R&D/,
# lighter logging) with charter §3 safety UNCHANGED. "Normal mode" => return to
# the standard working posture. Owner idea, Minda 2026-10-04. Read-only: prints
# context, changes nothing, never blocks the message (always exit 0).
input="$(cat)"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty' 2>/dev/null)"
[ -n "$prompt" ] || exit 0
if printf '%s' "$prompt" | grep -qiE "\bcreative mode\b|\br&d mode\b|enter creative"; then
  cat <<'EOF'
CREATIVE / R&D MODE ON (Eugene's R&D pool). Hold this posture for this and following turns until Minda says "Normal mode":
- Explore boldly: propose speculative, ambitious ideas; sketch and prototype quickly; think beyond the usual scope. Half-formed ideas are welcome here — the point is to generate, and let the good ones become real.
- Workspace: do R&D work in R&D/ — log every spark in R&D/ideas-log.md, and use a per-experiment folder R&D/<slug>/ for anything substantial. Keep R&D churn OUT of the main control files (current-state.md, processed-items-ledger.md, open-issues.md) until an idea graduates.
- Graduation: when an idea is ready to become real, put it to Minda — record it in R&D/graduation-register.md and turn it into a real project/runbook/Hub task, or hand it to the right employee via their Raw/, with her approval.
- SAFETY IS UNCHANGED. Charter §3 applies in full in Creative mode: no live-system changes (guide-and-verify only), never hold/type/request secrets, archive-never-trash, cross-KB only via Raw/. Creative is not reckless — anything irreversible or production-affecting is still flagged for a human, never done unilaterally.
- Full rules: R&D/README.md.
EOF
elif printf '%s' "$prompt" | grep -qiE "\bnormal mode\b|exit creative|back to normal|end creative"; then
  cat <<'EOF'
CREATIVE / R&D MODE OFF. Return to Eugene's standard working posture: normal scope, and full control-file documentation discipline per CLAUDE.md §4. Any R&D worth keeping should already be in R&D/ideas-log.md; carry forward only what Minda has approved to graduate.
EOF
fi
exit 0
