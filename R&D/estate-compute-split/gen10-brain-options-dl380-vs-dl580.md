# RND-23 — Gen10 as the AI brain: DL380 Gen10 vs DL580 Gen10

_R&D (creative mode, 2026-10-31). Minda picked "Gen10 = AI brain" (flips RND-20: the Gen10 takes the P40s,
the Gen9 becomes storage/phones), then spotted the **DL580 Gen10 (4U, 4-socket)**. Guide-only (§3): Eugene
specs, Minda buys/fits. **Nothing ordered.** Verified = read from HPE's own document this session; otherwise
marked unverified._

## Why flip at all
The brain's CPU work (the big RAM model, prefill, batch "night shift") is limited by **memory bandwidth**.
GPU work on the P40s is the same on any of these boxes (PCIe Gen3 x16).

| Box | Sockets × channels | RAM speed | Peak bandwidth | vs Gen9 |
|---|---|---|---|---|
| **Gen9 DL380 (today)** | 2 × 4 | 2400 | ~154 GB/s | 1× |
| **DL380 Gen10** | 2 × 6 | 2933 | ~282 GB/s | **~1.8×** |
| **DL580 Gen10** | **4 × 6** | 2933 | **~563 GB/s** | **~3.7×** |

(Peak = sockets × channels × MT/s × 8 B. Real throughput lower, ratios hold. Needs every channel populated:
12 DIMMs for a DL380 Gen10, **24 DIMMs** for a DL580 Gen10.)

