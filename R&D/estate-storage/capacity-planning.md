# RND-3 — Capacity planning (how big a pool do we need?)

_R&D working note, 2026-10-16. Sizes the ZFS pool for the DS2246 build (`design.md`,
`Runbooks/Runbook-RND3-Estate-Storage-Build.md`). **Measured** where possible; **estimated** elsewhere —
Minda corrects the estimates and the recommendation firms up._

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
≈ 3.7 ÷ 0.8 ≈ **~4.6 TB**.
**8× 1.92 TB enterprise SAS SSD in RAIDZ2 ≈ ~9 TB usable** comfortably covers it with room to spare — and
24 caddies mean a second vdev drops in later if AI/evidence growth outruns the estimate. **This is the buy.**
(960 GB drives → 6×960 GB RZ2 ≈ 3.6 TB usable would be tight; 1.92 TB is the right size.)

## Numbers that would still refine it (not blocking the buy)
1. **What PBS should back up** — just the VMs, or also large data volumes (category 5)? Only matters if
   there's a big non-VM dataset to protect.
2. (minor) AI: rough number/size of local models (category 3); Telegram archive size (category 4).
3. Estate Drive total across all users isn't measurable from minda@ alone (needs Workspace Admin) — but
   at tens of GB/account it's a small slice; not worth chasing before the buy.

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
