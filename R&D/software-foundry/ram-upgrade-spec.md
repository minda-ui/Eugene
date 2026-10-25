# RND-19 — RAM upgrade spec for the HQ DL380 Gen9 (research sheet)

_R&D research sheet (git-primary; creative mode, 2026-10-25). For Minda to shop/research against. The RAM
grows the box into the 480B "foundry" batch brain (RND-19). Guide-only (§3): Eugene specs; Minda buys/fits
(or an engineer); fitting needs a brief power-down (snapshot VMs first). **Verify against the HPE DL380
Gen9 QuickSpecs + the label on your existing DIMM before buying** — part numbers below are from memory
(cutoff Jan 2026); the platform is 2016-era and stable, but confirm at purchase._

## Where we are now
- **HP ProLiant DL380 Gen9**, 2× Xeon **E5-2695 v4** (both sockets populated ✅).
- **4× 32 GB = 128 GB** fitted; DIMM assembly **809083-091** (HPE 32 GB 2Rx4 **DDR4-2400** RDIMM).
- **24 DIMM slots total** (12 per CPU) → **20 slots free.**

## The platform's limits (DL380 Gen9 + v4 CPUs)
- **Memory type:** DDR4 **ECC**, **Registered (RDIMM)** or **Load-Reduced (LRDIMM)**. (No unbuffered/UDIMM.)
- **Max speed:** **DDR4-2400** with v4 CPUs (your existing DIMMs are 2400 — good).
- **Max capacity:** up to **3.0 TB** (24× 128 GB LRDIMM) — far beyond anything we need.
- **Channels:** **8 total** (4 per CPU), **3 DIMM slots per channel** (3 DPC).
- **Speed vs population** (2400 DIMMs, v4): 1 DPC = 2400 · 2 DPC = 2400 · **3 DPC = drops to 1866**.
- **Bandwidth is what matters for CPU inference** (it's memory-bandwidth-bound). Best bandwidth =
  **all 8 channels populated and balanced** → always buy in **multiples of 8 DIMMs**, same size/type.

## The golden rules (so it posts + runs fast)
1. **Don't mix RDIMM and LRDIMM.** You're on RDIMM now → stay RDIMM (unless you replace *all* of it).
2. **Match size, rank and speed** across all DIMMs; everything runs at the **slowest** installed speed.
   The cleanest buy is **more of the same 32 GB 2Rx4 2400 RDIMM** (809083-091 / kit 805351-B21).
3. **Fill in multiples of 8** to keep all 8 channels even (bandwidth); follow HP's DIMM install order
   (iLO/the lid diagram shows it) and populate **both CPUs equally**.
4. **ECC Registered only.** Non-HPE compatible RDIMMs usually post fine but iLO may show a cosmetic
   "unqualified memory" warning — fine for a batch brain; HPE "SmartMemory" avoids the warning at a price.

## Target configs for the 480B dream (Q4 ≈ ~250 GB resident + context/OS headroom)
| Total | DIMMs (32 GB RDIMM) | Buy on top of the 4 you have | DPC | Speed | Fits 480B? | Rough used £ (DIMMs only) |
|---|---|---|---|---|---|---|
| **256 GB** | 8× 32 GB | **+4** | 1 DPC | 2400 (max bw) | yes, **tight** (~250 GB model leaves little for context) | ~£50–100 |
| **384 GB** | 12× 32 GB | +8 | mixed 1–2 DPC | 2400 | comfortable | ~£100–200 |
| **512 GB** ⭐ | 16× 32 GB | **+12** | 2 DPC | 2400 | **roomy** — big context + room for other models | ~£150–300 |
| **768 GB** | 24× 32 GB | +20 | 3 DPC | **1866** | overkill; and speed drops | ~£250–450 |

**Recommendation: aim for 512 GB (16× 32 GB RDIMM).** It holds the 480B at Q4 with real headroom for
long context and a second model, stays at full 2400 speed (2 DPC), and keeps all 8 channels balanced for
best CPU-inference bandwidth. **256 GB is the cheap entry** if you just want to prove it runs. Avoid 768 GB
(3 DPC forces 1866 and the extra capacity is wasted on us).

**Density alternative (only if you ever want to free slots):** 64 GB **LRDIMM** 2Rx4 2400 (kit 805358-B21)
→ 512 GB in 8× 64 GB at 1 DPC. Dearer per GB used, and you'd have to pull the existing RDIMMs (no mixing).
Not worth it for us — 32 GB RDIMMs are cheaper and plentiful.

## What to actually search for (used market)
- **"HPE 32GB 2Rx4 PC4-2400T-R"** (= PC4-19200R) — kit **805351-B21**, spare/assembly **809083-091** (your
  exact match), equivalent **819412-001**. Buy a matched lot of the same if you can.
- Sellers: the usual used-enterprise outfits (the ones we've used — Techbuyer, Bytestock — plus eBay
  refurb lots). A matched 12× or 16× lot from one seller beats mixed singles.
- Confirm each stick is **2Rx4, Registered, 2400, 1.2 V, 288-pin ECC**.

## Fitting (when the time comes — guide-only, Minda/engineer)
- **Snapshot the VMs (esp. PBX VM 105) and schedule a brief power-down** — same care as the GPU dry-fit.
- Power off, fit per HP's install order (balanced both CPUs), power on → **iLO re-inventories**; check
  the new total in POST/iLO and `free -h` in Proxmox; run a quick memtest pass if paranoid.
- Trivial power/heat impact vs the GPUs — not a UPS concern.

## Cost reality (the nice bit)
**512 GB of used DDR4-2400 ECC RDIMM is roughly £150–300** — i.e. a frontier-class *coder* capability for
the price of a decent laptop's RAM, on a box we already own. Classic recycled-kit economics (like the
NetApp shelf / the R710). The 480B runs *slow* (CPU batch, overnight) — but for the foundry's night-shift
job, slow-but-ours is exactly the point.

## Note
This is the **RAM path** (480B batch coder). It's **independent of the GPU path** — the P40s do the
real-time tier; the RAM does the big-but-slow tier. You could do either, both, or neither; they don't
depend on each other. Everything here stays R&D until you decide to pull the trigger.

---
_Guide-only; verify part numbers against HPE QuickSpecs + your DIMM label at purchase. Pairs with
RND-19 (foundry), RND-2 (the box). Eugene can run a live used-price check on request._
