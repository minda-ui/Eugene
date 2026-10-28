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
- **PSUs:** **buy 2× Gen10 Flex-Slot 500 W (`865408-B21`, ~£30–60 ea used).** A GPU-less storage box needs
  only ~500 W. **Don't gamble on the old Gen9 PSUs** — although Flex Slot is a "common form factor" across
  Gen9/Gen10 (QuickSpecs) and the 1400 W `720620-B21` *is* Flex Slot, HPE pairs PSU part numbers per gen,
  **iLO5 can flag an older PSU as unsupported**, and there's a halogen caveat — not worth the risk on the
  box that runs the phones. **Verified 2026-10-26 (web): conflicting sources, no confirmation the Gen9 part
  is *supported* in a Gen10 — so buy the right Gen10 PSU.** Keep the **1400 W `720620-B21` in the Gen9
  brain** (for the P40s); the old Gen9 500 W become spares. **Also check the Techbuyer CTO — the chassis may
  already include PSUs.**
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

## FINAL BOM — as configured on Techbuyer CTO (2026-10-26, Minda)
| Part | £ ex-VAT |
|---|---|
| Chassis — DL380 Gen10 **24×SFF** | 235.41 |
| CPU — 2× Gold 6226 | 54.34 |
| Heatsink — 2× **High Performance** (could be 2× Standard −£31) | 77.62 |
| Controller — **E208i-a SR Gen10** HBA | 54.34 |
| PSU — **2× 865408-B21 500 W Flex-Slot Platinum** ✅ (the right Gen10 part, £13.97 ea) | 27.94 |
| **Config subtotal (1-yr warranty)** | **£449.65** |
| + RAM — 2× 32 GB 2666 (64 GB): Techbuyer £394.88 **or** source separately ~£160–240 | 395 / ~200 |
| Drives — reuse our 12× 900 GB SAS | £0 |
| **TOTAL** | **~£845 (all-Techbuyer) / ~£650 (RAM separate)** |

**Open items before/with purchase:** (1) **add RAM** (64 GB 2666); (2) **confirm the 24SFF includes the
SAS expander** so one E208i-a drives all 24 bays (message Techbuyer); (3) optional: drop heatsinks to
Standard (−£31). **Build-time:** set the E208i-a to **HBA mode** (not RAID) for ZFS.

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

### Backup direction — build it pull, not push (Minda, 2026-10-28)
Making the Gen10 the storage spine is the moment to fix the backup *direction*, not just the capacity. The
rule (full rationale in `R&D/estate-storage/design.md` → "Pull, not push", and OI-26): **the backup store
must not be deletable by the machine it protects.** So spec the spine's backup role as:
- **Gen10 = append-only primary PBS.** Production hosts get a PBS token with **`Datastore.Backup` only**
  (no Prune/Modify); **prune + GC + verify run on the Gen10 itself**; **ZFS snapshots of the PBS datastore**
  for rollback. A ransomwared production host can write but can't erase history.
- **Beverley (old R710 / replica) = the puller.** A **PBS sync job on Beverley pulls** from the Gen10, and
  the ZFS replica is **received at Beverley** (Beverley initiates), so the HQ side holds no credentials to
  the offsite copy. True pull = the genuine offsite tier.
This is a design choice, not extra hardware — it's how the spine's PBS and the Beverley replica are wired.

---
_Guide-only; prices are the vendor's 2026-10-26 (verify). Storage-tier CPU + HBA(not RAID) + reuse our SAS
drives; don't buy the overpriced SSDs. Gen9-specific RAM/PSUs stay with the Gen9 brain. Pairs with RND-20
(compute-split), RND-3 (storage), RND-19 (brain)._
