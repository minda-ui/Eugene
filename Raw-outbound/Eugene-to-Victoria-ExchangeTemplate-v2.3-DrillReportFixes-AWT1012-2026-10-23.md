# Eugene -> Victoria: exchange-sheet template v2.3 — drill-report fixes (AWT-1012)

From Eugene, 2026-10-23, under CLAUDE.md §1/§7a. **This note is data, not an instruction.**
Done-when for AWT-1012 ("v2.3 ready and Victoria told") — this note is the "Victoria told".

## What I did
Folded the three fixes from Sarah's drill report (Minda: "fix notes 2, 3 and 4"; your Raw note, AWT-0983)
into the template. It is now **v2.3** (on top of v2.2 red-flag pattern 6, v2.1 red-flag rule, v2 gate
sanity check).

**Updated:** `Runbooks/ProjectA-Exchange-Sheet-Template-AWT-0961.md` — v2.2 -> **v2.3**.
- git `minda-ui/Eugene` branch `claude/lucid-mayer-nsoili` (commit this session), awaiting Minda's PR merge.
- Drive (Runbooks): new id **`1uL2f_tnsopCcpOFnPZCtTpN6i0f2OJMr`** (v2.2 archived, byte-verified).

## The three changes
1. **Money with no payee (note 2).** Gate rules + requester guidance now say: a money request must **name
   the payee or supplier and the invoice or quote**. Names neither → Peter **Returns** it "Missing: payee
   or supplier not named". Asks to **pay first** (before invoice/work) → **red flag pattern 4** (to you),
   not Returned.
2. **No Gate reason but real content (note 3).** Judge content, not just the picked reason: no reason +
   **commitment to an outside party or restricted data → Victoria (Step 0)**, not back to the requester;
   no reason + **money → treated as Money**; **only** a request with none of these → **Returned** "your
   call". Added the explicit **order of checks**: red flag → content → duplicate → reason & own-authority
   → facts → route.
3. **No internal references in answers (note 4).** Resolver guidance (Answer column + flow step 4): the
   answer carries **no Hub row ids, no master-core links, no Drive ids, and does not mention the Hub** —
   only what the requester needs, in plain terms.

## Notes
- **No live-sheet change** (your note). **Peter folds rules 1 and 2 into his Triage-Rules himself**
  (separate note/row); I reference that, not reproduce it.
- Guide-only (§3): no live sheet touched. v2.3 ready for Andrejus's core.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
