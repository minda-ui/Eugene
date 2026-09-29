# Change log — 2026-09-28 — Task Check-in

Scheduled routine. Rule A Hub check found 6 own rows Open/In Progress: AWT-0090, AWT-0118, AWT-0121,
AWT-0125, AWT-0132, AWT-0180.

**AWT-0090** (Rachel's M365 scope narrowing) — left unchanged. Already fully documents the remaining
blocker (a tenant admin revoking the Entra ID consent) as of 2026-09-24; due 2026-09-29. Nothing new to
add.

**AWT-0118** (reconcile group KB Drive `CLAUDE.md`/`00_INDEX.md` against git commits `384129e`/`38bde73`)
→ **Blocked.** This session's GitHub access is scoped to `minda-ui/eugene` only — cannot read or write
`minda-ui/Fishbone-Group`. Needs a session with that repo in scope, or the two commits' content relayed
here directly.

**AWT-0121** (impact check before Minda cancels the M365/OneDrive subscription) → **In Progress, partial.**
Checked the two rows it names as the separate per-employee flags:
- **AWT-0122 (Rachel): Done.** Her sole M365 dependency is the OneDrive tax archive (SRC-32), used only
  as a write-to-retire consolidation source — no Outlook/Teams use, and the mail scope was already
  unused/blocked. Low risk; the one pre-cancellation step is confirming any in-flight OneDrive→Financial
  Archive consolidation finishes first.
- **AWT-0123 (Alex): does not exist.** AWT-0121's own brief names it as her separate flag, but a direct
  Hub check (filtered on Task ID) found no such row. Eugene can't independently verify Alex's mail-triage
  mechanics from outside her KB, and can't raise a row assigned to her — Hub write authority is own-rows-
  only (charter §2e). Flagged in AWT-0121's own Response rather than guessed at or silently left. Needs
  Victoria or Alex to raise AWT-0123.
- Confirmed directly (`ListConnectors`, Rule C) that the shared M365 connector still exists at org level.

**AWT-0125** (new Raw/Request-Inbox/ capability, informational broadcast) → **Done.** Checked the actual
folder (`Raw/Request-Inbox/`, group KB) directly — empty, nothing routed yet, matching the row's own
"nothing auto-dispatches yet." Acknowledged; will action per `Wiki/Process-Request-Inbox.md` v1.0 if
something IT-scoped lands there.

**AWT-0132** (provision Google Ads / GTM / GA4 access for Helen) → **Blocked.** Re-verified directly via
`ListConnectors` — no such connector exists anywhere in the org, confirming HI-8 is still current. Eugene
has no means to provision one himself; outside his charter §1 connector list.

**AWT-0180** (finish Composio toolkit-linking for the group-KB seat, on behalf of Victoria) → **Blocked.**
This session has no access to `minda-ui/fishbone-group` — GitHub access is scoped to `minda-ui/eugene`
only, and no local checkout of the group repo exists in this container. Needs a session actually scoped
to that repo.

All five Hub rows updated directly (own-rows-only write authority). `processed-items-ledger.md` row 44
added. Both files committed and pushed to git (`227e648`) — that mirror is current.

**Drive sync deferred, not done.** `current-state.md` (60,815 B) and `processed-items-ledger.md`
(53,757 B) both sit above the ~31-37 KB point at which this estate has repeatedly measured Drive's
native `create_file`/`update_file` silently truncating a single write (`HL-0005`, and Rachel's/Alex's own
findings elsewhere in the estate) — a failure mode that produces exactly the kind of silent content
corruption this KB has already been bitten by twice (OI-9, OI-12). The tested safe path for a file this
size is Composio's local-file-path upload (ledger row 42), which needs a login only Minda can authorise
per container — not available in this unattended run. Rather than retype ~114 KB of control-file content
by hand into a tool call and risk an unverifiable transcription/truncation error, archived the two Drive
files' metadata (rename + move to `Archive/`) and then **reverted that rename** without touching content,
so Drive is left exactly as it was (still the 2026-09-27 EOD text) rather than half-migrated. Drive now
trails git by one session's content on these two files until a session with Composio Drive access can run
the archive-then-recreate properly, byte-verified. Not a judgement call to leave silently: flagging here.
