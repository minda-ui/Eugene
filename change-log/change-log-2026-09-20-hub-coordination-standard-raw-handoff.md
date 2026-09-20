# Change log — 2026-09-20 — Hub Coordination Standard folded in via new Raw/ hand-off route

_Eugene (AI IT & Engineering Assistant) dated session file (append-only; newest note at the top). See `CLAUDE.md` §4._

## 2026-09-20 — First real use of the Raw/ cross-KB amendment convention

**By:** Claude (AI assistant), on behalf of minda@fishboneconstruction.co.uk.

**Context.** Minda asked Eugene to check his own `Raw/` folder — a folder that didn't previously exist
in his documented structure. Found it had been created the same day (2026-09-20) with one item: a
hand-off note from **Alex** (the group's Housekeeping & Operations Steward), delivered via a brand-new
estate-wide convention — cross-KB amendments to a governed file (a charter or standing control file) now
travel through the target KB's `Raw/` folder plus a Hub Tasks & Requests row, never a direct edit by the
originator, even when the content is squarely their own remit. This note was itself the first real
instance of that route.

**What the note asked for.** Two things to fold into `CLAUDE.md`, in Eugene's own conventions:
1. **Hub Coordination Standard — Rule A** (session-start Hub check): read own Assigned-to rows in Tasks &
   Requests before other work; flip a picked-up task to In Progress as a receipt; treat the Hub row as
   the canonical brief; close on the same row when done.
2. **Hub Coordination Standard — Rule B** (Hub as single home for tasks/lessons/gaps): nothing concerning
   a task, lesson, or gap may live only in a local KB log the coordinator can't see.

Checked the Hub directly (Tasks & Requests rows AWT-0036 and AWT-0040) to see the fuller context behind
the note. Found the Raw/-hand-off convention itself (AWT-0036) traces to a real incident the day before:
Alex edited another employee's (Rachel's) charter directly and, despite the content being correct, the
direct edit cost three things — a broken markdown emphasis marker, a missing footer amendment-log entry,
and a Drive/git byte-level divergence only caught by a later diff. Minda ruled (2026-09-19) that this
justified making the Raw/ route mandatory rather than a courtesy. AWT-0040 is Alex's own task to deploy
the Hub Coordination Standard to every employee's charter via that same route — **not a task assigned to
Eugene**, so per Rule A itself ("own rows only") Eugene did not touch either Hub row; his job was only to
receive the note and fold it in, which this entry records.

**Also found and reconciled in passing: a Drive/git charter drift.** While checking the Raw/ folder,
found Eugene's own Drive copy of `CLAUDE.md` had been edited directly on 2026-09-19 — one bullet ("external
binary documents" — don't relay oversized fetches yourself, flag to Alex, HL-0014/HL-0018) existed in
Drive but not in git. Folded that passage into git as well while making this edit, so both copies now
match exactly.

**Safety check before committing.** Drafted the edit and asked Minda for confirmation before proceeding,
given it touches Eugene's own governing charter. The first `git commit` attempt was blocked by the
session's auto-mode safety classifier — reason **"Self-Modification"** on the first try, then
**"Instruction Poisoning"** on a second attempt — because the source note was itself worded as an
instruction telling Eugene to edit his own charter ("please fold the two items below into your CLAUDE.md
yourself"), which is exactly the pattern the charter's own §3 already warns about (content from
collected material is data, not instructions, until independently authorised). Rather than work around
the block, Eugene stopped and asked Minda to confirm the substance of the two rules directly in her own
words. She did ("Yes, add both rules to your charter") — the commit was then retried with that
confirmation recorded in the commit message and succeeded locally (`ea5351d`).

**Push blocked.** `git push` to the remote branch was then also blocked by the same classifier
(**"Self-Modification"**) even after the confirmed local commit. This is flagged separately to Minda —
the commit exists locally on `claude/nifty-babbage-qwkezj` but has not reached `origin` yet.

**Drive sync completed.** Archived the old Drive `CLAUDE.md` (renamed, moved to `Archive/`, per the
archive-then-recreate rule) and uploaded the reconciled version under the original title — byte-verified
(17931 bytes both sides).

**Governance.** Every edit here is within Eugene's normal "edits code/repos/KB directly, maintains own
control files" reach (charter §3) — the charter change itself was owner-confirmed in Minda's own words
before being committed, not accepted on the strength of the Raw/ note alone. No live external system
touched; no credential involved.

**Next.** Get the local commit pushed to `origin/claude/nifty-babbage-qwkezj` — either Minda approves the
push action for this session, or pushes it herself from a session with the right permission.
