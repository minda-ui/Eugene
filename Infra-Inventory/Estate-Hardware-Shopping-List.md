# Estate hardware shopping list — network, compute & storage (priority-marked)

## ▶ CURRENT LIST (2026-10-31 evening) — supersedes the 28 Oct tables below (kept as history)
**Ordered today:** 2× DL380 Gen10 (Bargain Hardware, due 9 Nov) · 4× GPU cable `869820-001` · 6× RAM `P03052-091` · 4× ASA 5525-X (earlier).
| Pri | Qty | Item | Part / spec | ~£ | Status |
|---|---|---|---|---|---|
| 🔴 | 6 | RAM, HQ server | HPE 32 GB 2Rx4 DDR4-2933 RDIMM `P03052-091` | ~900 | Minda searching |
| 🔴 | 4 | Boot SSDs (2 per server, mirrored) | enterprise SATA 2.5" 240–480 GB (e.g. Intel S4510 / Samsung PM883 / HPE RI) — fits BH's caddies | 100–160 | to buy |
| 🔴 | 12 | High Performance fans (6 per server) | `867810-B21` (single fans `875075-001`) | 0–240 | **waiting on BH reply** |
| 🔴 | 2 | GPU-ready risers + baffle | P38515-B21 / GPU baffle | 0–150 | **waiting on BH reply** |
| 🟠 | 4 | Power leads C13–C14 | 1 m, for the UPS | ~15 | check stock first |
| 🟠 | 1 | Cisco console cable (RJ45→USB) | for the ASA 5525-X / OPNsense installs | ~10 | if none in hand |
| 🟠 | 0–4 | SSDs for the 5525-X | 2.5" SATA, only if the units arrive without | 0–80 | on arrival |
| 🟡 | — | iLO Advanced licence | only if not already on the boxes | 0–40 | check at arrival |
| 🔵 | 1–2 | 10G cards for the server triangle (R710, maybe Gen9 2nd) | 2-port SFP+; 2 Cisco DACs in hand | 55–85 | after lid-off checks |
| 🔵 | — | Tertiary riser `826700-B21` + `P38517-B21` | only for a 3rd card | 50–120 | later |
| 🔵 | 2 | V100 32 GB | ~£700 each | ~1,400 | **only if pilot testing says so** |
| ⚪ | — | UPS batteries / AI-server UPS / 16 A circuit / cooling | only if AWT-1065/1066 readings say so | 0–4,000 | measurements |

**Free (reuse):** Beverley RAM = 4 spare Gen9 sticks (128 GB) · Beverley data drives = spare 900 GB SAS (we have 32) · HQ model library = Minda's 6× 900 GB SAS · P40s → HQ Gen10.
**Dropped:** new P40s, Gen9 P40 cables, Gen9 baffle 719082-B21, HQ storage Gen10 (24SFF), NM-4-10G, Beverley SSD set.

---

## History — 28 Oct list (superseded)

> **Eugene, 2026-10-28 (guide-only, §3).** Everything still to buy to complete the estate as mapped
> (`fishbone-estate-map`). **Minda buys + fits; Eugene specs + verifies.** Prices are indicative used/market
> (ex-VAT) — **verify at purchase**. Part numbers from the specs: `R&D/estate-compute-split/gen10-r710-replacement.md`
> (HQ Gen10), `R&D/estate-compute-split/beverley-node-spec.md` (Beverley), `R&D/estate-storage/design.md`
> (storage), `R&D/local-models/parts-list.md` (brain GPUs).

**Priority key:** 🔴 **P1** = before Saturday (blocks the build) · 🟠 **P2** = Friday's HQ Gen10 order ·
🟡 **P3** = Beverley failover node (soon) · 🔵 **P4** = phase 2 (later).

---

## 🔴 P1 — Before Saturday (each blocks part of the build)
| ✓ | Qty | Item | Part / spec | ~£ | Why / blocks |
|---|---|---|---|---|---|
| ⬜ | 1 | **GPU baffle / shroud** (Gen9 brain) | **HPE 719082-B21** (Graphics Enablement Kit — baffle retention + high-perf heatsinks + cables) | 30–80 | P40s are passively cooled → **without it, no GPU load test**. The HPE-correct part (no standalone baffle); also covers the GPU heatsinks. |
| ⏸ | — | **Internal HBA** (R710) — **DEFERRED/DROPPED (Minda 2026-10-29)** | ~~LSI 9211-8i IT~~ — **not buying; keeping those drives for the Gen10** (which has its own E208i-a HBA) | £0 | **Saturday = shelf-only build** (24 drives on the CP400e) → no internal HBA needed. _If ever wanted later, the spec was: LSI 9211-8i · SAS2008 · 2× SFF-8087 · pre-flashed IT (P20) — avoid 4i / SFF-8643 / IR-mode listings._ |

_P1 now = just the **GPU baffle** (£30–80). Internal HBA dropped (drives → Gen10). **Saturday = shelf-only storage** (CP400e + 24 drives, both in hand) + the Gen9 brain fit; the baffle only gates the GPU **load test**, not the fit — so Saturday needs **nothing bought** to proceed._

