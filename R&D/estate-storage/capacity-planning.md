# RND-3 — Capacity planning (how big a pool do we need?)

_R&D working note, 2026-10-16. Sizes the ZFS pool for the DS2246 build (`design.md`,
`Runbooks/Runbook-RND3-Estate-Storage-Build.md`). **Measured** where possible; **estimated** elsewhere —
Minda corrects the estimates and the recommendation firms up._

## The one measured anchor (2026-10-16)
Google Drive `about` for **minda@fishboneconstruction.co.uk** (Composio `GOOGLEDRIVE_GET_ABOUT`):
- **Drive files: ~61 GB** (≈ 50 GB live + 15 GB trash).
- Whole account (Gmail + Photos + Drive): **~203 GB**.
- Workspace **pooled limit: 28 TB** (not the constraint — plenty of cloud headroom).

minda@ is the heaviest single account; other users' Drives add on top (TO CONFIRM — count + rough total,
or decide we only mirror key shared folders, not every user).

## What the pool has to hold (categories)
| # | Category | What it is | Now (est.) | +3 yr (est.) | How to firm up |
|---|---|---|---|---|---|
| 1 | **Drive copies / Nextcloud** | Mirror of estate Google Drive + the going-forward self-hosted store | ~150 GB | ~500 GB | measured minda@ 61 GB + other users (TO CONFIRM) |
| 2 | **File shares (SMB)** | Drawings, project folders, big files (the current file server) | **? ~500 GB** | ~1.5 TB | **Minda: current file-server used size?** ← biggest unknown |
| 3 | **AI project folders** | RND-2 local model weights + RAG index + source docs + scratch | ~300 GB | ~1 TB | # of models × size (GGUF 4–40 GB each) |
| 4 | **Telegram evidence mirror** | Archived photos/video evidence, ongoing | ~50 GB | ~300 GB | current archive size + monthly growth |
| | **Subtotal — primary data** | | **~1.0 TB** | **~3.3 TB** | |
| 5 | **PBS VM backups** (lives on this pool) | FusionPBX + DocuSeal + Proxmox guests (HQ+Beverley); PBS dedups/compresses | ~300 GB | ~800 GB | **Minda: PBS backs up just the VMs, or big data volumes too?** |
| 6 | **ZFS snapshot overhead** | Hourly/daily/weekly history of changes (~20%) | ~0.3 TB | ~0.8 TB | grows with churn |
| | **TOTAL pool working set** | | **~1.6 TB** | **~4.9 TB** | |

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

## Recommendation (pending Minda's two numbers)
**8× 1.92 TB enterprise SAS SSD in RAIDZ2 ≈ ~9 TB usable** — covers backups + AI + Drive copies + file
shares with 3-yr growth and snapshot overhead, at well under 80% full. Revisit up to 3.84 TB drives if the
**file-server size** (category 2) or **what PBS backs up** (category 5) comes back large.

## Numbers still needed from Minda
1. **Current file-server / shared-drawings used size** (category 2) — the biggest unknown.
2. **What PBS should back up** — just the VMs, or also large data volumes (category 5)?
3. (minor) Other Workspace users' Drive totals, or decision to mirror only key shared folders (category 1).
4. (minor) AI: rough number/size of local models (category 3); Telegram archive size (category 4).

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
Claude-Session: https://claude.ai/code/session_01CpGucX3hhykKcyhW2tf43c
