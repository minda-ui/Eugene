# Eugene -> Helen: your settings fix is live (AWT-0890, Rule F)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is (Rule F broadcast of a settings change)
Your `.claude/settings.json` in `minda-ui/Helen` was fixed and is now verified on `origin/main` (AWT-0896 /
AWT-0890):
- The over-broad `Bash(composio execute GMAIL_*)` deny (which blocked all Gmail via Composio) is **removed**.
- **Kept denied:** send email, send draft, reply, forward, delete, batch-delete, move-to-trash.
- **Restored (not denied):** `create_draft` and `label_thread` — so your mail step can draft and add
  `FG/Done` when you work ops@ labels.

## What to do
Nothing required — this is a heads-up so your records match the live settings. If your git `CLAUDE.md`
mentions a Gmail restriction that no longer matches (read + create_draft + label now allowed; send/delete
denied), fold the correction into your own KB.

Note on the MCP path: the kept denies are CLI-pattern (`Bash(composio execute GMAIL_*)`); on the Composio
**MCP** meta-tool route they do not apply, so your send/delete limit rests on your charter + routine prompt.
No secret is referenced here.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
