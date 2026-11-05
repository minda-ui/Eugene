# RND-33 — "Ledger Desk": our own Dext, on our own machines (spark, lab mode)

**Date:** 2026-11-04 · **Status:** spark · **Asked by:** Minda ("we use Dext — could we recreate it on our machines?")
**Domain owner:** **Rachel** (bookkeeping) — nothing is built until she confirms the real need via her Raw/ (integration-scope-with-owner). Finance documents live in the group **Financial Archive** (Policy §7b), never in git.

## Today's flow (AWT-0805)
invoice@ mailbox → auto-forward copy → **Dext** (reads + sorts) → **Minda publishes** to QuickBooks (auto-publish OFF).

## What Dext does, and whether we can do it ourselves
| Dext feature | Our version | Can we? |
|---|---|---|
| Email-in / upload / phone photo capture | invoice@ mailbox (already) + site-chat/Telegram photos (RND-21) + a drop folder | **Yes** |
| Read the document (supplier, date, number, net / VAT / total, line items) | **Qwen3-VL** reads it; **PaddleOCR** re-reads the numbers; disagree → human | **Yes** — the core; needs a test against Dext's accuracy |
| Supplier rules (default account, VAT code, CIS flag, project) | a rules table per supplier, learned from your past QuickBooks bills | **Yes** |
| Duplicate detection | same supplier + invoice no. / amount + date check against QuickBooks and the archive | **Yes** |
| Review queue | a simple page: image left, fields right, Approve / Fix / Reject (Approvals Desk, RND-9) | **Yes** |
| Publish to QuickBooks | create a **draft bill** via the QuickBooks API **only after your click** | **Yes, gated** — a write to the system of record: always your approval |
| Archive with the original | file + extracted JSON into the Financial Archive (7-year HMRC retention) | **Yes** |
| Supplier-portal fetch (auto-download from suppliers' websites) | per-supplier scripts — fragile, each portal different | **Partly** — keep Dext/email for these |
| Bank-feed matching, Dext Precision health checks | QuickBooks already does bank matching; Precision is a separate product | **Not worth it** |
| Accountant access, support, guaranteed uptime | us | **No** — that's what the subscription buys |

## Shape
```
invoice@ / photos / drop folder
      → intake watcher (local)
      → Eyes: Qwen3-VL extract  +  OCR cross-check
      → rules + duplicate check (supplier table, QuickBooks read-only)
      → review page (Approvals Desk)  — Rachel pre-checks, Minda approves
      → QuickBooks draft bill (on approval)  +  Financial Archive copy
```
Runs on Beverley's P40s ("Eyes") or the HQ Gen10; nothing leaves the building except the final approved bill to QuickBooks.

## Why it might be worth it
- **Privacy:** invoices stay on our machines.
- **Construction fit:** CIS, retentions, project/plot coding, delivery-note ↔ invoice matching (RND-22) — things a generic tool doesn't know about our jobs.
- **Cost:** the Dext subscription (Minda to confirm the monthly figure) vs our time to build and maintain.

## Why it might not be
- Dext is mature; matching its read accuracy on messy invoices is the real test.
- We'd own every breakage (supplier format changes, API changes, outages at month-end).
- Finance is high-stakes: wrong VAT = HMRC problem. Every bill keeps a human approval.

## Smallest honest test (no build, after the Gen10 lands)
1. Take **50 invoices Dext has already processed** (from the archive, anonymised where needed).
2. Run them through Qwen3-VL + OCR on our P40s.
3. Compare field by field with what Dext extracted / what was published. Score: supplier, date, number, net, VAT, total.
4. If we're within a whisker of Dext → design the review page. If not → stay with Dext and use the local models for what Dext can't do (delivery-note matching, CIS checks).

**Recommended path:** run **side by side** first (Dext stays live; ours shadows it), switch only when ours is as good for 2–3 months. Never a big-bang swap at year-end.