## Option A — DL380 Gen10 brain (verified against HPE QuickSpecs `a00008180enw`, archived/retired edition)
- **P40 (`Q0V80C`) officially supported: max 3 cards**, CPUs **≤165 W**, 1st or 2nd gen Xeon Scalable.
- **Chassis matters for heat (max inlet temp with P40s):** **8SFF = 35 °C**, 8LFF 35 °C, 16SFF 25 °C,
  **24SFF = 25 °C**, 12LFF 20 °C. → a brain wants the **8SFF** chassis (it doesn't need 24 bays).
- **Required with GPUs:** High-Performance fans **`867810-B21`** (standard on 24SFF/12LFF, must ADD on
  8SFF); High-Performance heatsinks **`826706-B21`** (standard on CPUs >130 W).
- **PSU:** "1× 1600 W recommended, works with 1× 800 W per GPU" → **2× `830272-B21` 1600 W Flex-Slot**.
- **RAM rule:** system memory ≥ 2× GPU memory (2× P40 = 48 GB → ≥96 GB). Plan **12× 32 GB = 384 GB**
  (all 12 channels) or reuse the Gen9's 2666 sticks topped up to 12.
- **CPU:** must be ≤165 W → **2× Gold 6252 (24c, 150 W)** ✅. ⚠️ **Platinum 8268 (205 W) is NOT allowed
  with the P40** (corrects the earlier RND-20 suggestion).
- **GPU power cable:** Gen10 kits are `871828-B21` (8-pin) / **`871829-B21` (8-pin keyed)** — both map to
  spare `875097-001` "GPU cables kit" (PartSurfer). Reseller listings tie `871829-B21` to spare
  **`869820-001` "8-pin to 8-pin, Tesla 12V-EPS"** (unverified). **Lesson from today: one-probe check
  before any cable touches a card — 12 V on the row AWAY from the clip.**
- **Risers:** P40 needs x16 full-length slots on Riser 1 + Riser 2 (only 2 rear SFF over the PSU then).
  Exact GPU-riser part numbers: **to confirm** at order time.

## Option B — DL580 Gen10 brain (mostly UNVERIFIED — HPE's DL580 QuickSpecs not reachable this session)
- 4U, **2 or 4 sockets**, **48 DIMM slots** (up to 6 TB), **up to 16 PCIe slots**, **up to 4 full-length
  double-wide GPUs** (QuickSpecs copy, via search). Up to 4× 1600 W Flex-Slot PSUs.
- **P40:** NVIDIA's certified-server list reportedly names the DL580 Gen10 for the P40 (forum, secondary).
- **Upside:** ~3.7× the Gen9's CPU-inference bandwidth; room for **4× P40 (96 GB VRAM)**; RAM for very big
  models; one box = the whole brain.
- **Costs to weigh (honest):**
  - **Power + heat.** 4 CPUs + 24 DIMMs + GPUs: think **~500–700 W idle-ish, 1.5 kW+ loaded**.
    ~600 W 24/7 ≈ 14 kWh/day ≈ **~£1,500/yr at 30p/kWh** — vs a DL380 Gen10 maybe half that.
  - **Noise + rack space:** 4U; confirm HQ rack space + cooling + circuit headroom.
  - **Parts bill:** 4 CPUs + 24 DIMMs to fill all channels. 2-CPU start is possible (half the bandwidth,
    ≈ DL380 Gen10) and grow later.
  - **GPU cable kit for DL580 Gen10:** unknown — must come from HPE's DL580 QuickSpecs before buying.

## V100 on the DL380 Gen10 (verified, same QuickSpecs, 2026-10-31)
| Card | HPE part | Max | CPU | Max inlet temp |
|---|---|---|---|---|
| Tesla V100 PCIe 32 GB | `Q9U36C` | 3 | ≤165 W, 1st/2nd gen | **8SFF 30 °C**; 8LFF/16SFF/24SFF 20 °C; 12LFF not supported |
| Tesla V100S PCIe 32 GB | `R4D73C` | 3 | ≤165 W, **2nd gen only** | same |
- PCIe only — SXM2 modules + adapters are not supported. HPE: **mixing GPU types not supported** (P40s *or* V100s).
- Why: HBM2 ~900 GB/s vs P40 346 GB/s + tensor cores → roughly 2–3× faster LLM tokens; 32 GB vs 24 GB.
- Pushes the chassis choice harder to **8SFF** (only config above 20 °C).

## Shape of the estate after the flip
- **Brain (new Gen10):** 2× P40 now (3–4 later), big RAM, AVX-512.
- **Gen9 → storage + PBS + phones spine:** it already has 256 GB, 1400 W PSUs, 10 G. Its P840 is RAID-only
  → for ZFS, an HBA (or HBA mode where supported) is needed — check before relying on it.
- **R710:** stays the 3rd backup copy (unchanged).
- Phones/PBX: move with care (snapshot first, phones-free window) — production-affecting, Minda executes.

## Steer (creative, not a decision)
- **DL380 Gen10 8SFF** = the sensible brain: verified P40 support, ~1.8×, modest power.
- **DL580 Gen10** = the moonshot brain: ~3.7× and 4 GPUs, but power bill + unknown cable kit. Worth it
  only if the big CPU model / night shift is the main goal. **Before deciding: get the DL580 QuickSpecs**
  (P40 support row, GPU cable kit, max GPU count with 4 CPUs, PSU rule) and a used price for a
  4-CPU/24-DIMM config.

## Open questions for Minda
1. What do you want the brain to do most — fast chat on the P40s (A is plenty) or the huge CPU model (B shines)?
2. Is the DL580 a specific listing? Price, CPUs, RAM, PSUs, risers included?
3. HQ rack: is there 4U free, and what's the power circuit/UPS headroom?

## Wider options (2026-10-31, Minda: "do we have other options?")
- **A. Keep Gen9 + P40s** — genuine `805123-001` cables (AWT-1061, ~£50) → working brain now; decide the rest calmly.
- **B. DL380 Gen10, other HPE-supported GPUs** (QuickSpecs `a00008180enw`, verified max qty): V100/V100S 32 GB ×3 · **Quadro RTX 8000 48 GB ×2** (2nd-gen CPU) · A40 48 GB ×2 · A30 24 GB ×2 · A16 64 GB ×2 · **T4 16 GB ×7** (70 W, single-slot) · A2 16 GB ×8.
- **C. Dedicated GPU server** — 4–8× **SXM2 V100** boxes (Dell C4140, Supermicro/Gigabyte/Inspur): SXM2 modules cheap used + NVLink; loud, power-hungry, non-HPE.
- **D. Not a server** — **Mac Studio Ultra 192–512 GB unified memory** (huge models, quiet, ~200 W; £4–10k) · **RTX 3090 24 GB** in a tower (best perf/£; won't power/cool properly in an HPE chassis).
- **E. Hybrid** — modest local box for private daily work + cloud (Claude / rented GPUs) for heavy jobs; cheapest, but data leaves the building.
- Steer: A now; then B (V100 / RTX 8000) for fast chat, or D (Mac Studio) for the biggest models quietly. Needs Minda's priority (cost / chat speed / model size / noise+power).
