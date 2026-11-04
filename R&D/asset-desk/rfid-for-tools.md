# RND-34 — RFID tags for tools: short research note (v0.1, 2026-11-04)

From general knowledge, not yet checked against UK supplier quotes; prices rough, ex VAT. Minda asked in lab mode.

## Three kinds of "tag", three different jobs
| Kind | Range | Reads many at once? | Phone reads it? | Tag cost | Good for |
|---|---|---|---|---|---|
| **QR / barcode label** (what we planned) | line of sight, ~10–30 cm | no, one by one | yes (camera) | pennies | check-out/in at the desk; cheapest |
| **NFC / HF RFID** (13.56 MHz) | 1–4 cm, a tap | no | **yes**, most phones | ~£0.50–2 (on-metal versions) | "tap the drill with a phone" — no line of sight, survives dirt/paint better than a printed label |
| **UHF RFID** (passive, EU band 865–868 MHz) | 1–6 m with a handheld reader | **yes**, dozens a second | no — needs a UHF reader | ~£1–6 for rugged **on-metal** tags | **counting a whole van or store in seconds**; door/portal readers that log what leaves |
| **Bluetooth trackers** (battery) | 10–50 m; some find via others' phones | partly | yes (app) | £15–40 each + battery | finding/recovering the expensive few (breakers, lasers, generators) |

## Where UHF RFID earns its cost
- **End-of-day van check:** wave a reader over the van → "38 of 40 tools here; missing: laser level, SDS drill" in a few seconds, no unloading.
- **Stores audit:** count a full shelf without scanning one by one.
- **Gate/door reader** (later): logs tools leaving the yard automatically.
It does *not* find a stolen tool far away — that's Bluetooth/GPS trackers or engraving/marking for police recovery.

## The catches
- **Metal and water kill UHF reads** — tools need **on-metal tags** (rigid or flexible with a spacer); placement matters (plastic housing, not on a battery that comes off).
- **Not 100%:** a packed van with tools in metal cases can hide a few tags — the reader must be good and the routine consistent.
- **EU frequency:** buy **ETSI / EU 865–868 MHz** readers and tags, not the US 902–928 versions.
- **Tags can be removed** by thieves; RFID is for tracking our own process, not anti-theft.
- **Software:** Snipe-IT doesn't talk to RFID readers directly. A UHF handheld in "keyboard" mode types the tag number like a scanner (one tool at a time), but **bulk counts need a small bridge** — the reader app exports the list of tags read → a script compares it with Snipe-IT (via its API): "these are checked out to this van, these were read, these are missing". Eugene can write that script (lab prototype).
- **Labour:** tagging every tool once, and re-tagging when tags wear.

## Readers (rough)
| Type | Examples | Rough £ |
|---|---|---|
| Android handheld with built-in UHF | **Chainway C72**, Urovo DT50U/RT40, Zebra MC3330xR | 600–2,000 |
| UHF "sled" that clips to an Android handheld/phone | **Zebra RFD40** (with TC22/TC27), Chainway R6 | 300–1,500 |
| Desktop UHF reader (enrol tags at the desk) | various USB readers | 80–300 |
| Fixed reader + antennas (door/gate) | Zebra FX9600, Impinj R700 | 1,000–3,000 installed |
| NFC | the phone you already have | £0 |

Note: an Android handheld with **both** a 2D scanner and UHF (e.g. Chainway C72) could be the "one unit" for stores (barcodes), assets (QR + RFID) and production — relevant to Darius's answer (AWT-1116).

## Off-the-shelf alternatives (for comparison)
Tool makers sell their own tracking: **Hilti ON!Track** (RFID/Bluetooth + software, subscription), **Milwaukee ONE-KEY** (Bluetooth, mainly Milwaukee tools), **DeWalt Tool Connect**, **Bosch TrackTag**. They work best if most tools are one brand and cost a monthly fee; our own set-up keeps the data in-house and covers every brand.

## Recommendation (lab view)
1. **Every tool gets a QR label anyway** (cheap, works with any phone) — already planned.
2. **Option: dual tags** — QR + NFC on-metal combined labels (~£1–2) → scan *or* tap with a phone.
3. **UHF only if the van/stores count is a real pain** — trial first: **1 van, ~40 tools, 50 rugged on-metal tags (~£100–250) + one UHF handheld (~£600–1,000)**, plus Eugene's reconcile script against Snipe-IT. Judge it on: read rate in a loaded van, time saved per day.
4. **Bluetooth trackers** only on the few expensive, theft-prone items.
Questions for Minda: how many tools and vans? Is the pain *knowing who has what*, *end-of-day counts*, or *theft*? That decides QR, NFC, UHF or trackers.
