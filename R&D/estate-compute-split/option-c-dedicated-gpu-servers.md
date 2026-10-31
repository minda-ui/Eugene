# RND-23 option C — dedicated SXM2 V100 GPU servers

_R&D research (creative mode, 2026-10-31). Web research only — listings are **asking prices** (mostly
US eBay / UK resellers, late Oct 2026), not quotes; USD→GBP ≈ ×0.78. Guide-only (§3); nothing bought._

## What "SXM2" buys you
SXM2 V100s are module-style (not cards). They plug into special GPU boards with **NVLink** (~300 GB/s
GPU↔GPU, vs ~16 GB/s over PCIe) — so 4 or 8 GPUs act much more like one big GPU for a large model.
Modules are cheap because they only fit these boards.

## The candidates
| Box | Size | GPUs | GPU memory | Used asking price (seen) | ≈ £ | Notes |
|---|---|---|---|---|---|---|
| **Dell PowerEdge C4140** (SXM2 config) | **1U** | 4× V100 SXM2 + NVLink | 64 GB (16 GB cards) / **128 GB** (32 GB) | $2,557 (4×16 GB, 32 GB RAM, ETB-Tech) · $6,436 (4×32 GB, 128 GB RAM, ETB-Tech) · $6,575 (4×16 GB, eBay) | ~£2,000 / ~£5,000 | 2× Xeon Scalable, 24 DIMMs, 2× 2000–2400 W PSUs, **220 V required**. 1U = very loud. iDRAC (Dell, not iLO). |
| **Supermicro SYS-4029GP-TVRT** | 4U | **8× V100 SXM2** + NVLink | 128 GB (16 GB) / **256 GB** (32 GB) | $4,522 (8×16 GB, UK seller) · $7,999 (8×32 GB, 192 GB RAM) · up to $8,999 | ~£3,500 / ~£6,200 | 2× Xeon Scalable, 2200 W Titanium PSUs (redundant). 4U = quieter than 1U but still loud. IPMI. |
| **HPE Apollo 6500 Gen10 (XL270d)** | 4U | 4 or 8× V100 SXM2 + NVLink | up to 256 GB | ~€14,500 (8×32 GB, 2× Plat 8280, servershop24) | ~£12,500 | **HPE family + iLO 5** (fits the estate), but ~2× the price of the Supermicro. Rails alone ~$499. |
| (DIY) SXM2 module + PCIe adapter | — | 1 per adapter | 16/32 GB | 32 GB module ~$500–1,100 incl. adapter | — | **Not recommended** — cooling/firmware hit-and-miss; HPE doesn't support it. |

Reference point (option B): **DL380 Gen10 8SFF + 3× V100 PCIe 32 GB** ≈ £1,200–1,900 + 3× ~€600–700 ≈
**~£3,000–3,700 for 96 GB**, HPE-supported, iLO 5, 2U.

## Value per GB of GPU memory (rough)
| Option | GPU memory | ≈ £ | ≈ £ per GB |
|---|---|---|---|
| C4140 4×16 GB | 64 GB | 2,000 | ~31 |
| Supermicro 8×16 GB | 128 GB | 3,500 | ~27 |
| Supermicro 8×32 GB | **256 GB** | 6,200 | **~24** |
| C4140 4×32 GB | 128 GB | 5,000 | ~39 |
| DL380 Gen10 + 3× V100 PCIe | 96 GB | 3,000–3,700 | ~31–39 |
| Apollo 6500 8×32 GB | 256 GB | 12,500 | ~49 |

## The catches (be honest)
1. **Power.** 8× V100 = up to ~2.4 kW for the GPUs alone at full load; idle maybe ~500–700 W for the box.
   24/7 at ~600 W ≈ 14 kWh/day ≈ **~£1,500/yr** at 30p; heavy use far more. Needs **230 V** (UK fine) and a
   circuit + UPS that can take ~2.5–3 kW peak. **Check the HQ rack circuit/UPS first.**
2. **Noise + heat.** These are datacentre boxes — the 1U C4140 is very loud; the 4U Supermicro is loud.
   OK in a closed server room with cooling; not near people. Adds heat load to the room.
