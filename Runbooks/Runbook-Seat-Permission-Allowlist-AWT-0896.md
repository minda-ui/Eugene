# Runbook — seat permission allow-lists before Mon 19 Oct 08:05 (AWT-0896)

**Owner of the fix:** Minda (attended). **Prepared + verified by:** Eugene, 2026-10-18.
**Guide-only (charter §3):** Eugene read every live file via Composio GitHub and worked out the exact
change per seat; the **writes are blocked by the session's Self-Modification guard** (it denies a
Composio GitHub branch/commit even on another repo), so Minda applies/merges. This is also what
Victoria's "Minda opens it tonight" assumed.

## What changed after reading the live files (important)
Victoria's note framed the fix as adding native `mcp__Gmail__*` tools. **The live files show every seat
drives Gmail, Drive and Smartsheet through Composio** (`Bash(composio execute *)` is allowed), with the
dangerous Gmail/Drive actions denied. **No seat uses the native Gmail connector** — so native
`mcp__Gmail__*` allows are *not* needed and would be dead rules. The stall Nadia hit (AWT-0895) was on
the **native `mcp__Google_Drive__` / `mcp__Smartsheet__` MCP tools**, which her routine does call. So:

**The real fix = add Nadia's proven native Drive+Smartsheet allow block, plus the native
`mcp__Google_Drive__trash_file` deny.** Gmail is already covered by `Bash(composio execute *)`; the
mail step will not stall. (Verified against `minda-ui/Nadia` `0ea8dc4`.)

## The core block (add to every seat that needs it)
**ADD these 14 lines to `permissions.allow`:**
```json
"mcp__Google_Drive__create_file",
"mcp__Google_Drive__update_file",
"mcp__Google_Drive__copy_file",
"mcp__Google_Drive__search_files",
"mcp__Google_Drive__read_file_content",
"mcp__Google_Drive__download_file_content",
"mcp__Google_Drive__get_file_metadata",
"mcp__Google_Drive__get_file_permissions",
"mcp__Google_Drive__list_recent_files",
"mcp__Smartsheet__update_rows",
"mcp__Smartsheet__add_rows",
"mcp__Smartsheet__get_sheet_summary",
"mcp__Smartsheet__get_columns",
"mcp__Smartsheet__find_in_sheet"
```
**ADD this 1 line to `permissions.deny`:**
```json
"mcp__Google_Drive__trash_file"
```
Keep `hooks`, `enabledMcpjsonServers`, and every existing rule. The standard Composio deny set that the
clean seats already carry (for reference / for the Helen+Darius rewrite below):
```json
"Bash(composio execute GMAIL_BATCH_DELETE_MESSAGES*)",
"Bash(composio execute GMAIL_DELETE_*)",
"Bash(composio execute GMAIL_FORWARD_MESSAGE*)",
"Bash(composio execute GMAIL_MOVE_THREAD_TO_TRASH*)",
"Bash(composio execute GMAIL_MOVE_TO_TRASH*)",
"Bash(composio execute GMAIL_REPLY_TO_THREAD*)",
"Bash(composio execute GMAIL_SEND_DRAFT*)",
"Bash(composio execute GMAIL_SEND_EMAIL*)",
"Bash(composio execute GOOGLEDRIVE_DELETE_*)",
"Bash(composio execute GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*)",
"mcp__Google_Drive__trash_file"
```

## Per-seat (live state verified 2026-10-18, order per Victoria)
Base SHAs captured for the PRs if Eugene is later allowed to push: Peter `ed2534c`, Rachel `5cc2d8d`,
Alex `58dd76a`, Anna `bae5fcd`, Helen `c159a6a`, Darius `3a19f33`.

1. **Peter** (`minda-ui/Peter`) — deny already complete. **ADD** the 14 allow lines + `trash_file`
   deny. Nothing to remove. Peter's archive/label (INBOX removal) is composio, not denied — fine.
2. **Rachel** (`minda-ui/Rachel`) — **ADD** the 14 allow lines + `trash_file` deny.
   **FLAG (confirm before merge):** Rachel's deny is **missing `GMAIL_SEND_EMAIL*` and
   `GMAIL_FORWARD_MESSAGE*`** — a send path is open. The estate rule is draft-only, so I recommend also
   adding those two denies. Only skip if Rachel is meant to send. (Her hooks include a
   `gmail-recipient-guard` PreToolUse — preserve it.)
3. **John** — **`minda-ui/John` returns 404** (repo/branch/path not found). Either the repo has a
   different name or John isn't seeded. **Action:** confirm the repo; if it exists, apply the core; if
   not, it's a seeding job (Victoria→Minda→Eugene), out of this runbook.
4. **Alex** (`minda-ui/Alex`) — **ADD** the 14 allow lines + `trash_file` deny (keep Alex's extra
   `Bash(git …)`/`Agent` allows). **FLAG:** Alex is **not** denied `GMAIL_CREATE_EMAIL_DRAFT*`, so Alex
   can draft via composio. Victoria said Alex is read-only for drafts — if so, add
   `"Bash(composio execute GMAIL_CREATE_EMAIL_DRAFT*)"` to deny. Confirm.
