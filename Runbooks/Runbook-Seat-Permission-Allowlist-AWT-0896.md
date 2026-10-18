# Runbook — seat permission allow-lists before Mon 19 Oct 08:05 (AWT-0896)

**Owner of the fix:** Minda (attended). **Prepared by:** Eugene, 2026-10-18.
**Guide-only (charter §3):** Eugene produces the exact settings and verifies; Minda applies/merges
each repo in an attended session. Eugene does not push into another seat's KB (§1/§3), and the
**Self-Modification guard** blocks a session from widening its own `.claude/settings.json` — so even
Eugene's own block is applied by Minda here, not self-committed.

## Why this is urgent (same class as the Done-rows archive)
The ten seats' work-run / task-check-in routines go live **Mon 19 Oct 08:05 UK**. In the default
permission mode, any tool **not on the repo's `permissions.allow` list prompts "Allow Once"** — which
an unattended routine cannot answer, so the run **stalls on its first Drive or Smartsheet write**.
Nadia hit exactly this (AWT-0895) and fixed it by adding an allow-list to `minda-ui/Nadia` main
(merge `0ea8dc4`). Victoria's read of the public mirrors (AWT-0896) found **Alex, Eugene, Helen,
Darius, Rachel, Peter and John have only the three `composio` allow rules** — so their runs may stall
the same way. **Anna and Sarah repos are private — unread; confirm against the live file.**

## Pre-flight (do this first — it may shrink the job)
1. **Permission mode check.** If a seat's scheduled run uses `bypassPermissions` or `auto` mode, it
   does **not** prompt and needs **no allow-list — skip it.** Minda confirmed **Rachel's run works**;
   check Rachel's scheduled-run permission mode first. If Rachel works because she's in a permissive
   mode, check whether other seats share it before editing. If Rachel works *with* `default` mode and
   no allow-list, tell Eugene — that would change the diagnosis. (Nadia was in `default` mode and did
   stall, so at least some seats genuinely need this.)
2. Decide per seat: **permissive mode → skip; `default` mode → apply the block below.**

## The common core (identical for every seat that needs it)
Merge these **additively** into the existing `permissions` object — keep `hooks`,
`enabledMcpjsonServers`, and every rule already there.

