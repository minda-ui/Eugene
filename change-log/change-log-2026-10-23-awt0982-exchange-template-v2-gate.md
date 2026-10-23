# Change log — 2026-10-23 — AWT-0982 exchange-sheet template v2 (gate sanity check)

## Summary
Folded Minda's approved **gate sanity check** (23 Oct, AWT-0980, relayed by Victoria) into the
Project-A exchange-sheet template, so routine work is done by the person and never reaches the gate.
Principle (Minda): *the master core is built to make decisions, not to solve other people's problems.*
Trigger was test request IR-0002 (share an EPC with an agent) — routine Properties work that wrongly
went through the gate to Minda.

## Sources read
- Victoria→Eugene Raw note `2026-10-23_Victoria-to-Eugene_gate-sanity-check_AWT-0980.md` (my Raw).
- Companion Victoria→Peter note `2026-10-23_Victoria-to-Peter_gate-sanity-check_AWT-0980.md` — for the
  exact own-authority list text (the Eugene note pointed to "Peter's note, same date").

## What changed in the template (v1 → v2)
`Runbooks/ProjectA-Exchange-Sheet-Template-AWT-0961.md`:
1. **Gate reason column (required)** — picklist Money / Legal / Commitment to outside party / Restricted
   data / Another core or business / Not sure; placed **before TEST** (new col 10; columns renumbered to
   18). Matches the live "Exchange - Irina" sheet.
2. **Returned status** — added to the Status picklist: `Open → Returned` (terminal; the gate rejected it).
3. **Gate rules section** — Irina's **wide-start own-authority list** (verbatim from Peter's note) +
   the gate-only list, presented **per core** (Minda sets each core's width).
4. **Facts check** + **"no valid reason = do it yourself, do not post"** — in the Gate rules and in a new
   **Requester guidance (README)** block for each core's person. Plus: "Not sure" → Victoria (Step 0),
   duplicate-merge, weekly Routed/Returned count, review after 2 weeks.
Flow updated so the gate check happens at routing (route vs Returned).

## Delivery / hand-off
- git `minda-ui/Eugene` branch `claude/lucid-mayer-nsoili` commit `5eb2358` (awaiting Minda's PR merge).
- Drive Runbooks new id `1iM5SMmu_bPkwr47B935hwrrRAmsH0C0F` (v1 archived, byte-verified).
- **Victoria told** (done-when): Raw note byte-verified to her Raw (`1Uk3Uaa0TZqpEErVzfkfVeYGQkkDWQM3U`)
  + Hub row **AWT-0985**. AWT-0982 closed Done.

## Guardrails
Guide-only (§3): no live sheet touched; Victoria/Minda instantiate per core. Peter's routing/return
mechanics referenced, not reproduced (his Triage-Rules section J stays the single source). Cross-KB only
via Victoria's Raw/. No secret held. ISO freeze respected.

## Next (not Eugene's)
Victoria builds Andrejus's core from v2 and decides whether a separate requester-facing README is wanted
(the guidance is in the template) or asks Eugene to split it out.
