#!/bin/bash
# Eugene — UserPromptSubmit hook: end-of-day documentation check.
#
# When Minda signs off ("good night", "done for today", …), inject a reminder so
# the reply starts with the end-of-day-wrapup skill instead of just saying good
# night. Owner idea, Minda 2026-09-29. Read-only: prints context, changes nothing,
# never blocks the message (always exit 0).
input="$(cat)"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty' 2>/dev/null)"
[ -n "$prompt" ] || exit 0
if printf '%s' "$prompt" | grep -qiE "good ?night|night night|\bnite\b|done for (the )?(day|today)|that'?s (it|all) for today|signing off|end of (the )?day|see you tomorrow|bye for (now|today)"; then
  cat <<'EOF'
End-of-day sign-off detected. Before replying, use the end-of-day-wrapup skill: check whether all of today's work is documented (change-log, processed-items-ledger.md, current-state.md, synced to Drive via drive-sync-verified), document anything missing, then say good night with a short summary of what was logged and what is open for tomorrow.
EOF
fi
exit 0
