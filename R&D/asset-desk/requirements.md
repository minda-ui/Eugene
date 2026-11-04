# RND-34 Asset Desk — requirements v0.1 (Minda, 2026-11-04)

Starting clean (EZOffice empty). Answers from Minda, lab mode.

## What it tracks
| Group | Examples | Tracked as |
|---|---|---|
| **IT kit** | servers, firewalls, switches, UPS, radios, printers, laptops, phones | individual assets (tag + serial) — seed list `seed-it-assets.csv` (26) |
| **Site tools** | power tools, lasers, breakers, ladders | individual assets (tag) |
| **Plant & vehicles** | vans, mixers, generators, scaffolding | individual assets + service / MOT / LOLER / insurance dates |
| **Stock & consumables** | PPE, fixings, materials | counts per location + minimum level → reorder alert |
| **Amfa consumables** | panels (board), hinges (e.g. Blum), handles, edging, fixings | counts per location + minimum level; panels may need sizes / colour / thickness |

## Must-have features
1. **Check-out / check-in** — to a person, site / plot, or van; full history.
2. **Service & inspections** — PAT, servicing, calibration, LOLER, MOT: due dates + reminders before due.
3. **Value & purchase info** — price, supplier, invoice ref, purchase date, warranty end, depreciation (for Rachel / the accounts).
4. **QR labels scanned with a phone** — camera → item page → one tap check-out / in. Phone browser is enough.
5. **Stock levels with reorder alerts** — for consumables and Amfa parts.

## Not needed (for now)
- Bookings / reservations.
- Site operatives using it — **office only, 2–3 users** (Minda, Andrejus, maybe one more).
- Site-chat check-outs (possible later via the AI layer).

## Fit
- **Snipe-IT** covers 1–4 well and has simple consumables with minimum quantities (5, basic).
- **Amfa stock** may outgrow Snipe-IT's consumables if panels need sizes / colours / offcuts, part numbers per supplier or bills of materials per furniture unit. If so, add **InvenTree** (open source parts & stock: locations, suppliers, purchase orders, BOMs) for Amfa only. Decide after a 2-week trial with a few real Amfa items.
- Office-only + no bookings → one small container, simple logins, no mobile app needed.

## Owners to agree (before loading their data)
- IT kit — Eugene (data ready).
- Site tools, plant, vehicles — Anna? / Alex?
- Amfa consumables — Darius? (Amfa)
- Value / depreciation fields — Rachel reads them.

## First steps
1. Install Snipe-IT (container on the Gen9, Tailscale-only, PBS backup) — Minda runs, Eugene writes steps.
2. Import the 26 IT assets; print QR labels; test one check-out / check-in.
3. Add 5 site tools, 1 van (with MOT date), 5 Amfa items (a panel type, Blum hinges…) as a trial.
4. Two weeks of use → decide whether Amfa stock needs InvenTree.

## Update 2026-11-04 — use the manufacturers' own barcodes (Minda)
- **Materials & consumables** (Blum hinges, fixings, PPE, boxed items): the printed **EAN/UPC barcode on the packet identifies the product**, so scanning it can find the part and add/remove stock — no labels to print. Same product = same barcode, which is exactly right for counts.
- **InvenTree** supports linking a third-party (manufacturer) barcode to a part, and its phone app scans → this tips **all stock (Amfa + site consumables) to InvenTree**. Snipe-IT can store a barcode number in its item fields but doesn't do scan-to-adjust-stock well.
- **Individual tools, plant, IT** still need **our own QR tag** (`FB-…`): every DeWalt drill of one model carries the same product barcode, so it can't tell *which* drill. The manufacturer's serial can be recorded on the asset.
- **Gaps:** cut panels / offcuts and loose items have no barcode → print our own label for the shelf/bin; the same product from two suppliers may carry two barcodes → link both to one part (check in the trial); some supplier labels use their own internal codes, not EAN.
- **Office scanning:** a USB/Bluetooth barcode scanner (~£20–40) acts as a keyboard — scan at the desk on delivery; phone camera for the stores.
- **Revised split:** Snipe-IT = things we track one by one (IT, tools, plant, vans); InvenTree = things we count (Amfa materials, site stock, PPE). Both small containers, Tailscale-only, PBS-backed. Trial: scan 5 real Amfa packets (incl. Blum hinges) into InvenTree.
