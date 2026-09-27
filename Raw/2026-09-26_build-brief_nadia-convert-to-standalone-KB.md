# Build brief — convert Nadia to a STANDALONE KB (AWT-0101)

From: Victoria, for Minda — 2026-09-26. **APPROVED by Minda (2026-09-26).** Per CHARTER §2
(propose → approve → build), this is your build spec — step 3, Eugene builds. Hub **AWT-0101**.
Supersedes the "adopt the Amfa KB, no new KB" decision in the original build brief (AWT-0093).

## The change
Nadia was built (AWT-0093) as a **domain assistant adopting the Amfa Furniture Ltd KB** — no KB of her
own, identity living at the Amfa KB root. **Minda now wants Nadia STANDALONE**: her own employee KB with
its own Drive home + `CLAUDE.md` + control files + `Raw/Wiki/Outputs/Archive`, on the existing
`minda-ui/Nadia` repo — the **Peter / Eugene / Anna model**.

**Owner decision (Minda, 2026-09-26):** **keep the Amfa Furniture Ltd KB** as the company's own KB (it
stays one of the seven company KBs — do NOT dismantle or migrate it). Nadia becomes a standalone employee
**alongside** it and continues to operate Amfa's systems from her own home.

## Build
1. **New Drive home folder for Nadia** (own KB), on the estate **core/rules/history** identity pattern +
   the standard employee-KB shape:
   - `CHARTER.md` (core) + `Charter-Rules.md` (Hub Rules A–D + cross-KB `Raw/` route) + a history/change-log
     file — carry over the content of her current charter (at the Amfa KB root), re-homed and re-scoped to
     "standalone, own KB" (see §Reach below). Keep the same authoritative content; change only what the
     standalone model requires.
   - Control files to match the estate (current-state / kb-registers, open-issues or equivalent,
     external-source-register, processed-items-ledger — whatever the standard employee-KB set is).
   - `Raw/`, `Wiki/`, `Outputs/`, `Archive/` subfolders + a SessionStart PDF-toolkit hook (already in the repo).
2. **`minda-ui/Nadia`** (exists — currently holds identity files) becomes her **full KB git mirror**. Sync
   the new KB there.
3. **Vacate the Amfa company KB:** move/archive Nadia's identity files out of the Amfa Furniture Ltd KB root
   (the `CHARTER.md` there and any Nadia-only files) into her new home / the Amfa KB's `Archive/` with a
   superseded note, so the Amfa company KB is just the company KB again (no employee identity living in it).
   Leave the Amfa KB's own company content (Wiki, CLAUDE.md, kb-registers, the KB-wide files you synced under
   AWT-0093) untouched.

## Reach / guardrails (UNCHANGED — just re-homed)
- **Function unchanged:** Amfa sales & ops — enquiry intake, quote drafting, the enquiry→quote→order pipeline,
  while Amfa stays dormant (launch 1 May 2027); test-run under the **Fishbone Construction Ltd umbrella**.
- **Serves/operates Amfa from her own home:** reads and maintains the **Amfa Furniture Ltd KB** (its Wiki,
  customers) and the **AMFA Furniture** Smartsheet workspace — the Enquiries/Quotes CRM (`5405540723328900`)
  and the order tracker (`5287398789482372`) — as before. Cite, don't duplicate.
- **Draft-only outward** (John/Helen pattern): never contacts a customer/supplier directly; no payments,
  commitments or filings. **Finance stays with Rachel** (AWT-0094). Policy **v1.4** (finance docs → Financial
  Archive only). All group `CLAUDE.md` §6a bars stand.
- **Connectors unchanged:** Drive + Smartsheet + Web + GitHub + Gmail read/draft on `enquiries@amfa.uk`
  (mailbox connection is still a human/admin live-system step — guide, don't execute).

## When built
Hand back to **Victoria** to re-register: group `CLAUDE.md` §1 (rewrite the Nadia paragraph from "adopts the
Amfa KB, no new KB" to "standalone KB + `minda-ui/Nadia`"; raise the KB count by one), the Hub **Roster**, and
close/refresh **AWT-0092**. Tell nobody else's scope changes. Log to Nadia's own KB history/change-log + git,
byte-verify every Drive write.

## Notes
- Nadia is **Building / not yet trading** (no live customer traffic; `enquiries@amfa.uk` not yet connected),
  so this re-home has minimal live impact — good moment to do it.
- Don't create routines (Minda creates via the form); the routine-prompt drafts already in the repo carry over.