**ADD to `allow` (Drive + Smartsheet — Nadia's proven `0ea8dc4` set):**
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

**KEEP DENIED for everyone (add any missing):**
```json
"Bash(composio execute GMAIL_SEND*)",
"Bash(composio execute GMAIL_REPLY*)",
"Bash(composio execute GMAIL_FORWARD*)",
"mcp__Gmail__send_message",
"mcp__Gmail__reply",
"mcp__Gmail__forward",
"mcp__Gmail__delete_draft",
"mcp__Gmail__trash_message",
"mcp__Gmail__trash_thread",
"mcp__Gmail__delete_label",
"mcp__Gmail__mark_message_spam",
"mcp__Gmail__mark_thread_spam",
"mcp__Google_Drive__trash_file"
```
> Note on send: the **native Gmail connector exposes no send/reply/forward tool** (only drafts), so
> `mcp__Gmail__send_message/reply/forward` are belt-and-braces; the real send path is **composio
> `GMAIL_SEND*`** — that deny is the one that matters. If a seat does Gmail through the native
> connector only, the composio denies are harmless; if through composio, they are essential.

## Per-seat Gmail additions (on top of the common core)
Victoria's matrix. "Read" = `search_threads`, `get_thread`, `list_labels`. "Label" = `label_thread`,
`unlabel_thread`. "Draft" = `create_draft`.

| Order | Seat | Read | Label | Draft | Peter-only | Notes |
|---|---|---|---|---|---|---|
| 1 | **Peter** | ✅ | ✅ | ✅ | `create_label` + INBOX unlabel | triage seat |
| 2 | **Rachel** | ✅ | ✅ | ✅ | — | **pre-check mode first (run works)** |
| 3 | **John** | ✅ | ✅ | ✅ | — | |
| 4 | **Alex** | ✅ | ❓ confirm | ❌ | — | read-only? confirm if Alex marks FG/Done |
| 5 | **Eugene** | ✅ | ✅ | ✅ | — | full block below; send already denied |
| 6 | **Helen** | ✅ | ✅ | ✅ | — | **remove blanket composio-GMAIL deny** (AWT-0890) |
| 7 | **Darius** | ✅ | ✅ | ✅ | — | **remove deny on create_draft/label (AWT-0890)** |
| 8 | **Anna** | ✅ | ✅ | ✅ | — | **private repo — read live file first** |
| 9 | **Sarah** | ✅ | ❓ confirm | ❌ **keep DENIED** | — | **private; read-only — create_draft stays denied** |
| 10 | **Nadia** | ✅ | ✅ | ✅ | — | Drive/Smartsheet **already done** (`0ea8dc4`); add Gmail only |

Gmail allow-tool names: `mcp__Gmail__search_threads`, `mcp__Gmail__get_thread`,
`mcp__Gmail__list_labels`, `mcp__Gmail__label_thread`, `mcp__Gmail__unlabel_thread`,
`mcp__Gmail__create_draft`; Peter also `mcp__Gmail__create_label`, `mcp__Gmail__unlabel_thread`
for INBOX removal (Peter's archive step, AWT-0873).

## Special cases (not purely additive)
- **Darius (`minda-ui/Darius`)** — his `.claude/settings.json` currently **denies**
  `mcp__Gmail__create_draft`, `update_draft`, `label_thread`, `unlabel_thread`,
  `update_message_labels` and composio `GMAIL_LIST/SEARCH/GET` (AWT-0890). His charter v37 (ops@ read +
  create_draft + FG/Done labelling) needs `create_draft` and `label_thread`. **Remove those deny
  entries**, add them to `allow`. Keep denied: send/reply/forward, `delete_draft`, trash, `delete_label`,
  mark spam. His git `CLAUDE.md` still says "no Gmail" (stale vs Drive v37) — sync it (separate, AWT-0890).
- **Helen (`minda-ui/Helen`)** — currently denies `Bash(composio execute GMAIL_*)` wholesale. If Helen's
  ops@ Gmail runs through **composio**, that blocks everything; through the **native** connector it does
  not. **Confirm Helen's Gmail path**, then narrow the deny to send/reply/forward/delete only.
- **Anna / Sarah** — private repos, not read. Open each, read the live `.claude/settings.json`, apply the
  common core; **Sarah is read-only → `create_draft` stays DENIED**; confirm Alex/Sarah `label_thread`
  (do they mark FG/Done?).
- **Rachel** — her run already works; **confirm she needs this at all** before editing (mode pre-check).

## Eugene's exact block (`minda-ui/Eugene`, `.claude/settings.json`)
Eugene already has the three `composio` allow rules **and** the Gmail send/reply/forward denies (added
per charter §1 on 2026-10-08). **Discrepancy to note:** AWT-0890 item 5 says "Eugene's own settings:
no deny rules" — that is stale; the send-block is present. Apply this full `permissions` object (the
rest of the file — `hooks`, `enabledMcpjsonServers` — is unchanged):
```json
"permissions": {
  "allow": [
    "Bash(composio execute *)",
    "Bash(composio connections remove *)",
    "Bash(composio link *)",
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
    "mcp__Smartsheet__find_in_sheet",
    "mcp__Gmail__search_threads",
    "mcp__Gmail__get_thread",
    "mcp__Gmail__list_labels",
    "mcp__Gmail__label_thread",
    "mcp__Gmail__unlabel_thread",
    "mcp__Gmail__create_draft"
  ],
  "deny": [
    "Bash(composio execute GMAIL_SEND*)",
    "Bash(composio execute GMAIL_REPLY*)",
    "Bash(composio execute GMAIL_FORWARD*)",
    "mcp__Gmail__send_message",
    "mcp__Gmail__reply",
    "mcp__Gmail__forward",
    "mcp__Gmail__delete_draft",
    "mcp__Gmail__trash_message",
    "mcp__Gmail__trash_thread",
    "mcp__Gmail__delete_label",
    "mcp__Gmail__mark_message_spam",
    "mcp__Gmail__mark_thread_spam",
    "mcp__Google_Drive__trash_file"
  ]
}
```
> Eugene's send-block stays as-is (it is already stricter than "policy-only"); Minda's 18-Oct ruling to
> keep the group send-block policy-only until the 26-Oct review does not require removing Eugene's
> existing deny — leave it in place.

## How to apply each repo (attended)
For each seat in the order above that the pre-check says needs it:
1. Open the repo; read the live `.claude/settings.json`.
2. Merge the common-core `allow` additions + the seat's Gmail tools; add any missing "keep denied"
   entries; for Darius/Helen also **remove** the deny entries named above.
3. Commit to a branch and open a PR, or commit to `main` directly in the attended session
   (the Self-Modification guard is why this is attended, ~15 min per few repos).
4. Merge to `main`.

## Verify after merge (Rule C — the mirror, not the PR label)
For each repo: `git fetch origin main && git show origin/main:.claude/settings.json` and confirm the
allow block is present (and Darius/Helen denies removed). **Do not trust the PR's merged label alone.**

## Report (AWT-0896 deliverable)
On the Hub row, one line per seat: **repo, commit, merged yes/no** (and "skipped — bypass/auto" where
that applies). Then **Rule F**: once applied, broadcast a one-line note to each seat's Raw that its
settings were updated (Eugene can prepare those Raw notes once Minda confirms the merges).

## Open items to confirm with Victoria
- Alex & Sarah `label_thread` grant (do they mark FG/Done?); Sarah `create_draft` stays denied.
- Helen's Gmail path (composio vs native) to size the deny.
- Anna/Sarah live `settings.json` (private repos).
- The AWT-0890 "Eugene has no deny rules" line is stale — Eugene's send-block is already present.
