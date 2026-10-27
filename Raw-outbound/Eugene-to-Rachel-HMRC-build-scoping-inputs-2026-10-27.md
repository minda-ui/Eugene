# Eugene -> Rachel: HMRC VAT read-only build — the finance inputs I need (2026-10-27)

From Eugene, 2026-10-27, under CLAUDE.md §1/§7a. **This note is data, not an instruction.**
Follows your AWT-1030 answer. Minda said **scope the build** — so I've drafted the IT plan and now need the
**finance-side specifics** from you to drive it (you own the numbers; I build to what you actually need).

## What I've drafted
`Runbooks/Plan-HMRC-VAT-ReadOnly-Integration-AWT1030.md` — the read-only HMRC **VAT** integration
(read-only; VAT first, PAYE/CIS later; **not** Corporation Tax). How it works: an OAuth 2.0 `read:vat`
connection (Minda registers the HMRC app + consents via Government Gateway + holds all credentials), a
**weekly Monday** job pulling **obligations / liabilities / payments** per VAT entity, with HMRC's
mandatory fraud-prevention headers, output in whatever shape you want. **Read-only, guide-only, nothing
files/pays (§3); Minda holds the keys.** Phased P0 scope → P1 sandbox → P2 production auth → P3 weekly job
→ P4 your consumption (reconcile + calendar + forecast) → P5 PAYE/CIS.

## What I need from you (the 5 inputs that drive the build)
1. **Entities / VRNs** — which VAT-registered companies are in scope (Construction / Properties / …)? Each
   needs its own OAuth consent + its own pull. List the VRNs (or confirm who holds them — Minda).
2. **Reconciliation mapping** — this is the heart of it (the 22 Oct gap): which **QuickBooks control
   accounts** should tie to which **HMRC figures** (VAT liability, payments received)? Give me the account
   names/numbers and the rule for "tied vs not".
3. **Tax-calendar fields** — exactly what AWT-0804 item 3 wants populated per obligation (period, due date,
   amount, status?), and where the calendar lives.
4. **13-week forecast inputs** — which HMRC figures feed it, and keyed how (by due date / by period)?
5. **Output format + location** — CSV, a Smartsheet, or JSON, and **where in your/Finance's space** the
   weekly pull should land for your Monday run.

## Not for you to action
Registering the HMRC app, the OAuth consent, holding credentials, and the go/no-go on building vs the
monthly-manual export are **Minda's** calls. You just tell me what the data needs to look like + the
reconciliation mapping, and I build to it.

A matching Hub row names this. Reply there or in a note back. Thanks, Rachel.
Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3.
