# RND-23 sketch — the V100 version: DL380 Gen10 brain at HQ, P40s to Beverley

_R&D sketch (creative mode, 2026-10-31, Minda: "sketch the V100 version"). Guide-only (§3). Nothing bought.
HPE facts verified from DL380 Gen10 QuickSpecs `a00008180enw` unless marked. Prices = rough used-market
estimates or the 26 Oct Techbuyer quotes — **check before buying**. V100 price is the big unknown._

## The idea in one line
**Buy one new box — a DL380 Gen10 8SFF with V100s — as the HQ AI brain. Everything else shuffles down a role
and two planned purchases disappear.**

```
TODAY                                   V100 VERSION
HQ  Gen9  = brain (2× P40) + storage    HQ  Gen10 8SFF (NEW) = AI brain, 2× V100 32 GB (3rd later)
          + phones (PBX)                HQ  Gen9             = storage pool + PBS + phones (no GPUs)
HQ  R710  = 3rd backup copy             HQ  R710             = 3rd backup copy (unchanged)
BEV (planned Gen10 + 2 NEW P40s)        BEV Gen10            = replica + failover brain with OUR 2× P40
```

## What it saves
| Planned purchase | Status in this version | Saving |
|---|---|---|
| HQ Gen10 **storage spine** (RND-20, ~£650–845) | **Not needed** — the Gen9 already holds the `tank` pool (shelf on the CP400e), PBS and the PBX; it just stops being the brain | **~£650–845** |
| **2× new P40** for Beverley (~£195 ea) | **Not needed** — the HQ P40s move there (with genuine Gen10 cables) | **~£390** |
| Genuine Gen9 P40 cables (AWT-1061, 2× `805123-001`) | Only needed if the P40s run in the Gen9 meanwhile — **could skip** if the V100 box comes soon | small |