3. **Not HPE** (except the Apollo): different management (iDRAC / Supermicro IPMI), different spares, a new
   runbook. The Apollo keeps iLO but costs ~2×.
4. **Software age.** V100 = Volta. NVIDIA's newest driver/CUDA lines are dropping Volta (and Pascal — our
   P40s too); expect to stay on an older driver branch long-term (verify current status before buying).
   No FP8. Still fine for llama.cpp/vLLM-class inference today.
5. **Used-market risk:** asking prices vary 2–3×; configs differ (RAM, CPUs, rails, PSUs included?).
   Buy from a UK reseller with warranty (e.g. ETB-Tech) over a cheap eBay box.

## What it would mean for the estate
- **Supermicro 8×32 GB (256 GB GPU memory)** could run very large models entirely on GPU — the "huge model"
  goal without the CPU route — and several medium models at once for the whole workforce.
- Gen9 → storage/PBS/phones (as in the V100 sketch); P40s → Beverley failover. The HQ storage Gen10 and
  new Beverley P40s still drop out.

## Steer
- **Best value + biggest:** Supermicro 4029GP-TVRT 8×V100 32 GB, from a UK reseller with warranty —
  *if* the HQ room can take the power, heat and noise.
- **Smallest step:** C4140 4×V100 16 GB (~£2k) — cheap, but 1U noise and only 64 GB.
- **Stay HPE:** option B (DL380 Gen10 + V100 PCIe) remains the calm choice; Apollo only if budget allows.

## Before deciding (for Minda)
1. HQ rack: free U (1U vs 4U), circuit rating, UPS capacity, room cooling.
2. Is noise an issue where the rack sits?
3. Budget ceiling.
4. Comfortable adding a non-HPE vendor (Dell/Supermicro) to the estate?

## Sources
- Dell C4140 spec sheet + technical guide (i.dell.com); ETB-Tech C4140 listings; eBay C4140 listings.
- eBay / ETB-Tech / techyparts Supermicro SYS-4029GP-TVRT listings.
- servershop24 / eBay Apollo 6500 Gen10 listings.
- compute.exchange used V100 32 GB; illinitechs / runaihome SXM2 guides.

## Cost comparison — Supermicro 4029GP-TVRT vs DL380 Gen10 + V100 PCIe (2026-10-31, rough)
Assumptions: V100 PCIe 32 GB ≈ £520–600 used (guide price €599–699); DL380 build from `v100-brain-sketch.md`
(£1,250–2,000 incl. 3rd-riser parts); Supermicro = complete used systems as listed (CPUs + RAM included) +
~£150 rails/boot SSD; electricity 30p/kWh, 24/7 at a typical light-AI average draw. **Excludes** any HQ
power-circuit/UPS upgrade the Supermicro might need (unknown — could be £300–1,500+).

| | DL380 Gen10, 2× V100 | DL380 Gen10, 3× V100 | Supermicro 8× V100 16 GB | Supermicro 8× V100 32 GB |
|---|---|---|---|---|
| GPU memory | 64 GB | 96 GB | 128 GB | **256 GB** |
| Buy (≈) | £2,300–3,200 | £2,800–3,800 | ~£3,700 | ~£6,400 |
| Avg draw (≈) | ~250 W | ~300 W | ~550 W | ~600 W |
| Power / yr (≈) | ~£650 | ~£790 | ~£1,450 | ~£1,580 |
| **3-yr total (≈)** | **£4,250–5,150** | **£5,200–6,200** | **~£8,050** | **~£11,150** |
| 3-yr £ per GB | ~£66–80 | ~£54–65 | ~£63 | **~£44** |
| Biggest model on GPU (Q4, rough) | ~70B | ~120B | ~200B | ~400B |
| Size / noise | 2U, moderate | 2U, moderate | 4U, loud | 4U, loud |
| Vendor | HPE (iLO 5, our runbooks) | HPE | Supermicro (IPMI) | Supermicro |
| Grow later | +1 card (to 3) | full | swap to 32 GB modules | full |

Read: the DL380 is cheapest to own and run, and stays HPE. The Supermicro 32 GB box is the cheapest
**per GB** over 3 years and the only one that runs ~400B models on GPU — worth it only if those huge models
are the goal and the room/circuit can take it.
