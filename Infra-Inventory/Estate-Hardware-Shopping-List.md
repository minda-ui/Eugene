# Estate hardware shopping list — network, compute & storage (priority-marked)

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
| ⬜ | 1 | **GPU baffle / shroud** (Gen9 brain) | HPE DL380 Gen9 GPU air baffle | 10–30 | P40s are passively cooled → **without it, no GPU load test**. The one outstanding brain part. |
| ⬜ | 1 | **Internal HBA** (R710) | **LSI 9211-8i IT mode** (or Dell H200/H310 **pre-flashed IT**), internal SFF-8087 | 15–25 | The R710's PERC 6/i has no IT mode → needed to put the **8 internal bays** into ZFS. Buy **pre-flashed** (no flashing on the day). |

_P1 subtotal ≈ **£25–55**. Without these, Saturday still works (shelf pool + mechanical GPU fit) — you just can't load-test the GPUs or use the 8 internal bays yet._

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
