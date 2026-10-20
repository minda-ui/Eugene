# Change log — 2026-10-12 (evening) — Sarah go-live prep + flag to Alex

_Guide-only (§3): Eugene checked state, wrote a runbook, and delivered a cross-KB flag; all live go-live
steps remain Minda's/Alex's. No secret held. Same session as the DocuSeal SMTP + wire-Anna hand-off._

## What Minda asked
Progress Sarah (Fishbone Group compliance officer) toward go-live: check the seed repo, write the connector
steps, check AWT-0521, and flag Alex.

## What was found (Rule C — read the live systems, incl. sibling sessions' work)
- **`minda-ui/sarah` repo already EXISTS + SEEDED** — by another session, not this one (cloned to verify):
  `main` @ `a0bef09` ("Record CDM clauses PM-6.11 to 6.14 as enforceable"), later `d053d12`. Holds the
  **governance-files-only** set (CHARTER, Charter-Rules, Charter-History, README, current-state, open-issues,
  external-source-register) — **complete by design** (findings-log, processed-items-ledger, Raw/Wiki/Outputs/
  Archive are Drive-only per her README/charter). So AWT-0520's "seed the repo" item was already done.
- **Sarah's connectors are DONE 2026-10-12** (per her `current-state.md` @ d053d12): **Drive** = Composio
  `sarah-googledrive` ACTIVE (Minda's Google account, read-tested); **Smartsheet** = session connector **as
  `minda@`** (Composio has no Smartsheet toolkit), Hub read-tested. Read-only / write-limits are
  charter-enforced (estate norm: all assistants use Smartsheet as minda@).
- **AWT-0521** (Alex): **Roster row + Authority Register grant already done.** Only the Hub **Assigned-to /
  Raised-by picklist add** is left, which Alex noted was waiting on *"Eugene's flag (Sarah's Hub login)."*

## What Eugene did
1. **Updated Hub AWT-0520** (own row) — recorded the repo as seeded (item 1 done), trimmed the remaining
   go-live items to connectors/Hub-login/Authority/open-seat; status left In Progress.
2. **Wrote `Runbooks/Runbook-Sarah-Connector-Setup.md`** — Drive + Smartsheet read-only, no Gmail/QuickBooks,
   with the identity decision + a belt-and-braces settings.json deny. **Now superseded** by the actual (done)
   setup — kept for the record.
3. **Flagged Alex** that Sarah's Hub access prerequisite is met → the picklist add can proceed:
   - Raw note `Eugene-to-Alex-Sarah-HubAccess-Ready-AWT0521-2026-10-12.md` into **Alex's KB `Raw/`**
     (`1khvHcmK-x2IE9L7NAv-wWammuDQtvuq3`), byte-verified **OK** (2945 B, md5 match, round-trip identical,
     0 U+FFFD). Drive id **`11k5eyFjJeK7Go4ztBuvBJzvs3ljy0BCh`**.
   - **Hub Tasks row `AWT-0594`** (Assigned to Alex, Open). ⚠️ First landed on **AWT-0590** → the Hub's
     duplicate-guard caught it (a concurrent session had created 0590–0593 since Eugene's AWT-0589 earlier
     today); renumbered to the next free, **AWT-0594**. Lesson reinforced: always re-check max AWT at write
     time — parallel sessions move it.

## Sarah go-live state at sign-off
Done: procedure v1.0 approved · scaffold + repo seeded · CDM clauses recorded · **connectors done**.
**Left (neither Eugene's):** (a) **Alex** adds "Sarah" to the Hub picklists (now unblocked — AWT-0594);
(b) **Minda opens Sarah's seat**. First work when live = Anna's FC2611 RAMS, with Minda present.

## Artefacts
`Runbooks/Runbook-Sarah-Connector-Setup.md`, Alex KB `Raw/` (Drive `11k5eyFjJeK7Go4ztBuvBJzvs3ljy0BCh`),
Hub `AWT-0520`/`AWT-0521`/`AWT-0594`, ledger row 105, `current-state.md`.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
