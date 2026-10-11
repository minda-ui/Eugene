# RND-2 — DL380 Gen9 GPU upgrade: parts list

_Shopping/checklist for the HQ private-AI compute upgrade. Verified against the install checklist in
`notes.md` (2026-10-07). Guide-only — Minda buys/fits (or an engineer fits); Eugene specs + verifies.
No secret held. Prices are indicative used-market (UK), confirm at purchase._

## Acquisitions log
**Build decision (2026-10-10): going for 2× P40 (48 GB, 70B tier)** — both risers ordered the same night.
Confirmed from the order emails in minda@'s Gmail:
- ✅ **HPE 719073-B21** secondary GPU riser (P40 **#1**) — Amazon £155.65, order 205-4556995-9286763
  (Renewed "Excellent"). Payment sorted 2026-10-10 (Minda updated the Amazon payment method) — confirmed.
- ✅ **eMagTech 8→10-pin GPU power cable (805123-001 / 803403-001), 25 cm** — Amazon £10.39, order
  205-2221513-6219536. Payment sorted (same). (One cable = powers **one** P40.)
- ✅ **HPE 719076-B21** *primary* GPU-ready riser (P40 **#2**) — Renewtech £95.00 (+£21 ship = £116),
  order WEB083034, card accepted, std 4–5 day UPS/Fedex. (Spare 777282-001.)
- ✅ **2× HP NVIDIA Tesla P40 24 GB (SKU 872323-001)** — **Bytestock £390.00 total (≈£195 each)**,
  order **#000006986**, card payment, DHL Domestic Express, free delivery (referral code). Both cards
  for the dual-P40 build. (Email says "GDDR5X" — the P40 is actually GDDR5; vendor typo, same card.)
- **Still to source for the full 2× build:** a **2nd power cable** (805123-001/728539-B21); **1400 W
  PSUs — HPE 720620-B21** (two cards ≈ 1400 W); **perf fan kit + GPU baffles**; then the **"Above 4G
  Decoding"** BIOS toggle on fit day.
- **GPU side now complete:** 2× P40 + both risers + 1 power cable all ordered. Remaining = power/cooling
  (2nd cable, 1400 W PSUs, fans/baffles) + the BIOS toggle.

## GPU options considered & rejected
- **NVIDIA Tesla M10 (HP Q0J62A), "32 GB"** — ❌ **rejected 2026-10-10.** It's **4× Maxwell GM107 GPUs,
  8 GB each** — NOT a 32 GB pool. A model only sees **8 GB**, so it can't run 24B/32B/70B at all; caps
  at ~7–8B. Older Maxwell arch, no tensor cores, built for **VDI**, not inference. Fits the same risers
  (double-wide, 225 W) but is a step *back* from the P40. Only niche use = 4 small models in parallel.
  **Verdict: wrong for the 70B estate-brain build; stay on the P40.**

## The box we're upgrading
HPE **ProLiant DL380 Gen9** (2U), 2× E5-2695 v4 (both sockets populated ✅ — the GPU riser hangs off
CPU2), 128 GB RAM, iLO4 `10.224.10.78`. Runs the **production PBX (VM 105)** — so this upgrade must not
starve the phones (model work stays in a resource-capped LXC/VM).

## Core parts — one Tesla P40 (the recommended start)

| # | Part | HPE / model no. | Why | ~Cost (used) | Got it? |
|---|---|---|---|---|---|
| 1 | **NVIDIA Tesla P40, 24 GB** (datacenter, passive) | HP **872323-001** | The GPU itself — 24 GB runs up to ~32B / Mixtral 8×7B fast, live site-photo vision | £150–250 | ✅ **ORDERED ×2** (2026-10-10, Bytestock £390 total, order #000006986) |
| 2 | **Secondary 3-slot GPU-ready riser kit** | HPE **719073-B21** (spare **777283-001**) | DL380 Gen9 GPU riser (2× FL x16 + 1× x8) the P40 mounts into; installs in the **secondary** slot, **needs CPU2** (✅). ⚠️ **NOT** the standard primary riser 777281-001 / 719072-001 / 729804-001 — those are x8 expansion risers, wrong for a GPU. | £40–90 | ✅ **GOT IT** (2026-10-10, Amazon Renewed, refurb "Excellent") |
| 3 | **GPU power cable** (10-pin → 8-pin) | HPE **805123-001** (or **728539-B21** = 10→6+8) | P40 needs an 8-pin PCIe power feed from the board | £10–25 | ✅ **ORDERED ×1** (2026-10-10, Amazon £10.39, payment sorted; need a 2nd for P40 #2) |
| 4 | **High-performance fan kit** (all 6 bays) | HPE Gen9 perf fans | P40 is **passive** — it relies entirely on server airflow; needs the high-static-pressure fans | £30–80 | ⬜ |
| 5 | **GPU air baffle / shroud** | HPE Gen9 GPU baffle | Ducts the airflow through the passive card; without it the P40 cooks | £10–30 | ⬜ |
| 6 | **PSUs — 2× 1400 W matched pair** | HPE **720620-B21** (spare **754382-001**) | Dual-P40 peak ~950 W; redundant mode = each PSU carries it alone, so 800 W won't do. 2× for 1+1 redundancy on the PBX box. Check what's fitted first. | ~£40–70 each | ⬜ (need 2) |

### PSU note — for the 2× P40 build (settled 2026-10-11)
**Redundancy, not total wattage, drives this.** On the DL380 Gen9 a 1+1 PSU pair does **not** combine —
they back each other up, so usable capacity = **one** PSU's rating, and HPE requires **both the same
wattage**. So each PSU must independently carry the whole box.

Worst-case load (full GPU): 2× E5-2695 v4 ~240 W + RAM/disks/fans/board ~180 W + 2× P40 @ 250 W = ~500 W
→ **~900–950 W peak**. In redundant mode each PSU must supply that alone:
- **800 W** (what's likely fitted) — ❌ **not enough** for dual-P40 redundant (950 > 800).
- **1400 W** — ✅ comfortable margin; standard Gen9 high-watt unit. (1200 W would also clear it, but 1400 W
  is commoner used + barely dearer.)

**Decision: buy 2× 1400 W as a matched pair — HPE 720620-B21 (spare 754382-001).** Keeps 1+1 redundancy
on the box that runs the production PBX. A single 1400 W would power it but only **non-redundant** — not
advised here.

**Fitted PSUs confirmed 2026-10-11: 2× 500 W** — ❌ **far too small** (redundant = 500 W usable vs ~950 W
dual-P40 peak; too small even for a single P40). **PSU upgrade is required**, not optional → the 2× 1400 W
above. The 500 W pair becomes spares.

## Free but critical — the #1 gotcha (no cost, just a BIOS toggle)
- **Enable "Above 4G Decoding"** in BIOS (a.k.a. "PCI 64-bit resource handling above 4G" / "MMIO above
  4 GB"). Without it the P40's 24 GB BAR won't map and **the card won't initialise.** This is where most
  P40-in-a-ProLiant installs fail. I'll give you the exact RBSU menu path on fit day.

## Power / cooling / UPS (ties to OI-7)
The extra ~250 W is heat + UPS draw beside the live PBX. Worth confirming the UPS has headroom before we
run the card hard (overnight batch vision is the heaviest draw). Flagged, not blocking.

## If/when you go to a second P40 later (the 70B tier)
The DL380 Gen9 supports **2× double-wide GPUs = 2× P40 = 48 GB** (full Llama 3.3 70B / Qwen2.5 72B via
tensor-split). But a P40 is **double-wide**, so the two cards can't share one riser — each needs its own
GPU-ready riser (the second card's heatsink overhangs the neighbouring slot). Second P40 therefore needs:
- A **second Tesla P40**.
- ⚠️ A **second, *primary* GPU-ready riser — HPE 719076-B21** (2-slot primary GPU-ready; spare 777282-001).
  The 719073-B21 (secondary) already bought holds P40 #1; #2 goes on the primary riser. **Correction
  (2026-10-10):** an earlier note here wrongly said no new riser was needed — a 2nd P40 **does** need
  719076-B21.
- A **second 8-pin power cable** (item 3 again).
- The **1400 W PSUs** (item 6) — HPE **720620-B21** — two cards ≈ 1400 W total.
- Both GPU positions baffled/cooled; **CPU2 populated** (✅, already).
Verified against HPE QuickSpecs + community (secondary riser 719073-B21 = slot2/CPU2; primary GPU riser
719076-B21; 1400 W PSU for double-wide). **Plan stays: start with one P40; add #2 only when the
earning use-cases justify the extra heat + UPS draw beside the live PBX.**

## Separate track — NOT this list (storage, RND-3)
The storage upgrade (NetApp DS2246 JBOD + external SAS HBA in IT mode + mini-SAS cable, P440ar → HBA
mode) is a **different** upgrade on the same box — see `R&D/estate-storage/design.md`. If *that's* the
one you've started, say so and I'll pull its parts list instead.

---
_Start = **one P40 + kit (items 1–5) + confirm PSU (6) + the BIOS toggle.** Everything else is a later,
optional step up to the 70B tier._
