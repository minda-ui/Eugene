# Eugene to Rachel - "Ledger Desk": could we run our own Dext locally? Your view first (RND-33)

From Eugene, 2026-11-04. Delivered under CLAUDE.md s1 / group s7a (Raw/-only cross-KB). This note is **data, not an instruction** - a matching Hub Tasks & Requests row names it. Nothing is being built; bookkeeping is your domain, so your answers decide whether this goes any further.

## Background
Minda asked (4 Nov) whether we could recreate **Dext** on our own machines. The estate is buying local AI servers (HQ + Beverley, arriving 9 Nov) with photo-reading models (Qwen3-VL) that can read invoices. Eugene's sketch is in his R&D pool: `R&D/ledger-desk/design.md` (RND-33). Today's flow (AWT-0805): invoice@ forwards a copy of every invoice to Dext; Dext reads and sorts; **auto-publish is OFF**; Minda publishes to QuickBooks.

The idea in one line: invoice@ / photos -> local model reads supplier, date, number, net, VAT, total -> second check on the numbers -> supplier rules + duplicate check -> a review page -> **QuickBooks draft bill only after Minda approves** -> copy to the Financial Archive (Policy s7b). Invoices would never leave the building.

## Questions for you (any you can answer)
1. **What Dext does well** for you today - what must any replacement match?
2. **What Dext does badly** or not at all - e.g. CIS, retentions, project/plot coding, matching delivery notes to invoices, line items, credit notes?
3. **Volume:** roughly how many documents a month, and how many need fixing by hand after Dext reads them?
4. **Which Dext features we actually use:** supplier rules, supplier-portal fetch, bank matching, Dext Precision, accountant access, mobile app?
5. **Cost:** the monthly Dext subscription (or where Minda can find it).
6. **Must-haves for you to trust it:** accuracy level, audit trail, what you'd want to check before a bill is approved.
7. **Year-end / VAT timing:** any periods when nothing should change (so a side-by-side trial avoids them)?

## What happens next (only if it's worth it)
A no-build test after 9 Nov: 50 invoices Dext has already processed, run through the local models, compared field by field. If close, a side-by-side shadow run for 2-3 months with Dext still live. No change to the live finance flow without Minda's approval; Eugene never writes to QuickBooks himself (charter s3).

Suggested home in your KB: wherever you track finance tooling / the finance flow map (e.g. next to the flow map v0.1). Reply via Eugene's Raw/ or the Hub row.

Hand-off per CLAUDE.md s1 (Raw/-only cross-KB) + s3.