## HQ brain — parts (DL380 Gen10 8SFF, built for 3× V100)
| Part | Spec | Why | ~£ |
|---|---|---|---|
| Chassis | **DL380 Gen10 8SFF** | only config rated **30 °C** with V100 (others 20 °C) | 200–300 |
| CPU | **2× Gold 6252** (24c, 150 W, 2nd gen) | V100 needs ≤165 W; V100S needs 2nd gen; AVX-512 | ~168 |
| Heatsinks | 2× High-Performance `826706-B21` | required for double-wide GPUs (standard on >130 W CPUs — check it's included) | 0–78 |
| Fans | High-Performance fan kit `867810-B21` (all 6) | required for any GPU; **not** standard on 8SFF | 40–100 |
| PSU | **2× 1600 W Flex-Slot `830272-B21`** | HPE: 1600 W recommended (min 800 W per GPU) | 60–120 |
| RAM | **12× 32 GB DDR4-2933 = 384 GB** | fills all 12 channels (full bandwidth); HPE rule ≥2× GPU memory (3× 32 = 96 → ≥192 GB) | 480–720 |
| GPU risers | Primary + Secondary GPU risers (Beverley spec lists `P14374-B21` / `P14373-B21` or `826704-B21`) | x16 full-length slots for 3 double-wide cards — **confirm exact parts** | 50–150 |
| 3rd-card riser | **x16 Tertiary Riser `826700-B21`** (FH/FL, slot 7, needs CPU 2) + retainer-less cages **`P38515-B21`** (primary) and **`P38517-B21`** (secondary+tertiary butterfly) | Gen10's **third riser position** (rear-left, over the PSUs) — the Gen9 has no third riser, which is why it tops out at 2 cards. Costs the rear-drive option | 50–120 |
| GPU power | **`871829-B21`** keyed 8-pin kit, one per card | V100 PCIe = EPS-style 8-pin (same family as the P40) — **one-probe check before plugging (HL-0110)** | 20–60 |
| GPU baffle | Gen10 GPU air baffle | passive cards — mandatory under load | 20–60 |
| Network | **10 G FlexibleLOM** (e.g. 562FLR-SFP+ — confirm part) | keeps PCIe slots free for GPUs; **Cisco SFP+ DAC cables on hand** (2 spare); **free 10G switch slots probably none** (ASA links use the module slots — TBC) → NM-4-10G upgrade or a 2nd Gen9 10G card + direct cable | 30–60 |
| Boot | 2× SATA SSD (mirror) on the onboard controller | Proxmox boot; models load from the Gen9 pool over 10 G or a local SSD | 100–200 |
| Rails | | | ~30 |
| **Subtotal (no GPUs)** | | | **~£1,200–1,900** |
| **GPUs** | **2× Tesla V100 PCIe 32 GB** (`Q9U36C`) or **V100S** (`R4D73C`) | PCIe only — **no SXM2 + adapter** | **get quotes** |

BIOS: Above 4G Decoding / large MMIO on; Max Cooling. Driver: the 535 branch already used for the P40s also
covers Volta (verify at install).

## Why the V100 is worth it over the P40
| | P40 | V100 PCIe 32 GB |
|---|---|---|
| Memory | 24 GB GDDR5, ~346 GB/s | **32 GB HBM2, ~900 GB/s** |
| Tensor cores / fast FP16 | no | **yes** |
| Rough effect on chat speed | 1× | **~2–3×** |
| Two cards together | 48 GB | **64 GB** (96 GB with a 3rd) |

**3-card power note:** HPE: 1600 W recommended, ≥800 W per GPU. With 3× V100 at full load, 2× 1600 W may no longer be redundant (1+1) — run HPE Power Advisor before fitting card 3.

## Phasing (low risk, phones never touched first)
1. **Price check** — V100 PCIe 32 GB ×2 quotes; DL380 Gen10 8SFF CTO quote (Techbuyer) with the parts above.
2. **Build + burn-in** the Gen10 brain beside the Gen9 (genuine cables, one-probe check, baffle, load test).
3. **Move the AI workloads** to it. The Gen9 keeps storage, PBS and the PBX exactly as now.
4. **Take the P40s out of the Gen9** (it becomes a plain storage/phones server; no GPU parts left to fail).
5. **Beverley Gen10** gets the 2× P40 + 2× genuine Gen10 cables (`871829-B21`) → failover brain.
6. Later: a **3rd V100** in the HQ brain (same model — HPE doesn't support mixing GPU types).

## Open questions for Minda
1. V100 or V100S? (V100S is a bit faster, needs 2nd-gen CPUs — the 6252 is 2nd gen, so either works.)
2. Budget ceiling for the GPUs?
3. Keep the Gen9's 2× 1400 W PSUs (fine for storage) or swap to smaller ones later to save power?
4. 10 G: is there a free 10 G port on the HQ 3850 stack, or do we need a module/switch change?

## DECISION (Minda, 2026-10-31): **DL380 Gen10** (option A) chosen over the DL385 Gen10 Plus (option B, ~£3k more).
**Final build checklist for quotes** (8SFF chassis):
- **2× Xeon Gold 6230 (20c, 125 W, 2nd gen, DDR4-2933) — £25 each at Bargain Hardware (2026-10-31)**, alt 2× Gold 6238 (22c, 140 W, £60 each). Rules: ≤165 W with V100/P40 (HPE); 2nd gen (62x0) for 2933 memory; avoid 1st gen 61xx (2666) and 200–205 W parts. + 2× High-Performance heatsinks (826706-B21) · HP fan kit 867810-B21 (all 6)
- **RAM — DECIDED (Minda, 2026-10-31, option C): 384 GB = 12× 32 GB DDR4-2666** → buy **8× 32 GB DDR4-2666 2Rx4 (£180 each = £1,440 ex VAT, Bargain Hardware)** + **move 4 of the Gen9's 8× HPE 32 GB DDR4-2666** (Gen9 keeps 4× 32 GB = 128 GB for storage + PBX). ~9 % slower than 2933 but fits the 480B (~270 GB); saves £720 vs buying 12. Gen9 RAM move = planned shutdown in a phones-free window when the new server arrives (2 DIMMs per CPU on the Gen9, populated per HPE's rules). Controller: **E208i-a (£43)** — not 'No RAID' (no cables) or S100i (SATA only). NVMe boot (NS204i): none.
- 2× 1600 W Flex-Slot PSU (830272-B21) · rails · C13–C14 leads to the UPS
- **E208i-a** (SAS-capable, HBA mode) · **2× boot SSD** (mirror) + **Minda's 6× Seagate 900 GB 10K SAS** = model library · **8× HPE SFF caddies**
- **2-port 10/25G FlexibleLOM — prefer a Mellanox-based one (e.g. HPE 640FLR-SFP28; confirm part)**: the Intel X710-based 562FLR can reject non-Intel modules; the Cisco DACs are more likely to work on Mellanox
- GPU-ready primary + secondary risers (+ tertiary x16 826700-B21 for card 3) + retainer-less cages P38515/P38517-B21 + GPU baffle
- 2× **V100 32 GB PCIe** (Q9U36C) + 2× **871829-B21** cable kits — one-probe check before plugging (HL-0110)
- iLO 5: confirm **iLO Advanced** licence (full remote console)
- **RAM update (2026-10-31, supersedes option C):** buy **HPE 32 GB 2Rx4 DDR4-2933 RDIMM P03052-091** (retail kit P00924-B21) —
  eBay seller IT Black Belt, £149.99 each, **only 6 in stock → buy 6**, find **6 more of the same part** elsewhere (≤ ~£150) → **12 sticks =
  384 GB at full 2933** (6 per CPU). Interim: 6 sticks = 3/6 channels (~141 GB/s), 8 = 4/6 (~188 GB/s); **never 16** (uneven, slower than 12).
  Gen9 keeps its 256 GB. Fallback = option C (mix with Gen9 2666 → all at 2666). Bargain Hardware memory = 0. Ask for VAT invoices.
- **Quotes pending (2026-10-31):** Minda requesting quotes from **Bargain Hardware** (configured build £473 ex VAT before
  heatsink/fan fix: change to 2× High-Performance heatsinks + add 6× High-Performance fans; add 2 boot SSDs) and **Techbuyer**
  (same spec). Questions to both: GPU-Ready contents (2× x16 FL, baffle, P38515-B21), 871829-B21 ×2, embedded 4×1G LOM,
  tertiary riser 826700-B21 + P38517-B21, optional 2× V100 32 GB price. Eugene to compare line by line when back.
- **Techbuyer quote (2026-10-31):** £649.24 ex VAT (£779.10 inc), **1-year warranty** — chassis DL380 Gen10 8SFF £265.78 · 2× HP
  heatsinks £38.81 · 2× Gold 6238 £73.74 · 640SFP28 £38.04 · E208i-a £54.34 · rails 733660-B21 £65.98. **Missing:** PSUs, HP fans,
  caddies, boot SSDs; GPU-ready risers not stated → complete ≈ £850–950. **Bargain Hardware** complete ≈ £560–650 ex VAT with a
  **3-year** warranty → BH preferred unless Techbuyer price-matches. Awaiting BH answers to the 4 questions.
- **Like-for-like (2026-10-31, both 2× Gold 6238):** **Bargain Hardware £583.00 ex VAT (£699.60 inc)** — GPU Ready 6-slot chassis, HP
  heatsinks, E208i-a, 8 caddies, 640FLR-SFP28, 2× 1600 W, rails, **3-yr RTB**, 4 available. **Techbuyer £649.24** missing PSUs + caddies
  (→ ~£750–830), 1-yr. **Choose Bargain Hardware.** Still to add on BH: **6× High-Performance/Max-Performance fans** (no Fans line in
  the summary) + 2 boot SSDs; then the 4 questions (GPU-Ready contents incl. baffle + 871829-B21, embedded 4×1G, tertiary riser).
- **ORDERED (Minda, 2026-10-31): 2× DL380 Gen10 from Bargain Hardware** (HQ AI server + Beverley node), £583.00 each ex VAT —
  subtotal £1,166.00 + DHL £34.22 = **£1,194.52 ex VAT / £1,433.42 inc VAT**, two-day build, **est. delivery 2026-11-09**.
  Each: 8SFF chassis £180 · 2× Gold 6238 · 2× Performance heatsinks · no RAM · E208i-a · 8 caddies · 640FLR-SFP28 · 2× 1600 W ·
  rail kit · 3-yr RTB. Lines add up to £583 exactly. **Not on the order:** High-Performance fans (needed for any GPU), boot SSDs,
  confirmed GPU risers/baffle (chassis line doesn't say "GPU Ready"), 871829-B21 cables. Rails listed as "G8/G9 SFF BB" — Gen9
  2U SFF rails are the same family HPE lists for Gen10 (733660-B21), but ask BH to confirm. **RAM now needed for two servers.**
  Ask BH before the build starts: add 6× HP fans per server, confirm GPU-ready risers + baffle, confirm rails.
- **V100 price correction (Minda, 2026-10-31):** V100 32 GB PCIe is **~£700 each** (my estimate was £520–600) → 2 cards ≈ £1,400,
  3 ≈ £2,100. P40 ≈ £195. Steer: both servers arrive 9 Nov — **fit our 2× P40 in the HQ AI server first** (genuine Gen10 cables),
  run the staff pilot, measure real speed, **then** decide V100 (the 480B's speed depends on RAM, not the GPUs; V100 mainly speeds
  up the smaller staff-chat models). Beverley node runs on CPU until then, or gets 2 more P40s (~£390). No V100 bought yet.
- **DECISION (Minda, 2026-10-31): P40 first, V100 later.** Order of spend: (1) the other **6× P03052-091** → 12 sticks / 384 GB in the
  HQ server (RAM sets the 480B's speed); (2) Gen10 GPU power cables for the **2× P40 into the HQ Gen10** (confirm the exact P40 kit
  in the Gen10 QuickSpecs; one-probe check, HL-0110); (3) run the staff pilot and time it; (4) **V100s (~£700 each) only if** staff
  chat or long documents feel slow. Beverley Gen10 starts CPU-only (RAM to size). Rough 480B speed: 6 sticks ~3–4 words/s, 12 sticks
  ~6–8, 12 + V100 ~7–9 (estimates, to measure).
- **P40 power cable for the Gen10 (checked 2026-10-31, QuickSpecs a00008180enw p.59–60):** P40 `Q0V80C` is HPE-supported in the DL380
  Gen10 (max 3, CPUs ≤165 W, 1st/2nd gen — 6238 OK). The current QuickSpecs no longer names the P40's kit. Gen10 8-pin kits:
  **`871829-B21` 8-pin Keyed** (spare `869820-001`) — the one HPE pairs with its EPS-powered data-centre cards (named for the A16 and
  V100) → **buy this, 2×**; `871828-B21` 8-pin (spare `875097-001`, discontinued) is the non-keyed graphics-card type — **avoid**.
  Inference, not an HPE line item for the P40 → **one-probe check before plugging (HL-0110)**: 12 V must be on the row AWAY from the clip.
- **ORDERED (Minda, 2026-10-31 evening): 4× HPE `869820-001` "DL380 Gen10 GPU Power Cable EPS 8 PIN"** (the cable inside kit
  871829-B21) — £80.00 ex VAT (£20 each), £96.00 inc, standard delivery (seller SKU ITM0002454, Bargain Hardware SKU format).
  Listed as **EPS** = the right type for P40/V100. Use: 2 for the P40s in the HQ Gen10 now, 2 for a later card/Beverley.
  **One-probe check on each before first plug (HL-0110).**
- **ORDERED (Minda, 2026-10-31 evening): 6× HPE 32 GB 2Rx4 DDR4-2933 RDIMM `P03052-091`** (eBay, the IT Black Belt listing),
  £899.94 (6 × £149.99), eBay order 10-15369-27694. = 192 GB, 3 per CPU (half the channels). **Still to find: 6 more of the same
  part** (2Rx4, 2933, RDIMM; any HPE-labelled maker is fine, keep 2Rx4) → 12 = 384 GB. Fit per HPE's population order (the
  Gen10 user guide's DIMM table) — 6 now = 3 per CPU, matching slots on both CPUs.
