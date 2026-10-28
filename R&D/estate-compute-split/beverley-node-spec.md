# Beverley node — 2nd Gen10: off-site storage replica + full failover brain (2× P40)

> **Eugene, 2026-10-28 (guide-only, §3): Eugene specs; Minda buys/fits.** Decision (Minda): **Beverley gets
> a 2nd DL380 Gen10** = SSD storage replica **+ 2× Tesla P40** (full HQ-parity failover brain). This is
> RND-18's sovereign/failover lane made real — if HQ goes dark (power/internet/fire), Beverley serves the
> data **and** runs the full brain. The P40 requirement rules out the R710 (poor GPU host, PCIe Gen2) →
> Gen10. Part numbers below are from HPE's Gen10 I/O & power docs (2026-10-28) — **verify on HPE PartSurfer/
> QuickSpecs at purchase.** Pairs with `gen10-r710-replacement.md` (the HQ storage Gen10 base spec) + RND-18._

## Role
- **Off-site storage replica** (SSD) — **pulls** from the HQ primary (OI-26 pull-not-push); a Beverley PBS
  sync job + ZFS receive, Beverley-initiated.
- **Full failover brain** — 2× P40 (48 GB), identical to HQ, so either site can run the complete brain.
- At Minda's home → **silent, cool, low-power, reliable, always-ready** matters → SSD + 24/7.

## ⚠️ The compatibility rule that shapes the build (verified 2026-10-28)
**HPE: the Tesla P40 is NOT supported with processors over 160 W TDP** on the DL380 Gen10. Our storage pick,
the **Gold 6226, is 125 W → under the limit ✅** — so the *same cheap 2× 6226* config is both the storage CPU
**and** P40-compatible. (This would have broken with a Platinum 8268 at 205 W — a reason the brain-tier CPU
fork was never needed here.) **Keep the CPU ≤ 160 W** (6226 125 W / 6242 150 W / 6246 165 W ✗).

## BOM — Beverley Gen10 (= the HQ storage Gen10 base, with the GPU + SSD deltas)
Start from `gen10-r710-replacement.md`'s base, then **change these lines**:

| Part | Pick | Note |
|---|---|---|
| Chassis | DL380 Gen10 **24SFF** | as HQ (~£235); confirm it includes the **SAS expander** for the E208i-a |
| CPU | **2× Gold 6226 (125 W)** | ✅ **P40-compatible (≤160 W)** + lights up PCIe for the GPU risers; ~£54 |
| Heatsinks | **2× High-Performance** | **required** for the GPU config (not the Standard option) |
| HBA (storage) | **E208i-a** (HBA/pass-through) | ZFS wants raw disks; ~£54 |
| **PSU** ⬆️ | **2× 1600 W Flex-Slot Platinum `830272-B21`** (spare 863373-001) | **replaces the 500 W storage PSUs** — HPE recommends **1× 1600 W** for GPUs (works on 1× 800 W per GPU); buy **2× for redundancy**, and **both must match** (no mixing). ~£30–60 ea used |
| **GPU riser(s)** ➕ | **GPU-capable riser kit to seat 2× double-wide P40** | Gen10 options: **P14374-B21** (x16/x16/x16 Primary GPU FIO), **P14373-B21** (x16/x16/x16 Secondary GPU FIO), or **826704-B21** (x16/x16 GPU). **Verify the exact combo** against the CTO/processor count — these are NOT the Gen9 719073/719076 risers |
| **GPU power cables** ➕ | **871829-B21** (keyed 8-pin GPU cable kit; spare 875097-001) | one per P40; note keyed (871829) vs unkeyed (871828) |
| **GPU baffle** ➕ | Gen10 GPU air baffle/shroud | P40s are **passively cooled** → mandatory for load (same as HQ) |
| **GPUs** ➕ | **2× Tesla P40 24 GB** (spare **872323-001**) | the cards we run at HQ; **buy 2 more** (Bytestock ~£195 ea) |
| RAM | 64–128 GB DDR4-**2933** | ZFS ARC + model working set |
| **Drives** ⬆️ | **SSD** (e.g. 8× 1.92 TB enterprise SATA/SAS → ~11 TB RAIDZ2) | **replaces the 10K HDDs** — silent/cool/low-power/instant-wake at home; sized to match HQ's ~11.6 TB |
| BIOS | **Above 4G Decoding** (+ large MMIO) | so both 24 GB P40s map |
| Rails | DL380 Gen10 rail kit | |

**Rough Beverley total ≈ £1,750–2,250** (chassis ~£235 · CPU ~£54 · heatsinks ~£78 · HBA ~£54 · 2× 1600 W PSU ~£60–120 · RAM ~£160–240 · GPU risers ~£50–150 · GPU cables ~£20–40 · baffle ~£10–30 · 2× P40 ~£390 · SSDs ~£600–900 · rails ~£30). Verify all at purchase.

## Power / running cost (Beverley, 24/7, ~£0.28/kWh ≈ £2.50/W-yr)
- Host ~120 W + 8 SSDs ~16 W + **2× P40 idle ~20–100 W** (Pascal) ≈ **~155–235 W idle** → **~£390–590/yr**.
- Under inference, +~250 W per active P40 (bursty, not continuous).
- Still far below the R710+HDD-shelf (~355 W / ~£890) **and** silent/cool/reliable — the right box for a home
  site that must be always-ready for failover.

## Estate-wide knock-ons (to plan separately — not blocking)
- **P40 tally = 4 total** (HQ 2 + Beverley 2). **Own 2 → buy 2 more.**
- **The R710 is freed** (Beverley no longer takes it). Options: **cold spare**, a **3rd backup copy**
  (R710 + DS2246 = a true 3-2-1 third tier), or **retire** for power. Minda's call.
- **Drive logistics:** HQ Gen10 (24 internal) takes the 24 HDDs; Beverley Gen10 runs its own SSDs; the
  8 R710-internal HDDs free up with the R710. Map the migration when Gen10 #1 lands.
- **Two Gen10s = identical platform** both sites → identical spares, one runbook, swappable roles.

---
_Guide-only (§3); part numbers from HPE Gen10 docs 2026-10-28 — verify at purchase. P40 needs CPU ≤160 W
(6226 ✓). Pairs with `gen10-r710-replacement.md` (storage base), RND-18 (sovereign/failover), RND-3
(storage), OI-26 (pull backups). Sources: HPE DL380 Gen10 I/O Expansion & Power Supply docs; HPE Gen10
GPU riser kits P14374/P14373/826704-B21; GPU cable kit 871829-B21; PSU 830272-B21 (1600 W); P40 spare
872323-001._
