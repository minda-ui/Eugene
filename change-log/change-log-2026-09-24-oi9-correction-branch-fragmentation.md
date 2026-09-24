# Change log — 2026-09-24 — OI-9 corrected: misdiagnosis, not an incident

**Session-start Hub check (Rule A)** found real, closed Hub rows — AWT-0060, AWT-0062, AWT-0064,
HL-0043, HL-0044 — with content matching, almost verbatim, what the 2026-09-23 session had archived
yesterday as "fabricated" (OI-9).

**Investigated with `git fetch --all` + `git log --all`:** confirmed commit `1ac5839` ("Sync charter
with Drive; fix Rule C/D fold-in clash (AWT-0064)") is real, sitting on a sibling branch
(`claude/beautiful-allen-mg6blz`) from a parallel Eugene session that this session's local clone had
never fetched. Root cause: every Claude Code session — interactive or scheduled Hub check-in — gets its
own auto-generated git branch off `minda-ui/Eugene`; branches never auto-merge into `main` or each
other. At least 7 sibling branches exist. The parallel session had correctly restored a real
**Rule C — verify against the system of record** (added 2026-09-21, a real owner ruling delivered via
Alex's Raw/ hand-off that the 2026-09-23 branch's history simply never received) after an earlier
fold-in mistake overwrote it, and correctly relabelled the group's plain-brief rule as **Rule D**. The
2026-09-23 session checked only its own branch and `Raw/` folder, found no corroboration, and concluded
— wrongly — that the content was unauthorised or fabricated. It archived the real fix and reconstructed
the charter from stale knowledge, reintroducing the exact Rule C/D clash the other session had fixed.

**Corrected:**
- Real Rule C (verify against system of record) restored in `Charter-Rules.md`; plain-brief correctly
  relabelled Rule D. Rules A-D now match the real, owner-ruled history.
- `CLAUDE.md` §1 and `Charter-Rules.md` Rule C itself now require checking sibling git branches
  (`git fetch --all` + `git log --all`) before treating unfamiliar Drive content as anomalous.
- `Charter-History.md` carries a 2026-09-24 correction entry; the 2026-09-22/23 entries are left exactly
  as originally written (an honest record of what was believed at the time), per the file's append-only
  discipline.
- `open-issues.md`: **OI-9 resolved** as a misdiagnosis; **OI-10 raised** (open, advisory) — the real,
  durable finding: parallel sessions on isolated branches create genuine risk of duplicate work (AWT-0062
  was independently completed twice, harmlessly) and false anomaly alarms (OI-9 itself). Open question
  for Minda: consolidate branches periodically, or accept per-session isolation with Drive as the sole
  shared source of truth.
- Hub Help & Lessons row 48 corrected from Critical/Open to Medium/Resolved, with the real root cause
  and fix recorded under "what to do next time."

Nothing was lost — the files archived yesterday as "anomalous" were the real fix all along; both are now
reconciled and Drive/git are current.

**Also:** session-start Hub check found new row **AWT-0084** (Alex → Eugene, Medium) — fold two
Authority Register rulings into the charter. In progress, next.

**Files:** `CLAUDE.md`, `Charter-Rules.md`, `Charter-History.md`, `open-issues.md` (OI-9 resolved,
OI-10 raised), `current-state.md`, `processed-items-ledger.md` (row 27), all synced to Drive and git.
Hub Help & Lessons row 48 corrected.
