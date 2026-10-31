# RND-30 follow-up — GPUs with longer support, ≤ £450 per card

_R&D research (creative mode, 2026-10-31, Minda: "cards supported longer, budget ≤ £450 per card"). Web research;
prices = UK listings / trackers seen today (used unless noted) — verify before buying. Guide-only (§3)._

## Why
P40 (Pascal) and V100 (Volta) are frozen on NVIDIA R580 + CUDA 12 (RND-30). **Turing** (2018–19) is still
actively supported, with no end date announced — but it's the obvious next in line. **Ampere, Ada, Blackwell**
have the longest runway. Newer cards also get FlashAttention-class speed-ups (Ampere+) and lower power.

## Speed rule of thumb
Chat speed ≈ memory bandwidth. V100 900 GB/s · A4000 / 5060 Ti 448 · P40 346 · T4 320 · 4060 Ti 288 · A2 200.

## Candidates
| Card | Gen | Memory | Bandwidth | Power / cooling | Fits our HPE Gen10? | Price seen | Support outlook |
|---|---|---|---|---|---|---|---|
| **Tesla V100 32 GB** (plan today) | Volta | 32 GB | **900 GB/s** | 250 W, passive, EPS 8-pin | ✅ HPE-supported (max 3) | ~£520–600 | ❌ frozen (R580) |
| **Tesla T4 16 GB** | Turing | 16 GB | 320 | **70 W, passive, no power cable (slot-powered)** | ✅ **HPE-supported, up to 7** | ~£450–720 (UK eBay) | 🟡 supported now; likely next to be dropped |
| **NVIDIA A2 16 GB** | Ampere | 16 GB | 200 | **60 W, passive, slot-powered** | ✅ HPE-supported, up to 8 | price not found — check | ✅ long |
| **RTX 5060 Ti 16 GB** | Blackwell | 16 GB | ~448 (sources differ) | ~180 W, fans, PCIe 8-pin | ⚠️ consumer card, not HPE-supported; fits a GPU riser, needs a PCIe-type power cable | ~£400–430 new (UK RRP); used ~£499+ seen | ✅✅ longest |
| **RTX 4060 Ti 16 GB** | Ada | 16 GB | 288 | ~165 W, fans, PCIe 8-pin | ⚠️ consumer, not HPE-supported | ~£300–350 used | ✅ long |
| **RTX A4000 16 GB** | Ampere | 16 GB | 448 | 140 W, single-slot blower, 6-pin | ⚠️ workstation card, not on HPE's list | ~$800 US (~£620) — **over budget** | ✅ long |
| *AMD Instinct MI50 32 GB* (wild card) | Vega 20 | 32 GB | ~1,000 | 300 W, passive | ⚠️ not HPE; AMD software (ROCm dropping it) | ~£150–250 | ❌ frozen on AMD side too |

## What it means
- **Under £450 nothing beats the V100 on speed AND support.** Newer = longer life, but slower (except the 5060 Ti,
  which is about half a V100's bandwidth) and only 16 GB per card.
- **T4 / A2 are the "no-drama" server cards:** HPE-supported, passive, **no GPU power cables at all** (after the P40
  cable saga, that matters), very low power (helps the UPS and summer cooling), up to 7–8 per DL380 Gen10. Trade-off:
  slow per card. E.g. 6× T4 = 96 GB at ~420 W total — runs a 70B model, but at roughly a third of the V100's speed.
- **RTX 5060 Ti** = the long-life *speed* pick in budget, new with warranty — but a consumer card in a server (fans,
  PCIe power cable, not HPE-supported). Note: the cables we have now are graphics-style; they *might* suit such a
  card — **only after a meter check against that card's socket** (HL-0110).

## Options for the HQ AI server
| Option | Cards | Total | Speed | Life | ~£ cards |
|---|---|---|---|---|---|
| **A. As planned** | 3× V100 32 GB | 96 GB | ★★★ | frozen (review ~2028) | ~1,560–1,800 |
| **B. Long-life speed** | 3× RTX 5060 Ti 16 GB | 48 GB | ★★ | longest | ~1,200–1,300 |
| **C. Low-power, HPE-supported** | 6× T4 16 GB | 96 GB | ★ | medium | ~2,700+ (at UK prices seen) |
| **D. Split** | HQ: V100s now (speed) → swap for newer cards at the ~2028 review | — | ★★★ then ★★★ | renewed | V100 now, later budget |

## Steer
Keep **A (V100)** for the main AI server — best speed per pound — and treat the R580 freeze as a **planned ~2028
refresh**, by which time Ampere/Ada server cards will be cheaper. If longevity matters more than speed, **B
(5060 Ti)** — but accept consumer-card caveats. **T4/A2** are a good fit for a *low-power* role (e.g. Beverley's
eyes/receptionist or the night shift) rather than the main brain.

## Sources
eBay UK Tesla T4 listings; Thunder Compute "T4 pricing (Oct 2026)"; GPUDojo RTX 5060 Ti 16 GB UK price history and RTX
A4000 used price; RunAIHome used RTX A4000; Aliteq RTX 5060 Ti for local AI; HPE DL380 Gen10 QuickSpecs a00008180enw
(GPU support list); Tom's Hardware / Phoronix (R580 last for Pascal/Volta; Turing not included).
