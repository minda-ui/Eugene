# RND-19 — RAM upgrade spec for the HQ DL380 Gen9 (research sheet)

_R&D research sheet (git-primary; creative mode, 2026-10-25). For Minda to shop/research against. The RAM
grows the box into the 480B "foundry" batch brain (RND-19). Guide-only (§3): Eugene specs; Minda buys/fits
(or an engineer); fitting needs a brief power-down (snapshot VMs first). **Verify against the HPE DL380
Gen9 QuickSpecs + the label on your existing DIMM before buying** — part numbers below are from memory
(cutoff Jan 2026); the platform is 2016-era and stable, but confirm at purchase._

## ✅ ACQUIRED — first step bought (2026-10-26, Minda)
- **HPE 840758-091 — 4× 32 GB = 128 GB kit** (HPE 32 GB **2Rx4 PC4-2666V-R** SmartMemory, SK hynix),
  genuine HPE, matched kit, from eBay UK (seller `sakha465`). → **takes the box to 256 GB** (the 480B
  "prove it runs" tier), **all 8 channels at 1 DPC** (best bandwidth).
- **It's 2666; the box maxes at 2400 → it down-clocks to 2400.** No problem — just no speed benefit.
  Genuine HPE ⇒ **no iLO "unqualified memory" warning**.
- **Mixing note:** the fitted 4× are **809083-091 (2400)**, the new 4× are **840758-091 (2666→2400)** —
  both HPE, both 32 GB 2Rx4, so they run together fine at **2400**. HPE "prefers matched" but same-size/
  same-rank mixing is routine and works; if you ever want it perfectly clean, make one set the spares.
- **Still to do for the foundry build:** (a) **fit** (guide-only; power-down + VM snapshots first — see
  Fitting below); (b) stand up the **480B-A35B at Q4 on CPU/batch** (RND-19 foundry rehearsal). Next
  capacity step (if ever): +8 more 32 GB → 512 GB (2 DPC, still 2400).

## Where we are now
- **HP ProLiant DL380 Gen9**, 2× Xeon **E5-2695 v4** (both sockets populated ✅).
- **4× 32 GB = 128 GB** fitted; DIMM assembly **809083-091** (HPE 32 GB 2Rx4 **DDR4-2400** RDIMM).
  **+ 4× 32 GB 840758-091 now acquired → 256 GB once fitted** (see Acquired, above).
- **24 DIMM slots total** (12 per CPU) → **20 slots free** (16 free after this kit is fitted).

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
_Costs updated with a **live used-market check, 2026-10-25** (see the dated section below). Per-module used
≈ **£80–120** (NOT the ~£12–25 an earlier draft wrongly guessed — that was old/smaller-DIMM pricing; this
correction matters)._

| Total | DIMMs (32 GB RDIMM) | Buy on top of the 4 you have | DPC | Speed | Fits 480B? | Realistic used £ (DIMMs only) |
|---|---|---|---|---|---|---|
| **256 GB** | 8× 32 GB | **+4** | 1 DPC | 2400 (max bw) | yes, **tight** (~250 GB model leaves little for context) | ~£350–480 |
| **384 GB** | 12× 32 GB | +8 | mixed 1–2 DPC | 2400 | comfortable | ~£700–950 |
| **512 GB** ⭐ | 16× 32 GB | **+12** | 2 DPC | 2400 | **roomy** — big context + room for other models | ~£1,000–1,450 |
| **768 GB** | 24× 32 GB | +20 | 3 DPC | **1866** | overkill; and speed drops | ~£1,700–2,400 |

**Recommendation: aim for 512 GB (16× 32 GB RDIMM).** It holds the 480B at Q4 with real headroom for
long context and a second model, stays at full 2400 speed (2 DPC), and keeps all 8 channels balanced for
best CPU-inference bandwidth. **256 GB (~£350–480) is the sensible cheap entry** to prove it runs before
committing to the full 512 GB. Avoid 768 GB (3 DPC forces 1866 and the extra capacity is wasted on us).

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

## Cost reality (corrected after the live check)
**512 GB of used DDR4-2400 ECC RDIMM is roughly £1,000–1,450** (12× 32 GB at ~£80–120 each) — more than
the first draft's flippant "£150–300", so worth being straight: this is a **four-figure** upgrade, not
pocket money. Still, in context it's a *frontier-class coder* for ~£1k of recycled parts on a box we
already own — cheap against any commercial equivalent, and the **256 GB entry at ~£350–480** lets you
prove the whole idea before spending the full amount. The 480B runs *slow* (CPU batch, overnight) — but
for the foundry's night-shift job, slow-but-ours is the point.

## Live used-market check — 2026-10-25 (asking prices; web search is US-centric)
Part: **HPE 32 GB 2Rx4 PC4-2400T-R** (805351-B21 / 809083-091 / 819412-001).
- **Per module, used:** one **confirmed eBay sale at $125**; lower asks **$85–120** (Micron $85 BIN,
  Samsung ~$120); higher asks $150–285; a **UK eBay used listing ended at £109**; a European refurb seller
  **€149.95** (on sale from €199.95). → **realistic used ≈ £80–120/module.**
- **Matched/warranty (dearer):** Origin Storage via a UK retailer **£284.12** per 32 GB module (lifetime
  warranty, matched) — the "pay for certainty" end.
- **Bulk:** lots of 2 seen ≈ $170/module — buying a single matched 12–16 lot from one seller is the move
  (consistency > chasing the cheapest singles).
- **Techbuyer / Bytestock:** didn't surface in search — **check their sites directly** (we have accounts),
  they're often good for matched used server RAM and a VAT invoice.
- **Caveat:** these are mostly *asking* prices and US-centric; for true UK market value use eBay UK's
  **Sold items** filter on "805351-B21" / "HPE 32GB 2Rx4 PC4-2400T-R", and confirm each stick is
  **2Rx4, Registered, 2400, 1.2 V, 288-pin ECC**.
- Sources: eBay listings/sold data; serverando.de (€149.95); avoira.com / Origin Storage (£284.12).

## Note
This is the **RAM path** (480B batch coder). It's **independent of the GPU path** — the P40s do the
real-time tier; the RAM does the big-but-slow tier. You could do either, both, or neither; they don't
depend on each other. Everything here stays R&D until you decide to pull the trigger.

---
_Guide-only; verify part numbers against HPE QuickSpecs + your DIMM label at purchase. Pairs with
RND-19 (foundry), RND-2 (the box). Eugene can run a live used-price check on request._
