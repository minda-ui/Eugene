#!/bin/bash
# Eugene — UserPromptSubmit hook: Creative mode / Lab mode toggle (Lab mode v1.0, charter §5).
# Changed 2026-11-12 (Minda: "R&D ideas should go to lab"). Read-only: prints context,
# changes nothing, never blocks the message (always exit 0).
input="$(cat)"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty' 2>/dev/null)"
[ -n "$prompt" ] || exit 0
p="$(printf '%s' "$prompt" | tr '[:upper:]' '[:lower:]')"
if printf '%s' "$p" | grep -qE "\blab mode off\b|\bcreative mode off\b|\bnormal mode\b|back to normal|exit creative|end creative"; then
  cat <<'EOF'
LAB / CREATIVE MODE OFF. Return to Eugene's standard working posture (CLAUDE.md §4 documentation discipline). Nothing from Creative mode is written or released by switching off.
EOF
elif printf '%s' "$p" | grep -qE "\blab mode\b"; then
  cat <<'EOF'
LAB MODE ON (Lab mode v1.0, CLAUDE.md §5). Until "Lab mode off":
- Write Lab work ONLY in Master Core – Lab: index "00 Models & Proposals Index" (Smartsheet 4471351379363716; your own rows, owner Eugene) and Drive Lab/ 1yUa7h10FeajcX15plwxSYTx6lZw380Ve (git working copy R&D/lab/<item>/ or R&D/<slug>/). Every item labelled LAB.
- Every R&D idea gets a Lab index row (not R&D/ideas-log.md, which is frozen history).
- Read live systems read-only; synthetic test data; no personal or financial data.
- NEVER from Lab work: sending, Hub rows, Roster/Authority changes, live writes, edits to another seat's files, sharing changes. A Lab item is never evidence.
- Only Minda releases an item, one at a time, naming what and where. Charter §3 applies in full.
EOF
elif printf '%s' "$p" | grep -qE "\bcreative mode\b|\br&d mode\b"; then
  cat <<'EOF'
CREATIVE MODE ON (estate one-to-one Creative mode, Lab mode v1.0 §1). Until "Creative mode off":
- Ideas stay in the chat: write NOTHING anywhere (no files, no Lab rows, no git), send nothing, no searches carrying Minda's words.
- What Minda says here is not an instruction, task, decision or record.
- Only Minda releases an idea, one at a time, naming what and where (normally: a new Lab index row). Show the exact text and place first and wait for her yes.
- Switching off releases nothing; a summary says only that Creative mode was on. Charter §3 applies in full.
EOF
fi
exit 0
