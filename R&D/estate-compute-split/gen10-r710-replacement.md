# RND-20 — Gen10 to replace the R710 (storage/production spine) — build guidance

_R&D build guidance (git-primary; creative mode, 2026-10-26, from Minda's vendor screenshots). Guide-only
(§3): Eugene specs; Minda buys/fits. Prices are the vendor's (ex-VAT), captured 2026-10-26 — verify at
purchase. This box = the **storage + backup + production-PBX spine** (the R710's role, done right), **not**
the brain (that stays the Gen9: RAM + P40s)._

> **DECISION (Minda, 2026-10-26): GO with Gen10 = STORAGE/PRODUCTION SPINE** (replace the R710); the
> **Gen9 stays the brain** (its RAM + P40s on-plan). The Gen10-as-brain alternative is parked. So this
> box is spec'd for storage: **cheap CPU + HBA (not RAID) + reuse our 2.5" SAS drives; don't buy the
> overpriced SSDs.**

## The role decides everything
This box does **ZFS storage + PBS backup + the lightweight PBX** — it is **not** a compute box. That means:
**cheap CPU, lots of RAM-for-ZFS, and an HBA (not a RAID card).** Don't pay for brain-tier parts here.

## Picks from the vendor list

### CPU — go cheap, this is storage
| Pick | £ ex-VAT | Verdict |
|---|---|---|
| **Gold 6226 (12c/24t, 2.7 GHz)** ⭐ | **£27.17** | **The value king.** Plenty for storage+backup+PBX. Buy **2× (£54)** to unlock all 24 DIMM slots + both PCIe risers + more lanes (for the HBA/NICs/10 G). |
| Gold 6242 (16c) / 6246 (12c@3.3) | £77 / £137 | Only if you want higher clock for the PBX/ZFS — not needed. |
| Platinum 8268 (24c) / 6252 (24c) / 6254 (18c) | £190 / £84 / £125 | **Brain-tier** (24c, AVX-512, high clock). **Overkill for storage — skip.** (These would be the pick only if you decided to make *this* box the brain instead — see the fork below.) |

**My pick: 2× Gold 6226 (£54 total).** Cascade Lake, ample, and the 2nd CPU is what lights up all the
memory slots + PCIe you'll want for a storage box.

### Storage controller — HBA, not RAID (this matters for ZFS)
| Pick | £ | Verdict |
|---|---|---|
| **E208i-a SR Gen10** ⭐ | **£54.34** | **The right one.** Runs in **HBA / pass-through mode** → presents raw disks, which **ZFS wants**. Cheap. |
| E208i-p | £42.69 | Same chip, PCIe plug-in form (vs the -a modular slot). Fine alternative. |
| P408i-a / P408i-p (RAID + cache) | £110 / £50 | **Avoid for a ZFS pool** — RAID-with-cache is what we're trying NOT to do (the Gen9's P840 forced ZFS-on-RAID; a fresh build should use a real HBA). |
| MR416i-a (16-lane NVMe/SAS) / P816i-a (16-port) | £427 / £152 | Only if you go all-NVMe or want 16 ports direct. Overkill now. |

⚠️ **The 24-drive gotcha:** an E208i-a has 8 internal lanes. To drive **all 24 SFF bays** from one HBA you
need the chassis's **SAS expander backplane** (HPE Gen10 24SFF usually ships with one; the expander card is
~870549-B21 if not included). **Confirm the 24SFF chassis includes the expander** — then E208i-a + expander
= all 24 drives in HBA mode for ZFS. (Our existing **12× 2.5" SAS 900 GB** drives from RND-3 become this
box's pool.)

### SSDs — DON'T buy these from this vendor
The **960 GB SATA SSDs at £318.94** are **~3–5× over market** (a used 960 GB enterprise SATA SSD is ~£60–120).
The 200 GB @ £69.86 is also pricey. **Source SSDs elsewhere** (or skip for now). The pool runs fine on the
**2.5" SAS 900 GB drives we already own**; add SSDs later only for a fast tier / ZFS SLOG+L2ARC.

## NOT in the screenshots — budget for these too
- **The chassis itself** (DL380 Gen10 24SFF) — price not shown; the biggest line.
- **RAM:** **DDR4-2933 RDIMM** for Gen10 (64–128 GB is plenty for a storage box — ZFS ARC). ~£100–200 used.
- **PSUs:** Gen10 uses **Flex Slot** PSUs (500 W/800 W) — **NOT** the Gen9 **Common Slot 1400 W** you bought
  for the P40s (those stay with the Gen9). A storage box with no GPUs only needs ~500–800 W.
- **Rail kit**, and a **10 G switch port** (3850 TenGig uplink) or direct link if you move the 10 G NIC here.

## ⚠️ Compatibility note — your recent buys are Gen9, they stay with the Gen9
- The **DDR4-2666 RAM** (840758-091) and the **1400 W Common-Slot PSUs** you just bought are **Gen9** parts
  → they stay in the **Gen9 brain**. The Gen10 needs its **own** DDR4-2933 RAM + Flex-Slot PSUs. (The 2666
  RAM *would* physically run in a Gen10 at 2666, but keep it in the Gen9 brain where it's planned.)

## The fork (worth a thought before you buy)
- **Default (your stated plan): Gen10 = storage/production spine, Gen9 = brain.** Lower disruption; your
  RAM + P40s stay on-plan on the Gen9; cheap CPU here. **Recommended.**
- **Alternative: Gen10 = BRAIN, Gen9 = storage.** Tempting because Cascade Lake has **AVX-512** (~2× faster
  CPU inference than the Gen9's Broadwell — big for the 480B RAM-brain). But it means re-homing the P40s +
  buying DDR4-2933 for the Gen10, and the Gen9 becomes storage with the RAM you just bought. More spend +
  disruption; only worth it if the AI brain is the top priority over everything else.
- My steer: **stick with your plan** (Gen10 = spine) unless you want to go all-in on the AI side, in which
  case we'd talk Gen10-as-brain properly.

### Gen10-as-brain vs Gen9-as-brain — is it more powerful? (the real numbers)
**Yes, on the CPU side; a wash on the GPU side.**
- **CPU inference (the 480B RAM-brain / prefill):** Gen10 **Cascade Lake wins ~1.8×.** Memory bandwidth
  sets CPU token speed, and Gen10 has **6 channels/socket vs Gen9's 4**, at **DDR4-2933 vs 2400**:
  - Gen9 (2× E5-2695 v4): ~**153 GB/s** total.
  - Gen10 (2× Gold, 2933): ~**281 GB/s** → **~1.8×** → roughly ~1.8× faster token generation.
  - (Reusing the 2666 sticks in a Gen10: ~256 GB/s = **~1.7×** — the 6th channel alone is most of the win.)
  - Plus **AVX-512** (Gen9 Broadwell has none; the Gold 62xx/82xx all have 2× FMA) speeds prefill further.
  → an 8 h overnight 480B batch becomes ~4–5 h. Real upgrade for the foundry/night-shift dream.
- **GPU inference (P40s, real-time 27–70B + vision):** **no difference** — both feed the P40s over the same
  PCIe Gen3 x16. Gen10 buys ~nothing here.
- **Cores:** Gen9 2×18 = 36c; Gen10 up to 2×24 = 48c (6252/8268) — modest help for batch parallelism.
- **Verdict:** worth flipping to Gen10-as-brain **only if the 480B CPU brain speed is what you want**; if
  the brain is mostly P40 GPU work, it's not worth the disruption.
- **If you flip, the cost/shuffle:** brain-tier CPUs (**2× Gold 6252 24c ≈ £168** = the AVX-512 sweet spot),
  **move the P40s** into the Gen10, **high-watt Flex-Slot PSUs** for the GPUs (the Gen9 1400 W Common-Slot
  ones don't fit Gen10), and ideally **12× DIMMs** (Gen10 is **12-channel** — optimal is multiples of 12,
  not the 8 you have). The 2666 RAM you bought **isn't wasted** — it runs at 2666 in a Gen10. The freed
  **Gen9 then becomes the storage spine** (still a big step up from the R710).

## Rough BOM (Gen10 storage spine, used)
2× Gold 6226 £54 · E208i-a HBA £54 · (+ SAS expander if not included) · RAM 64–128 GB DDR4-2933 ~£100–200 ·
Flex-Slot PSUs ~£50–80 · chassis (TBC) · rails. **Pool = our existing 12× 900 GB SAS.** Call it ~**£300–600
+ the chassis** — a modern, reliable production spine for the price of a weekend's parts.

## The resulting estate shape
- **Gen10 (new) = storage + backup + PBX spine** (24SFF, ZFS on HBA, 10 G, reliable, iLO5).
- **Gen9 = the unconstrained brain** (RAM + 2× P40, slots freed by the compute-split).
- **Beverley R710 or a replica = off-site backup.** (The old HQ R710 could even cascade to Beverley as the
  off-site box, or be retired.)
Each box doing the one thing it's best at.

---
_Guide-only; prices are the vendor's 2026-10-26 (verify). Storage-tier CPU + HBA(not RAID) + reuse our SAS
drives; don't buy the overpriced SSDs. Gen9-specific RAM/PSUs stay with the Gen9 brain. Pairs with RND-20
(compute-split), RND-3 (storage), RND-19 (brain)._
