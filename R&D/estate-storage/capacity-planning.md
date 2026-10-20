# RND-3 — Capacity planning (how big a pool do we need?)

_R&D working note, 2026-10-16. Sizes the ZFS pool for the DS2246 build (`design.md`,
`Runbooks/Runbook-RND3-Estate-Storage-Build.md`). **Measured** where possible; **estimated** elsewhere —
Minda corrects the estimates and the recommendation firms up._

## ⏩ INTERIM PLAN (2026-10-16): build in the R710's internal bays first
The SFF-8644→QSFP cable is 2–3 wks out / scarce in the UK (confirmed by live search). So **don't wait on
the shelf** — build **1× 8-wide RAIDZ2 (~4.3 TB usable) in the R710's 8 internal bays now** (covers the
target), start PBS/backups this week, and add the DS2246 as a 2nd vdev when the cable arrives. Module swap
(IOM6→IOM12) is a dead end: IOM12 is for the DS224C chassis, not the DS2246, and 12 G is wasted on HDDs.
Build steps: `Runbooks/Runbook-RND3-R710-Internal-Interim-Build.md`. First checks: R710 controller model
(H200/H310 → crossflash IT; H700 → cheap internal HBA) + Dell R710 2.5" caddies (≠ NetApp shelf caddies).

## The one measured anchor (2026-10-16)
Google Drive `about` for **minda@fishboneconstruction.co.uk** (Composio `GOOGLEDRIVE_GET_ABOUT`):
- **Drive files: ~61 GB** (≈ 50 GB live + 15 GB trash).
- Whole account (Gmail + Photos + Drive): **~203 GB**.
- Workspace **pooled limit: 28 TB** (not the constraint — plenty of cloud headroom).

minda@ is the heaviest single account; its 61 GB is a **mixed personal+work** store (largest items are a
Blum furniture catalogue PDF, installer EXEs, old phone videos — **not** drawings). Other users' Drives
add on top (not measurable without Workspace Admin; estimate below).

## KEY FINDING (Minda, 2026-10-16): all drawings live on Google Drive — there is NO separate file server
- **No Shared Drives** exist (checked). Drawings are folders of PDFs/DWGs in My Drive accounts —
  individually small; the estate Drive footprint is **tens of GB per account**, not TB.
- **Consequence:** Google Drive (the paid **28 TB** pool) stays the **authoritative** home for drawings.
  The NAS does **not** become the primary drawings store — it holds a **backup copy** of Drive as part of
  3-2-1. That removes the "file server" category entirely and shrinks the primary-data need.
- So the pool is dominated by **VM backups + AI models**, with Drive-copy + Nextcloud a modest slice.

## What the pool has to hold (categories — revised)
| # | Category | What it is | Now (est.) | +3 yr (est.) | How to firm up |
|---|---|---|---|---|---|
| 1 | **Google Drive backup copy** | A local mirror of the estate's Drive (drawings incl.) for 3-2-1. Drive stays authoritative. | ~150 GB | ~500 GB | measured minda@ 61 GB; other users not measurable w/o Admin |
| 2 | **Nextcloud (going-forward store)** | New self-hosted docs/shares/photo-upload — grows over time | ~50 GB | ~500 GB | usage-driven |
| 3 | **AI project folders** | RND-2 local model weights + RAG index + source docs + scratch | ~300 GB | ~1 TB | # of models × size (GGUF 4–40 GB each) |
| 4 | **Telegram evidence mirror** | Archived photos/video evidence, ongoing | ~50 GB | ~300 GB | current archive size + monthly growth |
| | **Subtotal — primary data** | | **~0.55 TB** | **~2.3 TB** | |
| 5 | **PBS VM backups** (lives on this pool) | FusionPBX + DocuSeal + Proxmox guests (HQ+Beverley); PBS dedups/compresses | ~300 GB | ~800 GB | **Minda: PBS backs up just the VMs, or big data volumes too?** |
| 6 | **ZFS snapshot overhead** | Hourly/daily/weekly history of changes (~20%) | ~0.2 TB | ~0.6 TB | grows with churn |
| | **TOTAL pool working set** | | **~1.0 TB** | **~3.7 TB** | |

## Sizing rule
- Keep a ZFS pool **under ~80% full** (performance + resilver headroom) → target **usable ≈ 3-yr need ÷ 0.8 ≈ ~6 TB usable**.
- **RAIDZ2** usable ≈ (N − 2) × drive_size, then × ~0.8 practical.

## Pool options (used enterprise 2.5" SAS SSD, 512-byte, PLP)
| Drives | Layout | Raw | ~Usable (RAIDZ2) | Covers 3-yr ~5 TB? |
|---|---|---|---|---|
| 6× 1.92 TB | RAIDZ2 | 11.5 TB | ~6.1 TB | Yes, tight |
| **8× 1.92 TB** | **RAIDZ2** | **15.4 TB** | **~9.2 TB** | **Yes, comfortably — recommended** |
| 8× 3.84 TB | RAIDZ2 | 30.7 TB | ~18 TB | Yes, lots of headroom |
| 12× 1.92 TB | 2× 6-wide RZ2 | 23 TB | ~14 TB | Yes, big |

