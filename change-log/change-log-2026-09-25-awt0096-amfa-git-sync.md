# Change log — 2026-09-25 — AWT-0096: Amfa git-sync gap fixed; AWT-0101 investigated, parked

Good-morning session-start Hub check (Rule A) found 4 open rows assigned to Eugene: AWT-0060
(carryover, still Blocked — Anna repo still empty), AWT-0090 (carryover, In Progress), and two new
since yesterday — **AWT-0096** and **AWT-0101**. Minda asked to start AWT-0096 first.

## AWT-0096 — Amfa git-sync gap

Self-flagged yesterday during the Nadia build: `minda-ui/Amfa-Furniture-Ltd` `main` held only the
SessionStart-hook scaffold, none of the KB's real Drive content had ever synced, despite `CLAUDE.md`
§1 naming a branch that didn't match reality. The Hub row offered a choice ("either sync the content,
or correct the documentation") — did the substantive fix.

**Investigated first:** enumerated the whole live (non-Archive) Drive tree for the Amfa KB — root,
`Raw/`, `Wiki/` (all subfolders), `Outputs/`, `Outputs/Correspondence/` — to scope exactly what needed
fetching, deliberately excluding Nadia's own identity files (`CHARTER.md`, `Drafts/`, routine prompts),
which correctly live only in the separate `minda-ui/Nadia` repo per her charter §5.

**Delegated the fetch** (29 files, including a jpg, a pdf and an xlsx) to a background agent with an
explicit path/byte-size table. It caught and self-corrected one instruction error on Eugene's part (a
copy-pasted byte count for `incoming-paper-mail-handling.md`) by fetching against the Drive file's real
metadata rather than trusting the stated size — all 29 files byte-verified exact.

**Committed and pushed clean** to `minda-ui/Amfa-Furniture-Ltd` `main` (`194d671`) — no classifier
block this time, confirming yesterday's "Instruction Poisoning"/"External System Writes" denials were
specific to that batch (which had included `CHARTER.md`), not to Eugene's writes into this repo in
general.

**Corrected `CLAUDE.md` §1's git-mirror line**, which named a stale branch
(`claude/amfa-furniture-kb-setup-bva2js`) that was never actually the live mirror — now correctly says
`main`, with a note explaining why Nadia's identity files are deliberately excluded from this repo.
Re-synced to Drive, archive-then-recreate, byte-verified (30745 → 31314 bytes).

Hub AWT-0096 closed **Done**.

## AWT-0101 — Alex's cross-login Properties routine audit (parked)

Minda asked to start this next. Investigated before building, rather than taking the brief's assumed
mechanism ("via `create_session` with the right environment_id") at face value:

- `list_environments` on this account: 19 environments, none for Fishbone Properties Ltd — every other
  company (Construction, Holdings, Waste, SSAS, Amfa) has one; Properties conspicuously doesn't.
- `list_triggers` (routines) on this account: exactly 16, independently re-counted (not just trusting
  Alex's AX-15 finding), none of them John's or Properties'.
- Read Alex's own `open-issues.md` AX-15 in full for the precise technical claim: Properties' cloud
  routines run under `ops@fishboneproperties.co.uk`, a genuinely separate Google/claude.ai login —
  reviewing them needs "a session signed in as that login specifically, not the group login."

**Conclusion:** this is a different Anthropic account, not a connector or environment setting within
this one. No tool available to any session in this account (Eugene's, Alex's, anyone's) can create a
session or read a routine list inside a different account — so "build Alex a second environment on
that login" isn't executable from here at all. It needs whoever holds that separate login (Minda,
per Victoria's digest — she's the one already pasting John's routine prompts there for AWT-0099/0100).

**Proposed to Minda:** given the ruled scope is already attended/periodic, the workable design is a
human-conduit one — whoever holds that login periodically logs in, runs a short audit prompt Eugene
would draft, and logs findings back to Alex's KB. **Minda asked to hold this while she runs some tests
and will come back.** Hub AWT-0101 updated to Blocked with the full investigation write-up recorded,
not built further.

**Files:** `minda-ui/Amfa-Furniture-Ltd` (29 files + corrected `CLAUDE.md`, pushed), Amfa KB `CLAUDE.md`
(Drive, re-synced), `processed-items-ledger.md` (row 35), `current-state.md`, Hub AWT-0096 (Done),
Hub AWT-0101 (Blocked, parked).
