# Change log — 2026-10-23 — AWT-1012 exchange-sheet template v2.3 (drill-report fixes)

## Summary
Folded the three fixes from Sarah's gate-drill report (Minda: "fix notes 2, 3 and 4"; Victoria's Raw
note, AWT-0983) into the Project-A exchange-sheet template (v2.2 → **v2.3**).

## Source read
Victoria→Eugene Raw note `2026-10-23_Victoria-to-Eugene_gate-rules-from-drill-report_AWT-0983.md`
(Drive `1x8KF8A0F2hFOHPNh8WAKoLJ2E4FUFYFs`).

## What changed (v2.2 → v2.3)
`Runbooks/ProjectA-Exchange-Sheet-Template-AWT-0961.md`:
1. **Money with no payee (note 2)** — a money request must name the payee/supplier **and** the invoice or
   quote. Names neither → Peter Returns "Missing: payee or supplier not named". Pay-first (before the
   invoice or work) → red flag pattern 4. Added to Gate rules + requester guidance.
2. **No Gate reason but real content (note 3)** — judged on content: no reason + commitment to an outside
   party or restricted data → **Victoria (Step 0)**; no reason + money → treated as **Money**; only a
   request with none of these → **Returned** "your call". Added the explicit **order of checks**: red flag
   → content → duplicate → reason & own-authority → facts → route.
3. **No internal references in answers (note 4)** — resolver guidance (Answer column + flow step 4): the
   answer carries no Hub row ids, no master-core links, no Drive ids, and does not mention the Hub.

## Delivery / hand-off
- git `minda-ui/Eugene` branch `claude/lucid-mayer-nsoili` (commit this session; awaiting Minda's PR merge, PR #25).
- Drive Runbooks new id `1uL2f_tnsopCcpOFnPZCtTpN6i0f2OJMr` (v2.2 archived, byte-verified). Baseline note:
  origin/main still carries v1, so synced v2.3 after verifying live Drive == my own git v2.2 (no
  concurrent writer), not via `--baseline`.
- **Victoria told** (done-when): Raw note byte-verified to her Raw (`1h0ysjN8W7bYCOD7CZz1mXIzseqK0Jnr7`)
  + Hub row **AWT-1014**. AWT-1012 closed Done.

## Guardrails
Guide-only (§3): no live sheet touched; no live-sheet column change needed. Peter folds rules 1 and 2 into
his Triage-Rules himself (referenced, not reproduced). Cross-KB only via Victoria's Raw/. No secret held.
ISO freeze respected.

## Next (not Eugene's)
v2.3 ready for Andrejus's core; Peter folds the money + no-reason rules into Triage-Rules (his own note/row).
