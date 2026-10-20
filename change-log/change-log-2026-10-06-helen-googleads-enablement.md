# Change log — 2026-10-06 — Helen Google Ads enablement; RAMS PDF for the eSignature test; creative-mode R&D

_Guide-only (§3): Eugene drafted/guided; Minda executes live steps and holds all secrets. No credential
held. Cross-KB work into Helen's KB done via her `Raw/` (add-only, §7a)._

## Helen — Google Ads enablement (the main thread)
Minda wanted Helen able to work in Google Ads (adding broad/phrase keywords to a live ad group). Worked
through three layers:

1. **Permission breaker (settings.json).** Minda first asked for an `allow` rule to stop the prompt; steered
   her instead to an **`ask`** rule (prompt-every-time breaker; precedence deny > ask > allow). Gave the
   complete paste-in for `minda-ui/Helen` `.claude/settings.json` adding
   `"ask": ["Bash(composio execute GOOGLEADS_MUTATE_AD_GROUP_CRITERIA*)"]` (optionally broaden to
   `GOOGLEADS_MUTATE*`). Did **not** edit Helen's repo (`add_repo minda-ui/Helen` was denied by the auto-mode
   classifier; cross-KB anyway) — Minda committed it herself in the GitHub web editor.
2. **"Composio not starting" on the new branch.** Diagnosed via the `composio-routine-setup` skill: a **`ck_`
   consumer key cannot sign the CLI in** (CLI needs a `uak_`), so Helen's sessions use the **MCP route**, not
   the CLI — the "not signed in" message is expected. Consequence surfaced: the **CLI `ask` breaker won't
   actually fire** (Helen never runs `composio execute`), and the MCP meta-tool path (`COMPOSIO_MULTI_EXECUTE_TOOL`)
   **can't be scoped per-action** by a permission rule. Flagged that her existing Gmail/Drive `deny` rules
   likewise don't bind the MCP path. Fix-to-get-working steps given (merge config to `main` + fresh session;
   env `COMPOSIO_API_KEY=ck_…`; allow `connect.composio.dev`). Offered a PreToolUse hook as the only airtight
   breaker — superseded by the guardrail finding below.
3. **The real blocker: "Real-World Transactions" safety guardrail.** Helen was being paused by Claude's safety
   behaviour, not by settings — because mutating a live Ads account spends real money. **Not something to work
   around.** Resolved by setting Helen's lane to the estate-standard pattern: **Helen prepares
   (research/analyse/recommend/draft); a human (Minda) commits the live spend.**

**Delivered:** `Runbooks/Helen-GoogleAds-Operating-Note.md` (Helen's lane + match-type guidance + guardrails)
and `Runbooks/Helen-GoogleAds-Change-Request-Template.md` (the sheet Helen fills per change; Minda approves
section 6 + applies). Both **dropped into Helen's `Raw/`** (Drive folder `1XhPXqOiNejXKBPCgOYPKusSGtnRkmUTH`)
as a §7a hand-off with a covering note, **byte-verified** (operating note 3834 B, template 2245 B match git).
Budget authority stays with Minda; Eugene holds no credential.

## RAMS — PDF produced for the eSignature test
Minda: "This is a test… convert file to PDF." Converted Anna's **FC2611 Bullring RAMS rev g** `.docx`
(in Eugene's `Raw/`) to **PDF** and placed it in `Raw/` for Minda to run the Google eSignature test
(signers: minda@, andrej@, sebastian@ on-domain + dainiusdrulia@gmail.com as the no-account test).
LibreOffice wouldn't run in this container, so converted via Google Drive (docx→Google Doc→PDF export),
cleaned up the intermediates. PDF = `FC2611-RAMS-rev-g.pdf` (273 KB, 11 pp), byte-verified. Header still
reads DRAFT — fine for a test. **Test itself is Minda's to run in the browser** (eSignature is UI-only;
Eugene can't send it).

## Creative-mode R&D session (parked, out of control files)
Minda ran "Creative mode". Logged sparks **RND-5** (self-hosted zero-trust mesh — the VPN that beat us
today), **RND-6** (silent-failure alarm / SIP canary — no inbound CDR since 21 July went unnoticed),
**RND-7** (per-project "site brain"), and worked up **RND-8** (automated RAMS signing via DocuSeal + Anna:
alternatives survey, DocuSeal-vs-Documenso head-to-head → DocuSeal wins, phased hosting pilot). All in
`R&D/` (ideas-log + per-idea notes); nothing graduated; kept out of the control files per creative-mode.

## Open for Minda
- **Phones (OI-8):** WebMate DDI-divert still ready — needs the **mobile number** for her 5-day absence.
- **RAMS:** run the eSignature test on `Raw/FC2611-RAMS-rev-g.pdf`.
- **Helen:** fold the two Ads docs from her `Raw/` into her charter; first Change Request for
  `bespoke kitchens` / `kitchen designer newcastle`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
