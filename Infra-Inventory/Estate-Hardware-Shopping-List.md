# Estate hardware shopping list — network, compute & storage (priority-marked)

## ▶ CURRENT LIST (2026-10-31 evening) — supersedes the 28 Oct tables below (kept as history)
**Ordered today:** 2× DL380 Gen10 (Bargain Hardware, due 9 Nov) · 4× GPU cable `869820-001` · 6× RAM `P03052-091` · 4× ASA 5525-X (earlier).
| Pri | Qty | Item | Part / spec | ~£ | Status |
|---|---|---|---|---|---|
| ✅ | 12 | RAM, HQ server | HPE 32 GB 2Rx4 DDR4-2933 RDIMM `P03052-091`, all from it-black-belt: 6 (10-15369-27694) + 6 (03-15383-02815, item 237150914833) | 1,800 | **all 12 ordered 2026-10-31**, due 3–4 Nov |
| ✅ | 4 | Boot SSDs (2 per server, mirrored) | **HPE 240 GB SATA RI 789135-B21** (eBay 27-15338-03502, 4× £48) | 192 | ordered 2026-10-31, due 2–3 Nov |
| 🔴 | 12 | High Performance fans (6 per server) | `867810-B21` (single-fan spare no. — confirm before buying) | 0–240 | **waiting on BH reply** |
| 🔴 | 2 | GPU-ready risers + baffle | P38515-B21 / GPU baffle | 0–150 | **waiting on BH reply** |
| 🟠 | 4 | Power leads C13–C14 | 1 m, for the UPS | ~15 | check stock first |
| ✅ | — | Cisco console cable (RJ45→USB) | for the ASA 5525-X / OPNsense installs | 0 | **2 in hand (Minda, 2026-10-31)** |
| 🟠 | 0–4 | SSDs for the 5525-X | 2.5" SATA, only if the units arrive without | 0–80 | on arrival |
| ✅ | 3 | iLO Advanced licence | eBay 'lifetime' keys 3× £6.99 (27-15338-03501) — ⚠️ cheap resold keys; usually activate, but licensing legitimacy not guaranteed | 23 | ordered 2026-10-31 |
| ✅ | 1 | 10G card, R710 | **Mellanox MCX312B-XCCT** full-height, £39 (eBay 09-15371-31144, due 2–3 Nov) | 39 | ordered 2026-10-31 |
| ⚠️ | 1 | 10G card, Gen9 | ordered **HP 530T** (eBay 09-15371-31143, £21.60) = **10GBASE-T RJ45, not SFP+ → won't take a DAC**. Swap to **530SFP+ / 546SFP+** (same listing has options) or cancel before dispatch | 22 | **seller messaged 2026-10-31 (swap to 530SFP+/546SFP+ or cancel) — awaiting reply** |
| ✅ | 1 | SFP+ DAC 3 m | Cisco `SFP-H10GB-CU3M`, £7.99 (eBay 09-15371-31142) → 3 DACs total | 8 | ordered 2026-10-31 |
| 🔵 | — | Tertiary riser `826700-B21` + `P38517-B21` | only for a 3rd card | 50–120 | later |
| 🔵 | 2 | V100 32 GB | ~£700 each | ~1,400 | **only if pilot testing says so** |
| ✅ | 2 | APC AP9631 UPS network cards (HQ, one per UPS) | eBay 27-15338-03500 £43.10 + 27-15338-03503 £39.00 | 82 | ordered 2026-10-31 |
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

### ASA 5525-X arrivals (bench log)
| # | Arrived | Chassis label (pull tag) | Lic S/N (front) | HW ver | SSD | Notes |
|---|---|---|---|---|---|---|
| 1 | 2026-11-03 | ASA5525 SN FGL1823410U | FCH18187KX2 | V03 | none | 8x GE + MGMT + console; 2 of 4 arrived 3 Nov (HQ); boot/ROMMON check pending |
| 2 | 2026-11-03 | ASA5525 SN FGL19234?5X (read from photo - confirm via show version) | FCH19267THV (confirmed, close-up) | V04 | not checked | 2nd HQ unit |
| 3 | 2026-11-03 | ASA5525 SN FGL1804407Y (read from photo - confirm via show version) | FCH1802J4Y9 (close-up) | V02 | not checked (front bay visible) | old seller label "N3 FIREWALL", front sticker "JR20"; earliest hardware rev of the three; **assigned to Beverley (`bev-fw`) - Minda 2026-11-03**; boot/ROMMON check pending |
- Bench boot (3 Nov, **unit #2**, V04, Lic FCH19267THV): Cisco BIOS 9B2C109A (2013-05-15), Intel Xeon X3430 2.40GHz (4-core Lynnfield, **no AES-NI**), 8192 MB DDR3-1333, BMC init OK, POST OK. OPNsense note: fine for firewall/routing; IPsec slower without AES-NI; WireGuard (ChaCha20) unaffected.
- Unit #2 continued: ROMMON 2.1(9)8; booted disk0:/asa982-20-smp-k8.bin (ASA 9.8(2)20); image SHA2 hash verified; POST result 0 (pass); internal flash /dev/sda1 FAT32 ~8 GB (867586/2011280 clusters used), minor boot-sector/backup mismatch reported by dosfsck (harmless, not fixed). IPMI over LAN not active.
- Unit #2 show version: ASA 9.8(2)20 / FXOS 2.2(2.63) / ASDM 7.2(2)1; ASA5525 8192 MB, Lynnfield 4-core; 8 GB internal CF; BMC fw 2.4; **no startup-config (wiped)**; licence **ASA5525 VPN Premium, perpetual** (Active/Active failover, 2 contexts, 750 VPN peers); serial FCH19267THV; ports Gi0/0-0/7 MAC 188b.9d72.a290-a297 (0/0=a294 ordering), Management0/0 188b.9d72.a28f. Activation key NOT recorded (licence secret; not needed for OPNsense).

### Deliveries 2026-11-05 (from Minda's mail, read-only check)
- **Cisco ASA5500X-SSD120** — delivered 12:35 (eBay) → OPNsense installs can start (AWT-1069).
- **HPE 32GB 2Rx4 DDR4** (Gen10 RAM) — delivered 11:28.
- **renewtech HPE DL360/DL380 Gen9 network adapter** (listing 278422773036 → the 665249-B21 **560SFP+** swap) — DHL delivered 12:35. Check it is the **high-profile** bracket (seller asked HP/LP on 2 Nov).
- **Genuine Cisco SFP-H10GB DAC** — delivered 13:46 (one parcel; other DACs as ordered).
- **IT Black belt** parcel — Royal Mail delivered 5 Nov (item to confirm). A further Royal Mail parcel due Fri 6 Nov (sender to confirm).
- Compuwyze order 000000449 (GPU cables) — delivered 3 Nov.
