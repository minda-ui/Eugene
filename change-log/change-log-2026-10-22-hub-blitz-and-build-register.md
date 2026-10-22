# Change log — 2026-10-22 — Morning Hub blitz + Build Register v1

Session-start Hub check (Rule A) found 18 open Eugene rows; Minda asked to triage and work the actionable
set, then build the Build Register. Guide-only throughout (§3): Eugene authored prompts/skills/register and
verified settings; Minda pastes live routine prompts and makes any access/dashboard/backup change.

## Closed Done
- **AWT-0905 + AWT-0919** — Peter mail-triage routine prompt **v0.3** (one paste-ready replacement), matched
  to procedure **v0.5 §4 step 3**: archive closed FG/Marketing, FG/Auto-reply, FG/Info (class alone) and
  FG/Notice only from the 8-sender list; first-pass backlog since 18 Oct; explicit re-triage-on-new-message
  rule. `Runbooks/Routine-Prompt-Peter-MailTriage-v0.3.md` (git + Drive `1iuangpl…`). Minda pastes.
- **AWT-0910** — ops@ triage **is running** (175 FG/Done, 143 closed-by-rule, 116 marketing archived,
  labelling as recent as 00:31 today). The 20-Oct "~48 unlabelled" was a go-live catch-up backlog, now
  cleared to 3 fresh arrivals awaiting the next pass. Flagged a live Lathams-solicitor thread (un-routed,
  <1h old). Peter may label the backlog freely.
- **AWT-0843** — `create_draft` proven live (today's Techbuyer + compuwyze drafts); scheduled-run
  skill-loading already proven; routing of corrected skills = **via Victoria** (Minda's call).
- **AWT-0778** — Composio Drive-connection findings folded into the Build Register §5.

## Advanced
- **AWT-0890** — verified on `origin/main`: Darius/Helen broad `GMAIL_*` deny removed, send/delete kept,
  create_draft+label restored; Anna no conflicts; Sarah mail read-only (create_draft denied) but writes
  reports. Residual: Rule-F Raw notes + Darius git CLAUDE.md sync (delivered as hand-offs below).
- **AWT-0859** — item 2 applied (`drive-sync-verified` MCP-fallback section); CLI-silence answered (ck_ key
  can't sign the interactive CLI in → use MCP route); items 1 & 3 authored and handed off.
- **AWT-0834** — Darius Raw id resolved = the shared **Workshop KB Raw** `18P2Gz64…` (he has no own Raw →
  OI-25). Still open: verify remaining seats + build the 10-seat session-start register.
- **AWT-0775** — Build Register v1 built (see below).

## Raised / new
- **OI-25** — every employee should own its `Raw/` folder, not share a company KB's (Minda's ruling,
  surfaced by Darius). Employee-KB structure is Victoria's domain; Eugene raised, did not restructure.
- **Five cross-KB Raw hand-offs** (byte-verified) + Hub rows **AWT-0941–0945** (no duplicate-guard flag):
  Victoria (OI-25), Darius (settings verified + sync git CLAUDE.md to Drive v37), Helen (settings
  heads-up), Anna (routine → Composio MCP + per-call account), Alex (shared-skills tool notes).

## Build Register v1 (AWT-0775 / AWT-0778)
`Runbooks/Build-Register-and-Ecosystem-Protection-AWT-0775.md` (git + Drive `1MMWHH9iqtY…`). Five-dimension
inventory in Build-Register shape (name/type/owner/where/created/status/last-checked): 11 assistants;
routines (known set + the 18-Oct-retired ones; Quarterly sweep not-built); knowledge systems (KBs, repos,
Hub + 7 sheet ids, AMFA CRM, Project Delivery + register ids, Financial Archive, shared-skills repo); skills
(11 Eugene-own + 8 shared + SC-8 adopted); connections (Composio Drive×14/Gmail/GitHub/Smartsheet/ck_ key/
Tailscale). Plus a 7-row SPOF + backup-posture table and a draft read-only **Quarterly-sweep** routine
prompt. Residual (due 29 Oct): confirm the exact live routine + per-account Drive connection lists, then
create the Quarterly sweep in the form.

## Residuals needing Minda/Victoria
- Paste Peter prompt v0.3 into his routine.
- AWT-0834: Darius Raw now known — remaining = verify the other 6 seats + the 10-seat register.
- OI-25 / AWT-0941: Victoria to decide per-employee Raw folders.
- AWT-0778 dashboard actions: alias the default Drive account, dedupe `sarah-googledrive`, confirm the 10-cap.

Commits (pushed): dc94dfa, f216c24, 4937bcc, 2eafb8c, 5026844.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
