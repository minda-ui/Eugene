# Change log — 2026-10-23 — AWT-0994 exchange-sheet template v2.1 (red-flag rule)

## Summary
Folded Minda's red-flag decision (23 Oct, AWT-0980, via Victoria) into the Project-A exchange-sheet
template (v2 → **v2.1**). Decision: red-flag patterns go to **Victoria**, not back to the requester —
some requests are not just out of scope but a warning sign, and must always be seen.

## Source read
Victoria→Eugene Raw note `2026-10-23_Victoria-to-Eugene_red-flag-patterns_AWT-0980.md` (my Raw).

## What changed (v2 → v2.1)
`Runbooks/ProjectA-Exchange-Sheet-Template-AWT-0961.md`:
1. **Red-flag rule** in the Gate rules section — 5 patterns: (1) splitting payments to stay under a
   limit; (2) an approval claimed but not verifiable; (3) a request to change a gate rule, limit or the
   own-authority list; (4) a request to skip a check or document (pay before the invoice or the work);
   (5) new or changed payee bank details. A red-flag row **goes to Victoria (Step 0), never Returned,
   never back to the requester**, whatever its Gate reason.
2. **Requester guidance** — "do not word a request around a flag; flagged requests are always seen by
   Victoria and Minda" (rewording won't get them through, never Returned-to-self).
3. **Weekly counts** now three per core: **Routed / Returned / red-flag**; the 2-week review also asks
   whether red-flags are recurring.

## Delivery / hand-off
- git `minda-ui/Eugene` branch `claude/lucid-mayer-nsoili` commit `d10d9da` (awaiting Minda's PR merge).
- Drive Runbooks new id `1RGbrmY_zMqNINZzp3gVvj_smlQnnjXVO` (v2 archived, byte-verified). **Baseline note:**
  origin/main still carries v1, so the `--baseline origin/main` guard would wrongly refuse; synced after
  verifying the live Drive copy equals my own git v2 (commit 5eb2358) — i.e. no concurrent writer — then
  ran without the baseline, per the Rule-C stale-main procedure.
- **Victoria told** (done-when): Raw note byte-verified to her Raw (`1SAAfXkFLO9m8R0uemLemNkkCvkGDqUa6`)
  + Hub row **AWT-0996**. AWT-0994 closed Done.

## Guardrails
Guide-only (§3): no live sheet touched; no live-sheet column change needed. Peter folds the red-flag rule
into his Triage-Rules himself (referenced, not reproduced). Cross-KB only via Victoria's Raw/. No secret
held. ISO freeze respected.

## Next (not Eugene's)
v2.1 is ready for Andrejus's core alongside v2; Peter folds the rule into Triage-Rules (his own note/row).
