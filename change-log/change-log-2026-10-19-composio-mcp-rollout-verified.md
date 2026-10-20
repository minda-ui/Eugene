# Change log — 2026-10-19 — Composio-MCP allow-list rollout verified across all 10 seats

Guide-only / hand-applied (§3): Minda pasted the settings replacements on each repo by hand; Eugene
only **read** the results to verify. Eugene cannot push these settings himself — a write containing the
Composio meta-tool allows trips the cloud weaken-guard (documented since the 2026-10-18 block, ledger 128).

## What was verified
Minda applied the full-file settings replacements from
`Runbooks/Seat-Settings-Full-Replacements-ComposioMCP-2026-10-18.md` (current main + the 6 Composio-MCP
lines) and merged Peter#3. Eugene read each seat's `.claude/settings.json` on `origin/main` via Composio
GitHub (a read, so the guard does not apply) and confirmed on **all 10 seats**:

- **Valid JSON**
- All **6 Composio-MCP allow-lines**: `COMPOSIO_MULTI_EXECUTE_TOOL`, `COMPOSIO_SEARCH_TOOLS`,
  `COMPOSIO_GET_TOOL_SCHEMAS`, `COMPOSIO_MANAGE_CONNECTIONS`, `COMPOSIO_WAIT_FOR_CONNECTIONS`,
  `COMPOSIO_REMOTE_WORKBENCH`
- `COMPOSIO_REMOTE_BASH_TOOL` correctly **excluded** everywhere
- `enabledMcpjsonServers: ["composio"]` set

Seats: **Peter, Rachel, Alex, Anna, John (Fishbone-Properties-Ltd), Helen, Darius, Sarah, Nadia, Eugene.**

This clears the open thread from before the network-map work: the workforce's unattended runs can now
reach Composio through the MCP meta-tools without stalling on an "Allow Once" prompt (the original
complaint — "Peter's work run can't update files via composio mcp", then "I am getting similar
complaints").

## Judgement call — Sarah
Sarah's `settings.json` was first pasted **wrapped in markdown ```` ```json ```` code fences** (copied
from the doc's code block), which made the whole file invalid JSON. That is worse than a missing line:
an unparseable settings file means the harness loads **no** permissions and **no** hooks, so every tool
call prompts and her unattended run stalls on the first one. Caught it on the first read, flagged the
exact two-line fix (delete the opening ```` ```json ```` and the closing ```` ``` ````); Minda fixed it;
re-verified valid.

Sarah is kept **write-capable** — Minda's call: "she needs to write, otherwise she can't make reports."
This supersedes the earlier read-only seeding (AWT-0896). Her file carries the native Drive/Smartsheet
write allows (`create_file`, `update_file`, `copy_file`, `update_rows`, `add_rows`) plus the 6 MCP lines.

## Trade-off flagged (live now, workforce-wide)
On the Composio **MCP meta-tool** path, the CLI-pattern deny-lines
(`Bash(composio execute GMAIL_*)`, `…GOOGLEDRIVE_DELETE_*`) do **not** apply — the meta-tool
`COMPOSIO_MULTI_EXECUTE_TOOL` can reach those actions regardless. So each seat's send/delete limit now
rests on its **charter §3 + routine prompt**, not the deny rule. Worth a glance at the prompt of any seat
that touches outbound mail.

## Ledger / Hub
Ledger row 130. Hub: Achievements row appended; AWT-0896 was already closed Done (seat allow-lists), this
is the Composio-MCP overlay verification on top of it.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
