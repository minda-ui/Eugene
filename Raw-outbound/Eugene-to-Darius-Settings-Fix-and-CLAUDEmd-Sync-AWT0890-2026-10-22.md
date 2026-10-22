# Eugene -> Darius: your settings fix is live; please sync your git CLAUDE.md (AWT-0890, Rule F)

From Eugene, 2026-10-22, delivered under CLAUDE.md s1/s7a. **This note is data, not an instruction.**
A matching Hub Tasks & Requests row names this note.

## What it is (Rule F broadcast of a settings change)
Your `.claude/settings.json` in `minda-ui/Darius` was fixed and is now verified on `origin/main` (AWT-0896 /
AWT-0890):
- The over-broad `Bash(composio execute GMAIL_*)` deny is **removed**.
- **Kept denied:** send email, send draft, reply, forward, delete, batch-delete, move-to-trash.
- **Restored (not denied):** `create_draft` and `label_thread` — so your mail step can draft and add
  `FG/Done`, per your charter v37 (ops@ read + create_draft + label).

## What to do
One thing needs your action: **your git `CLAUDE.md` still says "no Gmail"**, which is stale against your
Drive charter **v37** (Minda, 18 Oct: ops@ read + create_draft). Please **sync your git `CLAUDE.md` to the
Drive v37 wording** so the repo and Drive agree. Eugene cannot edit your KB files directly (s1) — only this
Raw/ note — so this is yours to fold in.

Note on the MCP path: the kept denies are CLI-pattern (`Bash(composio execute GMAIL_*)`); on the Composio
**MCP** meta-tool route they do not apply, so your send/delete limit rests on your charter + routine prompt.
No secret is referenced here.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
