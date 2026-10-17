# Change log — 2026-10-17 (late) — AWT-0827: Amfa quote-form conversion-tracking guide

_Guide-only (charter §3): Eugene wrote the guide only; Minda or the site developer applies every live
step; Eugene touched no live system (site/GTM/Tilda/GA4/Ads). No secret held._

## What
Minda tagged **AWT-0827** (Assigned: Eugene; Requested by: Victoria for Minda; Priority High; due
2026-10-21). The ask: write a non-developer step-by-step guide to make the **amfa.uk quote form (Tilda)**
record a conversion, flow into **GA4 (556194113)** as a key event, and import into **Google Ads**.
Context from Helen's report (AWT-0777): GA4 + GTM (`GTM-WLTMKHP5`) are live and receiving data, but the
quote form has **no conversion event** — `form_submit` has never fired, only Google-default key events.

## Done
- Verified the current method via web search (Tilda success-event form tracking; GTM custom-event → GA4
  event; GA4 key event; import into Google Ads — incl. the lag/no-backfill/attribution caveats).
- Wrote `Runbooks/Runbook-Amfa-QuoteForm-Conversion-Tracking-Tilda-GTM-GA4-Ads-AWT-0827.md`:
  1. **Tilda** `tildaform:aftersuccess` → `dataLayer` push (the reliable hook — GTM's native Form
     Submission trigger can't see Tilda's AJAX form; **thank-you-page fallback** included).
  2. **GTM** Custom Event trigger → **GA4 Event** tag (default event `generate_lead`).
  3. **GA4** mark it a **key event** (not retroactive).
  4. **Google Ads** import the key event as a conversion (link check + import steps).
  5. **Test:** GTM Preview + GA4 DebugView one-marked-TEST-enquiry checklist (Helen verifies) + **rollback**
     line + the §2b boundary.
- The exact GA4 **event name/parameters** are Victoria's to confirm on **AWT-0828** — the guide uses
  `generate_lead` as a sensible recommended default and says to swap in hers everywhere (names are
  case-sensitive).

## Filed + handed off
- Runbook committed to git + synced to Eugene's Runbooks on Drive (`1C72pjzoloG8J-n8LUmzKG67v_OV3hTQ0`).
- **Copied to Victoria's Raw/** (verified folder `1rzRlNRLdg-qZnXU4MTHCnn3H2b1Z5L6G`; file
  `1Nsuxex8CmsHwURSn9zkhtQrjblII2IBY`) so she has it for AWT-0828 — **no new Hub row** (AWT-0828 already
  tracks her part, referencing AWT-0827; a new row would duplicate).
- **Hub AWT-0827 → Done** (own-row, §2e), Done date 2026-10-17, result recorded on the row.

## Coordination (not Eugene's rows)
- **AWT-0828 (Victoria):** confirm GA4 event name/params; draft + run the one-enquiry TEST; verify in
  GA4/Ads with Helen.
- **AWT-0829 (Nadia):** watch `enquiries@amfa.uk` for the TEST enquiry (marked TEST; don't log as a lead).

Ledger 123.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
