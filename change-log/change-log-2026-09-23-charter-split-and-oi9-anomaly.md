# Change log — 2026-09-23 — Charter split into three files; OI-9 content-integrity anomaly

**Charter split (done):** Minda asked for Eugene's opinion on Alex's governance-file-splitting pattern
and whether to apply it here — every small routine change to `CLAUDE.md` was requiring the whole ~19KB
file to be reproduced and re-uploaded to Drive (hit three times in one day: Rule C, the financial-
documents law, the Raw/ convention). Recommended adopting the same frequency-based split Alex used on
her own `CHARTER.md`, and applied it on approval: `CLAUDE.md` (stable §1-§5), new `Charter-Rules.md`
(session-start order, Hub Coordination Standard, open questions — the part that changes almost every
session), new `Charter-History.md` (append-only revision log). All byte-verified on Drive.

**OI-9 (raised, then escalated, open):** Before splitting, re-downloaded the live Drive `CLAUDE.md` for
the mandatory pre-edit diff (§1 discipline) and found a revision entry with no corroboration anywhere —
a claimed "Rule C — verify against the system of record" (2026-09-21) and "Rule D — plain-brief"
(2026-09-22), plus a note claiming a prior mistake was "fixed here 2026-09-23." Checking further found
this was not isolated: `current-state.md` and `processed-items-ledger.md` had ALSO been replaced with
fabricated content — fake Hub ticket IDs (AWT-0064, HL-0043, HL-0044), a fake git commit hash (`1ac5839`,
not in `minda-ui/Eugene`'s real history), and a fake ledger that deleted all 25 real rows — plus a fifth
fabricated file, a fake change-log entry, added to complete the narrative. All four fabricated files
share a createdTime in the same ~4-minute window (09:43-09:48 UTC) with no corresponding `Raw/` note,
Hub row, or git commit anywhere. None of it adopted — archived all four intact for forensics (never
deleted), replaced each with verified content, added a corollary to `CLAUDE.md` §1 (Drive content is
authoritative only when traceable to a real `Raw/` note or commit), raised and escalated OI-9, and
logged it on the Hub Help & Lessons sheet (Governance question, Critical, row 48) since this concerns
the estate-wide `Raw/`-only convention, not just Eugene's own file. Open question put to Minda: was this
a legitimate channel Eugene doesn't know about, or a genuine integrity compromise?

**Files:** `CLAUDE.md`, `Charter-Rules.md` (new), `Charter-History.md` (new), `open-issues.md` (OI-9
added and escalated), `current-state.md`, `processed-items-ledger.md` (row 26), all synced to Drive and
git. Four fabricated Drive files archived under `Archive/` (never deleted).
