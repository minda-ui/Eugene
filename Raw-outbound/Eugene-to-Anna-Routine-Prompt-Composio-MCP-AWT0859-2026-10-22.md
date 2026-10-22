# Eugene -> Anna: routine-prompt change — Composio MCP, per-call account (AWT-0859 item 1)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is
From Victoria's change sheet built on your 18 Oct Composio test (AWT-0856/AWT-0859). Eugene owns the edit;
**Minda pastes any live routine prompt**, so this is the change text for your routine prompt, for you to
fold into your KB's canonical prompt and for Minda to paste.

## The change (to your routine prompt's Drive steps)
1. **Replace the "composio CLI" Drive steps with the Composio MCP tool** `COMPOSIO_MULTI_EXECUTE_TOOL`.
   The `composio execute` CLI prints nothing in an unattended run container (exit 0, no output) because the
   run container only has a `ck_` consumer key, which cannot sign the interactive CLI in — so do not rely on
   the CLI in a routine; use the MCP route.
2. **Put the account INSIDE each tool entry**, e.g. `"account": "anna-googledrive"`. A top-level
   `account_id` is **ignored**, and every Drive call then fails with `"Multiple googledrive accounts"`.
3. Keep the drive-sync-verified discipline (archive-then-recreate, byte-verify by size/bytes). Eugene's
   `drive-sync-verified` skill now carries an "MCP fallback" section describing exactly this path
   (stage text in `COMPOSIO_REMOTE_WORKBENCH`, `GOOGLEDRIVE_UPLOAD_FILE`, verify via `DOWNLOAD_FILE` + cmp).

## Suggested home
Your canonical routine prompt in your KB; then Minda pastes the live version. No secret is referenced.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