5. **Eugene** (`minda-ui/Eugene`) — **ADD** the 14 allow lines; **extend deny** with the standard
   composio set it's missing (`GMAIL_SEND_DRAFT*`, `GMAIL_DELETE_*`, `GMAIL_BATCH_DELETE_MESSAGES*`,
   `GMAIL_MOVE_TO_TRASH*`, `GMAIL_MOVE_THREAD_TO_TRASH*`, `GOOGLEDRIVE_DELETE_*`,
   `GOOGLEDRIVE_GOOGLE_DRIVE_DELETE_FOLDER_OR_FILE_ACTION*`) + `mcp__Google_Drive__trash_file`. Keep the
   existing native `mcp__Gmail__send_message/reply/forward` + composio `GMAIL_SEND/REPLY/FORWARD` denies
   (belt-and-braces). Eugene's send-block is **already present** (contradicts AWT-0890 item 5's "no deny
   rules"). Eugene can't self-apply (Self-Modification guard), so this one is yours too.
6. **Helen** (`minda-ui/Helen`) — **ADD** the 14 allow lines. **REMOVE** the blanket
   `"Bash(composio execute GMAIL_*)"` deny (it blocks her legitimate ops@ read/label/draft — the
   AWT-0890 Helen fix). **REPLACE** it with the standard composio Gmail send/trash denies
   (`GMAIL_BATCH_DELETE_MESSAGES*`, `GMAIL_DELETE_*`, `GMAIL_FORWARD_MESSAGE*`,
   `GMAIL_MOVE_THREAD_TO_TRASH*`, `GMAIL_MOVE_TO_TRASH*`, `GMAIL_REPLY_TO_THREAD*`, `GMAIL_SEND_DRAFT*`,
   `GMAIL_SEND_EMAIL*`). Keep the two `GOOGLEDRIVE_*` deletes, add `trash_file`, and **keep her `ask`
   block** (`GOOGLEADS_MUTATE_AD_GROUP_CRITERIA*`).
7. **Darius** (`minda-ui/Darius`) — **ADD** the 14 allow lines. **REPLACE his entire over-broad deny**
   (it blocks `GMAIL_LIST/SEARCH/GET/ADD/MODIFY/CREATE_LABEL`, `composio execute -p *`, and all native
   `mcp__Gmail__*` incl. `create_draft`/`label_thread` — blocking the read+draft+FG/Done his charter v37
   needs) with the **standard composio deny set** above. That keeps send/reply/forward/delete/trash
   denied and restores his mail step. **This is the biggest single change — review carefully on merge.**
   (The AWT-0890 Darius fix.)
8. **Anna** (`minda-ui/Anna`) — deny already complete. **ADD** the 14 allow lines + `trash_file` deny.
   (Repo is reachable — not the blocker Victoria feared.)
9. **Sarah** (`minda-ui/Sarah`) — **no `.claude/settings.json` at `main`** (unseeded; her prompt points
   at Drive `CHARTER.md`). Creating a settings file from scratch is scaffolding (Victoria→Minda→Eugene),
   not a delta. **Action:** decide whether to seed Sarah a settings.json (read-only: core allow + deny
   `GMAIL_SEND_EMAIL/SEND_DRAFT/REPLY/FORWARD/DELETE/trash` **and** `GMAIL_CREATE_EMAIL_DRAFT*`), or
   confirm Sarah's run uses a permissive mode so it needs none.
10. **Nadia** (`minda-ui/Nadia`) — **already done** (`0ea8dc4`); no change.

## Pre-flight that can shrink the job
If a seat's scheduled run uses `bypassPermissions`/`auto` mode it never prompts and needs nothing —
**skip it.** Minda confirmed **Rachel's run works**; check Rachel's mode first. (Nadia was in `default`
mode and did stall, so at least some seats genuinely need the block.)

## Apply + verify (attended)
Per seat that needs it: edit `.claude/settings.json` on a branch or directly on `main` in the attended
session (the Self-Modification guard is why it's attended), merge. Then **Rule C verify**:
`git fetch origin main` and confirm the allow block is on `main` (and Helen/Darius denies narrowed) —
not the PR label.

## Report + broadcast
On Hub AWT-0896, one line per seat: repo, commit, merged yes/no (or "skipped — bypass/auto"). Then
**Rule F**: once applied, a one-line Raw note to each seat whose file changed. Eugene can prepare those
Raw broadcasts on request.

## If Eugene is to push the PRs instead
The writes failed under this session's auto mode with `[Self-Modification]`. To let Eugene open the
PRs (branch + commit + PR per repo, for Minda to merge), Minda either approves the
`Bash(composio execute GITHUB_*)` action / adds a permission rule, or runs the session in a mode that
permits it. Eugene already holds every repo's current content and base SHA, so this becomes a few
minutes of Composio calls once unblocked.
