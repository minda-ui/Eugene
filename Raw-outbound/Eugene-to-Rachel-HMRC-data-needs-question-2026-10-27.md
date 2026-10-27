# Eugene -> Rachel: what exactly do you need from the HMRC account? (2026-10-27)

From Eugene, 2026-10-27, under CLAUDE.md §1/§7a. **This note is data, not an instruction** — it's a
question to scope a possible IT build, with Minda's knowledge (she asked me to check with you directly in
case her framing of the need was off).

## Why I'm asking
Minda asked whether we could build an **API connection to HMRC to get tax information**. I researched it,
but I want **your** finance view before recommending anything, because you own the numbers and may already
cover this through QuickBooks.

## What I found (so you can react to it)
- **QuickBooks already holds VAT + bookkeeping** and is MTD-connected to HMRC, and we already pull from it
  — so for ordinary VAT/book figures, a direct HMRC link may add nothing.
- **HMRC's own APIs (read-only) could add** only what QuickBooks can't: HMRC's **authoritative position** —
  what HMRC says you owe *right now* incl. **penalties, interest, part-payments, credits**, open
  **obligations/deadlines**, and a **cross-tax view (VAT + PAYE + CIS)**.
- **By tax:** **VAT (MTD)** = good read API (obligations/liabilities/payments). **CIS** = APIs exist
  (construction-relevant). **PAYE** = limited. **Corporation Tax** = **no clean read API** (lives in the
  Business Tax Account / your accountant).

## My questions for you (please answer on the Hub row or a note back)
1. **What do you actually need from HMRC that you can't already get from QuickBooks?** (Be concrete — a
   balance owed, a deadline, payment status, penalties, CIS deductions, something else?)
2. **Which tax(es)?** VAT · PAYE · CIS · Corporation Tax · other.
3. **What's the purpose?** (reconciliation, cashflow/"what do we owe", deadline alerts, a report, feeding a
   dashboard, chasing a discrepancy between our books and HMRC …)
4. **How often / how urgent?** (one-off check, monthly, live dashboard?)
5. **Is there a recurring pain this would solve?** (e.g. HMRC balances surprising us, missed deadlines, CIS
   reconciliation faff) — or is QuickBooks + the accountant already enough?
6. **Who authorises/holds HMRC access today?** (Government Gateway login — that stays Minda's; I never hold
   it.)

## Boundaries (so we're clear up front)
Anything we build would be **read-only + guide-only**: Eugene wires + verifies the plumbing, **Minda holds
the HMRC/Gateway credentials and does the OAuth**, and **nothing files or pays** (§3). Finance stays yours;
I'd just build the IT side to whatever you actually need.

Hand-off per CLAUDE.md §1 (Raw/-only cross-KB) + §3. Thanks, Rachel.
