# RND-34 — handheld barcode scanners for warehouse, workshop and production (v0.1, 2026-11-04)

Prices are rough UK street prices (ex VAT) from general knowledge — get quotes before buying. Must read **2D** (QR) for our own `FB-` labels **and 1D** (EAN/UPC/Code-128) for manufacturers' barcodes. 1D-only scanners can't read QR — avoid.

## A. "Keyboard" scanners (scan → types the code into whatever is open: InvenTree/Snipe-IT web page, a spreadsheet, production software)
| Tier | Model | Link | Rugged | Rough £ | Notes |
|---|---|---|---|---|---|
| Budget | **Inateck BCST-70 / BCST-73** | USB + Bluetooth | light | 40–70 | 2D, memory mode for offline counts; fine for office/stores |
| Budget | **Netum NT-1228BL / C750** | USB + Bluetooth (+ dongle) | light | 30–60 | cheapest usable 2D; test before buying many |
| Budget rugged | **Tera HW0002 / D5100** | USB + Bluetooth | IP65-ish, drop rated | 50–80 | good value for a dusty workshop |
| Pro | **Zebra DS2278** | Bluetooth + cradle | 1.5 m drop | 150–200 | reliable, 2D, long life |
| Pro | **Honeywell Voyager 1472g** | Bluetooth + base | 1.5 m drop | 140–200 | Zebra's equal |
| Industrial | **Zebra DS3678 (SR)** | Bluetooth + cradle | IP65/67, 3 m drop, freezer-rated | 400–550 | warehouse / workshop / production floor workhorse; reads damaged/dirty labels |
| Industrial | **Honeywell Granit XP 1991i** | Bluetooth + base | IP65, 5 m drop | 350–500 | same class as DS3678 |

## B. Android handheld computers (scanner + touchscreen; runs the InvenTree app, browser, or a production app — no PC needed)
| Tier | Model | Rough £ | Notes |
|---|---|---|---|
| Value | **Urovo DT50 / Newland MT90 / Chainway C61** | 250–400 | Android, 2D scan engine, IP65+, Wi-Fi; less polished software/support |
| Pro | **Zebra TC22 / TC27** (TC21/TC26 refurbished cheaper) | 500–800 | long Android support, enterprise tools, IP68, 1.8 m drop |
| Pro | **Honeywell CT30 XP / EDA52** | 450–800 | Honeywell's equivalent |

## C. Fixed / hands-free (production stations)
- **Zebra DS9308** or **Honeywell Genesis XP 7680g** presentation scanners on a bench (~£120–250): hold the part under it, hands stay free — good for a packing or assembly station.
- **Ring / wearable scanners** (Zebra RS5100 + WT6300, or budget Bluetooth ring scanners ~£60–100) when both hands are on the work.

## One unit for everything?
Yes, likely — an **Android handheld (B)** can serve stores (InvenTree app: receive, count, move), assets (Snipe-IT in the browser: check-out/in) **and production** (job tickets, part tracking, picking for a cabinet) with one device per person. Pair with a **fixed scanner (C)** at any station where hands must stay free. Standardise on **one brand** so chargers, cradles and settings are shared.
**What production needs decides it** → asked Darius (Workshop Operations) via his Raw/ (AWT, 2026-11-04).

## Suggested first buy (trial)
- 1× budget 2D keyboard scanner (Inateck/Tera, ~£50) for the office/stores trial with InvenTree + Snipe-IT.
- Hold the rugged/Android purchase until Darius answers what production needs.
