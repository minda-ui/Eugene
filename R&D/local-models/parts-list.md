# RND-2 — DL380 Gen9 GPU upgrade: parts list

_Shopping/checklist for the HQ private-AI compute upgrade. Verified against the install checklist in
`notes.md` (2026-10-07). Guide-only — Minda buys/fits (or an engineer fits); Eugene specs + verifies.
No secret held. Prices are indicative used-market (UK), confirm at purchase._

## The box we're upgrading
HPE **ProLiant DL380 Gen9** (2U), 2× E5-2695 v4 (both sockets populated ✅ — the GPU riser hangs off
CPU2), 128 GB RAM, iLO4 `10.224.10.78`. Runs the **production PBX (VM 105)** — so this upgrade must not
starve the phones (model work stays in a resource-capped LXC/VM).

## Core parts — one Tesla P40 (the recommended start)

| # | Part | HPE / model no. | Why | ~Cost (used) | Got it? |
|---|---|---|---|---|---|
| 1 | **NVIDIA Tesla P40, 24 GB** (datacenter, passive) | GPU-P40 | The GPU itself — 24 GB runs up to ~32B / Mixtral 8×7B fast, live site-photo vision | £150–250 | ⬜ |
| 2 | **GPU enablement / double-wide riser kit** | HPE **719082-B21** | DL380 Gen9 riser + bracket the P40 mounts into (off CPU2) | £40–90 | ⬜ |
| 3 | **GPU power cable** (10-pin → 8-pin) | HPE **805123-001** (or **728539-B21** = 10→6+8) | P40 needs an 8-pin PCIe power feed from the board | £10–25 | ⬜ |
| 4 | **High-performance fan kit** (all 6 bays) | HPE Gen9 perf fans | P40 is **passive** — it relies entirely on server airflow; needs the high-static-pressure fans | £30–80 | ⬜ |
| 5 | **GPU air baffle / shroud** | HPE Gen9 GPU baffle | Ducts the airflow through the passive card; without it the P40 cooks | £10–30 | ⬜ |
| 6 | **PSUs adequate for the load** | see note below | ~800 W total needs headroom; check what's fitted now | £0 if already OK | ⬜ |

### PSU note (check before buying)
One P40 ≈ 250 W on top of the base ~300–400 W → want **≥800 W**, redundant. DL380 Gen9 uses HPE
**Flex Slot / common-slot** PSUs. Typical options:
- **800 W Platinum** — HPE **720479-B21** (spare **754378-001**)
- **1400 W** (headroom for a second card later) — HPE **720620-B21** (spare **754382-001**)

**First step:** read the label on the two PSUs already in the box. If they're already ≥800 W you need
**nothing here** — don't buy blind.

## Free but critical — the #1 gotcha (no cost, just a BIOS toggle)
- **Enable "Above 4G Decoding"** in BIOS (a.k.a. "PCI 64-bit resource handling above 4G" / "MMIO above
  4 GB"). Without it the P40's 24 GB BAR won't map and **the card won't initialise.** This is where most
  P40-in-a-ProLiant installs fail. I'll give you the exact RBSU menu path on fit day.

## Power / cooling / UPS (ties to OI-7)
The extra ~250 W is heat + UPS draw beside the live PBX. Worth confirming the UPS has headroom before we
run the card hard (overnight batch vision is the heaviest draw). Flagged, not blocking.

## If/when you go to a second P40 later (the 70B tier)
- A **second Tesla P40** (→ 48 GB pooled = full Llama 3.3 70B / Qwen2.5 72B via tensor-split).
- **Second power cable** (item 3 again).
- Likely the **1400 W PSUs** (item 6) — two cards ≈ 1400 W total.
- The 719082-B21 kit supports up to 2× double-wide in the 2U, so no new riser needed.

## Separate track — NOT this list (storage, RND-3)
The storage upgrade (NetApp DS2246 JBOD + external SAS HBA in IT mode + mini-SAS cable, P440ar → HBA
mode) is a **different** upgrade on the same box — see `R&D/estate-storage/design.md`. If *that's* the
one you've started, say so and I'll pull its parts list instead.

---
_Start = **one P40 + kit (items 1–5) + confirm PSU (6) + the BIOS toggle.** Everything else is a later,
optional step up to the 70B tier._