## 🟠 P2 — HQ Gen10 storage spine (Friday's order)
| ✓ | Qty | Item | Part / spec | ~£ |
|---|---|---|---|---|
| ⬜ | 1 | Chassis **DL380 Gen10 24SFF** | **confirm it includes the SAS expander** (message Techbuyer) | 235 |
| ⬜ | 2 | CPU **Xeon Gold 6226** (12c, 125 W) | lights up all DIMM slots + PCIe | 54 |
| ⬜ | 2 | Heatsinks | Standard is fine (no GPU here); High-Perf optional | 46–78 |
| ⬜ | 1 | HBA **E208i-a SR Gen10** | **HBA/pass-through mode** for ZFS (not RAID) | 54 |
| ⬜ | 2 | PSU **865408-B21** 500 W Flex-Slot | right Gen10 part; GPU-less box only needs ~500 W | 28 |
| ⬜ | 1 | RAM **64 GB** (2× 32 GB DDR4-**2933**) | source separately (cheaper than the vendor's £395) | 160–240 |
| ⬜ | 1 | Rail kit | | 30 |
| — | — | Drives | **reuse** — migrate the 900 GB SAS from the R710/shelf | £0 |

_P2 subtotal ≈ **£600–720**. Build-time: set the E208i-a to **HBA mode**._

## 🟡 P3 — Beverley failover node (2nd Gen10 = SSD replica + brain)
_Same base as P2, plus the GPU + SSD deltas. CPU stays the 6226 (**≤160 W → P40-compatible**)._
| ✓ | Qty | Item | Part / spec | ~£ |
|---|---|---|---|---|
| ⬜ | 1 | Chassis **DL380 Gen10 24SFF** | confirm SAS expander | 235 |
| ⬜ | 2 | CPU **Xeon Gold 6226** | ≤160 W (P40 rule) | 54 |
| ⬜ | 2 | **High-Performance** heatsinks | **required** for the GPU config | 78 |
| ⬜ | 1 | HBA **E208i-a** | ZFS pass-through | 54 |
| ⬜ | 2 | PSU **830272-B21** 1600 W Flex-Slot | GPU-grade; **both must match** | 60–120 |
| ⬜ | 1 | RAM **64–128 GB** DDR4-2933 | ZFS ARC + model working set | 160–240 |
| ⬜ | 1 | **GPU riser(s)** | **P14374-B21** + **P14373-B21** (or **826704-B21**) — verify combo vs chassis | 50–150 |
| ⬜ | 1 | **GPU power cables** | **871829-B21** (keyed 8-pin kit) | 20–40 |
| ⬜ | 2 | **GPU baffle** (both positions) | Gen10 GPU shroud | 20–60 |
| ⬜ | **1** | **Tesla P40 24 GB** (now) | **872323-001** — Bytestock ~£195 | 195 |
| ⬜ | ~8 | **SSDs** — enterprise 2.5" (e.g. 1.92 TB) | SAS/SATA, PLP; ~11 TB RAIDZ2 to match HQ | 600–900 |
| ⬜ | 1 | Rail kit | | 30 |

_P3 subtotal ≈ **£1,550–2,050** (build the chassis **2-GPU-ready** so the 2nd P40 is pure plug-in)._

## 🔵 P4 — Phase 2 (later)
| ✓ | Qty | Item | Part / spec | ~£ |
|---|---|---|---|---|
| ⬜ | 1 | **2nd Tesla P40 24 GB** (Beverley) | **872323-001** → full HQ-parity 48 GB failover brain | 195 |

## 🔌 Networking — verify, likely small or £0
| ✓ | Qty | Item | Note | ~£ |
|---|---|---|---|---|
| ⬜ | 1–2 | **10 G SFP+ DAC / transceiver** | only if moving the 562SFP+ 10 G NIC to the storage box and the HQ 3850 10 G uplink needs a DAC — **verify a free 10 G port first** | 0–30 |
| — | — | Switches / firewalls / radios | **none** — ASAs, 3850s, airFiber (+ spare) all owned | £0 |

---

## ✅ Already in hand — DO NOT re-buy
- **32× 900 GB SAS** drives (24 shelf + 8 internal) · **SAS cable ×2** (SFF-8644→QSFP, delivered)
- **Gen9 brain:** 256 GB RAM (128 fitted + 128 arriving Fri) · **1400 W PSU** · **2× Tesla P40** · both GPU risers · both GPU power cables · high-perf fans
- **R710** (storage host) · **DS2246** shelf + 24 caddies · **CP400e** HBA
- **Lenovo mini-PC** (kept — Beverley always-on management/Tailscale anchor)

## Rough totals (still to spend)
| Priority | ~£ |
|---|---|
| 🔴 P1 (before Sat) | 25–55 |
| 🟠 P2 (HQ Gen10, Fri) | 600–720 |
| 🟡 P3 (Beverley node) | 1,550–2,050 |
| 🔵 P4 (2nd Beverley P40) | 195 |
| **Total to complete the estate** | **≈ £2,370–3,020** |

---
_Guide-only (§3): Eugene specs; Minda buys + fits + holds all accounts. Verify every part/price at purchase
(HPE PartSurfer/QuickSpecs for the Gen10 GPU parts). Pairs with the estate map + the four build specs._
