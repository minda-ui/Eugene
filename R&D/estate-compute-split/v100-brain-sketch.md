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
| Network | **10 G FlexibleLOM** — **switch side ready:** 2 free 10G slots (one per 3850, NM-2-10G) + **Cisco SFP+ DAC cables already on hand** (Minda, 2026-10-31) → cross-stack 10G bundle like the Gen9 |
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