24 caddies mean we can add a second vdev into the same pool later — **start with 8, grow when needed.**

## Recommendation (firmed up 2026-10-16)
With no file server to absorb (drawings stay on Drive), the 3-yr working set is **~3.7 TB**. Target usable
≈ 3.7 ÷ 0.8 ≈ **~4.6 TB** (today's need ~1 TB — the pool just can't run near full).

### Two ways to get there — fewer big drives, or more small/cheap ones (Minda, 2026-10-16)
24 bays means we can hit the target with **cheap smaller SSDs** instead of a few big ones. ZFS best practice:
keep RAIDZ2 vdevs **6 wide** and stripe several vdevs (better resilver + IOPS than one wide vdev).

| Drives | Layout | ~Usable | Bays used | £/TB | Notes |
|---|---|---|---|---|---|
| 12× **480 GB** | 2× 6-wide RZ2 | ~3.0 TB | 12/24 | low | covers **today**; tight for 3-yr — grow later |
| 18× **480 GB** | 3× 6-wide RZ2 | ~4.6 TB | 18/24 | low | hits target with cheapest small drives |
| 12× **800/960 GB** | 2× 6-wide RZ2 | ~5 TB | 12/24 | low–mid | **good small-drive pick** — half the bays free to grow |
| **8× 1.92 TB** | 1× 8-wide RZ2 | ~9 TB | 8/24 | mid | fewest drives, most headroom (earlier rec) |
| 24× **480 GB** | 4× 6-wide RZ2 | ~6 TB | 24/24 | low | fill the shelf with cheap drives, max small-drive |

**Smaller-drive trade-offs:** cheaper per drive and often cheaper per TB, but **more drives = more power,
more heat, more failure points**, and **a full shelf leaves no bays to grow**. Sweet spot for value +
headroom: **12× 800–960 GB in 2× 6-wide RAIDZ2 (~5 TB usable, 12 bays free).** If the budget is the driver
and growth can wait, **12× 480 GB (~3 TB)** covers everything today and you add a vdev when AI/evidence grow.

> ⚠️ Start a pool with drives of **one size** per vdev. You can mix vdev sizes in the same pool (e.g. a
> 480 GB vdev now + an 800 GB vdev later), so buying small now never blocks a bigger vdev later.

## ✅ DRIVES BOUGHT (Minda, 2026-10-16) — 12× Seagate Savvio 10K.6 900 GB SAS
- **Model:** Seagate **ST900MM0006**, 900 GB, 10K, **6 Gbps SAS, 2.5"**. **2 already owned + 10 bought**
  = **12 drives** @ ~£10 each (~£120 total). HDD (spinning), not SSD — right call for a backup/NAS pool.
- **Compatibility confirmed:** 2.5" SFF SAS 6G = native match to the DS2246 IOM6; fits the NetApp caddies
  (standard 2.5" screw pattern); **512n native → no `sg_format`/520 reformat**; raw disk for ZFS.
- **Chosen layout: 2× 6-wide RAIDZ2 = ~5.8 TB usable** (each vdev 4 data + 2 parity; survives 2 failures
  per vdev). Covers the 3-yr target (~4.6 TB) with headroom. **12 of 24 bays used → room for a 2nd pool/
  vdev later.** (Alt: 1× 12-wide RAIDZ2 ≈ 7.2 TB usable but wider/slower resilve — 2×6 is the pick.)
- **Cable chosen (2026-10-16):** **Cablexa CAB-8644-QSFP-1M** — External Mini SAS HD **SFF-8644 → QSFP+
  (SFF-8436)**, 1 m, factory-new sealed, UK stock, 3-yr warranty (genuinemodules.com). Correct both ends
  for CP400e → DS2246 IOM6. Buy 1 now (path to IOM A); a 2nd later for multipath. **Last buy.**
  ⚠️ Earlier candidates checked: 10Gtek/Allowish SFF-8644→QSFP (also correct); a SFF-8644→**SFF-8088**
  cable is **WRONG** — the DS2246 IOM6 is QSFP/SFF-8436, not SFF-8088.
- **On arrival:** spot-check one with `sg_readcap -l` (expect 512) → then build the pool.
- ⚠️ 12× 10K spinners = loud/hot/power — keep the shelf on the UPS in the rack/plant room, not a desk.

## Numbers that would still refine it (not blocking the buy)
1. **What PBS should back up** — just the VMs, or also large data volumes (category 5)? Only matters if
   there's a big non-VM dataset to protect.
2. (minor) AI: rough number/size of local models (category 3); Telegram archive size (category 4).
3. Estate Drive total across all users isn't measurable from minda@ alone (needs Workspace Admin) — but
   at tens of GB/account it's a small slice; not worth chasing before the buy.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
